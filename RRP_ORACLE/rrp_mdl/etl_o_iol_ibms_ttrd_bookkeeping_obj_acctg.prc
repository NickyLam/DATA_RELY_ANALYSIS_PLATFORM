CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_OBJ_ACCTG(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_OBJ_ACCTG
  *  功能描述：POS商户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_IBMS_TTRD_BOOKKEEPING_OBJ_ACCTG
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250106  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_OBJ_ACCTG'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE :=TO_CHAR( I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_BOOKKEEPING_OBJ_ACCTG';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-';
  V_STARTTIME := SYSDATE;
 INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_BOOKKEEPING_OBJ_ACCTG NOLOGGING
     (     TSK_ID  --
          ,BEG_DATE  --
          ,END_DATE  --
          ,SUBJ_ORG_ID  --
          ,SUBJ_CODE  --
          ,SUBJ_SUB_CODE  --
          ,INNER_ACCT_SN  --
          ,CORE_ACCT_CODE  --
          ,CURRENCY  --
          ,DEBIT_VALUE  --
          ,CREDIT_VALUE  --
          ,PAY_VALUE  --
          ,RECEIVE_VALUE  --
          ,SECU_ACCT_ID  --
          ,CASH_ACCT_ID  --
          ,UPDATE_TIME  --
          ,CORE_ACCT_NAME  --
          ,T_CURRENCY      --折算币种
          ,T_CREDIT_VALUE  --折算后贷方余额
          ,T_DEBIT_VALUE   --折算后借方余额
          ,ACCTG_OBJ_ID    --核算对象ID
          ,EXT_I_CODE      --金融工具代码
          ,EXT_A_TYPE      --金融工具资产类型
          ,EXT_M_TYPE      --金融工具市场类型
          ,EXT_DIM1        --扩展维度1
          ,EXT_DIM2        --扩展维度2
          ,EXT_DIM3        --扩展维度3
          ,EXT_DIM4        --扩展维度4
          ,EXT_DIM5        --扩展维度5
          ,EXT_DIM6        --扩展维度6
          ,START_DT        --开始时间
          ,END_DT          --结束时间
          ,ID_MARK         --增删标志
    )
  SELECT /*+PARALLEL*/
         TSK_ID  --
        ,BEG_DATE  --
        ,END_DATE  --
        ,SUBJ_ORG_ID  --
        ,SUBJ_CODE  --
        ,SUBJ_SUB_CODE  --
        ,INNER_ACCT_SN  --
        ,CORE_ACCT_CODE  --
        ,CURRENCY  --
        ,DEBIT_VALUE  --
        ,CREDIT_VALUE  --
        ,PAY_VALUE  --
        ,RECEIVE_VALUE  --
        ,SECU_ACCT_ID  --
        ,CASH_ACCT_ID  --
        ,UPDATE_TIME  --
        ,CORE_ACCT_NAME  --
        ,T_CURRENCY      --折算币种
        ,T_CREDIT_VALUE  --折算后贷方余额
        ,T_DEBIT_VALUE   --折算后借方余额
        ,ACCTG_OBJ_ID    --核算对象ID
        ,EXT_I_CODE      --金融工具代码
        ,EXT_A_TYPE      --金融工具资产类型
        ,EXT_M_TYPE      --金融工具市场类型
        ,EXT_DIM1        --扩展维度1
        ,EXT_DIM2        --扩展维度2
        ,EXT_DIM3        --扩展维度3
        ,EXT_DIM4        --扩展维度4
        ,EXT_DIM5        --扩展维度5
        ,EXT_DIM6        --扩展维度6
        ,START_DT        --开始时间
        ,END_DT          --结束时间
        ,ID_MARK         --增删标志
    FROM IOL.V_IBMS_TTRD_BOOKKEEPING_OBJ_ACCTG   --待定_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D' ;


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

  END ETL_O_IOL_IBMS_TTRD_BOOKKEEPING_OBJ_ACCTG;
/

