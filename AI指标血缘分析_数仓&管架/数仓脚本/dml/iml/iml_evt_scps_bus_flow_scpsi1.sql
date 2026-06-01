/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_scps_bus_flow_scpsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_scps_bus_flow_scpsi1_tm purge;
alter table ${iml_schema}.evt_scps_bus_flow add partition p_scpsi1 values ('scpsi1')(
        subpartition p_scpsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_scps_bus_flow modify partition p_scpsi1
    add subpartition p_scpsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_scps_bus_flow_scpsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,task_no -- 任务号
    ,bank_no -- 银行行号
    ,sys_id -- 系统编号
    ,sub_task_no -- 子任务号
    ,init_task_no -- 原任务号
    ,bus_flow_num -- 业务流水号
    ,ova_flow_num -- 全局流水号
    ,blip_flow_num -- 影像流水号
    ,tran_code -- 交易码
    ,chn_id -- 渠道编号
    ,bus_scene_id -- 业务场景编号
    ,bus_proc_prior_level -- 业务处理优先级
    ,prior_level_descb -- 优先级描述
    ,opera_mode_cd -- 作业模式代码
    ,init_teller_id -- 发起柜员编号
    ,init_org_id -- 发起机构编号
    ,bus_proc_org_id -- 业务处理机构编号
    ,tran_amt -- 交易金额
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,task_status_cd -- 任务状态代码
    ,cust_id -- 客户编号
    ,payer_acct_id -- 付款人账户编号
    ,payer_acct_name -- 付款人账户名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_acct_name -- 收款人账户名称
    ,ghb_acct_id -- 本行账户编号
    ,ghb_acct_name -- 本行账户名称
    ,authoriz_diret_teller_id -- 授权主管柜员编号
    ,refuse_rs_descb -- 拒绝原因描述
    ,invalid_tm -- 失效时间
    ,invalid_dt -- 失效日期
    ,termnt_rs_descb -- 终止原因描述
    ,blip_model_id -- 影像模型编号
    ,blip_upload_tm -- 影像上传日期
    ,entry_flow_num -- 记账流水号
    ,entry_dt -- 记账日期
    ,entry_tm -- 记账时间
    ,prob_initor_cd -- 问题发起端代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_scps_bus_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- scps_bp_translist_tb-1
insert into ${iml_schema}.evt_scps_bus_flow_scpsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,task_no -- 任务号
    ,bank_no -- 银行行号
    ,sys_id -- 系统编号
    ,sub_task_no -- 子任务号
    ,init_task_no -- 原任务号
    ,bus_flow_num -- 业务流水号
    ,ova_flow_num -- 全局流水号
    ,blip_flow_num -- 影像流水号
    ,tran_code -- 交易码
    ,chn_id -- 渠道编号
    ,bus_scene_id -- 业务场景编号
    ,bus_proc_prior_level -- 业务处理优先级
    ,prior_level_descb -- 优先级描述
    ,opera_mode_cd -- 作业模式代码
    ,init_teller_id -- 发起柜员编号
    ,init_org_id -- 发起机构编号
    ,bus_proc_org_id -- 业务处理机构编号
    ,tran_amt -- 交易金额
    ,tran_tm -- 交易时间
    ,tran_dt -- 交易日期
    ,task_status_cd -- 任务状态代码
    ,cust_id -- 客户编号
    ,payer_acct_id -- 付款人账户编号
    ,payer_acct_name -- 付款人账户名称
    ,recver_acct_id -- 收款人账户编号
    ,recver_acct_name -- 收款人账户名称
    ,ghb_acct_id -- 本行账户编号
    ,ghb_acct_name -- 本行账户名称
    ,authoriz_diret_teller_id -- 授权主管柜员编号
    ,refuse_rs_descb -- 拒绝原因描述
    ,invalid_tm -- 失效时间
    ,invalid_dt -- 失效日期
    ,termnt_rs_descb -- 终止原因描述
    ,blip_model_id -- 影像模型编号
    ,blip_upload_tm -- 影像上传日期
    ,entry_flow_num -- 记账流水号
    ,entry_dt -- 记账日期
    ,entry_tm -- 记账时间
    ,prob_initor_cd -- 问题发起端代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201017 '||P1.TASK_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TASK_ID -- 任务号
    ,P1.BANK_NO -- 银行行号
    ,P1.SYSTEM_NO -- 系统编号
    ,P1.SUBTASK_ID -- 子任务号
    ,P1.Y_TASK_ID -- 原任务号
    ,P1.BUSINESS_SERIAL -- 业务流水号
    ,P1.GLOB_SCAN_NO -- 全局流水号
    ,P1.DOC_ID -- 影像流水号
    ,P1.TRADECODE -- 交易码
    ,P1.CHANNEL_ID -- 渠道编号
    ,P1.SCENE_CODE -- 业务场景编号
    ,P1.PRIORITY -- 业务处理优先级
    ,P1.POINT_BITMAP -- 优先级描述
    ,P1.MODE_TYPE -- 作业模式代码
    ,P1.BEGIN_USERNO -- 发起柜员编号
    ,P1.BEGIN_ORGNO -- 发起机构编号
    ,P1.ADJUST_PRIORITY -- 业务处理机构编号
    ,P1.AMOUNT -- 交易金额
    ,${iml_schema}.timeformat_max2(to_char(P1.TRANS_DATE,'yyyy-mm-dd')||P1.TRANS_TIME) -- 交易时间
    ,${iml_schema}.dateformat_max2(P1.TRANS_DATE) -- 交易日期
    ,P1.TASK_STATE -- 任务状态代码
    ,P1.CUST_NO -- 客户编号
    ,P1.DRAWEE_ACCT_NO -- 付款人账户编号
    ,P1.DRAW_NAME -- 付款人账户名称
    ,P1.PAYEE_ACCT_NO -- 收款人账户编号
    ,P1.PAYEE_NAME -- 收款人账户名称
    ,P1.ACCOUNT_NO -- 本行账户编号
    ,P1.ACCOUNT_NAME -- 本行账户名称
    ,P1.SQZG_USERNO -- 授权主管柜员编号
    ,P1.REFUSAL_REASON -- 拒绝原因描述
    ,${iml_schema}.timeformat_max2(to_char(P1.END_DATE,'yyyy-mm-dd')||P1.END_TIME) -- 失效时间
    ,${iml_schema}.dateformat_max2(P1.END_DATE) -- 失效日期
    ,P1.REASON_FOR_TERMINATION -- 终止原因描述
    ,P1.MODEL_CODE -- 影像模型编号
    ,${iml_schema}.dateformat_min(P1.BUSI_START_DATE) -- 影像上传日期
    ,P1.TALLY_FLOW_NO -- 记账流水号
    ,${iml_schema}.dateformat_min(P1.ACCT_DATE) -- 记账日期
    ,${iml_schema}.timeformat_min(regexp_replace(P1.ACCT_TIME,':','.',20,1)) -- 记账时间
    ,P1.OPERATION_STATUS -- 问题发起端代码
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'scps_bp_translist_tb' -- 源表名称
    ,'scpsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.scps_bp_translist_tb p1
where  1 = 1 
 and to_char(end_date,'yyyymmdd') = '${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_scps_bus_flow truncate subpartition p_scpsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_scps_bus_flow exchange subpartition p_scpsi1_${batch_date} with table ${iml_schema}.evt_scps_bus_flow_scpsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_scps_bus_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_scps_bus_flow_scpsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_scps_bus_flow', partname => 'p_scpsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);