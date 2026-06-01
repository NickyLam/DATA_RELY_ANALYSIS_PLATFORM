/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_oa_form_item_data
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
                       FROM noas_oa_form_item_data_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('noas_oa_form_item_data');
  
  if v_var <> 0 then 
    execute immediate 'alter table noas_oa_form_item_data drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table noas_oa_form_item_data add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.noas_oa_form_item_data(
            form_item_data_id -- 主键
            ,process_ins_id -- 流程实体id
            ,item_key -- 表单key
            ,item_value -- 表单value
            ,form_def_id -- 表单定义id
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,process_status -- 1,审批中，2审批通过，3，已拒绝
            ,data_year -- 数据年份
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            form_item_data_id -- 主键
            ,process_ins_id -- 流程实体id
            ,item_key -- 表单key
            ,substr(item_value,1,1300) -- 表单value
            ,form_def_id -- 表单定义id
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事务时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事务时间
            ,process_status -- 1,审批中，2审批通过，3，已拒绝
            ,data_year -- 数据年份
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.noas_oa_form_item_data_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
