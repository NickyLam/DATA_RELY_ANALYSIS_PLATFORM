CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_CRD(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_CRD
  *  功能描述：银行卡整合表
  *  创建日期：20220507
  *  开发人员：蔡正伟
  *  来源表：  M_CRD_INFO
  *            M_CUST_IND_INFO
  *            M_TRA_DEP_ACC_DTL
  *            M_DEP_ACC_INFO
  *            M_DEP_ACC_MED_REL_INFO
  *            M_CUST_CORP_INFO
  *            S_CRD
  *
  *
  *
  *  目标表：  S_CRD
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_CRD'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_QUARTER_START_DATEID  CHAR(8); --本季季初日期
  V_MONTH_START_DATEID    CHAR(8); --本月月初日期
  V_DATE                  DATE; --数据日期(判断输入参数日期格式是否准确)
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_CRD'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_CRD T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_CRD'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  V_DATE                  := TO_DATE(I_P_DATE, 'YYYY-MM-DD');
  V_QUARTER_START_DATEID  := TO_CHAR(TRUNC(V_DATE, 'Q'), 'YYYYMMDD');
  V_MONTH_START_DATEID    := TO_CHAR(TRUNC(V_DATE, 'MM'), 'YYYYMMDD');
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理



  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '银行卡整合表';
  V_STARTTIME := SYSDATE;
  INSERT INTO S_CRD
      (DATA_DT, --数据日期
       LGL_REP_ID, --法人编号
       ORG_ID, --机构编号
       CUST_ID, --客户编号
       CRD_NO, --卡号
       SN, --序号
       CRDL_TYP, --证件类型
       CRDL_NO, --证件号码
       CUST_LRG_CL, --客户大类
       CRD_CUR_TYP, --卡片币种类型
       CUR, --币种
       CRD_STAT, --卡状态
       SUP_CRD_FLG, --副卡标志
       CRD_CL, --卡片种类
       CRD_MED, --卡片介质
       --OFFC_CRD_FLG, --公务卡标志
       ELEC_CASH_PAY_FCN_FLG, --电子现金支付功能标志
       /*LOSS_ACC_FLG, --损失类账户标志
       NOT_OVD_BAL, --未逾期余额
       M1, --M1
       M2, --M2
       M3, --M3
       M4, --M4
       M5, --M5
       M6, --M6
       M6_UP, --M6+*/
       MON_CNSMP_AMT, --本月消费金额
       MON_ENCSHMT_AMT, --本月取现金额
       MON_TRF_AMT, --本月转账金额
       MON_REPY_AMT, --本月还款金额
       QRT_CNSMP_AMT, --本季消费金额
       QRT_ENCSHMT_AMT, --本季取现金额
       QRT_TRF_AMT, --本季转账金额
       QRT_REPY_AMT, --本季还款金额
       CNL_CRD_DT, -- 销卡日期
       CRD_BAL   , -- 卡余额
       DEPT_LINE, --部门条线
       DATA_SRC --数据来源
       )
      WITH TMP_M_TRA_DEP_ACC_DTL AS
       (SELECT T.ACC_ID,
               CASE
                 WHEN T.TRA_TYP = '06' AND --消费
                      T.DATA_DT BETWEEN V_MONTH_START_DATEID AND V_P_DATE THEN
                  SUM(T.TRA_AMT)
                 ELSE
                  0
               END AS MON_CNSMP_AMT, ----本月消费金额
               CASE
                 WHEN T.TRA_TYP = '02' AND --消费
                      T.DATA_DT BETWEEN V_MONTH_START_DATEID AND V_P_DATE THEN
                  SUM(T.TRA_AMT)
                 ELSE
                  0
               END AS MON_ENCSHMT_AMT, --本月取现金额
               CASE
                 WHEN T.TRA_TYP = '01' AND --消费
                      T.DATA_DT BETWEEN V_MONTH_START_DATEID AND V_P_DATE THEN
                  SUM(T.TRA_AMT)
                 ELSE
                  0
               END AS MON_TRF_AMT, --本月转账金额
               0 AS MON_REPY_AMT, --本月还款金额
               CASE
                 WHEN T.TRA_TYP = '06' --消费
                  THEN
                  SUM(T.TRA_AMT)
                 ELSE
                  0
               END AS QRT_CNSMP_AMT, --本季消费金额
               CASE
                 WHEN T.TRA_TYP = '02' --消费
                  THEN
                  SUM(T.TRA_AMT)
                 ELSE
                  0
               END AS QRT_ENCSHMT_AMT, --本季取现金额
               CASE
                 WHEN T.TRA_TYP = '01' --消费
                  THEN
                  SUM(T.TRA_AMT)
                 ELSE
                  0
               END AS QRT_TRF_AMT, --本季转账金额
               0 AS QRT_REPY_AMT --本季还款金额
          FROM M_TRA_DEP_ACC_DTL T
         WHERE T.DATA_DT BETWEEN V_QUARTER_START_DATEID AND V_P_DATE
         GROUP BY T.ACC_ID,T.TRA_TYP, T.DATA_DT)
      SELECT A.DATA_DT AS DATA_DT, --数据日期
             A.LGL_REP_ID AS LGL_REP_ID, --法人编号
             A.ORG_ID AS ORG_ID, --机构编号
             A.CUST_ID AS CUST_ID, --客户编号
             A.CRD_NO AS CRD_NO, --卡号
             A.SN AS SN, --序号
             NVL(B.CRDL_TYP, C.CRDL_TYP) AS CRDL_TYP, --证件类型
             NVL(B.CRDL_NO, C.CRDL_NO) AS CRDL_NO, --证件号码
             CASE
               WHEN C.CUST_ID IS NOT NULL OR B.CUST_CL = 'E' THEN
                '01' --对私客户(含个体工商户)
               WHEN B.CUST_ID IS NOT NULL AND B.CUST_CL != 'E' THEN
                '02' --对公客户（剔除个体工商户）
             END AS CUST_LRG_CL, --客户大类
             A.CRD_CUR_TYP AS CRD_CUR_TYP, --卡片币种类型
             A.CRD_CUR AS CUR, --币种
             A.CRD_STAT AS CRD_STAT, --卡状态
             A.SUP_CRD_FLG AS SUP_CRD_FLG, --副卡标志
             A.CRD_CL AS CRD_CL, --卡片种类
             A.CRD_MED AS CRD_MED, --卡片介质
             --A. AS OFFC_CRD_FLG, --公务卡标志
             A.ELEC_CASH_PAY_FCN_FLG AS ELEC_CASH_PAY_FCN_FLG, --电子现金支付功能标志
             /*A. AS LOSS_ACC_FLG, --损失类账户标志
             A. AS NOT_OVD_BAL, --未逾期余额
             A. AS M1, --M1
             A. AS M2, --M2
             A. AS M3, --M3
             A. AS M4, --M4
             A. AS M5, --M5
             A. AS M6, --M6
             A. AS M6_UP, --M6+*/
             F.MON_CNSMP_AMT   AS MON_CNSMP_AMT, --本月消费金额
             F.MON_ENCSHMT_AMT AS MON_ENCSHMT_AMT, --本月取现金额
             F.MON_TRF_AMT     AS MON_TRF_AMT, --本月转账金额
             F.MON_REPY_AMT    AS MON_REPY_AMT, --本月还款金额
             F.QRT_CNSMP_AMT   AS QRT_CNSMP_AMT, --本季消费金额
             F.QRT_ENCSHMT_AMT AS QRT_ENCSHMT_AMT, --本季取现金额
             F.QRT_TRF_AMT     AS QRT_TRF_AMT, --本季转账金额
             F.QRT_REPY_AMT    AS QRT_REPY_AMT, --本季还款金额
             A.CNL_CRD_DT AS CNL_CRD_DT, -- 销卡日期
             A.CRD_AMT    AS CRD_BAL   , -- 卡余额
             A.DEPT_LINE       AS DEPT_LINE, --部门条线
             A.DATA_SRC        AS DATA_SRC --数据来源
        FROM M_CRD_INFO A --卡基本信息
        LEFT JOIN M_CUST_CORP_INFO B --对公客户信息
          ON A.CUST_ID = B.CUST_ID
         AND B.DATA_DT = V_P_DATE
        LEFT JOIN M_CUST_IND_INFO C --个人客户信息
          ON A.CUST_ID = C.CUST_ID
         AND C.DATA_DT = V_P_DATE
        LEFT JOIN M_DEP_ACC_MED_REL_INFO D --存款账户介质关系信息
          ON A.CRD_NO || SN = D.MED_ID
         AND D.DATA_DT = V_P_DATE
        LEFT JOIN M_DEP_ACC_INFO E --存款账户信息
          ON D.ACC_ID = E.ACC_ID
         AND E.DATA_DT = V_P_DATE
        LEFT JOIN (SELECT ACC_ID,MAX(MON_CNSMP_AMT) MON_CNSMP_AMT ,MAX(MON_ENCSHMT_AMT) MON_ENCSHMT_AMT,MAX(MON_TRF_AMT) MON_TRF_AMT,MAX(MON_REPY_AMT) MON_REPY_AMT,MAX(QRT_CNSMP_AMT) QRT_CNSMP_AMT,MAX(QRT_ENCSHMT_AMT) QRT_ENCSHMT_AMT,
        MAX(QRT_TRF_AMT) QRT_TRF_AMT,MAX(QRT_REPY_AMT) QRT_REPY_AMT  --本月取现金额
        FROM TMP_M_TRA_DEP_ACC_DTL
        GROUP BY ACC_ID) F --存款账户交易流水
          ON E.ACC_ID = F.ACC_ID
      /*LEFT JOIN M_CR_CRD_ACC_INFO G --信用卡账户信息表
       ON A.CRD_NO = G.CRD_NO
      AND A.SN = G.SN
      AND G.DATA_DT = V_P_DATE
        LEFT JOIN M_TRA_CR_CRD_DTL H --信用卡交易流水表
          ON A.CRD_NO = H.CRD_NO
            ---AND A.SN = H.SN
         AND H.DATA_DT = V_P_DATE*/
       WHERE A.DATA_DT = V_P_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;

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
     O_ERRCODE := '0';
     V_ENDTIME := SYSDATE;
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_CRD;
/

