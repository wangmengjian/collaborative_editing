package com.jit.doc.mapreduce;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

public class InvertedReducer extends Reducer<Text,Text,Text, Text> {
    Text outKey=new Text();
    Text outValue=new Text();

    /**
     * 每个词的多个文件进行合并
     * @param key
     * @param values
     * @param context
     * @throws IOException
     * @throws InterruptedException
     */
    @Override
    protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
        StringBuilder outStr=new StringBuilder();
        for(Text value:values){
            outStr.append(" ").append(value.toString());
        }
        outValue.set(outStr.toString());
        context.write(key,outValue);
    }
}
