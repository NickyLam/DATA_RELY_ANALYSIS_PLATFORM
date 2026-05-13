CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B
  *  功能描述：存款账户重要事件登记簿
  *  创建日期：20251126
  *  开发人员：YJY
  *  来源表： IML.V_EVT_DEP_ACCT_IMP_EVT_RGST_B
  *  目标表： O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251126  YJY     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B'; --程序名称
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
  V_STEP_DESC := '数据落地-存款账户重要事件登记簿';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B
  (   
      EVT_ID                      --事件编号
      ,LP_ID                      --法人编号
      ,SEQ_NUM                    --序号
      ,ACCT_ID                    --账户编号
      ,INT_CLS_CD                 --利息分类代码
      ,TRAN_DT                    --交易日期
      ,TRAN_ORG_ID                --交易机构编号
      ,CUST_ACCT_NUM              --客户账号
      ,PROD_ID                    --产品编号
      ,ACCT_CURR_CD               --账户币种代码
      ,SUB_ACCT_NUM               --子账号
      ,OPEN_ACCT_ORG_ID           --开户机构编号
      ,OPEN_ACCT_DT               --开户日期
      ,CUST_ID                    --客户编号
      ,DEP_REDT_TYPE_CD           --存款转存类型代码
      ,INT_RAT_TYPE_CD            --利率类型代码
      ,BANK_INT_INT_RAT           --行内利率
      ,FLOAT_INT_RAT              --浮动利率
      ,FLOAT_POINT                --浮动点数
      ,EXEC_INT_RAT               --执行利率
      ,ACM_INT_ADJ_AMT            --累计利息调整金额
      ,PROVI_DAY_INT_ADJ_AMT      --计提日利息调整金额
      ,BASE_INT_RAT               --基础利率
      ,TOT_INT_AMT                --总利息金额
      ,INT_ACCR_AMT               --计息金额
      ,LAST_INT_SET_DT            --上一结息日期
      ,CAP_FLG                    --资本化标志
      ,DEP_TERM_TENOR             --存期期限
      ,TENOR_TYPE_CD              --期限类型代码
      ,EXP_DT                     --到期日期
      ,AMT_TYPE_CD                --金额类型代码
      ,TRAN_HAPP_PRIC             --交易发生本金
      ,TRAN_AMT                   --交易金额
      ,WDRAW_INT_RAT              --支取利率
      ,NET_INT                    --净利息
      ,INT_ACCR_DAYS              --计息天数
      ,TAX_RAT                    --税率
      ,TAX_CATEGORY_CD            --税种代码
      ,TAX_AMT                    --税金
      ,DEP_VOUCH_CATE_CD          --存款凭证类别代码
      ,VOUCH_NO                   --凭证号码
      ,REDT_SEQ_NUM               --转存序号
      ,TRAN_REF_NO                --交易参考号
      ,POST_FLG                   --过账标志
      ,TRAN_REVS_DT               --交易冲正日期
      ,ACCTI_STATUS_CD            --核算状态代码
      ,SOB_CATE_CD                --账套类别代码
      ,TRAN_MEMO_DESCB            --交易摘要描述
      ,SRC_MODULE_TYPE_CD         --源模块类型代码
      ,BUS_PROC_STATUS_CD         --业务处理状态代码
      ,CHECK_ENTRY_CD             --对账码
      ,TRAN_TELLER_ID             --交易柜员编号
      ,TRAN_TM                    --交易时间
      ,BUS_FLOW_NUM               --业务流水号
      ,CUST_TYPE_CD               --客户类型代码
      ,INT_CALC_BEGIN_DT          --利息计算起始日期
      ,YEAR_BASE_DAYS             --年计息基准代码
      ,MON_BASE_CD                --月基准代码
      ,ETL_DT                     --ETL处理日期
      ,SRC_TABLE_NAME             --源表名称
      ,JOB_CD                     --任务编码
      ,ETL_TIMESTAMP              --ETL处理时间戳
   )
  SELECT 
      EVT_ID                      --事件编号
      ,LP_ID                      --法人编号
      ,SEQ_NUM                    --序号
      ,ACCT_ID                    --账户编号
      ,INT_CLS_CD                 --利息分类代码
      ,TRAN_DT                    --交易日期
      ,TRAN_ORG_ID                --交易机构编号
      ,CUST_ACCT_NUM              --客户账号
      ,PROD_ID                    --产品编号
      ,ACCT_CURR_CD               --账户币种代码
      ,SUB_ACCT_NUM               --子账号
      ,OPEN_ACCT_ORG_ID           --开户机构编号
      ,OPEN_ACCT_DT               --开户日期
      ,CUST_ID                    --客户编号
      ,DEP_REDT_TYPE_CD           --存款转存类型代码
      ,INT_RAT_TYPE_CD            --利率类型代码
      ,BANK_INT_INT_RAT           --行内利率
      ,FLOAT_INT_RAT              --浮动利率
      ,FLOAT_POINT                --浮动点数
      ,EXEC_INT_RAT               --执行利率
      ,ACM_INT_ADJ_AMT            --累计利息调整金额
      ,PROVI_DAY_INT_ADJ_AMT      --计提日利息调整金额
      ,BASE_INT_RAT               --基础利率
      ,TOT_INT_AMT                --总利息金额
      ,INT_ACCR_AMT               --计息金额
      ,LAST_INT_SET_DT            --上一结息日期
      ,CAP_FLG                    --资本化标志
      ,DEP_TERM_TENOR             --存期期限
      ,TENOR_TYPE_CD              --期限类型代码
      ,EXP_DT                     --到期日期
      ,AMT_TYPE_CD                --金额类型代码
      ,TRAN_HAPP_PRIC             --交易发生本金
      ,TRAN_AMT                   --交易金额
      ,WDRAW_INT_RAT              --支取利率
      ,NET_INT                    --净利息
      ,INT_ACCR_DAYS              --计息天数
      ,TAX_RAT                    --税率
      ,TAX_CATEGORY_CD            --税种代码
      ,TAX_AMT                    --税金
      ,DEP_VOUCH_CATE_CD          --存款凭证类别代码
      ,VOUCH_NO                   --凭证号码
      ,REDT_SEQ_NUM               --转存序号
      ,TRAN_REF_NO                --交易参考号
      ,POST_FLG                   --过账标志
      ,TRAN_REVS_DT               --交易冲正日期
      ,ACCTI_STATUS_CD            --核算状态代码
      ,SOB_CATE_CD                --账套类别代码
      ,TRAN_MEMO_DESCB            --交易摘要描述
      ,SRC_MODULE_TYPE_CD         --源模块类型代码
      ,BUS_PROC_STATUS_CD         --业务处理状态代码
      ,CHECK_ENTRY_CD             --对账码
      ,TRAN_TELLER_ID             --交易柜员编号
      ,TRAN_TM                    --交易时间
      ,BUS_FLOW_NUM               --业务流水号
      ,CUST_TYPE_CD               --客户类型代码
      ,INT_CALC_BEGIN_DT          --利息计算起始日期
      ,YEAR_BASE_DAYS             --年计息基准代码
      ,MON_BASE_CD                --月基准代码
      ,ETL_DT                     --ETL处理日期
      ,SRC_TABLE_NAME             --源表名称
      ,JOB_CD                     --任务编码
      ,ETL_TIMESTAMP              --ETL处理时间戳
    FROM IML.V_EVT_DEP_ACCT_IMP_EVT_RGST_B --视图-存款账户重要事件登记簿
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

END ETL_O_IML_EVT_DEP_ACCT_IMP_EVT_RGST_B;
/

