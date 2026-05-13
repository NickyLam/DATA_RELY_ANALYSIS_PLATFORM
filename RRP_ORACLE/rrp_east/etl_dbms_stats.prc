CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_DBMS_STATS(I_DATADATE       IN CHAR, --跑批日期
                                           I_TABLE_NAME     IN VARCHAR2, --表名称
                                           I_PARTITION_NAME IN VARCHAR2, --表分区名称：如果没有分区置空
                                           O_ERRCODE        OUT VARCHAR2 --错误代码
                                           )
 /***********************************************************************
    **  存储过程详细说明：表分析
    **  存储过程名称:  ETL_DBMS_STATS
    **  存储过程创建日期:2022-03-22
    **  存储过程创建人:蔡正伟
    **  调用方法:
         DECLARE
           I_DATADATE INTEGER;
           O_ERRCODE  CHAR(1);
         BEGIN
           I_DATADATE := '20220101';
           ETL_DBMS_STATS(I_DATADATE, O_ERRCODE);
         END;
    **  输入参数:   I_DATADATE
    **  输出参数:   O_ERRCODE
    **  返回值:     O_ERRCODE
    **  修改日期          修改项目        修改原因           修改人
    **
  ***********************************************************************/
IS
  V_DATEID         CHAR(8);               --数据日期
  V_START_DATE     DATE;                  --跑批开始时间
  V_END_DATE       DATE;                  --跑批结束时间
  V_PROC_NAME      VARCHAR2(100);         --存储过程名称
  V_TABLE_NAME     VARCHAR2(100);         --表名称
  V_PARTITION_NAME VARCHAR2(100);         --分区名称
  V_STEP_ID        INTEGER := 1;          --任务号
  V_STEP_DESC      VARCHAR2(1000);        --任务描述
  V_SCHEMA         VARCHAR2(100);         --模式名称
  V_COUNT          INTEGER := 0;          --数据记录条数
  V_SQLMSG         VARCHAR2(300);         --SQL执行描述信息
  V_SYSTEM         VARCHAR2(30) := '监管报送'; --来源系统
BEGIN
  V_DATEID         := TO_CHAR(I_DATADATE);
  V_START_DATE     := SYSDATE;
  V_PROC_NAME      := UPPER('ETL_'||I_TABLE_NAME);
  V_TABLE_NAME     := UPPER(I_TABLE_NAME);
  V_PARTITION_NAME := UPPER(I_PARTITION_NAME);
  V_SCHEMA         := USER;
  O_ERRCODE        := 0;
  V_STEP_DESC      := '表分析';

  --表分析
  IF V_PARTITION_NAME IS NULL THEN

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => V_SCHEMA,
                                  TABNAME          => V_TABLE_NAME,
                                  CASCADE          => TRUE,
                                  ESTIMATE_PERCENT => 1,
                                  DEGREE           => 1);

  END IF;

  IF V_PARTITION_NAME IS NOT NULL THEN

    DBMS_STATS.GATHER_TABLE_STATS(OWNNAME          => V_SCHEMA,
                                  TABNAME          => V_TABLE_NAME,
                                  PARTNAME         => V_PARTITION_NAME,
                                  CASCADE          => TRUE,
                                  ESTIMATE_PERCENT => 1,
                                  DEGREE           => 1);

  END IF;

  --记录正常日志
  V_END_DATE := SYSDATE;
  ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,V_START_DATE,V_END_DATE,V_STEP_ID,V_STEP_DESC,V_COUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE  := 1; --将SQL错误编号赋植给O_ERRCODE
    V_SQLMSG   := '发生异常！详细信息为： ' || SUBSTR(SQLERRM, 1, 280);
    V_END_DATE := SYSDATE;
    RAISE;
    --记录异常信息
    ETL_YUSYS_LOG(V_DATEID,V_SYSTEM,V_PROC_NAME,V_START_DATE,V_END_DATE,V_STEP_ID,V_STEP_DESC,V_COUNT,O_ERRCODE,V_SQLMSG);

END ETL_DBMS_STATS;
/

