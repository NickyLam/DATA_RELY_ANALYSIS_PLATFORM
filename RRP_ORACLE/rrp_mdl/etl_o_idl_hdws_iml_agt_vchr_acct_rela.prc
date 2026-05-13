CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IDL_HDWS_IML_AGT_VCHR_ACCT_RELA(I_P_DATE IN INTEGER,
                                                                  O_ERRCODE OUT VARCHAR2
                                                                  )
  /************************************************************
  **存储过程详细说明：凭证账户关系
  **存储过程名称：ETL_O_IDL_HDWS_IML_AGT_VCHR_ACCT_RELA
  **存储过程创建日期：20220318
  **存储过程创建人：易梓林
  **目的：
  **输入参数：I_DATADATE
  **输出参数：O_ERRCODE
  **返回值：O_ERRCODE
  ** 修改日期   修改人       修改原因
  ** 20221021   LIP          将表改为只存当天的数据
  **************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(200);              --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_IDL_HDWS_IML_AGT_VCHR_ACCT_RELA'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IDL_HDWS_IML_AGT_VCHR_ACCT_RELA'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IDL_HDWS_IML_AGT_VCHR_ACCT_RELA T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IDL_HDWS_IML_AGT_VCHR_ACCT_RELA';
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-凭证账户关系';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IDL_HDWS_IML_AGT_VCHR_ACCT_RELA';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IDL_HDWS_IML_AGT_VCHR_ACCT_RELA NOLOGGING
    (ETL_DT            --数据日期
    ,VCHR_ID           --凭证编号
    ,VCHR_TYPE_CD      --凭证种类代码
    ,DPST_ACCT_ID      --存款账户编号
    ,DATA_SRC_CD       --数据来源代码
    ,DEL_FLG           --删除标志
    ,LAST_UPDATE_DT    --最后更新日期
    ,ETL_TASK_NAME     --任务名称
    ,JOB_CD            --任务代码
    )
  SELECT /*+PARALLEL */
          TO_DATE(V_P_DATE,'YYYYMMDD') ETL_DT--数据日期
         ,VCHR_ID          --凭证编号
         ,VCHR_TYPE_CD     --凭证种类代码
         ,DPST_ACCT_ID     --存款账户编号
         ,DATA_SRC_CD      --数据来源代码
         ,DEL_FLG          --删除标志
         ,LAST_UPDATE_DT   --最后更新日期
         ,ETL_TASK_NAME    --任务名称
         ,JOB_CD           --任务代码
    FROM IDL.V_HDWS_IML_AGT_VCHR_ACCT_RELA  --凭证账户关系_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

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

END ETL_O_IDL_HDWS_IML_AGT_VCHR_ACCT_RELA;
/

