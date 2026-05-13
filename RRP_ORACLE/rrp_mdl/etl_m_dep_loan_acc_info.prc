CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_DEP_LOAN_ACC_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_M_DEP_LOAN_ACC_INFO
  *  功能描述：监管集市存款贷款账户信息表
  *  创建日期：20241023
  *  开发人员：LIP
  *  来源表：  ICL.CMM_DEP_ACCT_INFO   --存款分户账
  *            ICL.CMM_CORP_CUST_BASIC_INFO  --对公客户基本信息
  *  目标表：  M_DEP_LOAN_ACC_INFO  --存款贷款账户信息表
  *
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220919  HULJ     调整账户编号,子账户号取值。
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP_DESC VARCHAR2(100);              --处理步骤描述
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);              --分区名
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_COUNT     INTEGER;                    --数据记录条数
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_DEP_LOAN_ACC_INFO'; --程序名称
  V_TAB_NAME  VARCHAR2(100) := 'M_DEP_LOAN_ACC_INFO'; --表名
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--存款分户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
  SELECT /*+USE_HASH(A,C,D)*/
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.ACCT_ID                          AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.ACCT_ID                          AS CUST_ACCT_ID             --客户账户编号
         ,A.CUST_ACCT_SUB_ACCT_NUM           AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,A.CDS_LIAB_ACCT_NUM                AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,A.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,B.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'F'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.BELONG_ORG_ID                    AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,A.CORP_ACCT_FLG                    AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO A --存款分户信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B
      ON B.SUBJ_ID = A.SUBJ_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE NVL(A.CLOS_ACCT_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--联合存款分户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
    WITH TMP1 AS (
  SELECT /*+USE_HASH(A,C,D)*/
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.CUST_ACCT_ID                     AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.CUST_ACCT_ID                     AS CUST_ACCT_ID             --客户账户编号
         ,A.CUST_ACCT_SUB_ACCT_NUM           AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,A.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,B.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'F'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,A.CORP_ACCT_FLG                    AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                 --数据来源
         ,ROW_NUMBER() OVER(PARTITION BY A.CUST_ACCT_ID ORDER BY A.FINAL_ACTIV_ACCT_DT DESC,A.CUST_ACCT_SUB_ACCT_NUM) RN
    FROM RRP_MDL.O_ICL_CMM_IFS_ACCT_INFO A --联合存款分户信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO B
      ON B.SUBJ_ID = A.SUBJ_ID
     AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE NVL(A.CLOS_ACCT_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT  DATA_DT                  --数据日期
         ,ACCT_ID                  --账户编号
         ,ACCT_NAME                --账户名称
         ,CUST_ACCT_ID             --客户账户编号
         ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,CDS_LIAB_ACCT_NUM        --负债账户编号
         ,CUST_ID                  --客户编号
         ,SUBJ_ID                  --科目编号
         ,SUBJ_NAME                --科目名称
         ,FLAG                     --标志
         ,BELONG_ORG_ID            --所属机构编号
         ,ORG_ID1                  --目标机构号
         ,FIN_INST_CODE            --目标机构银行机构代码
         ,ORG_NAME                 --目标机构银行机构名称
         ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,DATA_SRC                  --数据来源
    FROM TMP1 WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--内部账户';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
  SELECT /*+USE_HASH(A,C,D)*/
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.ACCT_ID                          AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.MAIN_ACCT_ID                     AS CUST_ACCT_ID             --客户账户编号
         ,A.SUB_ACCT_NUM                     AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,NULL                               AS CUST_ID                  --客户编号
         ,A.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,E.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'N'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.BELONG_ORG_ID                    AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,'1'                                AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT A --内部账户
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.ACCT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO E --科目信息
      ON E.SUBJ_ID = A.SUBJ_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND NVL(A.CLOS_ACCT_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--对公贷款账户信息1';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
    WITH TMP1 AS (
  SELECT /*+MATERIALIZE*//*+USE_HASH(A,C,D)*/
         DISTINCT
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.ACCT_ID                          AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.ACCT_ID                          AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,A.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,E.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'L'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,ROW_NUMBER() OVER(PARTITION BY A.ACCT_ID ORDER BY A.DISTR_DT,A.DUBIL_NUM) RN
         ,'1'                                AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.ACCT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO E --科目信息
      ON E.SUBJ_ID = A.SUBJ_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND NVL(A.CLOS_ACCT_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
    SELECT  DATA_DT                  --数据日期
           ,ACCT_ID                  --账户编号
           ,ACCT_NAME                --账户名称
           ,CUST_ACCT_ID             --客户账户编号
           ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
           ,CDS_LIAB_ACCT_NUM        --负债账户编号
           ,CUST_ID                  --客户编号
           ,SUBJ_ID                  --科目编号
           ,SUBJ_NAME                --科目名称
           ,FLAG                     --标志
           ,BELONG_ORG_ID            --所属机构编号
           ,ORG_ID1                  --目标机构号
           ,FIN_INST_CODE            --目标机构银行机构代码
           ,ORG_NAME                 --目标机构银行机构名称
           ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
           ,DATA_SRC                  --数据来源
      FROM TMP1 WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--对公贷款账户信息2';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
  SELECT /*+USE_HASH(A,C,D)*/
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.DUBIL_NUM                        AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.DUBIL_NUM                        AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,A.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,E.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'L'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,'1'                                AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.DUBIL_NUM
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO E --科目信息
      ON E.SUBJ_ID = A.SUBJ_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.DUBIL_NUM) IS NOT NULL
     AND NVL(A.CLOS_ACCT_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--对公贷款账户信息3';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
    WITH TMP1 AS (
  SELECT /*+MATERIALIZE*/ /*+USE_HASH(A,C,D)*/
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.LOAN_NUM                         AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.LOAN_NUM                         AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,A.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,E.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'L'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,ROW_NUMBER() OVER(PARTITION BY A.LOAN_NUM ORDER BY A.DISTR_DT,A.DUBIL_NUM) RN
         ,'1'                                AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_ACCT_INFO A --对公贷款账户信息
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.LOAN_NUM
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO E --科目信息
      ON E.SUBJ_ID = A.SUBJ_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.LOAN_NUM) IS NOT NULL
     AND NVL(A.CLOS_ACCT_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
    SELECT  DATA_DT                  --数据日期
           ,ACCT_ID                  --账户编号
           ,ACCT_NAME                --账户名称
           ,CUST_ACCT_ID             --客户账户编号
           ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
           ,CDS_LIAB_ACCT_NUM        --负债账户编号
           ,CUST_ID                  --客户编号
           ,SUBJ_ID                  --科目编号
           ,SUBJ_NAME                --科目名称
           ,FLAG                     --标志
           ,BELONG_ORG_ID            --所属机构编号
           ,ORG_ID1                  --目标机构号
           ,FIN_INST_CODE            --目标机构银行机构代码
           ,ORG_NAME                 --目标机构银行机构名称
           ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
           ,DATA_SRC                  --数据来源
      FROM TMP1 WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--对公贷款账户信息4';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
  SELECT /*+USE_HASH(A,C,D)*/
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.DUBIL_ID                         AS ACCT_ID                  --账户编号
         ,E.CUST_NAME                        AS ACCT_NAME                --账户名称
         ,A.DUBIL_ID                         AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,H.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,H.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'L'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,'1'                                AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_DUBIL_INFO A --对公贷款借据信息
    LEFT JOIN RRP_MDL.O_ICL_CMM_CORP_CUST_BASIC_INFO E
      ON E.CUST_ID = A.CUST_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_DISCNT_INFO F --票据贴现信息
      ON NVL(TRIM(F.BILL_ENTRY_ID),F.BILL_ID) = A.BILL_UNIQ_MARK_ID
     AND F.DISCNT_STATUS_CD IN ('06')
     AND F.ENTRY_STATUS_CD = '03' --03 记账完成
     AND A.STD_PROD_ID IN ('203020600001','203020400001','204010200001','204010200002')
     AND TRIM(A.BILL_UNIQ_MARK_ID) IS NOT NULL
     AND F.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.O_ICL_CMM_BILL_DISCOUNT_INFO G --票据转贴现信息
      ON G.BILL_ID = A.BILL_ID
     AND G.TRAN_DIR_CD = '01'
     AND G.BUS_TYPE_CD = 'BT01' --BT00-未知 BT01-转贴现 BT02-质押式回购 BT03-买断式回购 BT06-央行卖票
     AND G.ENTRY_STATUS_CD = '03' --筛选记账成功的票据
     AND A.STD_PROD_ID IN ('204010100001','204010100002')
     AND G.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.DUBIL_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO H --科目信息
      ON H.SUBJ_ID = COALESCE(TRIM(F.SUBJ_ID),TRIM(G.SUBJ_ID))
     AND H.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.DUBIL_ID) IS NOT NULL
     AND NVL(A.PAYOFF_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--零售贷款账户信息1';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
    WITH TMP1 AS (
  SELECT /*+MATERIALIZE*//*+USE_HASH(A,C,D)*/
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.ACCT_ID                          AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.ACCT_ID                          AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,A.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,E.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'P'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,ROW_NUMBER() OVER(PARTITION BY A.ACCT_ID ORDER BY A.DISTR_DT,A.DUBIL_NUM) RN
         ,'0'                                AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.ACCT_ID
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO E --科目信息
      ON E.SUBJ_ID = A.SUBJ_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.ACCT_ID) IS NOT NULL
     AND NVL(A.CLOS_ACCT_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
    SELECT  DATA_DT                  --数据日期
           ,ACCT_ID                  --账户编号
           ,ACCT_NAME                --账户名称
           ,CUST_ACCT_ID             --客户账户编号
           ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
           ,CDS_LIAB_ACCT_NUM        --负债账户编号
           ,CUST_ID                  --客户编号
           ,SUBJ_ID                  --科目编号
           ,SUBJ_NAME                --科目名称
           ,FLAG                     --标志
           ,BELONG_ORG_ID            --所属机构编号
           ,ORG_ID1                  --目标机构号
           ,FIN_INST_CODE            --目标机构银行机构代码
           ,ORG_NAME                 --目标机构银行机构名称
           ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
           ,DATA_SRC                  --数据来源
      FROM TMP1 WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--零售贷款账户信息1';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
  SELECT /*+USE_HASH(A,C,D)*/
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.DUBIL_NUM                        AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.DUBIL_NUM                        AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,A.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,E.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'P'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,'0'                                AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.DUBIL_NUM
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO E --科目信息
      ON E.SUBJ_ID = A.SUBJ_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.DUBIL_NUM) IS NOT NULL
     AND NVL(A.CLOS_ACCT_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--零售贷款账户信息1';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
    WITH TMP1 AS (
  SELECT /*+MATERIALIZE*//*+USE_HASH(A,C,D)*/
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.LOAN_NUM                         AS ACCT_ID                  --账户编号
         ,A.ACCT_NAME                        AS ACCT_NAME                --账户名称
         ,A.LOAN_NUM                         AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,A.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,E.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'P'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_INSTIT_ID                   AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,ROW_NUMBER() OVER(PARTITION BY A.LOAN_NUM ORDER BY A.DISTR_DT,A.DUBIL_NUM) RN
         ,'0'                                AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_RETL_LOAN_ACCT_INFO A --零售贷款账户信息
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.LOAN_NUM
    LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO E --科目信息
      ON E.SUBJ_ID = A.SUBJ_ID
     AND E.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_INSTIT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.LOAN_NUM) IS NOT NULL
     AND NVL(A.CLOS_ACCT_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
    SELECT  DATA_DT                  --数据日期
           ,ACCT_ID                  --账户编号
           ,ACCT_NAME                --账户名称
           ,CUST_ACCT_ID             --客户账户编号
           ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
           ,CDS_LIAB_ACCT_NUM        --负债账户编号
           ,CUST_ID                  --客户编号
           ,SUBJ_ID                  --科目编号
           ,SUBJ_NAME                --科目名称
           ,FLAG                     --标志
           ,BELONG_ORG_ID            --所属机构编号
           ,ORG_ID1                  --目标机构号
           ,FIN_INST_CODE            --目标机构银行机构代码
           ,ORG_NAME                 --目标机构银行机构名称
           ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
           ,DATA_SRC                  --数据来源
      FROM TMP1 WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --ADD BY LIP 因主账户表中已经存在分户账和内部账中的主账号，所以上面两种存款表的情况下不取相关的主账号信息
  --加工账户信息
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--存款主账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
    WITH TMP1 AS (
    SELECT /*+MATERIALIZE*/CUST_ACCT_ID,CUST_ACCT_SUB_ACCT_NUM,SUBJ_ID,FINAL_ACTIV_ACCT_DT
      FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO T WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    SELECT CUST_ACCT_CARD_NO,CUST_ACCT_SUB_ACCT_NUM,SUBJ_ID,FINAL_ACTIV_ACCT_DT
      FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO T WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    SELECT MAIN_ACCT_ID,SUB_ACCT_NUM,SUBJ_ID,LAST_TRAN_DT
      FROM RRP_MDL.O_ICL_CMM_INTNAL_ACCT T WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    TMP2 AS (
    SELECT T.CUST_ACCT_ID,T.CUST_ACCT_SUB_ACCT_NUM,T.SUBJ_ID,TA.SUBJ_NAME,T.FINAL_ACTIV_ACCT_DT,
           ROW_NUMBER() OVER(PARTITION BY T.CUST_ACCT_ID ORDER BY T.FINAL_ACTIV_ACCT_DT DESC,T.CUST_ACCT_SUB_ACCT_NUM) RN
      FROM TMP1 T
      LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO TA --科目信息
        ON TA.SUBJ_ID = T.SUBJ_ID
       AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE_HASH(A,C,D)*/
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.CUST_ACCT_ID                     AS ACCT_ID                  --账户编号
         ,A.CUST_ACCT_NAME                   AS ACCT_NAME                --账户名称
         ,A.CUST_ACCT_ID                     AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,E.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,E.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'C'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,A.ACCT_BELONG_ORG_ID               AS BELONG_ORG_ID            --所属机构编号
         ,NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1                  --目标机构号
         ,NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE          --目标机构银行机构代码
         ,NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME                 --目标机构银行机构名称
         ,CASE WHEN LENGTH(A.CUST_ID) < 10 THEN '1' --内部户
              ELSE A.CORP_ACCT_FLG
          END                               AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))       AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.CUST_ACCT_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
    LEFT JOIN TMP2 E
      ON E.CUST_ACCT_ID = A.CUST_ACCT_ID
     AND E.RN = 1
   WHERE B.ACCT_ID IS NULL
     AND NVL(A.CLOS_ACCT_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  /*V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--存款主账户信息2';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
    DATA_DT,                  --数据日期
    ACCT_ID,                  --账户编号
    ACCT_NAME,                --账户名称
    CUST_ACCT_ID,             --客户账户编号
    CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
    CDS_LIAB_ACCT_NUM,        --负债账户编号
    CUST_ID,                  --客户编号
    SUBJ_ID,                  --科目编号
    SUBJ_NAME,                --科目名称
    FLAG,                     --标志
    BELONG_ORG_ID,            --所属机构编号
    ORG_ID1,                  --目标机构号
    FIN_INST_CODE,            --目标机构银行机构代码
    ORG_NAME,                 --目标机构银行机构名称
    CORP_ACCT_FLG,            --对公账户标志 --ADD BY LIP 20241018
    DATA_SRC                  --数据来源
    )
    WITH TMP1 AS (
  SELECT \*+USE_HASH(A,C,D)*\
         V_P_DATE                           AS DATA_DT,                  --数据日期
         A.CUST_ACCT_CARD_NO                AS ACCT_ID,                  --账户编号
         A.CUST_ACCT_NAME                   AS ACCT_NAME,                --账户名称
         A.CUST_ACCT_ID                     AS CUST_ACCT_ID,             --客户账户编号
         NULL                               AS CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
         NULL                               AS CDS_LIAB_ACCT_NUM,        --负债账户编号
         A.CUST_ID                          AS CUST_ID,                  --客户编号
         NULL                               AS SUBJ_ID,                  --科目编号
         NULL                               AS SUBJ_NAME,                --科目名称
         'C'                                AS FLAG,                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         A.ACCT_BELONG_ORG_ID               AS BELONG_ORG_ID,            --所属机构编号
         NVL(C.ORG_ID1,D.ORG_ID1)           AS ORG_ID1,                  --目标机构号
         NVL(C.FIN_INST_CODE,D.FIN_INST_CODE) AS FIN_INST_CODE,          --目标机构银行机构代码
         NVL(C.BKNAME,D.BKNAME)             AS ORG_NAME,                 --目标机构银行机构名称
         ROW_NUMBER() OVER(PARTITION BY A.CUST_ACCT_CARD_NO ORDER BY A.OPEN_ACCT_DT,A.VRIF_STATUS_CD DESC) RN,
         A.CORP_ACCT_FLG                    AS CORP_ACCT_FLG,            --对公账户标志 --ADD BY LIP 20241018
         UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.CUST_ACCT_CARD_NO
    LEFT JOIN RRP_MDL.ORG_CONFIG C
      ON C.ORG_ID = A.ACCT_BELONG_ORG_ID
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.CUST_ACCT_CARD_NO) IS NOT NULL
     AND NVL(A.CLOS_ACCT_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
    SELECT DATA_DT,                  --数据日期
           ACCT_ID,                  --账户编号
           ACCT_NAME,                --账户名称
           CUST_ACCT_ID,             --客户账户编号
           CUST_ACCT_SUB_ACCT_NUM,   --客户账户子户号
           CDS_LIAB_ACCT_NUM,        --负债账户编号
           CUST_ID,                  --客户编号
           SUBJ_ID,                  --科目编号
           SUBJ_NAME,                --科目名称
           FLAG,                     --标志
           BELONG_ORG_ID,            --所属机构编号
           ORG_ID1,                  --目标机构号
           FIN_INST_CODE,            --目标机构银行机构代码
           ORG_NAME,                 --目标机构银行机构名称
           CORP_ACCT_FLG,            --对公账户标志 --ADD BY LIP 20241018
           DATA_SRC                  --数据来源
      FROM TMP1 WHERE RN = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');*/

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '加工账户信息--银行卡信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_DEP_LOAN_ACC_INFO(
     DATA_DT                  --数据日期
    ,ACCT_ID                  --账户编号
    ,ACCT_NAME                --账户名称
    ,CUST_ACCT_ID             --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
    ,CDS_LIAB_ACCT_NUM        --负债账户编号
    ,CUST_ID                  --客户编号
    ,SUBJ_ID                  --科目编号
    ,SUBJ_NAME                --科目名称
    ,FLAG                     --标志
    ,BELONG_ORG_ID            --所属机构编号
    ,ORG_ID1                  --目标机构号
    ,FIN_INST_CODE            --目标机构银行机构代码
    ,ORG_NAME                 --目标机构银行机构名称
    ,CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
    ,DATA_SRC                  --数据来源
    )
    WITH TMP1 AS (
    SELECT /*+MATERIALIZE*/CUST_ACCT_ID,CUST_ACCT_SUB_ACCT_NUM,SUBJ_ID,FINAL_ACTIV_ACCT_DT
      FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO T WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     UNION ALL
    SELECT CUST_ACCT_CARD_NO,CUST_ACCT_SUB_ACCT_NUM,SUBJ_ID,FINAL_ACTIV_ACCT_DT
      FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO T WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')),
    TMP2 AS (
    SELECT T.CUST_ACCT_ID,T.CUST_ACCT_SUB_ACCT_NUM,T.SUBJ_ID,TA.SUBJ_NAME,T.FINAL_ACTIV_ACCT_DT,
           ROW_NUMBER() OVER(PARTITION BY T.CUST_ACCT_ID ORDER BY T.FINAL_ACTIV_ACCT_DT DESC,T.CUST_ACCT_SUB_ACCT_NUM) RN
      FROM TMP1 T
      LEFT JOIN RRP_MDL.O_ICL_CMM_SUBJ_INFO TA --科目信息
        ON TA.SUBJ_ID = T.SUBJ_ID
       AND TA.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'))
  SELECT /*+USE_HASH(A,C,D)*/
          V_P_DATE                           AS DATA_DT                  --数据日期
         ,A.CARD_NO                          AS ACCT_ID                  --账户编号
         ,A.CARD_HOLDER_NAME                 AS ACCT_NAME                --账户名称
         ,A.CARD_NO                          AS CUST_ACCT_ID             --客户账户编号
         ,NULL                               AS CUST_ACCT_SUB_ACCT_NUM   --客户账户子户号
         ,NULL                               AS CDS_LIAB_ACCT_NUM        --负债账户编号
         ,A.CUST_ID                          AS CUST_ID                  --客户编号
         ,E.SUBJ_ID                          AS SUBJ_ID                  --科目编号
         ,E.SUBJ_NAME                        AS SUBJ_NAME                --科目名称
         ,'C'                                AS FLAG                     --标志 F分户 N内部户 L对公贷款 P零售贷款 C主账户
         ,D.ORG_ID                           AS BELONG_ORG_ID            --所属机构编号
         ,D.ORG_ID1                          AS ORG_ID1                  --目标机构号
         ,D.FIN_INST_CODE                    AS FIN_INST_CODE            --目标机构银行机构代码
         ,D.BKNAME                           AS ORG_NAME                 --目标机构银行机构名称
         ,CASE WHEN SUBSTR(A.CUST_ID,1,1) IN ('1','3') THEN '0'
              ELSE '1'
           END                               AS CORP_ACCT_FLG            --对公账户标志 --ADD BY LIP 20241018
         ,UPPER(SUBSTR(A.JOB_CD,1,4))        AS DATA_SRC                  --数据来源
    FROM RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO A --银行卡基本信息
    LEFT JOIN RRP_MDL.M_DEP_LOAN_ACC_INFO B
      ON B.ACCT_ID = A.CARD_NO
    LEFT JOIN RRP_MDL.ORG_CONFIG D
      ON D.ORG_ID = '800'
    LEFT JOIN TMP2 E
      ON E.CUST_ACCT_ID = A.CARD_NO
     AND E.RN = 1
   WHERE B.ACCT_ID IS NULL
     AND TRIM(A.CARD_NO) IS NOT NULL
     AND NVL(A.PIN_CARD_DT,TO_DATE(V_P_DATE,'YYYYMMDD')) >= TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
     AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询M_DEP_LOAN_ACC_INFO数据是否重复';
  WITH TMP1 AS (
    SELECT ACCT_ID,COUNT(1)
      FROM RRP_MDL.M_DEP_LOAN_ACC_INFO T
     WHERE T.DATA_DT = V_P_DATE
     GROUP BY ACCT_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_COUNT FROM TMP1 ;

  IF V_COUNT > 0 THEN
     O_ERRCODE   := '1';
     V_ENDTIME := SYSDATE;
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '表分析';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := SQLCODE;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_DEP_LOAN_ACC_INFO;
/

