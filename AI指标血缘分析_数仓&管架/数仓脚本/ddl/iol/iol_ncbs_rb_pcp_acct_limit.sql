/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_acct_limit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_acct_limit
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_acct_limit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_acct_limit(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,agreement_id varchar2(50) -- 协议编号
    ,company varchar2(20) -- 法人
    ,frequence varchar2(5) -- 资金池签约频率
    ,limit_status varchar2(1) -- 限额状态
    ,limit_type varchar2(2) -- 限额类型
    ,pcp_group_id varchar2(30) -- 资金池账户组id
    ,peri_limit varchar2(1) -- 是否循环使用限额
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,limit_amt number(17,2) -- 累计额度金额
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
grant select on ${iol_schema}.ncbs_rb_pcp_acct_limit to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_acct_limit to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_acct_limit to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_acct_limit to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_acct_limit is '分户限额定义表';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.frequence is '资金池签约频率';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.limit_status is '限额状态';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.limit_type is '限额类型';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.pcp_group_id is '资金池账户组id';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.peri_limit is '是否循环使用限额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.limit_amt is '累计额度金额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_limit.etl_timestamp is 'ETL处理时间戳';
