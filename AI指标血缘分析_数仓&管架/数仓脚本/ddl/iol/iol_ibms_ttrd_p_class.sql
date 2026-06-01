/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_p_class
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_p_class
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_p_class purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_p_class(
    id number(22) -- 产品类型id
    ,a_type varchar2(30) -- 资产类型
    ,p_class varchar2(150) -- 产品分类
    ,p_type varchar2(30) -- 产品类型
    ,p_type_name varchar2(150) -- 产品类型名称
    ,in_sys_process number(22) -- 系统流程
    ,trdtype varchar2(15) -- 业务种类
    ,acting_type varchar2(45) -- 会计分类
    ,p_class_code varchar2(75) -- 产品分类码值
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
grant select on ${iol_schema}.ibms_ttrd_p_class to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_p_class to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_p_class to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_p_class to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_p_class is '产品分类表（资产类型细分）';
comment on column ${iol_schema}.ibms_ttrd_p_class.id is '产品类型id';
comment on column ${iol_schema}.ibms_ttrd_p_class.a_type is '资产类型';
comment on column ${iol_schema}.ibms_ttrd_p_class.p_class is '产品分类';
comment on column ${iol_schema}.ibms_ttrd_p_class.p_type is '产品类型';
comment on column ${iol_schema}.ibms_ttrd_p_class.p_type_name is '产品类型名称';
comment on column ${iol_schema}.ibms_ttrd_p_class.in_sys_process is '系统流程';
comment on column ${iol_schema}.ibms_ttrd_p_class.trdtype is '业务种类';
comment on column ${iol_schema}.ibms_ttrd_p_class.acting_type is '会计分类';
comment on column ${iol_schema}.ibms_ttrd_p_class.p_class_code is '产品分类码值';
comment on column ${iol_schema}.ibms_ttrd_p_class.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_p_class.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_p_class.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_p_class.etl_timestamp is 'ETL处理时间戳';
