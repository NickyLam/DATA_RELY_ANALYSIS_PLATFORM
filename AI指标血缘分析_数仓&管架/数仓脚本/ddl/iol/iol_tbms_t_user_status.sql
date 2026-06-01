/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbms_t_user_status
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbms_t_user_status
whenever sqlerror continue none;
drop table ${iol_schema}.tbms_t_user_status purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_user_status(
    uaid number(20) -- 用户ID
    ,userphone varchar2(96) -- 手机号
    ,mstpid varchar2(96) -- 通讯ID
    ,userstatus number(4) -- 手机状态,1未注册,2已注册, 3已锁定
    ,yqtid varchar2(96) -- 银企通Id
    ,sys_ctime date -- 系统-创建时间
    ,sys_utime date -- 系统-修改时间
    ,sys_valid number(4) -- 系统-有效状态
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
grant select on ${iol_schema}.tbms_t_user_status to ${iml_schema};
grant select on ${iol_schema}.tbms_t_user_status to ${icl_schema};
grant select on ${iol_schema}.tbms_t_user_status to ${idl_schema};
grant select on ${iol_schema}.tbms_t_user_status to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbms_t_user_status is '用户状态';
comment on column ${iol_schema}.tbms_t_user_status.uaid is '用户ID';
comment on column ${iol_schema}.tbms_t_user_status.userphone is '手机号';
comment on column ${iol_schema}.tbms_t_user_status.mstpid is '通讯ID';
comment on column ${iol_schema}.tbms_t_user_status.userstatus is '手机状态,1未注册,2已注册, 3已锁定';
comment on column ${iol_schema}.tbms_t_user_status.yqtid is '银企通Id';
comment on column ${iol_schema}.tbms_t_user_status.sys_ctime is '系统-创建时间';
comment on column ${iol_schema}.tbms_t_user_status.sys_utime is '系统-修改时间';
comment on column ${iol_schema}.tbms_t_user_status.sys_valid is '系统-有效状态';
comment on column ${iol_schema}.tbms_t_user_status.start_dt is '开始时间';
comment on column ${iol_schema}.tbms_t_user_status.end_dt is '结束时间';
comment on column ${iol_schema}.tbms_t_user_status.id_mark is '增删标志';
comment on column ${iol_schema}.tbms_t_user_status.etl_timestamp is 'ETL处理时间戳';
