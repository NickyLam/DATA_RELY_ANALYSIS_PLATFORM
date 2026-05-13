CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_NOSTRO_ACCT_INFO(I_P_DATE IN INTEGER,
                                                           O_ERRCODE OUT VARCHAR2
                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_NOSTRO_ACCT_INFO
  *  功能描述：存放同业账户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_NOSTRO_ACCT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_NOSTRO_ACCT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_NOSTRO_ACCT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_NOSTRO_ACCT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-存放同业账户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_NOSTRO_ACCT_INFO
    (  ETL_DT			                         --数据日期
      ,LP_ID			                         --法人编号
      ,CUST_ACCT_ID			                   --客户账户编号
      ,CUST_SUB_ACCT_ID			               --客户账户子户编号
      ,IBANK_OBJ_ID			                   --同业对象编号
      ,ASSET_UNIQ_IDF_ID			             --资产唯一标识编号
      ,CUST_ID			                       --客户编号
      ,SUBJ_ID			                       --科目编号
      ,STD_PROD_ID			                   --标准产品编号
      ,INT_RECVBL_SUBJ_ID			             --应收利息科目编号
      ,ACCT_NAME			                     --账户名称
      ,OPEN_BANK_NAME			                 --开户行名称
      ,OPEN_BANK_LP_ORG_CUST_ID			       --开户行法人机构客户编号
      ,OPEN_BANK_LP_NAME			             --开户行法人名称
      ,OPEN_ACCT_ORG_ID			               --开户机构编号
      ,OPEN_DT			                       --开户日期
      ,OPEN_FLOW_NUM			                 --开户流水号
      ,CLOS_ACCT_DT			                   --销户日期
      ,CLOS_ACCT_FLOW_NUM			             --销户流水号
      ,ACCT_CLS_CD			                   --账户分类代码
      ,ACCT_CHAR_CD			                   --账户性质代码
      ,ACCT_CHAR_DESCB			               --账户性质描述
      ,ACCT_ATTR_DESCB			               --账户属性描述
      ,OBANK_OPEN_ORG_DIST			           --他行开户机构行政区划
      ,OBANK_NATION			                   --他行国籍
      ,OBANK_CNTPTY_CLS			               --他行交易对手分类
      ,OBANK_OPEN_ORG_LP_NAME			         --他行开户机构法人名称
      ,OBANK_OPEN_ORG_ID			             --他行开户机构编号
      ,OBANK_BANK_NO			                 --他行银行行号
      ,OBANK_SWIFT_ID			                 --他行SWIFT编号
      ,OBANK_ACCT_ID			                 --他行账户编号
      ,OBANK_ACCT_NAME		                 --他行账户名称
      ,OBANK_CURR_BAL			                 --他行当前余额
      ,OBANK_OPEN_DT			                 --他行开户日期
      ,OBANK_CLOS_ACCT_DT			             --他行销户日期
      ,INT_START_DT			                   --计息开始日期
      ,INT_END_DT			                     --计息结束日期
      ,EXP_DT			                         --到期日期
      ,ACCT_STATUS_CD			                 --账户状态代码
      ,USE_RANGE_CD			                   --使用范围代码
      ,CURR_CD			                       --币种代码
      ,BASE_RAT			                       --基准利率
      ,INT_RAT_FLOAT_WAY_CD		             --利率浮动方式代码
      ,INT_ACCR_BASE_CD			               --计息基准代码
      ,CAP_CHAR_CD			                   --资金性质代码
      ,PAY_INT_FREQ			                   --付息频率
      ,INT_RAT_FLO_VAL			               --利率浮动值
      ,EXEC_INT_RAT			                   --执行利率
      ,INT_RECVBL			                     --应收利息
      ,CURRT_ACRU_INT		                 	 --当期应计利息
      ,TD_ACRU_INT			                   --当日应计利息
      ,CURRT_BAL			                     --当期余额
      ,CL_CURR_CURRT_BAL			             --折本币当期余额
      ,JOB_CD			                         --任务代码
      ,ETL_TIMESTAMP			                 --数据处理时间
      ,ACCT_USAGE_CD			
    )
  SELECT 
       ETL_DT			                         --数据日期
      ,LP_ID			                         --法人编号
      ,CUST_ACCT_ID			                   --客户账户编号
      ,CUST_SUB_ACCT_ID			               --客户账户子户编号
      ,IBANK_OBJ_ID			                   --同业对象编号
      ,ASSET_UNIQ_IDF_ID			             --资产唯一标识编号
      ,CUST_ID			                       --客户编号
      ,SUBJ_ID			                       --科目编号
      ,STD_PROD_ID			                   --标准产品编号
      ,INT_RECVBL_SUBJ_ID			             --应收利息科目编号
      ,ACCT_NAME			                     --账户名称
      ,OPEN_BANK_NAME			                 --开户行名称
      ,OPEN_BANK_LP_ORG_CUST_ID			       --开户行法人机构客户编号
      ,OPEN_BANK_LP_NAME			             --开户行法人名称
      ,OPEN_ACCT_ORG_ID			               --开户机构编号
      ,OPEN_DT			                       --开户日期
      ,OPEN_FLOW_NUM			                 --开户流水号
      ,CLOS_ACCT_DT			                   --销户日期
      ,CLOS_ACCT_FLOW_NUM			             --销户流水号
      ,ACCT_CLS_CD			                   --账户分类代码
      ,ACCT_CHAR_CD			                   --账户性质代码
      ,ACCT_CHAR_DESCB			               --账户性质描述
      ,ACCT_ATTR_DESCB			               --账户属性描述
      ,OBANK_OPEN_ORG_DIST			           --他行开户机构行政区划
      ,OBANK_NATION			                   --他行国籍
      ,OBANK_CNTPTY_CLS			               --他行交易对手分类
      ,OBANK_OPEN_ORG_LP_NAME			         --他行开户机构法人名称
      ,OBANK_OPEN_ORG_ID			             --他行开户机构编号
      ,OBANK_BANK_NO			                 --他行银行行号
      ,OBANK_SWIFT_ID			                 --他行SWIFT编号
      ,OBANK_ACCT_ID			                 --他行账户编号
      ,OBANK_ACCT_NAME		                 --他行账户名称
      ,OBANK_CURR_BAL			                 --他行当前余额
      ,OBANK_OPEN_DT			                 --他行开户日期
      ,OBANK_CLOS_ACCT_DT			             --他行销户日期
      ,INT_START_DT			                   --计息开始日期
      ,INT_END_DT			                     --计息结束日期
      ,EXP_DT			                         --到期日期
      ,ACCT_STATUS_CD			                 --账户状态代码
      ,USE_RANGE_CD			                   --使用范围代码
      ,CURR_CD			                       --币种代码
      ,BASE_RAT			                       --基准利率
      ,INT_RAT_FLOAT_WAY_CD		             --利率浮动方式代码
      ,INT_ACCR_BASE_CD			               --计息基准代码
      ,CAP_CHAR_CD			                   --资金性质代码
      ,PAY_INT_FREQ			                   --付息频率
      ,INT_RAT_FLO_VAL			               --利率浮动值
      ,EXEC_INT_RAT			                   --执行利率
      ,INT_RECVBL			                     --应收利息
      ,CURRT_ACRU_INT		                 	 --当期应计利息
      ,TD_ACRU_INT			                   --当日应计利息
      ,CURRT_BAL			                     --当期余额
      ,CL_CURR_CURRT_BAL			             --折本币当期余额
      ,JOB_CD			                         --任务代码
      ,ETL_TIMESTAMP			                 --数据处理时间
      ,ACCT_USAGE_CD			
    FROM ICL.V_CMM_NOSTRO_ACCT_INFO  --视图-存放同业账户信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_ICL_CMM_NOSTRO_ACCT_INFO;
/

