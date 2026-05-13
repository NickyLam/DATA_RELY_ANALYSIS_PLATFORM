CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_ENTRY(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_ENTRY
  *  功能描述：记账分录事件
  *  创建日期：20230113
  *  开发人员：MW
  *  来源表： IML.V_EVT_ENTRY
  *  目标表： O_IML_EVT_ENTRY
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230113  MW     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_ENTRY'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_ENTRY ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_ENTRY';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-记账分录事件';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_ENTRY
  (
							EVT_ID  --事件编号
							,LP_ID  --法人编号
							,ENTRY_ID  --记账分录编号
							,BELONG_HQ_BANK_NO  --所属总行行号
							,TRAN_ORG_ID  --交易机构编号
							,ENTRY_TRAN_ID  --记账交易编号
							,TRAN_ATTR_STRING  --交易属性字符串
							,PROD_ID  --产品编号
							,BATCH_ID  --批次编号
							,CONT_ID  --合同编号
							,DTL_ID  --明细编号
							,BILL_ID  --票据编号
							,BILL_NUM  --票据号码
							,FAC_VAL_AMT  --票面金额
							,ENTRY_SEQ_NUM  --分录顺序号
							,GET_VAL_FIELD  --取值字段
							,DEBIT_CRDT_DIR_CD  --借贷方向代码
							,PRTCPTR_ROLE_CD  --参与方角色代码
							,PRTCPTR_AMT  --参与方金额
							,ENTRY_FLG  --分录标志
							,SUBJ_ID  --科目编号
							,SUBJ_NAME  --科目名称
							,CUST_ID  --客户编号
							,TARGET_ACCT_NUM  --目标账户号
							,PRTCPTR_ACCT_TYPE_CD  --参与方账户类型代码
							,ORG_ID  --机构编号
							,PRTCPTR_TYPE_CD  --参与方类型代码
							,PRTCPTR_EXT  --参与方扩展
							,EXT_AMT_1  --扩展金额1
							,EXT_AMT_2  --扩展金额2
							,EXT_AMT_3  --扩展金额3
							,BATCH_ENTRY_FLG  --批次记账标志
							,DTL_STATUS_FLG  --明细状态标志
							,CREATE_TM  --创建时间
							,UPDATE_TM  --更新时间
							,FINAL_MODIF_OPERR_ID  --最后修改操作员编号
							,SYS_ID  --系统编号
							,ACCT_INSTIT_ID  --账务机构编号
							,INIT_BILL_SYS_RGST_CTER_ID  --原票据系统登记中心编号
							,H_DATA_FLG  --历史数据标志
							,ETL_DT  --ETL处理日期
							,SRC_TABLE_NAME  --源表名称
							,JOB_CD  --任务编码
							,ETL_TIMESTAMP  --ETL处理时间戳

    )
    SELECT
							EVT_ID  --事件编号
							,LP_ID  --法人编号
							,ENTRY_ID  --记账分录编号
							,BELONG_HQ_BANK_NO  --所属总行行号
							,TRAN_ORG_ID  --交易机构编号
							,ENTRY_TRAN_ID  --记账交易编号
							,TRAN_ATTR_STRING  --交易属性字符串
							,PROD_ID  --产品编号
							,BATCH_ID  --批次编号
							,CONT_ID  --合同编号
							,DTL_ID  --明细编号
							,BILL_ID  --票据编号
							,BILL_NUM  --票据号码
							,FAC_VAL_AMT  --票面金额
							,ENTRY_SEQ_NUM  --分录顺序号
							,GET_VAL_FIELD  --取值字段
							,DEBIT_CRDT_DIR_CD  --借贷方向代码
							,PRTCPTR_ROLE_CD  --参与方角色代码
							,PRTCPTR_AMT  --参与方金额
							,ENTRY_FLG  --分录标志
							,SUBJ_ID  --科目编号
							,SUBJ_NAME  --科目名称
							,CUST_ID  --客户编号
							,TARGET_ACCT_NUM  --目标账户号
							,PRTCPTR_ACCT_TYPE_CD  --参与方账户类型代码
							,ORG_ID  --机构编号
							,PRTCPTR_TYPE_CD  --参与方类型代码
							,PRTCPTR_EXT  --参与方扩展
							,EXT_AMT_1  --扩展金额1
							,EXT_AMT_2  --扩展金额2
							,EXT_AMT_3  --扩展金额3
							,BATCH_ENTRY_FLG  --批次记账标志
							,DTL_STATUS_FLG  --明细状态标志
							,CREATE_TM  --创建时间
							,UPDATE_TM  --更新时间
							,FINAL_MODIF_OPERR_ID  --最后修改操作员编号
							,SYS_ID  --系统编号
							,ACCT_INSTIT_ID  --账务机构编号
							,INIT_BILL_SYS_RGST_CTER_ID  --原票据系统登记中心编号
							,H_DATA_FLG  --历史数据标志
							,ETL_DT  --ETL处理日期
							,SRC_TABLE_NAME  --源表名称
							,JOB_CD  --任务编码
							,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_EVT_ENTRY  --视图-记账分录事件

;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_INIT_O_IML_EVT_ENTRY;
/

