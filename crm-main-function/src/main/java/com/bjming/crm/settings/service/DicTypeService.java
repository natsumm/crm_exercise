package com.bjming.crm.settings.service;

import com.bjming.crm.settings.domain.DicType;

import java.util.List;

/**
 * 2020/12/05 by AshenOne
 */
public interface DicTypeService {
    /**
     * 查询表中所有的数据字典类型
     *
     * @return
     */
    List<DicType> queryAllDicType();

    /**
     * 从实体类中插入一条记录
     *
     * @return rows
     */
    int saveCreateDicType(DicType dicType);

    DicType queryDicTypeByCode(String code);

    int deleteDicTypeByCodes(String[] codes);

    int saveEditDitType(DicType dicType);
}
