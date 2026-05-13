CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_STATE_INSERT_ADD(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_STATE_INSERT_ADD
  *  功能描述：特殊情况下插入跑批完成记录表——补录
  *  创建日期：20230417
  *  开发人员：MW
  *  来源表：
  *  目标表：  ETL_STATE
  *  配置表：  VIEW_LIST_FROM_HDW
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230417  梅炜      首次创建
  ***************************************************************************/
AS
  --定义变量
  V_STEP       INTEGER := '0';         --处理步骤
  V_P_DATE     VARCHAR2(8);            --跑批数据日期
  V_STARTTIME  DATE;                   --处理开始时间
  V_ENDTIME    DATE;                   --处理结束时间
  V_SQLCOUNT   INTEGER := 0;           --更新或删除影响的记录数
  V_SQLMSG     VARCHAR2(300);          --SQL执行描述信息
  V_STEP_DESC  VARCHAR2(200);          --任务名称
  V_TABLE_NAME VARCHAR2(100);          --表名
  M_PROC_NAME  VARCHAR2(200);          --存储过程名
  FINISH_FLG   INTEGER;                --跑批完成标志
  V_SYSTEM     VARCHAR2(30) := '监管报送'; --来源系统
  V_PROC_NAME  VARCHAR2(50) := 'ETL_STATE_INSERT_ADD'; --程序名称
  CURSOR C_TAB IS SELECT * FROM RRP_MDL.VIEW_LIST_FROM_HDW WHERE SUBSTR(ID,0,3) = 'ADD';
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE);
  V_STARTTIME := SYSDATE;

  FOR TAB IN C_TAB LOOP
    V_TABLE_NAME := TAB.TABLE_NAME;
    FINISH_FLG   := 0;
    M_PROC_NAME  := 'ETL_'||V_TABLE_NAME;

    SELECT COUNT(1) INTO FINISH_FLG FROM RRP_MDL.ETL_STATE
     WHERE PROC_NAME = M_PROC_NAME
       AND ETL_DATE = V_P_DATE;

    IF FINISH_FLG < 1 THEN
      INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
      VALUES (V_P_DATE,M_PROC_NAME,SYSDATE);
      COMMIT;
    END IF;
  END LOOP;
  
  V_STEP_DESC := '程序跑批结束';
  O_ERRCODE   := '0';
  V_ENDTIME   := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_STATE_INSERT_ADD;
/

