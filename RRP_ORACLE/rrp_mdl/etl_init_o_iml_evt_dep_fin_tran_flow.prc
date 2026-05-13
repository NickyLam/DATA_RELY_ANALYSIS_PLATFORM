CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_DEP_FIN_TRAN_FLOW(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_DEP_FIN_TRAN_FLOW
  *  功能描述：存款金融交易流水
  *  创建日期：20221222
  *  开发人员：梅炜
  *  来源表： IML.V_EVT_DEP_FIN_TRAN_FLOW
  *  目标表： O_IML_EVT_DEP_FIN_TRAN_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221222  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_DEP_FIN_TRAN_FLOW'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_DEP_FIN_TRAN_FLOW ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_DEP_FIN_TRAN_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-存款金融交易流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_DEP_FIN_TRAN_FLOW
  (
        EVT_ID  --事件编号
        ,LP_ID  --法人编号
        ,TRAN_FLOW_NUM  --交易流水号
        ,OVA_FLOW_NUM  --全局流水号
        ,CORE_FLOW_NUM  --核心流水号
        ,TRAN_REF_NO  --交易参考号
        ,ACCT_ID  --账户编号
        ,CUST_ACCT_NUM  --客户账号
        ,BUS_PROD_ID  --业务产品编号
        ,ACCT_CURR_CD  --账户币种代码
        ,SUB_ACCT_NUM  --子账号
        ,SUB_ACCT_ID  --子账户编号
        ,ACCT_TYPE_CD  --账户类型代码
        ,ACCT_STATUS_CD  --账户状态代码
        ,VTUAL_ACCT_FLG  --虚户标志
        ,CASH_TRAN_FLG  --现金交易标志
        ,ACCT_NAME  --账户名称
        ,OPEN_ACCT_ORG_ID  --开户机构编号
        ,EVT_CATE_ID  --事件类别编号
        ,TRAN_DT  --交易日期
        ,TRAN_ORG_ID  --交易机构编号
        ,DEBIT_CRDT_FLG  --借贷标志
        ,TRAN_CURR_CD  --交易币种代码
        ,TRAN_CD  --交易码
        ,TRAN_DESCB  --交易描述
        ,BEF_TRAN_BAL  --交易前余额
        ,TRAN_AMT  --交易金额
        ,ACTL_BAL  --实际余额
        ,TRAN_KIND_CD  --交易种类代码
        ,CNTPTY_TRAN_REF_NO  --交易对手交易参考号
        ,CNTPTY_ACCT_ID  --交易对手账户编号
        ,CNTPTY_CUST_ACCT_NUM  --交易对手客户账号
        ,CNTPTY_ACCT_CURR_CD  --交易对手账户币种代码
        ,CNTPTY_SUB_ACCT_NUM  --交易对手子账号
        ,CAP_FROZ_FLOW_NUM  --资金冻结流水号
        ,CNTPTY_ACCT_PROD_ID  --交易对手账户产品编号
        ,CNTPTY_ACCT_NAME  --交易对手账户名称
        ,CNTPTY_UNIONPAY_NUM  --交易对手银联号
        ,CNTPTY_BANK_NAME  --交易对手银行名称
        ,CNTPTY_OPEN_ACCT_ORG_ID  --交易对手开户机构编号
        ,REAL_CNTPTY_FIN_INST_ID  --真实交易对手金融机构编号
        ,REAL_CNTPTY_FIN_INST_NAME  --交易对手行名
        ,REAL_CNTPTY_ACCT_TYPE_CD  --真实交易对手账户类型代码
        ,REAL_CNTPTY_ACCT_ID  --真实交易对手账户编号
        ,CNTPTY_CURR_CD  --交易对手币种代码
        ,BEGIN_CURR_CD  --起始币种代码
        ,CNTPTY_TRAN_FLOW_NUM  --交易对手交易流水号
        ,AIM_CURR_CD  --目的币种代码
        ,BUY_AMT  --买入金额
        ,SELL_AMT  --卖出金额
        ,VOUCH_TYPE_CD  --凭证类型代码
        ,VOUCH_NO  --凭证号码
        ,CASH_PROJ_CD  --现金项目代码
        ,AMT_CALC_TYPE_CD  --金额计算类型代码
        ,CHN_ID  --渠道编号
        ,AMT_TYPE_CD  --金额类型代码
        ,BAL_TYPE_CD  --钞汇余额代码
        ,BASE_EQUVL_AMT  --基础等值金额
        ,OFFSET_EXCH_RAT  --平盘汇率
        ,CROSS_EXCH_RAT  --交叉汇率
        ,BUYER_EXCH_RAT_CLS_CD  --买方汇率分类代码
        ,BUYER_EXCH_RAT_VAL  --买方汇率值
        ,ACTL_CROSS_EXCH_RAT  --实际交叉汇率
        ,SELLER_EXCH_RAT_CLS_CD  --卖方汇率分类代码
        ,SELLER_EXCH_RAT_VAL  --卖方汇率值
        ,INTER_BUS_TYPE_CD  --中间业务类型代码
        ,FINC_TYPE_CD  --理财类型代码
        ,QUOT_TYPE_CD  --牌价类型代码
        ,MED_FLG  --介质标志
        ,MED_TYPE_CD  --介质类型代码
        ,BUS_CLS_CD  --业务分类代码
        ,CNTPTY_CERT_TYPE_CD  --交易对手证件类型代码
        ,ATTACH_RGST_DEP_FLG  --补登存标志
        ,MAIN_EVT_CLS_CD  --主事件分类代码
        ,EXCH_RAT_TYPE_CD  --汇率类型代码
        ,AVL_WAY_CD  --到账方式代码
        ,WDRAW_WAY_CD  --支取方式代码
        ,BUS_TRAN_BATCH_NO  --业务交易批次号
        ,BANK_TRAN_SEQ_NUM  --银行交易序号
        ,AGENT_TEL_NUM  --代理人电话号码
        ,CUST_NAME  --客户名称
        ,LMT_CODE  --限额编码
        ,CNTPTY_FIN_INST_DIST_CD  --交易对手金融机构行政区划代码
        ,CNTPTY_CERT_NO  --交易对手证件号码
        ,REAL_CNTPTY_FIN_INST_DIST_CD  --真实交易对手金融机构行政区划代码
        ,REAL_CNTPTY_CERT_NO  --真实交易对手证件号码
        ,REAL_CNTPTY_CERT_TYPE_CD  --真实交易对手证件类型代码
        ,TRAN_HAPP_SITE  --交易发生地点
        ,REAL_TRAN_HAPP_SITE  --真实交易发生地点
        ,CNTPTY_NAME  --交易对手名称
        ,REAL_CNTPTY_NAME  --真实交易对手名称
        ,PAYMENT_CORP_NAME  --交款单位名称
        ,PRIOR_LEVEL  --优先等级
        ,SELLER_QUOT_TYPE_CD  --卖方牌价类型代码
        ,CHN_DT  --渠道日期
        ,CUST_ID  --客户编号
        ,CERT_NO  --证件号码
        ,CERT_TYPE_CD  --证件类型代码
        ,BILL_NUM  --票据号码
        ,SOB_CATE_CD  --账套类别代码
        ,TRAN_POSTSC  --交易附言
        ,BUS_PROC_STATUS_CD  --业务处理状态代码
        ,AUTO_REVS_FLG  --自动冲正标志
        ,CNTPTY_EQUVL_AMT  --交易对手等值金额
        ,TRAN_POST_BAL_ADD_FINC  --交易后余额加理财
        ,FREE_SERV_FEE_FLG  --免服务费标志
        ,TRAN_PUBLIC_AGENT_NAME  --交易代办人名称
        ,SRC_MODULE_TYPE_CD  --源模块类型代码
        ,EFFECT_DT  --生效日期
        ,REVS_FLOW_NUM  --冲正流水号
        ,TRAN_TERMN_ID  --交易终端编号
        ,FOLLOW_ID  --跟踪编号
        ,REVS_TRAN_CD  --冲正交易码
        ,REVS_FLG  --冲正标志
        ,REVS_DT  --冲正日期
        ,CLEAR_DT  --清算日期
        ,POST_FLG  --过账标志
        ,MEMO_CODE  --摘要码
        ,TRAN_MEMO_DESCB  --交易摘要描述
        ,CHECK_TELLER_ID  --复核柜员编号
        ,AUTH_TELLER_ID  --授权柜员编号
        ,INIT_TRAN_TM  --原交易时间
        ,TRAN_TM  --交易时间
        ,TRAN_TELLER_ID  --交易柜员编号
        ,BEPS_UNPASEW_FLG  --小额免密标志
        ,BUS_FLOW_NUM  --业务流水号
        ,CHECK_ENTRY_CD  --对账代码
        ,TRAN_ID  --交易编号
        ,PRPERY_SYS_CODE  --来源系统编号
        ,ETL_DT  --ETL处理日期
        ,SRC_TABLE_NAME  --源表名称
        ,JOB_CD  --任务编码
        ,ETL_TIMESTAMP  --ETL处理时间戳
        ,CASH_FROM_CD
        ,CASH_USAGE_CD
        ,CASH_FROM_CTY_RG_CD
        ,CASH_TO_CTY_RG_CD

    )
    SELECT
        EVT_ID  --事件编号
        ,LP_ID  --法人编号
        ,TRAN_FLOW_NUM  --交易流水号
        ,OVA_FLOW_NUM  --全局流水号
        ,CORE_FLOW_NUM  --核心流水号
        ,TRAN_REF_NO  --交易参考号
        ,ACCT_ID  --账户编号
        ,CUST_ACCT_NUM  --客户账号
        ,BUS_PROD_ID  --业务产品编号
        ,ACCT_CURR_CD  --账户币种代码
        ,SUB_ACCT_NUM  --子账号
        ,SUB_ACCT_ID  --子账户编号
        ,ACCT_TYPE_CD  --账户类型代码
        ,ACCT_STATUS_CD  --账户状态代码
        ,VTUAL_ACCT_FLG  --虚户标志
        ,CASH_TRAN_FLG  --现金交易标志
        ,ACCT_NAME  --账户名称
        ,OPEN_ACCT_ORG_ID  --开户机构编号
        ,EVT_CATE_ID  --事件类别编号
        ,TRAN_DT  --交易日期
        ,TRAN_ORG_ID  --交易机构编号
        ,DEBIT_CRDT_FLG  --借贷标志
        ,TRAN_CURR_CD  --交易币种代码
        ,TRAN_CD  --交易码
        ,TRAN_DESCB  --交易描述
        ,BEF_TRAN_BAL  --交易前余额
        ,TRAN_AMT  --交易金额
        ,ACTL_BAL  --实际余额
        ,TRAN_KIND_CD  --交易种类代码
        ,CNTPTY_TRAN_REF_NO  --交易对手交易参考号
        ,CNTPTY_ACCT_ID  --交易对手账户编号
        ,CNTPTY_CUST_ACCT_NUM  --交易对手客户账号
        ,CNTPTY_ACCT_CURR_CD  --交易对手账户币种代码
        ,CNTPTY_SUB_ACCT_NUM  --交易对手子账号
        ,CAP_FROZ_FLOW_NUM  --资金冻结流水号
        ,CNTPTY_ACCT_PROD_ID  --交易对手账户产品编号
        ,CNTPTY_ACCT_NAME  --交易对手账户名称
        ,CNTPTY_UNIONPAY_NUM  --交易对手银联号
        ,CNTPTY_BANK_NAME  --交易对手银行名称
        ,CNTPTY_OPEN_ACCT_ORG_ID  --交易对手开户机构编号
        ,REAL_CNTPTY_FIN_INST_ID  --真实交易对手金融机构编号
        ,REAL_CNTPTY_FIN_INST_NAME  --交易对手行名
        ,REAL_CNTPTY_ACCT_TYPE_CD  --真实交易对手账户类型代码
        ,REAL_CNTPTY_ACCT_ID  --真实交易对手账户编号
        ,CNTPTY_CURR_CD  --交易对手币种代码
        ,BEGIN_CURR_CD  --起始币种代码
        ,CNTPTY_TRAN_FLOW_NUM  --交易对手交易流水号
        ,AIM_CURR_CD  --目的币种代码
        ,BUY_AMT  --买入金额
        ,SELL_AMT  --卖出金额
        ,VOUCH_TYPE_CD  --凭证类型代码
        ,VOUCH_NO  --凭证号码
        ,CASH_PROJ_CD  --现金项目代码
        ,AMT_CALC_TYPE_CD  --金额计算类型代码
        ,CHN_ID  --渠道编号
        ,AMT_TYPE_CD  --金额类型代码
        ,BAL_TYPE_CD  --钞汇余额代码
        ,BASE_EQUVL_AMT  --基础等值金额
        ,OFFSET_EXCH_RAT  --平盘汇率
        ,CROSS_EXCH_RAT  --交叉汇率
        ,BUYER_EXCH_RAT_CLS_CD  --买方汇率分类代码
        ,BUYER_EXCH_RAT_VAL  --买方汇率值
        ,ACTL_CROSS_EXCH_RAT  --实际交叉汇率
        ,SELLER_EXCH_RAT_CLS_CD  --卖方汇率分类代码
        ,SELLER_EXCH_RAT_VAL  --卖方汇率值
        ,INTER_BUS_TYPE_CD  --中间业务类型代码
        ,FINC_TYPE_CD  --理财类型代码
        ,QUOT_TYPE_CD  --牌价类型代码
        ,MED_FLG  --介质标志
        ,MED_TYPE_CD  --介质类型代码
        ,BUS_CLS_CD  --业务分类代码
        ,CNTPTY_CERT_TYPE_CD  --交易对手证件类型代码
        ,ATTACH_RGST_DEP_FLG  --补登存标志
        ,MAIN_EVT_CLS_CD  --主事件分类代码
        ,EXCH_RAT_TYPE_CD  --汇率类型代码
        ,AVL_WAY_CD  --到账方式代码
        ,WDRAW_WAY_CD  --支取方式代码
        ,BUS_TRAN_BATCH_NO  --业务交易批次号
        ,BANK_TRAN_SEQ_NUM  --银行交易序号
        ,AGENT_TEL_NUM  --代理人电话号码
        ,CUST_NAME  --客户名称
        ,LMT_CODE  --限额编码
        ,CNTPTY_FIN_INST_DIST_CD  --交易对手金融机构行政区划代码
        ,CNTPTY_CERT_NO  --交易对手证件号码
        ,REAL_CNTPTY_FIN_INST_DIST_CD  --真实交易对手金融机构行政区划代码
        ,REAL_CNTPTY_CERT_NO  --真实交易对手证件号码
        ,REAL_CNTPTY_CERT_TYPE_CD  --真实交易对手证件类型代码
        ,TRAN_HAPP_SITE  --交易发生地点
        ,REAL_TRAN_HAPP_SITE  --真实交易发生地点
        ,CNTPTY_NAME  --交易对手名称
        ,REAL_CNTPTY_NAME  --真实交易对手名称
        ,PAYMENT_CORP_NAME  --交款单位名称
        ,PRIOR_LEVEL  --优先等级
        ,SELLER_QUOT_TYPE_CD  --卖方牌价类型代码
        ,CHN_DT  --渠道日期
        ,CUST_ID  --客户编号
        ,CERT_NO  --证件号码
        ,CERT_TYPE_CD  --证件类型代码
        ,BILL_NUM  --票据号码
        ,SOB_CATE_CD  --账套类别代码
        ,TRAN_POSTSC  --交易附言
        ,BUS_PROC_STATUS_CD  --业务处理状态代码
        ,AUTO_REVS_FLG  --自动冲正标志
        ,CNTPTY_EQUVL_AMT  --交易对手等值金额
        ,TRAN_POST_BAL_ADD_FINC  --交易后余额加理财
        ,FREE_SERV_FEE_FLG  --免服务费标志
        ,TRAN_PUBLIC_AGENT_NAME  --交易代办人名称
        ,SRC_MODULE_TYPE_CD  --源模块类型代码
        ,EFFECT_DT  --生效日期
        ,REVS_FLOW_NUM  --冲正流水号
        ,TRAN_TERMN_ID  --交易终端编号
        ,FOLLOW_ID  --跟踪编号
        ,REVS_TRAN_CD  --冲正交易码
        ,REVS_FLG  --冲正标志
        ,REVS_DT  --冲正日期
        ,CLEAR_DT  --清算日期
        ,POST_FLG  --过账标志
        ,MEMO_CODE  --摘要码
        ,TRAN_MEMO_DESCB  --交易摘要描述
        ,CHECK_TELLER_ID  --复核柜员编号
        ,AUTH_TELLER_ID  --授权柜员编号
        ,INIT_TRAN_TM  --原交易时间
        ,TRAN_TM  --交易时间
        ,TRAN_TELLER_ID  --交易柜员编号
        ,BEPS_UNPASEW_FLG  --小额免密标志
        ,BUS_FLOW_NUM  --业务流水号
        ,CHECK_ENTRY_CD  --对账代码
        ,TRAN_ID  --交易编号
        ,PRPERY_SYS_CODE  --来源系统编号
        ,ETL_DT  --ETL处理日期
        ,SRC_TABLE_NAME  --源表名称
        ,JOB_CD  --任务编码
        ,ETL_TIMESTAMP  --ETL处理时间戳
        ,CASH_FROM_CD
        ,CASH_USAGE_CD
        ,CASH_FROM_CTY_RG_CD
        ,CASH_TO_CTY_RG_CD
    FROM IML.V_EVT_DEP_FIN_TRAN_FLOW  --视图-存款金融交易流水

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

  END ETL_INIT_O_IML_EVT_DEP_FIN_TRAN_FLOW;
/

