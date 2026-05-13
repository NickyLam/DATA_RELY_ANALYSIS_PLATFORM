CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_LOAN_LV5_CHANGE_SH(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_S_LOAN_LV5_CHANGE_SH
  *  功能描述：不良贷款转正常后收回明细表
  *  创建日期：20240322
  *  开发人员：卢伟博
  *  来源表：  M_LOAN_IN_DUBILL_INFO
  *
  *
  *  目标表：  S_LOAN_LV5_CHANGE_SH
  *  配置表：  CONFIG_AREA
  *  修改情况：序号  修改日期  修改人   修改原因
  *              1    20240510  lwb     根据G12需求开发
                 2    20240527  LWB     剔除借据核销后转正常收回的明细数据
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_STEP_DESC VARCHAR2(1000);-- 处理步骤描述
  V_PROC_NAME VARCHAR2(100) := 'ETL_S_LOAN_LV5_CHANGE_SH'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_YESTADAY VARCHAR2(8);--上一天
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := I_P_DATE; -- 获取跑批日期
  V_YESTADAY:=TO_CHAR(TO_DATE(I_P_DATE,'YYYYMMDD')-1,'YYYYMMDD');--上一天
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'S_LOAN_LV5_CHANGE_SH'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM S_LOAN_LV5_CHANGE_SH T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'S_LOAN_LV5_CHANGE_SH'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理
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
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  EXECUTE IMMEDIATE ('TRUNCATE TABLE ADJ_DT_TMP');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '记录年初不良贷款转为正常后收回的时间区间';
  V_STARTTIME := SYSDATE;
  INSERT INTO ADJ_DT_TMP
    (
     RCPT_ID,    --借据号
     DATA_SRC,   --数据来源
     START_DT,   --开始日期
     END_DT      --结束日期
 )
WITH TMP1 AS
 (SELECT T.*,
         ROW_NUMBER() OVER(PARTITION BY T.RCPT_ID ORDER BY T.ADJ_DT) AS NUM
    FROM RRP_MDL.S_LVL5_CL_CHANGE T  --记录年初不良贷款不良五级分类变动数据
   INNER JOIN RRP_MDL.S_LOAN TT --取全年末数据
      ON TT.RCPT_ID = T.RCPT_ID
     AND TT.LVL5_CL IN ('03', '04', '05')
     AND TT.DATA_DT = SUBSTR(V_P_DATE,0,4)-1||'1231'
   WHERE (CASE
           WHEN T.LVL5_CL_BF IN ('01', '02') THEN
            'A'
           WHEN T.LVL5_CL_BF IN ('03', '04', '05') THEN
            'B'
         END) <> (CASE
           WHEN T.LVL5_CL IN ('01', '02') THEN
            'A'
           WHEN T.LVL5_CL IN ('03', '04', '05') THEN
            'B'
         END)
     AND T.DATA_DT >= TO_CHAR(TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'Y'),'YYYYMMDD')
     AND T.DATA_DT<=V_P_DATE
     ),
TMP2 AS
 (SELECT T.RCPT_ID,
         T.DATA_SRC,
         T.ADJ_DT,
         ROW_NUMBER() OVER(PARTITION BY T.RCPT_ID ORDER BY T.ADJ_DT) AS NUM
    FROM TMP1 T  --单数即不良转正常数据
   WHERE MOD(NUM, 2) > 0),
TMP3 AS
 (SELECT T.RCPT_ID,
         T.DATA_SRC,
         T.ADJ_DT,
         ROW_NUMBER() OVER(PARTITION BY T.RCPT_ID ORDER BY T.ADJ_DT) AS NUM
    FROM TMP1 T --双数即正常转不良数据
   WHERE MOD(NUM, 2) = 0)
