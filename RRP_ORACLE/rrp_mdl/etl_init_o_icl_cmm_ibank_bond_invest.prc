CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_IBANK_BOND_INVEST(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_IBANK_BOND_INVEST
  *  功能描述：同业债券投资
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_IBANK_BOND_INVEST
  *  目标表： O_ICL_CMM_IBANK_BOND_INVEST
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_IBANK_BOND_INVEST'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_IBANK_BOND_INVEST ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_IBANK_BOND_INVEST';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-同业债券投资';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_IBANK_BOND_INVEST
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,EXT_SECU_ACCT_ID  --外部证券账户编号
      ,INTNAL_SECU_ACCT_ID  --内部证券账户编号
      ,FIN_INSTM_ID  --金融工具编号
      ,ASSET_TYPE_ID  --资产类型编号
      ,STD_PROD_ID  --标准产品编号
      ,MARKET_TYPE_ID  --市场类型编号
      ,BUS_ID  --业务编号
      ,PROD_TYPE_CD  --产品类型代码
      ,ASSET_TYPE_NAME  --资产类型名称
      ,ACCT_NAME  --账户名称
      ,BOND_NAME  --债券名称
      ,CONVBL_BOND_FLG  --可转债标志
      ,SUB_DEBT_FLG  --次级债标志
      ,ABS_FLG  --ABS标志
      ,SUBJ_ID  --科目编号
      ,TRAN_MARKET_ID  --交易市场编号
      ,EXCHG_ACCT_ID  --交易所账户编号
      ,ISSUER_ID  --发行人编号
      ,ISSUER_NAME  --发行人名称
      ,GUARTOR_NAME  --担保人名称
      ,PAYOFF_LEVEL_CD  --清偿等级代码
      ,ISSUE_DT  --发行日期
      ,VALUE_DT  --起息日期
      ,EXP_DT  --到期日期
      ,TENOR_CD  --期限代码
      ,BASE_RAT_ID  --基准利率编号
      ,INT_ACCR_BASE_CD  --计息基准代码
      ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
      ,ISSUE_WAY_CD  --发行方式代码
      ,EX_TYPE_CD  --行权类型代码
      ,FIR_EX_DT  --首个行权日期
      ,FIR_EX_PRICE  --首个行权价格
      ,FIR_COMPST_INT_RAT  --首个补偿利率
      ,CTY_CD  --国家代码
      ,CURR_CD  --币种代码
      ,FAC_VAL_AMT  --票面金额
      ,FAC_VAL_INT_RAT  --票面利率
      ,PAY_INT_PED_CD  --付息周期代码
      ,INT_ACCR_PED_CD  --计息周期代码
      ,RESET_PED_CD  --重置周期代码
      ,HOLD_POS  --持有仓位
      ,HOLD_FAC_VAL  --持有面值
      ,PRIC_BAL  --本金余额
      ,ACRU_INT  --应计利息
      ,RECVBL_UNCOL_PRIC  --应收未收本金
      ,RECVBL_UNCOL_INT  --应收未收利息
      ,INT_ADJ_AMT  --利息调整金额
      ,EVHA_VAL_CHAG  --公允价值变动
      ,ACTL_INT_RAT  --实际利率
      ,LAST_UPDATE_DT  --上次更新日期
      ,CAP_TYPE_CD  --资金类型代码
      ,ASSET_FOUR_CLS_CD  --资产四分类代码
      ,BELONG_ORG_ID  --所属机构编号
      ,OBJ_ID  --对象编号
      ,INT_SUBJ_ID  --利息科目编号
      ,INT_ADJ_SUBJ_ID  --利息调整科目编号
      ,BASE_RAT_ASSET_TYPE_ID  --基准利率资产类型编号
      ,BASE_RAT_MARKET_TYPE_ID  --基准利率市场类型编号
      ,BASE_RAT  --基准利率
      ,FAIR_VAL_PL  --公允价值损益
      ,ASSET_THD_CLS_CD  --资产三分类代码
      ,CBOND_FULL_PRICE_EVLTION  --中债全价估值
      ,CBOND_NET_PRICE_EVLTION  --中债净价估值
      ,ESTIM_CORET_DURAN  --估价修正久期
      ,BP_VAL  --基点价值
      ,ESTIM_CVTY  --估价凸性
      ,ESTIM_YLD_RAT  --估价收益率
      ,BOOK_BAL  --账面余额
      ,INT_RECVBL  --应收利息
      ,COMB_TRAN_NUM  --组合交易号
      ,CURRT_BAL  --当期余额
      ,CSECU_FULL_PRICE_EVLTION  --中证全价估值
      ,CSECU_NET_PRICE_EVLTION  --中证净价估值
      ,CSECU_CORET_DURAN  --中证修正久期
      ,CSECU_BP_VAL  --中证基点价值
      ,CSECU_ESTIM_CVTY  --中证估价凸性
      ,EXTRA_DIMEN_CD  --额外维度代码
      ,STL_DT  --结算日期
      ,OVDUE_STATUS  --逾期状态
      ,OVDUE_FLG  --逾期标志
      ,PRIC_OVDUE_DT  --本金逾期日期
      ,PRIC_OVDUE_DAYS  --本金逾期天数
      ,INT_OVDUE_DT  --利息逾期日期
      ,INT_OVDUE_DAYS  --利息逾期天数
      ,ISSUER_CUST_ID  --发行人客户编号
    ,JOB_CD --任务代码
    )
    SELECT
      /*+ PARALLEL */
      TO_DATE(V_P_DATE,'YYYYMMDD')  --数据日期
      ,LP_ID  --法人编号
      ,EXT_SECU_ACCT_ID  --外部证券账户编号
      ,INTNAL_SECU_ACCT_ID  --内部证券账户编号
      ,FIN_INSTM_ID  --金融工具编号
      ,ASSET_TYPE_ID  --资产类型编号
      ,STD_PROD_ID  --标准产品编号
      ,MARKET_TYPE_ID  --市场类型编号
      ,BUS_ID  --业务编号
      ,PROD_TYPE_CD  --产品类型代码
      ,ASSET_TYPE_NAME  --资产类型名称
      ,ACCT_NAME  --账户名称
      ,BOND_NAME  --债券名称
      ,CONVBL_BOND_FLG  --可转债标志
      ,SUB_DEBT_FLG  --次级债标志
      ,ABS_FLG  --ABS标志
      ,SUBJ_ID  --科目编号
      ,TRAN_MARKET_ID  --交易市场编号
      ,EXCHG_ACCT_ID  --交易所账户编号
      ,ISSUER_ID  --发行人编号
      ,ISSUER_NAME  --发行人名称
      ,GUARTOR_NAME  --担保人名称
      ,PAYOFF_LEVEL_CD  --清偿等级代码
      ,ISSUE_DT  --发行日期
      ,VALUE_DT  --起息日期
      ,EXP_DT  --到期日期
      ,TENOR_CD  --期限代码
      ,BASE_RAT_ID  --基准利率编号
      ,INT_ACCR_BASE_CD  --计息基准代码
      ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
      ,ISSUE_WAY_CD  --发行方式代码
      ,EX_TYPE_CD  --行权类型代码
      ,FIR_EX_DT  --首个行权日期
      ,FIR_EX_PRICE  --首个行权价格
      ,FIR_COMPST_INT_RAT  --首个补偿利率
      ,CTY_CD  --国家代码
      ,CURR_CD  --币种代码
      ,FAC_VAL_AMT  --票面金额
      ,FAC_VAL_INT_RAT  --票面利率
      ,PAY_INT_PED_CD  --付息周期代码
      ,INT_ACCR_PED_CD  --计息周期代码
      ,RESET_PED_CD  --重置周期代码
      ,HOLD_POS  --持有仓位
      ,HOLD_FAC_VAL  --持有面值
      ,PRIC_BAL  --本金余额
      ,ACRU_INT  --应计利息
      ,RECVBL_UNCOL_PRIC  --应收未收本金
      ,RECVBL_UNCOL_INT  --应收未收利息
      ,INT_ADJ_AMT  --利息调整金额
      ,EVHA_VAL_CHAG  --公允价值变动
      ,ACTL_INT_RAT  --实际利率
      ,LAST_UPDATE_DT  --上次更新日期
      ,CAP_TYPE_CD  --资金类型代码
      ,ASSET_FOUR_CLS_CD  --资产四分类代码
      ,BELONG_ORG_ID  --所属机构编号
      ,OBJ_ID  --对象编号
      ,INT_SUBJ_ID  --利息科目编号
      ,INT_ADJ_SUBJ_ID  --利息调整科目编号
      ,BASE_RAT_ASSET_TYPE_ID  --基准利率资产类型编号
      ,BASE_RAT_MARKET_TYPE_ID  --基准利率市场类型编号
      ,BASE_RAT  --基准利率
      ,FAIR_VAL_PL  --公允价值损益
      ,ASSET_THD_CLS_CD  --资产三分类代码
      ,CBOND_FULL_PRICE_EVLTION  --中债全价估值
      ,CBOND_NET_PRICE_EVLTION  --中债净价估值
      ,ESTIM_CORET_DURAN  --估价修正久期
      ,BP_VAL  --基点价值
      ,ESTIM_CVTY  --估价凸性
      ,ESTIM_YLD_RAT  --估价收益率
      ,BOOK_BAL  --账面余额
      ,INT_RECVBL  --应收利息
      ,COMB_TRAN_NUM  --组合交易号
      ,CURRT_BAL  --当期余额
      ,CSECU_FULL_PRICE_EVLTION  --中证全价估值
      ,CSECU_NET_PRICE_EVLTION  --中证净价估值
      ,CSECU_CORET_DURAN  --中证修正久期
      ,CSECU_BP_VAL  --中证基点价值
      ,CSECU_ESTIM_CVTY  --中证估价凸性
      ,EXTRA_DIMEN_CD  --额外维度代码
      ,STL_DT  --结算日期
      ,OVDUE_STATUS  --逾期状态
      ,OVDUE_FLG  --逾期标志
      ,PRIC_OVDUE_DT  --本金逾期日期
      ,PRIC_OVDUE_DAYS  --本金逾期天数
      ,INT_OVDUE_DT  --利息逾期日期
      ,INT_OVDUE_DAYS  --利息逾期天数
      ,ISSUER_CUST_ID  --发行人客户编号
    ,JOB_CD --任务代码
    /*FROM ICL.V_CMM_IBANK_BOND_INVEST  --视图-同业债券投资
    */
    FROM (SELECT /*+ PARALLEL */
    ROW_NUMBER() OVER(PARTITION BY OBJ_ID ORDER BY A.ETL_DT DESC) RN,A.*
            FROM ICL.V_CMM_IBANK_BOND_INVEST A
           WHERE TRUNC(ETL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')) --同业债券投资_视图
    WHERE RN = 1 --按照日期取最新一条，因为源系统当债券余额为0时第二天就不提供了

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

  END ETL_INIT_O_ICL_CMM_IBANK_BOND_INVEST;
/

