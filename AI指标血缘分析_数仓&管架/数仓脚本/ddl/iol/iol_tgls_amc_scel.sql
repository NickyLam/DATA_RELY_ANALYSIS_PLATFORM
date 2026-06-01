/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_scel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_scel
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_scel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_scel(
    stacid number(19) -- 账套
    ,elemcd varchar2(20) -- 要素编号
    ,elemna varchar2(100) -- 要素名称
    ,busitp varchar2(20) -- 业务类型
    ,elemtp varchar2(1) -- 要素类型
    ,status varchar2(1) -- 是否启用
    ,usedtp varchar2(1) -- 使用状态
    ,tablna varchar2(20) -- 涉及表名
    ,tablcl varchar2(100) -- 涉及表列名
    ,attrst varchar2(1) -- 是否需要维护要素含义的段值,0-否，1-是
    ,desctx varchar2(255) -- 说明
    ,sortno number(10) -- 排序
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
grant select on ${iol_schema}.tgls_amc_scel to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_scel to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_scel to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_scel to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_scel is '来源系统要素定义';
comment on column ${iol_schema}.tgls_amc_scel.stacid is '账套';
comment on column ${iol_schema}.tgls_amc_scel.elemcd is '要素编号';
comment on column ${iol_schema}.tgls_amc_scel.elemna is '要素名称';
comment on column ${iol_schema}.tgls_amc_scel.busitp is '业务类型';
comment on column ${iol_schema}.tgls_amc_scel.elemtp is '要素类型';
comment on column ${iol_schema}.tgls_amc_scel.status is '是否启用';
comment on column ${iol_schema}.tgls_amc_scel.usedtp is '使用状态';
comment on column ${iol_schema}.tgls_amc_scel.tablna is '涉及表名';
comment on column ${iol_schema}.tgls_amc_scel.tablcl is '涉及表列名';
comment on column ${iol_schema}.tgls_amc_scel.attrst is '是否需要维护要素含义的段值,0-否，1-是';
comment on column ${iol_schema}.tgls_amc_scel.desctx is '说明';
comment on column ${iol_schema}.tgls_amc_scel.sortno is '排序';
comment on column ${iol_schema}.tgls_amc_scel.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_scel.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_scel.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_scel.etl_timestamp is 'ETL处理时间戳';
