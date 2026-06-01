/*
Purpose:    偏源模型层-O层拉链算法回插脚本
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ICMS_ALERT_WASTEBOOK_ret1
CreateDate: 20240712_月度版本
Logs:
     SUNDEXIN 新建脚本 
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
                       FROM ICMS_ALERT_WASTEBOOK_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('ICMS_ALERT_WASTEBOOK');
  
  if v_var <> 0 then 
    execute immediate 'alter table ICMS_ALERT_WASTEBOOK drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table ICMS_ALERT_WASTEBOOK add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
-- 回插备份表的所有数据    
   
insert /*+ append */ into ${iol_schema}.ICMS_ALERT_WASTEBOOK(
            serialno -- 流水号
            ,updatedate -- 更新日期
            ,delstatus -- 状态
            ,cutdate -- 任务截止日期
            ,isoutfinish -- 是否过期未完成
            ,confirmstatus -- 确认状态
            ,effectflag -- 生效标志
            ,updateorgid -- 更新机构
            ,relativeserialno -- 关联流水号
            ,certid -- 证件编号
            ,customertype -- 客户类型
            ,accountmonth -- 会计月份
            ,orgid -- 机构号
            ,certtype -- 证件类型
            ,buildtype -- 预警发起方式
            ,isoverdue -- 是否过期
            ,alerttype -- 警示类型
            ,finishdate -- 完成日期
            ,approvestatus -- 流程状态
            ,migtflag -- 
            ,customername -- 客户名
            ,endstatus -- 结束状态
            ,balance -- 余额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,customerid -- 客户号
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,alertcontent -- 预警内容
            ,alertinfosource -- 预警信息来源
            ,remark1 -- 客户经理失效原因
            ,remark2 -- 风险经理失效原因
            ,remark3 -- 总经理室失效原因
            ,remark4 -- 客户经理生效原因
            ,belongdept -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            serialno -- 流水号
            ,updatedate -- 更新日期
            ,delstatus -- 状态
            ,cutdate -- 任务截止日期
            ,isoutfinish -- 是否过期未完成
            ,confirmstatus -- 确认状态
            ,effectflag -- 生效标志
            ,updateorgid -- 更新机构
            ,relativeserialno -- 关联流水号
            ,certid -- 证件编号
            ,customertype -- 客户类型
            ,accountmonth -- 会计月份
            ,orgid -- 机构号
            ,certtype -- 证件类型
            ,buildtype -- 预警发起方式
            ,isoverdue -- 是否过期
            ,alerttype -- 警示类型
            ,finishdate -- 完成日期
            ,approvestatus -- 流程状态
            ,migtflag -- 
            ,customername -- 客户名
            ,endstatus -- 结束状态
            ,balance -- 余额
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,customerid -- 客户号
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,alertcontent -- 预警内容
            ,alertinfosource -- 预警信息来源
            ,remark1 -- 客户经理失效原因
            ,remark2 -- 风险经理失效原因
            ,remark3 -- 总经理室失效原因
            ,remark4 -- 客户经理生效原因
            ,' ' AS belongdept -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ICMS_ALERT_WASTEBOOK_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;


end loop;
end;
/
