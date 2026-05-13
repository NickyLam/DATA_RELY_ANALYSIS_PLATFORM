CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_WLD_DUBIL_INFO_H(I_P_DATE IN INTEGER,
                                                           O_ERRCODE OUT VARCHAR2
                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_WLD_DUBIL_INFO_H
  *  功能描述：微粒贷借据信息历史
  *  创建日期：20230612
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_AGT_WLD_DUBIL_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230614  梅炜     首次创建
  *             2    20240424  YJY     PAYOFF_DT截掉时间戳
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
  V_TAB_NAME	VARCHAR2(200) := 'O_IML_AGT_WLD_DUBIL_INFO_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_WLD_DUBIL_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_WLD_DUBIL_INFO_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_WLD_DUBIL_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-微粒贷借据信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_WLD_DUBIL_INFO_H
    (AGT_ID                        --协议编号
    ,LP_ID                         --法人编号
    ,PROD_ID                       --产品编号
    ,INTNAL_DUBIL_ID               --内部借据编号
    ,DUBIL_ID                      --借据编号
    ,ACCT_ID                       --账户编号
    ,ACCT_TYPE_CD                  --账户类型代码
    ,CUST_ID                       --客户编号
    ,CUST_LMT_ID                   --客户额度编号
    ,APOT_REPAY_DEDUCT_ACCT_NUM    --约定还款扣款账号
    ,TRAN_REF_NO                   --交易参考号
    ,CARD_NO                       --卡号
    ,RENEW_EFFECT_DT               --展期生效日期
    ,LOAN_RGST_DT                  --贷款注册日期
    ,LOAN_EXP_DT                   --贷款到期日期
    ,APPL_TM                       --申请时间
    ,PAYOFF_DT                     --结清日期
    ,ADV_TERMNT_DT                 --提前终止日期
    ,GRACE_DT_TERM                 --宽限日期
    ,INIT_TRAN_DT                  --原始交易日期
    ,FIR_EXP_REPAY_DT              --首个到期还款日期
    ,LAST_BEHAV_DT                 --上次行动日期
    ,ACTV_DT                       --激活日期
    ,CURR_OVDUE_DAYS               --当前逾期天数
    ,LOAN_TYPE_CD                  --贷款类型代码
    ,LOAN_STATUS_CD                --贷款状态代码
    ,LOAN_TOT_PERDS                --贷款总期数
    ,CURR_PERDS                    --当前期数
    ,SURP_PERDS                    --剩余期数
    ,LOAN_PRIC                     --贷款本金
    ,LOAN_EH_ISSUE_RPBL_PRIC       --贷款每期应还本金
    ,LOAN_FST_RPBL_PRIC            --贷款首期应还本金
    ,LOAN_LATE_RPBL_PRIC           --贷款末期应还本金
    ,LOAN_TOT_COMM_FEE             --贷款总手续费
    ,LOAN_EH_ISSUE_COMM_FEE        --贷款每期手续费
    ,LOAN_FST_COMM_FEE             --贷款首期手续费
    ,LOAN_LATE_COMM_FEE            --贷款末期手续费
    ,LOAN_ACCT_BILL_PRIC           --贷款账单的本金
    ,LOAN_ACCT_BILL_COMM_FEE       --贷款账单手续费
    ,REPAID_PRIC                   --已偿还本金
    ,REPAID_INT                    --已偿还利息
    ,REPAID_FEE                    --已偿还费用
    ,LOAN_CURR_TOT_BAL             --贷款当前总余额
    ,LOAN_UNEXP_BAL                --贷款未到期余额
    ,LOAN_EXPD_BAL                 --贷款已到期余额
    ,DEBT_PRIC                     --欠款本金
    ,DEBT_INT                      --欠款利息
    ,DEBT_PNLT                     --欠款罚息
    ,LOAN_UNEXP_PRIC               --贷款未到期本金
    ,LOAN_EXPD_PRIC                --贷款已到期本金
    ,LOAN_UNEXP_COMM_FEE           --贷款未到期手续费
    ,LOAN_EXPD_COMM_FEE            --贷款已到期手续费
    ,CURRT_REPAY_AMT               --当期还款金额
    ,ADV_REPAY_AMT                 --提前还款金额
    ,INIT_TRAN_CURR_AMT            --原始交易币种金额
    ,RENEW_PRIC_AMT                --展期本金金额
    ,B_RENEW_EH_ISSUE_RPBL_PRIC    --展期前每期应还本金
    ,B_RENEW_TOT_PERDS             --展期前总期数
    ,B_RENEW_LOAN_FST_RPBL_PRIC    --展期前贷款首期应还本金
    ,B_RENEW_LOAN_LATE_RPBL_PRIC   --展期前贷款末期应还本金
    ,B_RENEW_LOAN_TOT_COMM_FEE     --展期前贷款总手续费
    ,B_RENEW_LOAN_EH_ISSUE_COMM_FEE   --展期前贷款每期手续费
    ,B_RENEW_LOAN_FST_COMM_FEE     --展期前贷款首期手续费
    ,B_RENEW_LOAN_LATE_COMM_FEE    --展期前贷款末期手续费
    ,A_RENEW_FST_COMM_FEE          --展期后首期手续费
    ,LOAN_TOT_INT                  --贷款总利息
    ,INIT_LOAN_TOT_INT             --原贷款总利息
    ,EXEC_INT_RAT                  --执行利率
    ,PNLT_INT_RAT                  --罚息利率
    ,COMP_INT_INT_RAT              --复利利率
    ,INT_RAT_FL_RT                 --利率浮动比例
    ,LOAN_OVDUE_MAX_PERDS          --贷款逾期最大期数
    ,RENEWD_CNT                    --已展期次数
    ,SOTERMED_CNT                  --已缩期次数
    ,LOAN_COMM_FEE_COLL_WAY_CD     --贷款手续费收取方式代码
    ,LAST_BEHAV_TYPE_CD            --上次行动类型代码
    ,INT_ACCR_BASE_CD              --计息基准代码
    ,AGING_CD                      --账龄代码
    ,LOAN_TERMNT_RS_CD             --贷款终止原因代码
    ,SYN_ID                        --银团编号
    ,LOAN_APPL_SEQ_NUM             --贷款申请顺序号
    ,CONT_EDIT_NUM                 --合同版本号
    ,LOAN_PROD_ID                  --贷款产品编号
    ,BANK_CONTRI_RATIO             --银行出资比例
    ,INIT_TRAN_AUTH_CD             --原始交易授权码
    ,OPTIMIT_LOCK_EDIT_NUM         --乐观锁版本号
    ,REVO_DT                       --撤销日期
    ,START_DT                      --开始时间
    ,END_DT                        --结束时间
    --,ID_MARK  --增删标志
    )
  SELECT 
     AGT_ID                        --协议编号
    ,LP_ID                         --法人编号
    ,PROD_ID                       --产品编号
    ,INTNAL_DUBIL_ID               --内部借据编号
    ,DUBIL_ID                      --借据编号
    ,ACCT_ID                       --账户编号
    ,ACCT_TYPE_CD                  --账户类型代码
    ,CUST_ID                       --客户编号
    ,CUST_LMT_ID                   --客户额度编号
    ,APOT_REPAY_DEDUCT_ACCT_NUM    --约定还款扣款账号
    ,TRAN_REF_NO                   --交易参考号
    ,CARD_NO                       --卡号
    ,RENEW_EFFECT_DT               --展期生效日期
    ,LOAN_RGST_DT                  --贷款注册日期
    ,LOAN_EXP_DT                   --贷款到期日期
    ,APPL_TM                       --申请时间
    ,TRUNC(PAYOFF_DT)              --结清日期   MODIFY YJY 20240424
    ,ADV_TERMNT_DT                 --提前终止日期
    ,GRACE_DT_TERM                 --宽限日期
    ,INIT_TRAN_DT                  --原始交易日期
    ,FIR_EXP_REPAY_DT              --首个到期还款日期
    ,LAST_BEHAV_DT                 --上次行动日期
    ,ACTV_DT                       --激活日期
    ,CURR_OVDUE_DAYS               --当前逾期天数
    ,LOAN_TYPE_CD                  --贷款类型代码
    ,LOAN_STATUS_CD                --贷款状态代码
    ,LOAN_TOT_PERDS                --贷款总期数
    ,CURR_PERDS                    --当前期数
    ,SURP_PERDS                    --剩余期数
    ,LOAN_PRIC                     --贷款本金
    ,LOAN_EH_ISSUE_RPBL_PRIC       --贷款每期应还本金
    ,LOAN_FST_RPBL_PRIC            --贷款首期应还本金
    ,LOAN_LATE_RPBL_PRIC           --贷款末期应还本金
    ,LOAN_TOT_COMM_FEE             --贷款总手续费
    ,LOAN_EH_ISSUE_COMM_FEE        --贷款每期手续费
    ,LOAN_FST_COMM_FEE             --贷款首期手续费
    ,LOAN_LATE_COMM_FEE            --贷款末期手续费
    ,LOAN_ACCT_BILL_PRIC           --贷款账单的本金
    ,LOAN_ACCT_BILL_COMM_FEE       --贷款账单手续费
    ,REPAID_PRIC                   --已偿还本金
    ,REPAID_INT                    --已偿还利息
    ,REPAID_FEE                    --已偿还费用
    ,LOAN_CURR_TOT_BAL             --贷款当前总余额
    ,LOAN_UNEXP_BAL                --贷款未到期余额
    ,LOAN_EXPD_BAL                 --贷款已到期余额
    ,DEBT_PRIC                     --欠款本金
    ,DEBT_INT                      --欠款利息
    ,DEBT_PNLT                     --欠款罚息
    ,LOAN_UNEXP_PRIC               --贷款未到期本金
    ,LOAN_EXPD_PRIC                --贷款已到期本金
    ,LOAN_UNEXP_COMM_FEE           --贷款未到期手续费
    ,LOAN_EXPD_COMM_FEE            --贷款已到期手续费
    ,CURRT_REPAY_AMT               --当期还款金额
    ,ADV_REPAY_AMT                 --提前还款金额
    ,INIT_TRAN_CURR_AMT            --原始交易币种金额
    ,RENEW_PRIC_AMT                --展期本金金额
    ,B_RENEW_EH_ISSUE_RPBL_PRIC    --展期前每期应还本金
    ,B_RENEW_TOT_PERDS             --展期前总期数
    ,B_RENEW_LOAN_FST_RPBL_PRIC    --展期前贷款首期应还本金
    ,B_RENEW_LOAN_LATE_RPBL_PRIC   --展期前贷款末期应还本金
    ,B_RENEW_LOAN_TOT_COMM_FEE     --展期前贷款总手续费
    ,B_RENEW_LOAN_EH_ISSUE_COMM_FEE--展期前贷款每期手续费
    ,B_RENEW_LOAN_FST_COMM_FEE     --展期前贷款首期手续费
    ,B_RENEW_LOAN_LATE_COMM_FEE    --展期前贷款末期手续费
    ,A_RENEW_FST_COMM_FEE          --展期后首期手续费
    ,LOAN_TOT_INT                  --贷款总利息
    ,INIT_LOAN_TOT_INT             --原贷款总利息
    ,EXEC_INT_RAT                  --执行利率
    ,PNLT_INT_RAT                  --罚息利率
    ,COMP_INT_INT_RAT              --复利利率
    ,INT_RAT_FL_RT                 --利率浮动比例
    ,LOAN_OVDUE_MAX_PERDS          --贷款逾期最大期数
    ,RENEWD_CNT                    --已展期次数
    ,SOTERMED_CNT                  --已缩期次数
    ,LOAN_COMM_FEE_COLL_WAY_CD     --贷款手续费收取方式代码
    ,LAST_BEHAV_TYPE_CD            --上次行动类型代码
    ,INT_ACCR_BASE_CD              --计息基准代码
    ,AGING_CD                      --账龄代码
    ,LOAN_TERMNT_RS_CD             --贷款终止原因代码
    ,SYN_ID                        --银团编号
    ,LOAN_APPL_SEQ_NUM             --贷款申请顺序号
    ,CONT_EDIT_NUM                 --合同版本号
    ,LOAN_PROD_ID                  --贷款产品编号
    ,BANK_CONTRI_RATIO             --银行出资比例
    ,INIT_TRAN_AUTH_CD             --原始交易授权码
    ,OPTIMIT_LOCK_EDIT_NUM         --乐观锁版本号
    ,REVO_DT                       --撤销日期
    ,START_DT                      --开始时间
    ,END_DT                        --结束时间
    --,ID_MARK   --增删标志
    FROM IML.V_AGT_WLD_DUBIL_INFO_H
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT	> TO_DATE(V_P_DATE,'YYYYMMDD')
     /*AND ID_MARK <> 'D'*/;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '跑批程序结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_AGT_WLD_DUBIL_INFO_H;
/

