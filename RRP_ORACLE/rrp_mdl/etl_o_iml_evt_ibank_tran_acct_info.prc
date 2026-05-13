CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_IBANK_TRAN_ACCT_INFO(I_P_DATE IN INTEGER,
                                                               O_ERRCODE OUT VARCHAR2
                                                               )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_IBANK_TRAN_ACCT_INFO
  *  功能描述：同业交易账户信息
  *  创建日期：20230612
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_EVT_IBANK_TRAN_ACCT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230614  梅炜     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_IBANK_TRAN_ACCT_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_IBANK_TRAN_ACCT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_EVT_IBANK_TRAN_ACCT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_IBANK_TRAN_ACCT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-同业交易账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_IBANK_TRAN_ACCT_INFO
    (EVT_ID                  --事件编号
    ,LP_ID                   --法人编号
    ,APV_ODD_NO              --审批单号
    ,CUST_ACCT_ID            --客户账户编号
    ,CUST_ACCT_SUB_ACCT_ID   --客户账户子户号
    ,CUST_ID                 --交易客户编号
    ,SAV_TYPE_CD             --储种代码
    ,ETL_DT                  --ETL处理日期
    )
  SELECT EVT_ID                  --事件编号
        ,LP_ID                   --法人编号
        ,APV_ODD_NO              --审批单号
        ,CUST_ACCT_ID            --客户账户编号
        ,CUST_ACCT_SUB_ACCT_ID   --客户账户子户号
        ,CUST_ID                 --交易客户编号
        ,SAV_TYPE_CD             --储种代码
        ,ETL_DT                  --ETL处理日期
    FROM IML.V_EVT_IBANK_TRAN_ACCT_INFO  --视图-同业交易账户信息
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

END ETL_O_IML_EVT_IBANK_TRAN_ACCT_INFO;
/

