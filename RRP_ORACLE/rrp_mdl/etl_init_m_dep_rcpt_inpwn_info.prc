CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_M_DEP_RCPT_INPWN_INFO
( I_P_DATE IN INTEGER, --跑批日期
  O_ERRCODE  OUT VARCHAR2 --错误代码
)
/******************************
**存储过程详细说明：存单质押信息
**存储过程名称：ETL_INIT_M_DEP_RCPT_INPWN_INFO
**存储过程创建日期：2022-11-22
**存储过程创建人：徐畅欣
**目的：
**输入参数：I_P_DATE
**输出参数：O_ERRCODE
**返回值：O_ERRCODE
** 修改日期    修改项目   修改原因   修改人
********************************************
  *******************************/
 AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(200) := 'ETL_INIT_M_DEP_RCPT_INPWN_INFO'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE; -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME VARCHAR2(100) ;   --表名
  V_PART_NAME VARCHAR2(100);   --分区名
  V_START_DT CHAR(8) ;       --月初日期
BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写
  V_TAB_NAME := 'M_DEP_RCPT_INPWN_INFO'; --表名
  V_PART_NAME := 'PARTITION_'||V_P_DATE;
 -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --判断跑批频度--


  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;

  --初始化表增加分区
  V_STEP_DESC := '初始化表增加分区';
  V_START_DT := SUBSTR(V_P_DATE,0,6)||'01';
  WHILE TO_DATE(V_START_DT,'YYYYMMDD') <= TO_DATE(V_P_DATE,'YYYYMMDD')
  LOOP
  ETL_PARTITION_ADD(V_START_DT,V_TAB_NAME, '1', O_ERRCODE);
  V_START_DT := TO_CHAR(TO_DATE(V_START_DT,'YYYYMMDD')  + 1 ,'YYYYMMDD');
  END LOOP;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  --删除当前分区数据

  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '插入本行存单质押信息';
  V_STARTTIME := SYSDATE;

  INSERT /*+APPEND */ INTO RRP_MDL.M_DEP_RCPT_INPWN_INFO NOLOGGING (
        ASSET_ID,--资产编号
        DATA_DT,--数据日期,
        LP_ID,--法人编号
        DEP_RCPT_VOUCH_NUM,--存单凭证号
        AVAL_AMT,--可用金额
        ACCT_ID,--客户账号编号
        EFFECT_DT,--生效日期
        EXP_DT,--到期日期
        ACCT_BAL,--账户余额
        CUST_SUB_ACCT_NUM,--客户子账户号
        STOP_PAY_ADVISE_ID,--止付通知书编号
        CURR_CD,--币种代码
        DEP_TERM_CD,--存期代码
        INT_RAT,--利率
        REMARK,--备注
        ID_MARK,--增删标志
        SRC_TABLE_NAME,--源表名称
        JOB_CD,--任务编码
        GHB_DEP_FLG--本行存单标志
        )
  SELECT A.ASSET_ID,--资产编号
      V_P_DATE,
      A.LP_ID,--法人编号
      A.DEP_RCPT_VOUCH_NUM,--存单凭证号
      A.AVAL_AMT,--可用金额
      --A.CUST_ACCT_NUM_ID || B.OLD_CUST_ACCT_SUB_ACCT_NUM , --客户账户编号 md by 20221124 xucx
      A.CUST_ACCT_NUM_ID || A.CUST_SUB_ACCT_NUM,--客户账户编号
      TO_CHAR(A.EFFECT_DT,'YYYYMMDD'),--生效日期
      TO_CHAR(A.EXP_DT,'YYYYMMDD'),--到期日期
      A.ACCT_BAL,--账户余额
      NULL,--客户子账户号
      A.STOP_PAY_ADVISE_ID,--止付通知书编号
      A.CURR_CD,--币种代码
      A.DEP_TERM_CD,--存期代码
      A.INT_RAT,--利率
      A.REMARK,--备注
      A.ID_MARK,--增删标志
      A.SRC_TABLE_NAME,--源表名称
      A.JOB_CD,  --任务编码
      'Y' GHB_DEP_FLG  --本行存单标志
    FROM RRP_MDL.O_IML_AST_GHB_DEP_RCPT_INPWN_INFO A --本行存单质押信息
