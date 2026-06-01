/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_tohonor_rec_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_tohonor_rec_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_tohonor_rec_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_tohonor_rec_info(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,batch_online varchar2(1) -- 批处理或在线更新
    ,company varchar2(20) -- 法人
    ,deal_type varchar2(1) -- 处理类型
    ,seq_no varchar2(50) -- 序号
    ,stage_code varchar2(50) -- 期次代码
    ,stage_prod_class varchar2(5) -- 期次产品分类
    ,tohonor_result varchar2(1) -- 兑付/赎回结果
    ,acct_open_date date -- 账户开户日期
    ,maturity_date date -- 到期日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,failure_reason varchar2(200) -- 失败原因
    ,int_amt number(17,2) -- 利息金额
    ,pri_amt number(17,2) -- 本金金额
    ,priint_acct_name varchar2(200) -- 利息入账账户名称
    ,priint_acct_seq_no varchar2(5) -- 本息入账账户序列号
    ,priint_base_acct_no varchar2(50) -- 本息入账账号
    ,priint_ccy varchar2(3) -- 本息入账账户币种
    ,priint_internal_key number(15) -- 本息入账账户标识符
    ,priint_prod_type varchar2(12) -- 本息入账账户产品类型
    ,tohonor_rec_amt number(17,2) -- 兑付赎回金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,year_rate number(15,8) -- 年利率
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
grant select on ${iol_schema}.ncbs_rb_dc_tohonor_rec_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_tohonor_rec_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_tohonor_rec_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_tohonor_rec_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_tohonor_rec_info is '到期自动兑付/赎回登记表';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.batch_online is '批处理或在线更新';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.deal_type is '处理类型';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.stage_prod_class is '期次产品分类';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.tohonor_result is '兑付/赎回结果';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.failure_reason is '失败原因';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.pri_amt is '本金金额';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.priint_acct_name is '利息入账账户名称';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.priint_acct_seq_no is '本息入账账户序列号';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.priint_base_acct_no is '本息入账账号';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.priint_ccy is '本息入账账户币种';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.priint_internal_key is '本息入账账户标识符';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.priint_prod_type is '本息入账账户产品类型';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.tohonor_rec_amt is '兑付赎回金额';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.year_rate is '年利率';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_dc_tohonor_rec_info.etl_timestamp is 'ETL处理时间戳';
