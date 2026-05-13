CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_UNITE_WL_REPAY_DTL(I_P_DATE IN INTEGER,
                                                             O_ERRCODE OUT VARCHAR2
                                                             )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_UNITE_WL_REPAY_DTL
  *  功能描述：联合网贷还款明细
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_UNITE_WL_REPAY_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20251106   YJY     针对分期乐、微业贷3.0产品做接数处理，按照t天进行获取
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(50) := 'O_ICL_CMM_UNITE_WL_REPAY_DTL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_UNITE_WL_REPAY_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_DTL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-联合网贷还款明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_UNITE_WL_REPAY_DTL
    (ETL_DT                   --数据日期
    ,LP_ID                    --法人编号
    ,DUBIL_ID                 --借据编号
    ,CUST_ID                  --客户编号
    ,PROD_ID                  --产品编号
    ,REPAY_ACCT_ID            --还款账户编号
    ,REPAY_FLOW_ID            --还款流水编号
    ,REPAY_DT                 --还款日期
    ,INTNAL_CARR_FLG          --内部结转标志
    ,WRT_OFF_FLG              --核销标志
    ,ADV_REPAY_FLG            --提前还款标志
    ,OVDUE_REPAY_FLG          --逾期还款标志
    ,ACRU_NON_ACRU_CD         --应计非应计代码
    ,REPAY_TYPE_CD            --还款类型代码
    ,CURR_CD                  --币种代码
    ,CURR_NOMAL_PRIC_BAL      --当前正常本金余额
    ,CURRT_REPAY_AMT          --当期还款金额
    ,CURRT_REPAY_PRIC         --当期还款本金
    ,CURRT_REPAY_NOMAL_PRIC   --当期还款正常本金
    ,CURRT_REPAY_OVDUE_PRIC   --当期还款逾期本金
    ,CURR_REPAY_INT           --当前还款利息
    ,CURRT_REPAY_NOMAL_INT    --当期还款正常利息
    ,CURRT_REPAY_OVDUE_INT    --当期还款逾期利息
    ,CURRT_REPAY_PNLT         --当期还款罚息
    ,CURRT_REPAY_OVDUE_PRIC_PNLT  --当期还款逾期本金罚息
    ,CURRT_REPAY_OVDUE_INT_PNLT   --当期还款逾期利息罚息
    ,CURRT_REPAY_FEE          --当期还款费用
    ,CURRT_REPAY_FEE_RAT      --当期还款费率
    ,JOB_CD                   --任务代码
    )
  SELECT 
     /*ETL_DT + 1*/TO_DATE(V_P_DATE,'YYYYMMDD')   --数据日期  MOD BY YJY 20251106
    ,LP_ID                    --法人编号
    ,DUBIL_ID                 --借据编号
    ,CUST_ID                  --客户编号
    ,PROD_ID                  --产品编号
    ,REPAY_ACCT_ID            --还款账户编号
    ,REPAY_FLOW_ID            --还款流水编号
    ,REPAY_DT                 --还款日期
    ,INTNAL_CARR_FLG          --内部结转标志
    ,WRT_OFF_FLG              --核销标志
    ,ADV_REPAY_FLG            --提前还款标志
    ,OVDUE_REPAY_FLG          --逾期还款标志
    ,ACRU_NON_ACRU_CD         --应计非应计代码
    ,REPAY_TYPE_CD            --还款类型代码
    ,CURR_CD                  --币种代码
    ,CURR_NOMAL_PRIC_BAL      --当前正常本金余额
    ,CURRT_REPAY_AMT          --当期还款金额
    ,CURRT_REPAY_PRIC         --当期还款本金
    ,CURRT_REPAY_NOMAL_PRIC   --当期还款正常本金
    ,CURRT_REPAY_OVDUE_PRIC   --当期还款逾期本金
    ,CURR_REPAY_INT           --当前还款利息
    ,CURRT_REPAY_NOMAL_INT    --当期还款正常利息
    ,CURRT_REPAY_OVDUE_INT    --当期还款逾期利息
    ,CURRT_REPAY_PNLT         --当期还款罚息
    ,CURRT_REPAY_OVDUE_PRIC_PNLT  --当期还款逾期本金罚息
    ,CURRT_REPAY_OVDUE_INT_PNLT   --当期还款逾期利息罚息
    ,CURRT_REPAY_FEE          --当期还款费用
    ,CURRT_REPAY_FEE_RAT      --当期还款费率
    ,JOB_CD                   --任务代码
    FROM ICL.V_CMM_UNITE_WL_REPAY_DTL  --视图-联合网贷还款明细
   WHERE --ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1;
         (PROD_ID NOT IN ('202010200011','202010200010','201020100063') AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1) --其他联合网贷依旧按照t-1接数
      OR (PROD_ID IN ('202010200011','202010200010','201020100063') AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')) --分期乐、微业贷3.0按照t接数  MOD BY YJY 20251106
       ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);

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

END ETL_O_ICL_CMM_UNITE_WL_REPAY_DTL;
/

