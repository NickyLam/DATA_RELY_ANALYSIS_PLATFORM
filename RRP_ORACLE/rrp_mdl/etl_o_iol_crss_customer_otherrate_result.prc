CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CRSS_CUSTOMER_OTHERRATE_RESULT(I_P_DATE IN INTEGER,
                                                                     O_ERRCODE OUT VARCHAR2
                                                                     )
/**************************************************************************
*  程序名称：ETL_O_IOL_CRSS_CUSTOMER_OTHERRATE_RESULT
*  功能描述：外部评级表
*  创建日期：20220408
*  开发人员：陈宜玲
*  来源表： IOL.V_CRSS_CUSTOMER_OTHERRATE_RESULT
*  目标表： O_IOL_CRSS_CUSTOMER_OTHERRATE_RESULT
*  配置表：
*  修改情况：序号  修改日期  修改人   修改原因
*             1    20220408  陈宜玲 首次创建
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_CRSS_CUSTOMER_OTHERRATE_RESULT'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CRSS_CUSTOMER_OTHERRATE_RESULT'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_CRSS_CUSTOMER_OTHERRATE_RESULT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-外部评级表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CRSS_CUSTOMER_OTHERRATE_RESULT NOLOGGING
    (CUSTOMERID              --客户号
    ,RATETYPE                --评级类型（1.外部机构评级、2.监管评级/分类 评级）
    ,RATEORG                 --评级机构
    ,RATERISKLEVEL           --评级结果
    ,RATEDATE                --评级日期
    ,RATEBEGINDATE           --评级生效日
    ,RATEENDDATE             --评级失效日
    ,INPUTUSERID             --登记人
    ,INPUTORGID              --登记机构
    ,INPUTDATE               --登记时间
    ,UPDATETIME              --更新时间
    ,SERIALNO                --流水号
    ,ETL_DT                  --ETL处理日期
    )
  SELECT /*+PARALLEL*/
         CUSTOMERID              --客户号
        ,RATETYPE                --评级类型（1.外部机构评级、2.监管评级/分类 评级）
        ,RATEORG                 --评级机构
        ,RATERISKLEVEL           --评级结果
        ,RATEDATE                --评级日期
        ,RATEBEGINDATE           --评级生效日
        ,RATEENDDATE             --评级失效日
        ,INPUTUSERID             --登记人
        ,INPUTORGID              --登记机构
        ,INPUTDATE               --登记时间
        ,UPDATETIME              --更新时间
        ,SERIALNO                --流水号
        ,ETL_DT                  --ETL处理日期
    FROM IOL.V_CRSS_CUSTOMER_OTHERRATE_RESULT  --外部评级表_视图
   /*WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/;

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

END ETL_O_IOL_CRSS_CUSTOMER_OTHERRATE_RESULT;
/

