CREATE OR REPLACE PROCEDURE RRP_MDL."ETL_INIT_O_IML_EVT_BIGAMT_TRAN_EVT" (I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 大额交易事件
  **存储过程名称：    ETL_INIT_O_IML_EVT_BIGAMT_TRAN_EVT
  **存储过程创建日期：20221201
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
 AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_BIGAMT_TRAN_EVT'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_LAST_DAT  VARCHAR2(8); -- 当月月末
  V_YESTADAY  VARCHAR2(8); -- 上日
  V_MONTH_START_DATE DATE;  --系统时间对应月初日期
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_DATE DATE;
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_YESTADAY := TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD')-1,'YYYYMMDD'); -- 上日
  V_LAST_DAT := TO_CHAR(LAST_DAY(TO_DATE(V_P_DATE,'YYYY-MM-DD')),'YYYYMMDD'); --当月月底
  V_MONTH_START_DATE:=TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'), 'MM');


  --将参数转化为日期格式，判读输入参数是否符合日期要求
  V_DATE    := TO_DATE(I_P_DATE,'YYYY-MM-DD');

  --清理当天数据
  -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IML_EVT_BIGAMT_TRAN_EVT';

 INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_BIGAMT_TRAN_EVT NOLOGGING
    (
      EVT_ID                              --事件编号
     ,LP_ID                               --法人编号
     ,PAY_DECL_FORM_ID                    --支付报单编号
     ,TRAN_DT                             --交易日期
     ,CURR_CD                             --币种代码
     ,TRAN_AMT                            --交易金额
     ,OUT_LINE_PAY_TRAN_SEQ_NUM           --行外支付交易序号
     ,BANK_INT_BUS_SEQ_NUM                --行内业务序号
     ,MSG_TYPE_ID                         --报文类型编号
     ,HOST_TRAN_CODE                      --主机交易码
     ,MIDGROD_TRAN_CODE                   --中台交易码
     ,ENTR_DT                             --委托日期
     ,HOST_DT                             --主机日期
     ,HOST_FLOW_NUM                       --主机流水号
     ,SPEC_PRMSSN_PRTCPTR_ID              --特许参与者编号
     ,SEND_MSG_CENTER_CD                  --发报中心代码
     ,INIT_CLEAR_BK_NO                    --发起清算行行号
     ,ORIGI_BANK_NO                       --发起行行号
     ,PAYER_OPEN_BANK_DEPT_ID             --付款人开户行部门编号
     ,PAYER_OPEN_BANK_NO                  --付款人开户行行号
     ,PAYER_OPEN_BANK_NAME                --付款人开户行名称
     ,PAYER_ACCT_NUM                      --付款人账号
     ,PAYER_NAME                          --付款人名称
     ,PAYER_ADDR                          --付款人地址
     ,RECV_MSG_CENTER_CD                  --收报中心代码
     ,RECV_CLEAR_BK_NO                    --接收清算行行号
     ,RECV_BANK_BANK_NO                   --接收行行号
     ,RECVER_OPEN_BANK_NO                 --收款人开户行行号
     ,RECVER_OPEN_BANK_NAME               --收款人开户行名称
     ,RECVER_ACCT_NUM                     --收款人账号
     ,RECVER_NAME                         --收款人名称
     ,RECVER_ADDR                         --收款人地址
     ,BUS_KIND_CD                         --业务种类代码
     ,BUS_TYPE_CD                         --业务类型代码
     ,INIT_ENTR_DT                        --原委托日期
     ,INIT_PAY_TRAN_SEQ_NUM               --原支付交易序号
     ,INIT_PRTCPT_ORG_ID                  --原发起参与机构编号
     ,INIT_MSG_TYPE_ID                    --原报文类型编号
     ,PROC_STATUS_CD                      --处理状态代码
     ,PBC_BUS_STATUS_CD                   --人行业务状态代码
     ,NPC_PROC_CD                         --NPC处理代码
     ,SYS_TYPE_CD                         --系统类型代码
     ,NODE_TYPE_CD                        --节点类型代码
     ,NPC_REST_CD                         --NPC处理结果代码
     ,CHECK_REVS_FLOW_NUM                 --复核冲正流水号
     ,SEND_REVS_FLOW_NUM                  --发送冲正流水号
     ,CLEAR_DT                            --清算日期
     ,ERR_RETURN_CODE                     --错误返回编码
     ,ERR_INFO                            --错误信息
     ,PRIOR_LEVEL                         --优先级别
     ,INPUT_TELLER_ID                     --录入柜员编号
     ,CHECK_TELLER_ID                     --复核柜员编号
     ,AUTH_TELLER_ID                      --授权柜员编号
     ,INPUT_CHECK_TELLER_DEPT_ID          --录入复核柜员部门编号
     ,AUTH_TELLER_DEPT_ID                 --授权柜员部门编号
     ,CHECK_ENTRY_STATUS_CD               --对账状态代码
     ,PRINT_CNT                           --打印次数
     ,REVID_TM                            --收到时间
     ,SEND_TM                             --发送时间
     ,SUGST_PAY_DT                        --提示付款日期
     ,NOSTRO_FLG                          --往来账标志
     ,CHARGE_FLG                          --收费标志
     ,DEBIT_CRDT_CD                       --借贷代码
     ,REG_MAIN_ACCT_NUM                   --挂账或维护入账账号
     ,REG_MAIN_NAME                       --挂账或维护入账姓名
     ,MATN_ENTER_ACCT_DT                  --维护入账日期
     ,MATN_ENTER_ACCT_TELLER_ID           --维护入账柜员编号
     ,MATN_ENTER_ACCT_DEPT_ID             --维护入账部门编号
     ,CLARIFY_ENTER_ACCT_NUM              --清分入账账号
     ,CLARIFY_FLOW_NUM                    --清分流水号
     ,AGENT_FLG                           --代理标志
     ,JNL_FLOW_NUM                        --日志流水号
     ,SEND_JNL_FLOW_NUM                   --发送日志流水号
     ,VOUCH_TYPE_CD                       --凭证类型代码
     ,VOUCH_DT                            --凭证日期
     ,VOUCH_NO                            --凭证号码
     ,CERT_KIND_CD                        --证件种类代码
     ,CERT_NO                             --证件号码
     ,TRAN_LMT                            --转账限额
     ,TRAN_FLOW_NUM                       --交易流水号
     ,SEND_TRAN_FLOW_NUM                  --发送交易流水号
     ,MODIF_TM                            --修改时间
     ,CC_BANK_DRAFT_ID                    --城商行汇票编号
     ,REC_UPDATE_EDIT_NUM                 --记录更新版本号
     ,REC_STATUS_CD                       --记录状态代码
     ,MODE_PAY_CD                         --支付方式代码
     ,EXCH_BUS_TRAN_CHN_CD                --汇兑业务交易渠道代码
     ,MODIF_DT                            --修改日期
     ,BUS_FLOW_NUM                        --业务流水号
     ,MGMT_ORG_ID                         --管理机构编号
     ,COMM_FEE_AMT                        --手续费用金额
     ,REMIT_TRAN_FEE_AMT                  --汇划费用金额
     ,TODOS                               --工本费
     ,MPR_TELLER_ID                       --维护入账冲账柜员编号
     ,REVS_TRAN_FLOW_NUM                  --冲正交易流水号
     ,REVS_TRAN_DT                        --冲正交易日期
     ,PROD_CD                             --产品代码
     ,INTNAL_ACCT_FLG                     --内部账标志
     ,ACTL_DEDUCT_ACCT_NUM                --实际扣账账号
     ,ACTL_DEDUCT_ACCT_NAME               --实际扣账户名称
     ,BANK_INT_SYS_EDIT_NUM               --行内系统版本号
     ,CNTPTY_SYS_EDIT_NUM                 --对手系统版本号
     ,GROUND_PROC_STATUS_CD               --落地处理状态代码
     ,VERIFY_PROC_STATUS_CD               --查证处理状态代码
     ,RGST_ADDIT_DATA_NAME                --登记附加数据表名称
     ,ON_ACCT_RS_CD                       --挂账原因代码
     ,SCD_GENER_MSG_TYPE_ID               --二代报文类型编号
     ,SCD_GENER_BUS_TYPE_CD               --二代业务类型代码
     ,SCD_GENER_BUS_KIND_CD               --二代业务种类代码
     ,CHARGE_WAY_CD                       --收费方式代码
     ,E_ACCT_CD                           --电子账户代码
     ,CHN_FLOW_NUM                        --渠道流水号
     ,NEXT_DAY_TRAN_FLG                   --次日转账标志
     ,AUTO_REFUND_FLG                     --自动退汇标志
     ,AUTO_REFUND_CNT                     --自动退汇次数
     ,VTUAL_ACCT_BIND_ACCT                --虚户绑定账户
     ,VTUAL_ACCT_BIND_ACCT_NAME           --虚户绑定账户名称
     ,ACCT_TYPE_CD                        --账户类型代码
     ,VTUAL_OPEN_ACCT_ORG_ID              --虚户绑定账户开户机构编号
     ,ACCT_GEN_CD                         --账户大类型代码
     ,LMT_ORDER_NO                        --限额订单号
     ,OVA_FLOW_NUM                        --全局流水号
     ,ESB_INTFC_RETURN_CODE               --ESB接口返回码
     ,ESB_INTFC_RETURN_INFO               --ESB接口返回信息
     ,ESB_INTFC_TRAN_FLOW_NUM             --ESB接口交易流水号
     ,SEND_PBC_TM                         --发送人行时间
     ,ETL_DT                              --数据日期
     ,SRC_TABLE_NAME                      --源表名称
     ,JOB_CD                              --任务代码
     ,ETL_TIMESTAMP                       --数据处理时间
    )
     SELECT /*+PARALLEL*/
         EVT_ID                              --事件编号
     ,LP_ID                               --法人编号
     ,PAY_DECL_FORM_ID                    --支付报单编号
     ,TRAN_DT                             --交易日期
     ,CURR_CD                             --币种代码
     ,TRAN_AMT                            --交易金额
     ,OUT_LINE_PAY_TRAN_SEQ_NUM           --行外支付交易序号
     ,BANK_INT_BUS_SEQ_NUM                --行内业务序号
     ,MSG_TYPE_ID                         --报文类型编号
     ,HOST_TRAN_CODE                      --主机交易码
     ,MIDGROD_TRAN_CODE                   --中台交易码
     ,ENTR_DT                             --委托日期
     ,HOST_DT                             --主机日期
     ,HOST_FLOW_NUM                       --主机流水号
     ,SPEC_PRMSSN_PRTCPTR_ID              --特许参与者编号
     ,SEND_MSG_CENTER_CD                  --发报中心代码
     ,INIT_CLEAR_BK_NO                    --发起清算行行号
     ,ORIGI_BANK_NO                       --发起行行号
     ,PAYER_OPEN_BANK_DEPT_ID             --付款人开户行部门编号
     ,PAYER_OPEN_BANK_NO                  --付款人开户行行号
     ,PAYER_OPEN_BANK_NAME                --付款人开户行名称
     ,PAYER_ACCT_NUM                      --付款人账号
     ,PAYER_NAME                          --付款人名称
     ,PAYER_ADDR                          --付款人地址
     ,RECV_MSG_CENTER_CD                  --收报中心代码
     ,RECV_CLEAR_BK_NO                    --接收清算行行号
     ,RECV_BANK_BANK_NO                   --接收行行号
     ,RECVER_OPEN_BANK_NO                 --收款人开户行行号
     ,RECVER_OPEN_BANK_NAME               --收款人开户行名称
     ,RECVER_ACCT_NUM                     --收款人账号
     ,RECVER_NAME                         --收款人名称
     ,RECVER_ADDR                         --收款人地址
     ,BUS_KIND_CD                         --业务种类代码
     ,BUS_TYPE_CD                         --业务类型代码
     ,INIT_ENTR_DT                        --原委托日期
     ,INIT_PAY_TRAN_SEQ_NUM               --原支付交易序号
     ,INIT_PRTCPT_ORG_ID                  --原发起参与机构编号
     ,INIT_MSG_TYPE_ID                    --原报文类型编号
     ,PROC_STATUS_CD                      --处理状态代码
     ,PBC_BUS_STATUS_CD                   --人行业务状态代码
     ,NPC_PROC_CD                         --NPC处理代码
     ,SYS_TYPE_CD                         --系统类型代码
     ,NODE_TYPE_CD                        --节点类型代码
     ,NPC_REST_CD                         --NPC处理结果代码
     ,CHECK_REVS_FLOW_NUM                 --复核冲正流水号
     ,SEND_REVS_FLOW_NUM                  --发送冲正流水号
     ,CLEAR_DT                            --清算日期
     ,ERR_RETURN_CODE                     --错误返回编码
     ,ERR_INFO                            --错误信息
     ,PRIOR_LEVEL                         --优先级别
     ,INPUT_TELLER_ID                     --录入柜员编号
     ,CHECK_TELLER_ID                     --复核柜员编号
     ,AUTH_TELLER_ID                      --授权柜员编号
     ,INPUT_CHECK_TELLER_DEPT_ID          --录入复核柜员部门编号
     ,AUTH_TELLER_DEPT_ID                 --授权柜员部门编号
     ,CHECK_ENTRY_STATUS_CD               --对账状态代码
     ,PRINT_CNT                           --打印次数
     ,REVID_TM                            --收到时间
     ,SEND_TM                             --发送时间
     ,SUGST_PAY_DT                        --提示付款日期
     ,NOSTRO_FLG                          --往来账标志
     ,CHARGE_FLG                          --收费标志
     ,DEBIT_CRDT_CD                       --借贷代码
     ,REG_MAIN_ACCT_NUM                   --挂账或维护入账账号
     ,REG_MAIN_NAME                       --挂账或维护入账姓名
     ,MATN_ENTER_ACCT_DT                  --维护入账日期
     ,MATN_ENTER_ACCT_TELLER_ID           --维护入账柜员编号
     ,MATN_ENTER_ACCT_DEPT_ID             --维护入账部门编号
     ,CLARIFY_ENTER_ACCT_NUM              --清分入账账号
     ,CLARIFY_FLOW_NUM                    --清分流水号
     ,AGENT_FLG                           --代理标志
     ,JNL_FLOW_NUM                        --日志流水号
     ,SEND_JNL_FLOW_NUM                   --发送日志流水号
     ,VOUCH_TYPE_CD                       --凭证类型代码
     ,VOUCH_DT                            --凭证日期
     ,VOUCH_NO                            --凭证号码
     ,CERT_KIND_CD                        --证件种类代码
     ,CERT_NO                             --证件号码
     ,TRAN_LMT                            --转账限额
     ,TRAN_FLOW_NUM                       --交易流水号
     ,SEND_TRAN_FLOW_NUM                  --发送交易流水号
     ,MODIF_TM                            --修改时间
     ,CC_BANK_DRAFT_ID                    --城商行汇票编号
     ,REC_UPDATE_EDIT_NUM                 --记录更新版本号
     ,REC_STATUS_CD                       --记录状态代码
     ,MODE_PAY_CD                         --支付方式代码
     ,EXCH_BUS_TRAN_CHN_CD                --汇兑业务交易渠道代码
     ,MODIF_DT                            --修改日期
     ,BUS_FLOW_NUM                        --业务流水号
     ,MGMT_ORG_ID                         --管理机构编号
     ,COMM_FEE_AMT                        --手续费用金额
     ,REMIT_TRAN_FEE_AMT                  --汇划费用金额
     ,TODOS                               --工本费
     ,MPR_TELLER_ID                       --维护入账冲账柜员编号
     ,REVS_TRAN_FLOW_NUM                  --冲正交易流水号
     ,REVS_TRAN_DT                        --冲正交易日期
     ,PROD_CD                             --产品代码
     ,INTNAL_ACCT_FLG                     --内部账标志
     ,ACTL_DEDUCT_ACCT_NUM                --实际扣账账号
     ,ACTL_DEDUCT_ACCT_NAME               --实际扣账户名称
     ,BANK_INT_SYS_EDIT_NUM               --行内系统版本号
     ,CNTPTY_SYS_EDIT_NUM                 --对手系统版本号
     ,GROUND_PROC_STATUS_CD               --落地处理状态代码
     ,VERIFY_PROC_STATUS_CD               --查证处理状态代码
     ,RGST_ADDIT_DATA_NAME                --登记附加数据表名称
     ,ON_ACCT_RS_CD                       --挂账原因代码
     ,SCD_GENER_MSG_TYPE_ID               --二代报文类型编号
     ,SCD_GENER_BUS_TYPE_CD               --二代业务类型代码
     ,SCD_GENER_BUS_KIND_CD               --二代业务种类代码
     ,CHARGE_WAY_CD                       --收费方式代码
     ,E_ACCT_CD                           --电子账户代码
     ,CHN_FLOW_NUM                        --渠道流水号
     ,NEXT_DAY_TRAN_FLG                   --次日转账标志
     ,AUTO_REFUND_FLG                     --自动退汇标志
     ,AUTO_REFUND_CNT                     --自动退汇次数
     ,VTUAL_ACCT_BIND_ACCT                --虚户绑定账户
     ,VTUAL_ACCT_BIND_ACCT_NAME           --虚户绑定账户名称
     ,ACCT_TYPE_CD                        --账户类型代码
     ,VTUAL_OPEN_ACCT_ORG_ID              --虚户绑定账户开户机构编号
     ,ACCT_GEN_CD                         --账户大类型代码
     ,LMT_ORDER_NO                        --限额订单号
     ,OVA_FLOW_NUM                        --全局流水号
     ,ESB_INTFC_RETURN_CODE               --ESB接口返回码
     ,ESB_INTFC_RETURN_INFO               --ESB接口返回信息
     ,ESB_INTFC_TRAN_FLOW_NUM             --ESB接口交易流水号
     ,SEND_PBC_TM                         --发送人行时间
     ,ETL_DT                              --数据日期
     ,SRC_TABLE_NAME                      --源表名称
     ,JOB_CD                              --任务代码
     ,ETL_TIMESTAMP                       --数据处理时间
    FROM IML.V_EVT_BIGAMT_TRAN_EVT   --视图大额交易事件表


   ;
 -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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


END ETL_INIT_O_IML_EVT_BIGAMT_TRAN_EVT;
/

