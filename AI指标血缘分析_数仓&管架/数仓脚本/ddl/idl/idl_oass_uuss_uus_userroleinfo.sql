/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_uuss_uus_userroleinfo
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_uuss_uus_userroleinfo purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_uuss_uus_userroleinfo(
etl_dt date --数据日期
,unitno varchar2(8) --商户
,subunitno varchar2(8) --子商户
,rolecode varchar2(32) --角色代码
,rolename varchar2(100) --角色名称
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,domainid varchar2(16) --域账号
,sysid varchar2(6) --系统标识

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_uuss_uus_userroleinfo to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_uuss_uus_userroleinfo is '用户角色信息表';
comment on column ${idl_schema}.oass_uuss_uus_userroleinfo.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_uuss_uus_userroleinfo.unitno is '商户';
comment on column ${idl_schema}.oass_uuss_uus_userroleinfo.subunitno is '子商户';
comment on column ${idl_schema}.oass_uuss_uus_userroleinfo.rolecode is '角色代码';
comment on column ${idl_schema}.oass_uuss_uus_userroleinfo.rolename is '角色名称';
comment on column ${idl_schema}.oass_uuss_uus_userroleinfo.start_dt is '开始时间';
comment on column ${idl_schema}.oass_uuss_uus_userroleinfo.end_dt is '结束时间';
comment on column ${idl_schema}.oass_uuss_uus_userroleinfo.id_mark is '增删标志';
comment on column ${idl_schema}.oass_uuss_uus_userroleinfo.domainid is '域账号';
comment on column ${idl_schema}.oass_uuss_uus_userroleinfo.sysid is '系统标识';

