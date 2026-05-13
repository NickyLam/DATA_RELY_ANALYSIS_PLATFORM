CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_REPAY_DTL(I_P_DATE IN INTEGER, --跑批日期
                                                    O_ERRCODE OUT VARCHAR2 --错误代码
                                                    )
 /*******************************************************************
  **存储过程详细说明： 还款明细表
  **存储过程名称：    ETL_O_IML_EVT_REPAY_DTL
  **存储过程创建日期：20221129
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(100) := 'O_IML_EVT_REPAY_DTL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_REPAY_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_REPAY_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-还款明细表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_REPAY_DTL NOLOGGING
    (EVT_ID                   --事件编号
    ,CALLBK_ID                --回收编号
    ,ADVISE_ODD_NO            --通知单号
    ,LP_ID                    --法人编号
    ,ACCT_ID                  --账户编号
    ,CUST_ACCT_NUM            --客户账号
    ,CURR_PD                  --当前期次
    ,AMT_TYPE_CD              --金额类型代码
    ,CALLBK_CURR_CD           --回收币种代码
    ,CALLBK_TO_CNY_EXCH_RAT   --回收对人民币汇率
    ,CALLBK_EXCH_WAY_CD       --回收汇兑方式代码
    ,CALLBK_PRIC              --回收金额
    ,OPEN_ACCT_ORG_ID         --开户机构编号
    ,TRAN_TM                  --交易时间
    ,ETL_DT                   --数据日期
    ,SRC_TABLE_NAME           --源表名称
    ,JOB_CD                   --任务代码
    ,ETL_TIMESTAMP            --数据处理时间
    )
  SELECT /*+PARALLEL*/
         EVT_ID                   --事件编号
        ,CALLBK_ID                --回收编号
        ,ADVISE_ODD_NO            --通知单号
        ,LP_ID                    --法人编号
        ,ACCT_ID                  --账户编号
        ,CUST_ACCT_NUM            --客户账号
        ,CURR_PD                  --当前期次
        ,AMT_TYPE_CD              --金额类型代码
        ,CALLBK_CURR_CD           --回收币种代码
        ,CALLBK_TO_CNY_EXCH_RAT   --回收对人民币汇率
        ,CALLBK_EXCH_WAY_CD       --回收汇兑方式代码
        ,CALLBK_PRIC              --回收金额
        ,OPEN_ACCT_ORG_ID         --开户机构编号
        ,TRAN_TM                  --交易时间
        ,ETL_DT                   --数据日期
        ,SRC_TABLE_NAME           --源表名称
        ,JOB_CD                   --任务代码
        ,ETL_TIMESTAMP            --数据处理时间
    FROM IML.V_EVT_REPAY_DTL   --视图_还款明细表
   /*WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
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

END ETL_O_IML_EVT_REPAY_DTL;
/

