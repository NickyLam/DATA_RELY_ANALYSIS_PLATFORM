CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_RETL_LOAN_BUS_CONT_ATTACH_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：零售贷款业务合同补充信息
  **存储过程名称：    ETL_O_ICL_CMM_RETL_LOAN_BUS_CONT_ATTACH_INFO
  **存储过程创建日期：20250303
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250303    YJY        创建
     20250414    YJY        新增管理柜员编号
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_ICL_CMM_RETL_LOAN_BUS_CONT_ATTACH_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_RETL_LOAN_BUS_CONT_ATTACH_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-零售贷款业务合同补充信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_ICL_CMM_RETL_LOAN_BUS_CONT_ATTACH_INFO NOLOGGING 
  (   ETL_DT			                --数据日期
     ,LP_ID			                  --法人编号
     ,CONT_ID			                --合同编号
     ,CONT_NAME			              --合同名称
     ,CUST_ID			                --客户编号
     ,LMT_CONT_ID		              --额度合同编号
     ,OPER_TELLER_ID	            --经办柜员编号
     ,CONT_TYPE_CD		            --合同类型代码
     ,LEVEL5_CLS_CD		            --五级分类代码
     ,INT_RAT_MODE_CD	            --利率模式代码
     ,OCUP_OPEN_LMT_RISK_TYPE_CD	--占用敞口额度风险类型代码
     ,CONT_BAL			              --合同余额
     ,MARGIN_AMT			            --保证金金额
     ,RGST_DT			                --登记日期
     ,LOAN_USAGE_DESCB			      --贷款用途描述
     ,REMARK			                --备注
     ,RECVBL_BANK_CARD_CARD_NO		--收款银行卡卡号
     ,RECVBL_BANK_CARD_NAME			  --收款银行卡名称
     ,RECVBL_BANK_NO			        --收款银行行号
     ,RECVBL_BANK_NAME			      --收款银行名称
     ,REPAY_BANK_CARD_NUM			    --还款银行卡号
     ,REPAY_BANK_CARD_NAME		  	--还款银行卡名称
     ,REPAY_BANK_NO			          --还款银行行号
     ,REPAY_BANK_NAME			        --还款银行名称
     ,JOB_CD			                --任务代码
     ,ETL_TIMESTAMP			          --数据处理时间
     ,MGMT_TELLER_ID              --管理柜员编号  ADD BY YJY 20250414
    )
    SELECT
      ETL_DT			                --数据日期
     ,LP_ID			                  --法人编号
     ,CONT_ID			                --合同编号
     ,CONT_NAME			              --合同名称
     ,CUST_ID			                --客户编号
     ,LMT_CONT_ID		              --额度合同编号
     ,OPER_TELLER_ID	            --经办柜员编号
     ,CONT_TYPE_CD		            --合同类型代码
     ,LEVEL5_CLS_CD		            --五级分类代码
     ,INT_RAT_MODE_CD	            --利率模式代码
     ,OCUP_OPEN_LMT_RISK_TYPE_CD	--占用敞口额度风险类型代码
     ,CONT_BAL			              --合同余额
     ,MARGIN_AMT			            --保证金金额
     ,RGST_DT			                --登记日期
     ,LOAN_USAGE_DESCB			      --贷款用途描述
     ,REMARK			                --备注
     ,RECVBL_BANK_CARD_CARD_NO		--收款银行卡卡号
     ,RECVBL_BANK_CARD_NAME			  --收款银行卡名称
     ,RECVBL_BANK_NO			        --收款银行行号
     ,RECVBL_BANK_NAME			      --收款银行名称
     ,REPAY_BANK_CARD_NUM			    --还款银行卡号
     ,REPAY_BANK_CARD_NAME		  	--还款银行卡名称
     ,REPAY_BANK_NO			          --还款银行行号
     ,REPAY_BANK_NAME			        --还款银行名称
     ,JOB_CD			                --任务代码
     ,ETL_TIMESTAMP			          --数据处理时间
     ,MGMT_TELLER_ID              --管理柜员编号  ADD BY YJY 20250414
  FROM ICL.V_CMM_RETL_LOAN_BUS_CONT_ATTACH_INFO --视图-零售贷款业务合同补充信息
 WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ;
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_RETL_LOAN_BUS_CONT_ATTACH_INFO', '', O_ERRCODE);

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

END ETL_O_ICL_CMM_RETL_LOAN_BUS_CONT_ATTACH_INFO;
/

