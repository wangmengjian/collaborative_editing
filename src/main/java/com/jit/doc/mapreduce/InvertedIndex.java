package com.jit.doc.mapreduce;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.KeyValueTextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.junit.Test;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class InvertedIndex {
    /**
     * 创建对应用户的索引文件
     * @param inputPath
     * @param outputPath
     * @throws IOException
     * @throws ClassNotFoundException
     * @throws InterruptedException
     */
    public static void createIndex(String inputPath,String outputPath) throws IOException, ClassNotFoundException, InterruptedException {
        Configuration configuration=new Configuration();
        configuration.set("fs.defaultFS","hdfs://175.24.16.7:9000");
        configuration.set("dfs.client.use.datanode.hostname", "true");
        FileSystem fileSystem= FileSystem.get(configuration);
        if(fileSystem.exists(new Path(outputPath))){
            fileSystem.delete(new Path(outputPath),true);
        }
        Job job=Job.getInstance(configuration);
        job.setJarByClass(InvertedIndex.class);

        job.setMapperClass(InvertedMapper.class);
        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(Text.class);

        job.setReducerClass(InvertedReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        job.setCombinerClass(InvertedCombiner.class);

        FileInputFormat.addInputPath(job,new Path(inputPath));
        FileOutputFormat.setOutputPath(job,new Path(outputPath));
        job.waitForCompletion(true);
    }
    @Test
    public void test() throws InterruptedException, IOException, ClassNotFoundException {
        createIndex("/file/7","/indexFile/7");
    }
}
