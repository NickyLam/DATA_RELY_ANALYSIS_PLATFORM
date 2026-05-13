CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_CLASSIFY_RELATIVE(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_CLASSIFY_RELATIVE
  *  功能描述：风险分类关联表
  *  创建日期：20240730
  *  开发人员：YJY
  *  来源表： IOL.V_ICMS_CLASSIFY_RELATIVE
  *  目标表： O_IOL_ICMS_CLASSIFY_RELATIVE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240730  YJY     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_CLASSIFY_RELATIVE'; -- 程序名称
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
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_ICMS_CLASSIFY_RELATIVE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-风险分类关联表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_CLASSIFY_RELATIVE
  (
           SERIALNO                      --关联流水号                                                                                   
          ,OBJECTTYPE                    --关联类型                                                                                    
          ,OBJECTNO                      --关联编号                                                                                    
          ,GUARANTORID                   --保证人                                                                                      
          ,RELATIVEDATE                  --关联日期                                                                                    
          ,INPUTDATE                     --登记时间                                                                                    
          ,LIMITELEMENT                  --限定因素                                                                                    
          ,UPDATEORGID                   --更新机构                                                                                    
          ,REMARK                        --备注                                                                                        
          ,ADJUSTREASON                  --调整理由                                                                                    
          ,INPUTUSERID                   --登记人                                                                                      
          ,VOUCHTYPE                     --担保类型                                                                                    
          ,INTERESTBALANCE               --关注余额                                                                                    
          ,STATUS                        --状态                                                                                        
          ,EVALUATERESULT                --业务评级结果                                                                                
          ,GUARANTYSUM                   --保证总金额                                                                                  
          ,UPDATEUSERID                  --更新人                                                                                      
          ,BUSINESSDESCRIBE              --业务模式说明/保证措施说明/预警信号描述                                                      
          ,SIGNID                        --预警信号编号                                                                                
          ,MIGTFLAG                      --迁移标志：crsrcrilcupl                                                                      
          ,COVERAGEAREA                  --覆盖率                                                                                      
          ,EQUITYSITUATION               --股权情况                                                                                    
          ,BUSINESSANALYZE               --押品价格稳定性、变现能力和法律保障分析/担保能力、担保意愿和法律保障分析/我行债券保障能力分析
          ,SIGNLEVEL                     --预警信号级别                                                                                
          ,ADJUST                        --调整                                                                                        
          ,GUARANTORNAME                 --保证人                                                                                      
          ,CHANNEL                       --渠道                                                                                        
          ,INPUTORGID                    --登记机构                                                                                    
          ,BALANCE                       --借据余额                                                                                    
          ,UPDATEDATE                    --更新时间                                                                                    
          ,AFTERCLASSIFYRESULTELEVEN     --调整后11级分类                                                                              
          ,LASTCLASSIFYRESULTELEVEN      --调整前11级分类                                                                              
          ,START_DT                      --开始时间                                                                                    
          ,END_DT                        --结束时间                                                                                    
          ,ID_MARK                       --增删标志                                                                                    
          ,ETL_TIMESTAMP                 --ETL处理时间戳                                                                               
                                     
    )
    SELECT
           SERIALNO                      --关联流水号                                                                                   
          ,OBJECTTYPE                    --关联类型                                                                                    
          ,OBJECTNO                      --关联编号                                                                                    
          ,GUARANTORID                   --保证人                                                                                      
          ,RELATIVEDATE                  --关联日期                                                                                    
          ,INPUTDATE                     --登记时间                                                                                    
          ,LIMITELEMENT                  --限定因素                                                                                    
          ,UPDATEORGID                   --更新机构                                                                                    
          ,REMARK                        --备注                                                                                        
          ,ADJUSTREASON                  --调整理由                                                                                    
          ,INPUTUSERID                   --登记人                                                                                      
          ,VOUCHTYPE                     --担保类型                                                                                    
          ,INTERESTBALANCE               --关注余额                                                                                    
          ,STATUS                        --状态                                                                                        
          ,EVALUATERESULT                --业务评级结果                                                                                
          ,GUARANTYSUM                   --保证总金额                                                                                  
          ,UPDATEUSERID                  --更新人                                                                                      
          ,BUSINESSDESCRIBE              --业务模式说明/保证措施说明/预警信号描述                                                      
          ,SIGNID                        --预警信号编号                                                                                
          ,MIGTFLAG                      --迁移标志：crsrcrilcupl                                                                      
          ,COVERAGEAREA                  --覆盖率                                                                                      
          ,EQUITYSITUATION               --股权情况                                                                                    
          ,BUSINESSANALYZE               --押品价格稳定性、变现能力和法律保障分析/担保能力、担保意愿和法律保障分析/我行债券保障能力分析
          ,SIGNLEVEL                     --预警信号级别                                                                                
          ,ADJUST                        --调整                                                                                        
          ,GUARANTORNAME                 --保证人                                                                                      
          ,CHANNEL                       --渠道                                                                                        
          ,INPUTORGID                    --登记机构                                                                                    
          ,BALANCE                       --借据余额                                                                                    
          ,UPDATEDATE                    --更新时间                                                                                    
          ,AFTERCLASSIFYRESULTELEVEN     --调整后11级分类                                                                              
          ,LASTCLASSIFYRESULTELEVEN      --调整前11级分类                                                                              
          ,START_DT                      --开始时间                                                                                    
          ,END_DT                        --结束时间                                                                                    
          ,ID_MARK                       --增删标志                                                                                    
          ,ETL_TIMESTAMP                 --ETL处理时间戳      
    FROM IOL.V_ICMS_CLASSIFY_RELATIVE    --视图-风险分类关联表
   WHERE ID_MARK <> 'D'; 

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

  END ETL_O_IOL_ICMS_CLASSIFY_RELATIVE;
/

