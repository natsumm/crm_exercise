package com.bjming.crm.settings.service.impl;

import com.bjming.crm.settings.domain.DicValue;
import com.bjming.crm.settings.mapper.DicValueMapper;
import com.bjming.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 2020/12/09 by AshenOne
 */
@Service
public class DicValueServiceImpl implements DicValueService {
    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValuesByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValuesByTypeCode(typeCode);
    }
}


