/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_flowtask_refuse_tb
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.scps_bp_flowtask_refuse_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_flowtask_refuse_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_flowtask_refuse_tb_op purge;
drop table ${iol_schema}.scps_bp_flowtask_refuse_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_flowtask_refuse_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_flowtask_refuse_tb where 0=1;

create table ${iol_schema}.scps_bp_flowtask_refuse_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_flowtask_refuse_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_flowtask_refuse_tb_cl(
            task_id -- 任务号
            ,tradecode -- 交易码
            ,scene_code -- 业务场景id
            ,begin_userno -- 发起柜员
            ,begin_orgno -- 发起机构
            ,trans_time -- 交易时间
            ,trans_date -- 交易日期
            ,doc_id -- 影像流水号
            ,bank_no -- 银行号
            ,system_no -- 系统编号
            ,task_state -- 业务处理状态
            ,account_no -- 本行账号
            ,account_name -- 本行名称
            ,end_time -- 结束时间
            ,end_date -- 结束日期
            ,refusal_reason -- 拒绝原因
            ,reason_of_error -- 差错认定原因（默认为空，由经办人员手工输入）
            ,mode_type -- 作业模式 1-集中作业；2-远程授权
            ,error_status -- 状态 1-待作业岗审核；2-待主管审核；3-通过
            ,branch_serial -- 前台流水号
            ,error_identification_results -- 差错认定结果(1-是,0-否)
            ,error_identification_classes -- 差错认定分类
            ,remarks -- 备注
            ,sqzg_user -- 授权主管号
            ,operation_status -- 操作状态 ：01-网点申请回退、02-中心申请回退
            ,problem_class -- 问题分类
            ,channel_id -- 渠道id
            ,trans_type -- 业务大类
            ,y_task_id -- 原任务号(重提交易)
            ,glob_seq_no -- 流水号
            ,question_node -- 问题节点
            ,begin_charge_id -- 发起主管
            ,question_begin_user_no -- 问题发起人员
            ,sub_task_id -- 子任务号
            ,question_begin_date -- 问题发起日期
            ,question_begin_time -- 问题发起时间
            ,question_renson -- 问题原因
            ,issue_date -- 发布日期
            ,issue_time -- 发布时间
            ,approv_results -- 审核认定结果
            ,approv_remarks -- 审核备注
            ,approv_reason -- 审核认定原因
            ,approv_status -- 审批状态
            ,error_identification_remarks -- 差错认定备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_flowtask_refuse_tb_op(
            task_id -- 任务号
            ,tradecode -- 交易码
            ,scene_code -- 业务场景id
            ,begin_userno -- 发起柜员
            ,begin_orgno -- 发起机构
            ,trans_time -- 交易时间
            ,trans_date -- 交易日期
            ,doc_id -- 影像流水号
            ,bank_no -- 银行号
            ,system_no -- 系统编号
            ,task_state -- 业务处理状态
            ,account_no -- 本行账号
            ,account_name -- 本行名称
            ,end_time -- 结束时间
            ,end_date -- 结束日期
            ,refusal_reason -- 拒绝原因
            ,reason_of_error -- 差错认定原因（默认为空，由经办人员手工输入）
            ,mode_type -- 作业模式 1-集中作业；2-远程授权
            ,error_status -- 状态 1-待作业岗审核；2-待主管审核；3-通过
            ,branch_serial -- 前台流水号
            ,error_identification_results -- 差错认定结果(1-是,0-否)
            ,error_identification_classes -- 差错认定分类
            ,remarks -- 备注
            ,sqzg_user -- 授权主管号
            ,operation_status -- 操作状态 ：01-网点申请回退、02-中心申请回退
            ,problem_class -- 问题分类
            ,channel_id -- 渠道id
            ,trans_type -- 业务大类
            ,y_task_id -- 原任务号(重提交易)
            ,glob_seq_no -- 流水号
            ,question_node -- 问题节点
            ,begin_charge_id -- 发起主管
            ,question_begin_user_no -- 问题发起人员
            ,sub_task_id -- 子任务号
            ,question_begin_date -- 问题发起日期
            ,question_begin_time -- 问题发起时间
            ,question_renson -- 问题原因
            ,issue_date -- 发布日期
            ,issue_time -- 发布时间
            ,approv_results -- 审核认定结果
            ,approv_remarks -- 审核备注
            ,approv_reason -- 审核认定原因
            ,approv_status -- 审批状态
            ,error_identification_remarks -- 差错认定备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.task_id, o.task_id) as task_id -- 任务号
    ,nvl(n.tradecode, o.tradecode) as tradecode -- 交易码
    ,nvl(n.scene_code, o.scene_code) as scene_code -- 业务场景id
    ,nvl(n.begin_userno, o.begin_userno) as begin_userno -- 发起柜员
    ,nvl(n.begin_orgno, o.begin_orgno) as begin_orgno -- 发起机构
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 交易时间
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 交易日期
    ,nvl(n.doc_id, o.doc_id) as doc_id -- 影像流水号
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行号
    ,nvl(n.system_no, o.system_no) as system_no -- 系统编号
    ,nvl(n.task_state, o.task_state) as task_state -- 业务处理状态
    ,nvl(n.account_no, o.account_no) as account_no -- 本行账号
    ,nvl(n.account_name, o.account_name) as account_name -- 本行名称
    ,nvl(n.end_time, o.end_time) as end_time -- 结束时间
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.refusal_reason, o.refusal_reason) as refusal_reason -- 拒绝原因
    ,nvl(n.reason_of_error, o.reason_of_error) as reason_of_error -- 差错认定原因（默认为空，由经办人员手工输入）
    ,nvl(n.mode_type, o.mode_type) as mode_type -- 作业模式 1-集中作业；2-远程授权
    ,nvl(n.error_status, o.error_status) as error_status -- 状态 1-待作业岗审核；2-待主管审核；3-通过
    ,nvl(n.branch_serial, o.branch_serial) as branch_serial -- 前台流水号
    ,nvl(n.error_identification_results, o.error_identification_results) as error_identification_results -- 差错认定结果(1-是,0-否)
    ,nvl(n.error_identification_classes, o.error_identification_classes) as error_identification_classes -- 差错认定分类
    ,nvl(n.remarks, o.remarks) as remarks -- 备注
    ,nvl(n.sqzg_user, o.sqzg_user) as sqzg_user -- 授权主管号
    ,nvl(n.operation_status, o.operation_status) as operation_status -- 操作状态 ：01-网点申请回退、02-中心申请回退
    ,nvl(n.problem_class, o.problem_class) as problem_class -- 问题分类
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 渠道id
    ,nvl(n.trans_type, o.trans_type) as trans_type -- 业务大类
    ,nvl(n.y_task_id, o.y_task_id) as y_task_id -- 原任务号(重提交易)
    ,nvl(n.glob_seq_no, o.glob_seq_no) as glob_seq_no -- 流水号
    ,nvl(n.question_node, o.question_node) as question_node -- 问题节点
    ,nvl(n.begin_charge_id, o.begin_charge_id) as begin_charge_id -- 发起主管
    ,nvl(n.question_begin_user_no, o.question_begin_user_no) as question_begin_user_no -- 问题发起人员
    ,nvl(n.sub_task_id, o.sub_task_id) as sub_task_id -- 子任务号
    ,nvl(n.question_begin_date, o.question_begin_date) as question_begin_date -- 问题发起日期
    ,nvl(n.question_begin_time, o.question_begin_time) as question_begin_time -- 问题发起时间
    ,nvl(n.question_renson, o.question_renson) as question_renson -- 问题原因
    ,nvl(n.issue_date, o.issue_date) as issue_date -- 发布日期
    ,nvl(n.issue_time, o.issue_time) as issue_time -- 发布时间
    ,nvl(n.approv_results, o.approv_results) as approv_results -- 审核认定结果
    ,nvl(n.approv_remarks, o.approv_remarks) as approv_remarks -- 审核备注
    ,nvl(n.approv_reason, o.approv_reason) as approv_reason -- 审核认定原因
    ,nvl(n.approv_status, o.approv_status) as approv_status -- 审批状态
    ,nvl(n.error_identification_remarks, o.error_identification_remarks) as error_identification_remarks -- 差错认定备注
    ,case when
            n.task_id is null
            and n.bank_no is null
            and n.system_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.task_id is null
            and n.bank_no is null
            and n.system_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.task_id is null
            and n.bank_no is null
            and n.system_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_flowtask_refuse_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_flowtask_refuse_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.task_id = n.task_id
            and o.bank_no = n.bank_no
            and o.system_no = n.system_no
