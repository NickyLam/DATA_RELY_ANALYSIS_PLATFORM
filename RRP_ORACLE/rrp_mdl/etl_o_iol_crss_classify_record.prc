CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CRSS_CLASSIFY_RECORD(I_P_DATE IN INTEGER,
                                                           O_ERRCODE OUT VARCHAR2
                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CRSS_CLASSIFY_RECORD
  *  功能描述：风险分类记录
  *  创建日期：20220325
  *  开发人员：陈宜玲
  *  来源表： IOL.V_CRSS_CLASSIFY_RECORD
  *  目标表： O_IOL_CRSS_CLASSIFY_RECORD
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220325  陈宜玲  首次创建
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_CRSS_CLASSIFY_RECORD'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CRSS_CLASSIFY_RECORD'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_CRSS_CLASSIFY_RECORD';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-风险分类记录';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CRSS_CLASSIFY_RECORD NOLOGGING
    (OBJECTTYPE
    ,OBJECTNO
    ,SERIALNO
    ,MODELNO
    ,FIRSTRESULT
    ,SECONDRESULT
    ,RESULT1
    ,RESULTOPINION1
    ,RESULT2
    ,RESULTOPINION2
    ,RESULT3
    ,RESULTOPINION3
    ,RESULT4
    ,RESULTOPINION4
    ,FINALLYRESULT
    ,SUM1
    ,SUM2
    ,SUM3
    ,SUM4
    ,SUM5
    ,EXPECTLOSSSUM
    ,RESERVESUM
    ,CLASSIFYUSERID
    ,CLASSIFYORGID
    ,CLASSIFYDATE
    ,FINISHDATE
    ,INPUTDATE
    ,UPDATEDATE
    ,REMARK
    ,BUSINESSBALANCE
    ,ORGID
    ,USERID
    ,ACCOUNTMONTH
    ,RESULT5
    ,RESULTOPINION5
    ,RESULTUSERNAME5
    ,RESULTUSERNAME4
    ,RESULTUSERNAME3
    ,RESULTUSERNAME2
    ,RESULTUSERNAME1
    ,CLASSIFYLEVEL
    ,RESULTUSERID2
    ,RESULTUSERID3
    ,RESULTUSERID4
    ,RESULTUSERID5
    ,FINISHDATE2
    ,FINISHDATE3
    ,FINISHDATE4
    ,FINISHDATE5
    ,ORIGINALPUTOUTDATE
    ,LASTRESULT
    ,CUSTOMERID
    ,CONTRACTSERIALNO
    ,FLAG                       --状态
    ,ISINUSE                    --添加维护标志1正常2不维护
    ,START_DT                   --开始时间
    ,END_DT                     --结束时间
    ,ID_MARK                    --增删标志
    )
  SELECT /*+PARALLEL*/
         OBJECTTYPE
        ,OBJECTNO
        ,SERIALNO
        ,MODELNO
        ,FIRSTRESULT
        ,SECONDRESULT
        ,RESULT1
        ,RESULTOPINION1
        ,RESULT2
        ,RESULTOPINION2
        ,RESULT3
        ,RESULTOPINION3
        ,RESULT4
        ,RESULTOPINION4
        ,FINALLYRESULT
        ,SUM1
        ,SUM2
        ,SUM3
        ,SUM4
        ,SUM5
        ,EXPECTLOSSSUM
        ,RESERVESUM
        ,CLASSIFYUSERID
        ,CLASSIFYORGID
        ,CLASSIFYDATE
        ,FINISHDATE
        ,INPUTDATE
        ,UPDATEDATE
        ,REMARK
        ,BUSINESSBALANCE
        ,ORGID
        ,USERID
        ,ACCOUNTMONTH
        ,RESULT5
        ,RESULTOPINION5
        ,RESULTUSERNAME5
        ,RESULTUSERNAME4
        ,RESULTUSERNAME3
        ,RESULTUSERNAME2
        ,RESULTUSERNAME1
        ,CLASSIFYLEVEL
        ,RESULTUSERID2
        ,RESULTUSERID3
        ,RESULTUSERID4
        ,RESULTUSERID5
        ,FINISHDATE2
        ,FINISHDATE3
        ,FINISHDATE4
        ,FINISHDATE5
        ,ORIGINALPUTOUTDATE
        ,LASTRESULT
        ,CUSTOMERID
        ,CONTRACTSERIALNO
        ,FLAG                       --状态
        ,ISINUSE                    --添加维护标志1正常2不维护
        ,START_DT                   --开始时间
        ,END_DT                     --结束时间
        ,ID_MARK                    --增删标志
    FROM IOL.V_CRSS_CLASSIFY_RECORD  --风险分类记录表_视图
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

END ETL_O_IOL_CRSS_CLASSIFY_RECORD;
/

