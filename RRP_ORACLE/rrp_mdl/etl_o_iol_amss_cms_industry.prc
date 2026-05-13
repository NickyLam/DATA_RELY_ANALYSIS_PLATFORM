CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_AMSS_CMS_INDUSTRY(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：行业类别表
  **存储过程名称：    ETL_O_IOL_AMSS_CMS_INDUSTRY
  **存储过程创建日期：20250507
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250507    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_AMSS_CMS_INDUSTRY'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_AMSS_CMS_INDUSTRY';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-行业类别表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_AMSS_CMS_INDUSTRY NOLOGGING 
  (        INDUSTRY_ID                    --行业ID
          ,INDUSTRY_NAME                  --行业名称
          ,PARENT_INDUSTRY                --所属行业
          ,THI_INDUSTRY                   --第三方行业类别.商户信息报备时使用
          ,DEAL_TYPE                      --经营类型.1:实体;2:虚拟
          ,REMARK                         --备注
          ,CREATE_USER                    --创建用户
          ,CREATE_EMP                     --创建人
          ,CREATE_TIME                    --创建时间
          ,UPDATE_TIME                    --更新时间
          ,ALI_INDUSTRY                   --阿里第三方行业类别
          ,QQ_INDUSTRY                    --QQ行业类别
          ,ALIPAY_AUTHORIZATION_DESC      --描述需要哪些执照和许可证，创建支付宝门店的时候需要用到
          ,ALI_V2_INDUSTRY                --支付宝V2报备行业类别
          ,BEST_PAY_INDUSTRY              --翼支付行业类别
          ,HEBAO_INDUSTRY                 --和包行业类别
          ,YIFUBAO_INDUSTRY               --易付宝行业类别
          ,UNION_PAY_INDUSTRY             --银联二维码行业类别
          ,SHENGFUTONG_INDUSTRY           --盛付通行业类别
          ,JD_INDUSTRY                    --京东行业类别
          ,UNION_QQ_INDUSTRY              --银联QQ钱包行业类别
          ,MCC                            --MCC码
          ,FLD_S1                         --字符备用1
          ,FLD_S2                         --字符备用2
          ,FLD_S3                         --字符备用3
          ,FLD_S4                         --字符备用4
          ,FLD_S5                         --字符备用5
          ,YZ_INDUSTRY                    --银总行业类别
          ,WX_SETTLEMENT_ID_NORMAL        --微信结算ID(普通)
          ,WX_SETTLEMENT_ID_NEWSMALL      --微信结算ID(小微)
          ,WX_SETTLEMENT_ID_NORMAL2          
          ,WX_SETTLEMENT_ID_NEWSMALL2          
          ,BANK_INDUSTRY                  --银行的行业ID
          ,UNION_UNSTANDARD_FLAG          --银联非标费率标识，0-标准费率;1-可非标费率
          ,ROOT_INDUSTRY                  --ROOT行业类别
          ,INDUSTRY_LEVEL                 --行业分级
          ,START_DT                       --开始时间
          ,END_DT                         --结束时间
          ,ID_MARK                        --增删标志
          ,ETL_TIMESTAMP                  --ETL处理时间戳
    )
    SELECT
           INDUSTRY_ID                    --行业ID
          ,INDUSTRY_NAME                  --行业名称
          ,PARENT_INDUSTRY                --所属行业
          ,THI_INDUSTRY                   --第三方行业类别.商户信息报备时使用
          ,DEAL_TYPE                      --经营类型.1:实体;2:虚拟
          ,REMARK                         --备注
          ,CREATE_USER                    --创建用户
          ,CREATE_EMP                     --创建人
          ,CREATE_TIME                    --创建时间
          ,UPDATE_TIME                    --更新时间
          ,ALI_INDUSTRY                   --阿里第三方行业类别
          ,QQ_INDUSTRY                    --QQ行业类别
          ,ALIPAY_AUTHORIZATION_DESC      --描述需要哪些执照和许可证，创建支付宝门店的时候需要用到
          ,ALI_V2_INDUSTRY                --支付宝V2报备行业类别
          ,BEST_PAY_INDUSTRY              --翼支付行业类别
          ,HEBAO_INDUSTRY                 --和包行业类别
          ,YIFUBAO_INDUSTRY               --易付宝行业类别
          ,UNION_PAY_INDUSTRY             --银联二维码行业类别
          ,SHENGFUTONG_INDUSTRY           --盛付通行业类别
          ,JD_INDUSTRY                    --京东行业类别
          ,UNION_QQ_INDUSTRY              --银联QQ钱包行业类别
          ,MCC                            --MCC码
          ,FLD_S1                         --字符备用1
          ,FLD_S2                         --字符备用2
          ,FLD_S3                         --字符备用3
          ,FLD_S4                         --字符备用4
          ,FLD_S5                         --字符备用5
          ,YZ_INDUSTRY                    --银总行业类别
          ,WX_SETTLEMENT_ID_NORMAL        --微信结算ID(普通)
          ,WX_SETTLEMENT_ID_NEWSMALL      --微信结算ID(小微)
          ,WX_SETTLEMENT_ID_NORMAL2          
          ,WX_SETTLEMENT_ID_NEWSMALL2          
          ,BANK_INDUSTRY                  --银行的行业ID
          ,UNION_UNSTANDARD_FLAG          --银联非标费率标识，0-标准费率;1-可非标费率
          ,ROOT_INDUSTRY                  --ROOT行业类别
          ,INDUSTRY_LEVEL                 --行业分级
          ,START_DT                       --开始时间
          ,END_DT                         --结束时间
          ,ID_MARK                        --增删标志
          ,ETL_TIMESTAMP                  --ETL处理时间戳
  FROM IOL.V_AMSS_CMS_INDUSTRY --视图-行业类别表
 WHERE ID_MARK <> 'D'
   AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD') 
   ;
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_AMSS_CMS_INDUSTRY', '', O_ERRCODE);

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
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_AMSS_CMS_INDUSTRY;
/

