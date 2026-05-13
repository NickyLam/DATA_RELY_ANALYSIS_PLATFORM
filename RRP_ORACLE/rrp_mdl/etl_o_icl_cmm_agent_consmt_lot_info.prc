CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_ICL_CMM_AGENT_CONSMT_LOT_INFO(I_P_DATE IN INTEGER,
                                                                O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_ICL_CMM_AGENT_CONSMT_LOT_INFO
  *  功能描述：代理代销份额信息
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_ICL_CMM_AGENT_CONSMT_LOT_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20221222  梅炜     首次创建
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
  V_PART_NAME VARCHAR2(200);              --分区名
  V_TAB_NAME  VARCHAR2(100) := 'O_ICL_CMM_AGENT_CONSMT_LOT_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_ICL_CMM_AGENT_CONSMT_LOT_INFO'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM O_ICL_CMM_AGENT_CONSMT_LOT_INFO T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE O_ICL_CMM_AGENT_CONSMT_LOT_INFO';
  ETL_PARTITION_ADD(V_P_DATE, V_TAB_NAME, '3', O_ERRCODE);
  EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-代理代销份额信息';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_ICL_CMM_AGENT_CONSMT_LOT_INFO
    (ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,TA_CD                      --TA代码
    ,PROD_ID                    --产品编号
    ,STD_PROD_ID                --标准产品编号
    ,TRAN_ACCT_ID               --交易账户编号
    ,CONSMT_BUS_TYPE_CD         --代销业务类型代码
    ,CAP_STL_ACCT_NUM           --资金结算账号
    ,CUST_ID                    --客户编号
    ,CONT_ID                    --合约编号
    ,BELONG_ORG_ID              --归属机构编号
    ,BANK_ID                    --银行编号
    ,SELLER_ID                  --销售商编号
    ,EC_FLG_CD                  --钞汇标志代码
    ,DIVD_WAY_CD                --分红方式代码
    ,CUST_TYPE_CD               --客户类型代码
    ,LOT_TYPE_CD                --份额类型代码
    ,FIR_SUBSCR_DT              --首次认购日期
    ,FINAL_ACTIV_ACCT_DT        --最后动户日期
    ,ACTL_VALUE_DT              --实际起息日期
    ,ACTL_EXP_DT                --实际到期日期
    ,DIVD_RATIO                 --分红比例
    ,YLD_RAT                    --收益率
    ,ACM_PRFT                   --累计收益
    ,UNPAID_PRFT                --未付收益
    ,FROZ_UNPAID_PRFT           --冻结未付收益
    ,CURR_ISSUE_PRFT            --本期收益
    ,TD_PRFT                    --本日收益
    ,TRAN_FROZ_LOT              --交易冻结份额
    ,LONTERM_FROZ_LOT           --长期冻结份额
    ,LOC_FROZ_LOT               --本地冻结份额
    ,LD_TOT_LOT                 --上日总份额
    ,UNCFM_PROD_AMT             --未确认产品金额
    ,REDEM_AMT                  --赎回金额
    ,BUY_COST                   --买入成本
    ,TOT_LOT                    --总份额
    ,NV                         --净值
    ,CURR_BAL                   --当前余额
    ,EAR_D_BAL                  --日初余额
    ,EAR_M_BAL                  --月初余额
    ,EAR_S_BAL                  --季初余额
    ,EAR_Y_BAL                  --年初余额
    ,Y_ACM_BAL                  --年累计余额
    ,S_ACM_BAL                  --季累计余额
    ,M_ACM_BAL                  --月累计余额
    ,Y_AVG_BAL                  --年日均余额
    ,Q_AVG_BAL                  --季日均余额
    ,M_AVG_BAL                  --月日均余额
    ,JOB_CD                     --任务代码
    ,ETL_TIMESTAMP              --数据处理时间
    )
  SELECT ETL_DT                     --数据日期
    ,LP_ID                      --法人编号
    ,TA_CD                      --TA代码
    ,PROD_ID                    --产品编号
    ,STD_PROD_ID                --标准产品编号
    ,TRAN_ACCT_ID               --交易账户编号
    ,CONSMT_BUS_TYPE_CD         --代销业务类型代码
    ,CAP_STL_ACCT_NUM           --资金结算账号
    ,CUST_ID                    --客户编号
    ,CONT_ID                    --合约编号
    ,BELONG_ORG_ID              --归属机构编号
    ,BANK_ID                    --银行编号
    ,SELLER_ID                  --销售商编号
    ,EC_FLG_CD                  --钞汇标志代码
    ,DIVD_WAY_CD                --分红方式代码
    ,CUST_TYPE_CD               --客户类型代码
    ,LOT_TYPE_CD                --份额类型代码
    ,FIR_SUBSCR_DT              --首次认购日期
    ,FINAL_ACTIV_ACCT_DT        --最后动户日期
    ,ACTL_VALUE_DT              --实际起息日期
    ,ACTL_EXP_DT                --实际到期日期
    ,DIVD_RATIO                 --分红比例
    ,YLD_RAT                    --收益率
    ,ACM_PRFT                   --累计收益
    ,UNPAID_PRFT                --未付收益
    ,FROZ_UNPAID_PRFT           --冻结未付收益
    ,CURR_ISSUE_PRFT            --本期收益
    ,TD_PRFT                    --本日收益
    ,TRAN_FROZ_LOT              --交易冻结份额
    ,LONTERM_FROZ_LOT           --长期冻结份额
    ,LOC_FROZ_LOT               --本地冻结份额
    ,LD_TOT_LOT                 --上日总份额
    ,UNCFM_PROD_AMT             --未确认产品金额
    ,REDEM_AMT                  --赎回金额
    ,BUY_COST                   --买入成本
    ,TOT_LOT                    --总份额
    ,NV                         --净值
    ,CURR_BAL                   --当前余额
    ,EAR_D_BAL                  --日初余额
    ,EAR_M_BAL                  --月初余额
    ,EAR_S_BAL                  --季初余额
    ,EAR_Y_BAL                  --年初余额
    ,Y_ACM_BAL                  --年累计余额
    ,S_ACM_BAL                  --季累计余额
    ,M_ACM_BAL                  --月累计余额
    ,Y_AVG_BAL                  --年日均余额
    ,Q_AVG_BAL                  --季日均余额
    ,M_AVG_BAL                  --月日均余额
    ,JOB_CD                     --任务代码
    ,ETL_TIMESTAMP              --数据处理时间
   FROM ICL.V_CMM_AGENT_CONSMT_LOT_INFO --视图-代理代销份额信息
  WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  --如需要分析表，请用如下代码 --
  --DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME,V_PART_NAME, O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_ICL_CMM_AGENT_CONSMT_LOT_INFO;
/

