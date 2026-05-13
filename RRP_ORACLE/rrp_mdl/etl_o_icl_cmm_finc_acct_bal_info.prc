CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_FINC_ACCT_BAL_INFO(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_FINC_ACCT_BAL_INFO
  *  功能描述：国结账户
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_FINC_ACCT_BAL_INFO
  *  目标表： O_ICL_CMM_FINC_ACCT_BAL_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
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
  V_TAB_NAME  VARCHAR2(100) := 'O_ICL_CMM_FINC_ACCT_BAL_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_FINC_ACCT_BAL_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_FINC_ACCT_BAL_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_FINC_ACCT_BAL_INFO';
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
  V_STEP_DESC := '数据落地-国结账户';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_FINC_ACCT_BAL_INFO
    (ETL_DT                     --ETL处理日期
    ,LP_ID                      --法人编号
    ,TRAN_ACCT_ID               --交易账户编号
    ,PROD_ID                    --产品编号
    ,STD_PROD_ID                --标准产品编号
    ,PROD_NAME                  --产品名称
    ,SUBJ_ID                    --科目编号
    ,PRFT_ADJ_SUBJ_ID           --收益调整科目编号
    ,CUST_ID                    --客户编号
    ,CUST_TYPE_CD               --客户类型代码
    ,FINC_ACCT_ID               --理财账户编号
    ,CONT_ID                    --合约编号
    ,OPEN_DT                    --开立日期
    ,LAST_ACTIV_ACCT_DT         --上次动户日期
    ,ACCT_STATUS_CD             --账户状态代码
    ,OPEN_ORG_ID                --开立机构编号
    ,CUST_MGR_ID                --客户经理编号
    ,CAP_STL_ACCT_NUM           --资金结算账号
    ,SELLER_CD                  --销售商代码
    ,BANK_ID                    --银行编号
    ,PRFT_FEA_CD                --收益特征代码
    ,DIVD_WAY_CD                --分红方式代码
    ,TARD_WAY_CD                --交易方式代码
    ,PROD_STATUS_CD             --产品状态代码
    ,PROD_RISK_LEVEL_CD         --产品风险等级代码
    ,PRFT_EMBODY_WAY_CD         --收益体现方式代码
    ,CHARGE_WAY_CD              --收费方式代码
    ,CTRL_FLG_COMB              --控制标志组合
    ,PROD_FOUND_DT              --产品成立日期
    ,ALLOW_BUY_BEGIN_DAY        --允许购买起始日
    ,ALLOW_BUY_EXP_DAY          --允许购买到期日
    ,PROD_PED_DAYS              --产品周期天数
    ,EXPE_YLD_RAT               --预期收益率
    ,ANNUAL_YLD_RAT             --年化收益率
    ,OPEN_FLG                   --开放式标志
    ,EC_FLG                     --钞汇标志
    ,INDV_ALLOW_BUY_FLG         --个人允许购买标志
    ,INPWN_FLG                  --质押标志
    ,PROD_TEPLA_ID              --产品模板编号
    ,PROD_TEPLA_COMNT           --产品模板说明
    ,BRKEVN_FLG                 --保本标志
    ,PURCH_DT                   --申购日期
    ,EXP_DT                     --到期日期
    ,VALUE_DT                   --起息日期
    ,PRFT_EXP_DAY               --收益到期日
    ,ACTL_VALUE_DT              --实际起息日期
    ,ACTL_EXP_DT                --实际到期日期
    ,CURR_CD                    --币种代码
    ,ACCT_BAL                   --账户余额
    ,MK_VAL_BAL                 --市值余额
    ,SUBSCR_TOT_AMT             --认购总金额
    ,SUBSCR_TOT_LOT             --认购总份额
    ,REDEM_LOT                  --赎回份额
    ,REDEM_AMT                  --赎回金额
    ,CURR_LOT                   --当前份额
    ,AVAL_LOT                   --可用份额
    ,TRAN_FROZ_LOT              --交易冻结份额
    ,LONTERM_FROZ_LOT           --长期冻结份额
    ,LOC_FROZ_LOT               --本地冻结份额
    ,PROD_FEE_F_UNIT_NV         --产品费前单位净值
    ,PROD_FEE_POST_CORP_NV      --产品费后单位净值
    ,TD_CUST_YLD_RAT			      --当日客户收益率
    ,PROD_FEE_BF_TEN_THOUS_PRFT	--产品费前万份收益
    ,TD_PRFT			              --本日收益
    ,INVEST_PRFT			          --投资收益
    ,CURR_ISSUE_PRFT			      --本期收益
    ,CL_CURR_ACCT_BAL			      --折本币账户余额
    ,EAR_D_BAL			            --日初余额
    ,EAR_M_BAL			            --月初余额
    ,EAR_S_BAL			            --季初余额
    ,EAR_Y_BAL			            --年初余额
    ,M_ACM_BAL			            --月累计余额
    ,S_ACM_BAL			            --季累计余额
    ,Y_ACM_BAL			            --年累计余额
    ,CL_CURR_EAR_D_BAL			    --折本币日初余额
    ,CL_CURR_EAR_M_BAL			    --折本币月初余额
    ,CL_CURR_EAR_S_BAL			    --折本币季初余额
    ,CL_CURR_EAR_Y_BAL			    --折本币年初余额
    ,CL_CURR_Y_ACM_BAL			    --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL	  --折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL		--折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL		--折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL		--折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL			    --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL		--折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL		--折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL		--折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL			    --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL		--折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL		--折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL		--折本币年初月累计余额
    ,Y_AVG_BAL			            --年日均余额
    ,Q_AVG_BAL			            --季日均余额
    ,M_AVG_BAL			            --月日均余额
    ,CL_CURR_Y_AVG_BAL			    --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL			    --折本币季日均余额
    ,CL_CURR_M_AVG_BAL			    --折本币月日均余额
    ,CL_CURR_MK_VAL_BAL			    --折本币市值余额
    ,EAR_D_MK_VAL_BAL			      --日初市值余额
    ,EAR_M_MK_VAL_BAL			      --月初市值余额
    ,EAR_S_MK_VAL_BAL			      --季初市值余额
    ,EAR_Y_MK_VAL_BAL			      --年初市值余额
    ,M_ACM_MK_VAL_BAL			      --月累计市值余额
    ,S_ACM_MK_VAL_BAL			      --季累计市值余额
    ,Y_ACM_MK_VAL_BAL			      --年累计市值余额
    ,CL_CURR_EAR_D_MK_VAL_BAL		--折本币日初市值余额
    ,CL_CURR_EAR_M_MK_VAL_BAL		--折本币月初市值余额
    ,CL_CURR_EAR_S_MK_VAL_BAL		--折本币季初市值余额
    ,CL_CURR_EAR_Y_MK_VAL_BAL		--折本币年初市值余额
    ,CL_CURR_Y_ACM_MK_VAL_BAL		--折本币年累计市值余额
    ,CL_CURR_EAR_D_Y_ACM_MK_VAL_BAL			--折本币日初年累计市值余额
    ,CL_CURR_EAR_M_Y_ACM_MK_VAL_BAL			--折本币月初年累计市值余额
    ,CL_CURR_EAR_S_Y_ACM_MK_VAL_BAL			--折本币季初年累计市值余额
    ,CL_CURR_EAR_Y_Y_ACM_MK_VAL_BAL			--折本币年初年累计市值余额
    ,CL_CURR_S_ACM_MK_VAL_BAL			      --折本币季累计市值余额
    ,CL_CURR_EAR_D_S_ACM_MK_VAL_BAL			--折本币日初季累计市值余额
    ,CL_CURR_EAR_S_S_ACM_MK_VAL_BAL			--折本币季初季累计市值余额
    ,CL_CURR_EAR_Y_S_ACM_MK_VAL_BAL			--折本币年初季累计市值余额
    ,CL_CURR_M_ACM_MK_VAL_BAL			      --折本币月累计市值余额
    ,CL_CURR_EAR_D_M_ACM_MK_VAL_BAL			--折本币日初月累计市值余额
    ,CL_CURR_EAR_M_M_ACM_MK_VAL_BAL			--折本币月初月累计市值余额
    ,CL_CURR_EAR_Y_M_ACM_MK_VAL_BAL			--折本币年初月累计市值余额
    ,Y_AVG_MK_VAL_BAL			      --年日均市值余额
    ,Q_AVG_MK_VAL_BAL			      --季日均市值余额
    ,M_AVG_MK_VAL_BAL			      --月日均市值余额
    ,CL_CURR_Y_AVG_MK_VAL_BAL		--折本币年日均市值余额
    ,CL_CURR_Q_AVG_MK_VAL_BAL		--折本币季日均市值余额
    ,CL_CURR_M_AVG_MK_VAL_BAL		--折本币月日均市值余额
    ,JOB_CD			                --任务代码
    )
  SELECT 
     ETL_DT                     --ETL处理日期
    ,LP_ID                      --法人编号
    ,TRAN_ACCT_ID               --交易账户编号
    ,PROD_ID                    --产品编号
    ,STD_PROD_ID                --标准产品编号
    ,PROD_NAME                  --产品名称
    ,SUBJ_ID                    --科目编号
    ,PRFT_ADJ_SUBJ_ID           --收益调整科目编号
    ,CUST_ID                    --客户编号
    ,CUST_TYPE_CD               --客户类型代码
    ,FINC_ACCT_ID               --理财账户编号
    ,CONT_ID                    --合约编号
    ,OPEN_DT                    --开立日期
    ,LAST_ACTIV_ACCT_DT         --上次动户日期
    ,ACCT_STATUS_CD             --账户状态代码
    ,OPEN_ORG_ID                --开立机构编号
    ,CUST_MGR_ID                --客户经理编号
    ,CAP_STL_ACCT_NUM           --资金结算账号
    ,SELLER_CD                  --销售商代码
    ,BANK_ID                    --银行编号
    ,PRFT_FEA_CD                --收益特征代码
    ,DIVD_WAY_CD                --分红方式代码
    ,TARD_WAY_CD                --交易方式代码
    ,PROD_STATUS_CD             --产品状态代码
    ,PROD_RISK_LEVEL_CD         --产品风险等级代码
    ,PRFT_EMBODY_WAY_CD         --收益体现方式代码
    ,CHARGE_WAY_CD              --收费方式代码
    ,CTRL_FLG_COMB              --控制标志组合
    ,PROD_FOUND_DT              --产品成立日期
    ,ALLOW_BUY_BEGIN_DAY        --允许购买起始日
    ,ALLOW_BUY_EXP_DAY          --允许购买到期日
    ,PROD_PED_DAYS              --产品周期天数
    ,EXPE_YLD_RAT               --预期收益率
    ,ANNUAL_YLD_RAT             --年化收益率
    ,OPEN_FLG                   --开放式标志
    ,EC_FLG                     --钞汇标志
    ,INDV_ALLOW_BUY_FLG         --个人允许购买标志
    ,INPWN_FLG                  --质押标志
    ,PROD_TEPLA_ID              --产品模板编号
    ,PROD_TEPLA_COMNT           --产品模板说明
    ,BRKEVN_FLG                 --保本标志
    ,PURCH_DT                   --申购日期
    ,EXP_DT                     --到期日期
    ,VALUE_DT                   --起息日期
    ,PRFT_EXP_DAY               --收益到期日
    ,ACTL_VALUE_DT              --实际起息日期
    ,ACTL_EXP_DT                --实际到期日期
    ,CURR_CD                    --币种代码
    ,ACCT_BAL                   --账户余额
    ,MK_VAL_BAL                 --市值余额
    ,SUBSCR_TOT_AMT             --认购总金额
    ,SUBSCR_TOT_LOT             --认购总份额
    ,REDEM_LOT                  --赎回份额
    ,REDEM_AMT                  --赎回金额
    ,CURR_LOT                   --当前份额
    ,AVAL_LOT                   --可用份额
    ,TRAN_FROZ_LOT              --交易冻结份额
    ,LONTERM_FROZ_LOT           --长期冻结份额
    ,LOC_FROZ_LOT               --本地冻结份额
    ,PROD_FEE_F_UNIT_NV         --产品费前单位净值
    ,PROD_FEE_POST_CORP_NV      --产品费后单位净值
    ,TD_CUST_YLD_RAT			      --当日客户收益率
    ,PROD_FEE_BF_TEN_THOUS_PRFT	--产品费前万份收益
    ,TD_PRFT			              --本日收益
    ,INVEST_PRFT			          --投资收益
    ,CURR_ISSUE_PRFT			      --本期收益
    ,CL_CURR_ACCT_BAL			      --折本币账户余额
    ,EAR_D_BAL			            --日初余额
    ,EAR_M_BAL			            --月初余额
    ,EAR_S_BAL			            --季初余额
    ,EAR_Y_BAL			            --年初余额
    ,M_ACM_BAL			            --月累计余额
    ,S_ACM_BAL			            --季累计余额
    ,Y_ACM_BAL			            --年累计余额
    ,CL_CURR_EAR_D_BAL			    --折本币日初余额
    ,CL_CURR_EAR_M_BAL			    --折本币月初余额
    ,CL_CURR_EAR_S_BAL			    --折本币季初余额
    ,CL_CURR_EAR_Y_BAL			    --折本币年初余额
    ,CL_CURR_Y_ACM_BAL			    --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL	  --折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL		--折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL		--折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL		--折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL			    --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL		--折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL		--折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL		--折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL			    --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL		--折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL		--折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL		--折本币年初月累计余额
    ,Y_AVG_BAL			            --年日均余额
    ,Q_AVG_BAL			            --季日均余额
    ,M_AVG_BAL			            --月日均余额
    ,CL_CURR_Y_AVG_BAL			    --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL			    --折本币季日均余额
    ,CL_CURR_M_AVG_BAL			    --折本币月日均余额
    ,CL_CURR_MK_VAL_BAL			    --折本币市值余额
    ,EAR_D_MK_VAL_BAL			      --日初市值余额
    ,EAR_M_MK_VAL_BAL			      --月初市值余额
    ,EAR_S_MK_VAL_BAL			      --季初市值余额
    ,EAR_Y_MK_VAL_BAL			      --年初市值余额
    ,M_ACM_MK_VAL_BAL			      --月累计市值余额
    ,S_ACM_MK_VAL_BAL			      --季累计市值余额
    ,Y_ACM_MK_VAL_BAL			      --年累计市值余额
    ,CL_CURR_EAR_D_MK_VAL_BAL		--折本币日初市值余额
    ,CL_CURR_EAR_M_MK_VAL_BAL		--折本币月初市值余额
    ,CL_CURR_EAR_S_MK_VAL_BAL		--折本币季初市值余额
    ,CL_CURR_EAR_Y_MK_VAL_BAL		--折本币年初市值余额
    ,CL_CURR_Y_ACM_MK_VAL_BAL		--折本币年累计市值余额
    ,CL_CURR_EAR_D_Y_ACM_MK_VAL_BAL			--折本币日初年累计市值余额
    ,CL_CURR_EAR_M_Y_ACM_MK_VAL_BAL			--折本币月初年累计市值余额
    ,CL_CURR_EAR_S_Y_ACM_MK_VAL_BAL			--折本币季初年累计市值余额
    ,CL_CURR_EAR_Y_Y_ACM_MK_VAL_BAL			--折本币年初年累计市值余额
    ,CL_CURR_S_ACM_MK_VAL_BAL			      --折本币季累计市值余额
    ,CL_CURR_EAR_D_S_ACM_MK_VAL_BAL			--折本币日初季累计市值余额
    ,CL_CURR_EAR_S_S_ACM_MK_VAL_BAL			--折本币季初季累计市值余额
    ,CL_CURR_EAR_Y_S_ACM_MK_VAL_BAL			--折本币年初季累计市值余额
    ,CL_CURR_M_ACM_MK_VAL_BAL			      --折本币月累计市值余额
    ,CL_CURR_EAR_D_M_ACM_MK_VAL_BAL			--折本币日初月累计市值余额
    ,CL_CURR_EAR_M_M_ACM_MK_VAL_BAL			--折本币月初月累计市值余额
    ,CL_CURR_EAR_Y_M_ACM_MK_VAL_BAL			--折本币年初月累计市值余额
    ,Y_AVG_MK_VAL_BAL			      --年日均市值余额
    ,Q_AVG_MK_VAL_BAL			      --季日均市值余额
    ,M_AVG_MK_VAL_BAL			      --月日均市值余额
    ,CL_CURR_Y_AVG_MK_VAL_BAL		--折本币年日均市值余额
    ,CL_CURR_Q_AVG_MK_VAL_BAL		--折本币季日均市值余额
    ,CL_CURR_M_AVG_MK_VAL_BAL		--折本币月日均市值余额
    ,JOB_CD			                --任务代码
    FROM ICL.V_CMM_FINC_ACCT_BAL_INFO  --视图-国结账户
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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

END ETL_O_ICL_CMM_FINC_ACCT_BAL_INFO;
/

