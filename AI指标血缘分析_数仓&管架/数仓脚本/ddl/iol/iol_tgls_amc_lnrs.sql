/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_lnrs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_lnrs
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_lnrs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_lnrs(
    stacid number(19) -- 账套
    ,levetp varchar2(2) -- 贷款五级分类
    ,puprtg varchar2(2) -- 对公/对私
    ,lossrt number(20,2) -- 损失率
    ,devatg varchar2(1) -- 减值标识
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
grant select on ${iol_schema}.tgls_amc_lnrs to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_lnrs to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_lnrs to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_lnrs to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_lnrs is '贷款五级风险信息表';
comment on column ${iol_schema}.tgls_amc_lnrs.stacid is '账套';
comment on column ${iol_schema}.tgls_amc_lnrs.levetp is '贷款五级分类';
comment on column ${iol_schema}.tgls_amc_lnrs.puprtg is '对公/对私';
comment on column ${iol_schema}.tgls_amc_lnrs.lossrt is '损失率';
comment on column ${iol_schema}.tgls_amc_lnrs.devatg is '减值标识';
comment on column ${iol_schema}.tgls_amc_lnrs.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_lnrs.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_lnrs.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_lnrs.etl_timestamp is 'ETL处理时间戳';
