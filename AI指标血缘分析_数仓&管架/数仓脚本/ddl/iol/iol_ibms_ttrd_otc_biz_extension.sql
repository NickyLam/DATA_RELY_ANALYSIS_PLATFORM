/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_otc_biz_extension
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_otc_biz_extension
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_otc_biz_extension purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_otc_biz_extension(
    biz_id varchar2(150) -- 扩展信息实体主键
    ,biz_tablename varchar2(75) -- 扩展信息表名
    ,columns_ext varchar2(4000) -- 扩展信息值
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
grant select on ${iol_schema}.ibms_ttrd_otc_biz_extension to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_biz_extension to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_biz_extension to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_biz_extension to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_otc_biz_extension is '扩展信息表';
comment on column ${iol_schema}.ibms_ttrd_otc_biz_extension.biz_id is '扩展信息实体主键';
comment on column ${iol_schema}.ibms_ttrd_otc_biz_extension.biz_tablename is '扩展信息表名';
comment on column ${iol_schema}.ibms_ttrd_otc_biz_extension.columns_ext is '扩展信息值';
comment on column ${iol_schema}.ibms_ttrd_otc_biz_extension.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_otc_biz_extension.etl_timestamp is 'ETL处理时间戳';
