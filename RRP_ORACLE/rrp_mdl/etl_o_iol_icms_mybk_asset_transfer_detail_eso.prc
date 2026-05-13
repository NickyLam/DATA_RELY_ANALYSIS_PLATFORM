CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO
  *  功能描述：代码表，代码库
  *  创建日期：20230925
  *  开发人员：HULIJUAN
  *  来源表： IOL.V_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO
  *  目标表： O_IOL_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO
  *  配置表：
  *  修改情况：序号  修改日期   修改人      修改原因
  *             1    20230925   HULIJUAN    首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO'; -- 程序名称
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
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
  --DELETE FROM O_IOL_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-代码表，代码库';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO
    (CONTRACTNO            -- 平台贷款合同号                  
    ,TERMNO                -- 期次号                          
    ,SETTLEDATE            -- 业务日期                        
    ,TRANSTIME             -- 交易时间                        
    ,SEQNO                 -- 资产转让业务流水号              
    ,FUNDSEQNO             -- 资金流水号                      
    ,STARTDATE             -- 分期开始日期                    
    ,ENDDATE               -- 分期结束日期                    
    ,PRINBAL               -- 本金余额（单位分）              
    ,INTBAL                -- 利息余额（单位分）              
    ,OVDPRINPNLTBAL        -- 逾期本金罚息余额（单位分）      
    ,OVDINTPNLTBAL         -- 逾期利息罚息余额（单位分）      
    ,OPTTYPE               -- 操作类型                        
    ,FVTPLTAG              -- 平价和折溢价转让为n，净值回购为y
    ,CLEARINGAMT           -- 转让金额（单位分）              
    ,DIFFAMT               -- 作价资产余额和转让金额之间的差价
    ,STATUS                -- 分期状态                        
    ,ACCRUEDSTATUS         -- 应计非应计标识                  
    ,WRITEOFF              -- 核销标识                        
    ,OPSTORG               -- 资产转让交易对手机构            
    ,BSNTYPE               -- 产品业务类型                    
    ,REGIONCODE            -- 行政区划                        
    ,ETL_DT                -- etl处理日期                     
    ,ETL_TIMESTAMP         -- etl处理时间戳
     )
  SELECT CONTRACTNO            -- 平台贷款合同号                  
        ,TERMNO                -- 期次号                          
        ,SETTLEDATE            -- 业务日期                        
        ,TRANSTIME             -- 交易时间                        
        ,SEQNO                 -- 资产转让业务流水号              
        ,FUNDSEQNO             -- 资金流水号                      
        ,STARTDATE             -- 分期开始日期                    
        ,ENDDATE               -- 分期结束日期                    
        ,PRINBAL               -- 本金余额（单位分）              
        ,INTBAL                -- 利息余额（单位分）              
        ,OVDPRINPNLTBAL        -- 逾期本金罚息余额（单位分）      
        ,OVDINTPNLTBAL         -- 逾期利息罚息余额（单位分）      
        ,OPTTYPE               -- 操作类型                        
        ,FVTPLTAG              -- 平价和折溢价转让为n，净值回购为y
        ,CLEARINGAMT           -- 转让金额（单位分）              
        ,DIFFAMT               -- 作价资产余额和转让金额之间的差价
        ,STATUS                -- 分期状态                        
        ,ACCRUEDSTATUS         -- 应计非应计标识                  
        ,WRITEOFF              -- 核销标识                        
        ,OPSTORG               -- 资产转让交易对手机构            
        ,BSNTYPE               -- 产品业务类型                    
        ,REGIONCODE            -- 行政区划                        
        ,ETL_DT + 1            -- etl处理日期                     
        ,ETL_TIMESTAMP         -- etl处理时间戳
    FROM IOL.V_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO  --视图-代码表，代码库
     --WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') - 1
   ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO','', O_ERRCODE);

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

END ETL_O_IOL_ICMS_MYBK_ASSET_TRANSFER_DETAIL_ESO;
/

