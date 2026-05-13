CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_TRA_INTL_ACC_DTL_TEST(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_TRA_INTL_ACC_DTL_TEST
  *  功能描述：监管集市银行业银行机构开设的所有内部账户的信息
  *  创建日期：20220521
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_INTNAL_ACCT       --内部账户
  *            ICL.CMM_INTNAL_ORG_INFO   --内部机构信息表
  *            ICL.CMM_SUBJ_INFO         --科目信息
  *            ICL.CMM_GL_BAL            --总账余额
  *  目标表：  M_TRA_INTL_ACC_DTL  --内部分户账交易流水
  *
  *  配置表：  IML.REF_PUB_CD       --公共代码表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221011   hulj    调整授权柜员取值。
  *             2    20221122   hulj    增加数据重复校验。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             6    20230201  TANGAN   根据业务卢萌反馈，先去掉交易对手兜底逻辑
  *             7    20241011  LIP      根据east现场检查，调整交易序列号的排序方式，增加原始交易时间戳字段
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP_DESC VARCHAR2(100);              --处理步骤描述
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);              --分区名
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLCOUNT2 INTEGER := 0;               --更新或删除影响的记录数
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_TRA_INTL_ACC_DTL_TEST'; --程序名称
  V_TAB_NAME  VARCHAR2(100) := 'M_TRA_INTL_ACC_DTL'; --表名
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_TRA_INTL_ACC_DTL T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
  ETL_PARTITION_ADD(V_P_DATE,'M_TRA_INTL_ACC_DTL','1',O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '||'M_TRA_INTL_ACC_DTL'||' TRUNCATE PARTITION '||'PARTITION_'||V_P_DATE);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '交易对手子表1-核心借方找贷方';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP';
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP NOLOGGING --交易对手子表
    (DATA_DT,         --数据日期
     TRA_SEQ_NO,      --交易流水号
     ACC_ID,          --对方账户ID
     OPP_SUBJ_ID,     --对方科目编号
     OPP_SUBJ_NM,     --对方科目名称
     OPP_ACC,         --对方账号
     OPP_ACC_NM,      --对方户名
     OPP_PBC_NO,      --对方行号
     OPP_BANK_NM,     --对方行名
     TRA_TLR_NO,      --交易柜员号
     GRANT_TLR_NO,    --授权柜员号
     OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
     )
   WITH INTL_ACC_DTL_TMP01 AS (
    SELECT /*+MATERIALIZE*/A.CNTPTY_ACCT_ID
          ,A.TRAN_FLOW_NUM
          ,A.CUST_ACCT_ID
          ,A.DEP_SUB_ACCT_ID
          ,NVL(C.CORP_ACCT_FLG,B.CORP_ACCT_FLG) AS CORP_ACCT_FLG
          ,NVL(C.ACCT_NAME,B.ACCT_NAME) AS ACCT_NAME
          ,NVL(C.SUBJ_ID,B.SUBJ_ID) AS SUBJ_ID
          ,NVL(C.SUBJ_NAME,B.SUBJ_NAME) AS SUBJ_NAME
          ,NVL(C.FIN_INST_CODE,B.FIN_INST_CODE) AS FIN_INST_CODE
          ,NVL(C.ORG_NAME,B.ORG_NAME) AS ORG_NAME
          ,ROW_NUMBER() OVER(PARTITION BY A.CNTPTY_ACCT_ID,A.TRAN_FLOW_NUM ORDER BY A.TRAN_AMT DESC ) AS RN
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.CUST_ACCT_ID
     AND B.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO C
      ON C.ACCT_ID = A.DEP_SUB_ACCT_ID
     AND C.DATA_DT = V_P_DATE
   WHERE A.DEBIT_CRDT_DIR_CD = 'C' --贷方
     AND A.MEMO_CD <> 'TO' --代发失败退款  代发工资代发失败的需剔除后再取最大的一笔
     AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NOT NULL
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                        AS DATA_DT,     --数据日期
         TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO,  --交易流水号
         CASE WHEN NVL(TRIM(C.DEP_SUB_ACCT_ID),'0') <> '0' THEN TRIM(C.DEP_SUB_ACCT_ID) --MOD BY 20240327 优先取账号ID
              WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CUST_ACCT_ID
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC
          END                                                                 AS ACC_ID,      --对方账户ID
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.SUBJ_ID
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_SUBJ_ID
          END                                                                 AS OPP_SUBJ_ID, --对方科目编号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.SUBJ_NAME
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_SUBJ_NM
          END                                                                 AS OPP_SUBJ_NM, --对方科目名称
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CUST_ACCT_ID/*||'等'*/
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC/*||'等'*/
          END                                                                 AS OPP_ACC,     --对方账号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.ACCT_NAME/*||'等'*/
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC_NM/*||'等'*/
          END                                                                 AS OPP_ACC_NM,  --对方户名
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.FIN_INST_CODE
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_PBC_NO
          END                                                                 AS OPP_PBC_NO,  --对方行号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.ORG_NAME
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_BANK_NM
          END                                                                 AS OPP_BANK_NM, --对方行名
         TRIM(A.TRAN_TELLER_ID)                                               AS TRA_TLR_NO,  --交易柜员号
         TRIM(A.AUTH_TELLER_ID)                                               AS GRANT_TLR_NO,--授权柜员号
         CASE WHEN NVL(TRIM(C.DEP_SUB_ACCT_ID),'0') <> '0' THEN C.CORP_ACCT_FLG
              WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CORP_ACCT_FLG
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN '1'
          END                                                                 AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT B --内部账户
      ON B.ACCT_ID = A.DEP_SUB_ACCT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN INTL_ACC_DTL_TMP01 C
      ON C.CNTPTY_ACCT_ID = A.CUST_ACCT_ID
     AND C.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND C.RN = 1
    LEFT JOIN (
         SELECT D1.SOURSQ, REGEXP_SUBSTR(D1.SRVCSQ,'[0-9]+') AS SRVCSQ, D1.BSNSSQ, D1.AMNTCD, D1.TRANAM, D1.ITEMCD, D1.ITEMNA
               ,D1.ACCTBR || D1.ITEMCD || D1.CRCYCD AS OPP_ACC
               ,D1.ITEMNA AS OPP_ACC_NM
               ,D2.FIN_INST_CODE AS OPP_PBC_NO
               ,D1.ITEMCD AS OPP_SUBJ_ID
               ,D1.ITEMNA AS OPP_SUBJ_NM
               --,D2.ORG_NAME AS OPP_BANK_NM
               ,D2.BKNAME AS OPP_BANK_NM
               ,ROW_NUMBER() OVER(PARTITION BY D1.SOURSQ,D1.SRVCSQ,D1.BSNSSQ ORDER BY D1.TRANAM DESC) AS RN
           FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H D1
           LEFT JOIN RRP_MDL.ORG_CONFIG D2
             ON D2.ORG_ID = D1.ACCTBR
          WHERE D1.STACID = 1
            AND D1.SYSTID = 'NCBS'
            AND D1.AMNTCD = 'C' --借方
            AND D1.TRANDT = V_P_DATE) D
      ON D.BSNSSQ = A.OVA_FLOW_NUM
     AND D.SRVCSQ = A.ACCT_BILL_FLOW_NUM
     AND D.SOURSQ = A.TRAN_FLOW_NUM
     AND D.RN = 1
   WHERE A.DEBIT_CRDT_DIR_CD = 'D' --借方
     AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NULL
     AND TRIM(REPLACE(A.REAL_CNTPTY_ACCT_ID,'0','')) IS NULL
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '交易对手子表2-核心贷方找借方';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP NOLOGGING --交易对手子表
    (DATA_DT,     --数据日期
     TRA_SEQ_NO,  --交易流水号
     ACC_ID,      --对方账户ID
     OPP_SUBJ_ID, --对方科目编号
     OPP_SUBJ_NM, --对方科目名称
     OPP_ACC,     --对方账号
     OPP_ACC_NM,  --对方户名
     OPP_PBC_NO,  --对方行号
     OPP_BANK_NM, --对方行名
     TRA_TLR_NO,  --交易柜员号
     GRANT_TLR_NO,--授权柜员号
     OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
     )
  WITH INTL_ACC_DTL_TMP02 AS(
    SELECT /*+MATERIALIZE*/A.CNTPTY_ACCT_ID
          ,A.TRAN_FLOW_NUM
          ,A.CUST_ACCT_ID
          ,A.DEP_SUB_ACCT_ID
          ,NVL(C.CORP_ACCT_FLG,B.CORP_ACCT_FLG) AS CORP_ACCT_FLAG
          ,NVL(C.ACCT_NAME,B.ACCT_NAME) AS ACCT_NAME
          ,NVL(C.SUBJ_ID,B.SUBJ_ID) AS SUBJ_ID
          ,NVL(C.SUBJ_NAME,B.SUBJ_NAME) AS SUBJ_NAME
          ,NVL(C.FIN_INST_CODE,B.FIN_INST_CODE) AS FIN_INST_CODE
          ,NVL(C.ORG_NAME,B.ORG_NAME) AS ORG_NAME
          ,ROW_NUMBER() OVER(PARTITION BY A.CNTPTY_ACCT_ID,A.TRAN_FLOW_NUM ORDER BY A.TRAN_AMT DESC ) AS RN
      FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
     INNER JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
        ON B.ACCT_ID = A.CUST_ACCT_ID
       AND B.DATA_DT = V_P_DATE
      LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO C
        ON C.ACCT_ID = A.DEP_SUB_ACCT_ID
       AND C.DATA_DT = V_P_DATE
     WHERE A.DEBIT_CRDT_DIR_CD = 'D' --借方
       AND A.MEMO_CD <> 'TO' --代发失败退款  代发工资代发失败的需剔除后再取最大的一笔
       AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NOT NULL
       AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
       AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                        AS DATA_DT,     --数据日期
         TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO,  --交易流水号
         CASE WHEN NVL(TRIM(C.DEP_SUB_ACCT_ID),'0') <> '0' THEN TRIM(C.DEP_SUB_ACCT_ID) --MOD BY 20240327 优先取账号ID
              WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CUST_ACCT_ID
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC
          END                                                                 AS ACC_ID,      --对方账户ID
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.SUBJ_ID
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_SUBJ_ID
          END                                                                 AS OPP_SUBJ_ID, --对方科目编号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.SUBJ_NAME
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_SUBJ_NM
          END                                                                 AS OPP_SUBJ_NM, --对方科目名称
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CUST_ACCT_ID/*||'等'*/
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC/*||'等'*/
          END                                                                 AS OPP_ACC,     --对方账号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.ACCT_NAME/*||'等'*/
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_ACC_NM/*||'等'*/
          END                                                                 AS OPP_ACC_NM,  --对方户名
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.FIN_INST_CODE
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_PBC_NO
          END                                                                 AS OPP_PBC_NO,  --对方行号
         CASE WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.ORG_NAME
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN D.OPP_BANK_NM
          END                                                                 AS OPP_BANK_NM, --对方行名
         TRIM(A.TRAN_TELLER_ID)                                               AS TRA_TLR_NO,  --交易柜员号
         TRIM(A.AUTH_TELLER_ID)                                               AS GRANT_TLR_NO,--授权柜员号
         CASE WHEN NVL(TRIM(C.DEP_SUB_ACCT_ID),'0') <> '0' THEN C.CORP_ACCT_FLAG
              WHEN TRIM(C.CUST_ACCT_ID) IS NOT NULL THEN C.CORP_ACCT_FLAG
              WHEN TRIM(D.OPP_ACC) IS NOT NULL THEN '1'
          END                                                                 AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT B --内部账户
      ON B.ACCT_ID = A.DEP_SUB_ACCT_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN INTL_ACC_DTL_TMP02 C
      ON C.CNTPTY_ACCT_ID = A.CUST_ACCT_ID
     AND C.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND C.RN = 1
    LEFT JOIN (
         SELECT D1.SOURSQ, REGEXP_SUBSTR(D1.SRVCSQ,'[0-9]+') AS SRVCSQ, D1.BSNSSQ, D1.AMNTCD, D1.TRANAM, D1.ITEMCD, D1.ITEMNA
               ,D1.ACCTBR || D1.ITEMCD || D1.CRCYCD AS OPP_ACC
               ,D1.ITEMNA AS OPP_ACC_NM
               ,D2.FIN_INST_CODE AS OPP_PBC_NO
               ,D1.ITEMCD AS OPP_SUBJ_ID
               ,D1.ITEMNA AS OPP_SUBJ_NM
               --,D2.ORG_NAME AS OPP_BANK_NM
               ,D2.BKNAME AS OPP_BANK_NM
               ,ROW_NUMBER() OVER(PARTITION BY D1.SOURSQ,D1.SRVCSQ,D1.BSNSSQ ORDER BY D1.TRANAM DESC) AS RN
           FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H D1
           LEFT JOIN RRP_MDL.ORG_CONFIG D2
             ON D2.ORG_ID = D1.ACCTBR
          WHERE D1.STACID = 1
            AND D1.SYSTID = 'NCBS'
            AND D1.AMNTCD = 'D' --借方
            AND D1.TRANDT = V_P_DATE) D
      ON D.BSNSSQ = A.OVA_FLOW_NUM
     AND D.SRVCSQ = A.ACCT_BILL_FLOW_NUM
     AND D.SOURSQ = A.TRAN_FLOW_NUM
     AND D.RN = 1
   WHERE A.DEBIT_CRDT_DIR_CD = 'C' --贷方
     AND TRIM(REPLACE(A.CNTPTY_ACCT_ID,'0','')) IS NULL
     AND TRIM(REPLACE(A.REAL_CNTPTY_ACCT_ID,'0','')) IS NULL
     AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '交易对手子表3--核算中台贷方找借方';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP NOLOGGING --交易对手子表
    (DATA_DT,     --数据日期
     TRA_SEQ_NO,  --交易流水号
     ACC_ID,      --对方账户ID
     OPP_SUBJ_ID, --对方科目编号
     OPP_SUBJ_NM, --对方科目名称
     OPP_ACC,     --对方账号
     OPP_ACC_NM,  --对方户名
     OPP_PBC_NO,  --对方行号
     OPP_BANK_NM, --对方行名
     TRA_TLR_NO,  --交易柜员号
     GRANT_TLR_NO,--授权柜员号
     OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
     )
    WITH TGLS_GLA_VCHR_H AS (
      SELECT /*+MATERIALIZE*/A.TRANSQ
            ,A.VCHRSQ
            ,A.ACCTBR || A.ITEMCD || A.CRCYCD AS OPP_ACC     --对方账号
            ,'1'                              AS OPP_CORP_ACCT_FLG --对方对公账户标志 --ADD BY LIP 20241018
            ,A.ITEMCD                         AS OPP_SUBJ_ID --对方科目编号
            ,A.ITEMNA                         AS OPP_SUBJ_NM --对方科目名称
            ,A.ITEMNA                         AS OPP_ACC_NM  --对方户名
            ,B.FIN_INST_CODE                  AS OPP_PBC_NO  --对方行号
            --,B.ORG_NAME                       AS OPP_BANK_NM --对方行名
            ,B.BKNAME                         AS OPP_BANK_NM --对方行名
            ,A.TRANAM
            ,ROW_NUMBER() OVER(PARTITION BY A.TRANSQ,A.TRANAM ORDER BY A.VCHRSQ DESC) AS RN
            ,ROW_NUMBER() OVER(PARTITION BY A.TRANSQ ORDER BY A.TRANAM DESC) AS RAN
        FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H A --核算中台的交易表
        LEFT JOIN RRP_MDL.ORG_CONFIG B
          ON B.ORG_ID = A.ACCTBR
       WHERE A.STACID = 1  --基础账套
         AND SUBSTR(A.ITEMCD,1,1) NOT IN ('7','8') --剔除表外
         AND (SUBSTR(A.ITEMCD,1,4) <> '3001' --系统间往来
              OR A.ITEMCD IN ('30010101','30010251','30010253'))  --30010101-零级清算机构间往来、30010251-费控报销与结算往来、30010253-会计计量与引擎往来  这3个往来科目业务反馈先报送
         AND ((A.AMNTCD = 'C' AND A.TRANAM < 0) OR (A.AMNTCD = 'D' AND A.TRANAM > 0))  --借方
         AND A.TRANDT = V_P_DATE
         AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    DEP_ACCT_TRAN_DTL AS (
      SELECT /*+MATERIALIZE*/A.TRAN_FLOW_NUM
            ,A.ACCT_BILL_FLOW_NUM
            ,A.OVA_FLOW_NUM
            ,A.CUST_ACCT_ID                 AS OPP_ACC           --对方账号
            ,NVL(C.CORP_ACCT_FLG,B.CORP_ACCT_FLG) AS OPP_CORP_ACCT_FLG --对方对公账户标志 --ADD BY LIP 20241018
            ,NVL(C.SUBJ_ID,B.SUBJ_ID)       AS OPP_SUBJ_ID       --对方科目编号
            ,NVL(C.SUBJ_NAME,B.SUBJ_NAME)   AS OPP_SUBJ_NM       --对方科目名称
            ,NVL(C.ACCT_NAME,B.ACCT_NAME)   AS OPP_ACC_NM        --对方户名
            ,NVL(C.FIN_INST_CODE,B.FIN_INST_CODE) AS OPP_PBC_NO  --对方行号
            ,NVL(C.ORG_NAME,B.ORG_NAME)     AS OPP_BANK_NM       --对方行名
            ,TRIM(A.TRAN_TELLER_ID)         AS TRA_TLR_NO        --交易柜员号
            ,TRIM(A.AUTH_TELLER_ID)         AS GRANT_TLR_NO      --授权柜员号
            ,ROW_NUMBER() OVER(PARTITION BY /*A.TRAN_FLOW_NUM,*/A.OVA_FLOW_NUM ORDER BY A.TRAN_AMT DESC,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'D'THEN 1 ELSE 2 END ) AS RN
        FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
       INNER JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
          ON B.ACCT_ID = A.CUST_ACCT_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO C
          ON C.ACCT_ID = A.DEP_SUB_ACCT_ID
         AND C.DATA_DT = V_P_DATE
       WHERE A.MEMO_CD <> 'TO' --代发失败退款  代发工资代发失败的需剔除后再取最大的一笔
         --AND A.DEBIT_CRDT_DIR_CD = 'D' --借方
         AND TRIM(REPLACE(A.CUST_ACCT_ID,'0','')) IS NOT NULL
         AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD') AS DATA_DT,     --数据日期
         A.TRANSQ || A.VCHRSQ         AS TRA_SEQ_NO,  --交易流水号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC)
         END                          AS ACC_ID,      --对方账户ID
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_SUBJ_ID)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_SUBJ_ID)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_SUBJ_ID)
         END                          AS OPP_SUBJ_ID, --对方科目编号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_SUBJ_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_SUBJ_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_SUBJ_NM)
         END                          AS OPP_SUBJ_NM, --对方科目名称
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC)
         END                          AS OPP_ACC,     --对方账号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC_NM)
         END                          AS OPP_ACC_NM,  --对方户名
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_PBC_NO)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_PBC_NO)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_PBC_NO)
         END                          AS OPP_PBC_NO,  --对方行号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_BANK_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_BANK_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_BANK_NM)
         END                          AS OPP_BANK_NM, --对方行名
         T.TRA_TLR_NO                 AS TRA_TLR_NO,  --交易柜员号
         T.GRANT_TLR_NO               AS GRANT_TLR_NO, --授权柜员号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_CORP_ACCT_FLG)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_CORP_ACCT_FLG)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_CORP_ACCT_FLG)
         END                          AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H A     --核算中台的交易表
    LEFT JOIN TGLS_GLA_VCHR_H F
      ON F.TRANSQ = A.TRANSQ
     AND F.TRANAM = A.TRANAM
     AND F.RN = 1
    LEFT JOIN TGLS_GLA_VCHR_H H
      ON H.TRANSQ = A.TRANSQ
     AND H.RAN = 1
    LEFT JOIN DEP_ACCT_TRAN_DTL T
      ON T.OVA_FLOW_NUM = A.BSNSSQ
     /*AND T.TRAN_FLOW_NUM = A.SOURSQ*/
     AND T.RN = 1
   WHERE A.STACID = 1  --基础账套
     AND SUBSTR(A.ITEMCD,1,1) NOT IN ('7','8') --剔除表外
     AND (SUBSTR(A.ITEMCD,1,4) <> '3001' --系统间往来
          OR A.ITEMCD IN ('30010101','30010251','30010253')) --30010101-零级清算机构间往来、30010251-费控报销与结算往来、30010253-会计计量与引擎往来  这3个往来科目业务反馈先报送
     AND ((A.AMNTCD = 'C' AND A.TRANAM > 0) OR (A.AMNTCD = 'D' AND A.TRANAM < 0))  --贷方
     AND A.TRANDT = V_P_DATE
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '交易对手子表4-核算中台借方找贷方';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP NOLOGGING --交易对手子表
    (DATA_DT,     --数据日期
     TRA_SEQ_NO,  --交易流水号
     ACC_ID,      --对方账户ID
     OPP_SUBJ_ID, --对方科目编号
     OPP_SUBJ_NM, --对方科目名称
     OPP_ACC,     --对方账号
     OPP_ACC_NM,  --对方户名
     OPP_PBC_NO,  --对方行号
     OPP_BANK_NM, --对方行名
     TRA_TLR_NO,  --交易柜员号
     GRANT_TLR_NO,--授权柜员号
     OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    )
    WITH TGLS_GLA_VCHR_H AS (
      SELECT /*+MATERIALIZE*/A.TRANSQ
            ,A.VCHRSQ
            ,A.ACCTBR || A.ITEMCD || A.CRCYCD AS OPP_ACC     --对方账号
            ,'1'                              AS OPP_CORP_ACCT_FLG --对方对公账户标志 --ADD BY LIP 20241018
            ,A.ITEMCD                         AS OPP_SUBJ_ID --对方科目编号
            ,A.ITEMNA                         AS OPP_SUBJ_NM --对方科目名称
            ,A.ITEMNA                         AS OPP_ACC_NM  --对方户名
            ,B.FIN_INST_CODE                  AS OPP_PBC_NO  --对方行号
            --,B.ORG_NAME                       AS OPP_BANK_NM --对方行名
            ,B.BKNAME                         AS OPP_BANK_NM --对方行名
            ,A.TRANAM
            ,ROW_NUMBER() OVER(PARTITION BY A.TRANSQ,A.TRANAM ORDER BY A.VCHRSQ DESC ) AS RN
            ,ROW_NUMBER() OVER(PARTITION BY A.TRANSQ ORDER BY A.TRANAM DESC ) AS RAN
        FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H A     --核算中台的交易表
        LEFT JOIN RRP_MDL.ORG_CONFIG B
          ON B.ORG_ID = A.ACCTBR
       WHERE A.STACID = 1  --基础账套
         AND SUBSTR(A.ITEMCD,1,1) NOT IN ('7','8') --剔除表外
         AND (SUBSTR(A.ITEMCD,1,4) <> '3001' --系统间往来
             OR A.ITEMCD IN ('30010101','30010251','30010253')) --30010101-零级清算机构间往来、30010251-费控报销与结算往来、30010253-会计计量与引擎往来  这3个往来科目业务反馈先报送
         AND ((A.AMNTCD = 'C' AND A.TRANAM > 0) OR (A.AMNTCD = 'D' AND A.TRANAM < 0)) --贷方
         AND A.TRANDT = V_P_DATE
         AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    DEP_ACCT_TRAN_DTL AS (
      SELECT /*+MATERIALIZE*/A.TRAN_FLOW_NUM
            ,A.ACCT_BILL_FLOW_NUM
            ,A.OVA_FLOW_NUM
            ,A.CUST_ACCT_ID                   AS OPP_ACC     --对方账号
            ,NVL(C.CORP_ACCT_FLG,B.CORP_ACCT_FLG) AS OPP_CORP_ACCT_FLG --对方对公账户标志 --ADD BY LIP 20241018
            ,NVL(C.SUBJ_ID,B.SUBJ_ID)         AS OPP_SUBJ_ID --对方科目编号
            ,NVL(C.SUBJ_NAME,B.SUBJ_NAME)     AS OPP_SUBJ_NM --对方科目名称
            ,NVL(C.ACCT_NAME,B.ACCT_NAME)     AS OPP_ACC_NM  --对方户名
            ,NVL(C.FIN_INST_CODE,B.FIN_INST_CODE) AS OPP_PBC_NO  --对方行号
            ,NVL(C.ORG_NAME,B.ORG_NAME)       AS OPP_BANK_NM--对方行名
            ,TRIM(A.TRAN_TELLER_ID)           AS TRA_TLR_NO  --交易柜员号
            ,TRIM(A.AUTH_TELLER_ID)           AS GRANT_TLR_NO --授权柜员号
            ,ROW_NUMBER() OVER(PARTITION BY /*A.TRAN_FLOW_NUM,*/A.OVA_FLOW_NUM ORDER BY A.TRAN_AMT DESC,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'C'THEN 1 ELSE 2 END ) AS RN
        FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
       INNER JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
          ON B.ACCT_ID = A.CUST_ACCT_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO C
          ON C.ACCT_ID = A.DEP_SUB_ACCT_ID
         AND C.DATA_DT = V_P_DATE
       WHERE TRIM(REPLACE(A.CUST_ACCT_ID,'0','')) IS NOT NULL
         --AND A.DEBIT_CRDT_DIR_CD = 'C' --贷方
         AND A.MEMO_CD <> 'TO' --代发失败退款  代发工资代发失败的需剔除后再取最大的一笔
         AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
         AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD') AS DATA_DT,     --数据日期
         A.TRANSQ || A.VCHRSQ         AS TRA_SEQ_NO,  --交易流水号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC)
          END                         AS ACC_ID,      --对方账户ID
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_SUBJ_ID)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_SUBJ_ID)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_SUBJ_ID)
          END                         AS OPP_SUBJ_ID, --对方科目编号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_SUBJ_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_SUBJ_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_SUBJ_NM)
          END                         AS OPP_SUBJ_NM, --对方科目名称
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC)
          END                         AS OPP_ACC,     --对方账号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_ACC_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_ACC_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_ACC_NM)
          END                         AS OPP_ACC_NM,  --对方户名
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_PBC_NO)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_PBC_NO)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_PBC_NO)
          END                         AS OPP_PBC_NO,  --对方行号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_BANK_NM)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_BANK_NM)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_BANK_NM)
          END                         AS OPP_BANK_NM, --对方行名
         T.TRA_TLR_NO                 AS TRA_TLR_NO,  --交易柜员号
         T.GRANT_TLR_NO               AS GRANT_TLR_NO,--授权柜员号
         CASE WHEN TRIM(T.OPP_ACC) IS NOT NULL THEN TRIM(T.OPP_CORP_ACCT_FLG)
              WHEN TRIM(F.OPP_ACC) IS NOT NULL THEN TRIM(F.OPP_CORP_ACCT_FLG)
              WHEN TRIM(H.OPP_ACC) IS NOT NULL THEN TRIM(H.OPP_CORP_ACCT_FLG)
          END                         AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H A     --核算中台的交易表
    LEFT JOIN TGLS_GLA_VCHR_H F
      ON F.TRANSQ = A.TRANSQ
     AND F.TRANAM = A.TRANAM
     AND F.RN = 1
    LEFT JOIN TGLS_GLA_VCHR_H H
      ON H.TRANSQ = A.TRANSQ
     AND H.RAN = 1
    LEFT JOIN DEP_ACCT_TRAN_DTL T
      ON T.OVA_FLOW_NUM = A.BSNSSQ
     /*AND T.TRAN_FLOW_NUM = A.SOURSQ*/
     AND T.RN = 1
   WHERE A.STACID = 1  --基础账套
     AND SUBSTR(A.ITEMCD,1,1) NOT IN ('7','8') --剔除表外
     AND (SUBSTR(A.ITEMCD,1,4) <> '3001' --系统间往来
         OR A.ITEMCD IN ('30010101','30010251','30010253')) --30010101-零级清算机构间往来、30010251-费控报销与结算往来、30010253-会计计量与引擎往来  这3个往来科目业务反馈先报送
     AND ((A.AMNTCD = 'C' AND A.TRANAM < 0) OR (A.AMNTCD = 'D' AND A.TRANAM > 0)) --借方
     AND A.TRANDT = V_P_DATE
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --ADD BY LIP 20231221
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '交易对手子表5-微众联合存款：其他-互联网金融往来-贷记';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP NOLOGGING --交易对手子表
    (DATA_DT,     --数据日期
     TRA_SEQ_NO,  --交易流水号
     ACC_ID,      --对方账户ID
     OPP_SUBJ_ID, --对方科目编号
     OPP_SUBJ_NM, --对方科目名称
     OPP_ACC,     --对方账号
     OPP_ACC_NM,  --对方户名
     OPP_PBC_NO,  --对方行号
     OPP_BANK_NM, --对方行名
     TRA_TLR_NO,  --交易柜员号
     GRANT_TLR_NO,--授权柜员号
     OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    )
  SELECT TO_CHAR(A.ETL_DT,'YYYYMMDD') AS DATA_DT,     --数据日期
         TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO,  --交易流水号
         TRIM(C.ACCT_ID)              AS ACC_ID,      --对方账户ID
         D.SUBJ_ID                    AS OPP_SUBJ_ID, --对方科目编号
         F.SUBJ_NAME                  AS OPP_SUBJ_NM, --对方科目名称
         TRIM(C.ACCT_ID)              AS OPP_ACC,     --对方账号
         D.ACCT_NAME                  AS OPP_ACC_NM,  --对方户名
         E.FIN_INST_CODE              AS OPP_PBC_NO,  --对方行号
         E.ORG_NAME                   AS OPP_BANK_NM, --对方行名
         A.TRAN_TELLER_ID             AS TRA_TLR_NO,  --交易柜员号
         A.AUTH_TELLER_ID             AS GRANT_TLR_NO,--授权柜员号
         '0'                          AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.O_IOL_TGLS_GLA_VCHR_H B --核算中台的交易表
      ON B.BSNSSQ = A.OVA_FLOW_NUM
     AND B.AMNTCD = 'D'
     AND B.STACID = '1'
     AND B.SYSTID = 'IFSX'
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   INNER JOIN RRP_MDL.O_IML_EVT_IFS_ACCT_TRAN_DTL C --联合存款账户交易明细
      ON C.TRAN_FLOW_ID = B.SOURSQ
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_IFS_ACCT_INFO D
      ON D.CUST_ACCT_ID = C.ACCT_ID
     AND D.CUST_ACCT_SUB_ACCT_NUM = C.DEP_SUB_ACCT_ID
     AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG E
      ON E.ORG_ID = D.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO F
      ON F.SUBJ_ID = D.SUBJ_ID
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE A.DEBIT_CRDT_DIR_CD = 'C'
     AND A.TRAN_KIND_CD = 'H003' --互联网金融往来-贷记
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入内部分户账核心交易流水';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/INTO RRP_MDL.M_TRA_INTL_ACC_DTL NOLOGGING
    (DATA_DT                        --数据日期
    ,LGL_REP_ID                     --法人编号
    ,TRA_SEQ_NO                     --交易流水号
    ,ACC_ID                         --账户编号
    ,ORG_ID                         --机构编号
    ,SUBJ_ID                        --科目编号
    ,CUR                            --币种
    ,ACC_NM                         --账户名称
    ,TRA_TYP                        --交易类型
    ,TRA_AMT                        --交易金额
    ,OPP_ACC                        --对方账号
    ,OPP_SUBJ_ID                    --对方科目编号
    ,OPP_SUBJ_NM                    --对方科目名称
    ,OPP_ACC_NM                     --对方户名
    ,OPP_PBC_NO                     --对方行号
    ,TRA_CHAN                       --交易渠道
    ,CASH_TRF_FLG                   --现转标志
    ,TRA_TLR_NO                     --交易柜员号
    ,GRANT_TLR_NO                   --授权柜员号
    ,ENT_ACCT_DT                    --进账日期
    ,WRT_OFF_DT                     --销账日期
    ,ABSTR                          --摘要
    ,FLUSH_PATCH_FLG                --冲补抹标志
    ,TRA_DR_CR_FLG                  --交易借贷标志
    ,TRA_DT                         --交易日期
    ,TRA_TM                         --交易时间
    ,DR_BAL                         --借方余额
    ,CR_BAL                         --贷方余额
    ,OPP_BANK_NM                    --对方行名
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,CORE_TRAN_FLOW_NUM             --核心交易流水号
    ,ACCT_BILL_FLOW_NUM             --账单流水号
    ,OVA_FLOW_NUM                   --全局流水号
    ,INIT_TRAN_TIMESTAMP            --原交易时间戳 --ADD BY LIP 20241011
    ,OPP_CORP_ACCT_FLG              --对方对公账户标志 -ADD BY LIP 20241018
    )
    WITH
   TMP_TRA_DTL AS (
    SELECT /*+MATERIALIZE*/ /*+USE_HASH(A,TMP,J,B,D,E,F,BB,BD,K,K1,K2,K3,KK,KKB)*/
            TO_CHAR(A.TRAN_DT,'YYYYMMDD')                     AS DATA_DT          --数据日期
           ,A.LP_ID                                           AS LGL_REP_ID       --法人编号
           ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.ACCT_BILL_FLOW_NUM||A.TRAN_FLOW_NUM AS TRA_SEQ_NO --交易流水号
           ,A.DEP_SUB_ACCT_ID                                 AS ACC_ID           --账户编号
           ,A.ACCT_ORG_ID                                     AS ORG_ID           --机构编号
           ,D.SUBJ_ID                                         AS SUBJ_ID          --科目编号
           ,A.TRAN_CURR_CD                                    AS CUR              --币种
           ,B.ACCT_NAME                                       AS ACC_NM           --账户名称
           ,A.TRAN_KIND_CD                                    AS TRA_TYP          --交易类型
           ,A.TRAN_AMT                                        AS TRA_AMT          --交易金额
           ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN TRIM(TC.OPP_ACC)
                 WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_ACC)
                 WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
                 WHEN NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0') NOT IN ('0') THEN TRIM(A.CNTPTY_INTER_ACCT_ID)
                 WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_ID)
            END                                               AS OPP_ACC          --对方账号
           ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN TRIM(TC.OPP_SUBJ_ID)
                 WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_SUBJ_ID)
                 WHEN TRIM(S1.SUBJ_ID) IS NOT NULL THEN TRIM(S1.SUBJ_ID)
            END                                               AS OPP_SUBJ_ID      --对方科目编号
           ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN TRIM(TC.OPP_SUBJ_NM)
                 WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_SUBJ_NM)
                 WHEN TRIM(S1.SUBJ_NAME) IS NOT NULL THEN TRIM(S1.SUBJ_NAME)
            END                                               AS OPP_SUBJ_NM      --对方科目名称
           ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN TRIM(TC.OPP_ACC_NM)
                 WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_ACC_NM)
                 WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
                 WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_NAME)
            END                                               AS OPP_ACC_NM       --对方户名
           ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN NVL(TRIM(B3.FIN_INST_CODE),TRIM(TC.OPP_PBC_NO))
                 WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_PBC_NO)
                 WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B2.FIN_INST_CODE),TRIM(A.REAL_CNTPTY_FIN_INST_CD))
                 WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B1.FIN_INST_CODE),TRIM(A.CNTPTY_OPEN_BANK_ID))
            END                                               AS OPP_PBC_NO       --对方行号
           ,A.CHN_CD                                          AS TRA_CHAN         --交易渠道
           ,CASE WHEN A.CASH_TRANS_FLG = '1' THEN '1' -- 现
                 WHEN A.CASH_TRANS_FLG = '0' THEN '2' -- 转
                 ELSE '2'
            END                                               AS CASH_TRF_FLG     --现转标志
           ,TRIM(A.ENTRY_TELLER_ID)                           AS TRA_TLR_NO       --交易柜员号
           ,TRIM(A.AUTH_TELLER_ID)                            AS GRANT_TLR_NO     --授权柜员号
           ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                    AS ENT_ACCT_DT      --进账日期
           ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                    AS WRT_OFF_DT       --销账日期
           ,TRIM(REPLACE(REPLACE(NVL(K.MEMO_CODE_DESCB,A.MEMO_CD_DESCB),CHR(10),''),CHR(13),'')) AS ABSTR  --摘要
           ,CASE WHEN A.ERASE_ACCT_FLG = '1' THEN '4'--抹账  --MODIFY BY TANGAN AT 20230106 码值调整CD1674
                 WHEN A.REVS_FLG = '1' THEN '2' --冲账
                 WHEN NVL(K.MEMO_CODE_DESCB,A.MEMO_CD_DESCB) LIKE '%冲账%' THEN '2' --冲账
                 ELSE '1'  --正常
             END                                              AS FLUSH_PATCH_FLG  --冲补抹标志
           ,DECODE(A.DEBIT_CRDT_DIR_CD,'R','C','P','D', A.DEBIT_CRDT_DIR_CD) AS TRA_DR_CR_FLG --交易借贷标志
           ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                    AS TRA_DT           --交易日期
           ,A.TRAN_TIMESTAMP                                  AS TRA_TM           --交易时间
           ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'D' THEN A.TRAN_BAL
                 ELSE 0
             END                                              AS DR_BAL           --借方余额
           ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'C' THEN A.TRAN_BAL
                 ELSE 0
             END                                              AS CR_BAL           --贷方余额
           ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL THEN NVL(TRIM(B3.BKNAME),TRIM(TC.OPP_BANK_NM))
                 WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_BANK_NM)  --modify by tangan at 20230403 调整优先级
                 WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B2.BKNAME),TRIM(A.REAL_CNTPTY_FIN_INST_NAME))
                 WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B1.BKNAME),TRIM(A.CNTPTY_OPEN_BANK_NAME))
            END                                               AS OPP_BANK_NM      --对方行名
           ,'800001'                                          AS DEPT_LINE        --部门条线 /*营运管理部*/
           ,'核心数据'                                        AS DATA_SRC         --数据来源
           ,A.TRAN_FLOW_NUM                                   AS CORE_TRAN_FLOW_NUM  --核心交易流水号
           ,A.ACCT_BILL_FLOW_NUM                              AS ACCT_BILL_FLOW_NUM  --账单流水号
           ,A.OVA_FLOW_NUM                                    AS OVA_FLOW_NUM        --全局流水号
           ,TO_CHAR(A.INIT_TRAN_TIMESTAMP,'YYYYMMDDHH24MISSFF') AS INIT_TRAN_TIMESTAMP --原交易时间戳 --ADD BY LIP 20241011
           ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL AND TRIM(TC.OPP_ACC) IS NOT NULL
                 THEN TRIM(S1.CORP_ACCT_FLG)
                 WHEN TRIM(TMP.OPP_ACC) IS NOT NULL THEN TRIM(TMP.OPP_CORP_ACCT_FLG)
                 ELSE TRIM(S1.CORP_ACCT_FLG)
            END                                               AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
      FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
      LEFT JOIN (
                SELECT DATA_DT,     --数据日期
                       TRA_SEQ_NO,  --交易流水号
                       ACC_ID,      --对方账户ID
                       OPP_SUBJ_ID, --对方科目编号
                       OPP_SUBJ_NM, --对方科目名称
                       OPP_ACC,     --对方账号
                       OPP_ACC_NM,  --对方户名
                       OPP_PBC_NO,  --对方行号
                       OPP_BANK_NM, --对方行名
                       OPP_CORP_ACCT_FLG, --对方对公账户标志 -ADD BY LIP 20241018
                       ROW_NUMBER() OVER(PARTITION BY TRA_SEQ_NO ORDER BY OPP_ACC NULLS LAST) AS RN
                FROM RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP
                WHERE DATA_DT = V_P_DATE
         ) TMP
        ON TMP.TRA_SEQ_NO = TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM
       AND TMP.RN = 1
      INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT B --内部账户
        ON A.DEP_SUB_ACCT_ID = B.ACCT_ID
       AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO D --科目信息
        ON D.SUBJ_ID = B.SUBJ_ID
       AND D.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP03 E --MODIFY BY LIP 20220726
        ON E.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
       AND E.TRAN_DT = A.TRAN_DT
      LEFT JOIN RRP_MDL.O_IML_REF_TRAN_MEMO_CODE_PARA_TAB K
        ON A.MEMO_CD = K.MEMO_CODE
       AND K.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND K.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
      LEFT JOIN RRP_MDL.CODE_MAP K1  --交易渠道
        ON K1.SRC_VALUE_CODE = A.CHN_CD
       AND K1.SRC_CLASS_CODE = 'CD1751'
       AND K1.TAR_CLASS_CODE = 'Z0014'
       AND K1.MOD_FLG = 'MDM'
      LEFT JOIN RRP_MDL.M_MID_TRA_CNTPTY_INFO TC --交易对手信息中间表
        ON TC.TRA_SEQ_NO = TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM
       AND TC.TRA_DT = TO_CHAR(A.TRAN_DT,'YYYYMMDD')
      LEFT JOIN RRP_MDL.ORG_CONFIG B1
        ON B1.ORG_ID = A.CNTPTY_OPEN_BANK_ID
      LEFT JOIN RRP_MDL.ORG_CONFIG B2
        ON B2.ORG_ID = A.REAL_CNTPTY_FIN_INST_CD
      LEFT JOIN RRP_MDL.ORG_CONFIG B3
        ON B3.ORG_ID = TC.OPP_PBC_NO
      LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO S1
        ON S1.ACCT_ID = COALESCE(TRIM(TC.OPP_ACC),TRIM(A.REAL_CNTPTY_ACCT_ID),DECODE(NVL(TRIM(A.CNTPTY_INTER_ACCT_ID),'0'),'0','',TRIM(A.CNTPTY_INTER_ACCT_ID)),TRIM(A.CNTPTY_ACCT_ID))
       AND S1.DATA_DT = V_P_DATE
     WHERE A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      AND SUBSTR(B.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')--不用上报科目
      AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT T.DATA_DT                        --数据日期
        ,T.LGL_REP_ID                     --法人编号
        ,T.TRA_SEQ_NO                     --交易流水号
        ,T.ACC_ID                         --账户编号
        ,T.ORG_ID                         --机构编号
        ,T.SUBJ_ID                        --科目编号
        ,T.CUR                            --币种
        ,T.ACC_NM                         --账户名称
        ,T.TRA_TYP                        --交易类型
        ,T.TRA_AMT                        --交易金额
        ,T.OPP_ACC                        --对方账号
        ,CASE WHEN TRIM(T.OPP_SUBJ_ID) IS NOT NULL THEN TRIM(T.OPP_SUBJ_ID)
              WHEN TRIM(T1.SUBJ_ID) IS NOT NULL THEN TRIM(T1.SUBJ_ID)
          END AS OPP_SUBJ_ID              --对方科目编号
        ,CASE WHEN TRIM(T.OPP_SUBJ_NM) IS NOT NULL THEN TRIM(T.OPP_SUBJ_NM)
              WHEN TRIM(T1.SUBJ_NAME) IS NOT NULL THEN TRIM(T1.SUBJ_NAME)
          END AS OPP_SUBJ_NM              --对方科目名称
        ,CASE WHEN TRIM(T.OPP_ACC_NM) IS NOT NULL THEN TRIM(T.OPP_ACC_NM)
              WHEN TRIM(T1.ACCT_NAME) IS NOT NULL THEN TRIM(T1.ACCT_NAME)
          END AS OPP_ACC_NM               --对方户名
        ,CASE WHEN TRIM(T.OPP_PBC_NO) IS NOT NULL THEN TRIM(T.OPP_PBC_NO)
              WHEN TRIM(T1.FIN_INST_CODE) IS NOT NULL THEN TRIM(T1.FIN_INST_CODE)
         END AS OPP_PBC_NO                --对方行号
        ,T.TRA_CHAN                       --交易渠道
        ,T.CASH_TRF_FLG                   --现转标志
        ,T.TRA_TLR_NO                     --交易柜员号
        ,T.GRANT_TLR_NO                   --授权柜员号
        ,T.ENT_ACCT_DT                    --进账日期
        ,T.WRT_OFF_DT                     --销账日期
        ,T.ABSTR                          --摘要
        ,T.FLUSH_PATCH_FLG                --冲补抹标志
        ,T.TRA_DR_CR_FLG                  --交易借贷标志
        ,T.TRA_DT                         --交易日期
        ,T.TRA_TM                         --交易时间
        ,T.DR_BAL                         --借方余额
        ,T.CR_BAL                         --贷方余额
        ,CASE WHEN TRIM(T.OPP_BANK_NM) IS NOT NULL THEN TRIM(T.OPP_BANK_NM)
              WHEN T2.ORG_NAME IS NOT NULL THEN T2.ORG_NAME --MOD BY LIP 20231010
              WHEN T3.BKNAME IS NOT NULL THEN T3.BKNAME --MOD BY LIP 20231010
              WHEN TRIM(T1.ORG_NAME) IS NOT NULL THEN TRIM(T1.ORG_NAME)
          END AS OPP_BANK_NM              --对方行名
        ,T.DEPT_LINE                      --部门条线
        ,T.DATA_SRC                       --数据来源
        ,T.CORE_TRAN_FLOW_NUM             --核心交易流水号
        ,T.ACCT_BILL_FLOW_NUM             --账单流水号
        ,T.OVA_FLOW_NUM                   --全局流水号
        ,T.INIT_TRAN_TIMESTAMP            --原交易时间戳 --ADD BY LIP 20241011
        ,CASE WHEN T1.CUST_ACCT_ID IS NOT NULL THEN T1.CORP_ACCT_FLG
              ELSE T.OPP_CORP_ACCT_FLG
          END AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM TMP_TRA_DTL T
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO T1
      ON T1.ACCT_ID = T.OPP_ACC
     AND T1.DATA_DT = V_P_DATE
    LEFT JOIN RRP_MDL.ADD_BANK_NAME_YL T2
      ON T2.YLH = TRIM(T.OPP_PBC_NO)
    LEFT JOIN RRP_MDL.O_IOL_MPCS_A08TBANKINFO T3
      ON T3.BKCD = TRIM(T.OPP_PBC_NO)
     AND T3.ID_MARK <> 'D'
     AND T3.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND T3.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入内部分户账核算中台交易流水';
  V_STARTTIME := SYSDATE;
  INSERT  /*+APPEND PARALLEL*/INTO RRP_MDL.M_TRA_INTL_ACC_DTL NOLOGGING
    (DATA_DT                        --数据日期
    ,LGL_REP_ID                     --法人编号
    ,TRA_SEQ_NO                     --交易流水号
    ,ACC_ID                         --账户编号
    ,ORG_ID                         --机构编号
    ,SUBJ_ID                        --科目编号
    ,CUR                            --币种
    ,ACC_NM                         --账户名称
    ,TRA_TYP                        --交易类型
    ,TRA_AMT                        --交易金额
    ,OPP_ACC                        --对方账号
    ,OPP_SUBJ_ID                    --对方科目编号
    ,OPP_SUBJ_NM                    --对方科目名称
    ,OPP_ACC_NM                     --对方户名
    ,OPP_PBC_NO                     --对方行号
    ,TRA_CHAN                       --交易渠道
    ,CASH_TRF_FLG                   --现转标志
    ,TRA_TLR_NO                     --交易柜员号
    ,GRANT_TLR_NO                   --授权柜员号
    ,ENT_ACCT_DT                    --进账日期
    ,WRT_OFF_DT                     --销账日期
    ,ABSTR                          --摘要
    ,FLUSH_PATCH_FLG                --冲补抹标志
    ,TRA_DR_CR_FLG                  --交易借贷标志
    ,TRA_DT                         --交易日期
    ,TRA_TM                         --交易时间
    ,DR_BAL                         --借方余额
    ,CR_BAL                         --贷方余额
    ,OPP_BANK_NM                    --对方行名
    ,DEPT_LINE                      --部门条线
    ,DATA_SRC                       --数据来源
    ,CORE_TRAN_FLOW_NUM             --核心交易流水号
    ,ACCT_BILL_FLOW_NUM             --账单流水号
    ,OVA_FLOW_NUM                   --全局流水号
    ,INIT_TRAN_TIMESTAMP            --原交易时间戳 --ADD BY LIP 20241011
    ,OPP_CORP_ACCT_FLG              --对方对公账户标志 -ADD BY LIP 20241018
    )
  SELECT /*+USE_HASH(A,TMP,C,B,D,E,F)*/
          A.TRANDT                                AS DATA_DT                        --数据日期
         ,'9999'                                  AS LGL_REP_ID                     --法人编号
         ,A.TRANDT || A.TRANSQ || A.VCHRSQ || A.ACCTBR || A.ITEMCD || A.CRCYCD AS TRA_SEQ_NO --交易流水号
         ,A.ACCTBR || A.ITEMCD || A.CRCYCD        AS ACC_ID                         --账户编号
         ,A.ACCTBR                                AS ORG_ID                         --机构编号
         ,A.ITEMCD                                AS SUBJ_ID                        --科目编号
         ,A.CRCYCD                                AS CUR                            --币种
         ,A.ITEMNA                                AS ACC_NM                         --账户名称
         ,CASE WHEN A.ITEMCD IN ('10010101','10010102') THEN 'CS'
               WHEN NVL(A.TRANTP,'*') = '*' THEN '99'
               ELSE A.TRANTP
          END                                     AS TRA_TYP                        --交易类型
         ,ABS(A.TRANAM)                           AS TRA_AMT                        --交易金额  --modify by tangan at 20230528
         ,CASE WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL THEN TRIM(BDMS.CUST_ACCT)
               WHEN TRIM(C.TX_CNTPTY_ACCT_NUM) IS NOT NULL THEN TRIM(C.TX_CNTPTY_ACCT_NUM)
               ELSE TRIM(TMP.OPP_ACC)
          END                                     AS OPP_ACC                        --对方账号
         ,CASE WHEN TRIM(A.TOITEM) IS NOT NULL THEN TRIM(A.TOITEM)
               ELSE TRIM(TMP.OPP_SUBJ_ID)
          END                                     AS OPP_SUBJ_ID                    --对方科目编号
         ,CASE WHEN TRIM(B.SUBJ_NAME) IS NOT NULL THEN TRIM(B.SUBJ_NAME)
               ELSE TRIM(TMP.OPP_SUBJ_NM)
          END                                     AS OPP_SUBJ_NM                    --对方科目名称
         ,CASE WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL THEN TRIM(BDMS.CUST_NAME)
               WHEN TRIM(C.TX_CNTPTY_NAME) IS NOT NULL THEN TRIM(C.TX_CNTPTY_NAME)
               ELSE TRIM(TMP.OPP_ACC_NM)
          END                                     AS OPP_ACC_NM                     --对方户名
         ,CASE WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL THEN TRIM(BDMS.CUST_BANK_NO)
               WHEN TRIM(C.CNTPTY_FIN_INST_BRAC_CD) IS NOT NULL THEN TRIM(C.CNTPTY_FIN_INST_BRAC_CD)
               ELSE TRIM(TMP.OPP_PBC_NO)
          END                                     AS OPP_PBC_NO                     --对方行号
         ,A.ASSIS0                                AS TRA_CHAN                       --交易渠道
         ,CASE WHEN A.ITEMCD IN ('10010101','10010102') THEN '1' ELSE '2' END  AS CASH_TRF_FLG                   --现转标志
         --MOD BY 20240117 核算中台的交易柜员默认为TGLS0001
         ,CASE WHEN A.SYSTID IN ('TGLS') THEN 'TGLS0001'
               WHEN TRIM(TMP.TRA_TLR_NO) IS NOT NULL THEN TRIM(TMP.TRA_TLR_NO)
               ELSE 'M0001'
           END                                    AS TRA_TLR_NO                     --交易柜员号
         ,TMP.GRANT_TLR_NO                        AS GRANT_TLR_NO                   --授权柜员号
         ,A.TRANDT                                AS ENT_ACCT_DT                    --进账日期
         ,A.TRANDT                                AS WRT_OFF_DT                     --销账日期
         ,CASE WHEN A.ITEMCD IN ('10010101','10010102') THEN '现金'
               WHEN A.TRANTP = 'TR' THEN '转账'
               ELSE '其他'
          END                                     AS ABSTR                          --摘要
         ,CASE WHEN A.STRKST = '9' THEN '2' --冲账
               ELSE '1'  --正常
          END                                     AS FLUSH_PATCH_FLG                --冲补抹标志
         ,CASE WHEN A.AMNTCD = 'C' AND A.TRANAM < 0 THEN 'D'
               WHEN A.AMNTCD = 'D' AND A.TRANAM < 0 THEN 'C'
               ELSE A.AMNTCD
          END                                     AS TRA_DR_CR_FLG                  --交易借贷标志  --modify by tangan at 20230528
         ,A.TRANDT                                AS TRA_DT                         --交易日期
         ,NULL                                    AS TRA_TM                         --交易时间
         ,NVL(TRIM(F.TD_OC_DR_BAL),0)             AS DR_BAL                         --借方余额
         ,NVL(TRIM(F.TD_OC_CR_BAL),0)             AS CR_BAL                         --贷方余额
         ,CASE WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL THEN TRIM(BDMS.CUST_BANK_NAME)
               WHEN TRIM(C.CNTPTY_FIN_INST_BRAC_NAME) IS NOT NULL THEN TRIM(C.CNTPTY_FIN_INST_BRAC_NAME)
               ELSE TRIM(TMP.OPP_BANK_NM)
          END                                     AS OPP_BANK_NM                    --对方行名
         ,'800001'                                AS DEPT_LINE                      --部门条线 /*营运管理部*/
         ,'核算中台'                              AS DATA_SRC                       --数据来源
         ,A.SOURSQ                                AS CORE_TRAN_FLOW_NUM             --核心交易流水号
         ,A.SRVCSQ                                AS ACCT_BILL_FLOW_NUM             --账单流水号
         ,A.BSNSSQ                                AS OVA_FLOW_NUM                   --全局流水号
         ,TO_CHAR(A.TRANTI,'YYYYMMDDHH24MISSFF')  AS INIT_TRAN_TIMESTAMP            --原交易时间戳 --ADD BY LIP 20241011
         ,CASE WHEN TRIM(BDMS.BSNSSQ) IS NOT NULL THEN '1'
               WHEN TRIM(C.TX_CNTPTY_ACCT_NUM) IS NOT NULL AND TRIM(C.TX_CNTPTY_CERT_TYPE) LIKE '2%' THEN '1'
               WHEN TRIM(C.TX_CNTPTY_ACCT_NUM) IS NOT NULL AND TRIM(C.TX_CNTPTY_CERT_TYPE) LIKE '1%' THEN '0'
               WHEN TRIM(C.TX_CNTPTY_ACCT_NUM) IS NOT NULL AND LENGTH(TRIM(C.TX_CNTPTY_NAME)) > 3 THEN '1'
               WHEN TRIM(C.TX_CNTPTY_ACCT_NUM) IS NOT NULL AND LENGTH(TRIM(C.TX_CNTPTY_NAME)) <= 3 THEN '0'
               ELSE TRIM(TMP.OPP_CORP_ACCT_FLG)
          END                                     AS OPP_CORP_ACCT_FLG --对方对公账户标志 -ADD BY LIP 20241018
    FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H A     --核算中台的交易表
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B  --科目信息
      ON B.SUBJ_ID = TRIM(A.TOITEM)
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    --MOD BY 20240402 增加票据的取数
    LEFT JOIN (
         SELECT PJ.*,
                ROW_NUMBER() OVER(PARTITION BY PJ.BSNSSQ,ISCUSTACCT,PJ.EVETDN ORDER BY PJ.SERINO DESC) AS RN
           FROM RRP_MDL.O_IOL_BDMS_VIEW_TRANS_OPPONENT_INFO PJ --票据系统交易对手信息视图
          WHERE TRIM(PJ.CUST_ACCT) IS NOT NULL
            AND ISCUSTACCT = '0') BDMS
      ON BDMS.BSNSSQ = A.BSNSSQ --全局流水号
     AND BDMS.EVETDN = A.AMNTCD
     AND BDMS.RN = 1
    LEFT JOIN (
         SELECT CC.*
               ,ROW_NUMBER() OVER(PARTITION BY CC.CORE_TRAN_FLOW_NUM,CC.BIZ_SEQ_NUM,CC.TRA_SEQ_NO ORDER BY CC.TX_CNTPTY_ACCT_NUM DESC) AS RN
           FROM RRP_MDL.O_IOL_TX_CNTPTY_INFO CC --交易对手视图
          WHERE TRIM(CC.CORE_TRAN_FLOW_NUM) IS NOT NULL
            AND CC.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
            AND CC.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')) C
      ON C.CORE_TRAN_FLOW_NUM = A.BSNSSQ --全局流水号
     AND C.BIZ_SEQ_NUM = A.SOURSQ        --系统流水号
     AND C.TRA_SEQ_NO = A.SRVCSQ         --交易序号
     AND C.RN = 1
    LEFT JOIN (
          SELECT DATA_DT,     --数据日期
                 TRA_SEQ_NO,  --交易流水号
                 ACC_ID,      --对方账户ID
                 OPP_SUBJ_ID, --对方科目编号
                 OPP_SUBJ_NM, --对方科目名称
                 OPP_ACC,     --对方账号
                 OPP_ACC_NM,  --对方户名
                 OPP_PBC_NO,  --对方行号
                 OPP_BANK_NM, --对方行名
                 TRA_TLR_NO,  --交易柜员号
                 GRANT_TLR_NO,--授权柜员号
                 OPP_CORP_ACCT_FLG,--对方对公账户标志 -ADD BY LIP 20241018
                 ROW_NUMBER() OVER(PARTITION BY TRA_SEQ_NO ORDER BY OPP_ACC) AS RN
          FROM RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP
          WHERE DATA_DT = V_P_DATE) TMP
      ON TMP.TRA_SEQ_NO = A.TRANSQ || A.VCHRSQ
     AND TMP.RN = 1
    LEFT JOIN (SELECT DISTINCT A.TRAN_FLOW_NUM,A.OVA_FLOW_NUM,A.ACCT_BILL_FLOW_NUM
                 FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
                 LEFT JOIN RRP_MDL.O_IOL_TGLS_GLA_VCHR_H H
                   ON H.SOURSQ = A.TRAN_FLOW_NUM
                  AND H.STACID = 1
                  AND H.ITEMCD = '64110102' --MODIFY BY TANGAN AT 20230612  64110102科目数据需要报送
                  AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                WHERE H.SOURSQ IS NULL
                  AND A.TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
                  AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) D
      ON D.TRAN_FLOW_NUM = A.SOURSQ
     AND D.OVA_FLOW_NUM = A.BSNSSQ
     AND D.ACCT_BILL_FLOW_NUM = REGEXP_SUBSTR(A.SRVCSQ,'[0-9]+')
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01 E
      ON E.SUBJ_ID = A.ITEMCD
    LEFT JOIN ( --关联总账余额表取余额
         SELECT SUBJ_ID,ORG_ID,CURR_CD,STD_PROD_ID,TRAN_CHN_CD,TD_OC_DR_BAL,TD_OC_CR_BAL,ABS(TD_OC_DR_BAL-TD_OC_CR_BAL) AS BAL
           FROM RRP_MDL.O_ICL_CMM_GL_BAL  --核算中台的总账余额表
          WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
            AND DATA_SRC_CD = '99' ) F
      ON A.ITEMCD = F.SUBJ_ID
     AND A.TRANBR = F.ORG_ID
     AND A.CRCYCD = F.CURR_CD
     AND A.ASSIS1 = F.STD_PROD_ID
     AND A.ASSIS0 = F.TRAN_CHN_CD
   WHERE A.STACID = 1  --基础账套
    --AND A.SYSTID NOT IN ('NCBS','IFSX')  --剔除新核心、互联网金融数据 暂定 modify by tangan at 20230215
     AND SUBSTR(A.ITEMCD,1,1) NOT IN ('7','8') --剔除表外
     AND (SUBSTR(A.ITEMCD,1,4) <> '3001' --系统间往来
         OR A.ITEMCD IN ('30010101','30010251','30010253'))  --30010101-零级清算机构间往来、30010251-费控报销与结算往来、30010253-会计计量与引擎往来  这3个往来科目业务反馈先报送
     AND A.TRANAM <> 0
     AND TRIM(D.TRAN_FLOW_NUM) IS NULL
     AND TRIM(E.SUBJ_ID) IS NULL
     AND A.TRANDT = V_P_DATE
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

     WITH TMP1 AS (
  SELECT DATA_DT,TRA_SEQ_NO,ACC_ID,COUNT(1)
    FROM RRP_MDL.M_TRA_INTL_ACC_DTL T
   WHERE DATA_DT = V_P_DATE
   GROUP BY DATA_DT,TRA_SEQ_NO,ACC_ID
  HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
    O_ERRCODE   := '1';
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'数据重复,跑批错误');
    RETURN;
  END IF;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'跑批正确');

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  --MOD BY LIP 20231010 月批调账后重跑一次后，增加月批的标志
    WITH TMP2 AS (
    SELECT COUNT(1) M FROM RRP_MDL.ETL_STATE WHERE ETL_DATE = V_P_DATE AND PROC_NAME = V_PROC_NAME)
  SELECT NVL(M,0) INTO V_SQLCOUNT2 FROM TMP2;

  IF TO_DATE(V_P_DATE,'YYYYMMDD') = LAST_DAY(TO_DATE(V_P_DATE,'YYYYMMDD')) AND V_SQLCOUNT2 >= 1 THEN
    INSERT INTO RRP_MDL.ETL_STATE (ETL_DATE,PROC_NAME,END_TIME)
    VALUES (V_P_DATE,V_PROC_NAME||'_MONTH',TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
    COMMIT;
  END IF;

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

END ETL_M_TRA_INTL_ACC_DTL_TEST;
/

