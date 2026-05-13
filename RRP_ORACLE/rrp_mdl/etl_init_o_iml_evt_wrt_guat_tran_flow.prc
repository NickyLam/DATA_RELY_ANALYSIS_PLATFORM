CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_WRT_GUAT_TRAN_FLOW(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_WRT_GUAT_TRAN_FLOW
  *  功能描述：结售汇交易流水
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_EVT_WRT_GUAT_TRAN_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_IML_EVT_WRT_GUAT_TRAN_FLOW'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_WRT_GUAT_TRAN_FLOW ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_WRT_GUAT_TRAN_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-结售汇交易流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_WRT_GUAT_TRAN_FLOW
  (  			EVT_ID  --事件编号
					,TRAN_FLOW_NUM  --交易流水号
					,LP_ID  --法人编号
					,CASH_TRAN_SEQ_NUM  --现金交易序号
					,CR_ACCT_ID  --贷方账户编号
					,CR_CUST_ACCT_NUM  --贷方客户账号
					,CR_ACCT_CURR  --贷方账户币种代码
					,CR_ACCT_SUB_ACCT_NUM  --贷方账户子账号
					,CR_ACCT_PROD_ID  --贷方账户产品编号
					,CR_BAL_TYPE_CD  --贷方钞汇余额代码
					,CR_TRAN_SEQ_NUM  --贷方交易序号
					,DR_ACCT_ID  --借方账户编号
					,DR_CUST_ACCT_NUM  --借方客户账号
					,DR_ACCT_CURR  --借方账户币种代码
					,DR_ACCT_SUB_ACCT_NUM  --借方账户子账号
					,DR_ACCT_PROD_ID  --借方账户产品编号
					,DR_BAL_TYPE_CD  --借方钞汇余额代码
					,DR_TRAN_SEQ_NUM  --借方交易序号
					,CUST_ID  --客户编号
					,TRAN_CD  --交易码
					,TRAN_DT  --交易日期
					,TRAN_ORG_ID  --交易机构编号
					,REVS_DT  --冲正日期
					,REVS_TRAN_CD  --冲正交易码
					,WRT_GUAT_TRAN_STATUS_CD  --结售汇交易状态代码
					,BUS_TYPE_CD  --业务类型代码
					,QUOT_TYPE_CD  --牌价类型代码
					,EXCH_RAT_TYPE_CD  --汇率类型代码
					,BUY_AMT  --买入金额
					,BUY_CURR_CD  --买入币种代码
					,BUYER_EXCH_RAT  --买方汇率
					,SELL_CURR  --卖出币种代码
					,SELL_AMT  --卖出金额
					,SELLER_EXCH_RAT  --卖方汇率
					,EXEC_EXCH_RAT  --执行汇率
					,FLOAT_INT_RAT  --浮动利率
					,BASE_QUOT_WAY_CD  --基础报价方式代码
					,BASE_EXCH_RAT_TYPE_CD  --基础汇率类型代码
					,BASE_EXCH_RAT  --基础汇率
					,BASE_EQUVL_AMT  --基础等值金额
					,CROSS_EXCH_RAT  --交叉汇率
					,OFFSET_CROSS_EXCH_RAT  --平盘交叉汇率
					,INTNAL_PRICE  --内部价格
					,CHANGE_EQUVL_AMT  --找零等值金额
					,CHANGE_AMT  --找零金额
					,CHANGE_BASE_INT_RAT  --找零基础利率
					,CHANGE_BASE_INT_RAT_TYPE_CD  --找零基础利率类型代码
					,CHANGE_INT_RAT  --找零利率
					,CHANGE_BASE_QUOT_WAY_CD  --找零基础报价方式代码
					,CHANGE_QUOT_WAY_CD  --找零报价方式代码
					,CHANGE_INT_RAT_TYPE_CD  --找零利率类型代码
					,TRAN_REF_NO  --交易参考号
					,FOLLOW_REF_NO  --跟踪参考号
					,CHN_ID  --渠道编号
					,BANK_TRAN_SEQ_NUM  --银行交易序号
					,TRAN_DESCB  --交易描述
					,SRC_MODULE_TYPE_CD  --源模块类型代码
					,TRAN_TERMN_ID  --交易终端编号
					,CHECK_DT  --复核日期
					,ENTRY_DT  --记账日期
					,CHECK_TELLER_ID  --复核柜员编号
					,CHECK_AUTH_TELLER_ID  --复核授权柜员编号
					,TRAN_AUTH_TELLER_ID  --交易授权柜员编号
					,REVS_AUTH_TELLER_ID  --冲正授权柜员编号
					,REVS_TELLER_ID  --冲正柜员编号
					,CORE_TRAN_TELLER_ID  --核心交易柜员编号
					,TRAN_TM  --交易时间
					,OFFSET_STATUS_CD  --平盘状态代码
					,FCURR_HQ_SYS_IN_SUPLM_AMT  --外币总行系统内平补金额
					,SYS_IN_OFFSET_FLOW_NUM  --系统内平盘流水号
					,TRAN_MARKET_OFFSET_FLOW_NUM  --交易市场平盘流水号
					,ETL_DT  --ETL处理日期
					,SRC_TABLE_NAME  --源表名称
					,JOB_CD  --任务编码
					,ETL_TIMESTAMP  --ETL处理时间戳
    )
    SELECT

     			EVT_ID  --事件编号
					,TRAN_FLOW_NUM  --交易流水号
					,LP_ID  --法人编号
					,CASH_TRAN_SEQ_NUM  --现金交易序号
					,CR_ACCT_ID  --贷方账户编号
					,CR_CUST_ACCT_NUM  --贷方客户账号
					,CR_ACCT_CURR  --贷方账户币种代码
					,CR_ACCT_SUB_ACCT_NUM  --贷方账户子账号
					,CR_ACCT_PROD_ID  --贷方账户产品编号
					,CR_BAL_TYPE_CD  --贷方钞汇余额代码
					,CR_TRAN_SEQ_NUM  --贷方交易序号
					,DR_ACCT_ID  --借方账户编号
					,DR_CUST_ACCT_NUM  --借方客户账号
					,DR_ACCT_CURR  --借方账户币种代码
					,DR_ACCT_SUB_ACCT_NUM  --借方账户子账号
					,DR_ACCT_PROD_ID  --借方账户产品编号
					,DR_BAL_TYPE_CD  --借方钞汇余额代码
					,DR_TRAN_SEQ_NUM  --借方交易序号
					,CUST_ID  --客户编号
					,TRAN_CD  --交易码
					,TRAN_DT  --交易日期
					,TRAN_ORG_ID  --交易机构编号
					,REVS_DT  --冲正日期
					,REVS_TRAN_CD  --冲正交易码
					,WRT_GUAT_TRAN_STATUS_CD  --结售汇交易状态代码
					,BUS_TYPE_CD  --业务类型代码
					,QUOT_TYPE_CD  --牌价类型代码
					,EXCH_RAT_TYPE_CD  --汇率类型代码
					,BUY_AMT  --买入金额
					,BUY_CURR_CD  --买入币种代码
					,BUYER_EXCH_RAT  --买方汇率
					,SELL_CURR  --卖出币种代码
					,SELL_AMT  --卖出金额
					,SELLER_EXCH_RAT  --卖方汇率
					,EXEC_EXCH_RAT  --执行汇率
					,FLOAT_INT_RAT  --浮动利率
					,BASE_QUOT_WAY_CD  --基础报价方式代码
					,BASE_EXCH_RAT_TYPE_CD  --基础汇率类型代码
					,BASE_EXCH_RAT  --基础汇率
					,BASE_EQUVL_AMT  --基础等值金额
					,CROSS_EXCH_RAT  --交叉汇率
					,OFFSET_CROSS_EXCH_RAT  --平盘交叉汇率
					,INTNAL_PRICE  --内部价格
					,CHANGE_EQUVL_AMT  --找零等值金额
					,CHANGE_AMT  --找零金额
					,CHANGE_BASE_INT_RAT  --找零基础利率
					,CHANGE_BASE_INT_RAT_TYPE_CD  --找零基础利率类型代码
					,CHANGE_INT_RAT  --找零利率
					,CHANGE_BASE_QUOT_WAY_CD  --找零基础报价方式代码
					,CHANGE_QUOT_WAY_CD  --找零报价方式代码
					,CHANGE_INT_RAT_TYPE_CD  --找零利率类型代码
					,TRAN_REF_NO  --交易参考号
					,FOLLOW_REF_NO  --跟踪参考号
					,CHN_ID  --渠道编号
					,BANK_TRAN_SEQ_NUM  --银行交易序号
					,TRAN_DESCB  --交易描述
					,SRC_MODULE_TYPE_CD  --源模块类型代码
					,TRAN_TERMN_ID  --交易终端编号
					,CHECK_DT  --复核日期
					,ENTRY_DT  --记账日期
					,CHECK_TELLER_ID  --复核柜员编号
					,CHECK_AUTH_TELLER_ID  --复核授权柜员编号
					,TRAN_AUTH_TELLER_ID  --交易授权柜员编号
					,REVS_AUTH_TELLER_ID  --冲正授权柜员编号
					,REVS_TELLER_ID  --冲正柜员编号
					,CORE_TRAN_TELLER_ID  --核心交易柜员编号
					,TRAN_TM  --交易时间
					,OFFSET_STATUS_CD  --平盘状态代码
					,FCURR_HQ_SYS_IN_SUPLM_AMT  --外币总行系统内平补金额
					,SYS_IN_OFFSET_FLOW_NUM  --系统内平盘流水号
					,TRAN_MARKET_OFFSET_FLOW_NUM  --交易市场平盘流水号
					,ETL_DT  --ETL处理日期
					,SRC_TABLE_NAME  --源表名称
					,JOB_CD  --任务编码
					,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_EVT_WRT_GUAT_TRAN_FLOW  --视图-结售汇交易流水
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

  END ETL_INIT_O_IML_EVT_WRT_GUAT_TRAN_FLOW;
/

