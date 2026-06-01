/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_basis_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_basis_rate
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_basis_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_basis_rate(
    ccy varchar2(3) -- 币种
    ,company varchar2(20) -- 法人
    ,int_basis varchar2(5) -- 基准利率类型
    ,effect_date date -- 产品生效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,int_basis_rate number(15,8) -- 基准利率
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
grant select on ${iol_schema}.ncbs_mb_basis_rate to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_basis_rate to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_basis_rate to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_basis_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_basis_rate is '基准利率信息表';
comment on column ${iol_schema}.ncbs_mb_basis_rate.ccy is '币种';
comment on column ${iol_schema}.ncbs_mb_basis_rate.company is '法人';
comment on column ${iol_schema}.ncbs_mb_basis_rate.int_basis is '基准利率类型';
comment on column ${iol_schema}.ncbs_mb_basis_rate.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_mb_basis_rate.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_basis_rate.int_basis_rate is '基准利率';
comment on column ${iol_schema}.ncbs_mb_basis_rate.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_basis_rate.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_basis_rate.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_basis_rate.etl_timestamp is 'ETL处理时间戳';
