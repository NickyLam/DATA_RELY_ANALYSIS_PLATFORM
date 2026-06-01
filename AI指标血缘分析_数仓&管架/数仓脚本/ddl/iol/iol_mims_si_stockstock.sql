/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_stockstock
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_stockstock
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_stockstock purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_stockstock(
    sccode varchar2(48) -- 押品编号
    ,financingamount number(16,2) -- 平仓融资金额
    ,repaymenttime varchar2(15) -- 还款时间
    ,closingamount number(16,2) -- 平仓押品金额
    ,closingtime varchar2(15) -- 平仓时间
    ,closingstock varchar2(2) -- 是否在报告期内平仓股票        0 否、1 是
    ,closingprice number(16,2) -- 每股平仓平均价格
    ,credno varchar2(60) -- 借据号
    ,reportperiod varchar2(9) -- 报告期季度
    ,reportperiodyear varchar2(30) -- 报告期起始年份
    ,reportperiodclosing varchar2(2) -- 报告期内是否发生平仓        0 否、1 是
    ,guartype varchar2(14) -- 押品类型编号
    ,isdeal varchar2(2) -- 是否场内交易
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
grant select on ${iol_schema}.mims_si_stockstock to ${iml_schema};
grant select on ${iol_schema}.mims_si_stockstock to ${icl_schema};
grant select on ${iol_schema}.mims_si_stockstock to ${idl_schema};
grant select on ${iol_schema}.mims_si_stockstock to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_stockstock is '上市公司股权';
comment on column ${iol_schema}.mims_si_stockstock.sccode is '押品编号';
comment on column ${iol_schema}.mims_si_stockstock.financingamount is '平仓融资金额';
comment on column ${iol_schema}.mims_si_stockstock.repaymenttime is '还款时间';
comment on column ${iol_schema}.mims_si_stockstock.closingamount is '平仓押品金额';
comment on column ${iol_schema}.mims_si_stockstock.closingtime is '平仓时间';
comment on column ${iol_schema}.mims_si_stockstock.closingstock is '是否在报告期内平仓股票        0 否、1 是';
comment on column ${iol_schema}.mims_si_stockstock.closingprice is '每股平仓平均价格';
comment on column ${iol_schema}.mims_si_stockstock.credno is '借据号';
comment on column ${iol_schema}.mims_si_stockstock.reportperiod is '报告期季度';
comment on column ${iol_schema}.mims_si_stockstock.reportperiodyear is '报告期起始年份';
comment on column ${iol_schema}.mims_si_stockstock.reportperiodclosing is '报告期内是否发生平仓        0 否、1 是';
comment on column ${iol_schema}.mims_si_stockstock.guartype is '押品类型编号';
comment on column ${iol_schema}.mims_si_stockstock.isdeal is '是否场内交易';
comment on column ${iol_schema}.mims_si_stockstock.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_stockstock.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_stockstock.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_stockstock.etl_timestamp is 'ETL处理时间戳';
