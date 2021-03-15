package com.jit.doc.common;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.*;

import java.io.OutputStream;
import java.net.URI;

public class Test {
    @org.junit.Test
    public void test() throws Exception {
        Configuration configuration=new Configuration();
        configuration.set("fs.defaultFS","hdfs://175.24.16.7:9000");
        configuration.set("dfs.client.use.datanode.hostname", "true");
        FileSystem fileSystem=FileSystem.newInstance(configuration);
        //OutputStream outputStream=fileSystem.create(new Path("/file/lgkdtY9KGmlQk8f4OZg46X2595e25B39/p1297t5JKBu6Y8E3t5Dtg3Nz84T144tg"));
        //outputStream.write("测试文件上传".getBytes());
        //outputStream.close();
        FileStatus file=fileSystem.getFileStatus(new Path("/file/lgkdtY9KGmlQk8f4OZg46X2595e25B39/p1297t5JKBu6Y8E3t5Dtg3Nz84T144tg"));
        System.out.println(file.getLen());
        fileSystem.close();
    }
}