/*    LEFT JOIN RRP_MDL.O_ICL_CMM_DEP_ACCT_INFO B --存款分户信息表
    ON B.CUST_ACCT_ID = A.CUST_ACCT_NUM_ID
    AND B.CUST_ACCT_SUB_ACCT_NUM = A.CUST_SUB_ACCT_NUM
    AND B.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/
    WHERE A.START_DT <= TO_DATE(V_P_DATE,'YYYY/MM/DD')
    AND A.END_DT > TO_DATE(V_P_DATE,'YYYY/MM/DD')
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '插入他行存单质押信息';
  V_STARTTIME := SYSDATE;

  INSERT /*+APPEND */ INTO RRP_MDL.M_DEP_RCPT_INPWN_INFO NOLOGGING (
        ASSET_ID,--资产编号
        DATA_DT,--数据日期,
        LP_ID,--法人编号
        DEP_RCPT_VOUCH_NUM,--存单凭证号
        AVAL_AMT,--可用金额
        ACCT_ID,--客户账号编号
        EFFECT_DT,--生效日期
        EXP_DT,--到期日期
        ACCT_BAL,--账户余额
        CUST_SUB_ACCT_NUM,--客户子账户号
        STOP_PAY_ADVISE_ID,--止付通知书编号
        CURR_CD,--币种代码
        DEP_TERM_CD,--存期代码
        INT_RAT,--利率
        REMARK,--备注
        ID_MARK,--增删标志
        SRC_TABLE_NAME,--源表名称
        JOB_CD,--任务编码
        GHB_DEP_FLG--本行存单标志
        )
  SELECT A.ASSET_ID,--资产编号
      V_P_DATE,
      A.LP_ID,--法人编号
      A.VOUCH_ID,--存单凭证号
      A.AVAL_AMT,--可用金额
      NULL,
      TO_CHAR(A.EFFECT_DT,'YYYYMMDD'),--生效日期
      TO_CHAR(A.EXP_DT,'YYYYMMDD'),--到期日期
      A.PRIC_AMT,--账户余额
      NULL,--A.CUST_SUB_ACCT_NUM,--客户子账户号 --外部评级日期
      NULL,--A.STOP_PAY_ADVISE_ID,--止付通知书编号
      A.CURR_CD,--币种代码
      NULL,--A.DEP_TERM_CD,--存期代码
      A.INT_RAT,--利率
      A.REMARK,--备注
      A.ID_MARK,--增删标志
      A.SRC_TABLE_NAME,--源表名称
      A.JOB_CD,  --任务编码
      'N' GHB_DEP_FLG  --本行存单标志
    FROM RRP_MDL.O_IML_AST_OBANK_DEP_RCPT_INPWN_INFO A --他行存单质押信息
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYY/MM/DD')
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

        -- 去掉表的主键，通过语句判断数据是否重复--
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '查询数据是否重复';

  WITH TMP1 AS (
    SELECT DATA_DT, ASSET_ID,COUNT(1)
      FROM M_DEP_RCPT_INPWN_INFO T
     WHERE DATA_DT = V_P_DATE
    GROUP BY DATA_DT, ASSET_ID
    HAVING COUNT(1) > 1)
  SELECT NVL(COUNT(1),0) INTO V_SQLCOUNT FROM TMP1 ;

  IF V_SQLCOUNT > 0 THEN
     O_ERRCODE   := '1';
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
     RETURN;
  END IF;

 -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,
                V_SYSTEM,
                V_PROC_NAME,
                V_STARTTIME,
                V_ENDTIME,
                V_STEP,
                V_STEP_DESC,
                V_SQLCOUNT,
                O_ERRCODE,
                '');

  -- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
    ROLLBACK;
    O_ERRCODE   := '1';
    V_ENDTIME   := SYSDATE;
    V_STEP      := V_STEP + 1;
    V_STEP_DESC := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,
                  V_SYSTEM,
                  V_PROC_NAME,
                  V_STARTTIME,
                  V_ENDTIME,
                  V_STEP,
                  V_STEP_DESC,
                  V_SQLCOUNT,
                  O_ERRCODE,
                  V_SQLMSG);

END ETL_INIT_M_DEP_RCPT_INPWN_INFO;
/