SELECT A.RCPT_ID AS RCPT_ID,
       A.DATA_SRC AS DATA_SRC,
       CASE
         WHEN A.DATA_SRC = '零售贷款' THEN
          TO_CHAR(TO_DATE(A.ADJ_DT, 'YYYYMMDD') + 1, 'YYYYMMDD')
         ELSE   --联合网贷的调整时间如是20240430调整，则真正的调整时间是20240429
          TO_CHAR(TO_DATE(A.ADJ_DT, 'YYYYMMDD'), 'YYYYMMDD')
       END AS START_DT,
       CASE
         WHEN A.DATA_SRC = '零售贷款' THEN
          NVL(TO_CHAR(TO_DATE(B.ADJ_DT, 'YYYYMMDD') - 1, 'YYYYMMDD'),
              V_P_DATE)
         ELSE
          NVL(TO_CHAR(TO_DATE(B.ADJ_DT, 'YYYYMMDD') - 2, 'YYYYMMDD'),
              V_P_DATE)
       END AS END_DT
  FROM TMP2 A
  LEFT JOIN TMP3 B
    ON A.RCPT_ID = B.RCPT_ID
   AND A.NUM = B.NUM
   ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


    -- 程序业务逻辑处理主体部分 --
  V_STEP := 3;
  V_STEP_DESC := '记录年初不良转正常后收回金额--零售贷款';
  V_STARTTIME := SYSDATE;
     INSERT INTO S_LOAN_LV5_CHANGE_SH
        (DATA_DT,
         RCPT_ID,
         REPAY_DT,
         REPAY_TERM,
         CD_DESCB,
         CURRT_REPAY_PRIC,
         CURR_REPAY_INT
         )
   WITH TMP AS
    (select T1.RCPT_ID,
            t1.CNCL_LN_PRIN AS REPAY_AMT, --核销金额
            t1.CNCL_DT      AS TRAN_DT, --核销时间
            T1.DATA_SRC
       FROM RRP_MDL.M_LOAN_CNCL_INFO T1 --全额核销&差额核销表
      where t1.data_src in ('零售贷款差额核销', '零售贷款', '联合网贷')
        and t1.data_dt = V_P_DATE)
          SELECT V_P_DATE   AS DATA_DT,
                 DTL.DUBIL_ID RCPT_ID,
                 TO_CHAR(DTL.REPAY_DT, 'YYYYMMDD') REPAY_DT, --剔除已核销数据
                 ''   REPAY_TERM,
                 TT.CD_DESCB  AS CD_DESCB,
                 DTL.CURRT_REPAY_PRIC AS CURRT_REPAY_PRIC,
                 DTL.CURR_REPAY_INT AS CURR_REPAY_INT
            FROM ICL.CMM_UNITE_WL_REPAY_DTL DTL  --联合网贷收回
           INNER JOIN ADJ_DT_TMP TMP
              ON DTL.DUBIL_ID = TMP.RCPT_ID
             AND TO_CHAR(DTL.REPAY_DT, 'YYYYMMDD') BETWEEN TMP.START_DT AND TMP.END_DT
            LEFT JOIN TMP TMP1
              ON TMP1.RCPT_ID=DTL.DUBIL_ID
             AND TMP1.TRAN_DT<TO_CHAR(DTL.REPAY_DT,'YYYYMMDD')--剔除还款日期大于核销日期的数据
            LEFT JOIN IML.REF_PUB_CD TT
              ON TT.CD_VAL = DTL.REPAY_TYPE_CD
             AND TT.CD_ID = 'CD2820'
              WHERE TMP1.RCPT_ID IS NULL
             ;
             COMMIT;

        INSERT INTO S_LOAN_LV5_CHANGE_SH
          (DATA_DT,
           RCPT_ID,
           REPAY_DT,
           REPAY_TERM,
           CD_DESCB,
           CURRT_REPAY_PRIC,
           CURR_REPAY_INT)
           WITH TMP AS
    (select T1.RCPT_ID,
            t1.CNCL_LN_PRIN AS REPAY_AMT, --核销金额
            t1.CNCL_DT      AS TRAN_DT, --核销时间
            T1.DATA_SRC
       FROM RRP_MDL.M_LOAN_CNCL_INFO T1 --全额核销&差额核销表
      where t1.data_src in ('零售贷款差额核销', '零售贷款', '联合网贷')
        and t1.data_dt = V_P_DATE)
          SELECT V_P_DATE as DATA_dT,
                 DTL.DUBIL_ID 借据号,
                 TO_CHAR(DTL.REPAY_DT, 'YYYYMMDD') 还款日期,
                 DTL.REPAY_PERDS 还款期数,
                 DTL.REPAY_EVT_DESCB 还款描述,
                 DTL.CURRT_REPAY_PRIC 还款本金,
                 DTL.CURRT_REPAY_INT 还款利息
            FROM ICL.CMM_RETL_LOAN_REPAY_DTL DTL  --零售贷款收回明细
           INNER JOIN ADJ_DT_TMP TMP
              ON DTL.DUBIL_ID = TMP.RCPT_ID
             AND TO_CHAR(REPAY_DT, 'YYYYMMDD') BETWEEN TMP.START_DT AND TMP.END_DT
             AND DTL.STRK_BAL_FLG='0'--剔除冲正的数据
              LEFT JOIN TMP TMP1
              ON TMP1.RCPT_ID=DTL.DUBIL_ID
             AND TMP1.TRAN_DT<TO_CHAR(DTL.REPAY_DT,'YYYYMMDD')--剔除还款日期大于核销日期的数据
             WHERE TMP1.RCPT_ID IS NULL
                 ;

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
     O_ERRCODE := '1';
     V_ENDTIME := SYSDATE;
   V_STEP := V_STEP + 1;
     V_STEP_DESC := '-- 程序跑批异常 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_S_LOAN_LV5_CHANGE_SH;
/

