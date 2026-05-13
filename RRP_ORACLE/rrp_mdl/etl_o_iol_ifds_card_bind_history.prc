CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IFDS_CARD_BIND_HISTORY(I_P_DATE IN INTEGER,
                                O_ERRCODE OUT VARCHAR2
                                 )
    /**************************************************************************
    *  程序名称：ETL_O_IOL_IFDS_CARD_BIND_HISTORY
    *  功能描述：绑卡历史
    *  创建日期：20240702
    *  开发人员：YUJINGYI
    *  来源表： IOL.V_IFDS_CARD_BIND_HISTORY
    *  目标表： O_IOL_IFDS_CARD_BIND_HISTORY
    *  配置表：
    *  修改情况：序号  修改日期  修改人   修改原因
    *             1    20240702  YUJINGYI     首次创建
    ***************************************************************************/
    AS
    -- 定义变量 --
    V_STEP      INTEGER := 0; -- 处理步骤
    V_PROC_NAME VARCHAR2(500) := 'ETL_O_IOL_IFDS_CARD_BIND_HISTORY'; -- 程序名称
    V_TAB_NAME      VARCHAR2(500):= 'O_IOL_IFDS_CARD_BIND_HISTORY';     --表名
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
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    -- 程序业务逻辑处理主体部分 --
    V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
    V_STEP_DESC := '数据落地-绑卡历史';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.O_IOL_IFDS_CARD_BIND_HISTORY
    (
              TRAN_SEQ_NO                   --交易流水            
             ,BILLING_ACCOUNT_ID            --E账户编号           
             ,CARD_NO                       --卡号                
             ,CARD_NAME                     --户名                
             ,CUSTOMER_NO                   --客户号              
             ,CARD_TYPE_ID                  --卡类型              
             ,OTHER_BANK_FLAG               --本他行标志          
             ,BANK_OFFICES_NO               --绑卡开户网点        
             ,BIND_DATE                     --绑定时间            
             ,OPERATE_TIME                  --操作时间            
             ,STATUS_ID                     --状态                
             ,AMOUNT                        --预绑金额            
             ,SIMP_PAY_FLAG                 --是否快捷支付        
             ,BANK_NUMBER                   --归属行              
             ,BANK_NAME                     --行名                
             ,THIRD_PARTY_ID                --商户号              
             ,THIRD_PARTY_NAME              --商户名称            
             ,CHANNEL                       --通道                
             ,CANCEL_DATE                   --状态结束日期        
             ,ACCOUNT_TYPE                  --账户类型            
             ,CARD_FLAG                     --卡类型              
             ,LIMITED_AMOUNT                --限额                
             ,IS_LIMITEO                    --是否限额            
             ,DEFAULT_CARD                  --是否默认卡          
             ,BUSINESS_TYPE                 --业务类型            
             ,FINANCIAL_INSTITUTION_CODE    --开户银行金融机构编码
             ,LAST_UPDATED_STAMP            --最后更新时间        
             ,LAST_UPDATED_TX_STAMP         --最后更新事务时间    
             ,CREATED_STAMP                 --创建时间            
             ,CREATED_TX_STAMP              --创建事务时间        
             ,ETL_DT                        --ETL处理日期         
             ,ETL_TIMESTAMP                 --ETL处理时间戳       
    )
      SELECT
              TRAN_SEQ_NO                   --交易流水            
             ,BILLING_ACCOUNT_ID            --E账户编号           
             ,CARD_NO                       --卡号                
             ,CARD_NAME                     --户名                
             ,CUSTOMER_NO                   --客户号              
             ,CARD_TYPE_ID                  --卡类型              
             ,OTHER_BANK_FLAG               --本他行标志          
             ,BANK_OFFICES_NO               --绑卡开户网点        
             ,BIND_DATE                     --绑定时间            
             ,OPERATE_TIME                  --操作时间            
             ,STATUS_ID                     --状态                
             ,AMOUNT                        --预绑金额            
             ,SIMP_PAY_FLAG                 --是否快捷支付        
             ,BANK_NUMBER                   --归属行              
             ,BANK_NAME                     --行名                
             ,THIRD_PARTY_ID                --商户号              
             ,THIRD_PARTY_NAME              --商户名称            
             ,CHANNEL                       --通道                
             ,CANCEL_DATE                   --状态结束日期        
             ,ACCOUNT_TYPE                  --账户类型            
             ,CARD_FLAG                     --卡类型              
             ,LIMITED_AMOUNT                --限额                
             ,IS_LIMITEO                    --是否限额            
             ,DEFAULT_CARD                  --是否默认卡          
             ,BUSINESS_TYPE                 --业务类型            
             ,FINANCIAL_INSTITUTION_CODE    --开户银行金融机构编码
             ,LAST_UPDATED_STAMP            --最后更新时间        
             ,LAST_UPDATED_TX_STAMP         --最后更新事务时间    
             ,CREATED_STAMP                 --创建时间            
             ,CREATED_TX_STAMP              --创建事务时间        
             ,ETL_DT                        --ETL处理日期         
             ,ETL_TIMESTAMP                 --ETL处理时间戳       
      FROM IOL.V_IFDS_CARD_BIND_HISTORY  --视图-绑卡历史
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

    END ETL_O_IOL_IFDS_CARD_BIND_HISTORY;
/

