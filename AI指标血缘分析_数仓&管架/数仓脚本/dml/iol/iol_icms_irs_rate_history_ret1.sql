/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_irs_rate_history
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
                       FROM icms_irs_rate_history_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('icms_irs_rate_history');
  
  if v_var <> 0 then 
    execute immediate 'alter table icms_irs_rate_history drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table icms_irs_rate_history add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.icms_irs_rate_history(
            adjustlevel -- 调整等级
            ,applyid -- 评级申请Id
            ,balance -- 当时余额
            ,customerid -- 客户ID
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,finallevel -- 确认级别
            ,ifvalid -- 评级是否失效(0是失效1是有效)
            ,inputdate -- 新增时间
            ,inputorgid -- 发起人机构id
            ,inputuserid -- 发起人id
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,occurtype -- 发生类型 IRS_OCCUR_TYPE
            ,originlevel -- 初始等级
            ,overthrowlevel -- 推翻等级
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedate -- 评级生效日期
            ,ratedelayreason -- 评级延期原因
            ,rateenddate -- 评级失效日期
            ,ratereport -- 评级报告
            ,realenddate -- 评级真正失效日期,新增记录时默认和评级失效日期一致，所以不能通过是否有值来判断是否失效
            ,reportdelete -- 评级使用期次财报是否删除 1.是（财报删除时） 0.否（使用财报创建新的评级记录时）
            ,reportno -- 使用报表号
            ,reporttime -- 使用报表期次
            ,reserve -- 备用字段
            ,serialno -- 主要用于存来自老评级迁移的结果历史表里的SNUMBERRAT字段
            ,wyreason -- 查询code_library对应的WYREASON对应的违约原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            adjustlevel -- 调整等级
            ,applyid -- 评级申请Id
            ,balance -- 当时余额
            ,customerid -- 客户ID
            ,datasource -- 数据来源 1.申请2.跑批3.老评级
            ,finallevel -- 确认级别
            ,ifvalid -- 评级是否失效(0是失效1是有效)
            ,inputdate -- 新增时间
            ,inputorgid -- 发起人机构id
            ,inputuserid -- 发起人id
            ,modelcode -- 模型编码
            ,modelname -- 模型名称
            ,occurtype -- 发生类型 IRS_OCCUR_TYPE
            ,originlevel -- 初始等级
            ,overthrowlevel -- 推翻等级
            ,pusherrorinfo -- 同盾推动异常信息，如果推送成功则为空
            ,ratedate -- 评级生效日期
            ,ratedelayreason -- 评级延期原因
            ,rateenddate -- 评级失效日期
            ,ratereport -- 评级报告
            ,realenddate -- 评级真正失效日期,新增记录时默认和评级失效日期一致，所以不能通过是否有值来判断是否失效
            ,reportdelete -- 评级使用期次财报是否删除 1.是（财报删除时） 0.否（使用财报创建新的评级记录时）
            ,reportno -- 使用报表号
            ,reporttime -- 使用报表期次
            ,reserve -- 备用字段
            ,serialno -- 主要用于存来自老评级迁移的结果历史表里的SNUMBERRAT字段
            ,wyreason -- 查询code_library对应的WYREASON对应的违约原因
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_irs_rate_history_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
