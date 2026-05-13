CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_PAYFAN_INDENT_INFO_H(I_P_DATE IN INTEGER, --跑批日期
                                                               O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_PAYFAN_INDENT_INFO_H
  *  功能描述：代付订单信息历史
  *  创建日期：20240506
  *  开发人员：YUJINGYI
  *  来源表：
  *  目标表： O_IML_AGT_PAYFAN_INDENT_INFO_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240506  YJY     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_PAYFAN_INDENT_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_PAYFAN_INDENT_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-代付订单信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_PAYFAN_INDENT_INFO_H
    (AGT_ID                     --协议编号
    ,LP_ID                      --法人编号
    ,TRAN_FLOW_NUM              --交易流水号
    ,TRAN_DT                    --交易日期
    ,PAYFAN_CHN_ID              --代付渠道编号
    ,TRAN_CODE                  --交易码
    ,CURR_CD                    --币种代码
    ,TRAN_TYPE_CD               --交易类型代码
    ,TRAN_STATUS_CD             --交易状态代码
    ,TRAN_AMT                   --交易金额
    ,BATCH_NO                   --批次号
    ,BATCH_RGST_STATUS_CD       --批次登记状态代码
    ,TOT                        --总笔数
    ,SUCS_TRAN_AMT              --成功交易金额
    ,SUCS_TRAN_CNT              --成功交易笔数
    ,FAIL_TRAN_AMT              --失败交易金额
    ,FAIL_TRAN_CNT              --失败交易笔数
    ,CHN_ORDER_NO               --渠道订单号
    ,RESP_CODE                  --响应码
    ,RESP_CODE_DESCB            --响应码描述
    ,MERCHT_ID                  --商户编号
    ,PAY_ACCT_TYPE_CD           --支付账户类型代码
    ,PAY_ACCT_ID                --支付账户编号
    ,PAY_ACCT_NAME              --支付账户名称
    ,INTNAL_ACCT_ID             --内部账户编号
    ,INTNAL_ACCT_NAME           --内部账户名称
    ,RECVBL_ACCT_ID             --收款账户编号
    ,RECVBL_ACCT_NAME           --收款账户名称
    ,RECVBL_ACCT_TYPE_CD        --收款账户类型代码
    ,RECVBL_BANK_IBANK_NO       --收款银行联行号
    ,RECVBL_BANK_NAME           --收款银行名称
    ,CERT_TYPE_CD               --证件类型代码
    ,CERT_NO                    --证件号码
    ,MOBILE_NO                  --手机号码
    ,POSTSC                     --附言
    ,OVA_FLOW_NUM               --全局流水号
    ,CORE_FLOW_NUM              --核心流水号
    ,UNIONPAY_MERCHT_ORDER_NO   --银联商户订单号
    ,UNIONPAY_TRAN_FLOW_NUM     --银联交易流水号
    ,UNIONPAY_TRAN_DT           --银联交易日期
    ,AGT_CORP_TYPE_CD           --协议单位类型代码
    ,AGENCY_ID                  --代理商编号
    ,AGT_CORP_ID                --协议单位编号
    ,AGT_CORP_NAME              --协议单位名称
    ,API_SYS_IDF                --API系统标识
    ,TELLER_ID                  --柜员编号
    ,START_DT                   --开始日期
    ,END_DT                     --结束日期
    ,ID_MARK                    --删除标识
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务代码
    ,ETL_TIMESTAMP              --数据处理时间
    )
  SELECT /*+PARALLEL*/
         AGT_ID                     --协议编号
        ,LP_ID                      --法人编号
        ,TRAN_FLOW_NUM              --交易流水号
        ,TRAN_DT                    --交易日期
        ,PAYFAN_CHN_ID              --代付渠道编号
        ,TRAN_CODE                  --交易码
        ,CURR_CD                    --币种代码
        ,TRAN_TYPE_CD               --交易类型代码
        ,TRAN_STATUS_CD             --交易状态代码
        ,TRAN_AMT                   --交易金额
        ,BATCH_NO                   --批次号
        ,BATCH_RGST_STATUS_CD       --批次登记状态代码
        ,TOT                        --总笔数
        ,SUCS_TRAN_AMT              --成功交易金额
        ,SUCS_TRAN_CNT              --成功交易笔数
        ,FAIL_TRAN_AMT              --失败交易金额
        ,FAIL_TRAN_CNT              --失败交易笔数
        ,CHN_ORDER_NO               --渠道订单号
        ,RESP_CODE                  --响应码
        ,RESP_CODE_DESCB            --响应码描述
        ,MERCHT_ID                  --商户编号
        ,PAY_ACCT_TYPE_CD           --支付账户类型代码
        ,PAY_ACCT_ID                --支付账户编号
        ,PAY_ACCT_NAME              --支付账户名称
        ,INTNAL_ACCT_ID             --内部账户编号
        ,INTNAL_ACCT_NAME           --内部账户名称
        ,RECVBL_ACCT_ID             --收款账户编号
        ,RECVBL_ACCT_NAME           --收款账户名称
        ,RECVBL_ACCT_TYPE_CD        --收款账户类型代码
        ,RECVBL_BANK_IBANK_NO       --收款银行联行号
        ,RECVBL_BANK_NAME           --收款银行名称
        ,CERT_TYPE_CD               --证件类型代码
        ,CERT_NO                    --证件号码
        ,MOBILE_NO                  --手机号码
        ,POSTSC                     --附言
        ,OVA_FLOW_NUM               --全局流水号
        ,CORE_FLOW_NUM              --核心流水号
        ,UNIONPAY_MERCHT_ORDER_NO   --银联商户订单号
        ,UNIONPAY_TRAN_FLOW_NUM     --银联交易流水号
        ,UNIONPAY_TRAN_DT           --银联交易日期
        ,AGT_CORP_TYPE_CD           --协议单位类型代码
        ,AGENCY_ID                  --代理商编号
        ,AGT_CORP_ID                --协议单位编号
        ,AGT_CORP_NAME              --协议单位名称
        ,API_SYS_IDF                --API系统标识
        ,TELLER_ID                  --柜员编号
        ,START_DT                   --开始日期
        ,END_DT                     --结束日期
        ,ID_MARK                    --删除标识
        ,SRC_TABLE_NAME             --源表名称
        ,JOB_CD                     --任务代码
        ,ETL_TIMESTAMP              --数据处理时间
    FROM IML.V_AGT_PAYFAN_INDENT_INFO_H   --代付订单信息历史--视图
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_PAYFAN_INDENT_INFO_H','', O_ERRCODE);

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

END ETL_O_IML_AGT_PAYFAN_INDENT_INFO_H;
/

