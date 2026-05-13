CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_CRDT_LOAN_REPAY_FLOW(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：信贷贷款还款流水
  **存储过程名称：    ETL_O_IML_EVT_CRDT_LOAN_REPAY_FLOW
  **存储过程创建日期：20260413
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20260413    YJY        创建  
  *****************************************************************/
AS
  --定义变量
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_EVT_CRDT_LOAN_REPAY_FLOW'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  --支持重跑
  V_STEP      := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_CRDT_LOAN_REPAY_FLOW';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-信贷贷款还款流水';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_CRDT_LOAN_REPAY_FLOW NOLOGGING 
    (EVT_ID                  --事件编号
     ,LP_ID                  --法人编号
     ,REPAY_FLOW_NUM         --还款流水号
     ,DUBIL_ID               --借据编号
     ,TRAN_DT                --交易日期
     ,CUST_ID                --客户编号
     ,CUST_NAME              --客户名称
     ,CERT_TYPE_CD           --证件类型代码
     ,CERT_ID                --证件编号
     ,CURR_CD                --币种代码
     ,DEDUCT_ACCT_NUM        --扣款账户编号
     ,REPAY_TRAN_FLOW_NUM    --还款交易流水号
     ,REPAY_TYPE_CD          --还款类型代码
     ,RPBL_AMT               --应还金额
     ,ACTL_REPAY_AMT         --实际还款金额
     ,PAID_PRIC              --实还本金
     ,PAID_INT               --实还利息
     ,PAID_PNLT              --实还罚息
     ,PAID_COMP_INT          --实还复利
     ,SURP_PRIC              --剩余本金
     ,REPAY_PERDS            --还款期数
     ,REVS_FLG               --冲正标志
     ,HAPP_RS_CD             --发生原因代码
     ,CALLBK_ID              --回收编号
     ,CORE_FLOW_NUM          --核心流水号
     ,CHN_ID                 --渠道编号
     ,INIT_SYS_ID            --发起系统编号
     ,REMARK                 --备注
     ,RGST_TELLER_ID         --登记柜员编号
     ,RGST_ORG_ID            --登记机构编号
     ,RGST_DT                --登记日期
     ,FINAL_UPDATE_TELLER_ID --最后更新柜员编号
     ,FINAL_UPDATE_ORG_ID    --最后更新机构编号
     ,FINAL_UPDATE_DT        --最后更新日期
     ,START_DT               --开始时间
     ,END_DT                 --结束时间
     ,ID_MARK                --增删标志
     ,SRC_TABLE_NAME         --源表名称
     ,JOB_CD                 --任务编码
     ,ETL_TIMESTAMP          --ETL处理时间戳
    )
  SELECT 
      EVT_ID                  --事件编号
     ,LP_ID                  --法人编号
     ,REPAY_FLOW_NUM         --还款流水号
     ,DUBIL_ID               --借据编号
     ,TRAN_DT                --交易日期
     ,CUST_ID                --客户编号
     ,CUST_NAME              --客户名称
     ,CERT_TYPE_CD           --证件类型代码
     ,CERT_ID                --证件编号
     ,CURR_CD                --币种代码
     ,DEDUCT_ACCT_NUM        --扣款账户编号
     ,REPAY_TRAN_FLOW_NUM    --还款交易流水号
     ,REPAY_TYPE_CD          --还款类型代码
     ,RPBL_AMT               --应还金额
     ,ACTL_REPAY_AMT         --实际还款金额
     ,PAID_PRIC              --实还本金
     ,PAID_INT               --实还利息
     ,PAID_PNLT              --实还罚息
     ,PAID_COMP_INT          --实还复利
     ,SURP_PRIC              --剩余本金
     ,REPAY_PERDS            --还款期数
     ,REVS_FLG               --冲正标志
     ,HAPP_RS_CD             --发生原因代码
     ,CALLBK_ID              --回收编号
     ,CORE_FLOW_NUM          --核心流水号
     ,CHN_ID                 --渠道编号
     ,INIT_SYS_ID            --发起系统编号
     ,REMARK                 --备注
     ,RGST_TELLER_ID         --登记柜员编号
     ,RGST_ORG_ID            --登记机构编号
     ,RGST_DT                --登记日期
     ,FINAL_UPDATE_TELLER_ID --最后更新柜员编号
     ,FINAL_UPDATE_ORG_ID    --最后更新机构编号
     ,FINAL_UPDATE_DT        --最后更新日期
     ,START_DT               --开始时间
     ,END_DT                 --结束时间
     ,ID_MARK                --增删标志
     ,SRC_TABLE_NAME         --源表名称
     ,JOB_CD                 --任务编码
     ,ETL_TIMESTAMP          --ETL处理时间戳
    FROM IML.V_EVT_CRDT_LOAN_REPAY_FLOW --视图-信贷贷款还款流水
   WHERE ID_MARK <> 'D'
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_CRDT_LOAN_REPAY_FLOW', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_EVT_CRDT_LOAN_REPAY_FLOW;
/

