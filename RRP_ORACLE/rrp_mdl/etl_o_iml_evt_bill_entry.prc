CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_BILL_ENTRY(I_P_DATE IN INTEGER,
                                                     O_ERRCODE OUT VARCHAR2
                                                     )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_BILL_ENTRY
  *  功能描述：票据记账事件
  *  创建日期：20230114
  *  开发人员：MW
  *  来源表： IML.V_EVT_BILL_ENTRY
  *  目标表： O_IML_EVT_BILL_ENTRY
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_BILL_ENTRY'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_EVT_BILL_ENTRY T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_BILL_ENTRY';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-票据记账事件';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_BILL_ENTRY
    (EVT_ID                 --事件编号
    ,LP_ID                  --法人编号
    ,ENTRY_BILL_ID          --记账票据编号
    ,HQ_ORG_ID              --总行机构编号
    ,TRAN_ORG_ID            --交易机构编号
    ,ENTRY_TRAN_NUM         --记账交易号
    ,PROD_ID                --产品编号
    ,CONT_ID                --合同编号
    ,AGT_ID                 --协议编号
    ,BUS_ID                 --业务编号
    ,BILL_ID                --票据编号
    ,BILL_NUM               --票据号码
    ,INT_ACCR_EXP_DT        --计息到期日期
    ,INT_ACCR_DAYS          --计息天数
    ,INTEREST               --利息
    ,FAC_VAL_AMT            --票面金额
    ,BUYER_PAY_INT_AMT      --买方付息金额
    ,ACTL_RECV_AMT          --实收金额
    ,ACTL_AMT               --贴现金额
    ,COMM_FEE               --手续费
    ,TODOS                  --工本费
    ,TRAN_FLOW_NUM          --交易流水号
    ,INTFC_RETURN_CODE      --接口返回码
    ,INTFC_RETURN_TYPE_CD   --接口返回类型代码
    ,ENTRY_STATUS_CD        --记账状态代码
    ,ENTRY_TM               --记账时间
    ,UPDATE_TM              --更新时间
    ,FINAL_MODIF_OPERR_ID   --最后修改操作员编号
    ,RGST_CTER_CCUTION_ID   --登记中心流转编号
    ,BANK_CORE_ENTRY_FLOW_NUM  --银行核心记账流水号
    ,FIN_ORG_ID             --财务机构编号
    ,BILL_SUB_INTRV_ID      --票据子区间号
    ,H_DATA_FLG             --历史数据标志
    ,ETL_DT                 --ETL处理日期
    ,SRC_TABLE_NAME         --源表名称
    ,JOB_CD                 --任务编码
    ,ETL_TIMESTAMP          --ETL处理时间戳
    )
  SELECT 
     EVT_ID                 --事件编号
    ,LP_ID                  --法人编号
    ,ENTRY_BILL_ID          --记账票据编号
    ,HQ_ORG_ID              --总行机构编号
    ,TRAN_ORG_ID            --交易机构编号
    ,ENTRY_TRAN_NUM         --记账交易号
    ,PROD_ID                --产品编号
    ,CONT_ID                --合同编号
    ,AGT_ID                 --协议编号
    ,BUS_ID                 --业务编号
    ,BILL_ID                --票据编号
    ,BILL_NUM               --票据号码
    ,INT_ACCR_EXP_DT        --计息到期日期
    ,INT_ACCR_DAYS          --计息天数
    ,INTEREST               --利息
    ,FAC_VAL_AMT            --票面金额
    ,BUYER_PAY_INT_AMT      --买方付息金额
    ,ACTL_RECV_AMT          --实收金额
    ,ACTL_AMT               --贴现金额
    ,COMM_FEE               --手续费
    ,TODOS                  --工本费
    ,TRAN_FLOW_NUM          --交易流水号
    ,INTFC_RETURN_CODE      --接口返回码
    ,INTFC_RETURN_TYPE_CD   --接口返回类型代码
    ,ENTRY_STATUS_CD        --记账状态代码
    ,ENTRY_TM               --记账时间
    ,UPDATE_TM              --更新时间
    ,FINAL_MODIF_OPERR_ID   --最后修改操作员编号
    ,RGST_CTER_CCUTION_ID   --登记中心流转编号
    ,BANK_CORE_ENTRY_FLOW_NUM  --银行核心记账流水号
    ,FIN_ORG_ID             --财务机构编号
    ,BILL_SUB_INTRV_ID      --票据子区间号
    ,H_DATA_FLG             --历史数据标志
    ,ETL_DT                 --ETL处理日期
    ,SRC_TABLE_NAME         --源表名称
    ,JOB_CD                 --任务编码
    ,ETL_TIMESTAMP          --ETL处理时间戳
    FROM IML.V_EVT_BILL_ENTRY  --视图-票据记账事件
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_BILL_ENTRY', '', O_ERRCODE);

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

END ETL_O_IML_EVT_BILL_ENTRY;
/

