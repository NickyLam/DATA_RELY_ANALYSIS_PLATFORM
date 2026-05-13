CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_RWAS_RWA_REPORT_FUND(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_RWAS_RWA_REPORT_FUND
  *  功能描述：POS商户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_RWAS_RWA_REPORT_FUND
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_RWAS_RWA_REPORT_FUND'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_RWAS_RWA_REPORT_FUND';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-POS商户信息';
  V_STARTTIME := SYSDATE;


  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_RWAS_RWA_REPORT_FUND NOLOGGING
    (DATA_DATE,                             --数据日期
     LOAN_REF_ID,                           --债项ID
     LOAN_REF_NO,                           --借据号
     I_CODE,                                --基金编号
     ASSET_THD_CLS_CD,                      --金融资产分类
     PRODUCT_NAME,                          --业务类型
     START_DATE,                            --开始日期
     DUE_DATE,                              --到期日期
     ORG_CD,                                --入账机构
     CCY_NAME,                              --币种代码
     CUST_NAME,                             --发行人名称
     SUBJECT_CD,                            --本金科目代码
     INTEREST_RECEIVE_SUBJECT_CD,           --应收利息科目代码
     ACCRUAL_CLASS_SUBJECT_CD,              --应计科目代码
     INTEREST_ADJUST_SUBJECT_CD,            --利息调整科目代码
     FAIRVALUE_CHANGES_SUBJECT_CD,          --公允价值变动科目代码
     PROVISION_SINGLE_SUBJECT_CD,           --准备金科目代码
     ASSET_BALANCE_HCURR,                   --资产余额(本币）
     RECEIVABLE_INT,                        --应收利息(本币）
     ACCRUED_INT,                           --应计利息(本币）
     INT_ADJ,                               --利息调整(本币）
     FAIR_VALUE_CHANGE,                     --公允价值变动(本币）
     PROVISION,                             --计提准备金(本币）
     EAD_ORIG,                              --原始风险暴露(本币)
     EAD_PROVISION,                         --扣减准备金后的风险暴露(本币)
     INVEST_CASH_AMT,                       --现金(0%)
     INVEST_MOF_AMT,                        --对我国中央政府的债权(0%)
     INVEST_CEN_BANK_AMT,                   --对中国人民银行的债权(0%)
     INVEST_PSE_SOV_AMT,                    --我国公共部门发行的债券(含铁道债)(20%)
     INVEST_PSE_RGLT_AMT,                   --我国省级（直辖区、自治区）以及计划单列市人民政府的债权(20%)
     INVEST_POLICY_SEN_AMT,                 --对我国政策性银行的债权(0%)
     INVEST_POLICY_SUB_AMT,                 --对我国政策性银行的次级债权（未扣除部分）(100%)
     INVEST_BANK_SHORT_AMT,                 --对我国商业银行的短期债权比例
     INVEST_BANK_LONG_AMT,                  --对我国商业银行的长期债权比例
     INVEST_BANK_SUB_AMT,                   --我国商业银行的次级债权(100%)
     INVEST_OTHFIN_AMT,                     --我国其他金融机构的债权(100%)
     INVEST_CORP_AMT,                       --一般企（事）业的债权(100%)
     INVEST_OTH_ASSETS_TWAMT,               --资产支持证券（20%）
     INVEST_OTH_ASSETS_OHAMT,               --适用100%风险权重的资产
     RWAAMOUNT,                             --RWA
     REGISTER_DATE,                         --缓释录入日期
     FUND_NAME,                             --基金名称
     ETL_DT                                 --数据日期
    )
  SELECT /*+PARALLEL*/
         DATA_DATE,                             --数据日期
         LOAN_REF_ID,                           --债项ID
         LOAN_REF_NO,                           --借据号
         I_CODE,                                --基金编号
         ASSET_THD_CLS_CD,                      --金融资产分类
         PRODUCT_NAME,                          --业务类型
         START_DATE,                            --开始日期
         DUE_DATE,                              --到期日期
         ORG_CD,                                --入账机构
         CCY_NAME,                              --币种代码
         CUST_NAME,                             --发行人名称
         SUBJECT_CD,                            --本金科目代码
         INTEREST_RECEIVE_SUBJECT_CD,           --应收利息科目代码
         ACCRUAL_CLASS_SUBJECT_CD,              --应计科目代码
         INTEREST_ADJUST_SUBJECT_CD,            --利息调整科目代码
         FAIRVALUE_CHANGES_SUBJECT_CD,          --公允价值变动科目代码
         PROVISION_SINGLE_SUBJECT_CD,           --准备金科目代码
         ASSET_BALANCE_HCURR,                   --资产余额(本币）
         RECEIVABLE_INT,                        --应收利息(本币）
         ACCRUED_INT,                           --应计利息(本币）
         INT_ADJ,                               --利息调整(本币）
         FAIR_VALUE_CHANGE,                     --公允价值变动(本币）
         PROVISION,                             --计提准备金(本币）
         EAD_ORIG,                              --原始风险暴露(本币)
         EAD_PROVISION,                         --扣减准备金后的风险暴露(本币)
         INVEST_CASH_AMT,                       --现金(0%)
         INVEST_MOF_AMT,                        --对我国中央政府的债权(0%)
         INVEST_CEN_BANK_AMT,                   --对中国人民银行的债权(0%)
         INVEST_PSE_SOV_AMT,                    --我国公共部门发行的债券(含铁道债)(20%)
         INVEST_PSE_RGLT_AMT,                   --我国省级（直辖区、自治区）以及计划单列市人民政府的债权(20%)
         INVEST_POLICY_SEN_AMT,                 --对我国政策性银行的债权(0%)
         INVEST_POLICY_SUB_AMT,                 --对我国政策性银行的次级债权（未扣除部分）(100%)
         INVEST_BANK_SHORT_AMT,                 --对我国商业银行的短期债权比例
         INVEST_BANK_LONG_AMT,                  --对我国商业银行的长期债权比例
         INVEST_BANK_SUB_AMT,                   --我国商业银行的次级债权(100%)
         INVEST_OTHFIN_AMT,                     --我国其他金融机构的债权(100%)
         INVEST_CORP_AMT,                       --一般企（事）业的债权(100%)
         INVEST_OTH_ASSETS_TWAMT,               --资产支持证券（20%）
         INVEST_OTH_ASSETS_OHAMT,               --适用100%风险权重的资产
         RWAAMOUNT,                             --RWA
         REGISTER_DATE,                         --缓释录入日期
         FUND_NAME,                             --基金名称
         ETL_DT                                 --数据日期
    FROM IOL.V_RWAS_RWA_REPORT_FUND   --债项填报信息表-基金投资_视图
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

  END ETL_INIT_O_IOL_RWAS_RWA_REPORT_FUND;
/

