/*
Purpose:    共性加工层-20190731分区的数据去重。
Author:     Sunline
Usage:      @03_insert_icl_cmm_inter_bus_inco_dtl.sql
CreateDate: 20230623
FileType:   
Logs:       python $ETL_HOME/script/main.py 20230625 icl_cmm_inter_bus_inco_dtl_del
*/
set serveroutput on
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;

whenever sqlerror continue none;
drop table icl.cmm_inter_bus_inco_dtl_P20190731_tmp02 purge;
drop table icl.cmm_inter_bus_inco_dtl_P20190731_tmp03 purge;

whenever sqlerror exit sql.sqlcode;
create table icl.cmm_inter_bus_inco_dtl_P20190731_tmp02
as
select t.*,row_number() over(partition by ETL_DT,
          LP_ID,
          ACCT_BILL_FLOW_NUM,
          TRAN_FLOW_NUM,
          TRAN_DT,
          OVA_FLOW_NUM,
          CHARGE_DOC_NUM,
          AMORT_FLOW_NUM
          order by BUS_ACCT_ID asc,CUST_ID desc) rn
 from icl.cmm_inter_bus_inco_dtl_P20190731_tmp01 t
 ;


create table icl.cmm_inter_bus_inco_dtl_P20190731_tmp03
as	
SELECT ETL_DT,
       LP_ID,
       ACCT_BILL_FLOW_NUM,
       TRAN_FLOW_NUM,
       TRAN_DT,
       OVA_FLOW_NUM,
       BUS_FLOW_NUM,
       CHARGE_DOC_NUM,
       ACCT_DT,
       AMORT_FLOW_NUM,
       AMORT_START_DT,
       AMORT_END_DT,
       SUBJ_ID,
       STD_PROD_ID,
       CUST_ID,
       BUS_ACCT_ID,
       INTNAL_ACCT_ID,
       INTNAL_ACCT_NAME,
       INTNAL_MAIN_ACCT_ID,
       TRAN_MAIN_ACCT_ID,
       TRAN_SUB_ACCT_ID,
       TRAN_CHN_CD,
       BAL_DIR_CD,
       SORC_SYS_CD,
       CUST_MGR_ID,
       CHARGE_CD,
       CHARGE_NAME,
       CHARGE_CATE_CD,
       AMORT_FLG,
       DEBIT_CRDT_FLG,
       ERASE_ACCT_FLG,
       REVS_FLG,
       TRAN_ORG_ID,
       ACCT_INSTIT_ID,
       CURR_CD,
       ACM_AMORT_AMT,
       AMORTED_TOT_AMT,
       TRAN_AMT,
       RECVBL_COMM_FEE_AMT,
       TAX_AMT,
       AT_AMT,
       TRAN_REMARK_INFO,
       JOB_CD,
       ETL_TIMESTAMP
  FROM icl.CMM_INTER_BUS_INCO_DTL_P20190731_TMP02 T
 WHERE RN = 1
 ;


--交换分区
alter table icl.cmm_inter_bus_inco_dtl exchange partition p_20190731 with table icl.cmm_inter_bus_inco_dtl_P20190731_tmp03;


--select * from icl.cmm_inter_bus_inco_dtl_bak_P20190731;
--select * from icl.cmm_inter_bus_inco_dtl_P20190731_tmp01;
--select * from icl.cmm_inter_bus_inco_dtl_P20190731_tmp02;
--drop table icl.cmm_inter_bus_inco_dtl_bak_P20190731 purge;
--drop table icl.cmm_inter_bus_inco_dtl_P20190731_tmp01 purge;
--drop table icl.cmm_inter_bus_inco_dtl_P20190731_tmp02 purge;
