/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_uuss_afa_comminfo
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_uuss_afa_comminfo purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_uuss_afa_comminfo(
etl_dt date --数据日期
,itemname varchar2(20) --通讯配置项名称
,serverip varchar2(20) --服务器IP
,serverport varchar2(5) --服务器端口
,conntimeout varchar2(5) --连接超时
,transtimeout varchar2(5) --传输超时
,encoding varchar2(10) --编码
,remark varchar2(80) --备注
,status varchar2(1) --配置状态 0:正常 1:失效
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,sendersysid varchar2(6) --发起方系统标识
,recversysid varchar2(6) --接收方系统标识

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_uuss_afa_comminfo to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_uuss_afa_comminfo is '通讯信息表';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.itemname is '通讯配置项名称';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.serverip is '服务器IP';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.serverport is '服务器端口';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.conntimeout is '连接超时';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.transtimeout is '传输超时';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.encoding is '编码';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.remark is '备注';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.status is '配置状态 0:正常 1:失效';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.start_dt is '开始时间';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.end_dt is '结束时间';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.id_mark is '增删标志';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.sendersysid is '发起方系统标识';
comment on column ${idl_schema}.oass_uuss_afa_comminfo.recversysid is '接收方系统标识';

