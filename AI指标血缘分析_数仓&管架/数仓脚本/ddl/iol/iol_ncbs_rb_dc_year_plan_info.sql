/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_year_plan_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_year_plan_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_year_plan_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_year_plan_info(
    ccy varchar2(3) -- 币种
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,issue_year varchar2(5) -- 发行年度
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,adjust_limit number(17,2) -- 调整额度
    ,auth_user_id varchar2(8) -- 授权柜员
    ,distribute_limit number(17,2) -- 已分配额度
    ,leave_limit number(17,2) -- 剩余额度
    ,old_record_limit number(17,2) -- 调整前备案额度
    ,record_limit number(17,2) -- 备案额度
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_dc_year_plan_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_year_plan_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_year_plan_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_year_plan_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_year_plan_info is '年度发行计划信息历史表';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.issue_year is '发行年度';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.adjust_limit is '调整额度';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.distribute_limit is '已分配额度';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.leave_limit is '剩余额度';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.old_record_limit is '调整前备案额度';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.record_limit is '备案额度';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_dc_year_plan_info.etl_timestamp is 'ETL处理时间戳';
