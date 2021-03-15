package com.jit.doc.common;


import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Random;

public class Util {

    public static String buildQuery(String url, String name, String value) {
        MultiValueMap<String, String> params = new LinkedMultiValueMap<String, String>();
        params.add(name, value);
        UriComponents uriComponents = UriComponentsBuilder.fromHttpUrl(url).queryParams(params).build();
        return uriComponents.toUriString();
    }
    /**
     * 几位随机数
     * @param number
     * @return
     */
    public static String getRandomNumber(int number){
        Random random = new Random();
        String result="";
        for (int i=0;i<number;i++)
        {
            result+=random.nextInt(10);
        }
        return result;
    }
    /**
     * 一次在url中添加多个参数
     * @param url
     * @param map
     * @return
     */
    public static String buildQueryMulti(String url, MultiValueMap<String, String> map) {
        UriComponents uriComponents = UriComponentsBuilder.fromHttpUrl(url).queryParams(map).build();
        return uriComponents.toUriString();
    }
    /**
     * 生成指定number个长度为length的随机数字加字母的不重复的字符串
     * @param length
     * @return
     */
    public static String getVerifyRandom(Integer length) {
        String val = "";
        Random random = new Random();
        //length为几位密码
        for (int i = 0; i < length; i++) {
            String charOrNum = random.nextInt(2) % 2 == 0 ? "char" : "num";
            //输出字母还是数字
            if ("char".equalsIgnoreCase(charOrNum)) {
                //输出是大写字母还是小写字母
                int temp = random.nextInt(2) % 2 == 0 ? 65 : 97;
                val += (char) (random.nextInt(26) + temp);
            } else if ("num".equalsIgnoreCase(charOrNum)) {
                val += String.valueOf(random.nextInt(10));
            }
        }
        return val;
    }

}
