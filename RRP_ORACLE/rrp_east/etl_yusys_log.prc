CREATE OR REPLACE PROCEDURE RRP_EAST.ETL_YUSYS_LOG(V_P_DATE    IN VARCHAR2, --跑批数据日期
                                          V_SYSTEM    IN VARCHAR2, --来源系统
                                          V_PROC_NAME IN VARCHAR2, --程序名称
                                          V_STARTTIME IN DATE,     --处理开始时间
                                          V_ENDTIME   IN DATE,     --处理结束时间
                                          V_STEP      IN INTEGER,  --处理步骤
                                          V_STEP_DESC IN VARCHAR2, --步骤描述
                                          V_SQLCOUNT  IN INTEGER,  --记录条数
                                          O_ERRCODE   IN INTEGER,  --返回值
                                          V_SQLMSG    IN VARCHAR2  --SQL执行描述信息
                                          )
  /**************************************************************************
  *  程序名称：ETL_YUSYS_LOG
  *  功能描述：监管报送平台存储过程日志处理程序，记录每一个程序每一步运行情况
  *  创建日期：20220514
  *  开发人员：唐安
  *  来源表：
  *  目标表：  ETL_LOG
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *
  ***************************************************************************/
AS
BEGIN
  --程序业务逻辑处理主体部分
  INSERT INTO ETL_LOG
    (P_DATE       --跑批数据日期
    ,SYSTEM       --来源系统
    ,PROC_NAME    --程序名称
    ,STARTTIME    --处理开始时间
    ,ENDTIME      --处理结束时间
    ,STEP         --处理步骤
    ,STEP_DESC    --步骤描述
    ,SQLCOUNT     --记录数
    ,RETURN_CODE  --返回值
    ,SQLMSG       --SQL执行描述信息
    )
  VALUES
    (V_P_DATE       --跑批数据日期
    ,V_SYSTEM       --来源系统
    ,V_PROC_NAME    --程序名称
    ,V_STARTTIME    --处理开始时间
    ,V_ENDTIME      --处理结束时间
    ,V_STEP         --处理步骤
    ,V_STEP_DESC    --步骤描述
    ,V_SQLCOUNT     --记录条数
    ,TRIM(TO_CHAR(O_ERRCODE)) --返回值
    ,V_SQLMSG       --SQL执行描述信息
    );
  COMMIT;

END ETL_YUSYS_LOG;
/

