CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_SVBS_HX_TRANS_JNL(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_SVBS_HX_TRANS_JNL
  *  功能描述：交易流水表
  *  创建日期：20240805
  *  开发人员：YJY
  *  来源表： IOL.V_SVBS_HX_TRANS_JNL
  *  目标表： O_IOL_SVBS_HX_TRANS_JNL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240805  YJY     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_SVBS_HX_TRANS_JNL'; -- 程序名称
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
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_SVBS_HX_TRANS_JNL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-交易流水表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_SVBS_HX_TRANS_JNL
  (
           ACCESS_JNL_NO              --流水号                                  
          ,TRANS_CODE                 --交易码                                    
          ,TRANS_CHANNEL              --交易渠道                                
          ,CUST_NO                    --客户号                                  
          ,CUST_NAME                  --客户名称                                
          ,ID_TYPE                    --证件类型                                
          ,ID_NO                      --证件号码                                
          ,CARD_TYPE                  --卡类型                                  
          ,CARD_NO                    --卡号                                    
          ,CLIENT_ID                  --坐席编号                                
          ,BRANCH_ID                  --机构编号                                
          ,AUTH_FLAG                  --是否授权                                
          ,AUTH_RESULT                --授权结果                                
          ,AUTHOR_ID                  --授权用户编号                            
          ,CUR_STEP                   --当前步骤                                
          ,TRANS_TIME                 --交易时间                                
          ,UPDATE_TIME                --更新时间                                
          ,TRANS_STATUS               --交易状态                                
          ,TRANS_MSG                  --交易结果                                
          ,CREATE_USER                --创建用户                                
          ,UPDATE_USER                --更新用户                                
          ,SESSION_ID                 --会话Id                                  
          ,SESSION_ID2                --会话Id2                                 
          ,SESSION_ID3                --会话Id3                                 
          ,SESSION_ID4                --会话Id4                                 
          ,SESSION_ID5                --会话Id5                                 
          ,SESSION_ID6                --会话Id6                                 
          ,SESSION_ID7                --会话Id7                                 
          ,SESSION_ID8                --会话Id8                                 
          ,SESSION_ID9                --会话Id9                                 
          ,TRANS_ADDRESS              --交易地址                                
          ,TASK_STATE                 --是否质检  否-0;是-1                     
          ,LONGITUDE                  --经度                                    
          ,LATITUDE                   --维度                                    
          ,TRANS_CITY                 --交易城市                                
          ,TRANS_CITY_CODE            --城市编码                                
          ,CONNECT_TYPE               --流水接通类型，0-未接通，1-已接通        
          ,REFUSE_INFO                --未接通的拒绝类型，如黑名单、未满18周岁等
          ,REFUSE_DETAIL              --拒绝内容明细                            
          ,TRANS_NODE_STATUS          --交易节点状态                            
          ,IS_RISK_RECORD             --是否是风险记录                          
          ,START_DT                   --开始时间                                
          ,END_DT                     --结束时间                                
          ,ID_MARK                    --增删标志                                
          ,ETL_TIMESTAMP              --ETL处理时间戳                           
                                                                                                                                                                                                        
    )
    SELECT
          ACCESS_JNL_NO              --流水号                                  
          ,TRANS_CODE                 --交易码                                    
          ,TRANS_CHANNEL              --交易渠道                                
          ,CUST_NO                    --客户号                                  
          ,CUST_NAME                  --客户名称                                
          ,ID_TYPE                    --证件类型                                
          ,ID_NO                      --证件号码                                
          ,CARD_TYPE                  --卡类型                                  
          ,CARD_NO                    --卡号                                    
          ,CLIENT_ID                  --坐席编号                                
          ,BRANCH_ID                  --机构编号                                
          ,AUTH_FLAG                  --是否授权                                
          ,AUTH_RESULT                --授权结果                                
          ,AUTHOR_ID                  --授权用户编号                            
          ,CUR_STEP                   --当前步骤                                
          ,TRANS_TIME                 --交易时间                                
          ,UPDATE_TIME                --更新时间                                
          ,TRANS_STATUS               --交易状态                                
          ,TRANS_MSG                  --交易结果                                
          ,CREATE_USER                --创建用户                                
          ,UPDATE_USER                --更新用户                                
          ,SESSION_ID                 --会话Id                                  
          ,SESSION_ID2                --会话Id2                                 
          ,SESSION_ID3                --会话Id3                                 
          ,SESSION_ID4                --会话Id4                                 
          ,SESSION_ID5                --会话Id5                                 
          ,SESSION_ID6                --会话Id6                                 
          ,SESSION_ID7                --会话Id7                                 
          ,SESSION_ID8                --会话Id8                                 
          ,SESSION_ID9                --会话Id9                                 
          ,TRANS_ADDRESS              --交易地址                                
          ,TASK_STATE                 --是否质检  否-0;是-1                     
          ,LONGITUDE                  --经度                                    
          ,LATITUDE                   --维度                                    
          ,TRANS_CITY                 --交易城市                                
          ,TRANS_CITY_CODE            --城市编码                                
          ,CONNECT_TYPE               --流水接通类型，0-未接通，1-已接通        
          ,REFUSE_INFO                --未接通的拒绝类型，如黑名单、未满18周岁等
          ,REFUSE_DETAIL              --拒绝内容明细                            
          ,TRANS_NODE_STATUS          --交易节点状态                            
          ,IS_RISK_RECORD             --是否是风险记录                          
          ,START_DT                   --开始时间                                
          ,END_DT                     --结束时间                                
          ,ID_MARK                    --增删标志                                
          ,ETL_TIMESTAMP              --ETL处理时间戳  
    FROM IOL.V_SVBS_HX_TRANS_JNL    --视图-交易流水表
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

  END ETL_O_IOL_SVBS_HX_TRANS_JNL;
/

