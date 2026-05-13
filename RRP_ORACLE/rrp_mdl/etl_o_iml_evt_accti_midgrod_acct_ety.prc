CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_ACCTI_MIDGROD_ACCT_ETY(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_ACCTI_MIDGROD_ACCT_ETY
  *  功能描述：核算中台会计分录事件
  *  创建日期：20251105
  *  开发人员：YJY
  *  来源表： IML.V_EVT_ACCTI_MIDGROD_ACCT_ETY
  *  目标表： O_IML_EVT_ACCTI_MIDGROD_ACCT_ETY
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251105  YJY     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_ACCTI_MIDGROD_ACCT_ETY'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_ACCTI_MIDGROD_ACCT_ETY'; --程序名称
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
  V_STEP_DESC := '数据落地-核算中台会计分录事件';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_ACCTI_MIDGROD_ACCT_ETY
  (   
       EVT_ID                  --事件编号
      ,SOB_ID                  --账套编号
      ,BUS_SYS_ID              --业务系统编号
      ,TRAN_DT                 --交易日期
      ,TRAN_FLOW_NUM           --交易流水号
      ,SUMOS_SEQ_NUM           --传票序号
      ,SUMOS_ID                --传票编号
      ,TRAN_ORG_ID             --交易机构编号
      ,FIN_ORG_ID              --财务机构编号
      ,SUBJ_ID                 --科目编号
      ,SUBJ_NAME               --科目名称
      ,BATCH_NO                --批次号
      ,TRAN_TM                 --交易时间
      ,CURR_CD                 --币种代码
      ,OFF_BS_FLG              --表外标志
      ,CUST_ID                 --客户编号
      ,PROD_ID                 --产品编号
      ,ACCT_ID                 --账户编号
      ,CASH_TRANS_FLG_CD       --现转标志代码
      ,DEBIT_CRDT_DIR_CD       --借贷方向代码
      ,TRAN_AMT                --交易金额
      ,TRAN_BAL                --交易余额
      ,MEMO_ID                 --摘要编号
      ,MEMO_DESCB              --摘要描述
      ,CONVT_EXCH_RAT          --折算汇率
      ,USER_ID                 --用户编号
      ,SORC_SYS_DT             --源系统日期
      ,SORC_SYS_FLOW_NUM       --源系统流水号
      ,SRC_SYS_CD              --源系统代码
      ,SRC_TRAN_FLOW_SEQ_NUM   --源交易流水序号
      ,CHN_ID                  --渠道编号
      ,SELLBL_PROD_ID          --可售产品编号
      ,CLEAR_STATUS_CD         --清算状态代码
      ,CLEAR_FLOW_NUM          --清算流水号
      ,CLEAR_DT                --清算日期
      ,ENTER_ACCT_STATUS_CD    --入账状态代码
      ,SRC_SOB_ID              --源账套编号
      ,REVS_STATUS_CD          --冲正状态代码
      ,INIT_BUS_DT             --原业务日期
      ,INIT_BUS_FLOW_NUM       --原业务流水号
      ,STAND_MONY_AMT          --本位币金额
      ,ALDY_SYNC_FLG           --已同步标志
      ,OVA_FLOW_NUM            --全局流水号
      ,ETL_DT                  --ETL处理日期
      ,SRC_TABLE_NAME          --源表名称
      ,JOB_CD                  --任务编码
      ,ETL_TIMESTAMP           --ETL处理时间戳
   )
  SELECT 
       EVT_ID                  --事件编号
      ,SOB_ID                  --账套编号
      ,BUS_SYS_ID              --业务系统编号
      ,TRAN_DT                 --交易日期
      ,TRAN_FLOW_NUM           --交易流水号
      ,SUMOS_SEQ_NUM           --传票序号
      ,SUMOS_ID                --传票编号
      ,TRAN_ORG_ID             --交易机构编号
      ,FIN_ORG_ID              --财务机构编号
      ,SUBJ_ID                 --科目编号
      ,SUBJ_NAME               --科目名称
      ,BATCH_NO                --批次号
      ,TRAN_TM                 --交易时间
      ,CURR_CD                 --币种代码
      ,OFF_BS_FLG              --表外标志
      ,CUST_ID                 --客户编号
      ,PROD_ID                 --产品编号
      ,ACCT_ID                 --账户编号
      ,CASH_TRANS_FLG_CD       --现转标志代码
      ,DEBIT_CRDT_DIR_CD       --借贷方向代码
      ,TRAN_AMT                --交易金额
      ,TRAN_BAL                --交易余额
      ,MEMO_ID                 --摘要编号
      ,MEMO_DESCB              --摘要描述
      ,CONVT_EXCH_RAT          --折算汇率
      ,USER_ID                 --用户编号
      ,SORC_SYS_DT             --源系统日期
      ,SORC_SYS_FLOW_NUM       --源系统流水号
      ,SRC_SYS_CD              --源系统代码
      ,SRC_TRAN_FLOW_SEQ_NUM   --源交易流水序号
      ,CHN_ID                  --渠道编号
      ,SELLBL_PROD_ID          --可售产品编号
      ,CLEAR_STATUS_CD         --清算状态代码
      ,CLEAR_FLOW_NUM          --清算流水号
      ,CLEAR_DT                --清算日期
      ,ENTER_ACCT_STATUS_CD    --入账状态代码
      ,SRC_SOB_ID              --源账套编号
      ,REVS_STATUS_CD          --冲正状态代码
      ,INIT_BUS_DT             --原业务日期
      ,INIT_BUS_FLOW_NUM       --原业务流水号
      ,STAND_MONY_AMT          --本位币金额
      ,ALDY_SYNC_FLG           --已同步标志
      ,OVA_FLOW_NUM            --全局流水号
      ,ETL_DT                  --ETL处理日期
      ,SRC_TABLE_NAME          --源表名称
      ,JOB_CD                  --任务编码
      ,ETL_TIMESTAMP           --ETL处理时间戳
    FROM IML.V_EVT_ACCTI_MIDGROD_ACCT_ETY --视图-核算中台会计分录事件
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
  COMMIT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_EVT_ACCTI_MIDGROD_ACCT_ETY;
/

