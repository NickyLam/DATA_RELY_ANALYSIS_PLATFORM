CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_A_PHB_MANAGEMENT
(I_P_DATE IN INTEGER,
 O_ERRCODE OUT VARCHAR2
)
  /**************************************************************************
  *  程序名称：ETL_A_PHB_MANAGEMENT
  *  功能描述：零售不良处置基表
  *  创建日期：20221031
  *  开发人员：刘宇
  *  来源表：
  *  目标表：A_PHB_MANAGEMENT --零售不良处置基表
  *  配置表：CODE_MAP
  *  修改情况：
     序号  修改日期   修改人     修改原因
  *   1    20221107   liuyu      首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP       INTEGER := 0;     -- 处理步骤
  V_PROC_NAME  VARCHAR2(30) := 'ETL_A_PHB_MANAGEMENT';
                                 -- 程序名称
  V_P_DATE     VARCHAR2(8);      -- 跑批数据日期
  V_STARTTIME  DATE;             -- 处理开始时间
  V_ENDTIME    DATE;             -- 处理结束时间
  V_SQLCOUNT   INTEGER := 0;     -- 更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);    -- SQL执行描述信息
  V_SYSTEM     VARCHAR2(30);     -- 来源系统
  V_STEP_DESC  VARCHAR2(200);    --任务名称
  V_TAB_NAME VARCHAR2(100) ; --表名
  V_PART_NAME VARCHAR2(100); --分区名
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE     := TO_CHAR( I_P_DATE);  -- 获取跑批日期
  V_SYSTEM     := '监管报送';           -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'A_PHB_MANAGEMENT'; --表名,写目标表表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --V_P_DATE 当前日期


  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 分区表分区处理 --
   V_STEP := V_STEP + 1;
   V_STEP_DESC := '分区处理';
   V_STARTTIME := SYSDATE;

   ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '1', O_ERRCODE);

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '核销部分';
  V_STARTTIME := SYSDATE;

  INSERT INTO RRP_MDL.A_PHB_MANAGEMENT
    (
           BGRQ            --报告日期
          ,JYWYM           --交易唯一码
          ,KHWYM           --客户唯一码
          ,KHMC            --客户名称
          ,BLZCLB          --不良资产类别
          ,BLCZHJFS        --不良处置化解方式
          ,BLCZHJRQ        --不良处置化解日期
          ,BLCZBJ          --不良处置本金
          ,BLCZSHQTJE      --不良处置收回其他金额
          ,JGBH            --机构编号
          ,JGMC            --机构名称
          ,SJLY            --数据来源
    )
     SELECT
            V_P_DATE      AS BGRQ             --1 报告日期
           ,T1.RCPT_ID    AS JYWYM           --交易唯一码
           ,T1.CUST_ID    AS KHWYM           --客户唯一码
           ,T4.CUST_NM    AS KHMC            --客户名称
           ,'贷款'        AS BLZCLB          --不良资产类别
           ,'非转让核销'  AS BLCZHJFS        --不良处置化解方式
           ,T2.CNCL_DT    AS BLCZHJRQ        --不良处置化解日期
           ,T2.CNCL_LN_PRIN
                          AS BLCZBJ          --不良处置本金
           ,0             AS BLCZSHQTJE      --不良处置收回其他金额
           ,T1.ORG_ID     AS JGBH            --机构编号
           ,T3.ORG_NM     AS JGMC            --机构编号
           ,'核销'        AS SJLY            --数据来源
     FROM RRP_MDL.S_LOAN T1 --贷款业务整合表
    INNER JOIN (
          SELECT A.RCPT_ID
                ,NVL(A.CNCL_LN_PRIN, 0) * U.EXRT AS CNCL_LN_PRIN --实核贷款本金
                ,ROW_NUMBER() OVER(PARTITION BY A.RCPT_ID,A.CNCL_DT ORDER BY A.RCPT_ID) AS RN --去重
                ,A.CNCL_DT --核销日期
            FROM RRP_MDL.M_LOAN_CNCL_INFO A --资产核销信息
            LEFT JOIN RRP_MDL.M_PUM_EXRT_INFO U --汇率表
              ON U.DATA_DT = A.DATA_DT
             AND U.BASE_CUR = A.CUR
             AND U.CNV_CUR = 'CNY'
           WHERE A.DATA_DT = V_P_DATE
             AND SUBSTR(A.CNCL_DT,1,4) = SUBSTR(V_P_DATE,1,4)
               ) T2
       ON T1.RCPT_ID = T2.RCPT_ID
      AND T2.RN = 1
     LEFT JOIN RRP_MDL.M_PUM_ORG_INFO T3 --机构表
       ON T3.ORG_ID = T1.ORG_ID
      AND T3.DATA_DT = T1.DATA_DT
     LEFT JOIN RRP_MDL.M_CUST_IND_INFO T4 --个人客户信息
       ON T4.CUST_ID = T1.CUST_ID
      AND T4.DATA_DT = T1.DATA_DT
    WHERE T1.DATA_DT = V_P_DATE
      AND T1.DATA_SRC IN ('零售贷款','联合网贷');
   COMMIT;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE  := '0';
   V_ENDTIME  := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


    WITH TMP1 AS (
  SELECT JYWYM,KHWYM,COUNT(1)
    FROM RRP_MDL.A_PHB_MANAGEMENT T
   WHERE BGRQ = V_P_DATE
   GROUP BY JYWYM,KHWYM
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
  --插入过程跑批完成记录表
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

  END ETL_A_PHB_MANAGEMENT;
/

