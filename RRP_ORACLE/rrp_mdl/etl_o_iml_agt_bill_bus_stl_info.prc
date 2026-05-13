CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_BILL_BUS_STL_INFO(I_P_DATE IN INTEGER,
                                                            O_ERRCODE OUT VARCHAR2
                                                            )
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_BILL_BUS_STL_INFO
  *  功能描述：票据业务结算信息
  *  创建日期：20230829
  *  开发人员：HULIJUAN
  *  来源表： IML.V_AGT_BILL_BUS_STL_INFO
  *  目标表： O_IML_AGT_BILL_BUS_STL_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *            1   20230829  HULIJUAN 首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_BILL_BUS_STL_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_BILL_BUS_STL_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-票据业务结算信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_BILL_BUS_STL_INFO
    (BUS_STL_ID               --业务结算编号
    ,LP_ID                    --法人编号
    ,MEM_ORG_CD               --会员机构代码
    ,STL_REQ_ID               --结算请求编号
    ,STL_TM                   --结算时间
    ,BUS_TYPE_CD              --业务类型代码
    ,STL_WAY_CD               --结算方式代码
    ,STL_BUS_TYPE_CD          --结算业务类型代码
    ,CLEAR_TYPE_CD            --清算类型代码
    ,BAG_DIR_CD               --成交方向代码
    ,STL_AMT                  --结算金额
    ,INT_PAYBL                --应付利息
    ,BILL_CNT                 --票据张数
    ,CTR_NT_ID                --成交单编号
    ,LG_PAY_SYS_MSG_IND_NO    --大额支付系统报文标识号
    ,BILL_NUM                 --票据号码
    ,RECVER_ORG_CD            --收款方机构代码
    ,RECVER_TRUST_ACCT_NUM    --收款方托管账号
    ,RECVER_TRUST_ACCT_NAME   --收款方托管账户名称
    ,RECVER_CAP_ACCT_NUM      --收款方资金账号
    ,RECVER_CAP_ACCT_NAME     --收款方资金账户名称
    ,PAYER_ORG_CD             --付款方机构代码
    ,PAYER_TRUST_ACCT_NUM     --付款方托管账号
    ,PAYER_TRUST_ACCT_NAME    --付款方托管账户名称
    ,PAYER_CAP_ACCT_NUM       --付款方资金账号
    ,PAYER_CAP_ACCT_NAME      --付款方资金账户名称
    ,STL_STATUS_CD            --结算状态代码
    ,STL_REST_CODE            --结算结果编码
    ,STL_FAIL_RS              --结算失败原因
    ,BILL_SUB_INTRV_ID        --票据子区间编号
    ,START_DT                 --开始时间
    ,END_DT                   --结束时间
    ,ID_MARK                  --增删标志
    ,SRC_TABLE_NAME           --源表名称
    ,JOB_CD                   --任务编码
    ,ETL_TIMESTAMP            --ETL处理时间戳
    )
  SELECT BUS_STL_ID               --业务结算编号
        ,LP_ID                    --法人编号
        ,MEM_ORG_CD               --会员机构代码
        ,STL_REQ_ID               --结算请求编号
        ,STL_TM                   --结算时间
        ,BUS_TYPE_CD              --业务类型代码
        ,STL_WAY_CD               --结算方式代码
        ,STL_BUS_TYPE_CD          --结算业务类型代码
        ,CLEAR_TYPE_CD            --清算类型代码
        ,BAG_DIR_CD               --成交方向代码
        ,STL_AMT                  --结算金额
        ,INT_PAYBL                --应付利息
        ,BILL_CNT                 --票据张数
        ,CTR_NT_ID                --成交单编号
        ,LG_PAY_SYS_MSG_IND_NO    --大额支付系统报文标识号
        ,BILL_NUM                 --票据号码
        ,RECVER_ORG_CD            --收款方机构代码
        ,RECVER_TRUST_ACCT_NUM    --收款方托管账号
        ,RECVER_TRUST_ACCT_NAME   --收款方托管账户名称
        ,RECVER_CAP_ACCT_NUM      --收款方资金账号
        ,RECVER_CAP_ACCT_NAME     --收款方资金账户名称
        ,PAYER_ORG_CD             --付款方机构代码
        ,PAYER_TRUST_ACCT_NUM     --付款方托管账号
        ,PAYER_TRUST_ACCT_NAME    --付款方托管账户名称
        ,PAYER_CAP_ACCT_NUM       --付款方资金账号
        ,PAYER_CAP_ACCT_NAME      --付款方资金账户名称
        ,STL_STATUS_CD            --结算状态代码
        ,STL_REST_CODE            --结算结果编码
        ,STL_FAIL_RS              --结算失败原因
        ,BILL_SUB_INTRV_ID        --票据子区间编号
        ,START_DT                 --开始时间
        ,END_DT                   --结束时间
        ,ID_MARK                  --增删标志
        ,SRC_TABLE_NAME           --源表名称
        ,JOB_CD                   --任务编码
        ,ETL_TIMESTAMP            --ETL处理时间戳
    FROM IML.V_AGT_BILL_BUS_STL_INFO  --视图-票据业务结算信息
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_BILL_BUS_STL_INFO', '', O_ERRCODE);

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

END ETL_O_IML_AGT_BILL_BUS_STL_INFO;
/

