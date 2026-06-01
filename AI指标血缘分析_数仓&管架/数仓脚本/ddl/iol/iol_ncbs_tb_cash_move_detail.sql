/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_cash_move_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_cash_move_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_cash_move_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_move_detail(
    ccy varchar2(3) -- 币种
    ,cash_num number(10) -- 现金数量
    ,company varchar2(20) -- 法人
    ,is_spall varchar2(1) -- 是否残损币
    ,move_id varchar2(30) -- 调拨转移id
    ,par_value_id varchar2(20) -- 券别代码
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_amt number(17,2) -- 交易金额
    ,move_detail_id varchar2(50) -- 转移明细编号
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
grant select on ${iol_schema}.ncbs_tb_cash_move_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_cash_move_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_move_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_move_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_cash_move_detail is '现金转移明细表';
comment on column ${iol_schema}.ncbs_tb_cash_move_detail.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_cash_move_detail.cash_num is '现金数量';
comment on column ${iol_schema}.ncbs_tb_cash_move_detail.company is '法人';
comment on column ${iol_schema}.ncbs_tb_cash_move_detail.is_spall is '是否残损币';
comment on column ${iol_schema}.ncbs_tb_cash_move_detail.move_id is '调拨转移id';
comment on column ${iol_schema}.ncbs_tb_cash_move_detail.par_value_id is '券别代码';
comment on column ${iol_schema}.ncbs_tb_cash_move_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_cash_move_detail.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_tb_cash_move_detail.move_detail_id is '转移明细编号';
comment on column ${iol_schema}.ncbs_tb_cash_move_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_cash_move_detail.etl_timestamp is 'ETL处理时间戳';
