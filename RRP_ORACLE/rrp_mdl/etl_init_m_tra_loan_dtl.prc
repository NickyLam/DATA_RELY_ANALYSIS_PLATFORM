CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_TRA_LOAN_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_TRA_LOAN_DTL
  *  功能描述：
  *  追数范围：'零售贷款收回','对公贷款收回','联合网贷放款','联合网贷收回','联合网贷核销'
  *  创建日期：20220526
  *  开发人员：mw
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_DATE      DATE;      --数据日期(判断输入参数日期格式是否准确)
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_TRA_LOAN_DTL'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_TAB_NAME VARCHAR2(100) := 'M_TRA_LOAN_DTL'; --表名
  V_PART_NAME VARCHAR2(100);
  RERUN_DATE  CHAR(8);       --重跑日期
BEGIN
  /*判断传入日期参数是否正确*/
  IF I_P_DATE IS NOT NULL THEN
    V_DATE := TO_DATE(I_P_DATE, 'YYYYMMDD');
  END IF;
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_TRA_LOAN_DTL'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  RERUN_DATE :=  SUBSTR(V_P_DATE,0,6)||'01';
    -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--
 EXECUTE IMMEDIATE ('   alter session enable parallel dml');
 WHILE TO_DATE(RERUN_DATE,'YYYYMMDD') <= TO_DATE(RERUN_DATE,'YYYYMMDD')
  LOOP
  -- 分区表清数处理 --
  V_STEP := 2;
  V_STEP_DESC := '清除数据';
  V_STARTTIME := SYSDATE;

  ETL_PARTITION_ADD(RERUN_DATE,V_TAB_NAME, '1', O_ERRCODE);

  V_STEP := 3; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '信贷账户交易流水--将主账户和内部户账户汇总1';
  V_STARTTIME := SYSDATE;

  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_LOAN_DTL_TEMP01';
  COMMIT;

  INSERT /*+ append  parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP01
    (CUST_ACCT_ID,             --账户编号
     CUST_ACCT_NAME ,          --账户户名
     ACCT_BELONG_ORG_ID,       --账户所属机构
     ORG_ID1,                  --账户所属机构映射报送机构
     FIN_INST_CODE,            --银行机构代码
     FIN_LICS_NUM,             --金融许可证号
     ORG_NAME,                 --银行机构名称
     COUNTY_CD,                --机构地区
     PBC_PAY_BANK_NO           --人行支付行号
     )
   SELECT A.CUST_ACCT_ID,             --账户编号
          A.CUST_ACCT_NAME ,          --账户户名
          NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID)) ACCT_BELONG_ORG_ID,       --账户所属机构
          C.ORG_ID,                   --账户所属机构映射报送机构
          C.FIN_INST_CODE,            --银行机构代码
          C.FIN_LICS_NUM,             --金融许可证号
          C.ORG_NAME,                 --银行机构名称
          COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) COUNTY_CD --机构地区
          ,C.PBC_PAY_BANK_NO          --人行支付行号
     FROM (--modify by tangan at 20230111  新核心跟旧核心主张户存储方式有变化，以前有卡有折的账户，会卡和折各一条，新核心是账号放折号，卡号放卡号，只有一条数据，数仓CMM_DEP_ACCT_INFO模型新增了字段【CUST_ACCT_CARD_NO-客户账户卡号】用来存放卡号。有卡有折的情况CUST_ACCT_ID-放的是折号，CUST_ACCT_CARD_NO-放的是卡号。
          SELECT T.CUST_ACCT_ID,MAX(T.CUST_ACCT_NAME) AS CUST_ACCT_NAME,MAX(ACCT_BELONG_ORG_ID) ACCT_BELONG_ORG_ID,MAX(OPEN_ACCT_ORG_ID) OPEN_ACCT_ORG_ID
          FROM (
          SELECT CUST_ACCT_ID,CUST_ACCT_NAME,ACCT_BELONG_ORG_ID,OPEN_ACCT_ORG_ID FROM ICL.V_CMM_DEP_CUST_ACCT_INFO WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND TRIM(CUST_ACCT_ID) IS NOT NULL
          UNION ALL
          SELECT CUST_ACCT_CARD_NO AS CUST_ACCT_ID,CUST_ACCT_NAME,ACCT_BELONG_ORG_ID,OPEN_ACCT_ORG_ID FROM ICL.V_CMM_DEP_CUST_ACCT_INFO WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND TRIM(CUST_ACCT_CARD_NO) IS NOT NULL
          ) T
          GROUP BY T.CUST_ACCT_ID
     ) A
     LEFT JOIN ICL.V_CMM_INTNAL_ORG_INFO C--内部机构信息表
       ON C.ORG_ID =  NVL(TRIM(A.ACCT_BELONG_ORG_ID),TRIM(A.OPEN_ACCT_ORG_ID))
      AND C.ETL_DT = V_DATE
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
  --记录正常日志
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '信贷账户交易流水--将主账户和内部户账户汇总2';
  V_STARTTIME := SYSDATE;
  INSERT /*+ append   parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP01
    (CUST_ACCT_ID,             --账户编号
     CUST_ACCT_NAME ,          --账户户名
     ACCT_BELONG_ORG_ID,       --账户所属机构
     ORG_ID1,                  --账户所属机构映射报送机构
     FIN_INST_CODE,            --银行机构代码
     FIN_LICS_NUM,             --金融许可证号
     ORG_NAME,                 --银行机构名称
     COUNTY_CD,                --机构地区
     PBC_PAY_BANK_NO           --人行支付行号
     )
   SELECT /*A.MAIN_ACCT_ID*/A.ACCT_ID AS CUST_ACCT_ID,  --账户编号 --MODIFY BY HULJ 20221021
          A.ACCT_NAME  AS CUST_ACCT_NAME,            --账户户名
          TRIM(A.BELONG_ORG_ID) ACCT_BELONG_ORG_ID,  --账户所属机构
          B.ORG_ID1,                                 --账户所属机构映射报送机构
          B.FIN_INST_CODE,                           --银行机构代码
          B.FIN_LICS_NUM,                            --金融许可证号
          B.ORG_NAME,                 --银行机构名称
          COALESCE(TRIM(C.COUNTY_CD),TRIM(C.CITY_CD),TRIM(C.PROV_CD)) COUNTY_CD --机构地区
          ,C.PBC_PAY_BANK_NO                         --人行支付行号
     FROM ICL.V_CMM_INTNAL_ACCT A --内部账户
     LEFT JOIN RRP_MDL.ORG_CONFIG B --机构配置表
       ON B.ORG_ID = TRIM(A.BELONG_ORG_ID)
     LEFT JOIN ICL.V_CMM_INTNAL_ORG_INFO C--内部机构信息表
       ON C.ORG_ID = B.ORG_ID1
      AND C.ETL_DT = V_DATE
    WHERE A.ETL_DT = V_DATE;

   V_SQLCOUNT := SQL%ROWCOUNT;
   COMMIT;
  --记录正常日志
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
  --记录正常日志
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


    V_STEP := 5;
  V_STEP_DESC := '信贷账户交易流水--贷款收回';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_LOAN_DTL_TEMP02';
  INSERT/*+ append  parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,       --数据来源
     REPAY_PERDS,    --还款期数
     DTL_SEQ_NUM,    --交易序号
     AMT_TYPE,       --金额类型
     REPAY_TYPE,     --还款类型代码
     STD_PROD_ID,    --标准产品编号
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID,      --成交单编号
     CALLBK_RS       --回款原因
     )
  SELECT V_P_DATE                                 AS DATA_DT,        --数据日期
         T1.LP_ID                                 AS LGL_REP_ID,     --法人编号
         T1.TRAN_ORG_ID                           AS TRA_ORG_ID,     --交易机构编号
         T2.ADVISE_ODD_NO                         AS TRA_SEQ_NO,     --交易流水号
         T2.ACCT_ID                               AS ACC_ID,         --账户编号
         T1.CUST_ID                               AS CUST_ID,        --客户编号
         CASE WHEN T3.DUBIL_NUM IS NOT NULL THEN T3.CONT_ID --对私
              WHEN T5.DUBIL_NUM IS NOT NULL THEN T5.CONT_ID --对公
          END                                     AS CONT_ID,        --合同编号
         CASE WHEN T3.DUBIL_NUM IS NOT NULL THEN '1' --对私
              WHEN T5.DUBIL_NUM IS NOT NULL THEN '2' --对公
          END                                     AS CORP_IND_FLG,   --对公对私标志
         NVL(T3.ACCT_INSTIT_ID,T5.ACCT_INSTIT_ID) AS ORG_ID,         --机构编号
         NVL(T3.SUBJ_ID,T5.SUBJ_ID)               AS SUBJ_ID,        --科目编号
         NVL(T3.DUBIL_NUM,T5.DUBIL_NUM)           AS RCPT_ID,        --借据编号
         --T1.CUST_ID                               AS CUST_NM,        --客户名称
         NVL(T3.ACCT_NAME,T5.ACCT_NAME)           AS CUST_NM,        --客户名称
         CASE WHEN T2.AMT_TYPE_CD IN ('PRI') THEN '12'   --贷款还本
              WHEN T2.AMT_TYPE_CD IN ('INT') THEN '13'   --贷款还息
              ELSE '99'
          END                                     AS TRA_TYP,        --交易类型 D0121
         'C'                                      AS TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         T2.CALLBK_PRIC                           AS TRA_AMT,        --交易金额
         NVL(T3.PRIC_BAL,T5.PRIC_BAL)             AS ACC_BAL,        --账户余额
         CASE WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_NUM) IS NOT NULL  --平安普惠
              THEN TB.FINAL_ENTY_C_NUM
              ELSE NVL(TRIM(T4.ENTER_ACCT_ID),T5.LOAN_DISTR_ACCT_NUM)
         END                                      AS OPP_ACC,        --对方账号
         CASE WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_NAME) IS NOT NULL  --平安普惠
              THEN TB.FINAL_ENTY_C_NAME
              ELSE NVL(T7.CUST_ACCT_NAME,T11.CUST_ACCT_NAME)
         END                                      AS OPP_ACC_NM,     --对方户名
         CASE WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NUM) IS NOT NULL  --平安普惠
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NUM
              WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTER_CLEAR_BK_NO) IS NOT NULL  --平安普惠
              THEN TB.FINAL_ENTER_CLEAR_BK_NO
              ELSE NVL(T7.PBC_PAY_BANK_NO,T11.PBC_PAY_BANK_NO)
         END                                      AS OPP_PBC_NO,     --对方行号
         CASE WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NAME) IS NOT NULL  --平安普惠
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NAME
              WHEN T3.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TC.SYS_PRTCPTR_BIGAMT_BANK_NAME) IS NOT NULL  --平安普惠
              THEN TRIM(TC.SYS_PRTCPTR_BIGAMT_BANK_NAME)
              ELSE NVL(T7.ORG_NAME,T11.ORG_NAME)
         END                                      AS OPP_BANK_NM,    --对方行名
         T9.CHN_ID                                AS TRA_CHAN,       --交易渠道
         DECODE(T1.CURR_CD,'-',NVL(T3.CURR_CD,T5.CURR_CD),T1.CURR_CD) AS CUR,            --币种
         '贷款回收-'||T10.CD_DESCB                AS ABSTR,          --摘要
         '1'                                      AS FLUSH_PATCH_FLG,--冲补抹标志 D0128 1-正常 2-冲账 3-补账
         T1.TRAN_TELLER_ID                        AS TRA_TLR_NO,     --交易柜员号
         T1.ACCT_APV_TELLER_ID                    AS GRANT_TLR_NO,   --授权柜员号
         '2'                                      AS CASH_TRF_FLG,   --现转标志 2-转账
         NULL                                     AS AGT_NM,         --代办人姓名
         NULL                                     AS AGT_CRDL_TYP,   --代办人证件类型
         NULL                                     AS AGT_CRDL_NO,    --代办人证件号码
         NULL                                     AS BATCH_TRF_FLG,  --批量转让标志
         CASE WHEN T1.LOAN_REPAY_TYPE_CD IN( 'NS','PO')
              THEN T1.CALLBK_PRIC
              END                                 AS NORM_RETRV_AMT, --正常回收金额
         CASE WHEN T1.LOAN_REPAY_TYPE_CD = 'ER'
              THEN T1.CALLBK_PRIC
              END                                 AS ADV_REPY_AMT,   --提前还款金额
         CASE WHEN D.DUBIL_ID IS NOT NULL THEN 'B10'--核销后收回ADD20230203XUXIAOBIN
              WHEN T1.LOAN_REPAY_TYPE_CD IN ('NS','PO')
              THEN 'B01'
              WHEN T1.LOAN_REPAY_TYPE_CD = 'ER'
              THEN 'B02'
              END                                 AS DSTR_RETRV_TYP, --发放收回类型
         CASE WHEN T2.AMT_TYPE_CD IN ('PRI')
              THEN 'Y'
              ELSE 'N'
              END                                  AS PRIN_TRA_FLG,   --本金交易标志
         T1.TRAN_TM                                AS TRA_TM,         --交易时间
         TO_CHAR(T1.LOAN_REPAY_DT,'YYYYMMDD')     AS TRA_DT,         --交易日期
         NULL                                     AS LOAN_CHG_TYP,   --贷款变动类型
         CASE WHEN T3.DUBIL_NUM IS NOT NULL
              THEN '800924'   /*零售信贷部(普惠金融部)*/
              ELSE '800919'   /*风险管理部*/
              END                                      AS DEPT_LINE,      --部门条线
         CASE WHEN T3.DUBIL_NUM IS NOT NULL
              THEN '零售贷款收回'
              ELSE '对公贷款收回'
              END                                  AS DATA_SRC,        --数据来源
         T2.CURR_PD                               AS REPAY_PERDS,     --还款期数
         T1.EVT_ID                                AS DTL_SEQ_NUM,     --交易序号
         T2.AMT_TYPE_CD                           AS AMT_TYPE,        --金额类型
         T1.LOAN_REPAY_TYPE_CD                    AS REPAY_TYPE,      --还款类型代码
         NVL(T3.STD_PROD_ID,T5.STD_PROD_ID)       AS STD_PROD_ID,     --标准产品编号
         NULL                                     AS DISCNT_INT_RAT,  --贴现利率
         NULL                                     AS CTR_NT_ID,       --成交单编号
         T1.CALLBK_RS                             AS CALLBK_RS        --回款原因
    FROM IML.V_EVT_REPAY_FLOW T1   --还款流水
   INNER JOIN IML.V_EVT_REPAY_DTL T2  --还款明细
      ON T2.EVT_ID = T1.EVT_ID
    LEFT JOIN ICL.V_CMM_RETL_LOAN_ACCT_INFO T3  --零售贷款账户信息
      ON T3.ACCT_ID = T2.ACCT_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_RETL_LOAN_CONT_INFO T4 --零售贷款合同信息
      ON T4.CONT_ID = T3.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN IML.V_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H TB --贷款合同个人贷款附属信息历史 --MODIFY BY TANGAN AT 20230111 取助贷的入账和出账账号
      ON TB.CONT_ID = T3.CONT_ID
     AND TB.START_DT <= TO_DATE(RERUN_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(RERUN_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TC --ADD BY LIP 20230530 互联网贷款取合同登记的还款账号
      ON TC.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(TB.FINAL_ENTER_CLEAR_BK_NO)
     AND TC.RANK_RN = 1
     --AND TC.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_CORP_LOAN_ACCT_INFO T5 --对公贷款账户信息
      ON T5.ACCT_ID = T2.ACCT_ID
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_CORP_LOAN_CONT_INFO T6 --对公贷款合同信息
      ON T6.CONT_ID = T5.CONT_ID
     AND T6.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN M_TRA_LOAN_DTL_TEMP01 T7  --主账户和内部户账户汇总临时表
      ON T7.CUST_ACCT_ID = NVL(TRIM(T4.ENTER_ACCT_ID),T5.LOAN_DISTR_ACCT_NUM)
    LEFT JOIN M_TRA_LOAN_DTL_TEMP01 T11 --主账户和内部户账户汇总临时表 助贷
      ON T11.CUST_ACCT_ID = TB.FINAL_ENTY_C_NUM
    LEFT JOIN (SELECT ACCT_ID,MAX(CHN_ID) CHN_ID
                FROM O_IML_EVT_LOAN_FIN_TRAN_FLOW A --贷款金融交易流水
               WHERE A.ETL_DT = TO_DATE(RERUN_DATE,'YYYYMMDD')
               GROUP BY ACCT_ID) T9
      ON T9.ACCT_ID = T2.ACCT_ID
    LEFT JOIN O_IML_REF_PUB_CD T10 --公共代码表 取还款备注
      ON T10.CD_VAL = T2.AMT_TYPE_CD
     AND T10.CD_ID = 'CD2558'
    LEFT JOIN O_ICL_CMM_LOAN_WRT_OFF_INFO D  ---贷款核销信息表
      ON D.DUBIL_ID = NVL(T3.DUBIL_NUM,T5.DUBIL_NUM)
     AND D.FIR_WRT_OFF_DT <= T1.LOAN_REPAY_DT
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE T1.ETL_DT = TO_DATE(RERUN_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  --记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--贷款发放';
  V_STARTTIME := SYSDATE;
  INSERT/*+ append  parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,        --数据来源
     REPAY_PERDS,     --还款期数
     DTL_SEQ_NUM,     --交易序号
     AMT_TYPE,        --金额类型
     STD_PROD_ID,     --标准产品编号
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
     )
  SELECT V_P_DATE                                       DATA_DT,        --数据日期
         T1.LP_ID                                       LGL_REP_ID,     --法人编号
         T1.TRAN_ORG_ID                                 TRA_ORG_ID,     --交易机构编号
         T1.TRAN_FLOW_NUM                               TRA_SEQ_NO,     --交易流水号
         T1.ACCT_ID                                     ACC_ID,         --账户编号
         T1.CUST_ID                                     CUST_ID,        --客户编号
         NVL(T2.CONT_ID,T3.CONT_ID)                     CONT_ID,        --合同编号
         CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '1' --个人
              WHEN T3.DUBIL_NUM IS NOT NULL THEN '2' --对公
          END                                           CORP_IND_FLG,   --对公对私标志
         NVL(T2.ACCT_INSTIT_ID,T3.ACCT_INSTIT_ID)       ORG_ID,         --机构编号
         NVL(T2.SUBJ_ID,T3.SUBJ_ID)                     SUBJ_ID,        --科目编号
         NVL(T2.DUBIL_NUM,T3.DUBIL_NUM)                 RCPT_ID,        --借据编号
         T1.CUST_NAME                                   CUST_NM,        --客户名称
         '11'                                           TRA_TYP,        --交易类型 D0121 --11-贷款放款
         'D'                                            TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         T1.TRAN_AMT                                    TRA_AMT,        --交易金额
         T1.ACTL_BAL                                    ACC_BAL,        --账户余额
         CASE WHEN T2.STD_PROD_ID IN ('202020200005','202020200006') AND TRIM(T4.ENTER_ACCT_ID) IS NOT NULL --网商小贷 取合同栏位的账号
              THEN T4.ENTER_ACCT_ID
              WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_NUM) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_NUM
              WHEN T3.PROD_ID IN ('203020700002') THEN T3.LOAN_REPAY_NUM --MOD BY LIP 20230531 根据严希婧口径：出口代付取还款账号
              ELSE DECODE(T1.CNTPTY_ACCT_ID,'0',NVL(TRIM(T2.LOAN_DISTR_ACCT_NUM),TRIM(T3.LOAN_DISTR_ACCT_NUM)),T1.CNTPTY_ACCT_ID)
          END                                     AS OPP_ACC,        --对方账号
         CASE WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_NAME) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_NAME
              WHEN T3.PROD_ID IN ('203020700002') THEN T8.CUST_ACCT_NAME --MOD BY LIP 20230531 根据严希婧口径：出口代付取还款账号
              ELSE NVL(NVL(T1.CNTPTY_ACCT_NAME,T7.CUST_ACCT_NAME),T11.CUST_ACCT_NAME)
         END                                      AS OPP_ACC_NM,     --对方户名
         CASE WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NUM) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NUM
              WHEN T3.PROD_ID IN ('203020700002') THEN T8.PBC_PAY_BANK_NO --MOD BY LIP 20230531 根据严希婧口径：出口代付取还款账号
              ELSE NVL(NVL(T7.PBC_PAY_BANK_NO,T1.CNTPTY_BANK_NO),T11.PBC_PAY_BANK_NO)
         END                                      AS OPP_PBC_NO,     --对方行号
         CASE WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TB.FINAL_ENTY_C_OPEN_BANK_NAME) IS NOT NULL  --平安普惠 助贷产品
              THEN TB.FINAL_ENTY_C_OPEN_BANK_NAME
              WHEN T2.STD_PROD_ID IN ('202020200002','202010200005') AND TRIM(TC.SYS_PRTCPTR_BIGAMT_BANK_NAME) IS NOT NULL  --平安普惠 助贷产品
              THEN TC.SYS_PRTCPTR_BIGAMT_BANK_NAME
              WHEN T3.PROD_ID IN ('203020700002') THEN T8.ORG_NAME --MOD BY LIP 20230531 根据严希婧口径：出口代付取还款账号
              ELSE NVL(NVL(T1.CNTPTY_BANK_NAME,T7.ORG_NAME),T11.ORG_NAME)
         END                                      AS OPP_BANK_NM,    --对方行名
         /*modify by tangan at 20230111 调整助贷产品对手方信息逻辑 END*/
         T1.CHN_ID                                      TRA_CHAN,       --交易渠道 Z0014
         --T1.CURR_CD                                     CUR,            --币种
         DECODE(T1.CURR_CD,'-',NVL(T2.CURR_CD,T3.CURR_CD),T1.CURR_CD) CUR,            --币种
         T1.TRAN_MEMO_DESCB                             ABSTR,          --摘要
         '1'                                            FLUSH_PATCH_FLG,--冲补抹标志
         T1.TRAN_TELLER_ID                              TRA_TLR_NO,     --交易柜员号
         T1.CHECK_TELLER_ID                             GRANT_TLR_NO,   --授权柜员号
         '2'                                            CASH_TRF_FLG,   --现转标志
         NULL                                           AGT_NM,         --代办人姓名
         NULL                                           AGT_CRDL_TYP,   --代办人证件类型
         NULL                                           AGT_CRDL_NO,    --代办人证件号码
         NULL                                           BATCH_TRF_FLG,  --批量转让标志
         NULL                                           NORM_RETRV_AMT, --正常回收金额
         NULL                                           ADV_REPY_AMT,   --提前还款金额
         CASE WHEN NVL(T2.STD_PROD_ID,T3.STD_PROD_ID) IN  ('203010500001')  --法人透支
              THEN 'A03' --透支
              ELSE 'A01' --贷款发放
              END                                     DSTR_RETRV_TYP, --发放收回类型
         'Y'                                          PRIN_TRA_FLG,   --本金交易标志
         T1.TRAN_TM                                   TRA_TM,         --交易时间
         TO_CHAR(T1.TRAN_DT,'YYYYMMDD')         TRA_DT,         --交易日期
         NULL                                         LOAN_CHG_TYP,   --贷款变动类型
         CASE WHEN T2.DUBIL_NUM IS NOT NULL
              THEN '800924'   /*零售信贷部(普惠金融部)*/
              ELSE '800919'   /*风险管理部*/
              END                                         DEPT_LINE,      --部门条线
         CASE WHEN T2.DUBIL_NUM IS NOT NULL
              THEN '零售贷款放款'
              ELSE '对公贷款放款'
              END                                     DATA_SRC,        --数据来源
         NULL                                         REPAY_PERDS,     --还款期数
         T1.MAIN_TRAN_SEQ_NUM                         DTL_SEQ_NUM,     --交易序号
         'PRI'                                         AMT_TYPE,        --金额类型
         NVL(T2.STD_PROD_ID,T3.STD_PROD_ID)           STD_PROD_ID,     --标准产品编号
         NULL                                         DISCNT_INT_RAT,  --贴现利率
         NULL                                         CTR_NT_ID       --成交单编号
    FROM IML.V_EVT_LOAN_FIN_TRAN_FLOW T1 --贷款金融交易流水
    LEFT JOIN ICL.V_CMM_RETL_LOAN_ACCT_INFO T2 --零售贷款账户信息
      ON T2.ACCT_ID = T1.ACCT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_CORP_LOAN_ACCT_INFO T3 --对公贷款账户信息
      ON T3.ACCT_ID = T1.ACCT_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_RETL_LOAN_CONT_INFO T4 --零售贷款合同信息 --modify by tangan at 20230111
      ON T4.CONT_ID = T2.CONT_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN IML.V_AGT_LOAN_CONT_INDV_LOAN_ATTACH_INFO_H TB --贷款合同个人贷款附属信息历史 --MODIFY BY TANGAN AT 20230111 取助贷的入账和出账账号
      ON TB.CONT_ID = T3.CONT_ID
     AND TB.START_DT <= TO_DATE(RERUN_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(RERUN_DATE,'YYYYMMDD')
    LEFT JOIN M_TRA_LOAN_DTL_TEMP01 T7   --主账户和内部户账户汇总临时表 零售
      ON T7.CUST_ACCT_ID = NVL(TRIM(T2.LOAN_DISTR_ACCT_NUM),TRIM(T3.LOAN_DISTR_ACCT_NUM))
    LEFT JOIN M_TRA_LOAN_DTL_TEMP01 T11  --主账户和内部户账户汇总临时表 助贷
      ON T11.CUST_ACCT_ID = TB.FINAL_ENTY_C_NUM
    LEFT JOIN M_TRA_LOAN_DTL_TEMP01 T8   --主账户和内部户账户汇总临时表 出口代付
      ON T8.CUST_ACCT_ID = T3.LOAN_REPAY_NUM
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TC --ADD BY LIP 20230530 互联网贷款取合同登记的还款账号
      ON TC.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(TB.FINAL_ENTER_CLEAR_BK_NO)
     AND TC.RANK_RN = 1
   WHERE T1.EVT_CATE_ID = 'DRW'
     AND T1.ETL_DT = TO_DATE(RERUN_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  --记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--对公/零售贷款核销';
  V_STARTTIME := SYSDATE;
  INSERT/*+ append  parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,        --数据来源
     REPAY_PERDS,     --还款期数
     DTL_SEQ_NUM,     --交易序号
     AMT_TYPE,        --金额类型
     STD_PROD_ID,     --标准产品编号
     DISCNT_INT_RAT,  --贴现利率
     CTR_NT_ID        --成交单编号
    )
   WITH TMP_CMM_LOAN_WRT_OFF_INFO AS
   (SELECT A.DUBIL_ID,A.FIR_WRT_OFF_DT,A.LP_ID,A.FINAL_WRT_OFF_RETRA_DT,A.CURR_CD,
           A.CUST_ID,A.CONT_ID,A.APPL_TELLER_ID,A.STD_PROD_ID,A.TRAN_TIMESTAMP,
           CASE LVL WHEN 1 THEN 'PRI' --本金
                    WHEN 2 THEN 'INT' --利息
                    WHEN 3 THEN 'FEE' --费用
            END AS AMT_TYPE,
           CASE LVL WHEN 1 THEN ACTL_WRTOFF_LOAN_PRIC
                    WHEN 2 THEN ACTL_WRTOFF_IN_BS_INT+ACTL_WRTOFF_OFF_BS_INT
                    WHEN 3 THEN WRT_OFF_RETRA_ADVC_FEE
            END AS TRAN_AMT
      FROM O_ICL_CMM_LOAN_WRT_OFF_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 3 )
     WHERE A.FIR_WRT_OFF_DT = TO_DATE(RERUN_DATE,'YYYYMMDD')--mod by hulj 20230109
       AND A.ETL_DT = TO_DATE(RERUN_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                   DATA_DT,        --数据日期
         T1.LP_ID                                   LGL_REP_ID,     --法人编号
         NVL(T2.ACCT_INSTIT_ID,T3.ACCT_INSTIT_ID)   TRA_ORG_ID,     --交易机构编号
         V_P_DATE||T1.DUBIL_ID                      TRA_SEQ_NO,     --交易流水号
         NVL(T2.ACCT_ID,T3.ACCT_ID)                 ACC_ID,         --账户编号
         T1.CUST_ID                                 CUST_ID,        --客户编号
         T1.CONT_ID                                 CONT_ID,        --合同编号
         CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '1' --对私
              WHEN T3.DUBIL_NUM IS NOT NULL THEN '2' --对公
          END                                       CORP_IND_FLG,   --对公对私标志
         NVL(T2.ACCT_INSTIT_ID,T3.ACCT_INSTIT_ID)   ORG_ID,         --机构编号
         NVL(T2.SUBJ_ID,T3.SUBJ_ID)                 SUBJ_ID,        --科目编号
         T1.DUBIL_ID                                RCPT_ID,        --借据编号
         --NVL(T2.CUST_ID,T3.CUST_ID)                 CUST_NM,        --客户名称
         NVL(T2.ACCT_NAME,T3.ACCT_NAME)             CUST_NM,        --客户名称
         CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12'   --贷款还本
              WHEN T1.AMT_TYPE IN ('INT') THEN '13'   --贷款还息
              ELSE '99'
          END                                       TRA_TYP,        --交易类型 D0121
         'C'                                        TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         T1.TRAN_AMT                                TRA_AMT,        --交易金额
         0                                          ACC_BAL,        --账户余额
         NULL                                       OPP_ACC,        --对方账号
         NULL                                       OPP_ACC_NM,     --对方户名
         NULL                                       OPP_PBC_NO,     --对方行号
         NULL                                       OPP_BANK_NM,    --对方行名
         '999996'                                   TRA_CHAN,       --交易渠道 其他-核销
         DECODE(T1.CURR_CD,'-',T2.CURR_CD,T1.CURR_CD) CUR,            --币种
         '核销'                                     ABSTR,          --摘要
         '1'                                        FLUSH_PATCH_FLG,--冲补抹标志
         T1.APPL_TELLER_ID                          TRA_TLR_NO,     --交易柜员号
         NULL                                       GRANT_TLR_NO,   --授权柜员号
         '2'                                        CASH_TRF_FLG,   --现转标志
         NULL                                       AGT_NM,         --代办人姓名
         NULL                                       AGT_CRDL_TYP,   --代办人证件类型
         NULL                                       AGT_CRDL_NO,    --代办人证件号码
         NULL                                       BATCH_TRF_FLG,  --批量转让标志
         NULL                                       NORM_RETRV_AMT, --正常回收金额
         NULL                                       ADV_REPY_AMT,   --提前还款金额
         'B03'                                      DSTR_RETRV_TYP, --发放收回类型
         NULL                                       PRIN_TRA_FLG,   --本金交易标志
         --T1.FIR_WRT_OFF_DT                          TRA_TM,         --交易时间
         T1.TRAN_TIMESTAMP                          TRA_TM,         --交易时间
         TO_CHAR(T1.FIR_WRT_OFF_DT,'YYYYMMDD')      TRA_DT,         --交易日期
         NULL                                       LOAN_CHG_TYP,   --贷款变动类型
         CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '800924'   /*零售信贷部(普惠金融部)*/
              WHEN T3.DUBIL_NUM IS NOT NULL THEN '800919'   /*风险管理部*/
              ELSE '贷款核销'
          END                                       DEPT_LINE,      --部门条线
         CASE WHEN T2.DUBIL_NUM IS NOT NULL THEN '零售贷款核销'
              WHEN T3.DUBIL_NUM IS NOT NULL THEN '对公贷款核销'
              ELSE '贷款核销'
          END                                       DATA_SRC,        --数据来源
         '1'                                        REPAY_PERDS,     --还款期数
         'CNCL'||CASE T1.AMT_TYPE WHEN 'PRI' THEN '01'
                                  WHEN 'INT' THEN '02'
                                  WHEN 'FEE' THEN '03'
          END                                       DTL_SEQ_NUM,     --交易序号
         T1.AMT_TYPE                                AMT_TYPE,        --金额类型
         T1.STD_PROD_ID                             STD_PROD_ID,     --标准产品编号
         NULL                                       DISCNT_INT_RAT,  --贴现利率
         NULL                                       CTR_NT_ID        --成交单编号
    FROM TMP_CMM_LOAN_WRT_OFF_INFO T1 --贷款核销信息
    LEFT JOIN O_ICL_CMM_RETL_LOAN_ACCT_INFO T2 --零售贷款账户信息
      ON T2.DUBIL_NUM = T1.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN O_ICL_CMM_CORP_LOAN_ACCT_INFO T3 --对公贷款账户信息
      ON T3.DUBIL_NUM = T1.DUBIL_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  --记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--零售贷款转让';
  V_STARTTIME := SYSDATE;
  INSERT/*+ append  parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,        --数据来源
     REPAY_PERDS,     --还款期数
     DTL_SEQ_NUM,     --交易序号
     AMT_TYPE,        --金额类型
     STD_PROD_ID,     --标准产品编号
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
     )
   WITH CMM_RETL_LOAN_ACCT_INFO AS
   (SELECT A.DUBIL_NUM,A.CURR_CD,A.LP_ID,A.ACCT_INSTIT_ID,A.ACCT_ID,A.CUST_ID,A.CONT_ID,A.SUBJ_ID,A.CURRT_BAL,
           A.STD_PROD_ID,A.ASSET_TRAN_DT,A.ACCT_NAME,
           CASE LVL WHEN 1 THEN 'PRI' --本金
                    WHEN 2 THEN 'INT'    --利息
           END AS AMT_TYPE,
          CASE LVL WHEN 1 THEN PRIC_BAL
                   WHEN 2 THEN IN_BS_INT+OFF_BS_INT
           END AS TRAN_AMT
     FROM ICL.V_CMM_RETL_LOAN_ACCT_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <=2)
    WHERE A.ASSET_TRAN_DT = TO_DATE(RERUN_DATE,'YYYYMMDD')
      AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                         DATA_DT,        --数据日期
         T1.LP_ID                         LGL_REP_ID,     --法人编号
         T1.ACCT_INSTIT_ID                TRA_ORG_ID,     --交易机构编号
         T1.DUBIL_NUM                     TRA_SEQ_NO,     --交易流水号
         T1.ACCT_ID                       ACC_ID,         --账户编号
         T1.CUST_ID                       CUST_ID,        --客户编号
         T1.CONT_ID                       CONT_ID,        --合同编号
         '2'                              CORP_IND_FLG,   --对公对私标志
         T1.ACCT_INSTIT_ID                ORG_ID,         --机构编号
         T1.SUBJ_ID                       SUBJ_ID,        --科目编号
         T1.DUBIL_NUM                     RCPT_ID,        --借据编号
         --T1.CUST_ID                       CUST_NM,        --客户名称
         T1.ACCT_NAME                     CUST_NM,        --客户名称
         CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12'   --贷款还本
              WHEN T1.AMT_TYPE IN ('INT') THEN '13'   --贷款还息
              ELSE '99'
          END                             TRA_TYP,        --交易类型 D0121
         'C'                              TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         T1.TRAN_AMT                      TRA_AMT,        --交易金额
         T1.CURRT_BAL                     ACC_BAL,        --账户余额
         T2.CNTPTY_ACCT_NUM               OPP_ACC,        --对方账号
         T2.CNTPTY_NAME                   OPP_ACC_NM,     --对方户名
         T2.CNTPTY_OPEN_BANK_NAME         OPP_PBC_NO,     --对方行号
         T3.CUST_NAME                     OPP_BANK_NM,    --对方行名
         '999013'                         TRA_CHAN,       --交易渠道 Z0014
         T1.CURR_CD                       CUR,            --币种
         '零售贷款-转让'                  ABSTR,          --摘要
         '1'                              FLUSH_PATCH_FLG,--冲补抹标志
         T4.CUST_MGR_ID                   TRA_TLR_NO,     --交易柜员号
         T4.CUST_MGR_ID                   GRANT_TLR_NO,   --授权柜员号
         '2'                              CASH_TRF_FLG,   --现转标志
         NULL                             AGT_NM,         --代办人姓名
         NULL                             AGT_CRDL_TYP,   --代办人证件类型
         NULL                             AGT_CRDL_NO,    --代办人证件号码
         NULL                             BATCH_TRF_FLG,  --批量转让标志
         NULL                             NORM_RETRV_AMT, --正常回收金额
         NULL                             ADV_REPY_AMT,   --提前还款金额
         'B06'                            DSTR_RETRV_TYP, --发放收回类型
         CASE WHEN T1.AMT_TYPE IN ('PRI') THEN 'Y'
              ELSE 'N'
          END                             PRIN_TRA_FLG,   --本金交易标志
         --T1.ASSET_TRAN_DT                 TRA_TM,         --交易时间
         TO_DATE(TRIM(SUBSTR(T6.TRAN_TIMESTAMP,1,19)),'YYYY-MM-DD HH24:MI:SS') TRA_TM,         --交易时间
         TO_CHAR(T1.ASSET_TRAN_DT,'YYYYMMDD') TRA_DT,         --交易日期
         NULL                             LOAN_CHG_TYP,   --贷款变动类型
         '800924'                         DEPT_LINE,      --部门条线/*零售信贷部(普惠金融部)*/
         '零售贷款转让'                   DATA_SRC,        --数据来源
         '1'                              REPAY_PERDS,     --还款期数
         'ZR'||CASE WHEN T1.AMT_TYPE = 'PRI' THEN '1'
                    WHEN T1.AMT_TYPE = 'INT' THEN '2'
                END                       DTL_SEQ_NUM,     --交易序号
         T1.AMT_TYPE                      AMT_TYPE,        --金额类型
         T1.STD_PROD_ID                   STD_PROD_ID,     --标准产品编号
         NULL                             DISCNT_INT_RAT,  --贴现利率
         NULL                             CTR_NT_ID        --成交单编号
    FROM CMM_RETL_LOAN_ACCT_INFO T1 --零售贷款账户信息
   INNER JOIN ICL.V_CMM_ABS_BASE_ASSET_INFO T5--资产证券化基础资产信息
      ON T5.DUBIL_ID = T1.DUBIL_NUM
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN ICL.V_CMM_ASSET_SECU_TRAN_CONT_INFO T2 --资产证券化转让合同信息
      --ON T2.CONT_ID = T1.CONT_ID
      ON T2.CONT_ID = T5.CONT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO T3 --对公客户信息表
      ON TRIM(T3.PBC_PAY_BANK_NO) = TRIM(T2.CNTPTY_OPEN_BANK_NAME)
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN ICL.V_CMM_RETL_LOAN_DUBIL_INFO T4 --零售贷款借据信息
      ON T4.DUBIL_ID = T1.DUBIL_NUM
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN IOL.V_NCBS_CL_TRANSFER_DETAIL T6--资产转让合同明细表
      ON T6.INTERNAL_KEY = T1.ACCT_ID
     AND T6.START_DT <= TO_DATE(RERUN_DATE,'YYYYMMDD')
     AND T6.END_DT > TO_DATE(RERUN_DATE,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  --记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--对公贷款转让';
  V_STARTTIME := SYSDATE;
  INSERT /*+ append  parallel */INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,        --数据来源
     REPAY_PERDS,     --还款期数
     DTL_SEQ_NUM,     --交易序号
     AMT_TYPE,        --金额类型
     STD_PROD_ID,     --标准产品编号
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
     )
   WITH CMM_CORP_LOAN_ACCT_INFO AS
   (SELECT A.DUBIL_NUM,A.CURR_CD,A.LP_ID,A.ACCT_INSTIT_ID,A.ACCT_ID,A.CUST_ID,A.CONT_ID,A.SUBJ_ID,A.CURRT_BAL,
           A.STD_PROD_ID,A.ASSET_TRAN_DT,A.ACCT_NAME,
           CASE LVL WHEN 1 THEN 'PRI' --本金
                    WHEN 2 THEN 'INT'    --利息
           END AS AMT_TYPE,
          CASE LVL WHEN 1 THEN PRIC_BAL
                   WHEN 2 THEN IN_BS_INT+OFF_BS_INT
           END AS TRAN_AMT
     FROM ICL.V_CMM_CORP_LOAN_ACCT_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <=2)
    WHERE A.ASSET_TRAN_DT = TO_DATE(RERUN_DATE,'YYYYMMDD')
      AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                         DATA_DT,        --数据日期
         T1.LP_ID                         LGL_REP_ID,     --法人编号
         T1.ACCT_INSTIT_ID                TRA_ORG_ID,     --交易机构编号
         T1.DUBIL_NUM                     TRA_SEQ_NO,     --交易流水号
         T1.ACCT_ID                       ACC_ID,         --账户编号
         T1.CUST_ID                       CUST_ID,        --客户编号
         T1.CONT_ID                       CONT_ID,        --合同编号
         '2'                              CORP_IND_FLG,   --对公对私标志
         T1.ACCT_INSTIT_ID                ORG_ID,         --机构编号
         T1.SUBJ_ID                       SUBJ_ID,        --科目编号
         T1.DUBIL_NUM                     RCPT_ID,        --借据编号
         --T1.CUST_ID                       CUST_NM,        --客户名称
         T1.ACCT_NAME                     CUST_NM,        --客户名称
         CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12'   --贷款还本
              WHEN T1.AMT_TYPE IN ('INT') THEN '13'   --贷款还息
              ELSE '99'
          END                             TRA_TYP,        --交易类型 D0121
         'C'                              TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         T1.TRAN_AMT                      TRA_AMT,        --交易金额
         T1.CURRT_BAL                     ACC_BAL,        --账户余额
         T2.CNTPTY_ACCT_NUM               OPP_ACC,        --对方账号
         T2.CNTPTY_NAME                   OPP_ACC_NM,     --对方户名
         T2.CNTPTY_OPEN_BANK_NAME         OPP_PBC_NO,     --对方行号
         T3.CUST_NAME                     OPP_BANK_NM,    --对方行名
         '999013'                         TRA_CHAN,       --交易渠道 Z0014
         T1.CURR_CD                       CUR,            --币种
         '对公贷款-转让'                   ABSTR,          --摘要
         '1'                              FLUSH_PATCH_FLG,--冲补抹标志
         T4.RGST_TELLER_ID                TRA_TLR_NO,     --交易柜员号
         T4.RGST_TELLER_ID                GRANT_TLR_NO,   --授权柜员号
         '2'                              CASH_TRF_FLG,   --现转标志
         NULL                             AGT_NM,         --代办人姓名
         NULL                             AGT_CRDL_TYP,   --代办人证件类型
         NULL                             AGT_CRDL_NO,    --代办人证件号码
         NULL                             BATCH_TRF_FLG,  --批量转让标志
         NULL                             NORM_RETRV_AMT, --正常回收金额
         NULL                             ADV_REPY_AMT,   --提前还款金额
         'B06'                            DSTR_RETRV_TYP, --发放收回类型
         CASE WHEN T1.AMT_TYPE IN ('PRI') THEN 'Y'
              ELSE 'N'
          END                             PRIN_TRA_FLG,   --本金交易标志
         --T1.ASSET_TRAN_DT                 TRA_TM,         --交易时间
         TO_DATE(TRIM(SUBSTR(T6.TRAN_TIMESTAMP,1,19)),'YYYY-MM-DD HH24:MI:SS') TRA_TM,         --交易时间
         TO_CHAR(T1.ASSET_TRAN_DT,'YYYYMMDD') TRA_DT,         --交易日期
         NULL                             LOAN_CHG_TYP,   --贷款变动类型
         '800919'                         DEPT_LINE,      --部门条线/*风险管理部*/
         '对公贷款转让'                   DATA_SRC,        --数据来源
         '1'                              REPAY_PERDS,     --还款期数
         'ZR'||CASE WHEN T1.AMT_TYPE = 'PRI' THEN '1'
                    WHEN T1.AMT_TYPE = 'INT' THEN '2'
                END                       DTL_SEQ_NUM,     --交易序号
         T1.AMT_TYPE                      AMT_TYPE,        --金额类型
         T1.STD_PROD_ID                   STD_PROD_ID,     --标准产品编号
         NULL                             DISCNT_INT_RAT,  --贴现利率
         NULL                             CTR_NT_ID        --成交单编号
    FROM CMM_CORP_LOAN_ACCT_INFO T1 --对公贷款账户信息
   INNER JOIN ICL.V_CMM_ABS_BASE_ASSET_INFO T5--资产证券化基础资产信息
      ON T5.DUBIL_ID = T1.DUBIL_NUM
     AND T5.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN ICL.V_CMM_ASSET_SECU_TRAN_CONT_INFO T2 --资产证券化转让合同信息
      --ON T2.CONT_ID = T1.CONT_ID
      ON T2.CONT_ID = T5.CONT_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO T3 --对公客户信息表
      ON TRIM(T3.PBC_PAY_BANK_NO) = TRIM(T2.CNTPTY_OPEN_BANK_NAME)
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN IOL.V_NCBS_CL_TRANSFER_DETAIL T6--资产转让合同明细表
      ON T6.INTERNAL_KEY = T1.ACCT_ID
     AND T6.START_DT <= TO_DATE(RERUN_DATE,'YYYYMMDD')
     AND T6.END_DT > TO_DATE(RERUN_DATE,'YYYYMMDD')
   INNER JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO T4 --对公贷款借据信息
      ON T4.DUBIL_ID = T1.DUBIL_NUM
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  --记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--联合网贷--放款';
  V_STARTTIME := SYSDATE;
  INSERT/*+ append  parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02 NOLOGGING
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,       --数据来源
     CRN_PRD_ACCRD_INT,  --当期应计利息
     CRN_PRD_REPY_PNY_INT,  --当期还款罚息
     CRN_PRD_REPY_CP_INT,  --当期还款复息
     REPAY_PERDS,          --还款期数
     DTL_SEQ_NUM,     --交易序号
     STD_PROD_ID,     --标准产品编号
     DISCNT_INT_RAT,  --贴现利率
     CTR_NT_ID,        --成交单编号
     AMT_TYPE          --金额类型
     )
  SELECT V_P_DATE                                                 DATA_DT,        --数据日期
         A.LP_ID                                                  LGL_REP_ID,     --法人编号
         A.OPEN_ACCT_ORG_ID                                       TRA_ORG_ID,     --交易机构编号
         A.DUBIL_ID                                               TRA_SEQ_NO,     --交易流水号
         A.DUBIL_ID                                               ACC_ID,         --账户编号
         A.CUST_ID                                                CUST_ID,        --客户编号
         A.DUBIL_ID                                               CONT_ID,        --合同编号
         '1'                                                      CORP_IND_FLG,   --对公对私标志
         A.ACCT_INSTIT_ID                                         ORG_ID,         --机构编号
         A.SUBJ_ID                                                SUBJ_ID,        --科目编号
         A.DUBIL_ID                                               RCPT_ID,        --借据编号
         C.CUST_NAME                                              CUST_NM,        --客户名称
         '11'                                                     TRA_TYP,        --交易类型 D0121
         'D'                                                      TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         A.DISTR_AMT                                              TRA_AMT,        --交易金额
         A.DISTR_AMT                                              ACC_BAL,        --账户余额
         /*NVL(TRIM(A.ENTER_ACCT_ACCT_NUM),A.REPAY_NUM)             OPP_ACC,        --对方账号
         C.CUST_NAME                                              OPP_ACC_NM,     --对方户名*/
         --MOD BY LIP 20230530 修改联合网贷的对手方信息
         CASE WHEN TRIM(D.RECVBL_ACCT_ID) IS NOT NULL
              THEN TRIM(D.RECVBL_ACCT_ID)
              WHEN TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL
              THEN TRIM(A.ENTER_ACCT_ACCT_NUM)
              ELSE A.REPAY_NUM
          END                                                     OPP_ACC,        --对方账号
         CASE WHEN TRIM(D.RECVBL_ACCT_ID) IS NOT NULL
              THEN TRIM(D.RECVBL_ACCT_NAME)
              ELSE C.CUST_NAME
          END                                                     OPP_ACC_NM,     --对方户名
         NULL                                                     OPP_PBC_NO,     --对方行号
         CASE WHEN A.PROD_ID IN ('202010100004') THEN '京东'
              WHEN A.PROD_ID IN ('202010100006','202010100008','202020100003') AND TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '微信'
              WHEN TRIM(A.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '支付宝'
          END                                                     OPP_BANK_NM,    --对方行名
         CASE WHEN A.PROD_ID IN ('202010100006','202010100008','202020100003') THEN '403011' --微信
              WHEN A.PROD_ID IN ('202010100004') THEN '403002' --京东
              ELSE '403001'--支付宝
          END                                                     TRA_CHAN,       --交易渠道 Z0014
         A.CURR_CD                                                CUR,            --币种
         '贷款发放'                                               ABSTR,          --摘要
         '1'                                                      FLUSH_PATCH_FLG,--冲补抹标志
         NULL                                                     TRA_TLR_NO,     --交易柜员号
         NULL                                                     GRANT_TLR_NO,   --授权柜员号
         '2'                                                      CASH_TRF_FLG,   --现转标志
         NULL                                                     AGT_NM,         --代办人姓名
         NULL                                                     AGT_CRDL_TYP,   --代办人证件类型
         NULL                                                     AGT_CRDL_NO,    --代办人证件号码
         NULL                                                     BATCH_TRF_FLG,  --批量转让标志
         NULL                                                     NORM_RETRV_AMT, --正常回收金额
         NULL                                                     ADV_REPY_AMT,   --提前还款金额
         'A01'                                                    DSTR_RETRV_TYP, --发放收回类型
         NULL                                                     PRIN_TRA_FLG,   --本金交易标志
         A.DISTR_DT                                               TRA_TM,         --交易时间
         TO_CHAR(A.DISTR_DT,'YYYYMMDD')                           TRA_DT,         --交易日期
         NULL                                                     LOAN_CHG_TYP,   --贷款变动类型
         '800924'                                                 DEPT_LINE,      --部门条线/*零售信贷部(普惠金融部)*/
         '联合网贷放款'                                           DATA_SRC,        --数据来源
         NULL                                                     CRN_PRD_ACCRD_INT,  --当期应计利息
         NULL                                                     CRN_PRD_REPY_PNY_INT,  --当期还款罚息
         NULL                                                     CRN_PRD_REPY_CP_INT,  --当期还款复息
         '1'                                                      REPAY_PERDS,           --还款期数
         '001'                                                    DTL_SEQ_NUM,          --交易序号
         A.STD_PROD_ID                                            STD_PROD_ID,          --标准产品编号
         NULL                                                     DISCNT_INT_RAT, --贴现利率
         NULL                                                     CTR_NT_ID,       --成交单编号
         'PRI'                                                    AMT_TYPE          --金额类型
    /*FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DISTR_DTL A  --联合网贷放款明细
    LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO B --联合网贷借据信息
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.ETL_DT = V_DATE*/
    FROM ICL.V_CMM_UNITE_WL_DUBIL_INFO  A
    LEFT JOIN RRP_MDL.O_ICL_CMM_INDV_CUST_BASIC_INFO C --个人客户基本信息
      ON C.CUST_ID = A.CUST_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN O_IML_AGT_MYLOAN_DUBIL D
      ON D.DUBIL_ID = A.DUBIL_ID
   WHERE A.DISTR_DT <= TO_DATE(RERUN_DATE||'235959','YYYYMMDD HH24:MI:SS') - 1
     AND A.DISTR_DT >= TO_DATE(RERUN_DATE||'000000','YYYYMMDD HH24:MI:SS') - 1
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  --记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--联合网贷--收回';
  V_STARTTIME := SYSDATE;
  INSERT/*+ append  parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,       --数据来源
     REPAY_PERDS,    --还款期数
     DTL_SEQ_NUM,    --交易序号
     AMT_TYPE,       --金额类型
     REPAY_TYPE,     --还款类型代码
     STD_PROD_ID,    --标准产品编号
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
     )
   WITH CMM_UNITE_WL_REPAY_DTL AS
   (SELECT A.DUBIL_ID,A.REPAY_DT,A.REPAY_FLOW_ID,A.REPAY_TYPE_CD,A.CURR_NOMAL_PRIC_BAL,A.CURR_CD,
           CASE LVL WHEN 1 THEN 'PRI' --本金
                    WHEN 2 THEN 'INT'    --利息
                    WHEN 3 THEN 'ODI'    --罚息
                    WHEN 4 THEN 'FEE'    --费用
            END AS AMT_TYPE,
           CASE LVL WHEN 1 THEN CURRT_REPAY_PRIC
                    WHEN 2 THEN CURR_REPAY_INT
                    WHEN 3 THEN CURRT_REPAY_PNLT
                    WHEN 4 THEN CURRT_REPAY_FEE
            END AS TRAN_AMT,
           ROW_NUMBER() OVER(PARTITION BY REPAY_FLOW_ID ORDER BY DUBIL_ID) AS RN
      FROM ICL.V_CMM_UNITE_WL_REPAY_DTL A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <=4)
     WHERE A.REPAY_DT <= TO_DATE(RERUN_DATE||'235959','YYYYMMDD HH24:MI:SS') - 1
       AND A.REPAY_DT >= TO_DATE(RERUN_DATE||'000000','YYYYMMDD HH24:MI:SS') - 1
       AND A.ETL_DT = TO_DATE(RERUN_DATE,'YYYYMMDD') - 1
     /*ORDER BY A.DUBIL_ID,A.REPAY_DT,A.REPAY_FLOW_ID*/)
  SELECT V_P_DATE                                   DATA_DT,        --数据日期
         T2.LP_ID                                   LGL_REP_ID,     --法人编号
         T2.OPEN_ACCT_ORG_ID                        TRA_ORG_ID,     --交易机构编号
         T1.REPAY_FLOW_ID || T1.RN                  TRA_SEQ_NO,     --交易流水号
         T1.DUBIL_ID                                ACC_ID,         --账户编号
         T2.CUST_ID                                 CUST_ID,        --客户编号
         T1.DUBIL_ID                                CONT_ID,        --合同编号
         '1'                                        CORP_IND_FLG,   --对公对私标志
         T2.ACCT_INSTIT_ID                          ORG_ID,         --机构编号
         T2.SUBJ_ID                                 SUBJ_ID,        --科目编号
         T1.DUBIL_ID                                RCPT_ID,        --借据编号
         T3.CUST_NAME                               CUST_NM,        --客户名称
         CASE WHEN T1.AMT_TYPE = 'PRI' THEN '12' --贷款还本
              WHEN T1.AMT_TYPE = 'INT' THEN '13' --贷款还息
              WHEN T1.AMT_TYPE = 'ODI' THEN '18' --贷款还罚息
              WHEN T1.AMT_TYPE = 'FEE' THEN '19' --费用
          END                                       TRA_TYP,        --交易类型 D0121
         'C'                                        TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         T1.TRAN_AMT                                TRA_AMT,        --交易金额
         --T1.CURR_NOMAL_PRIC_BAL                   ACC_BAL,        --账户余额
         /*MODIFY LHQ 20230112 零售和联合网贷口径的账户余额目前上游是没有实时借据的账户余额，
         所以取不到实时的账户余额 ,经咨询张家伟后，沿用生产口径*/
         T2.CURRT_BAL                               ACC_BAL,        --账户余额
         /*NVL(TRIM(T2.REPAY_NUM),T2.ENTER_ACCT_ACCT_NUM) OPP_ACC,        --对方账号
         T3.CUST_NAME                               OPP_ACC_NM,     --对方户名
         NULL                                       OPP_PBC_NO,     --对方行号
         CASE WHEN T2.PROD_ID IN ('202010100004') THEN '京东'
              WHEN T2.PROD_ID IN ('202010100006','202010100008','202020100003') AND TRIM(T2.ENTER_ACCT_ACCT_NUM) IS NOT NULL
              THEN '微信'
              WHEN TRIM(T2.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '支付宝'
          END                                       OPP_BANK_NM,    --对方行名*/
         CASE WHEN TRIM(T2.REPAY_NUM) IS NOT NULL THEN TRIM(T2.REPAY_NUM)
              ELSE TRIM(T2.ENTER_ACCT_ACCT_NUM)
          END                                       OPP_ACC,        --对方账号
         CASE WHEN T2.PROD_ID IN ('202020100001','202020200004') AND TRIM(T5.REPAY_ACCT_ID) IS NOT NULL
              THEN TRIM(T5.REPAY_ACCT_NAME) --网商贷的取借据表的还款账户名称
              WHEN T2.PROD_ID IN ('202010100006','202010100008','202020100003') AND TRIM(T8.APOT_REPAY_DEDUCT_ACCT_NUM) IS NOT NULL
              THEN TRIM(T8.APOT_REPAY_DEDUCT_ACCT_NAME) --微信取账户表的约定还款信息
              ELSE T3.CUST_NAME
          END                                       OPP_ACC_NM,     --对方户名
         CASE WHEN T2.PROD_ID IN ('202010100006','202010100008','202020100003') AND TRIM(T8.APOT_REPAY_DEDUCT_ACCT_NUM) IS NOT NULL
              THEN TRIM(T8.APOT_REPAY_OPEN_BANK_NUM) --微信取账户表的约定还款信息
          END                                       OPP_PBC_NO,     --对方行号
         CASE WHEN T2.PROD_ID IN ('202010100004') THEN '京东'
              WHEN T2.PROD_ID IN ('202010100006','202010100008','202020100003') AND TRIM(T8.APOT_REPAY_DEDUCT_ACCT_NUM) IS NOT NULL
              THEN NVL(TRIM(T8.APOT_REPAY_BANK_NAME),'微信') --微信取账户表的约定还款信息
              WHEN TRIM(T2.ENTER_ACCT_ACCT_NUM) IS NOT NULL THEN '支付宝'
          END                                       OPP_BANK_NM,    --对方行名
         CASE WHEN T2.PROD_ID IN ('202010100006','202010100008','202020100003') THEN '403011' --微信
              WHEN T2.PROD_ID IN ('202010100004') THEN '403002' --京东
              ELSE '403001'--支付宝
          END                                       TRA_CHAN,       --交易渠道 Z0014
         DECODE(T1.CURR_CD,'-',T2.CURR_CD,T1.CURR_CD) CUR,            --币种
         '贷款回收'||CASE T1.AMT_TYPE
                          WHEN 'PRI' THEN '本金'
                          WHEN 'INT' THEN '利息'
                          WHEN 'ODI' THEN '罚息'
                          WHEN 'FEE' THEN '费用'
                      END                           ABSTR,          --摘要
         '1'                                        FLUSH_PATCH_FLG,--冲补抹标志
         NULL                                       TRA_TLR_NO,     --交易柜员号
         NULL                                       GRANT_TLR_NO,   --授权柜员号
         '2'                                        CASH_TRF_FLG,   --现转标志
         NULL                                       AGT_NM,         --代办人姓名
         NULL                                       AGT_CRDL_TYP,   --代办人证件类型
         NULL                                       AGT_CRDL_NO,    --代办人证件号码
         NULL                                       BATCH_TRF_FLG,  --批量转让标志
         CASE WHEN T1.REPAY_TYPE_CD = '06' --CD2820
              THEN T1.TRAN_AMT
          END                                       NORM_RETRV_AMT, --正常回收金额
         CASE WHEN T1.REPAY_TYPE_CD = '07'
              THEN T1.TRAN_AMT
          END                                       ADV_REPY_AMT,   --提前还款金额
         CASE WHEN D.DUBIL_ID IS NOT NULL THEN 'B10'--核销后收回ADD20230203XUXIAOBIN
              WHEN T1.REPAY_TYPE_CD = '07' THEN 'B02' --提前还款
              ELSE 'B01'
          END                                       DSTR_RETRV_TYP, --发放收回类型
         CASE WHEN T1.AMT_TYPE = 'PRI' THEN 'Y'
              ELSE 'N'
          END                                       PRIN_TRA_FLG,   --本金交易标志
         T1.REPAY_DT                                TRA_TM,         --交易时间
         TO_CHAR(T1.REPAY_DT,'YYYYMMDD')            TRA_DT,         --交易日期
         NULL                                       LOAN_CHG_TYP,   --贷款变动类型
         '800924'                                   DEPT_LINE,      --部门条线/*零售信贷部(普惠金融部)*/
         '联合网贷收回'                             DATA_SRC,       --数据来源
         '1'                                        REPAY_PERDS,    --还款期数
         CASE WHEN T1.AMT_TYPE = 'PRI' THEN '1'
              WHEN T1.AMT_TYPE = 'INT' THEN '2'
              WHEN T1.AMT_TYPE = 'ODI' THEN '3'
              WHEN T1.AMT_TYPE = 'FEE' THEN '4'
              ELSE '9'
          END                                       DTL_SEQ_NUM,     --交易序号
         T1.AMT_TYPE                                AMT_TYPE,        --金额类型
         T1.REPAY_TYPE_CD                           REPAY_TYPE,      --还款类型代码
         T2.STD_PROD_ID                             STD_PROD_ID,     --标准产品编号
         NULL                                       DISCNT_INT_RAT,  --贴现利率
         NULL                                       CTR_NT_ID        --成交单编号
    FROM CMM_UNITE_WL_REPAY_DTL T1    --联合网贷还款明细
    LEFT JOIN ICL.V_CMM_UNITE_WL_DUBIL_INFO T2    --联合网贷借据信息
      ON T2.DUBIL_ID = T1.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_UNITE_WL_WRT_OFF_INFO D --联合网贷核销信息
      ON D.DUBIL_ID = T1.DUBIL_ID
     AND D.FIR_WRT_OFF_DT <= T1.REPAY_DT
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN ICL.V_CMM_INDV_CUST_BASIC_INFO T3 --个人客户基础信息
      ON T3.CUST_ID = T2.CUST_ID
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --ADD BY LIP 20230530 增加联合网贷还款账号取数口径
    LEFT JOIN O_IML_AGT_MYLOAN_DUBIL T5 --网商贷借据
      ON T5.DUBIL_ID = T2.DUBIL_ID
    LEFT JOIN IML.V_AGT_WLD_DUBIL_INFO T7    --微粒贷借据
      ON T7.DUBIL_ID = T2.DUBIL_ID
    LEFT JOIN IML.V_AGT_WLD_ACCT T8 --微粒贷账户
      ON T8.ACCT_ID = T7.ACCT_ID
     AND T8.ACCT_TYPE_CD = T7.ACCT_TYPE_CD
    LEFT JOIN ICL.V_CMM_STD_PROD_INFO T4    --标准产品信息表
      ON T4.PROD_ID = T2.STD_PROD_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  --记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--联合网贷核销';
  V_STARTTIME := SYSDATE;
  INSERT /*+ append  parallel */INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,        --数据来源
     REPAY_PERDS,     --还款期数
     DTL_SEQ_NUM,     --交易序号
     AMT_TYPE,        --金额类型
     STD_PROD_ID,     --标准产品编号
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
    )
   WITH CMM_UNITE_WL_WRT_OFF_INFO AS
   (SELECT A.DUBIL_ID,A.FIR_WRT_OFF_DT,A.LP_ID,A.FINAL_WRT_OFF_RETRA_DT,A.CURR_CD,
           A.CUST_ID,A.CONT_ID,A.APPL_TELLER_ID,A.STD_PROD_ID,
    CASE LVL WHEN 1 THEN 'PRI' --本金
             WHEN 2 THEN 'INT' --利息
             WHEN 3 THEN 'FEE' --费用
             END AS AMT_TYPE,
    CASE LVL WHEN 1 THEN ACTL_WRTOFF_LOAN_PRIC
             WHEN 2 THEN ACTL_WRTOFF_IN_BS_INT+ACTL_WRTOFF_OFF_BS_INT
             WHEN 3 THEN WRT_OFF_RETRA_ADVC_FEE
             END AS TRAN_AMT
   FROM ICL.V_CMM_UNITE_WL_WRT_OFF_INFO A,(SELECT LEVEL LVL FROM DUAL CONNECT BY LEVEL <= 3 )
   WHERE /*A.FIR_WRT_OFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1  --MOD BY HULJ 20230109
     AND*/ A.ETL_DT = TO_DATE(RERUN_DATE,'YYYYMMDD') - 1)
  SELECT V_P_DATE                     DATA_DT,        --数据日期
         T1.LP_ID                     LGL_REP_ID,     --法人编号
         T2.OPEN_ACCT_ORG_ID          TRA_ORG_ID,      --交易机构编号
         V_P_DATE||T1.DUBIL_ID        TRA_SEQ_NO,     --交易流水号
         T1.DUBIL_ID                  ACC_ID,         --账户编号
         T1.CUST_ID                   CUST_ID,        --客户编号
         T1.CONT_ID                   CONT_ID,        --合同编号
         '1'                          CORP_IND_FLG,   --对公对私标志
         T2.ACCT_INSTIT_ID            ORG_ID,         --机构编号
         T2.SUBJ_ID                   SUBJ_ID,        --科目编号
         T1.DUBIL_ID                  RCPT_ID,        --借据编号
         NULL                         CUST_NM,        --客户名称
         CASE WHEN T1.AMT_TYPE IN ('PRI') THEN '12'   --贷款还本
              WHEN T1.AMT_TYPE IN ('INT') THEN '13'   --贷款还息
              ELSE '99'
          END                         TRA_TYP,        --交易类型 D0121
         'C'                          TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         T1.TRAN_AMT                  TRA_AMT,        --交易金额
         0                            ACC_BAL,        --账户余额
         NULL                         OPP_ACC,        --对方账号
         NULL                         OPP_ACC_NM,     --对方户名
         NULL                         OPP_PBC_NO,     --对方行号
         NULL                         OPP_BANK_NM,    --对方行名
         '999996'                     TRA_CHAN,       --交易渠道 其他-核销
         DECODE(T1.CURR_CD,'-',T2.CURR_CD,T1.CURR_CD) CUR,            --币种
         '核销'                       ABSTR,          --摘要
         '1'                          FLUSH_PATCH_FLG,--冲补抹标志
         T1.APPL_TELLER_ID            TRA_TLR_NO,     --交易柜员号
         NULL                         GRANT_TLR_NO,   --授权柜员号
         '2'                          CASH_TRF_FLG,   --现转标志
         NULL                         AGT_NM,         --代办人姓名
         NULL                         AGT_CRDL_TYP,   --代办人证件类型
         NULL                         AGT_CRDL_NO,    --代办人证件号码
         NULL                         BATCH_TRF_FLG,  --批量转让标志
         NULL                         NORM_RETRV_AMT, --正常回收金额
         NULL                         ADV_REPY_AMT,   --提前还款金额
         'B03'                        DSTR_RETRV_TYP, --发放收回类型
         NULL                         PRIN_TRA_FLG,   --本金交易标志
         T1.FIR_WRT_OFF_DT            TRA_TM,         --交易时间
         TO_CHAR(T1.FIR_WRT_OFF_DT,'YYYYMMDD') TRA_DT,         --交易日期
         NULL                         LOAN_CHG_TYP,   --贷款变动类型
         '800924'                     DEPT_LINE,      --部门条线/*零售信贷部(普惠金融部)*/
         '联合网贷核销'               DATA_SRC,       --数据来源
         '1'                          REPAY_PERDS,    --还款期数
         'CNCL'||CASE T1.AMT_TYPE
                      WHEN 'PRI' THEN '01'
                      WHEN 'INT' THEN '02'
                      WHEN 'FEE' THEN '03'
                  END                 DTL_SEQ_NUM,     --交易序号
         T1.AMT_TYPE                  AMT_TYPE,        --金额类型
         T1.STD_PROD_ID               STD_PROD_ID,     --标准产品编号
         NULL                         DISCNT_INT_RAT, --贴现利率
         NULL                         CTR_NT_ID       --成交单编号
    FROM CMM_UNITE_WL_WRT_OFF_INFO T1 --联合网贷核销信息
    LEFT JOIN ICL.V_CMM_UNITE_WL_DUBIL_INFO T2 --联合网贷账户信息
      ON T1.DUBIL_ID = T2.DUBIL_ID
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE NVL(T1.TRAN_AMT,0) > 0
     AND T1.FIR_WRT_OFF_DT <= TO_DATE(RERUN_DATE||'235959','YYYYMMDD HH24:MI:SS') - 1
     AND T1.FIR_WRT_OFF_DT >= TO_DATE(RERUN_DATE||'000000','YYYYMMDD HH24:MI:SS') - 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--对公贷款贴现-买入';
  V_STARTTIME := SYSDATE;
  INSERT/*+ append  parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,       --数据来源
     REPAY_PERDS,    --还款期数
     DTL_SEQ_NUM,    --交易序号
     STD_PROD_ID,    --标准产品编号
     BILL_NUM,       --票据号码
     REL_ID,         --票据ID
     SYS_IN_FLG,     --系统内标识
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
    )
  SELECT  DISTINCT
          V_P_DATE      DATA_DT,        --数据日期
          A.LP_ID                      LGL_REP_ID,     --法人编号
          A.ENTER_ACCT_ORG_ID          TRA_ORG_ID,     --交易机构编号
          /*TRIM(B.OUT_ACCT_FLOW_NUM)||TO_CHAR(V_DATE,'YYYYMMDD')|| TRA_SEQ_NO,     --交易流水号*/
          B.DUBIL_ID                   TRA_SEQ_NO,     --交易流水号    --0906修改
          B.DUBIL_ID                   ACC_ID,         --账户编号
          A.CUST_ID                    CUST_ID,        --客户编号
          B.CONT_ID                    CONT_ID,        --合同编号
          '2'                          CORP_IND_FLG,   --对公对私标志
          A.ENTER_ACCT_ORG_ID          ORG_ID,         --机构编号
          A.SUBJ_ID                    SUBJ_ID,        --科目编号
          B.DUBIL_ID                   RCPT_ID,        --借据编号
          NULL                         CUST_NM,        --客户名称
          '11'                         TRA_TYP,        --交易类型 D0121
          'D'                          TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
          A.ACTL_AMT -A.BUYER_PAY_INT_AMT  TRA_AMT,        --交易金额
          A.CURRT_BAL                  ACC_BAL,        --账户余额
          /*NVL(TRIM(A.DISCNT_APPLIT_ACCT_NUM),TRIM(B.STL_ACCT_NUM))   OPP_ACC,        --对方账号
          NVL(TRIM(A.DSCNT_PROPS_NAME),TRIM(B.RECVBL_ACCT_NAME)) OPP_ACC_NM,     --对方户名
          TRIM(A.DISCNT_APPLIT_BANK_NO)   OPP_PBC_NO,     --对方行号
          --NVL(TRIM(A.DSCNT_PROPS_OPEN_BANK_NO),TRIM(B.RECVBL_BANK_NAME)) OPP_BANK_NM,    --对方行名
          NVL(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),TRIM(B.RECVBL_BANK_NAME)) OPP_BANK_NM,   --对方行名*/
          --MOD BY LIP 20230529 修改贴现买入的对手方信息
          COALESCE(TRIM(A.DSCNT_PROPS_ACCT_NUM),TRIM(A.DISCNT_APPLIT_ACCT_NUM),TRIM(B.STL_ACCT_NUM)) AS OPP_ACC,        --对方账号
          COALESCE(TRIM(A.DSCNT_PROPS_NAME),E.CUST_NAME,TRIM(B.RECVBL_ACCT_NAME)) AS OPP_ACC_NM,     --对方户名
          COALESCE(TRIM(A.DSCNT_PROPS_OPEN_BANK_NO),TRIM(A.DISCNT_APPLIT_BANK_NO)) AS OPP_PBC_NO,     --对方行号
          NVL(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),TRIM(B.RECVBL_BANK_NAME)) OPP_BANK_NM,   --对方行名
          '409020'                     TRA_CHAN,       --交易渠道 99-9020 其他-票据系统
          A.CURR_CD                    CUR,            --币种
          '票据贴现-买入'              ABSTR,          --摘要
          '1'                          FLUSH_PATCH_FLG,--冲补抹标志
          TRIM(A.CUST_MGR_ID)          TRA_TLR_NO,     --交易柜员号
          NULL                         GRANT_TLR_NO,   --授权柜员号
          '2'                          CASH_TRF_FLG,   --现转标志
          NULL                         AGT_NM,         --代办人姓名
          NULL                         AGT_CRDL_TYP,   --代办人证件类型
          NULL                         AGT_CRDL_NO,    --代办人证件号码
          NULL                         BATCH_TRF_FLG,  --批量转让标志
          NULL                         NORM_RETRV_AMT, --正常回收金额
          NULL                         ADV_REPY_AMT,   --提前还款金额
          'A04'                        DSTR_RETRV_TYP, --发放收回类型
          NULL                         PRIN_TRA_FLG,   --本金交易标志
          B.DISTR_DT                   TRA_TM,         --交易时间
          TO_CHAR(B.DISTR_DT,'YYYYMMDD') TRA_DT,         --交易日期
          NULL                         LOAN_CHG_TYP,   --贷款变动类型
         '800926'                      DEPT_LINE,      --部门条线/*公司银行总部*/
         '对公贷款贴现-买入'           DATA_SRC,        --数据来源
         '1'                           REPAY_PERDS,     --还款期数
         '1'                           DTL_SEQ_NUM,     --交易序号
         A.STD_PROD_ID                 STD_PROD_ID,      --标准产品编号
         A.BILL_NUM                    BILL_NUM,         --票据号码
         A.BILL_ID                     REL_ID,           --票据编号
         A.SYS_IN_FLG                  SYS_IN_FLG,     --系统内标识
         NULL                          DISCNT_INT_RAT, --贴现利率
         NULL                          CTR_NT_ID       --成交单编号
    FROM ICL.V_CMM_BILL_DISCNT_INFO A --票据贴现信息
   INNER JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)--20230424 XUXIAOBIN MODIFY
     AND B.STD_PROD_ID IN ('204010200001','204010200002')  --贴现
     AND B.ETL_DT = V_DATE
     AND TRIM(B.BILL_UNIQ_MARK_ID) IS NOT NULL
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TTA --票交所会员 只有一天数据
      ON TTA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.DISCNT_APPLIT_BANK_NO)
     AND TTA.RANK_RN = 1
    LEFT JOIN ICL.V_CMM_CORP_CUST_BASIC_INFO E --对公客户基本信息
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态  06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
     AND A.ENTRY_STATUS_CD = '03'
     AND B.DISTR_DT = TO_DATE(RERUN_DATE,'YYYYMMDD')--20230110XUXIAOBIN 注释 0930测试环境特殊处理，拿一整个月
     /*AND TRUNC(B.DISTR_DT,'MM')=TRUNC(DATE'2022-09-30','MM')*/
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--对公贷款贴现-结清';
  V_STARTTIME := SYSDATE;
  INSERT/*+ append  parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,       --数据来源
     REPAY_PERDS,    --还款期数
     DTL_SEQ_NUM,    --交易序号
     STD_PROD_ID,    --标准产品编号
     BILL_NUM,       --票据号码
     REL_ID,         --票据ID
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
    )
  SELECT  DISTINCT
          V_P_DATE      DATA_DT,        --数据日期
          A.LP_ID                      LGL_REP_ID,     --法人编号
          A.ENTER_ACCT_ORG_ID          TRA_ORG_ID,     --交易机构编号
          /*TRIM(B.OUT_ACCT_FLOW_NUM)||TO_CHAR(V_DATE,'YYYYMMDD')||*/B.DUBIL_ID  TRA_SEQ_NO,     --交易流水号    --0906修改
          B.DUBIL_ID                   ACC_ID,         --账户编号
          A.CUST_ID                    CUST_ID,        --客户编号
          B.CONT_ID                    CONT_ID,        --合同编号
          '2'                          CORP_IND_FLG,   --对公对私标志
          A.ENTER_ACCT_ORG_ID          ORG_ID,         --机构编号
          A.SUBJ_ID                    SUBJ_ID,        --科目编号
          B.DUBIL_ID                   RCPT_ID,        --借据编号
          NULL                         CUST_NM,        --客户名称
          '11'                         TRA_TYP,        --交易类型 D0121
          'C'                          TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
          B.DUBIL_AMT                  TRA_AMT,        --交易金额
          A.CURRT_BAL                  ACC_BAL,        --账户余额
          NVL(TRIM(A.DISCNT_APPLIT_ACCT_NUM),TRIM(B.STL_ACCT_NUM))   OPP_ACC,        --对方账号
          NVL(TRIM(A.DSCNT_PROPS_NAME),TRIM(B.RECVBL_ACCT_NAME)) OPP_ACC_NM,     --对方户名
          TRIM(A.DISCNT_APPLIT_BANK_NO)   OPP_PBC_NO,     --对方行号
          --NVL(TRIM(A.DSCNT_PROPS_OPEN_BANK_NO),TRIM(B.RECVBL_BANK_NAME)) OPP_BANK_NM,    --对方行名
          NVL(TRIM(TTA.SYS_PRTCPTR_BIGAMT_BANK_NAME),TRIM(B.RECVBL_BANK_NAME)) OPP_BANK_NM,   --对方行名
          '409020'                     TRA_CHAN,       --交易渠道 99-9020 其他-票据系统
          A.CURR_CD                    CUR,            --币种
          '票据贴现-结清'              ABSTR,          --摘要
          '1'                          FLUSH_PATCH_FLG,--冲补抹标志
          TRIM(A.CUST_MGR_ID)          TRA_TLR_NO,     --交易柜员号
          NULL                         GRANT_TLR_NO,   --授权柜员号
          '2'                          CASH_TRF_FLG,   --现转标志
          NULL                         AGT_NM,         --代办人姓名
          NULL                         AGT_CRDL_TYP,   --代办人证件类型
          NULL                         AGT_CRDL_NO,    --代办人证件号码
          NULL                         BATCH_TRF_FLG,  --批量转让标志
          NULL                         NORM_RETRV_AMT, --正常回收金额
          NULL                         ADV_REPY_AMT,   --提前还款金额
          'A04'                        DSTR_RETRV_TYP, --发放收回类型
          NULL                         PRIN_TRA_FLG,   --本金交易标志
          A.INT_ACCR_EXP_DT            TRA_TM,         --交易时间
          TO_CHAR(A.INT_ACCR_EXP_DT,'YYYYMMDD') TRA_DT,         --交易日期
          NULL                         LOAN_CHG_TYP,   --贷款变动类型
         '800926'                      DEPT_LINE,      --部门条线/*公司银行总部*/
         '对公贷款贴现-结清'            DATA_SRC,        --数据来源
         '1'                           REPAY_PERDS,     --还款期数
         '2'                           DTL_SEQ_NUM,     --交易序号
         A.STD_PROD_ID                 STD_PROD_ID,      --标准产品编号
         A.BILL_NUM                    BILL_NUM,         --票据号码
         A.BILL_ID                     REL_ID,          --票据ID
         NULL                          DISCNT_INT_RAT, --贴现利率
         NULL                          CTR_NT_ID       --成交单编号
    FROM ICL.V_CMM_BILL_DISCNT_INFO A --票据贴现信息
   INNER JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      --ON B.BILL_UNIQ_MARK_ID = A.BILL_ENTRY_ID
      ON B.BILL_UNIQ_MARK_ID = NVL(TRIM(A.BILL_ENTRY_ID),A.BILL_ID)--20230424 XUXIAOBIN MODIFY
     AND B.STD_PROD_ID IN ('204010200001','204010200002')  --贴现
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TRIM(B.BILL_UNIQ_MARK_ID) IS NOT NULL
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TTA --票交所会员 只有一天数据
      ON TTA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.DISCNT_APPLIT_BANK_NO)
     AND TTA.RANK_RN = 1
   WHERE A.DISCNT_STATUS_CD IN ('06') --新一代取的为买入明细状态  06为记账完成 A.DISCNT_STATUS_CD NOT IN ('012','001')
     AND A.ENTRY_STATUS_CD = '03'
     AND A.BILL_STATUS_CD IN ('42')
     AND A.INT_ACCR_EXP_DT = TO_DATE(RERUN_DATE,'YYYYMMDD')
     /*AND TRUNC(A.INT_ACCR_EXP_DT,'MM')=TRUNC(DATE'2022-09-30','MM')*/
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     ;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--买断式转贴现-买入卖出';
  V_STARTTIME := SYSDATE;
  INSERT /*+ append  parallel */INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,        --数据来源
     REPAY_PERDS,     --还款期数
     DTL_SEQ_NUM,     --交易序号
     STD_PROD_ID,      --标准产品编号
     BILL_NUM,         --票据号码
     REL_ID,          --关联编号
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
    )
  SELECT  DISTINCT
          V_P_DATE                     DATA_DT,        --数据日期
          A.LP_ID                      LGL_REP_ID,     --法人编号
          A.ACCT_INSTIT_ID             TRA_ORG_ID,     --交易机构编号
          /*TRIM(B.OUT_ACCT_FLOW_NUM)||TO_CHAR(A.STL_DT,'YYYYMMDD')||*/
          A.BATCH_ID||A.BILL_NUM TRA_SEQ_NO,     --交易流水号   --20230112修改
          B.DUBIL_ID                   ACC_ID,         --账户编号
          A.CNTPTY_ID                  CUST_ID,        --客户编号 --转贴、二级市场福费廷业务的借款人按照交易对手（同业）填报
          B.CONT_ID                    CONT_ID,        --合同编号
          '2'                          CORP_IND_FLG,   --对公对私标志
          A.ACCT_INSTIT_ID             ORG_ID,         --机构编号
          A.SUBJ_ID                    SUBJ_ID,        --科目编号
          B.DUBIL_ID                   RCPT_ID,        --借据编号
          NULL                         CUST_NM,        --客户名称
          '99-01'                      TRA_TYP,        --交易类型 D0121
          CASE WHEN A.TRAN_DIR_CD = '01' THEN 'D'
               ELSE 'C'
           END                         TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
          A.STL_AMT                    TRA_AMT,        --交易金额
          A.CURRT_BAL                  ACC_BAL,        --账户余额
          COALESCE(TRIM(A.CNTPTY_BANK_NO),TTB.MEM_ORG_CD) OPP_ACC,        --对方账号 --参考答疑口径二期740、704调整
          COALESCE(TRIM(A.CNTPTY_NAME),TTB.SYS_PRTCPTR_BIGAMT_BANK_NAME) OPP_ACC_NM,     --对方户名
          COALESCE(TRIM(A.CNTPTY_BANK_NO),TTB.MEM_ORG_CD) OPP_PBC_NO,     --对方行号
          --A.CNTPTY_NAME                OPP_BANK_NM,    --对方行名
          COALESCE(TRIM(A.CNTPTY_NAME),TTB.SYS_PRTCPTR_BIGAMT_BANK_NAME) OPP_BANK_NM,--对方行名
          '409995'                     TRA_CHAN,       --交易渠道 99-9020 其他-票据系统
          A.CURR_CD                    CUR,            --币种
          CASE WHEN A.TRAN_DIR_CD IN( '01') THEN '票据买断式转贴现-买入'
               WHEN A.TRAN_DIR_CD = '02' THEN  '票据买断式转贴现-卖出'
           END                         ABSTR,          --摘要
          '1'                          FLUSH_PATCH_FLG,--冲补抹标志
          TRIM(A.CUST_MGR_ID)          TRA_TLR_NO,     --交易柜员号
          NULL                         GRANT_TLR_NO,   --授权柜员号
          '2'                          CASH_TRF_FLG,   --现转标志
          NULL                         AGT_NM,         --代办人姓名
          NULL                         AGT_CRDL_TYP,   --代办人证件类型
          NULL                         AGT_CRDL_NO,    --代办人证件号码
          NULL                         BATCH_TRF_FLG,  --批量转让标志
          NULL                         NORM_RETRV_AMT, --正常回收金额
          NULL                         ADV_REPY_AMT,   --提前还款金额
          CASE WHEN A.TRAN_DIR_CD IN( '01') THEN 'A04'
               ELSE 'B99'
           END                         DSTR_RETRV_TYP, --发放收回类型
          NULL                         PRIN_TRA_FLG,   --本金交易标志
          A.BUS_DT                     TRA_TM,         --交易时间
          TO_CHAR(A.BUS_DT,'YYYYMMDD') TRA_DT,         --交易日期
          NULL                         LOAN_CHG_TYP,   --贷款变动类型
         '800935'                      DEPT_LINE,      --部门条线/*票据业务事业部*/
         CASE WHEN A.TRAN_DIR_CD IN( '01') THEN '买断式转贴现-买入'
              WHEN A.TRAN_DIR_CD = '02' THEN '买断式转贴现-卖出'
          END                          DATA_SRC,       --数据来源
         '1'                           REPAY_PERDS,    --还款期数
         CASE WHEN A.TRAN_DIR_CD IN( '01') THEN '1'
              WHEN A.TRAN_DIR_CD = '02' THEN '2'
          END                          DTL_SEQ_NUM,    --交易序号
         A.STD_PROD_ID                 STD_PROD_ID,     --标准产品编号
         A.BILL_NUM                    BILL_NUM,          --票据号码
         A.BATCH_ID||A.BILL_NUM        REL_ID,            --关联编号
         A.DISCNT_INT_RAT              DISCNT_INT_RAT,    --贴现利率
         A.CTR_NT_ID                   CTR_NT_ID          --成交单编号
    FROM ICL.V_CMM_BILL_DISCOUNT_INFO A --票据转贴现信息
    LEFT JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO B --对公贷款借据信息
      ON B.BILL_ID = A.BILL_ID
     AND B.STD_PROD_ID IN ('204010100001','204010100002')
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TTA --票交所会员 只有一天数据
      ON TTA.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(A.CNTPTY_BANK_NO)
     AND TTA.RANK_RN = 1
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 TTB --票交所会员 只有一天数据
      ON TTB.ORG_CN_ABBR = TRIM(A.CNTPTY_NAME)
     AND TTB.RANK_RN = 1
   WHERE A.TRAN_DIR_CD in ('01','02')  --买入
     AND A.BUS_TYPE_CD = 'BT01'  -- BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND A.ENTRY_STATUS_CD = '03'  --筛选记账成功的票据
     /*AND A.STL_DT <= V_DATE --当日记账的
     AND A.STL_DT >= V_MONTH_START_DATE*/
     AND A.BUS_DT  = TO_DATE(RERUN_DATE,'YYYYMMDD')
     /*AND TRUNC(A.BUS_DT,'MM')=TRUNC(DATE'2022-09-30','MM')*/
     AND A.SYS_IN_FLG='1'
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  --记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--对公贷款买断式贴现-结清';
  V_STARTTIME := SYSDATE;
  INSERT /*+ append  parallel */INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,       --数据来源
     REPAY_PERDS,    --还款期数
     DTL_SEQ_NUM,    --交易序号
     STD_PROD_ID,    --标准产品编号
     BILL_NUM,       --票据号码
     REL_ID,
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
    )
  SELECT  /*+USE_HASH(T1 T3 T4)*/
         V_P_DATE                                   AS DATA_DT,        --数据日期
         T1.LP_ID                                   AS LGL_REP_ID,     --法人编号
         T1.ORG_ID                                  AS TRA_ORG_ID,     --交易机构编号
         T2.BUS_ID                                  AS TRA_SEQ_NO,     --交易流水号
         T3.DUBIL_ID                                AS ACC_ID,         --账户编号
         T2.CNTPTY_ID                               AS CUST_ID,        --客户编号
         T3.CONT_ID                                 AS CONT_ID,        --合同编号
         '2'                                        AS CORP_IND_FLG,   --对公对私标志
         T2.ACCT_INSTIT_ID                          AS ORG_ID,         --机构编号
         T2.SUBJ_ID                                 AS SUBJ_ID,        --科目编号
         T3.DUBIL_ID                                AS RCPT_ID,        --借据编号
         T2.CNTPTY_NAME                             AS CUST_NM,        --客户名称
         '99-02'                                    AS TRA_TYP,        --交易类型 D0121
         'C'                                        AS TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         T1.FAC_VAL_AMT                             AS TRA_AMT,        --交易金额
         T2.CURRT_BAL                               AS ACC_BAL,        --账户余额
         /*TRIM(T4.DRAWER_ACCT_NUM)                   AS OPP_ACC,        --对方账号
         TRIM(T4.DRAWER_NAME)                       AS OPP_ACC_NM,     --对方户名
         TRIM(T4.DRAWER_OPEN_BANK_NO)               AS OPP_PBC_NO,     --对方行号
         TRIM(T4.DRAWER_OPEN_BANK_NAME)             AS OPP_BANK_NM,    --对方行名*/
         TRIM(T1.SUGST_PAYER_ORG_CD)                AS OPP_ACC,        --对方账号
         TRIM(T1.SUGST_PAYER_NAME)                  AS OPP_ACC_NM,     --对方户名
         TRIM(T1.SUGST_PAYER_OPEN_BANK_NUM)         AS OPP_PBC_NO,     --对方行号
         TRIM(T5.SYS_PRTCPTR_BIGAMT_BANK_NAME)      AS OPP_BANK_NM,    --对方行名
         '409020'                                   AS TRA_CHAN,       --交易渠道 Z0014
         T2.CURR_CD                                 AS CUR,            --币种
         '票据转贴现提示付款结清'                   AS ABSTR,          --摘要
         '1'                                        AS FLUSH_PATCH_FLG,--冲补抹标志
         TRIM(T1.MODIF_TELLER_ID)                   AS TRA_TLR_NO,     --交易柜员号
         NULL                                       AS GRANT_TLR_NO,   --授权柜员号
         '2'                                        AS CASH_TRF_FLG,   --现转标志
         NULL                                       AS AGT_NM,         --代办人姓名
         NULL                                       AS AGT_CRDL_TYP,   --代办人证件类型
         NULL                                       AS AGT_CRDL_NO,    --代办人证件号码
         NULL                                       AS BATCH_TRF_FLG,  --批量转让标志
         NULL                                       AS NORM_RETRV_AMT, --正常回收金额
         NULL                                       AS ADV_REPY_AMT,   --提前还款金额
         'B10'                                      AS DSTR_RETRV_TYP, --发放收回类型
         NULL                                       AS PRIN_TRA_FLG,   --本金交易标志
         T1.APPL_DT                                 AS TRA_TM,         --交易时间
         TO_CHAR(T1.APPL_DT,'YYYYMMDD')             AS TRA_DT,         --交易日期
         NULL                                       AS LOAN_CHG_TYP,   --贷款变动类型
         '800935'   /*票据业务事业部*/              AS DEPT_LINE,      --部门条线
         '票据转贴现提示付款'                        AS DATA_SRC,       --数据来源
         '1'                                        AS REPAY_PERDS,    --还款期数
         'TF'||'01'                                 AS DTL_SEQ_NUM,     --交易序号
         T2.STD_PROD_ID                             AS STD_PROD_ID,    --标准产品编号
         T2.BILL_NUM                                AS BILL_NUM,       --票据号码
         T2.BILL_ID                                 AS REL_ID,        --关联编号
         NULL                                       AS DISCNT_INT_RAT, --贴现利率
         NULL                                       AS CTR_NT_ID       --成交单编号
    FROM IML.V_EVT_SUGST_PAY_APPL_EVT T1 --提示付款申请事件
   INNER JOIN ICL.V_CMM_BILL_DISCOUNT_INFO T2 --票据转贴现信息
      ON T2.BILL_ID = T1.BILL_ID
     AND T2.ENTRY_STATUS_CD = '03' --记账成功 新票据
     AND T2.TRAN_DIR_CD = '01'
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN ICL.V_CMM_BILL_CENTER_INFO T4
      ON T4.BILL_ID = T2.BILL_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO T3
      ON T3.BILL_ID = T2.BILL_ID
     AND T3.STD_PROD_ID IN ('204010100001','204010100002') --新一代
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 T5
      ON T5.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(T1.SUGST_PAYER_OPEN_BANK_NUM)
     AND T5.RANK_RN = 1
   WHERE T1.APPL_TRAN_TYPE_CD = '01'
     AND T1.ENTRY_STATUS_CD = '03'
     AND T1.APPL_DT = TO_DATE(RERUN_DATE,'YYYYMMDD')
     AND T1.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') --20230113 手工注释，XUXIAOBIN 0930验证出数
     /*AND T1.APPL_DT >= TRUNC(TO_DATE('20220930','YYYYMMDD'),'MM')
     AND T1.APPL_DT <= TO_DATE('20220930','YYYYMMDD')*/
     ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--票据追索结清';
  V_STARTTIME := SYSDATE;
  INSERT/*+ append  parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,       --数据来源
     REPAY_PERDS,    --还款期数
     DTL_SEQ_NUM,    --交易序号
     STD_PROD_ID,    --标准产品编号
     BILL_NUM,       --票据号码
     SYS_IN_FLG,     --系统内标志
     REL_ID,         --票据ID
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
    )
  SELECT
     V_P_DATE         DATA_DT,        --数据日期
     T1.LP_ID         LGL_REP_ID,     --法人编号
     T1.BELONG_ORG_ID TRA_ORG_ID,     --交易机构编号
     T2.BUS_ID        TRA_SEQ_NO,     --交易流水号
     T3.DUBIL_ID      ACC_ID,         --账户编号
     T1.CUST_ID       CUST_ID,        --客户编号
     T3.CONT_ID       CONT_ID,        --合同编号
     '2'              CORP_IND_FLG,   --对公对私标志
     T1.BELONG_ORG_ID ORG_ID,         --机构编号
     T2.SUBJ_ID       SUBJ_ID,        --科目编号
     T3.DUBIL_ID      RCPT_ID,        --借据编号
     T1.CUST_ID       CUST_NM,        --客户名称
     '99-02'          TRA_TYP,        --交易类型 D0121
     'C'              TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     T3.DUBIL_AMT     TRA_AMT,        --交易金额
     T2.CURRT_BAL     ACC_BAL,        --账户余额
     NVL(TRIM(T2.DISCNT_APPLIT_ACCT_NUM),TRIM(T3.STL_ACCT_NUM))
                      OPP_ACC,        --对方账号
     NVL(TRIM(T2.DSCNT_PROPS_NAME),TRIM(T3.RECVBL_ACCT_NAME))
                      OPP_ACC_NM,     --对方户名
     TRIM(T2.DISCNT_APPLIT_BANK_NO)
                      OPP_PBC_NO,     --对方行号
     NVL(TRIM(T6.SYS_PRTCPTR_BIGAMT_BANK_NAME),TRIM(T3.RECVBL_BANK_NAME))
                      OPP_BANK_NM,    --对方行名
     '409020'         TRA_CHAN,       --交易渠道 Z0014
     T1.CURR_CD       CUR,            --币种
     '票据追索结清'    ABSTR,          --摘要
     '1'              FLUSH_PATCH_FLG,--冲补抹标志
     T2.CUST_MGR_ID   TRA_TLR_NO,     --交易柜员号
     NULL             GRANT_TLR_NO,   --授权柜员号
     '2'              CASH_TRF_FLG,   --现转标志
     NULL             AGT_NM,         --代办人姓名
     NULL             AGT_CRDL_TYP,   --代办人证件类型
     NULL             AGT_CRDL_NO,    --代办人证件号码
     NULL             BATCH_TRF_FLG,  --批量转让标志
     NULL             NORM_RETRV_AMT, --正常回收金额
     NULL             ADV_REPY_AMT,   --提前还款金额
     'B10'            DSTR_RETRV_TYP, --发放收回类型
     NULL             PRIN_TRA_FLG,   --本金交易标志
     T7.AGREE_PAYOFF_DT     TRA_TM,         --交易时间
     TO_CHAR(T7.AGREE_PAYOFF_DT,'YYYYMMDD')
                      TRA_DT,         --交易日期
     NULL             LOAN_CHG_TYP,   --贷款变动类型
     '800926'   /*公司银行总部*/ DEPT_LINE,      --部门条线
     '票据追索结清'    DATA_SRC,       --数据来源
     '1'              REPAY_PERDS,    --还款期数
     'ZS'||'01'       DTL_SEQ_NUM,    --交易序号
     T2.STD_PROD_ID   STD_PROD_ID,     --标准产品编号
     T1.BILL_NUM      BILL_NUM,         --票据号码
     T5.SYS_IN_FLG  ,      --系统内标志
     T2.BILL_ID       REL_ID,  --关联编号
     T2.DISCNT_INT_RAT
                      DISCNT_INT_RAT, --贴现利率
     NULL             CTR_NT_ID       --成交单编号
    FROM ICL.V_CMM_BILL_CENTER_INFO                        T1  --票据中心信息
    INNER JOIN ICL.V_CMM_BILL_DISCNT_INFO                  T2  --票据贴现信息
          ON  T2.BILL_ID = T1.BILL_ID
          AND T2.DISCNT_STATUS_CD NOT IN ('00','01','02')--UPD BY CG 经过咨询旭华，旧票据的001，012等未成功记账的码值都转为新票据的00失效了，只有记账成功等的转为新票据的06记账成功，新票据的都存在
          AND T2.ENTRY_STATUS_CD = '03'
          AND NVL(TRIM(T2.BILL_SUB_INTRV_ID),'-')=NVL(TRIM(T1.BILL_SUB_INTRV_ID),'-')
          AND T2.ETL_DT=T1.ETL_DT
    INNER JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO              T3  --对公贷款借据信息
          ON T1.BILL_NUM = T3.BILL_NUM
          --AND T2.BILL_ENTRY_ID = T3.BILL_UNIQ_MARK_ID
          AND NVL(T2.BILL_ENTRY_ID,T2.BILL_ID)= T3.BILL_UNIQ_MARK_ID --20230424 数仓陈伟锋反馈关联条件需调整
          AND TRIM(T3.BILL_UNIQ_MARK_ID) IS NOT NULL --20230424 需加非空
          AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO                T4 -- 对公贷款借据信息
          ON T4.ETL_DT = T2.ETL_DT
          AND T4.BILL_NUM=T2.BILL_NUM
    INNER JOIN ICL.V_CMM_BILL_DISCOUNT_INFO                T5 --票据转贴现信息
          ON T5.BILL_ID=T4.BILL_ID
          AND T5.ETL_DT=T4.ETL_DT
    INNER JOIN (SELECT T.*,ROW_NUMBER() OVER(PARTITION BY T.BILL_NUM ORDER BY T.AGREE_PAYOFF_DT DESC) RN
                 FROM IML.V_AGT_RECS_AGREE_PAYOFF_APPL_H T
                WHERE T.RECV_OPINION_TYPE_CD='SU00'--签收意见类型代码：SU00：同意签收 SU01拒绝签收 其它:未知
                  AND T.START_DT <= TO_DATE(RERUN_DATE,'YYYYMMDD')
                  AND T.END_DT > TO_DATE(RERUN_DATE,'YYYYMMDD')
                ) T7
          ON T7.BILL_NUM=T1.BILL_NUM AND T7.RN = 1

    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 T6 --票交所会员 只有一天数据
      ON T6.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(T2.DISCNT_APPLIT_BANK_NO)
     AND T6.RANK_RN = 1
   WHERE T1.RECS_FLG='1' --追索标志
      AND T1.BILL_STATUS_CD IN('56','42')--56追索已结清  42托收已收回
      /*AND TRUNC(T4.PAYOFF_DT,'MM')=TRUNC(DATE'2022-09-30','MM')*/
      AND T4.PAYOFF_DT = TO_DATE(RERUN_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--转贴追索数据_IMAS';
  V_STARTTIME := SYSDATE;
  INSERT/*+ append  parallel */ INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,       --数据来源
     REPAY_PERDS,    --还款期数
     DTL_SEQ_NUM,    --交易序号
     STD_PROD_ID,    --标准产品编号
     BILL_NUM,       --票据号码
     SYS_IN_FLG,     --系统内标志
     REL_ID,         --票据ID
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
    )
    WITH TMP1 AS (
    SELECT TA.*,
           ROW_NUMBER() OVER(PARTITION BY TA.BILL_NUM,TA.BILL_SUB_INTRV_ID ORDER BY TA.CTR_NT_ID DESC) RN
      FROM ICL.V_CMM_BILL_DISCOUNT_INFO TA --票据转贴现信息
     INNER JOIN ICL.V_CMM_BILL_CENTER_INFO TB --票据中心信息
        ON TB.BILL_ID = TA.BILL_ID
       AND TB.BILL_STATUS_CD = 'S14'--已结清
       AND TB.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE TA.BUS_TYPE_CD = 'BT01' --转贴现
       AND TA.TRAN_DIR_CD <> '02'  --还没卖出的
       AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                    DATA_DT,        --数据日期
         T1.LP_ID                                    LGL_REP_ID,     --法人编号
         T3.ORG_ID                                   TRA_ORG_ID,     --交易机构编号
         T2.BUS_ID                                   TRA_SEQ_NO,     --交易流水号
         T3.DUBIL_ID                                 ACC_ID,         --账户编号
         T2.CNTPTY_ID                                CUST_ID,        --客户编号
         T3.CONT_ID                                  CONT_ID,        --合同编号
         '2'                                         CORP_IND_FLG,   --对公对私标志
         T3.ORG_ID                                   ORG_ID,         --机构编号
         T2.SUBJ_ID                                  SUBJ_ID,        --科目编号
         T3.DUBIL_ID                                 RCPT_ID,        --借据编号
         T3.CUST_ID                                  CUST_NM,        --客户名称
         '99-02'                                     TRA_TYP,        --交易类型 D0121
         CASE WHEN T2.TRAN_DIR_CD = '01' THEN 'D' --买入
              WHEN T2.TRAN_DIR_CD = '02' THEN 'C'  --卖出
              ELSE 'D'
          END                                        TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         T1.BILL_AMT                                 TRA_AMT,        --交易金额
         T2.CURRT_BAL                                ACC_BAL,        --账户余额
         /*TRIM(T4.DRAWER_ACCT_NUM)                    OPP_ACC,        --对方账号
         TRIM(T4.DRAWER_NAME)                        OPP_ACC_NM,     --对方户名
         TRIM(T4.DRAWER_OPEN_BANK_NO)                OPP_PBC_NO,     --对方行号
         TRIM(T4.DRAWER_OPEN_BANK_NAME)              OPP_BANK_NM,    --对方行名*/
         TRIM(T1.AGREE_PAYOFF_PS_ACCT_ID)            OPP_ACC,        --对方账号
         TRIM(T1.AGREE_PAYOFF_PS_NAME)               OPP_ACC_NM,     --对方户名
         TRIM(T1.AGREE_PAYOFF_PS_OPEN_BANK_NO)       OPP_PBC_NO,     --对方行号
         TRIM(T5.SYS_PRTCPTR_BIGAMT_BANK_NAME)       OPP_BANK_NM,    --对方行名
         '400920'                                    TRA_CHAN,       --交易渠道 Z0014
         T1.BILL_CURR_CD                             CUR,            --币种
         '票据追索结清'                              ABSTR,          --摘要
         '1'                                         FLUSH_PATCH_FLG,--冲补抹标志
         T2.CUST_MGR_ID                              TRA_TLR_NO,     --交易柜员号
         NULL                                        GRANT_TLR_NO,   --授权柜员号
         '2'                                          CASH_TRF_FLG,   --现转标志
         NULL                                        AGT_NM,         --代办人姓名
         NULL                                        AGT_CRDL_TYP,   --代办人证件类型
         NULL                                        AGT_CRDL_NO,    --代办人证件号码
         NULL                                        BATCH_TRF_FLG,  --批量转让标志
         NULL                                        NORM_RETRV_AMT, --正常回收金额
         NULL                                        ADV_REPY_AMT,   --提前还款金额
         'B10'                                       DSTR_RETRV_TYP, --发放收回类型
         NULL                                        PRIN_TRA_FLG,   --本金交易标志
         T1.RECV_DT                                  TRA_TM,         --交易时间
         TO_CHAR(T1.RECV_DT,'YYYYMMDD')              TRA_DT,         --交易日期
         NULL                                        LOAN_CHG_TYP,   --贷款变动类型
         '800926'                                    DEPT_LINE,      --部门条线/*公司银行总部*/
         '转贴追索数据-IMAS'                         DATA_SRC,       --数据来源
         '1'                                         REPAY_PERDS,    --还款期数
         'ZTZS'||'01'                                DTL_SEQ_NUM,    --交易序号
         T2.STD_PROD_ID                              STD_PROD_ID,    --标准产品编号
         T1.BILL_NUM                                 BILL_NUM,       --票据号码
         NULL                                        SYS_IN_FLG,     --系统内标志
         T1.BILL_ID                                  REL_ID,         --票据ID
         T2.DISCNT_INT_RAT                           DISCNT_INT_RAT, --贴现利率
         T2.CTR_NT_ID                                CTR_NT_ID       --成交单编号
    FROM IML.V_AGT_RECS_AGREE_PAYOFF_APPL_H T1  --追索同意清偿申请历史
   INNER JOIN TMP1 T2  --票据转贴现信息
      ON T2.BILL_NUM = T1.BILL_NUM
     AND T2.RN = 1
   INNER JOIN ICL.V_CMM_CORP_LOAN_DUBIL_INFO T3  --对公贷款借据信息
      ON T3.BILL_ID = T2.BILL_ID
     AND T3.STD_PROD_ID IN ('204010100001','204010100002')
     AND T3.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN ICL.V_CMM_BILL_CENTER_INFO T4  --票据贴现信息
      ON T4.BILL_ID = T2.BILL_ID
     AND T4.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 T5
      ON T5.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(T1.AGREE_PAYOFF_PS_OPEN_BANK_NO)
     AND T5.RANK_RN = 1
   WHERE T1.RECS_AGREE_PAYOFF_STATUS_CD = '02'
     AND T1.RECV_OPINION_TYPE_CD = 'SU00'
     AND T1.RECV_DT >= TRUNC(TO_DATE(RERUN_DATE,'YYYYMMDD'),'MM')
     AND T1.RECV_DT <= TO_DATE(RERUN_DATE,'YYYYMMDD')
     AND T1.RECV_DT = TO_DATE(RERUN_DATE,'YYYYMMDD')
     AND T1.START_DT <= TO_DATE(RERUN_DATE,'YYYYMMDD')
     AND T1.END_DT > TO_DATE(RERUN_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--贴现到期/卖出_IMAS';
  V_STARTTIME := SYSDATE;
  INSERT /*+ append  parallel */INTO RRP_MDL.M_TRA_LOAN_DTL_TEMP02
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,       --数据来源
     REPAY_PERDS,    --还款期数
     DTL_SEQ_NUM,    --交易序号
     STD_PROD_ID,    --标准产品编号
     BILL_NUM,       --票据号码
     SYS_IN_FLG,     --系统内标志
     REL_ID,         --票据ID
     DISCNT_INT_RAT, --贴现利率
     CTR_NT_ID       --成交单编号
    )
    WITH DISCOUNT_INFO AS (
      SELECT TA.BILL_NUM
            ,TA.BILL_SUB_INTRV_ID
            ,TA.ACCT_INSTIT_ID
            ,STL_DT,CNTPTY_NAME,CNTPTY_BANK_NO
            ,ROW_NUMBER () OVER (PARTITION BY TA.BILL_NUM,TA.BILL_SUB_INTRV_ID ORDER BY STL_DT ASC)  RN
        FROM ICL.V_CMM_BILL_DISCOUNT_INFO TA
       WHERE TA.ENTRY_STATUS_CD = '03' --记账成功
         AND TA.TRAN_DIR_CD = '02' --卖出
         AND TA.BUS_TYPE_CD = 'BT01'
         AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT V_P_DATE                                   DATA_DT,        --数据日期
         T1.LP_ID                                   LGL_REP_ID,     --法人编号
         T1.ORG_ID                                  TRA_ORG_ID,     --交易机构编号
         --T4.BANK_CORE_ENTRY_FLOW_NUM                TRA_SEQ_NO,     --交易流水号
         T2.BUS_ID                                  TRA_SEQ_NO,     --交易流水号
         T1.DUBIL_ID                                ACC_ID,         --账户编号
         T1.CUST_ID                                 CUST_ID,        --客户编号
         T1.CONT_ID                                 CONT_ID,        --合同编号
         '2'                                        CORP_IND_FLG,   --对公对私标志
         --T1.ORG_ID                                  ORG_ID,         --机构编号
         NVL(T5.ACCT_INSTIT_ID,T2.ENTER_ACCT_ORG_ID) ORG_ID,         --机构编号
         T2.SUBJ_ID                                  SUBJ_ID,        --科目编号
         T1.DUBIL_ID                                 RCPT_ID,        --借据编号
         T1.CUST_ID                                  CUST_NM,        --客户名称
         '99-01'                                     TRA_TYP,        --交易类型 D0121
         'C'                                         TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
         T2.FAC_VAL_AMT                              TRA_AMT,        --交易金额
         T2.CURRT_BAL                                ACC_BAL,        --账户余额
         /*NVL(TRIM(T2.DISCNT_APPLIT_ACCT_NUM),TRIM(T1.STL_ACCT_NUM)) OPP_ACC,        --对方账号
         NVL(TRIM(T2.DSCNT_PROPS_NAME),TRIM(T1.RECVBL_ACCT_NAME)) OPP_ACC_NM,     --对方户名
         TRIM(T2.DISCNT_APPLIT_BANK_NO)              OPP_PBC_NO,     --对方行号
         TRIM(T1.RECVBL_BANK_NAME)                   OPP_BANK_NM,    --对方行名*/
         CASE WHEN T1.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND T5.BILL_NUM IS NULL
              THEN TRIM(T2.DRAWER_ACCT_NUM)
              WHEN T5.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN TRIM(T5.CNTPTY_BANK_NO)
          END                                       AS OPP_ACC,        --对方账号
         CASE WHEN T1.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND T5.BILL_NUM IS NULL
              THEN TRIM(T2.DRAWER_NAME)
              WHEN T5.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN TRIM(T5.CNTPTY_NAME)
          END                                       AS OPP_ACC_NM,     --对方户名
         CASE WHEN T1.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND T5.BILL_NUM IS NULL
              THEN TRIM(T2.DRAWER_OPEN_BANK_NO)
              WHEN T5.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN TRIM(T5.CNTPTY_BANK_NO)
          END                                       AS OPP_PBC_NO,     --对方行号
         CASE WHEN T1.PAYOFF_DT = TO_DATE(V_P_DATE,'YYYYMMDD') AND T5.BILL_NUM IS NULL
              THEN TRIM(T2.DRAWER_OPEN_BANK_NAME)
              WHEN T5.STL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
              THEN T6.SYS_PRTCPTR_BIGAMT_BANK_NAME
          END                                       AS OPP_BANK_NM,    --对方行名
         '409020'                                   TRA_CHAN,       --交易渠道 Z0014
         T2.CURR_CD                                 CUR,            --币种
         '票据贴现-到期/卖出'                       ABSTR,          --摘要
         '1'                                        FLUSH_PATCH_FLG,--冲补抹标志
         TRIM(T2.CUST_MGR_ID)                       TRA_TLR_NO,     --交易柜员号
         NULL                                       GRANT_TLR_NO,   --授权柜员号
         '2'                                        CASH_TRF_FLG,   --现转标志
         NULL                                       AGT_NM,         --代办人姓名
         NULL                                       AGT_CRDL_TYP,   --代办人证件类型
         NULL                                       AGT_CRDL_NO,    --代办人证件号码
         NULL                                       BATCH_TRF_FLG,  --批量转让标志
         NULL                                       NORM_RETRV_AMT, --正常回收金额
         NULL                                       ADV_REPY_AMT,   --提前还款金额
         'A04'                                      DSTR_RETRV_TYP, --发放收回类型
         NULL                                       PRIN_TRA_FLG,   --本金交易标志
         TO_DATE(V_P_DATE,'YYYYMMDD')               TRA_TM,         --交易时间
         V_P_DATE                                   TRA_DT,         --交易日期
         NULL                                       LOAN_CHG_TYP,   --贷款变动类型
         '800926'                                   DEPT_LINE,      --部门条线/*公司银行总部*/
         '贴现到期/结清-IMAS'                       DATA_SRC,       --数据来源
         '1'                                        REPAY_PERDS,    --还款期数
         'TXDQJQ'||'02'                             DTL_SEQ_NUM,    --交易序号
         T2.STD_PROD_ID                             STD_PROD_ID,    --标准产品编号
         T2.BILL_NUM                                BILL_NUM,       --票据号码
         NULL                                       SYS_IN_FLG,     --系统内标志
         T2.BILL_ID                                 REL_ID,         --票据ID
         T2.DISCNT_INT_RAT                          DISCNT_INT_RAT, --贴现利率
         T1.DUBIL_ID                                CTR_NT_ID       --成交单编号
    FROM ICL.V_CMM_CORP_LOAN_DUBIL_INFO T1 --对公贷款借据信息
   INNER JOIN ICL.V_CMM_BILL_DISCNT_INFO T2 --票据贴现信息
      --ON T2.BILL_ENTRY_ID = T1.BILL_UNIQ_MARK_ID
      ON NVL(TRIM(T2.BILL_ENTRY_ID),T2.BILL_ID)= T1.BILL_UNIQ_MARK_ID --20230424 数仓反馈需调整条件
     AND TRIM(T1.BILL_UNIQ_MARK_ID) IS NOT NULL  --20230505 同表内借据表逻辑一致
     AND T2.ENTRY_STATUS_CD = '03'
     AND T2.DISCNT_STATUS_CD = '06'
     AND T2.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN IML.V_EVT_ENTRY T3 --记账分录事件
      ON T3.BILL_NUM = T1.BILL_NUM
     AND T3.DTL_STATUS_FLG = '1'
     AND T3.DEBIT_CRDT_DIR_CD = 'C'
     AND T3.SUBJ_ID IN ('13010101','13010201','811605')
     AND T3.ETL_DT = TO_DATE(RERUN_DATE,'YYYYMMDD')
   LEFT JOIN IML.V_EVT_BILL_ENTRY T4 --记账事件
     ON T4.BILL_ID = T3.BILL_ID
    AND T4.ETL_DT = TO_DATE(RERUN_DATE,'YYYYMMDD')
   LEFT JOIN DISCOUNT_INFO T5 --票据转贴信息
     ON T5.BILL_NUM = T2.BILL_NUM
    AND T5.BILL_SUB_INTRV_ID = T2.BILL_SUB_INTRV_ID
    AND RN = 1
   LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 T6
     ON T6.SYS_PRTCPTR_BIGAMT_BANK_NO = TRIM(T5.CNTPTY_BANK_NO)
    AND T6.RANK_RN = 1
  WHERE T1.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
    AND ((T1.PAYOFF_DT = TO_DATE(RERUN_DATE,'YYYYMMDD') AND T5.BILL_NUM IS NULL)--当天到期且没有做转贴现卖出的
          OR T5.STL_DT = TO_DATE(RERUN_DATE,'YYYYMMDD')) --当天做转贴现卖出的
     --AND T1.BILL_NUM IS NOT NULL  --临时过滤为空数据
    AND T1.ETL_DT = V_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '信贷账户交易流水--数据汇总';
  V_STARTTIME := SYSDATE;
  INSERT /*+ append  parallel */INTO RRP_MDL.M_TRA_LOAN_DTL
    (DATA_DT,        --数据日期
     LGL_REP_ID,     --法人编号
     TRA_ORG_ID,     --交易机构编号
     TRA_SEQ_NO,     --交易流水号
     ACC_ID,         --账户编号
     CUST_ID,        --客户编号
     CONT_ID,        --合同编号
     CORP_IND_FLG,   --对公对私标志
     ORG_ID,         --机构编号
     SUBJ_ID,        --科目编号
     RCPT_ID,        --借据编号
     CUST_NM,        --客户名称
     TRA_TYP,        --交易类型 D0121
     TRA_DR_CR_FLG,  --交易借贷标志 Z0017 D-借，C-贷
     TRA_AMT,        --交易金额
     ACC_BAL,        --账户余额
     OPP_ACC,        --对方账号
     OPP_ACC_NM,     --对方户名
     OPP_PBC_NO,     --对方行号
     OPP_BANK_NM,    --对方行名
     TRA_CHAN,       --交易渠道 Z0014
     CUR,            --币种
     ABSTR,          --摘要
     FLUSH_PATCH_FLG,--冲补抹标志
     TRA_TLR_NO,     --交易柜员号
     GRANT_TLR_NO,   --授权柜员号
     CASH_TRF_FLG,   --现转标志
     AGT_NM,         --代办人姓名
     AGT_CRDL_TYP,   --代办人证件类型
     AGT_CRDL_NO,    --代办人证件号码
     BATCH_TRF_FLG,  --批量转让标志
     NORM_RETRV_AMT, --正常回收金额
     ADV_REPY_AMT,   --提前还款金额
     DSTR_RETRV_TYP, --发放收回类型
     PRIN_TRA_FLG,   --本金交易标志
     TRA_TM,         --交易时间
     TRA_DT,         --交易日期
     LOAN_CHG_TYP,   --贷款变动类型
     DEPT_LINE,      --部门条线
     DATA_SRC,        --数据来源
     CRN_PRD_ACCRD_INT,  --当期应计利息
     CRN_PRD_REPY_PNY_INT,  --当期还款罚息
     CRN_PRD_REPY_CP_INT,  --当期还款复息
     REPAY_PERDS,        --期数号
     DTL_SEQ_NUM,         --交易序号
     AMT_TYPE,            --金额类型
     REPAY_TYPE,          --还款类型代码
     STD_PROD_ID,          --标准产品编号
     BILL_NUM,         --票据号码
     REL_ID,
     SYS_IN_FLG,
     DISCNT_INT_RAT,   --贴现利率
     CTR_NT_ID,        --成交单编号
     CALLBK_RS         --回款原因
     )
   WITH TMP1 AS (
      SELECT TLR_NO AS TELLER_ID,EMP_ID AS CLERK_ID,TO_DATE(UPDATE_DT,'YYYYMMDD') AS DIMISSION_DT  FROM ADD_EMP_TLR
      UNION ALL
      SELECT TELLER_ID,CLERK_ID,DIMISSION_DT FROM RRP_MDL.O_ICL_CMM_CLERK_INFO
       WHERE TRIM(TELLER_ID) IS NOT NULL AND ETL_DT = V_DATE),
     CMM_CLERK_INFO AS (
          SELECT TC.TELLER_ID,
                 TC.CLERK_ID,
                 ROW_NUMBER() OVER(PARTITION BY TC.CLERK_ID ORDER BY TC.DIMISSION_DT DESC) RN
            FROM TMP1 TC)
  SELECT RERUN_DATE                                              DATA_DT,        --数据日期
         T.LGL_REP_ID                                           LGL_REP_ID,     --法人编号
         --T.TRA_ORG_ID                                           TRA_ORG_ID,     --交易机构编号
         TRA_ORG_ID                                             TRA_ORG_ID,     --交易机构编号
         T.TRA_SEQ_NO                                           TRA_SEQ_NO,     --交易流水号
         T.ACC_ID                                               ACC_ID,         --账户编号
         T.CUST_ID                                              CUST_ID,        --客户编号
         T.CONT_ID                                              CONT_ID,        --合同编号
         T.CORP_IND_FLG                                         CORP_IND_FLG,   --对公对私标志
         --T.ORG_ID                                               ORG_ID,         --机构编号
         T.ORG_ID                                               ORG_ID,         --机构编号
         T.SUBJ_ID                                              SUBJ_ID,        --科目编号
         T.RCPT_ID                                              RCPT_ID,        --借据编号
         T.CUST_NM                                              CUST_NM,        --客户名称
         T.TRA_TYP                                              TRA_TYP,        --交易类型
         T.TRA_DR_CR_FLG                                        TRA_DR_CR_FLG,  --交易借贷标志
         T.TRA_AMT                                              TRA_AMT,        --交易金额
         T.ACC_BAL                                              ACC_BAL,        --账户余额
         CASE WHEN T.TRA_TYP IN ('04') THEN NULL
              ELSE TRIM(T.OPP_ACC)
          END                                                   OPP_ACC,        --对方账号
         CASE WHEN T.TRA_TYP IN ('04') THEN NULL
              ELSE COALESCE(TRIM(T.OPP_ACC_NM),TRIM(TB.CUST_ACCT_NAME))
          END                                                   OPP_ACC_NM,     --对方户名
         CASE WHEN T.TRA_TYP IN ('04') THEN NULL
              WHEN COALESCE(TRIM(T.OPP_PBC_NO),TRIM(TB.ORG_ID1)) IS NOT NULL
              THEN COALESCE(TRIM(TB.PBC_PAY_BANK_NO),TRIM(TC.FIN_INST_CODE),TRIM(T.OPP_PBC_NO),TRIM(TD.FIN_INST_CODE))
              WHEN TRIM(T.OPP_BANK_NM) = '工商银行' THEN '102100099996'
              WHEN TRIM(T.OPP_BANK_NM) = '中信银行' THEN '302100011000'
              WHEN TRIM(T.OPP_BANK_NM) = '兴业银行' THEN '309391000011'
              WHEN TRIM(T.OPP_BANK_NM) = '平安银行' THEN '307584007998'
              WHEN TRIM(T.OPP_BANK_NM) = '民生银行' THEN '305100000013'
              WHEN TRIM(T.OPP_BANK_NM) = '建设银行' THEN '105100000017'
          END                                                   OPP_PBC_NO,--对方行号
         CASE WHEN T.TRA_TYP IN ('04') THEN NULL
              ELSE CASE WHEN COALESCE(TRIM(T.OPP_BANK_NM),TRIM(T.OPP_PBC_NO),TRIM(TB.ORG_ID1)) IS NOT NULL
                        THEN COALESCE(CASE WHEN TRIM(T.OPP_BANK_NM) ='0' THEN NULL ELSE TRIM(T.OPP_BANK_NM) END,
                                      CASE WHEN TRIM(A.SYS_PRTCPTR_BIGAMT_BANK_NAME) ='0' THEN NULL ELSE TRIM(A.SYS_PRTCPTR_BIGAMT_BANK_NAME) END,
                                      TRIM(TB.ORG_NAME),
                                      TRIM(TC.ORG_NAME),TRIM(TD.ORG_NAME))
                    END
          END                                                   OPP_BANK_NM,    --对方行名
         NVL(T.TRA_CHAN,'99')                                   TRA_CHAN,       --交易渠道
         T.CUR                                                  CUR,            --币种
         TRIM(T.ABSTR)                                          ABSTR,          --摘要
         TRIM(T.FLUSH_PATCH_FLG)                                FLUSH_PATCH_FLG,--冲补抹标志
         NVL(TRIM(TF.TELLER_ID),TRIM(T.TRA_TLR_NO))             TRA_TLR_NO,     --交易柜员号
         NVL(TRIM(TG.TELLER_ID),TRIM(T.GRANT_TLR_NO))           GRANT_TLR_NO,   --授权柜员号
         T.CASH_TRF_FLG                                         CASH_TRF_FLG,   --现转标志
         T.AGT_NM                                               AGT_NM,         --代办人姓名
         T.AGT_CRDL_TYP                                         AGT_CRDL_TYP,   --代办人证件类型
         T.AGT_CRDL_NO                                          AGT_CRDL_NO,    --代办人证件号码
         T.BATCH_TRF_FLG                                        BATCH_TRF_FLG,  --批量转让标志
         T.NORM_RETRV_AMT                                       NORM_RETRV_AMT, --正常回收金额
         T.ADV_REPY_AMT                                         ADV_REPY_AMT,   --提前还款金额
         T.DSTR_RETRV_TYP                                       DSTR_RETRV_TYP, --发放收回类型
         T.PRIN_TRA_FLG                                         PRIN_TRA_FLG,   --本金交易标志
         T.TRA_TM                                               TRA_TM,         --交易时间
         T.TRA_DT                                               TRA_DT,         --交易日期
         T.LOAN_CHG_TYP                                         LOAN_CHG_TYP,   --贷款变动类型
         T.DEPT_LINE                                            DEPT_LINE,      --部门条线
         UPPER(T.DATA_SRC)                                      DATA_SRC,       --数据来源
         T.CRN_PRD_ACCRD_INT                                    CRN_PRD_ACCRD_INT,  --当期应计利息
         T.CRN_PRD_REPY_PNY_INT                                 CRN_PRD_REPY_PNY_INT,  --当期还款罚息
         T.CRN_PRD_REPY_CP_INT                                  CRN_PRD_REPY_CP_INT, --当期还款复息
         T.REPAY_PERDS                                          REPAY_PERDS,          --还款期数号
         T.DTL_SEQ_NUM                                          DTL_SEQ_NUM,           --交易序号
         T.AMT_TYPE                                             AMT_TYPE,             --金额类型
         T.REPAY_TYPE                                           REPAY_TYPE,           --还款类型代码
         T.STD_PROD_ID                                          STD_PROD_ID,           --标准产品编号
         T.BILL_NUM ,                                            --票据号码
         T.REL_ID,
         T.SYS_IN_FLG,
         T.DISCNT_INT_RAT                                       DISCNT_INT_RAT,  --贴现利率
         T.CTR_NT_ID                                            CTR_NT_ID,       --成交单编号
         T.CALLBK_RS                                            CALLBK_RS        --回款原因
    FROM RRP_MDL.M_TRA_LOAN_DTL_TEMP02 T
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP01 TB
      ON TB.CUST_ACCT_ID = T.OPP_ACC
    LEFT JOIN CMM_CLERK_INFO TF
      ON TF.CLERK_ID = TRIM(T.TRA_TLR_NO)
     AND TF.RN = 1
    LEFT JOIN CMM_CLERK_INFO TG
      ON TG.CLERK_ID = TRIM(T.GRANT_TLR_NO)
     AND TG.RN = 1
    LEFT JOIN RRP_MDL.M_TRA_LOAN_DTL_TEMP04 A
      ON A.SYS_PRTCPTR_BIGAMT_BANK_NO = T.OPP_PBC_NO
     AND A.RANK_RN = 1
    LEFT JOIN RRP_MDL.ORG_CONFIG TA
      ON TA.ORG_ID = T.ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG TC
      ON TC.ORG_ID = TRIM(T.OPP_PBC_NO)
    LEFT JOIN RRP_MDL.ORG_CONFIG TD
      ON TD.ORG_ID = '800'
    LEFT JOIN RRP_MDL.ORG_CONFIG TE
      ON TE.ORG_ID = T.TRA_ORG_ID
   WHERE NVL(T.TRA_AMT,0)>0;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;

   RERUN_DATE := TO_CHAR(TO_DATE(RERUN_DATE,'YYYYMMDD') + 1,'YYYYMMDD');

   END LOOP;
  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, TRA_SEQ_NO,DTL_SEQ_NUM,REPAY_PERDS,DATA_SRC,COUNT(1)
      FROM M_TRA_LOAN_DTL T
    GROUP BY DATA_DT, TRA_SEQ_NO,DTL_SEQ_NUM,REPAY_PERDS,DATA_SRC
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);


    -- 程序跑批结束记录 --
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_TRA_LOAN_DTL;
/

