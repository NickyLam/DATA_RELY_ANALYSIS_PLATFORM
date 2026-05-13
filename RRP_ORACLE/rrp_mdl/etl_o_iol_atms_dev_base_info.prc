CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_ATMS_DEV_BASE_INFO(I_P_DATE IN INTEGER, --跑批日期
                                                         O_ERRCODE OUT VARCHAR2 --错误代码
                                                         )
 /*******************************************************************
  **存储过程详细说明： 设备基础信息表
  **存储过程名称：    ETL_O_IOL_ATMS_DEV_BASE_INFO
  **存储过程创建日期：20221130
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  *  20241225    YJY        优化脚本
  *  20250828    YJY        新增存款虚拟柜员号、取款虚拟柜员号
  ******************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_ATMS_DEV_BASE_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_ATMS_DEV_BASE_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_ATMS_DEV_BASE_INFO';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-设备基础信息表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_ATMS_DEV_BASE_INFO NOLOGGING
    (NO
    ,IP
    ,ORG_NO
    ,AWAY_FLAG
    ,DEV_CATALOG
    ,DEV_VENDOR
    ,DEV_TYPE
    ,WORK_TYPE
    ,STATUS
    ,DEV_SERVICE
    ,TERMINAL_NO
    ,SERIAL
    ,ADDRESS
    ,BUY_DATE
    ,INSTALL_DATE
    ,START_DATE
    ,STOP_DATE
    ,OPEN_TIME
    ,CLOSE_TIME
    ,EXPIRE_DATE
    ,PATROL_PERIOD
    ,AREA_NO
    ,X
    ,Y
    ,CASHBOX_LIMIT
    ,OS
    ,ATMC_SOFT
    ,ANTI_VIRUS_SOFT
    ,SP
    ,VIRTUAL_TELLER_NO
    ,CARE_LEVEL
    ,LAST_PM_DATE
    ,EXPIRE_PM_DATE
    ,LOCATE_NO
    ,NOTE1
    ,NOTE2
    ,NOTE3
    ,NOTE4
    ,NOTE5
    ,CARRIER
    ,MONEY_ORG
    ,DEV_STATUS
    ,ENVIRONMENT
    ,ADDRESS_CODE
    ,CASH_TYPE
    ,SETUP_TYPE
    ,NET_TYPE
    ,OPERATE_STATUS
    ,REGISTRATION_STATUS
    ,COMM_PACKET
    ,ZIP_TYPE
    ,DEK_ENCODED
    ,ATMP_AREA
    ,SELFBANKTYPE
    ,ARM_TYPE
    ,PREF_NO
    ,COUNTRY_NO
    ,POSTCODE
    ,CONTACT
    ,ACPT_INS_ID_CD
    ,INVSTR_INS_ID_CD
    ,MAINTN_INS_ID_CD
    ,TERM_PUBLICIZE_CHNL
    ,SOCKET
    ,FRN_ACPT_TP
    ,SCAN_CODE
    ,MAGN_READ_IN
    ,NO_CARD
    ,CONT_IC_IN
    ,CONTLESS_IC_IN
    ,TERM_TRAN_FUN
    ,LAST_STATUE
    ,IS_EXPORT
    ,DEPLOY_AREA_NO
    ,DEPLOY_AREA_NAME
    ,TERMINAL_STATUS
    ,START_DT
    ,END_DT
    ,ID_MARK
    ,ETL_TIMESTAMP
    ,DAC              --存款虚拟柜员号    MOD BY YJY 20250828
    ,COMMENTS         --取款虚拟柜员号    MOD BY YJY 20250828
    )
  SELECT /*+PARALLEL(4)*/
         NO
        ,IP
        ,ORG_NO
        ,AWAY_FLAG
        ,DEV_CATALOG
        ,DEV_VENDOR
        ,DEV_TYPE
        ,WORK_TYPE
        ,STATUS
        ,DEV_SERVICE
        ,TERMINAL_NO
        ,SERIAL
        ,ADDRESS
        ,BUY_DATE
        ,INSTALL_DATE
        ,START_DATE
        ,STOP_DATE
        ,OPEN_TIME
        ,CLOSE_TIME
        ,EXPIRE_DATE
        ,PATROL_PERIOD
        ,AREA_NO
        ,X
        ,Y
        ,CASHBOX_LIMIT
        ,OS
        ,ATMC_SOFT
        ,ANTI_VIRUS_SOFT
        ,SP
        ,VIRTUAL_TELLER_NO
        ,CARE_LEVEL
        ,LAST_PM_DATE
        ,EXPIRE_PM_DATE
        ,LOCATE_NO
        ,NOTE1
        ,NOTE2
        ,NOTE3
        ,NOTE4
        ,NOTE5
        ,CARRIER
        ,MONEY_ORG
        ,DEV_STATUS
        ,ENVIRONMENT
        ,ADDRESS_CODE
        ,CASH_TYPE
        ,SETUP_TYPE
        ,NET_TYPE
        ,OPERATE_STATUS
        ,REGISTRATION_STATUS
        ,COMM_PACKET
        ,ZIP_TYPE
        ,DEK_ENCODED
        ,ATMP_AREA
        ,SELFBANKTYPE
        ,ARM_TYPE
        ,PREF_NO
        ,COUNTRY_NO
        ,POSTCODE
        ,CONTACT
        ,ACPT_INS_ID_CD
        ,INVSTR_INS_ID_CD
        ,MAINTN_INS_ID_CD
        ,TERM_PUBLICIZE_CHNL
        ,SOCKET
        ,FRN_ACPT_TP
        ,SCAN_CODE
        ,MAGN_READ_IN
        ,NO_CARD
        ,CONT_IC_IN
        ,CONTLESS_IC_IN
        ,TERM_TRAN_FUN
        ,LAST_STATUE
        ,IS_EXPORT
        ,DEPLOY_AREA_NO
        ,DEPLOY_AREA_NAME
        ,TERMINAL_STATUS
        ,START_DT
        ,END_DT
        ,ID_MARK
        ,ETL_TIMESTAMP
        ,DAC              --存款虚拟柜员号    MOD BY YJY 20250828
        ,COMMENTS         --取款虚拟柜员号    MOD BY YJY 20250828
    FROM IOL.V_ATMS_DEV_BASE_INFO --视图_设备基础信息表
   WHERE ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_IOL_ATMS_DEV_BASE_INFO;
/

