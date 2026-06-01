/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_amend_branch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_amend_branch
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_amend_branch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_amend_branch(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,amend_seq_no varchar2(50) -- 变更序号
    ,company varchar2(20) -- 法人
    ,error_msg varchar2(3000) -- 错误代码
    ,seq_no varchar2(50) -- 序号
    ,amend_date date -- 变更日期
    ,auth_date date -- 授权日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,auth_user_id varchar2(8) -- 授权柜员
    ,new_branch varchar2(12) -- 变更后机构
    ,old_branch varchar2(12) -- 变更前机构
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,branch_change_type varchar2(20) -- 机构撤并交易类型
    ,ob_amend_seq_no varchar2(50) -- 记录机构变更时，公共产生的序号
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
grant select on ${iol_schema}.ncbs_rb_amend_branch to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_amend_branch to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_amend_branch to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_amend_branch to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_amend_branch is '机构变更登记表';
comment on column ${iol_schema}.ncbs_rb_amend_branch.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_amend_branch.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_amend_branch.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_amend_branch.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_amend_branch.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_amend_branch.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_amend_branch.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_amend_branch.amend_seq_no is '变更序号';
comment on column ${iol_schema}.ncbs_rb_amend_branch.company is '法人';
comment on column ${iol_schema}.ncbs_rb_amend_branch.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_rb_amend_branch.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_amend_branch.amend_date is '变更日期';
comment on column ${iol_schema}.ncbs_rb_amend_branch.auth_date is '授权日期';
comment on column ${iol_schema}.ncbs_rb_amend_branch.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_amend_branch.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_amend_branch.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_amend_branch.new_branch is '变更后机构';
comment on column ${iol_schema}.ncbs_rb_amend_branch.old_branch is '变更前机构';
comment on column ${iol_schema}.ncbs_rb_amend_branch.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_amend_branch.branch_change_type is '机构撤并交易类型';
comment on column ${iol_schema}.ncbs_rb_amend_branch.ob_amend_seq_no is '记录机构变更时，公共产生的序号';
comment on column ${iol_schema}.ncbs_rb_amend_branch.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_amend_branch.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_amend_branch.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_amend_branch.etl_timestamp is 'ETL处理时间戳';
