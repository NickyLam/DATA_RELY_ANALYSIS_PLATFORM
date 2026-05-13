CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_REF_BASE_RAT_H(I_P_DATE IN INTEGER,
                                                     O_ERRCODE OUT VARCHAR2
                                                     )
  /**************************************************************************
  *  程序名称：ETL_O_IML_REF_BASE_RAT_H
  *  功能描述：基准利率历史表
  *  创建日期：20230201
  *  开发人员：MW
  *  来源表： IML.V_REF_BASE_RAT_H
  *  目标表： O_IML_REF_BASE_RAT_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230201  MW     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_REF_BASE_RAT_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_REF_BASE_RAT_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_REF_BASE_RAT_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_REF_BASE_RAT_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-基准利率历史表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_REF_BASE_RAT_H
    (LP_ID  --法人编号
    ,BASE_RAT_ID  --基准利率编号
    ,CURR_CD  --币种代码
    ,EFFECT_DT  --生效日期
    ,BASE_RAT  --基准利率
    ,START_DT  --开始时间
    ,END_DT  --结束时间
    ,ID_MARK  --增删标志
    ,SRC_TABLE_NAME  --源表名称
    ,JOB_CD  --任务编码
    ,ETL_TIMESTAMP  --ETL处理时间戳
    ,INVALID_DT --失效日期 --ADD BY LIP 20230809
    )
  WITH TMP1 AS (
    SELECT T.BASE_RAT_ID,T.CURR_CD,T.EFFECT_DT,MIN(TA.EFFECT_DT) INVALID_DT
      FROM IML.V_REF_BASE_RAT_H T 
     INNER JOIN IML.V_REF_BASE_RAT_H TA 
        ON TA.BASE_RAT_ID = T.BASE_RAT_ID
       AND TA.CURR_CD = T.CURR_CD
       AND TA.EFFECT_DT > T.EFFECT_DT
       AND TA.ID_MARK <> 'D'
       AND TA.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND TA.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     WHERE T.ID_MARK <> 'D'
       AND T.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
       AND T.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     GROUP BY T.BASE_RAT_ID,T.CURR_CD,T.EFFECT_DT)
  SELECT  TB.LP_ID  --法人编号
         ,TB.BASE_RAT_ID  --基准利率编号
         ,TB.CURR_CD  --币种代码
         ,TB.EFFECT_DT  --生效日期
         ,TB.BASE_RAT  --基准利率
         ,TB.START_DT  --开始时间
         ,TB.END_DT  --结束时间
         ,TB.ID_MARK  --增删标志
         ,TB.SRC_TABLE_NAME  --源表名称
         ,TB.JOB_CD  --任务编码
         ,TB.ETL_TIMESTAMP  --ETL处理时间戳
         ,NVL(TC.INVALID_DT,TO_DATE('20991231','YYYYMMDD')) INVALID_DT --失效日期 --ADD BY LIP 20230809
    FROM IML.V_REF_BASE_RAT_H TB --视图-基准利率历史表
    LEFT JOIN TMP1 TC 
      ON TC.BASE_RAT_ID = TB.BASE_RAT_ID
     AND TC.CURR_CD = TB.CURR_CD
     AND TC.EFFECT_DT = TB.EFFECT_DT
   WHERE TB.ID_MARK <> 'D'
     AND TB.START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TB.END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
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

END ETL_O_IML_REF_BASE_RAT_H;
/

