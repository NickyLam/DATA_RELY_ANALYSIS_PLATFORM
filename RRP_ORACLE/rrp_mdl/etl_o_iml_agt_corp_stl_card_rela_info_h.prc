CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_CORP_STL_CARD_RELA_INFO_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：单位结算卡关联信息历史
  **存储过程名称：    ETL_O_IML_AGT_CORP_STL_CARD_RELA_INFO_H
  **存储过程创建日期：20250408
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250408    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_AGT_CORP_STL_CARD_RELA_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_CORP_STL_CARD_RELA_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-单位结算卡关联信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_CORP_STL_CARD_RELA_INFO_H NOLOGGING 
  (      VOUCH_ID                 --凭证编号
        ,CARD_NO                  --卡号
        ,ACCT_NUM_SUB_ACCT_NUM    --账号子账号
        ,CUST_ACCT_NUM            --客户账号
        ,ACCT_PROD_ID             --账户产品编号
        ,LP_ID                    --法人编号
        ,CARD_PROD_ID             --卡产品编号
        ,ACCT_CURR_CD             --账户币种代码
        ,CUST_ID                  --客户编号
        ,DEFLT_ACCT_NUM_FLG       --默认账号标志
        ,MAIN_CARD_FLG            --主卡标志
        ,MAIN_CARD_CARD_NO        --主卡卡号
        ,GENERAL_EXCH_FLG         --通兑标志
        ,AUTO_COLL_SEQ_TYPE_CD    --自动归集顺序类型代码
        ,COLL_SEQ_NUM             --归集顺序号
        ,LINKG_DEDUCT_FLG         --联动扣款标志
        ,CARD_STOP_USE_FLG        --卡停用标志
        ,IN_CARD_INTERTURN_FLG    --卡内互转标志
        ,DEP_FLG                  --可存款标志
        ,TRANBL_FLG               --可转出标志
        ,CASH_FLG                 --可取现标志
        ,INCO_DECIDE_EXPNS_FLG    --以收定支标志
        ,TRAN_DT                  --交易日期
        ,TRAN_ORG_ID              --交易机构编号
        ,START_DT                 --开始时间
        ,END_DT                   --结束时间
        ,ID_MARK                  --增删标志
        ,SRC_TABLE_NAME           --源表名称
        ,JOB_CD                   --任务编码
        ,ETL_TIMESTAMP            --ETL处理时间戳
        ,TRAN_TIMESTAMP           --交易时间
    )
    SELECT
         VOUCH_ID                 --凭证编号
        ,CARD_NO                  --卡号
        ,ACCT_NUM_SUB_ACCT_NUM    --账号子账号
        ,CUST_ACCT_NUM            --客户账号
        ,ACCT_PROD_ID             --账户产品编号
        ,LP_ID                    --法人编号
        ,CARD_PROD_ID             --卡产品编号
        ,ACCT_CURR_CD             --账户币种代码
        ,CUST_ID                  --客户编号
        ,DEFLT_ACCT_NUM_FLG       --默认账号标志
        ,MAIN_CARD_FLG            --主卡标志
        ,MAIN_CARD_CARD_NO        --主卡卡号
        ,GENERAL_EXCH_FLG         --通兑标志
        ,AUTO_COLL_SEQ_TYPE_CD    --自动归集顺序类型代码
        ,COLL_SEQ_NUM             --归集顺序号
        ,LINKG_DEDUCT_FLG         --联动扣款标志
        ,CARD_STOP_USE_FLG        --卡停用标志
        ,IN_CARD_INTERTURN_FLG    --卡内互转标志
        ,DEP_FLG                  --可存款标志
        ,TRANBL_FLG               --可转出标志
        ,CASH_FLG                 --可取现标志
        ,INCO_DECIDE_EXPNS_FLG    --以收定支标志
        ,TRAN_DT                  --交易日期
        ,TRAN_ORG_ID              --交易机构编号
        ,START_DT                 --开始时间
        ,END_DT                   --结束时间
        ,ID_MARK                  --增删标志
        ,SRC_TABLE_NAME           --源表名称
        ,JOB_CD                   --任务编码
        ,ETL_TIMESTAMP            --ETL处理时间戳
        ,TRAN_TIMESTAMP           --交易时间
  FROM IML.V_AGT_CORP_STL_CARD_RELA_INFO_H --视图-单位结算卡关联信息历史
 WHERE ID_MARK <> 'D'
   AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_CORP_STL_CARD_RELA_INFO_H', '', O_ERRCODE);

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

END ETL_O_IML_AGT_CORP_STL_CARD_RELA_INFO_H;
/

