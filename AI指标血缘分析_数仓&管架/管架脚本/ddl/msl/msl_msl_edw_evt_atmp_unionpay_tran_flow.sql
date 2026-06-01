/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_evt_atmp_unionpay_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow(
    ETL_DT DATE
    ,EVT_ID VARCHAR2(100)
    ,LP_ID VARCHAR2(60)
    ,SEND_ORG_ID VARCHAR2(100)
    ,SYS_FOLLOW_ID VARCHAR2(100)
    ,TRAN_TM VARCHAR2(30)
    ,TRAN_CD VARCHAR2(30)
    ,TRAN_TYPE_CD VARCHAR2(30)
    ,PROC_ORG_ID VARCHAR2(100)
    ,TRAN_DT DATE
    ,TELLER_ID VARCHAR2(100)
    ,TRAN_ORG_ID VARCHAR2(100)
    ,CHN_CD VARCHAR2(30)
    ,MSG_TYPE_CD VARCHAR2(30)
    ,MAIN_ACCT_ID VARCHAR2(100)
    ,PROC_CD VARCHAR2(30)
    ,INTNAL_PROC_CD VARCHAR2(30)
    ,TRAN_AMT NUMBER(30,8)
    ,ONL_ACCT_BAL NUMBER(30,8)
    ,ACCT_TD_AVAL_BAL NUMBER(30,8)
    ,ATM_DRAW_TD_AVAL_BAL NUMBER(30,8)
    ,TRAN_FEE VARCHAR2(30)
    ,PROC_ORG_SITE_TM VARCHAR2(30)
    ,PROC_ORG_SITE_DT VARCHAR2(30)
    ,CLEAR_DT VARCHAR2(30)
    ,MERCHT_TYPE_CD VARCHAR2(30)
    ,TRAN_SERV_INPUT_WAY_CD VARCHAR2(30)
    ,TRAN_SERV_COND_CD VARCHAR2(30)
    ,RETRIV_REF_ID VARCHAR2(100)
    ,APPRV_TRAN_AUTH_ID VARCHAR2(100)
    ,RETURN_CODE VARCHAR2(30)
    ,PROC_TERMN_ID VARCHAR2(100)
    ,PROC_MERCHT_ID VARCHAR2(100)
    ,PROC_MERCHT_NAME VARCHAR2(100)
    ,ADDIT_RESP_DESCB VARCHAR2(100)
    ,ADDIT_PRIV VARCHAR2(1000)
    ,CURR_CD VARCHAR2(30)
    ,RESV_REGION VARCHAR2(250)
    ,RECV_ORG_ID VARCHAR2(100)
    ,CUPS_RESV_NUM VARCHAR2(250)
    ,INIT_PROC_ORG_ID VARCHAR2(100)
    ,INIT_SEND_ORG_ID VARCHAR2(100)
    ,INIT_SYS_FOLLOW_ID VARCHAR2(100)
    ,INIT_TRAN_TM TIMESTAMP
    ,UNIONPAY_EXCH_RAT VARCHAR2(250)
    ,EXPNS_ACCT_ID VARCHAR2(100)
    ,DEPOT_ACCT_ID VARCHAR2(100)
    ,ATMC_TRAN_FLOW_NUM VARCHAR2(100)
    ,MSG_HEAD_INFO VARCHAR2(250)
    ,TRAN_STATUS_CD VARCHAR2(30)
    ,ERR_CD VARCHAR2(30)
    ,ERR_INFO VARCHAR2(250)
    ,TERMN_TYPE_CD VARCHAR2(30)
    ,INIT_WAY_CD VARCHAR2(30)
    ,MERCHT_CTY_RG_CD VARCHAR2(30)
    ,DEDUCT_AMT NUMBER(30,8)
    ,DEDUCT_EXCH_RAT NUMBER(30,8)
    ,CLEAR_AMT NUMBER(30,8)
    ,SEND_ORG_ACTL_ID VARCHAR2(100)
    ,CROSS_BOR_FLG VARCHAR2(10)
    ,CARD_SER_NUM VARCHAR2(100)
    ,ACCESS_IC_DATA_REGION VARCHAR2(1000)
    ,SEND_IC_DATA_REGION VARCHAR2(1000)
    ,INTNAL_TRAN_CD VARCHAR2(30)
    ,FCURR_TRAN_AMT NUMBER(30,8)
    ,BANK_ACCT_TYPE_CD VARCHAR2(30)
    ,OPEN_ACCT_ORG_ID VARCHAR2(100)
    ,COMM_FEE NUMBER(30,8)
    ,CARD_TYPE_CD VARCHAR2(30)
    ,CARD_TRAN_TYPE_CD VARCHAR2(30)
    ,QR_CODE_PAY_SCENE_CD VARCHAR2(30)
    ,CROSS_BANK_FLG VARCHAR2(10)
    ,DEGR_FLG VARCHAR2(10)
    ,BEPS_UNPASEW_FLG VARCHAR2(10)
    ,SUBCLASS_RETURN_CODE VARCHAR2(30)
    ,MEMO_CD VARCHAR2(30)
    ,OVA_FLOW_NUM VARCHAR2(100)
    ,TRAN_FLOW_NUM VARCHAR2(100)
    ,INIT_TRAN_FLOW_NUM VARCHAR2(100)
    ,UPP_ENTER_STATUS_CD VARCHAR2(30)
    ,ENTRY_FLOW_NUM VARCHAR2(100)
    ,ENTRY_DT DATE
    ,DELAY_DEDUCT_TRAN_FLOW_NUM VARCHAR2(100)
    ,DELAY_DEDUCT_TRAN_DT DATE
    ,UNIONPAY_DELAY_TRAN_RETURN_CD VARCHAR2(30)
    ,DELAY_TRAN_RETURN_CD VARCHAR2(30)
    ,TERMN_EQUIP_ID VARCHAR2(100)
    ,TERMN_IP_ADDR VARCHAR2(100)
    ,TERMN_SIM_NUM VARCHAR2(100)
    ,TERMN_GPS_POSITION VARCHAR2(100)
    ,RSRV_MOBILE_NO VARCHAR2(60)
    ,CUST_ID VARCHAR2(100)
    ,CUST_NAME VARCHAR2(500)
    ,MIDGROD_TRAN_DT TIMESTAMP
    ,ACCT_DT DATE
    ,INIT_TRAN_CD VARCHAR2(30)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow is 'ATMP银联前置交易流水';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.EVT_ID is '事件编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.LP_ID is '法人编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.SEND_ORG_ID is '发送机构编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.SYS_FOLLOW_ID is '系统跟踪编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TRAN_TM is '交易时间';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TRAN_CD is '交易代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TRAN_TYPE_CD is '交易类型代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.PROC_ORG_ID is '受理机构编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TRAN_DT is '交易日期';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TELLER_ID is '柜员编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TRAN_ORG_ID is '交易机构编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CHN_CD is '渠道代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.MSG_TYPE_CD is '报文类型代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.MAIN_ACCT_ID is '主账户编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.PROC_CD is '处理代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.INTNAL_PROC_CD is '内部处理代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TRAN_AMT is '交易金额';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ONL_ACCT_BAL is '联机账户余额';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ACCT_TD_AVAL_BAL is '账户当日可用余额';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ATM_DRAW_TD_AVAL_BAL is 'ATM取款当日可用余额';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TRAN_FEE is '交易费用';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.PROC_ORG_SITE_TM is '受理机构所在地时间';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.PROC_ORG_SITE_DT is '受理机构所在地日期';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CLEAR_DT is '清算日期';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.MERCHT_TYPE_CD is '商户类型代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TRAN_SERV_INPUT_WAY_CD is '交易服务点输入方式代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TRAN_SERV_COND_CD is '交易服务点条件代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.RETRIV_REF_ID is '检索参考编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.APPRV_TRAN_AUTH_ID is '批准交易授权编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.RETURN_CODE is '返回码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.PROC_TERMN_ID is '受理终端编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.PROC_MERCHT_ID is '受理商户编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.PROC_MERCHT_NAME is '受理商户名称';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ADDIT_RESP_DESCB is '附加响应描述';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ADDIT_PRIV is '附加私有域';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CURR_CD is '币种代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.RESV_REGION is '保留域';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.RECV_ORG_ID is '接收机构编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CUPS_RESV_NUM is 'CUPS保留号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.INIT_PROC_ORG_ID is '原受理机构编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.INIT_SEND_ORG_ID is '原发送机构编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.INIT_SYS_FOLLOW_ID is '原系统跟踪编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.INIT_TRAN_TM is '原交易时间';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.UNIONPAY_EXCH_RAT is '银联汇率';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.EXPNS_ACCT_ID is '支出账户编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.DEPOT_ACCT_ID is '存入账户编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ATMC_TRAN_FLOW_NUM is 'ATMC交易流水号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.MSG_HEAD_INFO is '报文头信息';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TRAN_STATUS_CD is '交易状态代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ERR_CD is '错误码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ERR_INFO is '错误信息';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TERMN_TYPE_CD is '终端类型代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.INIT_WAY_CD is '发起方式代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.MERCHT_CTY_RG_CD is '商户国家地区代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.DEDUCT_AMT is '扣款金额';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.DEDUCT_EXCH_RAT is '扣款汇率';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CLEAR_AMT is '清算金额';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.SEND_ORG_ACTL_ID is '发送机构实际编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CROSS_BOR_FLG is '跨境标志';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CARD_SER_NUM is '卡序列号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ACCESS_IC_DATA_REGION is '接入IC卡数据域';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.SEND_IC_DATA_REGION is '发出IC卡数据域';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.INTNAL_TRAN_CD is '内部交易代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.FCURR_TRAN_AMT is '外币交易金额';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.BANK_ACCT_TYPE_CD is '银行账户类型代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.OPEN_ACCT_ORG_ID is '开户机构编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.COMM_FEE is '手续费';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CARD_TYPE_CD is '卡类型代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CARD_TRAN_TYPE_CD is '卡交易类型代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.QR_CODE_PAY_SCENE_CD is '二维码付款场景代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CROSS_BANK_FLG is '跨行标志';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.DEGR_FLG is '降级标志';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.BEPS_UNPASEW_FLG is '小额免密标志';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.SUBCLASS_RETURN_CODE is '细类返回码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.MEMO_CD is '摘要代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.OVA_FLOW_NUM is '全局流水号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TRAN_FLOW_NUM is '交易流水号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.INIT_TRAN_FLOW_NUM is '原交易流水号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.UPP_ENTER_STATUS_CD is 'UPP入账状态代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ENTRY_FLOW_NUM is '记账流水号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ENTRY_DT is '记账日期';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.DELAY_DEDUCT_TRAN_FLOW_NUM is '延时扣款交易流水号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.DELAY_DEDUCT_TRAN_DT is '延时扣款交易日期';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.UNIONPAY_DELAY_TRAN_RETURN_CD is '银联延时转账返回代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.DELAY_TRAN_RETURN_CD is '延时转账返回代码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TERMN_EQUIP_ID is '终端设备编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TERMN_IP_ADDR is '终端IP地址';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TERMN_SIM_NUM is '终端SIM号码';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.TERMN_GPS_POSITION is '终端GPS位置';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.RSRV_MOBILE_NO is '预留手机号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CUST_ID is '客户编号';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.CUST_NAME is '客户名称';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.MIDGROD_TRAN_DT is '中台交易日期';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.ACCT_DT is '账务日期';
comment on column ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow.INIT_TRAN_CD is '原交易代码';
