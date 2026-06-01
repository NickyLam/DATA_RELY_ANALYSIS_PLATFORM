/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_sched_mode
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_sched_mode
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_sched_mode purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_sched_mode(
    calc_formula varchar2(50) -- 计算公式
    ,company varchar2(20) -- 法人
    ,first_break_flag varchar2(1) -- 首期破期
    ,pay_rec varchar2(1) -- 收付标志
    ,pri_repay_type varchar2(1) -- 本金还款方式
    ,process_type varchar2(1) -- 本息处理方式
    ,sched_mode varchar2(2) -- 还款方式
    ,sched_mode_desc varchar2(50) -- 还款方式描述
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,last_merge_period number(5) -- 末期合并天数
    ,last_merge_type varchar2(1) -- 末期合并类型
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
grant select on ${iol_schema}.ncbs_cl_sched_mode to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_sched_mode to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_sched_mode to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_sched_mode to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_sched_mode is '计划方式定义表';
comment on column ${iol_schema}.ncbs_cl_sched_mode.calc_formula is '计算公式';
comment on column ${iol_schema}.ncbs_cl_sched_mode.company is '法人';
comment on column ${iol_schema}.ncbs_cl_sched_mode.first_break_flag is '首期破期';
comment on column ${iol_schema}.ncbs_cl_sched_mode.pay_rec is '收付标志';
comment on column ${iol_schema}.ncbs_cl_sched_mode.pri_repay_type is '本金还款方式';
comment on column ${iol_schema}.ncbs_cl_sched_mode.process_type is '本息处理方式';
comment on column ${iol_schema}.ncbs_cl_sched_mode.sched_mode is '还款方式';
comment on column ${iol_schema}.ncbs_cl_sched_mode.sched_mode_desc is '还款方式描述';
comment on column ${iol_schema}.ncbs_cl_sched_mode.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_sched_mode.last_merge_period is '末期合并天数';
comment on column ${iol_schema}.ncbs_cl_sched_mode.last_merge_type is '末期合并类型';
comment on column ${iol_schema}.ncbs_cl_sched_mode.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_sched_mode.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_sched_mode.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_sched_mode.etl_timestamp is 'ETL处理时间戳';
