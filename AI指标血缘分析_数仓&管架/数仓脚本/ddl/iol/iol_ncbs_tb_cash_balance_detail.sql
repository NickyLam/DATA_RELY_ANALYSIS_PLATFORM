/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_cash_balance_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_cash_balance_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_cash_balance_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_balance_detail(
    amount number(17,2) -- 金额
    ,ccy varchar2(3) -- 币种
    ,cash_num number(10) -- 现金数量
    ,company varchar2(20) -- 法人
    ,par_value_id varchar2(20) -- 券别代码
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,update_date date -- 更新日期
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
grant select on ${iol_schema}.ncbs_tb_cash_balance_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_cash_balance_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_balance_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_balance_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_cash_balance_detail is '尾箱现金余额明细表';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.amount is '金额';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.cash_num is '现金数量';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.company is '法人';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.par_value_id is '券别代码';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.update_date is '更新日期';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_cash_balance_detail.etl_timestamp is 'ETL处理时间戳';
