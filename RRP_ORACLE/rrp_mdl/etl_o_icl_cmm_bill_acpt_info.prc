CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_BILL_ACPT_INFO(I_P_DATE IN INTEGER,
                                                         O_ERRCODE OUT VARCHAR2
                                                        )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_BILL_ACPT_INFO
  *  功能描述：票据承兑信息
  *  创建日期：20230905
  *  开发人员：hulj
  *  来源表： ICL.V_CMM_BILL_ACPT_INFO
  *  目标表： O_ICL_CMM_BILL_ACPT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230905  hulj     首次创建
  *             2    20230918  HYF      DELETE语句调整
  *             3    20250410  YJY      新增承兑协议批次编号
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_BILL_ACPT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_ICL_CMM_BILL_ACPT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_ICL_CMM_BILL_ACPT_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-票据承兑信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_BILL_ACPT_INFO
    (ETL_DT                                   --数据日期            
    ,LP_ID                                    --法人编号            
    ,BUS_ID                                   --业务编号            
    ,BATCH_ID                                 --批次编号            
    ,BILL_ENTRY_ID                            --票据记账编号        
    ,BILL_ID                                  --票据编号            
    ,BILL_NUM                                 --票据号码            
    ,BILL_SUB_INTRV_ID                        --子票据区间编号      
    ,CUST_ID                                  --客户编号            
    ,BILL_MED_CD                              --票据介质代码        
    ,BILL_KIND_CD                             --票据种类代码        
    ,APPL_DT                                  --申请日期            
    ,RECV_DT                                  --签收日期            
    ,DRAW_DT                                  --出票日期            
    ,EXP_DT                                   --到期日期            
    ,DIR_INDUS_NAME                           --投向行业名称        
    ,MAIN_GUAR_WAY_CD                         --主担保方式代码      
    ,DRAWER_NAME                              --出票人名称          
    ,DRAWER_CATE_CD                           --出票人类别代码      
    ,DRAWER_ACCT_NUM                          --出票人账号          
    ,DRAWER_OPEN_BANK_NO                      --出票人开户行行号    
    ,DRAWER_OPEN_BANK_NAME                    --出票人开户行名称    
    ,ACCPTOR_NAME                             --承兑人名称          
    ,ACCPTOR_ACCT_NUM                         --承兑人账号          
    ,ACCPTOR_OPEN_BANK_NO                     --承兑人开户行行号    
    ,ACCPTOR_OPEN_BANK_NAME                   --承兑人开户行名称    
    ,RECVER_CUST_ID                           --收款人客户编号      
    ,RECVER_NAME                              --收款人名称          
    ,RECVER_ACCT_NUM                          --收款人账号          
    ,RECVER_OPEN_BANK_NO                      --收款人开户行行号    
    ,RECVER_OPEN_BANK_NAME                    --收款人开户行名称    
    ,REPAY_NUM                                --还款账号            
    ,ENTRY_DT                                 --记账日期            
    ,REVO_DT                                  --撤销日期            
    ,BUS_FLOW_NUM                             --业务流水号          
    ,MARGIN_RATIO                             --保证金比例          
    ,COMM_FEE_RATIO                           --手续费比例          
    ,ENTRY_STATUS_CD                          --记账状态代码        
    ,DRAW_STATUS_CD                           --出票状态代码        
    ,BILL_ACPT_STATUS_CD                      --承兑状态代码        
    ,TRANBL_FLG                               --可转让标志          
    ,UNCOND_PAY_FLG                           --无条件支付标志      
    ,CURR_CD                                  --币种代码            
    ,FAC_VAL_AMT                              --票面金额            
    ,PAYOFF_FLG                               --结清标志            
    ,LMT_OCUP_AMT                             --额度占用金额        
    ,LMT_OCUP_STATUS_CD                       --额度占用状态代码    
    ,COMM_FEE                                 --手续费              
    ,TODOS                                    --工本费              
    ,ACPT_FEE                                 --承兑费              
    ,MGMT_FEE                                 --管理费              
    ,ACCPTOR_CRDT_LEVEL_CD                    --承兑人信用等级代码  
    ,ACCPTOR_RATING_EXP_DT                    --承兑人评级到期日期  
    ,ISSUE_ORG_ID                             --签发机构编号        
    ,ENTER_ACCT_ORG_ID                        --入账机构编号        
    ,CUST_MGR_ID                              --客户经理编号        
    ,DEPT_ID                                  --部门编号            
    ,OPERR_ID                                 --操作员编号          
    ,GROUP_OPEN_FLG                           --集团代开标志        
    ,GROUP_NAME                               --集团名称            
    ,GROUP_ID                                 --集团编号            
    ,GROUP_OPEN_DRAWER_NAME                   --集团代开出票人名称  
    ,GROUP_OPEN_DRAWER_CUST_NO                --集团代开出票人客户号
    ,RELA_PARTY_QUE_REST_CD                   --关联方查询结果代码  
    ,JOB_CD                                   --任务代码            
    ,ETL_TIMESTAMP                            --数据处理时间 
    ,ACPT_AGT_BATCH_ID                        --承兑协议批次编号  ADD BY YJY 20250410
    )
  SELECT ETL_DT                                    --数据日期            
        ,LP_ID                                    --法人编号            
        ,BUS_ID                                   --业务编号            
        ,BATCH_ID                                 --批次编号            
        ,BILL_ENTRY_ID                            --票据记账编号        
        ,BILL_ID                                  --票据编号            
        ,BILL_NUM                                 --票据号码            
        ,BILL_SUB_INTRV_ID                        --子票据区间编号      
        ,CUST_ID                                  --客户编号            
        ,BILL_MED_CD                              --票据介质代码        
        ,BILL_KIND_CD                             --票据种类代码        
        ,APPL_DT                                  --申请日期            
        ,RECV_DT                                  --签收日期            
        ,DRAW_DT                                  --出票日期            
        ,EXP_DT                                   --到期日期            
        ,DIR_INDUS_NAME                           --投向行业名称        
        ,MAIN_GUAR_WAY_CD                         --主担保方式代码      
        ,DRAWER_NAME                              --出票人名称          
        ,DRAWER_CATE_CD                           --出票人类别代码      
        ,DRAWER_ACCT_NUM                          --出票人账号          
        ,DRAWER_OPEN_BANK_NO                      --出票人开户行行号    
        ,DRAWER_OPEN_BANK_NAME                    --出票人开户行名称    
        ,ACCPTOR_NAME                             --承兑人名称          
        ,ACCPTOR_ACCT_NUM                         --承兑人账号          
        ,ACCPTOR_OPEN_BANK_NO                     --承兑人开户行行号    
        ,ACCPTOR_OPEN_BANK_NAME                   --承兑人开户行名称    
        ,RECVER_CUST_ID                           --收款人客户编号      
        ,RECVER_NAME                              --收款人名称          
        ,RECVER_ACCT_NUM                          --收款人账号          
        ,RECVER_OPEN_BANK_NO                      --收款人开户行行号    
        ,RECVER_OPEN_BANK_NAME                    --收款人开户行名称    
        ,REPAY_NUM                                --还款账号            
        ,ENTRY_DT                                 --记账日期            
        ,REVO_DT                                  --撤销日期            
        ,BUS_FLOW_NUM                             --业务流水号          
        ,MARGIN_RATIO                             --保证金比例          
        ,COMM_FEE_RATIO                           --手续费比例          
        ,ENTRY_STATUS_CD                          --记账状态代码        
        ,DRAW_STATUS_CD                           --出票状态代码        
        ,BILL_ACPT_STATUS_CD                      --承兑状态代码        
        ,TRANBL_FLG                               --可转让标志          
        ,UNCOND_PAY_FLG                           --无条件支付标志      
        ,CURR_CD                                  --币种代码            
        ,FAC_VAL_AMT                              --票面金额            
        ,PAYOFF_FLG                               --结清标志            
        ,LMT_OCUP_AMT                             --额度占用金额        
        ,LMT_OCUP_STATUS_CD                       --额度占用状态代码    
        ,COMM_FEE                                 --手续费              
        ,TODOS                                    --工本费              
        ,ACPT_FEE                                 --承兑费              
        ,MGMT_FEE                                 --管理费              
        ,ACCPTOR_CRDT_LEVEL_CD                    --承兑人信用等级代码  
        ,ACCPTOR_RATING_EXP_DT                    --承兑人评级到期日期  
        ,ISSUE_ORG_ID                             --签发机构编号        
        ,ENTER_ACCT_ORG_ID                        --入账机构编号        
        ,CUST_MGR_ID                              --客户经理编号        
        ,DEPT_ID                                  --部门编号            
        ,OPERR_ID                                 --操作员编号          
        ,GROUP_OPEN_FLG                           --集团代开标志        
        ,GROUP_NAME                               --集团名称            
        ,GROUP_ID                                 --集团编号            
        ,GROUP_OPEN_DRAWER_NAME                   --集团代开出票人名称  
        ,GROUP_OPEN_DRAWER_CUST_NO                --集团代开出票人客户号
        ,RELA_PARTY_QUE_REST_CD                   --关联方查询结果代码  
        ,JOB_CD                                   --任务代码            
        ,ETL_TIMESTAMP                            --数据处理时间 
        ,ACPT_AGT_BATCH_ID                        --承兑协议批次编号 ADD BY YJY 20250410
    FROM ICL.V_CMM_BILL_ACPT_INFO  --视图-票据承兑信息
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_ICL_CMM_BILL_ACPT_INFO','', O_ERRCODE);

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

END ETL_O_ICL_CMM_BILL_ACPT_INFO;
/

