CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_RB_ACCT_EVENT_REGISTER(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NCBS_RB_ACCT_EVENT_REGISTER
  *  功能描述：账户重要事件登记簿
  *  创建日期：20251210
  *  开发人员：YJY
  *  来源表： IOL.V_NCBS_RB_ACCT_EVENT_REGISTER
  *  目标表： O_IOL_NCBS_RB_ACCT_EVENT_REGISTER
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251210  YJY     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IOL_NCBS_RB_ACCT_EVENT_REGISTER'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NCBS_RB_ACCT_EVENT_REGISTER'; --程序名称
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
  V_STEP_DESC := '数据落地-账户重要事件登记簿';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NCBS_RB_ACCT_EVENT_REGISTER NOLOGGING 
  (         ACCT_SEQ_NO            --账户子账号
           ,AMT_TYPE               --金额类型
           ,BASE_ACCT_NO           --交易账号/卡号
           ,BUSINESS_UNIT          --账套
           ,CLIENT_NO              --客户编号
           ,CLIENT_TYPE            --客户类型
           ,DOC_TYPE               --凭证类型
           ,INT_TYPE               --利率类型
           ,INTERNAL_KEY           --账户内部键值
           ,PROD_TYPE              --产品编号
           ,PROFIT_CENTER          --利润中心
           ,REFERENCE              --交易参考号
           ,USER_ID                --交易柜员编号
           ,VOUCHER_NO             --凭证号码
           ,TERM                   --存期
           ,TERM_TYPE              --期限单位
           ,COMPANY                --法人
           ,GL_POSTED_FLAG         --过账标记
           ,INT_CAP_FLAG           --资本化标志
           ,MOVT_STATUS            --转存类型
           ,NARRATIVE              --摘要
           ,PREFIX                 --前缀
           ,PRINT_CNT              --打印次数
           ,SEQ_NO                 --序号
           ,SEQ_RENEW_ROLLOVER_NO  --转存序号
           ,SOURCE_MODULE          --源模块
           ,TAX_TYPE               --税种
           ,TRAN_STATUS            --冲补抹标志
           ,INT_CLASS              --利息分类
           ,ACCOUNTING_STATUS      --核算状态
           ,ACCT_OPEN_DATE         --账户开户日期
           ,LAST_CYCLE_DATE        --上一结息日
           ,MATURITY_DATE          --到期日期
           ,REVERSAL_DATE          --冲正日期
           ,TRAN_DATE              --交易日期
           ,TRAN_TIMESTAMP         --交易时间戳
           ,ACCT_BRANCH            --开户机构编号
           ,ACCT_CCY               --账户币种
           ,ACCT_LEVEL_INT_RATE    --账户基础利率
           ,ACTUAL_RATE            --行内利率
           ,CALC_DAYS              --算息天数
           ,CALC_INT_AMT           --算息金额
           ,DEBT_INT_RATE          --支取利率
           ,FLOAT_RATE             --浮动利率
           ,GROSS_INTEREST_AMT     --总利息金额
           ,INT_ADJ                --利息调增金额
           ,INT_ADJ_CTD            --计提日利息调整
           ,NET_INTEREST_AMT       --净利息
           ,PRINCIPAL_AMT          --交易本金
           ,REAL_RATE              --执行利率
           ,SPREAD_RATE            --浮动点数
           ,TAX_AMT                --税金
           ,TAX_RATE               --税率
           ,TRAN_AMT               --交易金额
           ,TRAN_BRANCH            --核心交易机构编号
           ,REACCOUNT_CD           --对账代码
           ,BUS_SEQ_NO             --业务流水号
           ,CALC_BEGIN_DATE        --利息计算起始日
           ,YEAR_BASIS             --年基准天数
           ,MONTH_BASIS            --月基准
           ,ETL_DT                 --ETL处理日期
           ,ETL_TIMESTAMP          --ETL处理时间戳
    )
  SELECT 
            ACCT_SEQ_NO            --账户子账号
           ,AMT_TYPE               --金额类型
           ,BASE_ACCT_NO           --交易账号/卡号
           ,BUSINESS_UNIT          --账套
           ,CLIENT_NO              --客户编号
           ,CLIENT_TYPE            --客户类型
           ,DOC_TYPE               --凭证类型
           ,INT_TYPE               --利率类型
           ,INTERNAL_KEY           --账户内部键值
           ,PROD_TYPE              --产品编号
           ,PROFIT_CENTER          --利润中心
           ,REFERENCE              --交易参考号
           ,USER_ID                --交易柜员编号
           ,VOUCHER_NO             --凭证号码
           ,TERM                   --存期
           ,TERM_TYPE              --期限单位
           ,COMPANY                --法人
           ,GL_POSTED_FLAG         --过账标记
           ,INT_CAP_FLAG           --资本化标志
           ,MOVT_STATUS            --转存类型
           ,NARRATIVE              --摘要
           ,PREFIX                 --前缀
           ,PRINT_CNT              --打印次数
           ,SEQ_NO                 --序号
           ,SEQ_RENEW_ROLLOVER_NO  --转存序号
           ,SOURCE_MODULE          --源模块
           ,TAX_TYPE               --税种
           ,TRAN_STATUS            --冲补抹标志
           ,INT_CLASS              --利息分类
           ,ACCOUNTING_STATUS      --核算状态
           ,ACCT_OPEN_DATE         --账户开户日期
           ,LAST_CYCLE_DATE        --上一结息日
           ,MATURITY_DATE          --到期日期
           ,REVERSAL_DATE          --冲正日期
           ,TRAN_DATE              --交易日期
           ,TRAN_TIMESTAMP         --交易时间戳
           ,ACCT_BRANCH            --开户机构编号
           ,ACCT_CCY               --账户币种
           ,ACCT_LEVEL_INT_RATE    --账户基础利率
           ,ACTUAL_RATE            --行内利率
           ,CALC_DAYS              --算息天数
           ,CALC_INT_AMT           --算息金额
           ,DEBT_INT_RATE          --支取利率
           ,FLOAT_RATE             --浮动利率
           ,GROSS_INTEREST_AMT     --总利息金额
           ,INT_ADJ                --利息调增金额
           ,INT_ADJ_CTD            --计提日利息调整
           ,NET_INTEREST_AMT       --净利息
           ,PRINCIPAL_AMT          --交易本金
           ,REAL_RATE              --执行利率
           ,SPREAD_RATE            --浮动点数
           ,TAX_AMT                --税金
           ,TAX_RATE               --税率
           ,TRAN_AMT               --交易金额
           ,TRAN_BRANCH            --核心交易机构编号
           ,REACCOUNT_CD           --对账代码
           ,BUS_SEQ_NO             --业务流水号
           ,CALC_BEGIN_DATE        --利息计算起始日
           ,YEAR_BASIS             --年基准天数
           ,MONTH_BASIS            --月基准
           ,ETL_DT                 --ETL处理日期
           ,ETL_TIMESTAMP          --ETL处理时间戳
    FROM IOL.V_NCBS_RB_ACCT_EVENT_REGISTER --视图-账户重要事件登记簿
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

END ETL_O_IOL_NCBS_RB_ACCT_EVENT_REGISTER;
/

