CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_GROUP_INFO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_GROUP_INFO
  *  功能描述：集群客户概况信息
  *  创建日期：20240718
  *  开发人员：YJY
  *  来源表： IOL.V_ICMS_GROUP_INFO
  *  目标表： O_IOL_ICMS_GROUP_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240718  YJY     首次创建
  *             2    20250106  YJY     优化脚本
  **************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_GROUP_INFO'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_GROUP_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-集群客户概况信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_GROUP_INFO
  (
            GROUPID                             --客户编号                    
           ,BUSINESSSCOPE                       --经营范围(文本描述)          
           ,MGTORGID                            --主办机构                    
           ,CURRENTVERSIONSEQ                   --当前正在使用的家谱版本号    
           ,COUNTRYCODE                         --所在国家(地区)              
           ,FIRSTLOANDATE                       --首贷日期                    
           ,GROUPMEMBERCOUNT                    --集群成员数量                
           ,REGISTERREGIONCODE                  --登记地行政区划代码          
           ,CREDITLEVEL                         --内部信用评级级别            
           ,GROUPCREDITTYPE                     --集团类型                    
           ,CUSTOMERTYPE                        --客户类型                    
           ,NEWREGIONCODE                       --行政区域（风险预警）        
           ,INDUSTRYTYPEPROPORTION              --第一大主营业务占比          
           ,CITY                                --省直辖市/县                 
           ,OFFICEADDUPDATEDATE                 --更新办公地址日期            
           ,ISRETIVEECONMICS                    --是否经济依存                
           ,GROUPNAME                           --集群名称                    
           ,FAMILYMAPSTATUS                     --家谱版本状态                
           ,APPROVEORGID                        --复核机构                    
           ,ISRELATEDPARTY                      --是否我行关联方标志          
           ,PARENTCOMPANYOFFICEADD              --集团客户母公司国内办公地址  
           ,INDUSTRYTYPEPROPORTION2             --第三大主营业务占比          
           ,CORPIDETITYTYPE                     --征信报送企业身份标识类型    
           ,REFVERSIONSEQ                       --当前正在维护的家谱版本号    
           ,OLDFINANCEFOCUS                     --过往财务集中情况            
           ,OLDHEADOFFICEMANAGE                 --过往总行集中管理情况        
           ,INDUSTRYTYPE                        --所属行业类型                
           ,SUBJECTBUSINESS                     --主营业务(文本描述)          
           ,GROUPSTATUS                         --集群状态                    
           ,GROUPABBNAME                        --集团简称                    
           ,UPDATEUSERID                        --更新人                      
           ,UPDATEDATE                          --更新日期                    
           ,CORPORGID                           --法人机构编号                
           ,GROUPCUSTOMERTYPE                   --集群客户类型                
           ,OLDGROUPCREDITTYPE                  --过往集团类型                
           ,INDUSTRYTYPEPROPORTION1             --第二大主营业务占比          
           ,MIGTFLAG                            --                            
           ,MGTUSERID                           --主办客户经理                
           ,INPUTORGID                          --登记单位                    
           ,INPUTUSERID                         --登记人                      
           ,OLDGROUPABBNAME                     --集群曾用简称                
           ,ISRELATIVETRADE                     --是否我行关联交易            
           ,ACTUALCONTROLLERCOUNTS              --实际控制人个数              
           ,REMARK                              --备注                        
           ,UPDATEORGID                         --更新机构                    
           ,INDUSTRYTYPE1                       --第二大主营业务编号(行业代码)
           ,INDUSTRYTYPE2                       --第三大主营业务编号(行业代码)
           ,INPUTDATE                           --登记日期                    
           ,FINANCIALGROUPSCOPE                 --规模(文本描述)              
           ,FINANCIALGROUPPOSITION              --行业地位(文本描述)          
           ,GROUPTYPE                           --集群类型                    
           ,APPROVEDATE                         --复核日期                    
           ,OLDGROUPNAME                        --集团曾用名                  
           ,HEADOFFICEMANAGE                    --总行集中管理                
           ,APPROVEUSERID                       --复核人                      
           ,INVESTMENCOUNTS                     --主要出资人个数              
           ,KEYMEMBERCUSTOMERID                 --集团核心企业                
           ,FINANCEFOCUS                        --财务是否集中                
           ,MIGTOLDVALUE                        --迁移数据-参数转换前字段值   
           ,ACTUALCONTROLLER                    --实际控制人                  
           ,START_DT                            --开始时间                    
           ,END_DT                              --结束时间                    
           ,ID_MARK                             --增删标志                    
           ,ETL_TIMESTAMP                       --ETL处理时间戳                               
    )
    SELECT
           GROUPID                             --客户编号                    
           ,BUSINESSSCOPE                       --经营范围(文本描述)          
           ,MGTORGID                            --主办机构                    
           ,CURRENTVERSIONSEQ                   --当前正在使用的家谱版本号    
           ,COUNTRYCODE                         --所在国家(地区)              
           ,FIRSTLOANDATE                       --首贷日期                    
           ,GROUPMEMBERCOUNT                    --集群成员数量                
           ,REGISTERREGIONCODE                  --登记地行政区划代码          
           ,CREDITLEVEL                         --内部信用评级级别            
           ,GROUPCREDITTYPE                     --集团类型                    
           ,CUSTOMERTYPE                        --客户类型                    
           ,NEWREGIONCODE                       --行政区域（风险预警）        
           ,INDUSTRYTYPEPROPORTION              --第一大主营业务占比          
           ,CITY                                --省直辖市/县                 
           ,OFFICEADDUPDATEDATE                 --更新办公地址日期            
           ,ISRETIVEECONMICS                    --是否经济依存                
           ,GROUPNAME                           --集群名称                    
           ,FAMILYMAPSTATUS                     --家谱版本状态                
           ,APPROVEORGID                        --复核机构                    
           ,ISRELATEDPARTY                      --是否我行关联方标志          
           ,PARENTCOMPANYOFFICEADD              --集团客户母公司国内办公地址  
           ,INDUSTRYTYPEPROPORTION2             --第三大主营业务占比          
           ,CORPIDETITYTYPE                     --征信报送企业身份标识类型    
           ,REFVERSIONSEQ                       --当前正在维护的家谱版本号    
           ,OLDFINANCEFOCUS                     --过往财务集中情况            
           ,OLDHEADOFFICEMANAGE                 --过往总行集中管理情况        
           ,INDUSTRYTYPE                        --所属行业类型                
           ,SUBJECTBUSINESS                     --主营业务(文本描述)          
           ,GROUPSTATUS                         --集群状态                    
           ,GROUPABBNAME                        --集团简称                    
           ,UPDATEUSERID                        --更新人                      
           ,UPDATEDATE                          --更新日期                    
           ,CORPORGID                           --法人机构编号                
           ,GROUPCUSTOMERTYPE                   --集群客户类型                
           ,OLDGROUPCREDITTYPE                  --过往集团类型                
           ,INDUSTRYTYPEPROPORTION1             --第二大主营业务占比          
           ,MIGTFLAG                            --                            
           ,MGTUSERID                           --主办客户经理                
           ,INPUTORGID                          --登记单位                    
           ,INPUTUSERID                         --登记人                      
           ,OLDGROUPABBNAME                     --集群曾用简称                
           ,ISRELATIVETRADE                     --是否我行关联交易            
           ,ACTUALCONTROLLERCOUNTS              --实际控制人个数              
           ,REMARK                              --备注                        
           ,UPDATEORGID                         --更新机构                    
           ,INDUSTRYTYPE1                       --第二大主营业务编号(行业代码)
           ,INDUSTRYTYPE2                       --第三大主营业务编号(行业代码)
           ,INPUTDATE                           --登记日期                    
           ,FINANCIALGROUPSCOPE                 --规模(文本描述)              
           ,FINANCIALGROUPPOSITION              --行业地位(文本描述)          
           ,GROUPTYPE                           --集群类型                    
           ,APPROVEDATE                         --复核日期                    
           ,OLDGROUPNAME                        --集团曾用名                  
           ,HEADOFFICEMANAGE                    --总行集中管理                
           ,APPROVEUSERID                       --复核人                      
           ,INVESTMENCOUNTS                     --主要出资人个数              
           ,KEYMEMBERCUSTOMERID                 --集团核心企业                
           ,FINANCEFOCUS                        --财务是否集中                
           ,MIGTOLDVALUE                        --迁移数据-参数转换前字段值   
           ,ACTUALCONTROLLER                    --实际控制人                  
           ,START_DT                            --开始时间                    
           ,END_DT                              --结束时间                    
           ,ID_MARK                             --增删标志                    
           ,ETL_TIMESTAMP                       --ETL处理时间戳               
    FROM IOL.V_ICMS_GROUP_INFO    --视图-集群客户概况信息
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

  END ETL_O_IOL_ICMS_GROUP_INFO;
/

