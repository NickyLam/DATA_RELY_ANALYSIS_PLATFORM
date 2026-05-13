CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_CSNER_OUT_ACCT_INFO_H(I_P_DATE IN INTEGER, --跑批日期
                                                                O_ERRCODE  OUT VARCHAR2 --错误代码
                                                                )
 /*******************************************************************
  **存储过程详细说明： 委托人出账信息历史
  **存储过程名称：    ETL_O_IML_AGT_CSNER_OUT_ACCT_INFO_H
  **存储过程创建日期：20221129
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250106    YJY        优化脚本
  ******************************************************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;             --\处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_CSNER_OUT_ACCT_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_CSNER_OUT_ACCT_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-委托人出账信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_CSNER_OUT_ACCT_INFO_H NOLOGGING
    (APPL_ID                 --申请编号
    ,LP_ID                   --法人编号
    ,FLOW_NUM                --流水号
    ,CSNER_CUST_ID           --委托人客户编号
    ,CSNER_NAME              --委托人名称
    ,CSNER_ACCT_ID           --委托人账户编号
    ,CSNER_DEP_ACCT_NAME     --委托人存款账户名称
    ,CSNER_TYPE_CD           --委托人类型代码
    ,ENTR_DEP_ACCT_ID        --委托存款账户账号
    ,ENTR_DEP_ACCT_NAME      --委托存款账户名称
    ,DUBIL_ID                --借据编号
    ,BORW_CONT_ID            --借款合同编号
    ,BRWER_CUST_ID           --借款人客户编号
    ,BRWER_NAME              --借款人名称
    ,PRIC_RTN_ENTER_ID       --本金归还入账账户编号
    ,PRIC_RTN_ENTER_NAME     --本金归还入账账户名称
    ,STAMP_TAX_TAX_ACCT_ID   --印花税扣税账户编号
    ,STAMP_TAX_TAX_ACCT_NAME --印花税扣税账户名称
    ,COMM_FEE_COLL_ACCT_ID   --手续费收取账户编号
    ,COMM_FEE_COLL_ACCT_NAME --手续费收取账户名称
    ,INT_RTN_ENTER_ID        --利息归还入账账户编号
    ,INT_RTN_ENTER_NAME      --利息归还入账账户名称
    ,CAP_SRC_CD              --资金来源代码
    ,CSNER_OPEN_BANK_NUM     --委托人开户行号
    ,CSNER_OPEN_BANK_NAME    --委托人开户行名称
    ,START_DT                --开始时间
    ,END_DT                  --结束时间
    ,ID_MARK                 --增删标志
    ,SRC_TABLE_NAME          --源表名称
    ,JOB_CD                  --任务编码
    ,ETL_TIMESTAMP           --ETL处理时间戳
    )
  SELECT /*+PARALLEL*/
     APPL_ID                 --申请编号
    ,LP_ID                   --法人编号
    ,FLOW_NUM                --流水号
    ,CSNER_CUST_ID           --委托人客户编号
    ,CSNER_NAME              --委托人名称
    ,CSNER_ACCT_ID           --委托人账户编号
    ,CSNER_DEP_ACCT_NAME     --委托人存款账户名称
    ,CSNER_TYPE_CD           --委托人类型代码
    ,ENTR_DEP_ACCT_ID        --委托存款账户账号
    ,ENTR_DEP_ACCT_NAME      --委托存款账户名称
    ,DUBIL_ID                --借据编号
    ,BORW_CONT_ID            --借款合同编号
    ,BRWER_CUST_ID           --借款人客户编号
    ,BRWER_NAME              --借款人名称
    ,PRIC_RTN_ENTER_ID       --本金归还入账账户编号
    ,PRIC_RTN_ENTER_NAME     --本金归还入账账户名称
    ,STAMP_TAX_TAX_ACCT_ID   --印花税扣税账户编号
    ,STAMP_TAX_TAX_ACCT_NAME --印花税扣税账户名称
    ,COMM_FEE_COLL_ACCT_ID   --手续费收取账户编号
    ,COMM_FEE_COLL_ACCT_NAME --手续费收取账户名称
    ,INT_RTN_ENTER_ID        --利息归还入账账户编号
    ,INT_RTN_ENTER_NAME      --利息归还入账账户名称
    ,CAP_SRC_CD              --资金来源代码
    ,CSNER_OPEN_BANK_NUM     --委托人开户行号
    ,CSNER_OPEN_BANK_NAME    --委托人开户行名称
    ,START_DT                --开始时间
    ,END_DT                  --结束时间
    ,ID_MARK                 --增删标志
    ,SRC_TABLE_NAME          --源表名称
    ,JOB_CD                  --任务编码
    ,ETL_TIMESTAMP           --ETL处理时间戳
    FROM IML.V_AGT_CSNER_OUT_ACCT_INFO_H  --委托人出账信息历史视图
   WHERE ID_MARK <> 'D' ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_CSNER_OUT_ACCT_INFO_H', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_IML_AGT_CSNER_OUT_ACCT_INFO_H;
/

