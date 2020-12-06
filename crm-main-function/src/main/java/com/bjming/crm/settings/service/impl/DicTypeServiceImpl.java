package com.bjming.crm.settings.service.impl;

import com.bjming.crm.settings.domain.DicType;
import com.bjming.crm.settings.mapper.DicTypeMapper;
import com.bjming.crm.settings.service.DicTypeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 2020/12/05 by AshenOne
 */
@Service
public class DicTypeServiceImpl implements DicTypeService {
    @Autowired
    private DicTypeMapper dicTypeMapper;

    @Override
    public List<DicType> queryAllDicType() {
        return dicTypeMapper.selectAllDicType();
    }

    @Override
    public int saveCreateDicType(DicType dicType) {
        return dicTypeMapper.insertDicType(dicType);
    }

    @Override
    public DicType queryDicTypeByCode(String code) {
        return dicTypeMapper.selectDicTypeByCode(code);
    }

    @Override
    public int deleteDicTypeByCodes(String[] codes) {
        return dicTypeMapper.deleteDicTypeByCodes(codes);
    }

    @Override
    public int saveEditDitType(DicType dicType) {
        return dicTypeMapper.updateDicType(dicType);
    }
}


