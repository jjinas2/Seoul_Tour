package com.travel.seoul.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;


@Controller
public class KakaologinController {
	@RequestMapping(value = "/login/getKakaoAuthUrl")
	public @ResponseBody String getKakaoAuthUrl(
			HttpServletRequest request) throws Exception {
		String reqUrl = 
				"https://kauth.kakao.com/oauth/authorize"
				+ "?client_id=aef638334c428509688c542797b696aa"
				+ "&redirect_uri=http://localhost:8080/kakaologin.do"
				+ "&response_type=code";
		
		return reqUrl;
	}


    @GetMapping("/kakaologin.do")
    public String oauthKakao(@RequestParam(value = "code", required = false) String code, Model model) {
        try {
            System.out.println("#########" + code);
            String access_Token = getAccessToken(code);
            System.out.println("###access_Token#### : " + access_Token);

            HashMap<String, Object> userInfo = getUserInfo(access_Token);
            if (userInfo != null) {
                System.out.println("###userInfo#### : " + userInfo.get("email"));
                System.out.println("###nickname#### : " + userInfo.get("nickname"));

                JSONObject kakaoInfo = new JSONObject(userInfo);
                model.addAttribute("kakaoInfo", kakaoInfo);
            } else {
                // userInfo가 null이면 처리할 내용 추가
            }
        } catch (Exception e) {
            e.printStackTrace();
            // 예외 처리
        }

        return "/Main";
    }

    public String getAccessToken(String authorize_code) throws IOException {
        String access_Token = "";
        String refresh_Token = "";
        String reqURL = "https://kauth.kakao.com/oauth/token";

        try {
            URL url = new URL(reqURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setDoOutput(true);

            try (BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()))) {
                StringBuilder sb = new StringBuilder();
                sb.append("grant_type=authorization_code");
                sb.append("&client_id=aef638334c428509688c542797b696aa");
                sb.append("&redirect_uri=http://localhost:8080/kakaologin.do");
                sb.append("&code=").append(authorize_code);
                bw.write(sb.toString());
            }

            int responseCode = conn.getResponseCode();
            System.out.println("responseCode : " + responseCode);

            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                StringBuilder result = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    result.append(line);
                }

                JsonParser parser = new JsonParser();
                JsonObject json = parser.parse(result.toString()).getAsJsonObject();

                access_Token = json.get("access_token").getAsString();
                refresh_Token = json.get("refresh_token").getAsString();

                System.out.println("access_token : " + access_Token);
                System.out.println("refresh_token : " + refresh_Token);
            }
        } catch (IOException e) {
            e.printStackTrace();
            // 예외 처리
            throw e;
        }

        return access_Token;
    }

    public HashMap<String, Object> getUserInfo(String access_Token) {
        HashMap<String, Object> userInfo = new HashMap<>();
        String reqURL = "https://kapi.kakao.com/v2/user/me";

        try {
            URL url = new URL(reqURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("GET");
            conn.setRequestProperty("Authorization", "Bearer " + access_Token);

            int responseCode = conn.getResponseCode();
            System.out.println("responseCode : " + responseCode);

            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
                StringBuilder result = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    result.append(line);
                }

                JsonParser parser = new JsonParser();
                JsonObject json = parser.parse(result.toString()).getAsJsonObject();

                JsonObject properties = json.getAsJsonObject("properties");
                JsonObject kakao_account = json.getAsJsonObject("kakao_account");

                String nickname = properties.get("nickname").getAsString();
                String email = kakao_account.get("email").getAsString();

                userInfo.put("accessToken", access_Token);
                userInfo.put("nickname", nickname);
                userInfo.put("email", email);
            }
        } catch (IOException e) {
            e.printStackTrace();
            // 예외 처리
            return null;
        }

        return userInfo;
    }

 }
