CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU
  *  功能描述：中国债券信用评级表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

 --清理当天数据
  V_STEP_DESC  := '清理当天数据';
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU NOLOGGING
    ( SECU_INST_ID,               --
      SECU_INST_GRP_ID,           --
      INST_ID,                    --
      BIZ_TYPE,                   --
      DIRECTION,                  --
      TRADE_GRP_ID,               --
      SECU_ACCT_ID,               --
      EXT_SECU_ACCT_ID,           --
      I_CODE,                     --
      A_TYPE,                     --
      M_TYPE,                     --
      CURRENCY,                   --
      REAL_FEE,                   --
      ESTD_AI,                    --
      RECEIVED_AI,                --
      ESTD_CP,                    --
      REAL_AI,                    --
      REAL_CP,                    --
      DUE_AI,                     --
      DUE_CP,                     --
      PRFT_FEE,                   --
      IS_REMAIN_DUE_AI,           --
      IS_REMAIN_DUE_CP,           --
      VOLUME,                     --
      FREEZE_VOLUME,              --
      IS_FIXED,                   --
      CAL_DATE,                   --
      SET_DATE,                   --
      SET_FINISH_DATE,            --
      I_NAME,                     --
      P_CLASS,                    --
      COST,                       --
      COST_AI_HIS_REAL,           --
      ZZD_ACCT_CODE,              --
      PARTY_ZZD_ACCT_CODE,        --
      CREATE_TIME,                --
      UPDATE_TIME,                --
      UPDATE_USER,                --
      CONFIRM_TIME,               --
      CONFIRM_USER,               --
      ACCOUNT_TIME,               --
      ACCOUNT_USER,               --
      MEMO,                       --
      AMOUNT,                     --
      CLOSE_TRADE_ID,             --
      BLC_STATE,                  --
      ACCTG_STATE,                --
      ESTD_FEE,                   --
      FEE,                        --
      OPR_STATE,                  --
      SECU_INST_SETGRP_ID,        --
      HIS_FLAG,                   --
      HIS_SECU_INST_ID,           --
      HIS_SET_FINISH_DATE,        --
      ACCTG_INST_ID,              --
      CANCEL_FLAG,                --
      VOLUME_TERMCUR,             --
      AMOUNT_TERMCUR,             --
      ESTD_CP_TERMCUR,            --
      REAL_CP_TERMCUR,            --
      AMRT_METHOD,                --
      REAL_MARGIN,                --
      FPML,                       --
      IS_IMPAIR,                  --
      IS_THEORY_ACCT,             --
      IS_THEORY_BLC,              --
      CL_STATUS,                  --
      PARTY_PSET,                 --
      PARTY_PSET_COUNTRY,         --
      PARTY_AGENT_CODE_TYPE,      --
      PARTY_AGENT_CODE_DSS,       --
      PARTY_AGENT_CODE,           --
      PARTY_AGENT_ACCOUNT,        --
      PARTY_CODE_TYPE,            --
      PARTY_CODE_DSS,             --
      PARTY_CODE,                 --
      PARTY_ACCOUNT,              --
      ETL_DT                      --ETL处理日期
     )
  SELECT /*+PARALLEL*/
         SECU_INST_ID,               --
         SECU_INST_GRP_ID,           --
         INST_ID,                    --
         BIZ_TYPE,                   --
         DIRECTION,                  --
         TRADE_GRP_ID,               --
         SECU_ACCT_ID,               --
         EXT_SECU_ACCT_ID,           --
         I_CODE,                     --
         A_TYPE,                     --
         M_TYPE,                     --
         CURRENCY,                   --
         REAL_FEE,                   --
         ESTD_AI,                    --
         RECEIVED_AI,                --
         ESTD_CP,                    --
         REAL_AI,                    --
         REAL_CP,                    --
         DUE_AI,                     --
         DUE_CP,                     --
         PRFT_FEE,                   --
         IS_REMAIN_DUE_AI,           --
         IS_REMAIN_DUE_CP,           --
         VOLUME,                     --
         FREEZE_VOLUME,              --
         IS_FIXED,                   --
         CAL_DATE,                   --
         SET_DATE,                   --
         SET_FINISH_DATE,            --
         I_NAME,                     --
         P_CLASS,                    --
         COST,                       --
         COST_AI_HIS_REAL,           --
         ZZD_ACCT_CODE,              --
         PARTY_ZZD_ACCT_CODE,        --
         CREATE_TIME,                --
         UPDATE_TIME,                --
         UPDATE_USER,                --
         CONFIRM_TIME,               --
         CONFIRM_USER,               --
         ACCOUNT_TIME,               --
         ACCOUNT_USER,               --
         MEMO,                       --
         AMOUNT,                     --
         CLOSE_TRADE_ID,             --
         BLC_STATE,                  --
         ACCTG_STATE,                --
         ESTD_FEE,                   --
         FEE,                        --
         OPR_STATE,                  --
         SECU_INST_SETGRP_ID,        --
         HIS_FLAG,                   --
         HIS_SECU_INST_ID,           --
         HIS_SET_FINISH_DATE,        --
         ACCTG_INST_ID,              --
         CANCEL_FLAG,                --
         VOLUME_TERMCUR,             --
         AMOUNT_TERMCUR,             --
         ESTD_CP_TERMCUR,            --
         REAL_CP_TERMCUR,            --
         AMRT_METHOD,                --
         REAL_MARGIN,                --
         FPML,                       --
         IS_IMPAIR,                  --
         IS_THEORY_ACCT,             --
         IS_THEORY_BLC,              --
         CL_STATUS,                  --
         PARTY_PSET,                 --
         PARTY_PSET_COUNTRY,         --
         PARTY_AGENT_CODE_TYPE,      --
         PARTY_AGENT_CODE_DSS,       --
         PARTY_AGENT_CODE,           --
         PARTY_AGENT_ACCOUNT,        --
         PARTY_CODE_TYPE,            --
         PARTY_CODE_DSS,             --
         PARTY_CODE,                 --
         PARTY_ACCOUNT,              --
         ETL_DT                      --ETL处理日期
    FROM IOL.V_IBMS_VTRD_SET_INSTRUCTION_SECU   --券指令表(视图)_视图
     WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

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

  END ETL_O_IOL_IBMS_VTRD_SET_INSTRUCTION_SECU;
/

