CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_FINC_TRAN_CFM(I_P_DATE IN INTEGER,
                                                        O_ERRCODE OUT VARCHAR2
                                                        )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_FINC_TRAN_CFM
  *  功能描述：理财交易确认事件
  *  创建日期：20231010
  *  开发人员：HULIJUAN
  *  来源表： IML.V_EVT_FINC_TRAN_CFM
  *  目标表： O_IML_EVT_FINC_TRAN_CFM
  *  配置表：
  *  修改情况：序号  修改日期    修改人       修改原因
  *             1    20231010    HULIJUAN     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_FINC_TRAN_CFM'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_FINC_TRAN_CFM'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_EVT_FINC_TRAN_CFM T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_FINC_TRAN_CFM';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-理财交易确认事件';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_FINC_TRAN_CFM
    (TA_CD                    -- TA代码
    ,EVT_ID                   -- 事件编号
    ,LP_ID                    -- 法人编号
    ,CFM_DT                   -- 确认日期
    ,TA_CFM_FLOW_NUM          -- TA确认流水号
    ,INIT_CFM_FLOW_NUM        -- 原确认流水号
    ,INTIOR_CD                -- 发起方代码
    ,TRAN_DT                  -- 交易日期
    ,TRAN_TM                  -- 交易时间
    ,CLEAR_DAY_TERM           -- 清算日期
    ,FLOW_NUM                 -- 流水号
    ,TRAN_CD                  -- 交易代码
    ,BUS_CD                   -- 业务代码
    ,TRAN_ORG_ID              -- 交易机构编号
    ,TRAN_OPEN_ACCT_ORG_ID    -- 交易账户开户机构编号
    ,TRAN_CHN_CD              -- 交易渠道代码
    ,TRAN_TELLER_ID           -- 交易柜员编号
    ,INT_PARTY_ACCT_ID        -- 内当事人户编号
    ,FINC_ACCT_ID             -- 理财账户编号
    ,BANK_CD                  -- 银行代码
    ,PARTY_ID                 -- 当事人编号
    ,BANK_ACCT_ID             -- 银行账户编号
    ,TA_TRAN_ACCT_ID          -- TA交易账户编号
    ,TRAN_MED_TYPE_CD         -- 交易介质类型代码
    ,TRAN_MED_ID              -- 交易介质编号
    ,EC_FLG                   -- 钞汇标志
    ,FINC_PROD_ID             -- 理财产品编号
    ,PROD_NV                  -- 产品净值
    ,TRAN_PRICE               -- 交易价格
    ,TRAN_AMT                 -- 交易金额
    ,CURR_CD                  -- 币种代码
    ,CFM_AMT                  -- 确认金额
    ,TRAN_LOT                 -- 交易份额
    ,CFM_LOT                  -- 确认份额
    ,HUGE_REDEM_PROC_FLG      -- 巨额赎回处理标志
    ,FORCE_REDEM_RS_CD        -- 强行赎回原因代码
    ,COTIN_FROZ_AMT           -- 继续冻结金额
    ,LOT_ACCU_ACCUM           -- 份额累积积数
    ,DTL_FLG                  -- 明细标志
    ,FROZ_RS_CD               -- 冻结原因代码
    ,TRAN_DIR_CD              -- 转换方向代码
    ,DEFLT_DIVD_WAY_CD        -- 默认分红方式代码
    ,RETURN_CD                -- 返回代码
    ,REMARK_INFO              -- 备注信息
    ,TRAN_STATUS_CD           -- 交易状态代码
    ,CUST_MGR_ID              -- 客户经理编号
    ,RELA_DT                  -- 关联日期
    ,RELA_FLOW_NUM            -- 关联流水号
    ,CONT_ID                  -- 合约编号
    ,HOST_DT                  -- 主机日期
    ,HOST_FLOW_NUM            -- 主机流水号
    ,TRAN_POST_LOT            -- 交易后份额
    ,RSRV_AMT3                -- 预留金额3
    ,RESV2                    -- 备用2
    ,RESV_REGION3             -- 保留域3
    ,CUST_TYPE_CD             -- 客户类型代码
    ,TARGET_BANK_ACCT_ID      -- 目标银行账户编号
    ,TOT_COST                 -- 总费用
    ,ETL_DT                   -- 数据日期
    ,SRC_TABLE_NAME           -- 源表名称
    ,JOB_CD                   -- 任务代码
    )
  SELECT TA_CD                    -- TA代码
        ,EVT_ID                   -- 事件编号
        ,LP_ID                    -- 法人编号
        ,CFM_DT                   -- 确认日期
        ,TA_CFM_FLOW_NUM          -- TA确认流水号
        ,INIT_CFM_FLOW_NUM        -- 原确认流水号
        ,INTIOR_CD                -- 发起方代码
        ,TRAN_DT                  -- 交易日期
        ,TRAN_TM                  -- 交易时间
        ,CLEAR_DAY_TERM           -- 清算日期
        ,FLOW_NUM                 -- 流水号
        ,TRAN_CD                  -- 交易代码
        ,BUS_CD                   -- 业务代码
        ,TRAN_ORG_ID              -- 交易机构编号
        ,TRAN_OPEN_ACCT_ORG_ID    -- 交易账户开户机构编号
        ,TRAN_CHN_CD              -- 交易渠道代码
        ,TRAN_TELLER_ID           -- 交易柜员编号
        ,INT_PARTY_ACCT_ID        -- 内当事人户编号
        ,FINC_ACCT_ID             -- 理财账户编号
        ,BANK_CD                  -- 银行代码
        ,PARTY_ID                 -- 当事人编号
        ,BANK_ACCT_ID             -- 银行账户编号
        ,TA_TRAN_ACCT_ID          -- TA交易账户编号
        ,TRAN_MED_TYPE_CD         -- 交易介质类型代码
        ,TRAN_MED_ID              -- 交易介质编号
        ,EC_FLG                   -- 钞汇标志
        ,FINC_PROD_ID             -- 理财产品编号
        ,PROD_NV                  -- 产品净值
        ,TRAN_PRICE               -- 交易价格
        ,TRAN_AMT                 -- 交易金额
        ,CURR_CD                  -- 币种代码
        ,CFM_AMT                  -- 确认金额
        ,TRAN_LOT                 -- 交易份额
        ,CFM_LOT                  -- 确认份额
        ,HUGE_REDEM_PROC_FLG      -- 巨额赎回处理标志
        ,FORCE_REDEM_RS_CD        -- 强行赎回原因代码
        ,COTIN_FROZ_AMT           -- 继续冻结金额
        ,LOT_ACCU_ACCUM           -- 份额累积积数
        ,DTL_FLG                  -- 明细标志
        ,FROZ_RS_CD               -- 冻结原因代码
        ,TRAN_DIR_CD              -- 转换方向代码
        ,DEFLT_DIVD_WAY_CD        -- 默认分红方式代码
        ,RETURN_CD                -- 返回代码
        ,REMARK_INFO              -- 备注信息
        ,TRAN_STATUS_CD           -- 交易状态代码
        ,CUST_MGR_ID              -- 客户经理编号
        ,RELA_DT                  -- 关联日期
        ,RELA_FLOW_NUM            -- 关联流水号
        ,CONT_ID                  -- 合约编号
        ,HOST_DT                  -- 主机日期
        ,HOST_FLOW_NUM            -- 主机流水号
        ,TRAN_POST_LOT            -- 交易后份额
        ,RSRV_AMT3                -- 预留金额3
        ,RESV2                    -- 备用2
        ,RESV_REGION3             -- 保留域3
        ,CUST_TYPE_CD             -- 客户类型代码
        ,TARGET_BANK_ACCT_ID      -- 目标银行账户编号
        ,TOT_COST                 -- 总费用
        ,ETL_DT                   -- 数据日期
        ,SRC_TABLE_NAME           -- 源表名称
        ,JOB_CD                   -- 任务代码
    FROM IML.V_EVT_FINC_TRAN_CFM;  --视图-理财交易确认事件

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
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

END ETL_O_IML_EVT_FINC_TRAN_CFM;
/

