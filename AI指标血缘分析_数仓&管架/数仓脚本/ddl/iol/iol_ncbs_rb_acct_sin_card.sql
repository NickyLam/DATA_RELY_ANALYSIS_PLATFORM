/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_sin_card
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_sin_card
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_sin_card purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_sin_card(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15,0) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,make_card_type varchar2(1) -- 制卡类型
    ,last_tran_date date -- 最后交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,med_ins_card_no varchar2(50) -- 医保卡号
    ,related_acct_type varchar2(12) -- 账户关联类型
    ,sin_card_no varchar2(50) -- 金融卡号
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
grant select on ${iol_schema}.ncbs_rb_acct_sin_card to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_sin_card to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_sin_card to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_sin_card to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_sin_card is '社保卡账户关联信息表';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.make_card_type is '制卡类型';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.last_tran_date is '最后交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.med_ins_card_no is '医保卡号';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.related_acct_type is '账户关联类型';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.sin_card_no is '金融卡号';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_sin_card.etl_timestamp is 'ETL处理时间戳';
