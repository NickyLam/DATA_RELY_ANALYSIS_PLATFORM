CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_UNITE_WL_DISTR_DTL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_UNITE_WL_DISTR_DTL
  *  功能描述：联合网贷放款明细
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_UNITE_WL_DISTR_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_UNITE_WL_DISTR_DTL'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_UNITE_WL_DISTR_DTL ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_UNITE_WL_DISTR_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-联合网贷放款明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_UNITE_WL_DISTR_DTL
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,DUBIL_ID  --借据编号
      ,CUST_ID  --客户编号
      ,CUST_NAME  --客户姓名
      ,CUST_CERT_TYPE_CD  --客户证件类型代码
      ,CUST_CERT_NO  --客户证件号码
      ,CRDT_ID  --授信编号
      ,LOAN_APPL_FORM_NUM  --贷款申请单号
      ,DISTR_FLOW_NUM  --放款流水号
      ,PROD_ID  --产品编号
      ,LOAN_CONTR_NO  --贷款合同号
      ,LOAN_STATUS_CD  --贷款状态代码
      ,LOAN_USAGE  --贷款用途
      ,CURR_CD  --币种代码
      ,DISTR_AMT  --放款金额
      ,APPL_DT  --申请日期
      ,DISTR_DT  --放款日期
      ,LOAN_PD_CNT  --贷款期次数
      ,REPAY_WAY_CD  --还款方式代码
      ,GRACE_PERIOD_DAYS  --宽限期天数
      ,INT_RAT_TYPE_CD  --利率类型代码
      ,LOAN_DAY_INT_RAT  --贷款日利率
      ,PRIC_REPAY_FREQ  --本金还款频率
      ,INT_REPAY_FREQ  --利息还款频率
      ,GUAR_TYPE_CD  --担保类型代码
      ,RECVBL_NUM  --收款帐号
      ,RECVBL_NUM_TYPE_CD  --收款帐号类型代码
      ,REPAY_NUM  --还款帐号
      ,REPAY_NUM_TYPE_CD  --还款帐号类型代码
      ,INTNAL_CARR_IDF  --内部结转标识
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT +1 --数据日期
      ,LP_ID  --法人编号
      ,DUBIL_ID  --借据编号
      ,CUST_ID  --客户编号
      ,CUST_NAME  --客户姓名
      ,CUST_CERT_TYPE_CD  --客户证件类型代码
      ,CUST_CERT_NO  --客户证件号码
      ,CRDT_ID  --授信编号
      ,LOAN_APPL_FORM_NUM  --贷款申请单号
      ,DISTR_FLOW_NUM  --放款流水号
      ,PROD_ID  --产品编号
      ,LOAN_CONTR_NO  --贷款合同号
      ,LOAN_STATUS_CD  --贷款状态代码
      ,LOAN_USAGE  --贷款用途
      ,CURR_CD  --币种代码
      ,DISTR_AMT  --放款金额
      ,APPL_DT  --申请日期
      ,DISTR_DT  --放款日期
      ,LOAN_PD_CNT  --贷款期次数
      ,REPAY_WAY_CD  --还款方式代码
      ,GRACE_PERIOD_DAYS  --宽限期天数
      ,INT_RAT_TYPE_CD  --利率类型代码
      ,LOAN_DAY_INT_RAT  --贷款日利率
      ,PRIC_REPAY_FREQ  --本金还款频率
      ,INT_REPAY_FREQ  --利息还款频率
      ,GUAR_TYPE_CD  --担保类型代码
      ,RECVBL_NUM  --收款帐号
      ,RECVBL_NUM_TYPE_CD  --收款帐号类型代码
      ,REPAY_NUM  --还款帐号
      ,REPAY_NUM_TYPE_CD  --还款帐号类型代码
      ,INTNAL_CARR_IDF  --内部结转标识
    ,JOB_CD --任务代码
    FROM ICL.V_CMM_UNITE_WL_DISTR_DTL  --视图-联合网贷放款明细
    WHERE TRUNC(ETL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
  ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


   -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_INIT_O_ICL_CMM_UNITE_WL_DISTR_DTL;
/

