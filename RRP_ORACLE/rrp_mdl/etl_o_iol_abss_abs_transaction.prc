CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ABSS_ABS_TRANSACTION(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：交易表
  **存储过程名称：    ETL_O_IOL_ABSS_ABS_TRANSACTION
  **存储过程创建日期：20250910
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250910    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ABSS_ABS_TRANSACTION'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ABSS_ABS_TRANSACTION';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-交易表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ABSS_ABS_TRANSACTION NOLOGGING 
  (         SERIALNO                 --交易流水号
           ,PARENTTRANSSERIALNO      --关联交易流水号
           ,TRANSCODE                --交易代码(Transaction-abs-Config.xml
           ,RELATIVEOBJECTTYPE       --关联对象类型
           ,RELATIVEOBJECTNO         --关联对象编号
           ,DOCUMENTTYPE             --单据类型
           ,DOCUMENTNO               --单据流水号
           ,CHANNELID                --交易渠道
           ,OCCURDATE                --交易操作日期
           ,OCCURTIME                --交易时间
           ,TRANSDATE                --交易日期
           ,TRANSSTATUS              --交易状态
           ,INPUTORGID               --录入机构
           ,INPUTUSERID              --录入人
           ,INPUTTIME                --录入时间
           ,REMARK                   --描述
           ,LOG                      --其他日志
           ,FALLBACKTRANSSERIALNO    --回退交易流水号
           ,SCENEID                  --情景编号
           ,TRANCHERATE1             --分档利率A
           ,TRANCHERATE2             --分档利率B
           ,START_DT                 --开始时间
           ,END_DT                   --结束时间
           ,ID_MARK                  --增删标志
           ,ETL_TIMESTAMP            --ETL处理时间戳
    )
    SELECT
            SERIALNO                 --交易流水号
           ,PARENTTRANSSERIALNO      --关联交易流水号
           ,TRANSCODE                --交易代码(Transaction-abs-Config.xml
           ,RELATIVEOBJECTTYPE       --关联对象类型
           ,RELATIVEOBJECTNO         --关联对象编号
           ,DOCUMENTTYPE             --单据类型
           ,DOCUMENTNO               --单据流水号
           ,CHANNELID                --交易渠道
           ,OCCURDATE                --交易操作日期
           ,OCCURTIME                --交易时间
           ,TRANSDATE                --交易日期
           ,TRANSSTATUS              --交易状态
           ,INPUTORGID               --录入机构
           ,INPUTUSERID              --录入人
           ,INPUTTIME                --录入时间
           ,REMARK                   --描述
           ,LOG                      --其他日志
           ,FALLBACKTRANSSERIALNO    --回退交易流水号
           ,SCENEID                  --情景编号
           ,TRANCHERATE1             --分档利率A
           ,TRANCHERATE2             --分档利率B
           ,START_DT                 --开始时间
           ,END_DT                   --结束时间
           ,ID_MARK                  --增删标志
           ,ETL_TIMESTAMP            --ETL处理时间戳
  FROM IOL.V_ABSS_ABS_TRANSACTION   --视图-交易表
 WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
   AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
   AND ID_MARK <> 'D'
   ;
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ABSS_ABS_TRANSACTION', '', O_ERRCODE);

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

END ETL_O_IOL_ABSS_ABS_TRANSACTION;
/

