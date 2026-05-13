CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NFSS_TBPRDBANKACC(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明： 产品账号表
  **存储过程名称：    ETL_O_IOL_NFSS_TBPRDBANKACC
  **存储过程创建日期：2022112807
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  *  20250610    YJY        优化脚本
  *******************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := '0'; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NFSS_TBPRDBANKACC'; -- 程序名称
  V_SYSTEM    VARCHAR2(30):= '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写 -- 来源系统
  BEGIN
  
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_IOL_CTMS_VI_TBS_ACCOUNT_CPTYS_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_NFSS_TBPRDBANKACC';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-产品账号表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NFSS_TBPRDBANKACC NOLOGGING
    (TA_CODE              --TA代码
    ,PRD_CODE             --产品代码
    ,BANK_NO              --银行编号
    ,OPEN_BANK_VER        --验资户开户行
    ,OPEN_BANK_UP         --注册登记账户开户行
    ,BANK_ACC_UP          --上帐银行帐号
    ,BANK_ACC_DOWN        --下帐银行帐号
    ,BANK_ACC_VER         --募集验资账户
    ,ASSO_CODE            --基金公司产品代码
    ,SQUARE_WAY           --结算方式
    ,BANK_NAME            --托管银行名称
    ,BRANCH_NAME          --托管机构名称
    ,PRD_NAME             --外部产品名称
    ,BANK_ACC_UP_NAME     --上帐银行帐号名称
    ,BANK_ACC_DOWN_NAME   --下账银行帐号名称
    ,BANK_ACC_VER_NAME    --募集验资户账户名称
    ,RESERVE1             --备用1
    ,RESERVE2             --备用字段2
    ,START_DT             --开始日期
    ,END_DT               --结束日期
    ,ID_MARK              --删除标识
    )
  SELECT /*+PARALLEL*/
     TA_CODE              --TA代码
    ,PRD_CODE             --产品代码
    ,BANK_NO              --银行编号
    ,OPEN_BANK_VER        --验资户开户行
    ,OPEN_BANK_UP         --注册登记账户开户行
    ,BANK_ACC_UP          --上帐银行帐号
    ,BANK_ACC_DOWN        --下帐银行帐号
    ,BANK_ACC_VER         --募集验资账户
    ,ASSO_CODE            --基金公司产品代码
    ,SQUARE_WAY           --结算方式
    ,BANK_NAME            --托管银行名称
    ,BRANCH_NAME          --托管机构名称
    ,PRD_NAME             --外部产品名称
    ,BANK_ACC_UP_NAME     --上帐银行帐号名称
    ,BANK_ACC_DOWN_NAME   --下账银行帐号名称
    ,BANK_ACC_VER_NAME    --募集验资户账户名称
    ,RESERVE1             --备用1
    ,RESERVE2             --备用字段2
    ,START_DT             --开始日期
    ,END_DT               --结束日期
    ,ID_MARK              --删除标识
    FROM IOL.V_NFSS_TBPRDBANKACC  --产品账号表_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
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

END ETL_O_IOL_NFSS_TBPRDBANKACC;
/

