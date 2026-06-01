/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_cash_move_total
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_cash_move_total
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_cash_move_total purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_move_total(
    ccy varchar2(3) -- 币种
    ,company varchar2(20) -- 法人
    ,is_spall varchar2(1) -- 是否残损币
    ,move_id varchar2(30) -- 调拨转移id
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,total_amount number(17,2) -- 汇总金额
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
grant select on ${iol_schema}.ncbs_tb_cash_move_total to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_cash_move_total to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_move_total to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_move_total to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_cash_move_total is '现金调拨汇总表';
comment on column ${iol_schema}.ncbs_tb_cash_move_total.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_cash_move_total.company is '法人';
comment on column ${iol_schema}.ncbs_tb_cash_move_total.is_spall is '是否残损币';
comment on column ${iol_schema}.ncbs_tb_cash_move_total.move_id is '调拨转移id';
comment on column ${iol_schema}.ncbs_tb_cash_move_total.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_cash_move_total.total_amount is '汇总金额';
comment on column ${iol_schema}.ncbs_tb_cash_move_total.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_cash_move_total.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_cash_move_total.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_cash_move_total.etl_timestamp is 'ETL处理时间戳';
