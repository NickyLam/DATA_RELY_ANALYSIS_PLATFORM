CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_PBC_PASS_TRAN_FLOW(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_PBC_PASS_TRAN_FLOW
  *  功能描述：人行通道交易流水表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_PBC_PASS_TRAN_FLOW
  *  目标表： O_ICL_CMM_PBC_PASS_TRAN_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_STEP      INTEGER := 0;               --处理步骤
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  --V_TAB_NAME  VARCHAR2(100):= 'O_ICL_CMM_PBC_PASS_TRAN_FLOW'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_PBC_PASS_TRAN_FLOW'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  -- DELETE FROM O_ICL_CMM_PBC_PASS_TRAN_FLOW T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  DELETE FROM RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW T
   WHERE T.TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') AND T.TRAN_DT>= TO_DATE(V_P_DATE,'YYYYMMDD')-14; --modify 20230727 CMM_PBC_PASS_TRAN_FLOW 数仓下发15天数据，要用tran_dt去卡
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-人行通道交易流水表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_PBC_PASS_TRAN_FLOW
    ( ETL_DT			                --数据日期
      ,EVT_ID			                --事件编号
      ,LP_ID			                --法人编号
      ,PAY_DECL_FORM_ID			      --支付报单编号
      ,TRAN_DT			              --交易日期
      ,OUT_LINE_PAY_TRAN_SEQ_NUM	--行外支付交易序号
      ,BANK_INT_BUS_SEQ_NUM			  --行内业务序号
      ,BUS_ORIGI_BANK_NO			    --业务发起行行号
      ,MSG_TYPE_ID			          --报文类型编号
      ,SCD_GENER_MSG_TYPE_ID			--二代报文类型编号
      ,HOST_FLOW_NUM			        --主机流水号
      ,TRAN_FLOW_NUM			        --交易流水号
      ,SEND_TRAN_FLOW_NUM			    --发送交易流水号
      ,OVA_FLOW_NUM			          --全局流水号
      ,HOST_TRAN_CODE			        --主机交易码
      ,MIDGROD_TRAN_CODE			    --中台交易码
      ,CURR_CD			              --币种代码CD1728
      ,PROD_CD			              --产品代码
      ,BUS_KIND_CD			          --业务种类代码
      ,BUS_TYPE_CD			          --业务类型代码
      ,PROC_STATUS_CD			        --处理状态代码
      ,NPC_PROC_CD			          --NPC处理代码
      ,CHECK_ENTRY_STATUS_CD			--对账状态代码
      ,DEBIT_CRDT_CD			        --借贷代码
      ,ENTRY_CODE			            --记账分录编码
      ,ACCT_GEN_CD			          --账户大类型代码
      ,ACCT_TYPE_CD			          --账户类型代码
      ,E_ACCT_CD			            --电子账户代码
      ,REC_STATUS_CD			        --记录状态代码
      ,MODE_PAY_CD			          --支付方式代码
      ,EXCH_BUS_TRAN_CHN_CD			  --汇兑业务交易渠道代码
      ,GROUND_PROC_STATUS_CD			--落地处理状态代码
      ,VERIFY_PROC_STATUS_CD			--查证处理状态代码
      ,NOSTRO_FLG			            --往账标志
      ,CHARGE_FLG			            --收费标志
      ,AGENT_FLG			            --代理标志
      ,INTNAL_ACCT_FLG			      --内部账标志
      ,ENTR_DT			              --委托日期
      ,HOST_DT			              --主机日期
      ,CLEAR_DT			              --清算日期
      ,CHECK_ENTRY_DT			        --对账日期
      ,MODIF_DT			              --修改日期
      ,MODIF_TM			              --修改时间
      ,INIT_ENTR_DT			          --原委托日期
      ,INIT_PAY_TRAN_SEQ_NUM			--原支付交易序号
      ,TRAN_AMT			              --交易金额
      ,COMM_FEE_AMT			          --手续费金额
      ,REMIT_TRAN_FEE_AMT			    --汇划费用金额
      ,TODOS			                --工本费
      ,PAYER_OPEN_BANK_DEPT_ID		--付款人开户行部门编号
      ,PAYER_OPEN_BANK_NO			    --付款人开户行行号
      ,PAYER_OPEN_BANK_NAME			  --付款人开户行名称
      ,PAYER_ACCT_NUM			        --付款人账号
      ,PAYER_NAME			            --付款人名称
      ,PAYER_ADDR			            --付款人地址
      ,RECVER_OPEN_BANK_NO			  --收款人开户行行号
      ,RECVER_OPEN_BANK_NAME			--收款人开户行名称
      ,RECVER_ACCT_NUM			      --收款人账号
      ,RECVER_NAME			          --收款人名称
      ,RECVER_ADDR			          --收款人地址
      ,ERR_RETURN_CODE			      --错误返回码
      ,ERR_INFO			              --错误信息
      ,PRIOR_LEVEL			          --优先等级
      ,INPUT_TELLER_ID			      --录入柜员编号
      ,CHECK_TELLER_ID			      --复核柜员编号
      ,AUTH_TELLER_ID			        --授权柜员编号
      ,INPUT_CHECK_TELLER_DEPT_ID	--录入复核柜员部门编号
      ,AUTH_TELLER_DEPT_ID			  --授权柜员部门编号
      ,REG_MAIN_ACCT_NUM			    --挂账或维护入账账号
      ,REG_MAIN_NAME			        --挂账或维护入账姓名
      ,MATN_ENTER_ACCT_DT			    --维护入账日期
      ,MATN_ENTER_ACCT_TELLER_ID	--维护入账柜员编号
      ,MATN_ENTER_ACCT_DEPT_ID		--维护入账部门编号
      ,VOUCH_TYPE_CD			        --凭证类型代码
      ,VOUCH_DT			              --凭证日期
      ,VOUCH_NO			              --凭证号码
      ,CERT_KIND_CD			          --证件种类代码
      ,CERT_NO			              --证件号码
      ,ACTL_DEDUCT_ACCT_NUM			  --实际扣账账号
      ,ACTL_DEDUCT_ACCT_NAME			--实际扣账账户名称
      ,RGST_ADDIT_DATA_TAB_NAME		--登记附加数据表名称
      ,ON_ACCT_RS_CD			        --挂账原因代码
      ,AUTO_REFUND_FLG			      --自动退汇标志
      ,AUTO_REFUND_CNT			      --自动退汇次数
      ,VTUAL_BIND_ACCT			      --虚户绑定账户
      ,VTUAL_BIND_ACCT_NAME			  --虚户绑定账户名称
      ,VTUAL_OPEN_ACCT_ORG_ID			--虚户绑定账户开户机构编号
      ,MGMT_ORG_ID			          --管理机构编号
      ,JNL_FLOW_NUM			          --日志流水号
      ,BANK_INT_OUT_LINE_FLG			--行内行外标志
      ,REVID_TM			              --收到时间
      ,JOB_CD			                --任务代码
      ,PBC_PASS_TRAN_TYPE_CD			--人行通道交易类型代码
    )
  SELECT 
       ETL_DT			                --数据日期
      ,EVT_ID			                --事件编号
      ,LP_ID			                --法人编号
      ,PAY_DECL_FORM_ID			      --支付报单编号
      ,TRAN_DT			              --交易日期
      ,OUT_LINE_PAY_TRAN_SEQ_NUM	--行外支付交易序号
      ,BANK_INT_BUS_SEQ_NUM			  --行内业务序号
      ,BUS_ORIGI_BANK_NO			    --业务发起行行号
      ,MSG_TYPE_ID			          --报文类型编号
      ,SCD_GENER_MSG_TYPE_ID			--二代报文类型编号
      ,HOST_FLOW_NUM			        --主机流水号
      ,TRAN_FLOW_NUM			        --交易流水号
      ,SEND_TRAN_FLOW_NUM			    --发送交易流水号
      ,OVA_FLOW_NUM			          --全局流水号
      ,HOST_TRAN_CODE			        --主机交易码
      ,MIDGROD_TRAN_CODE			    --中台交易码
      ,CURR_CD			              --币种代码CD1728
      ,PROD_CD			              --产品代码
      ,BUS_KIND_CD			          --业务种类代码
      ,BUS_TYPE_CD			          --业务类型代码
      ,PROC_STATUS_CD			        --处理状态代码
      ,NPC_PROC_CD			          --NPC处理代码
      ,CHECK_ENTRY_STATUS_CD			--对账状态代码
      ,DEBIT_CRDT_CD			        --借贷代码
      ,ENTRY_CODE			            --记账分录编码
      ,ACCT_GEN_CD			          --账户大类型代码
      ,ACCT_TYPE_CD			          --账户类型代码
      ,E_ACCT_CD			            --电子账户代码
      ,REC_STATUS_CD			        --记录状态代码
      ,MODE_PAY_CD			          --支付方式代码
      ,EXCH_BUS_TRAN_CHN_CD			  --汇兑业务交易渠道代码
      ,GROUND_PROC_STATUS_CD			--落地处理状态代码
      ,VERIFY_PROC_STATUS_CD			--查证处理状态代码
      ,NOSTRO_FLG			            --往账标志
      ,CHARGE_FLG			            --收费标志
      ,AGENT_FLG			            --代理标志
      ,INTNAL_ACCT_FLG			      --内部账标志
      ,ENTR_DT			              --委托日期
      ,HOST_DT			              --主机日期
      ,CLEAR_DT			              --清算日期
      ,CHECK_ENTRY_DT			        --对账日期
      ,MODIF_DT			              --修改日期
      ,MODIF_TM			              --修改时间
      ,INIT_ENTR_DT			          --原委托日期
      ,INIT_PAY_TRAN_SEQ_NUM			--原支付交易序号
      ,TRAN_AMT			              --交易金额
      ,COMM_FEE_AMT			          --手续费金额
      ,REMIT_TRAN_FEE_AMT			    --汇划费用金额
      ,TODOS			                --工本费
      ,PAYER_OPEN_BANK_DEPT_ID		--付款人开户行部门编号
      ,PAYER_OPEN_BANK_NO			    --付款人开户行行号
      ,PAYER_OPEN_BANK_NAME			  --付款人开户行名称
      ,PAYER_ACCT_NUM			        --付款人账号
      ,PAYER_NAME			            --付款人名称
      ,PAYER_ADDR			            --付款人地址
      ,RECVER_OPEN_BANK_NO			  --收款人开户行行号
      ,RECVER_OPEN_BANK_NAME			--收款人开户行名称
      ,RECVER_ACCT_NUM			      --收款人账号
      ,RECVER_NAME			          --收款人名称
      ,RECVER_ADDR			          --收款人地址
      ,ERR_RETURN_CODE			      --错误返回码
      ,ERR_INFO			              --错误信息
      ,PRIOR_LEVEL			          --优先等级
      ,INPUT_TELLER_ID			      --录入柜员编号
      ,CHECK_TELLER_ID			      --复核柜员编号
      ,AUTH_TELLER_ID			        --授权柜员编号
      ,INPUT_CHECK_TELLER_DEPT_ID	--录入复核柜员部门编号
      ,AUTH_TELLER_DEPT_ID			  --授权柜员部门编号
      ,REG_MAIN_ACCT_NUM			    --挂账或维护入账账号
      ,REG_MAIN_NAME			        --挂账或维护入账姓名
      ,MATN_ENTER_ACCT_DT			    --维护入账日期
      ,MATN_ENTER_ACCT_TELLER_ID	--维护入账柜员编号
      ,MATN_ENTER_ACCT_DEPT_ID		--维护入账部门编号
      ,VOUCH_TYPE_CD			        --凭证类型代码
      ,VOUCH_DT			              --凭证日期
      ,VOUCH_NO			              --凭证号码
      ,CERT_KIND_CD			          --证件种类代码
      ,CERT_NO			              --证件号码
      ,ACTL_DEDUCT_ACCT_NUM			  --实际扣账账号
      ,ACTL_DEDUCT_ACCT_NAME			--实际扣账账户名称
      ,RGST_ADDIT_DATA_TAB_NAME		--登记附加数据表名称
      ,ON_ACCT_RS_CD			        --挂账原因代码
      ,AUTO_REFUND_FLG			      --自动退汇标志
      ,AUTO_REFUND_CNT			      --自动退汇次数
      ,VTUAL_BIND_ACCT			      --虚户绑定账户
      ,VTUAL_BIND_ACCT_NAME			  --虚户绑定账户名称
      ,VTUAL_OPEN_ACCT_ORG_ID			--虚户绑定账户开户机构编号
      ,MGMT_ORG_ID			          --管理机构编号
      ,JNL_FLOW_NUM			          --日志流水号
      ,BANK_INT_OUT_LINE_FLG			--行内行外标志
      ,REVID_TM			              --收到时间
      ,JOB_CD			                --任务代码
      ,PBC_PASS_TRAN_TYPE_CD			--人行通道交易类型代码
    FROM ICL.V_CMM_PBC_PASS_TRAN_FLOW  --视图-人行通道交易流水表
   WHERE TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND TRAN_DT>= TO_DATE(V_P_DATE,'YYYYMMDD') - 14;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_ICL_CMM_PBC_PASS_TRAN_FLOW;
/

