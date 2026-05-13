CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_LOAN_OUT_ACCT_APPL_H(I_P_DATE IN INTEGER,
                                                               O_ERRCODE OUT VARCHAR2
                                                               )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_LOAN_OUT_ACCT_APPL_H
  *  功能描述：贷款出账申请历史
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_AGT_LOAN_OUT_ACCT_APPL_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20231108   hulj    优化O层
  *             3    20241227   YJY     优化脚本
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_LOAN_OUT_ACCT_APPL_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-贷款出账申请历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL_H
    (AGT_ID                     --申请编号
    ,OUT_ACCT_FLOW_NUM          --出账流水号
    ,CONT_ID                    --合同编号
    ,CUST_ID                    --客户编号
    ,CUST_NAME                  --客户名称
    ,PROD_ID                    --产品编号
    ,CURR_CD                    --币种代码
    ,CONT_AMT                   --合同金额
    ,THS_TM_DISTR_AMT           --本次放款金额
    ,LOAN_DISTR_TYPE_CD         --贷款发放类型代码
    ,HAPP_DT                    --发生日期
    ,DISTR_DT                   --发放日期
    ,EXP_DT                     --到期日期
    ,INT_RAT_MODE_CD            --利率模式代码
    ,FIX_INT_RAT                --固定利率
    ,BASE_RAT_TYPE_CD           --基准利率类型代码
    ,BASE_RAT                   --基准利率
    ,INT_RAT_FLOAT_TYPE_CD      --利率浮动类型代码
    ,INT_RAT_ADJ_WAY_CD         --利率调整方式代码
    ,INT_RAT_FLO_VAL            --利率浮动值
    ,EXEC_INT_RAT               --执行利率
    ,STL_ACCT_ID                --结算账户编号
    ,ENTER_ID                   --入账账户编号
    ,SECD_REPAY_ACCT_ID         --第二还款账户编号
    ,DISTR_MODE_PAY_CD          --放款支付方式代码
    ,APPL_WAY_CD                --申请方式代码
    ,APV_STATUS_CD              --审批状态代码
    ,BELONG_STRIP_LINE_CD       --所属条线代码
    ,OFF_BS_FLG                 --表外标志
    ,LOW_RISK_FLG               --低风险标志
    ,LMT_ID                     --额度编号
    ,SPEC_PED_CORP_CD           --指定周期单位代码
    ,SPEC_PED_CD                --指定周期代码
    ,REPAY_WAY_CD               --还款方式代码
    ,REPAY_PED                  --还款周期
    ,REPAY_PED_CD               --还款周期单位代码
    ,DEFLT_REPAY_DAY            --默认还款日
    ,OVDUE_EXEC_INT_RAT         --逾期执行利率
    ,OVDUE_INT_RAT_FLOAT_WAY_CD --逾期利率浮动方式代码
    ,OVDUE_INT_RAT_FLO_VAL      --逾期利率浮动值
    ,OPER_ORG_ID                --经办机构编号
    ,BUS_OPER_TELLER_ID         --业务经办人编号
    ,OPER_DT                    --经办日期
    ,RGST_TELLER_ID             --登记柜员编号
    ,RGST_ORG_ID                --登记机构编号
    ,RGST_DT                    --登记日期
    ,UPDATE_TELLER_ID           --更新柜员编号
    ,UPDATE_ORG_ID              --更新机构编号
    ,MODIF_DT                   --变更日期
    ,LP_ID                      --法人编号
    ,TEXT_CONT_ID               --文本合同编号
    ,MARGIN_ACCT_ID             --保证金账户编号
    ,MARGIN_TRAN_OUT_ACCT_ID    --保证金转出账户编号
    ,MARGIN_CURR_CD             --保证金币种代码
    ,MARGIN_RATIO               --保证金比例
    ,MARGIN_SUB_ACCT_NUM        --保证金子账号
    ,MARGIN_AMT                 --保证金金额
    ,DUBIL_ID                   --借据编号
    ,SUBJ_ID                    --科目编号
    ,OUT_ACCT_ORG_ID            --出账机构编号
    ,LOAN_ORG_ID                --贷款机构编号
    ,INT_ACCR_WAY_CD            --计息方式代码
    ,ENTER_OPEN_ACCT_ORG_ID     --入账账户开户机构编号
    ,ENTER_NAME                 --入账账户名称
    ,ENTER_SUB_ACCT_NUM         --入账账户子账号
    ,COMM_FEE_COLLECT_WAY_CD    --手续费计收方式代码
    ,COMM_FEE_DEDUCT_ACCT_ID    --手续费扣费账户编号
    ,COMM_FEE_AMORT_FLG         --手续费摊销标志
    ,COMM_FEE_RAT               --手续费率
    ,COMM_FEE_AMT               --手续费金额
    ,LOAN_USAGE_CD              --贷款用途代码
    ,ENTR_PAY_AMT               --受托支付金额
    ,ENTR_PAY_STOP_PAY_FLOW_NUM --受托支付止付流水号
    ,FILE_DT                    --归档日期
    ,MAJOR_GUAR_WAY_CD          --主要担保方式代码
    ,MON_TENOR                  --月期限
    ,DAY_TENOR                  --日期限
    ,TRAN_STATUS_CD             --交易状态代码
    ,TRAN_TM                    --交易时间
    ,CORE_TRAN_DT               --核心交易日期
    ,CORE_TRAN_FLOW_NUM         --核心交易流水号
    ,STL_ACCT_NAME              --结算账户名称
    ,INT_RAT_ADJ_PED_CD         --利率调整周期代码
    ,MOVE_REMARK                --迁移备注
    ,START_DT                   --开始时间
    ,END_DT                     --结束时间
    ,ID_MARK                    --增删标志
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务编码
    ,ETL_TIMESTAMP              --ETL处理时间戳
    )
  SELECT 
     AGT_ID                     --申请编号
    ,OUT_ACCT_FLOW_NUM          --出账流水号
    ,CONT_ID                    --合同编号
    ,CUST_ID                    --客户编号
    ,CUST_NAME                  --客户名称
    ,PROD_ID                    --产品编号
    ,CURR_CD                    --币种代码
    ,CONT_AMT                   --合同金额
    ,THS_TM_DISTR_AMT           --本次放款金额
    ,LOAN_DISTR_TYPE_CD         --贷款发放类型代码
    ,HAPP_DT                    --发生日期
    ,DISTR_DT                   --发放日期
    ,EXP_DT                     --到期日期
    ,INT_RAT_MODE_CD            --利率模式代码
    ,FIX_INT_RAT                --固定利率
    ,BASE_RAT_TYPE_CD           --基准利率类型代码
    ,BASE_RAT                   --基准利率
    ,INT_RAT_FLOAT_TYPE_CD      --利率浮动类型代码
    ,INT_RAT_ADJ_WAY_CD         --利率调整方式代码
    ,INT_RAT_FLO_VAL            --利率浮动值
    ,EXEC_INT_RAT               --执行利率
    ,STL_ACCT_ID                --结算账户编号
    ,ENTER_ID                   --入账账户编号
    ,SECD_REPAY_ACCT_ID         --第二还款账户编号
    ,DISTR_MODE_PAY_CD          --放款支付方式代码
    ,APPL_WAY_CD                --申请方式代码
    ,APV_STATUS_CD              --审批状态代码
    ,BELONG_STRIP_LINE_CD       --所属条线代码
    ,OFF_BS_FLG                 --表外标志
    ,LOW_RISK_FLG               --低风险标志
    ,LMT_ID                     --额度编号
    ,SPEC_PED_CORP_CD           --指定周期单位代码
    ,SPEC_PED_CD                --指定周期代码
    ,REPAY_WAY_CD               --还款方式代码
    ,REPAY_PED                  --还款周期
    ,REPAY_PED_CD               --还款周期单位代码
    ,DEFLT_REPAY_DAY            --默认还款日
    ,OVDUE_EXEC_INT_RAT         --逾期执行利率
    ,OVDUE_INT_RAT_FLOAT_WAY_CD --逾期利率浮动方式代码
    ,OVDUE_INT_RAT_FLO_VAL      --逾期利率浮动值
    ,OPER_ORG_ID                --经办机构编号
    ,BUS_OPER_TELLER_ID         --业务经办人编号
    ,OPER_DT                    --经办日期
    ,RGST_TELLER_ID             --登记柜员编号
    ,RGST_ORG_ID                --登记机构编号
    ,RGST_DT                    --登记日期
    ,UPDATE_TELLER_ID           --更新柜员编号
    ,UPDATE_ORG_ID              --更新机构编号
    ,MODIF_DT                   --变更日期
    ,LP_ID                      --法人编号
    ,TEXT_CONT_ID               --文本合同编号
    ,MARGIN_ACCT_ID             --保证金账户编号
    ,MARGIN_TRAN_OUT_ACCT_ID    --保证金转出账户编号
    ,MARGIN_CURR_CD             --保证金币种代码
    ,MARGIN_RATIO               --保证金比例
    ,MARGIN_SUB_ACCT_NUM        --保证金子账号
    ,MARGIN_AMT                 --保证金金额
    ,DUBIL_ID                   --借据编号
    ,SUBJ_ID                    --科目编号
    ,OUT_ACCT_ORG_ID            --出账机构编号
    ,LOAN_ORG_ID                --贷款机构编号
    ,INT_ACCR_WAY_CD            --计息方式代码
    ,ENTER_OPEN_ACCT_ORG_ID     --入账账户开户机构编号
    ,ENTER_NAME                 --入账账户名称
    ,ENTER_SUB_ACCT_NUM         --入账账户子账号
    ,COMM_FEE_COLLECT_WAY_CD    --手续费计收方式代码
    ,COMM_FEE_DEDUCT_ACCT_ID    --手续费扣费账户编号
    ,COMM_FEE_AMORT_FLG         --手续费摊销标志
    ,COMM_FEE_RAT               --手续费率
    ,COMM_FEE_AMT               --手续费金额
    ,LOAN_USAGE_CD              --贷款用途代码
    ,ENTR_PAY_AMT               --受托支付金额
    ,ENTR_PAY_STOP_PAY_FLOW_NUM --受托支付止付流水号
    ,FILE_DT                    --归档日期
    ,MAJOR_GUAR_WAY_CD          --主要担保方式代码
    ,MON_TENOR                  --月期限
    ,DAY_TENOR                  --日期限
    ,TRAN_STATUS_CD             --交易状态代码
    ,TRAN_TM                    --交易时间
    ,CORE_TRAN_DT               --核心交易日期
    ,CORE_TRAN_FLOW_NUM         --核心交易流水号
    ,STL_ACCT_NAME              --结算账户名称
    ,INT_RAT_ADJ_PED_CD         --利率调整周期代码
    ,MOVE_REMARK                --迁移备注
    ,START_DT                   --开始时间
    ,END_DT                     --结束时间
    ,ID_MARK                    --增删标志
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务编码
    ,ETL_TIMESTAMP              --ETL处理时间戳
    FROM IML.V_AGT_LOAN_OUT_ACCT_APPL_H --视图-贷款出账申请历史
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_LOAN_OUT_ACCT_APPL_H','', O_ERRCODE);

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

END ETL_O_IML_AGT_LOAN_OUT_ACCT_APPL_H;
/

