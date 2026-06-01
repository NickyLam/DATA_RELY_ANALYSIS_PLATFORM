/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbprdparamvalue
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbprdparamvalue
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbprdparamvalue purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbprdparamvalue(
    table_name varchar2(48) -- 
    ,prd_code varchar2(32) -- 
    ,field_code varchar2(48) -- 
    ,field_value varchar2(2000) -- 
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
grant select on ${iol_schema}.nfss_tbprdparamvalue to ${iml_schema};
grant select on ${iol_schema}.nfss_tbprdparamvalue to ${icl_schema};
grant select on ${iol_schema}.nfss_tbprdparamvalue to ${idl_schema};
grant select on ${iol_schema}.nfss_tbprdparamvalue to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbprdparamvalue is '产品参数值表';
comment on column ${iol_schema}.nfss_tbprdparamvalue.table_name is '';
comment on column ${iol_schema}.nfss_tbprdparamvalue.prd_code is '';
comment on column ${iol_schema}.nfss_tbprdparamvalue.field_code is '';
comment on column ${iol_schema}.nfss_tbprdparamvalue.field_value is '';
comment on column ${iol_schema}.nfss_tbprdparamvalue.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbprdparamvalue.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbprdparamvalue.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbprdparamvalue.etl_timestamp is 'ETL处理时间戳';
