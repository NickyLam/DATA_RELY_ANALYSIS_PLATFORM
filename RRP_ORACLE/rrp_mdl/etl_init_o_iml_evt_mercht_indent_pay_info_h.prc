CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_MERCHT_INDENT_PAY_INFO_H(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_MERCHT_INDENT_PAY_INFO_H
  *  功能描述：商户订单支付信息历史
  *  创建日期：20221210
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_EVT_MERCHT_INDENT_PAY_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221210  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_MERCHT_INDENT_PAY_INFO_H'; -- 程序名称
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
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_MERCHT_INDENT_PAY_INFO_H ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_MERCHT_INDENT_PAY_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-商户订单支付信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_MERCHT_INDENT_PAY_INFO_H
  (  EVT_ID  --事件编号
    ,LP_ID  --法人编号
    ,INTNAL_FLOW_NUM  --内部流水号
    ,TRAN_DT  --交易日期
    ,TRAN_TM  --交易时间
    ,BUS_TYPE_CD  --业务类型代码
    ,BACK_END_CHN_TYPE_CD  --后端渠道类型代码
    ,MERCHT_ID  --商户编号
    ,MERCHT_NAME  --商户名称
    ,CHN_MERCHT_ID  --渠道商户编号
    ,CHN_SUB_MERCHT_ID  --渠道子商户编号
    ,CHN_INDENT_FLOW_NUM  --渠道订单流水号
    ,CHN_INDENT_TRAN_DT  --渠道订单交易日期
    ,PAY_CHN_FEE_RAT  --支付渠道费率
    ,PAY_FLOW_NUM  --支付流水号
    ,OVA_FLOW_NUM  --全局流水号
    ,FEE_RAT_CHN_CD  --费率渠道代码
    ,EXT_INDENT_ID  --外部订单编号
    ,INDENT_CAPTION_NAME  --订单标题名称
    ,INDENT_DESCB  --订单描述
    ,AGENCY_ID  --代理商编号
    ,CURR_CD  --币种代码
    ,TRAN_AMT  --交易金额
    ,INDENT_BAL  --订单余额
    ,INIT_INDENT_FLOW_NUM  --原订单流水号
    ,INIT_INDENT_TRAN_DT  --原订单交易日期
    ,TRAN_STATUS_CD  --交易状态代码
    ,PAY_SUCS_DT  --付款成功日期
    ,PAY_SUCS_TM  --付款成功时间
    ,RESP_CODE  --响应码
    ,RESP_CODE_DESCB  --响应码描述
    ,RTN_GOODS_STATUS_CD  --退货状态代码
    ,ON_ACCT_FLG  --挂账标志
    ,INDENT_VALID_TM  --订单有效时间
    ,PAY_BANK_CARD_ID  --支付银行卡编号
    ,TERMN_TYPE_CD  --终端类型代码
    ,RECV_BILL_BRCH_ID  --收单分行编号
    ,EXT_MERCHT_ID  --外部商户编号
    ,PAY_CHN_CD  --支付渠道代码
    ,BACK_END_CHN_INDENT_ID  --后端渠道订单编号
    ,EPC_G_ROOM_FLG  --网联机房标志
    ,PAY_VOUCH_ID  --付款凭证编号
    ,START_DT  --开始时间
    ,END_DT  --结束时间
    ,ID_MARK  --增删标志
    ,SRC_TABLE_NAME  --源表名称
    ,JOB_CD  --任务编码


    )
    SELECT
 EVT_ID  --事件编号
    ,LP_ID  --法人编号
    ,INTNAL_FLOW_NUM  --内部流水号
    ,TRAN_DT  --交易日期
    ,TRAN_TM  --交易时间
    ,BUS_TYPE_CD  --业务类型代码
    ,BACK_END_CHN_TYPE_CD  --后端渠道类型代码
    ,MERCHT_ID  --商户编号
    ,MERCHT_NAME  --商户名称
    ,CHN_MERCHT_ID  --渠道商户编号
    ,CHN_SUB_MERCHT_ID  --渠道子商户编号
    ,CHN_INDENT_FLOW_NUM  --渠道订单流水号
    ,CHN_INDENT_TRAN_DT  --渠道订单交易日期
    ,PAY_CHN_FEE_RAT  --支付渠道费率
    ,PAY_FLOW_NUM  --支付流水号
    ,OVA_FLOW_NUM  --全局流水号
    ,FEE_RAT_CHN_CD  --费率渠道代码
    ,EXT_INDENT_ID  --外部订单编号
    ,INDENT_CAPTION_NAME  --订单标题名称
    ,INDENT_DESCB  --订单描述
    ,AGENCY_ID  --代理商编号
    ,CURR_CD  --币种代码
    ,TRAN_AMT  --交易金额
    ,INDENT_BAL  --订单余额
    ,INIT_INDENT_FLOW_NUM  --原订单流水号
    ,INIT_INDENT_TRAN_DT  --原订单交易日期
    ,TRAN_STATUS_CD  --交易状态代码
    ,PAY_SUCS_DT  --付款成功日期
    ,PAY_SUCS_TM  --付款成功时间
    ,RESP_CODE  --响应码
    ,RESP_CODE_DESCB  --响应码描述
    ,RTN_GOODS_STATUS_CD  --退货状态代码
    ,ON_ACCT_FLG  --挂账标志
    ,INDENT_VALID_TM  --订单有效时间
    ,PAY_BANK_CARD_ID  --支付银行卡编号
    ,TERMN_TYPE_CD  --终端类型代码
    ,RECV_BILL_BRCH_ID  --收单分行编号
    ,EXT_MERCHT_ID  --外部商户编号
    ,PAY_CHN_CD  --支付渠道代码
    ,BACK_END_CHN_INDENT_ID  --后端渠道订单编号
    ,EPC_G_ROOM_FLG  --网联机房标志
    ,PAY_VOUCH_ID  --付款凭证编号
    ,START_DT  --开始时间
    ,END_DT  --结束时间
    ,ID_MARK  --增删标志
    ,SRC_TABLE_NAME  --源表名称
    ,JOB_CD  --任务编码
    FROM IML.V_EVT_MERCHT_INDENT_PAY_INFO_H  --视图-商户订单支付信息历史
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

  END ETL_INIT_O_IML_EVT_MERCHT_INDENT_PAY_INFO_H;
/

