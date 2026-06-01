/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_orws_t_ghbr_bv_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_t_ghbr_bv_details
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_t_ghbr_bv_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_t_ghbr_bv_details(
    ETL_DT DATE
    ,TXN_DT TIMESTAMP(6)
    ,TXN_TM VARCHAR2(30)
    ,PARENT_ORG_ID VARCHAR2(50)
    ,BLNG_ORG_ID VARCHAR2(50)
    ,OPER_TELLER_ID VARCHAR2(50)
    ,OPER_TELLER_NAME VARCHAR2(255)
    ,AUTH_TELLER_ID VARCHAR2(50)
    ,AUTH_TELLER_NAME VARCHAR2(255)
    ,TXN_NUM VARCHAR2(30)
    ,TXN_DESC VARCHAR2(500)
    ,BIZ_SYS_EVT_ID VARCHAR2(60)
    ,BCS_EVT_ID VARCHAR2(60)
    ,DATA_SRC_CD VARCHAR2(4)
    ,PAY_AGT_ID VARCHAR2(60)
    ,RCV_AGT_ID VARCHAR2(60)
    ,TXN_AMT NUMBER(18,2)
    ,MENUID VARCHAR2(10)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_t_ghbr_bv_details to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_t_ghbr_bv_details is '业务量明细表';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.TXN_DT is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.TXN_TM is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.PARENT_ORG_ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.BLNG_ORG_ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.OPER_TELLER_ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.OPER_TELLER_NAME is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.AUTH_TELLER_ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.AUTH_TELLER_NAME is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.TXN_NUM is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.TXN_DESC is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.BIZ_SYS_EVT_ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.BCS_EVT_ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.DATA_SRC_CD is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.PAY_AGT_ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.RCV_AGT_ID is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.TXN_AMT is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_details.MENUID is '';
