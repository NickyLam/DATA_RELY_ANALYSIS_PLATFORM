CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_CLASSIFY_APPLY(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_CLASSIFY_APPLY
  *  功能描述：风险分类申请表
  *  创建日期：20240730
  *  开发人员：YJY
  *  来源表： IOL.V_ICMS_CLASSIFY_APPLY
  *  目标表： O_IOL_ICMS_CLASSIFY_APPLY
  *  配置表：
  *  修改情况：序号  修改日期  修改人    修改原因
  *             1    20240730  YJY      首次创建
  *             2    20250106  YJY      优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := '0'; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_CLASSIFY_APPLY'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_CLASSIFY_APPLY';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-风险分类申请表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_CLASSIFY_APPLY
  (
            SERIALNO                      --流水号                          
           ,CREDITAGGREEMENT              --额度合同号                      
           ,RELATIVETYPE                  --关联类型                        
           ,FINALPOLICYRESULT             --终审策略分类                    
           ,FINALCUSTOMERLEVEL            --终审监测评级                    
           ,INPUTUSERID                   --登记人                          
           ,FLAG                          --标记                            
           ,RELATIVESERIALNO              --关联流水号                      
           ,ISCURRENTMONTH                --是否本月新发生                  
           ,TOTALSUM                      --敞口                            
           ,MATURITY                      --到期日                          
           ,VOUCHTYPE                     --担保类型                        
           ,LEVELCLASSIFY                 --评级对应的风险分类              
           ,KERNALADJUSTLEVEL             --                                
           ,ALARMINFO                     --                                
           ,ENTRANCE                      --申请发起入口1对公系统，2同业系统
           ,OBJECTTYPE                    --对象类型                        
           ,BUSINESSTYPE                  --业务类型                        
           ,BUSINESSCURRENCY              --业务币种                        
           ,INPUTORGID                    --登记机构                        
           ,POLICYRESULT                  --本期申请策略分类                
           ,UPDATEORGID                   --更新时间                        
           ,UPDATEDATE                    --更新日期                        
           ,TYPE                          --类型                            
           ,LICENSEDATE                   --营业执照登记日                  
           ,APPROVECLASSIFYRESULT         --审批环节风险分类                
           ,LASTCUSTOMERLEVEL             --上期监测评级                    
           ,UPDATEUSERID                  --更新人                          
           ,PIGEONHOLEDATE                --归案日期                        
           ,CONTRACTSERIALNO              --合同号                          
           ,REMARK1                       --意见                            
           ,CUSTOMERLEVEL                 --信用评级                        
           ,CLASSIFYNUM                   --分类笔数                        
           ,ACCOUNTMONTH                  --分类截至日期                    
           ,CUSTOMERID                    --客户号                          
           ,RELATIVENO                    --关联号                          
           ,INPUTDATE                     --登记日期                        
           ,APPROVECLASSIFYTIME           --审批时间                        
           ,COVERAGE                      --担保覆盖率                      
           ,ASSURECUSTOMERID              --保证人流水号                    
           ,APPROVESTATUS                 --流程状态                        
           ,CUSTOMERNAME                  --客户名                          
           ,REMARK                        --备注                            
           ,GUARANTYSUM                   --处置抵质押物收回净值（元）      
           ,CLASSIFYMODE                  --关联合同类型                    
           ,FINALCLASSIFYRESULT           --终审风险分类                    
           ,ALARMADJUSTLEVEL              --                                
           ,LASTPOLICYRESULT              --上期策略分类                    
           ,ADJUSTTYPE                    --                                
           ,MIGTFLAG                      --迁移标志：crsrcrilcupl          
           ,CLASSIFYRESULT                --分类结果                        
           ,LASTCLASSIFYRESULT            --上期风险分类                    
           ,CUSTOMERLEVELTIME             --信用评级时间                    
           ,APPROVEEVALUATERESULT         --审批环节主体评级                
           ,OPENSUM                       --                                
           ,ASSURELEVEL                   --保证人信用等级                  
           ,ADVISECLASSIFYRESULT          --本期系统建议分类                
           ,BALANCE                       --余额                            
           ,START_DT                      --开始时间                        
           ,END_DT                        --结束时间                        
           ,ID_MARK                       --增删标志                        
           ,ETL_TIMESTAMP                 --ETL处理时间戳                                                
    )
    SELECT
           SERIALNO                      --流水号                          
           ,CREDITAGGREEMENT              --额度合同号                      
           ,RELATIVETYPE                  --关联类型                        
           ,FINALPOLICYRESULT             --终审策略分类                    
           ,FINALCUSTOMERLEVEL            --终审监测评级                    
           ,INPUTUSERID                   --登记人                          
           ,FLAG                          --标记                            
           ,RELATIVESERIALNO              --关联流水号                      
           ,ISCURRENTMONTH                --是否本月新发生                  
           ,TOTALSUM                      --敞口                            
           ,MATURITY                      --到期日                          
           ,VOUCHTYPE                     --担保类型                        
           ,LEVELCLASSIFY                 --评级对应的风险分类              
           ,KERNALADJUSTLEVEL             --                                
           ,ALARMINFO                     --                                
           ,ENTRANCE                      --申请发起入口1对公系统，2同业系统
           ,OBJECTTYPE                    --对象类型                        
           ,BUSINESSTYPE                  --业务类型                        
           ,BUSINESSCURRENCY              --业务币种                        
           ,INPUTORGID                    --登记机构                        
           ,POLICYRESULT                  --本期申请策略分类                
           ,UPDATEORGID                   --更新时间                        
           ,UPDATEDATE                    --更新日期                        
           ,TYPE                          --类型                            
           ,LICENSEDATE                   --营业执照登记日                  
           ,APPROVECLASSIFYRESULT         --审批环节风险分类                
           ,LASTCUSTOMERLEVEL             --上期监测评级                    
           ,UPDATEUSERID                  --更新人                          
           ,PIGEONHOLEDATE                --归案日期                        
           ,CONTRACTSERIALNO              --合同号                          
           ,REMARK1                       --意见                            
           ,CUSTOMERLEVEL                 --信用评级                        
           ,CLASSIFYNUM                   --分类笔数                        
           ,ACCOUNTMONTH                  --分类截至日期                    
           ,CUSTOMERID                    --客户号                          
           ,RELATIVENO                    --关联号                          
           ,INPUTDATE                     --登记日期                        
           ,APPROVECLASSIFYTIME           --审批时间                        
           ,COVERAGE                      --担保覆盖率                      
           ,ASSURECUSTOMERID              --保证人流水号                    
           ,APPROVESTATUS                 --流程状态                        
           ,CUSTOMERNAME                  --客户名                          
           ,REMARK                        --备注                            
           ,GUARANTYSUM                   --处置抵质押物收回净值（元）      
           ,CLASSIFYMODE                  --关联合同类型                    
           ,FINALCLASSIFYRESULT           --终审风险分类                    
           ,ALARMADJUSTLEVEL              --                                
           ,LASTPOLICYRESULT              --上期策略分类                    
           ,ADJUSTTYPE                    --                                
           ,MIGTFLAG                      --迁移标志：crsrcrilcupl          
           ,CLASSIFYRESULT                --分类结果                        
           ,LASTCLASSIFYRESULT            --上期风险分类                    
           ,CUSTOMERLEVELTIME             --信用评级时间                    
           ,APPROVEEVALUATERESULT         --审批环节主体评级                
           ,OPENSUM                       --                                
           ,ASSURELEVEL                   --保证人信用等级                  
           ,ADVISECLASSIFYRESULT          --本期系统建议分类                
           ,BALANCE                       --余额                            
           ,START_DT                      --开始时间                        
           ,END_DT                        --结束时间                        
           ,ID_MARK                       --增删标志                        
           ,ETL_TIMESTAMP                 --ETL处理时间戳  
    FROM IOL.V_ICMS_CLASSIFY_APPLY    --视图-风险分类申请表
   WHERE ID_MARK <> 'D'; 

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

  END ETL_O_IOL_ICMS_CLASSIFY_APPLY;
/

