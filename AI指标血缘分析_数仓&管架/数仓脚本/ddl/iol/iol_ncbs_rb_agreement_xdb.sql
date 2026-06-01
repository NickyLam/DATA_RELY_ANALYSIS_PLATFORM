/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_xdb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_xdb
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_xdb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_xdb(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_status varchar2(2) -- 协议状态
    ,auto_sign varchar2(1) -- 是否自动续约
    ,company varchar2(20) -- 法人
    ,print_flag varchar2(1) -- 打印标识
    ,seq_no varchar2(50) -- 序号
    ,source_type varchar2(6) -- 渠道编号
    ,cancel_date date -- 取消日期
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,cancel_user_id varchar2(8) -- 取消柜员
    ,keep_amt number(17,2) -- 产品留存金额
    ,sign_amt number(17,2) -- 签约金额
    ,xdb_prod_type varchar2(12) -- 协定宝产品类型
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
grant select on ${iol_schema}.ncbs_rb_agreement_xdb to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_xdb to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_xdb to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_xdb to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_xdb is '协定宝协议表';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.term is '存期';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.auto_sign is '是否自动续约';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.print_flag is '打印标识';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.cancel_date is '取消日期';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.cancel_user_id is '取消柜员';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.keep_amt is '产品留存金额';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.sign_amt is '签约金额';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.xdb_prod_type is '协定宝产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_xdb.etl_timestamp is 'ETL处理时间戳';
