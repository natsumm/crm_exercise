package com.bjming.crm.convert;

import com.bjming.crm.commons.utils.ClueConvertUtils;
import com.bjming.crm.workbench.domain.Clue;
import com.bjming.crm.workbench.domain.Customer;
import com.bjming.crm.workbench.mapper.ClueMapper;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * 2020/12/11 by AshenOne
 */
public class ConvertTest {
    @Test
    public void test01() throws Exception {

        ApplicationContext context=new ClassPathXmlApplicationContext("applicationContext.xml");
        ClueMapper mapper= (ClueMapper) context.getBean("clueMapper");
        Clue clue=mapper.selectClueById("df68a7c6f16146a5994558331252a1dd");
        clue.setPhone(null);
        Customer customer=new Customer();
        //Customer customer= (Customer) ClueConvertUtils.injectAttributeValue(clue, Customer.class);
        ClueConvertUtils.injectAttributeValue(clue, customer);
        System.out.println(customer);
    }

    @Test
    public void test02(){
        Object s1=new String("zhangsan");
        Object s2=new String("zhangsan");
        System.out.println("s1.equals(s2) = " + s1.equals(s2));
    }
}


