CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_RWAS_RRS_G4X_REPORT_RESULT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_RWAS_RRS_G4X_REPORT_RESULT
  *  功能描述：风险计量系统1104法人报表
  *  创建日期：20221007
  *  开发人员：HULJ
  *  来源表：
  *  目标表： O_IOL_RWAS_RRS_G4X_REPORT_RESULT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221007  HULJ     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_RWAS_RRS_G4X_REPORT_RESULT'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_RPT_DATE  VARCHAR2(8);
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
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IOL_RWAS_RRS_G4X_REPORT_RESULT T WHERE T.DATA_DATE = TO_DATE(V_P_DATE,'YYYYMMDD');
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_RWAS_RRS_G4X_REPORT_RESULT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


-- 如果满足启动时间，此时CONTROL-M调用的数据日期是T+1，因此我们需要根据调用的数据日期获取相关的真正取数日期（即数据日期）
/*    IF TO_CHAR(TO_DATE(I_P_DATE, 'YYYYMMDD')+1, 'DD') = '01' THEN
      V_RPT_DATE := I_P_DATE;
    ELSE
      V_RPT_DATE := TO_NUMBER(TO_CHAR(TO_DATE(SUBSTR(I_P_DATE, 1, 6)||'01', 'YYYYMMDD')-1, 'YYYYMMDD'));
    END IF;*/

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-风险计量系统1104法人报表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_RWAS_RRS_G4X_REPORT_RESULT
  (
    DATA_DATE
   ,RPT_NO
   ,LINE_NO
   ,LINE_DESC
   ,VAL1
   ,VAL2
   ,VAL3
   ,VAL4
   ,VAL5
   ,VAL6
   ,VAL7
   ,VAL8
   ,VAL9
   ,VAL10
   ,VAL11
   ,VAL12
   ,VAL13
   ,VAL14
   ,VAL15
   ,VAL16
   ,VAL17
   ,VAL18
   ,VAL19
   ,VAL20
   ,ETL_DT
    )
    SELECT
    DATA_DATE
   ,RPT_NO
   ,LINE_NO
   ,LINE_DESC
   ,VAL1
   ,VAL2
   ,VAL3
   ,VAL4
   ,VAL5
   ,VAL6
   ,VAL7
   ,VAL8
   ,VAL9
   ,VAL10
   ,VAL11
   ,VAL12
   ,VAL13
   ,VAL14
   ,VAL15
   ,VAL16
   ,VAL17
   ,VAL18
   ,VAL19
   ,VAL20
   ,ETL_DT
    FROM IOL.V_RWAS_RRS_G4X_REPORT_RESULT --视图-风险计量系统1104法人报表
    --
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

  END ETL_INIT_O_IOL_RWAS_RRS_G4X_REPORT_RESULT;
/

