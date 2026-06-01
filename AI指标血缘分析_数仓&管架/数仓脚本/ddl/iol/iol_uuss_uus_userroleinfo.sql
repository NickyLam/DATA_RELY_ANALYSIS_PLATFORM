/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uuss_uus_userroleinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uuss_uus_userroleinfo
whenever sqlerror continue none;
drop table ${iol_schema}.uuss_uus_userroleinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_uus_userroleinfo(
    domainid varchar2(24) -- 域账号
    ,sysid varchar2(9) -- 系统标识
    ,unitno varchar2(12) -- 商户
    ,subunitno varchar2(12) -- 子商户
    ,rolecode varchar2(48) -- 角色代码
    ,rolename varchar2(150) -- 角色名称
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
grant select on ${iol_schema}.uuss_uus_userroleinfo to ${iml_schema};
grant select on ${iol_schema}.uuss_uus_userroleinfo to ${icl_schema};
grant select on ${iol_schema}.uuss_uus_userroleinfo to ${idl_schema};
grant select on ${iol_schema}.uuss_uus_userroleinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.uuss_uus_userroleinfo is '用户角色信息表';
comment on column ${iol_schema}.uuss_uus_userroleinfo.domainid is '域账号';
comment on column ${iol_schema}.uuss_uus_userroleinfo.sysid is '系统标识';
comment on column ${iol_schema}.uuss_uus_userroleinfo.unitno is '商户';
comment on column ${iol_schema}.uuss_uus_userroleinfo.subunitno is '子商户';
comment on column ${iol_schema}.uuss_uus_userroleinfo.rolecode is '角色代码';
comment on column ${iol_schema}.uuss_uus_userroleinfo.rolename is '角色名称';
comment on column ${iol_schema}.uuss_uus_userroleinfo.start_dt is '开始时间';
comment on column ${iol_schema}.uuss_uus_userroleinfo.end_dt is '结束时间';
comment on column ${iol_schema}.uuss_uus_userroleinfo.id_mark is '增删标志';
comment on column ${iol_schema}.uuss_uus_userroleinfo.etl_timestamp is 'ETL处理时间戳';
