CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_IBANK_CASH_DEBIT_CRDT(I_P_DATE IN INTEGER,
                                                                O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_IBANK_CASH_DEBIT_CRDT
  *  功能描述：同业现金借贷
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_IBANK_CASH_DEBIT_CRDT
  *  目标表： O_ICL_CMM_IBANK_CASH_DEBIT_CRDT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20220615           修改参数
  *             3    20240110  HYF      新增应收利息
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_IBANK_CASH_DEBIT_CRDT'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-同业现金借贷';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_IBANK_CASH_DEBIT_CRDT
    (ETL_DT                              --数据日期
    ,LP_ID                               --法人编号
    ,EXT_SECU_ACCT_ID                    --外部证券账户编号
    ,INTNAL_SECU_ACCT_ID                 --内部证券账户编号
    ,ACCT_ID                             --账户编号
    ,FIN_INSTM_ID                        --金融工具编号
    ,ASSET_TYPE_ID                       --资产类型编号
    ,STD_PROD_ID                         --标准产品编号
    ,MARKET_TYPE_ID                      --市场类型编号
    ,BUS_ID                              --业务编号
    ,COMB_TRAN_NUM                       --组合交易号
    ,OBJ_ID                              --对象编号
    ,PROD_TYPE_CD                        --产品类型代码
    ,ASSET_TYPE_NAME                     --资产类型名称
    ,LEVEL5_CLS_CD                       --五级分类代码
    ,ACCT_NAME                           --账户名称
    ,SUBJ_ID                             --科目编号
    ,INT_SUBJ_ID                         --利息科目编号
    ,INT_ADJ_SUBJ_ID                     --利息调整科目编号
    ,TRAN_MARKET_ID                      --交易市场编号
    ,EXCHG_ACCT_ID                       --交易所账户编号
    ,CNTPTY_CUST_ID                      --交易对手客户编号
    ,CNTPTY_ID                           --交易对手编号
    ,CNTPTY_NAME                         --交易对手名称
    ,CNTPTY_ACCT_NUM                     --交易对手账号
    ,CNTPTY_ACCT_NAME                    --交易对手账户名称
    ,CNTPTY_OPEN_BANK_NUM                --交易对手开户行号
    ,CNTPTY_OPEN_BANK_NAME               --交易对手开户行名称
    ,CNTPTY_CLS_DESCB                    --交易对手分类描述
    ,CNTPTY_IDF_CODE                     --交易对手标识编码
    ,CNTPTY_IDF_CODE_TYPE_CD             --交易对手标识编码类型代码
    ,TRAN_TYPE_CD                        --交易类型代码
    ,BANK_FLG                            --银行标志
    ,CTY_CD                              --国家代码
    ,VALUE_DT                            --起息日期
    ,EXP_DT                              --到期日期
    ,CASH_DT                             --兑付日期
    ,TENOR_CD                            --期限代码
    ,INT_ACCR_BASE_CD                    --计息基准代码
    ,INT_RAT_ADJ_WAY_CD                  --利率调整方式代码
    ,BASE_RAT_TYPE_CD                    --基准利率类型代码
    ,INT_RAT_ADJ_FREQ_CD                 --利率调整频率代码
    ,APV_ODD_NO                          --审批单号
    ,CURR_CD                             --币种代码
    ,FAC_VAL_AMT                         --票面金额
    ,FAC_VAL_INT_RAT                     --票面利率
    ,BASE_RAT                            --基准利率
    ,EXEC_INT_RAT                        --执行利率
    ,PAY_INT_PED_CD                      --付息周期代码
    ,AUTO_REDT_FLG                       --自动转存标志
    ,ACTL_BAL                            --实际余额
    ,PRIC_BAL                            --本金余额
    ,CURRT_BAL                           --当期余额
    ,ACRU_INT                            --应计利息
    ,RECVBL_UNCOL_PRIC                   --应收未收本金
    ,RECVBL_UNCOL_INT                    --应收未收利息
    ,LAST_UPDATE_DT                      --上次更新日期
    ,CAP_TYPE_CD                         --资金类型代码
    ,ASSET_FOUR_CLS_CD                   --资产四分类代码
    ,ASSET_THD_CLS_CD                    --资产三分类代码
    ,BELONG_ORG_ID                       --所属机构编号
    ,TRAN_AMT                            --交易金额
    ,EXTRA_DIMEN_CD                      --额外维度代码
    ,STL_DT                              --结算日期
    ,OVDUE_STATUS                        --逾期状态
    ,OVDUE_FLG                           --逾期标志
    ,PRIC_OVDUE_DT                       --本金逾期日期
    ,PRIC_OVDUE_DAYS                     --本金逾期天数
    ,INT_OVDUE_DT                        --利息逾期日期
    ,INT_OVDUE_DAYS                      --利息逾期天数
    ,ACCT_CHAR_DESCB                     --账户性质描述
    ,ACCT_ATTR_DESCB                     --账户属性描述
    ,ACTL_FINER_CUST_ID                  --实际融资人客户编号
    ,ACTL_FINER_NAME                     --实际融资人名称
    ,ACTL_FINER_GROUP_NAME               --实际融资人集团名称
    ,INPWN_VCH_ID                        --质押券编号
    ,INPWN_VCH_ASSET_TYPE_ID             --质押券资产类型编号
    ,INPWN_VCH_MARKET_TYPE_ID            --质押券市场类型编号
    ,INPWN_CERT_FACE_LMT                 --质押券面额
    ,INPWN_VCH_DISCNT_RAT                --质押券折价率
    ,INPWN_VCH_PCT                       --质押券占比
    ,TRAN_SEQ_NUM                        --交易序号
    ,ASSET_UNIQ_IDF_ID                   --资产唯一标识编号
    ,TRANS_LOAN_FLG                      --转贷款标志
    ,INT_RECVBL                          --应收利息
    )
  SELECT TO_DATE(V_P_DATE,'YYYYMMDD') ETL_DT --数据日期
        ,LP_ID                               --法人编号
        ,EXT_SECU_ACCT_ID                    --外部证券账户编号
        ,INTNAL_SECU_ACCT_ID                 --内部证券账户编号
        ,ACCT_ID                             --账户编号
        ,FIN_INSTM_ID                        --金融工具编号
        ,ASSET_TYPE_ID                       --资产类型编号
        ,STD_PROD_ID                         --标准产品编号
        ,MARKET_TYPE_ID                      --市场类型编号
        ,BUS_ID                              --业务编号
        ,COMB_TRAN_NUM                       --组合交易号
        ,OBJ_ID                              --对象编号
        ,PROD_TYPE_CD                        --产品类型代码
        ,ASSET_TYPE_NAME                     --资产类型名称
        ,LEVEL5_CLS_CD                       --五级分类代码
        ,ACCT_NAME                           --账户名称
        ,SUBJ_ID                             --科目编号
        ,INT_SUBJ_ID                         --利息科目编号
        ,INT_ADJ_SUBJ_ID                     --利息调整科目编号
        ,TRAN_MARKET_ID                      --交易市场编号
        ,EXCHG_ACCT_ID                       --交易所账户编号
        ,CNTPTY_CUST_ID                      --交易对手客户编号
        ,CNTPTY_ID                           --交易对手编号
        ,CNTPTY_NAME                         --交易对手名称
        ,CNTPTY_ACCT_NUM                     --交易对手账号
        ,CNTPTY_ACCT_NAME                    --交易对手账户名称
        ,CNTPTY_OPEN_BANK_NUM                --交易对手开户行号
        ,CNTPTY_OPEN_BANK_NAME               --交易对手开户行名称
        ,CNTPTY_CLS_DESCB                    --交易对手分类描述
        ,CNTPTY_IDF_CODE                     --交易对手标识编码
        ,CNTPTY_IDF_CODE_TYPE_CD             --交易对手标识编码类型代码
        ,TRAN_TYPE_CD                        --交易类型代码
        ,BANK_FLG                            --银行标志
        ,CTY_CD                              --国家代码
        ,VALUE_DT                            --起息日期
        ,EXP_DT                              --到期日期
        ,CASH_DT                             --兑付日期
        ,TENOR_CD                            --期限代码
        ,INT_ACCR_BASE_CD                    --计息基准代码
        ,INT_RAT_ADJ_WAY_CD                  --利率调整方式代码
        ,BASE_RAT_TYPE_CD                    --基准利率类型代码
        ,INT_RAT_ADJ_FREQ_CD                 --利率调整频率代码
        ,APV_ODD_NO                          --审批单号
        ,CURR_CD                             --币种代码
        ,FAC_VAL_AMT                         --票面金额
        ,FAC_VAL_INT_RAT                     --票面利率
        ,BASE_RAT                            --基准利率
        ,EXEC_INT_RAT                        --执行利率
        ,PAY_INT_PED_CD                      --付息周期代码
        ,AUTO_REDT_FLG                       --自动转存标志
        ,ACTL_BAL                            --实际余额
        ,PRIC_BAL                            --本金余额
        ,CURRT_BAL                           --当期余额
        ,ACRU_INT                            --应计利息
        ,RECVBL_UNCOL_PRIC                   --应收未收本金
        ,RECVBL_UNCOL_INT                    --应收未收利息
        ,LAST_UPDATE_DT                      --上次更新日期
        ,CAP_TYPE_CD                         --资金类型代码
        ,ASSET_FOUR_CLS_CD                   --资产四分类代码
        ,ASSET_THD_CLS_CD                    --资产三分类代码
        ,BELONG_ORG_ID                       --所属机构编号
        ,TRAN_AMT                            --交易金额
        ,EXTRA_DIMEN_CD                      --额外维度代码
        ,STL_DT                              --结算日期
        ,OVDUE_STATUS                        --逾期状态
        ,OVDUE_FLG                           --逾期标志
        ,PRIC_OVDUE_DT                       --本金逾期日期
        ,PRIC_OVDUE_DAYS                     --本金逾期天数
        ,INT_OVDUE_DT                        --利息逾期日期
        ,INT_OVDUE_DAYS                      --利息逾期天数
        ,ACCT_CHAR_DESCB                     --账户性质描述
        ,ACCT_ATTR_DESCB                     --账户属性描述
        ,ACTL_FINER_CUST_ID                  --实际融资人客户编号
        ,ACTL_FINER_NAME                     --实际融资人名称
        ,ACTL_FINER_GROUP_NAME               --实际融资人集团名称
        ,INPWN_VCH_ID                        --质押券编号
        ,INPWN_VCH_ASSET_TYPE_ID             --质押券资产类型编号
        ,INPWN_VCH_MARKET_TYPE_ID            --质押券市场类型编号
        ,INPWN_CERT_FACE_LMT                 --质押券面额
        ,INPWN_VCH_DISCNT_RAT                --质押券折价率
        ,INPWN_VCH_PCT                       --质押券占比
        ,TRAN_SEQ_NUM                        --交易序号
        ,ASSET_UNIQ_IDF_ID                   --资产唯一标识编号
        ,TRANS_LOAN_FLAG                     --转贷款标志
        ,INT_RECVBL                          --应收利息
    FROM (SELECT /*+ PARALLEL */
                 ROW_NUMBER() OVER(PARTITION BY OBJ_ID ORDER BY A.ETL_DT DESC) RN,A.*
            FROM ICL.V_CMM_IBANK_CASH_DEBIT_CRDT A--同业现金借贷
           WHERE TRUNC(A.ETL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
             AND A.ETL_DT <= TO_DATE(V_P_DATE,'YYYYMMDD'))
   WHERE RN = 1; --按照日期取最新一条，因为源系统当债券余额为0时第二天就不提供了

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_ICL_CMM_IBANK_CASH_DEBIT_CRDT;
/

