CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_CORP_CUST_BASIC_INFO(I_P_DATE IN INTEGER,
                                                               O_ERRCODE  OUT VARCHAR2)
/**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_CORP_CUST_BASIC_INFO
  *  功能描述：对公客户基本信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_CORP_CUST_BASIC_INFO
  *  目标表： O_ICL_CMM_CORP_CUST_BASIC_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20221615           修改参数
  ***************************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_CORP_CUST_BASIC_INFO'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE; -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'O_ICL_CMM_CORP_CUST_BASIC_INFO'; --表名
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_CORP_CUST_BASIC_INFO T
   --WHERE T.ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD');
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_CORP_CUST_BASIC_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,
                V_SYSTEM,
                V_PROC_NAME,
                V_STARTTIME,
                V_ENDTIME,
                V_STEP,
                V_STEP_DESC,
                V_SQLCOUNT,
                O_ERRCODE,
                V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-对公客户基本信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO
    (ETL_DT,
     LP_ID,
     CUST_ID,
     CUST_NAME,
     CUST_EN_NAME,
     CUST_KIND_CD,
     OPEN_ACCT_DT,
     BELONG_ORG_ID,
     OPEN_ACCT_ORG_ID,
     OPEN_ACCT_TELLER_ID,
     OPEN_ACCT_CHN_CD,
     CREATE_CHN_CD,
     CUST_MGR_ID,
     CUST_TYPE_CD,
     CRDT_CUST_TYPE_CD,
     CUST_LEV_CD,
     DEPOSITR_CATE_CD,
     BAL_PAY_WAY_CD,
     CUST_STATUS_CD,
     CORP_ANL_INCO,
     CORP_YEAR_BUS_LMT,
     CORP_FOUND_DT,
     CORP_SIZE_CD,
     INDUS_CATEGY_CD,
     INDUS_TYPE_CD,
     INDUS_TYPE_CD_CRDTC,
     PHONE_CRDTC,
     CORP_TYPE_CD,
     CTY_RG_CD,
     RG_CD,
     ECON_CHAR_CD,
     ECON_TYPE_CD,
     ORGNZ_CD,
     ORGNZ_TYPE_CD,
     NATNAL_ECON_DEPT_TYPE_CD,
     INDUS_LEVEL5_CLS_CD,
     INDUS_CRDT_RATING_CD,
     SOCI_CRDT_CD,
     BUS_LICS_NUM,
     BUS_LICS_EXP_DT,
     NATION_TAX_RGST_CERT_NUM,
     LOCAL_TAX_RGST_CERT_NUM,
     FIN_LICS_NUM,
     PBC_PAY_BANK_NO,
     ECON_ORGNZ_FORM_CD,
     LOAN_CARD_NO,
     STOCK_CD,
     OPER_RANGE,
     EMPLY_QTTY,
     CURR_CD,
     RGST_CAP,
     RGST_ADDR,
     RGST_DT,
     RGSTION_CD,
     MANG_FIELD_PROP_CD,
     CORP_RGSTION_TYPE,
     PAID_IN_CAPITAL,
     PAID_IN_CAPITAL_CURR_CD,
     INVTOR_CTY_CD,
     MANG_FIELD_AREA,
     ASSET_TOT,
     NET_ASSET_TOT,
     SINGLE_LP_FLG,
     HIGH_NEW_TECH_CORP_FLG,
     RELA_PARTY_FLG,
     RELA_GROUP_TYPE_CD,
     LP_ORG_NAME,
     LP_ORG_TYPE_CD,
     LP_ORG_CUST_ID,
     GROUP_CUST_FLG,
     CBRC_SB_FLG,
     LABOR_INTE_FLG,
     HOLD_TYPE_CD,
     OFF_SHORE_CUST_FLG,
     PRIT_ETP_FLG,
     CTYSD_CORP_FLG,
     CORP_GROW_STAGE_CD,
     LIST_CORP_TYPE_CD,
     STRATE_NEW_INDUS_CLS_CD,
     LIST_CORP_FLG,
     STRTG_CUST_FLG,
     OPEN_CAP,
     CRDT_CUST_FLG,
     STAMENT_FLG,
     TAX_ORG_CATE_CD,
     TAX_RESDNT_CTY_CD,
     TAX_RESDNT_IDTI_CD,
     BASIC_ACCT_OPEN_BANK_NAME,
     BASIC_ACCT_ACCT_NUM,
     TAX_NUM,
     TAX_NUM_NULL_RS_DESCB,
     BEL_THI_FLG,
     TRAST_TAX_REGI_CERT_FLG,
     CTY_KEY_ENTERP_FLG,
     GROUP_CORP_FLG,
     GROUP_CUST_ID,
     GROUP_PARENT_CORP_ID,
     LMT_OR_ENCRGE_INDUS_CD,
     HAVE_BOD_FLG,
     GREEN_CRDT_CUST_FLG,
     GREEN_CRDT_CLS_CD,
     SCI_TECH_CORP_CLS_CD,
     SCI_TECH_CORP_IDTFY_DT,
     EDU_HEA_FLG,
     INC_FLG,
     ARAF_FLG,
     IS_MX_MGMT_RIGH_FLG,
     ESCP_DEBT_CORP_FLG,
     IS_MX_OPER_ITEM_FLG,
     RESDNT_FLG,
     DOM_OVERS_FLG,
     WORK_ADDR,
     WORK_ADDR_ZIP_CD,
     POSTA_ADDR,
     POSTA_ADDR_ZIP_CD,
     PROD_MANG_ADDR,
     PROD_MANG_ADDR_ZIP_CD,
     MANG_SITE_CD,
     CRDT_CUST_RISK_RATING_CD,
     CRDT_CUST_RISK_RATING_START_DT,
     CRDT_CUST_RISK_RATING_EXP_DT,
     OWNSP_TYPE_CD,
     CORP_CLOSE_FLG,
     GOVER_FIN_PLAT_FLG,
     SHORT_CHECK_BLKLIST_FLG,
     FIR_LON_DT,
     ORGNZ_SURVIV_STATUS_CD,
     CORP_IDTI_IDF_TYPE_CD,
     MAJOR_CONTRIOR_CNT,
     ACTL_CTRLER_CNT,
     FIN_DEPT_PHONE,
     JOB_CD

     )
    SELECT

     ETL_DT,
     LP_ID,
     CUST_ID,
     CUST_NAME,
     CUST_EN_NAME,
     CUST_KIND_CD,
     OPEN_ACCT_DT,
     BELONG_ORG_ID,
     OPEN_ACCT_ORG_ID,
     OPEN_ACCT_TELLER_ID,
     OPEN_ACCT_CHN_CD,
     CREATE_CHN_CD,
     CUST_MGR_ID,
     CUST_TYPE_CD,
     CRDT_CUST_TYPE_CD,
     CUST_LEV_CD,
     DEPOSITR_CATE_CD,
     BAL_PAY_WAY_CD,
     CUST_STATUS_CD,
     CORP_ANL_INCO,
     CORP_YEAR_BUS_LMT,
     CORP_FOUND_DT,
     CORP_SIZE_CD,
     INDUS_CATEGY_CD,
     INDUS_TYPE_CD,
     INDUS_TYPE_CD_CRDTC,
     PHONE_CRDTC,
     CORP_TYPE_CD,
     CTY_RG_CD,
     RG_CD,
     ECON_CHAR_CD,
     ECON_TYPE_CD,
     ORGNZ_CD,
     ORGNZ_TYPE_CD,
     NATNAL_ECON_DEPT_TYPE_CD,
     INDUS_LEVEL5_CLS_CD,
     INDUS_CRDT_RATING_CD,
     SOCI_CRDT_CD,
     BUS_LICS_NUM,
     BUS_LICS_EXP_DT,
     NATION_TAX_RGST_CERT_NUM,
     LOCAL_TAX_RGST_CERT_NUM,
     FIN_LICS_NUM,
     PBC_PAY_BANK_NO,
     ECON_ORGNZ_FORM_CD,
     LOAN_CARD_NO,
     STOCK_CD,
     OPER_RANGE,
     EMPLY_QTTY,
     CURR_CD,
     RGST_CAP,
     RGST_ADDR,
     RGST_DT,
     RGSTION_CD,
     MANG_FIELD_PROP_CD,
     CORP_RGSTION_TYPE,
     PAID_IN_CAPITAL,
     PAID_IN_CAPITAL_CURR_CD,
     INVTOR_CTY_CD,
     MANG_FIELD_AREA,
     ASSET_TOT,
     NET_ASSET_TOT,
     SINGLE_LP_FLG,
     HIGH_NEW_TECH_CORP_FLG,
     RELA_PARTY_FLG,
     RELA_GROUP_TYPE_CD,
     LP_ORG_NAME,
     LP_ORG_TYPE_CD,
     LP_ORG_CUST_ID,
     GROUP_CUST_FLG,
     CBRC_SB_FLG,
     LABOR_INTE_FLG,
     HOLD_TYPE_CD,
     OFF_SHORE_CUST_FLG,
     PRIT_ETP_FLG,
     CTYSD_CORP_FLG,
     CORP_GROW_STAGE_CD,
     LIST_CORP_TYPE_CD,
     STRATE_NEW_INDUS_CLS_CD,
     LIST_CORP_FLG,
     STRTG_CUST_FLG,
     OPEN_CAP,
     CRDT_CUST_FLG,
     STAMENT_FLG,
     TAX_ORG_CATE_CD,
     TAX_RESDNT_CTY_CD,
     TAX_RESDNT_IDTI_CD,
     BASIC_ACCT_OPEN_BANK_NAME,
     BASIC_ACCT_ACCT_NUM,
     TAX_NUM,
     TAX_NUM_NULL_RS_DESCB,
     BEL_THI_FLG,
     TRAST_TAX_REGI_CERT_FLG,
     CTY_KEY_ENTERP_FLG,
     GROUP_CORP_FLG,
     GROUP_CUST_ID,
     GROUP_PARENT_CORP_ID,
     LMT_OR_ENCRGE_INDUS_CD,
     HAVE_BOD_FLG,
     GREEN_CRDT_CUST_FLG,
     GREEN_CRDT_CLS_CD,
     SCI_TECH_CORP_CLS_CD,
     SCI_TECH_CORP_IDTFY_DT,
     EDU_HEA_FLG,
     INC_FLG,
     ARAF_FLG,
     IS_MX_MGMT_RIGH_FLG,
     ESCP_DEBT_CORP_FLG,
     IS_MX_OPER_ITEM_FLG,
     RESDNT_FLG,
     DOM_OVERS_FLG,
     WORK_ADDR,
     WORK_ADDR_ZIP_CD,
     POSTA_ADDR,
     POSTA_ADDR_ZIP_CD,
     PROD_MANG_ADDR,
     PROD_MANG_ADDR_ZIP_CD,
     MANG_SITE_CD,
     CRDT_CUST_RISK_RATING_CD,
     CRDT_CUST_RISK_RATING_START_DT,
     CRDT_CUST_RISK_RATING_EXP_DT,
     OWNSP_TYPE_CD,
     CORP_CLOSE_FLG,
     GOVER_FIN_PLAT_FLG,
     SHORT_CHECK_BLKLIST_FLG,
     FIR_LON_DT,
     ORGNZ_SURVIV_STATUS_CD,
     CORP_IDTI_IDF_TYPE_CD,
     MAJOR_CONTRIOR_CNT,
     ACTL_CTRLER_CNT,
     FIN_DEPT_PHONE,
     JOB_CD

      FROM ICL.V_CMM_CORP_CUST_BASIC_INFO@LINK_SIT2 --视图-对公客户基本信息
         WHERE ETL_DT =TO_DATE(V_P_DATE,'YYYYMMDD')/*BETWEEN TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1--上月末
        AND TO_DATE(V_P_DATE,'YYYYMMDD')*/ --跑批日
     ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;

  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,
                V_SYSTEM,
                V_PROC_NAME,
                V_STARTTIME,
                V_ENDTIME,
                V_STEP,
                V_STEP_DESC,
                V_SQLCOUNT,
                O_ERRCODE,
                '');

  -- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE   := '1';
    V_ENDTIME   := SYSDATE;
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,
                  V_SYSTEM,
                  V_PROC_NAME,
                  V_STARTTIME,
                  V_ENDTIME,
                  V_STEP,
                  V_STEP_DESC,
                  V_SQLCOUNT,
                  O_ERRCODE,
                  V_SQLMSG);

END ETL_INIT_O_ICL_CMM_CORP_CUST_BASIC_INFO;
/

