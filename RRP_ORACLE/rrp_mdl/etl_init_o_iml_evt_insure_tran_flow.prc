CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IML_EVT_INSURE_TRAN_FLOW(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IML_EVT_INSURE_TRAN_FLOW
  *  功能描述：保险交易流水
  *  创建日期：20220619
  *  开发人员：梅炜
  *  来源表： IML.V_EVT_INSURE_TRAN_FLOW
  *  目标表： O_IML_EVT_INSURE_TRAN_FLOW
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IML_EVT_INSURE_TRAN_FLOW'; -- 程序名称
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
  -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IML_EVT_INSURE_TRAN_FLOW ;
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IML_EVT_INSURE_TRAN_FLOW';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-保险交易流水';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_INSURE_TRAN_FLOW
  (
    EVT_ID  --事件编号
    ,LP_ID  --法人编号
    ,TRAN_DT  --交易日期
    ,FLOW_NUM  --流水号
    ,RELA_FLOW_NUM  --关联流水号
    ,TA_CD  --TA代码
    ,STD_PROD_ID  --标准产品编号
    ,PROD_ID  --交易产品编号
    ,INSURE_PL_NUM  --保险单号
    ,CUST_MGR_ID  --客户经理编号
    ,CUST_ID  --交易客户编号
    ,CUST_TYPE_CD  --客户类型代码
    ,TRAN_CD  --交易代码
    ,TRAN_CD_NAME  --交易代码名称
    ,BANK_ACCT_ID  --银行账户编号
    ,VOUCH_TYPE_CD  --凭证类型代码
    ,VOUCH_ID  --凭证编号
    ,CURR_CD  --币种代码
    ,TRAN_AMT  --交易金额
    ,COMM_FEE  --手续费
    ,TRAN_ORG_ID  --交易机构编号
    ,OPERR_ID  --操作员编号
    ,AUTH_TELLER_ID  --授权柜员编号
    ,TRAN_CHN_CD  --交易渠道编号
    ,RETURN_CODE  --返回码
    ,RETURN_INFO  --返回信息
    ,POLICY_DT  --保单日期
    ,POLICY_CFM_FLOW_NUM  --保单确认流水号
    ,HOST_DT  --主机日期
    ,HOST_FLOW_NUM  --主机流水号
    ,HOST_TRAN_CD  --主机交易代码
    ,HOST_RETURN_CODE  --主机返回码
    ,HOST_RETURN_INFO  --主机返回信息
    ,TRAN_STATUS_CD  --交易状态代码
    ,TRAN_TM  --交易时间
    ,INSURE_PRINT_ID  --保险打印单编号
    ,START_DT  --开始日期
    ,END_DT  --结束日期
    ,ID_MARK  --删除标识
    )
    SELECT
    EVT_ID  --事件编号
    ,LP_ID  --法人编号
    ,TRAN_DT  --交易日期
    ,FLOW_NUM  --流水号
    ,RELA_FLOW_NUM  --关联流水号
    ,TA_CD  --TA代码
    ,STD_PROD_ID  --标准产品编号
    ,PROD_ID  --交易产品编号
    ,INSURE_PL_NUM  --保险单号
    ,CUST_MGR_ID  --客户经理编号
    ,CUST_ID  --交易客户编号
    ,CUST_TYPE_CD  --客户类型代码
    ,TRAN_CD  --交易代码
    ,TRAN_CD_NAME  --交易代码名称
    ,BANK_ACCT_ID  --银行账户编号
    ,VOUCH_TYPE_CD  --凭证类型代码
    ,VOUCH_ID  --凭证编号
    ,CURR_CD  --币种代码
    ,TRAN_AMT  --交易金额
    ,COMM_FEE  --手续费
    ,TRAN_ORG_ID  --交易机构编号
    ,OPERR_ID  --操作员编号
    ,AUTH_TELLER_ID  --授权柜员编号
    ,TRAN_CHN_CD  --交易渠道编号
    ,RETURN_CODE  --返回码
    ,RETURN_INFO  --返回信息
    ,POLICY_DT  --保单日期
    ,POLICY_CFM_FLOW_NUM  --保单确认流水号
    ,HOST_DT  --主机日期
    ,HOST_FLOW_NUM  --主机流水号
    ,HOST_TRAN_CD  --主机交易代码
    ,HOST_RETURN_CODE  --主机返回码
    ,HOST_RETURN_INFO  --主机返回信息
    ,TRAN_STATUS_CD  --交易状态代码
    ,TRAN_TM  --交易时间
    ,INSURE_PRINT_ID  --保险打印单编号
    ,START_DT  --开始日期
    ,END_DT  --结束日期
    ,ID_MARK  --删除标识
    FROM IML.V_EVT_INSURE_TRAN_FLOW  --视图-保险交易流水
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

  END ETL_INIT_O_IML_EVT_INSURE_TRAN_FLOW;
/

