CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_AGT_WLD_ACCT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_AGT_WLD_ACCT
  *  功能描述：微粒贷账户
  *  创建日期：20230202
  *  开发人员：MW
  *  来源表： IML.V_AGT_WLD_ACCT
  *  目标表： O_IML_AGT_WLD_ACCT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230202  MW     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_AGT_WLD_ACCT'; -- 程序名称
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
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_AGT_WLD_ACCT ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_AGT_WLD_ACCT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-微粒贷账户';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_WLD_ACCT
  (
				AGT_ID  --协议编号
				,LP_ID  --法人编号
				,ACCT_ID  --账户编号
				,ACCT_TYPE_CD  --账户类型代码
				,CUST_ID  --客户编号
				,NAME  --姓名
				,GENDER_CD  --性别代码
				,CUST_LMT_ID  --客户额度编号
				,LOAN_PROD_ID  --贷款产品编号
				,SYN_ID  --银团编号
				,CARD_NO  --卡号
				,CURR_CD  --币种代码
				,LMT  --额度
				,CURR_BAL  --当前余额
				,PRIC_BAL  --本金余额
				,LAST_EXP_DAY_BAL  --上一到期日余额
				,DUF_MONS  --拖欠月数
				,UNBD_DEBIT_AMT  --未入账借记金额
				,UNBD_CRDT_AMT  --未入账贷记金额
				,APOT_REPAY_TYPE_CD  --约定还款类型代码
				,APOT_REPAY_BANK_NAME  --约定还款银行名称
				,APOT_REPAY_OPEN_BANK_NUM  --约定还款开户行号
				,APOT_REPAY_DEDUCT_ACCT_NUM  --约定还款扣款账号
				,APOT_REPAY_DEDUCT_ACCT_NAME  --约定还款扣款账户名称
				,REPAY_DAY  --还款日
				,LAST_ENTER_ACCT_BATCH_DT  --上一次入账的批量日期
				,PREV_REPAY_DT  --上个还款日期
				,PREV_EXP_REPAY_DT  --上个到期还款日期
				,PREV_OVDUE_REPAY_DT  --上个逾期还款日期
				,PREV_OVDUE_MONS_PROMT_DT  --上个逾期月数提升日期
				,IN_COLL_DT  --入催日期
				,OUT_COLL_QUE_DT  --出催收队列日期
				,NEXT_EXP_REPAY_DT  --下个到期还款日期
				,EXP_REPAY_DT  --到期还款日期
				,APOT_REPAY_DT  --约定还款日期
				,GRACE_DT_TERM  --宽限日期
				,FIR_EXP_REPAY_DT  --首个到期还款日期
				,CLOS_ACCT_DT  --销户日期
				,TRAN_BAD_DEBT_ACCT_DT  --转呆账日期
				,FIR_CONSM_DT  --首次消费日期
				,LAST_REPAY_AMT  --上笔还款金额
				,FIR_CONSM_AMT  --首次消费金额
				,MIN_SECOND_MARKE  --最小还款额
				,CURRT_MIN_SECOND_MARKE  --当期最小还款额
				,CURRT_CASH_AMT  --当期取现金额
				,CURRT_CASH_CNT  --当期取现笔数
				,CURRT_CONSM_AMT  --当期消费金额
				,CURRT_CONSM_CNT  --当期消费笔数
				,CURRT_REPAY_AMT  --当期还款金额
				,CURRT_REPAY_CNT  --当期还款笔数
				,CURRT_DEBIT_ADJ_AMT  --当期借记调整金额
				,CURRT_DEBIT_ADJ_CNT  --当期借记调整笔数
				,CURRT_CRDT_ADJ_AMT  --当期贷记调整金额
				,CURRT_CRDT_ADJ_CNT  --当期贷记调整笔数
				,CURRT_FEE_AMT  --当期费用金额
				,CURRT_FEE_CNT  --当期费用笔数
				,CURRT_INT_AMT  --当期利息金额
				,CURRT_INT_CNT  --当期利息笔数
				,CURRT_RTN_GOODS_AMT  --当期退货金额
				,CURRT_RTN_GOODS_CNT  --当期退货笔数
				,CURRT_HIGT_OVER_LMT_AMT_LMT  --当期最高超限金额
				,TH_MON_CONSM_AMT  --本月消费金额
				,TH_MON_CONSM_CNT  --本月消费笔数
				,TH_YEAR_CONSM_AMT  --本年消费金额
				,TH_YEAR_CONSM_CNT  --本年消费笔数
				,CURR_MON_REPAY_AMT  --当月还款金额
				,CURR_MON_REPAY_CNT  --当月还款笔数
				,TH_YEAR_REPAY_AMT  --当年还款金额
				,TH_YEAR_REPAY_CNT  --当年还款笔数
				,H_REPAY_AMT  --历史还款金额
				,H_REPAY_CNT  --历史还款笔数
				,ACCT_OVDUE_AMT  --账户逾期金额
				,BANK_CONTRI_RATIO  --银行出资比例
				,BATCH_DOC_NAME  --批量文件名称
				,SER_NUM  --序列号
				,CREATE_DT  --创建日期
				,UPDATE_DT  --更新日期
				,ETL_DT  --ETL处理日期
				--,ID_MARK  --增删标志
				--,SRC_TABLE_NAME  --源表名称
				--,JOB_CD  --任务编码
				--,ETL_TIMESTAMP  --ETL处理时间戳
				,EXT_CUST_ID  --外部客户编号

    )
    SELECT
				AGT_ID  --协议编号
				,LP_ID  --法人编号
				,ACCT_ID  --账户编号
				,ACCT_TYPE_CD  --账户类型代码
				,CUST_ID  --客户编号
				,NAME  --姓名
				,GENDER_CD  --性别代码
				,CUST_LMT_ID  --客户额度编号
				,LOAN_PROD_ID  --贷款产品编号
				,SYN_ID  --银团编号
				,CARD_NO  --卡号
				,CURR_CD  --币种代码
				,LMT  --额度
				,CURR_BAL  --当前余额
				,PRIC_BAL  --本金余额
				,LAST_EXP_DAY_BAL  --上一到期日余额
				,DUF_MONS  --拖欠月数
				,UNBD_DEBIT_AMT  --未入账借记金额
				,UNBD_CRDT_AMT  --未入账贷记金额
				,APOT_REPAY_TYPE_CD  --约定还款类型代码
				,APOT_REPAY_BANK_NAME  --约定还款银行名称
				,APOT_REPAY_OPEN_BANK_NUM  --约定还款开户行号
				,APOT_REPAY_DEDUCT_ACCT_NUM  --约定还款扣款账号
				,APOT_REPAY_DEDUCT_ACCT_NAME  --约定还款扣款账户名称
				,REPAY_DAY  --还款日
				,LAST_ENTER_ACCT_BATCH_DT  --上一次入账的批量日期
				,PREV_REPAY_DT  --上个还款日期
				,PREV_EXP_REPAY_DT  --上个到期还款日期
				,PREV_OVDUE_REPAY_DT  --上个逾期还款日期
				,PREV_OVDUE_MONS_PROMT_DT  --上个逾期月数提升日期
				,IN_COLL_DT  --入催日期
				,OUT_COLL_QUE_DT  --出催收队列日期
				,NEXT_EXP_REPAY_DT  --下个到期还款日期
				,EXP_REPAY_DT  --到期还款日期
				,APOT_REPAY_DT  --约定还款日期
				,GRACE_DT_TERM  --宽限日期
				,FIR_EXP_REPAY_DT  --首个到期还款日期
				,CLOS_ACCT_DT  --销户日期
				,TRAN_BAD_DEBT_ACCT_DT  --转呆账日期
				,FIR_CONSM_DT  --首次消费日期
				,LAST_REPAY_AMT  --上笔还款金额
				,FIR_CONSM_AMT  --首次消费金额
				,MIN_SECOND_MARKE  --最小还款额
				,CURRT_MIN_SECOND_MARKE  --当期最小还款额
				,CURRT_CASH_AMT  --当期取现金额
				,CURRT_CASH_CNT  --当期取现笔数
				,CURRT_CONSM_AMT  --当期消费金额
				,CURRT_CONSM_CNT  --当期消费笔数
				,CURRT_REPAY_AMT  --当期还款金额
				,CURRT_REPAY_CNT  --当期还款笔数
				,CURRT_DEBIT_ADJ_AMT  --当期借记调整金额
				,CURRT_DEBIT_ADJ_CNT  --当期借记调整笔数
				,CURRT_CRDT_ADJ_AMT  --当期贷记调整金额
				,CURRT_CRDT_ADJ_CNT  --当期贷记调整笔数
				,CURRT_FEE_AMT  --当期费用金额
				,CURRT_FEE_CNT  --当期费用笔数
				,CURRT_INT_AMT  --当期利息金额
				,CURRT_INT_CNT  --当期利息笔数
				,CURRT_RTN_GOODS_AMT  --当期退货金额
				,CURRT_RTN_GOODS_CNT  --当期退货笔数
				,CURRT_HIGT_OVER_LMT_AMT_LMT  --当期最高超限金额
				,TH_MON_CONSM_AMT  --本月消费金额
				,TH_MON_CONSM_CNT  --本月消费笔数
				,TH_YEAR_CONSM_AMT  --本年消费金额
				,TH_YEAR_CONSM_CNT  --本年消费笔数
				,CURR_MON_REPAY_AMT  --当月还款金额
				,CURR_MON_REPAY_CNT  --当月还款笔数
				,TH_YEAR_REPAY_AMT  --当年还款金额
				,TH_YEAR_REPAY_CNT  --当年还款笔数
				,H_REPAY_AMT  --历史还款金额
				,H_REPAY_CNT  --历史还款笔数
				,ACCT_OVDUE_AMT  --账户逾期金额
				,BANK_CONTRI_RATIO  --银行出资比例
				,BATCH_DOC_NAME  --批量文件名称
				,SER_NUM  --序列号
				,CREATE_DT  --创建日期
				,UPDATE_DT  --更新日期
				,ETL_DT + 1  --ETL处理日期
				--,ID_MARK  --增删标志
				--,SRC_TABLE_NAME  --源表名称
				--,JOB_CD  --任务编码
				--,ETL_TIMESTAMP  --ETL处理时间戳
				,EXT_CUST_ID  --外部客户编号
    FROM IML.V_AGT_WLD_ACCT  --视图-微粒贷账户
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

  END ETL_INIT_O_IML_AGT_WLD_ACCT;
/

