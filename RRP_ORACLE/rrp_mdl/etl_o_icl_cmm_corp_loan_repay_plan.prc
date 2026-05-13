CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_CORP_LOAN_REPAY_PLAN(I_P_DATE IN INTEGER,
                                                               O_ERRCODE OUT VARCHAR2
                                                               )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_CORP_LOAN_REPAY_PLAN
  *  功能描述：对公贷款还款计划
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_CORP_LOAN_REPAY_PLAN
  *  目标表： O_ICL_CMM_CORP_LOAN_REPAY_PLAN
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20220615  hulj      修改参数
  *             3    20231107  hulj      新增期次历史逾期标志,优化O层 
  *             4    20251202  YJY       新增本期单据余额
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_CORP_LOAN_REPAY_PLAN'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_PLAN T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_PLAN';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-对公贷款还款计划';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_CORP_LOAN_REPAY_PLAN
    (ETL_DT                   --数据日期
    ,LP_ID                    --法人编号
    ,DUBIL_ID                 --借据编号
    ,ACCT_ID                  --账户编号
    ,CUST_ID                  --客户编号
    ,TOT_PERDS                --总期数
    ,REPAY_PERDS              --还款期数
    ,REPAY_SUB_PERDS          --还款子期数
    ,VALUE_DT                 --起息日期
    ,REPAYBL_DT               --应还款日期
    ,EXEC_STATUS_FLG          --执行状态标志
    ,OVDUE_FLG                --逾期标志
    ,IRR_REPAY_PLAN_FLG       --不规则还款计划标志
    ,REPAY_FLG                --偿还标志
    ,IS_INT_SET_FLG           --是否结息标志
    ,REPAY_CATE_CD            --还款类别代码
    ,REPAY_WAY_CD             --还款方式代码
    ,CURR_CD                  --币种代码
    ,EXEC_INT_RAT             --执行利率
    ,ACRU_NOMAL_PRIC          --应计正常本金
    ,CURR_ISSUE_RECVBL_PRIC   --本期应收本金
    ,CURR_ISSUE_INT_RECVBL    --本期应收利息
    ,CURR_ISSUE_RECVBL_FEE    --本期应收费用
    ,CURR_ISSUE_INT_SUB_AMT   --本期贴息金额
    ,PAYOFF_DT                --结清日期
    ,CURR_ISSUE_PRIC_OVDUE_DT --本期本金逾期日期
    ,CURR_ISSUE_INT_OVDUE_DT  --本期利息逾期日期
    ,CURR_ISSUE_OVDUE_DAYS    --本期逾期天数
    ,CURR_ISSUE_OVDUE_PRIC    --本期逾期本金
    ,CURR_ISSUE_OVDUE_INT     --本期逾期利息
    ,CURR_ISSUE_OVDUE_COMP_INT  --本期逾期复利
    ,CURR_ISSUE_OVER_INT_BAL  --本期欠息余额
    ,CURR_ISSUE_PNLT_BAL      --本期罚息余额
    ,CURR_ISSUE_IDLE_BAL      --本期呆滞余额
    ,CURR_ISSUE_BAD_DEBT_BAL  --本期呆账余额
    ,INT_OVDUE_DAYS           --利息逾期天数
    ,PRIC_BAL                 --本金余额
    ,CURR_ISSUE_RECVBL_AMT    --本期应收金额
    ,JOB_CD                   --任务代码
    ,REPAY_AMT_TYPE_CD        --还款金额类型代码
    ,PD_H_OVDUE_FLG           --期次历史逾期标志
    ,CURR_DOC_BAL             --本期单据余额   --ADD BY YJY 20251202
    )
  SELECT 
     ETL_DT                   --数据日期
    ,LP_ID                    --法人编号
    ,DUBIL_ID                 --借据编号
    ,ACCT_ID                  --账户编号
    ,CUST_ID                  --客户编号
    ,TOT_PERDS                --总期数
    ,REPAY_PERDS              --还款期数
    ,REPAY_SUB_PERDS          --还款子期数
    ,VALUE_DT                 --起息日期
    ,REPAYBL_DT               --应还款日期
    ,EXEC_STATUS_FLG          --执行状态标志
    ,OVDUE_FLG                --逾期标志
    ,IRR_REPAY_PLAN_FLG       --不规则还款计划标志
    ,REPAY_FLG                --偿还标志
    ,IS_INT_SET_FLG           --是否结息标志
    ,REPAY_CATE_CD            --还款类别代码
    ,REPAY_WAY_CD             --还款方式代码
    ,CURR_CD                  --币种代码
    ,EXEC_INT_RAT             --执行利率
    ,ACRU_NOMAL_PRIC          --应计正常本金
    ,CURR_ISSUE_RECVBL_PRIC   --本期应收本金
    ,CURR_ISSUE_INT_RECVBL    --本期应收利息
    ,CURR_ISSUE_RECVBL_FEE    --本期应收费用
    ,CURR_ISSUE_INT_SUB_AMT   --本期贴息金额
    ,PAYOFF_DT                --结清日期
    ,CURR_ISSUE_PRIC_OVDUE_DT --本期本金逾期日期
    ,CURR_ISSUE_INT_OVDUE_DT  --本期利息逾期日期
    ,CURR_ISSUE_OVDUE_DAYS    --本期逾期天数
    ,CURR_ISSUE_OVDUE_PRIC    --本期逾期本金
    ,CURR_ISSUE_OVDUE_INT     --本期逾期利息
    ,CURR_ISSUE_OVDUE_COMP_INT  --本期逾期复利
    ,CURR_ISSUE_OVER_INT_BAL  --本期欠息余额
    ,CURR_ISSUE_PNLT_BAL      --本期罚息余额
    ,CURR_ISSUE_IDLE_BAL      --本期呆滞余额
    ,CURR_ISSUE_BAD_DEBT_BAL  --本期呆账余额
    ,INT_OVDUE_DAYS           --利息逾期天数
    ,PRIC_BAL                 --本金余额
    ,CURR_ISSUE_RECVBL_AMT    --本期应收金额
    ,JOB_CD                   --任务代码
    ,REPAY_AMT_TYPE_CD        --还款金额类型代码
    ,PD_H_OVDUE_FLG           --期次历史逾期标志
    ,CURR_DOC_BAL             --本期单据余额   --ADD BY YJY 20251202
    FROM ICL.V_CMM_CORP_LOAN_REPAY_PLAN  --视图-对公贷款还款计划
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_CORP_LOAN_REPAY_PLAN','', O_ERRCODE);

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

END ETL_O_ICL_CMM_CORP_LOAN_REPAY_PLAN;
/

