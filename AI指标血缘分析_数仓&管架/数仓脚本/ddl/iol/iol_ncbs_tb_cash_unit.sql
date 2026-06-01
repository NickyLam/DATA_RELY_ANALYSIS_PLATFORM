/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_cash_unit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_cash_unit
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_cash_unit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_cash_unit(
    company varchar2(20) -- 法人
    ,par_value_id varchar2(20) -- 券别代码
    ,unit_sum_b number(5) -- 每把张数
    ,unit_sum_k number(5) -- 每捆张数
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_tb_cash_unit to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_cash_unit to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_unit to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_cash_unit to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_cash_unit is '现金预约汇总统计单元表';
comment on column ${iol_schema}.ncbs_tb_cash_unit.company is '法人';
comment on column ${iol_schema}.ncbs_tb_cash_unit.par_value_id is '券别代码';
comment on column ${iol_schema}.ncbs_tb_cash_unit.unit_sum_b is '每把张数';
comment on column ${iol_schema}.ncbs_tb_cash_unit.unit_sum_k is '每捆张数';
comment on column ${iol_schema}.ncbs_tb_cash_unit.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_cash_unit.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_cash_unit.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_cash_unit.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_cash_unit.etl_timestamp is 'ETL处理时间戳';
