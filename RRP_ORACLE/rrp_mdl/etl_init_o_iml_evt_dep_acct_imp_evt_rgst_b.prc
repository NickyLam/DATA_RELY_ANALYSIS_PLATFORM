CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B
  *  功能描述：存款计提流水
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IML.V_EVT_DEP_ACCT_IMP_EVT_RGST_B
  *  目标表： O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B'; -- 程序名称
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
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-存款计提流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B
  (
					EVT_ID  --事件编号
					,LP_ID  --法人编号
					,SEQ_NUM  --序号
					,ACCT_ID  --账户编号
					,INT_CLS_CD  --利息分类代码
					,TRAN_DT  --交易日期
					,TRAN_ORG_ID  --交易机构编号
					,CUST_ACCT_NUM  --客户账号
					,PROD_ID  --产品编号
					,ACCT_CURR_CD  --账户币种代码
					,SUB_ACCT_NUM  --子账号
					,OPEN_ACCT_ORG_ID  --开户机构编号
					,OPEN_ACCT_DT  --开户日期
					,CUST_ID  --客户编号
					,DEP_REDT_TYPE_CD  --存款转存类型代码
					,INT_RAT_TYPE_CD  --利率类型代码
					,BANK_INT_INT_RAT  --行内利率
					,FLOAT_INT_RAT  --浮动利率
					,FLOAT_POINT  --浮动点数
					,EXEC_INT_RAT  --执行利率
					,ACM_INT_ADJ_AMT  --累计利息调整金额
					,PROVI_DAY_INT_ADJ_AMT  --计提日利息调整金额
					,BASE_INT_RAT  --基础利率
					,TOT_INT_AMT  --总利息金额
					,INT_ACCR_AMT  --计息金额
					,LAST_INT_SET_DT  --上一结息日期
					,CAP_FLG  --资本化标志
					,DEP_TERM_TENOR  --存期期限
					,TENOR_TYPE_CD  --期限类型代码
					,EXP_DT  --到期日期
					,AMT_TYPE_CD  --金额类型代码
					,TRAN_HAPP_PRIC  --交易发生本金
					,TRAN_AMT  --交易金额
					,WDRAW_INT_RAT  --支取利率
					,NET_INT  --净利息
					,INT_ACCR_DAYS  --计息天数
					,TAX_RAT  --税率
					,TAX_CATEGORY_CD  --税种代码
					,TAX_AMT  --税金
					,DEP_VOUCH_CATE_CD  --存款凭证类别代码
					,VOUCH_NO  --凭证号码
					,REDT_SEQ_NUM  --转存序号
					,TRAN_REF_NO  --交易参考号
					,POST_FLG  --过账标志
					,TRAN_REVS_DT  --交易冲正日期
					,ACCTI_STATUS_CD  --核算状态代码
					,SOB_CATE_CD  --账套类别代码
					,TRAN_MEMO_DESCB  --交易摘要描述
					,SRC_MODULE_TYPE_CD  --源模块类型代码
					,BUS_PROC_STATUS_CD  --业务处理状态代码
					,CHECK_ENTRY_CD  --对账代码
					,TRAN_TELLER_ID  --交易柜员编号
					,TRAN_TM  --交易时间
					,BUS_FLOW_NUM  --业务流水号
					,ETL_DT  --ETL处理日期
					,SRC_TABLE_NAME  --源表名称
					,JOB_CD  --任务编码
					,ETL_TIMESTAMP  --ETL处理时间戳
    )
    SELECT
					EVT_ID  --事件编号
					,LP_ID  --法人编号
					,SEQ_NUM  --序号
					,ACCT_ID  --账户编号
					,INT_CLS_CD  --利息分类代码
					,TRAN_DT  --交易日期
					,TRAN_ORG_ID  --交易机构编号
					,CUST_ACCT_NUM  --客户账号
					,PROD_ID  --产品编号
					,ACCT_CURR_CD  --账户币种代码
					,SUB_ACCT_NUM  --子账号
					,OPEN_ACCT_ORG_ID  --开户机构编号
					,OPEN_ACCT_DT  --开户日期
					,CUST_ID  --客户编号
					,DEP_REDT_TYPE_CD  --存款转存类型代码
					,INT_RAT_TYPE_CD  --利率类型代码
					,BANK_INT_INT_RAT  --行内利率
					,FLOAT_INT_RAT  --浮动利率
					,FLOAT_POINT  --浮动点数
					,EXEC_INT_RAT  --执行利率
					,ACM_INT_ADJ_AMT  --累计利息调整金额
					,PROVI_DAY_INT_ADJ_AMT  --计提日利息调整金额
					,BASE_INT_RAT  --基础利率
					,TOT_INT_AMT  --总利息金额
					,INT_ACCR_AMT  --计息金额
					,LAST_INT_SET_DT  --上一结息日期
					,CAP_FLG  --资本化标志
					,DEP_TERM_TENOR  --存期期限
					,TENOR_TYPE_CD  --期限类型代码
					,EXP_DT  --到期日期
					,AMT_TYPE_CD  --金额类型代码
					,TRAN_HAPP_PRIC  --交易发生本金
					,TRAN_AMT  --交易金额
					,WDRAW_INT_RAT  --支取利率
					,NET_INT  --净利息
					,INT_ACCR_DAYS  --计息天数
					,TAX_RAT  --税率
					,TAX_CATEGORY_CD  --税种代码
					,TAX_AMT  --税金
					,DEP_VOUCH_CATE_CD  --存款凭证类别代码
					,VOUCH_NO  --凭证号码
					,REDT_SEQ_NUM  --转存序号
					,TRAN_REF_NO  --交易参考号
					,POST_FLG  --过账标志
					,TRAN_REVS_DT  --交易冲正日期
					,ACCTI_STATUS_CD  --核算状态代码
					,SOB_CATE_CD  --账套类别代码
					,TRAN_MEMO_DESCB  --交易摘要描述
					,SRC_MODULE_TYPE_CD  --源模块类型代码
					,BUS_PROC_STATUS_CD  --业务处理状态代码
					,CHECK_ENTRY_CD  --对账代码
					,TRAN_TELLER_ID  --交易柜员编号
					,TRAN_TM  --交易时间
					,BUS_FLOW_NUM  --业务流水号
					,ETL_DT  --ETL处理日期
					,SRC_TABLE_NAME  --源表名称
					,JOB_CD  --任务编码
					,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_EVT_DEP_ACCT_IMP_EVT_RGST_B  --视图-存款计提流水

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

  END ETL_INIT_O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B;
/

