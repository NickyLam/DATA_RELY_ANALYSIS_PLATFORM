/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_ic_ec_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_ic_ec_acct_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_ic_ec_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_ic_ec_acct_info(
    card_no varchar2(76) -- 卡号
    ,ic_card_seq varchar2(12) -- 卡序列号
    ,ic_aid varchar2(128) -- 应用标识符
    ,ec_acct_stat varchar2(4) -- 电子现金账户状态
    ,ec_acct_ccy varchar2(12) -- 电子现金账户币种
    ,ic_act_bal number(17,2) -- 电子现金账户余额
    ,ec_bal_top_limit number(17,2) -- 电子现金余额上限
    ,ec_tran_limit number(17,2) -- 电子现金单笔交易限额
    ,ic_app_start_date varchar2(32) -- 应用生效日期
    ,ic_app_end_date varchar2(32) -- 应用失效日期
    ,open_date date -- 电子现金账户开户日期
    ,acct_name varchar2(200) -- 账户名称
    ,open_org_id varchar2(48) -- 开户机构
    ,aggr_amt number(17,2) -- 累计圈存金额
    ,acct_close_date date -- 电子现金账户销户日期
    ,close_seq_num varchar2(200) -- 销户流水号
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
grant select on ${iol_schema}.ncbs_ic_ec_acct_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_ic_ec_acct_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_ic_ec_acct_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_ic_ec_acct_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_ic_ec_acct_info is 'IC卡电子现金账户表';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.card_no is '卡号';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.ic_card_seq is '卡序列号';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.ic_aid is '应用标识符';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.ec_acct_stat is '电子现金账户状态';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.ec_acct_ccy is '电子现金账户币种';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.ic_act_bal is '电子现金账户余额';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.ec_bal_top_limit is '电子现金余额上限';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.ec_tran_limit is '电子现金单笔交易限额';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.ic_app_start_date is '应用生效日期';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.ic_app_end_date is '应用失效日期';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.open_date is '电子现金账户开户日期';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.open_org_id is '开户机构';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.aggr_amt is '累计圈存金额';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.acct_close_date is '电子现金账户销户日期';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.close_seq_num is '销户流水号';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_ic_ec_acct_info.etl_timestamp is 'ETL处理时间戳';
