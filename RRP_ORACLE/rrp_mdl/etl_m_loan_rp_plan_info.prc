CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_LOAN_RP_PLAN_INFO(I_P_DATE IN INTEGER,
                                                O_ERRCODE OUT VARCHAR2
                                                )
  /**************************************************************************
  *  程序名称：ETL_M_LOAN_RP_PLAN_INFO
  *  功能描述：贷款还款计划信息
  *  创建日期：20220524
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  M_LOAN_RP_PLAN_INFO
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220524  梅炜      首次创建
  *             2    20221114  hulj      增加数据重复校验
  *             3    20230928  lip       增加数据重复校验
  *             4    20231128  HULJ      对公部分口径剔除豁免利息
  *             5    20250219  YJY       新增对公联合网贷微业贷的判断
  *             6    20250521  YJY       修改联合网贷部分的借据号，取联合网贷借据表的核心借据编号
  *             7    20250725  YJY       回退联合网贷部分的借据号
  *             8    20251120  YJY       新增203050100002-微众对公联合贷（微业贷4.0）产品
  ************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;         --处理步骤
  V_P_DATE    VARCHAR2(8);          --跑批数据日期
  V_STARTTIME DATE;                 --处理开始时间
  V_ENDTIME   DATE;                 --处理结束时间
  V_SQLCOUNT  INTEGER := 0;         --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);        --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);        --任务名称
  V_PART_NAME VARCHAR2(100);        --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_LOAN_RP_PLAN_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_LOAN_RP_PLAN_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

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

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款还款计划信息--对公部分';
  V_STARTTIME := SYSDATE;
  INSERT  /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_RP_PLAN_INFO
    (DATA_DT                 --数据日期
    ,LGL_REP_ID              --法人编号
    ,RCPT_ID                 --借据编号
    ,REPY_PRD_NUM            --还款期数
    ,PRIN_EXP_DT             --本金到期
    ,PRIN                    --本金
    ,RET_PRIN                --归还本金
    ,INT_EXP_DT              --利息到期
    ,INT                     --利息
    ,RET_INT                 --归还利息
    ,DEPT_LINE               --部门条线
    ,DATA_SRC                --数据来源
    ,REPY_DT                 --还款日期
    ,REPY_WAY                --还款方式
    )
  WITH CORP_LOAN_REPAY_PLAN AS (
       SELECT  LP_ID
              ,DUBIL_ID
              ,REPAY_PERDS
              ,MAX(JOB_CD)                AS JOB_CD
              ,MAX(ACCT_ID)               AS ACCT_ID
              ,MAX(CUST_ID)               AS CUST_ID
              ,MAX(REPAYBL_DT)            AS REPAYBL_DT
              ,SUM(CURR_ISSUE_RECVBL_PRIC)AS CURR_ISSUE_RECVBL_PRIC
              ,SUM(CURR_ISSUE_INT_RECVBL) AS CURR_ISSUE_INT_RECVBL
         FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_PLAN --对公贷款还款计划
        WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY LP_ID,DUBIL_ID,REPAY_PERDS),
  CMM_CORP_LOAN_REPAY_DTL AS (
       SELECT  DUBIL_ID
              ,REPAY_PERDS
              ,SUM(CURRT_REPAY_PRIC) AS CURRT_REPAY_PRIC
              ,SUM(CURRT_REPAY_INT)  AS CURRT_REPAY_INT
              ,MAX(ADV_REPAY_FLG)    AS ADV_REPAY_FLG
              ,REPAY_DT              AS REPAY_DT
         FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_DTL   --对公贷款还款明细
         WHERE TRIM(DEBIT_CRDT_FLG) IS NOT NULL
        --WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY DUBIL_ID,REPAY_PERDS,REPAY_DT)
  SELECT  V_P_DATE                          AS DATA_DT                 --数据日期
         ,A.LP_ID                           AS LGL_REP_ID              --法人编号
         ,A.DUBIL_ID                        AS RCPT_ID                 --借据编号
         ,A.REPAY_PERDS                     AS REPY_PRD_NUM            --还款期数
         ,TO_CHAR(A.REPAYBL_DT,'YYYYMMDD')  AS PRIN_EXP_DT             --本金到期日期
         ,A.CURR_ISSUE_RECVBL_PRIC          AS PRIN                    --本金
         ,B.CURRT_REPAY_PRIC                AS RET_PRIN                --归还本金
         ,TO_CHAR(A.REPAYBL_DT,'YYYYMMDD')  AS INT_EXP_DT              --利息到期日期
         ,A.CURR_ISSUE_INT_RECVBL           AS INT                     --利息
         ,B.CURRT_REPAY_INT                 AS RET_INT                 --归还利息
         ,NULL                              AS DEPT_LINE               --部门条线 800919 风险管理部
         ,'对公信贷'                        AS DATA_SRC                --数据来源
         ,TO_CHAR(B.REPAY_DT,'YYYYMMDD')    AS REPAY_DT                --还款方式
         ,CASE WHEN E.DUBIL_ID IS NOT NULL THEN '08' --核损核销  按华兴银行还款处理逻辑本代码实际业务场景应为核销后收回标志
               WHEN B.ADV_REPAY_FLG = '1' THEN '03'  --提前还款
               ELSE '01'
           END
    FROM CORP_LOAN_REPAY_PLAN A  --对公贷款还款计划
    LEFT JOIN CMM_CORP_LOAN_REPAY_DTL B
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.REPAY_PERDS = A.REPAY_PERDS
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO E --贷款核销信息表
      ON E.DUBIL_ID = A.DUBIL_ID
     AND E.FIR_WRT_OFF_DT <= B.REPAY_DT
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款还款计划信息--零售部分';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_LOAN_RP_PLAN_INFO
    (DATA_DT                 --数据日期
    ,LGL_REP_ID              --法人编号
    ,RCPT_ID                 --借据编号
    ,REPY_PRD_NUM            --还款期数
    ,PRIN_EXP_DT             --本金到期
    ,PRIN                    --本金
    ,RET_PRIN                --归还本金
    ,INT_EXP_DT              --利息到期
    ,INT                     --利息
    ,RET_INT                 --归还利息
    ,DEPT_LINE               --部门条线
    ,DATA_SRC                --数据来源
    ,REPY_DT                 --还款日期
    ,REPY_WAY                --还款方式
    )
  WITH RETL_LOAN_REPAY_PLAN AS (
        SELECT LP_ID
              ,DUBIL_ID
              ,REPAY_PERDS
              ,MAX(JOB_CD)                AS JOB_CD
              ,MAX(ACCT_ID)               AS ACCT_ID
              ,MAX(CUST_ID)               AS CUST_ID
              ,MAX(REPAYBL_DT)            AS REPAYBL_DT
              ,SUM(CURR_ISSUE_RECVBL_PRIC)AS CURR_ISSUE_RECVBL_PRIC
              ,SUM(CURR_ISSUE_INT_RECVBL) AS CURR_ISSUE_INT_RECVBL
         FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_PLAN --零售贷款还款计划
        WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY LP_ID,DUBIL_ID,REPAY_PERDS),
  RETL_LOAN_REPAY_DTL AS (
        SELECT DUBIL_ID
              ,REPAY_PERDS
              ,SUM(CURRT_REPAY_PRIC) AS CURRT_REPAY_PRIC
              ,SUM(CURRT_REPAY_INT) AS CURRT_REPAY_INT
              ,MAX(REPAY_ACCT_ID)   AS REPAY_ACCT_ID
              ,MAX(ADV_REPAY_FLG)   AS ADV_REPAY_FLG
              ,MAX(COMP_REPAY_FLG)  AS COMP_REPAY_FLG
              ,REPAY_DT             AS REPAY_DT
         FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_REPAY_DTL   --零售贷款还款明细
        --WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY DUBIL_ID,REPAY_PERDS,REPAY_DT)
  SELECT  V_P_DATE                         AS DATA_DT                 -- 数据日期
         ,A.LP_ID                          AS LGL_REP_ID              -- 法人编号
         ,A.DUBIL_ID                       AS RCPT_ID                 -- 借据编号
         ,A.REPAY_PERDS                    AS REPY_PRD_NUM            -- 还款期数
         ,TO_CHAR(A.REPAYBL_DT,'YYYYMMDD') AS PRIN_EXP_DT             -- 本金到期日期
         ,A.CURR_ISSUE_RECVBL_PRIC         AS PRIN                    -- 本金
         ,B.CURRT_REPAY_PRIC               AS RET_PRIN                -- 归还本金
         ,TO_CHAR(A.REPAYBL_DT,'YYYYMMDD') AS INT_EXP_DT              -- 利息到期日期
         ,A.CURR_ISSUE_INT_RECVBL          AS INT                     -- 利息
         ,B.CURRT_REPAY_INT                AS RET_INT                 -- 归还利息
         ,NULL                             AS DEPT_LINE               -- 部门条线 800924零售信贷部
         ,'零售贷款'                       AS DATA_SRC                -- 数据来源
         ,TO_CHAR(B.REPAY_DT,'YYYYMMDD')   AS REPY_DT                 --还款日期
         ,CASE WHEN E.DUBIL_ID IS NOT NULL THEN '08'  --核损核销
               WHEN B.COMP_REPAY_FLG = '1' THEN '07'  --担保代偿
               WHEN B.ADV_REPAY_FLG = '1' THEN '03'  --提前还款
               WHEN (B.REPAY_ACCT_ID = C.LOAN_REPAY_NUM OR B.REPAY_ACCT_ID = C.LOAN_DISTR_ACCT_NUM) THEN '01'  --正常收回
               WHEN SUBSTR(A.DUBIL_ID,1,3)='UPL' AND (B.REPAY_ACCT_ID <> C.LOAN_REPAY_NUM AND B.REPAY_ACCT_ID <> C.LOAN_DISTR_ACCT_NUM)
               THEN '07'  --经刘健确认还款账户不等于放款账户的UPL还款为担保代偿，实际测试发现还款明细的还款账户有可能为账户表的还款账户还款，且账户表的还款账户不等于账户表的放款账户，因此增加逻辑UPL的还款明细的还款账户不等于账户表的还款账户和放款账户判定为担保代偿
               WHEN C.STD_PROD_ID IN ('202020200003','202010200004') AND (B.REPAY_ACCT_ID <> C.LOAN_REPAY_NUM AND B.REPAY_ACCT_ID <> C.LOAN_DISTR_ACCT_NUM)
                    AND C.LOAN_ACCT_STATUS_CD IN ('1','2','3')
               THEN '07'  --担保代偿
               WHEN C.STD_PROD_ID IN ('202020200003','202010200004') AND (B.REPAY_ACCT_ID <> C.LOAN_REPAY_NUM AND B.REPAY_ACCT_ID <> C.LOAN_DISTR_ACCT_NUM)
                    AND C.LOAN_ACCT_STATUS_CD NOT IN ('1','2','3')
               THEN '01'  --正常收回
               ELSE '99' --其他
           END
    FROM RETL_LOAN_REPAY_PLAN A
    LEFT JOIN RETL_LOAN_REPAY_DTL B
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.REPAY_PERDS = A.REPAY_PERDS
    LEFT JOIN RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO C --零售贷款账户信息
      ON C.DUBIL_NUM = A.DUBIL_ID
     AND C.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_LOAN_WRT_OFF_INFO E --贷款核销信息表
      ON E.DUBIL_ID = B.DUBIL_ID
     AND E.FIR_WRT_OFF_DT <= B.REPAY_DT
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '插入贷款还款计划信息--联合网贷部分';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND PARALLEL*/ INTO RRP_MDL.M_LOAN_RP_PLAN_INFO
    (DATA_DT                 --数据日期
    ,LGL_REP_ID              --法人编号
    ,RCPT_ID                 --借据编号
    ,REPY_PRD_NUM            --还款期数
    ,PRIN_EXP_DT             --本金到期
    ,PRIN                    --本金
    ,RET_PRIN                --归还本金
    ,INT_EXP_DT              --利息到期
    ,INT                     --利息
    ,RET_INT                 --归还利息
    ,DEPT_LINE               --部门条线
    ,DATA_SRC                --数据来源
    ,REPY_DT                 --还款日期
    ,REPY_WAY                --还款方式
    )
  WITH UNITE_WL_REPAY_PLAN AS (
        SELECT A.LP_ID
              --,DUBIL_ID
              --,B.CORE_DUBIL_ID AS DUBIL_ID --核心借据编号 MOD BY YJY 20250521
              ,A.DUBIL_ID  --MOD BY YJY 20250725
              ,A.PROD_ID  --ADD BY YJY 20250219
              ,A.INIT_REPAY_PERDS AS REPAY_PERDS           --MOD BY LIP 20231011 用原本的还款期数
              ,MAX(A.PAYOFF_DT)   AS PAYOFF_DT
              ,MAX(A.JOB_CD)      AS JOB_CD
              ,MAX(A.CUST_ID)     AS CUST_ID
              ,MAX(A.REPAYBL_DT)  AS REPAYBL_DT
              ,SUM(A.CURR_ISSUE_RECVBL_PRIC) AS CURR_ISSUE_RECVBL_PRIC
              ,SUM(A.CURR_ISSUE_INT_RECVBL)  AS CURR_ISSUE_INT_RECVBL
         FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_PLAN A --联合网贷还款计划  
         -- ADD BY YJY 20250521 通过借据号关联，取联合网贷借据表的核心借据号
         LEFT JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO B
           ON B.DUBIL_ID = A.DUBIL_ID
          AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY A.LP_ID,/*B.CORE_DUBIL_ID*/A.DUBIL_ID,A.PROD_ID,A.INIT_REPAY_PERDS),
  UNITE_WL_REPAY_DTL AS (
        SELECT --T.DUBIL_ID
              -- TA.CORE_DUBIL_ID AS DUBIL_ID --核心借据编号 MOD BY YJY 20250521
               T.DUBIL_ID --MOD BY YJY 20250725
              ,T.REPAY_DT
              ,SUM(T.CURRT_REPAY_PRIC) AS CURRT_REPAY_PRIC
              ,SUM(T.CURR_REPAY_INT) AS CURR_REPAY_INT
         FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_DTL T  --联合网贷还款明细
        INNER JOIN RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO TA  --数据量太大，过滤往年结清的
           ON TA.DUBIL_ID = T.DUBIL_ID
          AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        --WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
        GROUP BY /*TA.CORE_DUBIL_ID*/T.DUBIL_ID,T.REPAY_DT)
  SELECT  V_P_DATE                         AS DATA_DT                 -- 数据日期
         ,A.LP_ID                          AS LGL_REP_ID              -- 法人编号
         ,A.DUBIL_ID                       AS RCPT_ID                 -- 借据编号         
         ,A.REPAY_PERDS                    AS REPY_PRD_NUM            -- 还款期数
         ,TO_CHAR(A.REPAYBL_DT,'YYYYMMDD') AS PRIN_EXP_DT             -- 本金到期日期
         ,A.CURR_ISSUE_RECVBL_PRIC         AS PRIN                    -- 本金
         ,B.CURRT_REPAY_PRIC               AS RET_PRIN                -- 归还本金
         ,TO_CHAR(A.REPAYBL_DT,'YYYYMMDD') AS INT_EXP_DT              -- 利息到期日期
         ,A.CURR_ISSUE_INT_RECVBL          AS INT                     -- 利息
         ,B.CURR_REPAY_INT                 AS RET_INT                 -- 归还利息
         ,NULL                             AS DEPT_LINE               -- 部门条线 800924零售信贷部
         ,CASE WHEN A.PROD_ID IN ('203050100001','203050100002') --MOD BY YJY 20251120 新增203050100002-微众对公联合贷
		           THEN '对公联合网贷' --MOD BY YJY 20250219
			         ELSE '联合网贷'
          END 			                       AS DATA_SRC                -- 数据来源
         ,TO_CHAR(B.REPAY_DT,'YYYYMMDD')   AS REPY_DT                 --还款日期
         ,NULL                             AS REPY_WAY                --还款方式
    FROM UNITE_WL_REPAY_PLAN A
    LEFT JOIN UNITE_WL_REPAY_DTL B   --联合网贷还款明细
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.REPAY_DT = A.PAYOFF_DT;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';
  WITH TMP1 AS (
    SELECT DATA_DT, RCPT_ID,REPY_PRD_NUM,REPY_DT,COUNT(1)
      FROM RRP_MDL.M_LOAN_RP_PLAN_INFO T
     WHERE DATA_DT = V_P_DATE
     GROUP BY DATA_DT, RCPT_ID,REPY_PRD_NUM,REPY_DT
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
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

END ETL_M_LOAN_RP_PLAN_INFO;
/

