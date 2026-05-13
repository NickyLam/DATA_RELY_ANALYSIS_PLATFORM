CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_LOAN_CONT_INFO_H(I_P_DATE IN INTEGER,
                                                           O_ERRCODE OUT VARCHAR2
                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_LOAN_CONT_INFO_H
  *  功能描述：贷款合同信息历史
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_AGT_LOAN_CONT_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250527  YJY      新增签订额度合同标志、签署纸质合同标志
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
  V_TAB_NAME  VARCHAR2(100) := 'O_IML_AGT_LOAN_CONT_INFO_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_LOAN_CONT_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_LOAN_CONT_INFO_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_LOAN_CONT_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-贷款合同信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_LOAN_CONT_INFO_H
    (AGT_ID                      --协议编号
    ,CONT_ID                     --合同编号
    ,APV_FLOW_NUM                --审批流水号
    ,RELA_CONT_ID                --关联合同编号
    ,TEXT_CONT_ID                --文本合同编号
    ,CUST_ID                     --客户编号
    ,CUST_NAME                   --客户名称
    ,LMT_CONT_FLG                --额度合同标志
    ,RELA_OLD_CONT_ID            --关联旧合同编号
    ,APPL_WAY_CD                 --申请方式代码
    ,LOAN_DISTR_TYPE_CD          --贷款发放类型代码
    ,DISTR_MODE_PAY_CD           --放款支付方式代码
    ,HAPP_DT                     --发生日期
    ,CURR_CD                     --币种代码
    ,CONT_AMT                    --合同金额
    ,ACTL_OUT_ACCT_AMT           --实际出账金额
    ,OUT_ACCT_DT                 --出账日期
    ,BASE_PROD_ID                --基础产品编号
    ,PROD_ID                     --产品编号
    ,MON_TENOR                   --月期限
    ,DAY_TENOR                   --日期限
    ,CONT_EFFECT_DT              --合同生效日期
    ,CONT_EXP_DT                 --合同到期日期
    ,LMT_CIRCL_FLG               --循环贷款标志
    ,RISK_TYPE_CD                --风险类型代码
    ,LOW_RISK_BUS_FLG            --低风险业务标志
    ,REMOTE_BUS_FLG              --异地业务标志
    ,INT_RAT_MODE_CD             --利率模式代码
    ,FIX_INT_RAT                 --固定利率
    ,BASE_RAT_TYPE_CD            --基准利率类型代码
    ,BASE_RAT                    --基准利率
    ,INT_RAT_FLOAT_TYPE_CD       --利率浮动类型代码
    ,INT_RAT_ADJ_WAY_CD          --利率调整方式代码
    ,INT_RAT_FLO_VAL             --利率浮动值
    ,EXEC_INT_RAT                --执行利率
    ,MAIN_GUAR_WAY_CD            --主担保方式代码
    ,SUPP_GUAR_WAY_FLG           --追加担保方式标志
    ,OTHER_COND_DESCB            --其他条件描述
    ,GUAR_WAY_CD_TWO             --担保方式代码二
    ,GUAR_WAY_CD_THREE           --担保方式代码三
    ,REPAY_WAY_CD                --还款方式代码
    ,SUB_GUAR_WAY_CD             --子担保方式代码
    ,REPAY_PED                   --还款周期
    ,REPAY_PED_CD                --还款周期单位代码
    ,DEFLT_REPAY_DAY             --默认还款日
    ,STL_ACCT_ID                 --结算账户编号
    ,CRDT_DIR_CD                 --授信投向代码
    ,NAT_STD_INDUS_DIR_CD        --国标行业投向代码
    ,BANK_INT_INDUS_DIR_CD       --行内行业投向代码
    ,USAGE_DESCB                 --用途描述
    ,DATA_INPUT_INTEGY_FLG       --数据录入已完善标志
    ,RSRV_AMT                    --预留金额
    ,CURR_BAL                    --当前余额
    ,NOMAL_BAL                   --正常余额
    ,LOAN_OVDUE_AMT              --贷款逾期金额
    ,IDLE_BAL                    --呆滞余额
    ,BAD_DEBT_BAL                --呆账余额
    ,IN_BS_OVER_INT_BAL          --表内欠息余额
    ,OFF_BS_OVER_INT_BAL         --表外欠息余额
    ,OVDUE_PNLT_BAL              --逾期罚息余额
    ,COMP_INT_BAL                --复息余额
    ,LOAN_OVDUE_DAYS             --贷款逾期天数
    ,OVER_INT_DAYS               --欠息天数
    ,WRT_OFF_PRIC                --核销本金
    ,WRT_OFF_INT                 --核销利息
    ,PRE_LOSS_AMT                --预测损失金额
    ,FIR_IDTFY_NON_DT            --首次认定不良日期
    ,CONT_STATUS_CD              --合同状态代码
    ,EFFECT_DT                   --生效日期
    ,TERMNT_DT                   --终止日期
    ,PAYOFF_FLG                  --结清标志
    ,OFF_BS_FLG                  --表外标志
    ,ONL_BUS_FLG                 --线上业务标志
    ,BELONG_STRIP_LINE_CD        --所属条线代码
    ,APV_STATUS_CD               --审批状态代码
    ,LMT_ID                      --额度编号
    ,OPER_TELLER_ID              --业务经办人编号
    ,OPER_ORG_ID                 --经办机构编号
    ,OPER_DT                     --经办日期
    ,RGST_TELLER_ID              --登记柜员编号
    ,RGST_ORG_ID                 --登记机构编号
    ,RGST_DT                     --登记日期
    ,UPDATE_TELLER_ID            --更新柜员编号
    ,UPDATE_ORG_ID               --更新机构编号
    ,MODIF_DT                    --变更日期
    ,LP_ID                       --法人编号
    ,SPEC_PED_CORP_CD            --指定周期单位代码
    ,SPEC_PED_CD                 --指定周期代码
    ,B_RENEW_EXP_DT              --展期前到期日期
    ,B_RENEW_AMT                 --展期前金额
    ,B_RENEW_EXEC_YEAR_INT_RAT   --展期前执行年利率
    ,HXB_RELA_PARTY_FLG          --我行关联方标志
    ,LOAN_USAGE_CD               --贷款用途代码
    ,INT_RAT_ADJ_PED_CD          --利率调整周期代码
    ,LMT_OPEN_AMT                --额度敞口金额
    ,OCCU_LMT                    --已占用额度
    ,MARGIN_CURR_CD              --保证金币种代码
    ,MARGIN_RATIO                --保证金比例
    ,MARGIN_AMT                  --保证金金额
    ,OPEN_AMT                    --敞口金额
    ,OPEN_AMT_STAT               --敞口金额统计
    ,LMT_CONT_ID                 --额度合同编号
    ,EXEC_MON_INT_RAT            --执行月利率
    ,ASSET_THD_CLS_CD            --资产三分类代码
    ,LEVEL5_CLS_CD               --五级分类代码
    ,LEVEL5_CLS_DT               --五级分类日期
    ,LEVEL11_CLS_CD              --十一级分类代码
    ,LON_POST_MGMT_TELLER_ID     --贷后管理柜员编号
    ,LON_POST_MGMT_ORG_ID        --贷后管理机构编号
    ,FILE_DT                     --归档日期
    ,FROZ_FLG                    --冻结状态代码
    ,OVDUE_EXEC_INT_RAT          --逾期执行利率
    ,OVDUE_INT_RAT_FLOAT_WAY_CD  --逾期利率浮动方式代码
    ,OVDUE_INT_RAT_FLO_VAL       --逾期利率浮动值
    ,CORE_OUT_ACCT_ORG_ID        --核心出账机构编号
    ,STL_ACCT_NAME               --结算账户名称
    ,ENTER_ID                    --入账账户编号
    ,ENTER_NAME                  --入账账户名称
    ,ENTER_OPEN_ACCT_ORG_ID      --入账账户开户机构编号
    ,BACKUP_STATUS_CD            --备份状态代码
    ,BACKUP_LMT_CONT_ID          --备份额度合同编号
    ,COMM_FEE_RAT                --手续费率
    ,MOVE_REMARK                 --迁移备注
    ,STRTG_NEW_INDUS_TYPE_CD     --战略新兴产业类型代码
    ,HIGH_NEW_TECH_CORP_FLG      --高新技术企业标志
    ,SCEN_TECH_CORP_FLG          --科技企业标志
    ,TECH_INOVT_CORP_FLG         --科创企业标志
    ,START_DT                    --开始时间
    ,END_DT                      --结束时间
    ,SIGN_LMT_CONT_FLG           --签订额度合同标志  ADD BY YJY 20250527
    ,SIGN_PAPER_CONT_FLG         --签署纸质合同标志  ADD BY YJY 20250527
    --,ID_MARK  --增删标志
    --,SRC_TABLE_NAME  --源表名称
    --,JOB_CD  --任务编码
    --,ETL_TIMESTAMP  --ETL处理时间戳
    )
  SELECT AGT_ID                      --协议编号
    ,CONT_ID                     --合同编号
    ,APV_FLOW_NUM                --审批流水号
    ,RELA_CONT_ID                --关联合同编号
    ,TEXT_CONT_ID                --文本合同编号
    ,CUST_ID                     --客户编号
    ,CUST_NAME                   --客户名称
    ,LMT_CONT_FLG                --额度合同标志
    ,RELA_OLD_CONT_ID            --关联旧合同编号
    ,APPL_WAY_CD                 --申请方式代码
    ,LOAN_DISTR_TYPE_CD          --贷款发放类型代码
    ,DISTR_MODE_PAY_CD           --放款支付方式代码
    ,HAPP_DT                     --发生日期
    ,CURR_CD                     --币种代码
    ,CONT_AMT                    --合同金额
    ,ACTL_OUT_ACCT_AMT           --实际出账金额
    ,OUT_ACCT_DT                 --出账日期
    ,BASE_PROD_ID                --基础产品编号
    ,PROD_ID                     --产品编号
    ,MON_TENOR                   --月期限
    ,DAY_TENOR                   --日期限
    ,CONT_EFFECT_DT              --合同生效日期
    ,CONT_EXP_DT                 --合同到期日期
    ,LMT_CIRCL_FLG               --循环贷款标志
    ,RISK_TYPE_CD                --风险类型代码
    ,LOW_RISK_BUS_FLG            --低风险业务标志
    ,REMOTE_BUS_FLG              --异地业务标志
    ,INT_RAT_MODE_CD             --利率模式代码
    ,FIX_INT_RAT                 --固定利率
    ,BASE_RAT_TYPE_CD            --基准利率类型代码
    ,BASE_RAT                    --基准利率
    ,INT_RAT_FLOAT_TYPE_CD       --利率浮动类型代码
    ,INT_RAT_ADJ_WAY_CD          --利率调整方式代码
    ,INT_RAT_FLO_VAL             --利率浮动值
    ,EXEC_INT_RAT                --执行利率
    ,MAIN_GUAR_WAY_CD            --主担保方式代码
    ,SUPP_GUAR_WAY_FLG           --追加担保方式标志
    ,OTHER_COND_DESCB            --其他条件描述
    ,GUAR_WAY_CD_TWO             --担保方式代码二
    ,GUAR_WAY_CD_THREE           --担保方式代码三
    ,REPAY_WAY_CD                --还款方式代码
    ,SUB_GUAR_WAY_CD             --子担保方式代码
    ,REPAY_PED                   --还款周期
    ,REPAY_PED_CD                --还款周期单位代码
    ,DEFLT_REPAY_DAY             --默认还款日
    ,STL_ACCT_ID                 --结算账户编号
    ,CRDT_DIR_CD                 --授信投向代码
    ,NAT_STD_INDUS_DIR_CD        --国标行业投向代码
    ,BANK_INT_INDUS_DIR_CD       --行内行业投向代码
    ,USAGE_DESCB                 --用途描述
    ,DATA_INPUT_INTEGY_FLG       --数据录入已完善标志
    ,RSRV_AMT                    --预留金额
    ,CURR_BAL                    --当前余额
    ,NOMAL_BAL                   --正常余额
    ,LOAN_OVDUE_AMT              --贷款逾期金额
    ,IDLE_BAL                    --呆滞余额
    ,BAD_DEBT_BAL                --呆账余额
    ,IN_BS_OVER_INT_BAL          --表内欠息余额
    ,OFF_BS_OVER_INT_BAL         --表外欠息余额
    ,OVDUE_PNLT_BAL              --逾期罚息余额
    ,COMP_INT_BAL                --复息余额
    ,LOAN_OVDUE_DAYS             --贷款逾期天数
    ,OVER_INT_DAYS               --欠息天数
    ,WRT_OFF_PRIC                --核销本金
    ,WRT_OFF_INT                 --核销利息
    ,PRE_LOSS_AMT                --预测损失金额
    ,FIR_IDTFY_NON_DT            --首次认定不良日期
    ,CONT_STATUS_CD              --合同状态代码
    ,EFFECT_DT                   --生效日期
    ,TERMNT_DT                   --终止日期
    ,PAYOFF_FLG                  --结清标志
    ,OFF_BS_FLG                  --表外标志
    ,ONL_BUS_FLG                 --线上业务标志
    ,BELONG_STRIP_LINE_CD        --所属条线代码
    ,APV_STATUS_CD               --审批状态代码
    ,LMT_ID                      --额度编号
    ,OPER_TELLER_ID              --业务经办人编号
    ,OPER_ORG_ID                 --经办机构编号
    ,OPER_DT                     --经办日期
    ,RGST_TELLER_ID              --登记柜员编号
    ,RGST_ORG_ID                 --登记机构编号
    ,RGST_DT                     --登记日期
    ,UPDATE_TELLER_ID            --更新柜员编号
    ,UPDATE_ORG_ID               --更新机构编号
    ,MODIF_DT                    --变更日期
    ,LP_ID                       --法人编号
    ,SPEC_PED_CORP_CD            --指定周期单位代码
    ,SPEC_PED_CD                 --指定周期代码
    ,B_RENEW_EXP_DT              --展期前到期日期
    ,B_RENEW_AMT                 --展期前金额
    ,B_RENEW_EXEC_YEAR_INT_RAT   --展期前执行年利率
    ,HXB_RELA_PARTY_FLG          --我行关联方标志
    ,LOAN_USAGE_CD               --贷款用途代码
    ,INT_RAT_ADJ_PED_CD          --利率调整周期代码
    ,LMT_OPEN_AMT                --额度敞口金额
    ,OCCU_LMT                    --已占用额度
    ,MARGIN_CURR_CD              --保证金币种代码
    ,MARGIN_RATIO                --保证金比例
    ,MARGIN_AMT                  --保证金金额
    ,OPEN_AMT                    --敞口金额
    ,OPEN_AMT_STAT               --敞口金额统计
    ,LMT_CONT_ID                 --额度合同编号
    ,EXEC_MON_INT_RAT            --执行月利率
    ,ASSET_THD_CLS_CD            --资产三分类代码
    ,LEVEL5_CLS_CD               --五级分类代码
    ,LEVEL5_CLS_DT               --五级分类日期
    ,LEVEL11_CLS_CD              --十一级分类代码
    ,LON_POST_MGMT_TELLER_ID     --贷后管理柜员编号
    ,LON_POST_MGMT_ORG_ID        --贷后管理机构编号
    ,FILE_DT                     --归档日期
    ,FROZ_FLG                    --冻结状态代码
    ,OVDUE_EXEC_INT_RAT          --逾期执行利率
    ,OVDUE_INT_RAT_FLOAT_WAY_CD  --逾期利率浮动方式代码
    ,OVDUE_INT_RAT_FLO_VAL       --逾期利率浮动值
    ,CORE_OUT_ACCT_ORG_ID        --核心出账机构编号
    ,STL_ACCT_NAME               --结算账户名称
    ,ENTER_ID                    --入账账户编号
    ,ENTER_NAME                  --入账账户名称
    ,ENTER_OPEN_ACCT_ORG_ID      --入账账户开户机构编号
    ,BACKUP_STATUS_CD            --备份状态代码
    ,BACKUP_LMT_CONT_ID          --备份额度合同编号
    ,COMM_FEE_RAT                --手续费率
    ,MOVE_REMARK                 --迁移备注
    ,STRTG_NEW_INDUS_TYPE_CD     --战略新兴产业类型代码
    ,HIGH_NEW_TECH_CORP_FLG      --高新技术企业标志
    ,SCEN_TECH_CORP_FLG          --科技企业标志
    ,TECH_INOVT_CORP_FLG         --科创企业标志
    ,START_DT                    --开始时间
    ,END_DT                      --结束时间
    ,SIGN_LMT_CONT_FLG           --签订额度合同标志  ADD BY YJY 20250527
    ,SIGN_PAPER_CONT_FLG         --签署纸质合同标志  ADD BY YJY 20250527
    --,ID_MARK  --增删标志
    --,SRC_TABLE_NAME  --源表名称
    --,JOB_CD  --任务编码
    --,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_AGT_LOAN_CONT_INFO_H  --视图-贷款合同信息历史
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT >= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);

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

END ETL_O_IML_AGT_LOAN_CONT_INFO_H;
/

