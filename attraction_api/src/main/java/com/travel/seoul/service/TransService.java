package com.travel.seoul.service;

import com.travel.seoul.vo.TransVO;

public interface TransService {
	public String test();
	public String getChinese(TransVO dd);
	public String getEnglish(TransVO dd);
	public String getJapanese(TransVO dd);
	//언어감지 테스트필요
	public String detectLanguage(TransVO dd);
}
