CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IFDS_V_PAYMENT_ALL(I_P_DATE IN INTEGER,
                                O_ERRCODE OUT VARCHAR2
                                 )
    /**************************************************************************
    *  程序名称：ETL_O_IOL_IFDS_V_PAYMENT_ALL
    *  功能描述：账户交易支付明细
    *  创建日期：20240702
    *  开发人员：YUJINGYI
    *  来源表： IOL.V_IFDS_V_PAYMENT_ALL
    *  目标表： O_IOL_IFDS_V_PAYMENT_ALL
    *  配置表：
    *  修改情况：序号  修改日期  修改人   修改原因
    *             1    20240702  YUJINGYI     首次创建
    *             2    20241031  YJY      调整清数策略
    **************************************************************************/
    AS
    -- 定义变量 --
    V_STEP      INTEGER := 0; -- 处理步骤
    V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IFDS_V_PAYMENT_ALL'; -- 程序名称
    V_TAB_NAME      VARCHAR2(500):= 'O_IOL_IFDS_V_PAYMENT_ALL';     --表名
    V_PART_NAME VARCHAR2(100);       --分区名
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
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  -- 分区表分区处理 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
 -- EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IFDS_V_PAYMENT_ALL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


    -- 程序业务逻辑处理主体部分 --
    V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
    V_STEP_DESC := '数据落地-账户交易支付明细';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.O_IOL_IFDS_V_PAYMENT_ALL
    (
              PAYMENT_ID                        --支付编号              
             ,PAYMENT_TYPE_ID                   --支付类型编号        
             ,PAYMENT_METHOD_TYPE_ID            --支付方式类型编号    
             ,PAYMENT_METHOD_ID                 --支付方式标识        
             ,PAYMENT_GATEWAY_RESPONSE_ID       --支付网关响应号      
             ,PAYMENT_PREFERENCE_ID             --支付优先标识        
             ,PARTY_ID_FROM                     --自会员标识          
             ,PARTY_ID_TO                       --到会员表示          
             ,ROLE_TYPE_ID_TO                   --角色类型标识到      
             ,STATUS_ID                         --状态                
             ,EFFECTIVE_DATE                    --账务日期            
             ,PAYMENT_REF_NUM                   --前台流水号          
             ,AMOUNT                            --交易金额            
             ,CURRENCY_UOM_ID                   --币种                
             ,COMMENTS                          --备注                
             ,FIN_ACCOUNT_TRANS_ID              --金融账户交易明细编号
             ,OVERRIDE_GL_ACCOUNT_ID            --覆盖总账账户标识    
             ,ACTUAL_CURRENCY_AMOUNT            --实际金额            
             ,ACTUAL_CURRENCY_UOM_ID            --实际币种            
             ,LAST_UPDATED_STAMP                --最后更新时间        
             ,LAST_UPDATED_TX_STAMP             --最后更新事务时间    
             ,CREATED_STAMP                     --创建时间            
             ,CREATED_TX_STAMP                  --创建事务时间        
             ,OPP_ACCOUNT_NUM                   --对方账号            
             ,OPP_ACCOUNT_NAME                  --对方户名            
             ,OPP_BANK_NUM                      --对方账户开户行      
             ,OPP_BANK_NAME                     --对方账户开户行名称  
             ,FIN_ACCOUNT_ID                    --金融账户编号        
             ,ACC_NAME                          --账户名              
             ,TRADE_PARTY_ID                    --交易机构            
             ,ALL_RECEIVE_DATE                  --交易日期            
             ,PARENT_PAYMENT_ID                 --原支付编号          
             ,SUMMARY_INFO                      --摘要                
             ,POSTSCRIPT                        --附言                
             ,NUM                               --序列号              
             ,RE_TYPE                           --类型                
             ,PAYMENT_TRANS_KIND                --                    
             ,ACTUAL_BALANCE                    --实际余额            
             ,AVAILABLE_BALANCE                 --可用余额            
             ,IS_SHOW                           --是否对外展示        
             ,TRANSACTION_TYPE                  --                    
             ,TRANSACTION_SERIAL                --                    
             ,MERCHANT_CODE                     --                    
             ,MERCHANT_NAME                     --                    
             ,TRANSACTION_ADDRESS               --                    
             ,CHECK_BILL_PRODUCT_ID             --                    
             ,CHECK_BILL_DATE                   --                    
             ,CUSTOMER_ID                       --客户编号            
             ,ETL_DT                            --ETL处理日期         
             ,ETL_TIMESTAMP                     --ETL处理时间戳       
    )
      SELECT
             PAYMENT_ID                        --支付编号              
             ,PAYMENT_TYPE_ID                   --支付类型编号        
             ,PAYMENT_METHOD_TYPE_ID            --支付方式类型编号    
             ,PAYMENT_METHOD_ID                 --支付方式标识        
             ,PAYMENT_GATEWAY_RESPONSE_ID       --支付网关响应号      
             ,PAYMENT_PREFERENCE_ID             --支付优先标识        
             ,PARTY_ID_FROM                     --自会员标识          
             ,PARTY_ID_TO                       --到会员表示          
             ,ROLE_TYPE_ID_TO                   --角色类型标识到      
             ,STATUS_ID                         --状态                
             ,EFFECTIVE_DATE                    --账务日期            
             ,PAYMENT_REF_NUM                   --前台流水号          
             ,AMOUNT                            --交易金额            
             ,CURRENCY_UOM_ID                   --币种                
             ,COMMENTS                          --备注                
             ,FIN_ACCOUNT_TRANS_ID              --金融账户交易明细编号
             ,OVERRIDE_GL_ACCOUNT_ID            --覆盖总账账户标识    
             ,ACTUAL_CURRENCY_AMOUNT            --实际金额            
             ,ACTUAL_CURRENCY_UOM_ID            --实际币种            
             ,LAST_UPDATED_STAMP                --最后更新时间        
             ,LAST_UPDATED_TX_STAMP             --最后更新事务时间    
             ,CREATED_STAMP                     --创建时间            
             ,CREATED_TX_STAMP                  --创建事务时间        
             ,OPP_ACCOUNT_NUM                   --对方账号            
             ,OPP_ACCOUNT_NAME                  --对方户名            
             ,OPP_BANK_NUM                      --对方账户开户行      
             ,OPP_BANK_NAME                     --对方账户开户行名称  
             ,FIN_ACCOUNT_ID                    --金融账户编号        
             ,ACC_NAME                          --账户名              
             ,TRADE_PARTY_ID                    --交易机构            
             ,ALL_RECEIVE_DATE                  --交易日期            
             ,PARENT_PAYMENT_ID                 --原支付编号          
             ,SUMMARY_INFO                      --摘要                
             ,POSTSCRIPT                        --附言                
             ,NUM                               --序列号              
             ,RE_TYPE                           --类型                
             ,PAYMENT_TRANS_KIND                --                    
             ,ACTUAL_BALANCE                    --实际余额            
             ,AVAILABLE_BALANCE                 --可用余额            
             ,IS_SHOW                           --是否对外展示        
             ,TRANSACTION_TYPE                  --                    
             ,TRANSACTION_SERIAL                --                    
             ,MERCHANT_CODE                     --                    
             ,MERCHANT_NAME                     --                    
             ,TRANSACTION_ADDRESS               --                    
             ,CHECK_BILL_PRODUCT_ID             --                    
             ,CHECK_BILL_DATE                   --                    
             ,CUSTOMER_ID                       --客户编号            
             ,ETL_DT                            --ETL处理日期         
             ,ETL_TIMESTAMP                     --ETL处理时间戳       
      FROM IOL.V_IFDS_V_PAYMENT_ALL  --视图-账户交易支付明细
      WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
      ;

     V_SQLCOUNT := SQL%ROWCOUNT;
     V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
     O_ERRCODE := '0';
     V_ENDTIME := SYSDATE;
     COMMIT;


     -- 如需要分析表，请用如下代码 --
     -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
     ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
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
    V_STEP := V_STEP + 1;
       V_STEP_DESC := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    END ETL_O_IOL_IFDS_V_PAYMENT_ALL;
/

