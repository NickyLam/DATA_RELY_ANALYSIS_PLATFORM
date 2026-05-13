CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ALBS_BPS_RSH_CUST_HIT_FUND(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE OUT VARCHAR2 --错误代码
                                                                 )
 /*******************************************************************
  **存储过程详细说明：增量客户命中表
  **存储过程名称：    ETL_O_IOL_ALBS_BPS_RSH_CUST_HIT_FUND
  **存储过程创建日期：20241219
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20241219    YJY        创建
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_ALBS_BPS_RSH_CUST_HIT_FUND'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ALBS_BPS_RSH_CUST_HIT_FUND';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-增量客户命中表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ALBS_BPS_RSH_CUST_HIT_FUND NOLOGGING 
    (ID                        --表主键
    ,MAIN_ID                  --表主键
    ,OWN_ORG                  --归属组织
    ,CUST_ID                  --客户表主键
    ,SCH_RESULT               --检索命中结果：00-检索通过；02-中黑名单；03-中白名单；01-中高风险国家地区；99-检索异常。
    ,MATCH_LEVEL_ID           --命中后的侦测等级ID，对应匹配等级参数表的值。
    ,RISK_LEVEL               --风险等级（1-一级，2-二级，3-三级，4-四级，5-五级），该值从枚举表中定义，后面会变化
    ,LIST_SCOPE               --检索名单范围，登记该次检索用到的名单范围，多个用半角逗号分隔。
    ,CONFIRM_RESULT           --确认结果
    ,LAST_CONFIRM_RESULT      --上次确认结果：0-未确认；1-确认命中；2-确认误中。
    ,CRT_DATE                 --创建日期(YYYYMMDD)
    ,CRT_DATETIME             --创建时间(YYYYMMDDHHMMSS)
    ,LAST_DATETIME            --最后操作时间(YYYYMMDDHHMMSS)
    ,LAST_USER_ID             --最后操作用户ID
    ,LAST_USER_CODE           --最后操作用户代码
    ,SYSTEM_ID                --对接系统
    ,CUST_CODE                --客户编号
    ,CUST_TYPE                --客户类型
    ,CUST_KIND                --客户种类
    ,CUST_NAME                --客户名称
    ,CUST_ENG_NAME            --客户英文名称
    ,CUST_ADDR                --客户地址
    ,CUST_ENG_ADDR            --客户英文地址
    ,CUST_ID_TYPE             --客户证件类型
    ,CUST_ID_NO               --客户证件号
    ,CUST_COUNTRY             --客户国家
    ,CRT_USER_CODE            --创建用户代码
    ,CRT_BRANCH_CODE          --创建用户机构代码
    ,LAST_BRANCH_ID           --业务机构ID
    ,LAST_TXN                 --交易码
    ,SCH_KIND                 --增量回溯类型
    ,BACKFIELS1               --备用字段1
    ,BACKFIELS2               --备用字段2
    ,BACKFIELS3               --备用字段3
    ,CONFIRM_DESC      
    ,CUST_CHECK_PASS      
    ,CHECK_PASS_FLAG      
    ,ETL_DT                   --ETL处理日期
    ,ETL_TIMESTAMP            --ETL处理时间戳
    )
  SELECT ID                        --表主键
        ,MAIN_ID                  --表主键
        ,OWN_ORG                  --归属组织
        ,CUST_ID                  --客户表主键
        ,SCH_RESULT               --检索命中结果：00-检索通过；02-中黑名单；03-中白名单；01-中高风险国家地区；99-检索异常。
        ,MATCH_LEVEL_ID           --命中后的侦测等级ID，对应匹配等级参数表的值。
        ,RISK_LEVEL               --风险等级（1-一级，2-二级，3-三级，4-四级，5-五级），该值从枚举表中定义，后面会变化
        ,LIST_SCOPE               --检索名单范围，登记该次检索用到的名单范围，多个用半角逗号分隔。
        ,CONFIRM_RESULT           --确认结果
        ,LAST_CONFIRM_RESULT      --上次确认结果：0-未确认；1-确认命中；2-确认误中。
        ,CRT_DATE                 --创建日期(YYYYMMDD)
        ,CRT_DATETIME             --创建时间(YYYYMMDDHHMMSS)
        ,LAST_DATETIME            --最后操作时间(YYYYMMDDHHMMSS)
        ,LAST_USER_ID             --最后操作用户ID
        ,LAST_USER_CODE           --最后操作用户代码
        ,SYSTEM_ID                --对接系统
        ,CUST_CODE                --客户编号
        ,CUST_TYPE                --客户类型
        ,CUST_KIND                --客户种类
        ,CUST_NAME                --客户名称
        ,CUST_ENG_NAME            --客户英文名称
        ,CUST_ADDR                --客户地址
        ,CUST_ENG_ADDR            --客户英文地址
        ,CUST_ID_TYPE             --客户证件类型
        ,CUST_ID_NO               --客户证件号
        ,CUST_COUNTRY             --客户国家
        ,CRT_USER_CODE            --创建用户代码
        ,CRT_BRANCH_CODE          --创建用户机构代码
        ,LAST_BRANCH_ID           --业务机构ID
        ,LAST_TXN                 --交易码
        ,SCH_KIND                 --增量回溯类型
        ,BACKFIELS1               --备用字段1
        ,BACKFIELS2               --备用字段2
        ,BACKFIELS3               --备用字段3
        ,CONFIRM_DESC      
        ,CUST_CHECK_PASS      
        ,CHECK_PASS_FLAG      
        ,ETL_DT                   --ETL处理日期
        ,ETL_TIMESTAMP            --ETL处理时间戳
    FROM IOL.V_ALBS_BPS_RSH_CUST_HIT_FUND;  --视图-增量客户命中表
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_ALBS_BPS_RSH_CUST_HIT_FUND', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_ALBS_BPS_RSH_CUST_HIT_FUND;
/

