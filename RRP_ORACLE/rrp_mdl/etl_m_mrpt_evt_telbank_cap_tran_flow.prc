CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_MRPT_EVT_TELBANK_CAP_TRAN_FLOW(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_M_MRPT_EVT_TELBANK_CAP_TRAN_FLOW
  *  功能描述：电话银行资金交易流水
  *  创建日期：20221213
  *  开发人员：阳娟
  *  来源表：
  *  目标表： M_MRPT_EVT_TELBANK_CAP_TRAN_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221213  阳娟     首次创建
  ***************************************************************************/
  AS
  I_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_M_MRPT_EVT_TELBANK_CAP_TRAN_FLOW'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  D_STARTTIME DATE; -- 处理开始时间
  D_ENDTIME DATE;   -- 处理结束时间
  I_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_SQL       VARCHAR2(2000); -- 动态sql
  I_STEP_DESC VARCHAR2(200); --任务名称
  V_PART_NAME VARCHAR2(100);  --分区名称
  V_PART_COUNT  INTEGER;        --分区是否存在
  V_TAB_NAME  VARCHAR2(100);  --表名称
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名称
  V_TAB_NAME := 'M_MRPT_EVT_TELBANK_CAP_TRAN_FLOW'; --表名称

  -- 支持重跑 --
  I_STEP := 1;
  I_STEP_DESC := '-- 程序跑批开始 --';
  D_STARTTIME := SYSDATE;
  --DELETE FROM M_MRPT_EVT_TELBANK_CAP_TRAN_FLOW T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  /*SELECT COUNT(0)
    INTO V_PART_COUNT
    FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME
     AND T.PARTITION_NAME = V_PART_NAME;

  IF V_PART_COUNT = 1 THEN
  V_SQL := 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;--分区表的重跑处理
  EXECUTE IMMEDIATE V_SQL;
  --ETL_PARTITION_DROP(V_P_DATE,V_TAB_NAME,O_ERRCODE);--分区表的重跑处理
  END IF ;*/
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME,1,O_ERRCODE);--新增分区

  I_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  D_ENDTIME := SYSDATE;

  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_STARTTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  I_STEP := 2; -- 小于10步骤直接写数字，大于10步用I_STEP := I_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  I_STEP_DESC := '数据落地-电话银行资金交易流水';
  D_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_MRPT_EVT_TELBANK_CAP_TRAN_FLOW
  (      DATA_DT  -- 数据日期
				,EVT_ID  --事件编号
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
        V_P_DATE
				,EVT_ID  --事件编号
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

    FROM RRP_MDL.O_IML_EVT_TELBANK_CAP_TRAN_FLOW --电话银行资金交易流水
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

   I_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   D_ENDTIME := SYSDATE;
   COMMIT;

   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;

   -- 程序跑批结束记录 --
   I_STEP_DESC := '-- 程序跑批结束 --';
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,'');

   -- 程序异常处理部分 --
   EXCEPTION
     WHEN OTHERS THEN
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  ROLLBACK;
     O_ERRCODE := '0';
     D_ENDTIME := SYSDATE;
     /*I_STEP := I_STEP + 1;
     I_STEP_DESC := '-- 程序跑批异常 --';*/
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,D_STARTTIME,D_ENDTIME,I_STEP,I_STEP_DESC,I_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_M_MRPT_EVT_TELBANK_CAP_TRAN_FLOW;
/

