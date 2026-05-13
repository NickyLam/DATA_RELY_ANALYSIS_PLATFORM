CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_PAYOFF_WITHHOLD_BATCH_DTL(I_P_DATE IN INTEGER,
                                                                    O_ERRCODE OUT VARCHAR2
                                                                    )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_PAYOFF_WITHHOLD_BATCH_DTL
  *  功能描述：代发代扣签约信息历史
  *  创建日期：20221227
  *  开发人员：梅炜
  *  来源表： IML.V_EVT_PAYOFF_WITHHOLD_BATCH_DTL
  *  目标表： O_IML_EVT_PAYOFF_WITHHOLD_BATCH_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221227  梅炜     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_PAYOFF_WITHHOLD_BATCH_DTL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_PAYOFF_WITHHOLD_BATCH_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_EVT_PAYOFF_WITHHOLD_BATCH_DTL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_PAYOFF_WITHHOLD_BATCH_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-代发代扣签约信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_PAYOFF_WITHHOLD_BATCH_DTL
    (EVT_ID  --事件编号
    ,LP_ID  --法人编号
    ,TRAN_DT  --交易日期
    ,TRAN_FLOW_NUM  --交易流水号
    ,BATCH_ID  --批次编号
    ,DEDUCT_SEQ_NUM  --扣款序号
    ,ACCT_ID  --账户编号
    ,ACCT_NAME  --账户名称
    ,AMT  --金额
    ,ACCT_NUM_RESP_CODE  --账号响应码
    ,ACCT_NUM_RESP_INFO  --账号响应信息
    ,HOST_FLOW_NUM  --主机流水号
    ,HOST_TRAN_DT  --主机交易日期
    ,HOST_RETURN_CODE  --主机返回码
    ,HOST_RETURN_INFO  --主机返回信息
    ,ETL_DT  --ETL处理日期
    ,SRC_TABLE_NAME  --源表名称
    ,JOB_CD  --任务编码
    ,ETL_TIMESTAMP  --ETL处理时间戳
    )
  SELECT EVT_ID  --事件编号
        ,LP_ID  --法人编号
        ,TRAN_DT  --交易日期
        ,TRAN_FLOW_NUM  --交易流水号
        ,BATCH_ID  --批次编号
        ,DEDUCT_SEQ_NUM  --扣款序号
        ,ACCT_ID  --账户编号
        ,ACCT_NAME  --账户名称
        ,AMT  --金额
        ,ACCT_NUM_RESP_CODE  --账号响应码
        ,ACCT_NUM_RESP_INFO  --账号响应信息
        ,HOST_FLOW_NUM  --主机流水号
        ,HOST_TRAN_DT  --主机交易日期
        ,HOST_RETURN_CODE  --主机返回码
        ,HOST_RETURN_INFO  --主机返回信息
        ,ETL_DT  --ETL处理日期
        ,SRC_TABLE_NAME  --源表名称
        ,JOB_CD  --任务编码
        ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_EVT_PAYOFF_WITHHOLD_BATCH_DTL  --视图-代发代扣签约信息历史
   /*WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  V_STEP := 3;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
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

END ETL_O_IML_EVT_PAYOFF_WITHHOLD_BATCH_DTL;
/

