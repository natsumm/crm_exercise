package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.ClueActivityRelation;

import java.util.List;

/**
 * 2020/12/10 by AshenOne
 */
public interface ClueActivityRelationService {
    int saveCreateClueActivityRelationByList(List<ClueActivityRelation> relationList);

    int deleteClueActivityRelationByActivityIdAndClueId(ClueActivityRelation relation);
}
