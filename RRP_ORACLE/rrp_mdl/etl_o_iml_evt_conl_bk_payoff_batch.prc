CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_CONL_BK_PAYOFF_BATCH(I_P_DATE IN INTEGER,
                                                               O_ERRCODE OUT VARCHAR2
                                                               )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_CONL_BK_PAYOFF_BATCH
  *  功能描述：企业网银代发批次
  *  创建日期：20221227
  *  开发人员：梅炜
  *  来源表： IML.V_EVT_CONL_BK_PAYOFF_BATCH
  *  目标表： O_IML_EVT_CONL_BK_PAYOFF_BATCH
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_CONL_BK_PAYOFF_BATCH'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_EVT_CONL_BK_PAYOFF_BATCH T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_CONL_BK_PAYOFF_BATCH';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-企业网银代发批次';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_CONL_BK_PAYOFF_BATCH
    (EVT_ID                    --事件编号
    ,LP_ID                     --法人编号
    ,CHN_ID                    --渠道编号
    ,BATCH_ID                  --批次编号
    ,BATCH_DT                  --批次日期
    ,PAYOFF_KIND_CD            --代发种类代码
    ,CHN_DT                    --渠道日期
    ,CHN_SEQ_NUM               --渠道序号
    ,BATCH_DOC_ID              --批量文件编号
    ,CUST_ID                   --客户编号
    ,TRAN_OUT_ACCT_ID          --转出账户编号
    ,TRAN_OUT_ACCT_NAME        --转出账户名称
    ,CURR_CD                   --币种代码
    ,TOT_QTTY                  --总数量
    ,SUCS_TOT_QTTY             --成功总数量
    ,FAIL_TOT_QTTY             --失败总数量
    ,TOT_AMT                   --总金额
    ,SUCS_TOT_AMT              --成功总金额
    ,FAIL_TOT_AMT              --失败总金额
    ,TRAN_TM                   --交易时间
    ,NEED_ACCT_TRAN_FLG        --需要账户过渡标志
    ,TRAN_ACCT_ID              --过渡账户编号
    ,TRAN_ACCT_NAME            --过渡账户名称
    ,POSTSC                    --附言
    ,FLOW_STATUS_CD            --流程状态代码
    ,ERR_INFO_DESC             --错误信息描述
    ,CNTPTY_ACCT_BANK_OUT_FLG  --对手账户行外标志
    ,CORP_ACCT_BANK_OUT_FLG    --对公账户行外标志
    ,TRAN_INSIDE_ACCT_ACCT_NUM --过渡内部户账号
    ,TRAN_INSIDE_ACCT_NAME     --过渡内部户名称
    ,CORE_PRPERY_FLOW_NUM      --核心外围流水号
    ,CORE_FLOW_NUM             --核心流水号
    ,CORE_ENTRY_DT             --核心记账日期
    ,SIGN_ORG_ID               --签约机构编号
    ,TRAN_TELLER_ID            --交易柜员编号
    ,ETL_DT                    --数据日期
    ,SRC_TABLE_NAME            --源表名称
    ,JOB_CD                    --任务代码
    ,ETL_TIMESTAMP             --数据处理时间
    )
  SELECT 
     EVT_ID                    --事件编号
    ,LP_ID                     --法人编号
    ,CHN_ID                    --渠道编号
    ,BATCH_ID                  --批次编号
    ,BATCH_DT                  --批次日期
    ,PAYOFF_KIND_CD            --代发种类代码
    ,CHN_DT                    --渠道日期
    ,CHN_SEQ_NUM               --渠道序号
    ,BATCH_DOC_ID              --批量文件编号
    ,CUST_ID                   --客户编号
    ,TRAN_OUT_ACCT_ID          --转出账户编号
    ,TRAN_OUT_ACCT_NAME        --转出账户名称
    ,CURR_CD                   --币种代码
    ,TOT_QTTY                  --总数量
    ,SUCS_TOT_QTTY             --成功总数量
    ,FAIL_TOT_QTTY             --失败总数量
    ,TOT_AMT                   --总金额
    ,SUCS_TOT_AMT              --成功总金额
    ,FAIL_TOT_AMT              --失败总金额
    ,TRAN_TM                   --交易时间
    ,NEED_ACCT_TRAN_FLG        --需要账户过渡标志
    ,TRAN_ACCT_ID              --过渡账户编号
    ,TRAN_ACCT_NAME            --过渡账户名称
    ,POSTSC                    --附言
    ,FLOW_STATUS_CD            --流程状态代码
    ,ERR_INFO_DESC             --错误信息描述
    ,CNTPTY_ACCT_BANK_OUT_FLG  --对手账户行外标志
    ,CORP_ACCT_BANK_OUT_FLG    --对公账户行外标志
    ,TRAN_INSIDE_ACCT_ACCT_NUM --过渡内部户账号
    ,TRAN_INSIDE_ACCT_NAME     --过渡内部户名称
    ,CORE_PRPERY_FLOW_NUM      --核心外围流水号
    ,CORE_FLOW_NUM             --核心流水号
    ,CORE_ENTRY_DT             --核心记账日期
    ,SIGN_ORG_ID               --签约机构编号
    ,TRAN_TELLER_ID            --交易柜员编号
    ,ETL_DT                    --数据日期
    ,SRC_TABLE_NAME            --源表名称
    ,JOB_CD                    --任务代码
    ,ETL_TIMESTAMP             --数据处理时间
    FROM IML.V_EVT_CONL_BK_PAYOFF_BATCH  --视图-企业网银代发批次
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
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_CONL_BK_PAYOFF_BATCH','', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  -- 程序跑批结束记录 --
  V_STEP := 4;
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

END ETL_O_IML_EVT_CONL_BK_PAYOFF_BATCH;
/

