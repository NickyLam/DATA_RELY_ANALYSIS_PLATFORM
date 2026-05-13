CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_LOAN_OUT_ACCT_APPL(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_LOAN_OUT_ACCT_APPL
  *  功能描述：公司贷款出账申请
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_AGT_LOAN_OUT_ACCT_APPL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250610  YJY      剔除删除数据
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
  V_TAB_NAME  VARCHAR2(100) := 'O_IML_AGT_LOAN_OUT_ACCT_APPL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_LOAN_OUT_ACCT_APPL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-公司贷款出账申请';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_APPL NOLOGGING
    (APPL_ID               --申请编号
    ,LP_ID                 --法人编号
    ,OUT_ACCT_FLOW_NUM     --出账流水号
    ,PARTY_ID              --当事人编号
    ,BUS_TYPE_ID           --业务类型编号
    ,CURR_CD               --币种代码
    ,AMT                   --金额
    ,TENOR_MON             --期限月
    ,DISTR_DT              --发放日期
    ,EXP_DT                --到期日期
    ,EXEC_INT_RAT          --执行利率
    ,PRIC_REPAY_WAY_CD     --本金还款方式代码
    ,SUBJ_ID               --科目编号
    ,OPER_ORG_ID           --经办机构编号
    ,OPER_TELLER_ID        --经办柜员编号
    ,OPER_DT               --经办日期
    ,RGST_ORG_ID           --登记机构编号
    ,RGST_TELLER_ID        --登记柜员编号
    ,INPUT_DT              --输入日期
    ,MODIF_DT              --变更日期
    ,FILE_DT               --归档日期
    ,BASE_RAT_CD           --基准利率代码
    ,BASE_RAT              --基准利率
    ,FLOAT_TYPE_CD         --浮动类型代码
    ,FLOAT_INT_RAT         --浮动利率
    ,CONT_ID               --合同编号
    ,DUBIL_ID              --借据编号
    ,MANU_CONT_ID          --人工合同编号
    ,STL_ACCT_ID           --结算账户编号
    ,LOAN_TYPE_CD          --贷款类型代码
    ,CRDT_LMT_AGT_ID       --授信额度协议编号
    ,INT_RAT_ADJ_TYPE_CD   --利率调整类型代码
    ,FIX_PED               --固定周期
    ,COL_INT_TYPE_CD       --收息类型代码
    ,PRE_RECV_INT_FLG      --预收息标志
    ,CONT_COMP_INT_FLG     --计复息标志
    ,SECD_REPAY_ACCT_ID    --第二还款账户编号
    ,ENTR_ACCT_ID          --委托账户编号
    ,COMM_FEE_AMT          --手续费金额
    ,COMM_FEE_COLLECT_WAY_CD   --手续费计收方式代码
    ,BUS_BREED_SUB_TYPE_CD     --业务品种子类型代码
    ,OUT_ACCT_TRAN         --出帐交易
    ,APPL_STATUS_CD        --申请状态代码
    ,BILL_ID               --票据编号
    ,RECVER_ACCT_NAME      --收款人户名称
    ,RECV_BANK_NAME        --收款行名称
    ,MARGIN_ACCT_ID        --保证金账户编号
    ,RECV_BANK_NO          --收款行行号
    ,GUAR_WAY_CD           --担保方式代码
    ,MARGIN_CURR_CD        --保证金币种代码
    ,MARGIN_RATIO          --保证金比例
    ,OUT_ACCT_ORG_ID       --出账机构编号
    ,ENTR_DEP_ACCT_ID      --委托存款账户编号
    ,CSNER_DEP_ACCT_ID     --委托人存款账户编号
    ,LOAN_ORG_ID           --贷款机构编号
    ,PRIC_AUTO_RTN_FLG     --本金自动归还标志
    ,INT_AUTO_RTN_FLG      --利息自动归还标志
    ,INT_RAT_REVAL_CD      --利率重定价代码
    ,INST_LOAN_REPAY_WAY_CD    --分期贷款还款方式代码
    ,OVDUE_LOAN_INT_RAT_FL_RT  --逾期贷款利率浮动比例
    ,OVDUE_LOAN_EXEC_INT_RAT   --逾期贷款执行利率
    ,INST_LOAN_TOT_PERDS    --分期贷款总期数
    ,ENTR_DEP_SUB_ACCT_ID   --委托存款子户编号
    ,MONEY_USE_TYPE_CD      --款项使用类型代码
    ,COLL_COMP_INT_FLG      --收复息标志
    ,TENOR_CD               --期限代码
    ,ENTR_LOAN_COMM_FEE_COLL_RATIO  --委托贷款手续费收取比例
    ,CRDT_DISTR_REPAY_PLAN_FLG      --信贷发放还款计划标志
    ,STOP_ACCR_INT_FLG      --停息标志
    ,ENTR_PAY_AMT           --委托支付金额
    ,CHECK_ORG_ID           --复核机构编号
    ,CHECK_TELLER_ID        --复核柜员编号
    ,CHECK_DT               --复核日期
    ,REPAY_WAY_CD           --还款方式代码
    ,RECVER_ACCT_ID         --收款人账户编号
    ,TRAN_TM                --交易时间
    ,MARGIN_SUB_ACCT_NUM    --保证金子户号
    ,MARGIN_AMT             --保证金金额
    ,GUAR_ORG_ID            --担保机构编号
    ,FIN_LOG_FLG            --融资性保函标志
    ,COMM_FEE               --手续费
    ,TODOS                  --工本费
    ,DISCNT_INT             --贴现利息
    ,BUS_KIND_CD            --业务种类代码
    ,OUT_ACCT_ACCT_ID       --出账账户编号
    ,STRK_BAL_FLG           --冲账标志
    ,LC_AMT                 --信用证金额
    ,INT_ACCR_METHOD_CD     --计息方法代码
    ,AGT_RAT                --协议利率
    ,MARGIN_EXP_DAY         --保证金到期日
    ,RECVER_NAME            --收款人名称
    ,ONL_BANK_DISTR_FLG     --网银放款标志
    ,CONTI_LOAN_INIT_DUBIL_ID    --续贷原借据编号
    ,LOAN_KIND_CD           --贷款种类代码
    ,MATN_FLG               --维护标志
    ,OD_PROMIS_FEE          --透支承诺费
    ,START_OD_AMT           --起透金额
    ,OD_LMT                 --透支额度
    ,OD_ACCT_NUM            --透支账户账号
    ,OD_LOAN_WAY_CD         --透支贷款方式代码
    ,LP_OD_LMT_START_DAY    --法透额度起始日
    ,LP_OD_LMT_EXP_DAY      --法透额度到期日
    ,ACCPTOR_NAME           --承兑人名称
    ,ACCPTOR_OPEN_BANK_NUM  --承兑人开户行号
    ,ACCPTOR_OPEN_BANK_NAME --承兑人开户行名称
    ,COMM_FEE_AMORT_FLG     --手续费摊销标志
    ,COMM_FEE_CHARGE_WAY_CD --手续费收费方式代码
    ,AMORT_FLOW_NUM         --摊销流水号
    ,ACPT_ENTRY_TRAN_DT     --承兑记账交易日期
    ,ACPT_ENTRY_TRAN_FLOW_NUM   --承兑记账交易流水号
    ,FIN_SYS_OUT_ACCT_FLG       --融资系统出账标志
    ,DISTR_ACCT_NAME            --放款账户名称
    ,DISTR_ACCT_OPEN_BANK_NAME  --放款账户开户行名称
    ,SIGN_CRDT_CONT_FLG         --签署授信合同标志
    ,SIG_BILL_UNIQ_MARK_ID      --单笔票据唯一标示编号
    ,ASSET_THD_CLS_CD           --资产三分类代码
    ,FFT_EXP_LC_ADVISE_ID       --福费廷出口信用证通知编号
    ,FFT_EXP_LC_ID              --福费廷出口信用证编号
    ,FFT_EXP_SEND_BILL_ID       --福费廷出口寄单编号
    ,FILE_INT_ACCR_FLG          --靠档计息标志
    ,AGCLT_FLG                  --涉农标志
    ,AGCLT_LOAN_MAIN_TYPE_CD    --涉农贷款主体类型代码
    ,AGCLT_LOAN_DIR_CD          --涉农贷款投向代码
    ,PLAT_SOLV_CAP_SRC_CD       --平台偿债资金来源代码
    ,BUID_BUS_GUAR_LOAN_FLG     --创业担保贷款标志
    ,BUID_BUS_GUAR_LOAN_TYPE_CD --创业担保贷款类型代码
    ,CREATE_DT                  --创建日期
    ,UPDATE_DT                  --更新日期
    ,ETL_DT                     --ETL处理日期
    ,ID_MARK                    --增删标志
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务编码
    ,ERA_PAY_BANK_NAME          --代付行名称
    )
  SELECT /*+PARALLEL*/
     APPL_ID               --申请编号
    ,LP_ID                 --法人编号
    ,OUT_ACCT_FLOW_NUM     --出账流水号
    ,PARTY_ID              --当事人编号
    ,BUS_TYPE_ID           --业务类型编号
    ,CURR_CD               --币种代码
    ,AMT                   --金额
    ,TENOR_MON             --期限月
    ,DISTR_DT              --发放日期
    ,EXP_DT                --到期日期
    ,EXEC_INT_RAT          --执行利率
    ,PRIC_REPAY_WAY_CD     --本金还款方式代码
    ,SUBJ_ID               --科目编号
    ,OPER_ORG_ID           --经办机构编号
    ,OPER_TELLER_ID        --经办柜员编号
    ,OPER_DT               --经办日期
    ,RGST_ORG_ID           --登记机构编号
    ,RGST_TELLER_ID        --登记柜员编号
    ,INPUT_DT              --输入日期
    ,MODIF_DT              --变更日期
    ,FILE_DT               --归档日期
    ,BASE_RAT_CD           --基准利率代码
    ,BASE_RAT              --基准利率
    ,FLOAT_TYPE_CD         --浮动类型代码
    ,FLOAT_INT_RAT         --浮动利率
    ,CONT_ID               --合同编号
    ,DUBIL_ID              --借据编号
    ,MANU_CONT_ID          --人工合同编号
    ,STL_ACCT_ID           --结算账户编号
    ,LOAN_TYPE_CD          --贷款类型代码
    ,CRDT_LMT_AGT_ID       --授信额度协议编号
    ,INT_RAT_ADJ_TYPE_CD   --利率调整类型代码
    ,FIX_PED               --固定周期
    ,COL_INT_TYPE_CD       --收息类型代码
    ,PRE_RECV_INT_FLG      --预收息标志
    ,CONT_COMP_INT_FLG     --计复息标志
    ,SECD_REPAY_ACCT_ID    --第二还款账户编号
    ,ENTR_ACCT_ID          --委托账户编号
    ,COMM_FEE_AMT          --手续费金额
    ,COMM_FEE_COLLECT_WAY_CD   --手续费计收方式代码
    ,BUS_BREED_SUB_TYPE_CD     --业务品种子类型代码
    ,OUT_ACCT_TRAN         --出帐交易
    ,APPL_STATUS_CD        --申请状态代码
    ,BILL_ID               --票据编号
    ,RECVER_ACCT_NAME      --收款人户名称
    ,RECV_BANK_NAME        --收款行名称
    ,MARGIN_ACCT_ID        --保证金账户编号
    ,RECV_BANK_NO          --收款行行号
    ,GUAR_WAY_CD           --担保方式代码
    ,MARGIN_CURR_CD        --保证金币种代码
    ,MARGIN_RATIO          --保证金比例
    ,OUT_ACCT_ORG_ID       --出账机构编号
    ,ENTR_DEP_ACCT_ID      --委托存款账户编号
    ,CSNER_DEP_ACCT_ID     --委托人存款账户编号
    ,LOAN_ORG_ID           --贷款机构编号
    ,PRIC_AUTO_RTN_FLG     --本金自动归还标志
    ,INT_AUTO_RTN_FLG      --利息自动归还标志
    ,INT_RAT_REVAL_CD      --利率重定价代码
    ,INST_LOAN_REPAY_WAY_CD    --分期贷款还款方式代码
    ,OVDUE_LOAN_INT_RAT_FL_RT  --逾期贷款利率浮动比例
    ,OVDUE_LOAN_EXEC_INT_RAT   --逾期贷款执行利率
    ,INST_LOAN_TOT_PERDS    --分期贷款总期数
    ,ENTR_DEP_SUB_ACCT_ID   --委托存款子户编号
    ,MONEY_USE_TYPE_CD      --款项使用类型代码
    ,COLL_COMP_INT_FLG      --收复息标志
    ,TENOR_CD               --期限代码
    ,ENTR_LOAN_COMM_FEE_COLL_RATIO  --委托贷款手续费收取比例
    ,CRDT_DISTR_REPAY_PLAN_FLG      --信贷发放还款计划标志
    ,STOP_ACCR_INT_FLG      --停息标志
    ,ENTR_PAY_AMT           --委托支付金额
    ,CHECK_ORG_ID           --复核机构编号
    ,CHECK_TELLER_ID        --复核柜员编号
    ,CHECK_DT               --复核日期
    ,REPAY_WAY_CD           --还款方式代码
    ,RECVER_ACCT_ID         --收款人账户编号
    ,TRAN_TM                --交易时间
    ,MARGIN_SUB_ACCT_NUM    --保证金子户号
    ,MARGIN_AMT             --保证金金额
    ,GUAR_ORG_ID            --担保机构编号
    ,FIN_LOG_FLG            --融资性保函标志
    ,COMM_FEE               --手续费
    ,TODOS                  --工本费
    ,DISCNT_INT             --贴现利息
    ,BUS_KIND_CD            --业务种类代码
    ,OUT_ACCT_ACCT_ID       --出账账户编号
    ,STRK_BAL_FLG           --冲账标志
    ,LC_AMT                 --信用证金额
    ,INT_ACCR_METHOD_CD     --计息方法代码
    ,AGT_RAT                --协议利率
    ,MARGIN_EXP_DAY         --保证金到期日
    ,RECVER_NAME            --收款人名称
    ,ONL_BANK_DISTR_FLG     --网银放款标志
    ,CONTI_LOAN_INIT_DUBIL_ID    --续贷原借据编号
    ,LOAN_KIND_CD           --贷款种类代码
    ,MATN_FLG               --维护标志
    ,OD_PROMIS_FEE          --透支承诺费
    ,START_OD_AMT           --起透金额
    ,OD_LMT                 --透支额度
    ,OD_ACCT_NUM            --透支账户账号
    ,OD_LOAN_WAY_CD         --透支贷款方式代码
    ,LP_OD_LMT_START_DAY    --法透额度起始日
    ,LP_OD_LMT_EXP_DAY      --法透额度到期日
    ,ACCPTOR_NAME           --承兑人名称
    ,ACCPTOR_OPEN_BANK_NUM  --承兑人开户行号
    ,ACCPTOR_OPEN_BANK_NAME --承兑人开户行名称
    ,COMM_FEE_AMORT_FLG     --手续费摊销标志
    ,COMM_FEE_CHARGE_WAY_CD --手续费收费方式代码
    ,AMORT_FLOW_NUM         --摊销流水号
    ,ACPT_ENTRY_TRAN_DT     --承兑记账交易日期
    ,ACPT_ENTRY_TRAN_FLOW_NUM   --承兑记账交易流水号
    ,FIN_SYS_OUT_ACCT_FLG       --融资系统出账标志
    ,DISTR_ACCT_NAME            --放款账户名称
    ,DISTR_ACCT_OPEN_BANK_NAME  --放款账户开户行名称
    ,SIGN_CRDT_CONT_FLG         --签署授信合同标志
    ,SIG_BILL_UNIQ_MARK_ID      --单笔票据唯一标示编号
    ,ASSET_THD_CLS_CD           --资产三分类代码
    ,FFT_EXP_LC_ADVISE_ID       --福费廷出口信用证通知编号
    ,FFT_EXP_LC_ID              --福费廷出口信用证编号
    ,FFT_EXP_SEND_BILL_ID       --福费廷出口寄单编号
    ,FILE_INT_ACCR_FLG          --靠档计息标志
    ,AGCLT_FLG                  --涉农标志
    ,AGCLT_LOAN_MAIN_TYPE_CD    --涉农贷款主体类型代码
    ,AGCLT_LOAN_DIR_CD          --涉农贷款投向代码
    ,PLAT_SOLV_CAP_SRC_CD       --平台偿债资金来源代码
    ,BUID_BUS_GUAR_LOAN_FLG     --创业担保贷款标志
    ,BUID_BUS_GUAR_LOAN_TYPE_CD --创业担保贷款类型代码
    ,CREATE_DT                  --创建日期
    ,UPDATE_DT                  --更新日期
    ,ETL_DT                     --ETL处理日期
    ,ID_MARK                    --增删标志
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务编码
    ,ERA_PAY_BANK_NAME          --代付行名称
    FROM IML.V_AGT_LOAN_OUT_ACCT_APPL       --公司贷款出账申请_视图
    WHERE ID_MARK <> 'D';  --MOD BY YJY 20250610

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

END ETL_O_IML_AGT_LOAN_OUT_ACCT_APPL;
/

