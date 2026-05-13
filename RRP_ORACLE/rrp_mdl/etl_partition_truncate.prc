CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_PARTITION_TRUNCATE(I_DATADATE   IN INTEGER, --跑批日期
                                               I_TABLE_NAME IN VARCHAR2, --表名称
                                               O_ERRCODE    OUT CHAR --错误代码
                                               )
/***********************************************************************
  ************************************************************************
    **  存储过程详细说明：分区删除
    **  存储过程名称:  ETL_PARTITION_TRUNCATE
    **  存储过程创建日期:2022-03-22
    **  存储过程创建人:蔡正伟
    **  调用方法:
         DECLARE
           I_DATADATE INTEGER;
           O_ERRCODE  CHAR(1);
         BEGIN
           I_DATADATE := '20220101';
           ETL_PARTITION_TRUNCATE(I_DATADATE, O_ERRCODE);
         END;
    **  输入参数:   I_DATADATE
    **  输出参数:   O_ERRCODE
    **  返回值:     O_ERRCODE
    **  修改日期          修改项目        修改原因           修改人
    **
    ************************************************************************
  ***********************************************************************/
 IS
  V_DATE            DATE; --数据日期(判断输入参数日期格式是否准确)
  V_P_DATE          CHAR(8); --数据日期
  V_START_DATE      DATE; --跑批开始时间
  V_END_DATE        DATE; --跑批结束时间
  V_PROC_NAME       VARCHAR2(50); --存储过程名称
  V_TABLE_NAME      VARCHAR2(100); --表名称
  V_STEP_ID         INTEGER; --任务号
  V_STEP_DESC       VARCHAR2(1000); --任务描述
  V_STAT_DESC       VARCHAR2(20); --跑批状态
  V_PARTITION_NAME  VARCHAR2(100); --分区名称
  V_PARTITION_COUNT INTEGER; --分区记录
  V_SYSTEM          VARCHAR2(100); --系统名称
  V_COUNT           INTEGER; --数据记录条数
  V_SQL             VARCHAR2(1000); --删除分区脚本
  V_SQLMSG          VARCHAR2(300);  -- SQL执行描述信息

BEGIN
  V_P_DATE     := TO_CHAR(I_DATADATE);
  V_START_DATE := SYSDATE;
  V_PROC_NAME  := UPPER('ETL_'||I_TABLE_NAME);
  V_TABLE_NAME := UPPER(I_TABLE_NAME);
  V_STAT_DESC  := '跑批正确';
  O_ERRCODE    := '0';
  V_STEP_ID    := '1';
  V_COUNT      := 0;
  V_SYSTEM     := '监管报送';
  V_STEP_DESC  := '删除' || V_TABLE_NAME || '分区' || V_PARTITION_NAME;
  ----将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE           := TO_DATE(SUBSTR(I_DATADATE, 1, 4) || '-' ||
                              SUBSTR(I_DATADATE, 5, 2) || '-' ||
                              SUBSTR(I_DATADATE, 7, 2),
                              'YYYY-MM-DD');
  V_PARTITION_NAME := 'PARTITION_' || V_P_DATE;

  ---查看当日分区是否已存在

  SELECT COUNT(0)
    INTO V_PARTITION_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TABLE_NAME
     AND T.PARTITION_NAME = V_PARTITION_NAME;

  ---删除当日已存在分区

  IF V_PARTITION_COUNT = 1 THEN
    /*V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || ' DROP PARTITION ' ||
    V_PARTITION_NAME;*/

    V_SQL := 'ALTER TABLE ' || V_TABLE_NAME || ' TRUNCATE PARTITION ' ||
             V_PARTITION_NAME;

    EXECUTE IMMEDIATE V_SQL;
  END IF;

  ---记录正常日志
  V_END_DATE := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,
                V_SYSTEM,
                V_PROC_NAME,
                V_START_DATE,
                V_END_DATE,
                V_STEP_ID,
                V_STEP_DESC,
                V_COUNT,
                O_ERRCODE,
                V_SQLMSG
                );

EXCEPTION
  WHEN OTHERS THEN
    O_ERRCODE   := '1'; --将SQL错误编号赋植给O_ERRCODE
    V_STEP_DESC := '发生异常！详细信息为： ' || SUBSTR(SQLERRM, 1, 280);
    V_END_DATE  := SYSDATE;
    V_COUNT     := 1;
    V_STAT_DESC := '跑批异常';
    --记录异常信息

  ETL_YUSYS_LOG(V_P_DATE,
                V_SYSTEM,
                V_PROC_NAME,
                V_START_DATE,
                V_END_DATE,
                V_STEP_ID,
                V_STEP_DESC,
                V_COUNT,
                O_ERRCODE,
                V_SQLMSG
                );
    RAISE;

END ETL_PARTITION_TRUNCATE;
/

