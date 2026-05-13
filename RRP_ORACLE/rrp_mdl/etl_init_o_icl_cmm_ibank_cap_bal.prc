CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_IBANK_CAP_BAL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_IBANK_CAP_BAL
  *  功能描述：同业资金余额
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_IBANK_CAP_BAL
  *  目标表： O_ICL_CMM_IBANK_CAP_BAL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_IBANK_CAP_BAL'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_IBANK_CAP_BAL ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_IBANK_CAP_BAL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-同业资金余额';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_IBANK_CAP_BAL
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,INTNAL_CAP_ACCT_ID  --内部资金账户编号
      ,EXT_CAP_ACCT_ID  --外部资金账户编号
      ,ACCT_NAME  --账户名称
      ,TRAN_MARKET_ID  --交易市场编号
      ,EXCHG_ACCT_ID  --交易所账户编号
      ,OPEN_ACCT_BANK_NO  --开户银行行号
      ,OPEN_ACCT_BANK_NAME  --开户银行名称
      ,OPEN_ACCT_DT  --开户日期
      ,CNTPTY_CUST_ID  --交易对手客户编号
      ,CNTPTY_ID  --交易对手编号
      ,CNTPTY_NAME  --交易对手名称
      ,INTNAL_CAP_ACCT_NUM  --内部资金账号
      ,CAP_ACCT_TYPE_CD  --资金账户类型代码
      ,INTNAL_ACCT_NUM  --内部账号
      ,INTNAL_ACCT_NAME  --内部账名称
      ,PAY_INT_FREQ  --付息频率
      ,PROD_TYPE_ID  --产品类型编号
      ,PROD_CLS_NAME  --产品分类名称
      ,SUBJ_ID  --科目编号
      ,INT_RAT_DEF_ID  --利率定义编号
      ,INT_RAT  --利率
      ,CAP_TYPE_CD  --资金类型代码
      ,BAL_TYPE_CD  --余额类型代码
      ,CURR_CD  --币种代码
      ,ACTL_BAL  --实际余额
      ,FROZ_BAL  --冻结余额
      ,AVAL_BAL  --可用余额
      ,STL_DT  --结算日期
      ,OPEN_DT  --开仓日期
      ,ENTRY_ORG_ID  --记账机构编号
      ,BELONG_ORG_ID  --所属机构编号
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,INTNAL_CAP_ACCT_ID  --内部资金账户编号
      ,EXT_CAP_ACCT_ID  --外部资金账户编号
      ,ACCT_NAME  --账户名称
      ,TRAN_MARKET_ID  --交易市场编号
      ,EXCHG_ACCT_ID  --交易所账户编号
      ,OPEN_ACCT_BANK_NO  --开户银行行号
      ,OPEN_ACCT_BANK_NAME  --开户银行名称
      ,OPEN_ACCT_DT  --开户日期
      ,CNTPTY_CUST_ID  --交易对手客户编号
      ,CNTPTY_ID  --交易对手编号
      ,CNTPTY_NAME  --交易对手名称
      ,INTNAL_CAP_ACCT_NUM  --内部资金账号
      ,CAP_ACCT_TYPE_CD  --资金账户类型代码
      ,INTNAL_ACCT_NUM  --内部账号
      ,INTNAL_ACCT_NAME  --内部账名称
      ,PAY_INT_FREQ  --付息频率
      ,PROD_TYPE_ID  --产品类型编号
      ,PROD_CLS_NAME  --产品分类名称
      ,SUBJ_ID  --科目编号
      ,INT_RAT_DEF_ID  --利率定义编号
      ,INT_RAT  --利率
      ,CAP_TYPE_CD  --资金类型代码
      ,BAL_TYPE_CD  --余额类型代码
      ,CURR_CD  --币种代码
      ,ACTL_BAL  --实际余额
      ,FROZ_BAL  --冻结余额
      ,AVAL_BAL  --可用余额
      ,STL_DT  --结算日期
      ,OPEN_DT  --开仓日期
      ,ENTRY_ORG_ID  --记账机构编号
      ,BELONG_ORG_ID  --所属机构编号
    ,JOB_CD --任务代码
    FROM ICL.V_CMM_IBANK_CAP_BAL  --视图-同业资金余额
   WHERE TRUNC(ETL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
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

  END ETL_INIT_O_ICL_CMM_IBANK_CAP_BAL;
/

