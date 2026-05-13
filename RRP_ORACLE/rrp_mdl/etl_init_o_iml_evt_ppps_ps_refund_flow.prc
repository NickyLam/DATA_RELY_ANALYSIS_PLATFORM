CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_PPPS_PS_REFUND_FLOW(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_PPPS_PS_REFUND_FLOW
  *  功能描述：PPPS退款流水
  *  创建日期：20230302
  *  开发人员：梅炜
  *  来源表： IML.V_EVT_PPPS_PS_REFUND_FLOW
  *  目标表： O_IML_EVT_PPPS_PS_REFUND_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_PPPS_PS_REFUND_FLOW'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_PPPS_PS_REFUND_FLOW ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_PPPS_PS_REFUND_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-PPPS退款流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_PPPS_PS_REFUND_FLOW
  (
					EVT_ID  --事件编号
					,LP_ID  --法人编号
					,TRAN_FLOW_NUM  --交易流水号
					,REFUND_ACCT_BELONG_ORG_ID  --退款方账户所属机构编号
					,ACPT_PAY_INSTR_CD  --收付款指令代码
					,TRAN_CURR_CD  --交易币种代码
					,TRAN_AMT  --交易金额
					,TRAN_CATE_CD  --交易类别代码
					,TRAN_DT  --交易日期
					,TRAN_TM  --交易时间
					,TRAN_STATUS_CD  --交易状态代码
					,PAY_STATUS_CD  --支付状态代码
					,BATCH_NO  --批次号
					,OVA_FLOW_NUM  --全局流水号
					,PLAT_TRAN_FLOW_NUM  --平台交易流水号
					,PLAT_TRAN_DT  --平台交易日期
					,PLAT_TRAN_TM  --平台交易时间
					,CREATE_TM  --创建时间
					,CHECK_ENTRY_DESCB  --对账描述
					,CHECK_ENTRY_STATUS_ID  --对账状态编号
					,PAYER_ACCT_TYPE_CD  --付款方账户类型代码
					,CORE_REVS_FLOW_NUM  --核心冲正流水号
					,CORE_REVS_DT  --核心冲正日期
					,CORE_TRAN_DT  --核心交易日期
					,CORE_TRAN_STATUS_CD  --核心交易状态代码
					,CORE_FLOW_NUM  --核心流水号
					,CORE_REQ_FLOW_NUM  --核心请求流水号
					,CORE_RESP_CODE  --核心响应码
					,CORE_RESP_INFO  --核心响应信息
					,RECVER_AGT_ID  --收款方协议编号
					,RECVER_ACCT_ID  --收款方账户编号
					,RECVER_ACCT_TYPE_CD  --收款方账户类型代码
					,RECVER_ACCT_NAME  --收款方账户名称
					,RECVER_ACCT_BELONG_ORG_ID  --收款方账户所属机构编号
					,ADJ_ENTRY_WAY_CD  --调账方式代码
					,REFUND_ACCT_ID  --退款方账户编号
					,SYS_RETURN_CODE  --系统返回码
					,SYS_RETURN_COMNT  --系统返回说明
					,SYS_TYPE_CD  --系统类型代码
					,SYS_FLOW_NUM  --系统流水号
					,BUS_RETURN_CODE  --业务返回码
					,BUS_RETURN_DT  --业务返回日期
					,BUS_RETURN_COMNT  --业务返回说明
					,ALDY_CLEAR_FLG  --已清算标志
					,ALDY_ADJ_ENTRY_FLG  --已调账标志
					,ALDY_TRAN_FLG  --已转移标志
					,INIT_INDENT_AMT  --原订单金额
					,INIT_PAY_BANK_TRAN_FLOW  --原付款行交易流水号
					,INIT_TRAN_FLOW_NUM  --原交易流水号
					,FINAL_UPDATE_TM  --最后更新时间
					,ETL_DT  --ETL处理日期
					,SRC_TABLE_NAME  --源表名称
					,JOB_CD  --任务编码
					,ETL_TIMESTAMP  --ETL处理时间戳
    )
    SELECT
					EVT_ID  --事件编号
					,LP_ID  --法人编号
					,TRAN_FLOW_NUM  --交易流水号
					,REFUND_ACCT_BELONG_ORG_ID  --退款方账户所属机构编号
					,ACPT_PAY_INSTR_CD  --收付款指令代码
					,TRAN_CURR_CD  --交易币种代码
					,TRAN_AMT  --交易金额
					,TRAN_CATE_CD  --交易类别代码
					,TRAN_DT  --交易日期
					,TRAN_TM  --交易时间
					,TRAN_STATUS_CD  --交易状态代码
					,PAY_STATUS_CD  --支付状态代码
					,BATCH_NO  --批次号
					,OVA_FLOW_NUM  --全局流水号
					,PLAT_TRAN_FLOW_NUM  --平台交易流水号
					,PLAT_TRAN_DT  --平台交易日期
					,PLAT_TRAN_TM  --平台交易时间
					,CREATE_TM  --创建时间
					,CHECK_ENTRY_DESCB  --对账描述
					,CHECK_ENTRY_STATUS_ID  --对账状态编号
					,PAYER_ACCT_TYPE_CD  --付款方账户类型代码
					,CORE_REVS_FLOW_NUM  --核心冲正流水号
					,CORE_REVS_DT  --核心冲正日期
					,CORE_TRAN_DT  --核心交易日期
					,CORE_TRAN_STATUS_CD  --核心交易状态代码
					,CORE_FLOW_NUM  --核心流水号
					,CORE_REQ_FLOW_NUM  --核心请求流水号
					,CORE_RESP_CODE  --核心响应码
					,CORE_RESP_INFO  --核心响应信息
					,RECVER_AGT_ID  --收款方协议编号
					,RECVER_ACCT_ID  --收款方账户编号
					,RECVER_ACCT_TYPE_CD  --收款方账户类型代码
					,RECVER_ACCT_NAME  --收款方账户名称
					,RECVER_ACCT_BELONG_ORG_ID  --收款方账户所属机构编号
					,ADJ_ENTRY_WAY_CD  --调账方式代码
					,REFUND_ACCT_ID  --退款方账户编号
					,SYS_RETURN_CODE  --系统返回码
					,SYS_RETURN_COMNT  --系统返回说明
					,SYS_TYPE_CD  --系统类型代码
					,SYS_FLOW_NUM  --系统流水号
					,BUS_RETURN_CODE  --业务返回码
					,BUS_RETURN_DT  --业务返回日期
					,BUS_RETURN_COMNT  --业务返回说明
					,ALDY_CLEAR_FLG  --已清算标志
					,ALDY_ADJ_ENTRY_FLG  --已调账标志
					,ALDY_TRAN_FLG  --已转移标志
					,INIT_INDENT_AMT  --原订单金额
					,INIT_PAY_BANK_TRAN_FLOW  --原付款行交易流水号
					,INIT_TRAN_FLOW_NUM  --原交易流水号
					,FINAL_UPDATE_TM  --最后更新时间
					,ETL_DT  --ETL处理日期
					,SRC_TABLE_NAME  --源表名称
					,JOB_CD  --任务编码
					,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IML.V_EVT_PPPS_PS_REFUND_FLOW  --视图-PPPS退款流水
;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


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

  END ETL_INIT_O_IML_EVT_PPPS_PS_REFUND_FLOW;
/

