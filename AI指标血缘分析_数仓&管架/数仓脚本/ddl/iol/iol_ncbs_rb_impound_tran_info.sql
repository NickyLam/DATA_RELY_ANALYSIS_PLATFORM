/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_impound_tran_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_impound_tran_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_impound_tran_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_impound_tran_info(
    amt_type varchar2(10) -- 金额类型
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,agreement_id varchar2(50) -- 协议编号
    ,company varchar2(20) -- 法人
    ,narrative varchar2(400) -- 摘要
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,benefit_internal_key number(15) -- 受益人账户主键
    ,impound_amt number(17,2) -- 扣划金额
    ,transfer_balance number(17,2) -- 未扣划余额
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
grant select on ${iol_schema}.ncbs_rb_impound_tran_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_impound_tran_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_impound_tran_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_impound_tran_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_impound_tran_info is '周期性扣划流水表';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.benefit_internal_key is '受益人账户主键';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.impound_amt is '扣划金额';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.transfer_balance is '未扣划余额';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_impound_tran_info.etl_timestamp is 'ETL处理时间戳';
