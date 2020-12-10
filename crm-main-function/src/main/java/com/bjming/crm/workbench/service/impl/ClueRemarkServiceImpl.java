package com.bjming.crm.workbench.service.impl;

import com.bjming.crm.workbench.domain.ClueRemark;
import com.bjming.crm.workbench.mapper.ClueRemarkMapper;
import com.bjming.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 2020/12/10 by AshenOne
 */
@Service
public class ClueRemarkServiceImpl implements ClueRemarkService {
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;

    @Override
    public List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId) {
        return clueRemarkMapper.selectClueRemarkForDetailByClueId(clueId);
    }
}


