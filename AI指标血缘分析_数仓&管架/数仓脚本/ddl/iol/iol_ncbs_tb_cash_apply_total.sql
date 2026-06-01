/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_cash_apply_total
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_cash_apply_total
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_cash_apply_total purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_apply_total(
    apply_id varchar2(50) -- 申请预约编号
    ,company varchar2(20) -- 法人
    ,is_spall varchar2(1) -- 是否残损币
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,apply_ccy varchar2(3) -- 预约币种
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
grant select on ${iol_schema}.ncbs_tb_cash_apply_total to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_cash_apply_total to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_apply_total to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_apply_total to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_cash_apply_total is '现金预约汇总表';
comment on column ${iol_schema}.ncbs_tb_cash_apply_total.apply_id is '申请预约编号';
comment on column ${iol_schema}.ncbs_tb_cash_apply_total.company is '法人';
comment on column ${iol_schema}.ncbs_tb_cash_apply_total.is_spall is '是否残损币';
comment on column ${iol_schema}.ncbs_tb_cash_apply_total.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_cash_apply_total.apply_ccy is '预约币种';
comment on column ${iol_schema}.ncbs_tb_cash_apply_total.total_amount is '汇总金额';
comment on column ${iol_schema}.ncbs_tb_cash_apply_total.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_cash_apply_total.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_cash_apply_total.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_cash_apply_total.etl_timestamp is 'ETL处理时间戳';