where (
        o.task_id is null
        and o.bank_no is null
        and o.system_no is null
    )
    or (
        n.task_id is null
        and n.bank_no is null
        and n.system_no is null
    )
    or (
        o.tradecode <> n.tradecode
        or o.scene_code <> n.scene_code
        or o.begin_userno <> n.begin_userno
        or o.begin_orgno <> n.begin_orgno
        or o.trans_time <> n.trans_time
        or o.trans_date <> n.trans_date
        or o.doc_id <> n.doc_id
        or o.task_state <> n.task_state
        or o.account_no <> n.account_no
        or o.account_name <> n.account_name
        or o.end_time <> n.end_time
        or o.end_date <> n.end_date
        or o.refusal_reason <> n.refusal_reason
        or o.reason_of_error <> n.reason_of_error
        or o.mode_type <> n.mode_type
        or o.error_status <> n.error_status
        or o.branch_serial <> n.branch_serial
        or o.error_identification_results <> n.error_identification_results
        or o.error_identification_classes <> n.error_identification_classes
        or o.remarks <> n.remarks
        or o.sqzg_user <> n.sqzg_user
        or o.operation_status <> n.operation_status
        or o.problem_class <> n.problem_class
        or o.channel_id <> n.channel_id
        or o.trans_type <> n.trans_type
        or o.y_task_id <> n.y_task_id
        or o.glob_seq_no <> n.glob_seq_no
        or o.question_node <> n.question_node
        or o.begin_charge_id <> n.begin_charge_id
        or o.question_begin_user_no <> n.question_begin_user_no
        or o.sub_task_id <> n.sub_task_id
        or o.question_begin_date <> n.question_begin_date
        or o.question_begin_time <> n.question_begin_time
        or o.question_renson <> n.question_renson
        or o.issue_date <> n.issue_date
        or o.issue_time <> n.issue_time
        or o.approv_results <> n.approv_results
        or o.approv_remarks <> n.approv_remarks
        or o.approv_reason <> n.approv_reason
        or o.approv_status <> n.approv_status
        or o.error_identification_remarks <> n.error_identification_remarks
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_flowtask_refuse_tb_cl(
            task_id -- 任务号
            ,tradecode -- 交易码
            ,scene_code -- 业务场景id
            ,begin_userno -- 发起柜员
            ,begin_orgno -- 发起机构
            ,trans_time -- 交易时间
            ,trans_date -- 交易日期
            ,doc_id -- 影像流水号
            ,bank_no -- 银行号
            ,system_no -- 系统编号
            ,task_state -- 业务处理状态
            ,account_no -- 本行账号
            ,account_name -- 本行名称
            ,end_time -- 结束时间
            ,end_date -- 结束日期
            ,refusal_reason -- 拒绝原因
            ,reason_of_error -- 差错认定原因（默认为空，由经办人员手工输入）
            ,mode_type -- 作业模式 1-集中作业；2-远程授权
            ,error_status -- 状态 1-待作业岗审核；2-待主管审核；3-通过
            ,branch_serial -- 前台流水号
            ,error_identification_results -- 差错认定结果(1-是,0-否)
            ,error_identification_classes -- 差错认定分类
            ,remarks -- 备注
            ,sqzg_user -- 授权主管号
            ,operation_status -- 操作状态 ：01-网点申请回退、02-中心申请回退
            ,problem_class -- 问题分类
            ,channel_id -- 渠道id
            ,trans_type -- 业务大类
            ,y_task_id -- 原任务号(重提交易)
            ,glob_seq_no -- 流水号
            ,question_node -- 问题节点
            ,begin_charge_id -- 发起主管
            ,question_begin_user_no -- 问题发起人员
            ,sub_task_id -- 子任务号
            ,question_begin_date -- 问题发起日期
            ,question_begin_time -- 问题发起时间
            ,question_renson -- 问题原因
            ,issue_date -- 发布日期
            ,issue_time -- 发布时间
            ,approv_results -- 审核认定结果
            ,approv_remarks -- 审核备注
            ,approv_reason -- 审核认定原因
            ,approv_status -- 审批状态
            ,error_identification_remarks -- 差错认定备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_flowtask_refuse_tb_op(
            task_id -- 任务号
            ,tradecode -- 交易码
            ,scene_code -- 业务场景id
            ,begin_userno -- 发起柜员
            ,begin_orgno -- 发起机构
            ,trans_time -- 交易时间
            ,trans_date -- 交易日期
            ,doc_id -- 影像流水号
            ,bank_no -- 银行号
            ,system_no -- 系统编号
            ,task_state -- 业务处理状态
            ,account_no -- 本行账号
            ,account_name -- 本行名称
            ,end_time -- 结束时间
            ,end_date -- 结束日期
            ,refusal_reason -- 拒绝原因
            ,reason_of_error -- 差错认定原因（默认为空，由经办人员手工输入）
            ,mode_type -- 作业模式 1-集中作业；2-远程授权
            ,error_status -- 状态 1-待作业岗审核；2-待主管审核；3-通过
            ,branch_serial -- 前台流水号
            ,error_identification_results -- 差错认定结果(1-是,0-否)
            ,error_identification_classes -- 差错认定分类
            ,remarks -- 备注
            ,sqzg_user -- 授权主管号
            ,operation_status -- 操作状态 ：01-网点申请回退、02-中心申请回退
            ,problem_class -- 问题分类
            ,channel_id -- 渠道id
            ,trans_type -- 业务大类
            ,y_task_id -- 原任务号(重提交易)
            ,glob_seq_no -- 流水号
            ,question_node -- 问题节点
            ,begin_charge_id -- 发起主管
            ,question_begin_user_no -- 问题发起人员
            ,sub_task_id -- 子任务号
            ,question_begin_date -- 问题发起日期
            ,question_begin_time -- 问题发起时间
            ,question_renson -- 问题原因
            ,issue_date -- 发布日期
            ,issue_time -- 发布时间
            ,approv_results -- 审核认定结果
            ,approv_remarks -- 审核备注
            ,approv_reason -- 审核认定原因
            ,approv_status -- 审批状态
            ,error_identification_remarks -- 差错认定备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.task_id -- 任务号
    ,o.tradecode -- 交易码
    ,o.scene_code -- 业务场景id
    ,o.begin_userno -- 发起柜员
    ,o.begin_orgno -- 发起机构
    ,o.trans_time -- 交易时间
    ,o.trans_date -- 交易日期
    ,o.doc_id -- 影像流水号
    ,o.bank_no -- 银行号
    ,o.system_no -- 系统编号
    ,o.task_state -- 业务处理状态
    ,o.account_no -- 本行账号
    ,o.account_name -- 本行名称
    ,o.end_time -- 结束时间
    ,o.end_date -- 结束日期
    ,o.refusal_reason -- 拒绝原因
    ,o.reason_of_error -- 差错认定原因（默认为空，由经办人员手工输入）
    ,o.mode_type -- 作业模式 1-集中作业；2-远程授权
    ,o.error_status -- 状态 1-待作业岗审核；2-待主管审核；3-通过
    ,o.branch_serial -- 前台流水号
    ,o.error_identification_results -- 差错认定结果(1-是,0-否)
    ,o.error_identification_classes -- 差错认定分类
    ,o.remarks -- 备注
    ,o.sqzg_user -- 授权主管号
    ,o.operation_status -- 操作状态 ：01-网点申请回退、02-中心申请回退
    ,o.problem_class -- 问题分类
    ,o.channel_id -- 渠道id
    ,o.trans_type -- 业务大类
    ,o.y_task_id -- 原任务号(重提交易)
    ,o.glob_seq_no -- 流水号
    ,o.question_node -- 问题节点
    ,o.begin_charge_id -- 发起主管
    ,o.question_begin_user_no -- 问题发起人员
    ,o.sub_task_id -- 子任务号
    ,o.question_begin_date -- 问题发起日期
    ,o.question_begin_time -- 问题发起时间
    ,o.question_renson -- 问题原因
    ,o.issue_date -- 发布日期
    ,o.issue_time -- 发布时间
    ,o.approv_results -- 审核认定结果
    ,o.approv_remarks -- 审核备注
    ,o.approv_reason -- 审核认定原因
    ,o.approv_status -- 审批状态
    ,o.error_identification_remarks -- 差错认定备注
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.scps_bp_flowtask_refuse_tb_bk o
    left join ${iol_schema}.scps_bp_flowtask_refuse_tb_op n
        on
            o.task_id = n.task_id
            and o.bank_no = n.bank_no
            and o.system_no = n.system_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_flowtask_refuse_tb_cl d
        on
            o.task_id = d.task_id
            and o.bank_no = d.bank_no
            and o.system_no = d.system_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_flowtask_refuse_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_flowtask_refuse_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_flowtask_refuse_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_flowtask_refuse_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_flowtask_refuse_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_flowtask_refuse_tb_cl;
alter table ${iol_schema}.scps_bp_flowtask_refuse_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_flowtask_refuse_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_flowtask_refuse_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_flowtask_refuse_tb_op purge;
drop table ${iol_schema}.scps_bp_flowtask_refuse_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_flowtask_refuse_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_flowtask_refuse_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
