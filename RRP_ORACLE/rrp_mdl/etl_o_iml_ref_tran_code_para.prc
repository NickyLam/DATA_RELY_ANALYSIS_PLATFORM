CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_REF_TRAN_CODE_PARA(I_P_DATE IN INTEGER,
                                                         O_ERRCODE OUT VARCHAR2
                                                         )
  /**************************************************************************
  *  程序名称：ETL_O_IML_REF_TRAN_CODE_PARA
  *  功能描述：交易码参数表
  *  创建日期：20230302
  *  开发人员：梅炜
  *  来源表： IML.V_REF_TRAN_CODE_PARA
  *  目标表： O_IML_REF_TRAN_CODE_PARA
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  *             2    20250718  YJY      优化脚本
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_REF_TRAN_CODE_PARA'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_REF_TRAN_CODE_PARA'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;  
  --DELETE FROM RRP_MDL.O_IML_REF_TRAN_CODE_PARA T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_REF_TRAN_CODE_PARA';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-交易码参数表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_REF_TRAN_CODE_PARA
    (TRAN_CODE                  --交易码
    ,BUS_CLS_CD                 --业务分类代码
    ,A_CALC_BAL_STOP_PAY_FLG    --重新计算余额止付标志
    ,REVS_TRAN_CODE             --冲正交易码
    ,TRAN_CODE_DESCB            --交易码描述
    ,CNTPTY_TRAN_CODE           --对方交易码
    ,A_CALC_LMT_AMT_FLG         --重新计算限制金额标志
    ,REVS_FLG                   --冲正标志
    ,CHN_ID                     --渠道编号
    ,AVAL_BAL_CALC_TYPE_CD      --可用余额计算类型代码
    ,MULTI_REVS_WAY_FLG         --多种冲正方式标志
    ,CASH_TRAN_FLG              --现金交易标志
    ,COR_TRAN_FLG               --更正交易标志
    ,TRAN_CLS_CD                --交易分类代码
    ,DEBIT_CRDT_FLG             --借贷标志
    ,LP_ID                      --法人编号
    ,START_DT                   --开始时间
    ,END_DT                     --结束时间
    ,ID_MARK                    --增删标志
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务编码
    ,ETL_TIMESTAMP              --ETL处理时间戳
    )
  SELECT 
     TRAN_CODE                  --交易码
    ,BUS_CLS_CD                 --业务分类代码
    ,A_CALC_BAL_STOP_PAY_FLG    --重新计算余额止付标志
    ,REVS_TRAN_CODE             --冲正交易码
    ,TRAN_CODE_DESCB            --交易码描述
    ,CNTPTY_TRAN_CODE           --对方交易码
    ,A_CALC_LMT_AMT_FLG         --重新计算限制金额标志
    ,REVS_FLG                   --冲正标志
    ,CHN_ID                     --渠道编号
    ,AVAL_BAL_CALC_TYPE_CD      --可用余额计算类型代码
    ,MULTI_REVS_WAY_FLG         --多种冲正方式标志
    ,CASH_TRAN_FLG              --现金交易标志
    ,COR_TRAN_FLG               --更正交易标志
    ,TRAN_CLS_CD                --交易分类代码
    ,DEBIT_CRDT_FLG             --借贷标志
    ,LP_ID                      --法人编号
    ,START_DT                   --开始时间
    ,END_DT                     --结束时间
    ,ID_MARK                    --增删标志
    ,SRC_TABLE_NAME             --源表名称
    ,JOB_CD                     --任务编码
    ,ETL_TIMESTAMP              --ETL处理时间戳
    FROM IML.V_REF_TRAN_CODE_PARA  --视图-交易码参数表
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

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

END ETL_O_IML_REF_TRAN_CODE_PARA;
/

