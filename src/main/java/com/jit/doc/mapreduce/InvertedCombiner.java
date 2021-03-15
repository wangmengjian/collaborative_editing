package com.jit.doc.mapreduce;

import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

import java.io.IOException;

public class InvertedCombiner extends Reducer<Text,Text,Text, Text> {
    Text outKey=new Text();
    Text outValue=new Text();

    /**
     * 相同词进行合并
     * @param key
     * @param values
     * @param context
     * @throws IOException
     * @throws InterruptedException
     */
    @Override
    protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
        long sum=0;
        for(Text value:values){
            sum+=Long.parseLong(value.toString());
        }
        String[] words=key.toString().split("->");
        outKey.set(words[0]);
        outValue.set(words[1]+"->"+sum);
        context.write(outKey,outValue);
    }
}
