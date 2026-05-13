CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_UNITE_WL_DUBIL_INFO(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_UNITE_WL_DUBIL_INFO
  *  功能描述：联合网贷借据信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_UNITE_WL_DUBIL_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20230920  HYF      根据业务要求，将61笔借据的旧代码更新为新产品
  *             3    20240102  hulj     新增花呗放款金额
  *             4    20240424  YJY      PAYOFF_DT截掉时间戳
  *             5    20240528  YJY      调整联合网贷的往年结清跑批时间为每年1月2号
  *             6    20240703  YJY      新增重组标志、重组贷款类型代码、重组日期、原始到期日期字段
  *             7    20250110  YJY      新增入账账户开户银行名称、还款账户开户银行编号、还款账户开户机构名称
  *             8    20250206  YJY      调整联合网贷的往年结清跑批时间为每年1月1号
  *             9    20250521  YJY      新增核心借据编号
  *            10    20250613  YJY      调整核心借据号的加工逻辑，优先取核心借据号，取不到时取其借据号
  *            11    20250707  YJY      调整联合网贷往年结清部分的核心借据号的加工逻辑，优先取核心借据号，取不到时取其借据号
  *            12    20251106  YJY      1、针对分期乐、微业贷3.0（好企贷-数据贷）产品做接数处理，按照T-1天进行获取
                                        2、新增行内贷款类型代码
  ******************************************************************/
AS
  --定义变量
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_LAST_YEAR DATE;                       --上年末日期
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(200);              --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_ICL_CMM_UNITE_WL_DUBIL_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_UNITE_WL_DUBIL_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  V_LAST_YEAR := TRUNC(TO_DATE(I_P_DATE,'YYYY-MM-DD'),'YYYY') - 1;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '程序跑批开始';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO';
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := 2;
  V_STEP_DESC := '数据落地-联合网贷借据信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO
    (ETL_DT                        --数据日期
    ,LP_ID                         --法人编号
    ,DUBIL_ID                      --借据编号
    ,STD_PROD_ID                   --标准产品编号
    ,PROD_ID                       --产品编号
    ,CUST_ID                       --客户编号
    ,SUBJ_ID                       --科目编号
    ,ACCTNT_CATE_CD                --会计类别代码
    ,ENTER_ACCT_ACCT_NUM           --入账账号
    ,REPAY_NUM                     --还款账号
    ,RELA_AGT_ID                   --关联协议编号
    ,RELA_APPL_FLOW_NUM            --关联申请流水号
    ,CURR_CD                       --币种代码
    ,BUS_BREED_ID                  --业务品种编号
    ,LOAN_TYPE_CD                  --贷款类型代码
    ,ASSET_THD_CLS_CD              --资产三分类代码
    ,DUBIL_STATUS_CD               --借据状态代码
    ,LOAN_USAGE_CD                 --贷款用途代码
    ,DIR_INDUS_CD                  --投向行业代码
    ,CONT_STATUS_CD                --合同状态代码
    ,LOAN_LEVEL4_CLS_CD            --贷款四级分类代码
    ,LOAN_LEVEL5_CLS_CD            --贷款五级分类代码
    ,LOAN_LEVEL10_CLS_CD           --贷款十级分类代码
    ,LOAN_LEVEL12_CLS_CD           --贷款十二级分类代码
    ,ACRU_NON_ACRU_CD              --应计非应计代码
    ,REPAY_WAY_CD                  --还款方式代码
    ,INT_SET_WAY_CD                --结息方式代码
    ,INT_ACCR_WAY_CD               --计息方式代码
    ,INT_RAT_ADJ_WAY_CD            --利率调整方式代码
    ,INT_RAT_ADJ_PED_CORP_CD       --利率调整周期单位代码
    ,INT_RAT_ADJ_PED_FREQ          --利率调整周期频率
    ,INT_RAT_BASE_TYPE_CD          --利率基准类型代码
    ,INT_RAT_FLOAT_WAY_CD          --利率浮动方式代码
    ,INT_RAT_FLOAT_DIR_CD          --利率浮动方向代码
    ,INT_RAT_FLO_VAL               --利率浮动值
    ,PRIC_REPAY_FREQ_CD            --本金还款频率代码
    ,INT_REPAY_FREQ_CD             --利息还款频率代码
    ,GUAR_WAY_CD                   --担保方式代码
    ,ENTER_ACCT_ACCT_NUM_TYPE      --入账账号类型
    ,REPAY_NUM_TYPE                --还款账号类型
    ,INTNAL_CARR_FLG               --内部结转标志
    ,DOM_OVERS_FLG                 --境内外标志
    ,INT_ACCR_FLG                  --计息标志
    ,COMP_INT_FLG                  --复息标志
    ,OVDUE_FLG                     --逾期标志
    ,WRT_OFF_FLG                   --核销标志
    ,OPEN_ACCT_DT                  --开户日期
    ,DISTR_DT                      --放款日期
    ,VALUE_DT                      --起息日期
    ,EXP_DT                        --到期日期
    ,PAYOFF_DT                     --结清日期
    ,LAST_REPAY_DT                 --上次还款日期
    ,NEXT_REPAY_DT                 --下次还款日期
    ,CURR_INT_RAT_EFFECT_DT        --当前利率生效日期
    ,NEXT_INT_RAT_ADJ_DT           --下次利率调整日期
    ,CUST_MGR_ID                   --客户经理编号
    ,OPEN_ACCT_ORG_ID              --开户机构编号
    ,MGMT_ORG_ID                   --管理机构编号
    ,ACCT_INSTIT_ID                --账务机构编号
    ,TOT_PERDS                     --总期数
    ,CURR_ISSUE_PERDS              --本期期数
    ,SURP_PERDS                    --剩余期数
    ,OVDUE_PERDS                   --逾期期数
    ,PRIC_OVDUE_FLG                --本金逾期标志
    ,INT_OVDUE_FLG                 --利息逾期标志
    ,PRIC_OVDUE_DAYS               --本金逾期天数
    ,INT_OVDUE_DAYS                --利息逾期天数
    ,GRACE_PERIOD_DAYS             --宽限期天数
    ,INST_COMM_FEE_RAT             --分期手续费费率
    ,BASE_RAT                      --基准利率
    ,EXEC_INT_RAT                  --执行利率
    ,OVDUE_INT_RAT                 --逾期利率
    ,DAILY_EXEC_INT_RAT            --每日执行利率
    ,CONT_AMT                      --合同金额
    ,DUBIL_AMT                     --借据金额
    ,DISTR_AMT                     --放款金额
    ,BANK_CONTRI_RATIO             --银行出资比例
    ,TD_ACRU_INT                   --当日应计利息
    ,CURRT_ACRU_INT                --当期应计利息
    ,NOMAL_PRIC                    --正常本金
    ,OVDUE_PRIC                    --逾期本金
    ,IDLE_PRIC                     --呆滞本金
    ,BAD_DEBT_PRIC                 --呆账本金
    ,WRT_OFF_PRIC                  --核销本金
    ,NOMAL_INT                     --正常利息
    ,OVDUE_INT                     --逾期利息
    ,WRT_OFF_INT                   --核销利息
    ,OVDUE_PRIC_PNLT               --逾期本金罚息
    ,OVDUE_INT_PNLT                --逾期利息罚息
    ,RECVBL_OVER_INT               --应收欠息
    ,RECVBL_ACRU_PNLT              --应收应计罚息
    ,RECVBL_PNLT                   --应收罚息
    ,RECVBL_FEE                    --应收费用
    ,IN_BS_OVER_INT_BAL            --表内欠息余额
    ,OFF_BS_OVER_INT_BAL           --表外欠息余额
    ,IN_BS_INT                     --表内利息
    ,OFF_BS_INT                    --表外利息
    ,ACM_RECVBL_UNCOL_INT_AMT      --累计应收未收利息金额
    ,REPAID_NOMAL_PRIC             --已偿还正常本金
    ,REPAID_OVDUE_PRIC             --已偿还逾期本金
    ,REPAID_NOMAL_INT              --已偿还正常利息
    ,REPAID_OVDUE_INT              --已偿还逾期利息
    ,REPAID_OVDUE_PRIC_PNLT        --已偿还逾期本金罚息
    ,REPAID_OVDUE_INT_PNLT         --已偿还逾期利息罚息
    ,REPAID_FEE                    --已偿还费用
    ,PRIC_BAL                      --本金余额
    ,CURRT_BAL                     --当期余额
    ,CL_CURR_CURRT_BAL             --折本币当期余额
    ,EAR_D_BAL                     --日初余额
    ,EAR_M_BAL                     --月初余额
    ,EAR_S_BAL                     --季初余额
    ,EAR_Y_BAL                     --年初余额
    ,Y_ACM_BAL                     --年累计余额
    ,S_ACM_BAL                     --季累计余额
    ,M_ACM_BAL                     --月累计余额
    ,CL_CURR_EAR_D_BAL             --折本币日初余额
    ,CL_CURR_EAR_M_BAL             --折本币月初余额
    ,CL_CURR_EAR_S_BAL             --折本币季初余额
    ,CL_CURR_EAR_Y_BAL             --折本币年初余额
    ,CL_CURR_Y_ACM_BAL             --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL       --折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL       --折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL       --折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL       --折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL             --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL       --折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL       --折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL       --折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL             --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL       --折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL       --折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL       --折本币年初月累计余额
    ,Y_AVG_BAL                     --年日均余额
    ,Q_AVG_BAL                     --季日均余额
    ,M_AVG_BAL                     --月日均余额
    ,CL_CURR_Y_AVG_BAL             --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL             --折本币季日均余额
    ,CL_CURR_M_AVG_BAL             --折本币月日均余额
    ,INIT_TOT_PERDS                --原始总期数
    ,WHITE_LIST_CUST_FLG           --白户标志
    ,JOB_CD                        --任务代码
    ,CRED_RHT_TURN_FLG             --债权直转标志
    ,INIT_DISTR_DT                 --原始放款日期
    ,INIT_DISTR_AMT                --原始放款金额
    ,CONT_ID                       --合同编号
    ,ACP_DISTR_AMT                 --花呗放款金额
    ,REGROUP_FLG                   --重组标志               --ADD BY YJY IN 20240703
    ,REGROUP_LOAN_TYPE_CD          --重组贷款类型代码       --ADD BY YJY IN 20240703
    ,REGROUP_DT                    --重组日期               --ADD BY YJY IN 20240703
    ,INIT_EXP_DT	                 --原始到期日期           --ADD BY YJY IN 20240703
    ,ENTER_ACCT_BANK_NAME          --入账账户开户银行名称   --ADD BY YJY 20250110
    ,REPAY_OPEN_ACCT_BANK_ID       --还款账户开户银行编号   --ADD BY YJY 20250110
    ,REPAY_OPEN_ACCT_ORG_NAME      --还款账户开户机构名称   --ADD BY YJY 20250110
    ,CORE_DUBIL_ID                 --核心借据编号           --ADD BY YJY 20250521
    ,INTNAL_LOAN_TYPE_CD           --行内贷款类型代码       --ADD BY YJY 20251106
    )
  SELECT /*A.ETL_DT + 1*/ TO_DATE(V_P_DATE,'YYYYMMDD')   --数据日期  MOD BY YJY 20250820
        ,A.LP_ID                   --法人编号
        ,A.DUBIL_ID                --借据编号
        ,A.STD_PROD_ID             --标准产品编号
        ,A.PROD_ID                 --产品编号
        ,A.CUST_ID                 --客户编号
        ,A.SUBJ_ID                 --科目编号
        ,A.ACCTNT_CATE_CD          --会计类别代码
        ,A.ENTER_ACCT_ACCT_NUM     --入账账号
        ,A.REPAY_NUM               --还款账号
        ,A.RELA_AGT_ID             --关联协议编号
        ,A.RELA_APPL_FLOW_NUM      --关联申请流水号
        ,A.CURR_CD                 --币种代码
        ,A.BUS_BREED_ID            --业务品种编号
        ,A.LOAN_TYPE_CD            --贷款类型代码
        ,A.ASSET_THD_CLS_CD        --资产三分类代码
        ,A.DUBIL_STATUS_CD         --借据状态代码
        ,A.LOAN_USAGE_CD           --贷款用途代码
        ,A.DIR_INDUS_CD            --投向行业代码
        ,A.CONT_STATUS_CD          --合同状态代码
        ,A.LOAN_LEVEL4_CLS_CD      --贷款四级分类代码
        ,A.LOAN_LEVEL5_CLS_CD      --贷款五级分类代码
        ,A.LOAN_LEVEL10_CLS_CD     --贷款十级分类代码
        ,A.LOAN_LEVEL12_CLS_CD     --贷款十二级分类代码
        ,A.ACRU_NON_ACRU_CD        --应计非应计代码
        ,A.REPAY_WAY_CD            --还款方式代码
        ,A.INT_SET_WAY_CD          --结息方式代码
        ,A.INT_ACCR_WAY_CD         --计息方式代码
        ,A.INT_RAT_ADJ_WAY_CD      --利率调整方式代码
        ,A.INT_RAT_ADJ_PED_CORP_CD --利率调整周期单位代码
        ,A.INT_RAT_ADJ_PED_FREQ    --利率调整周期频率
        ,A.INT_RAT_BASE_TYPE_CD    --利率基准类型代码
        ,A.INT_RAT_FLOAT_WAY_CD    --利率浮动方式代码
        ,A.INT_RAT_FLOAT_DIR_CD    --利率浮动方向代码
        ,A.INT_RAT_FLO_VAL         --利率浮动值
        ,A.PRIC_REPAY_FREQ_CD      --本金还款频率代码
        ,A.INT_REPAY_FREQ_CD       --利息还款频率代码
        ,A.GUAR_WAY_CD             --担保方式代码
        ,A.ENTER_ACCT_ACCT_NUM_TYPE  --入账账号类型
        ,A.REPAY_NUM_TYPE          --还款账号类型
        ,A.INTNAL_CARR_FLG         --内部结转标志
        ,A.DOM_OVERS_FLG           --境内外标志
        ,A.INT_ACCR_FLG            --计息标志
        ,A.COMP_INT_FLG            --复息标志
        ,A.OVDUE_FLG               --逾期标志
        ,A.WRT_OFF_FLG             --核销标志
        ,A.OPEN_ACCT_DT            --开户日期
        ,A.DISTR_DT                --放款日期
        ,A.VALUE_DT                --起息日期
        ,A.EXP_DT                  --到期日期
        ,TRUNC(A.PAYOFF_DT)        --结清日期   MODIFY YJY 20240424
        ,A.LAST_REPAY_DT           --上次还款日期
        ,A.NEXT_REPAY_DT           --下次还款日期
        ,A.CURR_INT_RAT_EFFECT_DT  --当前利率生效日期
        ,A.NEXT_INT_RAT_ADJ_DT     --下次利率调整日期
        ,A.CUST_MGR_ID             --客户经理编号
        ,A.OPEN_ACCT_ORG_ID        --开户机构编号
        ,A.MGMT_ORG_ID             --管理机构编号
        ,A.ACCT_INSTIT_ID          --账务机构编号
        ,A.TOT_PERDS               --总期数
        ,A.CURR_ISSUE_PERDS        --本期期数
        ,A.SURP_PERDS              --剩余期数
        ,A.OVDUE_PERDS             --逾期期数
        ,A.PRIC_OVDUE_FLG          --本金逾期标志
        ,A.INT_OVDUE_FLG           --利息逾期标志
        ,A.PRIC_OVDUE_DAYS         --本金逾期天数
        ,A.INT_OVDUE_DAYS          --利息逾期天数
        ,A.GRACE_PERIOD_DAYS       --宽限期天数
        ,A.INST_COMM_FEE_RAT       --分期手续费费率
        ,A.BASE_RAT                --基准利率
        ,A.EXEC_INT_RAT            --执行利率
        ,A.OVDUE_INT_RAT           --逾期利率
        ,A.DAILY_EXEC_INT_RAT      --每日执行利率
        ,A.CONT_AMT                --合同金额
        ,A.DUBIL_AMT               --借据金额
        ,A.DISTR_AMT               --放款金额
        ,A.BANK_CONTRI_RATIO       --银行出资比例
        ,A.TD_ACRU_INT             --当日应计利息
        ,A.CURRT_ACRU_INT          --当期应计利息
        ,A.NOMAL_PRIC              --正常本金
        ,A.OVDUE_PRIC              --逾期本金
        ,A.IDLE_PRIC               --呆滞本金
        ,A.BAD_DEBT_PRIC           --呆账本金
        ,A.WRT_OFF_PRIC            --核销本金
        ,A.NOMAL_INT               --正常利息
        ,A.OVDUE_INT               --逾期利息
        ,A.WRT_OFF_INT             --核销利息
        ,A.OVDUE_PRIC_PNLT         --逾期本金罚息
        ,A.OVDUE_INT_PNLT          --逾期利息罚息
        ,A.RECVBL_OVER_INT         --应收欠息
        ,A.RECVBL_ACRU_PNLT        --应收应计罚息
        ,A.RECVBL_PNLT             --应收罚息
        ,A.RECVBL_FEE              --应收费用
        ,A.IN_BS_OVER_INT_BAL      --表内欠息余额
        ,A.OFF_BS_OVER_INT_BAL     --表外欠息余额
        ,A.IN_BS_INT               --表内利息
        ,A.OFF_BS_INT              --表外利息
        ,A.ACM_RECVBL_UNCOL_INT_AMT  --累计应收未收利息金额
        ,A.REPAID_NOMAL_PRIC       --已偿还正常本金
        ,A.REPAID_OVDUE_PRIC       --已偿还逾期本金
        ,A.REPAID_NOMAL_INT        --已偿还正常利息
        ,A.REPAID_OVDUE_INT        --已偿还逾期利息
        ,A.REPAID_OVDUE_PRIC_PNLT  --已偿还逾期本金罚息
        ,A.REPAID_OVDUE_INT_PNLT   --已偿还逾期利息罚息
        ,A.REPAID_FEE              --已偿还费用
        ,A.PRIC_BAL                --本金余额
        ,A.CURRT_BAL               --当期余额
        ,A.CL_CURR_CURRT_BAL       --折本币当期余额
        ,A.EAR_D_BAL               --日初余额
        ,A.EAR_M_BAL               --月初余额
        ,A.EAR_S_BAL               --季初余额
        ,A.EAR_Y_BAL               --年初余额
        ,A.Y_ACM_BAL               --年累计余额
        ,A.S_ACM_BAL               --季累计余额
        ,A.M_ACM_BAL               --月累计余额
        ,A.CL_CURR_EAR_D_BAL       --折本币日初余额
        ,A.CL_CURR_EAR_M_BAL       --折本币月初余额
        ,A.CL_CURR_EAR_S_BAL       --折本币季初余额
        ,A.CL_CURR_EAR_Y_BAL       --折本币年初余额
        ,A.CL_CURR_Y_ACM_BAL       --折本币年累计余额
        ,A.CL_CURR_EAR_D_Y_ACM_BAL --折本币日初年累计余额
        ,A.CL_CURR_EAR_M_Y_ACM_BAL --折本币月初年累计余额
        ,A.CL_CURR_EAR_S_Y_ACM_BAL --折本币季初年累计余额
        ,A.CL_CURR_EAR_Y_Y_ACM_BAL --折本币年初年累计余额
        ,A.CL_CURR_S_ACM_BAL       --折本币季累计余额
        ,A.CL_CURR_EAR_D_S_ACM_BAL --折本币日初季累计余额
        ,A.CL_CURR_EAR_S_S_ACM_BAL --折本币季初季累计余额
        ,A.CL_CURR_EAR_Y_S_ACM_BAL --折本币年初季累计余额
        ,A.CL_CURR_M_ACM_BAL       --折本币月累计余额
        ,A.CL_CURR_EAR_D_M_ACM_BAL --折本币日初月累计余额
        ,A.CL_CURR_EAR_M_M_ACM_BAL --折本币月初月累计余额
        ,A.CL_CURR_EAR_Y_M_ACM_BAL --折本币年初月累计余额
        ,A.Y_AVG_BAL               --年日均余额
        ,A.Q_AVG_BAL               --季日均余额
        ,A.M_AVG_BAL               --月日均余额
        ,A.CL_CURR_Y_AVG_BAL       --折本币年日均余额
        ,A.CL_CURR_Q_AVG_BAL       --折本币季日均余额
        ,A.CL_CURR_M_AVG_BAL       --折本币月日均余额
        ,A.INIT_TOT_PERDS          --原始总期数
        ,A.WHITE_LIST_CUST_FLG     --白户标志
        ,A.JOB_CD                  --任务代码
        ,A.CRED_RHT_TURN_FLG       --债权直转标志
        ,A.INIT_DISTR_DT           --原始放款日期
        ,A.INIT_DISTR_AMT          --原始放款金额
        ,A.CONT_ID                 --合同编号
        ,B.DISTR_AMT               --花呗放款金额
        ,A.REGROUP_FLG             --重组标志                --ADD BY YJY IN 20240703
        ,A.REGROUP_LOAN_TYPE_CD    --重组贷款类型代码        --ADD BY YJY IN 20240703
        ,A.REGROUP_DT              --重组日期                --ADD BY YJY IN 20240703
        ,A.INIT_EXP_DT	           --原始到期日期            --ADD BY YJY IN 20240703
        ,A.ENTER_ACCT_BANK_NAME    --入账账户开户银行名称    --ADD BY YJY 20250110
        ,A.REPAY_OPEN_ACCT_BANK_ID --还款账户开户银行编号    --ADD BY YJY 20250110
        ,A.REPAY_OPEN_ACCT_ORG_NAME --还款账户开户机构名称   --ADD BY YJY 20250110
        ,NVL(TRIM(A.CORE_DUBIL_ID),A.DUBIL_ID)   AS CORE_DUBIL_ID   --核心借据编号  --ADD BY YJY 20250521 --MOD BY YJY 20250613 调整核心借据号的加工逻辑，优先取核心借据号，取不到时取其借据号
        ,A.INTNAL_LOAN_TYPE_CD     --行内贷款类型代码        --ADD BY YJY 20251106
    FROM ICL.V_CMM_UNITE_WL_DUBIL_INFO A  --视图-联合网贷借据信息
    LEFT JOIN IML.V_AGT_ACP_DUBIL B --视图-花呗借据
      ON B.DUBIL_ID = A.DUBIL_ID
     AND B.CREATE_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND B.ID_MARK <> 'D'
     --AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')- 1
   WHERE --A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1;
        --MOD BY YJY 20251106 其他联合网贷依旧按照t-2接数,分期乐、微业贷3.0（好企贷-数据贷）按照T-1天进行获取
        (A.STD_PROD_ID NOT IN ('202010200011','202010200010','201020100063') AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1) --其他联合网贷
      OR (A.STD_PROD_ID IN ('202010200011','202010200010','201020100063') AND A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) --分期乐、微业贷3.0（好企贷-数据贷）产品
       ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 3;
  V_STEP_DESC := '数据落地-联合网贷往年结清数据';
  V_STARTTIME := SYSDATE;
  --取上年1231放款的数据
  INSERT /*+APPEND*/ INTO RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO
    (ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,DUBIL_ID                   --借据编号
    ,STD_PROD_ID                --标准产品编号
    ,PROD_ID                    --产品编号
    ,CUST_ID                    --客户编号
    ,SUBJ_ID                    --科目编号
    ,ACCTNT_CATE_CD             --会计类别代码
    ,ENTER_ACCT_ACCT_NUM        --入账账号
    ,REPAY_NUM                  --还款账号
    ,RELA_AGT_ID                --关联协议编号
    ,RELA_APPL_FLOW_NUM         --关联申请流水号
    ,CURR_CD                    --币种代码
    ,BUS_BREED_ID               --业务品种编号
    ,LOAN_TYPE_CD               --贷款类型代码
    ,ASSET_THD_CLS_CD           --资产三分类代码
    ,DUBIL_STATUS_CD            --借据状态代码
    ,LOAN_USAGE_CD              --贷款用途代码
    ,DIR_INDUS_CD               --投向行业代码
    ,CONT_STATUS_CD             --合同状态代码
    ,LOAN_LEVEL4_CLS_CD         --贷款四级分类代码
    ,LOAN_LEVEL5_CLS_CD         --贷款五级分类代码
    ,LOAN_LEVEL10_CLS_CD        --贷款十级分类代码
    ,LOAN_LEVEL12_CLS_CD        --贷款十二级分类代码
    ,ACRU_NON_ACRU_CD           --应计非应计代码
    ,REPAY_WAY_CD               --还款方式代码
    ,INT_SET_WAY_CD             --结息方式代码
    ,INT_ACCR_WAY_CD            --计息方式代码
    ,INT_RAT_ADJ_WAY_CD         --利率调整方式代码
    ,INT_RAT_ADJ_PED_CORP_CD    --利率调整周期单位代码
    ,INT_RAT_ADJ_PED_FREQ       --利率调整周期频率
    ,INT_RAT_BASE_TYPE_CD       --利率基准类型代码
    ,INT_RAT_FLOAT_WAY_CD       --利率浮动方式代码
    ,INT_RAT_FLOAT_DIR_CD       --利率浮动方向代码
    ,INT_RAT_FLO_VAL            --利率浮动值
    ,PRIC_REPAY_FREQ_CD         --本金还款频率代码
    ,INT_REPAY_FREQ_CD          --利息还款频率代码
    ,GUAR_WAY_CD                --担保方式代码
    ,CUST_CHAR_CD               --客户性质代码
    ,ENTER_ACCT_ACCT_NUM_TYPE   --入账账号类型
    ,REPAY_NUM_TYPE             --还款账号类型
    ,INTNAL_CARR_FLG            --内部结转标志
    ,DOM_OVERS_FLG              --境内外标志
    ,WHITE_LIST_CUST_FLG        --白户标志
    ,FARM_FLG                   --农户标志
    ,INT_ACCR_FLG               --计息标志
    ,COMP_INT_FLG               --复息标志
    ,OVDUE_FLG                  --逾期标志
    ,WRT_OFF_FLG                --核销标志
    ,OPEN_ACCT_DT               --开户日期
    ,DISTR_DT                   --放款日期
    ,VALUE_DT                   --起息日期
    ,EXP_DT                     --到期日期
    ,PAYOFF_DT                  --结清日期
    ,LAST_REPAY_DT              --上次还款日期
    ,NEXT_REPAY_DT              --下次还款日期
    ,CURR_INT_RAT_EFFECT_DT     --当前利率生效日期
    ,NEXT_INT_RAT_ADJ_DT        --下次利率调整日期
    ,CUST_MGR_ID                --客户经理编号
    ,OPEN_ACCT_ORG_ID           --开户机构编号
    ,MGMT_ORG_ID                --管理机构编号
    ,ACCT_INSTIT_ID             --账务机构编号
    ,INIT_TOT_PERDS             --原始总期数
    ,TOT_PERDS                  --总期数
    ,CURR_ISSUE_PERDS           --本期期数
    ,SURP_PERDS                 --剩余期数
    ,OVDUE_PERDS                --逾期期数
    ,PRIC_OVDUE_FLG             --本金逾期标志
    ,INT_OVDUE_FLG              --利息逾期标志
    ,PRIC_OVDUE_DAYS            --本金逾期天数
    ,INT_OVDUE_DAYS             --利息逾期天数
    ,GRACE_PERIOD_DAYS          --宽限期天数
    ,INST_COMM_FEE_RAT          --分期手续费费率
    ,BASE_RAT                   --基准利率
    ,EXEC_INT_RAT               --执行利率
    ,OVDUE_INT_RAT              --逾期利率
    ,DAILY_EXEC_INT_RAT         --每日执行利率
    ,CONT_AMT                   --合同金额
    ,DUBIL_AMT                  --借据金额
    ,DISTR_AMT                  --放款金额
    ,BANK_CONTRI_RATIO          --银行出资比例
    ,TD_ACRU_INT                --当日应计利息
    ,CURRT_ACRU_INT             --当期应计利息
    ,NOMAL_PRIC                 --正常本金
    ,OVDUE_PRIC                 --逾期本金
    ,IDLE_PRIC                  --呆滞本金
    ,BAD_DEBT_PRIC              --呆账本金
    ,WRT_OFF_PRIC               --核销本金
    ,NOMAL_INT                  --正常利息
    ,OVDUE_INT                  --逾期利息
    ,WRT_OFF_INT                --核销利息
    ,OVDUE_PRIC_PNLT            --逾期本金罚息
    ,OVDUE_INT_PNLT             --逾期利息罚息
    ,RECVBL_OVER_INT            --应收欠息
    ,RECVBL_ACRU_PNLT           --应收应计罚息
    ,RECVBL_PNLT                --应收罚息
    ,RECVBL_FEE                 --应收费用
    ,IN_BS_OVER_INT_BAL         --表内欠息余额
    ,OFF_BS_OVER_INT_BAL        --表外欠息余额
    ,IN_BS_INT                  --表内利息
    ,OFF_BS_INT                 --表外利息
    ,ACM_RECVBL_UNCOL_INT_AMT   --累计应收未收利息金额
    ,REPAID_NOMAL_PRIC          --已偿还正常本金
    ,REPAID_OVDUE_PRIC          --已偿还逾期本金
    ,REPAID_NOMAL_INT           --已偿还正常利息
    ,REPAID_OVDUE_INT           --已偿还逾期利息
    ,REPAID_OVDUE_PRIC_PNLT     --已偿还逾期本金罚息
    ,REPAID_OVDUE_INT_PNLT      --已偿还逾期利息罚息
    ,REPAID_FEE                 --已偿还费用
    ,PRIC_BAL                   --本金余额
    ,CURRT_BAL                  --当期余额
    ,CL_CURR_CURRT_BAL          --折本币当期余额
    ,EAR_D_BAL                  --日初余额
    ,EAR_M_BAL                  --月初余额
    ,EAR_S_BAL                  --季初余额
    ,EAR_Y_BAL                  --年初余额
    ,Y_ACM_BAL                  --年累计余额
    ,S_ACM_BAL                  --季累计余额
    ,M_ACM_BAL                  --月累计余额
    ,CL_CURR_EAR_D_BAL          --折本币日初余额
    ,CL_CURR_EAR_M_BAL          --折本币月初余额
    ,CL_CURR_EAR_S_BAL          --折本币季初余额
    ,CL_CURR_EAR_Y_BAL          --折本币年初余额
    ,CL_CURR_Y_ACM_BAL          --折本币年累计余额
    ,CL_CURR_EAR_D_Y_ACM_BAL    --折本币日初年累计余额
    ,CL_CURR_EAR_M_Y_ACM_BAL    --折本币月初年累计余额
    ,CL_CURR_EAR_S_Y_ACM_BAL    --折本币季初年累计余额
    ,CL_CURR_EAR_Y_Y_ACM_BAL    --折本币年初年累计余额
    ,CL_CURR_S_ACM_BAL          --折本币季累计余额
    ,CL_CURR_EAR_D_S_ACM_BAL    --折本币日初季累计余额
    ,CL_CURR_EAR_S_S_ACM_BAL    --折本币季初季累计余额
    ,CL_CURR_EAR_Y_S_ACM_BAL    --折本币年初季累计余额
    ,CL_CURR_M_ACM_BAL          --折本币月累计余额
    ,CL_CURR_EAR_D_M_ACM_BAL    --折本币日初月累计余额
    ,CL_CURR_EAR_M_M_ACM_BAL    --折本币月初月累计余额
    ,CL_CURR_EAR_Y_M_ACM_BAL    --折本币年初月累计余额
    ,Y_AVG_BAL                  --年日均余额
    ,Q_AVG_BAL                  --季日均余额
    ,M_AVG_BAL                  --月日均余额
    ,CL_CURR_Y_AVG_BAL          --折本币年日均余额
    ,CL_CURR_Q_AVG_BAL          --折本币季日均余额
    ,CL_CURR_M_AVG_BAL          --折本币月日均余额
    ,JOB_CD                     --任务代码
    ,CRED_RHT_TURN_FLG          --债权直转标志
    ,INIT_DISTR_DT              --原始放款日期
    ,INIT_DISTR_AMT             --原始放款金额
    ,CONT_ID                    --合同编号
    ,CORE_DUBIL_ID              --核心借据编号 --ADD BY YJY 20250521
    ,REGROUP_FLG                --重组标志               --ADD BY LIP 20260202
    ,REGROUP_LOAN_TYPE_CD       --重组贷款类型代码       --ADD BY LIP 20260202
    ,REGROUP_DT                 --重组日期               --ADD BY LIP 20260202
    ,INIT_EXP_DT	              --原始到期日期           --ADD BY LIP 20260202
    ,ENTER_ACCT_BANK_NAME       --入账账户开户银行名称   --ADD BY LIP 20260202
    ,REPAY_OPEN_ACCT_BANK_ID    --还款账户开户银行编号   --ADD BY LIP 20260202
    ,REPAY_OPEN_ACCT_ORG_NAME   --还款账户开户机构名称   --ADD BY LIP 20260202
    ,INTNAL_LOAN_TYPE_CD        --行内贷款类型代码       --ADD BY LIP 20260202
    )
  SELECT TO_DATE(V_P_DATE,'YYYYMMDD')  --数据日期
        ,LP_ID                         --法人编号
        ,DUBIL_ID                      --借据编号
        ,STD_PROD_ID                   --标准产品编号
        ,PROD_ID                       --产品编号
        ,CUST_ID                       --客户编号
        ,SUBJ_ID                       --科目编号
        ,ACCTNT_CATE_CD                --会计类别代码
        ,ENTER_ACCT_ACCT_NUM           --入账账号
        ,REPAY_NUM                     --还款账号
        ,RELA_AGT_ID                   --关联协议编号
        ,RELA_APPL_FLOW_NUM            --关联申请流水号
        ,CURR_CD                       --币种代码
        ,BUS_BREED_ID                  --业务品种编号
        ,LOAN_TYPE_CD                  --贷款类型代码
        ,ASSET_THD_CLS_CD              --资产三分类代码
        ,DUBIL_STATUS_CD               --借据状态代码
        ,LOAN_USAGE_CD                 --贷款用途代码
        ,DIR_INDUS_CD                  --投向行业代码
        ,CONT_STATUS_CD                --合同状态代码
        ,LOAN_LEVEL4_CLS_CD            --贷款四级分类代码
        ,LOAN_LEVEL5_CLS_CD            --贷款五级分类代码
        ,LOAN_LEVEL10_CLS_CD           --贷款十级分类代码
        ,LOAN_LEVEL12_CLS_CD           --贷款十二级分类代码
        ,ACRU_NON_ACRU_CD              --应计非应计代码
        ,REPAY_WAY_CD                  --还款方式代码
        ,INT_SET_WAY_CD                --结息方式代码
        ,INT_ACCR_WAY_CD               --计息方式代码
        ,INT_RAT_ADJ_WAY_CD            --利率调整方式代码
        ,INT_RAT_ADJ_PED_CORP_CD       --利率调整周期单位代码
        ,INT_RAT_ADJ_PED_FREQ          --利率调整周期频率
        ,INT_RAT_BASE_TYPE_CD          --利率基准类型代码
        ,INT_RAT_FLOAT_WAY_CD          --利率浮动方式代码
        ,INT_RAT_FLOAT_DIR_CD          --利率浮动方向代码
        ,INT_RAT_FLO_VAL               --利率浮动值
        ,PRIC_REPAY_FREQ_CD            --本金还款频率代码
        ,INT_REPAY_FREQ_CD             --利息还款频率代码
        ,GUAR_WAY_CD                   --担保方式代码
        ,CUST_CHAR_CD                  --客户性质代码
        ,ENTER_ACCT_ACCT_NUM_TYPE      --入账账号类型
        ,REPAY_NUM_TYPE                --还款账号类型
        ,INTNAL_CARR_FLG               --内部结转标志
        ,DOM_OVERS_FLG                 --境内外标志
        ,WHITE_LIST_CUST_FLG           --白户标志
        ,FARM_FLG                      --农户标志
        ,INT_ACCR_FLG                  --计息标志
        ,COMP_INT_FLG                  --复息标志
        ,OVDUE_FLG                     --逾期标志
        ,WRT_OFF_FLG                   --核销标志
        ,OPEN_ACCT_DT                  --开户日期
        ,DISTR_DT                      --放款日期
        ,VALUE_DT                      --起息日期
        ,EXP_DT                        --到期日期
        ,TRUNC(PAYOFF_DT)              --结清日期   MODIFY YJY 20240424
        ,LAST_REPAY_DT                 --上次还款日期
        ,NEXT_REPAY_DT                 --下次还款日期
        ,CURR_INT_RAT_EFFECT_DT        --当前利率生效日期
        ,NEXT_INT_RAT_ADJ_DT           --下次利率调整日期
        ,CUST_MGR_ID                   --客户经理编号
        ,OPEN_ACCT_ORG_ID              --开户机构编号
        ,MGMT_ORG_ID                   --管理机构编号
        ,ACCT_INSTIT_ID                --账务机构编号
        ,INIT_TOT_PERDS                --原始总期数
        ,TOT_PERDS                     --总期数
        ,CURR_ISSUE_PERDS              --本期期数
        ,SURP_PERDS                    --剩余期数
        ,OVDUE_PERDS                   --逾期期数
        ,PRIC_OVDUE_FLG                --本金逾期标志
        ,INT_OVDUE_FLG                 --利息逾期标志
        ,PRIC_OVDUE_DAYS               --本金逾期天数
        ,INT_OVDUE_DAYS                --利息逾期天数
        ,GRACE_PERIOD_DAYS             --宽限期天数
        ,INST_COMM_FEE_RAT             --分期手续费费率
        ,BASE_RAT                      --基准利率
        ,EXEC_INT_RAT                  --执行利率
        ,OVDUE_INT_RAT                 --逾期利率
        ,DAILY_EXEC_INT_RAT            --每日执行利率
        ,CONT_AMT                      --合同金额
        ,DUBIL_AMT                     --借据金额
        ,DISTR_AMT                     --放款金额
        ,BANK_CONTRI_RATIO             --银行出资比例
        ,TD_ACRU_INT                   --当日应计利息
        ,CURRT_ACRU_INT                --当期应计利息
        ,NOMAL_PRIC                    --正常本金
        ,OVDUE_PRIC                    --逾期本金
        ,IDLE_PRIC                     --呆滞本金
        ,BAD_DEBT_PRIC                 --呆账本金
        ,WRT_OFF_PRIC                  --核销本金
        ,NOMAL_INT                     --正常利息
        ,OVDUE_INT                     --逾期利息
        ,WRT_OFF_INT                   --核销利息
        ,OVDUE_PRIC_PNLT               --逾期本金罚息
        ,OVDUE_INT_PNLT                --逾期利息罚息
        ,RECVBL_OVER_INT               --应收欠息
        ,RECVBL_ACRU_PNLT              --应收应计罚息
        ,RECVBL_PNLT                   --应收罚息
        ,RECVBL_FEE                    --应收费用
        ,IN_BS_OVER_INT_BAL            --表内欠息余额
        ,OFF_BS_OVER_INT_BAL           --表外欠息余额
        ,IN_BS_INT                     --表内利息
        ,OFF_BS_INT                    --表外利息
        ,ACM_RECVBL_UNCOL_INT_AMT      --累计应收未收利息金额
        ,REPAID_NOMAL_PRIC             --已偿还正常本金
        ,REPAID_OVDUE_PRIC             --已偿还逾期本金
        ,REPAID_NOMAL_INT              --已偿还正常利息
        ,REPAID_OVDUE_INT              --已偿还逾期利息
        ,REPAID_OVDUE_PRIC_PNLT        --已偿还逾期本金罚息
        ,REPAID_OVDUE_INT_PNLT         --已偿还逾期利息罚息
        ,REPAID_FEE                    --已偿还费用
        ,PRIC_BAL                      --本金余额
        ,CURRT_BAL                     --当期余额
        ,CL_CURR_CURRT_BAL             --折本币当期余额
        ,EAR_D_BAL                     --日初余额
        ,EAR_M_BAL                     --月初余额
        ,EAR_S_BAL                     --季初余额
        ,EAR_Y_BAL                     --年初余额
        ,Y_ACM_BAL                     --年累计余额
        ,S_ACM_BAL                     --季累计余额
        ,M_ACM_BAL                     --月累计余额
        ,CL_CURR_EAR_D_BAL             --折本币日初余额
        ,CL_CURR_EAR_M_BAL             --折本币月初余额
        ,CL_CURR_EAR_S_BAL             --折本币季初余额
        ,CL_CURR_EAR_Y_BAL             --折本币年初余额
        ,CL_CURR_Y_ACM_BAL             --折本币年累计余额
        ,CL_CURR_EAR_D_Y_ACM_BAL       --折本币日初年累计余额
        ,CL_CURR_EAR_M_Y_ACM_BAL       --折本币月初年累计余额
        ,CL_CURR_EAR_S_Y_ACM_BAL       --折本币季初年累计余额
        ,CL_CURR_EAR_Y_Y_ACM_BAL       --折本币年初年累计余额
        ,CL_CURR_S_ACM_BAL             --折本币季累计余额
        ,CL_CURR_EAR_D_S_ACM_BAL       --折本币日初季累计余额
        ,CL_CURR_EAR_S_S_ACM_BAL       --折本币季初季累计余额
        ,CL_CURR_EAR_Y_S_ACM_BAL       --折本币年初季累计余额
        ,CL_CURR_M_ACM_BAL             --折本币月累计余额
        ,CL_CURR_EAR_D_M_ACM_BAL       --折本币日初月累计余额
        ,CL_CURR_EAR_M_M_ACM_BAL       --折本币月初月累计余额
        ,CL_CURR_EAR_Y_M_ACM_BAL       --折本币年初月累计余额
        ,Y_AVG_BAL                     --年日均余额
        ,Q_AVG_BAL                     --季日均余额
        ,M_AVG_BAL                     --月日均余额
        ,CL_CURR_Y_AVG_BAL             --折本币年日均余额
        ,CL_CURR_Q_AVG_BAL             --折本币季日均余额
        ,CL_CURR_M_AVG_BAL             --折本币月日均余额
        ,JOB_CD                        --任务代码
        ,CRED_RHT_TURN_FLG             --债权直转标志
        ,INIT_DISTR_DT                 --原始放款日期
        ,INIT_DISTR_AMT                --原始放款金额
        ,CONT_ID                       --合同编号
        ,NVL(TRIM(CORE_DUBIL_ID),DUBIL_ID)   AS CORE_DUBIL_ID   --核心借据编号 MOD BY YJY 20250707 调整核心借据号的加工逻辑，优先取核心借据号，取不到时取其借据号
        ,REGROUP_FLG                   --重组标志               --ADD BY LIP 20260202
        ,REGROUP_LOAN_TYPE_CD          --重组贷款类型代码       --ADD BY LIP 20260202
        ,REGROUP_DT                    --重组日期               --ADD BY LIP 20260202
        ,INIT_EXP_DT                   --原始到期日期           --ADD BY LIP 20260202
        ,ENTER_ACCT_BANK_NAME          --入账账户开户银行名称   --ADD BY LIP 20260202
        ,REPAY_OPEN_ACCT_BANK_ID       --还款账户开户银行编号   --ADD BY LIP 20260202
        ,REPAY_OPEN_ACCT_ORG_NAME      --还款账户开户机构名称   --ADD BY LIP 20260202
        ,INTNAL_LOAN_TYPE_CD           --行内贷款类型代码       --ADD BY LIP 20260202
    FROM ICL.V_CMM_UNITE_WL_DUBIL_INFO_CLEAR --联合网贷借据信息-结清
   WHERE TRUNC(PAYOFF_DT) = V_LAST_YEAR  --MODIFY YJY 20240424 只取上年年末当天发放当天结清的数据  
     AND CURRT_BAL = 0
     AND ETL_DT = CASE WHEN SUBSTR(V_P_DATE,1,4) = '2024' THEN TO_DATE('20240425','YYYYMMDD')
                       WHEN SUBSTR(V_P_DATE,1,4) < '2024' THEN V_LAST_YEAR + 10
                       ELSE V_LAST_YEAR + 1 /*2*/ --MODIFY BY 20250206
                   END;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 4;
  V_STEP_DESC := '更新部分借据的标准产品';
  V_STARTTIME := SYSDATE;
  UPDATE RRP_MDL.O_ICL_CMM_UNITE_WL_DUBIL_INFO SET STD_PROD_ID = '202020100001'
   WHERE DUBIL_ID IN ('2022123101021012033561871139','2022123101021012033375765105','2022123101021012036085354532'
          ,'2022123101021012022059202980','2022123101021012022038363952','2022123101021012034584903313'
          ,'2022123101021012035978448419','2022123101021012036074633524','2022123101021012036010505505'
          ,'2022123101021012033388858277','2022123101021012036209490519','2022123101021012023618162624'
          ,'2022123101021012023714883628','2022123101021012022009247853','2022123101021012036101419491'
          ,'2022123101021012033376600210','2022123101021012036247345477','2022123101021012023527415659'
          ,'2022123101021012033449198119','2022123101021012023636194716','2022123101021012033452951065'
          ,'2022123101021012034624639307','2022123101021012034571962306','2022123101021012023570906638'
          ,'2022123101021012036147441590','2022123101021012033786262221','2022123101021012034567195358'
          ,'2022123101021012035962598401','2022123101021012033407120055','2022123101021012035963429440'
          ,'2022123101021012023639150665','2022123101021012023622810648','2022123101021012033453476062'
          ,'2022123101021012033269819240','2022123101021012036078703588','2022123101021012033363257255'
          ,'2022123101021012036093826448','2022123101021012023526200631','2022123101021012036006509552'
          ,'2022123101021012023669920714','2022123101021012022088263896','2022123101021012036116404520'
          ,'2022123101021012022069722852','2022123101021012021996036857','2022123101021012021949753855'
          ,'2022123101021012033549948173','2022123101021012036188511517','2022123101021012033590441235'
          ,'2022123101021012022076905896','2022123101021012023641606761','2022123101021012023653917742'
          ,'2022123101021012033314702185','2022123101021012034612829373','2022123101021012033418400298'
          ,'2022123101021012023653557670','2022123101021012033492986279','2022123101021012023421673601'
          ,'2022123101021012034541880315','2022123101021012033416694298','2022123101021012036059138499'
          ,'2022123101021012034694045310');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  
  --如需要分析表，请用如下代码
  V_STEP := 5;
  V_STEP_DESC := '表分析';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := 6;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_ICL_CMM_UNITE_WL_DUBIL_INFO;
/

