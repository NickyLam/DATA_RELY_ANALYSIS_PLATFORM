CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ESCS_ESC_INDICATOR_DATA(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ESCS_ESC_INDICATOR_DATA
  *  功能描述：ESC特色指标表
  *  创建日期：20240828
  *  开发人员：YJY
  *  来源表： IOL.V_ESCS_ESC_INDICATOR_DATA
  *  目标表： O_IOL_ESCS_ESC_INDICATOR_DATA
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240828  YJY     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ESCS_ESC_INDICATOR_DATA'; -- 程序名称
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

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_ESCS_ESC_INDICATOR_DATA';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-ESC特色指标表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ESCS_ESC_INDICATOR_DATA
  (
            ID                                       --ESC指标id            主键              
           ,ESC_TRANSACTION_TOTAL_DAY                --ESC当日交易笔数                   
           ,TRANSACTION_SUCC_RATE                    --ESC当日交易成功率                 
           ,MAX_TPS                                  --ESC当日最大TPS                    
           ,ESC_TRANSACTION_TOTAL_MONTH              --ESC月交易笔数                     
           ,ESC_TRANSACTION_TOTAL_YEAR               --ESC年交易笔数                     
           ,ESC_TRANSACTION_TOTAL_YEAR_AVG           --ESC年均交易笔数                   
           ,ESC_SINGLE_SERVICE_MAX_CONCURRENCY       --ESC单服务支持最大并发数           
           ,ESC_STANDALONE_MAX_CONCURRENCY           --ESC单机支持最大并发数             
           ,ESC_SERVICE_NUM                          --ESC服务治理接口数                 
           ,INTERFACE_STOCK_NUM                      --存量迁移接口数                    
           ,ACCESS_ESC_SYSTEM_NUM                    --接入ESC系统数                     
           ,TRACE_INFO_NUM                           --ESC服务治理接口数                 
           ,TRANSACTION_FAILURE_ALARM_NUM            --交易失败达到设置阀值发送邮件告警数
           ,INTRADAY_INTERFACE_STOCK_ACTIVE_NUM      --当日存量迁移接口活跃数            
           ,INTRADAY_ESC_SERVICE_ACTIVE_NUM          --当日服务治理接口活跃数            
           ,SOFTNESS_AND_PATENT                      --软著和专利                        
           ,STATISTICS_DATE                          --统计日期                          
           ,UPDATE_TIME                              --更新时间                          
           ,ESC_CALL_TOTAL_DAY                       --ESC当日调用笔数                   
           ,STATISTICS_START_DATE                    --统计开始日期                      
           ,ETL_DT                                   --ETL处理日期                       
           ,ETL_TIMESTAMP                            --ETL处理时间戳                     
                  
    )
    SELECT
            ID                                       --ESC指标id                 主键         
           ,ESC_TRANSACTION_TOTAL_DAY                --ESC当日交易笔数                   
           ,TRANSACTION_SUCC_RATE                    --ESC当日交易成功率                 
           ,MAX_TPS                                  --ESC当日最大TPS                    
           ,ESC_TRANSACTION_TOTAL_MONTH              --ESC月交易笔数                     
           ,ESC_TRANSACTION_TOTAL_YEAR               --ESC年交易笔数                     
           ,ESC_TRANSACTION_TOTAL_YEAR_AVG           --ESC年均交易笔数                   
           ,ESC_SINGLE_SERVICE_MAX_CONCURRENCY       --ESC单服务支持最大并发数           
           ,ESC_STANDALONE_MAX_CONCURRENCY           --ESC单机支持最大并发数             
           ,ESC_SERVICE_NUM                          --ESC服务治理接口数                 
           ,INTERFACE_STOCK_NUM                      --存量迁移接口数                    
           ,ACCESS_ESC_SYSTEM_NUM                    --接入ESC系统数                     
           ,TRACE_INFO_NUM                           --ESC服务治理接口数                 
           ,TRANSACTION_FAILURE_ALARM_NUM            --交易失败达到设置阀值发送邮件告警数
           ,INTRADAY_INTERFACE_STOCK_ACTIVE_NUM      --当日存量迁移接口活跃数            
           ,INTRADAY_ESC_SERVICE_ACTIVE_NUM          --当日服务治理接口活跃数            
           ,SOFTNESS_AND_PATENT                      --软著和专利                        
           ,STATISTICS_DATE                          --统计日期                          
           ,UPDATE_TIME                              --更新时间                          
           ,ESC_CALL_TOTAL_DAY                       --ESC当日调用笔数                   
           ,STATISTICS_START_DATE                    --统计开始日期                      
           ,ETL_DT                                   --ETL处理日期                       
           ,ETL_TIMESTAMP                            --ETL处理时间戳          
    FROM IOL.V_ESCS_ESC_INDICATOR_DATA  --视图-ESC特色指标表
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

  END ETL_O_IOL_ESCS_ESC_INDICATOR_DATA;
/

