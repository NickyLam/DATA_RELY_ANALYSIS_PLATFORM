CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_M_FINC_CPTL_SUB(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
/**************************************************************************
 *  程序名称：ETL_M_FINC_CPTL_SUB
 *  功能描述：理财产品余额子表
 *  创建日期：20220930
 *  开发人员：MW
 *  来源表：
 *
 *  目标表：  M_FINC_CPTL_SUB
 *  配置表：
 *  修改情况：序号  修改日期  修改人   修改原因
 *
 ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;           --处理步骤
  V_STEP_DESC VARCHAR2(100);          --处理步骤描述
  V_P_DATE    VARCHAR2(8);            --跑批数据日期
  V_STARTTIME DATE;                   --处理开始时间
  V_ENDTIME   DATE;                   --处理结束时间
  V_SQLCOUNT  INTEGER := 0;           --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);          --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);          --分区名
  V_TAB_NAME  VARCHAR2(100) := 'M_FINC_CPTL_SUB'; --表名
  V_PROC_NAME VARCHAR2(100) := 'ETL_M_FINC_CPTL_SUB'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  --处理参数及月末等判断逻辑
  V_P_DATE := I_P_DATE; --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  --支持重跑
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.M_FINC_CPTL_SUB T WHERE T.DATA_DT = V_P_DATE;--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||'M_FINC_CPTL_SUB'||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --分区表分区处理
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序业务逻辑处理主体部分
  V_STEP := 3;
  V_STEP_DESC := '插入理财产品余额子表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.M_FINC_CPTL_SUB
    (DATA_DT        --数据日期
    ,LGL_REP_ID     --法人编号
    ,TRA_ACC_ID     --交易账户编号
    ,CONT_ID        --合同编号
    ,OPEN_DT        --开立日期
    ,ACT_VAL_DT     --实际起息日期
    ,ACT_EXP_DT     --实际到期日期
    ,CUR_LOT        --当前份额
    ,CUR            --币种
    ,DEPT_LINE      --部门条线
    ,JOB_CD         --任务代码
    ,CUST_ID        --客户编号
    )
  SELECT DISTINCT
         V_P_DATE                            AS DATA_DT        --数据日期
        ,A.LP_ID                             AS LGL_REP_ID     --法人编号
        ,A.TRAN_ACCT_ID                      AS TRA_ACC_ID     --交易账户编号
        ,A.CONT_ID                           AS CONT_ID        --合同编号
        ,TO_CHAR(OPEN_DT,'YYYYMMDD')         AS OPEN_DT        --开立日期
        ,TO_CHAR(ACTL_VALUE_DT,'YYYYMMDD')   AS ACT_VAL_DT     --实际起息日期
        ,TO_CHAR(ACTL_EXP_DT,'YYYYMMDD')     AS ACT_EXP_DT     --实际到期日期
        ,A.CURR_LOT                          AS CUR_LOT        --当前份额
        ,A.CURR_CD                           AS CUR            --币种
        ,NULL                                AS DEPT_LINE      --部门条线
        ,'普通理财'                          AS JOB_CD         --任务代码
        ,A.CUST_ID                           AS CUST_ID        --客户编号
    FROM RRP_MDL.O_ICL_CMM_FINC_ACCT_BAL_INFO A --理财账户余额信息
   WHERE A.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := 4;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE); --表分析

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_M_FINC_CPTL_SUB;
/

