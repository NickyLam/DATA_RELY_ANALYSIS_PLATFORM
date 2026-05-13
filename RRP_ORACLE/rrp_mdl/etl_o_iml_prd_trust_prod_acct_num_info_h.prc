CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_PRD_TRUST_PROD_ACCT_NUM_INFO_H(I_P_DATE IN INTEGER, --跑批日期
                                                                     O_ERRCODE OUT VARCHAR2 --错误代码
                                                                     )
 /*******************************************************************
  **存储过程详细说明： 资管信托产品账号信息历史
  **存储过程名称：    ETL_O_IML_PRD_TRUST_PROD_ACCT_NUM_INFO_H
  **存储过程创建日期：20221130
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  *  20250610    YJY        优化脚本
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_PRD_TRUST_PROD_ACCT_NUM_INFO_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_PRD_TRUST_PROD_ACCT_NUM_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_PRD_TRUST_PROD_ACCT_NUM_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-资管信托产品账号信息历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_PRD_TRUST_PROD_ACCT_NUM_INFO_H NOLOGGING
    (TA_CD                           --TA代码
    ,LP_ID                           --法人编号
    ,PROD_ID                         --产品编号
    ,CAP_VERI_ACCT_OPEN_BANK_CD      --验资户开户行代码
    ,RGST_RGST_ACCT_OPEN_BANK_CD     --注册登记账户开户行代码
    ,MAKE_ACCT_BANK_ACCT_NUM         --上账银行账号
    ,KEEP_ACCT_BANK_ACCT_NUM         --下账银行账号
    ,COLL_CAP_VRFCTION_ACCT          --募集验资账户
    ,COLL_CAP_VRFCTION_ACCT_NAME     --募集验资账户名称
    ,TRUST_CORP_PROD_ID              --信托公司产品编号
    ,STL_TYPE_CD                     --结算类型代码
    ,TRUST_BANK_NAME                 --托管银行名称
    ,TRUST_ORG_NAME                  --托管机构名称
    ,PROD_NAME                       --产品名称
    ,MAKE_ACCT_BANK_ACCT_NUM_NAME    --上账银行账号名称
    ,KEEP_ACCT_BANK_ACCT_NUM_NAME    --下账银行账号名称
    ,RESV_FIELD_1                    --备用字段1
    ,RESV_FIELD_2                    --备用字段2
    ,START_DT                        --开始日期
    ,END_DT                          --结束日期
    ,ID_MARK                         --删除标识
    ,SRC_TABLE_NAME                  --源表名称
    ,JOB_CD                          --任务代码
    --,ETL_TIMESTAMP                   --数据处理时间
    )
  SELECT /*+PARALLEL*/
         TA_CD                           --TA代码
        ,LP_ID                           --法人编号
        ,PROD_ID                         --产品编号
        ,CAP_VERI_ACCT_OPEN_BANK_CD      --验资户开户行代码
        ,RGST_RGST_ACCT_OPEN_BANK_CD     --注册登记账户开户行代码
        ,MAKE_ACCT_BANK_ACCT_NUM         --上账银行账号
        ,KEEP_ACCT_BANK_ACCT_NUM         --下账银行账号
        ,COLL_CAP_VRFCTION_ACCT          --募集验资账户
        ,COLL_CAP_VRFCTION_ACCT_NAME     --募集验资账户名称
        ,TRUST_CORP_PROD_ID              --信托公司产品编号
        ,STL_TYPE_CD                     --结算类型代码
        ,TRUST_BANK_NAME                 --托管银行名称
        ,TRUST_ORG_NAME                  --托管机构名称
        ,PROD_NAME                       --产品名称
        ,MAKE_ACCT_BANK_ACCT_NUM_NAME    --上账银行账号名称
        ,KEEP_ACCT_BANK_ACCT_NUM_NAME    --下账银行账号名称
        ,RESV_FIELD_1                    --备用字段1
        ,RESV_FIELD_2                    --备用字段2
        ,START_DT                        --开始日期
        ,END_DT                          --结束日期
        ,ID_MARK                         --删除标识
        ,SRC_TABLE_NAME                  --源表名称
        ,JOB_CD                          --任务代码
        --,ETL_TIMESTAMP                   --数据处理时间
    FROM IML.V_PRD_TRUST_PROD_ACCT_NUM_INFO_H --视图_资管信托产品账号信息历史
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

END ETL_O_IML_PRD_TRUST_PROD_ACCT_NUM_INFO_H;
/

