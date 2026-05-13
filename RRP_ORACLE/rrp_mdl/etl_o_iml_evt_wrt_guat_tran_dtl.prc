CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_WRT_GUAT_TRAN_DTL(I_P_DATE IN INTEGER, --跑批日期
                                                            O_ERRCODE OUT VARCHAR2 --错误代码
                                                            )
 /*******************************************************************
  **存储过程详细说明： 结售汇交易明细
  **存储过程名称：    ETL_O_IML_EVT_WRT_GUAT_TRAN_DTL
  **存储过程创建日期：20220325
  **存储过程创建人：  陈宜玲
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  ********************************************************************/
IS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PART_NAME VARCHAR2(50);               --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_WRT_GUAT_TRAN_DTL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_WRT_GUAT_TRAN_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME :=  'P'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_CORE_BASIC_TRAN';
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
  V_STEP_DESC := '数据落地-结售汇交易明细';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_WRT_GUAT_TRAN_DTL NOLOGGING
    (EVT_ID                       --事件编号
    ,LP_ID                        --法人编号
    ,TRAN_DT                      --交易日期
    ,TRAN_FLOW_NUM                --交易流水号
    ,TRAN_ORG_ID                  --交易机构编号
    ,TRAN_TELLER_ID               --交易柜员编号
    ,WRT_GUAT_TYPE_CD             --结售汇类型代码
    ,WRT_GUAT_DTL_TYPE_CD         --结售汇明细类型代码
    ,STAT_PROJ_CD                 --统计项目代码
    ,BUY_CURR_CD                  --买入币种代码
    ,BUY_ACCT_ID                  --买入账户编号
    ,BUY_ACCT_SUB_ACCT_ID         --买入账户子账户编号
    ,BUY_EC_IDF_CD                --买入钞汇标识代码
    ,BUY_NR                       --买入挂牌汇率
    ,BUY_TRAN_EXCH_RAT            --买入交易汇率
    ,BUY_AMT                      --买入金额
    ,BUY_NP                       --买入挂牌价格
    ,SELL_CURR_CD                 --卖出币种代码
    ,SELL_ACCT_ID                 --卖出账户编号
    ,SELL_ACCT_SUB_ACCT_ID        --卖出账户子账户编号
    ,SELL_EC_IDF_CD               --卖出钞汇标识代码
    ,SELL_NR                      --卖出挂牌汇率
    ,SELL_TRAN_EXCH_RAT           --卖出交易汇率
    ,SELL_AMT                     --卖出金额
    ,SELL_NP                      --卖出挂牌价格
    ,CUST_ID                      --客户编号
    ,CUST_NAME                    --客户名称
    ,CUST_PREFR_POINT             --客户优惠点数
    ,CTY_RG_CD                    --国家和地区代码
    ,CERT_TYPE_CD                 --证件类型代码
    ,CERT_NO                      --证件号码
    ,QUOT_TM                      --报价时间
    ,BUS_KIND_CD                  --业务种类代码
    ,BS_TYPE_CD                   --买卖类型代码
    ,TRAN_STATUS_CD               --交易状态代码
    ,RESDNT_REFUND_FLG            --居民退汇标志
    ,TRAN_CHN_CD                  --交易渠道代码
    ,ETL_DT                       --ETL处理日期
    ,SRC_TABLE_NAME               --源表名称
    ,JOB_CD                       --任务编码
    )
  SELECT /*+PARALLEL*/
         EVT_ID                       --事件编号
        ,LP_ID                        --法人编号
        ,TRAN_DT                      --交易日期
        ,TRAN_FLOW_NUM                --交易流水号
        ,TRAN_ORG_ID                  --交易机构编号
        ,TRAN_TELLER_ID               --交易柜员编号
        ,WRT_GUAT_TYPE_CD             --结售汇类型代码
        ,WRT_GUAT_DTL_TYPE_CD         --结售汇明细类型代码
        ,STAT_PROJ_CD                 --统计项目代码
        ,BUY_CURR_CD                  --买入币种代码
        ,BUY_ACCT_ID                  --买入账户编号
        ,BUY_ACCT_SUB_ACCT_ID         --买入账户子账户编号
        ,BUY_EC_IDF_CD                --买入钞汇标识代码
        ,BUY_NR                       --买入挂牌汇率
        ,BUY_TRAN_EXCH_RAT            --买入交易汇率
        ,BUY_AMT                      --买入金额
        ,BUY_NP                       --买入挂牌价格
        ,SELL_CURR_CD                 --卖出币种代码
        ,SELL_ACCT_ID                 --卖出账户编号
        ,SELL_ACCT_SUB_ACCT_ID        --卖出账户子账户编号
        ,SELL_EC_IDF_CD               --卖出钞汇标识代码
        ,SELL_NR                      --卖出挂牌汇率
        ,SELL_TRAN_EXCH_RAT           --卖出交易汇率
        ,SELL_AMT                     --卖出金额
        ,SELL_NP                      --卖出挂牌价格
        ,CUST_ID                      --客户编号
        ,CUST_NAME                    --客户名称
        ,CUST_PREFR_POINT             --客户优惠点数
        ,CTY_RG_CD                    --国家和地区代码
        ,CERT_TYPE_CD                 --证件类型代码
        ,CERT_NO                      --证件号码
        ,QUOT_TM                      --报价时间
        ,BUS_KIND_CD                  --业务种类代码
        ,BS_TYPE_CD                   --买卖类型代码
        ,TRAN_STATUS_CD               --交易状态代码
        ,RESDNT_REFUND_FLG            --居民退汇标志
        ,TRAN_CHN_CD                  --交易渠道代码
        ,ETL_DT                       --ETL处理日期
        ,SRC_TABLE_NAME               --源表名称
        ,JOB_CD                       --任务编码
    FROM IML.V_EVT_WRT_GUAT_TRAN_DTL   --结售汇交易明细_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

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

END ETL_O_IML_EVT_WRT_GUAT_TRAN_DTL;
/

