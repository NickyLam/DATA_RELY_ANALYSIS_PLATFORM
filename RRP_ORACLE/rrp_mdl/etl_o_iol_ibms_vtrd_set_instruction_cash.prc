CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_VTRD_SET_INSTRUCTION_CASH(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_VTRD_SET_INSTRUCTION_CASH
  *  功能描述：POS商户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_IBMS_VTRD_SET_INSTRUCTION_CASH
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_VTRD_SET_INSTRUCTION_CASH'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

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
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_IBMS_VTRD_SET_INSTRUCTION_CASH';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-POS商户信息';
  V_STARTTIME := SYSDATE;
 INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_VTRD_SET_INSTRUCTION_CASH NOLOGGING
  (  CASH_INST_ID    --
    ,INST_ID    --
    ,CASH_INST_GRP_ID    --
    ,BIZ_TYPE    --
    ,DIRECTION    --
    ,CASH_ACCT_ID    --
    ,EXT_CASH_ACCT_ID    --
    ,CURRENCY    --
    ,AMOUNT    --
    ,FREEZE_AMOUNT    --
    ,SET_DATE    --
    ,SET_FINISH_DATE    --
    ,TRANSFER_TYPE    --
    ,ACCT_CODE    --
    ,ACCT_NAME    --
    ,BANK_CODE    --
    ,BANK_NAME    --
    ,PARTY_ACCT_CODE    --
    ,PARTY_ACCT_NAME    --
    ,PARTY_BANK_CODE    --
    ,PARTY_BANK_NAME    --
    ,CREATE_TIME    --
    ,UPDATE_TIME    --
    ,UPDATE_USER    --
    ,ACCOUNT_TIME    --
    ,ACCOUNT_USER    --
    ,MEMO    --
    ,BLC_STATE    --
    ,ACCTG_STATE    --
    ,OPR_STATE    --
    ,CASH_INST_SETGRP_ID    --
    ,ACCTG_INST_ID    --
    ,CANCEL_FLAG    --
    ,IS_THEORY_BLC    --
    ,NOSTRO_REF_CASH_INST_ID    --
    ,PENDING_FLOW_NO    --
    ,PENDING_DATE    --
    ,IS_THEORY_ACCT    --
    ,MID_BANK_ACCT_CODE    --
    ,MID_BANK_NAME    --
    ,MID_SWIFT_CODE    --
    ,SWIFT_CODE    --
    ,PARTY_SWIFT_CODE    --
    ,PARTY_MID_BANK_ACCT_CODE    --
    ,PARTY_MID_BANK_NAME    --
    ,PARTY_MID_SWIFT_CODE    --
    ,CL_STATUS    --
    ,ETL_DT    --ETL处理日期

    )
  SELECT /*+PARALLEL*/
      CASH_INST_ID    --
      ,INST_ID    --
      ,CASH_INST_GRP_ID    --
      ,BIZ_TYPE    --
      ,DIRECTION    --
      ,CASH_ACCT_ID    --
      ,EXT_CASH_ACCT_ID    --
      ,CURRENCY    --
      ,AMOUNT    --
      ,FREEZE_AMOUNT    --
      ,SET_DATE    --
      ,SET_FINISH_DATE    --
      ,TRANSFER_TYPE    --
      ,ACCT_CODE    --
      ,ACCT_NAME    --
      ,BANK_CODE    --
      ,BANK_NAME    --
      ,PARTY_ACCT_CODE    --
      ,PARTY_ACCT_NAME    --
      ,PARTY_BANK_CODE    --
      ,PARTY_BANK_NAME    --
      ,CREATE_TIME    --
      ,UPDATE_TIME    --
      ,UPDATE_USER    --
      ,ACCOUNT_TIME    --
      ,ACCOUNT_USER    --
      ,MEMO    --
      ,BLC_STATE    --
      ,ACCTG_STATE    --
      ,OPR_STATE    --
      ,CASH_INST_SETGRP_ID    --
      ,ACCTG_INST_ID    --
      ,CANCEL_FLAG    --
      ,IS_THEORY_BLC    --
      ,NOSTRO_REF_CASH_INST_ID    --
      ,PENDING_FLOW_NO    --
      ,PENDING_DATE    --
      ,IS_THEORY_ACCT    --
      ,MID_BANK_ACCT_CODE    --
      ,MID_BANK_NAME    --
      ,MID_SWIFT_CODE    --
      ,SWIFT_CODE    --
      ,PARTY_SWIFT_CODE    --
      ,PARTY_MID_BANK_ACCT_CODE    --
      ,PARTY_MID_BANK_NAME    --
      ,PARTY_MID_SWIFT_CODE    --
      ,CL_STATUS    --
      ,ETL_DT    --ETL处理日期

    FROM IOL.V_IBMS_VTRD_SET_INSTRUCTION_CASH   --资金指令表(视图)_视图
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

  END ETL_O_IOL_IBMS_VTRD_SET_INSTRUCTION_CASH;
/

