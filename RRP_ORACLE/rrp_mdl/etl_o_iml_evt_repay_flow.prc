CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_REPAY_FLOW(I_P_DATE IN INTEGER, --跑批日期
                                                     O_ERRCODE OUT VARCHAR2 --错误代码
                                                     )
 /*******************************************************************
  **存储过程详细说明： 还款流水表
  **存储过程名称：    ETL_O_IML_EVT_REPAY_FLOW
  **存储过程创建日期：20221129
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20260104    YJY        该表从20260109开始由增量流水改为全量流水，修改限制条件，用BUS_TRAN_DT业务交易日期做增量条件
  ******************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(100) := 'O_IML_EVT_REPAY_FLOW'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_REPAY_FLOW'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_REPAY_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-还款流水表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_REPAY_FLOW NOLOGGING
    (EVT_ID                                 --事件编号
    ,CALLBK_ID                              --回收编号
    ,LP_ID                                  --法人编号
    ,LOAN_NUM                               --贷款号
    ,CUST_ID                                --客户编号
    ,LOAN_REPAY_DT                          --贷款还款日期
    ,LOAN_REPAY_TYPE_CD                     --贷款还款类型代码
    ,PAY_CUST_ID                            --付款客户编号
    ,CURR_CD                                --币种代码
    ,CNY_EXCH_RAT                           --对人民币汇率
    ,EXCH_WAY_CD                            --汇兑方式代码
    ,CALLBK_PRIC                            --回收金额
    ,BUS_TRAN_DT                            --业务交易日期
    ,CALLBK_PROD_WAY_CD                     --回收产生方式代码
    ,TRAN_REF_NO                            --交易参考号
    ,TRAN_ORG_ID                            --交易机构编号
    ,REPAY_PLAN_MODIF_WAY_CD                --还款计划变更方式代码
    ,ADV_REPAY_FEE_AMT                      --提前还款费用金额
    ,ADV_REPAY_PRIC_AMT                     --提前还款本金金额
    ,LOAN_RS_CD                             --贷款原因代码
    ,TRAN_MEMO_DESCB                        --交易摘要描述
    ,TRAN_STL_FLG                           --交易结算标志
    ,TRAN_STL_DT                            --交易结算日期
    ,ACCT_ALDY_CHECK_FLG                    --账户已复核标志
    ,ACCT_CHECK_DT                          --账户复核日期
    ,REVS_FLG                               --冲正标志
    ,TRAN_REVS_RS_DESCB                     --交易冲正原因描述
    ,SELLOUT_FLG                            --卖断式标志
    ,EVT_CATE_ID                            --事件类别编号
    ,TRAN_CD                                --交易码
    ,ADV_BF_REPAY_REPAY_PLAN_MODIF_WAY_CD   --提前还款前还款计划变更方式代码
    ,ADV_BF_REPAY_EXP_DT                    --提前还款前到期日期
    ,NOMAL_REPAY_EH_ISSUE_REPAY_AMT         --正常还款每期还款金额
    ,STL_TELLER_ID                          --结算柜员编号
    ,ACCT_APV_TELLER_ID                     --账户审批柜员编号
    ,BA_AUTH_TELLER_ID                      --银承授权柜员编号
    ,TRAN_TELLER_ID                         --交易柜员编号
    ,FINAL_MODIF_DT                         --最后修改日期
    ,TRAN_TM                                --交易时间
    ,REPAY_RSTRCT_CD                        --还款约束代码
    ,CHECK_ENTRY_CODE                       --对账编码
    ,ETL_DT                                 --数据日期
    ,SRC_TABLE_NAME                         --源表名称
    ,JOB_CD                                 --任务代码
    ,ETL_TIMESTAMP                          --数据处理时间
    ,CALLBK_RS                              --回收原因
    )
  SELECT /*+PARALLEL*/
         EVT_ID                                 --事件编号
        ,CALLBK_ID                              --回收编号
        ,LP_ID                                  --法人编号
        ,LOAN_NUM                               --贷款号
        ,CUST_ID                                --客户编号
        ,LOAN_REPAY_DT                          --贷款还款日期
        ,LOAN_REPAY_TYPE_CD                     --贷款还款类型代码
        ,PAY_CUST_ID                            --付款客户编号
        ,CURR_CD                                --币种代码
        ,CNY_EXCH_RAT                           --对人民币汇率
        ,EXCH_WAY_CD                            --汇兑方式代码
        ,CALLBK_PRIC                            --回收金额
        ,BUS_TRAN_DT                            --业务交易日期
        ,CALLBK_PROD_WAY_CD                     --回收产生方式代码
        ,TRAN_REF_NO                            --交易参考号
        ,TRAN_ORG_ID                            --交易机构编号
        ,REPAY_PLAN_MODIF_WAY_CD                --还款计划变更方式代码
        ,ADV_REPAY_FEE_AMT                      --提前还款费用金额
        ,ADV_REPAY_PRIC_AMT                     --提前还款本金金额
        ,LOAN_RS_CD                             --贷款原因代码
        ,TRAN_MEMO_DESCB                        --交易摘要描述
        ,TRAN_STL_FLG                           --交易结算标志
        ,TRAN_STL_DT                            --交易结算日期
        ,ACCT_ALDY_CHECK_FLG                    --账户已复核标志
        ,ACCT_CHECK_DT                          --账户复核日期
        ,REVS_FLG                               --冲正标志
        ,TRAN_REVS_RS_DESCB                     --交易冲正原因描述
        ,SELLOUT_FLG                            --卖断式标志
        ,EVT_CATE_ID                            --事件类别编号
        ,TRAN_CD                                --交易码
        ,ADV_BF_REPAY_REPAY_PLAN_MODIF_WAY_CD   --提前还款前还款计划变更方式代码
        ,ADV_BF_REPAY_EXP_DT                    --提前还款前到期日期
        ,NOMAL_REPAY_EH_ISSUE_REPAY_AMT         --正常还款每期还款金额
        ,STL_TELLER_ID                          --结算柜员编号
        ,ACCT_APV_TELLER_ID                     --账户审批柜员编号
        ,BA_AUTH_TELLER_ID                      --银承授权柜员编号
        ,TRAN_TELLER_ID                         --交易柜员编号
        ,FINAL_MODIF_DT                         --最后修改日期
        ,TRAN_TM                                --交易时间
        ,REPAY_RSTRCT_CD                        --还款约束代码
        ,CHECK_ENTRY_CODE                       --对账编码
        ,ETL_DT                                 --数据日期
        ,SRC_TABLE_NAME                         --源表名称
        ,JOB_CD                                 --任务代码
        ,ETL_TIMESTAMP                          --数据处理时间
        ,CALLBK_RS                              --回收原因
    FROM IML.V_EVT_REPAY_FLOW   --还款流水表视图
   WHERE BUS_TRAN_DT = TO_DATE(V_P_DATE,'YYYYMMDD')    
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD'); --MOD BY YJY 20260104 

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
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
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

END ETL_O_IML_EVT_REPAY_FLOW;
/

