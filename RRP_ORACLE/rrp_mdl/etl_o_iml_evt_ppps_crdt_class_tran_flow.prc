CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_PPPS_CRDT_CLASS_TRAN_FLOW(I_P_DATE IN INTEGER,
                                                                    O_ERRCODE OUT VARCHAR2
                                                                    )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_PPPS_CRDT_CLASS_TRAN_FLOW
  *  功能描述：PPPS贷记类交易流水
  *  创建日期：20240805
  *  开发人员：YUJINGYI
  *  来源表： IML.V_EVT_PPPS_CRDT_CLASS_TRAN_FLOW
  *  目标表： O_IML_EVT_PPPS_CRDT_CLASS_TRAN_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240805  YUJINGYI  首次创建
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
  V_PART_NAME VARCHAR2(200);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'O_IML_EVT_PPPS_CRDT_CLASS_TRAN_FLOW'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_PPPS_CRDT_CLASS_TRAN_FLOW'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE; --分区名

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-PPPS贷记类交易流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_PPPS_CRDT_CLASS_TRAN_FLOW
    (EVT_ID                                   --事件编号
    ,LP_ID                                    --法人编号
    ,TRAN_FLOW_NUM                            --交易流水号
    ,TRAN_DT                                  --交易日期
    ,OVA_FLOW_NUM                             --全局流水号
    ,TRAN_CATE_CD                             --交易类别代码
    ,BUS_TYPE_CD                              --业务类型代码
    ,BUS_STATUS_CD                            --业务状态代码
    ,NOSTRO_CD                                --往来账代码
    ,CHN_ID                                   --渠道编号
    ,MERCHT_TRAN_FLOW_NUM                     --商户交易流水号
    ,MERCHT_TRAN_DT                           --商户交易日期
    ,TRAN_AMT                                 --交易金额
    ,TRAN_CURR_CD                             --交易币种代码
    ,TRAN_AGING_TYPE_CD                       --交易时效类型代码
    ,TRAN_PROC_STATUS_CD                      --交易处理状态代码
    ,TRAN_BATCH_NO                            --交易批次号
    ,TRAN_ORG_ID                              --交易机构编号
    ,TRAN_TELLER_ID                           --交易柜员编号
    ,REALTM_CLEAR_FLG                         --实时清算标志
    ,CLEAR_DT                                 --清算日期
    ,SIGN_AGT_ID                              --签约协议编号
    ,TRAN_POSTSC                              --交易附言
    ,RECVBL_CERT_TYPE_CD                      --收款证件类型代码
    ,RECVBL_ACCT_ID                           --收款账户编号
    ,RECVBL_ACCT_NAME                         --收款账户名称
    ,RECVBL_ACCT_CATE_CD                      --收款账户类别代码
    ,RECVBL_ACCT_BELONG_SYS_CD                --收款账户归属系统代码
    ,RECVBL_MOBILE_NO                         --收款手机号码
    ,RECVBL_CLEAR_BK_NO                       --收款清算行行号
    ,RECVBL_CLEAR_BK_NAME                     --收款清算行名称
    ,PAY_CERT_TYPE_CD                         --付款证件类型代码
    ,PAY_ACCT_ID                              --付款账户编号
    ,PAY_ACCT_NAME                            --付款账户名称
    ,PAY_ACCT_CATE_CD                         --付款账户类别代码
    ,PAY_ACCT_BELONG_SYS_CD                   --付款账户归属系统代码
    ,PAY_BANK_CLEAR_BK_NUM                    --付款行清算行号
    ,PAY_CLEAR_BK_NAME                        --付款清算行名称
    ,ACTL_PAY_ACCT_ID                         --实际付款账户编号
    ,ACTL_PAY_NAME                            --实际付款名称
    ,ACTL_PAY_ACCT_CATE_CD                    --实际付款账户类别代码
    ,ACTL_PAY_ACCT_BELONG_SYS_CD              --实际付款账户归属系统代码
    ,ACM_LMT_TYPE_CD                          --累计限额类型代码
    ,CORE_TRAN_FLOW_NUM                       --核心交易流水号
    ,CORE_ACCT_STATUS_CD                      --核心账务状态代码
    ,CORE_DT                                  --核心日期
    ,CALL_PASS_FLOW_NUM                       --调用通道流水号
    ,PASS_SYS_ABBR                            --通道系统简称
    ,PASS_TRAN_FLOW_NUM                       --通道交易流水号
    ,PASS_INIT_STATUS_CD                      --通道原始状态代码
    ,PASS_RESP_FLOW_NUM                       --通道响应流水号
    ,PASS_RESP_DT                             --通道响应日期
    ,PASS_RESP_STATUS_CD                      --通道响应状态代码
    ,PASS_TRAN_DT                             --通道交易日期
    ,PASS_COST_FEE                            --通道成本费
    ,CHECK_ENTRY_DT                           --对账日期
    ,CHECK_ENTRY_PROC_IDF                     --对账处理标识
    ,CHECK_ENTRY_IDF_TYPE_CD                  --对账标识类型代码
    ,CHECK_ENTRY_REST_DESCB                   --对账结果描述
    ,CHECK_ENTRY_PROC_DT                      --对账处理日期
    ,CHN_CHECK_ENTRY_CODE                     --渠道对账编码
    ,CHN_CHECK_ENTRY_DT                       --渠道对账日期
    ,CHN_CHECK_ENTRY_MODE_CD                  --渠道对账模式代码
    ,PASS_CHECK_ENTRY_PROC_DESCB              --通道对账处理描述
    ,CROSS_BANK_FLG                           --跨行标志
    ,COLL_COMM_FEE_FLG                        --收取手续费标志
    ,COMM_FEE_AMT                             --手续费金额
    ,NEED_DELAY_TRAN_ACCT_FLG                 --需要延时转账标志
    ,DELAY_TM                                 --延长时间
    ,CHECK_TELLER_ID                          --复核柜员编号
    ,CALL_SYS_ID                              --调用系统编号
    ,SORC_SYS_ID                              --源系统编号
    ,ADV_EXP_FLG                              --垫支标志
    ,BELONG_SYS_ID                            --归属系统编号
    ,FIR_CREATE_DT                            --首次创建日期
    ,FINAL_UPDATE_DT                          --最后更新日期
    ,REMARK                                   --备注
    ,ETL_DT                                   --ETL处理日期
    ,SRC_TABLE_NAME                           --源表名称
    ,JOB_CD                                   --任务编码
    ,ETL_TIMESTAMP                            --ETL处理时间戳
    )
  SELECT EVT_ID                                   --事件编号
        ,LP_ID                                    --法人编号
        ,TRAN_FLOW_NUM                            --交易流水号
        ,TRAN_DT                                  --交易日期
        ,OVA_FLOW_NUM                             --全局流水号
        ,TRAN_CATE_CD                             --交易类别代码
        ,BUS_TYPE_CD                              --业务类型代码
        ,BUS_STATUS_CD                            --业务状态代码
        ,NOSTRO_CD                                --往来账代码
        ,CHN_ID                                   --渠道编号
        ,MERCHT_TRAN_FLOW_NUM                     --商户交易流水号
        ,MERCHT_TRAN_DT                           --商户交易日期
        ,TRAN_AMT                                 --交易金额
        ,TRAN_CURR_CD                             --交易币种代码
        ,TRAN_AGING_TYPE_CD                       --交易时效类型代码
        ,TRAN_PROC_STATUS_CD                      --交易处理状态代码
        ,TRAN_BATCH_NO                            --交易批次号
        ,TRAN_ORG_ID                              --交易机构编号
        ,TRAN_TELLER_ID                           --交易柜员编号
        ,REALTM_CLEAR_FLG                         --实时清算标志
        ,CLEAR_DT                                 --清算日期
        ,SIGN_AGT_ID                              --签约协议编号
        ,TRAN_POSTSC                              --交易附言
        ,RECVBL_CERT_TYPE_CD                      --收款证件类型代码
        ,RECVBL_ACCT_ID                           --收款账户编号
        ,RECVBL_ACCT_NAME                         --收款账户名称
        ,RECVBL_ACCT_CATE_CD                      --收款账户类别代码
        ,RECVBL_ACCT_BELONG_SYS_CD                --收款账户归属系统代码
        ,RECVBL_MOBILE_NO                         --收款手机号码
        ,RECVBL_CLEAR_BK_NO                       --收款清算行行号
        ,RECVBL_CLEAR_BK_NAME                     --收款清算行名称
        ,PAY_CERT_TYPE_CD                         --付款证件类型代码
        ,PAY_ACCT_ID                              --付款账户编号
        ,PAY_ACCT_NAME                            --付款账户名称
        ,PAY_ACCT_CATE_CD                         --付款账户类别代码
        ,PAY_ACCT_BELONG_SYS_CD                   --付款账户归属系统代码
        ,PAY_BANK_CLEAR_BK_NUM                    --付款行清算行号
        ,PAY_CLEAR_BK_NAME                        --付款清算行名称
        ,ACTL_PAY_ACCT_ID                         --实际付款账户编号
        ,ACTL_PAY_NAME                            --实际付款名称
        ,ACTL_PAY_ACCT_CATE_CD                    --实际付款账户类别代码
        ,ACTL_PAY_ACCT_BELONG_SYS_CD              --实际付款账户归属系统代码
        ,ACM_LMT_TYPE_CD                          --累计限额类型代码
        ,CORE_TRAN_FLOW_NUM                       --核心交易流水号
        ,CORE_ACCT_STATUS_CD                      --核心账务状态代码
        ,CORE_DT                                  --核心日期
        ,CALL_PASS_FLOW_NUM                       --调用通道流水号
        ,PASS_SYS_ABBR                            --通道系统简称
        ,PASS_TRAN_FLOW_NUM                       --通道交易流水号
        ,PASS_INIT_STATUS_CD                      --通道原始状态代码
        ,PASS_RESP_FLOW_NUM                       --通道响应流水号
        ,PASS_RESP_DT                             --通道响应日期
        ,PASS_RESP_STATUS_CD                      --通道响应状态代码
        ,PASS_TRAN_DT                             --通道交易日期
        ,PASS_COST_FEE                            --通道成本费
        ,CHECK_ENTRY_DT                           --对账日期
        ,CHECK_ENTRY_PROC_IDF                     --对账处理标识
        ,CHECK_ENTRY_IDF_TYPE_CD                  --对账标识类型代码
        ,CHECK_ENTRY_REST_DESCB                   --对账结果描述
        ,CHECK_ENTRY_PROC_DT                      --对账处理日期
        ,CHN_CHECK_ENTRY_CODE                     --渠道对账编码
        ,CHN_CHECK_ENTRY_DT                       --渠道对账日期
        ,CHN_CHECK_ENTRY_MODE_CD                  --渠道对账模式代码
        ,PASS_CHECK_ENTRY_PROC_DESCB              --通道对账处理描述
        ,CROSS_BANK_FLG                           --跨行标志
        ,COLL_COMM_FEE_FLG                        --收取手续费标志
        ,COMM_FEE_AMT                             --手续费金额
        ,NEED_DELAY_TRAN_ACCT_FLG                 --需要延时转账标志
        ,DELAY_TM                                 --延长时间
        ,CHECK_TELLER_ID                          --复核柜员编号
        ,CALL_SYS_ID                              --调用系统编号
        ,SORC_SYS_ID                              --源系统编号
        ,ADV_EXP_FLG                              --垫支标志
        ,BELONG_SYS_ID                            --归属系统编号
        ,FIR_CREATE_DT                            --首次创建日期
        ,FINAL_UPDATE_DT                          --最后更新日期
        ,REMARK                                   --备注
        ,ETL_DT                                   --ETL处理日期
        ,SRC_TABLE_NAME                           --源表名称
        ,JOB_CD                                   --任务编码
        ,ETL_TIMESTAMP                            --ETL处理时间戳
    FROM IML.V_EVT_PPPS_CRDT_CLASS_TRAN_FLOW  --视图-PPPS贷记类交易流水
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
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

END ETL_O_IML_EVT_PPPS_CRDT_CLASS_TRAN_FLOW;
/

