CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_ICL_CMM_BANK_CARD_BASIC_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_ICL_CMM_BANK_CARD_BASIC_INFO
  *  功能描述：银行卡基本信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表： ICL.V_CMM_BANK_CARD_BASIC_INFO
  *  目标表： O_ICL_CMM_BANK_CARD_BASIC_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
                2    20220615           修改参数
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(500) := 'ETL_INIT_O_ICL_CMM_BANK_CARD_BASIC_INFO'; -- 程序名称
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
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_ICL_CMM_BANK_CARD_BASIC_INFO ;
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_ICL_CMM_BANK_CARD_BASIC_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := 0;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-银行卡基本信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_BANK_CARD_BASIC_INFO
  (      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,CARD_NO  --卡号
      ,VOUCH_NO  --凭证号码
      ,VOUCH_MGMT_ID  --凭证管理编号
      ,NC_CARD_NO  --无校验位卡号
      ,MAGT_CTRL_ID  --写磁控制编号
      ,CARD_NAME  --卡名称
      ,START_USE_FLG  --启用标志
      ,VTUAL_CARD_FLG  --虚拟卡标志
      ,VOUCH_KIND_CD  --凭证种类代码
      ,CARD_TYPE_CD  --卡种类代码
      ,CO_CARD_TYPE_CD  --合作卡类型代码
      ,CARD_STATUS_CD  --卡状态代码
      ,CARD_LEVEL_CD  --卡等级代码
      ,MAKE_CARD_FLOW_NUM  --制卡流水号
      ,MAKE_CARD_DT  --制卡日期
      ,EFFECT_DT  --生效日期
      ,INVALID_DT  --失效日期
      ,USE_BRCH_RANGE  --使用分行范围
      ,CARD_HOLDER_NAME  --持卡人名称
      ,CARD_HOLDER_CERT_TYPE_CD  --持卡人证件类型代码
      ,CARD_HOLDER_CERT_NO  --持卡人证件号码
      ,FINAL_TRAN_DT  --最后交易日期
      ,FINAL_TRAN_FLOW  --最后交易流水
      ,FINAL_OFFLINE_TRAN_DT  --最后脱机交易日期
      ,OFFLINE_TRAN_TOT_AMT  --脱机交易总金额
      ,BAL_UPLMI  --余额上限
      ,SIG_CASH_TRAN_LMT  --单笔现金交易限额
      ,AUTO_LOAD_TSHOLD  --自动圈存阀值
      ,AUTO_LOAD_AMT  --自动圈存金额
      ,ACM_LOAD_AMT  --累计圈存金额
      ,ACM_UNLOAD_AMT  --累计圈提金额
      ,CURR_BAL  --当前余额
      ,CUST_ID  --客户编号
      ,CARD_BIN  --卡BIN
    ,JOB_CD --任务代码
    )
    SELECT

      ETL_DT  --数据日期
      ,LP_ID  --法人编号
      ,CARD_NO  --卡号
      ,VOUCH_NO  --凭证号码
      ,VOUCH_MGMT_ID  --凭证管理编号
      ,NC_CARD_NO  --无校验位卡号
      ,MAGT_CTRL_ID  --写磁控制编号
      ,CARD_NAME  --卡名称
      ,START_USE_FLG  --启用标志
      ,VTUAL_CARD_FLG  --虚拟卡标志
      ,VOUCH_KIND_CD  --凭证种类代码
      ,CARD_TYPE_CD  --卡种类代码
      ,CO_CARD_TYPE_CD  --合作卡类型代码
      ,CARD_STATUS_CD  --卡状态代码
      ,CARD_LEVEL_CD  --卡等级代码
      ,MAKE_CARD_FLOW_NUM  --制卡流水号
      ,MAKE_CARD_DT  --制卡日期
      ,EFFECT_DT  --生效日期
      ,INVALID_DT  --失效日期
      ,USE_BRCH_RANGE  --使用分行范围
      ,CARD_HOLDER_NAME  --持卡人名称
      ,CARD_HOLDER_CERT_TYPE_CD  --持卡人证件类型代码
      ,CARD_HOLDER_CERT_NO  --持卡人证件号码
      ,FINAL_TRAN_DT  --最后交易日期
      ,FINAL_TRAN_FLOW  --最后交易流水
      ,FINAL_OFFLINE_TRAN_DT  --最后脱机交易日期
      ,OFFLINE_TRAN_TOT_AMT  --脱机交易总金额
      ,BAL_UPLMI  --余额上限
      ,SIG_CASH_TRAN_LMT  --单笔现金交易限额
      ,AUTO_LOAD_TSHOLD  --自动圈存阀值
      ,AUTO_LOAD_AMT  --自动圈存金额
      ,ACM_LOAD_AMT  --累计圈存金额
      ,ACM_UNLOAD_AMT  --累计圈提金额
      ,CURR_BAL  --当前余额
      ,CUST_ID  --客户编号
      ,CARD_BIN  --卡BIN
    ,JOB_CD --任务代码
    FROM ICL.V_CMM_BANK_CARD_BASIC_INFO  --视图-银行卡基本信息
   WHERE TRUNC(ETL_DT,'MM') = TRUNC(TO_DATE(V_P_DATE,'YYYYMMDD'),'MM')
    ;

   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
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

  END ETL_INIT_O_ICL_CMM_BANK_CARD_BASIC_INFO;
/

