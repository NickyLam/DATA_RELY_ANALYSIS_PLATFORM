/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_ncts_ab_auth_tasktabledtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl(
    ETL_DT DATE
    ,TXDATE DATE
    ,TXTIME VARCHAR2(6)
    ,TRADESERNO VARCHAR2(24)
    ,AUTHSERNO VARCHAR2(30)
    ,CRTDATE VARCHAR2(8)
    ,TXORGNO VARCHAR2(6)
    ,TXTELLERNO VARCHAR2(50)
    ,AUTHORGNO VARCHAR2(6)
    ,AUTHTELLERNO VARCHAR2(50)
    ,AUDITORGNO VARCHAR2(6)
    ,AUDITTELLERNO VARCHAR2(50)
    ,AUTHSTATUS VARCHAR2(1)
    ,AUTHTASKNOTE VARCHAR2(300)
    ,AUTHREFUSENOTE VARCHAR2(300)
    ,CRTTIME VARCHAR2(6)
    ,WEIGHT NUMBER(2,0)
    ,AUTHMODEL VARCHAR2(1)
    ,ISAUTHFLAG VARCHAR2(1)
    ,TXCODE VARCHAR2(8)
    ,REASONCODE VARCHAR2(1000)
    ,BARCODE VARCHAR2(50)
    ,AUTHLEVEL VARCHAR2(2)
    ,TRADESTATUS VARCHAR2(1)
    ,TRADEMODE VARCHAR2(1)
    ,AUTHRETURNNOTE VARCHAR2(300)
    ,AUTHCANCELNOTE VARCHAR2(300)
    ,RETURNTYPE VARCHAR2(300)
    ,OVERTIME VARCHAR2(6)
    ,CARTORDER NUMBER(3,0)
    ,MAKEUPSN VARCHAR2(32)
    ,TIMES NUMBER(3,0)
    ,AUTHNOTE_REPLENISH VARCHAR2(300)
    ,REPLENISH_STATUS VARCHAR2(1)
    ,AUTH_REPLENISH_TYPE VARCHAR2(300)
    ,AUTH_REPLENISH_NOTE VARCHAR2(300)
    ,BJ_TELLERNO VARCHAR2(50)
    ,FQBJ_TELLERNO VARCHAR2(50)
    ,SH_TELLERNO VARCHAR2(50)
    ,BJ_AUTHTELLERNO VARCHAR2(50)
    ,REPLENISH_NOTE VARCHAR2(300)
    ,REPLENISHFLAG VARCHAR2(1)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl is '授权任务流水表';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.TXDATE is '交易日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.TXTIME is '交易时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.TRADESERNO is '前台交易流水号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTHSERNO is '授权流水号（编号规则：6位日期+10位顺序号）';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.CRTDATE is '创建日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.TXORGNO is '交易机构号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.TXTELLERNO is '交易柜员号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTHORGNO is '授权机构号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTHTELLERNO is '授权柜员号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUDITORGNO is '复核机构号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUDITTELLERNO is '复核柜员号';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTHSTATUS is '远程授权任务状态(1-授权等待中、2-授权处理中、3-授权通过、4-授权拒绝、5-授权返回、6-转现场授权、7-授权撤销、8-异常)';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTHTASKNOTE is '授权任务备注';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTHREFUSENOTE is '授权任务拒绝备注';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.CRTTIME is '创建时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.WEIGHT is '权重值';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTHMODEL is '授权模式(0-本地授权、1-跨终端授权、2-远程授权)';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.ISAUTHFLAG is '是否授权返回（0-否、1-是）';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.TXCODE is '交易码';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.REASONCODE is '授权原因';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.BARCODE is '影像码';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTHLEVEL is '授权级别';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.TRADESTATUS is '交易状态（0-处理中，1-成功，2-失败）';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.TRADEMODE is '交易模式（1-单交易模式，2-交易包模式）';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTHRETURNNOTE is '授权退件备注';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTHCANCELNOTE is '授权撤销备注';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.RETURNTYPE is '授权返回原因码';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.OVERTIME is '数据日期';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.CARTORDER is '提交购物车批次数（跟购物车组合流水一起，唯一标示每一批购物车交易）';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.MAKEUPSN is '购物车授权任务顺序，从1开始';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.TIMES is '购物车组合流水';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTHNOTE_REPLENISH is '发起补件备注';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.REPLENISH_STATUS is '补件状态';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTH_REPLENISH_TYPE is '补件退回类型';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.AUTH_REPLENISH_NOTE is '补件退回备注';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.BJ_TELLERNO is '补件柜员';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.FQBJ_TELLERNO is '发起后补件人员';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.SH_TELLERNO is '审核授权人员';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.BJ_AUTHTELLERNO is '后补件授权柜员';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.REPLENISH_NOTE is '补件备注';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.REPLENISHFLAG is '补件标记。1-后补件;0-默认值，原授权任务，非后补件';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.START_DT is '开始时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.END_DT is '结束时间';
comment on column ${msl_schema}.msl_edw_ncts_ab_auth_tasktabledtl.ID_MARK is '增删标志';
