package com.travel.seoul.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.json.XML;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.travel.seoul.vo.UserVO;

@Controller
public class MapController {

    @GetMapping("/map2")
    public static String main(@RequestParam String place, Model model,HttpServletRequest request) {
    	 HttpURLConnection conn = null;
    	    BufferedReader rd = null;
    	    StringBuilder sb = new StringBuilder();
   	      	HttpSession session = request.getSession();
   	      	UserVO user = (UserVO) session.getAttribute("loginMember");
    	     System.out.println("지도 세션:" +user);
    	     model.addAttribute("user",user);
    	     
    	    try {
    	        StringBuilder urlBuilder = new StringBuilder("http://openapi.seoul.go.kr:8088");
    	        urlBuilder.append("/" + URLEncoder.encode("7666485574616e733131306c4a787178", "UTF-8"));
    	        urlBuilder.append("/" + URLEncoder.encode("xml", "UTF-8"));
    	        urlBuilder.append("/" + URLEncoder.encode("citydata", "UTF-8"));
    	        urlBuilder.append("/" + URLEncoder.encode("1", "UTF-8"));
    	        urlBuilder.append("/" + URLEncoder.encode("2", "UTF-8"));
    	        urlBuilder.append("/" + URLEncoder.encode(place, "UTF-8"));

    	        URL url = new URL(urlBuilder.toString());
    	        conn = (HttpURLConnection) url.openConnection();
    	        conn.setRequestMethod("GET");
    	        conn.setRequestProperty("Content-type", "application/json");
    	        System.out.println("Response code: " + conn.getResponseCode());

    	        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
    	            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
    	            String line;
    	            while ((line = rd.readLine()) != null) {
    	                sb.append(line);
    	            }
    	            JSONObject json = XML.toJSONObject(sb.toString());
    	            String jsonStr = json.toString(4);
    	            //System.out.println(jsonStr);
    	            String sbString = sb.toString();
    	            //System.out.println("string builder:"+sbString);
    	            boolean bb = sbString.contains("정상");
    	            System.out.println("true or false "+bb);
    	            if(bb) {
    	            	System.out.println("힘들어 ㅎㅎ");
    	            	model.addAttribute("jsonStr", jsonStr);
    	            	  return "map/map";
    	            }
    	          
    	        } else {
    	            return "API 호출 중 오류 발생";
    	        }
    	    } catch (IOException e) {
    	        // Handle IOException
    	        e.printStackTrace();
    	        return "API 호출 중 오류 발생";
    	    } finally {
    	        try {
    	            if (rd != null) {
    	                rd.close();
    	            }
    	        } catch (IOException e) {
    	            e.printStackTrace();
    	        }
    	        if (conn != null) {
    	            conn.disconnect();
    	        }
    	      
    	    }
			return place;
    	}
    
}
