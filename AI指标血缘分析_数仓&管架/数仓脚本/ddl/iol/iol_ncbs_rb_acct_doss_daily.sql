/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_doss_daily
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_doss_daily
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_doss_daily purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_doss_daily(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,acct_class varchar2(1) -- 账户等级
    ,company varchar2(20) -- 法人
    ,deal_status varchar2(1) -- 处理状态
    ,doss_operate_type varchar2(2) -- 转久悬操作类型
    ,doss_tran_status varchar2(1) -- 久悬业务处理状态
    ,error_msg varchar2(3000) -- 错误代码
    ,individual_flag varchar2(1) -- 对公对私标志
    ,sign_dtl varchar2(3000) -- 签约明细
    ,voucher_dtl varchar2(3000) -- 重空明细
    ,doss_date date -- 转久悬日期
    ,last_chg_time varchar2(26) -- 上一更新时间
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_acct_doss_daily to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_daily to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_daily to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_doss_daily to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_doss_daily is '久悬户每日处理登记表（eod状态转移异常登记簿）';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.acct_class is '账户等级';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.deal_status is '处理状态';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.doss_operate_type is '转久悬操作类型';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.doss_tran_status is '久悬业务处理状态';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.sign_dtl is '签约明细';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.voucher_dtl is '重空明细';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.doss_date is '转久悬日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.last_chg_time is '上一更新时间';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_doss_daily.etl_timestamp is 'ETL处理时间戳';
