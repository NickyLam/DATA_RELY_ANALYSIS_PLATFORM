/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_t_report_task
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
                       FROM orws_t_report_task_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('orws_t_report_task');
  
  if v_var <> 0 then 
    execute immediate 'alter table orws_t_report_task drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table orws_t_report_task add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.orws_t_report_task(
            id -- 主键
            ,task_title -- 任务标题
            ,task_status -- 当前节点
            ,explain_advise -- 说明建议
            ,verification_opinion -- 核实意见
            ,executive_organ_id -- 任务执行机构
            ,task_level -- 任务级别
            ,parent_organ_id -- 上级机构
            ,parent_task_id -- 上级任务
            ,task_create_date -- 创建时间
            ,task_report_date -- 上报时间
            ,task_update_date -- 修改时间
            ,is_delete -- 是否删除
            ,curr_operator_id -- 当前操作人
            ,operator_entry_time -- 操作人进入时间
            ,business_date -- 业务日期
            ,curr_node_id -- 当前节点
            ,temp_verification_opinion -- 临时核实意见
            ,is_selected -- 是否选中
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- 主键
            ,task_title -- 任务标题
            ,task_status -- 当前节点
            ,substr(explain_advise,1,1300) -- 说明建议
            ,verification_opinion -- 核实意见
            ,executive_organ_id -- 任务执行机构
            ,task_level -- 任务级别
            ,parent_organ_id -- 上级机构
            ,parent_task_id -- 上级任务
            ,task_create_date -- 创建时间
            ,task_report_date -- 上报时间
            ,task_update_date -- 修改时间
            ,is_delete -- 是否删除
            ,curr_operator_id -- 当前操作人
            ,operator_entry_time -- 操作人进入时间
            ,business_date -- 业务日期
            ,curr_node_id -- 当前节点
            ,temp_verification_opinion -- 临时核实意见
            ,is_selected -- 是否选中
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.orws_t_report_task_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
