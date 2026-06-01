/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_agt_cust_acct_sub_acct_rela_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h(
    ETL_DT DATE
    ,AGT_ID VARCHAR2(60)
    ,LP_ID VARCHAR2(60)
    ,AGT_RELA_TYPE_CD VARCHAR2(10)
    ,SEQ_NUM VARCHAR2(60)
    ,RELA_AGT_ID VARCHAR2(60)
    ,ACCT_ID VARCHAR2(60)
    ,ACCT_SUB_ACCT_ID VARCHAR2(60)
    ,STAND_B_TYPE_CD VARCHAR2(10)
    ,DEP_BASIC_ACCT_FLG VARCHAR2(10)
    ,CURR_CD VARCHAR2(10)
    ,EC_FLG VARCHAR2(10)
    ,EXT_PROD_ID VARCHAR2(60)
    ,INTNAL_PROD_ID VARCHAR2(60)
    ,START_DT DATE
    ,END_DT DATE
    ,ID_MARK VARCHAR2(10)
    ,JOB_CD  VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h is '客户账户与子户关系历史';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.AGT_ID is '协议编号';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.LP_ID is '法人编号';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.AGT_RELA_TYPE_CD is '协议关系类型代码';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.SEQ_NUM is '序号';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.RELA_AGT_ID is '关联协议编号';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.ACCT_ID is '账户编号';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.ACCT_SUB_ACCT_ID is '账户分户编号';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.STAND_B_TYPE_CD is '台账类型代码';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.DEP_BASIC_ACCT_FLG is '存款基本户标志';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.CURR_CD is '币种代码';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.EC_FLG is '钞汇标志';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.EXT_PROD_ID is '外部产品编号';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.INTNAL_PROD_ID is '内部产品编号';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.START_DT is '开始日期';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.END_DT is '结束日期';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.ID_MARK is '删除标识';
comment on column ${msl_schema}.msl_edw_agt_cust_acct_sub_acct_rela_h.JOB_CD is '任务编码';
