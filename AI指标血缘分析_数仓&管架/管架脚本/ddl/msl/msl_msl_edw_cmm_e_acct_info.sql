/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl edw_cmm_e_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cmm_e_acct_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cmm_e_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cmm_e_acct_info(
    ETL_DT DATE
    ,LP_ID VARCHAR2(60)
    ,ACCT_ID VARCHAR2(60)
    ,ACCT_NAME VARCHAR2(500)
    ,CUST_ACCT_ID VARCHAR2(60)
    ,CUST_SUB_ACCT_NUM VARCHAR2(100)
    ,CUST_ID VARCHAR2(60)
    ,SUBJ_ID VARCHAR2(60)
    ,PROD_ID VARCHAR2(60)
    ,STD_PROD_ID VARCHAR2(60)
    ,DEP_TERM VARCHAR2(10)
    ,DEP_KIND_CD VARCHAR2(10)
    ,ACCT_CLS_CD VARCHAR2(20)
    ,ACCT_TYPE_CD VARCHAR2(10)
    ,E_ACCT_TYPE_CD VARCHAR2(10)
    ,DEP_ACCT_STATUS_CD VARCHAR2(10)
    ,CORP_ACCT_FLG VARCHAR2(10)
    ,RC_FLG VARCHAR2(10)
    ,WEB_DEP_FLG VARCHAR2(10)
    ,GENERAL_EXCH_FLG VARCHAR2(10)
    ,MARGIN_FLG VARCHAR2(10)
    ,ADVISE_DEP_FLG VARCHAR2(10)
    ,EC_FLG VARCHAR2(10)
    ,PRIVAVY_ACCT_FLG VARCHAR2(10)
    ,LEGAL_ACCT_FLG VARCHAR2(10)
    ,SLEEP_ACCT_FLG VARCHAR2(10)
    ,FROZ_FLG VARCHAR2(10)
    ,BIND_ACCT_FLG VARCHAR2(11)
    ,INT_ACCR_FLG VARCHAR2(10)
    ,AUTO_REDT_FLG VARCHAR2(10)
    ,REDT_WAY_CD VARCHAR2(10)
    ,INT_ACCR_BASE_CD VARCHAR2(10)
    ,INT_SET_WAY_CD VARCHAR2(10)
    ,INT_ACCR_WAY_CD VARCHAR2(10)
    ,CURR_CD VARCHAR2(10)
    ,OPEN_ACCT_CHN_TYPE_CD VARCHAR2(10)
    ,TRAN_CHN_STATUS_CD VARCHAR2(10)
    ,OPEN_ACCT_DT DATE
    ,OPEN_ACCT_TM TIMESTAMP(6)
    ,CLOS_ACCT_DT DATE
    ,CLOS_ACCT_TM TIMESTAMP(6)
    ,ACTV_DT DATE
    ,VALUE_DT DATE
    ,EXP_DT DATE
    ,FINAL_ACTIV_ACCT_DT DATE
    ,FROZ_DT DATE
    ,UNFRZ_DT DATE
    ,LAST_INT_SET_DT DATE
    ,NEXT_INT_SET_DT DATE
    ,FIR_VALUE_DT DATE
    ,BASE_RAT_TYPE_CD VARCHAR2(10)
    ,BASE_RAT NUMBER(18,8)
    ,EXEC_INT_RAT NUMBER(18,8)
    ,TD_ACRU_INT NUMBER(30,8)
    ,CURRT_ACRU_INT NUMBER(30,8)
    ,OPEN_ACCT_TELLER_ID VARCHAR2(60)
    ,CLOS_ACCT_TELLER_ID VARCHAR2(60)
    ,OPEN_ACCT_ORG_ID VARCHAR2(60)
    ,CLOSE_ACCT_ORG_ID VARCHAR2(60)
    ,BELONG_ORG_ID VARCHAR2(60)
    ,CAMP_ACTIV_ID VARCHAR2(60)
    ,REFERRER_TYPE_CD VARCHAR2(10)
    ,REFERRER_NUM VARCHAR2(30)
    ,VTUAL_ACCT_FLG VARCHAR2(10)
    ,MERCHT_ID VARCHAR2(60)
    ,CURRT_BAL NUMBER(30,2)
    ,AVAL_BAL NUMBER(18,2)
    ,FROZ_AMT NUMBER(18,2)
    ,CL_CURR_CURRT_BAL NUMBER(30,2)
    ,EAR_D_BAL NUMBER(30,2)
    ,EAR_M_BAL NUMBER(30,2)
    ,EAR_S_BAL NUMBER(30,2)
    ,EAR_Y_BAL NUMBER(30,2)
    ,Y_ACM_BAL NUMBER(30,2)
    ,S_ACM_BAL NUMBER(30,2)
    ,M_ACM_BAL NUMBER(30,2)
    ,CL_CURR_EAR_D_BAL NUMBER(30,2)
    ,CL_CURR_EAR_M_BAL NUMBER(30,2)
    ,CL_CURR_EAR_S_BAL NUMBER(30,2)
    ,CL_CURR_EAR_Y_BAL NUMBER(30,2)
    ,CL_CURR_Y_ACM_BAL NUMBER(30,2)
    ,CL_CURR_EAR_D_Y_ACM_BAL NUMBER(30,2)
    ,CL_CURR_EAR_M_Y_ACM_BAL NUMBER(30,2)
    ,CL_CURR_EAR_S_Y_ACM_BAL NUMBER(30,2)
    ,CL_CURR_EAR_Y_Y_ACM_BAL NUMBER(30,2)
    ,CL_CURR_S_ACM_BAL NUMBER(30,2)
    ,CL_CURR_EAR_D_S_ACM_BAL NUMBER(30,2)
    ,CL_CURR_EAR_S_S_ACM_BAL NUMBER(30,2)
    ,CL_CURR_EAR_Y_S_ACM_BAL NUMBER(30,2)
    ,CL_CURR_M_ACM_BAL NUMBER(30,2)
    ,CL_CURR_EAR_D_M_ACM_BAL NUMBER(30,2)
    ,CL_CURR_EAR_M_M_ACM_BAL NUMBER(30,2)
    ,CL_CURR_EAR_Y_M_ACM_BAL NUMBER(30,2)
    ,ENTRY_FLG VARCHAR2(10)
    ,Y_AVG_BAL NUMBER(30,2)
    ,Q_AVG_BAL NUMBER(30,2)
    ,M_AVG_BAL NUMBER(30,2)
    ,CL_CURR_Y_AVG_BAL NUMBER(30,2)
    ,CL_CURR_Q_AVG_BAL NUMBER(30,2)
    ,CL_CURR_M_AVG_BAL NUMBER(30,2)
    ,LIAB_ACCT_ID VARCHAR2(60)
    ,OPEN_AMT NUMBER(30,2)
    ,OLD_ACCT_ID VARCHAR2(60)
    ,INT_PAYBL_SUBJ_ID VARCHAR2(60)
    ,INT_PAYBL_ADJ_SUBJ_ID VARCHAR2(60)
    ,INT_EXPNS_SUBJ_ID VARCHAR2(60)
    ,INT_EXPNS_ADJ_SUBJ_ID VARCHAR2(60)
    ,CURRT_INT_PAYBL_ADJ NUMBER(30,8)
    ,TD_INT_EXPNS NUMBER(30,8)
    ,TD_INT_EXPNS_ADJ NUMBER(30,8)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cmm_e_acct_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cmm_e_acct_info is '存款电子分户信息';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.ETL_DT is '数据日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.LP_ID is '法人编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.ACCT_ID is '账户编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.ACCT_NAME is '账户名称';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CUST_ACCT_ID is '客户账户编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CUST_SUB_ACCT_NUM is '客户账户子户号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CUST_ID is '客户编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.SUBJ_ID is '科目编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.PROD_ID is '产品编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.STD_PROD_ID is '标准产品编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.DEP_TERM is '存期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.DEP_KIND_CD is '储种代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.ACCT_CLS_CD is '账户分类代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.ACCT_TYPE_CD is '账户类型代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.E_ACCT_TYPE_CD is '电子账户类型代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.DEP_ACCT_STATUS_CD is '存款账户状态代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CORP_ACCT_FLG is '对公账户标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.RC_FLG is '定活标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.WEB_DEP_FLG is '网络存款标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.GENERAL_EXCH_FLG is '通兑标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.MARGIN_FLG is '保证金标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.ADVISE_DEP_FLG is '通知存款标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.EC_FLG is '钞汇标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.PRIVAVY_ACCT_FLG is '隐私账户标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.LEGAL_ACCT_FLG is '涉案账户标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.SLEEP_ACCT_FLG is '睡眠户标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.FROZ_FLG is '冻结标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.BIND_ACCT_FLG is '绑定账户标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.INT_ACCR_FLG is '计息标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.AUTO_REDT_FLG is '自动转存标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.REDT_WAY_CD is '转存方式代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.INT_ACCR_BASE_CD is '计息基准代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.INT_SET_WAY_CD is '结息方式代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.INT_ACCR_WAY_CD is '计息方式代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CURR_CD is '币种代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.OPEN_ACCT_CHN_TYPE_CD is '开户渠道类型代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.TRAN_CHN_STATUS_CD is '交易渠道状态代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.OPEN_ACCT_DT is '开户日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.OPEN_ACCT_TM is '开户时间';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CLOS_ACCT_DT is '销户日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CLOS_ACCT_TM is '销户时间';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.ACTV_DT is '激活日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.VALUE_DT is '起息日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.EXP_DT is '到期日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.FINAL_ACTIV_ACCT_DT is '最后动户日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.FROZ_DT is '冻结日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.UNFRZ_DT is '解冻日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.LAST_INT_SET_DT is '上次结息日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.NEXT_INT_SET_DT is '下次结息日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.FIR_VALUE_DT is '首次起息日期';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.BASE_RAT_TYPE_CD is '基准利率类型代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.BASE_RAT is '基准利率';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.EXEC_INT_RAT is '执行利率';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.TD_ACRU_INT is '当日应计利息';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CURRT_ACRU_INT is '当期应计利息';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.OPEN_ACCT_TELLER_ID is '开户柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CLOS_ACCT_TELLER_ID is '销户柜员编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.OPEN_ACCT_ORG_ID is '开户机构编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CLOSE_ACCT_ORG_ID is '销户机构编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.BELONG_ORG_ID is '所属机构编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CAMP_ACTIV_ID is '营销活动编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.REFERRER_TYPE_CD is '推荐人类型代码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.REFERRER_NUM is '推荐人号码';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.VTUAL_ACCT_FLG is '虚拟账户标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.MERCHT_ID is '商户编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CURRT_BAL is '当期余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.AVAL_BAL is '可用余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.FROZ_AMT is '冻结金额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_CURRT_BAL is '折本币当期余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.EAR_D_BAL is '日初余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.EAR_M_BAL is '月初余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.EAR_S_BAL is '季初余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.EAR_Y_BAL is '年初余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.Y_ACM_BAL is '年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.S_ACM_BAL is '季累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.M_ACM_BAL is '月累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_D_BAL is '折本币日初余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_M_BAL is '折本币月初余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_S_BAL is '折本币季初余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_Y_BAL is '折本币年初余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_Y_ACM_BAL is '折本币年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_D_Y_ACM_BAL is '折本币日初年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_M_Y_ACM_BAL is '折本币月初年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_S_Y_ACM_BAL is '折本币季初年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_Y_Y_ACM_BAL is '折本币年初年累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_S_ACM_BAL is '折本币季累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_D_S_ACM_BAL is '折本币日初季累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_S_S_ACM_BAL is '折本币季初季累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_Y_S_ACM_BAL is '折本币年初季累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_M_ACM_BAL is '折本币月累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_D_M_ACM_BAL is '折本币日初月累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_M_M_ACM_BAL is '折本币月初月累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_EAR_Y_M_ACM_BAL is '折本币年初月累计余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.ENTRY_FLG is '记账标志';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.Y_AVG_BAL is '年日均余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.Q_AVG_BAL is '季日均余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.M_AVG_BAL is '月日均余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_Y_AVG_BAL is '折本币年日均余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_Q_AVG_BAL is '折本币季日均余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CL_CURR_M_AVG_BAL is '折本币月日均余额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.LIAB_ACCT_ID is '负债账户编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.OPEN_AMT is '开户金额';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.OLD_ACCT_ID is '旧账户编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.INT_PAYBL_SUBJ_ID is '应付利息科目编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.INT_PAYBL_ADJ_SUBJ_ID is '应付利息调整科目编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.INT_EXPNS_SUBJ_ID is '利息支出科目编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.INT_EXPNS_ADJ_SUBJ_ID is '利息支出调整科目编号';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.CURRT_INT_PAYBL_ADJ is '当期应付利息调整';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.TD_INT_EXPNS is '当日利息支出';
comment on column ${msl_schema}.msl_edw_cmm_e_acct_info.TD_INT_EXPNS_ADJ is '当日利息支出调整';
