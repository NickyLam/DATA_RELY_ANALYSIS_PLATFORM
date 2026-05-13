CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_DEP_ACC_MED_REL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_INIT_M_DEP_ACC_MED_REL_INFO
  *  功能描述：监管集市银行存款账户和账户介质关系，介质类型包含卡，折、存单、其他。
  *  创建日期：20220525
  *  开发人员：hulijuan
  *  来源表：  ICL.CMM_DEP_CUST_ACCT_INFO    --存款主账户信息
  *            IML.AGT_VOUCH_ACCT_RELA_H     --凭证账户关系历史
  *            ICL.CMM_DEP_ACCT_INFO         --存款分户信息
  *
  *
  *  目标表：  M_DEP_ACC_MED_REL_INFO  --存款账户介质关系信息
  *
  *  配置表：  CODE_MAP  --码值映射表
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221114  hulj     增加数据重复校验。
  *             2    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             3    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             4    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  *             5    20220508  程序员   数仓修改表结构，修改源表处理逻辑。
  ***************************************************************************/
  AS
  -- 定义变量 --

  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(100) := 'ETL_INIT_M_DEP_ACC_MED_REL_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  --V_LAST_DAT  VARCHAR2(8); -- 当月月末
  --V_YESTADAY  VARCHAR2(8); -- 上日
  --V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_DATE       DATE; --数据日期(判断输入参数日期格式是否准确)
  --V_START_DT   VARCHAR2(8);
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
 V_START_DT CHAR(8) ;       --月初日期
  BEGIN
     -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_DEP_ACC_MED_REL_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  V_DATE    := TO_DATE(I_P_DATE,'YYYY-MM-DD');
  --V_START_DT := TO_CHAR(TRUNC(V_DATE, 'MM'), 'YYYYMMDD');

  V_STEP := V_STEP + 1;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    --判断传入日期参数是否正确--
  IF I_P_DATE IS NOT NULL THEN
    V_DATE := TO_DATE(V_P_DATE, 'yyyymmdd');
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
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := 'TRUNCAT临时表CHG_ACCT_TMP';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.CHG_ACCT_TMP';
  V_SQLCOUNT := SQL%ROWCOUNT ;
  COMMIT ;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := 'TRUNCAT临时表TMP_CBS_DECD';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.TMP_CBS_DECD';
  V_SQLCOUNT := SQL%ROWCOUNT ;
  COMMIT ;

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入换卡临时表数据';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.CHG_ACCT_TMP(
    ACCT_ID,
    CUST_ACCT_ID,
    DEP_ACCT_STATUS_CD
  )
  WITH VOUCH_ACCT_NUM_RELA AS (
   SELECT AGT_ID, CUST_ACCT_NUM, ROW_NUMBER() OVER(PARTITION BY CUST_ACCT_NUM ORDER BY SUB_ACCT_NUM, VOUCH_STATUS_CD DESC) AS ARANK
        FROM RRP_MDL.O_IML_AGT_VOUCH_ACCT_RELA_H AR--凭证账户关系历史
        WHERE START_DT <= V_DATE AND END_DT > V_DATE),
   CMM_DEP_ACCT_INFO AS (
   SELECT /*+MATERIALIZE*/ACCT_ID,
             CUST_ACCT_ID,
             DEP_ACCT_STATUS_CD,
             ROW_NUMBER() OVER(PARTITION BY CUST_ACCT_ID ORDER BY ACCT_ID, OPEN_ACCT_TM) AS ARANK
        FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO
        WHERE ETL_DT = V_DATE)
    SELECT D.ACCT_ID,                                --存款账号
         A.CUST_ACCT_ID,                            --介质编号
         D.DEP_ACCT_STATUS_CD
    FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
    LEFT JOIN VOUCH_ACCT_NUM_RELA C
      ON C.CUST_ACCT_NUM = A.CUST_ACCT_ID
     AND C.ARANK = 1 --账号凭证对照(按照ACCTNO分组，子户号和状态（倒序）排序，取第一条)
   INNER JOIN CMM_DEP_ACCT_INFO D
      ON D.CUST_ACCT_ID= C.CUST_ACCT_NUM
     AND D.ARANK = 1
   WHERE A.VOUCH_KIND_CD IN ('731','737','735','771', '772')
     AND (CASE WHEN TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231')
               THEN '20991231'
               ELSE TO_CHAR(A.CLOS_ACCT_DT,'YYYYMMDD') END) >= V_START_DT  --过滤掉销户
     AND UPPER(A.JOB_CD) <> 'IFCSF1' --去除微众数据
     AND A.ETL_DT = V_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  COMMIT;
  ---记录正常日志
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   /*update by cxl 20220426 增加大额存单临时表*/
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入大额存单临时表数据';
  V_STARTTIME := SYSDATE;

    INSERT INTO RRP_MDL.TMP_CBS_DECD(
    DATA_DT           --数据日期
    ,LGL_REP_ID        --法人编号
    ,ACC_ID            --账户编号
    ,MED_ID            --介质编号
    ,DEPT_LINE         --部门条线
    ,DATA_SRC          --数据来源
  )
   WITH ACCT_INFO AS (
      SELECT /*+MATERIALIZE*/CUST_ACCT_ID, ACCT_ID,  OPEN_ACCT_TM, JOB_CD
        FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO --存款分户信息
       WHERE (CASE WHEN TO_CHAR(CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231')
                   THEN '20991231'
                   ELSE TO_CHAR(CLOS_ACCT_DT,'YYYYMMDD')
               END) >= V_START_DT
         AND SUBJ_ID IN ('20110103', '20110203')
         AND ETL_DT = V_DATE
       ),
    ACCT_INFO_1 AS (
      SELECT /*+MATERIALIZE*/CUST_ACCT_ID, ACCT_ID, JOB_CD,
             ROW_NUMBER() OVER(PARTITION BY CUST_ACCT_ID ORDER BY ACCT_ID, OPEN_ACCT_TM) AS ARANK
        FROM ACCT_INFO T)
  SELECT
    V_P_DATE,                                                                   --数据日期
    '9999'                       AS LGL_REP_ID,          --法人编号
          A.ACCT_ID                    AS ACC_ID,              --存款账号
          A.CUST_ACCT_ID               AS MED_ID,              --介质编号
          /*'03'*/'800001'             AS DEPT_LINE,           --部门条线
          SUBSTR(A.JOB_CD, 0, 4)       AS DATA_SRC             --数据来源
     FROM ACCT_INFO_1 A
    WHERE A.ARANK = 1;

  V_SQLCOUNT := SQL%ROWCOUNT;
  COMMIT;
  ---记录正常日志
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   /***普通存折存单***/
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入普通存折存单数据';
  V_STARTTIME := SYSDATE;

  INSERT INTO M_DEP_ACC_MED_REL_INFO
  (DATA_DT             --数据日期
  ,LGL_REP_ID          --法人编号
  ,ACC_ID              --账户编号
  ,MED_ID              --介质编号
  ,DEPT_LINE           --部门条线
  ,DATA_SRC            --数据来源
   )
   WITH AGT_VOUCH_ACCT_NUM_RELA AS (
   SELECT AGT_ID, CUST_ACCT_NUM, ROW_NUMBER() OVER(PARTITION BY CUST_ACCT_NUM ORDER BY SUB_ACCT_NUM, VOUCH_STATUS_CD DESC) AS ARANK
        FROM RRP_MDL.O_IML_AGT_VOUCH_ACCT_RELA_H --凭证账户关系历史
        WHERE START_DT <= V_DATE AND END_DT > V_DATE),
   CMM_DEP_ACCT_INFO AS (
      SELECT /*+MATERIALIZE*/ACCT_ID,
             CUST_ACCT_ID,
             ROW_NUMBER() OVER(PARTITION BY CUST_ACCT_ID ORDER BY ACCT_ID, OPEN_ACCT_TM) AS ARANK
        FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO
       WHERE ETL_DT = V_DATE)
  SELECT /*+use_hash(A, C, D, CAT, E)*/ DISTINCT
    TO_CHAR(A.ETL_DT, 'YYYYMMDD'),                                              --数据日期
    A.LP_ID,                                                                    --法人编号
    NVL(D.ACCT_ID, CAT.ACCT_ID),                                      --存款账号
    NVL(C.AGT_ID, A.CUST_ACCT_ID),                                       --介质编号
    --A.CUST_ACCT_ID,
    '800001'   /*营运管理部*/,                                                  --部门条线
    SUBSTR(A.JOB_CD, 0, 4)                                                      --数据来源
      FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A --存款主账户信息
    LEFT JOIN AGT_VOUCH_ACCT_NUM_RELA C ----凭证账号关系表
      ON C.CUST_ACCT_NUM = A.CUST_ACCT_ID
     AND C.ARANK = 1
    LEFT JOIN CMM_DEP_ACCT_INFO D --存款分户账临时表
      ON D.CUST_ACCT_ID= A.CUST_ACCT_ID
     AND D.ARANK = 1
    LEFT JOIN RRP_MDL.CHG_ACCT_TMP CAT --换卡临时表
      ON CAT.ACCT_ID = D.ACCT_ID
     AND CAT.CUST_ACCT_ID = A.CUST_ACCT_ID /*过滤掉换卡的账户*/
    LEFT JOIN RRP_MDL.TMP_CBS_DECD E --大额存单临时表
      ON E.MED_ID = A.CUST_ACCT_ID
     AND E.ACC_ID = NVL(D.ACCT_ID, CAT.ACCT_ID) --过滤大额存单部分
   WHERE A.VOUCH_KIND_CD IN ('731','737','735','771', '772')
     /*AND (CASE WHEN TO_CHAR(CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231')
               THEN '20991231'
               ELSE TO_CHAR(CLOS_ACCT_DT,'YYYYMMDD')
           END) >= V_START_DT --过滤当月销户的数据*/
     AND E.MED_ID IS NULL --剔除掉大额存单部分
     AND NVL(D.ACCT_ID, CAT.ACCT_ID) IS NOT NULL
     AND UPPER(A.JOB_CD) <> 'IFCSF1' --去除微众数据
     AND A.ETL_DT = V_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  COMMIT;
  ---记录正常日志
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   /***卡信息***/
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入卡基本信息数据';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND */INTO RRP_MDL.M_DEP_ACC_MED_REL_INFO
  (
   DATA_DT             --数据日期
  ,LGL_REP_ID          --法人编号
  ,ACC_ID              --账户编号
  ,MED_ID              --介质编号
  ,DEPT_LINE           --部门条线
  ,DATA_SRC            --数据来源
   )
    WITH ACCT_INFO AS (
      SELECT CUST_ACCT_ID, ACCT_ID, OPEN_ACCT_TM
        FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO
       WHERE ETL_DT = V_DATE),
    ACCT_INFO1 AS (
      SELECT /*+MATERIALIZE*/T.CUST_ACCT_ID, T.ACCT_ID,
             ROW_NUMBER() OVER(PARTITION BY T.CUST_ACCT_ID ORDER BY T.ACCT_ID, T.OPEN_ACCT_TM) AS ARANK
        FROM ACCT_INFO T)
  SELECT TO_CHAR(V_DATE, 'YYYYMMDD')      AS DATA_DT,        --数据日期
         A.LP_ID                          AS LGL_REP_ID,     --法人编号
         B.ACCT_ID                        AS ACC_ID,         --存款账号
         A.CUST_ACCT_ID                   AS MED_ID,         --介质编号
         /*'03'*/'800001'                 AS DEPT_LINE,      --部门条线 营运管理部
         SUBSTR(A.JOB_CD, 0, 4)           AS DATA_SRC        --数据来源
    --FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO A  --modify by tangan at 20221129 新核心跟旧核心主张户存储方式有变化，以前有卡有折的账户，会卡和折各一条，新核心是账号放折号，卡号放卡号，只有一条数据，数仓CMM_DEP_ACCT_INFO模型新增了字段【CUST_ACCT_CARD_NO-客户账户卡号】用来存放卡号。有卡有折的情况CUST_ACCT_ID-放的是折号，CUST_ACCT_CARD_NO-放的是卡号。
   FROM ( SELECT T.CUST_ACCT_ID,T.CUST_ACCT_ID1,MAX(LP_ID) LP_ID,MAX(JOB_CD) JOB_CD
          FROM (
          SELECT CUST_ACCT_ID,CUST_ACCT_ID AS CUST_ACCT_ID1,LP_ID,JOB_CD FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO WHERE ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD') AND TRIM(CUST_ACCT_ID) IS NOT NULL
          UNION ALL
          SELECT CUST_ACCT_CARD_NO AS CUST_ACCT_ID,CUST_ACCT_ID AS CUST_ACCT_ID1,LP_ID,JOB_CD FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO WHERE ETL_DT = TO_DATE(V_P_DATE, 'YYYYMMDD') AND TRIM(CUST_ACCT_CARD_NO) IS NOT NULL
          ) T
          GROUP BY T.CUST_ACCT_ID,T.CUST_ACCT_ID1
   ) A
   INNER JOIN ACCT_INFO1 B
      ON B.CUST_ACCT_ID = A.CUST_ACCT_ID1
     AND B.ARANK = 1
   WHERE A.CUST_ACCT_ID LIKE '6%'
     /*AND ((CASE WHEN TO_CHAR(CLOS_ACCT_DT,'YYYYMMDD') IN ('00010101','20991231')
                THEN '20991231'
                ELSE TO_CHAR(CLOS_ACCT_DT,'YYYYMMDD')
            END) >= V_START_DT)*/
     AND NOT EXISTS (SELECT 1
                       FROM RRP_MDL.O_ICL_CMM_DEP_CUST_ACCT_INFO I --存款分户基本信息
                      WHERE I.CUST_ACCT_ID LIKE '623688%'  --过滤掉天猫卡，因为业务已暂停
                        AND I.OPEN_ACCT_ORG_ID = '805011'
                        AND I.CUST_ACCT_ID = A.CUST_ACCT_ID
                        AND I.ETL_DT = V_DATE)
     --AND A.ACCT_TYPE_CD = '1'
     --AND A.ETL_DT = V_DATE
     ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  COMMIT;
  ---记录正常日志
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

     /***大额存单***/
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入大额存单数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO M_DEP_ACC_MED_REL_INFO
    (
     DATA_DT           --数据日期
    ,LGL_REP_ID        --法人编号
    ,ACC_ID            --账户编号
    ,MED_ID            --介质编号
    ,DEPT_LINE         --部门条线
    ,DATA_SRC          --数据来源
     )
  SELECT DISTINCT
    DATA_DT           --数据日期
    ,LGL_REP_ID        --法人编号
    ,ACC_ID            --账户编号
    ,MED_ID            --介质编号
    ,DEPT_LINE         --部门条线
    ,DATA_SRC
  FROM TMP_CBS_DECD
  ;
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, ACC_ID,MED_ID,COUNT(1)
      FROM M_DEP_ACC_MED_REL_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, ACC_ID,MED_ID
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
   V_STEP_DESC := '-- 程序跑批开始 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   ROLLBACK;
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;

   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_M_DEP_ACC_MED_REL_INFO;
/

