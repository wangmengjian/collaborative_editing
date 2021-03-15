package com.jit.doc.mapreduce;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;

import java.io.IOException;

public class InvertedMapper extends Mapper<LongWritable,Text,Text,Text> {
    Text outKey=new Text();
    Text outValue=new Text();

    /**
     * 统计每篇文章中的词(word->fileName:1)
     * @param key
     * @param value
     * @param context
     * @throws IOException
     * @throws InterruptedException
     */
    @Override
    protected void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
        FileSplit fileSplit= (FileSplit) context.getInputSplit();
        String fileName=fileSplit.getPath().getName();
        //分词
        String[] words=value.toString().split("[^a-zA-Z1-9]+");
        for(String word:words){
            outKey.set(word+"->"+fileName);
            outValue.set("1");
            context.write(outKey,outValue);
        }
    }
}
