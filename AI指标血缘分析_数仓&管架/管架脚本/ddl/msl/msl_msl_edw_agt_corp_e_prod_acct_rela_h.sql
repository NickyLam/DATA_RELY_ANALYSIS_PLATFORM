/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_agt_corp_e_prod_acct_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h(
    ETL_DT DATE
    ,ACCT_RELA_ID VARCHAR2(100)
    ,LP_ID VARCHAR2(60)
    ,AGT_ID VARCHAR2(60)
    ,E_ACCT_ID VARCHAR2(60)
    ,ACCT_SUB_SEQ_NUM VARCHAR2(100)
    ,PROD_ACCT_ID VARCHAR2(60)
    ,CUST_ID VARCHAR2(60)
    ,MERCHT_ID VARCHAR2(60)
    ,ACCT_ID VARCHAR2(60)
    ,PROD_ID VARCHAR2(60)
    ,ACCT_ROLE_TYPE_CD VARCHAR2(30)
    ,EFFECT_TM TIMESTAMP
    ,INVALID_TM TIMESTAMP
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h is '公司电子账户与产品账号关系历史';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.ACCT_RELA_ID is '账户关系编号';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.LP_ID is '法人编号';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.AGT_ID is '协议编号';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.E_ACCT_ID is 'E账户编号';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.ACCT_SUB_SEQ_NUM is '账户子序号';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.PROD_ACCT_ID is '产品账户编号';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.CUST_ID is '客户编号';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.MERCHT_ID is '商户编号';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.ACCT_ID is '账户编号';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.PROD_ID is '产品编号';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.ACCT_ROLE_TYPE_CD is '账户角色类型代码';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.EFFECT_TM is '生效时间';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.INVALID_TM is '失效时间';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.START_DT is '开始日期';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.END_DT is '结束日期';
comment on column ${msl_schema}.msl_edw_agt_corp_e_prod_acct_rela_h.ID_MARK is '删除标识';
