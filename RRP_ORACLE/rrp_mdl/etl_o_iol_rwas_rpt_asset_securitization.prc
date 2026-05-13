CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_RWAS_RPT_ASSET_SECURITIZATION(I_P_DATE IN INTEGER,
                                                         O_ERRCODE OUT VARCHAR2
                                                         )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_RWAS_RPT_ASSET_SECURITIZATION
  *  功能描述：内部管理报表_资产证券化
  *  创建日期：20241121
  *  开发人员：yujingyi
  *  来源表：
  *  目标表： O_IOL_RWAS_RPT_ASSET_SECURITIZATION
  *  配置表：
  *  修改情况：序号  修改日期  修改人       修改原因
  *             1    20241121  yujingyi     首次创建
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_RWAS_RPT_ASSET_SECURITIZATION'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_RWAS_RPT_ASSET_SECURITIZATION'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_RWAS_RPT_ASSET_SECURITIZATION';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-内部管理报表_资产证券化';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_RWAS_RPT_ASSET_SECURITIZATION NOLOGGING
  (
    DATA_DATE                                    --数据日期                                                    
   ,LOAN_REF_NO                                  --债项编号                                         
   ,SEC_ITEMS_ISSUE_NO                           --资产证券化发行编号                               
   ,SEC_ITEMS_ISSUE_NAME                         --资产证券化发行产品名称                           
   ,ITEMS_TRANCHE_NO                             --资产证券化档次编号                               
   ,ITEMS_TRANCHE_NAME                           --资产证券化档次名称                               
   ,ON_OFF_ID                                    --表内外资产标志：01 表内,02 表外                  
   ,SEC_PRIORITY_RATING_FLAG                     --证券化优先档次标志：1 优先档，0 非优先档         
   ,MARKET_TYPE_ID                               --市场类型代码                                     
   ,ORG_CD                                       --账务机构                                         
   ,ORG_NAME                                     --账务机构名称                                     
   ,OVERDUE_DAYS                                 --逾期天数                                         
   ,FIVE_CLASS_CD                                --五级分类代码                                     
   ,FIVE_CLASS_NAME                              --五级分类名称                                     
   ,PRODUCT_NO                                   --产品代码                                         
   ,PRODUCT_NAME                                 --产品名称                                         
   ,SEC_SP_RATING_CD                             --外部评级代码                                     
   ,SEC_RATING_ORG_CD                            --证券评级机构代码                                 
   ,SEC_RATING_ORG_NAME                          --证券评级机构名称                                 
   ,SEC_ECTERNAL_RATING_CD                       --债券标普评级                                     
   ,ITEMS_TRANCHE_DUE_DAY                        --持有档次的预期到期日                             
   ,ITEMS_SENIORITY                              --项目档次优先级：1 优先档，0 非优先档             
   ,ISSUE_AMT_TOTAL                              --产品当期总余额                                   
   ,AMT_CUR                                      --产品当期总余额                                   
   ,SEC_STC_FLAG                                 --资产证券化简单透明可比标志：1 STC，0 非STC       
   ,ANEW_ASSET_SEC_FLAG                          --再资产证券化标志：1 是，0 否                     
   ,SEC_START_DATE                               --证券起息日                                       
   ,SEC_END_DATE                                 --证券到期日                                       
   ,SEC_POOL_A                                   --档次起始点A                                      
   ,SEC_POOL_D                                   --档次分离点D                                      
   ,SEC_POOL_T                                   --厚度T                                            
   ,SEC_POOL_MR                                  --剩余有效期限                                     
   ,SEC_RATING_FLOOR_RW                          --外部评级1年期权重                                
   ,SEC_RATING_CEIL_RW                           --外部评级5年期权重                                
   ,SEC_ORIG_RW                                  --资产证券化原始权重                               
   ,SEC_POOL_RW                                  --资产池平均权重                                   
   ,SEC_RW                                       --资产证券化调整后权重                             
   ,SEC_RW_ADJ                                   --资产证券化底线调整后的权重                       
   ,CCY_CD                                       --币种代码                                         
   ,CCY_NAME                                     --币种名称                                         
   ,SUBJECT_CD                                   --本金科目代码                                     
   ,SUBJECT_NAME                                 --本金科目名称                                     
   ,ACCRUED_SUBJECT_CD                           --应计利息科目                                     
   ,ACCRUED_SUBJECT_NAME                         --应计利息科目名称                                 
   ,RECEIVABLE_SUBJECT_CD                        --应收利息科目                                     
   ,RECEIVABLE_SUBJECT_NAME                      --应收利息科目名称                                 
   ,ACCRUED_RECEIV_SUBJECT_CD                    --应收未收利息科目                                 
   ,ACCRUED_RECEIV_SUBJECT_NAME                  --应收未收利息名称                                 
   ,INTADJ_SUBJECT_CD                            --利息调整科目                                     
   ,INTADJ_SUBJECT_NAME                          --利息调整科目名称                                 
   ,FAIRCHANGE_SUBJECT_CD                        --公允价值变动科目                                 
   ,FAIRCHANGE_SUBJECT_NAME                      --公允价值变动科目名称                             
   ,PROVISION_SUBJECT_CD                         --准备金科目代码                                   
   ,PROVISION_SUBJECT_NAME                       --准备金科目名称                                   
   ,BALANCE                                      --本金余额（原币）                                 
   ,BALANCE_HCURR                                --本金余额（本币）                                 
   ,RECEIVABLE_INT                               --应收利息(本币)                                   
   ,ACCRUED_RECEIV_INT                           --应收未收利息（本币）                             
   ,ACCRUED_INT                                  --应计利息(本币)                                   
   ,INT_ADJ                                      --利息调整(本币)                                   
   ,FAIR_VALUE_CHANGE                            --公允价值变动(本币)                               
   ,PROVISION                                    --计提准备金(本币)                                 
   ,ASSET_BALANCE                                --资产余额(本币）                                  
   ,EAD_ORIG                                     --原始风险暴露(本币）                              
   ,CCF                                          --表外信用风险转换系数                             
   ,EAD_AFTERCCF                                 --转换后的风险暴露(本币）                          
   ,EAD_AFTERPRO                                 --扣减准备金后的风险暴露（本币）                   
   ,RWA                                          --风险加权资产                                     
   ,AFTER_MITI_RWA                               --缓释后的风险加权资产                             
   ,AFTER_ADJ_RWA                                --考虑监管上限调整后的风险加权资产                 
   ,REPORT_NO                                    --报表编号                                         
   ,REPORT_LINE_NO                               --报表栏位号                                       
   ,LOAD_DATE                                    --加载日期                                         
   ,BOOK_TYPE_ID                                 --账簿类型：BANK_BOOK 银行账簿，TRADE_BOOK 交易账簿
   ,ETL_DT                                       --ETL处理日期                                      
   ,ETL_TIMESTAMP                                --ETL处理时间戳                                    
    )
  SELECT /*+PARALLEL*/
         DATA_DATE                                    --数据日期                                                    
        ,LOAN_REF_NO                                  --债项编号                                         
        ,SEC_ITEMS_ISSUE_NO                           --资产证券化发行编号                               
        ,SEC_ITEMS_ISSUE_NAME                         --资产证券化发行产品名称                           
        ,ITEMS_TRANCHE_NO                             --资产证券化档次编号                               
        ,ITEMS_TRANCHE_NAME                           --资产证券化档次名称                               
        ,ON_OFF_ID                                    --表内外资产标志：01 表内,02 表外                  
        ,SEC_PRIORITY_RATING_FLAG                     --证券化优先档次标志：1 优先档，0 非优先档         
        ,MARKET_TYPE_ID                               --市场类型代码                                     
        ,ORG_CD                                       --账务机构                                         
        ,ORG_NAME                                     --账务机构名称                                     
        ,OVERDUE_DAYS                                 --逾期天数                                         
        ,FIVE_CLASS_CD                                --五级分类代码                                     
        ,FIVE_CLASS_NAME                              --五级分类名称                                     
        ,PRODUCT_NO                                   --产品代码                                         
        ,PRODUCT_NAME                                 --产品名称                                         
        ,SEC_SP_RATING_CD                             --外部评级代码                                     
        ,SEC_RATING_ORG_CD                            --证券评级机构代码                                 
        ,SEC_RATING_ORG_NAME                          --证券评级机构名称                                 
        ,SEC_ECTERNAL_RATING_CD                       --债券标普评级                                     
        ,ITEMS_TRANCHE_DUE_DAY                        --持有档次的预期到期日                             
        ,ITEMS_SENIORITY                              --项目档次优先级：1 优先档，0 非优先档             
        ,ISSUE_AMT_TOTAL                              --产品当期总余额                                   
        ,AMT_CUR                                      --产品当期总余额                                   
        ,SEC_STC_FLAG                                 --资产证券化简单透明可比标志：1 STC，0 非STC       
        ,ANEW_ASSET_SEC_FLAG                          --再资产证券化标志：1 是，0 否                     
        ,SEC_START_DATE                               --证券起息日                                       
        ,SEC_END_DATE                                 --证券到期日                                       
        ,SEC_POOL_A                                   --档次起始点A                                      
        ,SEC_POOL_D                                   --档次分离点D                                      
        ,SEC_POOL_T                                   --厚度T                                            
        ,SEC_POOL_MR                                  --剩余有效期限                                     
        ,SEC_RATING_FLOOR_RW                          --外部评级1年期权重                                
        ,SEC_RATING_CEIL_RW                           --外部评级5年期权重                                
        ,SEC_ORIG_RW                                  --资产证券化原始权重                               
        ,SEC_POOL_RW                                  --资产池平均权重                                   
        ,SEC_RW                                       --资产证券化调整后权重                             
        ,SEC_RW_ADJ                                   --资产证券化底线调整后的权重                       
        ,CCY_CD                                       --币种代码                                         
        ,CCY_NAME                                     --币种名称                                         
        ,SUBJECT_CD                                   --本金科目代码                                     
        ,SUBJECT_NAME                                 --本金科目名称                                     
        ,ACCRUED_SUBJECT_CD                           --应计利息科目                                     
        ,ACCRUED_SUBJECT_NAME                         --应计利息科目名称                                 
        ,RECEIVABLE_SUBJECT_CD                        --应收利息科目                                     
        ,RECEIVABLE_SUBJECT_NAME                      --应收利息科目名称                                 
        ,ACCRUED_RECEIV_SUBJECT_CD                    --应收未收利息科目                                 
        ,ACCRUED_RECEIV_SUBJECT_NAME                  --应收未收利息名称                                 
        ,INTADJ_SUBJECT_CD                            --利息调整科目                                     
        ,INTADJ_SUBJECT_NAME                          --利息调整科目名称                                 
        ,FAIRCHANGE_SUBJECT_CD                        --公允价值变动科目                                 
        ,FAIRCHANGE_SUBJECT_NAME                      --公允价值变动科目名称                             
        ,PROVISION_SUBJECT_CD                         --准备金科目代码                                   
        ,PROVISION_SUBJECT_NAME                       --准备金科目名称                                   
        ,BALANCE                                      --本金余额（原币）                                 
        ,BALANCE_HCURR                                --本金余额（本币）                                 
        ,RECEIVABLE_INT                               --应收利息(本币)                                   
        ,ACCRUED_RECEIV_INT                           --应收未收利息（本币）                             
        ,ACCRUED_INT                                  --应计利息(本币)                                   
        ,INT_ADJ                                      --利息调整(本币)                                   
        ,FAIR_VALUE_CHANGE                            --公允价值变动(本币)                               
        ,PROVISION                                    --计提准备金(本币)                                 
        ,ASSET_BALANCE                                --资产余额(本币）                                  
        ,EAD_ORIG                                     --原始风险暴露(本币）                              
        ,CCF                                          --表外信用风险转换系数                             
        ,EAD_AFTERCCF                                 --转换后的风险暴露(本币）                          
        ,EAD_AFTERPRO                                 --扣减准备金后的风险暴露（本币）                   
        ,RWA                                          --风险加权资产                                     
        ,AFTER_MITI_RWA                               --缓释后的风险加权资产                             
        ,AFTER_ADJ_RWA                                --考虑监管上限调整后的风险加权资产                 
        ,REPORT_NO                                    --报表编号                                         
        ,REPORT_LINE_NO                               --报表栏位号                                       
        ,LOAD_DATE                                    --加载日期                                         
        ,BOOK_TYPE_ID                                 --账簿类型：BANK_BOOK 银行账簿，TRADE_BOOK 交易账簿
        ,ETL_DT                                       --ETL处理日期                                      
        ,ETL_TIMESTAMP                                --ETL处理时间戳                           
    FROM IOL.V_RWAS_RPT_ASSET_SECURITIZATION   --持仓视图_内部管理报表_资产证券化
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_RWAS_RPT_ASSET_SECURITIZATION;
/

