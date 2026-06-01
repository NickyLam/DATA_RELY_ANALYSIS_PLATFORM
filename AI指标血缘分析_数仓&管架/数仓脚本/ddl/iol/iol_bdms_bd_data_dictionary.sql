/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bd_data_dictionary
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bd_data_dictionary
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bd_data_dictionary purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bd_data_dictionary(
    id varchar2(45) -- 主键
    ,sys_code varchar2(75) -- 系统编码
    ,sys_name varchar2(75) -- 系统名称
    ,team_code varchar2(75) -- 预留字段
    ,team_name varchar2(75) -- 预留字段
    ,dict_code varchar2(75) -- 字典编号
    ,dict_name varchar2(75) -- 编号名称
    ,data_val varchar2(150) -- 值
    ,data_trs_val varchar2(450) -- 英文值
    ,description varchar2(300) -- 描述
    ,orderby number(22) -- 排序
    ,version_num number(22) -- 版本号
    ,is_del number(22) -- 是否已删除
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
grant select on ${iol_schema}.bdms_bd_data_dictionary to ${iml_schema};
grant select on ${iol_schema}.bdms_bd_data_dictionary to ${icl_schema};
grant select on ${iol_schema}.bdms_bd_data_dictionary to ${idl_schema};
grant select on ${iol_schema}.bdms_bd_data_dictionary to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bd_data_dictionary is '字典表';
comment on column ${iol_schema}.bdms_bd_data_dictionary.id is '主键';
comment on column ${iol_schema}.bdms_bd_data_dictionary.sys_code is '系统编码';
comment on column ${iol_schema}.bdms_bd_data_dictionary.sys_name is '系统名称';
comment on column ${iol_schema}.bdms_bd_data_dictionary.team_code is '预留字段';
comment on column ${iol_schema}.bdms_bd_data_dictionary.team_name is '预留字段';
comment on column ${iol_schema}.bdms_bd_data_dictionary.dict_code is '字典编号';
comment on column ${iol_schema}.bdms_bd_data_dictionary.dict_name is '编号名称';
comment on column ${iol_schema}.bdms_bd_data_dictionary.data_val is '值';
comment on column ${iol_schema}.bdms_bd_data_dictionary.data_trs_val is '英文值';
comment on column ${iol_schema}.bdms_bd_data_dictionary.description is '描述';
comment on column ${iol_schema}.bdms_bd_data_dictionary.orderby is '排序';
comment on column ${iol_schema}.bdms_bd_data_dictionary.version_num is '版本号';
comment on column ${iol_schema}.bdms_bd_data_dictionary.is_del is '是否已删除';
comment on column ${iol_schema}.bdms_bd_data_dictionary.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bd_data_dictionary.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bd_data_dictionary.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bd_data_dictionary.etl_timestamp is 'ETL处理时间戳';
