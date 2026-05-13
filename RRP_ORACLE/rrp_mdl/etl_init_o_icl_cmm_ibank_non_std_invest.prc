CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_IBANK_NON_STD_INVEST(I_P_DATE IN INTEGER,
                                                               O_ERRCODE OUT VARCHAR2
                                                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_IBANK_NON_STD_INVEST
  *  功能描述：同业非标投资
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_IBANK_NON_STD_INVEST
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20231109  HULJ     优化O层
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_IBANK_NON_STD_INVEST'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME  VARCHAR2(50);
  V_PART_NAME VARCHAR2(200); --分区名
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'O_ICL_CMM_IBANK_NON_STD_INVEST'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_ICL_CMM_IBANK_NON_STD_INVEST T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE O_ICL_CMM_IBANK_NON_STD_INVEST';
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-同业非标投资';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST
    (ETL_DT  --数据日期
    ,LP_ID  --法人编号
    ,EXT_SECU_ACCT_ID  --外部证券账户编号
    ,INTNAL_SECU_ACCT_ID  --内部证券账户编号
    ,FIN_INSTM_ID  --金融工具编号
    ,ASSET_TYPE_ID  --资产类型编号
    ,STD_PROD_ID  --标准产品编号
    ,MARKET_TYPE_ID  --市场类型编号
    ,BUS_ID  --业务编号
    ,COMB_TRAN_NUM  --组合交易号
    ,OBJ_ID  --对象编号
    ,PROD_TYPE_CD  --产品类型代码
    ,ASSET_TYPE_NAME  --资产类型名称
    ,CLASS_CRDT_FLG  --类信贷标志
    ,ABS_FLG  --ABS标志
    ,LEVEL5_CLS_CD  --五级分类代码
    ,ACCT_NAME  --账户名称
    ,SUBJ_ID  --科目编号
    ,INT_SUBJ_ID  --利息科目编号
    ,INT_ADJ_SUBJ_ID  --利息调整科目编号
    ,TRAN_MARKET_ID  --交易市场编号
    ,EXCHG_ACCT_ID  --交易所账户编号
    ,CNTPTY_CUST_ID  --交易对手客户编号
    ,CNTPTY_ID  --交易对手编号
    ,CNTPTY_NAME  --交易对手名称
    ,CNTPTY_CLS_DESCB  --交易对手分类描述
    ,BANK_FLG  --银行标志
    ,CTY_CD  --国家代码
    ,VALUE_DT  --起息日期
    ,EXP_DT  --到期日期
    ,TENOR_CD  --期限代码
    ,INT_ACCR_BASE_CD  --计息基准代码
    ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
    ,APV_ODD_NO  --审批单号
    ,CURR_CD  --币种代码
    ,FAC_VAL_AMT  --票面金额
    ,FAC_VAL_INT_RAT  --票面利率
    ,PAY_INT_PED_CD  --付息周期代码
    ,AUTO_REDT_FLG  --自动转存标志
    ,ACTL_QTTY  --实际数量
    ,ACTL_BAL  --实际余额
    ,PRIC_BAL  --本金余额
    ,CURRT_BAL  --当期余额
    ,ACRU_INT  --应计利息
    ,INT_RECVBL  --应收利息
    ,RECVBL_UNCOL_PRIC  --应收未收本金
    ,RECVBL_UNCOL_INT  --应收未收利息
    ,INT_ADJ_AMT  --利息调整金额
    ,EVHA_VAL_CHAG  --公允价值变动
    ,NV_PROD_FLG  --净值产品标志
    ,BASE_RAT  --基准利率
    ,SPD  --利差
    ,BASE_RAT_MULT  --基准利率倍数
    ,TD_NV  --当日净值
    ,BOOK_BAL  --账面余额
    ,CURR_BAL  --当前余额
    ,LAST_UPDATE_DT  --上次更新日期
    ,CAP_TYPE_CD  --资金类型代码
    ,ASSET_FOUR_CLS_CD  --资产四分类代码
    ,ASSET_THD_CLS_CD  --资产三分类代码
    ,BELONG_ORG_ID  --所属机构编号
    ,UDER_DIR_INDUS_CATEGY_CD  --底层资产投向行业门类代码
    ,UDER_BOND_CD  --底层债券代码
    ,UDER_BOND_NAME  --底层债券名称
    ,UDER_BOND_FLG  --底层债券标志
    ,UDER_ASSET_TYPE_ID  --底层资产类型编号
    ,UDER_BOND_RATING_REST_CD  --底层债券评级结果代码
    ,UDER_ACTL_FINER_NAME  --底层实际融资人名称
    ,UDER_POST_DENOM  --底层持仓面额
    ,UDER_ACTL_FINER_CUST_ID  --底层实际融资人客户编号
    ,UDER_ACTL_FINER_GROUP  --底层实际融资人所属集团
    ,UDER_ACTL_FINER_CUST_CHAR  --底层实际融资人客户性质
    ,UDER_COLL_WAY_CD  --底层募集方式代码
    ,UDER_CBOND_ESTIM_FULL_PRICE  --底层中债估价全价
    ,UDER_CBOND_ESTIM_NET_PRICE  --底层中债估价净价
    ,UDER_CSECU_FULL_PRICE_EVLTION  --底层中证全价估值
    ,UDER_CSECU_NET_PRICE_EVLTION  --底层中证净价估值
    ,UDER_CSECU_CORET_DURAN  --底层中证修正久期
    ,UDER_CSECU_BP_VAL  --底层中证基点价值
    ,UDER_CSECU_ESTIM_CVTY  --底层中证估价凸性
    ,UDER_ESTIM_CORET_DURAN  --底层估价修正久期
    ,UDER_BP_VAL  --底层基点价值
    ,UDER_ESTIM_CVTY  --底层估价凸性
    ,FINAL_DIR_TYPE_CD  --最终投向类型代码
    ,FINAL_DIR_INDUS_GEN  --最终投向行业_大类
    ,FINAL_DIR_INDUS_SUBCLASS  --最终投向行业_细类
    ,DIR_IND_FUND_PART  --投向产业基金的部分
    ,DIR_DEBT_EQTY_PART  --投向债转股的部分
    ,DIR_PE_PART  --投向私募股权投资基金的部分
    ,DIR_PAM_PROD_PART  --投向私募资产管理产品的部分
    ,TRAN_AMT  --交易金额
    ,EXTRA_DIMEN_CD  --额外维度代码
    ,STL_DT  --结算日期
    ,OVDUE_STATUS  --逾期状态
    ,OVDUE_FLG  --逾期标志
    ,PRIC_OVDUE_DT  --本金逾期日期
    ,PRIC_OVDUE_DAYS  --本金逾期天数
    ,INT_OVDUE_DT  --利息逾期日期
    ,INT_OVDUE_DAYS  --利息逾期天数
    ,IN_OUT_TAB_FLG_CD  --表内外标志代码
    ,PRIC_OVDUE_FLG  --本金逾期标志
    ,INT_OVDUE_FLG  --利息逾期标志
    ,JOB_CD --任务代码
    )
  SELECT TO_DATE(V_P_DATE,'YYYYMMDD') AS ETL_DT  --数据日期
        ,LP_ID  --法人编号
        ,EXT_SECU_ACCT_ID  --外部证券账户编号
        ,INTNAL_SECU_ACCT_ID  --内部证券账户编号
        ,FIN_INSTM_ID  --金融工具编号
        ,ASSET_TYPE_ID  --资产类型编号
        ,STD_PROD_ID  --标准产品编号
        ,MARKET_TYPE_ID  --市场类型编号
        ,BUS_ID  --业务编号
        ,COMB_TRAN_NUM  --组合交易号
        ,OBJ_ID  --对象编号
        ,PROD_TYPE_CD  --产品类型代码
        ,ASSET_TYPE_NAME  --资产类型名称
        ,CLASS_CRDT_FLG  --类信贷标志
        ,ABS_FLG  --ABS标志
        ,LEVEL5_CLS_CD  --五级分类代码
        ,ACCT_NAME  --账户名称
        ,SUBJ_ID  --科目编号
        ,INT_SUBJ_ID  --利息科目编号
        ,INT_ADJ_SUBJ_ID  --利息调整科目编号
        ,TRAN_MARKET_ID  --交易市场编号
        ,EXCHG_ACCT_ID  --交易所账户编号
        ,CNTPTY_CUST_ID  --交易对手客户编号
        ,CNTPTY_ID  --交易对手编号
        ,CNTPTY_NAME  --交易对手名称
        ,CNTPTY_CLS_DESCB  --交易对手分类描述
        ,BANK_FLG  --银行标志
        ,CTY_CD  --国家代码
        ,VALUE_DT  --起息日期
        ,EXP_DT  --到期日期
        ,TENOR_CD  --期限代码
        ,INT_ACCR_BASE_CD  --计息基准代码
        ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
        ,APV_ODD_NO  --审批单号
        ,CURR_CD  --币种代码
        ,FAC_VAL_AMT  --票面金额
        ,FAC_VAL_INT_RAT  --票面利率
        ,PAY_INT_PED_CD  --付息周期代码
        ,AUTO_REDT_FLG  --自动转存标志
        ,ACTL_QTTY  --实际数量
        ,CASE WHEN ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN ACTL_BAL
         ELSE 0 END ACTL_BAL  --实际余额
        ,PRIC_BAL  --本金余额
        ,CURRT_BAL  --当期余额
        ,ACRU_INT  --应计利息
        ,INT_RECVBL  --应收利息
        ,RECVBL_UNCOL_PRIC  --应收未收本金
        ,RECVBL_UNCOL_INT  --应收未收利息
        ,INT_ADJ_AMT  --利息调整金额
        ,EVHA_VAL_CHAG  --公允价值变动
        ,NV_PROD_FLG  --净值产品标志
        ,BASE_RAT  --基准利率
        ,SPD  --利差
        ,BASE_RAT_MULT  --基准利率倍数
        ,TD_NV  --当日净值
        ,CASE WHEN ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN BOOK_BAL
         ELSE 0 END BOOK_BAL  --账面余额
        ,CASE WHEN ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN CURR_BAL
         ELSE 0 END  CURR_BAL  --当前余额
        ,LAST_UPDATE_DT  --上次更新日期
        ,CAP_TYPE_CD  --资金类型代码
        ,ASSET_FOUR_CLS_CD  --资产四分类代码
        ,ASSET_THD_CLS_CD  --资产三分类代码
        ,BELONG_ORG_ID  --所属机构编号
        ,UDER_DIR_INDUS_CATEGY_CD  --底层资产投向行业门类代码
        ,UDER_BOND_CD  --底层债券代码
        ,UDER_BOND_NAME  --底层债券名称
        ,UDER_BOND_FLG  --底层债券标志
        ,UDER_ASSET_TYPE_ID  --底层资产类型编号
        ,UDER_BOND_RATING_REST_CD  --底层债券评级结果代码
        ,UDER_ACTL_FINER_NAME  --底层实际融资人名称
        ,UDER_POST_DENOM  --底层持仓面额
        ,UDER_ACTL_FINER_CUST_ID  --底层实际融资人客户编号
        ,UDER_ACTL_FINER_GROUP  --底层实际融资人所属集团
        ,UDER_ACTL_FINER_CUST_CHAR  --底层实际融资人客户性质
        ,UDER_COLL_WAY_CD  --底层募集方式代码
        ,UDER_CBOND_ESTIM_FULL_PRICE  --底层中债估价全价
        ,UDER_CBOND_ESTIM_NET_PRICE  --底层中债估价净价
        ,UDER_CSECU_FULL_PRICE_EVLTION  --底层中证全价估值
        ,UDER_CSECU_NET_PRICE_EVLTION  --底层中证净价估值
        ,UDER_CSECU_CORET_DURAN  --底层中证修正久期
        ,UDER_CSECU_BP_VAL  --底层中证基点价值
        ,UDER_CSECU_ESTIM_CVTY  --底层中证估价凸性
        ,UDER_ESTIM_CORET_DURAN  --底层估价修正久期
        ,UDER_BP_VAL  --底层基点价值
        ,UDER_ESTIM_CVTY  --底层估价凸性
        ,FINAL_DIR_TYPE_CD  --最终投向类型代码
        ,FINAL_DIR_INDUS_GEN  --最终投向行业_大类
        ,FINAL_DIR_INDUS_SUBCLASS  --最终投向行业_细类
        ,DIR_IND_FUND_PART  --投向产业基金的部分
        ,DIR_DEBT_EQTY_PART  --投向债转股的部分
        ,DIR_PE_PART  --投向私募股权投资基金的部分
        ,DIR_PAM_PROD_PART  --投向私募资产管理产品的部分
        ,TRAN_AMT  --交易金额
        ,EXTRA_DIMEN_CD  --额外维度代码
        ,STL_DT  --结算日期
        ,OVDUE_STATUS  --逾期状态
        ,OVDUE_FLG  --逾期标志
        ,PRIC_OVDUE_DT  --本金逾期日期
        ,PRIC_OVDUE_DAYS  --本金逾期天数
        ,INT_OVDUE_DT  --利息逾期日期
        ,INT_OVDUE_DAYS  --利息逾期天数
        ,IN_OUT_TAB_FLG_CD  --表内外标志代码
        ,PRIC_OVDUE_FLG  --本金逾期标志
        ,INT_OVDUE_FLG  --利息逾期标志
        ,JOB_CD --任务代码
    /*FROM ICL.V_CMM_IBANK_NON_STD_INVEST  --视图-同业非标投资
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
    FROM (SELECT /*+ PARALLEL */ROW_NUMBER() OVER(PARTITION BY OBJ_ID ORDER BY A.ETL_DT DESC) RN,A.*
            FROM RRP_MDL.O_ICL_CMM_IBANK_NON_STD_INVEST_20231117/*@LINK_EDW*/ A
           WHERE TRUNC(A.ETL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
             AND A.ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD'))--视图-同业非标投资
    WHERE RN = 1; --取当月的数据，按照日期取最新一条，因为源系统当债券余额为0时第二天就不提供了，为了能与当月发生额关联上翟若平说用这个逻辑

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

END ETL_INIT_O_ICL_CMM_IBANK_NON_STD_INVEST;
/

