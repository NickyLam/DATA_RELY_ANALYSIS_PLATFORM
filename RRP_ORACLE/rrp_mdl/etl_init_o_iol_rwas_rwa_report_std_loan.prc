CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_RWAS_RWA_REPORT_STD_LOAN(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_RWAS_RWA_REPORT_STD_LOAN
  *  功能描述：POS商户信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_RWAS_RWA_REPORT_STD_LOAN
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_RWAS_RWA_REPORT_STD_LOAN'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_RWAS_RWA_REPORT_STD_LOAN';
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
 INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_RWAS_RWA_REPORT_STD_LOAN NOLOGGING
    (DATA_DATE,                           --数据日期
     LOAN_REF_ID,                         --债项ID
     LOAN_REF_NO,                         --借据号
     SEC_NO,                              --证券编号
     ASSET_THD_CLS_CD,                    --金融资产分类
     SENIORITY_ID,                        --优先债权标志.110：优先债权130：次级债权
     S_GRADE,                             --债券评级
     GRADE,                               --主体评级
     SRC_SYSTEM_ID,                       --来源系统
     PRODUCT_NAME,                        --业务类型(债券类型)
     START_DATE,                          --开始日期
     DUE_DATE,                            --到期日期
     ORG_CD,                              --入账机构
     CUST_NO,                             --发行人客户号
     CUST_NAME,                           --发行人名称
     REG_COUNTRY_CD,                      --发行人注册国
     RATING_CD,                           --发行人注册国评级
     CCP_TYPE_CD,                         --客户类型(引擎)
     ASSETTYPE_ID,                        --资产类型(引擎)
     SUBJECT_CD,                          --本金科目代码
     INTEREST_RECEIVE_SUBJECT_CD,         --应收利息科目代码
     ACCRUAL_CLASS_SUBJECT_CD,            --应计科目代码
     INTEREST_ADJUST_SUBJECT_CD,          --利息调整科目代码
     FAIRVALUE_CHANGES_SUBJECT_CD,        --公允价值变动科目代码
     PROVISION_SINGLE_SUBJECT_CD,         --准备金科目代码
     CCY_NAME,                            --币种代码
     ASSET_BALANCE,                       --资产余额(原币)
     ASSET_BALANCE_HCURR,                 --资产余额(本币)
     RECEIVABLE_INT,                      --应收利息(本币)
     ACCRUED_INT,                         --应计利息(本币)
     INT_ADJ,                             --利息调整(本币)
     FAIR_VALUE_CHANGE,                   --公允价值变动(本币)
     PROVISION,                           --计提准备金(本币)
     EAD_ORIG,                            --原始风险暴露(本币)
     EAD_PROVISION,                       --扣减准备金后的风险暴露(本币)
     PORTFOLIOTYPEDESC,                   --填报项目
     RWBANDID,                            --债项权重
     RWAAMOUNT,                           --RWA
     CRM_CASH_AMT,                        --现金类资产0%
     CRM_GOVERNMENT_AMT,                  --我国中央政府0%
     CRM_PBC_MAT,                         --中国人民银行0%
     CRM_POLICY_BANK_AMT,                 --我国政策性银行0%
     CRM_PSE_SOV_AMT,                     --我国公共部门实体20%
     CRM_BANK_AMT,                        --我国商业银行25%
     CRM_BONDS_ISSUED_AMT,                --金融资产管理公司为收购国有银行不良贷款而定向发行的债券0%
     CRM_GOVERNMENTS_AA_AMT,              --评级AA-以上（含AA-）的国家和地区的中央政府和中央银行0%
     CRM_GOVERNMENTS_A_AMT,               --评级AA-以下，A-（含A-）以上的国家和地区的中央政府和中央银行20%
     CRM_GOVERNMENTS_BBB_AMT,             --评级A-以下，BBB-（含BBB-）以上的国家和地区的中央政府和中央银行50%
     CRM_PSES_AA_AMT,                     --评级AA-及以上国家和地区注册的商业银行和公共部门实体25%
     CRM_PSES_A_AMT,                      --评级AA-以下，A-（含A-）以上国家和地区注册的商业银行和公共部门实体50%
     CRM_MDBS_BISS_IMFS_AMT,              --多边开发银行、国际清算银行及国际货币基金组织0%
     FIRST_ORG_CD,                        --首次贴现机构
     FIRST_CUST_NAME,                     --首次贴现交易对手名称
     ETL_DT                               --数据日期
    )
  SELECT /*+PARALLEL*/
         DATA_DATE,                           --数据日期
         LOAN_REF_ID,                         --债项ID
         LOAN_REF_NO,                         --借据号
         SEC_NO,                              --证券编号
         ASSET_THD_CLS_CD,                    --金融资产分类
         SENIORITY_ID,                        --优先债权标志.110：优先债权130：次级债权
         S_GRADE,                             --债券评级
         GRADE,                               --主体评级
         SRC_SYSTEM_ID,                       --来源系统
         PRODUCT_NAME,                        --业务类型(债券类型)
         START_DATE,                          --开始日期
         DUE_DATE,                            --到期日期
         ORG_CD,                              --入账机构
         CUST_NO,                             --发行人客户号
         CUST_NAME,                           --发行人名称
         REG_COUNTRY_CD,                      --发行人注册国
         RATING_CD,                           --发行人注册国评级
         CCP_TYPE_CD,                         --客户类型(引擎)
         ASSETTYPE_ID,                        --资产类型(引擎)
         SUBJECT_CD,                          --本金科目代码
         INTEREST_RECEIVE_SUBJECT_CD,         --应收利息科目代码
         ACCRUAL_CLASS_SUBJECT_CD,            --应计科目代码
         INTEREST_ADJUST_SUBJECT_CD,          --利息调整科目代码
         FAIRVALUE_CHANGES_SUBJECT_CD,        --公允价值变动科目代码
         PROVISION_SINGLE_SUBJECT_CD,         --准备金科目代码
         CCY_NAME,                            --币种代码
         ASSET_BALANCE,                       --资产余额(原币)
         ASSET_BALANCE_HCURR,                 --资产余额(本币)
         RECEIVABLE_INT,                      --应收利息(本币)
         ACCRUED_INT,                         --应计利息(本币)
         INT_ADJ,                             --利息调整(本币)
         FAIR_VALUE_CHANGE,                   --公允价值变动(本币)
         PROVISION,                           --计提准备金(本币)
         EAD_ORIG,                            --原始风险暴露(本币)
         EAD_PROVISION,                       --扣减准备金后的风险暴露(本币)
         PORTFOLIOTYPEDESC,                   --填报项目
         RWBANDID,                            --债项权重
         RWAAMOUNT,                           --RWA
         CRM_CASH_AMT,                        --现金类资产0%
         CRM_GOVERNMENT_AMT,                  --我国中央政府0%
         CRM_PBC_MAT,                         --中国人民银行0%
         CRM_POLICY_BANK_AMT,                 --我国政策性银行0%
         CRM_PSE_SOV_AMT,                     --我国公共部门实体20%
         CRM_BANK_AMT,                        --我国商业银行25%
         CRM_BONDS_ISSUED_AMT,                --金融资产管理公司为收购国有银行不良贷款而定向发行的债券0%
         CRM_GOVERNMENTS_AA_AMT,              --评级AA-以上（含AA-）的国家和地区的中央政府和中央银行0%
         CRM_GOVERNMENTS_A_AMT,               --评级AA-以下，A-（含A-）以上的国家和地区的中央政府和中央银行20%
         CRM_GOVERNMENTS_BBB_AMT,             --评级A-以下，BBB-（含BBB-）以上的国家和地区的中央政府和中央银行50%
         CRM_PSES_AA_AMT,                     --评级AA-及以上国家和地区注册的商业银行和公共部门实体25%
         CRM_PSES_A_AMT,                      --评级AA-以下，A-（含A-）以上国家和地区注册的商业银行和公共部门实体50%
         CRM_MDBS_BISS_IMFS_AMT,              --多边开发银行、国际清算银行及国际货币基金组织0%
         FIRST_ORG_CD,                        --首次贴现机构
         FIRST_CUST_NAME,                     --首次贴现交易对手名称
         ETL_DT                               --数据日期
    FROM IOL.V_RWAS_RWA_REPORT_STD_LOAN   --债项填报信息表-标准债权_视图
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

  END ETL_INIT_O_IOL_RWAS_RWA_REPORT_STD_LOAN;
/

