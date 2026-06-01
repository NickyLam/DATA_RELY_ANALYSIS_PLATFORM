/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_past_due_bal_step
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_past_due_bal_step
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_past_due_bal_step purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_past_due_bal_step(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cl_past_due_bal_step to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_past_due_bal_step to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_past_due_bal_step to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_past_due_bal_step to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_past_due_bal_step is '余额批处理更新日期表';
comment on column ${iol_schema}.ncbs_cl_past_due_bal_step.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_past_due_bal_step.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_past_due_bal_step.company is '法人';
comment on column ${iol_schema}.ncbs_cl_past_due_bal_step.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_past_due_bal_step.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_past_due_bal_step.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_past_due_bal_step.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_past_due_bal_step.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_past_due_bal_step.etl_timestamp is 'ETL处理时间戳';
