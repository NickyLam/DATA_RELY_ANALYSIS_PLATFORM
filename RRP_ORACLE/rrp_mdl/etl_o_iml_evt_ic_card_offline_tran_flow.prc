CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_IC_CARD_OFFLINE_TRAN_FLOW(I_P_DATE IN INTEGER,
                                                                    O_ERRCODE OUT VARCHAR2
                                                                    )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_IC_CARD_OFFLINE_TRAN_FLOW
  *  功能描述：IC卡脱机交易流水
  *  创建日期：20230114
  *  开发人员：MW
  *  来源表： IML.V_EVT_IC_CARD_OFFLINE_TRAN_FLOW
  *  目标表： O_IML_EVT_IC_CARD_OFFLINE_TRAN_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230114  MW     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_IC_CARD_OFFLINE_TRAN_FLOW'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_IC_CARD_OFFLINE_TRAN_FLOW'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_EVT_IC_CARD_OFFLINE_TRAN_FLOW T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_IC_CARD_OFFLINE_TRAN_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-IC卡脱机交易流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_IC_CARD_OFFLINE_TRAN_FLOW
    (EVT_ID  --事件编号
    ,LP_ID  --法人编号
    ,OFFLINE_FLOW_NUM  --脱机流水号
    ,OFFLINE_BATCH_NO  --脱机批次号
    ,ACCT_ID  --账户编号
    ,CARD_NO  --卡号
    ,CARD_SER_NUM  --卡序列号
    ,APP_IDF  --应用标识符
    ,OFFLINE_TRAN_TYPE_CD  --脱机交易类型代码
    ,TRAN_AMT  --交易金额
    ,PLAT_TRAN_DT  --平台交易日期
    ,PLAT_TRAN_TM  --平台交易时间
    ,UNIONPAY_CURR_CD  --银联币种代码
    ,UNIONPAY_CLEAR_DT  --银联清算日期
    ,MERCHT_ID  --商户编号
    ,MERCHT_TYPE_CD  --商户类型代码
    ,TRAN_STATUS_CD  --交易状态代码
    ,SERV_STATUS_DESCB  --服务状态描述
    ,TRAN_ADDR_DESC  --交易地址描述
    ,ELEC_CASH_ACCT_BAL  --电子现金账户余额
    ,OTHER_AMT  --其他金额
    ,ADJ_ENTRY_FLG  --调账标志
    ,ENTRY_FLG  --记账标志
    ,ENTER_ACCT_DT  --入账日期
    ,TRAN_TERMN_ID  --交易终端编号
    ,TERMN_FLOW_NUM  --终端流水号
    ,TERMN_CTY_CD  --终端国家代码
    ,ETL_DT  --ETL处理日期
    ,SRC_TABLE_NAME  --源表名称
    ,JOB_CD  --任务编码
    ,ETL_TIMESTAMP  --ETL处理时间戳
    )
  SELECT EVT_ID  --事件编号
        ,LP_ID  --法人编号
        ,OFFLINE_FLOW_NUM  --脱机流水号
        ,OFFLINE_BATCH_NO  --脱机批次号
        ,ACCT_ID  --账户编号
        ,CARD_NO  --卡号
        ,CARD_SER_NUM  --卡序列号
        ,APP_IDF  --应用标识符
        ,OFFLINE_TRAN_TYPE_CD  --脱机交易类型代码
        ,TRAN_AMT  --交易金额
        ,PLAT_TRAN_DT  --平台交易日期
        ,PLAT_TRAN_TM  --平台交易时间
        ,UNIONPAY_CURR_CD  --银联币种代码
        ,UNIONPAY_CLEAR_DT  --银联清算日期
        ,MERCHT_ID  --商户编号
        ,MERCHT_TYPE_CD  --商户类型代码
        ,TRAN_STATUS_CD  --交易状态代码
        ,SERV_STATUS_DESCB  --服务状态描述
        ,TRAN_ADDR_DESC  --交易地址描述
        ,ELEC_CASH_ACCT_BAL  --电子现金账户余额
        ,OTHER_AMT  --其他金额
        ,ADJ_ENTRY_FLG  --调账标志
        ,ENTRY_FLG  --记账标志
        ,ENTER_ACCT_DT  --入账日期
        ,TRAN_TERMN_ID  --交易终端编号
        ,TERMN_FLOW_NUM  --终端流水号
        ,TERMN_CTY_CD  --终端国家代码
        ,ETL_DT  --ETL处理日期
        ,SRC_TABLE_NAME  --源表名称
        ,JOB_CD  --任务编码
        ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_EVT_IC_CARD_OFFLINE_TRAN_FLOW  --视图-IC卡脱机交易流水
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

END ETL_O_IML_EVT_IC_CARD_OFFLINE_TRAN_FLOW;
/

