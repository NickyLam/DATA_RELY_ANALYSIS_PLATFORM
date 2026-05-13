CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_SEC_ACPT_PAY_INT(I_P_DATE IN INTEGER,
                                                           O_ERRCODE OUT VARCHAR2
                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_SEC_ACPT_PAY_INT
  *  功能描述：现券收付息
  *  创建日期：20220611
  *  开发人员：梅炜
  *  来源表：
  *  目标表：  O_IML_EVT_SEC_ACPT_PAY_INT
  *  配置表：  CODE_MAP
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜      首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_SEC_ACPT_PAY_INT'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_SEC_ACPT_PAY_INT'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_IML_EVT_SEC_ACPT_PAY_INT T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--普通表的重跑处理
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_SEC_ACPT_PAY_INT';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 分区表分区处理 --
  /*V_STEP := V_STEP + 1;
  V_STEP_DESC := '分区处理';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(I_P_DATE, 'O_IML_EVT_SEC_ACPT_PAY_INT', '1', O_ERRCODE);
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');*/

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-现券收付息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_SEC_ACPT_PAY_INT
    (EVT_ID  --事件编号
    ,LP_ID  --法人编号
    ,SRC_EVT_ID  --源事件编号
    ,QUOTE_TABLE_NAME  --引用表名称
    ,DEPT_ID  --部门编号
    ,QUOTE_TAB_2_ID  --引用表2ID
    ,RPP_INT_DT  --还本付息日期
    ,ACCT_ID  --账户编号
    ,ACCT_NAME  --账户名称
    ,ASSET_CATE_NAME  --资产类别名称
    ,BOND_CD  --债券代码
    ,PRIC_INT_TYPE_CD  --本息类型代码
    ,RPP_AMT  --还本金额
    ,PAY_INT_AMT  --付息金额
    ,INIT_TRAN_ID  --原始交易编号
    ,ACTL_PAY_DT  --实际支付日期
    ,ACTL_RP_CFM_TM  --实收付确认时间
    ,ETL_DT  --ETL处理日期
    ,SRC_TABLE_NAME  --源表名称
    ,JOB_CD  --任务编码
    )
  SELECT EVT_ID  --事件编号
        ,LP_ID  --法人编号
        ,SRC_EVT_ID  --源事件编号
        ,QUOTE_TABLE_NAME  --引用表名称
        ,DEPT_ID  --部门编号
        ,QUOTE_TAB_2_ID  --引用表2ID
        ,RPP_INT_DT  --还本付息日期
        ,ACCT_ID  --账户编号
        ,ACCT_NAME  --账户名称
        ,ASSET_CATE_NAME  --资产类别名称
        ,BOND_CD  --债券代码
        ,PRIC_INT_TYPE_CD  --本息类型代码
        ,RPP_AMT  --还本金额
        ,PAY_INT_AMT  --付息金额
        ,INIT_TRAN_ID  --原始交易编号
        ,ACTL_PAY_DT  --实际支付日期
        ,ACTL_RP_CFM_TM  --实收付确认时间
        ,TO_DATE(V_P_DATE,'YYYYMMDD') ETL_DT --ETL处理日期
        ,SRC_TABLE_NAME  --源表名称
        ,JOB_CD  --任务编码
    FROM IML.V_EVT_SEC_ACPT_PAY_INT
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

END ETL_O_IML_EVT_SEC_ACPT_PAY_INT;
/

