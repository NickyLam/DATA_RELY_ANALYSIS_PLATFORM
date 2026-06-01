/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_plan_run_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_plan_run_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_plan_run_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_plan_run_info(
    amount number(17,2) -- 金额
    ,amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,error_code varchar2(50) -- 错误码
    ,error_msg varchar2(3000) -- 错误代码
    ,event_type varchar2(20) -- 事件类型
    ,plan_no varchar2(50) -- 执行计划编号
    ,reserve1 varchar2(50) -- 预留字段1
    ,reserve2 varchar2(50) -- 预留字段2
    ,tran_status varchar2(1) -- 冲补抹标志
    ,deal_date date -- 处理日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,loan_no varchar2(50) -- 贷款号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_cl_plan_run_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_plan_run_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_plan_run_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_plan_run_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_plan_run_info is '贷款计划执行信息表';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.amount is '金额';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.company is '法人';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.error_code is '错误码';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.plan_no is '执行计划编号';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.reserve1 is '预留字段1';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.reserve2 is '预留字段2';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.deal_date is '处理日期';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_plan_run_info.etl_timestamp is 'ETL处理时间戳';
