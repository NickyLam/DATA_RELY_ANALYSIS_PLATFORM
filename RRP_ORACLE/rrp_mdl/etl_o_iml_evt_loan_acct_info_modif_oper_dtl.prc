CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL
  *  功能描述：贷款账户信息变更操作明细
  *  创建日期：20251014
  *  开发人员：YJY
  *  来源表： IML.V_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL
  *  目标表： O_IML_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251014  YJY     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                --处理步骤
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);               --任务名称
  V_PART_NAME VARCHAR2(200);               --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-贷款账户信息变更操作明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL
  (   
       EVT_ID                  --事件编号
      ,LP_ID                   --法人编号
      ,BUS_FLOW_NUM            --业务流水号
      ,SEQ_NUM                 --序号
      ,LOAN_NUM                --贷款号
      ,MODIF_BUS_CLS_CD        --变更业务分类代码
      ,MODIF_CONTENT_KEY_VAL   --变更内容关键值
      ,ACCT_MODIF_CATE_CD      --账户变更类别代码
      ,MODIF_ITEM              --修改项
      ,MODIF_DT                --变更日期
      ,MODIF_BF_VAL            --变更前值
      ,MODIF_POST_VAL          --变更后值
      ,TRAN_ORG_ID             --交易机构编号
      ,ACCT_ALDY_CHECK_FLG     --账户已复核标志
      ,CHECK_DT                --复核日期
      ,TRAN_DESCB              --交易描述
      ,PROD_ID                 --产品编号
      ,CURR_CD                 --币种代码
      ,DISTR_FLOW_NUM          --放款流水号
      ,CUST_ID                 --客户编号
      ,TRAN_REF_NO             --交易参考号
      ,MODIF_BATCH_NO          --变更批次号
      ,CHECK_TELLER_ID         --复核柜员编号
      ,TRAN_TELLER_ID          --交易柜员编号
      ,TRAN_TM                 --交易时间
      ,ETL_DT                  --ETL处理日期
      ,SRC_TABLE_NAME          --源表名称
      ,JOB_CD                  --任务编码
      ,ETL_TIMESTAMP          --ETL处理时间戳
   )
  SELECT 
       EVT_ID                  --事件编号
      ,LP_ID                   --法人编号
      ,BUS_FLOW_NUM            --业务流水号
      ,SEQ_NUM                 --序号
      ,LOAN_NUM                --贷款号
      ,MODIF_BUS_CLS_CD        --变更业务分类代码
      ,MODIF_CONTENT_KEY_VAL   --变更内容关键值
      ,ACCT_MODIF_CATE_CD      --账户变更类别代码
      ,MODIF_ITEM              --修改项
      ,MODIF_DT                --变更日期
      ,MODIF_BF_VAL            --变更前值
      ,MODIF_POST_VAL          --变更后值
      ,TRAN_ORG_ID             --交易机构编号
      ,ACCT_ALDY_CHECK_FLG     --账户已复核标志
      ,CHECK_DT                --复核日期
      ,TRAN_DESCB              --交易描述
      ,PROD_ID                 --产品编号
      ,CURR_CD                 --币种代码
      ,DISTR_FLOW_NUM          --放款流水号
      ,CUST_ID                 --客户编号
      ,TRAN_REF_NO             --交易参考号
      ,MODIF_BATCH_NO          --变更批次号
      ,CHECK_TELLER_ID         --复核柜员编号
      ,TRAN_TELLER_ID          --交易柜员编号
      ,TRAN_TM                 --交易时间
      ,ETL_DT                  --ETL处理日期
      ,SRC_TABLE_NAME          --源表名称
      ,JOB_CD                  --任务编码
      ,ETL_TIMESTAMP          --ETL处理时间戳
    FROM IML.V_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL --视图-贷款账户信息变更操作明细
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_EVT_LOAN_ACCT_INFO_MODIF_OPER_DTL;
/

