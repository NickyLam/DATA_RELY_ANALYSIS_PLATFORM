CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H
  *  功能描述：证券账户核算余额变动历史
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
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
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMMDD');
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-证券账户核算余额变动历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H
  (
          AGT_ID
        ,LP_ID
        ,CHG_ID
        ,TASK_ID
        ,REVO_RELA_CHG_ID
        ,CHG_DT
        ,CHG_TYPE_CD
        ,ACCTI_OBJ_ID
        ,INSTR_ID
        ,EXT_VCH_ACCT_ID
        ,INTNAL_VCH_ACCT_ID
        ,COMB_TRAN_ID
        ,FIN_INSTM_ID
        ,ASSET_TYPE_ID
        ,MARKET_TYPE_ID
        ,TRAN_NUM
        ,EXTRA_DIMEN_CD
        ,ACCTI_TYPE_CD
        ,ACTL_QTTY
        ,ACTL_BAL
        ,NET_PRICE_COST
        ,ACRU_INT
        ,INT_COST
        ,ACRU_TURN_RECVBL_UNCOL
        ,RECVBL_UNCOL_TURN_ACTL_RECV
        ,ACRU_INT_THEORY_ATTACH_PROVI
        ,ACRU_INT_ACTL_ATTACH_PROVI
        ,EVHA_VAL_CHAG
        ,FAIR_VAL_PL_ASSET
        ,FAIR_VAL_PL_LIAB
        ,RECVBL_UNCOL_BAL
        ,RECVBL_UNCOL_NET_PRICE_COST
        ,RECVBL_UNCOL_ACRU_INT
        ,TD_AMORT_BUS_CNT
        ,AMORT_DT
        ,INT_ADJ_AMT
        ,FAIR_VAL_PL
        ,BS_PL
        ,INT_INCOME
        ,ACRU_INT_INT_INCOME
        ,AMORT_INT_INCOME
        ,CURR_POST_ACRU_INT_INT_INCOME
        ,CURR_POST_AMORT_INT_INCOME
        ,RECLAFY_FAIR_VAL_PL
        ,FUTURES_MARGIN
        ,UPDATE_TM
        ,FEE
        ,PAYBL_FEE
        ,FEE_COST
        ,AMORT_NET_PRICE_COST
        ,AMORT_INT_COST
        ,BUS_DT
        ,H_AMORT_START_DT
        ,ACTL_INT_RAT
        ,INVEST_YLD_RAT
        ,OPEN_YLD_RAT
        ,PRE_RECV_INT
        ,NON_AMORT_NET_PRICE_COST
        ,NON_AMORT_EVHA_VAL_CHAG
        ,NON_AMORT_FAIR_VAL_PL
        ,NON_AMORT_BS_PL
        ,RESET_BF_AMORT_DT
        ,RESET_POST_AMORT_CLOSING_DT
        ,RESET_BF_AMORT_CLOSING_DT
        ,WRTN_OFF_COST
        ,WRTN_OFF_ACRU_INT
        ,WRTN_OFF_RECVBL_UNCOL_INT
        ,OFF_BS_ACRU_INT
        ,OFF_BS_RECVBL_UNCOL_INT
        ,ACRU_INT_AMT
        ,ACRU_VAT
        ,PAYBL_VAT
        ,RESET_BF_EVLTION_CURR_CD
        ,RESET_POST_EVLTION_CURR_CD
        ,STL_DT
        ,RLIZD_EVHA_VAL_CHAG_PL
        ,CURR_POST_INT_TAX
        ,OPEN_INT_COST
        ,OPEN_EX_YLD_RAT
        ,PRE_TAX_PRE_RECV_INT_INCOME
        ,PROVI_INT_INCOME
        ,INT_RECVBL_INCO
        ,ACTL_RECV_INT_INCOME
        ,PROVI_INT_INCOME_PRE_RECV_TAX
        ,AMORT_INT_INCOME_PAYBL_VAT
        ,BS_PL_PAYBL_VAT
        ,OFFSET_DLVY_DT
        ,RESET_BF_OFFSET_DLVY_DT
        ,EXT_DIMEN_INFO
        ,INT_INCOME_ESTIM_TAX
        ,INT_INCOME_PAYBL_VAT
        ,PL_OBJ_ID
        ,OLD_PL_OBJ_ID
        ,AT_PRE_RECV_INT_INCOME
        ,START_DT
        ,END_DT
        ,ID_MARK
        ,SRC_TABLE_NAME
        ,JOB_CD
        ,ETL_TIMESTAMP

    )
    SELECT

         AGT_ID
        ,LP_ID
        ,CHG_ID
        ,TASK_ID
        ,REVO_RELA_CHG_ID
        ,CHG_DT
        ,CHG_TYPE_CD
        ,ACCTI_OBJ_ID
        ,INSTR_ID
        ,EXT_VCH_ACCT_ID
        ,INTNAL_VCH_ACCT_ID
        ,COMB_TRAN_ID
        ,FIN_INSTM_ID
        ,ASSET_TYPE_ID
        ,MARKET_TYPE_ID
        ,TRAN_NUM
        ,EXTRA_DIMEN_CD
        ,ACCTI_TYPE_CD
        ,ACTL_QTTY
        ,ACTL_BAL
        ,NET_PRICE_COST
        ,ACRU_INT
        ,INT_COST
        ,ACRU_TURN_RECVBL_UNCOL
        ,RECVBL_UNCOL_TURN_ACTL_RECV
        ,ACRU_INT_THEORY_ATTACH_PROVI
        ,ACRU_INT_ACTL_ATTACH_PROVI
        ,EVHA_VAL_CHAG
        ,FAIR_VAL_PL_ASSET
        ,FAIR_VAL_PL_LIAB
        ,RECVBL_UNCOL_BAL
        ,RECVBL_UNCOL_NET_PRICE_COST
        ,RECVBL_UNCOL_ACRU_INT
        ,TD_AMORT_BUS_CNT
        ,AMORT_DT
        ,INT_ADJ_AMT
        ,FAIR_VAL_PL
        ,BS_PL
        ,INT_INCOME
        ,ACRU_INT_INT_INCOME
        ,AMORT_INT_INCOME
        ,CURR_POST_ACRU_INT_INT_INCOME
        ,CURR_POST_AMORT_INT_INCOME
        ,RECLAFY_FAIR_VAL_PL
        ,FUTURES_MARGIN
        ,UPDATE_TM
        ,FEE
        ,PAYBL_FEE
        ,FEE_COST
        ,AMORT_NET_PRICE_COST
        ,AMORT_INT_COST
        ,BUS_DT
        ,H_AMORT_START_DT
        ,ACTL_INT_RAT
        ,INVEST_YLD_RAT
        ,OPEN_YLD_RAT
        ,PRE_RECV_INT
        ,NON_AMORT_NET_PRICE_COST
        ,NON_AMORT_EVHA_VAL_CHAG
        ,NON_AMORT_FAIR_VAL_PL
        ,NON_AMORT_BS_PL
        ,RESET_BF_AMORT_DT
        ,RESET_POST_AMORT_CLOSING_DT
        ,RESET_BF_AMORT_CLOSING_DT
        ,WRTN_OFF_COST
        ,WRTN_OFF_ACRU_INT
        ,WRTN_OFF_RECVBL_UNCOL_INT
        ,OFF_BS_ACRU_INT
        ,OFF_BS_RECVBL_UNCOL_INT
        ,ACRU_INT_AMT
        ,ACRU_VAT
        ,PAYBL_VAT
        ,RESET_BF_EVLTION_CURR_CD
        ,RESET_POST_EVLTION_CURR_CD
        ,STL_DT
        ,RLIZD_EVHA_VAL_CHAG_PL
        ,CURR_POST_INT_TAX
        ,OPEN_INT_COST
        ,OPEN_EX_YLD_RAT
        ,PRE_TAX_PRE_RECV_INT_INCOME
        ,PROVI_INT_INCOME
        ,INT_RECVBL_INCO
        ,ACTL_RECV_INT_INCOME
        ,PROVI_INT_INCOME_PRE_RECV_TAX
        ,AMORT_INT_INCOME_PAYBL_VAT
        ,BS_PL_PAYBL_VAT
        ,OFFSET_DLVY_DT
        ,RESET_BF_OFFSET_DLVY_DT
        ,EXT_DIMEN_INFO
        ,INT_INCOME_ESTIM_TAX
        ,INT_INCOME_PAYBL_VAT
        ,PL_OBJ_ID
        ,OLD_PL_OBJ_ID
        ,AT_PRE_RECV_INT_INCOME
        ,START_DT
        ,END_DT
        ,ID_MARK
        ,SRC_TABLE_NAME
        ,JOB_CD
        ,ETL_TIMESTAMP
    FROM IML.V_AGT_SECU_ACCT_ACCTI_BAL_CHG_H --视图-证券账户核算余额变动历史
     WHERE START_DT <= TO_DATE(I_P_DATE,'YYYYMMDD')
      AND END_DT > TO_DATE(I_P_DATE,'YYYYMMDD');


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

  END ETL_INIT_O_IML_AGT_SECU_ACCT_ACCTI_BAL_CHG_H;
/

