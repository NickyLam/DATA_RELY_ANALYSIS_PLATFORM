CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_EQUITY_FINAL_INVEST(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_TTRD_EQUITY_FINAL_INVEST
  *  功能描述：最终投向类型表
  *  创建日期：20240718
  *  开发人员：YJY
  *  来源表： IOL.V_IBMS_TTRD_EQUITY_FINAL_INVEST
  *  目标表： O_IOL_IBMS_TTRD_EQUITY_FINAL_INVEST
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20240718  YJY      首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_EQUITY_FINAL_INVEST'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_EQUITY_FINAL_INVEST';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-最终投向类型表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_IBMS_TTRD_EQUITY_FINAL_INVEST
  (
            ID                          --序号                                           
           ,RATIO_ID                    --占比id                                         
           ,I_CODE                      --金融工具代码                                   
           ,A_TYPE                      --资产大类                                       
           ,M_TYPE                      --市场类型                                       
           ,FINAL_INVEST_TYPE           --最终投向类型（穿透底层）                       
           ,INVEST_RATIO                --当期投资金额占比(%)                            
           ,GRADE                       --评级（金融债权为主体评级/非金融债权为债项评级）
           ,LOW_PROP                    --合同中的最低投资比例(%)                        
           ,HIGH_PROP                   --合同中的最高投资比例(%)                        
           ,WEIGHT                      --权重(%)                                        
           ,REMARK                      --备注                                           
           ,DATE_EXPLAIN                --数据项说明                                     
           ,ASSET_CLASS                 --映射资本新规基础资产品种或资产中类             
           ,START_DT                    --开始时间                                       
           ,END_DT                      --结束时间                                       
           ,ID_MARK                     --增删标志                                       
           ,ETL_TIMESTAMP               --ETL处理时间戳                                  
    )
    SELECT
            ID                          --序号                                           
           ,RATIO_ID                    --占比id                                         
           ,I_CODE                      --金融工具代码                                   
           ,A_TYPE                      --资产大类                                       
           ,M_TYPE                      --市场类型                                       
           ,FINAL_INVEST_TYPE           --最终投向类型（穿透底层）                       
           ,INVEST_RATIO                --当期投资金额占比(%)                            
           ,GRADE                       --评级（金融债权为主体评级/非金融债权为债项评级）
           ,LOW_PROP                    --合同中的最低投资比例(%)                        
           ,HIGH_PROP                   --合同中的最高投资比例(%)                        
           ,WEIGHT                      --权重(%)                                        
           ,REMARK                      --备注                                           
           ,DATE_EXPLAIN                --数据项说明                                     
           ,ASSET_CLASS                 --映射资本新规基础资产品种或资产中类             
           ,START_DT                    --开始时间                                       
           ,END_DT                      --结束时间                                       
           ,ID_MARK                     --增删标志                                       
           ,ETL_TIMESTAMP               --ETL处理时间戳           
    FROM IOL.V_IBMS_TTRD_EQUITY_FINAL_INVEST  --视图-最终投向类型表
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

  END ETL_O_IOL_IBMS_TTRD_EQUITY_FINAL_INVEST;
/

