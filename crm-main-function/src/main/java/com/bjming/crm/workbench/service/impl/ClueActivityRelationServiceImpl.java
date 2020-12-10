package com.bjming.crm.workbench.service.impl;

import com.bjming.crm.workbench.domain.ClueActivityRelation;
import com.bjming.crm.workbench.mapper.ClueActivityRelationMapper;
import com.bjming.crm.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 2020/12/10 by AshenOne
 */
@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;

    @Override
    public int saveCreateClueActivityRelationByList(List<ClueActivityRelation> relationList) {
        return clueActivityRelationMapper.insertClueActivityRelationByList(relationList);
    }

    @Override
    public int deleteClueActivityRelationByActivityIdAndClueId(ClueActivityRelation relation) {
        return clueActivityRelationMapper.deleteClueActivityRelationByActivityIdAndClueId(relation);
    }
}


