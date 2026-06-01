/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondratingdefinition
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondratingdefinition
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondratingdefinition purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondratingdefinition(
    object_id varchar2(57) -- 对象ID
    ,b_info_creditratingagency varchar2(15) -- 评估机构代码
    ,b_info_creditrating_name varchar2(150) -- 评估机构名称
    ,s_info_compcode varchar2(15) -- 公司ID
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
grant select on ${iol_schema}.wind_cbondratingdefinition to ${iml_schema};
grant select on ${iol_schema}.wind_cbondratingdefinition to ${icl_schema};
grant select on ${iol_schema}.wind_cbondratingdefinition to ${idl_schema};
grant select on ${iol_schema}.wind_cbondratingdefinition to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondratingdefinition is '债券信用评估机构';
comment on column ${iol_schema}.wind_cbondratingdefinition.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondratingdefinition.b_info_creditratingagency is '评估机构代码';
comment on column ${iol_schema}.wind_cbondratingdefinition.b_info_creditrating_name is '评估机构名称';
comment on column ${iol_schema}.wind_cbondratingdefinition.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_cbondratingdefinition.start_dt is '开始时间';
comment on column ${iol_schema}.wind_cbondratingdefinition.end_dt is '结束时间';
comment on column ${iol_schema}.wind_cbondratingdefinition.id_mark is '增删标志';
comment on column ${iol_schema}.wind_cbondratingdefinition.etl_timestamp is 'ETL处理时间戳';
