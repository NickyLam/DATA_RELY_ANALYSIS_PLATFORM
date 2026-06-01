/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_ftp_spread_maintenance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance(
    id number(22,0) -- 
    ,status varchar2(2) -- 状态0-未生效1-已生效
    ,is_current varchar2(2) -- 是否活期业务
    ,trade_id varchar2(150) -- 交易id
    ,i_code varchar2(96) -- 金融工具代码
    ,current_account varchar2(96) -- 活期账户
    ,new_spread number(12,6) -- 新点差
    ,update_user varchar2(96) -- 
    ,effect_time varchar2(29) -- 
    ,update_user_id number(22,0) -- 
    ,origin_spread number(12,6) -- 原点差
    ,a_type varchar2(48) -- 
    ,m_type varchar2(48) -- 
    ,accid varchar2(45) -- 投组id
    ,accountname varchar2(192) -- 投组名称
    ,i_name varchar2(192) -- 
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
grant select on ${iol_schema}.ibms_ttrd_ftp_spread_maintenance to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_spread_maintenance to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_spread_maintenance to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_ftp_spread_maintenance to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance is 'FTP点差修正相关信息';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.id is '';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.status is '状态0-未生效1-已生效';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.is_current is '是否活期业务';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.trade_id is '交易id';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.current_account is '活期账户';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.new_spread is '新点差';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.update_user is '';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.effect_time is '';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.update_user_id is '';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.origin_spread is '原点差';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.a_type is '';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.m_type is '';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.accid is '投组id';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.accountname is '投组名称';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.i_name is '';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_ftp_spread_maintenance.etl_timestamp is 'ETL处理时间戳';
