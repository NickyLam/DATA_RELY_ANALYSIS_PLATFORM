CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES
  *  功能描述：债券信息填报表
  *  创建日期：20220619
  *  开发人员：梅炜
  *  来源表： IOL.V_RWAS_RWA_REPORT_TRAN_SECURITIES
  *  目标表： O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-债券信息填报表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES
  (
			S_GRADE			                   --债项/主体评级
      ,ORG_CD			                   --组织机构代码
      ,COUPON_FLAG			             --
      ,GENERAL_RISK_CAPITAL_AMOUNT	 --
      ,INT_RAT_ADJ_WAY_CD			       --利率调整方式代码
      ,EXPOSUREAMOUNT			           --
      ,INTEREST_ADJUST_SUBJECT_CD		 --利息调整科目代码
      ,RECEIVABLE_INT			           --应收利息(本币)
      ,END_DT			                   --截止日期
      ,DUE_DATE			                 --到期日期
      ,LOAN_REF_NO			             --借据号
      ,DATA_DATE			               --数据日期
      ,NEXT_REVAL_DATE			         --
      ,SEC_NO			                   --
      ,SPECIFIC_RISK_CHARGE			     --
      ,SPECIFIC_RISK_RATIO			     --
      ,CCY_CD			                   --币种代码
      ,REMAININGMATURITY			       --
      ,START_DATE			               --起息日
      ,ACCRUED_INT			             --应计利息(本币）
      ,RATE_SEC_TYPE_CD			         --
      ,LOAN_REF_ID			             --债项ID
      ,SPEC_RISK_CAPITAL_AMOUNT			 --
      ,TRADETYPEID			             --
      ,AMT			                     --发生额
      ,ASSET_BALANCE_HCURR			     --资产余额(本币）
      ,PROVISION_SINGLE_SUBJECT_CD	 --准备金科目代码
      ,ASSET_BALANCE			           --资产余额(原币)
      ,ASSET_THD_CLS_CD			         --资产三分类代码
      ,PRODUCT_NAME			             --产品名称
      ,INTEREST_RECEIVE_SUBJECT_CD	 --应收利息科目代码
      ,MAT_BUCKETID			             --
      ,CUST_NAME			               --客户名称
      ,FAIRVALUE_CHANGES_SUBJECT_CD	 --公允价值变动科目代码
      ,GRADE			                   --评分
      ,SEC_NAME			                 --
      ,INT_ADJ			                 --利息调整
      ,PROVISION			               --计提准备金(本币)
      ,RWAAMOUNT			               --RWA（风险加权资产）金额
      ,ASSETTYPE_ID			             --资产类型ID
      ,FAIR_VALUE_CHANGE			       --公允价值变动(本币）
      ,START_DT			                 --起始日期
      ,COUPON			                   --执行利率
      ,CCP_TYPE_CD			             --实际融资主体客户类型(引擎)
      ,ID_MARK			                 --增删标志
      ,SEC_TYPE_CD			             --
      ,REMA__REVAL_DATE			         --
      ,SUBJECT_CD			               --科目代码
      ,ACCRUAL_CLASS_SUBJECT_CD			 --应计科目代码
    )
    SELECT
			S_GRADE			                   --债项/主体评级
      ,ORG_CD			                   --组织机构代码
      ,COUPON_FLAG			             --
      ,GENERAL_RISK_CAPITAL_AMOUNT	 --
      ,INT_RAT_ADJ_WAY_CD			       --利率调整方式代码
      ,EXPOSUREAMOUNT			           --
      ,INTEREST_ADJUST_SUBJECT_CD		 --利息调整科目代码
      ,RECEIVABLE_INT			           --应收利息(本币)
      ,END_DT			                   --截止日期
      ,DUE_DATE			                 --到期日期
      ,LOAN_REF_NO			             --借据号
      ,DATA_DATE			               --数据日期
      ,NEXT_REVAL_DATE			         --
      ,SEC_NO			                   --
      ,SPECIFIC_RISK_CHARGE			     --
      ,SPECIFIC_RISK_RATIO			     --
      ,CCY_CD			                   --币种代码
      ,REMAININGMATURITY			       --
      ,START_DATE			               --起息日
      ,ACCRUED_INT			             --应计利息(本币）
      ,RATE_SEC_TYPE_CD			         --
      ,LOAN_REF_ID			             --债项ID
      ,SPEC_RISK_CAPITAL_AMOUNT			 --
      ,TRADETYPEID			             --
      ,AMT			                     --发生额
      ,ASSET_BALANCE_HCURR			     --资产余额(本币）
      ,PROVISION_SINGLE_SUBJECT_CD	 --准备金科目代码
      ,ASSET_BALANCE			           --资产余额(原币)
      ,ASSET_THD_CLS_CD			         --资产三分类代码
      ,PRODUCT_NAME			             --产品名称
      ,INTEREST_RECEIVE_SUBJECT_CD	 --应收利息科目代码
      ,MAT_BUCKETID			             --
      ,CUST_NAME			               --客户名称
      ,FAIRVALUE_CHANGES_SUBJECT_CD	 --公允价值变动科目代码
      ,GRADE			                   --评分
      ,SEC_NAME			                 --
      ,INT_ADJ			                 --利息调整
      ,PROVISION			               --计提准备金(本币)
      ,RWAAMOUNT			               --RWA（风险加权资产）金额
      ,ASSETTYPE_ID			             --资产类型ID
      ,FAIR_VALUE_CHANGE			       --公允价值变动(本币）
      ,START_DT			                 --起始日期
      ,COUPON			                   --执行利率
      ,CCP_TYPE_CD			             --实际融资主体客户类型(引擎)
      ,ID_MARK			                 --增删标志
      ,SEC_TYPE_CD			             --
      ,REMA__REVAL_DATE			         --
      ,SUBJECT_CD			               --科目代码
      ,ACCRUAL_CLASS_SUBJECT_CD			 --应计科目代码
    FROM IOL.V_RWAS_RWA_REPORT_TRAN_SECURITIES  --视图-债券信息填报表
   WHERE DATA_DATE <= TO_DATE(V_P_DATE,'YYYYMMDD')  
     AND ID_MARK <> 'D';

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

  END ETL_O_IOL_RWAS_RWA_REPORT_TRAN_SECURITIES;
/

