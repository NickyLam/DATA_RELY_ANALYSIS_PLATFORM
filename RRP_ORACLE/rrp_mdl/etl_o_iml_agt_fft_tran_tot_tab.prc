CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_FFT_TRAN_TOT_TAB(I_P_DATE IN INTEGER, --跑批日期
                                                           O_ERRCODE  OUT VARCHAR2 --错误代码
                                                           )
 /*******************************************************************
  **存储过程详细说明： 福费廷转让汇总表
  **存储过程名称：    ETL_O_IML_AGT_FFT_TRAN_TOT_TAB
  **存储过程创建日期：20240204
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  **  20240204   hulj       首次创建
  *   20240312   YJY        新增“资金来源银行名称”字段
  *   20241226   YJY        优化脚本
  ******************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(500) := 'ETL_O_IML_AGT_FFT_TRAN_TOT_TAB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_FFT_TRAN_TOT_TAB';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-福费廷转让汇总表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_FFT_TRAN_TOT_TAB NOLOGGING
    (AGT_ID                     --协议编号
    ,LP_ID                      --法人编号
    ,FLOW_NUM                   --流水号
    ,CNTPTY_ID                  --交易对手编号
    ,CNTPTY_NAME                --交易对手名称
    ,DUBIL_CNT                  --借据笔数
    ,TRAN_SELL_RECVBL_AMT_TOT   --转卖收款金额汇总
    ,TRAN_SELL_DUBIL_AMT_TOT    --转卖借据金额汇总
    ,RECVBL_ACCT_ID             --收款账户编号
    ,TS_FLG                     --暂存标志
    ,TRAN_COMNT                 --转让说明
    ,CAP_SRC_ACCT_ID            --资金来源账户编号
    ,CAP_SRC_ACCT_NAME          --资金来源账户名称
    ,CAP_SRC_BANK_NO            --资金来源行号
    ,CAP_SRC_BANK_NAME          --资金来源行名称  ADD BY YJY 20240312
    ,START_DT                   --开始日期
    ,END_DT                     --结束日期
    ,ID_MARK                    --删除标识
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务代码
    )
  SELECT /*+PARALLEL*/
         AGT_ID                     --协议编号
        ,LP_ID                      --法人编号
        ,FLOW_NUM                   --流水号
        ,CNTPTY_ID                  --交易对手编号
        ,CNTPTY_NAME                --交易对手名称
        ,DUBIL_CNT                  --借据笔数
        ,TRAN_SELL_RECVBL_AMT_TOT   --转卖收款金额汇总
        ,TRAN_SELL_DUBIL_AMT_TOT    --转卖借据金额汇总
        ,RECVBL_ACCT_ID             --收款账户编号
        ,TS_FLG                     --暂存标志
        ,TRAN_COMNT                 --转让说明
        ,CAP_SRC_ACCT_ID            --资金来源账户编号
        ,CAP_SRC_ACCT_NAME          --资金来源账户名称
        ,CAP_SRC_BANK_NO            --资金来源行号
        ,CAP_SRC_BANK_NAME          --资金来源行名称  ADD BY YJY 20240312
        ,START_DT                   --开始日期
        ,END_DT                     --结束日期
        ,ID_MARK                    --删除标识
        ,SRC_TABLE_NAME             --源表名称
        ,JOB_CD                     --任务代码
    FROM IML.V_AGT_FFT_TRAN_TOT_TAB   --福费廷转让汇总表
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_FFT_TRAN_TOT_TAB', '', O_ERRCODE);

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

END ETL_O_IML_AGT_FFT_TRAN_TOT_TAB;
/

