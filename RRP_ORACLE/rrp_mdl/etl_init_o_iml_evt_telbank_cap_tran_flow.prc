CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_TELBANK_CAP_TRAN_FLOW(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_TELBANK_CAP_TRAN_FLOW
  *  功能描述：电话银行资金交易流水
  *  创建日期：20221210
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_EVT_TELBANK_CAP_TRAN_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221210  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_TELBANK_CAP_TRAN_FLOW'; -- 程序名称
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
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_TELBANK_CAP_TRAN_FLOW ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_TELBANK_CAP_TRAN_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-电话银行资金交易流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_TELBANK_CAP_TRAN_FLOW
  (
				EVT_ID  --事件编号
				,LP_ID  --法人编号
				,TRAN_FLOW_NUM  --交易流水号
				,CALL_FLOW_NUM  --呼叫流水号
				,IN_CALL_NUM  --呼入电话号码
				,AUD_SYS_CD  --语音系统代码
				,TRAN_CD  --交易代码
				,TRAN_TM  --交易时间
				,RETURN_CODE  --返回码
				,RETURN_INFO  --返回信息
				,CUST_NAME  --客户名称
				,PAY_ACCT_ID  --付款账户编号
				,PAY_BANK_NO  --付款行行号
				,PAY_BANK_NAME  --付款行名称
				,RECVBL_ACCT_ID  --收款账户编号
				,RECVBL_ACCT_NAME  --收款账户名称
				,RECV_BANK_NO  --收款行行号
				,RECV_BANK_NAME  --收款行名称
				,AVL_AGING_CD  --到账时效代码
				,TRAN_AMT  --交易金额
				,COMM_FEE  --手续费
				,CURR_CD  --币种代码
				,CHN_CD  --渠道代码
				,DEP_TERM  --存期
				,REDT_FLG  --转存标志
				,OPERR_ID  --操作员编号
				,SIGN_ORG_NAME  --签约机构名称
				,DEP_TERM_CD  --存期代码
				,SAV_TYPE_CD  --储种代码
				,ETL_DT  --ETL处理日期
				,SRC_TABLE_NAME  --源表名称
				,JOB_CD  --任务编码
				,ETL_TIMESTAMP  --ETL处理时间戳

    )
    SELECT
					EVT_ID  --事件编号
				,LP_ID  --法人编号
				,TRAN_FLOW_NUM  --交易流水号
				,CALL_FLOW_NUM  --呼叫流水号
				,IN_CALL_NUM  --呼入电话号码
				,AUD_SYS_CD  --语音系统代码
				,TRAN_CD  --交易代码
				,TRAN_TM  --交易时间
				,RETURN_CODE  --返回码
				,RETURN_INFO  --返回信息
				,CUST_NAME  --客户名称
				,PAY_ACCT_ID  --付款账户编号
				,PAY_BANK_NO  --付款行行号
				,PAY_BANK_NAME  --付款行名称
				,RECVBL_ACCT_ID  --收款账户编号
				,RECVBL_ACCT_NAME  --收款账户名称
				,RECV_BANK_NO  --收款行行号
				,RECV_BANK_NAME  --收款行名称
				,AVL_AGING_CD  --到账时效代码
				,TRAN_AMT  --交易金额
				,COMM_FEE  --手续费
				,CURR_CD  --币种代码
				,CHN_CD  --渠道代码
				,DEP_TERM  --存期
				,REDT_FLG  --转存标志
				,OPERR_ID  --操作员编号
				,SIGN_ORG_NAME  --签约机构名称
				,DEP_TERM_CD  --存期代码
				,SAV_TYPE_CD  --储种代码
				,ETL_DT  --ETL处理日期
				,SRC_TABLE_NAME  --源表名称
				,JOB_CD  --任务编码
				,ETL_TIMESTAMP  --ETL处理时间戳

    FROM IML.V_EVT_TELBANK_CAP_TRAN_FLOW  --视图-电话银行资金交易流水
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

  END ETL_INIT_O_IML_EVT_TELBANK_CAP_TRAN_FLOW;
/

