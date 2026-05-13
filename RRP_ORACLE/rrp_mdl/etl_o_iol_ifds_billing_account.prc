CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IFDS_BILLING_ACCOUNT(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IFDS_BILLING_ACCOUNT
  *  功能描述：E账户表
  *  创建日期：20240701
  *  开发人员：YUJINGYI
  *  来源表： IML.V_IFDS_BILLING_ACCOUNT
  *  目标表： O_IOL_IFDS_BILLING_ACCOUNT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240701  YJY     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IFDS_BILLING_ACCOUNT'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TAB_NAME  VARCHAR2(50) := 'O_IOL_IFDS_BILLING_ACCOUNT';
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_IFDS_BILLING_ACCOUNT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-E账户表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_IFDS_BILLING_ACCOUNT
  (
          BILLING_ACCOUNT_ID                 --E账户编号             
         ,BILLING_ACCOUNT_NAME               --E账户名称           
         ,ACCOUNT_TYPE                       --账户类型            
         ,ACCOUNT_CURRENCY_UOM_ID            --E账户币种           
         ,MEDIA_TYPE_ID                      --媒介类型            
         ,PARTY_ID                           --E账户所属客户号     
         ,STATUS_ID                          --E账户状态           
         ,ACCOUNT_LIMIT                      --E账户限额           
         ,EXTERNAL_ACCOUNT_ID                --E账号               
         ,ACCOUNT_LEVEL                      --E账户等级           
         ,NET_CHECK_RESULT                   --联网核查结果        
         ,ACCOUNT_BRANCH_ID                  --开户机构            
         ,FROM_DATE                          --开户日期            
         ,THRU_DATE                          --销户日期            
         ,CONTACT_MECH_ID                    --联系人              
         ,CHANNEL                            --渠道                
         ,DESCRIPTION                        --描述                
         ,LAST_UPDATED_STAMP                 --最后更新时间        
         ,LAST_UPDATED_TX_STAMP              --最后更新事务时间    
         ,CREATED_STAMP                      --创建时间            
         ,CREATED_TX_STAMP                   --创建事务时间        
         ,ACCOUNT_CATEGORY_LEVEL             --账户等级            
         ,ACCOUNT_TRANS_TYPE                 --开户交易类型        
         ,CARD_LEVEL                         --卡级别              
         ,CASH_OR_REMIT_ID                   --钞汇标识            
         ,CASH_SAVING_WITHDW_ID              --通存通兑标识        
         ,CHIP_CARD_TYPE                     --芯片卡标识          
         ,COOPERATE_CARD_TYPE                --合作卡类型          
         ,DOCS_NO                            --凭证号码            
         ,DOCS_STATUS                        --凭证状态            
         ,DOCS_TYPE                          --凭证类型            
         ,OPERATE_ACCT_TYPE                  --账户组织形式        
         ,PRIVATE_ACCT_ID                    --私密账户标识        
         ,SEED_STOCK                         --储种                
         ,WITHDRAWAL_METHOD                  --支取方式            
         ,CHANNEL_STATUS                     --交易渠道状态        
         ,ACCOUNT_FLAG                       --涉案账户标识        
         ,FLAG_DATE                          --设置日期            
         ,DATA_SOURCE                        --数据来源            
         ,STATUS_UPDATE_ORG                  --交易渠道状态变更机构
         ,GUILT_DATE                         --涉案日期            
         ,VERIFY_STATUS                      --核实状态            
         ,CERTIFICATION_STATUS               --实名认证标识        
         ,BUSINESS_TYPE                      --业务类型            
         ,SUPPLYER_NO                        --商户号              
         ,SUPPLYER_NAME                      --商户名称            
         ,FREEZE_STATUS                      --冻结状态            
         ,IMAGE_RETENTION_STATUS             --影像留存标记        
         ,UN_ACCOUNT_ENTRY_STATUS            --非绑定账户入账标志  
         ,IMAGE_RETENTION_DATE               --影像留存标记时间    
         ,START_DT                           --开始时间            
         ,END_DT                             --结束时间            
         ,ID_MARK                            --增删标志            
         ,ETL_TIMESTAMP                      --ETL处理时间戳       
    )
    SELECT
         BILLING_ACCOUNT_ID                 --E账户编号             
         ,BILLING_ACCOUNT_NAME               --E账户名称           
         ,ACCOUNT_TYPE                       --账户类型            
         ,ACCOUNT_CURRENCY_UOM_ID            --E账户币种           
         ,MEDIA_TYPE_ID                      --媒介类型            
         ,PARTY_ID                           --E账户所属客户号     
         ,STATUS_ID                          --E账户状态           
         ,ACCOUNT_LIMIT                      --E账户限额           
         ,EXTERNAL_ACCOUNT_ID                --E账号               
         ,ACCOUNT_LEVEL                      --E账户等级           
         ,NET_CHECK_RESULT                   --联网核查结果        
         ,ACCOUNT_BRANCH_ID                  --开户机构            
         ,FROM_DATE                          --开户日期            
         ,THRU_DATE                          --销户日期            
         ,CONTACT_MECH_ID                    --联系人              
         ,CHANNEL                            --渠道                
         ,DESCRIPTION                        --描述                
         ,LAST_UPDATED_STAMP                 --最后更新时间        
         ,LAST_UPDATED_TX_STAMP              --最后更新事务时间    
         ,CREATED_STAMP                      --创建时间            
         ,CREATED_TX_STAMP                   --创建事务时间        
         ,ACCOUNT_CATEGORY_LEVEL             --账户等级            
         ,ACCOUNT_TRANS_TYPE                 --开户交易类型        
         ,CARD_LEVEL                         --卡级别              
         ,CASH_OR_REMIT_ID                   --钞汇标识            
         ,CASH_SAVING_WITHDW_ID              --通存通兑标识        
         ,CHIP_CARD_TYPE                     --芯片卡标识          
         ,COOPERATE_CARD_TYPE                --合作卡类型          
         ,DOCS_NO                            --凭证号码            
         ,DOCS_STATUS                        --凭证状态            
         ,DOCS_TYPE                          --凭证类型            
         ,OPERATE_ACCT_TYPE                  --账户组织形式        
         ,PRIVATE_ACCT_ID                    --私密账户标识        
         ,SEED_STOCK                         --储种                
         ,WITHDRAWAL_METHOD                  --支取方式            
         ,CHANNEL_STATUS                     --交易渠道状态        
         ,ACCOUNT_FLAG                       --涉案账户标识        
         ,FLAG_DATE                          --设置日期            
         ,DATA_SOURCE                        --数据来源            
         ,STATUS_UPDATE_ORG                  --交易渠道状态变更机构
         ,GUILT_DATE                         --涉案日期            
         ,VERIFY_STATUS                      --核实状态            
         ,CERTIFICATION_STATUS               --实名认证标识        
         ,BUSINESS_TYPE                      --业务类型            
         ,SUPPLYER_NO                        --商户号              
         ,SUPPLYER_NAME                      --商户名称            
         ,FREEZE_STATUS                      --冻结状态            
         ,IMAGE_RETENTION_STATUS             --影像留存标记        
         ,UN_ACCOUNT_ENTRY_STATUS            --非绑定账户入账标志  
         ,IMAGE_RETENTION_DATE               --影像留存标记时间    
         ,START_DT                           --开始时间            
         ,END_DT                             --结束时间            
         ,ID_MARK                            --增删标志            
         ,ETL_TIMESTAMP                      --ETL处理时间戳       
    FROM IOL.V_IFDS_BILLING_ACCOUNT  --视图-E账户表
  WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';


   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


  -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,'', O_ERRCODE);

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

  END ETL_O_IOL_IFDS_BILLING_ACCOUNT;
/

