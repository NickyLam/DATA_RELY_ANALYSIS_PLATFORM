CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_RETL_LOAN_CONT_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_RETL_LOAN_CONT_INFO
  *  功能描述：零售贷款合同信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_RETL_LOAN_CONT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_ICL_CMM_RETL_LOAN_CONT_INFO'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'O_ICL_CMM_RETL_LOAN_CONT_INFO'; --表名

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_RETL_LOAN_CONT_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_RETL_LOAN_CONT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-零售贷款合同信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_RETL_LOAN_CONT_INFO
  (
                ETL_DT  --数据日期
                ,LP_ID  --法人编号
                ,CONT_ID  --合同编号
                ,CONT_NAME  --合同名称
                ,CUST_ID  --客户编号
                ,LMT_CONT_ID  --额度合同编号
                ,ENTER_ACCT_ID  --入账账户编号
                ,REPAY_ACCT_ID  --还款账户编号
                ,PROD_ID  --产品编号
                ,PROD_NAME  --产品名称
                ,APV_FLOW_NUM  --审批流水号
                ,INIT_DUBIL_ID  --原借据编号
                ,CONT_TYPE_CD  --合同类型代码
                ,CONT_STATUS_CD  --合同状态代码
                ,BUS_KIND_CD  --业务种类代码
                ,LOAN_HAPP_TYPE_CD  --贷款发生类型代码
                ,MAJOR_GUAR_WAY_CD  --主要担保方式代码
                ,SUB_GUAR_WAY_CD  --子担保方式代码
                ,BORW_USAGE_TYPE_CD  --借款用途类型代码
                ,DIR_INDUS_CD  --投向行业代码
                ,DISTR_WAY_CD  --发放方式代码
                ,MODE_PAY_CD  --支付方式代码
                ,TENOR_TYPE_CD  --期限类型代码
                ,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
                ,INT_RAT_FLOAT_DIR_CD  --利率浮动方向代码
                ,REPAY_FREQ_CD  --还款频率代码
                ,REPAY_DAY_CFM_CD  --还款日确定代码
                ,CURR_CD  --币种代码
                ,HOUSING_CNT_CD  --住房套数代码
                ,HIGH_TECH_PROPERTY_TYPE_CD  --高技术产业类型代码
                ,CRDT_LMT_USE_FLG  --授信额度使用标志
                ,DIGIT_ECON_CORE_PROPERTY_TYPE_CD  --数字经济核心产业类型代码
								,MORTG_FLG  --按揭标志
								,INTEL_PROP_INTE_PROPERTY_TYPE_CD  --知识产权密集型产业类型代码
								,GRO_LEND_FLG  --联保贷款标志
								,STRTG_NEW_INDUS_TYPE_CD  --战略新兴产业类型代码
								,BLON_LOAN_FLG  --气球贷标志
								,CUL_AND_RELA_PROPERTY_TYPE_CD  --文化及相关产业类型代码
								,GREEN_PASS_FLG  --绿色通道标志
								,AGCLT_FLG  --涉农标志
								,LOW_RISK_BUS_FLG  --低风险业务标志
								,GREEN_CRDT_FLG  --绿色信贷标志
								,BAR_FLG  --随借随还标志
								,GREEN_LOAN_USAGE_CD  --绿色贷款用途代码
								,ALLOW_STAGE_REPAY_FLG  --允许阶段性还款标志
								,GREEN_LOAN_USAGE_LEVEL2_CLS_CD  --绿色贷款用途二级分类代码
								,HXB_OPEN_SUPV_ACCT_FLG  --在我行开立监管账户标志
								,GREEN_LOAN_USAGE_LEVEL3_CLS_CD  --绿色贷款用途三级分类代码
								,INCRE_CRDT_MODE_CD  --增信模式代码
								,VEHIC_TYPE_CD  --车辆类型代码
								,ENTR_LOAN_FLG  --委托贷款标志
								,CSNER_CUST_NO  --委托人客户号
								,CSNER_CUST_NAME  --委托人客户名称
								,APPL_DT  --申请日期
								,APV_DT  --审批日期
								,SIGN_DT  --签约日期
								,CONT_CREATE_DT  --合同生成日期
								,START_DT  --起始日期
								,TERMNT_DT  --终止日期
								,EXP_DT  --到期日期
								,CUST_MGR_ID  --客户经理编号
								,RGST_ORG_ID  --登记机构编号
								,MGMT_ORG_ID  --管理机构编号
								,ACCT_INSTIT_ID  --账务机构编号
								,CRDT_LOAN_FLG  --信用贷款标志
								,CRDT_LOAN_REPLY_FLOW_NUM  --信用贷款批复流水号
								,COPRATOR_ID  --合作商编号
								,COPRATOR_NAME  --合作商名称
								,USE_COPRATOR_LMT_FLG  --使用合作商额度标志
								,COPRATOR_AGT_ID  --合作商协议编号
								,COPRATOR_STAND_B_ID  --合作商台账编号
								,COPRATOR_PROJ_TYPE_CD  --合作商项目类型代码
								,COPRATOR_TYPE_CD  --合作商类型代码
								,BASE_RAT  --基准利率
								,EXEC_INT_RAT  --执行利率
								,REPAY_DAY  --还款日
								,TENOR  --期限
								,PM_GUAR_TOT  --抵质押担保总额
								,AVG_PM_RAT  --平均抵质押率
								,CONT_AMT  --合同金额
								,CONT_AVAL_BAL  --合同可用余额
								,ACM_DISTR_AMT  --累计发放金额
								,ACM_CALLBK_AMT  --累计回收金额
								,JOB_CD  --任务代码
								,ETL_TIMESTAMP  --数据处理时间
    )
    SELECT
								ETL_DT  --数据日期
								,LP_ID  --法人编号
								,CONT_ID  --合同编号
								,CONT_NAME  --合同名称
								,CUST_ID  --客户编号
								,LMT_CONT_ID  --额度合同编号
								,ENTER_ACCT_ID  --入账账户编号
								,REPAY_ACCT_ID  --还款账户编号
								,PROD_ID  --产品编号
								,PROD_NAME  --产品名称
								,APV_FLOW_NUM  --审批流水号
								,INIT_DUBIL_ID  --原借据编号
								,CONT_TYPE_CD  --合同类型代码
								,CONT_STATUS_CD  --合同状态代码
								,BUS_KIND_CD  --业务种类代码
								,LOAN_HAPP_TYPE_CD  --贷款发生类型代码
								,MAJOR_GUAR_WAY_CD  --主要担保方式代码
								,SUB_GUAR_WAY_CD  --子担保方式代码
								,BORW_USAGE_TYPE_CD  --借款用途类型代码
								,DIR_INDUS_CD  --投向行业代码
								,DISTR_WAY_CD  --发放方式代码
								,MODE_PAY_CD  --支付方式代码
								,TENOR_TYPE_CD  --期限类型代码
								,INT_RAT_ADJ_WAY_CD  --利率调整方式代码
								,INT_RAT_FLOAT_DIR_CD  --利率浮动方向代码
								,REPAY_FREQ_CD  --还款频率代码
								,REPAY_DAY_CFM_CD  --还款日确定代码
								,CURR_CD  --币种代码
								,HOUSING_CNT_CD  --住房套数代码
								,HIGH_TECH_PROPERTY_TYPE_CD  --高技术产业类型代码
								,CRDT_LMT_USE_FLG  --授信额度使用标志
								,DIGIT_ECON_CORE_PROPERTY_TYPE_CD  --数字经济核心产业类型代码
								,MORTG_FLG  --按揭标志
								,INTEL_PROP_INTE_PROPERTY_TYPE_CD  --知识产权密集型产业类型代码
								,GRO_LEND_FLG  --联保贷款标志
								,STRTG_NEW_INDUS_TYPE_CD  --战略新兴产业类型代码
								,BLON_LOAN_FLG  --气球贷标志
								,CUL_AND_RELA_PROPERTY_TYPE_CD  --文化及相关产业类型代码
								,GREEN_PASS_FLG  --绿色通道标志
								,AGCLT_FLG  --涉农标志
								,LOW_RISK_BUS_FLG  --低风险业务标志
								,GREEN_CRDT_FLG  --绿色信贷标志
								,BAR_FLG  --随借随还标志
								,GREEN_LOAN_USAGE_CD  --绿色贷款用途代码
								,ALLOW_STAGE_REPAY_FLG  --允许阶段性还款标志
								,GREEN_LOAN_USAGE_LEVEL2_CLS_CD  --绿色贷款用途二级分类代码
								,HXB_OPEN_SUPV_ACCT_FLG  --在我行开立监管账户标志
								,GREEN_LOAN_USAGE_LEVEL3_CLS_CD  --绿色贷款用途三级分类代码
								,INCRE_CRDT_MODE_CD  --增信模式代码
								,VEHIC_TYPE_CD  --车辆类型代码
								,ENTR_LOAN_FLG  --委托贷款标志
								,CSNER_CUST_NO  --委托人客户号
								,CSNER_CUST_NAME  --委托人客户名称
								,APPL_DT  --申请日期
								,APV_DT  --审批日期
								,SIGN_DT  --签约日期
								,CONT_CREATE_DT  --合同生成日期
								,START_DT  --起始日期
								,TERMNT_DT  --终止日期
								,EXP_DT  --到期日期
								,CUST_MGR_ID  --客户经理编号
								,RGST_ORG_ID  --登记机构编号
								,MGMT_ORG_ID  --管理机构编号
								,ACCT_INSTIT_ID  --账务机构编号
								,CRDT_LOAN_FLG  --信用贷款标志
								,CRDT_LOAN_REPLY_FLOW_NUM  --信用贷款批复流水号
								,COPRATOR_ID  --合作商编号
								,COPRATOR_NAME  --合作商名称
								,USE_COPRATOR_LMT_FLG  --使用合作商额度标志
								,COPRATOR_AGT_ID  --合作商协议编号
								,COPRATOR_STAND_B_ID  --合作商台账编号
								,COPRATOR_PROJ_TYPE_CD  --合作商项目类型代码
								,COPRATOR_TYPE_CD  --合作商类型代码
								,BASE_RAT  --基准利率
								,EXEC_INT_RAT  --执行利率
								,REPAY_DAY  --还款日
								,TENOR  --期限
								,PM_GUAR_TOT  --抵质押担保总额
								,AVG_PM_RAT  --平均抵质押率
								,CONT_AMT  --合同金额
								,CONT_AVAL_BAL  --合同可用余额
								,ACM_DISTR_AMT  --累计发放金额
								,ACM_CALLBK_AMT  --累计回收金额
								,JOB_CD  --任务代码
								,ETL_TIMESTAMP  --数据处理时间

    FROM ICL.V_CMM_RETL_LOAN_CONT_INFO  --视图-零售贷款合同信息
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

  END ETL_INIT_O_ICL_CMM_RETL_LOAN_CONT_INFO;
/

