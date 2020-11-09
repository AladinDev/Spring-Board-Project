package org.zerock.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;

import lombok.Setter;

public class MemberJoinServiceImpl implements MemberJoinService {

	@Setter(onMethod_ = @Autowired)
	private MemberMapper mapper;
	
	@Override
	public void join(MemberVO vo) {
		mapper.join(vo);
		
	}

}
