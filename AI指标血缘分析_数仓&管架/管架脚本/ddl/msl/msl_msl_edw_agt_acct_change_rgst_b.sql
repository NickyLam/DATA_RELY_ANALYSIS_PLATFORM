/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_agt_acct_change_rgst_b
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_agt_acct_change_rgst_b
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_agt_acct_change_rgst_b purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_agt_acct_change_rgst_b(
    ETL_DT DATE
    ,AGT_ID VARCHAR2(60)
    ,LP_ID VARCHAR2(60)
    ,OLD_ACCT_ID VARCHAR2(60)
    ,NEW_ACCT_ID VARCHAR2(60)
    ,TRAN_DT DATE
    ,TRAN_FLOW_NUM VARCHAR2(60)
    ,ADVISED_MIDGROD_FLG VARCHAR2(10)
    ,TRAN_ORG_ID VARCHAR2(60)
    ,TRAN_TELLER_ID VARCHAR2(60)
    ,JOB_CD  VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_agt_acct_change_rgst_b to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_agt_acct_change_rgst_b is '账号更换登记簿';
comment on column ${msl_schema}.msl_edw_agt_acct_change_rgst_b.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_agt_acct_change_rgst_b.AGT_ID is '协议编号';
comment on column ${msl_schema}.msl_edw_agt_acct_change_rgst_b.LP_ID is '法人编号';
comment on column ${msl_schema}.msl_edw_agt_acct_change_rgst_b.OLD_ACCT_ID is '旧账户编号';
comment on column ${msl_schema}.msl_edw_agt_acct_change_rgst_b.NEW_ACCT_ID is '新账户编号';
comment on column ${msl_schema}.msl_edw_agt_acct_change_rgst_b.TRAN_DT is '交易日期';
comment on column ${msl_schema}.msl_edw_agt_acct_change_rgst_b.TRAN_FLOW_NUM is '交易流水号';
comment on column ${msl_schema}.msl_edw_agt_acct_change_rgst_b.ADVISED_MIDGROD_FLG is '已通知中台标志';
comment on column ${msl_schema}.msl_edw_agt_acct_change_rgst_b.TRAN_ORG_ID is '交易机构编号';
comment on column ${msl_schema}.msl_edw_agt_acct_change_rgst_b.TRAN_TELLER_ID is '交易柜员编号';
comment on column ${msl_schema}.msl_edw_agt_acct_change_rgst_b.JOB_CD is '任务编码';
