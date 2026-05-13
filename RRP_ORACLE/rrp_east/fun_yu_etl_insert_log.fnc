CREATE OR REPLACE FUNCTION RRP_EAST.FUN_YU_ETL_INSERT_LOG(V_DATA_DT   IN INTEGER,
                                                 V_PROC_NAME IN VARCHAR2,
                                                 V_STEP_ID   IN VARCHAR2,
                                                 V_STEP_DESC IN VARCHAR2)
  RETURN VARCHAR2 IS
  /***********************************************************************
  ************************************************************************
    **  存储过程详细说明：日志表
    **  存储过程名称:  FUN_YU_ETL_INSERT_LOG
    **  存储过程创建日期:2022-4-23
    **  存储过程创建人:WUHB
    **  目的:
    **  输入参数:
    **  V_DATA_DT         VARCHAR2(8), --数据日期
        V_PROC_NAME VARCHAR2(20), --过程英文名称
        V_STEP_ID        INTEGER, --步骤
        V_STEP_DESC      VARCHAR2(3000), --步骤描述（含错误信息提示）
    **  输出参数:
    **  返回值: V_SP_ID
    **  修改日期          修改项目        修改原因           修改人
    **
    ************************************************************************
  ***********************************************************************/

  V_SP_ID INTEGER;

BEGIN
  /*将序列ID赋值给 V_SP_ID*/
  SELECT SQ_YU_LOG_ID.NEXTVAL INTO V_SP_ID FROM DUAL;
  /*插入操作日志*/
  INSERT INTO ETL_LOG
    (P_DATE, STARTTIME, PROC_NAME, STEP, STEP_DESC)
  VALUES
    ( V_DATA_DT, SYSDATE, V_PROC_NAME, V_STEP_ID, V_STEP_DESC);

  COMMIT;
  /*将序列ID返回便于使用*/
  RETURN V_SP_ID;

END;
/

