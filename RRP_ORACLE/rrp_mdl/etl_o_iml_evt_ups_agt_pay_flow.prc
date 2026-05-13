CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_UPS_AGT_PAY_FLOW(I_P_DATE IN INTEGER,
                                                           O_ERRCODE OUT VARCHAR2
                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_UPS_AGT_PAY_FLOW
  *  功能描述：银联协议支付流水
  *  创建日期：20231031
  *  开发人员：hulj
  *  来源表： IML.V_EVT_UPS_AGT_PAY_FLOW
  *  目标表： O_IML_EVT_UPS_AGT_PAY_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20231031  hulj     首次创建
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
  V_PART_NAME VARCHAR2(200);              --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_UPS_AGT_PAY_FLOW'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_UPS_AGT_PAY_FLOW'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-银联协议支付流水';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_UPS_AGT_PAY_FLOW
    (EVT_ID --事件编号
    ,LP_ID --法人编号
    ,BATCH_NO --批次号
    ,TRAN_FLOW_NUM --交易流水号
    ,BUS_KIND_ID --业务种类编号
    ,TRAN_TYPE_CD --交易类型代码
    ,TRAN_CURR_CD --交易币种代码
    ,TRAN_AMT --交易金额
    ,TRAN_TM --交易时间
    ,ALDY_REFUND_AMT --已退款金额
    ,ALDY_REFUND_CNT --已退款次数
    ,TRAN_STATUS_CD --交易状态代码
    ,ACPT_PAY_INSTR_CD --收付款指令代码
    ,EXC_RESV_BANK_ACCT_ID --备付金银行账户编号
    ,EXC_RESV_BANK_ACCT_NAME --备付金银行账户名称
    ,PAYER_ACCT_ORG_ID --付款方账户所属机构编号
    ,PAYER_ACCT_TYPE_CD --付款方账户类型代码
    ,PAYER_ACCT_ID --付款方账户编号
    ,PAYER_ACCT_NAME --付款方账户名称
    ,PAYER_RSRV_MOBILE_NO --付款方预留手机号
    ,SEND_ORG_ID --发送机构编号
    ,RECVER_ACCT_ORG_ID --收款方账户所属机构编号
    ,RECVER_ACCT_ID --收款方账户编号
    ,RECVER_ACCT_NAME --收款方账户名称
    ,RECVER_ACCT_TYPE_CD --收款方账户类型代码
    ,SIGN_AGT_ID --签约协议编号
    ,MERCHT_ID --商户编号
    ,MERCHT_CATE_CD --商户类别代码
    ,MERCHT_NAME --商户名称
    ,LEVEL2_MERCHT_ID --二级商户编号
    ,LEVEL2_MERCHT_CATE_CD --二级商户类别代码
    ,LEVEL2_MERCHT_NAME --二级商户名称
    ,SYS_FLOW_NUM --系统流水号
    ,SYS_TYPE_CD --系统类型代码
    ,SYS_TRAN_DT --系统交易日期
    ,SYS_RETURN_CODE --系统返回码
    ,SYS_RETURN_COMNT --系统返回说明
    ,CORE_FLOW_NUM --核心流水号
    ,CORE_TRAN_DT --核心交易日期
    ,CORE_TRAN_STATUS_CD --核心交易状态代码
    ,ALDY_TRAN_FLG --已转移标志
    ,ALDY_ADJ_ENTRY_FLG --已调账标志
    ,ALDY_CLEAR_FLG --已清算标志
    ,CHECK_ENTRY_STATUS_CD --对账状态代码
    ,CLEAR_BATCH_NO --清算批次号
    ,CLEAR_DT --清算日期
    ,INDENT_ID --订单编号
    ,INDENT_DESCB --订单描述
    ,PLAT_TRAN_FLOW_NUM --平台交易流水号
    ,PLAT_TRAN_DT --平台交易日期
    ,PLAT_TRAN_TM --平台交易时间
    ,OUT_PLAT_FLOW_NUM --外联平台流水号
    ,OUT_OVA_PLAT_FLOW_NUM --外联全局平台流水号
    ,OPEN_ACCT_ORG_ID --开户机构编号
    ,TELLER_ID --柜员编号
    ,CREATE_TM --创建时间
    ,FINAL_UPDATE_TM --最后更新时间
    ,ETL_DT --数据日期
    ,SRC_TABLE_NAME --源表名称
    ,JOB_CD --任务代码
    )
  SELECT EVT_ID --事件编号
        ,LP_ID --法人编号
        ,BATCH_NO --批次号
        ,TRAN_FLOW_NUM --交易流水号
        ,BUS_KIND_ID --业务种类编号
        ,TRAN_TYPE_CD --交易类型代码
        ,TRAN_CURR_CD --交易币种代码
        ,TRAN_AMT --交易金额
        ,TRAN_TM --交易时间
        ,ALDY_REFUND_AMT --已退款金额
        ,ALDY_REFUND_CNT --已退款次数
        ,TRAN_STATUS_CD --交易状态代码
        ,ACPT_PAY_INSTR_CD --收付款指令代码
        ,EXC_RESV_BANK_ACCT_ID --备付金银行账户编号
        ,EXC_RESV_BANK_ACCT_NAME --备付金银行账户名称
        ,PAYER_ACCT_ORG_ID --付款方账户所属机构编号
        ,PAYER_ACCT_TYPE_CD --付款方账户类型代码
        ,PAYER_ACCT_ID --付款方账户编号
        ,PAYER_ACCT_NAME --付款方账户名称
        ,PAYER_RSRV_MOBILE_NO --付款方预留手机号
        ,SEND_ORG_ID --发送机构编号
        ,RECVER_ACCT_ORG_ID --收款方账户所属机构编号
        ,RECVER_ACCT_ID --收款方账户编号
        ,RECVER_ACCT_NAME --收款方账户名称
        ,RECVER_ACCT_TYPE_CD --收款方账户类型代码
        ,SIGN_AGT_ID --签约协议编号
        ,MERCHT_ID --商户编号
        ,MERCHT_CATE_CD --商户类别代码
        ,MERCHT_NAME --商户名称
        ,LEVEL2_MERCHT_ID --二级商户编号
        ,LEVEL2_MERCHT_CATE_CD --二级商户类别代码
        ,LEVEL2_MERCHT_NAME --二级商户名称
        ,SYS_FLOW_NUM --系统流水号
        ,SYS_TYPE_CD --系统类型代码
        ,SYS_TRAN_DT --系统交易日期
        ,SYS_RETURN_CODE --系统返回码
        ,SYS_RETURN_COMNT --系统返回说明
        ,CORE_FLOW_NUM --核心流水号
        ,CORE_TRAN_DT --核心交易日期
        ,CORE_TRAN_STATUS_CD --核心交易状态代码
        ,ALDY_TRAN_FLG --已转移标志
        ,ALDY_ADJ_ENTRY_FLG --已调账标志
        ,ALDY_CLEAR_FLG --已清算标志
        ,CHECK_ENTRY_STATUS_CD --对账状态代码
        ,CLEAR_BATCH_NO --清算批次号
        ,CLEAR_DT --清算日期
        ,INDENT_ID --订单编号
        ,INDENT_DESCB --订单描述
        ,PLAT_TRAN_FLOW_NUM --平台交易流水号
        ,PLAT_TRAN_DT --平台交易日期
        ,PLAT_TRAN_TM --平台交易时间
        ,OUT_PLAT_FLOW_NUM --外联平台流水号
        ,OUT_OVA_PLAT_FLOW_NUM --外联全局平台流水号
        ,OPEN_ACCT_ORG_ID --开户机构编号
        ,TELLER_ID --柜员编号
        ,CREATE_TM --创建时间
        ,FINAL_UPDATE_TM --最后更新时间
        ,ETL_DT --数据日期
        ,SRC_TABLE_NAME --源表名称
        ,JOB_CD --任务代码
    FROM IML.V_EVT_UPS_AGT_PAY_FLOW  --视图-银联协议支付流水
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 如需要分析表，请用如下代码 --
  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_EVT_UPS_AGT_PAY_FLOW;
/

