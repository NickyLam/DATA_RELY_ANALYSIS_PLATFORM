CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_MYLOAN_DUBIL(I_P_DATE IN INTEGER,
                                                       O_ERRCODE OUT VARCHAR2
                                                       )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_MYLOAN_DUBIL
  *  功能描述：微粒贷账户
  *  创建日期：20230530
  *  开发人员：MW
  *  来源表： IML.V_AGT_MYLOAN_DUBIL
  *  目标表： O_IML_AGT_MYLOAN_DUBIL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230530  MW     首次创建
  *             2    20240424  YJY     PAYOFF_DT截掉时间戳
  *             3    20241010  YJY     新增发生方式代码
  *             4    20241022  YJY     调整数据日期加工方式
  ************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_MYLOAN_DUBIL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_MYLOAN_DUBIL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_MYLOAN_DUBIL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-微粒贷账户';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_MYLOAN_DUBIL
    (AGT_ID                                --协议编号
    ,LP_ID                                 --法人编号
    ,DUBIL_ID                              --借据编号
    ,EXT_PROD_ID                           --外部产品编号
    ,LOAN_STATUS_CD                        --贷款状态代码
    ,LOAN_USAGE_CD                         --贷款用途代码
    ,LOAN_CAP_USE_POSITION_CD              --贷款资金使用位置代码
    ,DISTR_DT                              --放款日期
    ,CURR_CD                               --币种代码
    ,DISTR_AMT                             --放款金额
    ,LOAN_VALUE_DT                         --贷款起息日期
    ,LOAN_EXP_DT                           --贷款到期日期
    ,LOAN_CONT_TENOR                       --贷款合同期限
    ,REPAY_WAY_CD                          --还款方式代码
    ,GRACE_PERIOD_DAYS                     --宽限期天数
    ,SRC_INT_RAT_TYPE_CD                   --源利率类型代码
    ,INT_RAT_ADJ_WAY_CD                    --利率调整方式代码
    ,INT_RAT_ADJ_PED_CORP_CD               --利率调整周期单位代码
    ,INT_RAT_ADJ_PED_FREQ                  --利率调整周期频率
    ,LOAN_ACTL_DAY_INT_RAT                 --贷款实际日利率
    ,PRIC_REPAY_FREQ_CD                    --本金还款频率代码
    ,INT_REPAY_FREQ_CD                     --利息还款频率代码
    ,GUAR_TYPE_CD                          --担保类型代码
    ,CRDT_APPL_ID                          --授信申请编号
    ,RECVBL_NUM_TYPE_CD                    --收款账号类型代码
    ,RECVBL_ACCT_NAME                      --收款账户名称
    ,RECVBL_ACCT_ID                        --收款账户编号
    ,RECVBL_BANK_NAME                      --收款银行名称
    ,REPAY_NUM_TYPE_CD                     --还款账号类型代码
    ,REPAY_ACCT_NAME                       --还款账户名称
    ,REPAY_ACCT_ID                         --还款账户编号
    ,REPAY_BANK_NAME                       --还款银行名称
    ,PROD_TYPE_CD                          --产品类型代码
    ,ACCTNT_DT                             --会计日期
    ,CONT_STATUS_CD                        --合约状态代码
    ,PAYOFF_DT                             --结清日期
    ,LOAN_LEVEL5_CLS_CD                    --贷款五级分类代码
    ,ACRU_NON_ACRU_FLG                     --应计非应计标志
    ,NEXT_REPAY_DT                         --下一还款日期
    ,UNPAYOFF_PERDS                        --未结清期数
    ,OVDUE_PD_CNT                          --逾期期次数
    ,PRIC_OVDUE_DAYS                       --本金逾期天数
    ,INT_OVDUE_DAYS                        --利息逾期天数
    ,NOMAL_PRIC_BAL                        --正常本金余额
    ,OVDUE_PRIC_BAL                        --逾期本金余额
    ,LOAN_DIR_INDUS_CD                     --贷款投向行业代码
    ,CUST_ID                               --客户编号
    ,CUST_MGR_ID                           --客户经理编号
    ,NOMAL_INT_BAL                         --正常利息余额
    ,OVDUE_INT_BAL                         --逾期利息余额
    ,OVDUE_PRIC_PNLT_BAL                   --逾期本金罚息余额
    ,OVDUE_INT_PNLT_BAL                    --逾期利息罚息余额
    ,LOAN_EXEC_YEAR_INT_RAT                --贷款执行年利率
    ,LPR_INT_RAT                           --LPR利率
    ,INT_RAT_FLOAT_SPREAD_VAL              --利率浮动点差值
    ,INT_RAT_FLOAT_DIR_CD                  --利率浮动方向代码
    ,BASE_RAT_TYPE_CD                      --基准利率类型代码
    ,TRAN_TYPE_CD                          --转让类型代码
    ,ASSET_THD_CLS_CD                      --资产三分类代码
    ,PROD_ID                               --产品编号
    ,CONTRI_TYPE_CD                        --出资类型代码
    ,CONTRI_RATIO                          --出资比例
    ,WHITE_LIST_CUST_FLG                   --白户标志
    ,CUST_CHAR_CD                          --客户性质代码
    ,FARM_FLG                              --农户标志
    ,CREATE_DT                             --创建日期
    ,UPDATE_DT                             --更新日期
    ,ETL_DT                                --ETL处理日期
    ,HAPP_WAY_CD                           --发生方式代码   ADD BY YJY 20241010
    )
  SELECT AGT_ID                                --协议编号
    ,LP_ID                                 --法人编号
    ,DUBIL_ID                              --借据编号
    ,EXT_PROD_ID                           --外部产品编号
    ,LOAN_STATUS_CD                        --贷款状态代码
    ,LOAN_USAGE_CD                         --贷款用途代码
    ,LOAN_CAP_USE_POSITION_CD              --贷款资金使用位置代码
    ,DISTR_DT                              --放款日期
    ,CURR_CD                               --币种代码
    ,DISTR_AMT                             --放款金额
    ,LOAN_VALUE_DT                         --贷款起息日期
    ,LOAN_EXP_DT                           --贷款到期日期
    ,LOAN_CONT_TENOR                       --贷款合同期限
    ,REPAY_WAY_CD                          --还款方式代码
    ,GRACE_PERIOD_DAYS                     --宽限期天数
    ,SRC_INT_RAT_TYPE_CD                   --源利率类型代码
    ,INT_RAT_ADJ_WAY_CD                    --利率调整方式代码
    ,INT_RAT_ADJ_PED_CORP_CD               --利率调整周期单位代码
    ,INT_RAT_ADJ_PED_FREQ                  --利率调整周期频率
    ,LOAN_ACTL_DAY_INT_RAT                 --贷款实际日利率
    ,PRIC_REPAY_FREQ_CD                    --本金还款频率代码
    ,INT_REPAY_FREQ_CD                     --利息还款频率代码
    ,GUAR_TYPE_CD                          --担保类型代码
    ,CRDT_APPL_ID                          --授信申请编号
    ,RECVBL_NUM_TYPE_CD                    --收款账号类型代码
    ,RECVBL_ACCT_NAME                      --收款账户名称
    ,RECVBL_ACCT_ID                        --收款账户编号
    ,RECVBL_BANK_NAME                      --收款银行名称
    ,REPAY_NUM_TYPE_CD                     --还款账号类型代码
    ,REPAY_ACCT_NAME                       --还款账户名称
    ,REPAY_ACCT_ID                         --还款账户编号
    ,REPAY_BANK_NAME                       --还款银行名称
    ,PROD_TYPE_CD                          --产品类型代码
    ,ACCTNT_DT                             --会计日期
    ,CONT_STATUS_CD                        --合约状态代码
    ,PAYOFF_DT                             --结清日期
    ,LOAN_LEVEL5_CLS_CD                    --贷款五级分类代码
    ,ACRU_NON_ACRU_FLG                     --应计非应计标志
    ,NEXT_REPAY_DT                         --下一还款日期
    ,UNPAYOFF_PERDS                        --未结清期数
    ,OVDUE_PD_CNT                          --逾期期次数
    ,PRIC_OVDUE_DAYS                       --本金逾期天数
    ,INT_OVDUE_DAYS                        --利息逾期天数
    ,NOMAL_PRIC_BAL                        --正常本金余额
    ,OVDUE_PRIC_BAL                        --逾期本金余额
    ,LOAN_DIR_INDUS_CD                     --贷款投向行业代码
    ,CUST_ID                               --客户编号
    ,CUST_MGR_ID                           --客户经理编号
    ,NOMAL_INT_BAL                         --正常利息余额
    ,OVDUE_INT_BAL                         --逾期利息余额
    ,OVDUE_PRIC_PNLT_BAL                   --逾期本金罚息余额
    ,OVDUE_INT_PNLT_BAL                    --逾期利息罚息余额
    ,LOAN_EXEC_YEAR_INT_RAT                --贷款执行年利率
    ,LPR_INT_RAT                           --LPR利率
    ,INT_RAT_FLOAT_SPREAD_VAL              --利率浮动点差值
    ,INT_RAT_FLOAT_DIR_CD                  --利率浮动方向代码
    ,BASE_RAT_TYPE_CD                      --基准利率类型代码
    ,TRAN_TYPE_CD                          --转让类型代码
    ,ASSET_THD_CLS_CD                      --资产三分类代码
    ,PROD_ID                               --产品编号
    ,CONTRI_TYPE_CD                        --出资类型代码
    ,CONTRI_RATIO                          --出资比例
    ,WHITE_LIST_CUST_FLG                   --白户标志
    ,CUST_CHAR_CD                          --客户性质代码
    ,FARM_FLG                              --农户标志
    ,CREATE_DT                             --创建日期
    ,UPDATE_DT                             --更新日期
    ,ETL_DT + 1                            --ETL处理日期   --MOD BY YJY 20241022
    ,HAPP_WAY_CD                           --发生方式代码   ADD BY YJY 20241010
    FROM IML.V_AGT_MYLOAN_DUBIL --视图-微粒贷账户
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')- 1  --MOD BY YJY 20241022 
    ; 

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_MYLOAN_DUBIL', '', O_ERRCODE);

  -- 程序跑批结束记录 --
  V_STEP := 3;
  V_STARTTIME := SYSDATE;
  V_STEP_DESC := '-- 程序跑批结束 --';
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_ENDTIME := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_AGT_MYLOAN_DUBIL;
/

