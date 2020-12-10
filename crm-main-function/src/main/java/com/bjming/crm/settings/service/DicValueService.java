package com.bjming.crm.settings.service;

import com.bjming.crm.settings.domain.DicValue;

import java.util.List;

/**
 * 2020/12/09 by AshenOne
 */
public interface DicValueService {
    List<DicValue> queryDicValuesByTypeCode(String typeCode);
}


