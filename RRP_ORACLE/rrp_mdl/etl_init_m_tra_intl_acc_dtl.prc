CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_TRA_INTL_ACC_DTL(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_TRA_INTL_ACC_DTL
  *  功能描述：监管集市银行业银行机构开设的所有内部账户的信息
  *  初始化一月数据
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
  *             6    20230201  tangan   根据业务卢萌反馈，先去掉交易对手兜底逻辑
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(100);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_TRA_INTL_ACC_DTL'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  V_DATE       DATE; --数据日期(判断输入参数日期格式是否准确)
  V_TAB_NAME VARCHAR2(100) := 'M_TRA_INTL_ACC_DTL'; --表名
  V_PART_NAME VARCHAR2(100);
  --V_RPT_NO    VARCHAR2(100) := 'M_DEP_INTL_ACC_INFO'; -- 内部分户账信息
  V_START_DT CHAR(8) ;       --月初日期

  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  --V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  --V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;
  V_TAB_NAME := 'M_TRA_INTL_ACC_DTL'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  /*判断传入日期参数是否正确*/
  IF I_P_DATE IS NOT NULL THEN
    V_DATE := TO_DATE(I_P_DATE, 'yyyymmdd');
  END IF;

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


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分户账号信息--存款分户信息';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01';
  INSERT INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01(
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    CORP_ACCT_FLG,            --对公账户标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    FLAG                      --标志
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
         A.ACCT_ID                          AS ACCT_ID,                  --账户编号
         A.ACCT_NAME                        AS ACCT_NAME,                --账户名称
         A.CUST_ACCT_ID                     AS CUST_ACCT_ID,             --客户账户编号
         A.CUST_ACCT_SUB_ACCT_NUM           AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         A.CDS_LIAB_ACCT_NUM                AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         A.CUST_ID                          AS CUST_ID,                  --客户编号
         A.SUBJ_ID                          AS SUBJ_ID,                  --科目编号
         B.SUBJ_NAME                        AS SUBJ_NAME,                --科目名称
         A.CORP_ACCT_FLG                    AS CORP_ACCT_FLG,            --对公账户标志 0对私 1对公
         A.BELONG_ORG_ID                    AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME,                 --目标机构银行机构名称
         'F'                                AS FLAG                      --标志 F分户 N内部户 L对公贷款
    --FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
    FROM (SELECT DISTINCT ETL_DT,ACCT_ID,ACCT_NAME,CUST_ACCT_ID,CUST_ACCT_SUB_ACCT_NUM,CDS_LIAB_ACCT_NUM,CUST_ID,SUBJ_ID,CORP_ACCT_FLG,BELONG_ORG_ID
          FROM (
               SELECT ETL_DT,ACCT_ID,ACCT_NAME,CUST_ACCT_ID,CUST_ACCT_SUB_ACCT_NUM,CDS_LIAB_ACCT_NUM,CUST_ID,SUBJ_ID,CORP_ACCT_FLG,BELONG_ORG_ID
               FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
               WHERE ETL_DT = V_DATE
               AND TRIM(CUST_ACCT_ID) IS NOT NULL
               UNION ALL
               SELECT ETL_DT,ACCT_ID,ACCT_NAME,CUST_ACCT_CARD_NO AS CUST_ACCT_ID,CUST_ACCT_SUB_ACCT_NUM,CDS_LIAB_ACCT_NUM,CUST_ID,SUBJ_ID,CORP_ACCT_FLG,BELONG_ORG_ID
               FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
               WHERE ETL_DT = V_DATE
               AND TRIM(CUST_ACCT_CARD_NO) IS NOT NULL
          ) T
       ) A
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B --科目信息
           ON B.SUBJ_ID = A.SUBJ_ID
          AND B.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.ORG_CONFIG C
           ON C.ORG_ID = A.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
           ON D.ORG_ID = '800'
  WHERE A.ETL_DT = V_DATE;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '分户账号信息--内部账户';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01(
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    CORP_ACCT_FLG,            --对公账户标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    FLAG                      --标志
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
         A.ACCT_ID                          AS ACCT_ID,                  --账户编号
         A.ACCT_NAME                        AS ACCT_NAME,                --账户名称
         A.MAIN_ACCT_ID                     AS CUST_ACCT_ID,             --客户账户编号
         A.SUB_ACCT_NUM                     AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         NULL                               AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         NULL                               AS CUST_ID,                  --客户编号
         A.SUBJ_ID                          AS SUBJ_ID,                  --科目编号
         B.SUBJ_NAME                        AS SUBJ_NAME,                --科目名称
         '1'                                AS CORP_ACCT_FLG,            --对公账户标志 0对私 1对公
         A.BELONG_ORG_ID                    AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME,                 --目标机构银行机构名称
         'N'                                AS FLAG                      --标志 F分户 N内部户 L对公贷款
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A --内部账户
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B --科目信息
           ON B.SUBJ_ID = A.SUBJ_ID
          AND B.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.ORG_CONFIG C
           ON C.ORG_ID = A.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
           ON D.ORG_ID = '800'
  WHERE A.ETL_DT = V_DATE
      ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '分户账号信息--对公贷款账户信息';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01(
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    CORP_ACCT_FLG,            --对公账户标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    FLAG                      --标志
    )
  SELECT /*+USE_HASH(A,B,C,D)*/
         A.ACCT_ID                          AS ACCT_ID,                  --账户编号
         A.ACCT_NAME                        AS ACCT_NAME,                --账户名称
         A.DUBIL_NUM                        AS CUST_ACCT_ID,             --客户账户编号
         NULL                               AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         NULL                               AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         A.CUST_ID                          AS CUST_ID,                  --客户编号
         A.SUBJ_ID                          AS SUBJ_ID,                  --科目编号
         B.SUBJ_NAME                        AS SUBJ_NAME,                --科目名称
         '1'                                AS CORP_ACCT_FLG,            --对公账户标志 0对私 1对公
         A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         NVL(C.ORG_NAME,D.ORG_NAME)         AS ORG_NAME,                 --目标机构银行机构名称
         'L'                                AS FLAG                      --标志 F分户 N内部户 L对公贷款
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B --科目信息
           ON B.SUBJ_ID = A.SUBJ_ID
          AND B.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.ORG_CONFIG C
           ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
           ON D.ORG_ID = '800'
  WHERE A.ETL_DT = V_DATE;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '交易信息临时表处理';
    V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP04';

  INSERT INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP04 NOLOGGING
    (DATA_DT             ,  --数据日期
     TRAN_DT             ,  --交易日期
     TRAN_FLOW_NUM       ,  --交易流水号
     TRA_SEQ_NO          ,  --交易流水号
     OPP_ACC_ID          ,  --对方账户ID
     OPP_CUST_ACCT_ID    ,  --对方账户
     OPP_SUB_ACCT_ID     ,  --对方账户子序号
     NU                     --序号
     )
/*  SELECT \*+USE_HASH(A,B,X,E,C,F,D,G)*\
         TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                                 AS DATA_DT,         --数据日期
         A.TRAN_DT                                                                     AS TRAN_DT,         --交易日期
         A.TRAN_FLOW_NUM                                                               AS TRAN_FLOW_NUM,   --交易流水号
         TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM          AS TRA_SEQ_NO,      --交易流水号
         COALESCE(TRIM(B.DEP_SUB_ACCT_ID),TRIM(X.DEP_SUB_ACCT_ID))                     AS OPP_ACC_ID,      --对方账户ID
         TRIM(A.CNTPTY_ACCT_ID)                                                        AS OPP_CUST_ACCT_ID,--对方账户
         TRIM(A.CNTPTY_SUB_ACCT_ID)                                                    AS OPP_SUB_ACCT_ID, --对方账户子序号
         ROW_NUMBER() OVER(PARTITION BY A.TRAN_DT,A.TRAN_FLOW_NUM,A.ACCT_BILL_FLOW_NUM
                      ORDER BY COALESCE(B.TRAN_AMT,X.TRAN_AMT) DESC)                   AS NU --序号
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
   INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT D --内部账户
      ON \*D.SUB_ACCT_NUM = A.SUB_ACCT_ID AND*\ \*A.CUST_ID*\ A.DEP_SUB_ACCT_ID = D.ACCT_ID
     AND SUBSTR(D.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')--不用上报科目
     AND D.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL B --存款分户账交易明细
      ON B.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND B.TRAN_DT = A.TRAN_DT
     AND B.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL X --内部帐户交易明细
      ON X.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND X.TRAN_DT = A.TRAN_DT
     AND X.ETL_DT = V_DATE
     ;*/  ---modify by tangan ta 20220111
    SELECT T.DATA_DT        AS DATA_DT             ,  --数据日期
           T.TRAN_DT        AS TRAN_DT             ,  --交易日期
           T.TRAN_FLOW_NUM  AS TRAN_FLOW_NUM       ,  --交易流水号
           T.TRA_SEQ_NO     AS TRA_SEQ_NO          ,  --交易流水号
           T.OPP_ACC_ID     AS OPP_ACC_ID          ,  --对方账户ID
           NULL             AS OPP_CUST_ACCT_ID    ,  --对方账户
           NULL             AS OPP_SUB_ACCT_ID     ,  --对方账户子序号
           1                AS NU                     --序号
    FROM
    (
    ---交易方向为D-借方，对手方应该取C-贷方信息
    SELECT DISTINCT
           TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                                 AS DATA_DT,         --数据日期
           A.TRAN_DT                                                                     AS TRAN_DT,         --交易日期
           A.TRAN_FLOW_NUM                                                               AS TRAN_FLOW_NUM,   --交易流水号
           TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM          AS TRA_SEQ_NO,      --交易流水号
           /*COALESCE(TRIM(C.DEP_SUB_ACCT_ID),TRIM(A.DEP_SUB_ACCT_ID))                     AS OPP_ACC_ID       --对方账户ID*/
           TRIM(C.DEP_SUB_ACCT_ID)                                                       AS OPP_ACC_ID       --对方账户ID
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT  B --内部账户
       ON A.DEP_SUB_ACCT_ID = B.ACCT_ID
      AND B.ETL_DT = V_DATE
    LEFT JOIN (
            SELECT DISTINCT TRAN_FLOW_NUM, DEP_SUB_ACCT_ID, TRAN_CURR_CD, CUST_ACCT_ID, SUB_ACCT_ID
            FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL AA --存款账户交易明细
            WHERE AA.TRAN_DT = V_DATE
            AND AA.ETL_DT = V_DATE
            AND AA.DEBIT_CRDT_DIR_CD = 'C' --贷方
      ) C
     ON A.TRAN_FLOW_NUM = C.TRAN_FLOW_NUM
    AND A.TRAN_CURR_CD = C.TRAN_CURR_CD
    AND NVL(TRIM(A.CNTPTY_ACCT_ID),A.CUST_ACCT_ID) = C.CUST_ACCT_ID
    AND NVL(TRIM(A.CNTPTY_SUB_ACCT_ID),A.SUB_ACCT_ID) = C.SUB_ACCT_ID
    WHERE A.TRAN_DT = V_DATE
    AND SUBSTR(B.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')--不用上报科目
    AND A.ETL_DT = V_DATE
    AND A.DEBIT_CRDT_DIR_CD = 'D'  --借方
    UNION ALL
    ---交易方向为C-贷方，对手方应该取D-借方信息
    SELECT DISTINCT
           TO_CHAR(A.TRAN_DT,'YYYYMMDD')                                                 AS DATA_DT,         --数据日期
           A.TRAN_DT                                                                     AS TRAN_DT,         --交易日期
           A.TRAN_FLOW_NUM                                                               AS TRAN_FLOW_NUM,   --交易流水号
           TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM          AS TRA_SEQ_NO,      --交易流水号
           /*COALESCE(TRIM(C.DEP_SUB_ACCT_ID),TRIM(A.DEP_SUB_ACCT_ID))                     AS OPP_ACC_ID       --对方账户ID*/
           TRIM(C.DEP_SUB_ACCT_ID)                                                       AS OPP_ACC_ID       --对方账户ID
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT  B --内部账户
       ON A.DEP_SUB_ACCT_ID = B.ACCT_ID
      AND B.ETL_DT = V_DATE
    LEFT JOIN (
            SELECT DISTINCT TRAN_FLOW_NUM, DEP_SUB_ACCT_ID, TRAN_CURR_CD, CUST_ACCT_ID, SUB_ACCT_ID
            FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL AA --存款账户交易明细
            WHERE AA.TRAN_DT = V_DATE
            AND AA.ETL_DT = V_DATE
            AND AA.DEBIT_CRDT_DIR_CD = 'D'  --借方
      ) C
     ON A.TRAN_FLOW_NUM = C.TRAN_FLOW_NUM
    AND A.TRAN_CURR_CD = C.TRAN_CURR_CD
    AND NVL(TRIM(A.CNTPTY_ACCT_ID),A.CUST_ACCT_ID) = C.CUST_ACCT_ID
    AND NVL(TRIM(A.CNTPTY_SUB_ACCT_ID),A.SUB_ACCT_ID) = C.SUB_ACCT_ID
    WHERE A.TRAN_DT = V_DATE
    AND SUBSTR(B.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')--不用上报科目
    AND A.ETL_DT = V_DATE
    AND A.DEBIT_CRDT_DIR_CD = 'C' --贷方
    ) T
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '交易对手子表';
    V_STARTTIME := SYSDATE;
    EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP';
    INSERT /*+APPEND*/ INTO RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP NOLOGGING --交易对手子表
    (DATA_DT,     --数据日期
     TRA_SEQ_NO,  --交易流水号
     ACC_ID,      --对方账户ID
     OPP_SUBJ_ID, --对方科目编号
     OPP_SUBJ_NM, --对方科目名称
     OPP_ACC,     --对方账号
     OPP_ACC_NM,  --对方户名
     OPP_PBC_NO,  --对方行号
     OPP_BANK_NM  --对方行名
     )
    WITH ACC_DTL_TEMP01 AS (
    SELECT
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    CORP_ACCT_FLG,            --对公账户标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    FLAG,                      --标志
    ROW_NUMBER() OVER(PARTITION BY ACCT_ID ORDER BY CASE WHEN FLAG = 'F' THEN 1
                                                         WHEN FLAG = 'L' THEN 2
                                                         WHEN FLAG = 'N' THEN 3
                                                         ELSE 4
                                                    END)       AS NU --序号  --modify by tangan at 20230111
    FROM RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01)
    SELECT /*+USE_HASH(A,F,D,G)*/
         A.DATA_DT                                              AS DATA_DT,     --数据日期
         A.TRA_SEQ_NO                                           AS TRA_SEQ_NO,  --交易流水号
         COALESCE(F.ACCT_ID,D.ACCT_ID,G.ACCT_ID)                AS ACC_ID,      --对方账户ID
         COALESCE(F.SUBJ_ID,D.SUBJ_ID,G.SUBJ_ID)                AS OPP_SUBJ_ID, --对方科目编号
         COALESCE(F.SUBJ_NAME,D.SUBJ_NAME,G.SUBJ_NAME)          AS OPP_SUBJ_NM, --对方科目名称
         COALESCE(F.CUST_ACCT_ID,D.CUST_ACCT_ID,G.CUST_ACCT_ID) AS OPP_ACC, -- 对方账户号
         COALESCE(F.ACCT_NAME,D.ACCT_NAME,G.ACCT_NAME)          AS OPP_ACC_NM,  --对方户名
         COALESCE(F.FIN_INST_CODE,D.FIN_INST_CODE,G.FIN_INST_CODE) AS OPP_PBC_NO, --对方行号
         COALESCE(F.ORG_NAME,D.ORG_NAME,G.ORG_NAME)             AS OPP_BANK_NM --对方行名
    FROM RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP04 A --交易信息临时表
    LEFT JOIN ACC_DTL_TEMP01 F --分户账号信息--临时表
      ON F.ACCT_ID = A.OPP_ACC_ID
     AND F.NU = 1  --modify by tangan at 20230104
    LEFT JOIN ACC_DTL_TEMP01 D --分户账号信息--临时表
      ON D.CUST_ACCT_ID = A.OPP_CUST_ACCT_ID
     AND A.OPP_SUB_ACCT_ID IS NULL
     AND D.FLAG IN ('N','L') --借据、内部户
     AND F.NU = 1  --modify by tangan at 20230104
    LEFT JOIN ACC_DTL_TEMP01 G --分户账号信息--临时表
      ON G.CUST_ACCT_ID = A.OPP_CUST_ACCT_ID
     AND G.CUST_ACCT_SUB_ACCT_NUM = A.OPP_SUB_ACCT_ID
     AND A.OPP_SUB_ACCT_ID IS NOT NULL
     AND G.FLAG IN ('N','F') --借据、内部户
   WHERE A.NU = 1;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入内部分户账核心交易流水';
    V_STARTTIME := SYSDATE;
    INSERT /*+APPEND */INTO RRP_MDL.M_TRA_INTL_ACC_DTL NOLOGGING
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
    )
    WITH SUBJ_TEMP01 AS (
        SELECT
        ACCT_ID,                  --账户编号
        ACCT_NAME,                --账户名称
        CUST_ACCT_ID,             --客户账户编号
        CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
        CDS_LIAB_ACCT_NUM,        --负债账户编号
        CUST_ID,                  --客户编号
        SUBJ_ID,                  --科目编号
        SUBJ_NAME,                --科目名称
        CORP_ACCT_FLG,            --对公账户标志
        BELONG_ORG_ID,            --所属机构编号
        ORG_ID1,                  --目标机构号
        FIN_INST_CODE,            --目标机构银行机构代码
        ORG_NAME,                 --目标机构银行机构名称
        FLAG,                      --标志
        ROW_NUMBER() OVER(PARTITION BY ACCT_ID ORDER BY CASE WHEN FLAG = 'F' THEN 1
                                                             WHEN FLAG = 'L' THEN 2
                                                             WHEN FLAG = 'N' THEN 3
                                                             ELSE 4
                                                        END)       AS NU --序号  --modify by tangan at 20230111
        FROM RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01
        WHERE TRIM(ACCT_ID) IS NOT NULL
   ),SUBJ_TEMP02 AS (
        SELECT
        ACCT_ID,                  --账户编号
        ACCT_NAME,                --账户名称
        CUST_ACCT_ID,             --客户账户编号
        CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
        CDS_LIAB_ACCT_NUM,        --负债账户编号
        CUST_ID,                  --客户编号
        SUBJ_ID,                  --科目编号
        SUBJ_NAME,                --科目名称
        CORP_ACCT_FLG,            --对公账户标志
        BELONG_ORG_ID,            --所属机构编号
        ORG_ID1,                  --目标机构号
        FIN_INST_CODE,            --目标机构银行机构代码
        ORG_NAME,                 --目标机构银行机构名称
        FLAG,                      --标志
        ROW_NUMBER() OVER(PARTITION BY CUST_ACCT_ID ORDER BY CASE WHEN FLAG = 'F' THEN 1
                                                             WHEN FLAG = 'L' THEN 2
                                                             WHEN FLAG = 'N' THEN 3
                                                             ELSE 4
                                                        END)       AS NU --序号  --modify by tangan at 20230111
        FROM RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP01
        WHERE TRIM(CUST_ACCT_ID) IS NOT NULL
  )
  SELECT /*+USE_HASH(A,TMP,J,B,D,E,F,BB,BD,K,K1,K2,K3,KK,KKB)*/
          TO_CHAR(A.TRAN_DT,'YYYYMMDD')                     AS DATA_DT          --数据日期
         ,A.LP_ID                                          AS LGL_REP_ID       --法人编号
         ,TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM AS TRA_SEQ_NO --交易流水号
         ,A.CUST_ACCT_ID                                    AS LGL_REP_ID       --账户编号
         ,/*KK.ORG_ID1*/  A.ACCT_ORG_ID                     AS ORG_ID           --机构编号
         ,D.SUBJ_ID                                        AS SUBJ_ID          --科目编号
         ,A.TRAN_CURR_CD                                   AS CUR              --币种
         ,B.ACCT_NAME                                      AS ACC_NM           --账户名称
         ,A.TRAN_KIND_CD                                   AS TRA_TYP          --交易类型  --modify by tangan at 20230105
         ,A.TRAN_AMT                                       AS TRA_AMT          --交易金额
         ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN TRIM(TC.OPP_ACC)  --modify by tangan at 20230207
               WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_ID)
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_ID)
          END                                             AS OPP_ACC          --对方账号
         ,CASE --WHEN TRIM(TMP.OPP_SUBJ_ID) IS NOT NULL THEN TRIM(TMP.OPP_SUBJ_ID)
               WHEN TRIM(TC.OPP_SUBJ_ID) IS NOT NULL THEN TRIM(TC.OPP_SUBJ_ID) --modify by tangan at 20230207
               WHEN TRIM(S2.SUBJ_ID) IS NOT NULL THEN TRIM(S2.SUBJ_ID)
               WHEN TRIM(S1.SUBJ_ID) IS NOT NULL THEN TRIM(S1.SUBJ_ID)
          END                                             AS OPP_SUBJ_ID      --对方科目编号
         ,CASE --WHEN TRIM(TMP.OPP_SUBJ_NM) IS NOT NULL THEN TRIM(TMP.OPP_SUBJ_NM)
               WHEN TRIM(TC.OPP_SUBJ_NM) IS NOT NULL THEN TRIM(TC.OPP_SUBJ_NM) --modify by tangan at 20230207
               WHEN TRIM(S2.SUBJ_NAME) IS NOT NULL THEN TRIM(S2.SUBJ_NAME)
               WHEN TRIM(S1.SUBJ_NAME) IS NOT NULL THEN TRIM(S1.SUBJ_NAME)
          END                                             AS OPP_SUBJ_NM      --对方科目名称
         ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN TRIM(TC.OPP_ACC_NM)  --modify by tangan at 20230207
               WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.REAL_CNTPTY_ACCT_NAME)
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN TRIM(A.CNTPTY_ACCT_NAME)
          END                                             AS OPP_ACC_NM       --对方户名
         ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN NVL(TRIM(B3.FIN_INST_CODE),TRIM(TC.OPP_PBC_NO))  --modify by tangan at 20230207
               WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B2.FIN_INST_CODE),TRIM(A.REAL_CNTPTY_FIN_INST_CD))
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B1.FIN_INST_CODE),TRIM(A.CNTPTY_OPEN_BANK_ID))
          END                                             AS OPP_PBC_NO       --对方行号
         /*---modify by tangan at 20230201 应业务卢萌要求修改 END----*/
         /*UPDATE BY CXL 20220516*/
         --,NVL(K1.TAR_VALUE_CODE,'99-0000')                 AS TRA_CHAN         --交易渠道
         ,A.CHN_CD     AS TRA_CHAN         --交易渠道 --modify by tangan at 20221205
        /* ,CASE WHEN NVL(K.MEMO_CODE_DESCB,A.MEMO_CD_DESCB) LIKE '%现金%' THEN '1'  --modify by tangan at 20230105
               WHEN NVL(K.MEMO_CODE_DESCB,A.MEMO_CD_DESCB) LIKE '%转账%' THEN '2'  --modify by tangan at 20230105
               WHEN A.MEMO_CD IN ('AC','YL','AD','CR') THEN '1' \*AC银联取现 YL银联  AD  ATM存款  CR  存入  现金*\
               WHEN E.TRAN_DT IS NOT NULL THEN '1'  --优先判断现金登记簿是否是现金,因为有现金转账的情况--MODIFY BY LIP 20220722
               \*WHEN A.TRAN_KIND_CD LIKE 'C%' THEN '1' --交易种类
               WHEN A.TRAN_KIND_CD LIKE 'T%' THEN '2'
               WHEN SUBSTR(A.TRAN_KIND_CD,0,1) NOT IN ('C','T') AND E.TRAN_DT IS NOT NULL THEN '1'
               WHEN SUBSTR(A.TRAN_KIND_CD,0,1) NOT IN ('C','T') AND A.TRAN_KIND_CD IS NOT NULL AND E.TRAN_DT IS NULL THEN '2'*\
               WHEN (SUBSTR(A.TRAN_KIND_CD,1,2) IN ('10','CA','CC','CE','CL','CM') OR A.TRAN_KIND_CD IN ('CK02','CS','CY05','CY06')) THEN '1' --交易种类  modify by tangan at 20230105
               WHEN SUBSTR(A.TRAN_KIND_CD,0,1) IN ('T','0') THEN '2'
               WHEN SUBSTR(A.TRAN_KIND_CD,0,1) NOT IN ('C','T','1','0') AND E.TRAN_DT IS NOT NULL THEN '1'
               WHEN SUBSTR(A.TRAN_KIND_CD,0,1) NOT IN ('C','T','1','0') AND A.TRAN_KIND_CD IS NOT NULL AND E.TRAN_DT IS NULL THEN '2'
               ELSE '2'
           END                                             AS CASH_TRF_FLG     --现转标志*/
         ,CASE WHEN A.CASH_TRANS_FLG = '1' THEN '1' -- 现
               WHEN A.CASH_TRANS_FLG = '0' THEN '2' -- 转
               ELSE '2'
          END                                              AS CASH_TRF_FLG     --现转标志 --modify by tangan at 20230215
         ,A.ENTRY_TELLER_ID                                AS TRA_TLR_NO       --交易柜员号
         ,/*A.CHECK_TELLER_ID*/ A.AUTH_TELLER_ID           AS GRANT_TLR_NO     --授权柜员号
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                   AS ENT_ACCT_DT      --进账日期
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                   AS WRT_OFF_DT       --销账日期
         ,NVL(K.MEMO_CODE_DESCB,A.MEMO_CD_DESCB)           AS ABSTR            --摘要
         ,CASE WHEN A.ERASE_ACCT_FLG = '1' THEN '4'--抹账  --modify by tangan at 20230106 码值调整CD1674
               WHEN A.REVS_FLG = '1' THEN '2' --冲账
               WHEN NVL(K.MEMO_CODE_DESCB,A.MEMO_CD_DESCB) LIKE '%冲账%' THEN '2' --冲账
               ELSE '1'  --正常
           END                                             AS FLUSH_PATCH_FLG  --冲补抹标志
         ,DECODE(A.DEBIT_CRDT_DIR_CD,'R','C','P','D', A.DEBIT_CRDT_DIR_CD) AS TRA_DR_CR_FLG --交易借贷标志
         ,TO_CHAR(A.TRAN_DT, 'YYYYMMDD')                   AS TRA_DT           --交易日期
         --MODIFY BY 蔡正伟 20220429 修改核心交易时间加工逻辑 BEGIN
         --,TO_TIMESTAMP(TO_CHAR(A.TRAN_DT,'YYYYMMDD'),'YYYYMMDD HH24:MI:SS') AS TRA_TM --交易时间
         ,A.TRAN_TIMESTAMP                                        AS TRA_TM           --交易时间
         --MODIFY BY 蔡正伟 20220429 修改核心交易时间加工逻辑 END
         ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'D' THEN A.TRAN_BAL
               ELSE 0
           END                                             AS DR_BAL           --借方余额
         ,CASE WHEN A.DEBIT_CRDT_DIR_CD = 'C' THEN A.TRAN_BAL
               ELSE 0
           END                                             AS CR_BAL           --贷方余额
         --,H.ORG_NAME                                     AS OPP_BANK_NM      --对方行名
         /*,CASE WHEN TRIM(TMP.OPP_BANK_NM) IS NOT NULL THEN TRIM(TMP.OPP_BANK_NM)
               WHEN K1.TAR_VALUE_NAME LIKE '%同业%' AND \*K2.TAR_VALUE_NAME = '转账'*\ NVL(K.MEMO_CODE_DESCB,A.MEMO_CD_DESCB) LIKE '%转账%' THEN KK.ORG_NAME --渠道为同业,转账为自己转自己
           END                                  AS OPP_BANK_NM      --对方行名*/
         ,CASE WHEN TRIM(TC.TRA_SEQ_NO) IS NOT NULL THEN NVL(TRIM(B3.ORG_NAME),TRIM(TC.OPP_BANK_NM))  --modify by tangan at 20230207
               WHEN TRIM(A.REAL_CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B2.ORG_NAME),TRIM(A.REAL_CNTPTY_FIN_INST_NAME))
               WHEN TRIM(A.CNTPTY_ACCT_ID) IS NOT NULL THEN NVL(TRIM(B1.ORG_NAME),TRIM(A.CNTPTY_OPEN_BANK_NAME))
          END                                              AS OPP_BANK_NM      --对方行名  --modify by tangan at 20230201 应业务卢萌要求修改
         ,'800001' /*营运管理部*/                          AS DEPT_LINE        --部门条线
        -- ,SUBSTR(A.JOB_CD, 0, 4)                           AS DATA_SRC         --数据来源
         ,'核心数据'                                       AS DATA_SRC         --数据来源
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL A --存款账户交易明细
    INNER JOIN RRP_MDL.O_ICL_CMM_INTNAL_ACCT  B --内部账户
      ON /*B.SUB_ACCT_NUM = A.SUB_ACCT_ID
     AND*/ A.DEP_SUB_ACCT_ID = B.ACCT_ID
     AND B.ETL_DT = V_DATE
    /*LEFT JOIN RRP_MDL.O_ICL_CMM_INTNAL_ORG_INFO C --内部机构信息表
      ON C.ORG_ID = A.ACCT_ORG_ID
     AND C.ETL_DT = V_DATE*/
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO D --科目信息
      ON D.SUBJ_ID = B.SUBJ_ID
     AND D.ETL_DT = V_DATE
    LEFT JOIN RRP_MDL.M_TRA_INTL_ACC_DTL_TEMP03 E --MODIFY BY LIP 20220726
      ON E.TRAN_FLOW_NUM = A.TRAN_FLOW_NUM
     AND E.TRAN_DT = A.TRAN_DT
    LEFT JOIN RRP_MDL.O_IML_REF_TRAN_MEMO_CODE_PARA_TAB K --modify by tangan at 20230203
      ON A.MEMO_CD = K.MEMO_CODE
     AND K.START_DT <= V_DATE
     AND K.END_DT > V_DATE
    LEFT JOIN RRP_MDL.CODE_MAP K1  --交易渠道
      ON K1.SRC_VALUE_CODE = A.CHN_CD
     AND K1.SRC_CLASS_CODE = 'CD1751'
     AND K1.TAR_CLASS_CODE = 'Z0014'
     AND K1.MOD_FLG = 'MDM'            --监管集市明细层
    LEFT JOIN RRP_MDL.M_MID_TRA_CNTPTY_INFO TC --交易对手信息中间表 --add by tangan at 20230207
      ON TC.TRA_SEQ_NO = TO_CHAR(A.TRAN_DT,'YYYYMMDD')||A.TRAN_FLOW_NUM||A.ACCT_BILL_FLOW_NUM
     AND TC.TRA_DT = TO_CHAR(A.TRAN_DT,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG B1  --modify by tangan at 20230201
      ON B1.ORG_ID = A.CNTPTY_OPEN_BANK_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG B2  --modify by tangan at 20230201
      ON B2.ORG_ID = A.REAL_CNTPTY_FIN_INST_CD
    LEFT JOIN RRP_MDL.ORG_CONFIG B3  --modify by tangan at 20230207
      ON B3.ORG_ID = TC.OPP_PBC_NO
    LEFT JOIN SUBJ_TEMP01 S1 --modify by tangan at 20230201
      --ON NVL(NVL(TRIM(A.REAL_CNTPTY_ACCT_ID),TRIM(A.CNTPTY_ACCT_ID)),TRIM(TC.OPP_ACC)) = S1.ACCT_ID
      ON S1.ACCT_ID = NVL(NVL(TRIM(TC.OPP_ACC),TRIM(A.REAL_CNTPTY_ACCT_ID)),TRIM(A.CNTPTY_ACCT_ID))
     AND S1.NU = 1
    LEFT JOIN SUBJ_TEMP02 S2 --modify by tangan at 20230201
      --ON NVL(NVL(TRIM(A.REAL_CNTPTY_ACCT_ID),TRIM(A.CNTPTY_ACCT_ID)),TRIM(TC.OPP_ACC)) = S2.CUST_ACCT_ID
      ON S2.CUST_ACCT_ID = NVL(NVL(TRIM(TC.OPP_ACC),TRIM(A.REAL_CNTPTY_ACCT_ID)),TRIM(A.CNTPTY_ACCT_ID))
     AND S2.NU = 1
   WHERE A.TRAN_DT = V_DATE
     /*AND NOT EXISTS (SELECT 1 FROM ACCT_TMP T WHERE T.ACCT_ID=A.INTNAL_ACCT_ID )*/
    AND SUBSTR(B.SUBJ_ID, 1, 4) NOT IN ('6402','6403','6411','6413','6414','6421','6602','6701','6711','6801')--不用上报科目
    AND TRUNC(A.TRAN_DT,'MM') = TRUNC(V_DATE,'MM')
    ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


    V_STEP := V_STEP + 1;
    V_STEP_DESC := '插入内部分户账核算中台交易流水';  --ADD BY TANGAN AT 20230213
    V_STARTTIME := SYSDATE;

    INSERT /*+APPEND */INTO RRP_MDL.M_TRA_INTL_ACC_DTL NOLOGGING
    (
       DATA_DT                        --数据日期
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
    )
    SELECT A.TRANDT                                AS DATA_DT                        --数据日期
          ,'9999'                                  AS LGL_REP_ID                     --法人编号
          ,A.TRANSQ || A.VCHRSQ                    AS TRA_SEQ_NO                     --交易流水号
          ,A.ACCTBR || A.ITEMCD || A.CRCYCD        AS ACC_ID                         --账户编号
          ,A.ACCTBR                                AS ORG_ID                         --机构编号
          ,A.ITEMCD                                AS SUBJ_ID                        --科目编号
          ,A.CRCYCD                                AS CUR                            --币种
          ,A.ITEMNA                                AS ACC_NM                         --账户名称
          ,CASE WHEN NVL(A.TRANTP,'*') = '*' THEN '99'
                ELSE A.TRANTP
           END                                     AS TRA_TYP                        --交易类型
          ,A.TRANAM                                AS TRA_AMT                        --交易金额
          ,C.TX_CNTPTY_ACCT_NUM                    AS OPP_ACC                        --对方账号
          ,TRIM(A.TOITEM)                          AS OPP_SUBJ_ID                    --对方科目编号
          ,TRIM(B.SUBJ_NAME)                       AS OPP_SUBJ_NM                    --对方科目名称
          ,C.TX_CNTPTY_NAME                        AS OPP_ACC_NM                     --对方户名
          ,C.CNTPTY_FIN_INST_BRAC_CD               AS OPP_PBC_NO                     --对方行号
          ,A.ASSIS0                                AS TRA_CHAN                       --交易渠道
          ,''                                      AS CASH_TRF_FLG                   --现转标志
          ,NULL                                    AS TRA_TLR_NO                     --交易柜员号
          ,NULL                                    AS GRANT_TLR_NO                   --授权柜员号
          ,A.TRANDT                                AS ENT_ACCT_DT                    --进账日期
          ,A.TRANDT                                AS WRT_OFF_DT                     --销账日期
          ,CASE WHEN A.TRANTP = 'TR' THEN '转账'
                ELSE '其他'
           END                                     AS ABSTR                          --摘要
          ,CASE WHEN A.STRKST = '9' THEN '2' --冲账
                ELSE '1'  --正常
           END                                     AS FLUSH_PATCH_FLG                --冲补抹标志
          ,A.AMNTCD                                AS TRA_DR_CR_FLG                  --交易借贷标志
          ,A.TRANDT                                AS TRA_DT                         --交易日期
          ,NULL                                    AS TRA_TM                         --交易时间
          ,CASE WHEN A.AMNTCD = 'D' THEN A.TRANBL
                   ELSE 0
           END                                     AS DR_BAL                         --借方余额
          ,CASE WHEN A.AMNTCD = 'C' THEN A.TRANBL
                   ELSE 0
           END                                     AS CR_BAL                         --贷方余额
          ,C.CNTPTY_FIN_INST_BRAC_NAME             AS OPP_BANK_NM                    --对方行名
          ,'800001' /*营运管理部*/                 AS DEPT_LINE                      --部门条线
          ,'核算中台'                              AS DATA_SRC                       --数据来源
    FROM RRP_MDL.O_IOL_TGLS_GLA_VCHR_H A     --核算中台的交易表
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B  --科目信息
      ON TRIM(A.TOITEM) = B.SUBJ_ID
     AND B.ETL_DT = V_DATE
    LEFT JOIN (
         SELECT CC.*
               ,ROW_NUMBER() OVER(PARTITION BY CC.CORE_TRAN_FLOW_NUM,CC.BIZ_SEQ_NUM,CC.TRA_SEQ_NO ORDER BY CC.TX_CNTPTY_ACCT_NUM DESC) AS RN
         FROM RRP_MDL.O_IOL_TX_CNTPTY_INFO CC --交易对手视图
         /*WHERE CC.START_DT <= V_DATE
           AND CC.END_DT > V_DATE*/
       ) C
      ON C.CORE_TRAN_FLOW_NUM = A.BSNSSQ --全局流水号
     AND C.BIZ_SEQ_NUM = A.SOURSQ        --系统流水号
     AND C.TRA_SEQ_NO = A.SRVCSQ         --交易序号
     AND C.RN = 1
    WHERE A.STACID = 1  --基础账套
      AND A.SYSTID NOT IN ('NCBS','IFSX')  --剔除新核心、互联网金融数据 暂定 modify by tangan at 20230215
      AND TO_DATE(A.TRANDT,'YYYYMMDD') >= TRUNC(V_DATE,'MM')
      AND TO_DATE(A.TRANDT,'YYYYMMDD') <= V_DATE
    ;

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



     -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

  END ETL_INIT_M_TRA_INTL_ACC_DTL;
/

