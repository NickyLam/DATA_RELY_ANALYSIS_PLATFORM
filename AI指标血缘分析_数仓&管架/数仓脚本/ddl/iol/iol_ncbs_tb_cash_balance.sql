/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_cash_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_cash_balance
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_cash_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_balance(
    amount number(17,2) -- 金额
    ,branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,company varchar2(20) -- 法人
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,update_date date -- 更新日期
    ,available_amt number(17,2) -- 可用余额
    ,amount_prev number(17,2) -- 期初金额
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
grant select on ${iol_schema}.ncbs_tb_cash_balance to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_cash_balance to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_balance to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_cash_balance is '尾箱现金余额表';
comment on column ${iol_schema}.ncbs_tb_cash_balance.amount is '金额';
comment on column ${iol_schema}.ncbs_tb_cash_balance.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_cash_balance.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_cash_balance.company is '法人';
comment on column ${iol_schema}.ncbs_tb_cash_balance.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_cash_balance.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_cash_balance.update_date is '更新日期';
comment on column ${iol_schema}.ncbs_tb_cash_balance.available_amt is '可用余额';
comment on column ${iol_schema}.ncbs_tb_cash_balance.amount_prev is '期初金额';
comment on column ${iol_schema}.ncbs_tb_cash_balance.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_cash_balance.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_cash_balance.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_cash_balance.etl_timestamp is 'ETL处理时间戳';
