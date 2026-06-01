/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_ncts_ab_auth_taskpooldata
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata(
    ETL_DT DATE
    ,AUTHDATE VARCHAR2(8)
    ,AUTHSERNO VARCHAR2(30)
    ,AUTHORGNO VARCHAR2(10)
    ,TASKPOOLID VARCHAR2(10)
    ,AUTHLEVEL VARCHAR2(2)
    ,ENTRYTIME VARCHAR2(6)
    ,OUTTIME VARCHAR2(6)
    ,WAITTIME NUMBER(22,0)
    ,STATUS VARCHAR2(2)
    ,AUTHTELLERNO VARCHAR2(50)
    ,WEIGHT NUMBER(2,0)
    ,ABOID VARCHAR2(150)
    ,TRADEID VARCHAR2(150)
    ,TRADESERNO VARCHAR2(24)
    ,FLAG VARCHAR2(1)
    ,QUEUENUM VARCHAR2(5)
    ,TRADEMODE VARCHAR2(1)
    ,CARTORDER NUMBER(3,0)
    ,MAKEUPSN VARCHAR2(32)
    ,TIMES NUMBER(3,0)
    ,REPLENISH_STATUS VARCHAR2(1)
    ,BJ_TELLERNO VARCHAR2(50)
    ,FQBJ_TELLERNO VARCHAR2(50)
    ,BJ_AUTHTELLERNO VARCHAR2(50)
    ,FQBJ_DATE VARCHAR2(8)
    ,FQBJ_TIME VARCHAR2(6)
    ,BJ_AUTHDATE VARCHAR2(8)
    ,BJ_AUTHTIME VARCHAR2(6)
    ,BJ_SUCCESSTIME VARCHAR2(6)
    ,BJ_LASTOPTDATE VARCHAR2(8)
    ,REPLENISHFLAG VARCHAR2(1)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata is '授权任务池数据';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.AUTHDATE is '授权日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.AUTHSERNO is '授权流水';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.AUTHORGNO is '授权机构';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.TASKPOOLID is '任务池';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.AUTHLEVEL is '授权级别';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.ENTRYTIME is '进入任务池时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.OUTTIME is '取出任务池时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.WAITTIME is '任务排队时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.STATUS is '任务状态;0,未获取;1,获取';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.AUTHTELLERNO is '授权柜员';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.WEIGHT is '权重值';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.ABOID is '客户端ID';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.TRADEID is '交易ID';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.TRADESERNO is '交易流水号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.FLAG is '详细任务标志：0-退件；1-拒绝;2-后补件退件';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.QUEUENUM is '';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.TRADEMODE is '交易模式（1-单交易模式，2-交易包模式）';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.CARTORDER is '购物车授权任务顺序，从1开始';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.MAKEUPSN is '购物车组合流水';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.TIMES is '提交购物车批次数（跟购物车组合流水一起，唯一标示每一批购物车交易）';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.REPLENISH_STATUS is '补件状态';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.BJ_TELLERNO is '补件人员';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.FQBJ_TELLERNO is '发起后补件人员';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.BJ_AUTHTELLERNO is '后补件授权柜员';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.FQBJ_DATE is '发起补件日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.FQBJ_TIME is '发起补件时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.BJ_AUTHDATE is '补件授权日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.BJ_AUTHTIME is '补件授权时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.BJ_SUCCESSTIME is '补件成功时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.BJ_LASTOPTDATE is '补件任务最新操作日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.REPLENISHFLAG is '补件标记。1-后补件;0-默认值，原授权任务，非后补件';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_taskpooldata.ID_MARK is '增删标志';
