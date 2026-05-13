CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_LOAN_PROD_TRAN_ADDIT_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                                    O_ERRCODE OUT VARCHAR2 --错误代码
                                                                    )
 /*******************************************************************
  **存储过程详细说明： 贷款产品交易附加信息
  **存储过程名称：    ETL_O_IML_EVT_INSTR_TOT_RGST_B
  **存储过程创建日期：20220325
  **存储过程创建人：  陈宜玲
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(50);               --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_LOAN_PROD_TRAN_ADDIT_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_LOAN_PROD_TRAN_ADDIT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME :=  'P'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_INSTR_TOT_RGST_B';
  SELECT COUNT(1) INTO V_SQLCOUNT FROM USER_TAB_PARTITIONS T
   WHERE T.TABLE_NAME = V_TAB_NAME AND T.PARTITION_NAME = V_PART_NAME;
  IF V_SQLCOUNT = 1 THEN
     EXECUTE IMMEDIATE 'ALTER TABLE '||V_TAB_NAME||' DROP PARTITION '||V_PART_NAME;
  END IF;

  EXECUTE IMMEDIATE 'ALTER TABLE '||V_TAB_NAME||' ADD PARTITION '||V_PART_NAME||' VALUES '||
                    '('||'TO_DATE('''||V_P_DATE||''',''YYYYMMDD'')'||')' ||' COMPRESS NOLOGGING';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-贷款产品交易附加信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_LOAN_PROD_TRAN_ADDIT_INFO NOLOGGING
    (EVT_ID                         --事件编号
    ,LP_ID                          --法人编号
    ,TRAN_DT                        --交易日期
    ,TRAN_TM                        --交易时间
    ,TRAN_SEQ_NUM                   --交易序号
    ,TRAN_CODE                      --交易码
    ,BUS_ORG_ID                     --营业机构编号
    ,ACCT_INSTIT_ID                 --账务机构编号
    ,CHN_CD                         --渠道代码
    ,TRAN_TELLER_ID                 --交易柜员编号
    ,TELLER_FLOW_ID                 --柜员流水编号
    ,AUTH_DT                        --授权日期
    ,AUTH_ORG_ID                    --授权机构编号
    ,AUTH_TELLER_ID                 --授权柜员编号
    ,SYS_FLOW_NUM                   --系统流水号
    ,PAYMENT_TRAN_CODE              --前台交易码
    ,PAYMENT_TRAN_DT                --前台交易日期
    ,PAYMENT_FLOW_NUM               --前台流水号
    ,TRAN_NAME                      --交易名称
    ,ERASE_ACCT_FLG                 --抹账标志
    ,ERASE_ACCT_DT                  --抹账日期
    ,ERASE_ACCT_TELLER_ID           --抹帐柜员编号
    ,ERASE_ACCT_FLOW_NUM            --抹帐流水号
    ,HOST_DT                        --主机日期
    ,CHECK_DT                       --复核日期
    ,CHECK_TELLER_ID                --复核柜员编号
    ,CHECK_FLOW_NUM                 --复核流水号
    ,LON_MDL_SUPVS_FLG              --贷中监督标志
    ,LON_MDL_SUPVS_DT               --贷中监督日期
    ,LON_MDL_SUPVS_TELLER_ID        --贷中监督柜员编号
    ,BLEND_FLG                      --勾兑标志
    ,BLEND_TELLER_ID                --勾兑柜员编号
    ,BUS_ID                         --业务编号
    ,ETL_DT                         --ETL处理日期
    ,SRC_TABLE_NAME                 --源表名称
    ,JOB_CD                         --任务编码
    )
  SELECT /*+PARALLEL*/
         EVT_ID                         --事件编号
        ,LP_ID                          --法人编号
        ,TRAN_DT                        --交易日期
        ,TRAN_TM                        --交易时间
        ,TRAN_SEQ_NUM                   --交易序号
        ,TRAN_CODE                      --交易码
        ,BUS_ORG_ID                     --营业机构编号
        ,ACCT_INSTIT_ID                 --账务机构编号
        ,CHN_CD                         --渠道代码
        ,TRAN_TELLER_ID                 --交易柜员编号
        ,TELLER_FLOW_ID                 --柜员流水编号
        ,AUTH_DT                        --授权日期
        ,AUTH_ORG_ID                    --授权机构编号
        ,AUTH_TELLER_ID                 --授权柜员编号
        ,SYS_FLOW_NUM                   --系统流水号
        ,PAYMENT_TRAN_CODE              --前台交易码
        ,PAYMENT_TRAN_DT                --前台交易日期
        ,PAYMENT_FLOW_NUM               --前台流水号
        ,TRAN_NAME                      --交易名称
        ,ERASE_ACCT_FLG                 --抹账标志
        ,ERASE_ACCT_DT                  --抹账日期
        ,ERASE_ACCT_TELLER_ID           --抹帐柜员编号
        ,ERASE_ACCT_FLOW_NUM            --抹帐流水号
        ,HOST_DT                        --主机日期
        ,CHECK_DT                       --复核日期
        ,CHECK_TELLER_ID                --复核柜员编号
        ,CHECK_FLOW_NUM                 --复核流水号
        ,LON_MDL_SUPVS_FLG              --贷中监督标志
        ,LON_MDL_SUPVS_DT               --贷中监督日期
        ,LON_MDL_SUPVS_TELLER_ID        --贷中监督柜员编号
        ,BLEND_FLG                      --勾兑标志
        ,BLEND_TELLER_ID                --勾兑柜员编号
        ,BUS_ID                         --业务编号
        ,ETL_DT                         --ETL处理日期
        ,SRC_TABLE_NAME                 --源表名称
        ,JOB_CD                         --任务编码
    FROM IML.V_EVT_LOAN_PROD_TRAN_ADDIT_INFO  --贷款产品交易附加信息_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_EVT_LOAN_PROD_TRAN_ADDIT_INFO;
/

