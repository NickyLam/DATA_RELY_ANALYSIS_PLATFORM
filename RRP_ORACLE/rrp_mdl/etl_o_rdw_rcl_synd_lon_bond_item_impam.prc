CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_RDW_RCL_SYND_LON_BOND_ITEM_IMPAM(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_RDW_RCL_SYND_LON_BOND_ITEM_IMPAM
  *  功能描述：联合贷款借据减值表
  *  创建日期：20260323
  *  开发人员：YJY
  *  来源表： RDW.V_RCL_SYND_LON_BOND_ITEM_IMPAM
  *  目标表： O_RDW_RCL_SYND_LON_BOND_ITEM_IMPAM
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20260323  YJY     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                --处理步骤
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);               --任务名称
  V_PART_NAME VARCHAR2(200);               --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_RDW_RCL_SYND_LON_BOND_ITEM_IMPAM'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_RDW_RCL_SYND_LON_BOND_ITEM_IMPAM'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-联合贷款借据减值表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_RDW_RCL_SYND_LON_BOND_ITEM_IMPAM
  (   
        BOND_ITEM_NO              --借据编号
       ,REPAID_NOMAL_INT          --已偿还正常利息
       ,REPAID_OVDUE_PRIC_PNLT    --已偿还逾期本金罚息
       ,DUBIL_AMT                 --借据金额
       ,CL_CURR_CURRT_BAL         --折本币当期余额
       ,REPAY_PERIOD_CD           --还款周期代码
       ,BIZ_BREED_NO              --业务品种编号
       ,DAILY_EXEC_INT_RAT        --每日执行利率
       ,NOMAL_PRIC                --正常本金
       ,RECVBL_ACRU_PNLT          --应收应计罚息
       ,OFF_BS_OVER_INT_BAL       --表外欠息余额
       ,NOMAL_INT                 --正常利息
       ,RECVBL_PNLT               --应收罚息
       ,REPAID_OVDUE_PRIC         --已偿还逾期本金
       ,PRODUCT_NO                --产品编号
       ,INT_SET_WAY_CD            --结息方式代码
       ,EXECU_ORG_NO              --管户机构编号
       ,BASE_INT_RATE             --基准利率
       ,IN_BS_OVER_INT_BAL        --表内欠息余额
       ,IN_BS_INT                 --表内利息
       ,ACM_RECVBL_UNCOL_INT_AMT  --累计应收未收利息金额
       ,REPAID_NOMAL_PRIC         --已偿还正常本金
       ,PRIC_BAL                  --本金余额
       ,PRIC_REPAY_FREQ_CD        --本金还款频率代码
       ,INT_RAT_ADJ_WAY_CD        --利率调整方式代码
       ,DISTR_AMT                 --放款金额
       ,REPAID_FEE                --已偿还费用
       ,INT_RAT_FLO_VAL           --利率浮动值
       ,LON_USAGE_CD              --贷款用途代码
       ,OVDUE_PRIC_PNLT           --逾期本金罚息
       ,OVDUE_INT_PNLT            --逾期利息罚息
       ,WRT_OFF_FLG               --核销标志
       ,REPAY_WAY_CD              --还款方式代码
       ,LEVEL10_CLASS_CD          --十级分类代码
       ,CURR_ISSUE_PERDS          --当前期数
       ,OVDUE_INT                 --逾期利息
       ,REPAID_OVDUE_INT_PNLT     --已偿还逾期利息罚息
       ,INT_RAT_FLOAT_DIR_CD      --利率浮动方向代码
       ,VALUE_DT                  --起息日期
       ,CURR_OVDUE_FLG            --当前逾期标志
       ,INT_OVDUE_DAYS            --利息逾期天数
       ,OFF_BS_INT                --表外利息
       ,NEXT_INT_RAT_ADJ_DT       --下次利率调整日期
       ,INT_ACCR_FLG              --计息标志
       ,ACCRUED_NON_ACCRUED_FLG   --应计非应计标志
       ,DIR_INDUS_CD              --贷款投向行业代码
       ,LEVEL5_CLASS_CD           --五级分类代码
       ,NORMAL_PRIN_SUBJECT_NO    --正常本金科目编号
       ,RECVBL_OVER_INT           --应收欠息
       ,OVDUE_INT_RATE            --逾期执行利率
       ,TD_ACRU_INT               --当日应计利息
       ,CURRT_ACRU_INT            --当期应计利息
       ,OVDUE_PRIC                --逾期本金
       ,INT_BASE_CD               --计息基准代码
       ,PAYOFF_DT                 --结清日期
       ,REPAID_OVDUE_INT          --已偿还逾期利息
       ,PRIC_OVDUE_FLG            --本金逾期标志
       ,NEXT_REPAY_DT             --下次还款日期
       ,CUST_NO                   --客户编号
       ,INT_OVDUE_FLG             --利息逾期标志
       ,CURR_INT_RAT_EFFECT_DT    --当前利率生效日期
       ,REPAY_FREQ_CD             --还款频率代码
       ,DUBIL_STATUS_CD           --借据状态代码
       ,CURR_CD                   --币种代码
       ,RECVBL_FEE                --应收费用
       ,INT_ACCR_WAY_CD           --计息方式代码
       ,CUST_NAME                 --客户名称
       ,CURR_OVDUE_TERM           --当前逾期期数
       ,MATURE_DT                 --到期日期
       ,TOT_PERDS                 --贷款期数
       ,EXEC_INT_RATE             --正常执行利率
       ,LAST_REPAY_DT             --上次还款日期
       ,COMP_INT_FLG              --复息标志
       ,INT_RAT_FLOAT_WAY_CD      --利率浮动方式代码
       ,REPAY_ACCT_NO             --还款账号
       ,CUST_MGR_NO               --客户经理编号
       ,OVDUE_PRIN_SUBJECT_NO     --逾期本金科目编号
       ,SURP_PERDS                --剩余期数
       ,CURRT_BAL                 --当期余额
       ,BOND_ITEM_STATUS_CD       --借据状态代码
       ,INT_REPAY_FREQ_CD         --利息还款频率代码
       ,ACCTS_ORG_NO              --账务机构编号
       ,DISTR_DT                  --发放日期
       ,OVDUE_DAYS                --本金逾期天数
       ,ADV_VAT_AMT               --代垫增值税
       ,CRED_RHT_TURN_FLG         --债权直转标志
       ,LOAN_TYPE_CD              --贷款类型代码
       ,PKG_SEQ_NUM               --打包序号
       ,V_CCY_CD_BEFORE           --原币币种
       ,V_DFC_ECL_CD              --调整后：’dcf‘ 未调整： ’ecl‘
       ,ASSET_THREE_CLS_CD        --三分类代码
       ,N_ECL                     --ecl
       ,N_ECL_BEFORE_DCF          --dcf调整后的原币ecl
       ,N_ECL_BEFORE              --原币ecl
       ,ETL_DT                    --数据日期
       ,CONT_ID                   --合同编号
       ,GUARTOR_NAME              --担保人名称
       ,OPEN_ACCT_DT              --开户日期
       ,COMP_INT_CALC_WAY_CD      --复利计算方式代码
       ,PAYOFF_IND                --结清标志
       ,INT_RATE_FLOAT_FREQ_CD    --利率浮动频率代码
       ,BIZ_STRIP_LINE_CD         --业务条线代码
       ,REPAY_FREQ_VAL            --还款频率值
       ,INT_REPAY_FREQ_VAL        --利息还款频率值
       ,WRT_OFF_PRIC              --核销本金
       ,WRT_OFF_INT               --核销利息
       ,REPAY_PRIN                --下期应收本金
       ,REPAY_INT                 --下期应收利息
       ,BUS_BREED_CD              --业务品种代码
       ,TAX_ECL                   --垫付增值税ecl
       ,N_ECL_DCF                 --dcf调整后的ecl
       ,TAX_ECL_BEFORE            --垫付增值税原币ECL
       ,GUARTOR_CUST_ID           --担保人客户号
   )
  SELECT 
       BOND_ITEM_NO              --借据编号
       ,REPAID_NOMAL_INT          --已偿还正常利息
       ,REPAID_OVDUE_PRIC_PNLT    --已偿还逾期本金罚息
       ,DUBIL_AMT                 --借据金额
       ,CL_CURR_CURRT_BAL         --折本币当期余额
       ,REPAY_PERIOD_CD           --还款周期代码
       ,BIZ_BREED_NO              --业务品种编号
       ,DAILY_EXEC_INT_RAT        --每日执行利率
       ,NOMAL_PRIC                --正常本金
       ,RECVBL_ACRU_PNLT          --应收应计罚息
       ,OFF_BS_OVER_INT_BAL       --表外欠息余额
       ,NOMAL_INT                 --正常利息
       ,RECVBL_PNLT               --应收罚息
       ,REPAID_OVDUE_PRIC         --已偿还逾期本金
       ,PRODUCT_NO                --产品编号
       ,INT_SET_WAY_CD            --结息方式代码
       ,EXECU_ORG_NO              --管户机构编号
       ,BASE_INT_RATE             --基准利率
       ,IN_BS_OVER_INT_BAL        --表内欠息余额
       ,IN_BS_INT                 --表内利息
       ,ACM_RECVBL_UNCOL_INT_AMT  --累计应收未收利息金额
       ,REPAID_NOMAL_PRIC         --已偿还正常本金
       ,PRIC_BAL                  --本金余额
       ,PRIC_REPAY_FREQ_CD        --本金还款频率代码
       ,INT_RAT_ADJ_WAY_CD        --利率调整方式代码
       ,DISTR_AMT                 --放款金额
       ,REPAID_FEE                --已偿还费用
       ,INT_RAT_FLO_VAL           --利率浮动值
       ,LON_USAGE_CD              --贷款用途代码
       ,OVDUE_PRIC_PNLT           --逾期本金罚息
       ,OVDUE_INT_PNLT            --逾期利息罚息
       ,WRT_OFF_FLG               --核销标志
       ,REPAY_WAY_CD              --还款方式代码
       ,LEVEL10_CLASS_CD          --十级分类代码
       ,CURR_ISSUE_PERDS          --当前期数
       ,OVDUE_INT                 --逾期利息
       ,REPAID_OVDUE_INT_PNLT     --已偿还逾期利息罚息
       ,INT_RAT_FLOAT_DIR_CD      --利率浮动方向代码
       ,VALUE_DT                  --起息日期
       ,CURR_OVDUE_FLG            --当前逾期标志
       ,INT_OVDUE_DAYS            --利息逾期天数
       ,OFF_BS_INT                --表外利息
       ,NEXT_INT_RAT_ADJ_DT       --下次利率调整日期
       ,INT_ACCR_FLG              --计息标志
       ,ACCRUED_NON_ACCRUED_FLG   --应计非应计标志
       ,DIR_INDUS_CD              --贷款投向行业代码
       ,LEVEL5_CLASS_CD           --五级分类代码
       ,NORMAL_PRIN_SUBJECT_NO    --正常本金科目编号
       ,RECVBL_OVER_INT           --应收欠息
       ,OVDUE_INT_RATE            --逾期执行利率
       ,TD_ACRU_INT               --当日应计利息
       ,CURRT_ACRU_INT            --当期应计利息
       ,OVDUE_PRIC                --逾期本金
       ,INT_BASE_CD               --计息基准代码
       ,PAYOFF_DT                 --结清日期
       ,REPAID_OVDUE_INT          --已偿还逾期利息
       ,PRIC_OVDUE_FLG            --本金逾期标志
       ,NEXT_REPAY_DT             --下次还款日期
       ,CUST_NO                   --客户编号
       ,INT_OVDUE_FLG             --利息逾期标志
       ,CURR_INT_RAT_EFFECT_DT    --当前利率生效日期
       ,REPAY_FREQ_CD             --还款频率代码
       ,DUBIL_STATUS_CD           --借据状态代码
       ,CURR_CD                   --币种代码
       ,RECVBL_FEE                --应收费用
       ,INT_ACCR_WAY_CD           --计息方式代码
       ,CUST_NAME                 --客户名称
       ,CURR_OVDUE_TERM           --当前逾期期数
       ,MATURE_DT                 --到期日期
       ,TOT_PERDS                 --贷款期数
       ,EXEC_INT_RATE             --正常执行利率
       ,LAST_REPAY_DT             --上次还款日期
       ,COMP_INT_FLG              --复息标志
       ,INT_RAT_FLOAT_WAY_CD      --利率浮动方式代码
       ,REPAY_ACCT_NO             --还款账号
       ,CUST_MGR_NO               --客户经理编号
       ,OVDUE_PRIN_SUBJECT_NO     --逾期本金科目编号
       ,SURP_PERDS                --剩余期数
       ,CURRT_BAL                 --当期余额
       ,BOND_ITEM_STATUS_CD       --借据状态代码
       ,INT_REPAY_FREQ_CD         --利息还款频率代码
       ,ACCTS_ORG_NO              --账务机构编号
       ,DISTR_DT                  --发放日期
       ,OVDUE_DAYS                --本金逾期天数
       ,ADV_VAT_AMT               --代垫增值税
       ,CRED_RHT_TURN_FLG         --债权直转标志
       ,LOAN_TYPE_CD              --贷款类型代码
       ,PKG_SEQ_NUM               --打包序号
       ,V_CCY_CD_BEFORE           --原币币种
       ,V_DFC_ECL_CD              --调整后：’dcf‘ 未调整： ’ecl‘
       ,ASSET_THREE_CLS_CD        --三分类代码
       ,N_ECL                     --ecl
       ,N_ECL_BEFORE_DCF          --dcf调整后的原币ecl
       ,N_ECL_BEFORE              --原币ecl
       ,ETL_DT                    --数据日期
       ,CONT_ID                   --合同编号
       ,GUARTOR_NAME              --担保人名称
       ,OPEN_ACCT_DT              --开户日期
       ,COMP_INT_CALC_WAY_CD      --复利计算方式代码
       ,PAYOFF_IND                --结清标志
       ,INT_RATE_FLOAT_FREQ_CD    --利率浮动频率代码
       ,BIZ_STRIP_LINE_CD         --业务条线代码
       ,REPAY_FREQ_VAL            --还款频率值
       ,INT_REPAY_FREQ_VAL        --利息还款频率值
       ,WRT_OFF_PRIC              --核销本金
       ,WRT_OFF_INT               --核销利息
       ,REPAY_PRIN                --下期应收本金
       ,REPAY_INT                 --下期应收利息
       ,BUS_BREED_CD              --业务品种代码
       ,TAX_ECL                   --垫付增值税ecl
       ,N_ECL_DCF                 --dcf调整后的ecl
       ,TAX_ECL_BEFORE            --垫付增值税原币ECL
       ,GUARTOR_CUST_ID           --担保人客户号
    FROM RDW.V_RCL_SYND_LON_BOND_ITEM_IMPAM --视图-联合贷款借据减值表
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_RDW_RCL_SYND_LON_BOND_ITEM_IMPAM;
/

