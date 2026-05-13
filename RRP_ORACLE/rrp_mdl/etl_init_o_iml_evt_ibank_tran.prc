CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_IBANK_TRAN(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_evt_ibank_tran
  *  功能描述：同业交易表
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： iml.V_evt_ibank_tran
  *  目标表： O_iml_evt_ibank_tran
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_IML_EVT_IBANK_TRAN'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_iml_evt_ibank_tran ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_iml_evt_ibank_tran';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-同业交易表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_iml_evt_ibank_tran
  (
        ETL_DT  --ETL处理日期
        ,EVT_ID  --事件编号
        ,LP_ID  --法人编号
        ,TRAN_NUM  --交易号
        ,ENTR_DT  --委托日期
        ,ENTR_TM  --委托时间
        ,CFM_DT  --确认日期
        ,CFM_TM  --确认时间
        ,INTNAL_TRAN_NUM  --内部交易号
        ,EXT_TRAN_NUM  --外部交易号
        ,OPERR_NAME  --操作员名称
        ,TRAN_TYPE_ID  --交易类型编号
        ,EXT_CAP_ACCT_ID  --外部资金账户编号
        ,INTNAL_CAP_ACCT_ID  --内部资金账户编号
        ,EXT_SECU_ACCT_ID  --外部证券账户编号
        ,INTNAL_SECU_ACCT_ID  --内部证券账户编号
        ,CNTPTY_ID  --交易对手编号
        ,PRIC_INTNAL_CAP_ACCT_ID  --本金内部资金账户编号
        ,FIN_INSTM_ID  --金融工具编号
        ,ASSET_TYPE_ID  --资产类型编号
        ,TRAN_MARKET_ID  --交易市场编号
        ,FIN_INSTM_NAME  --金融工具名称
        ,TRAN_QTTY  --交易数量
        ,TRAN_PRICE  --交易价格
        ,TRAN_AMT  --交易金额
        ,TRAN_FEE  --交易费用
        ,STL_DT  --结算日期
        ,TRAN_STATUS_CD  --交易状态代码
        ,STL_WAY_CD  --结算方式代码
        ,NET_PRICE_AMT  --净价金额
        ,INT_RECVBL  --应收利息
        ,QUOTE_TRAN_NUM  --引用交易号
        ,IGNORE_FLG  --忽略标志
        ,TRAN_EXEC_MARKET_ID  --交易执行市场编号
        ,AGENT_NAME  --经办人名称
        ,CNTPTY_NAME  --交易对手名称
        ,EVLTION_NET_PRICE_BRKB  --估值净价偏移度
        ,TRAN_SRC_CD  --交易来源代码
        ,DEAL_QTTY  --已成交数量
        ,ACTL_RECV_INT  --实收利息
        ,ACTL_RECV_AMT  --实收金额
        ,DEALER_NAME  --交易员名称
        ,CNTPTY_ZZD_ACCT_ID  --交易对手中债登账户编号
      	,CNTPTY_OPEN_BANK_NUM  --交易对手开户行号
				,CNTPTY_ACCT_NUM  --交易对手账号
				,CNTPTY_OPEN_BANK_NAME  --交易对手开户行名称
				,CNTPTY_ACCT_NAME  --交易对手账户名称
				,CBOND_YLD_RAT  --中债收益率
				,EXP_YLD_RAT  --到期收益率
				,RECVBL_UNCOL_INT  --应收未收利息
				,OPERR_ID  --操作员编号
				,CHECKER_ID  --复核员编号
				,RECVBL_UNCOL_PRIC  --应收未收本金
				,ACTL_INT  --实付利息
				,ACTL_PRIC  --实付本金
				,REF_TYPE_CD  --参考类型代码
				,RECVBL_UNCOL_INT_RESV_FLG  --应收未收利息保留标志
				,RECVBL_UNCOL_PRIC_RESV_FLG  --应收未收本金保留标志
				,DEALER_ID  --交易员编号
				,TRAN_MODE_CD  --交易模式代码
				,CLEAR_MODE_CD  --清算模式代码
				,APV_ODD_NO  --审批单号
				,STL_STATUS_CD  --结算状态代码
				,ACCTI_TRAN_NUM  --核算交易号
				,FTP_INT_RAT  --FTP利率
				,ASSOCED_APV_ODD_NO  --关联的审批单号
				,BI_VALID_CONT_ID  --双边有效合同编号
				,DATA_SRC_CD  --数据来源代码
				,NV_DT  --净值日期
				,CNTPTY_SWIFT_CD  --交易对手SWIFT代码
				,SPLT_TYPE_CD  --拆分类型代码
				,PARENT_TRAN_NUM  --父交易号
				,MAIN_TRAN_NUM  --主交易号
				,MERGE_TRAN_NUM  --合交易号
				,MIRO_TRAN_NUM  --镜像交易号
				,RELA_TRAN_NUM  --关联交易号
				,EX_YLD_RAT  --行权收益率
				,CUST_MGR_NAME  --客户经理名称
				,CUST_MGR_ID  --客户经理编号
				,CAMP_ORG_ID  --营销机构编号
				,REDEM_CFM_DT  --赎回确认日期
				,TRAN_WAY_CD  --转账方式代码
				,DLVY_DT  --交割日期
				,CONT_ID  --合同编号
				,CAP_DIR_DESCB  --资金投向描述
				,FINAL_DIR_TYPE_CD  --最终投向类型代码
				,RELA_SER_NUM  --关联序列号
				,LEVEL5_CLS_CD  --五级分类代码
				,PROD_CHAR_CD  --产品性质代码
				,CURR_LOT  --当前份额
				,UNPAY_TURN_LOT  --未结转份额
				,INPUT_DT  --录入日期
				,DLVY_SITE_ID  --交割场所编号
				,NOT_STL_COMM_FEE  --不结算手续费
				,INT_ACCR_BASE_CD  --计息基准代码
				,CONTN_INT_FLG  --含息标志
				,RELA_PARTY_INFO  --关联方信息
				,REDEM_TYPE_CD  --赎回类型代码
				,STD_PROD_ID  --标准产品编号
				,FTP_ID  --FTP编号
				,IS_TERM  --是否约期
				,TERM_START_DAY  --约期开始日
				,TERM_END_DAY  --约期结束日
				,BANK_CAP_ACCT_OPEN_BANK_NUM  --银行资金账户开户行号
				,BANK_CAP_ACCT_ID  --银行资金账户编号
				,TH_SSN_REDEM_FLG  --当季赎回标志
				,PLAN_REDEM_DT  --计划赎回日期
    )
    SELECT

   				ETL_DT  --ETL处理日期
				,EVT_ID  --事件编号
				,LP_ID  --法人编号
				,TRAN_NUM  --交易号
				,ENTR_DT  --委托日期
				,ENTR_TM  --委托时间
				,CFM_DT  --确认日期
				,CFM_TM  --确认时间
				,INTNAL_TRAN_NUM  --内部交易号
				,EXT_TRAN_NUM  --外部交易号
				,OPERR_NAME  --操作员名称
				,TRAN_TYPE_ID  --交易类型编号
				,EXT_CAP_ACCT_ID  --外部资金账户编号
				,INTNAL_CAP_ACCT_ID  --内部资金账户编号
				,EXT_SECU_ACCT_ID  --外部证券账户编号
				,INTNAL_SECU_ACCT_ID  --内部证券账户编号
				,CNTPTY_ID  --交易对手编号
				,PRIC_INTNAL_CAP_ACCT_ID  --本金内部资金账户编号
				,FIN_INSTM_ID  --金融工具编号
				,ASSET_TYPE_ID  --资产类型编号
				,TRAN_MARKET_ID  --交易市场编号
				,FIN_INSTM_NAME  --金融工具名称
				,TRAN_QTTY  --交易数量
				,TRAN_PRICE  --交易价格
				,TRAN_AMT  --交易金额
				,TRAN_FEE  --交易费用
				,STL_DT  --结算日期
				,TRAN_STATUS_CD  --交易状态代码
				,STL_WAY_CD  --结算方式代码
				,NET_PRICE_AMT  --净价金额
				,INT_RECVBL  --应收利息
				,QUOTE_TRAN_NUM  --引用交易号
				,IGNORE_FLG  --忽略标志
				,TRAN_EXEC_MARKET_ID  --交易执行市场编号
				,AGENT_NAME  --经办人名称
				,CNTPTY_NAME  --交易对手名称
				,EVLTION_NET_PRICE_BRKB  --估值净价偏移度
				,TRAN_SRC_CD  --交易来源代码
				,DEAL_QTTY  --已成交数量
				,ACTL_RECV_INT  --实收利息
				,ACTL_RECV_AMT  --实收金额
				,DEALER_NAME  --交易员名称
				,CNTPTY_ZZD_ACCT_ID  --交易对手中债登账户编号
				,CNTPTY_OPEN_BANK_NUM  --交易对手开户行号
				,CNTPTY_ACCT_NUM  --交易对手账号
				,CNTPTY_OPEN_BANK_NAME  --交易对手开户行名称
				,CNTPTY_ACCT_NAME  --交易对手账户名称
				,CBOND_YLD_RAT  --中债收益率
				,EXP_YLD_RAT  --到期收益率
				,RECVBL_UNCOL_INT  --应收未收利息
				,OPERR_ID  --操作员编号
				,CHECKER_ID  --复核员编号
				,RECVBL_UNCOL_PRIC  --应收未收本金
				,ACTL_INT  --实付利息
				,ACTL_PRIC  --实付本金
				,REF_TYPE_CD  --参考类型代码
				,RECVBL_UNCOL_INT_RESV_FLG  --应收未收利息保留标志
				,RECVBL_UNCOL_PRIC_RESV_FLG  --应收未收本金保留标志
				,DEALER_ID  --交易员编号
				,TRAN_MODE_CD  --交易模式代码
				,CLEAR_MODE_CD  --清算模式代码
				,APV_ODD_NO  --审批单号
				,STL_STATUS_CD  --结算状态代码
				,ACCTI_TRAN_NUM  --核算交易号
				,FTP_INT_RAT  --FTP利率
				,ASSOCED_APV_ODD_NO  --关联的审批单号
				,BI_VALID_CONT_ID  --双边有效合同编号
				,DATA_SRC_CD  --数据来源代码
				,NV_DT  --净值日期
				,CNTPTY_SWIFT_CD  --交易对手SWIFT代码
				,SPLT_TYPE_CD  --拆分类型代码
				,PARENT_TRAN_NUM  --父交易号
				,MAIN_TRAN_NUM  --主交易号
				,MERGE_TRAN_NUM  --合交易号
				,MIRO_TRAN_NUM  --镜像交易号
				,RELA_TRAN_NUM  --关联交易号
				,EX_YLD_RAT  --行权收益率
				,CUST_MGR_NAME  --客户经理名称
				,CUST_MGR_ID  --客户经理编号
				,CAMP_ORG_ID  --营销机构编号
				,REDEM_CFM_DT  --赎回确认日期
				,TRAN_WAY_CD  --转账方式代码
				,DLVY_DT  --交割日期
				,CONT_ID  --合同编号
				,CAP_DIR_DESCB  --资金投向描述
				,FINAL_DIR_TYPE_CD  --最终投向类型代码
				,RELA_SER_NUM  --关联序列号
				,LEVEL5_CLS_CD  --五级分类代码
				,PROD_CHAR_CD  --产品性质代码
				,CURR_LOT  --当前份额
				,UNPAY_TURN_LOT  --未结转份额
				,INPUT_DT  --录入日期
				,DLVY_SITE_ID  --交割场所编号
				,NOT_STL_COMM_FEE  --不结算手续费
				,INT_ACCR_BASE_CD  --计息基准代码
				,CONTN_INT_FLG  --含息标志
				,RELA_PARTY_INFO  --关联方信息
				,REDEM_TYPE_CD  --赎回类型代码
				,STD_PROD_ID  --标准产品编号
				,FTP_ID  --FTP编号
				,IS_TERM  --是否约期
				,TERM_START_DAY  --约期开始日
				,TERM_END_DAY  --约期结束日
				,BANK_CAP_ACCT_OPEN_BANK_NUM  --银行资金账户开户行号
				,BANK_CAP_ACCT_ID  --银行资金账户编号
				,TH_SSN_REDEM_FLG  --当季赎回标志
				,PLAN_REDEM_DT  --计划赎回日期
    FROM IML.V_EVT_IBANK_TRAN  --视图-同业交易表
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

  END ETL_INIT_O_IML_evt_ibank_tran;
/

