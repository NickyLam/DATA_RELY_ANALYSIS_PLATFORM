CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_PTY_INDV_CUST_CHN_RELA_H(I_P_DATE IN INTEGER, --跑批日期
                                                               O_ERRCODE OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明： 个人客户与渠道关系历史表
  **存储过程名称：    ETL_O_IML_PTY_INDV_CUST_CHN_RELA_H
  **存储过程创建日期：20221130
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  *  20241227    YJY        优化脚本
  *******************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_PTY_INDV_CUST_CHN_RELA_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_PTY_INDV_CUST_CHN_RELA_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_PTY_INDV_CUST_CHN_RELA_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-个人客户与渠道关系历史表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_PTY_INDV_CUST_CHN_RELA_H NOLOGGING
    (PARTY_ID                    --当事人编号
    ,BELONG_PLAT_CD              --所属平台代码
    ,LP_ID                       --法人编号
    ,SIGN_CHN_CD                 --签约渠道代码
    ,USER_SEQ_NUM                --用户顺序号
    ,LOGON_ACCT_ID               --登陆账户编号
    ,USER_ACCT_STATUS_CD         --用户账户状态代码
    ,OPEN_TM                     --开户时间
    ,CLOS_ACCT_TM                --销户时间
    ,ONL_BANK_PAUSE_STATUS_CD    --网银暂停状态代码
    ,ONL_BANK_PAUSE_END_TM       --网银暂停结束时间
    ,ONL_BANK_PAUSE_START_TM     --网银暂停开始时间
    ,MBANK_PAUSE_STATUS_CD       --手机银行暂停状态代码
    ,MBANK_PAUSE_START_TM        --手机银行暂停开始时间
    ,MBANK_PAUSE_END_TM          --手机银行暂停结束时间
    ,E_ACCT_SIGN_PLAT_CD         --电子账户签约平台代码
    ,SAVE_CERT_WAY_CD            --安全认证方式代码
    ,START_DT                    --开始日期
    ,END_DT                      --结束日期
    ,ID_MARK                     --删除标识
    ,SRC_TABLE_NAME              --源表名称
    ,JOB_CD                      --任务代码
    ,ETL_TIMESTAMP               --数据处理时间
    )
  SELECT /*+PARALLEL*/
         PARTY_ID                    --当事人编号
        ,BELONG_PLAT_CD              --所属平台代码
        ,LP_ID                       --法人编号
        ,SIGN_CHN_CD                 --签约渠道代码
        ,USER_SEQ_NUM                --用户顺序号
        ,LOGON_ACCT_ID               --登陆账户编号
        ,USER_ACCT_STATUS_CD         --用户账户状态代码
        ,OPEN_TM                     --开户时间
        ,CLOS_ACCT_TM                --销户时间
        ,ONL_BANK_PAUSE_STATUS_CD    --网银暂停状态代码
        ,ONL_BANK_PAUSE_END_TM       --网银暂停结束时间
        ,ONL_BANK_PAUSE_START_TM     --网银暂停开始时间
        ,MBANK_PAUSE_STATUS_CD       --手机银行暂停状态代码
        ,MBANK_PAUSE_START_TM        --手机银行暂停开始时间
        ,MBANK_PAUSE_END_TM          --手机银行暂停结束时间
        ,E_ACCT_SIGN_PLAT_CD         --电子账户签约平台代码
        ,SAVE_CERT_WAY_CD            --安全认证方式代码
        ,START_DT                    --开始日期
        ,END_DT                      --结束日期
        ,ID_MARK                     --删除标识
        ,SRC_TABLE_NAME              --源表名称
        ,JOB_CD                      --任务代码
        ,ETL_TIMESTAMP               --数据处理时间
    FROM IML.V_PTY_INDV_CUST_CHN_RELA_H --视图_个人客户与渠道关系历史表
   WHERE ID_MARK <> 'D' ;

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

END ETL_O_IML_PTY_INDV_CUST_CHN_RELA_H;
/

