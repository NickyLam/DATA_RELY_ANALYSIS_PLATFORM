/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_sys_datadict
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_sys_datadict
whenever sqlerror continue none;
drop table ${iol_schema}.fams_sys_datadict purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_sys_datadict(
    dict_code varchar2(50) -- 字典代码
    ,system_code varchar2(50) -- 系统代码
    ,dict_cnname varchar2(200) -- 字典中文名称
    ,dict_enname varchar2(200) -- 字典英文名称
    ,update_flg varchar2(50) -- 用户可更改标识
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_sys_datadict to ${iml_schema};
grant select on ${iol_schema}.fams_sys_datadict to ${icl_schema};
grant select on ${iol_schema}.fams_sys_datadict to ${idl_schema};
grant select on ${iol_schema}.fams_sys_datadict to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_sys_datadict is '数据字典';
comment on column ${iol_schema}.fams_sys_datadict.dict_code is '字典代码';
comment on column ${iol_schema}.fams_sys_datadict.system_code is '系统代码';
comment on column ${iol_schema}.fams_sys_datadict.dict_cnname is '字典中文名称';
comment on column ${iol_schema}.fams_sys_datadict.dict_enname is '字典英文名称';
comment on column ${iol_schema}.fams_sys_datadict.update_flg is '用户可更改标识';
comment on column ${iol_schema}.fams_sys_datadict.create_user is '创建人';
comment on column ${iol_schema}.fams_sys_datadict.create_dept is '创建部门';
comment on column ${iol_schema}.fams_sys_datadict.create_time is '创建时间';
comment on column ${iol_schema}.fams_sys_datadict.update_user is '更新人';
comment on column ${iol_schema}.fams_sys_datadict.update_time is '更新时间';
comment on column ${iol_schema}.fams_sys_datadict.start_dt is '开始时间';
comment on column ${iol_schema}.fams_sys_datadict.end_dt is '结束时间';
comment on column ${iol_schema}.fams_sys_datadict.id_mark is '增删标志';
comment on column ${iol_schema}.fams_sys_datadict.etl_timestamp is 'ETL处理时间戳';
