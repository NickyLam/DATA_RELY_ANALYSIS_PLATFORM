/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol heps_s_loan_process
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.heps_s_loan_process
whenever sqlerror continue none;
drop table ${iol_schema}.heps_s_loan_process purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.heps_s_loan_process(
    id varchar2(50) -- id
    ,operate_result varchar2(20) -- 操作结果：0失败  1成功  2待执行
    ,operator varchar2(90) -- 操作人
    ,operate_time date -- 操作时间
    ,status varchar2(12) -- 更新后状态：00-初审中，01-待分配，02-待下户核验/待补充资料，03-待面谈面签，04-终审中，05-审核通过，06-审核拒绝，07-退回，08-初审不通过，09-状态未名，10-终止，11-待质检员审核
    ,node_name varchar2(64) -- 节点名称对应上面状态（提供给前台）
    ,pre_status varchar2(12) -- 更新前状态
    ,failure_reason varchar2(60) -- 失败原因
    ,task_id varchar2(50) -- 任务流水号
    ,remark varchar2(128) -- 备注
    ,operate_trace varchar2(5) -- 操作轨迹  0 进件申请 1 初审校验 2 抢单 3 分配 4 移交 5 现场签到 6 下户核验 7 面谈面签 8 终审校验
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.heps_s_loan_process to ${iml_schema};
grant select on ${iol_schema}.heps_s_loan_process to ${icl_schema};
grant select on ${iol_schema}.heps_s_loan_process to ${idl_schema};
grant select on ${iol_schema}.heps_s_loan_process to ${iel_schema};

-- comment
comment on table ${iol_schema}.heps_s_loan_process is '贷款进度记录表';
comment on column ${iol_schema}.heps_s_loan_process.id is 'id';
comment on column ${iol_schema}.heps_s_loan_process.operate_result is '操作结果：0失败  1成功  2待执行';
comment on column ${iol_schema}.heps_s_loan_process.operator is '操作人';
comment on column ${iol_schema}.heps_s_loan_process.operate_time is '操作时间';
comment on column ${iol_schema}.heps_s_loan_process.status is '更新后状态：00-初审中，01-待分配，02-待下户核验/待补充资料，03-待面谈面签，04-终审中，05-审核通过，06-审核拒绝，07-退回，08-初审不通过，09-状态未名，10-终止，11-待质检员审核';
comment on column ${iol_schema}.heps_s_loan_process.node_name is '节点名称对应上面状态（提供给前台）';
comment on column ${iol_schema}.heps_s_loan_process.pre_status is '更新前状态';
comment on column ${iol_schema}.heps_s_loan_process.failure_reason is '失败原因';
comment on column ${iol_schema}.heps_s_loan_process.task_id is '任务流水号';
comment on column ${iol_schema}.heps_s_loan_process.remark is '备注';
comment on column ${iol_schema}.heps_s_loan_process.operate_trace is '操作轨迹  0 进件申请 1 初审校验 2 抢单 3 分配 4 移交 5 现场签到 6 下户核验 7 面谈面签 8 终审校验';
comment on column ${iol_schema}.heps_s_loan_process.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.heps_s_loan_process.etl_timestamp is 'ETL处理时间戳';
