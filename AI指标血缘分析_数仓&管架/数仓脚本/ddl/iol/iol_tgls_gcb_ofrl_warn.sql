/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_gcb_ofrl_warn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_gcb_ofrl_warn
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_gcb_ofrl_warn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gcb_ofrl_warn(
    combdt varchar2(8) -- 合并报表日期
    ,ofrlcd varchar2(32) -- 抵消代码
    ,ofrlno number -- 序号
    ,remark varchar2(255) -- 异常说明
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
grant select on ${iol_schema}.tgls_gcb_ofrl_warn to ${iml_schema};
grant select on ${iol_schema}.tgls_gcb_ofrl_warn to ${icl_schema};
grant select on ${iol_schema}.tgls_gcb_ofrl_warn to ${idl_schema};
grant select on ${iol_schema}.tgls_gcb_ofrl_warn to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_gcb_ofrl_warn is '自动抵消异常登记簿';
comment on column ${iol_schema}.tgls_gcb_ofrl_warn.combdt is '合并报表日期';
comment on column ${iol_schema}.tgls_gcb_ofrl_warn.ofrlcd is '抵消代码';
comment on column ${iol_schema}.tgls_gcb_ofrl_warn.ofrlno is '序号';
comment on column ${iol_schema}.tgls_gcb_ofrl_warn.remark is '异常说明';
comment on column ${iol_schema}.tgls_gcb_ofrl_warn.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_gcb_ofrl_warn.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_gcb_ofrl_warn.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_gcb_ofrl_warn.etl_timestamp is 'ETL处理时间戳';
