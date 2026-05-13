CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_RDW_RML_R02_CORP_LOAN_PROMIS(I_P_DATE IN INTEGER,
                                                               O_ERRCODE OUT VARCHAR2
                                                            )
  /**************************************************************************
  *  程序名称：ETL_O_RDW_RML_R02_CORP_LOAN_PROMIS
  *  功能描述：风险集市_R02_公司贷款承诺明细
  *  创建日期：20240516
  *  开发人员：YJY
  *  来源表： RDW.V_RML_R02_CORP_LOAN_PROMIS
  *  目标表： O_RDW_RML_R02_CORP_LOAN_PROMIS
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240516  YJY      首次创建
  *             2    20260105  YJY      新增 固定资产贷款归还金额
  *             3    20260415  YJY      新增业务合同币种、固定资产贷款归还金额（折人民币）
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_RDW_RML_R02_CORP_LOAN_PROMIS'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_RDW_RML_R02_CORP_LOAN_PROMIS T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '风险集市-R02_公司贷款承诺明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_RDW_RML_R02_CORP_LOAN_PROMIS
    (
      CUST_ID                          --客户编号                          
     ,CUST_NAME                        --客户名称                          
     ,CORP_SIZE_CD                     --企业规模代码                      
     ,INDUS_TYPE_CD                    --行业类型代码                      
     ,BELONG_ORG                       --客户所属机构                      
     ,LMT_CONT_ID                      --额度合同编号                      
     ,LMT_PROD_NO                      --额度产品编号                      
     ,CURR_CD                          --币种代码                          
     ,LMT_PROD_OPER_ORG                --额度产品经办机构                  
     ,LMT_PROD_MGMT_ORG                --额度产品管理机构                  
     ,LMT_CONT_AMT                     --额度合同金额                      
     ,GROUP_CRDT_CONT_ID               --集团授信合同编号                  
     ,GROUP_CRDT_PROD_NO               --集团授信产品号                    
     ,GROUP_CRDT_LMT_CONT_STATUS       --集团授信额度合同状态              
     ,CRDT_APV_ID                      --授信审批编号                      
     ,LMT_CONT_STATUS                  --额度合同状态                      
     ,LMT_CONT_CIRCL_FLG               --额度合同循环标志                  
     ,LMT_CONT_FROZ_FLG                --额度合同冻结标志                  
     ,CONT_BAL                         --合同余额                          
     ,LMT_CONT_START_DT                --额度合同开始日期                  
     ,LMT_CONT_EXP_DT                  --额度合同到期日期                  
     ,BUS_CONT_START_DT                --业务合同开始日期                  
     ,BUS_CONT_EXP_DT                  --业务合同到期日期                  
     ,LOAN_LEVEL10_CLS_CD              --贷款十级分类代码                  
     ,OVDUE_DAYS                       --逾期天数                          
     ,DIR_INDUS_CD                     --投向行业代码                      
     ,TURN_CRDT_FLG                    --转授信标志                        
     ,TEXT_CONT_ID                     --文本合同编号                      
     ,LMT_CONT_NMAL_AVAL_AMT           --额度合同的名义可用金额            
     ,SIGN_LMT_CONT_PROMIS_BAL         --签署额度合同承诺余额（剩余额度）  
     ,NOT_SIGN_LMT_CONT_PROMIS_BAL     --未签署额度合同承诺余额（剩余额度）
     ,BUS_CONT_ID                      --业务合同编号                      
     ,BUS_CONT_PROD_ID                 --业务合同产品编号                  
     ,BUS_CONT_RGST_ORG                --业务合同登记机构                  
     ,BUS_CONT_STATUS                  --业务合同状态                      
     ,BUS_CONT_FROZ_FLG                --业务合同冻结标志                  
     ,BUS_CONT_AMT                     --业务合同金额                      
     ,BUS_CONT_DISTR_AMT               --业务合同放款金额                  
     ,BUS_CONT_UNDISTR_MONEY_AMT       --业务合同未放款金额                
     ,BUS_CONT_BAL_CNY                 --业务合同余额（折人民币）          
     ,ETL_DT                           --数据日期                          
     ,GROUP_NO                         --组号   
     ,FIX_ASSET_LOAN_RTN_AMT           --固定资产贷款归还金额     ADD BY YJY 20260105    
     ,BUS_CONT_CURR_CD                 --业务合同币种 ADD BY YJY 20260415 
     ,FIX_ASSET_LOAN_RTN_AMT_CNY       --固定资产贷款归还金额（折人民币）  ADD BY YJY 20260415                  
    )
  SELECT                 
     CUST_ID                          --客户编号                          
     ,CUST_NAME                        --客户名称                          
     ,CORP_SIZE_CD                     --企业规模代码                      
     ,INDUS_TYPE_CD                    --行业类型代码                      
     ,BELONG_ORG                       --客户所属机构                      
     ,LMT_CONT_ID                      --额度合同编号                      
     ,LMT_PROD_NO                      --额度产品编号                      
     ,CURR_CD                          --币种代码                          
     ,LMT_PROD_OPER_ORG                --额度产品经办机构                  
     ,LMT_PROD_MGMT_ORG                --额度产品管理机构                  
     ,LMT_CONT_AMT                     --额度合同金额                      
     ,GROUP_CRDT_CONT_ID               --集团授信合同编号                  
     ,GROUP_CRDT_PROD_NO               --集团授信产品号                    
     ,GROUP_CRDT_LMT_CONT_STATUS       --集团授信额度合同状态              
     ,CRDT_APV_ID                      --授信审批编号                      
     ,LMT_CONT_STATUS                  --额度合同状态                      
     ,LMT_CONT_CIRCL_FLG               --额度合同循环标志                  
     ,LMT_CONT_FROZ_FLG                --额度合同冻结标志                  
     ,CONT_BAL                         --合同余额                          
     ,LMT_CONT_START_DT                --额度合同开始日期                  
     ,LMT_CONT_EXP_DT                  --额度合同到期日期                  
     ,BUS_CONT_START_DT                --业务合同开始日期                  
     ,BUS_CONT_EXP_DT                  --业务合同到期日期                  
     ,LOAN_LEVEL10_CLS_CD              --贷款十级分类代码                  
     ,OVDUE_DAYS                       --逾期天数                          
     ,DIR_INDUS_CD                     --投向行业代码                      
     ,TURN_CRDT_FLG                    --转授信标志                        
     ,TEXT_CONT_ID                     --文本合同编号                      
     ,LMT_CONT_NMAL_AVAL_AMT           --额度合同的名义可用金额            
     ,SIGN_LMT_CONT_PROMIS_BAL         --签署额度合同承诺余额（剩余额度）  
     ,NOT_SIGN_LMT_CONT_PROMIS_BAL     --未签署额度合同承诺余额（剩余额度）
     ,BUS_CONT_ID                      --业务合同编号                      
     ,BUS_CONT_PROD_ID                 --业务合同产品编号                  
     ,BUS_CONT_RGST_ORG                --业务合同登记机构                  
     ,BUS_CONT_STATUS                  --业务合同状态                      
     ,BUS_CONT_FROZ_FLG                --业务合同冻结标志                  
     ,BUS_CONT_AMT                     --业务合同金额                      
     ,BUS_CONT_DISTR_AMT               --业务合同放款金额                  
     ,BUS_CONT_UNDISTR_MONEY_AMT       --业务合同未放款金额                
     ,BUS_CONT_BAL_CNY                 --业务合同余额（折人民币）          
     ,ETL_DT                           --数据日期                          
     ,GROUP_NO                         --组号  
     ,FIX_ASSET_LOAN_RTN_AMT           --固定资产贷款归还金额     ADD BY YJY 20260105 
     ,BUS_CONT_CURR_CD                 --业务合同币种 ADD BY YJY 20260415     
     ,FIX_ASSET_LOAN_RTN_AMT_CNY       --固定资产贷款归还金额（折人民币）  ADD BY YJY 20260415                                                
    FROM RDW.V_RML_R02_CORP_LOAN_PROMIS  --视图-风险集市R02_公司贷款承诺明细
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --分析表
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, 'O_RDW_RML_R02_CORP_LOAN_PROMIS', '', O_ERRCODE);
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_RDW_RML_R02_CORP_LOAN_PROMIS;
/

