CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_DEP_ACCT_TRAN_DTL_ATTACH_INFO(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_DEP_ACCT_TRAN_DTL_ATTACH_INFO
  *  功能描述：存款账户交易明细补充信息
  *  创建日期：20260112
  *  开发人员：YJY
  *  来源表： ICL.V_CMM_DEP_ACCT_TRAN_DTL_ATTACH_INFO
  *  目标表： O_ICL_CMM_DEP_ACCT_TRAN_DTL_ATTACH_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20260112  YJY     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                --处理步骤
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);               --任务名称
  V_PART_NAME VARCHAR2(200);               --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_ICL_CMM_DEP_ACCT_TRAN_DTL_ATTACH_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_DEP_ACCT_TRAN_DTL_ATTACH_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-存款账户交易明细补充信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_DEP_ACCT_TRAN_DTL_ATTACH_INFO
  (   
       ETL_DT                    --数据日期
      ,LP_ID                     --法人编号
      ,TRAN_FLOW_NUM             --交易流水号
      ,TRAN_DT                   --交易日期
      ,TRAN_TIMESTAMP            --交易时间戳
      ,ACCT_BILL_FLOW_NUM        --账单流水号
      ,OVA_FLOW_NUM              --全局流水号
      ,SRC_TRAN_FLOW_NUM         --源交易流水号
      ,SRC_SEQ_NO                --源交易序号
      ,CUST_ID                   --客户编号
      ,CUST_NAME                 --客户名称
      ,DEP_SUB_ACCT_ID           --存款分户编号
      ,CUST_ACCT_ID              --客户账户编号
      ,SUB_ACCT_ID               --子户编号
      ,TRAN_MEMO_DESCB           --交易摘要描述
      ,TRAN_KIND_CD              --交易类型代码
      ,DEBIT_CRDT_DIR_CD         --借贷方向代码
      ,TRAN_ORG_ID               --交易机构编号
      ,CNTPTY_ACCT_ID            --交易对手账户编号
      ,CNTPTY_ACCT_NAME          --交易对手账户名称
      ,CNTPTY_ACCT_OPEN_BANK_CD  --交易对手账户开户行代码
      ,CNTPTY_OPEN_BANK_NAME     --交易对手账户开户行名称
      ,CNTPTY_SUBJ_ID            --交易对手科目编号
      ,CNTPTY_SUBJ_NAME          --交易对手科目名称
      ,TRAN_CURR_CD              --交易币种代码
      ,TRAN_AMT                  --交易金额
      ,LEV_TAX_REBATE_TRAN_FLG   --离境退税交易标志
      ,SRC_SYS_ID                --系统来源标识
      ,TRAN_REMARK               --
      ,JOB_CD                    --任务代码
      ,ETL_TIMESTAMP             --数据处理时间
   )
  SELECT 
       ETL_DT                    --数据日期
      ,LP_ID                     --法人编号
      ,TRAN_FLOW_NUM             --交易流水号
      ,TRAN_DT                   --交易日期
      ,TRAN_TIMESTAMP            --交易时间戳
      ,ACCT_BILL_FLOW_NUM        --账单流水号
      ,OVA_FLOW_NUM              --全局流水号
      ,SRC_TRAN_FLOW_NUM         --源交易流水号
      ,SRC_SEQ_NO                --源交易序号
      ,CUST_ID                   --客户编号
      ,CUST_NAME                 --客户名称
      ,DEP_SUB_ACCT_ID           --存款分户编号
      ,CUST_ACCT_ID              --客户账户编号
      ,SUB_ACCT_ID               --子户编号
      ,TRAN_MEMO_DESCB           --交易摘要描述
      ,TRAN_KIND_CD              --交易类型代码
      ,DEBIT_CRDT_DIR_CD         --借贷方向代码
      ,TRAN_ORG_ID               --交易机构编号
      ,CNTPTY_ACCT_ID            --交易对手账户编号
      ,CNTPTY_ACCT_NAME          --交易对手账户名称
      ,CNTPTY_ACCT_OPEN_BANK_CD  --交易对手账户开户行代码
      ,CNTPTY_OPEN_BANK_NAME     --交易对手账户开户行名称
      ,CNTPTY_SUBJ_ID            --交易对手科目编号
      ,CNTPTY_SUBJ_NAME          --交易对手科目名称
      ,TRAN_CURR_CD              --交易币种代码
      ,TRAN_AMT                  --交易金额
      ,LEV_TAX_REBATE_TRAN_FLG   --离境退税交易标志
      ,SRC_SYS_ID                --系统来源标识
      ,TRAN_REMARK               --
      ,JOB_CD                    --任务代码
      ,ETL_TIMESTAMP             --数据处理时间
    FROM ICL.V_CMM_DEP_ACCT_TRAN_DTL_ATTACH_INFO --视图-存款账户交易明细补充信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_ICL_CMM_DEP_ACCT_TRAN_DTL_ATTACH_INFO;
/

