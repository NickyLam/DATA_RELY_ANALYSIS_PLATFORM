/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_cmm_pbc_pass_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow(
    ETL_DT DATE
    ,EVT_ID VARCHAR2(60)
    ,LP_ID VARCHAR2(60)
    ,PAY_DECL_FORM_ID VARCHAR2(60)
    ,TRAN_DT DATE
    ,OUT_LINE_PAY_TRAN_SEQ_NUM VARCHAR2(60)
    ,BANK_INT_BUS_SEQ_NUM VARCHAR2(60)
    ,BUS_ORIGI_BANK_NO VARCHAR2(60)
    ,MSG_TYPE_ID VARCHAR2(60)
    ,SCD_GENER_MSG_TYPE_ID VARCHAR2(60)
    ,HOST_FLOW_NUM VARCHAR2(100)
    ,TRAN_FLOW_NUM VARCHAR2(60)
    ,SEND_TRAN_FLOW_NUM VARCHAR2(30)
    ,OVA_FLOW_NUM VARCHAR2(60)
    ,HOST_TRAN_CODE VARCHAR2(30)
    ,MIDGROD_TRAN_CODE VARCHAR2(30)
    ,CURR_CD VARCHAR2(10)
    ,PROD_CD VARCHAR2(10)
    ,BUS_KIND_CD VARCHAR2(20)
    ,BUS_TYPE_CD VARCHAR2(10)
    ,PROC_STATUS_CD VARCHAR2(10)
    ,NPC_PROC_CD VARCHAR2(60)
    ,CHECK_ENTRY_STATUS_CD VARCHAR2(10)
    ,DEBIT_CRDT_CD VARCHAR2(10)
    ,ENTRY_CODE VARCHAR2(30)
    ,ACCT_GEN_CD VARCHAR2(20)
    ,ACCT_TYPE_CD VARCHAR2(20)
    ,E_ACCT_CD VARCHAR2(10)
    ,REC_STATUS_CD VARCHAR2(10)
    ,MODE_PAY_CD VARCHAR2(10)
    ,EXCH_BUS_TRAN_CHN_CD VARCHAR2(10)
    ,GROUND_PROC_STATUS_CD VARCHAR2(10)
    ,VERIFY_PROC_STATUS_CD VARCHAR2(10)
    ,NOSTRO_FLG VARCHAR2(10)
    ,CHARGE_FLG VARCHAR2(10)
    ,AGENT_FLG VARCHAR2(10)
    ,INTNAL_ACCT_FLG VARCHAR2(10)
    ,ENTR_DT DATE
    ,HOST_DT DATE
    ,CLEAR_DT DATE
    ,CHECK_ENTRY_DT DATE
    ,MODIF_DT DATE
    ,MODIF_TM TIMESTAMP
    ,INIT_ENTR_DT DATE
    ,INIT_PAY_TRAN_SEQ_NUM VARCHAR2(60)
    ,TRAN_AMT NUMBER(30,2)
    ,COMM_FEE_AMT NUMBER(30,8)
    ,REMIT_TRAN_FEE_AMT NUMBER(30,8)
    ,TODOS NUMBER(30,8)
    ,PAYER_OPEN_BANK_NO VARCHAR2(60)
    ,PAYER_OPEN_BANK_NAME VARCHAR2(250)
    ,PAYER_ACCT_NUM VARCHAR2(60)
    ,PAYER_NAME VARCHAR2(250)
    ,PAYER_ADDR VARCHAR2(250)
    ,RECVER_OPEN_BANK_NO VARCHAR2(60)
    ,RECVER_OPEN_BANK_NAME VARCHAR2(250)
    ,RECVER_ACCT_NUM VARCHAR2(60)
    ,RECVER_NAME VARCHAR2(250)
    ,RECVER_ADDR VARCHAR2(250)
    ,ERR_RETURN_CODE VARCHAR2(30)
    ,ERR_INFO VARCHAR2(500)
    ,PRIOR_LEVEL VARCHAR2(20)
    ,INPUT_TELLER_ID VARCHAR2(60)
    ,CHECK_TELLER_ID VARCHAR2(60)
    ,AUTH_TELLER_ID VARCHAR2(60)
    ,INPUT_CHECK_TELLER_DEPT_ID VARCHAR2(60)
    ,AUTH_TELLER_DEPT_ID VARCHAR2(60)
    ,REG_MAIN_ACCT_NUM VARCHAR2(60)
    ,REG_MAIN_NAME VARCHAR2(250)
    ,MATN_ENTER_ACCT_DT DATE
    ,MATN_ENTER_ACCT_TELLER_ID VARCHAR2(60)
    ,MATN_ENTER_ACCT_DEPT_ID VARCHAR2(60)
    ,VOUCH_TYPE_CD VARCHAR2(10)
    ,VOUCH_DT DATE
    ,VOUCH_NO VARCHAR2(60)
    ,CERT_KIND_CD VARCHAR2(10)
    ,CERT_NO VARCHAR2(60)
    ,ACTL_DEDUCT_ACCT_NUM VARCHAR2(60)
    ,ACTL_DEDUCT_ACCT_NAME VARCHAR2(100)
    ,RGST_ADDIT_DATA_TAB_NAME VARCHAR2(100)
    ,ON_ACCT_RS_CD VARCHAR2(10)
    ,AUTO_REFUND_FLG VARCHAR2(10)
    ,AUTO_REFUND_CNT NUMBER(10)
    ,VTUAL_BIND_ACCT VARCHAR2(60)
    ,VTUAL_BIND_ACCT_NAME VARCHAR2(250)
    ,VTUAL_OPEN_ACCT_ORG_ID VARCHAR2(60)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow is '人行通道交易流水';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.EVT_ID is '事件编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.LP_ID is '法人编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.PAY_DECL_FORM_ID is '支付报单编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.TRAN_DT is '交易日期';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.OUT_LINE_PAY_TRAN_SEQ_NUM is '行外支付交易序号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.BANK_INT_BUS_SEQ_NUM is '行内业务序号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.BUS_ORIGI_BANK_NO is '业务发起行行号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.MSG_TYPE_ID is '报文类型编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.SCD_GENER_MSG_TYPE_ID is '二代报文类型编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.HOST_FLOW_NUM is '主机流水号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.TRAN_FLOW_NUM is '交易流水号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.SEND_TRAN_FLOW_NUM is '发送交易流水号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.OVA_FLOW_NUM is '全局流水号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.HOST_TRAN_CODE is '主机交易码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.MIDGROD_TRAN_CODE is '中台交易码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.CURR_CD is '币种代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.PROD_CD is '产品代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.BUS_KIND_CD is '业务种类代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.BUS_TYPE_CD is '业务类型代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.PROC_STATUS_CD is '处理状态代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.NPC_PROC_CD is 'NPC处理代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.CHECK_ENTRY_STATUS_CD is '对账状态代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.DEBIT_CRDT_CD is '借贷代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.ENTRY_CODE is '记账分录编码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.ACCT_GEN_CD is '账户大类型代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.ACCT_TYPE_CD is '账户类型代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.E_ACCT_CD is '电子账户代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.REC_STATUS_CD is '记录状态代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.MODE_PAY_CD is '支付方式代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.EXCH_BUS_TRAN_CHN_CD is '汇兑业务交易渠道代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.GROUND_PROC_STATUS_CD is '落地处理状态代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.VERIFY_PROC_STATUS_CD is '查证处理状态代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.NOSTRO_FLG is '往来账标志';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.CHARGE_FLG is '收费标志';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.AGENT_FLG is '代理标志';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.INTNAL_ACCT_FLG is '内部账标志';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.ENTR_DT is '委托日期';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.HOST_DT is '主机日期';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.CLEAR_DT is '清算日期';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.CHECK_ENTRY_DT is '对账日期';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.MODIF_DT is '修改日期';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.MODIF_TM is '修改时间';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.INIT_ENTR_DT is '原委托日期';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.INIT_PAY_TRAN_SEQ_NUM is '原支付交易序号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.TRAN_AMT is '交易金额';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.COMM_FEE_AMT is '手续费用金额';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.REMIT_TRAN_FEE_AMT is '汇划费用金额';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.TODOS is '工本费';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.PAYER_OPEN_BANK_NO is '付款人开户行行号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.PAYER_OPEN_BANK_NAME is '付款人开户行名称';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.PAYER_ACCT_NUM is '付款人账号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.PAYER_NAME is '付款人名称';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.PAYER_ADDR is '付款人地址';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.RECVER_OPEN_BANK_NO is '收款人开户行行号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.RECVER_OPEN_BANK_NAME is '收款人开户行名称';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.RECVER_ACCT_NUM is '收款人账号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.RECVER_NAME is '收款人名称';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.RECVER_ADDR is '收款人地址';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.ERR_RETURN_CODE is '错误返回编码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.ERR_INFO is '错误信息';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.PRIOR_LEVEL is '优先级别';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.INPUT_TELLER_ID is '录入柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.CHECK_TELLER_ID is '复核柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.AUTH_TELLER_ID is '授权柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.INPUT_CHECK_TELLER_DEPT_ID is '录入复核柜员部门编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.AUTH_TELLER_DEPT_ID is '授权柜员部门编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.REG_MAIN_ACCT_NUM is '挂账或维护入账账号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.REG_MAIN_NAME is '挂账或维护入账姓名';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.MATN_ENTER_ACCT_DT is '维护入账日期';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.MATN_ENTER_ACCT_TELLER_ID is '维护入账柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.MATN_ENTER_ACCT_DEPT_ID is '维护入账部门编号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.VOUCH_TYPE_CD is '凭证类型代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.VOUCH_DT is '凭证日期';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.VOUCH_NO is '凭证号码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.CERT_KIND_CD is '证件种类代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.CERT_NO is '证件号码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.ACTL_DEDUCT_ACCT_NUM is '实际扣账账号';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.ACTL_DEDUCT_ACCT_NAME is '实际扣账户名称';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.RGST_ADDIT_DATA_TAB_NAME is '登记附加数据表名称';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.ON_ACCT_RS_CD is '挂账原因代码';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.AUTO_REFUND_FLG is '自动退汇标志';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.AUTO_REFUND_CNT is '自动退汇次数';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.VTUAL_BIND_ACCT is '虚户绑定账户';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.VTUAL_BIND_ACCT_NAME is '虚户绑定账户名称';
comment on column ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow.VTUAL_OPEN_ACCT_ORG_ID is '虚户绑定账户开户机构编号';
