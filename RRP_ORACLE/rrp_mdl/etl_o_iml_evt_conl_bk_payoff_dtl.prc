CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_CONL_BK_PAYOFF_DTL(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_CONL_BK_PAYOFF_DTL
  *  功能描述：企业网银代发明细
  *  创建日期：20221227
  *  开发人员：梅炜
  *  来源表： IML.V_EVT_CONL_BK_PAYOFF_DTL
  *  目标表： O_IML_EVT_CONL_BK_PAYOFF_DTL
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_CONL_BK_PAYOFF_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_IML_EVT_CONL_BK_PAYOFF_DTL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--需后面加分区删除6个月前的数
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_CONL_BK_PAYOFF_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-企业网银代发明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_CONL_BK_PAYOFF_DTL
    (EVT_ID                   --事件编号
    ,LP_ID                    --法人编号
    ,BATCH_ID                 --批次编号
    ,BATCH_DT                 --批次日期
    ,REC_ID                   --记录编号
    ,CHN_DT                   --渠道日期
    ,CHN_SEQ_NUM              --渠道序号
    ,CONL_BK_TRAN_TYPE_CD     --企业网银交易类型代码
    ,DTL_ACCT_ID              --明细账户编号
    ,DTL_ACCT_NAME            --明细账户名称
    ,TRAN_AMT                 --交易金额
    ,TRAN_SUCS_AMT            --交易成功金额
    ,DEDUCT_MODE_CD           --扣款模式代码
    ,CORE_MEMO_CD             --核心摘要代码
    ,CORP_AGENT_ACCT          --对公代理账户
    ,CORE_TRAN_FLOW_NUM       --核心交易流水号
    ,CORE_TRAN_DT             --核心交易日期
    ,RESP_CODE                --响应码
    ,RESP_CODE_DESCB          --响应码描述
    ,CNTPTY_ACCT_BANK_NUM     --对手账户行号
    ,POSTSC                   --附言
    ,UNIFY_PAY_ORDER_NO       --统一支付订单号
    ,UNIFY_PAY_FLOW_NUM       --统一支付流水号
    ,ETL_DT                   --数据日期
    ,SRC_TABLE_NAME           --源表名称
    ,JOB_CD                   --任务代码
    ,ETL_TIMESTAMP            --数据处理时间
    )
  SELECT 
     EVT_ID                   --事件编号
    ,LP_ID                    --法人编号
    ,BATCH_ID                 --批次编号
    ,BATCH_DT                 --批次日期
    ,REC_ID                   --记录编号
    ,CHN_DT                   --渠道日期
    ,CHN_SEQ_NUM              --渠道序号
    ,CONL_BK_TRAN_TYPE_CD     --企业网银交易类型代码
    ,DTL_ACCT_ID              --明细账户编号
    ,DTL_ACCT_NAME            --明细账户名称
    ,TRAN_AMT                 --交易金额
    ,TRAN_SUCS_AMT            --交易成功金额
    ,DEDUCT_MODE_CD           --扣款模式代码
    ,CORE_MEMO_CD             --核心摘要代码
    ,CORP_AGENT_ACCT          --对公代理账户
    ,CORE_TRAN_FLOW_NUM       --核心交易流水号
    ,CORE_TRAN_DT             --核心交易日期
    ,RESP_CODE                --响应码
    ,RESP_CODE_DESCB          --响应码描述
    ,CNTPTY_ACCT_BANK_NUM     --对手账户行号
    ,POSTSC                   --附言
    ,UNIFY_PAY_ORDER_NO       --统一支付订单号
    ,UNIFY_PAY_FLOW_NUM       --统一支付流水号
    ,ETL_DT                   --数据日期
    ,SRC_TABLE_NAME           --源表名称
    ,JOB_CD                   --任务代码
    ,ETL_TIMESTAMP            --数据处理时间
    FROM IML.V_EVT_CONL_BK_PAYOFF_DTL  --视图-企业网银代发明细
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_IML_EVT_CONL_BK_PAYOFF_DTL;
/

