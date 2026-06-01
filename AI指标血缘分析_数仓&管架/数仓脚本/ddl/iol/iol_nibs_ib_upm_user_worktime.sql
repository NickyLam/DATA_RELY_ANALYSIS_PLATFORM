/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_upm_user_worktime
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_upm_user_worktime
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_upm_user_worktime purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_upm_user_worktime(
    usernum varchar2(8) -- 柜员号
    ,branchnum varchar2(10) -- 机构号
    ,logindatestr varchar2(8) -- 登入日期 yyyymmdd
    ,logintime date -- 登入时间 yyyymmdd hhmmss
    ,logouttime date -- 登出时间 yyyymmdd hhmmss
    ,totaltimesecond varchar2(10) -- 总时长 秒
    ,trantimesecond varchar2(10) -- 交易时长 秒
    ,leveltimesecond varchar2(10) -- 离柜时长 秒
    ,onlineleisuresecond varchar2(10) -- 在线空闲时长 秒
    ,singoutfalg varchar2(2) -- 是否进行进行了日终签退 0-否 1-是
    ,userstatus varchar2(5) -- 柜员在登陆状态|o-在线 l-离线
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
grant select on ${iol_schema}.nibs_ib_upm_user_worktime to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_upm_user_worktime to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_upm_user_worktime to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_upm_user_worktime to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_upm_user_worktime is '柜员工作时长统计';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.usernum is '柜员号';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.branchnum is '机构号';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.logindatestr is '登入日期 yyyymmdd';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.logintime is '登入时间 yyyymmdd hhmmss';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.logouttime is '登出时间 yyyymmdd hhmmss';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.totaltimesecond is '总时长 秒';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.trantimesecond is '交易时长 秒';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.leveltimesecond is '离柜时长 秒';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.onlineleisuresecond is '在线空闲时长 秒';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.singoutfalg is '是否进行进行了日终签退 0-否 1-是';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.userstatus is '柜员在登陆状态|o-在线 l-离线';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.start_dt is '开始时间';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.end_dt is '结束时间';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.id_mark is '增删标志';
comment on column ${iol_schema}.nibs_ib_upm_user_worktime.etl_timestamp is 'ETL处理时间戳';
