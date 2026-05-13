CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_POS_MERCHT_INFO(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_POS_MERCHT_INFO
  *  功能描述：POS商户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_POS_MERCHT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20240718  YJY      新增商户签约日期、商户撤销日期、直连商户合作状态代码字段
  *             3    20251027  YJY      新增商户客户号
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_POS_MERCHT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_POS_MERCHT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE O_ICL_CMM_POS_MERCHT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-POS商户信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_POS_MERCHT_INFO
    (ETL_DT			              --数据日期
    ,LP_ID			              --法人编号
    ,MERCHT_ORDER_ID			    --商户序列编号
    ,MERCHT_ID			          --商户编号
    ,AGENCY_ID			          --代理商编号
    ,MERCHT_NAME			        --商户名称
    ,MERCHT_FNAME			        --商户全称
    ,WORK_ADDR			          --办公地址
    ,OPEN_ACCT_BANK_NAME			--开户银行名称
    ,OPEN_ACCT_BANK_ID			  --开户银行编号
    ,ACCT_ID			            --账户编号
    ,ACCT_NAME			          --账户名称
    ,ACCT_TYPE_CD			        --账户类型代码
    ,COTAS_TYPE_CD			      --联系人类型代码
    ,COTAS_NAME			          --联系人名称
    ,CONT_NUM			            --联系号码
    ,COTAS_E_MAIL			        --联系人电子邮箱
    ,FAX_NUM			            --传真号码
    ,MERCHT_BELONG_RG_CD			--商户所属区域代码
    ,MERCHT_MCC_CODE			    --商户mcc编码
    ,MERCHT_MCC_DESCB			    --商户mcc描述
    ,OPER_CO_CORP_NAME			  --经办合作单位名称
    ,AGENCY_ABBR			        --代理商简称
    ,AGENCY_BELONG_BRCH_ID		--代理商所属分行编号
    ,AGENCY_BUS_LICS_ID			  --代理商营业执照编号
    ,AGENCY_COTAS_NAME			  --代理商联系人名称
    ,AGENCY_COTAS_ADDR			  --代理商联系人地址
    ,AGENCY_ENTER_ACCT_CHN_CD	--代理商入账渠道代码
    ,AGENCY_STATUS_CD			    --代理商状态代码
    ,RECV_BILL_BANK_ID			  --收单银行编号
    ,MERCHT_STATUS_CD			    --商户状态代码
    ,BELONG_ORG_ID			      --所属机构编号
    ,CUST_MGR_ID			        --客户经理编号
    ,CUST_MGR_NAME			      --客户经理名称
    ,FLOW_BANK_APV_FLOW_ID		--流程银行审批流水编号
    ,FLOW_BANK_APV_REST_CD		--流程银行审批结果代码
    ,H5_FLOW_FLG			        --H5进件标志
    ,DIC_CONC_MERCHT_FLG			--直连商户标志
    ,JH_MERCHT_FLG			      --聚合商户标志
    ,MERCHT_START_USE_DT			--商户启用日期
    ,JOB_CD			              --任务代码
    ,MERCHT_SIGN_DT           --商户签约日期    ADD BY YJY IN 20240718
    ,MERCHT_REVO_DT           --商户撤销日期    ADD BY YJY IN 20240718 
    ,DIC_CONC_CO_STATUS_CD    --直连商户合作状态代码   ADD BY YJY IN 20240718 
    ,MERCHT_CUST_ID           --商户客户号   ADD BY YJY 20251027
    )
  SELECT 
     ETL_DT			              --数据日期
    ,LP_ID			              --法人编号
    ,MERCHT_ORDER_ID			    --商户序列编号
    ,MERCHT_ID			          --商户编号
    ,AGENCY_ID			          --代理商编号
    ,MERCHT_NAME			        --商户名称
    ,MERCHT_FNAME			        --商户全称
    ,WORK_ADDR			          --办公地址
    ,OPEN_ACCT_BANK_NAME			--开户银行名称
    ,OPEN_ACCT_BANK_ID			  --开户银行编号
    ,ACCT_ID			            --账户编号
    ,ACCT_NAME			          --账户名称
    ,ACCT_TYPE_CD			        --账户类型代码
    ,COTAS_TYPE_CD			      --联系人类型代码
    ,COTAS_NAME			          --联系人名称
    ,CONT_NUM			            --联系号码
    ,COTAS_E_MAIL			        --联系人电子邮箱
    ,FAX_NUM			            --传真号码
    ,MERCHT_BELONG_RG_CD			--商户所属区域代码
    ,MERCHT_MCC_CODE			    --商户mcc编码
    ,MERCHT_MCC_DESCB			    --商户mcc描述
    ,OPER_CO_CORP_NAME			  --经办合作单位名称
    ,AGENCY_ABBR			        --代理商简称
    ,AGENCY_BELONG_BRCH_ID		--代理商所属分行编号
    ,AGENCY_BUS_LICS_ID			  --代理商营业执照编号
    ,AGENCY_COTAS_NAME			  --代理商联系人名称
    ,AGENCY_COTAS_ADDR			  --代理商联系人地址
    ,AGENCY_ENTER_ACCT_CHN_CD	--代理商入账渠道代码
    ,AGENCY_STATUS_CD			    --代理商状态代码
    ,RECV_BILL_BANK_ID			  --收单银行编号
    ,MERCHT_STATUS_CD			    --商户状态代码
    ,BELONG_ORG_ID			      --所属机构编号
    ,CUST_MGR_ID			        --客户经理编号
    ,CUST_MGR_NAME			      --客户经理名称
    ,FLOW_BANK_APV_FLOW_ID		--流程银行审批流水编号
    ,FLOW_BANK_APV_REST_CD		--流程银行审批结果代码
    ,H5_FLOW_FLG			        --H5进件标志
    ,DIC_CONC_MERCHT_FLG			--直连商户标志
    ,JH_MERCHT_FLG			      --聚合商户标志
    ,MERCHT_START_USE_DT			--商户启用日期
    ,JOB_CD			              --任务代码
    ,MERCHT_SIGN_DT           --商户签约日期    ADD BY YJY IN 20240718
    ,MERCHT_REVO_DT           --商户撤销日期    ADD BY YJY IN 20240718 
    ,DIC_CONC_CO_STATUS_CD    --直连商户合作状态代码   ADD BY YJY IN 20240718
    ,MERCHT_CUST_ID           --商户客户号   ADD BY YJY IN 20251027
    FROM ICL.V_CMM_POS_MERCHT_INFO  --视图-POS商户信息
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

END ETL_O_ICL_CMM_POS_MERCHT_INFO;
/

