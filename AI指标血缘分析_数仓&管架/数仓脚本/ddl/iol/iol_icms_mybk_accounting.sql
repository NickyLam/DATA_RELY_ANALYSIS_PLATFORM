/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_accounting
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_accounting
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_accounting purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_accounting(
    bsntype varchar2(64) -- 产品业务类型
    ,accountingtype varchar2(80) -- 字段名称
    ,accountingamt varchar2(32) -- 字段值
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
grant select on ${iol_schema}.icms_mybk_accounting to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_accounting to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_accounting to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_accounting to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_accounting is '网商贷汇总记账文件';
comment on column ${iol_schema}.icms_mybk_accounting.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_accounting.accountingtype is '字段名称';
comment on column ${iol_schema}.icms_mybk_accounting.accountingamt is '字段值';
comment on column ${iol_schema}.icms_mybk_accounting.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybk_accounting.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybk_accounting.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybk_accounting.etl_timestamp is 'ETL处理时间戳';
