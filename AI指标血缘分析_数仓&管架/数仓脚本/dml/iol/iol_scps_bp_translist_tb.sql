/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_translist_tb
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_translist_tb_ex purge;
alter table ${iol_schema}.scps_bp_translist_tb add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.scps_bp_translist_tb truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.scps_bp_translist_tb_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_translist_tb where 0=1;

insert /*+ append */ into ${iol_schema}.scps_bp_translist_tb_ex(
    task_id -- 任务号(集中作业取ESC订单号，远程授权放授权任务号)
    ,subtask_id -- 子任务号(事后补扫，Pad端，影像补扫)
    ,tradecode -- 交易码
    ,scene_code -- 业务场景id
    ,begin_userno -- 发起柜员
    ,begin_orgno -- 发起机构
    ,trans_time -- 交易时间(HHmmss)
    ,trans_date -- 交易日期(yyyyMMdd)
    ,doc_id -- 影像流水号
    ,bank_no -- 银行号
    ,system_no -- 系统编号
    ,task_state -- 01-处理中、02-已成功、03-已终止、04-异常状态、05-已回退
    ,account_no -- 本行账号
    ,account_name -- 本行名称
    ,end_time -- 结束时间
    ,end_date -- 结束日期
    ,adjust_priority -- 业务处理中心
    ,mode_type -- 作业模式 1-集中作业；2-远程授权
    ,amount -- 金额
    ,glob_scan_no -- 全局流水号
    ,cust_no -- 客户号
    ,operation_status -- 问题发起端，01-回退，02-终止，03-拒绝，04-事中补扫，05-事后补扫
    ,y_task_id -- 原任务号(重提交易)
    ,channel_id -- 渠道id
    ,trans_type -- 业务大类
    ,drawee_acct_no -- 交易对手账号
    ,draw_name -- 付款人名称
    ,payee_acct_no -- 收款人账号
    ,payee_name -- 收款人名称
    ,acct_date -- 记账日期(如果跟结束日期一样的话，就一样)
    ,acct_time -- 记账时间(如果跟结束时间一样的话，就一样)
    ,point_bitmap -- 优先级位图
    ,priority -- 优先级分数
    ,refusal_reason -- 原因
    ,sqzg_userno -- 授权主管号（本地授权或者远程授权的用户号）
    ,trans_subclass -- 交易子类
    ,tally_flow_no -- 记账流水
    ,model_code -- 影像模型
    ,busi_start_date -- 影像上传时间
    ,business_serial -- 业务流水
    ,opidtype -- 证件类型
    ,opidno -- 证件号码
    ,reason_for_termination -- 终止原因（显示回退或终止的原因具体信息）
    ,remark -- 备注
    ,cust_name -- 客户名称
    ,back_reason -- 回退原因
    ,back_remark -- 回退备注
    ,center_no -- 中心号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    task_id -- 任务号(集中作业取ESC订单号，远程授权放授权任务号)
    ,subtask_id -- 子任务号(事后补扫，Pad端，影像补扫)
    ,tradecode -- 交易码
    ,scene_code -- 业务场景id
    ,begin_userno -- 发起柜员
    ,begin_orgno -- 发起机构
    ,trans_time -- 交易时间(HHmmss)
    ,trans_date -- 交易日期(yyyyMMdd)
    ,doc_id -- 影像流水号
    ,bank_no -- 银行号
    ,system_no -- 系统编号
    ,task_state -- 01-处理中、02-已成功、03-已终止、04-异常状态、05-已回退
    ,account_no -- 本行账号
    ,account_name -- 本行名称
    ,end_time -- 结束时间
    ,end_date -- 结束日期
    ,adjust_priority -- 业务处理中心
    ,mode_type -- 作业模式 1-集中作业；2-远程授权
    ,amount -- 金额
    ,glob_scan_no -- 全局流水号
    ,cust_no -- 客户号
    ,operation_status -- 问题发起端，01-回退，02-终止，03-拒绝，04-事中补扫，05-事后补扫
    ,y_task_id -- 原任务号(重提交易)
    ,channel_id -- 渠道id
    ,trans_type -- 业务大类
    ,drawee_acct_no -- 交易对手账号
    ,draw_name -- 付款人名称
    ,payee_acct_no -- 收款人账号
    ,payee_name -- 收款人名称
    ,acct_date -- 记账日期(如果跟结束日期一样的话，就一样)
    ,acct_time -- 记账时间(如果跟结束时间一样的话，就一样)
    ,point_bitmap -- 优先级位图
    ,priority -- 优先级分数
    ,refusal_reason -- 原因
    ,sqzg_userno -- 授权主管号（本地授权或者远程授权的用户号）
    ,trans_subclass -- 交易子类
    ,tally_flow_no -- 记账流水
    ,model_code -- 影像模型
    ,busi_start_date -- 影像上传时间
    ,business_serial -- 业务流水
    ,opidtype -- 证件类型
    ,opidno -- 证件号码
    ,reason_for_termination -- 终止原因（显示回退或终止的原因具体信息）
    ,remark -- 备注
    ,cust_name -- 客户名称
    ,back_reason -- 回退原因
    ,back_remark -- 回退备注
    ,center_no -- 中心号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.scps_bp_translist_tb
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.scps_bp_translist_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_translist_tb_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_translist_tb to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.scps_bp_translist_tb_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_translist_tb',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);