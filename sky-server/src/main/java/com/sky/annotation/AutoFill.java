package com.sky.annotation;

import com.sky.enumeration.OperationType;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;


/**
 * 自定义注解，用于标识某个方法需要进行功能字段自动填充处理
 */
//表示 @AutoFill只能标注在方法上。
@Target(ElementType.METHOD)
//表示程序运行时仍然保留这个注解，AOP切面才能通过反射读取它。
@Retention(RetentionPolicy.RUNTIME)
public @interface AutoFill {
    //数据库操作类型，包含 insert,update
    OperationType value();
}