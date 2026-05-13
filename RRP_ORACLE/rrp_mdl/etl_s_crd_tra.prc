CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_S_CRD_TRA(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /***********************************************************************
  **  存储过程详细说明：卡交易整合表
  **  存储过程名称:  ETL_S_CRD_TRA
  **  存储过程创建日期:2022-03-07
  **  存储过程创建人:蔡正伟
  **  调用方法:
       DECLARE
         I_P_DATE INTEGER;
         O_ERRCODE  CHAR(1);
       BEGIN
         I_P_DATE := '20220101';
         ETL_S_CRD_TRA(I_P_DATE, O_ERRCODE);
       END;
  **  输入参数:   I_P_DATE
  **  输出参数:   O_ERRCODE
  **  修改记录：  序号          修改日期          修改人          修改原因
  **
  ***********************************************************************/
IS
  -- 定义变量 --
  V_STEP      INTEGER := 0;         --处理步骤
  V_STEP_DESC VARCHAR2(100);        --处理步骤描述
  V_P_DATE    VARCHAR2(10);         --跑批数据日期
  V_STARTTIME DATE;                 --处理开始时间
  V_ENDTIME   DATE;                 --处理结束时间
  V_SQLCOUNT  INTEGER := 0;         --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);        --SQL执行描述信息
  V_PART_NAME VARCHAR2(100);        --分区名
  --V_FREQ_FLAG VARCHAR2(100);
  V_PROC_NAME VARCHAR2(30) := 'ETL_S_CRD_TRA'; --程序名称
  V_TAB_NAME  VARCHAR2(100) := 'S_CRD_TRA'; --表名
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
  O_ERRCODE   := '0';
  --V_FREQ_FLAG := FUN_FREQ(I_P_DATE,V_PROC_NAME);

  --判断跑批频度和跑批日期是否相符
  /*IF V_FREQ_FLAG = '1' THEN*/

  -- 支持重跑 --
  V_STEP := 2;
  V_STEP_DESC := '重跑表';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.S_CRD_TRA T WHERE T.DATA_DT = V_P_DATE; --普通表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  RRP_MDL.ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '1', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  V_STEP := 3;
  V_STEP_DESC := '卡交易整合表--开发逻辑1-借记卡';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_CRD_TRA(
    DATA_DT,     --数据日期
    LGL_REP_ID,  --法人编号
    TRA_SEQ_NO,  --交易流水号
    ORG_ID,      --机构编号
    CRD_NO,      --卡号
    CUR,         --币种
    CRD_CL,      --卡片种类
    TRA_DT,      --交易日期
    TRA_AMT,     --交易金额
    TRA_TYP,     --交易类型
    TRA_CHAN,    --交易渠道
    DEPT_LINE,   --部门条线
    DATA_SRC,    --数据来源
    TRA_DIR      --交易方向
    )
  SELECT A.DATA_DT        AS DATA_DT,     --数据日期
         A.LGL_REP_ID     AS LGL_REP_ID,  --法人编号
         A.TRA_SEQ_NO     AS TRA_SEQ_NO,  --交易流水号
         A.ORG_ID         AS ORG_ID,      --机构编号
         A.TRA_MED_NO     AS CRD_NO,      --卡号
         A.CUR            AS CUR,         --币种
         '1'              AS CRD_CL,      --卡片种类
         A.TRA_DT         AS TRA_DT,      --交易日期
         A.TRA_AMT        AS TRA_AMT,     --交易金额
         A.TRA_TYP        AS TRA_TYP,     --交易类型
         A.TRA_CHAN       AS TRA_CHAN,    --交易渠道
         A.DEPT_LINE      AS DEPT_LINE,   --部门条线
         A.DATA_SRC       AS DATA_SRC,    --数据来源
         A.DEP_IN_OUT_FLG AS TRA_DIR      --交易方向
    FROM RRP_MDL.M_TRA_DEP_ACC_DTL A --存款账户交易流水
   WHERE A.TRA_MED_TYP = 'A' --卡
     AND A.DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  /*V_STEP := 4;
  V_STEP_DESC := '卡交易整合表--开发逻辑2-贷记卡';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.S_CRD_TRA(
    DATA_DT,     --数据日期
    LGL_REP_ID,  --法人编号
    TRA_SEQ_NO,  --交易流水号
    ORG_ID,      --机构编号
    CRD_NO,      --卡号
    CUR,         --币种
    CRD_CL,      --卡片种类
    TRA_DT,      --交易日期
    TRA_AMT,     --交易金额
    TRA_TYP,     --交易类型
    TRA_CHAN,    --交易渠道
    DEPT_LINE,   --部门条线
    DATA_SRC     --数据来源
    )
  SELECT A.DATA_DT        AS DATA_DT,     --数据日期
         A.LGL_REP_ID     AS LGL_REP_ID,  --法人编号
         A.TRA_SEQ_NO     AS TRA_SEQ_NO,  --交易流水号
         A.ORG_ID         AS ORG_ID,      --机构编号
         A.TRA_MED_NO     AS CRD_NO,      --卡号
         A.CUR            AS CUR,         --币种
         '1'              AS CRD_CL,      --卡片种类
         A.TRA_DT         AS TRA_DT,      --交易日期
         A.TRA_AMT        AS TRA_AMT,     --交易金额
         A.TRA_TYP        AS TRA_TYP,     --交易类型
         A.TRA_CHAN       AS TRA_CHAN,    --交易渠道
         A.DEPT_LINE      AS DEPT_LINE,   --部门条线
         A.DATA_SRC       AS DATA_SRC     --数据来源
    FROM RRP_MDL.M_TRA_DEP_ACC_DTL A --存款账户交易流水
   WHERE A.TRA_MED_TYP = 'A' --卡
     AND A.DATA_DT = V_P_DATE;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  END IF;*/

  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  RRP_MDL.ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_S_CRD_TRA;
/

