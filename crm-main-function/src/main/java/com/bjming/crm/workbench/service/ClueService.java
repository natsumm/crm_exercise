package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

/**
 * 2020/12/09 by AshenOne
 */
public interface ClueService {

    int saveCreateClue(Clue clue);

    List<Clue> queryClueByConditionForPage(Map<String, Object> map);

    int queryCountOfClueByCondition(Map<String, Object> map);

    Clue queryClueForDetailById(String id);

    int deleteClueByIds(String[] ids);

    Clue queryClueById(String id);

    int saveEditClue(Clue clue);
}


