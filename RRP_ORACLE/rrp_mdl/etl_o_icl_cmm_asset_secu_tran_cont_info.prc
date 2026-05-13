CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO(I_P_DATE IN INTEGER,
                                                                    O_ERRCODE OUT VARCHAR2
                                                                    )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO
  *  功能描述：资产证券化转让合同信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：ICL.V_CMM_ASSET_SECU_TRAN_CONT_INFO
  *  目标表： O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20251127  YJY      新增交易对手证件类型、交易对手证件号码
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-资产证券化转让合同信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO
    (  ETL_DT			             --数据日期
      ,LP_ID			             --法人编号
      ,CONT_ID			           --合同编号
      ,PROD_ID			           --产品编号
      ,ASSET_POOL_ID			     --资产池编号
      ,PROD_TYPE_CD			       --产品类型代码
      ,PROD_STATUS_CD			     --产品状态代码
      ,PROD_BUS_STATUS_CD			 --产品业务状态代码
      ,PROD_MODE_CD			       --产品模式代码
      ,ASSET_POOL_TYPE_CD			 --资产池类型代码
      ,ASSET_POOL_CHAR_CD			 --资产池性质代码
      ,ASSET_POOL_STATUS_CD		 --资产池状态代码
      ,TRAN_CALC_WAY_CD			   --转让计算方式代码
      ,CNTPTY_ORG_TYPE_CD			 --交易对手机构类型代码
      ,CNTPTY_ID			         --交易对手编号
      ,CNTPTY_NAME			       --交易对手名称
      ,CNTPTY_ACCT_NUM			   --交易对手账号
      ,CNTPTY_OPEN_BANK_NAME	 --交易对手开户行名称
      ,CNTPTY_TRAN_DT			     --交易对手转账日期
      ,CNTPTY_PAY_AMT			     --交易对手已支付金额
      ,PAY_DT_RULE_CD			     --支付日期规则代码
      ,TS_CD			             --暂存代码
      ,USER_DEF_COLL_PED_FLG	 --自定义归集周期标志
      ,CLEARUP_REPO_FLG			   --清仓回购标志
      ,TRAN_PLAT_NAME			     --交易平台名称
      ,PROD_NAME			         --产品名称
      ,PKG_DT			             --封包日期
      ,BEGIN_DT			           --起始日期
      ,EXP_DT			             --到期日期
      ,RGST_TELLER_ID			     --登记柜员编号
      ,RGST_ORG_ID			       --登记机构编号
      ,MGMT_ORG_ID			       --管理机构编号
      ,ACCT_INSTIT_ID			     --账务机构编号
      ,CURR_CD			           --币种代码
      ,ASSET_TOT_AMT			     --资产总金额
      ,ISSUE_TOT_AMT			     --发行总金额
      ,ASSET_TRAN_CONSIDERATION_AMT			--资产转让对价金额
      ,ASSET_TRAN_COMM_FEE		 --资产转让手续费
      ,PROD_SELF_HOLD_AMT			 --产品自持金额
      ,ISSUE_QTTY			         --发行数量
      ,BANK_RGST_CENTER_AMT		 --银登中心登记金额
      ,JOB_CD			             --任务代码
      ,CNTPTY_CERT_TYPE	       --交易对手证件类型 ADD BY YJY 20251127	
      ,CNTPTY_CERT_NO	         --交易对手证件号码 ADD BY YJY 20251127				
    )
  SELECT 
       ETL_DT			             --数据日期
      ,LP_ID			             --法人编号
      ,CONT_ID			           --合同编号
      ,PROD_ID			           --产品编号
      ,ASSET_POOL_ID			     --资产池编号
      ,PROD_TYPE_CD			       --产品类型代码
      ,PROD_STATUS_CD			     --产品状态代码
      ,PROD_BUS_STATUS_CD			 --产品业务状态代码
      ,PROD_MODE_CD			       --产品模式代码
      ,ASSET_POOL_TYPE_CD			 --资产池类型代码
      ,ASSET_POOL_CHAR_CD			 --资产池性质代码
      ,ASSET_POOL_STATUS_CD		 --资产池状态代码
      ,TRAN_CALC_WAY_CD			   --转让计算方式代码
      ,CNTPTY_ORG_TYPE_CD			 --交易对手机构类型代码
      ,CNTPTY_ID			         --交易对手编号
      ,CNTPTY_NAME			       --交易对手名称
      ,CNTPTY_ACCT_NUM			   --交易对手账号
      ,CNTPTY_OPEN_BANK_NAME	 --交易对手开户行名称
      ,CNTPTY_TRAN_DT			     --交易对手转账日期
      ,CNTPTY_PAY_AMT			     --交易对手已支付金额
      ,PAY_DT_RULE_CD			     --支付日期规则代码
      ,TS_CD			             --暂存代码
      ,USER_DEF_COLL_PED_FLG	 --自定义归集周期标志
      ,CLEARUP_REPO_FLG			   --清仓回购标志
      ,TRAN_PLAT_NAME			     --交易平台名称
      ,PROD_NAME			         --产品名称
      ,PKG_DT			             --封包日期
      ,BEGIN_DT			           --起始日期
      ,EXP_DT			             --到期日期
      ,RGST_TELLER_ID			     --登记柜员编号
      ,RGST_ORG_ID			       --登记机构编号
      ,MGMT_ORG_ID			       --管理机构编号
      ,ACCT_INSTIT_ID			     --账务机构编号
      ,CURR_CD			           --币种代码
      ,ASSET_TOT_AMT			     --资产总金额
      ,ISSUE_TOT_AMT			     --发行总金额
      ,ASSET_TRAN_CONSIDERATION_AMT			--资产转让对价金额
      ,ASSET_TRAN_COMM_FEE		 --资产转让手续费
      ,PROD_SELF_HOLD_AMT			 --产品自持金额
      ,ISSUE_QTTY			         --发行数量
      ,BANK_RGST_CENTER_AMT		 --银登中心登记金额
      ,JOB_CD			             --任务代码
      ,CNTPTY_CERT_TYPE	       --交易对手证件类型 ADD BY YJY 20251127	
      ,CNTPTY_CERT_NO	         --交易对手证件号码 ADD BY YJY 20251127
    FROM ICL.V_CMM_ASSET_SECU_TRAN_CONT_INFO  --视图-资产证券化转让合同信息
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

END ETL_O_ICL_CMM_ASSET_SECU_TRAN_CONT_INFO;
/

