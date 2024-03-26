package com.travel.seoul.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.springframework.stereotype.Service;

import com.travel.seoul.vo.TransVO;

@Service
public class TransServiceImpl implements TransService{

	@Override
	public String getChinese(TransVO dd) {
		System.out.println("여기는 중국 번역 "+dd);
		String korean = dd.getKorean();
		String apiURL = "https://openapi.naver.com/v1/papago/n2mt";
		String text;
		String result = "";
		String line = "";
		try {
			text = URLEncoder.encode(korean, "UTF-8");
			String param = "source=ko&target=zh-CN&text=" + text;
			URL url = new URL(apiURL);
			HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
			con.setRequestProperty("X-Naver-Client-Id", "QeqOiHorQwo6GHdoFPBj");
			con.setRequestProperty("X-Naver-Client-Secret", "jmKk9BC21B");
			con.setRequestMethod("POST");
			con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
			con.setDoInput(true);
			con.setDoOutput(true);
			con.setUseCaches(false);
			con.setDefaultUseCaches(false);

			OutputStreamWriter osw = new OutputStreamWriter(con.getOutputStream());
			osw.write(param);
			osw.flush();

			int responseCode = con.getResponseCode();
			System.out.println("중국 코드 :"+ responseCode);
			/*
			 * result += "responseCode  : " + responseCode; result += "\n";
			 */
            // 200코드가 아니면 오류인데 무엇이 오류 인지 디버깅 
			if (responseCode != 200) {
				Map<String, List<String>> map = con.getRequestProperties();
				result += "Printing Response Header...\n";
				for (Map.Entry<String, List<String>> entry : map.entrySet()) {
					if (entry.getKey().equals("apikey")) {
						result += "";
					} else {
						result += "Key : " + entry.getKey() + " ,Value : " + entry.getValue();
					}
				}
			}

			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            // 여긴 출력 
			while ((line = br.readLine()) != null) {
				result += line + "\n";
			}
			br.close();

		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException("인코딩 실패", e);
		} catch (IOException e) {
			result = e.getMessage();
		}

		return result;
	}
	@Override
	public String getJapanese(TransVO dd) {
		String korean = dd.getKorean();
		String apiURL = "https://openapi.naver.com/v1/papago/n2mt";
		String text;
		String result = "";
		String line = "";
		try {
			text = URLEncoder.encode(korean, "UTF-8");
			String param = "source=ko&target=ja&text=" + text;
			URL url = new URL(apiURL);
			HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
			con.setRequestProperty("X-Naver-Client-Id", "7r40px2B1XUsao9Ayzud");
			con.setRequestProperty("X-Naver-Client-Secret", "QzZuASgPKU");
			con.setRequestMethod("POST");
			con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
			con.setDoInput(true);
			con.setDoOutput(true);
			con.setUseCaches(false);
			con.setDefaultUseCaches(false);

			OutputStreamWriter osw = new OutputStreamWriter(con.getOutputStream());
			osw.write(param);
			osw.flush();

			int responseCode = con.getResponseCode();
			/*
			 * result += "responseCode  : " + responseCode; result += "\n";
			 */
            // 200코드가 아니면 오류인데 무엇이 오류 인지 디버깅 
			if (responseCode != 200) {
				Map<String, List<String>> map = con.getRequestProperties();
				result += "Printing Response Header...\n";
				for (Map.Entry<String, List<String>> entry : map.entrySet()) {
					if (entry.getKey().equals("apikey")) {
						result += "";
					} else {
						result += "Key : " + entry.getKey() + " ,Value : " + entry.getValue();
					}
				}
			}

			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            // 여긴 출력 
			while ((line = br.readLine()) != null) {
				result += line + "\n";
			}
			br.close();

		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException("인코딩 실패", e);
		} catch (IOException e) {
			result = e.getMessage();
		}

		return result;
	}
	@Override
	public String getEnglish(TransVO dd) {
		String korean = dd.getKorean();
		String apiURL = "https://openapi.naver.com/v1/papago/n2mt";
		String text;
		String result = "";
		String line = "";
		try {
			text = URLEncoder.encode(korean, "UTF-8");
			String param = "source=ko&target=en&text=" + text;
			URL url = new URL(apiURL);
			HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
			con.setRequestProperty("X-Naver-Client-Id", "7r40px2B1XUsao9Ayzud");
			con.setRequestProperty("X-Naver-Client-Secret", "QzZuASgPKU");
			con.setRequestMethod("POST");
			con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
			con.setDoInput(true);
			con.setDoOutput(true);
			con.setUseCaches(false);
			con.setDefaultUseCaches(false);

			OutputStreamWriter osw = new OutputStreamWriter(con.getOutputStream());
			osw.write(param);
			osw.flush();

			int responseCode = con.getResponseCode();
			/*
			 * result += "responseCode  : " + responseCode; result += "\n";
			 */
            // 200코드가 아니면 오류인데 무엇이 오류 인지 디버깅 
			if (responseCode != 200) {
				Map<String, List<String>> map = con.getRequestProperties();
				result += "Printing Response Header...\n";
				for (Map.Entry<String, List<String>> entry : map.entrySet()) {
					if (entry.getKey().equals("apikey")) {
						result += "";
					} else {
						result += "Key : " + entry.getKey() + " ,Value : " + entry.getValue();
					}
				}
			}

			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            // 여긴 출력 
			while ((line = br.readLine()) != null) {
				result += line + "\n";
			}
			br.close();

		} catch (UnsupportedEncodingException e) {
			throw new RuntimeException("인코딩 실패", e);
		} catch (IOException e) {
			result = e.getMessage();
		}

		return result;
	}
	@Override
	public String test() {
		return "test";
	}
	@Override
    public String detectLanguage(TransVO dd) {
        System.out.println("언어 감지: " + dd);
        String inputText = dd.getKorean();
        String apiURL = "https://openapi.naver.com/v1/papago/detectLangs";
        String result = "";

        try {
            String encodedText = URLEncoder.encode(inputText, "UTF-8");
            String param = "query=" + encodedText;
            URL url = new URL(apiURL);

            HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("X-Naver-Client-Id", "7r40px2B1XUsao9Ayzud");
			con.setRequestProperty("X-Naver-Client-Secret", "QzZuASgPKU");
            con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
            con.setDoInput(true);
            con.setDoOutput(true);

            try (OutputStreamWriter osw = new OutputStreamWriter(con.getOutputStream())) {
                osw.write(param);
                osw.flush();
            }

            int responseCode = con.getResponseCode();

            if (responseCode != 200) {
                Map<String, List<String>> requestHeaders = con.getRequestProperties();
                result += "Printing Request Headers...\n";
                for (Map.Entry<String, List<String>> entry : requestHeaders.entrySet()) {
                    if (!entry.getKey().equals("apikey")) {
                        result += "Key: " + entry.getKey() + ", Value: " + entry.getValue() + "\n";
                    }
                }
            }

            try (BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()))) {
                String line;
                while ((line = br.readLine()) != null) {
                    result += line + "\n";
                }
            }

        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("인코딩 실패", e);
        } catch (IOException e) {
            result = e.getMessage();
        }

        return result;
    }


}
