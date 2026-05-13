CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_BILL_REDCST_INFO(I_P_DATE IN INTEGER,
                                                           O_ERRCODE OUT VARCHAR2
                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_BILL_REDCST_INFO
  *  功能描述：票据再贴现信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_BILL_REDCST_INFO
  *  目标表： O_ICL_CMM_BILL_REDCST_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_BILL_REDCST_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_BILL_REDCST_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_BILL_REDCST_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-票据再贴现信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_BILL_REDCST_INFO
    (ETL_DT                    --数据日期
    ,LP_ID                     --法人编号
    ,BUS_ID                    --业务编号
    ,BATCH_ID                  --批次编号
    ,STD_PROD_ID               --标准产品编号
    ,BILL_ID                   --票据编号
    ,SUBJ_ID                   --科目编号
    ,INT_ADJ_SUBJ_ID           --利息调整科目编号
    ,BILL_PROD_ID              --票据产品编号
    ,BILL_MED_CD               --票据介质代码
    ,BILL_KIND_CD              --票据种类代码
    ,DRAW_DT                   --出票日期
    ,EXP_DT                    --到期日期
    ,ACTL_EXP_DT               --实际到期日期
    ,APPL_DT                   --申请日期
    ,STL_DT                    --结算日期
    ,REPO_DT                   --回购日期
    ,BAG_DT                    --成交日期
    ,BAG_TM                    --成交时间
    ,CURR_CD                   --币种代码
    ,FAC_VAL_AMT               --票面金额
    ,STL_AMT                   --结算金额
    ,REPO_AMT                  --回购金额
    ,INT_AMT                   --利息金额
    ,DISCNT_INT_RAT            --贴现利率
    ,CURRT_BAL                 --当期余额
    ,INT_ADJ_BAL               --利息调整余额
    ,TD_ACRU_INT               --当日应计利息
    ,CURRT_ACRU_INT            --当期应计利息
    ,BUS_TYPE_CD               --业务类型代码
    ,CNTPTY_ID                 --交易对手编号
    ,CNTPTY_NAME               --交易对手名称
    ,CNTPTY_BANK_NO            --交易对手行号
    ,CNTPTY_CATE_CD            --交易对手类别代码
    ,CNTPTY_TYPE_CD            --交易对手类型代码
    ,HXB_ACPT_FLG              --我行承兑标志
    ,BILL_SRC_CD               --票据来源代码
    ,STL_WAY_CD                --结算方式代码
    ,DISCOUNT_BILL_FLG         --转贴票据标志
    ,REMOTE_BILL_FLG           --异地票据标志
    ,ACRD_POLICY_FLG           --符合政策标志
    ,REFUSE_FLG                --拒绝标志
    ,HOLD_DAYS                 --持票天数
    ,DEFER_DAYS                --顺延天数
    ,VALID_FLG                 --有效标志
    ,BUS_STATUS_CD             --业务状态代码
    ,ENTRY_STATUS_CD           --记账状态代码
    ,LMT_STATUS_CD             --额度状态代码
    ,CUST_MGR_ID               --客户经理编号
    ,DEPT_ID                   --部门编号
    ,BUS_ORG_ID                --业务机构编号
    ,ACCT_INSTIT_ID            --账务机构编号
    ,RGST_TELLER_ID            --登记柜员编号
    ,RECVER_ORG_ID             --收款方机构编号
    ,RECVER_TRUST_ACCT_NUM     --收款方托管账户编号
    ,RECVER_TRUST_ACCT_NAME    --收款方托管账户名称
    ,RECVER_BANK_NO            --收款方银行行号
    ,RECVER_BANK_NAME          --收款方银行名称
    ,PAYER_ORG_ID              --付款方机构编号
    ,PAYER_TRUST_ACCT_NUM      --付款方托管账户编号
    ,PAYER_TRUST_ACCT_NAME     --付款方托管账户名称
    ,PAYER_BANK_NO             --付款方银行行号
    ,PAYER_BANK_NAME           --付款方银行名称
    ,STL_STATUS_CD             --结算状态代码
    ,BILL_NUM                  --票据号码
    ,BUS_DT                    --业务日期
    ,BATCH_NO_CODE             --批次号码
    ,CTR_NT_ID                 --成交单编号
    ,JOB_CD                    --任务代码
    )
  SELECT 
     ETL_DT                    --数据日期
    ,LP_ID                     --法人编号
    ,BUS_ID                    --业务编号
    ,BATCH_ID                  --批次编号
    ,STD_PROD_ID               --标准产品编号
    ,BILL_ID                   --票据编号
    ,SUBJ_ID                   --科目编号
    ,INT_ADJ_SUBJ_ID           --利息调整科目编号
    ,BILL_PROD_ID              --票据产品编号
    ,BILL_MED_CD               --票据介质代码
    ,BILL_KIND_CD              --票据种类代码
    ,DRAW_DT                   --出票日期
    ,EXP_DT                    --到期日期
    ,ACTL_EXP_DT               --实际到期日期
    ,APPL_DT                   --申请日期
    ,STL_DT                    --结算日期
    ,REPO_DT                   --回购日期
    ,BAG_DT                    --成交日期
    ,BAG_TM                    --成交时间
    ,CURR_CD                   --币种代码
    ,FAC_VAL_AMT               --票面金额
    ,STL_AMT                   --结算金额
    ,REPO_AMT                  --回购金额
    ,INT_AMT                   --利息金额
    ,DISCNT_INT_RAT            --贴现利率
    ,CURRT_BAL                 --当期余额
    ,INT_ADJ_BAL               --利息调整余额
    ,TD_ACRU_INT               --当日应计利息
    ,CURRT_ACRU_INT            --当期应计利息
    ,BUS_TYPE_CD               --业务类型代码
    ,CNTPTY_ID                 --交易对手编号
    ,CNTPTY_NAME               --交易对手名称
    ,CNTPTY_BANK_NO            --交易对手行号
    ,CNTPTY_CATE_CD            --交易对手类别代码
    ,CNTPTY_TYPE_CD            --交易对手类型代码
    ,HXB_ACPT_FLG              --我行承兑标志
    ,BILL_SRC_CD               --票据来源代码
    ,STL_WAY_CD                --结算方式代码
    ,DISCOUNT_BILL_FLG         --转贴票据标志
    ,REMOTE_BILL_FLG           --异地票据标志
    ,ACRD_POLICY_FLG           --符合政策标志
    ,REFUSE_FLG                --拒绝标志
    ,HOLD_DAYS                 --持票天数
    ,DEFER_DAYS                --顺延天数
    ,VALID_FLG                 --有效标志
    ,BUS_STATUS_CD             --业务状态代码
    ,ENTRY_STATUS_CD           --记账状态代码
    ,LMT_STATUS_CD             --额度状态代码
    ,CUST_MGR_ID               --客户经理编号
    ,DEPT_ID                   --部门编号
    ,BUS_ORG_ID                --业务机构编号
    ,ACCT_INSTIT_ID            --账务机构编号
    ,RGST_TELLER_ID            --登记柜员编号
    ,RECVER_ORG_ID             --收款方机构编号
    ,RECVER_TRUST_ACCT_NUM     --收款方托管账户编号
    ,RECVER_TRUST_ACCT_NAME    --收款方托管账户名称
    ,RECVER_BANK_NO            --收款方银行行号
    ,RECVER_BANK_NAME          --收款方银行名称
    ,PAYER_ORG_ID              --付款方机构编号
    ,PAYER_TRUST_ACCT_NUM      --付款方托管账户编号
    ,PAYER_TRUST_ACCT_NAME     --付款方托管账户名称
    ,PAYER_BANK_NO             --付款方银行行号
    ,PAYER_BANK_NAME           --付款方银行名称
    ,STL_STATUS_CD             --结算状态代码
    ,BILL_NUM                  --票据号码
    ,BUS_DT                    --业务日期
    ,BATCH_NO_CODE             --批次号码
    ,CTR_NT_ID                 --成交单编号
    ,JOB_CD                    --任务代码
    FROM ICL.V_CMM_BILL_REDCST_INFO  --视图-票据再贴现信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

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

END ETL_O_ICL_CMM_BILL_REDCST_INFO;
/

