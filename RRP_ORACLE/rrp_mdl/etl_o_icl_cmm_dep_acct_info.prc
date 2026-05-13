CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_DEP_ACCT_INFO(I_P_DATE IN INTEGER,
                                                        O_ERRCODE OUT VARCHAR2
                                                        )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_DEP_ACCT_INFO
  *  功能描述：存款分户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_DEP_ACCT_INFO
  *  目标表： O_ICL_CMM_DEP_ACCT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20221615           修改参数
  *             3    20231110  hulj     优化O层
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
  V_TAB_NAME  VARCHAR2(100) := 'O_ICL_CMM_DEP_ACCT_INFO'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_ICL_CMM_DEP_ACCT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO';
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
  V_STEP_DESC := '数据落地-存款分户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO
    (ETL_DT			                  --数据日期
    ,LP_ID			                  --法人编号
    ,ACCT_ID			                --账户编号
    ,ACCT_NAME			              --账户名称
    ,CUST_ACCT_ID			            --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM			  --客户账户子户号
    ,CDS_LIAB_ACCT_NUM			      --负债账户编号
    ,OLD_ACCT_ID			            --旧账户编号
    ,OLD_CUST_ACCT_SUB_ACCT_NUM		--旧客户账户子户号
    ,CUST_ACCT_CARD_NO			      --客户账户卡号
    ,CUST_ID			                --客户编号
    ,SUBJ_ID			                --科目编号
    ,INT_PAYBL_SUBJ_ID			      --应付利息科目编号
    ,INT_PAYBL_ADJ_SUBJ_ID	 		  --应付利息调整科目编号
    ,INT_EXPNS_SUBJ_ID			      --利息支出科目编号
    ,INT_EXPNS_ADJ_SUBJ_ID			  --利息支出调整科目编号
    ,DEP_KIND_CD			            --储种代码
    ,ACCT_CLS_CD			            --账户分类代码
    ,ACCT_TYPE_CD			            --账户类型代码
    ,ACCT_ATTR_CD			            --账户属性代码
    ,DEP_TERM			                --存期
    ,DEP_TERM_TENOR_TYPE_CD			  --存期期限类型代码
    ,STD_PROD_ID			            --标准产品编号
    ,EXT_PROD_ID			            --外部产品编号
    ,INTNAL_PROD_ID			          --内部产品编号
    ,PD_ID			                  --期次编号
    ,OPEN_OA_APV_FORM_NUM			    --开户OA审批单号
    ,APPROVAL_ID			            --核准件编号
    ,DEP_ACCT_STATUS_CD			      --存款账户状态代码
    ,CUST_TYPE_CD			            --客户类型代码
    ,CORP_ACCT_FLG			          --对公账户标志
    ,STOP_PAY_STATUS_CD			      --止付状态代码
    ,GENERAL_EXCH_FLG			        --通兑标志
    ,GENERAL_EXCH_ORG_ID			    --通兑机构编号
    ,GENERAL_STORAGE_FLG			    --通存标志
    ,ADVISE_DEP_FLG			          --通知存款标志
    ,AGT_DEP_FLG			            --协议存款标志
    ,FLOAT_INT_RAT_FLG			      --浮动利率标志
    ,INT_RAT_FLOAT_WAY_CD			    --利率浮动方式代码
    ,INT_RAT_ADJ_PED_CORP_CD			--利率调整周期单位代码
    ,INT_RAT_ADJ_PED_FREQ			    --利率调整周期频率
    ,CORP_SUPV_ACCT_FLG			      --对公监管户标志
    ,RC_FLG			                  --定活标志
    ,MARGIN_FLG			              --保证金标志
    ,BILL_POOL_MARGIN_FLG			    --票据池保证金标志
    ,BILL_POOL_TYPE_CD			      --票据池类型代码
    ,AGREE_DEP_FLG			          --协定存款标志
    ,IBANK_DEP_FLG			          --同业存款标志
    ,WEB_DEP_FLG			            --网络存款标志
    ,DEP_BASIC_ACCT_FLG			      --存款基本户标志
    ,EC_FLG			                  --钞汇标志
    ,PRIVAVY_ACCT_FLG			        --隐私账户标志
    ,LEGAL_ACCT_FLG			          --涉案账户标志
    ,AUTO_REDT_FLG			          --自动转存标志
    ,REDTED_CNT			              --已转存次数
    ,ITG_DEP_EARLIEST_DRAWBL_DT		--智能存款最早可提支日期
    ,SLEEP_ACCT_FLG			          --睡眠户标志
    ,DORMT_ACCT_FLG			          --不动户标志
    ,LONG_HANG_ACCT_FLG			      --久悬户标志
    ,VTUAL_ACCT_FLG			          --虚拟账户标志
    ,ENTRY_FLG			              --记账标志
    ,MATER_ACCT_FLG			          --母户标志
    ,SAL_ACCT_FLG			            --工资账户标志
    ,FROZ_FLG			                --冻结标志
    ,ADVD_DRAW_FLG			          --可提前支取标志
    ,TRANBL_FLG			              --可转让标志
    ,DELAY_PAY_INT_FLG			      --延期付息标志
    ,DELAY_PAY_INT_DAYS			      --延期付息天数
    ,INT_ACCR_BASE_CD			        --计息基准代码
    ,INT_ACCR_FLG			            --计息标志
    ,CASH_FLG			                --取现标志
    ,INT_SET_WAY_CD			          --结息方式代码
    ,INT_ACCR_WAY_CD			        --计息方式代码
    ,ALLOW_OD_FLG			            --允许透支标志
    ,CURR_CD			                --币种代码
    ,REDT_WAY_CD			            --转存方式代码
    ,OPEN_ACCT_CHN_TYPE_CD			  --开户渠道类型代码
    ,TRAN_CHN_STATUS_CD			      --交易渠道状态代码
    ,ACCT_USAGE_CD			          --账户用途代码
    ,DEP_CHAR_CD			            --存款性质代码
    ,OPEN_ACCT_DT			            --开户日期
    ,OPEN_ACCT_TM			            --开户时间
    ,OPEN_FLOW_NUM			          --开户流水号
    ,CLOS_ACCT_DT			            --销户日期
    ,CLOS_ACCT_TM			            --销户时间
    ,CLOS_FLOW_NUM			          --销户流水号
    ,ACTV_DT			                --激活日期
    ,VALUE_DT			                --起息日期
    ,EXP_DT			                  --到期日期
    ,TURN_DORMT_ACCT_DT			      --转不动户日期
    ,FINAL_ACTIV_ACCT_DT			    --最后动户日期
    ,AGREE_DEP_VALUE_DT			      --协定存款起息日期
    ,AGREE_DEP_EXP_DT			        --协定存款到期日期
    ,AGREE_DEP_RELS_DT			      --协定存款解约日期
    ,AGT_DEP_EARLIEST_DRAWBL_DT		--协议存款最早可提支日期
    ,FROZ_DT			                --冻结日期
    ,UNFRZ_DT			                --解冻日期
    ,LAST_INT_SET_DT			        --上次结息日期
    ,NEXT_INT_SET_DT			        --下次结息日期
    ,FIR_VALUE_DT			            --首次起息日期
    ,AGREE_INT_RAT			          --协定利率
    ,BASE_RAT_TYPE_CD			        --基准利率类型代码
    ,BASE_RAT			                --基准利率
    ,EXEC_INT_RAT			            --执行利率
    ,TD_ACRU_INT			            --当日应计利息
    ,CURRT_ACRU_INT			          --当期应计利息
    ,CURRT_INT_PAYBL_ADJ			    --当期应付利息调整
    ,TD_INT_EXPNS			            --当日利息支出
    ,TD_INT_EXPNS_ADJ			        --当日利息支出调整
    ,CUST_MGR_ID			            --客户经理编号
    ,OPEN_ACCT_TELLER_ID			    --开户柜员编号
    ,CLOS_ACCT_TELLER_ID			    --销户柜员编号
    ,OPEN_ACCT_ORG_ID			        --开户机构编号
    ,CLOSE_ACCT_ORG_ID			      --销户机构编号
    ,BELONG_ORG_ID			          --所属机构编号
    ,LOC_FLG			                --开立存款证实书标志
    ,EXPE_HIGT_YLD_RAT			      --预期最高收益率
    ,AGREE_DEP_INIT_AMT			      --协定存款起存金额
    ,LOWT_BAL			                --最低余额 
    ,OPEN_ACCT_AMT			          --开户金额
    ,CURRT_BAL			              --当期余额
    ,AVAL_BAL			                --可用余额
    ,FROZ_AMT			                --冻结金额
    ,STOP_PAY_AMT			            --止付金额
    ,CL_CURR_CURRT_BAL			      --折本币当期余额
    ,EAR_D_BAL			              --日初余额
    ,EAR_M_BAL			              --月初余额
    ,EAR_S_BAL			              --季初余额
    ,EAR_Y_BAL			              --年初余额
    ,Y_ACM_BAL			              --年累计余额
    ,S_ACM_BAL			              --季累计余额
    ,M_ACM_BAL			              --月累计余额
    ,CL_CURR_EAR_D_BAL			      --折本币日初余额
    ,CL_CURR_EAR_M_BAL			      --折本币月初余额
    ,CL_CURR_EAR_S_BAL			      --折本币季初余额
    ,CL_CURR_EAR_Y_BAL			      --折本币年初余额
    ,CL_CURR_Y_ACM_BAL			      --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL			--折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL			--折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL			--折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL			--折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL			      --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL			--折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL			--折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL			--折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL			      --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL			--折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL			--折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL			--折本币年初月累计余额
    ,Y_AVG_BAL			              --年日均余额
    ,Q_AVG_BAL			              --季日均余额
    ,M_AVG_BAL			              --月日均余额
    ,CL_CURR_Y_AVG_BAL			      --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL			      --折本币季日均余额
    ,CL_CURR_M_AVG_BAL			      --折本币月日均余额
    ,JOB_CD			                  --任务代码
    ,ETL_TIMESTAMP			          --etl处理时间
    ,OVER_TERM_EXEC_INT_RAT			  --超期执行利率
    )
  SELECT 
     ETL_DT			                  --数据日期
    ,LP_ID			                  --法人编号
    ,ACCT_ID			                --账户编号
    ,ACCT_NAME			              --账户名称
    ,CUST_ACCT_ID			            --客户账户编号
    ,CUST_ACCT_SUB_ACCT_NUM			  --客户账户子户号
    ,CDS_LIAB_ACCT_NUM			      --负债账户编号
    ,OLD_ACCT_ID			            --旧账户编号
    ,OLD_CUST_ACCT_SUB_ACCT_NUM		--旧客户账户子户号
    ,CUST_ACCT_CARD_NO			      --客户账户卡号
    ,CUST_ID			                --客户编号
    ,SUBJ_ID			                --科目编号
    ,INT_PAYBL_SUBJ_ID			      --应付利息科目编号
    ,INT_PAYBL_ADJ_SUBJ_ID	 		  --应付利息调整科目编号
    ,INT_EXPNS_SUBJ_ID			      --利息支出科目编号
    ,INT_EXPNS_ADJ_SUBJ_ID			  --利息支出调整科目编号
    ,DEP_KIND_CD			            --储种代码
    ,ACCT_CLS_CD			            --账户分类代码
    ,ACCT_TYPE_CD			            --账户类型代码
    ,ACCT_ATTR_CD			            --账户属性代码
    ,DEP_TERM			                --存期
    ,DEP_TERM_TENOR_TYPE_CD			  --存期期限类型代码
    ,STD_PROD_ID			            --标准产品编号
    ,EXT_PROD_ID			            --外部产品编号
    ,INTNAL_PROD_ID			          --内部产品编号
    ,PD_ID			                  --期次编号
    ,OPEN_OA_APV_FORM_NUM			    --开户OA审批单号
    ,APPROVAL_ID			            --核准件编号
    ,DEP_ACCT_STATUS_CD			      --存款账户状态代码
    ,CUST_TYPE_CD			            --客户类型代码
    ,CORP_ACCT_FLG			          --对公账户标志
    ,STOP_PAY_STATUS_CD			      --止付状态代码
    ,GENERAL_EXCH_FLG			        --通兑标志
    ,GENERAL_EXCH_ORG_ID			    --通兑机构编号
    ,GENERAL_STORAGE_FLG			    --通存标志
    ,ADVISE_DEP_FLG			          --通知存款标志
    ,AGT_DEP_FLG			            --协议存款标志
    ,FLOAT_INT_RAT_FLG			      --浮动利率标志
    ,INT_RAT_FLOAT_WAY_CD			    --利率浮动方式代码
    ,INT_RAT_ADJ_PED_CORP_CD			--利率调整周期单位代码
    ,INT_RAT_ADJ_PED_FREQ			    --利率调整周期频率
    ,CORP_SUPV_ACCT_FLG			      --对公监管户标志
    ,RC_FLG			                  --定活标志
    ,MARGIN_FLG			              --保证金标志
    ,BILL_POOL_MARGIN_FLG			    --票据池保证金标志
    ,BILL_POOL_TYPE_CD			      --票据池类型代码
    ,AGREE_DEP_FLG			          --协定存款标志
    ,IBANK_DEP_FLG			          --同业存款标志
    ,WEB_DEP_FLG			            --网络存款标志
    ,DEP_BASIC_ACCT_FLG			      --存款基本户标志
    ,EC_FLG			                  --钞汇标志
    ,PRIVAVY_ACCT_FLG			        --隐私账户标志
    ,LEGAL_ACCT_FLG			          --涉案账户标志
    ,AUTO_REDT_FLG			          --自动转存标志
    ,REDTED_CNT			              --已转存次数
    ,ITG_DEP_EARLIEST_DRAWBL_DT		--智能存款最早可提支日期
    ,SLEEP_ACCT_FLG			          --睡眠户标志
    ,DORMT_ACCT_FLG			          --不动户标志
    ,LONG_HANG_ACCT_FLG			      --久悬户标志
    ,VTUAL_ACCT_FLG			          --虚拟账户标志
    ,ENTRY_FLG			              --记账标志
    ,MATER_ACCT_FLG			          --母户标志
    ,SAL_ACCT_FLG			            --工资账户标志
    ,FROZ_FLG			                --冻结标志
    ,ADVD_DRAW_FLG			          --可提前支取标志
    ,TRANBL_FLG			              --可转让标志
    ,DELAY_PAY_INT_FLG			      --延期付息标志
    ,DELAY_PAY_INT_DAYS			      --延期付息天数
    ,INT_ACCR_BASE_CD			        --计息基准代码
    ,INT_ACCR_FLG			            --计息标志
    ,CASH_FLG			                --取现标志
    ,INT_SET_WAY_CD			          --结息方式代码
    ,INT_ACCR_WAY_CD			        --计息方式代码
    ,ALLOW_OD_FLG			            --允许透支标志
    ,CURR_CD			                --币种代码
    ,REDT_WAY_CD			            --转存方式代码
    ,OPEN_ACCT_CHN_TYPE_CD			  --开户渠道类型代码
    ,TRAN_CHN_STATUS_CD			      --交易渠道状态代码
    ,ACCT_USAGE_CD			          --账户用途代码
    ,DEP_CHAR_CD			            --存款性质代码
    ,OPEN_ACCT_DT			            --开户日期
    ,OPEN_ACCT_TM			            --开户时间
    ,OPEN_FLOW_NUM			          --开户流水号
    ,CLOS_ACCT_DT			            --销户日期
    ,CLOS_ACCT_TM			            --销户时间
    ,CLOS_FLOW_NUM			          --销户流水号
    ,ACTV_DT			                --激活日期
    ,VALUE_DT			                --起息日期
    ,EXP_DT			                  --到期日期
    ,TURN_DORMT_ACCT_DT			      --转不动户日期
    ,FINAL_ACTIV_ACCT_DT			    --最后动户日期
    ,AGREE_DEP_VALUE_DT			      --协定存款起息日期
    ,AGREE_DEP_EXP_DT			        --协定存款到期日期
    ,AGREE_DEP_RELS_DT			      --协定存款解约日期
    ,AGT_DEP_EARLIEST_DRAWBL_DT		--协议存款最早可提支日期
    ,FROZ_DT			                --冻结日期
    ,UNFRZ_DT			                --解冻日期
    ,LAST_INT_SET_DT			        --上次结息日期
    ,NEXT_INT_SET_DT			        --下次结息日期
    ,FIR_VALUE_DT			            --首次起息日期
    ,AGREE_INT_RAT			          --协定利率
    ,BASE_RAT_TYPE_CD			        --基准利率类型代码
    ,BASE_RAT			                --基准利率
    ,EXEC_INT_RAT			            --执行利率
    ,TD_ACRU_INT			            --当日应计利息
    ,CURRT_ACRU_INT			          --当期应计利息
    ,CURRT_INT_PAYBL_ADJ			    --当期应付利息调整
    ,TD_INT_EXPNS			            --当日利息支出
    ,TD_INT_EXPNS_ADJ			        --当日利息支出调整
    ,CUST_MGR_ID			            --客户经理编号
    ,OPEN_ACCT_TELLER_ID			    --开户柜员编号
    ,CLOS_ACCT_TELLER_ID			    --销户柜员编号
    ,OPEN_ACCT_ORG_ID			        --开户机构编号
    ,CLOSE_ACCT_ORG_ID			      --销户机构编号
    ,BELONG_ORG_ID			          --所属机构编号
    ,LOC_FLG			                --开立存款证实书标志
    ,EXPE_HIGT_YLD_RAT			      --预期最高收益率
    ,AGREE_DEP_INIT_AMT			      --协定存款起存金额
    ,LOWT_BAL			                --最低余额 
    ,OPEN_ACCT_AMT			          --开户金额
    ,CURRT_BAL			              --当期余额
    ,AVAL_BAL			                --可用余额
    ,FROZ_AMT			                --冻结金额
    ,STOP_PAY_AMT			            --止付金额
    ,CL_CURR_CURRT_BAL			      --折本币当期余额
    ,EAR_D_BAL			              --日初余额
    ,EAR_M_BAL			              --月初余额
    ,EAR_S_BAL			              --季初余额
    ,EAR_Y_BAL			              --年初余额
    ,Y_ACM_BAL			              --年累计余额
    ,S_ACM_BAL			              --季累计余额
    ,M_ACM_BAL			              --月累计余额
    ,CL_CURR_EAR_D_BAL			      --折本币日初余额
    ,CL_CURR_EAR_M_BAL			      --折本币月初余额
    ,CL_CURR_EAR_S_BAL			      --折本币季初余额
    ,CL_CURR_EAR_Y_BAL			      --折本币年初余额
    ,CL_CURR_Y_ACM_BAL			      --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL			--折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL			--折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL			--折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL			--折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL			      --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL			--折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL			--折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL			--折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL			      --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL			--折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL			--折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL			--折本币年初月累计余额
    ,Y_AVG_BAL			              --年日均余额
    ,Q_AVG_BAL			              --季日均余额
    ,M_AVG_BAL			              --月日均余额
    ,CL_CURR_Y_AVG_BAL			      --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL			      --折本币季日均余额
    ,CL_CURR_M_AVG_BAL			      --折本币月日均余额
    ,JOB_CD			                  --任务代码
    ,ETL_TIMESTAMP			          --etl处理时间
    ,OVER_TERM_EXEC_INT_RAT			  --超期执行利率
    FROM ICL.V_CMM_DEP_ACCT_INFO --视图-存款分户信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
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

END ETL_O_ICL_CMM_DEP_ACCT_INFO;
/

