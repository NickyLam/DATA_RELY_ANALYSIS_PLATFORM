CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_WEB_MALL_INDENT_INFO_H(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                 )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_WEB_MALL_INDENT_INFO_H
  *  功能描述：网上商城订单信息历史
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_EVT_WEB_MALL_INDENT_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250610  YJY      剔除删除数据
  *             3    20251020  YJY      作业下线
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_EVT_WEB_MALL_INDENT_INFO_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_WEB_MALL_INDENT_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  
  /*  --MOD BY YJY 20251020
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_WEB_MALL_INDENT_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-网上商城订单信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_WEB_MALL_INDENT_INFO_H
  (  EVT_ID                  --事件编号
    ,LP_ID                   --法人编号
    ,INDENT_FLOW_NUM         --订单流水号
    ,TRAN_FLOW_NUM           --交易流水号
    ,INIT_INDENT_FLOW_NUM    --原订单流水号
    ,INIT_INDENT_TRAN_DT     --原订单交易日期
    ,TRAN_DT                 --交易日期
    ,TRAN_TM                 --交易时间
    ,TRAN_CODE               --交易码
    ,TRAN_STATUS_CD          --交易状态代码
    ,PAY_SUCS_DT             --付款成功日期
    ,PAY_SUCS_TM             --付款成功时间
    ,RESP_CODE               --响应码
    ,RESP_CODE_DESCB         --响应码描述
    ,PAY_CARD_NUM            --支付卡号
    ,CARD_NAME               --卡名称
    ,IBANK_NO                --银行联行号
    ,BANK_NAME               --银行名称
    ,CARD_TYPE_CD            --卡类型代码
    ,RECV_BILL_BRCH_ID       --收单分行编号
    ,CALLER_OVA_FLOW_NUM     --调用方全局流水号
    ,CALLER_ONL_OVA_FLOW_NUM --调用方联机全局流水号
    ,DISPATCH_STATUS_CD      --发货状态代码
    ,PICK_GOODS_WAY_CD       --提货方式代码
    ,MERCHT_NO               --商户号
    ,RECVER_NAME             --收货人名称
    ,RECVER_MOBILE_NO        --收货人手机号码
    ,RECVER_LOCAL_PROV       --收货人所在省
    ,RECVER_LOCAL_CITY       --收货人所在市
    ,RECVER_LOCAL_RG_COUNTY  --收货人所在区县
    ,RECVER_LOCAL_TOWN       --收货人所在镇
    ,RECVER_DTL_ADDR         --收货人详细地址
    ,INDENT_TOT_AMT          --订单总金额
    ,INDENT_POINT_TYPE_CD    --订单积分类型代码
    ,INDENT_TOT_POINT        --订单总积分
    ,FREGT_AMT               --运费金额
    ,CUST_ID                 --交易客户编号
    ,CUST_NAME               --客户名称
    ,CUST_OPEN_ACCT_ORG_ID   --客户开户机构编号
    ,BANK_CUST_MGR_ID        --银行客户经理编号
    ,TOT_COMM_FEE_INCO       --总手续费收入
    ,AGENCY_ID               --代理商编号
    ,PAY_CARD_OPEN_ORG_ID    --支付卡开户机构编号
    ,TRAN_ORG_ID             --交易机构编号
    ,SURP_AVAL_AMT           --剩余可用金额
    ,SURP_AVAL_POINT         --剩余可用积分
    ,POINT_MALL_ORDER_NO     --积分商城订单号
    ,MERCHD_TYPE_CD          --商品类型代码
    ,START_DT                --开始日期
    ,END_DT                  --结束日期
    ,ID_MARK                 --删除标识
    ,JOB_CD                  --任务代码
    )
  SELECT  
     EVT_ID                  --事件编号
    ,LP_ID                   --法人编号
    ,INDENT_FLOW_NUM         --订单流水号
    ,TRAN_FLOW_NUM           --交易流水号
    ,INIT_INDENT_FLOW_NUM    --原订单流水号
    ,INIT_INDENT_TRAN_DT     --原订单交易日期
    ,TRAN_DT                 --交易日期
    ,TRAN_TM                 --交易时间
    ,TRAN_CODE               --交易码
    ,TRAN_STATUS_CD          --交易状态代码
    ,PAY_SUCS_DT             --付款成功日期
    ,PAY_SUCS_TM             --付款成功时间
    ,RESP_CODE               --响应码
    ,RESP_CODE_DESCB         --响应码描述
    ,PAY_CARD_NUM            --支付卡号
    ,CARD_NAME               --卡名称
    ,IBANK_NO                --银行联行号
    ,BANK_NAME               --银行名称
    ,CARD_TYPE_CD            --卡类型代码
    ,RECV_BILL_BRCH_ID       --收单分行编号
    ,CALLER_OVA_FLOW_NUM     --调用方全局流水号
    ,CALLER_ONL_OVA_FLOW_NUM --调用方联机全局流水号
    ,DISPATCH_STATUS_CD      --发货状态代码
    ,PICK_GOODS_WAY_CD       --提货方式代码
    ,MERCHT_NO               --商户号
    ,RECVER_NAME             --收货人名称
    ,RECVER_MOBILE_NO        --收货人手机号码
    ,RECVER_LOCAL_PROV       --收货人所在省
    ,RECVER_LOCAL_CITY       --收货人所在市
    ,RECVER_LOCAL_RG_COUNTY  --收货人所在区县
    ,RECVER_LOCAL_TOWN       --收货人所在镇
    ,RECVER_DTL_ADDR         --收货人详细地址
    ,INDENT_TOT_AMT          --订单总金额
    ,INDENT_POINT_TYPE_CD    --订单积分类型代码
    ,INDENT_TOT_POINT        --订单总积分
    ,FREGT_AMT               --运费金额
    ,CUST_ID                 --交易客户编号
    ,CUST_NAME               --客户名称
    ,CUST_OPEN_ACCT_ORG_ID   --客户开户机构编号
    ,BANK_CUST_MGR_ID        --银行客户经理编号
    ,TOT_COMM_FEE_INCO       --总手续费收入
    ,AGENCY_ID               --代理商编号
    ,PAY_CARD_OPEN_ORG_ID    --支付卡开户机构编号
    ,TRAN_ORG_ID             --交易机构编号
    ,SURP_AVAL_AMT           --剩余可用金额
    ,SURP_AVAL_POINT         --剩余可用积分
    ,POINT_MALL_ORDER_NO     --积分商城订单号
    ,MERCHD_TYPE_CD          --商品类型代码
    ,START_DT                --开始日期
    ,END_DT                  --结束日期
    ,ID_MARK                 --删除标识
    ,JOB_CD                  --任务代码
   FROM IML.V_EVT_WEB_MALL_INDENT_INFO_H  --视图-网上商城订单信息历史
   WHERE ID_MARK <> 'D'; --MOD BY YJY 20250610

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  */
  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_EVT_WEB_MALL_INDENT_INFO_H;
/

