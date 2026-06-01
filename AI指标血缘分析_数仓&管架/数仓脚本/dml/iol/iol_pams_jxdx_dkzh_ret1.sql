/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxdx_dkzh
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM pams_jxdx_dkzh_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('pams_jxdx_dkzh');
  
  if v_var <> 0 then 
    execute immediate 'alter table pams_jxdx_dkzh drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table pams_jxdx_dkzh add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.pams_jxdx_dkzh(
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账户代号
            ,zzh -- 子账户
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,yqkm -- 逾期科目
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,ffrq -- 发放日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,qx -- 期限
            ,nll -- 年利率
            ,llyhbz -- 利率浮动标志
            ,llyhbl -- 利率浮动比例
            ,pjh -- 票据号
            ,hth -- 合同号
            ,dkfs -- 贷款方式
            ,dkje -- 贷款金额
            ,zhye -- 账户余额
            ,zcye -- 正常余额
            ,yqye -- 逾期余额
            ,daizhiye -- 呆滞余额
            ,daizhangye -- 呆账余额
            ,bzjbl -- 保证金比例
            ,hydh -- 行员代号
            ,zhbs -- 账户标识
            ,tjrq -- 统计日期
            ,qygm -- 企业规模
            ,psckzh -- 派生存款账户
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,xwdkbs -- 小微贷款标识
            ,ywpz -- 业务品种
            ,dkfflb -- 贷款发放类别
            ,hkfs -- 还款方式
            ,bjyqts -- 本金逾期天数
            ,lxyqts -- 利息逾期天数
            ,jxfs -- 计息方式
            ,qynll -- 逾期年利率
            ,sxed -- 授信额度
            ,lsdkbs -- 绿色贷款标识
            ,jjh -- 借据号
            ,jjzt -- 拮据状态
            ,zxll -- 执行利率
            ,jzll -- 基准利率
            ,llfdfs -- 利率浮动方式
            ,jtlxsr -- 计提利息收入
            ,zyqrq -- 
            ,hxbz -- 
            ,sndkbz -- 
            ,lhdkbz -- 
            ,wldkbz -- 
            ,se -- 
            ,drlxsr -- 
            ,bwbs -- 表外标识
            ,zqjh -- 子区间号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            jxdxdh -- 绩效对象代号
            ,zhdh -- 账户代号
            ,zzh -- 子账户
            ,zhhm -- 账户户名
            ,bz -- 币种
            ,cph -- 产品号
            ,kmh -- 科目号
            ,yqkm -- 逾期科目
            ,jgdh -- 机构代号
            ,khh -- 客户号
            ,khrq -- 开户日期
            ,ffrq -- 发放日期
            ,qxrq -- 起息日期
            ,dqrq -- 到期日期
            ,xhrq -- 销户日期
            ,zhzt -- 账户状态
            ,qx -- 期限
            ,nll -- 年利率
            ,llyhbz -- 利率浮动标志
            ,llyhbl -- 利率浮动比例
            ,pjh -- 票据号
            ,hth -- 合同号
            ,dkfs -- 贷款方式
            ,dkje -- 贷款金额
            ,zhye -- 账户余额
            ,zcye -- 正常余额
            ,yqye -- 逾期余额
            ,daizhiye -- 呆滞余额
            ,daizhangye -- 呆账余额
            ,bzjbl -- 保证金比例
            ,hydh -- 行员代号
            ,zhbs -- 账户标识
            ,tjrq -- 统计日期
            ,qygm -- 企业规模
            ,psckzh -- 派生存款账户
            ,gxhslx -- 关系函数类型
            ,khdxdh -- 考核对象代号
            ,xwdkbs -- 小微贷款标识
            ,ywpz -- 业务品种
            ,dkfflb -- 贷款发放类别
            ,hkfs -- 还款方式
            ,bjyqts -- 本金逾期天数
            ,lxyqts -- 利息逾期天数
            ,jxfs -- 计息方式
            ,qynll -- 逾期年利率
            ,sxed -- 授信额度
            ,lsdkbs -- 绿色贷款标识
            ,jjh -- 借据号
            ,jjzt -- 拮据状态
            ,zxll -- 执行利率
            ,jzll -- 基准利率
            ,llfdfs -- 利率浮动方式
            ,jtlxsr -- 计提利息收入
            ,zyqrq -- 
            ,hxbz -- 
            ,sndkbz -- 
            ,lhdkbz -- 
            ,wldkbz -- 
            ,se -- 
            ,drlxsr -- 
            ,bwbs -- 表外标识
            ,' ' as zqjh -- 子区间号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.pams_jxdx_dkzh_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
