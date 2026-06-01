/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_tbst_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_tbst_detl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_tbst_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_tbst_detl(
    stacid number(19) -- 账套
    ,tablcd varchar2(30) -- 表代码
    ,busitp varchar2(20) -- 业务类型
    ,sortno number -- 序号
    ,tablcl varchar2(30) -- 表字段代码
    ,coluna varchar2(255) -- 表字段名称
    ,colutp varchar2(1) -- 表字段类型
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
grant select on ${iol_schema}.tgls_amc_tbst_detl to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_tbst_detl to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_tbst_detl to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_tbst_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_tbst_detl is '会计计量涉及表定义明细表';
comment on column ${iol_schema}.tgls_amc_tbst_detl.stacid is '账套';
comment on column ${iol_schema}.tgls_amc_tbst_detl.tablcd is '表代码';
comment on column ${iol_schema}.tgls_amc_tbst_detl.busitp is '业务类型';
comment on column ${iol_schema}.tgls_amc_tbst_detl.sortno is '序号';
comment on column ${iol_schema}.tgls_amc_tbst_detl.tablcl is '表字段代码';
comment on column ${iol_schema}.tgls_amc_tbst_detl.coluna is '表字段名称';
comment on column ${iol_schema}.tgls_amc_tbst_detl.colutp is '表字段类型';
comment on column ${iol_schema}.tgls_amc_tbst_detl.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_tbst_detl.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_tbst_detl.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_tbst_detl.etl_timestamp is 'ETL处理时间戳';
