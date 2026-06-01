/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ncts_ab_auth_taskpooltrade
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade(
    authorgno varchar2(10) -- 授权机构
    ,taskpoolid varchar2(10) -- 任务池编号
    ,channelcode varchar2(3) -- 渠道码
    ,tradecode varchar2(100) -- 交易码
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade is '任务池与交易关系';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade.authorgno is '授权机构';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade.taskpoolid is '任务池编号';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade.channelcode is '渠道码';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade.tradecode is '交易码';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_ncts_ab_auth_taskpooltrade.etl_timestamp is 'ETL处理时间戳';