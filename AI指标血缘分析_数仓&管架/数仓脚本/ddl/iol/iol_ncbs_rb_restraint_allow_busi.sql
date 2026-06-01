/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_restraint_allow_busi
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_restraint_allow_busi
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_restraint_allow_busi purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_restraint_allow_busi(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,restraint_type varchar2(3) -- 限制类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,busi_type varchar2(20) -- 业务种类
    ,company varchar2(20) -- 法人
    ,res_seq_no varchar2(50) -- 限制编号
    ,restraints_status varchar2(1) -- 限制状态
    ,last_tran_date date -- 最后交易日期
    ,tran_date date -- 交易日期
    ,acct_ccy varchar2(3) -- 账户币种
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,allow_channel varchar2(50) -- 允许的渠道集合
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
grant select on ${iol_schema}.ncbs_rb_restraint_allow_busi to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_restraint_allow_busi to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_restraint_allow_busi to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_restraint_allow_busi to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_restraint_allow_busi is '限制允许使用的业务信息表';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.restraint_type is '限制类型';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.busi_type is '业务种类';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.company is '法人';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.restraints_status is '限制状态';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.last_tran_date is '最后交易日期';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.allow_channel is '允许的渠道集合';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_restraint_allow_busi.etl_timestamp is 'ETL处理时间戳';
