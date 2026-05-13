CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_CORE_BASIC_TRAN(I_P_DATE IN INTEGER, --跑批日期
                                                          O_ERRCODE OUT VARCHAR2 --错误代码
                                                          )
 /*******************************************************************
  **存储过程详细说明： 核心基本交易
  **存储过程名称：    ETL_O_IML_EVT_CORE_BASIC_TRAN
  **存储过程创建日期：20220315
  **存储过程创建人：  严唯正
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_CORE_BASIC_TRAN'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_CORE_BASIC_TRAN'; --程序名称
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
  V_STEP_DESC := '数据落地-核心基本交易';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_EVT_CORE_BASIC_TRAN NOLOGGING
    (EVT_ID                      --事件编号
    ,LP_ID                       --法人编号
    ,TRAN_DT                     --交易日期
    ,TRAN_FLOW_NUM               --交易流水号
    ,TRAN_TM                     --交易时间
    ,TRAN_KIND_CD                --交易种类代码
    ,TRAN_CODE                   --交易码
    ,TRAN_CHN_ID                 --交易渠道编号
    ,TRAN_ORG_ID                 --交易机构编号
    ,TERMN_ID                    --终端编号
    ,TRAN_TELLER_ID              --交易柜员编号
    ,CHECK_TELLER_ID             --复核柜员编号
    ,AUTH_TELLER_ID              --授权柜员编号
    ,BAL_CHK_FLG                 --勾对标志
    ,TRAN_STATUS_CD              --交易状态代码
    ,OVA_FLOW_NUM                --全局流水号
    ,EXT_FLOW_NUM                --外部流水号
    ,CNTER_TRAN_CODE             --柜面交易码
    ,ETL_DT                      --数据日期
    ,SRC_TABLE_NAME              --源表名称
    ,JOB_CD                      --任务代码
    )
  SELECT /*+PARALLEL*/
         EVT_ID                      --事件编号
        ,LP_ID                       --法人编号
        ,TRAN_DT                     --交易日期
        ,TRAN_FLOW_NUM               --交易流水号
        ,TRAN_TM                     --交易时间
        ,TRAN_KIND_CD                --交易种类代码
        ,TRAN_CODE                   --交易码
        ,TRAN_CHN_ID                 --交易渠道编号
        ,TRAN_ORG_ID                 --交易机构编号
        ,TERMN_ID                    --终端编号
        ,TRAN_TELLER_ID              --交易柜员编号
        ,CHECK_TELLER_ID             --复核柜员编号
        ,AUTH_TELLER_ID              --授权柜员编号
        ,BAL_CHK_FLG                 --勾对标志
        ,TRAN_STATUS_CD              --交易状态代码
        ,OVA_FLOW_NUM                --全局流水号
        ,EXT_FLOW_NUM                --外部流水号
        ,CNTER_TRAN_CODE             --柜面交易码
        ,ETL_DT                      --数据日期
        ,SRC_TABLE_NAME              --源表名称
        ,JOB_CD                      --任务代码
    FROM IML.V_EVT_CORE_BASIC_TRAN  --核心基本交易_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
   --TRAN_DT <= TO_DATE(V_P_DATE,'YYYYMMDD'); --MOIDFY BY ZM 20210119 流水表取当天交易日期为数据日期

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序跑批结束记录 --
  V_STEP := 3;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,V_PART_NAME, O_ERRCODE);

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

END ETL_O_IML_EVT_CORE_BASIC_TRAN;
/

