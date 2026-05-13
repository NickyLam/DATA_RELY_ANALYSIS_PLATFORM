CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_RWAS_MR_SA_RWA_RESULT_DETAIL(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：计量_RWA计量明细结果表
  **存储过程名称：    ETL_O_IOL_RWAS_MR_SA_RWA_RESULT_DETAIL
  **存储过程创建日期：20250114
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250114    YJY        创建
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_RWAS_MR_SA_RWA_RESULT_DETAIL'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_RWAS_MR_SA_RWA_RESULT_DETAIL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-计量_RWA计量明细结果表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_RWAS_MR_SA_RWA_RESULT_DETAIL NOLOGGING 
  (    DATA_DATE                                --数据日期                                                                  
    ,VERSION_NO                               --计量版本号                                                                
    ,LOAN_REF_CRM_SPLIT_SEQ                   --缓释拆分序号                                                              
    ,SCENARIO_NO                              --业务情景编号 10-标准法 20-资产证券化 30-证券融资 40-场外衍生品 50-资管产品
    ,SA_CALCULATE_ID                          --标准法计量方法标识                                                        
    ,SA_CALCULATE_NAME                        --标准法计量方法名称                                                        
    ,CORPORATION                              --法人实体编号                                                              
    ,BANK_LEVEL                               --银行档次                                                                  
    ,CONSOL_CORPORATION                       --并表集团机构编号                                                          
    ,CONSOL_BANK_LEVEL                        --并表银行档次                                                              
    ,LOAN_REF_NO                              --债项编号                                                                  
    ,LOAN_REF_DESC                            --债项描述                                                                  
    ,CONTRACT_NO                              --合同编号                                                                  
    ,MAIN_GRNT_MTH_CD                         --主要担保方式代码                                                          
    ,ADT_GRNT_MTH_IND                         --附加担保方式                                                              
    ,DUE_ID                                   --债项号                                                                    
    ,SRC_SYSTEM_ID                            --来源系统标识                                                              
    ,ORG_PARTENT_NO                           --分行管户机构                                                              
    ,ORG_PARTENT_NAME                         --分行机构名称                                                              
    ,ORG_NO                                   --管户机构                                                                  
    ,ORG_NAME                                 --机构名称                                                                  
    ,ORG_ORDER_NO                             --机构排序号                                                                
    ,ACCORG_PARTENT_NO                        --分行账务机构                                                              
    ,ACCORG_PARTENT_NAME                      --分行账务机构名称                                                          
    ,ACCORG_NO                                --账务机构                                                                  
    ,ACCORG_NAME                              --账务机构名称                                                              
    ,BANK_REGION_CD                           --银行地域代码                                                              
    ,BIS_REGION_CD                            --监管区域代码                                                              
    ,BIS_REGION_NAME                          --监管区域名称                                                              
    ,LOAN_REF_INV_INDU_CD                     --投向行业代码                                                              
    ,CUST_INDUSTRY_CD                         --客户所属行业代码                                                          
    ,BIS_INDUSTRY_CD                          --计量行业代码                                                              
    ,BIS_INDUSTRY_NAME                        --计量行业名称                                                              
    ,FIVE_CLASS_CD                            --五级分类代码                                                              
    ,FIVE_CLASS_NAME                          --五级分类名称                                                              
    ,PRODUCT_CD                               --产品代码                                                                  
    ,PRODUCT_NAME                             --产品名称                                                                  
    ,BIS_PRODUCT_TYPE_CD                      --监管产品类型代码                                                          
    ,BIS_PRODUCT_TYPE_NAME                    --监管产品类型名称                                                          
    ,BIS_PRODUCT_BTYPE_CD                     --监管产品大类代码                                                          
    ,BIS_PRODUCT_BTYPE_NAME                   --监管产品大类名称                                                          
    ,SA_EXP_CLASS_CD                          --标准法风险暴露分类                                                        
    ,SA_EXP_CLASS_NAME                        --标准法风险暴露分类名称                                                    
    ,SA_EXP_SUB_CLASS_CD                      --标准法风险暴露大类                                                        
    ,SA_EXP_SUB_CLASS_NAME                    --标准法风险暴露大类名称                                                    
    ,ITEM_OFF_CCF_BTYPE_CD                    --表外CCF项目大类代码                                                       
    ,ITEM_OFF_CCF_BTYPE_NAME                  --表外CCF项目大类名称                                                       
    ,ITEM_OFF_CCF_TYPE_CD                     --表外CCF项目类型代码                                                       
    ,ITEM_OFF_CCF_TYPE_NAME                   --表外CCF项目类型名称                                                       
    ,BUSINESS_LINE_CD                         --业务条线代码                                                              
    ,BUSINESS_LINE_NAME                       --业务条线名称                                                              
    ,BUSS_TYPE_CD                             --业务类型                                                                  
    ,BUSS_TYPE_NAME                           --业务名称                                                                  
    ,START_DATE                               --开始日期                                                                  
    ,DUE_DATE                                 --到期日期                                                                  
    ,ORIG_MATURITY                            --原始期限                                                                  
    ,REMA_MATURITY                            --剩余期限                                                                  
    ,OVERDUE_DAYS                             --逾期天数                                                                  
    ,STD_DEFAULT_FLAG                         --权重法违约标志                                                            
    ,ON_OFF_ID                                --表内外资产标志                                                            
    ,ON_OFF_NAME                              --表内外资产名称                                                            
    ,SENIORITY_ID                             --优先债权标识                                                              
    ,SENIORITY_NAME                           --优先标识名称                                                              
    ,BOOK_TYPE_ID                             --账簿类型                                                                  
    ,BOOK_TYPE_NAME                           --账簿名称                                                                  
    ,BANK_CCY_CD                              --银行币种代码                                                              
    ,BIS_CCY_CD                               --计量币种代码                                                              
    ,BIS_CCY_NAME                             --计量币种名称                                                              
    ,BOOKKEEP_CNY_FLAG                        --记账本位币计价标志                                                        
    ,CCY_MISMATCH_FLAG                        --币种错配标志                                                              
    ,EXCHANGE_RATE                            --汇率                                                                      
    ,SUBJECT_CD                               --本金科目代码                                                              
    ,SUBJECT_NAME                             --本金科目名称                                                              
    ,ASSET_BALANCE                            --资产余额                                                                  
    ,ACCRUED_SUBJECT_CD                       --应计利息科目                                                              
    ,ACCRUED_SUBJECT_NAME                     --应计利息科目名称                                                          
    ,ACCRUED_INT                              --应计利息                                                                  
    ,RECEIVABLE_SUBJECT_CD                    --应收利息科目                                                              
    ,RECEIVABLE_SUBJECT_NAME                  --应收利息科目名称                                                          
    ,RECEIVABLE_INT                           --应收利息                                                                  
    ,INTADJ_SUBJECT_CD                        --利息调整科目                                                              
    ,INTADJ_SUBJECT_NAME                      --利息调整科目名称                                                          
    ,INT_ADJ                                  --利息调整                                                                  
    ,FAIRCHANGE_SUBJECT_CD                    --公允价值变动科目                                                          
    ,FAIRCHANGE_SUBJECT_NAME                  --公允价值变动科目名称                                                      
    ,FAIRVALUE_CHANGES                        --公允价值变动                                                              
    ,DEPREAMOR_SUBJECT_CD                     --折旧科目                                                                  
    ,DEPREAMOR_SUBJECT_NAME                   --折旧科目名称                                                              
    ,DEPRE_AMORTIZAT                          --折旧金额                                                                  
    ,OTHER_SUBJECT_CD                         --其他科目                                                                  
    ,OTHER_SUBJECT_NAME                       --其他科目名称                                                              
    ,OTHER_AMT                                --其他金额                                                                  
    ,PROVISION_SUBJECT_CD                     --准备金科目代码                                                            
    ,PROVISION_SUBJECT_NAME                   --准备金科目名称                                                            
    ,PROVISION                                --准备金                                                                    
    ,PROVESION_RATIO                          --准备金计提比例                                                            
    ,LOAN_FLAG                                --贷款标志                                                                  
    ,MCR_FLAG                                 --信用风险计量标志                                                          
    ,CROSS_BORDER_TRADE_FLAG                  --因跨境货物贸易标志                                                        
    ,ACCEPT_CREDIT_SELF_FLAG                  --自开信用证标志                                                            
    ,REAL_ESTATE_TYPE_CD                      --房地产风险暴露类型代码                                                    
    ,LTV                                      --LTV规则                                                                   
    ,ACCEPT_DISCOUNT_SELF_FLAG                --自承自贴标志                                                              
    ,SPE_LENDING_FLAG                         --专业贷款标志                                                              
    ,SPE_LENDING_TYPE                         --专业贷款分类                                                              
    ,OPERATION_PF_FLAG                        --项目融资运营阶段标识                                                      
    ,BOND_FOR_ACQUIR_NON_PERF_FLAG            --为收购国有银行不良贷款而定向发行的债券                                    
    ,BOND_PAY_ATTR_ID                         --地方债偿还属性标志                                                        
    ,GUARANTEED_BOND_FLAG                     --合格担保债券标志                                                          
    ,SEC_SP_RATING_CD                         --债券标普评级                                                              
    ,ACCOUNT_CLASSIFICATION                   --金融资产分类                                                              
    ,CANCEL_FLAG                              --随时可撤销标志                                                            
    ,OFF_ASSET_UNMEASURED_FLAG                --表外资产不计量标志                                                        
    ,UNUSED_PRL_TMEET_FLAG                    --符合标准的未使用额度标志                                                  
    ,EQUITY_INVEST_ATTR_IDENTI                --股权投资属性                                                              
    ,CAPITAL_TYPE_CD                          --金融机构股权投资类别 10-并表 20-大额少数 30-小额少数                      
    ,CORE_ONE_CAPITAL_DEDUCTION               --核心一级资本扣除金额                                                      
    ,OTH_ONE_CAPITAL_DEDUCTION                --其他核心一级资本扣除金额                                                  
    ,TWO_CAPITAL_DEDUCTION                    --二级资本扣除金额                                                          
    ,CORE_ONE_CAPITAL                         --股权投资余额，其中核心一级资本                                            
    ,OTH_ONE_CAPITAL                          --股权投资余额，其中其他核心一级资本                                        
    ,TWO_CAPITAL                              --股权投资余额，其中二级资本                                                
    ,BUS_REAL_PROPERTY_TYPE_CD                --抵债资产类别                                                              
    ,DEAL_TRADE_DAYS                          --自合约结算日起延迟交易的交易日数                                          
    ,CUST_MCR_FLAG                            --交易对手信用风险计量标志                                                  
    ,OWNERSHIP_TRANSFER_FLAG                  --所有权发生转移标志                                                        
    ,DERIVATIVES_TYPE_ID                      --衍生工具类型标识                                                          
    ,OVER_DERIVATIVES_FLAG                    --场外衍生工具标志                                                          
    ,UNDERLYING_ASSET_QLF_FLAG                --信用衍生品标的合格标志                                                    
    ,ADD_ON                                   --潜在风险暴露的附加因子                                                    
    ,CERTIFICATE                              --零售客户证件号                                                            
    ,RETAIL_CUST_INCOME_CCY_CD                --零售客户主要收入币种代码                                                  
    ,CUST_NO                                  --客户号                                                                    
    ,CUST_NAME                                --客户名称                                                                  
    ,CCP_TYPE_CD                              --交易对手类型代码                                                          
    ,CCP_TYPE_NAME                            --交易对手类型名称                                                          
    ,CCP_BTYPE_CD                             --交易对手大类代码                                                          
    ,CCP_BTYPE_NAME                           --交易对手大类名称                                                          
    ,BANK_COUNTRY_CD                          --银行注册国                                                                
    ,BIS_COUNTRY_CD                           --计量注册国家代码                                                          
    ,BIS_COUNTRY_NAME                         --注册国名称                                                                
    ,SOV_SP_LT_RATING_CD                      --注册国标普评级代码                                                        
    ,CUST_SP_LT_RATING_CD                     --客户标普评级                                                              
    ,SCRA_RATING                              --SCRA评级                                                                  
    ,INT_TRADE_FLAG                           --内部交易标志                                                              
    ,SOLO_INT_TRADE_FLAG                      --法人内部交易标志                                                          
    ,SEC_FLAG                                 --资产证券化标志                                                            
    ,SEC_ITEM_NO                              --资产证券化项目标志                                                        
    ,SEC_ROLE_ID                              --证券化角色标识 1:发起机构自持 2:投资机构 3：其他从事资产证券化参与机构    
    ,SEC_CATEGORY_ID                          --证券化类别标识                                                            
    ,SEC_EXPOSURE_TYPE_ID                     --证券化暴露类型标识                                                        
    ,ASSET_SEC_CR_TRANSFER_FLAG               --证券化售出资产是否实现信用风险转移标志                                    
    ,ANEW_ASSET_SEC_FLAG                      --再资产证券化标志                                                          
    ,NPL_SEC_FLAG                             --不良资产证券化标志                                                        
    ,SEC_PRIORITY_RATING_FLAG                 --证券化优先档次标志                                                        
    ,SEC_PRUDENT_MNG_FLAG                     --证券化审慎管理标志                                                        
    ,SEC_POOL_RISK_TYPE_CD                    --基础资产风险类型 1-合格不良资产证券化 2-不合格不良资产证券化 0-正常资产   
    ,SEC_STC_FLAG                             --资产证券化简单透明可比标志                                                
    ,SEC_OFF_EXPOSURE_ID                      --证券化表外暴露标识                                                        
    ,SEC_POOL_RWA                             --基础资产池RWA                                                             
    ,CASH_OVERDRAW_CANCEL_FLAG                --现金透支便利无条件可撤销标志                                              
    ,SEC_ITEMS_ISSUE_NO                       --资产证券化发行编号                                                        
    ,FM_HOLD_RATIO                            --资管产品持有比例                                                          
    ,FM_FIN_PRODUCT_AMT                       --资管产品所有者权益总额                                                    
    ,FM_LVG                                   --资管产品杠杆率                                                            
    ,FM_RWA_CCP                               --资管产品CCP风险加权资产                                                   
    ,FM_RWA_CVA                               --资管产品CVA                                                               
    ,FM_LINK_GET_WAY                          --资管产品基础资产获取方式                                                  
    ,FM_FLAG                                  --资管产品标志                                                              
    ,FM_PRODUCT_TYPE                          --资管产品类别                                                              
    ,EAD_ORIG                                 --原始风险暴露                                                              
    ,CCF                                      --表外信用风险转换系数                                                      
    ,EAD_AFTERCCF                             --转换后的风险暴露                                                          
    ,EAD_AFTERPRO                             --扣减准备金后的风险暴露                                                    
    ,RW                                       --权重                                                                      
    ,NET_SETTLEMENT_ID                        --净额结算标识                                                              
    ,NET_SETTLEMENT_NO                        --净额结算合约编号                                                          
    ,CRM_NO                                   --缓释物编号                                                                
    ,CRM_NAME                                 --缓释物名称                                                                
    ,BANK_CRM_TYPE_CD                         --银行缓释工具类型代码                                                      
    ,BANK_CRM_TYPE_NAME                       --银行缓释工具类型名称                                                      
    ,BIS_CRM_BTYPE_NAME                       --监管缓释工具大类名称                                                      
    ,BIS_CRM_TYPE_NAME                        --监管缓释工具类型名称                                                      
    ,BIS_CRM_BTYPE_CD                         --监管缓释工具大类代码                                                      
    ,BIS_CRM_TYPE_CD                          --监管缓释工具类型代码                                                      
    ,CRM_CCY_CD                               --缓释币种代码                                                              
    ,CRM_BIS_CCY_CD                           --缓释物计量币种代码                                                        
    ,CRM_AMT                                  --缓释金额                                                                  
    ,CRM_AMT_RMB                              --缓释金额折本币                                                            
    ,CRM_ORIG_MATURITY                        --缓释原始期限                                                              
    ,CRM_REMA_MATURITY                        --缓释剩余期限                                                              
    ,CRM_CUST_NO                              --缓释客户编号                                                              
    ,CRM_CUST_NAME                            --缓释客户名称                                                              
    ,CRM_CCP_TYPE_CD                          --缓释交易对手类型代码                                                      
    ,CRM_SP_RATING_CD                         --缓释交易对手评级                                                          
    ,CRM_SCRA_RATING                          --缓释交易对手SCRA评级                                                      
    ,CRM_REG_COUNTRY                          --缓释注册国                                                                
    ,CRM_SOV_SP_RATING_CD                     --缓释注册国标普评级代码                                                    
    ,CRM_BOND_PAY_ATTR_ID                     --地方债属性标识                                                            
    ,CRM_AMT_SPLIT                            --缓释金额拆分                                                              
    ,CRM_CCY_MIS_COEFF                        --缓释币种错配折扣系数                                                      
    ,CRM_MAT_MIS_COEFF                        --缓释期限错配系数                                                          
    ,CRM_FLOOR_MIS_COEFF                      --底线折扣系数                                                              
    ,CRM_RW                                   --缓释权重                                                                  
    ,AFTER_CRMRW                              --缓释后风险权重                                                            
    ,AFTER_CRMEAD                             --缓释后风险暴露                                                            
    ,AFTER_MITI_RWA                           --缓释后的风险加权资产                                                      
    ,REPORT_NO                                --报表编号                                                                  
    ,REPORT_LINE_NO                           --报表栏位号                                                                
    ,LOAD_DATE                                --加载日期                                                                  
    ,ETL_DT                                   --ETL处理日期                                                               
    ,ETL_TIMESTAMP                            --ETL处理时间戳                                                             
    )
  SELECT DATA_DATE                                --数据日期                                                                  
         ,VERSION_NO                               --计量版本号                                                                
         ,LOAN_REF_CRM_SPLIT_SEQ                   --缓释拆分序号                                                              
         ,SCENARIO_NO                              --业务情景编号 10-标准法 20-资产证券化 30-证券融资 40-场外衍生品 50-资管产品
         ,SA_CALCULATE_ID                          --标准法计量方法标识                                                        
         ,SA_CALCULATE_NAME                        --标准法计量方法名称                                                        
         ,CORPORATION                              --法人实体编号                                                              
         ,BANK_LEVEL                               --银行档次                                                                  
         ,CONSOL_CORPORATION                       --并表集团机构编号                                                          
         ,CONSOL_BANK_LEVEL                        --并表银行档次                                                              
         ,LOAN_REF_NO                              --债项编号                                                                  
         ,LOAN_REF_DESC                            --债项描述                                                                  
         ,CONTRACT_NO                              --合同编号                                                                  
         ,MAIN_GRNT_MTH_CD                         --主要担保方式代码                                                          
         ,ADT_GRNT_MTH_IND                         --附加担保方式                                                              
         ,DUE_ID                                   --债项号                                                                    
         ,SRC_SYSTEM_ID                            --来源系统标识                                                              
         ,ORG_PARTENT_NO                           --分行管户机构                                                              
         ,ORG_PARTENT_NAME                         --分行机构名称                                                              
         ,ORG_NO                                   --管户机构                                                                  
         ,ORG_NAME                                 --机构名称                                                                  
         ,ORG_ORDER_NO                             --机构排序号                                                                
         ,ACCORG_PARTENT_NO                        --分行账务机构                                                              
         ,ACCORG_PARTENT_NAME                      --分行账务机构名称                                                          
         ,ACCORG_NO                                --账务机构                                                                  
         ,ACCORG_NAME                              --账务机构名称                                                              
         ,BANK_REGION_CD                           --银行地域代码                                                              
         ,BIS_REGION_CD                            --监管区域代码                                                              
         ,BIS_REGION_NAME                          --监管区域名称                                                              
         ,LOAN_REF_INV_INDU_CD                     --投向行业代码                                                              
         ,CUST_INDUSTRY_CD                         --客户所属行业代码                                                          
         ,BIS_INDUSTRY_CD                          --计量行业代码                                                              
         ,BIS_INDUSTRY_NAME                        --计量行业名称                                                              
         ,FIVE_CLASS_CD                            --五级分类代码                                                              
         ,FIVE_CLASS_NAME                          --五级分类名称                                                              
         ,PRODUCT_CD                               --产品代码                                                                  
         ,PRODUCT_NAME                             --产品名称                                                                  
         ,BIS_PRODUCT_TYPE_CD                      --监管产品类型代码                                                          
         ,BIS_PRODUCT_TYPE_NAME                    --监管产品类型名称                                                          
         ,BIS_PRODUCT_BTYPE_CD                     --监管产品大类代码                                                          
         ,BIS_PRODUCT_BTYPE_NAME                   --监管产品大类名称                                                          
         ,SA_EXP_CLASS_CD                          --标准法风险暴露分类                                                        
         ,SA_EXP_CLASS_NAME                        --标准法风险暴露分类名称                                                    
         ,SA_EXP_SUB_CLASS_CD                      --标准法风险暴露大类                                                        
         ,SA_EXP_SUB_CLASS_NAME                    --标准法风险暴露大类名称                                                    
         ,ITEM_OFF_CCF_BTYPE_CD                    --表外CCF项目大类代码                                                       
         ,ITEM_OFF_CCF_BTYPE_NAME                  --表外CCF项目大类名称                                                       
         ,ITEM_OFF_CCF_TYPE_CD                     --表外CCF项目类型代码                                                       
         ,ITEM_OFF_CCF_TYPE_NAME                   --表外CCF项目类型名称                                                       
         ,BUSINESS_LINE_CD                         --业务条线代码                                                              
         ,BUSINESS_LINE_NAME                       --业务条线名称                                                              
         ,BUSS_TYPE_CD                             --业务类型                                                                  
         ,BUSS_TYPE_NAME                           --业务名称                                                                  
         ,START_DATE                               --开始日期                                                                  
         ,DUE_DATE                                 --到期日期                                                                  
         ,ORIG_MATURITY                            --原始期限                                                                  
         ,REMA_MATURITY                            --剩余期限                                                                  
         ,OVERDUE_DAYS                             --逾期天数                                                                  
         ,STD_DEFAULT_FLAG                         --权重法违约标志                                                            
         ,ON_OFF_ID                                --表内外资产标志                                                            
         ,ON_OFF_NAME                              --表内外资产名称                                                            
         ,SENIORITY_ID                             --优先债权标识                                                              
         ,SENIORITY_NAME                           --优先标识名称                                                              
         ,BOOK_TYPE_ID                             --账簿类型                                                                  
         ,BOOK_TYPE_NAME                           --账簿名称                                                                  
         ,BANK_CCY_CD                              --银行币种代码                                                              
         ,BIS_CCY_CD                               --计量币种代码                                                              
         ,BIS_CCY_NAME                             --计量币种名称                                                              
         ,BOOKKEEP_CNY_FLAG                        --记账本位币计价标志                                                        
         ,CCY_MISMATCH_FLAG                        --币种错配标志                                                              
         ,EXCHANGE_RATE                            --汇率                                                                      
         ,SUBJECT_CD                               --本金科目代码                                                              
         ,SUBJECT_NAME                             --本金科目名称                                                              
         ,ASSET_BALANCE                            --资产余额                                                                  
         ,ACCRUED_SUBJECT_CD                       --应计利息科目                                                              
         ,ACCRUED_SUBJECT_NAME                     --应计利息科目名称                                                          
         ,ACCRUED_INT                              --应计利息                                                                  
         ,RECEIVABLE_SUBJECT_CD                    --应收利息科目                                                              
         ,RECEIVABLE_SUBJECT_NAME                  --应收利息科目名称                                                          
         ,RECEIVABLE_INT                           --应收利息                                                                  
         ,INTADJ_SUBJECT_CD                        --利息调整科目                                                              
         ,INTADJ_SUBJECT_NAME                      --利息调整科目名称                                                          
         ,INT_ADJ                                  --利息调整                                                                  
         ,FAIRCHANGE_SUBJECT_CD                    --公允价值变动科目                                                          
         ,FAIRCHANGE_SUBJECT_NAME                  --公允价值变动科目名称                                                      
         ,FAIRVALUE_CHANGES                        --公允价值变动                                                              
         ,DEPREAMOR_SUBJECT_CD                     --折旧科目                                                                  
         ,DEPREAMOR_SUBJECT_NAME                   --折旧科目名称                                                              
         ,DEPRE_AMORTIZAT                          --折旧金额                                                                  
         ,OTHER_SUBJECT_CD                         --其他科目                                                                  
         ,OTHER_SUBJECT_NAME                       --其他科目名称                                                              
         ,OTHER_AMT                                --其他金额                                                                  
         ,PROVISION_SUBJECT_CD                     --准备金科目代码                                                            
         ,PROVISION_SUBJECT_NAME                   --准备金科目名称                                                            
         ,PROVISION                                --准备金                                                                    
         ,PROVESION_RATIO                          --准备金计提比例                                                            
         ,LOAN_FLAG                                --贷款标志                                                                  
         ,MCR_FLAG                                 --信用风险计量标志                                                          
         ,CROSS_BORDER_TRADE_FLAG                  --因跨境货物贸易标志                                                        
         ,ACCEPT_CREDIT_SELF_FLAG                  --自开信用证标志                                                            
         ,REAL_ESTATE_TYPE_CD                      --房地产风险暴露类型代码                                                    
         ,LTV                                      --LTV规则                                                                   
         ,ACCEPT_DISCOUNT_SELF_FLAG                --自承自贴标志                                                              
         ,SPE_LENDING_FLAG                         --专业贷款标志                                                              
         ,SPE_LENDING_TYPE                         --专业贷款分类                                                              
         ,OPERATION_PF_FLAG                        --项目融资运营阶段标识                                                      
         ,BOND_FOR_ACQUIR_NON_PERF_FLAG            --为收购国有银行不良贷款而定向发行的债券                                    
         ,BOND_PAY_ATTR_ID                         --地方债偿还属性标志                                                        
         ,GUARANTEED_BOND_FLAG                     --合格担保债券标志                                                          
         ,SEC_SP_RATING_CD                         --债券标普评级                                                              
         ,ACCOUNT_CLASSIFICATION                   --金融资产分类                                                              
         ,CANCEL_FLAG                              --随时可撤销标志                                                            
         ,OFF_ASSET_UNMEASURED_FLAG                --表外资产不计量标志                                                        
         ,UNUSED_PRL_TMEET_FLAG                    --符合标准的未使用额度标志                                                  
         ,EQUITY_INVEST_ATTR_IDENTI                --股权投资属性                                                              
         ,CAPITAL_TYPE_CD                          --金融机构股权投资类别 10-并表 20-大额少数 30-小额少数                      
         ,CORE_ONE_CAPITAL_DEDUCTION               --核心一级资本扣除金额                                                      
         ,OTH_ONE_CAPITAL_DEDUCTION                --其他核心一级资本扣除金额                                                  
         ,TWO_CAPITAL_DEDUCTION                    --二级资本扣除金额                                                          
         ,CORE_ONE_CAPITAL                         --股权投资余额，其中核心一级资本                                            
         ,OTH_ONE_CAPITAL                          --股权投资余额，其中其他核心一级资本                                        
         ,TWO_CAPITAL                              --股权投资余额，其中二级资本                                                
         ,BUS_REAL_PROPERTY_TYPE_CD                --抵债资产类别                                                              
         ,DEAL_TRADE_DAYS                          --自合约结算日起延迟交易的交易日数                                          
         ,CUST_MCR_FLAG                            --交易对手信用风险计量标志                                                  
         ,OWNERSHIP_TRANSFER_FLAG                  --所有权发生转移标志                                                        
         ,DERIVATIVES_TYPE_ID                      --衍生工具类型标识                                                          
         ,OVER_DERIVATIVES_FLAG                    --场外衍生工具标志                                                          
         ,UNDERLYING_ASSET_QLF_FLAG                --信用衍生品标的合格标志                                                    
         ,ADD_ON                                   --潜在风险暴露的附加因子                                                    
         ,CERTIFICATE                              --零售客户证件号                                                            
         ,RETAIL_CUST_INCOME_CCY_CD                --零售客户主要收入币种代码                                                  
         ,CUST_NO                                  --客户号                                                                    
         ,CUST_NAME                                --客户名称                                                                  
         ,CCP_TYPE_CD                              --交易对手类型代码                                                          
         ,CCP_TYPE_NAME                            --交易对手类型名称                                                          
         ,CCP_BTYPE_CD                             --交易对手大类代码                                                          
         ,CCP_BTYPE_NAME                           --交易对手大类名称                                                          
         ,BANK_COUNTRY_CD                          --银行注册国                                                                
         ,BIS_COUNTRY_CD                           --计量注册国家代码                                                          
         ,BIS_COUNTRY_NAME                         --注册国名称                                                                
         ,SOV_SP_LT_RATING_CD                      --注册国标普评级代码                                                        
         ,CUST_SP_LT_RATING_CD                     --客户标普评级                                                              
         ,SCRA_RATING                              --SCRA评级                                                                  
         ,INT_TRADE_FLAG                           --内部交易标志                                                              
         ,SOLO_INT_TRADE_FLAG                      --法人内部交易标志                                                          
         ,SEC_FLAG                                 --资产证券化标志                                                            
         ,SEC_ITEM_NO                              --资产证券化项目标志                                                        
         ,SEC_ROLE_ID                              --证券化角色标识 1:发起机构自持 2:投资机构 3：其他从事资产证券化参与机构    
         ,SEC_CATEGORY_ID                          --证券化类别标识                                                            
         ,SEC_EXPOSURE_TYPE_ID                     --证券化暴露类型标识                                                        
         ,ASSET_SEC_CR_TRANSFER_FLAG               --证券化售出资产是否实现信用风险转移标志                                    
         ,ANEW_ASSET_SEC_FLAG                      --再资产证券化标志                                                          
         ,NPL_SEC_FLAG                             --不良资产证券化标志                                                        
         ,SEC_PRIORITY_RATING_FLAG                 --证券化优先档次标志                                                        
         ,SEC_PRUDENT_MNG_FLAG                     --证券化审慎管理标志                                                        
         ,SEC_POOL_RISK_TYPE_CD                    --基础资产风险类型 1-合格不良资产证券化 2-不合格不良资产证券化 0-正常资产   
         ,SEC_STC_FLAG                             --资产证券化简单透明可比标志                                                
         ,SEC_OFF_EXPOSURE_ID                      --证券化表外暴露标识                                                        
         ,SEC_POOL_RWA                             --基础资产池RWA                                                             
         ,CASH_OVERDRAW_CANCEL_FLAG                --现金透支便利无条件可撤销标志                                              
         ,SEC_ITEMS_ISSUE_NO                       --资产证券化发行编号                                                        
         ,FM_HOLD_RATIO                            --资管产品持有比例                                                          
         ,FM_FIN_PRODUCT_AMT                       --资管产品所有者权益总额                                                    
         ,FM_LVG                                   --资管产品杠杆率                                                            
         ,FM_RWA_CCP                               --资管产品CCP风险加权资产                                                   
         ,FM_RWA_CVA                               --资管产品CVA                                                               
         ,FM_LINK_GET_WAY                          --资管产品基础资产获取方式                                                  
         ,FM_FLAG                                  --资管产品标志                                                              
         ,FM_PRODUCT_TYPE                          --资管产品类别                                                              
         ,EAD_ORIG                                 --原始风险暴露                                                              
         ,CCF                                      --表外信用风险转换系数                                                      
         ,EAD_AFTERCCF                             --转换后的风险暴露                                                          
         ,EAD_AFTERPRO                             --扣减准备金后的风险暴露                                                    
         ,RW                                       --权重                                                                      
         ,NET_SETTLEMENT_ID                        --净额结算标识                                                              
         ,NET_SETTLEMENT_NO                        --净额结算合约编号                                                          
         ,CRM_NO                                   --缓释物编号                                                                
         ,CRM_NAME                                 --缓释物名称                                                                
         ,BANK_CRM_TYPE_CD                         --银行缓释工具类型代码                                                      
         ,BANK_CRM_TYPE_NAME                       --银行缓释工具类型名称                                                      
         ,BIS_CRM_BTYPE_NAME                       --监管缓释工具大类名称                                                      
         ,BIS_CRM_TYPE_NAME                        --监管缓释工具类型名称                                                      
         ,BIS_CRM_BTYPE_CD                         --监管缓释工具大类代码                                                      
         ,BIS_CRM_TYPE_CD                          --监管缓释工具类型代码                                                      
         ,CRM_CCY_CD                               --缓释币种代码                                                              
         ,CRM_BIS_CCY_CD                           --缓释物计量币种代码                                                        
         ,CRM_AMT                                  --缓释金额                                                                  
         ,CRM_AMT_RMB                              --缓释金额折本币                                                            
         ,CRM_ORIG_MATURITY                        --缓释原始期限                                                              
         ,CRM_REMA_MATURITY                        --缓释剩余期限                                                              
         ,CRM_CUST_NO                              --缓释客户编号                                                              
         ,CRM_CUST_NAME                            --缓释客户名称                                                              
         ,CRM_CCP_TYPE_CD                          --缓释交易对手类型代码                                                      
         ,CRM_SP_RATING_CD                         --缓释交易对手评级                                                          
         ,CRM_SCRA_RATING                          --缓释交易对手SCRA评级                                                      
         ,CRM_REG_COUNTRY                          --缓释注册国                                                                
         ,CRM_SOV_SP_RATING_CD                     --缓释注册国标普评级代码                                                    
         ,CRM_BOND_PAY_ATTR_ID                     --地方债属性标识                                                            
         ,CRM_AMT_SPLIT                            --缓释金额拆分                                                              
         ,CRM_CCY_MIS_COEFF                        --缓释币种错配折扣系数                                                      
         ,CRM_MAT_MIS_COEFF                        --缓释期限错配系数                                                          
         ,CRM_FLOOR_MIS_COEFF                      --底线折扣系数                                                              
         ,CRM_RW                                   --缓释权重                                                                  
         ,AFTER_CRMRW                              --缓释后风险权重                                                            
         ,AFTER_CRMEAD                             --缓释后风险暴露                                                            
         ,AFTER_MITI_RWA                           --缓释后的风险加权资产                                                      
         ,REPORT_NO                                --报表编号                                                                  
         ,REPORT_LINE_NO                           --报表栏位号                                                                
         ,LOAD_DATE                                --加载日期                                                                  
         ,ETL_DT                                   --ETL处理日期                                                               
         ,ETL_TIMESTAMP                            --ETL处理时间戳      
    FROM IOL.V_RWAS_MR_SA_RWA_RESULT_DETAIL      --计量_RWA计量明细结果表 
   WHERE --SRC_SYSTEM_ID IN ('CTMS/IBM','CTMS','IBMS','RWA','FBS') --MOD BY YJY 20241127 EAST5.0建议暂时先接这几个系统来源的数据，其他来源数据量太大
         SRC_SYSTEM_ID NOT IN ('LHWD','BDMX')
     AND LOAN_REF_DESC NOT LIKE '%贷款%'
     AND ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_RWAS_MR_SA_RWA_RESULT_DETAIL', '', O_ERRCODE);

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

END ETL_O_IOL_RWAS_MR_SA_RWA_RESULT_DETAIL;
/

