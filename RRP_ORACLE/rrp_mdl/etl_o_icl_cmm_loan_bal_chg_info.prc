CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_LOAN_BAL_CHG_INFO(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_LOAN_BAL_CHG_INFO
  *  功能描述：不良问题贷款余额变动信息
  *  创建日期：20250707
  *  开发人员：YJY
  *  来源表： ICL.V_CMM_LOAN_BAL_CHG_INFO
  *  目标表： O_ICL_CMM_LOAN_BAL_CHG_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20250707  YJY     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_ICL_CMM_LOAN_BAL_CHG_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_LOAN_BAL_CHG_INFO'; --程序名称
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
  V_STEP_DESC := '数据落地-不良问题贷款余额变动信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_LOAN_BAL_CHG_INFO
    ( ETL_DT                 --数据日期
     ,LP_ID                  --法人编号
     ,DUBIL_ID               --借据编号
     ,CUST_ID                --客户编号
     ,STD_PROD_ID            --标准产品编号
     ,BUS_LINE_CD            --业务条线代码
     ,DISP_TYPE_CD           --处置类型代码
     ,DISP_WAY_CD            --处置方式代码
     ,TRAN_TYPE_CD           --转让类型代码
     ,BAL_CHAG_DATE          --余额变动日期
     ,BAL_TM_EAR_LVL5_CLS_CD --余额时点年初五级分类代码
     ,BAL_TM_LVL5_CLS_CD     --余额时点五级分类代码
     ,TRAN_DT                --转让日期
     ,WRT_OFF_DT             --核销日期
     ,PROB_LOAN_DT           --问题贷款日期
     ,EAR_Y_PRIC_BAL         --年初本金余额
     ,PRIC_AMT               --本金金额
     ,INT_AMT                --利息金额
     ,PNLT_AMT               --罚息金额
     ,COMP_INT_AMT           --复息金额
     ,FEE_AMT                --费用金额
     ,OPEN_ACCT_ORG_ID       --开户机构编号
     ,MGMT_ORG_ID            --管理机构编号
     ,ACCT_INSTIT_ID         --账务机构编号
     ,JOB_CD                 --任务代码
     ,ETL_TIMESTAMP          --数据处理时间
    )
  SELECT 
      ETL_DT                 --数据日期
     ,LP_ID                  --法人编号
     ,DUBIL_ID               --借据编号
     ,CUST_ID                --客户编号
     ,STD_PROD_ID            --标准产品编号
     ,BUS_LINE_CD            --业务条线代码
     ,DISP_TYPE_CD           --处置类型代码
     ,DISP_WAY_CD            --处置方式代码
     ,TRAN_TYPE_CD           --转让类型代码
     ,BAL_CHAG_DATE          --余额变动日期
     ,BAL_TM_EAR_LVL5_CLS_CD --余额时点年初五级分类代码
     ,BAL_TM_LVL5_CLS_CD     --余额时点五级分类代码
     ,TRAN_DT                --转让日期
     ,WRT_OFF_DT             --核销日期
     ,PROB_LOAN_DT           --问题贷款日期
     ,EAR_Y_PRIC_BAL         --年初本金余额
     ,PRIC_AMT               --本金金额
     ,INT_AMT                --利息金额
     ,PNLT_AMT               --罚息金额
     ,COMP_INT_AMT           --复息金额
     ,FEE_AMT                --费用金额
     ,OPEN_ACCT_ORG_ID       --开户机构编号
     ,MGMT_ORG_ID            --管理机构编号
     ,ACCT_INSTIT_ID         --账务机构编号
     ,JOB_CD                 --任务代码
     ,ETL_TIMESTAMP          --数据处理时间
    FROM ICL.V_CMM_LOAN_BAL_CHG_INFO --视图-不良问题贷款余额变动信息
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

END ETL_O_ICL_CMM_LOAN_BAL_CHG_INFO;
/

