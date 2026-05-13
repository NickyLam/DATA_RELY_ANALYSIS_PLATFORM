CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO(I_P_DATE IN INTEGER,
                                                                  O_ERRCODE OUT VARCHAR2
                                                                  )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO
  *  功能描述：联合网贷贷款合同信息
  *  创建日期：20231009
  *  开发人员：HULIJUAN
  *  来源表： ICL.V_CMM_UNITE_WL_LOAN_CONT_INFO
  *  目标表： O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO
  *  配置表：
  *  修改情况：序号  修改日期   修改人      修改原因
  *             1    20231009   HULIJUAN    首次创建
  *             2    20250509   YJY         新增相关微业贷36个标签
  *             3    20251106   YJY         针对分期乐、微业贷3.0产品做接数处理，按照t天进行获取
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-联合网贷贷款合同信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO
    (ETL_DT                        --数据日期
    ,LP_ID                        --法人编号
    ,CONT_ID                      --合同编号
    ,CRDT_APPL_FLOW_NUM           --授信申请流水号
    ,CUST_ID                      --客户编号
    ,CUST_NAME                    --客户名称
    ,STD_PROD_ID                  --标准产品编号
    ,CRDT_TYPE_CD                 --授信类型代码
    ,APPL_TYPE_CD                 --申请类型代码
    ,CURR_CD                      --币种代码
    ,BASE_RAT_TYPE_CD             --基准利率类型代码
    ,INT_RAT_ADJ_WAY_CD           --利率调整方式代码
    ,CONT_STATUS_CD               --合同状态代码
    ,APV_STATUS_CD                --审批状态代码
    ,GUAR_WAY_CD                  --担保方式代码
    ,REPAY_WAY_CD                 --还款方式代码
    ,LOAN_USAGE_TYPE_CD           --贷款用途类型代码
    ,RECVBL_ACCT_NAME             --收款账户名称
    ,RECVBL_ACCT_OPEN_ORG_ID      --收款账户开户机构编号
    ,EXEC_INT_RAT                 --执行利率
    ,CONT_BAL                     --合同余额
    ,CONT_AMT                     --合同金额
    ,DISTR_AMT                    --放款金额
    ,TENOR                        --期限
    ,BEGIN_DT                     --起始日期
    ,EXP_DT                       --到期日期
    ,SIGN_DT                      --签订日期
    ,DISTR_DT                     --放款日期
    ,TERMNT_DT                    --终止日期
    ,SPEC_REPAY_DAY               --指定还款日
    ,OPERR_ID                     --经办人编号
    ,OPER_ORG_ID                  --经办机构编号
    ,OPER_DT                      --经办日期
    ,RGSTRAT_ID                   --登记人编号
    ,RGST_ORG_ID                  --登记机构编号
    ,RGST_DT                      --登记日期
    ,UPDATE_ID                    --更新人编号
    ,UPDATE_ORG_ID                --更新机构编号
    ,UPDATE_DT                    --更新日期
    ,JOB_CD                       --任务代码
    ,ADV_MAN_INDU_FLG             --先进制造业标志       ADD BY YJY 20250509
    ,GREEN_CRDT_FIN_FLG           --绿色信贷融资标志     ADD BY YJY 20250509
    ,CTY_LMT_INDUS_FLG            --国家限制行业标志	   ADD BY YJY 20250509
    ,HIGH_TECH_SERV_LOAN_FLG      --高技术服务业贷款标志 ADD BY YJY 20250509
    ,SCI_TECH_INOVT_CORP_FLG      --科创企业标志			   ADD BY YJY 20250509
    ,SCI_TECH_CORP_FLG            --科技型企业标志			  ADD BY YJY 20250509
    ,HIGH_NEW_TECH_CORP_FLG       --高新技术企业标志		 ADD BY YJY 20250509
    ,SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG --专精特新中小企业标志					  ADD BY YJY 20250509
    ,SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG --专精特新小巨人企业标志	ADD BY YJY 20250509
    ,PROVI_FOR_AGED_PROPERTY_FLG       --养老产业标志						 ADD BY YJY 20250509
    ,INDU_CORP_TECH_REM_UGD_FLG        --工业转型升级标识				 ADD BY YJY 20250509
    ,THREE_OLD_TF_OR_CITY_UPDATE_PROJ_FLG   --三旧改造或城市更新项目标志	ADD BY YJY 20250509
    ,BR_BUILD_IFIN_FLG             --一带一路建设投融资标志			ADD BY YJY 20250509
    ,SUP_CHAIN_FIN_BUS_FLG         --供应链金融业务标志					ADD BY YJY 20250509
    ,BUID_BUS_GUAR_LOAN_FLG        --创业担保贷款标志						 ADD BY YJY 20250509
    ,COUNTY_LOAN_FLG               --县城区贷款标志							ADD BY YJY 20250509
    ,OVERS_LOAN_FLG	               --境外贷款标志								 ADD BY YJY 20250509
    ,PPP_PROJ_FLG	                 --投向政府和社会资本合作项目标志				 ADD BY YJY 20250509
    ,CUL_PROPERTY_FLG	             --文化产业标志					 ADD BY YJY 20250509
    ,HIGH_TECH_PROPERTY_FLG	       --投向高技术产业标志		ADD BY YJY 20250509
    ,NEW_DISTR_FLG	               --新机制发放贷款标志		ADD BY YJY 20250509
    ,AGCLT_FLG	                   --涉农标志							 ADD BY YJY 20250509
    ,SEED_LOAN_FLG	               --种业振兴贷款标志			 ADD BY YJY 20250509
    ,PROJ_FIN_FLG	                 --项目融资标志				   ADD BY YJY 20250509
    ,LMT_OR_ENCRGE_INDUS_CD	       --限制或鼓励行业代码		ADD BY YJY 20250509
    ,SUP_CHAIN_FIN_BUS_PROD_CLS_CD --供应链金融业务产品分类代码		ADD BY YJY 20250509
    ,GUAR_PROJ_LOAN_TYPE_CD	       --保障性安居工程贷款类型				ADD BY YJY 20250509
    ,BUID_BUS_GUAR_LOAN_TYPE_CD	   --创业担保贷款类型代码				   ADD BY YJY 20250509
    ,ESTATE_LOAN_TYPE_CD	         --房地产贷款类型代码						ADD BY YJY 20250509
    ,STRATE_NEW_INDUS_TYPE_CD	     --战略性新兴产业类型代码				ADD BY YJY 20250509
    ,DIGIT_ECON_CORE_TYPE_CD	     --投向数字经济核心产业类型代码	 ADD BY YJY 20250509
    ,AGCLT_LOAN_MAIN_TYPE_CD		   --涉农贷款主体类型代码					 ADD BY YJY 20250509
    ,AGCLT_LOAN_DIR_CD			       --涉农贷款投向代码						   ADD BY YJY 20250509
    ,DIR_INDUS_CD				           --行业投向代码							     ADD BY YJY 20250509
    ,LOAN_FIN_SUPT_WAY_CD				   --贷款财政扶持方式代码					 ADD BY YJY 20250509
    ,SURP_INDUS_CD				         --过剩行业代码									 ADD BY YJY 20250509
    )
  SELECT /*ETL_DT + 1*/TO_DATE(V_P_DATE,'YYYYMMDD')   --数据日期  MOD BY YJY 20251106
        ,LP_ID                        --法人编号
        ,CONT_ID                      --合同编号
        ,CRDT_APPL_FLOW_NUM           --授信申请流水号
        ,CUST_ID                      --客户编号
        ,CUST_NAME                    --客户名称
        ,STD_PROD_ID                  --标准产品编号
        ,CRDT_TYPE_CD                 --授信类型代码
        ,APPL_TYPE_CD                 --申请类型代码
        ,CURR_CD                      --币种代码
        ,BASE_RAT_TYPE_CD             --基准利率类型代码
        ,INT_RAT_ADJ_WAY_CD           --利率调整方式代码
        ,CONT_STATUS_CD               --合同状态代码
        ,APV_STATUS_CD                --审批状态代码
        ,GUAR_WAY_CD                  --担保方式代码
        ,REPAY_WAY_CD                 --还款方式代码
        ,LOAN_USAGE_TYPE_CD           --贷款用途类型代码
        ,RECVBL_ACCT_NAME             --收款账户名称
        ,RECVBL_ACCT_OPEN_ORG_ID      --收款账户开户机构编号
        ,EXEC_INT_RAT                 --执行利率
        ,CONT_BAL                     --合同余额
        ,CONT_AMT                     --合同金额
        ,DISTR_AMT                    --放款金额
        ,TENOR                        --期限
        ,BEGIN_DT                     --起始日期
        ,EXP_DT                       --到期日期
        ,SIGN_DT                      --签订日期
        ,DISTR_DT                     --放款日期
        ,TERMNT_DT                    --终止日期
        ,SPEC_REPAY_DAY               --指定还款日
        ,OPERR_ID                     --经办人编号
        ,OPER_ORG_ID                  --经办机构编号
        ,OPER_DT                      --经办日期
        ,RGSTRAT_ID                   --登记人编号
        ,RGST_ORG_ID                  --登记机构编号
        ,RGST_DT                      --登记日期
        ,UPDATE_ID                    --更新人编号
        ,UPDATE_ORG_ID                --更新机构编号
        ,UPDATE_DT                    --更新日期
        ,JOB_CD                       --任务代码
        ,ADV_MAN_INDU_FLG             --先进制造业标志       ADD BY YJY 20250509
        ,GREEN_CRDT_FIN_FLG           --绿色信贷融资标志     ADD BY YJY 20250509
        ,CTY_LMT_INDUS_FLG            --国家限制行业标志	   ADD BY YJY 20250509
        ,HIGH_TECH_SERV_LOAN_FLG      --高技术服务业贷款标志 ADD BY YJY 20250509
        ,SCI_TECH_INOVT_CORP_FLG      --科创企业标志			   ADD BY YJY 20250509
        ,SCI_TECH_CORP_FLG            --科技型企业标志			  ADD BY YJY 20250509
        ,HIGH_NEW_TECH_CORP_FLG       --高新技术企业标志		 ADD BY YJY 20250509
        ,SPE_SOPH_UNQ_NEW_MED_SIDE_ENTER_FLG --专精特新中小企业标志		 ADD BY YJY 20250509
        ,SPE_SOPH_UNQ_NEW_LTE_GNT_CORP_FLG   --专精特新小巨人企业标志	ADD BY YJY 20250509
        ,PROVI_FOR_AGED_PROPERTY_FLG   --养老产业标志						 ADD BY YJY 20250509
        ,INDU_CORP_TECH_REM_UGD_FLG    --工业转型升级标识				 ADD BY YJY 20250509
        ,THREE_OLD_TF_OR_CITY_UPDATE_PROJ_FLG    --三旧改造或城市更新项目标志	ADD BY YJY 20250509
        ,BR_BUILD_IFIN_FLG             --一带一路建设投融资标志			ADD BY YJY 20250509
        ,SUP_CHAIN_FIN_BUS_FLG         --供应链金融业务标志					ADD BY YJY 20250509
        ,BUID_BUS_GUAR_LOAN_FLG        --创业担保贷款标志						 ADD BY YJY 20250509
        ,COUNTY_LOAN_FLG               --县城区贷款标志							ADD BY YJY 20250509
        ,OVERS_LOAN_FLG	               --境外贷款标志								 ADD BY YJY 20250509
        ,PPP_PROJ_FLG	                 --投向政府和社会资本合作项目标志				 ADD BY YJY 20250509
        ,CUL_PROPERTY_FLG	             --文化产业标志					 ADD BY YJY 20250509
        ,HIGH_TECH_PROPERTY_FLG	       --投向高技术产业标志		ADD BY YJY 20250509
        ,NEW_DISTR_FLG	               --新机制发放贷款标志		ADD BY YJY 20250509
        ,AGCLT_FLG	                   --涉农标志							 ADD BY YJY 20250509
        ,SEED_LOAN_FLG	               --种业振兴贷款标志			 ADD BY YJY 20250509
        ,PROJ_FIN_FLG	                 --项目融资标志				   ADD BY YJY 20250509
        ,LMT_OR_ENCRGE_INDUS_CD	       --限制或鼓励行业代码		ADD BY YJY 20250509
        ,SUP_CHAIN_FIN_BUS_PROD_CLS_CD --供应链金融业务产品分类代码		ADD BY YJY 20250509
        ,GUAR_PROJ_LOAN_TYPE_CD	       --保障性安居工程贷款类型				ADD BY YJY 20250509
        ,BUID_BUS_GUAR_LOAN_TYPE_CD	   --创业担保贷款类型代码				   ADD BY YJY 20250509
        ,ESTATE_LOAN_TYPE_CD	         --房地产贷款类型代码						ADD BY YJY 20250509
        ,STRATE_NEW_INDUS_TYPE_CD	     --战略性新兴产业类型代码				ADD BY YJY 20250509
        ,DIGIT_ECON_CORE_TYPE_CD	     --投向数字经济核心产业类型代码	 ADD BY YJY 20250509
        ,AGCLT_LOAN_MAIN_TYPE_CD		   --涉农贷款主体类型代码					 ADD BY YJY 20250509
        ,AGCLT_LOAN_DIR_CD			       --涉农贷款投向代码						   ADD BY YJY 20250509
        ,DIR_INDUS_CD				           --行业投向代码							     ADD BY YJY 20250509
        ,LOAN_FIN_SUPT_WAY_CD				   --贷款财政扶持方式代码					 ADD BY YJY 20250509
        ,SURP_INDUS_CD				         --过剩行业代码									 ADD BY YJY 20250509
    FROM ICL.V_CMM_UNITE_WL_LOAN_CONT_INFO --视图-联合网贷贷款合同信息
   WHERE --ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1;
         (STD_PROD_ID NOT IN ('202010200011','202010200010','201020100063') AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1) --其他联合网贷依旧按照t-1接数
      OR (STD_PROD_ID IN ('202010200011','202010200010','201020100063') AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) --分期乐、微业贷3.0按照t接数  MOD BY YJY 20251106
       ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO','', O_ERRCODE);

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

END ETL_O_ICL_CMM_UNITE_WL_LOAN_CONT_INFO;
/

