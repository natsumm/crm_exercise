package com.bjming.crm.workbench.service;

import com.bjming.crm.workbench.domain.ActivityRemark;

import java.util.List;

/**
 * 2020/12/09 by AshenOne
 */
public interface ActivityRemarkService {
    List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String activityId);

    int saveCreateActivityRemark(ActivityRemark remark);

    int deleteActivityRemarkById(String id);

    int saveEditActivityRemark(ActivityRemark remark);
}
