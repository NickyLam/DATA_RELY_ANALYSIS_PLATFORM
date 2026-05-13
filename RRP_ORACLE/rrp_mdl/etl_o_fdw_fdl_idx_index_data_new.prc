CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_FDW_FDL_IDX_INDEX_DATA_NEW(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_FDW_FDL_IDX_INDEX_DATA_NEW
  *  功能描述：指标-指标数据
  *  创建日期：20220627
  *  开发人员：梅炜
  *  来源表： FDW.V_FDL_IDX_INDEX_DATA_NEW
  *  目标表： O_FDW_FDL_IDX_INDEX_DATA_NEW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220627  梅炜     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;            --处理步骤
  V_P_DATE    VARCHAR2(8);             --跑批数据日期
  V_STARTTIME DATE;                    --处理开始时间
  V_ENDTIME   DATE;                    --处理结束时间
  V_SQLCOUNT  INTEGER := 0;            --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);           --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);           --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_FDW_FDL_IDX_INDEX_DATA_NEW'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_FDW_FDL_IDX_INDEX_DATA_NEW T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_FDW_FDL_IDX_INDEX_DATA_NEW';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '财务指标-指标数据';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_FDW_FDL_IDX_INDEX_DATA_NEW
    (INDEX_NO
    ,ORG_NO
    ,BIZ_STRIP_LINE_CD
    ,DIM_CD1
    ,DIM_CD2
    ,DIM_CD3
    ,BATCH_FREQ
    ,INDEX_MEASURE
    ,CURR_CD
    ,INDEX_VAL
    ,ETL_DT
    ,ETL_TIMESTAMP
    )
  SELECT INDEX_NO
        ,ORG_NO
        ,BIZ_STRIP_LINE_CD
        ,DIM_CD1
        ,DIM_CD2
        ,DIM_CD3
        ,BATCH_FREQ
        ,INDEX_MEASURE
        ,CURR_CD
        ,INDEX_VAL
        ,ETL_DT
        ,ETL_TIMESTAMP
    FROM FDW.V_FDL_IDX_INDEX_DATA_NEW  --视图-指标-指标数据
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分析表
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_FDW_FDL_IDX_INDEX_DATA_NEW', '', O_ERRCODE); --表分析

  --程序跑批结束记录
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES(V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_FDW_FDL_IDX_INDEX_DATA_NEW;
/

