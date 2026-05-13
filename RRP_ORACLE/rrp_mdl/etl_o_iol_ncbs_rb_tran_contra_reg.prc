CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_RB_TRAN_CONTRA_REG(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NCBS_RB_TRAN_CONTRA_REG
  *  功能描述：真实交易对手登记簿
  *  创建日期：20230115
  *  开发人员：MW
  *  来源表： IOL.V_NCBS_RB_TRAN_CONTRA_REG
  *  目标表： O_IOL_NCBS_RB_TRAN_CONTRA_REG
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20230115  MW       首次创建
  *             2    20250106  YJY      优化脚本
  *             3    20260415  YJY      新增真实对手行名
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                  --处理步骤
  V_P_DATE    VARCHAR2(8);                   --跑批数据日期
  V_STARTTIME DATE;                          --处理开始时间
  V_ENDTIME   DATE;                          --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                  --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);                 --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);                 --任务名称
  V_SYSTEM    VARCHAR2(30):= '监管报送';     --来源系统 --默认写监管报送系统，有真实来源的按实际写
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NCBS_RB_TRAN_CONTRA_REG'; --程序名称
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_NCBS_RB_TRAN_CONTRA_REG T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NCBS_RB_TRAN_CONTRA_REG';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-真实交易对手登记簿';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_NCBS_RB_TRAN_CONTRA_REG
    (SEQ_NO                       --序号
    ,REFERENCE                    --交易参考号
    ,CHANNEL_SEQ_NO               --全局流水号
    ,SUB_SEQ_NO                   --系统子流水号
    ,OTH_REAL_BASE_ACCT_NO        --真实交易对手账号
    ,OTH_REAL_TRAN_NAME           --真实交易对手名称
    ,CONTRA_BANK_CODE             --交易对手行号
    ,TRAN_AMT                     --交易金额
    ,OTH_REAL_ACCT_SEQ_NO         --真实交易对手账户序号
    ,REGISTER_SEQ_NO              --补录子序号
    ,TRAN_TIMESTAMP               --交易时间戳
    ,COMPANY                      --法人
    ,SOURCE_MODULE                --源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有
    ,START_DT                     --开始时间
    ,END_DT                       --结束时间
    ,ID_MARK                      --增删标志
    ,ETL_TIMESTAMP                --ETL处理时间戳
    ,CONTRA_BANK_NAME             --真实对手行名 ADD BY YJY 20260415 
    )
  SELECT SEQ_NO                       --序号
        ,REFERENCE                    --交易参考号
        ,CHANNEL_SEQ_NO               --全局流水号
        ,SUB_SEQ_NO                   --系统子流水号
        ,OTH_REAL_BASE_ACCT_NO        --真实交易对手账号
        ,OTH_REAL_TRAN_NAME           --真实交易对手名称
        ,CONTRA_BANK_CODE             --交易对手行号
        ,TRAN_AMT                     --交易金额
        ,OTH_REAL_ACCT_SEQ_NO         --真实交易对手账户序号
        ,REGISTER_SEQ_NO              --补录子序号
        ,TRAN_TIMESTAMP               --交易时间戳
        ,COMPANY                      --法人
        ,SOURCE_MODULE                --源模块|源模块,RB-存款,CL-贷款,GL-总账,ALL-所有
        ,START_DT                     --开始时间
        ,END_DT                       --结束时间
        ,ID_MARK                      --增删标志
        ,ETL_TIMESTAMP                --ETL处理时间戳
        ,CONTRA_BANK_NAME             --真实对手行名 ADD BY YJY 20260415 
    FROM IOL.V_NCBS_RB_TRAN_CONTRA_REG   --视图-真实交易对手登记簿
   WHERE ID_MARK <> 'D' ;

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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

END ETL_O_IOL_NCBS_RB_TRAN_CONTRA_REG;
/

