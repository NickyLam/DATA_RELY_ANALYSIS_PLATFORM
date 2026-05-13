CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ICMS_LHD_TRANS_FLOW_INFO_HISTORY(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：信贷供交易流水文件临时表历史表
  **存储过程名称：    ETL_O_IOL_ICMS_LHD_TRANS_FLOW_INFO_HISTORY
  **存储过程创建日期：20260105
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20260105    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ICMS_LHD_TRANS_FLOW_INFO_HISTORY'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ICMS_LHD_TRANS_FLOW_INFO_HISTORY';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-信贷供交易流水文件临时表历史表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ICMS_LHD_TRANS_FLOW_INFO_HISTORY NOLOGGING 
  (             SERIALNO        --流水号
                ,DUEBILLNO      --信贷借据号
                ,ACCOUNTDATE    --账务日期
                ,TRANSNO        --交易流水号
                ,TRANSTYPE      --交易类型
                ,TRANSAMT       --交易金额
                ,NOACCSTATUS    --非应计状态
                ,PRIOCCAMT      --本金发生额
                ,INTOCCAMT      --利息发生额
                ,DEFINTOCCAMT   --罚息发生额
                ,CZFLAG         --冲正标识
                ,CHANNEL        --渠道
                ,TRANSDATE      --交易时间戳
                ,TRANSORGID     --交易机构
                ,MIGTTYPE       --交易标志
                ,INPUTUSERID    --登记人
                ,INPUTORGID     --登记机构
                ,INPUTDATE      --登记日期
                ,UPDATEUSERID   --更新人
                ,UPDATEORGID    --更新机构
                ,UPDATEDATE     --更新日期
                ,COMPINTOCCAMT  --复利发生额
                ,HXDUEBILLNO    --核心借据号
                ,NORMALINTAMT   --正常利息
                ,NORMALODPAMT   --正常罚息
                ,NORMALODIAMT   --正常复利
                ,INTPAMT        --逾期利息
                ,ODPPAMT        --逾期罚息
                ,ODIPAMT        --逾期复利
                ,BATCHNO        --批次号
                ,SENDFLAG       --是否上送（1上送成功，null未上送，0上送失败）
                ,COMPFLAG       --是否代偿（1是，其他为否）
                ,BIZDATE        --数据日期
                ,TYPE           --类型
                ,GLOBSEQNUM     --全局流水号
                ,ETL_DT         --ETL处理日期
                ,ETL_TIMESTAMP  --ETL处理时间戳
    )
  SELECT 
                SERIALNO        --流水号
                ,DUEBILLNO      --信贷借据号
                ,ACCOUNTDATE    --账务日期
                ,TRANSNO        --交易流水号
                ,TRANSTYPE      --交易类型
                ,TRANSAMT       --交易金额
                ,NOACCSTATUS    --非应计状态
                ,PRIOCCAMT      --本金发生额
                ,INTOCCAMT      --利息发生额
                ,DEFINTOCCAMT   --罚息发生额
                ,CZFLAG         --冲正标识
                ,CHANNEL        --渠道
                ,TRANSDATE      --交易时间戳
                ,TRANSORGID     --交易机构
                ,MIGTTYPE       --交易标志
                ,INPUTUSERID    --登记人
                ,INPUTORGID     --登记机构
                ,INPUTDATE      --登记日期
                ,UPDATEUSERID   --更新人
                ,UPDATEORGID    --更新机构
                ,UPDATEDATE     --更新日期
                ,COMPINTOCCAMT  --复利发生额
                ,HXDUEBILLNO    --核心借据号
                ,NORMALINTAMT   --正常利息
                ,NORMALODPAMT   --正常罚息
                ,NORMALODIAMT   --正常复利
                ,INTPAMT        --逾期利息
                ,ODPPAMT        --逾期罚息
                ,ODIPAMT        --逾期复利
                ,BATCHNO        --批次号
                ,SENDFLAG       --是否上送（1上送成功，null未上送，0上送失败）
                ,COMPFLAG       --是否代偿（1是，其他为否）
                ,BIZDATE        --数据日期
                ,TYPE           --类型
                ,GLOBSEQNUM     --全局流水号
                ,ETL_DT         --ETL处理日期
                ,ETL_TIMESTAMP  --ETL处理时间戳
    FROM IOL.V_ICMS_LHD_TRANS_FLOW_INFO_HISTORY --视图-信贷供交易流水文件临时表历史表
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ICMS_LHD_TRANS_FLOW_INFO_HISTORY', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ICMS_LHD_TRANS_FLOW_INFO_HISTORY;
/

