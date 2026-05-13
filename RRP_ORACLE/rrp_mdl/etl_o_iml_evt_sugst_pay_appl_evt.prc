CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_SUGST_PAY_APPL_EVT(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_SUGST_PAY_APPL_EVT
  *  功能描述：登提示付款申请事件
  *  创建日期：20230113
  *  开发人员：MW
  *  来源表： IML.V_EVT_SUGST_PAY_APPL_EVT
  *  目标表： O_IML_EVT_SUGST_PAY_APPL_EVT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230113  MW     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_SUGST_PAY_APPL_EVT'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_SUGST_PAY_APPL_EVT'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_EVT_SUGST_PAY_APPL_EVT T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_SUGST_PAY_APPL_EVT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-登提示付款申请事件';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_SUGST_PAY_APPL_EVT
    (EVT_ID  --事件编号
    ,LP_ID  --法人编号
    ,APPL_FLOW_NUM  --申请流水号
    ,HQ_ORG_ID  --总行机构编号
    ,ORG_ID  --机构编号
    ,PROD_ID  --产品编号
    ,APPL_TRAN_TYPE_CD  --申请交易类型代码
    ,APPL_DT  --申请日期
    ,BILL_TYPE_CD  --票据类型代码
    ,BILL_MED_CD  --票据介质代码
    ,BILL_ID  --票据编号
    ,FAC_VAL_AMT  --票面金额
    ,DRAW_DT  --出票日期
    ,EXP_DT  --到期日期
    ,SUGST_PAYER_CATE_CD  --提示付款人类别代码
    ,SUGST_PAYER_SOCI_CRDT_CD  --提示付款人社会信用代码
    ,SUGST_PAYER_NAME  --提示付款人名称
    ,SUGST_PAYER_OPEN_BANK_NUM  --提示付款人开户行号
    ,SUGST_PAYER_ORG_CD  --提示付款人机构代码
    ,PAY_BANK_NO  --付款行行号
    ,PAY_BANK_REPLY_CD  --付款行回复代码
    ,PAY_BANK_REFUSE_RS_CD  --付款行拒绝原因代码
    ,PROC_STATUS_CD  --处理状态代码
    ,BILL_STATUS_CD  --票据状态代码
    ,ENTRY_STATUS_CD  --记账状态代码
    ,CLEAR_REST_CD  --清算结果代码
    ,CASH_ORG_ROLE_TYPE_CD  --兑付机构角色类型代码
    ,ERR_CD  --错误码
    ,MODIF_TELLER_ID  --修改柜员编号
    ,FINAL_MODIF_TM  --最后修改时间
    ,FINAL_MODIF_DT  --最后修改日期
    ,ETL_DT  --ETL处理日期
    ,SRC_TABLE_NAME  --源表名称
    ,JOB_CD  --任务编码
    ,ETL_TIMESTAMP  --ETL处理时间戳
    ,RECVER_ACCT_NUM --收款人账号
    )
  SELECT EVT_ID  --事件编号
        ,LP_ID  --法人编号
        ,APPL_FLOW_NUM  --申请流水号
        ,HQ_ORG_ID  --总行机构编号
        ,ORG_ID  --机构编号
        ,PROD_ID  --产品编号
        ,APPL_TRAN_TYPE_CD  --申请交易类型代码
        ,APPL_DT  --申请日期
        ,BILL_TYPE_CD  --票据类型代码
        ,BILL_MED_CD  --票据介质代码
        ,BILL_ID  --票据编号
        ,FAC_VAL_AMT  --票面金额
        ,DRAW_DT  --出票日期
        ,EXP_DT  --到期日期
        ,SUGST_PAYER_CATE_CD  --提示付款人类别代码
        ,SUGST_PAYER_SOCI_CRDT_CD  --提示付款人社会信用代码
        ,SUGST_PAYER_NAME  --提示付款人名称
        ,SUGST_PAYER_OPEN_BANK_NUM  --提示付款人开户行号
        ,SUGST_PAYER_ORG_CD  --提示付款人机构代码
        ,PAY_BANK_NO  --付款行行号
        ,PAY_BANK_REPLY_CD  --付款行回复代码
        ,PAY_BANK_REFUSE_RS_CD  --付款行拒绝原因代码
        ,PROC_STATUS_CD  --处理状态代码
        ,BILL_STATUS_CD  --票据状态代码
        ,ENTRY_STATUS_CD  --记账状态代码
        ,CLEAR_REST_CD  --清算结果代码
        ,CASH_ORG_ROLE_TYPE_CD  --兑付机构角色类型代码
        ,ERR_CD  --错误码
        ,MODIF_TELLER_ID  --修改柜员编号
        ,FINAL_MODIF_TM  --最后修改时间
        ,FINAL_MODIF_DT  --最后修改日期
        ,ETL_DT  --ETL处理日期
        ,SRC_TABLE_NAME  --源表名称
        ,JOB_CD  --任务编码
        ,ETL_TIMESTAMP  --ETL处理时间戳
        ,RECVER_ACCT_NUM --收款人账号
    FROM IML.V_EVT_SUGST_PAY_APPL_EVT  --视图-登提示付款申请事件
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

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

END ETL_O_IML_EVT_SUGST_PAY_APPL_EVT;
/

