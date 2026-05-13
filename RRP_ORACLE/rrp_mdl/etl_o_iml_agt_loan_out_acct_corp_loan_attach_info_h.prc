CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H(I_P_DATE IN INTEGER, --跑批日期
                                                                                O_ERRCODE  OUT VARCHAR2 --错误代码
                                                                                )
 /*******************************************************************
  **存储过程详细说明： 贷款出账对公贷款附属信息历史
  **存储过程名称：    ETL_O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H
  **存储过程创建日期：20221128
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  **  20230728   hulj       新增福费廷需求6个字段
  **  20240204   hulj       新增EAST需求5个字段
  **  20241231   YJY        优化脚本
  ******************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(500) := 'ETL_O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-贷款出账对公贷款附属信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H NOLOGGING
    (APPL_ID                       --申请编号
    ,LP_ID                         --法人编号
    ,OUT_ACCT_FLOW_NUM             --出账流水号
    ,LOAN_TYPE_CD                  --贷款类型代码
    ,ENTR_DEP_ACCT_ID              --委托存款账户账号
    ,ENTR_DEP_SUB_ACCT_NUM         --委托存款子账号
    ,CSNER_DEP_ACCT_ID             --委托人存款账户编号
    ,PRIC_AUTO_RTN_FLG             --本金自动归还标志
    ,INT_AUTO_RTN_FLG              --利息自动归还标志
    ,COMN_INST_REPAY_FLG           --普通分期还款标志
    ,INST_LOAN_TOT_PERDS           --分期贷款总期数
    ,TENOR_TYPE_CD                 --期限类型代码
    ,ENTR_LOAN_COMM_FEE_RAT        --委托贷款手续费率
    ,CRDT_DISTR_REPAY_PLAN_FLG     --信贷发放还款计划标志
    ,STOP_ACCR_INT_FLG             --停息标志
    ,MARGIN_INT_RAT_TYPE_CD        --保证金利率类型代码
    ,MARGIN_INT_RAT_FLOAT_TYPE_CD  --保证金利率浮动类型代码
    ,MARGIN_INT_RAT_FLOAT_WAY_CD   --保证金利率浮动方式代码
    ,MARGIN_FLO_VAL                --保证金浮动值
    ,MARGIN_INT_ACCR_METHOD_CD     --保证金计息方法代码
    ,MARGIN_INT_RAT_LEVEL_CD       --保证金利率档次代码
    ,MARGIN_AGT_RAT                --保证金协议利率
    ,MARGIN_EXP_DT                 --保证金到期日期
    ,BILL_UNIQ_IND_NO              --票据唯一标识号
    ,LC_AMT                        --信用证金额
    ,IBANK_PAYFAN_PRIC             --同业代付本金
    ,DISCNT_BUS_ACCPTOR_NAME       --贴现业务承兑人名称
    ,BILL_ID                       --票据编号
    ,STRK_BAL_FLG                  --冲账标志
    ,INT_ACCR_DAYS                 --计息天数
    ,IBANK_PAYFAN_PROVI_INT_RAT    --同业代付计提利率
    ,TODOS                         --工本费
    ,BILL_COMM_FEE_CHARGE_WAY_CD   --票据手续费收费方式代码
    ,LOG_MODE_PAY_CD               --保函支付方式代码
    ,ACPT_BUS_ACCPTOR_NAME         --承兑业务承兑人名称
    ,DRAW_DT                       --出票日期
    ,BILL_TYPE_CD                  --票据类型代码
    ,TRUST_FLG                     --托管标志
    ,BILL_CLS_CD                   --票据分类代码
    ,INTSTL_BUS_ID                 --国结业务编号
    ,ACCPT_BIL_COMM_FEE_AMT        --承兑汇票手续费金额
    ,TRADE_FIN_RELA_AMT_ONE        --贸易融资相关金额一
    ,TRADE_FIN_RELA_AMT_TWO        --贸易融资相关金额二
    ,TRADE_FIN_RELA_AMT_THREE      --贸易融资相关金额三
    ,TRADE_FIN_RELA_DT_ONE         --贸易融资相关日期一
    ,TRADE_FIN_RELA_DT_TWO         --贸易融资相关日期二
    ,TRADE_FIN_RATIO               --贸易融资比例
    ,COLL_TYPE_CD                  --代收类型代码
    ,BILL_RGST_STATUS_FLG          --票据登记状态标志
    ,GUAR_ORG_ID                   --担保机构编号
    ,INT_AMT                       --利息金额
    ,RECV_BANK_NAME                --收款行名称
    ,TRADE_FIN_TYPE_CD             --贸易融资类型代码
    ,EXP_LC_ISSUE_BANK_NAME        --出口信用证开证行名称
    ,RECVER_OPEN_BANK_NAME         --收款人开户行名称
    ,ACCEPT_PS_NAME                --收票人名称
    ,INV_ID                        --发票号码
    ,ENTER_ID                      --入账账户编号
    ,DISTR_COND_IMPT_FLG           --放款条件落实标志
    ,TRADE_FIN_RELA_CURR_CD_ONE    --贸易融资相关币种代码一
    ,TRADE_FIN_RELA_CURR_CD_TWO    --贸易融资相关币种代码二
    ,TRADE_FIN_RELA_CURR_CD_THREE  --贸易融资相关币种代码三
    ,LOG_BNFT_BANK_NAME            --保函受益行名称
    ,FFT_ACPT_BANK_NO              --福费廷承兑行行号
    ,ACCPTOR_OPEN_BANK_NO          --承兑人开户行行号
    ,FFT_CFM_BANK_BANK_NO          --福费廷保兑行行号
    ,BUYER_PAY_INT_AMT             --买方付息金额
    ,REDEM_FLG                     --赎回标志
    ,TRADE_FIN_BUS_ID_ONE          --贸易融资业务编号一
    ,TRADE_FIN_BUS_ID_TWO          --贸易融资业务编号二
    ,ERA_PAY_BANK_NAME             --代付行名称
    ,LOG_TYPE_CD                   --保函类型代码
    ,TRADE_FIN_TENOR_TYPE_CD_ONE   --贸易融资期限类型代码一
    ,TRADE_FIN_TENOR_TYPE_CD_TWO   --贸易融资期限类型代码二
    ,ACCPTOR_OPEN_BANK_NAME        --承兑人开户行名称
    ,STL_ACCT_OPEN_BANK_NAME       --结算帐号开户行名称
    ,STL_ACCT_CUST_NAME            --结算帐号客户名称
    ,BUYER_PAY_INT_ACCT_ID         --买方付息账户编号
    ,FIN_LOG_FLG                   --融资性保函标志
    ,ENTER_OPEN_BANK_NAME          --入账账户开户行名称
    ,ENTER_CUST_NAME               --入账账户客户名称
    ,PAYFAN_PRIC_REPAY_WAY_CD      --代付本金还款方式代码
    ,LMT_CONT_ID                   --额度合同编号
    ,PRE_RECV_INT_FLG              --预收息标志
    ,COLL_COMP_INT_FLG             --收复息标志
    ,OUT_ACCT_TRAN_CODE            --出帐交易码
    ,CHECK_ORG_ID                  --复核机构编号
    ,CHECK_TELLER_ID               --复核柜员编号
    ,CHECK_DT                      --复核日期
    ,MARGIN_TRAN_STATUS_CD         --保证金交易状态代码
    ,REPAY_PLAN_TRAN_STATUS_CD     --还款计划交易状态代码
    ,CORE_OUT_ACCT_FLOW_NUM        --核心出账流水号
    ,FIN_SYS_OUT_ACCT_FLG          --融资系统出账标志
    ,CAP_SRC_CD                    --资金来源代码
    ,ACPT_ENTRY_TRAN_DT            --承兑记账交易日期
    ,ACPT_ENTRY_TRAN_FLOW_NUM      --承兑记账交易流水号
    ,START_DT                      --开始时间
    ,END_DT                        --结束时间
    ,ID_MARK                       --增删标志
    ,SRC_TABLE_NAME                --源表名称
    ,JOB_CD                        --任务编码
    ,ETL_TIMESTAMP                 --etl处理时间戳
    ,FILE_INT_FLG                  --靠档计息标志
    ,COMM_FEE                      --手续费
    ,LC_BENEFC                     --信用证受益人 add by hulj20230728
    ,FIX_INT_RAT_FLG               --固定利率标志 add by hulj20230728
    ,LC_ISSUER                     --信用证开证人 add by hulj20230728
    ,LC_BENEFC_NAME                --信用证受益人名称 --east 需求5个字段
    ,CNTPTY_RECVBL_ACCT_ID         --交易对手收款账户编号
    ,CNTPTY_RECVBL_ACCT_NAME       --交易对手收款账户名称
    ,CNTPTY_RECVBL_BANK_NO         --交易对手收款行行号
    ,CNTPTY_RECVBL_BANK_NAME       --交易对手收款行名称
    ,LEVEL1_FFT_ACTL_ENTER_ID      --一级福费廷实际入账账户编号
    )
  SELECT /*+PARALLEL*/
     APPL_ID                       --申请编号
    ,LP_ID                         --法人编号
    ,OUT_ACCT_FLOW_NUM             --出账流水号
    ,LOAN_TYPE_CD                  --贷款类型代码
    ,ENTR_DEP_ACCT_ID              --委托存款账户账号
    ,ENTR_DEP_SUB_ACCT_NUM         --委托存款子账号
    ,CSNER_DEP_ACCT_ID             --委托人存款账户编号
    ,PRIC_AUTO_RTN_FLG             --本金自动归还标志
    ,INT_AUTO_RTN_FLG              --利息自动归还标志
    ,COMN_INST_REPAY_FLG           --普通分期还款标志
    ,INST_LOAN_TOT_PERDS           --分期贷款总期数
    ,TENOR_TYPE_CD                 --期限类型代码
    ,ENTR_LOAN_COMM_FEE_RAT        --委托贷款手续费率
    ,CRDT_DISTR_REPAY_PLAN_FLG     --信贷发放还款计划标志
    ,STOP_ACCR_INT_FLG             --停息标志
    ,MARGIN_INT_RAT_TYPE_CD        --保证金利率类型代码
    ,MARGIN_INT_RAT_FLOAT_TYPE_CD  --保证金利率浮动类型代码
    ,MARGIN_INT_RAT_FLOAT_WAY_CD   --保证金利率浮动方式代码
    ,MARGIN_FLO_VAL                --保证金浮动值
    ,MARGIN_INT_ACCR_METHOD_CD     --保证金计息方法代码
    ,MARGIN_INT_RAT_LEVEL_CD       --保证金利率档次代码
    ,MARGIN_AGT_RAT                --保证金协议利率
    ,MARGIN_EXP_DT                 --保证金到期日期
    ,BILL_UNIQ_IND_NO              --票据唯一标识号
    ,LC_AMT                        --信用证金额
    ,IBANK_PAYFAN_PRIC             --同业代付本金
    ,DISCNT_BUS_ACCPTOR_NAME       --贴现业务承兑人名称
    ,BILL_ID                       --票据编号
    ,STRK_BAL_FLG                  --冲账标志
    ,INT_ACCR_DAYS                 --计息天数
    ,IBANK_PAYFAN_PROVI_INT_RAT    --同业代付计提利率
    ,TODOS                         --工本费
    ,BILL_COMM_FEE_CHARGE_WAY_CD   --票据手续费收费方式代码
    ,LOG_MODE_PAY_CD               --保函支付方式代码
    ,ACPT_BUS_ACCPTOR_NAME         --承兑业务承兑人名称
    ,DRAW_DT                       --出票日期
    ,BILL_TYPE_CD                  --票据类型代码
    ,TRUST_FLG                     --托管标志
    ,BILL_CLS_CD                   --票据分类代码
    ,INTSTL_BUS_ID                 --国结业务编号
    ,ACCPT_BIL_COMM_FEE_AMT        --承兑汇票手续费金额
    ,TRADE_FIN_RELA_AMT_ONE        --贸易融资相关金额一
    ,TRADE_FIN_RELA_AMT_TWO        --贸易融资相关金额二
    ,TRADE_FIN_RELA_AMT_THREE      --贸易融资相关金额三
    ,TRADE_FIN_RELA_DT_ONE         --贸易融资相关日期一
    ,TRADE_FIN_RELA_DT_TWO         --贸易融资相关日期二
    ,TRADE_FIN_RATIO               --贸易融资比例
    ,COLL_TYPE_CD                  --代收类型代码
    ,BILL_RGST_STATUS_FLG          --票据登记状态标志
    ,GUAR_ORG_ID                   --担保机构编号
    ,INT_AMT                       --利息金额
    ,RECV_BANK_NAME                --收款行名称
    ,TRADE_FIN_TYPE_CD             --贸易融资类型代码
    ,EXP_LC_ISSUE_BANK_NAME        --出口信用证开证行名称
    ,RECVER_OPEN_BANK_NAME         --收款人开户行名称
    ,ACCEPT_PS_NAME                --收票人名称
    ,INV_ID                        --发票号码
    ,ENTER_ID                      --入账账户编号
    ,DISTR_COND_IMPT_FLG           --放款条件落实标志
    ,TRADE_FIN_RELA_CURR_CD_ONE    --贸易融资相关币种代码一
    ,TRADE_FIN_RELA_CURR_CD_TWO    --贸易融资相关币种代码二
    ,TRADE_FIN_RELA_CURR_CD_THREE  --贸易融资相关币种代码三
    ,LOG_BNFT_BANK_NAME            --保函受益行名称
    ,FFT_ACPT_BANK_NO              --福费廷承兑行行号
    ,ACCPTOR_OPEN_BANK_NO          --承兑人开户行行号
    ,FFT_CFM_BANK_BANK_NO          --福费廷保兑行行号
    ,BUYER_PAY_INT_AMT             --买方付息金额
    ,REDEM_FLG                     --赎回标志
    ,TRADE_FIN_BUS_ID_ONE          --贸易融资业务编号一
    ,TRADE_FIN_BUS_ID_TWO          --贸易融资业务编号二
    ,ERA_PAY_BANK_NAME             --代付行名称
    ,LOG_TYPE_CD                   --保函类型代码
    ,TRADE_FIN_TENOR_TYPE_CD_ONE   --贸易融资期限类型代码一
    ,TRADE_FIN_TENOR_TYPE_CD_TWO   --贸易融资期限类型代码二
    ,ACCPTOR_OPEN_BANK_NAME        --承兑人开户行名称
    ,STL_ACCT_OPEN_BANK_NAME       --结算帐号开户行名称
    ,STL_ACCT_CUST_NAME            --结算帐号客户名称
    ,BUYER_PAY_INT_ACCT_ID         --买方付息账户编号
    ,FIN_LOG_FLG                   --融资性保函标志
    ,ENTER_OPEN_BANK_NAME          --入账账户开户行名称
    ,ENTER_CUST_NAME               --入账账户客户名称
    ,PAYFAN_PRIC_REPAY_WAY_CD      --代付本金还款方式代码
    ,LMT_CONT_ID                   --额度合同编号
    ,PRE_RECV_INT_FLG              --预收息标志
    ,COLL_COMP_INT_FLG             --收复息标志
    ,OUT_ACCT_TRAN_CODE            --出帐交易码
    ,CHECK_ORG_ID                  --复核机构编号
    ,CHECK_TELLER_ID               --复核柜员编号
    ,CHECK_DT                      --复核日期
    ,MARGIN_TRAN_STATUS_CD         --保证金交易状态代码
    ,REPAY_PLAN_TRAN_STATUS_CD     --还款计划交易状态代码
    ,CORE_OUT_ACCT_FLOW_NUM        --核心出账流水号
    ,FIN_SYS_OUT_ACCT_FLG          --融资系统出账标志
    ,CAP_SRC_CD                    --资金来源代码
    ,ACPT_ENTRY_TRAN_DT            --承兑记账交易日期
    ,ACPT_ENTRY_TRAN_FLOW_NUM      --承兑记账交易流水号
    ,START_DT                      --开始时间
    ,END_DT                        --结束时间
    ,ID_MARK                       --增删标志
    ,SRC_TABLE_NAME                --源表名称
    ,JOB_CD                        --任务编码
    ,ETL_TIMESTAMP                 --etl处理时间戳
    ,FILE_INT_FLG                  --靠档计息标志
    ,COMM_FEE                      --手续费
    ,LC_BENEFC                     --信用证受益人 add by hulj20230728
    ,FIX_INT_RAT_FLG               --固定利率标志 add by hulj20230728
    ,LC_ISSUER                     --信用证开证人 add by hulj20230728
    ,LC_BENEFC_NAME                --信用证受益人名称 --east 需求5个字段
    ,CNTPTY_RECVBL_ACCT_ID         --交易对手收款账户编号
    ,CNTPTY_RECVBL_ACCT_NAME       --交易对手收款账户名称
    ,CNTPTY_RECVBL_BANK_NO         --交易对手收款行行号
    ,CNTPTY_RECVBL_BANK_NAME       --交易对手收款行名称
    ,LEVEL1_FFT_ACTL_ENTER_ID      --一级福费廷实际入账账户编号
    FROM IML.V_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H   --贷款出账对公贷款附属信息历史表_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H','', O_ERRCODE);

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

END ETL_O_IML_AGT_LOAN_OUT_ACCT_CORP_LOAN_ATTACH_INFO_H;
/

