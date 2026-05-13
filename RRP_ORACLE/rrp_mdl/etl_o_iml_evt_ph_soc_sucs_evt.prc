CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_PH_SOC_SUCS_EVT(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_PH_SOC_SUCS_EVT
  *  功能描述：助贷理赔成功事件
  *  创建日期：20240524
  *  开发人员：YUJINGYI
  *  来源表： IML.V_EVT_PH_SOC_SUCS_EVT
  *  目标表： O_IML_EVT_PH_SOC_SUCS_EVT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240524  YUJINGYI 首次创建
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
  V_TAB_NAME  VARCHAR2(100) := 'O_IML_EVT_PH_SOC_SUCS_EVT'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_PH_SOC_SUCS_EVT'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_IML_EVT_PH_SOC_SUCS_EVT
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD') AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-助贷理赔成功事件';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_PH_SOC_SUCS_EVT
    (EVT_ID                 --事件编号
    ,LP_ID                  --法人编号
    ,DUBIL_ID               --借据编号
    ,INPUT_DT               --录入日期
    ,SOC_DT                 --理赔日期
    ,SHOULD_SOC_AMT         --应理赔金额
    ,ACTL_SOC_AMT           --实际理赔金额
    ,BORW_BAL               --借款余额
    ,SOC_SUCS_FLG           --理赔成功标志
    ,STUD_LOAN_PROD_ID      --助贷产品编号
    ,START_DT               --开始日期
    ,END_DT                 --结束日期
    ,ID_MARK                --删除标识
    ,SRC_TABLE_NAME         --源表名称
    ,JOB_CD                 --任务代码
    ,ETL_TIMESTAMP          --数据处理时间
    )
  SELECT EVT_ID                 --事件编号
        ,LP_ID                  --法人编号
        ,DUBIL_ID               --借据编号
        ,INPUT_DT               --录入日期
        ,SOC_DT                 --理赔日期
        ,SHOULD_SOC_AMT         --应理赔金额
        ,ACTL_SOC_AMT           --实际理赔金额
        ,BORW_BAL               --借款余额
        ,SOC_SUCS_FLG           --理赔成功标志
        ,STUD_LOAN_PROD_ID      --助贷产品编号
        ,START_DT               --开始日期
        ,END_DT                 --结束日期
        ,ID_MARK                --删除标识
        ,SRC_TABLE_NAME         --源表名称
        ,JOB_CD                 --任务代码
        ,ETL_TIMESTAMP          --数据处理时间
    FROM IML.V_EVT_PH_SOC_SUCS_EVT  --视图-助贷理赔成功事件
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_IML_EVT_PH_SOC_SUCS_EVT;
/

