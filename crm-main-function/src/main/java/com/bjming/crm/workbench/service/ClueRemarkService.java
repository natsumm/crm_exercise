package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.ClueRemark;

import java.util.List;

/**
 * 2020/12/10 by AshenOne
 */
public interface ClueRemarkService {
    List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId);

    int saveCreateClueRemark(ClueRemark remark);

    int deleteClueRemarkById(String id);

    int saveEditClueRemark(ClueRemark remark);
}
