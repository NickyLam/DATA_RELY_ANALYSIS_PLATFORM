/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_clean_parameter
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_clean_parameter
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_clean_parameter purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_clean_parameter(
    acct_status varchar2(1) -- 账户状态
    ,acct_type varchar2(1) -- 账户类型
    ,balance number(17,2) -- 余额
    ,client_no varchar2(16) -- 客户编号
    ,period_freq varchar2(5) -- 频率id
    ,prod_type varchar2(12) -- 产品编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,agreement_type varchar2(5) -- 协议类型
    ,company varchar2(20) -- 法人
    ,period_freq_type varchar2(5) -- 期限种类
    ,seq_no varchar2(50) -- 序号
    ,expire_date date -- 失效日期
    ,last_clean_date date -- 上一清扫日期
    ,next_clean_date date -- 下一清扫日期
    ,start_time varchar2(26) -- 起始时间
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
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
grant select on ${iol_schema}.ncbs_rb_clean_parameter to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_clean_parameter to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_clean_parameter to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_clean_parameter to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_clean_parameter is '账户清理参数表';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.balance is '余额';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.period_freq is '频率id';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.term is '存期';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.agreement_type is '协议类型';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.company is '法人';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.period_freq_type is '期限种类';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.last_clean_date is '上一清扫日期';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.next_clean_date is '下一清扫日期';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.start_time is '起始时间';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_clean_parameter.etl_timestamp is 'ETL处理时间戳';
