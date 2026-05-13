CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_NCBS_RB_BATCH_RESERVE_INFO(I_P_DATE IN INTEGER,
                                O_ERRCODE OUT VARCHAR2
                                 )
    /**************************************************************************
    *  程序名称：ETL_INIT_O_IOL_NCBS_RB_BATCH_RESERVE_INFO
    *  功能描述：备款基础信息表
    *  创建日期：20230302
    *  开发人员：MW
    *  来源表： IOL.V_NCBS_RB_BATCH_RESERVE_INFO
    *  目标表： O_IOL_NCBS_RB_BATCH_RESERVE_INFO
    *  配置表：
    *  修改情况：序号  修改日期  修改人   修改原因
    *             1    20220619  MW      首次创建
    ***************************************************************************/
    AS
    -- 定义变量 --
    V_STEP      INTEGER := 0; -- 处理步骤
    V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_NCBS_RB_BATCH_RESERVE_INFO'; -- 程序名称
    V_P_DATE  VARCHAR2(8); -- 跑批数据日期
    V_STARTTIME DATE; -- 处理开始时间
    V_ENDTIME DATE;   -- 处理结束时间
    V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
    V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
    V_SYSTEM    VARCHAR2(100); -- 来源系统
    V_STEP_DESC VARCHAR2(200); --任务名称
    V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

    -- 处理参数及月末等判断逻辑 --
    V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
    V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

    --IF V_P_DATE <> V_LAST_DAT THEN
    --  RETURN;
    --END IF;

    -- 支持重跑 --
    V_STEP := 1;
    V_STEP_DESC := '-- 程序跑批开始 --';
    V_STARTTIME := SYSDATE;
    -- -- EXECUTE IMMEDIATE ' TRUNCATE TABLE  O_IOL_NCBS_RB_BATCH_RESERVE_INFO ;
     -- EXECUTE IMMEDIATE ' TRUNCATE TABLE O_IOL_NCBS_RB_BATCH_RESERVE_INFO';
    V_SQLCOUNT := SQL%ROWCOUNT;
    V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
    O_ERRCODE := '0';
    V_ENDTIME := SYSDATE;
    COMMIT;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);


    -- 程序业务逻辑处理主体部分 --
    V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
    V_STEP_DESC := '数据落地-备款基础信息表';
    V_STARTTIME := SYSDATE;
    INSERT INTO RRP_MDL.O_IOL_NCBS_RB_BATCH_RESERVE_INFO
    (
            REFERENCE  --交易参考号
            ,CLOSE_ACCT_FLAG  --是否可销户
            ,ADVANCED_AMT  --保函垫款金额
            ,NEW_SETTLE_BASE_ACCT_NO  --新利息入账账号
            ,REGISTER_DATE  --登记日期
            ,EXT_TRADE_NO  --原业务编号
            ,ADVANCED_NEXT_CYCLE_DATE  --垫款下一结息日
            ,ADVANCED_BRANCH  --垫款发放机构
            ,ADVANCED_INT_DAY  --垫款结息日
            ,ADVANCED_CYCLE_FREQ  --垫款结息频率
            ,EXT_REF_NO  --来单编号
            ,ADVANCED_REAL_RATE  --垫款执行利率
            ,RESERVE_AMT  --核心备款金额
            ,TRADE_TYPE  --业务类型
            ,RESERVE_DATE  --备款日期
            ,ADVANCED_SCHED_MODE  --垫款还款方式
            ,FROM_CHANNEL  --记录来源
            ,RESERVE_STATUS  --备款状态
            ,ADVANCED_CMISLOAN_NO  --垫款借据号
            ,ERROR_DESC  --错误描述
            ,CORP_SIZE  --企业规模
            ,ECON_DEPARTMENT_TYPE  --国民经济部门类型
            ,DEAL_DATE  --处理日期
            ,START_DT  --开始时间
            ,END_DT  --结束时间
            ,ID_MARK  --增删标志
            ,ETL_TIMESTAMP  --ETL处理时间戳
      )
      SELECT
            REFERENCE  --交易参考号
            ,CLOSE_ACCT_FLAG  --是否可销户
            ,ADVANCED_AMT  --保函垫款金额
            ,NEW_SETTLE_BASE_ACCT_NO  --新利息入账账号
            ,REGISTER_DATE  --登记日期
            ,EXT_TRADE_NO  --原业务编号
            ,ADVANCED_NEXT_CYCLE_DATE  --垫款下一结息日
            ,ADVANCED_BRANCH  --垫款发放机构
            ,ADVANCED_INT_DAY  --垫款结息日
            ,ADVANCED_CYCLE_FREQ  --垫款结息频率
            ,EXT_REF_NO  --来单编号
            ,ADVANCED_REAL_RATE  --垫款执行利率
            ,RESERVE_AMT  --核心备款金额
            ,TRADE_TYPE  --业务类型
            ,RESERVE_DATE  --备款日期
            ,ADVANCED_SCHED_MODE  --垫款还款方式
            ,FROM_CHANNEL  --记录来源
            ,RESERVE_STATUS  --备款状态
            ,ADVANCED_CMISLOAN_NO  --垫款借据号
            ,ERROR_DESC  --错误描述
            ,CORP_SIZE  --企业规模
            ,ECON_DEPARTMENT_TYPE  --国民经济部门类型
            ,DEAL_DATE  --处理日期
            ,START_DT  --开始时间
            ,END_DT  --结束时间
            ,ID_MARK  --增删标志
            ,ETL_TIMESTAMP  --ETL处理时间戳
      FROM IOL.V_NCBS_RB_BATCH_RESERVE_INFO  --视图-备款基础信息表
  ;


     V_SQLCOUNT := SQL%ROWCOUNT;
     V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
     O_ERRCODE := '0';
     V_ENDTIME := SYSDATE;
     COMMIT;


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
    V_STEP := V_STEP + 1;
       V_STEP_DESC := '-- 程序跑批异常 --';
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

    END ETL_INIT_O_IOL_NCBS_RB_BATCH_RESERVE_INFO;
/

