/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_cash_ctl_sign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_cash_ctl_sign
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_cash_ctl_sign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_cash_ctl_sign(
    base_acct_no varchar2(50) -- 交易账号/卡号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,status varchar2(1) -- 状态
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,tran_date date -- 交易日期
    ,sub_base_acct_no varchar2(50) -- 账户组子账户账号
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
grant select on ${iol_schema}.ncbs_rb_cash_ctl_sign to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_cash_ctl_sign to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_cash_ctl_sign to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_cash_ctl_sign to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_cash_ctl_sign is '现金管理签约登记表';
comment on column ${iol_schema}.ncbs_rb_cash_ctl_sign.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_cash_ctl_sign.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_cash_ctl_sign.company is '法人';
comment on column ${iol_schema}.ncbs_rb_cash_ctl_sign.status is '状态';
comment on column ${iol_schema}.ncbs_rb_cash_ctl_sign.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_rb_cash_ctl_sign.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_cash_ctl_sign.sub_base_acct_no is '账户组子账户账号';
comment on column ${iol_schema}.ncbs_rb_cash_ctl_sign.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_cash_ctl_sign.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_cash_ctl_sign.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_cash_ctl_sign.etl_timestamp is 'ETL处理时间戳';
