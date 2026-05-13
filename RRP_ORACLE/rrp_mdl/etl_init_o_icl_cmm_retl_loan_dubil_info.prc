CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_RETL_LOAN_DUBIL_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_RETL_LOAN_DUBIL_INFO
  *  功能描述：零售贷款借据信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_RETL_LOAN_DUBIL_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_RETL_LOAN_DUBIL_INFO'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_RETL_LOAN_DUBIL_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_RETL_LOAN_DUBIL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-零售贷款借据信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_RETL_LOAN_DUBIL_INFO
  (
               ETL_DT  --数据日期
          ,LP_ID  --法人编号
          ,DUBIL_ID  --借据编号
          ,CONT_ID  --合同编号
          ,STD_PROD_ID  --标准产品编号
          ,BUS_BREED_ID  --业务品种编号
          ,BUS_BREED_NAME  --业务品种名称
          ,CRDTC_SUBM_BUS_BREED_CD  --征信报送业务品种代码
          ,CUST_ID  --客户编号
          ,CRDTC_SUBM_BUS_BREED_DESCB  --征信报送业务品种描述
          ,REPAY_NUM  --还款账号
          ,ENTER_ACCT_NUM  --入账账号
          ,MORTG_FLG  --按揭标志
          ,NPL_FLG  --不良贷款标志
          ,DEFLT_FLG  --违约标志
          ,CRDT_LMT_USE_FLG  --授信额度使用标志
          ,GRO_LEND_FLG  --联保贷款标志
          ,BLON_LOAN_FLG  --气球贷标志
          ,LEVEL10_CLS_MANU_MED_FLG  --十级分类人工干预标志
          ,INSURE_COMP_FLG  --保险代偿标志
          ,PBC_INC_LOAN_FLG  --人行普惠贷款标志
          ,WHITE_LIST_CUST_FLG  --白户标志
          ,FARM_FLG  --农户标志
          ,PROD_TYPE_CD  --产品类型代码
          ,LOAN_HAPP_TYPE_CD  --贷款发生类型代码
          ,LOAN_TYPE_CD  --贷款类型代码
          ,ASSET_THD_CLS_CD  --资产三分类代码
          ,GUAR_WAY_CD  --担保方式代码
          ,SUB_GUAR_WAY_CD  --子担保方式代码
          ,REPAY_WAY_CD  --还款方式代码
          ,DIR_INDUS_CD  --投向行业代码
          ,DUBIL_STATUS_CD  --借据状态代码
          ,REFAC_LOAN_STATUS_CD  --支小再贷款状态代码
          ,COMP_INT_CALC_WAY_CD  --复利计算方式代码
					,INT_RAT_ADJ_PED_CORP_CD  --利率调整周期单位代码
					,INT_RAT_ADJ_PED_FREQ  --利率调整周期频率
					,LOAN_LEVEL4_CLS_CD  --贷款四级分类代码
					,LOAN_LEVEL5_CLS_CD  --贷款五级分类代码
					,LOAN_LEVEL10_CLS_CD  --贷款十级分类代码
					,LOAN_LEVEL12_CLS_CD  --贷款十二级分类代码
					,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
					,OVDUE_INT_RAT_ADJ_WAY  --逾期利率调整方式
					,INT_RAT_ADJ_EFFECT_WAY  --利率调整生效方式
					,INT_RAT_FLOAT_TENOR_CD  --利率浮动期限代码
					,ENTER_ACCT_PT_TYPE_CD  --入账账户支付工具类型代码
					,REPAY_ACCT_PT_TYPE_CD  --还款账户支付工具类型代码
					,DEDUCT_WAY_CD  --扣款方式代码
					,MODE_PAY_CD  --支付方式代码
					,CURR_CD  --币种代码
					,CUST_CHAR_CD  --客户性质代码
					,CUST_CRDT_TOT  --客户授信总额
					,LOAN_TYPE_DESCB  --贷款类型描述
					,ENTER_ACCT_NAME  --入账账户名称
					,CUST_MGR_ID  --客户经理编号
					,TRUST_CUST_MGR  --托管客户经理
					,RGST_TELLER_ID  --登记柜员编号
					,RGST_ORG_ID  --登记机构编号
					,ACCT_INSTIT_ID  --账务机构编号
					,MGMT_ORG_ID  --管理机构编号
					,DUBIL_OPEN_DT  --借据开立日期
					,DUBIL_EXP_DT  --借据到期日期
					,FIR_DISTR_DT  --首次放款日期
					,RECNT_REPAY_DT  --最近还款日期
					,REPAY_DAY  --还款日
					,PAYOFF_DT  --结清日期
					,PRIC_OVDUE_DT  --本金逾期日期
					,INT_OVDUE_DT  --利息逾期日期
					,LOAN_LEVEL5_CLS_DT  --贷款五级分类日期
					,LOAN_LEVEL10_CLS_DT  --贷款十级分类日期
					,LAST_LEVEL5_CLS_MODIF_DT  --上次五级分类变更日期
					,LAST_RISK_RGST_ADJ_RS  --上次风险登记调整原因
					,RISK_RGST_APVER_ID  --风险登记审批人编号
					,BASE_RAT  --基准利率
					,EXEC_INT_RAT  --执行利率
					,OVDUE_INT_RAT  --逾期利率
					,OVDUE_INT_RAT_FLO_VAL  --逾期利率浮动值
					,INT_RAT_FLO_VAL  --利率浮动值
					,PRIC_OVDUE_DAYS  --本金逾期天数
					,INT_OVDUE_DAYS  --利息逾期天数
					,GRACE_DAYS  --宽限天数
					,GRACE_PERIOD_START_DT  --宽限期开始日期
					,GRACE_PERIOD_EXP_DT  --宽限期到期日期
					,FINAL_PED_RESV_AMT  --最后一期保留金额
					,DUBIL_AMT  --借据金额
					,REFAC_LOAN_BATCH_PKG_ID  --支小再贷款批次包编号
					,REFAC_LOAN_BATCH_EXP_DT  --支小再贷款批次到期日期
					,REFAC_LOAN_USE_INT_RAT  --支小再贷款使用利率
					,JOB_CD  --任务代码
					,ETL_TIMESTAMP  --数据处理时间
    )
    SELECT
					ETL_DT  --数据日期
					,LP_ID  --法人编号
					,DUBIL_ID  --借据编号
					,CONT_ID  --合同编号
					,STD_PROD_ID  --标准产品编号
					,BUS_BREED_ID  --业务品种编号
					,BUS_BREED_NAME  --业务品种名称
					,CRDTC_SUBM_BUS_BREED_CD  --征信报送业务品种代码
					,CUST_ID  --客户编号
					,CRDTC_SUBM_BUS_BREED_DESCB  --征信报送业务品种描述
					,REPAY_NUM  --还款账号
					,ENTER_ACCT_NUM  --入账账号
					,MORTG_FLG  --按揭标志
					,NPL_FLG  --不良贷款标志
					,DEFLT_FLG  --违约标志
					,CRDT_LMT_USE_FLG  --授信额度使用标志
					,GRO_LEND_FLG  --联保贷款标志
					,BLON_LOAN_FLG  --气球贷标志
					,CASE WHEN LEVEL10_CLS_MANU_MED_FLG = '1' THEN '1'
      WHEN LEVEL10_CLS_MANU_MED_FLG = '2' THEN '0' ELSE LEVEL10_CLS_MANU_MED_FLG END--十级分类人工干预标志
					,INSURE_COMP_FLG  --保险代偿标志
					,PBC_INC_LOAN_FLG  --人行普惠贷款标志
					,WHITE_LIST_CUST_FLG  --白户标志
					,FARM_FLG  --农户标志
					,PROD_TYPE_CD  --产品类型代码
					,LOAN_HAPP_TYPE_CD  --贷款发生类型代码
					,LOAN_TYPE_CD  --贷款类型代码
					,ASSET_THD_CLS_CD  --资产三分类代码
					,GUAR_WAY_CD  --担保方式代码
					,SUB_GUAR_WAY_CD  --子担保方式代码
					,REPAY_WAY_CD  --还款方式代码
					,DIR_INDUS_CD  --投向行业代码
					,DUBIL_STATUS_CD  --借据状态代码
					,REFAC_LOAN_STATUS_CD  --支小再贷款状态代码
					,COMP_INT_CALC_WAY_CD  --复利计算方式代码
					,INT_RAT_ADJ_PED_CORP_CD  --利率调整周期单位代码
					,INT_RAT_ADJ_PED_FREQ  --利率调整周期频率
					,LOAN_LEVEL4_CLS_CD  --贷款四级分类代码
					,LOAN_LEVEL5_CLS_CD  --贷款五级分类代码
					,LOAN_LEVEL10_CLS_CD  --贷款十级分类代码
					,LOAN_LEVEL12_CLS_CD  --贷款十二级分类代码
					,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
					,OVDUE_INT_RAT_ADJ_WAY  --逾期利率调整方式
					,INT_RAT_ADJ_EFFECT_WAY  --利率调整生效方式
					,INT_RAT_FLOAT_TENOR_CD  --利率浮动期限代码
					,ENTER_ACCT_PT_TYPE_CD  --入账账户支付工具类型代码
					,REPAY_ACCT_PT_TYPE_CD  --还款账户支付工具类型代码
					,DEDUCT_WAY_CD  --扣款方式代码
					,MODE_PAY_CD  --支付方式代码
					,CURR_CD  --币种代码
					,CUST_CHAR_CD  --客户性质代码
					,CUST_CRDT_TOT  --客户授信总额
					,LOAN_TYPE_DESCB  --贷款类型描述
					,ENTER_ACCT_NAME  --入账账户名称
					,CUST_MGR_ID  --客户经理编号
					,TRUST_CUST_MGR  --托管客户经理
					,RGST_TELLER_ID  --登记柜员编号
					,RGST_ORG_ID  --登记机构编号
					,ACCT_INSTIT_ID  --账务机构编号
					,MGMT_ORG_ID  --管理机构编号
					,DUBIL_OPEN_DT  --借据开立日期
					,DUBIL_EXP_DT  --借据到期日期
					,FIR_DISTR_DT  --首次放款日期
					,RECNT_REPAY_DT  --最近还款日期
					,REPAY_DAY  --还款日
					,PAYOFF_DT  --结清日期
					,PRIC_OVDUE_DT  --本金逾期日期
					,INT_OVDUE_DT  --利息逾期日期
					,LOAN_LEVEL5_CLS_DT  --贷款五级分类日期
					,LOAN_LEVEL10_CLS_DT  --贷款十级分类日期
					,LAST_LEVEL5_CLS_MODIF_DT  --上次五级分类变更日期
					,LAST_RISK_RGST_ADJ_RS  --上次风险登记调整原因
					,RISK_RGST_APVER_ID  --风险登记审批人编号
					,BASE_RAT  --基准利率
					,EXEC_INT_RAT  --执行利率
					,OVDUE_INT_RAT  --逾期利率
					,OVDUE_INT_RAT_FLO_VAL  --逾期利率浮动值
					,INT_RAT_FLO_VAL  --利率浮动值
					,PRIC_OVDUE_DAYS  --本金逾期天数
					,INT_OVDUE_DAYS  --利息逾期天数
					,GRACE_DAYS  --宽限天数
					,GRACE_PERIOD_START_DT  --宽限期开始日期
					,GRACE_PERIOD_EXP_DT  --宽限期到期日期
					,FINAL_PED_RESV_AMT  --最后一期保留金额
					,DUBIL_AMT  --借据金额
					,REFAC_LOAN_BATCH_PKG_ID  --支小再贷款批次包编号
					,REFAC_LOAN_BATCH_EXP_DT  --支小再贷款批次到期日期
					,REFAC_LOAN_USE_INT_RAT  --支小再贷款使用利率
					,JOB_CD  --任务代码
					,ETL_TIMESTAMP  --数据处理时间
    FROM ICL.V_CMM_RETL_LOAN_DUBIL_INFO  --视图-零售贷款借据信息
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
    OR ETL_DT = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')-1
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

  END ETL_INIT_O_ICL_CMM_RETL_LOAN_DUBIL_INFO;
/

