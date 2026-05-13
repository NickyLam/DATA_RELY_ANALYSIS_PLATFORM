CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CRSS_PAYMENT_INFO(I_P_DATE IN INTEGER,
                                                        O_ERRCODE OUT VARCHAR2
                                                        )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CRSS_PAYMENT_INFO
  *  功能描述：支付清单表
  *  创建日期：20220325
  *  开发人员：陈宜玲
  *  来源表： IOL.V_CRSS_PAYMENT_INFO
  *  目标表： O_IOL_CRSS_PAYMENT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220325  陈宜玲 首次创建
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_CRSS_PAYMENT_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CRSS_PAYMENT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_CRSS_PAYMENT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-支付清单表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CRSS_PAYMENT_INFO NOLOGGING
    (SERIALNO
    ,PUTOUTSERIALNO
    ,CUSTOMERID
    ,CUSTOMERNAME
    ,PAYMENTMODE
    ,PAYMENTDATE
    ,PAIDDATE
    ,PAYEENAME
    ,PAYEEBANK
    ,PAYEEACCOUNT
    ,CURRENCY
    ,PAYMENTSUM
    ,PAYMENTSTATUS
    ,DOCID
    ,CAPITALUSE
    ,REMARK
    ,INPUTUSERID
    ,INPUTORGID
    ,INPUTDATE
    ,UPDATEUSERID
    ,UPDATEDATE
    ,PIGEONHOLEDATE
    ,OBJECTNO                --受托支付编号
    ,ENTRUSTEDPAYID          --受托支付序号
    ,ISINUSE                 --添加维护标志1正常2不维护
    ,ZFSERIALNO              --止付流水号
    ,ZFDATE                  --止付交易日期
    ,ZFJYSERIALNO            --在线受托支付-止付交易流水号
    ,CAUSE                   --支付失败原因
    ,BATCHNO                 --受托支付批次号
    ,PAYEEBANKNO             --开户行号
    ,TRXSEQ                  --平台交易流水号
    ,TRXDATE                 --平台交易日期
    ,PAY_STATUS              --在线受托支付-支付状态码值 BILLPAYSTATUS
    ,PLATTRXSEQ
    ,PAYMENTTIME             --支付时间
    ,TRANSEQNO               --平台请求流水号
    ,TXNNO                   --平台交易流水号
    ,FREEZESEQNO             --冻结流水号
    ,ISKJ                    --是否跨境
    ,ROWNO                   --明细流水号
    ,START_DT                --开始时间
    ,END_DT                  --结束时间
    ,ID_MARK                 --增删标志
    )
  SELECT /*+PARALLEL*/
         SERIALNO
        ,PUTOUTSERIALNO
        ,CUSTOMERID
        ,CUSTOMERNAME
        ,PAYMENTMODE
        ,PAYMENTDATE
        ,PAIDDATE
        ,PAYEENAME
        ,PAYEEBANK
        ,PAYEEACCOUNT
        ,CURRENCY
        ,PAYMENTSUM
        ,PAYMENTSTATUS
        ,DOCID
        ,CAPITALUSE
        ,REMARK
        ,INPUTUSERID
        ,INPUTORGID
        ,INPUTDATE
        ,UPDATEUSERID
        ,UPDATEDATE
        ,PIGEONHOLEDATE
        ,OBJECTNO                --受托支付编号
        ,ENTRUSTEDPAYID          --受托支付序号
        ,ISINUSE                 --添加维护标志1正常2不维护
        ,ZFSERIALNO              --止付流水号
        ,ZFDATE                  --止付交易日期
        ,ZFJYSERIALNO            --在线受托支付-止付交易流水号
        ,CAUSE                   --支付失败原因
        ,BATCHNO                 --受托支付批次号
        ,PAYEEBANKNO             --开户行号
        ,TRXSEQ                  --平台交易流水号
        ,TRXDATE                 --平台交易日期
        ,PAY_STATUS              --在线受托支付-支付状态码值 BILLPAYSTATUS
        ,PLATTRXSEQ
        ,PAYMENTTIME             --支付时间
        ,TRANSEQNO               --平台请求流水号
        ,TXNNO                   --平台交易流水号
        ,FREEZESEQNO             --冻结流水号
        ,ISKJ                    --是否跨境
        ,ROWNO                   --明细流水号
        ,START_DT                --开始时间
        ,END_DT                  --结束时间
        ,ID_MARK                 --增删标志
    FROM IOL.V_CRSS_PAYMENT_INFO  --支付清单表_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

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

END ETL_O_IOL_CRSS_PAYMENT_INFO;
/

