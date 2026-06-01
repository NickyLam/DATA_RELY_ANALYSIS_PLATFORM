/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_t_report_data
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
                       FROM orws_t_report_data_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('orws_t_report_data');
  
  if v_var <> 0 then 
    execute immediate 'alter table orws_t_report_data drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table orws_t_report_data add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
  
insert /*+ append */ into ${iol_schema}.orws_t_report_data(
            id -- 主键
            ,bmc_id -- 业务监测内容
            ,yesterday_condition -- 当天情况
            ,sb_confirmation_feedback -- 详情确认反馈支行上报
            ,bb_confirmation_feedback -- 详情确认反馈分行上报
            ,hb_confirmation_feedback -- 详情确认反馈总行上报
            ,is_count -- 是否汇总
            ,mmd_id -- 模型监控数据编号
            ,executive_organ_id -- 任务执行机构
            ,rdata_level -- 数据级别
            ,task_id -- 任务id
            ,rdata_status -- 数据状态
            ,problem_id -- 问题流程编号
            ,flow_up_status -- 是否后续跟踪
            ,risk_level -- 风险等级
            ,approve_status -- 审批状态
            ,reportto_node_id -- 上报节点
            ,business_date -- 业务日期
            ,templatetype_id -- 模板id
            ,sb_status_feedback -- 是否正常支行上报
            ,bb_status_feedback -- 是否正常分行上报
            ,hb_status_feedback -- 是否正常总行上报
            ,is_overdue -- 是否超期处理
            ,upgrade_date -- 风险升级日期
            ,approve_days -- 处理天数
            ,flow_up_id -- 跟进数据id
            ,approve_date -- 数据处理日期
            ,is_manualup -- 是否手动升级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            id -- 主键
            ,bmc_id -- 业务监测内容
            ,substr(yesterday_condition,1,1300) -- 当天情况
            ,sb_confirmation_feedback -- 详情确认反馈支行上报
            ,bb_confirmation_feedback -- 详情确认反馈分行上报
            ,hb_confirmation_feedback -- 详情确认反馈总行上报
            ,is_count -- 是否汇总
            ,mmd_id -- 模型监控数据编号
            ,executive_organ_id -- 任务执行机构
            ,rdata_level -- 数据级别
            ,task_id -- 任务id
            ,rdata_status -- 数据状态
            ,problem_id -- 问题流程编号
            ,flow_up_status -- 是否后续跟踪
            ,risk_level -- 风险等级
            ,approve_status -- 审批状态
            ,reportto_node_id -- 上报节点
            ,business_date -- 业务日期
            ,templatetype_id -- 模板id
            ,sb_status_feedback -- 是否正常支行上报
            ,bb_status_feedback -- 是否正常分行上报
            ,hb_status_feedback -- 是否正常总行上报
            ,is_overdue -- 是否超期处理
            ,upgrade_date -- 风险升级日期
            ,approve_days -- 处理天数
            ,flow_up_id -- 跟进数据id
            ,approve_date -- 数据处理日期
            ,is_manualup -- 是否手动升级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.orws_t_report_data_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
