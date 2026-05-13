CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_WLD_ACCT_ETY_TRAN(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_WLD_ACCT_ETY_TRAN
  *  功能描述：微粒贷会计分录交易事件
  *  创建日期：20230114
  *  开发人员：MW
  *  来源表： IML.V_EVT_WLD_ACCT_ETY_TRAN
  *  目标表： O_IML_EVT_WLD_ACCT_ETY_TRAN
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230114  MW     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_WLD_ACCT_ETY_TRAN'; -- 程序名称
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
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_WLD_ACCT_ETY_TRAN ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_WLD_ACCT_ETY_TRAN';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-微粒贷会计分录交易事件';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_WLD_ACCT_ETY_TRAN
  (
            EVT_ID  --事件编号
            ,LP_ID  --法人编号
            ,SER_NUM  --序列号
            ,BATCH_DOC_NAME  --批量文件名称
            ,BATCH_DT  --批量日期
            ,GROUPING_SEQ_NUM  --分组序号
            ,EVT_TRAN_CODE  --事件交易码
            ,CORE_TRAN_FLOW  --核心交易流水
            ,TRAN_DESCB  --交易描述
            ,PERDS  --期数
            ,CARD_NO  --卡号
            ,CURR_CD  --币种代码
            ,ENTER_ACCT_AMT  --入账金额
            ,DEBIT_CRDT_FLG  --借贷标志
            ,ENTER_ACCT_WAY_CD  --入账方式代码
            ,SUBRCH_ID  --支行编号
            ,SUBJ_ID  --科目编号
            ,LOAN_PROD_ID  --贷款产品编号
            ,CRDT_PLAN_ID  --信用计划编号
            ,SYN_ID  --银团编号
            ,BANK_ID  --银行编号
            ,RB_W_FLG  --冲补抹标志
            ,TRAN_REF_NO  --交易参考号
            ,AGING_GROUP_CD  --账龄组代码
            ,BAL_COMPNT_GROUP_CD  --余额成分组代码
            ,ETL_DT  --ETL处理日期
            ,SRC_TABLE_NAME  --源表名称
            ,JOB_CD  --任务编码
            ,ETL_TIMESTAMP  --ETL处理时间戳

    )
    SELECT
            EVT_ID  --事件编号
            ,LP_ID  --法人编号
            ,SER_NUM  --序列号
            ,BATCH_DOC_NAME  --批量文件名称
            ,BATCH_DT  --批量日期
            ,GROUPING_SEQ_NUM  --分组序号
            ,EVT_TRAN_CODE  --事件交易码
            ,CORE_TRAN_FLOW  --核心交易流水
            ,TRAN_DESCB  --交易描述
            ,PERDS  --期数
            ,CARD_NO  --卡号
            ,CURR_CD  --币种代码
            ,ENTER_ACCT_AMT  --入账金额
            ,DEBIT_CRDT_FLG  --借贷标志
            ,ENTER_ACCT_WAY_CD  --入账方式代码
            ,SUBRCH_ID  --支行编号
            ,SUBJ_ID  --科目编号
            ,LOAN_PROD_ID  --贷款产品编号
            ,CRDT_PLAN_ID  --信用计划编号
            ,SYN_ID  --银团编号
            ,BANK_ID  --银行编号
            ,RB_W_FLG  --冲补抹标志
            ,TRAN_REF_NO  --交易参考号
            ,AGING_GROUP_CD  --账龄组代码
            ,BAL_COMPNT_GROUP_CD  --余额成分组代码
            ,ETL_DT  --ETL处理日期
            ,SRC_TABLE_NAME  --源表名称
            ,JOB_CD  --任务编码
            ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_EVT_WLD_ACCT_ETY_TRAN  --视图-微粒贷会计分录交易事件

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

  END ETL_INIT_O_IML_EVT_WLD_ACCT_ETY_TRAN;
/

