CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_IBANK_SECU_POST(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_IBANK_SECU_POST
  *  功能描述：同业证券持仓
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_IBANK_SECU_POST
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20231109  HULJ     优化O层\
  *             3    20231117  HYF      新增资产唯一标识编号
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(200);              --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_ICL_CMM_IBANK_SECU_POST'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_IBANK_SECU_POST'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_IBANK_SECU_POST T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_IBANK_SECU_POST';
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
  V_STEP_DESC := '数据落地-同业证券持仓';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_IBANK_SECU_POST
    (ETL_DT                      --数据日期
    ,LP_ID                       --法人编号
    ,EXT_SECU_ACCT_ID            --外部证券账户编号
    ,INTNAL_SECU_ACCT_ID         --内部证券账户编号
    ,FIN_INSTM_ID                --金融工具编号
    ,ASSET_TYPE_ID               --资产类型编号
    ,STD_PROD_ID                 --标准产品编号
    ,MARKET_TYPE_ID              --市场类型编号
    ,BUS_ID                      --业务编号
    ,PROD_TYPE_CD                --产品类型代码
    ,ASSET_TYPE_NAME             --资产类型名称
    ,LEVEL5_CLS_CD               --五级分类代码
    ,SUBJ_ID                     --科目编号
    ,ACCT_NAME                   --账户名称
    ,TRAN_MARKET_ID              --交易市场编号
    ,EXCHG_ACCT_ID               --交易所账户编号
    ,ISSUER_ID                   --发行人编号
    ,ISSUER_NAME                 --发行人名称
    ,STL_SITE_ID                 --结算场所编号
    ,STL_SITE_NAME               --结算场所名称
    ,TRAN_NUM                    --交易号
    ,EXTRA_DIMEN_CD              --额外维度代码
    ,CURR_CD                     --币种代码
    ,ACTL_QTTY                   --实际数量
    ,ACTL_BAL                    --实际余额
    ,NET_PRICE_COST              --净价成本
    ,ACRU_INT                    --应计利息
    ,INT_COST                    --利息成本
    ,EVHA_VAL_CHAG               --公允价值变动
    ,RECVBL_UNCOL_BAL            --应收未收余额
    ,RECVBL_UNCOL_NET_PRICE_COST --应收未收净价成本
    ,RECVBL_UNCOL_ACRU_INT       --应收未收应计利息
    ,INT_ADJ_AMT                 --利息调整金额
    ,ACTL_INT_RAT                --实际利率
    ,INVEST_YLD_RAT              --投资收益率
    ,OPEN_YLD_RAT                --开仓收益率
    ,AMORT_DT                    --摊销日期
    ,STL_DT                      --结算日期
    ,OPEN_DT                     --开仓日期
    ,LAST_UPDATE_DT              --上次更新日期
    ,CAP_TYPE_CD                 --资金类型代码
    ,ASSET_FOUR_CLS_CD           --资产四分类代码
    ,BELONG_ORG_ID               --所属机构编号
    ,COMB_TRAN_NUM               --组合交易号
    ,OBJ_ID                      --对象编号
    ,APV_FORM_NUM                --审批单号
    ,INT_SUBJ_ID                 --利息科目编号
    ,INT_ADJ_SUBJ_ID             --利息调整科目编号
    ,ACRU_INT_INCO_SUBJ_ID       --应计利息收入科目编号
    ,AMORT_INT_INCOME_SUBJ_ID    --摊销利息收入科目编号
    ,EVHA_VAL_CHAG_PL_SUBJ_ID    --公允价值变动损益科目编号
    ,SPD_PL_SUBJ_ID              --价差损益科目编号
    ,CURRT_BAL                   --当期余额
    ,INT_RECVBL                  --应收利息
    ,TD_NV                       --当日净值
    ,FIR_STL_DT                  --首次结算日期
    ,ASSET_THD_CLS_CD            --资产三分类代码
    ,TRAN_AMT                    --交易金额
    ,EVHA_VAL_CHAG_PL            --公允价值变动损益
    ,SPD_PL                      --价差损益
    ,ACRU_INT_INCO               --应计利息收入
    ,AMORT_INT_INCO              --摊销利息收入
    ,FTP_PROP_CATE               --FTP方案类别
    ,FTP_SPREAD                  --FTP点差
    ,NCDS_ISSUE_ORG_ID           --同业存单发行机构编号
    ,NCDS_ISSUE_ORG_NAME         --同业存单发行机构名称
    ,OVDUE_STATUS                --逾期状态
    ,OVDUE_FLG                   --逾期标志
    ,PRIC_OVDUE_DT               --本金逾期日期
    ,PRIC_OVDUE_DAYS             --本金逾期天数
    ,INT_OVDUE_DT                --利息逾期日期
    ,INT_OVDUE_DAYS              --利息逾期天数
    ,EVHA_VAL_CHAG_SUBJ_ID       --公允价值变动科目编号
    ,ACRU_INT_INCO_VAT_SUBJ_ID   --应计利息收入增值税科目编号
    ,AMORT_INT_INCOME_VAT_SUBJ_ID  --摊销利息收入增值税科目编号
    ,SPD_PL_VAT_SUBJ_ID          --价差损益增值税科目编号
    ,TRAN_DT                     --交易日期
    ,VALUE_DT                    --起息日期
    ,EXP_DT                      --到期日期
    ,ACRU_INT_INCO_SHOULD_TAX_FLG     --应计利息收入应税标志
    ,AMORT_INT_INCOME_SHOULD_TAX_FLG  --摊销利息收入应税标志
    ,SPD_PL_SHOULD_TAX_FLG       --价差损益应税标志
    ,ACRU_INT_INCO_TAX_RAT       --应计利息收入税率
    ,AMORT_INT_INCOME_TAX_RAT    --摊销利息收入税率
    ,SPD_PL_TAX_RAT              --价差损益税率
    ,ACRU_INT_INCO_TAX_LMT       --应计利息收入税额
    ,AMORT_INT_INCOME_TAX_LMT    --摊销利息收入税额
    ,SPD_PL_TAX_LMT              --价差损益税额
    ,IS_TH_SSN_REDEM             --是否当季赎回
    ,EXPE_REDEM_DT               --预期赎回日期
    ,TRAN_HOLD_IDF               --交易持有标识
    ,APOT_TENOR_DEP_FLG          --约期存款标志
    ,APOT_TENOR_START_DT         --约期开始日期
    ,APOT_TENOR_END_DT           --约期结束日期
    ,CURRT_ACRU_INT              --当期应计利息
    ,TRAN_COST_ACCTI_METHOD_CD   --交易成本核算方法代码
    ,INT_INCOME                  --利息收入
    ,INTNAL_SECU_ACCT_STATUS_CD  --内部证券账户状态代码
    ,CNTPTY_ACCT_ID              --交易对手账户编号
    ,CURR_ISSUE_BUILD_UP_POS_DT  --本期建仓日期
    ,JOB_CD                      --任务代码
    ,ASSET_UNIQ_IDF_ID           --资产唯一标识编号
    )
  SELECT TO_DATE(V_P_DATE,'YYYYMMDD') AS ETL_DT  --数据日期
        ,LP_ID                       --法人编号
        ,EXT_SECU_ACCT_ID            --外部证券账户编号
        ,INTNAL_SECU_ACCT_ID         --内部证券账户编号
        ,FIN_INSTM_ID                --金融工具编号
        ,ASSET_TYPE_ID               --资产类型编号
        ,STD_PROD_ID                 --标准产品编号
        ,MARKET_TYPE_ID              --市场类型编号
        ,BUS_ID                      --业务编号
        ,PROD_TYPE_CD                --产品类型代码
        ,ASSET_TYPE_NAME             --资产类型名称
        ,LEVEL5_CLS_CD               --五级分类代码
        ,SUBJ_ID                     --科目编号
        ,ACCT_NAME                   --账户名称
        ,TRAN_MARKET_ID              --交易市场编号
        ,EXCHG_ACCT_ID               --交易所账户编号
        ,ISSUER_ID                   --发行人编号
        ,ISSUER_NAME                 --发行人名称
        ,STL_SITE_ID                 --结算场所编号
        ,STL_SITE_NAME               --结算场所名称
        ,TRAN_NUM                    --交易号
        ,EXTRA_DIMEN_CD              --额外维度代码
        ,CURR_CD                     --币种代码
        ,ACTL_QTTY                   --实际数量
        ,CASE WHEN ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN ACTL_BAL
              ELSE 0
          END AS ACTL_BAL            --实际余额
        ,NET_PRICE_COST              --净价成本
        ,ACRU_INT                    --应计利息
        ,INT_COST                    --利息成本
        ,EVHA_VAL_CHAG               --公允价值变动
        ,RECVBL_UNCOL_BAL            --应收未收余额
        ,RECVBL_UNCOL_NET_PRICE_COST --应收未收净价成本
        ,RECVBL_UNCOL_ACRU_INT       --应收未收应计利息
        ,INT_ADJ_AMT                 --利息调整金额
        ,ACTL_INT_RAT                --实际利率
        ,INVEST_YLD_RAT              --投资收益率
        ,OPEN_YLD_RAT                --开仓收益率
        ,AMORT_DT                    --摊销日期
        ,STL_DT                      --结算日期
        ,OPEN_DT                     --开仓日期
        ,LAST_UPDATE_DT              --上次更新日期
        ,CAP_TYPE_CD                 --资金类型代码
        ,ASSET_FOUR_CLS_CD           --资产四分类代码
        ,BELONG_ORG_ID               --所属机构编号
        ,COMB_TRAN_NUM               --组合交易号
        ,OBJ_ID                      --对象编号
        ,APV_FORM_NUM                --审批单号
        ,INT_SUBJ_ID                 --利息科目编号
        ,INT_ADJ_SUBJ_ID             --利息调整科目编号
        ,ACRU_INT_INCO_SUBJ_ID       --应计利息收入科目编号
        ,AMORT_INT_INCOME_SUBJ_ID    --摊销利息收入科目编号
        ,EVHA_VAL_CHAG_PL_SUBJ_ID    --公允价值变动损益科目编号
        ,SPD_PL_SUBJ_ID              --价差损益科目编号
        ,CASE WHEN ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') THEN CURRT_BAL
              ELSE 0
          END AS CURRT_BAL           --当期余额
        ,INT_RECVBL                  --应收利息
        ,TD_NV                       --当日净值
        ,FIR_STL_DT                  --首次结算日期
        ,ASSET_THD_CLS_CD            --资产三分类代码
        ,TRAN_AMT                    --交易金额
        ,EVHA_VAL_CHAG_PL            --公允价值变动损益
        ,SPD_PL                      --价差损益
        ,ACRU_INT_INCO               --应计利息收入
        ,AMORT_INT_INCO              --摊销利息收入
        ,FTP_PROP_CATE               --FTP方案类别
        ,FTP_SPREAD                  --FTP点差
        ,NCDS_ISSUE_ORG_ID           --同业存单发行机构编号
        ,NCDS_ISSUE_ORG_NAME         --同业存单发行机构名称
        ,OVDUE_STATUS                --逾期状态
        ,OVDUE_FLG                   --逾期标志
        ,PRIC_OVDUE_DT               --本金逾期日期
        ,PRIC_OVDUE_DAYS             --本金逾期天数
        ,INT_OVDUE_DT                --利息逾期日期
        ,INT_OVDUE_DAYS              --利息逾期天数
        ,EVHA_VAL_CHAG_SUBJ_ID       --公允价值变动科目编号
        ,ACRU_INT_INCO_VAT_SUBJ_ID   --应计利息收入增值税科目编号
        ,AMORT_INT_INCOME_VAT_SUBJ_ID  --摊销利息收入增值税科目编号
        ,SPD_PL_VAT_SUBJ_ID          --价差损益增值税科目编号
        ,TRAN_DT                     --交易日期
        ,VALUE_DT                    --起息日期
        ,EXP_DT                      --到期日期
        ,ACRU_INT_INCO_SHOULD_TAX_FLG     --应计利息收入应税标志
        ,AMORT_INT_INCOME_SHOULD_TAX_FLG  --摊销利息收入应税标志
        ,SPD_PL_SHOULD_TAX_FLG       --价差损益应税标志
        ,ACRU_INT_INCO_TAX_RAT       --应计利息收入税率
        ,AMORT_INT_INCOME_TAX_RAT    --摊销利息收入税率
        ,SPD_PL_TAX_RAT              --价差损益税率
        ,ACRU_INT_INCO_TAX_LMT       --应计利息收入税额
        ,AMORT_INT_INCOME_TAX_LMT    --摊销利息收入税额
        ,SPD_PL_TAX_LMT              --价差损益税额
        ,IS_TH_SSN_REDEM             --是否当季赎回
        ,EXPE_REDEM_DT               --预期赎回日期
        ,TRAN_HOLD_IDF               --交易持有标识
        ,APOT_TENOR_DEP_FLG          --约期存款标志
        ,APOT_TENOR_START_DT         --约期开始日期
        ,APOT_TENOR_END_DT           --约期结束日期
        ,CURRT_ACRU_INT              --当期应计利息
        ,TRAN_COST_ACCTI_METHOD_CD   --交易成本核算方法代码
        ,INT_INCOME                  --利息收入
        ,INTNAL_SECU_ACCT_STATUS_CD  --内部证券账户状态代码
        ,CNTPTY_ACCT_ID              --交易对手账户编号
        ,CURR_ISSUE_BUILD_UP_POS_DT  --本期建仓日期
        ,JOB_CD                      --任务代码
        ,ASSET_UNIQ_IDF_ID           --资产唯一标识编号
    FROM (SELECT /*+PARALLEL*/ ROW_NUMBER() OVER(PARTITION BY OBJ_ID ORDER BY A.ETL_DT DESC) RN,A.*
            FROM ICL.V_CMM_IBANK_SECU_POST A --同业证券持仓_视图 --20230112 XUXIAOBIN特殊处理
           WHERE TRUNC(A.ETL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
             AND A.ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD'))
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

END ETL_O_ICL_CMM_IBANK_SECU_POST;
/

