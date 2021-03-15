package com.jit.doc.common;

import java.util.StringTokenizer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;
public class MapReduceTest {
    public static class Map extends Mapper<LongWritable, Text, Text, Text>{
        //      word 用来储存单词和URI one 用来储存词频
        private static Text word = new Text();
        private static Text one = new Text();

        protected void map(LongWritable key, Text value, Context context)
                throws java.io.IOException ,InterruptedException {

//          (FileSplit)context.getInputSplit() 获取<key, value> 对所属的FileSplit对象
//          在这里由于文件不大，每一个Split分片即是一个对应的文件

//          获取当前Split下的文件名称
            String fileName = ((FileSplit)context.getInputSplit()).getPath().getName();
//            StringTokenizer 是用来把字符串截取成一个个标记或单词的
            StringTokenizer st = new StringTokenizer(value.toString());
            while(st.hasMoreTokens()){

                word.set(st.nextToken()+"\t"+fileName);
                context.write(word, one);
            }
        };
    }
    /**
     * Combine 的作用是完成词频统计
     * @author Administrator
     *
     */
    public static class Combine extends Reducer<Text, Text, Text, Text>{
        private static Text word = new Text();
        private static Text index = new Text();

        protected void reduce(Text key, Iterable<Text> values, Context context)
                throws java.io.IOException ,InterruptedException {
//          对key进行操作， 截取分开 单词 和 URI
            String[] splits = key.toString().split("\t");
            if(splits.length != 2){
                return ;
            }
//            统计词频
            long count = 0;
            for (Text v : values) {
                count++;
            }

//            设置key 为 splits[0] 单词  value 为 splits[1] 文件名 + 次数
            word.set(splits[0]);
            index.set(splits[1]+":"+count);
            context.write(word, index);
        };
    }
    /**
     * Reduce 的作用是生成文档列表
     * @author Administrator
     *
     */
    public static class Reduce extends Reducer<Text, Text, Text, Text>{
        private static StringBuilder sub = new StringBuilder(256);
        private static Text index = new Text();

        protected void reduce(Text word, Iterable<Text> values, Context context)
                throws java.io.IOException ,InterruptedException {
            for (Text v : values) {
                sub.append(v.toString()).append(";");
            }
            index.set(sub.toString()); 
            context.write(word, index);
            sub.delete(0,sub.length());
        };
    }
    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        conf.set("fs.defaultFS","hdfs://175.24.16.7:9000");
        conf.set("dfs.client.use.datanode.hostname", "true");

        Job job = new Job(conf, "InvertedIndex");
        job.setJarByClass(MapReduceTest.class);

        //设置Map Combine Reduce 处理类
        job.setMapperClass(Map.class);
        job.setCombinerClass(Combine.class);
        job.setReducerClass(Reduce.class);


        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(Text.class);
        //设置输出类型
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        //设置输入和输出目录
        FileInputFormat.addInputPath(job, new Path("/file/23N90Q617125Po9911I04fU6j9JP8T32/152x75Sc218578V9L53PkW59L2156826"));
        FileOutputFormat.setOutputPath(job, new Path("/output/test/12"));

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
