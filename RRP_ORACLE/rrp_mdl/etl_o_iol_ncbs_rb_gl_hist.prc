CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_RB_GL_HIST(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NCBS_RB_GL_HIST
  *  功能描述：核算流水表
  *  创建日期：20251210
  *  开发人员：YJY
  *  来源表： IOL.V_NCBS_RB_GL_HIST
  *  目标表： O_IOL_NCBS_RB_GL_HIST
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251210  YJY     首次创建
  ***************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;                --处理步骤
  V_P_DATE    VARCHAR2(8);                 --跑批数据日期
  V_STARTTIME DATE;                        --处理开始时间
  V_ENDTIME   DATE;                        --处理结束时间
  V_SQLCOUNT  INTEGER := 0;                --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);               --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);               --任务名称
  V_PART_NAME VARCHAR2(200);               --分区名
  V_TAB_NAME  VARCHAR2(50) := 'O_IOL_NCBS_RB_GL_HIST'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NCBS_RB_GL_HIST'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送';  --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期
  V_PART_NAME := 'PARTITION_'||V_P_DATE;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  ETL_PARTITION_ADD(V_P_DATE,V_TAB_NAME, '3', O_ERRCODE);
  --删除当前分区数据
  EXECUTE IMMEDIATE ('ALTER TABLE '|| V_TAB_NAME ||' TRUNCATE PARTITION '||V_PART_NAME);--分区表的重跑处理
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := 2;
  V_STEP_DESC := '数据落地-核算流水表';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_NCBS_RB_GL_HIST NOLOGGING 
  (     ACCT_SEQ_NO              --账户子账号
        ,AMOUNT                  --金额
        ,AMT_TYPE                --金额类型
        ,BASE_ACCT_NO            --交易账号/卡号
        ,BUSINESS_UNIT           --账套
        ,CCY                     --币种
        ,CLIENT_NO               --客户编号
        ,CLIENT_TYPE             --客户类型
        ,GL_CODE                 --科目代码
        ,INTERNAL_KEY            --账户内部键值
        ,PROD_TYPE               --产品编号
        ,PROFIT_CENTER           --利润中心
        ,REFERENCE               --交易参考号
        ,TRAN_TYPE               --交易类型
        ,USER_ID                 --交易柜员编号
        ,BANK_SEQ_NO             --银行交易序号
        ,CHANNEL_SEQ_NO          --全局流水号
        ,COMPANY                 --法人
        ,CR_DR_IND               --借贷标志
        ,EVENT_TYPE              --事件类型
        ,GL_POSTED_FLAG          --过账标记
        ,GL_SEQ_NO               --总账序号
        ,IN_STATUS               --入账方式
        ,INT_IND_FLAG            --是否计息
        ,MARKETING_PROD_DESC     --营销产品名称
        ,NARRATIVE               --摘要
        ,RESERVE1                --预留字段1
        ,REVERSAL_FLAG           --交易是否已冲正
        ,SEND_SYSTEM             --转发系统
        ,SOURCE_MODULE           --源模块
        ,SOURCE_TYPE             --渠道编号
        ,SUB_SEQ_NO              --系统流水号
        ,SYSTEM_ID               --系统id
        ,UN_REAL                 --虚拟标志
        ,TRAN_CATEGORY           --交易种类
        ,ACCOUNTING_STATUS       --核算状态
        ,CHANNEL_DATE            --渠道日期
        ,EFFECT_DATE             --产品生效日期
        ,TRAN_DATE               --交易日期
        ,TRAN_TIMESTAMP          --交易时间戳
        ,ACCT_BRANCH             --开户机构编号
        ,ACCT_CCY                --账户币种
        ,CONTRA_EQUIV_AMT        --对方等值金额
        ,CROSS_RATE              --交叉汇率
        ,INT_AMT                 --利息金额
        ,LOAN_PROD_TYPE          --贷款产品类型
        ,MARKETING_PROD          --营销产品
        ,ODI_AMT                 --复利金额
        ,ODP_AMT                 --罚息金额
        ,PRI_AMT                 --本金金额
        ,SPREAD_PERCENT          --浮动百分比
        ,TAX_AMT                 --税金
        ,TRAN_BRANCH             --核心交易机构编号
        ,TRAN_PROFIT_CENTER      --交易利润中心
        ,FLAT_RATE               --平盘汇率
        ,AMOUNT_NATURE           --资金性质
        ,BUS_SEQ_NO              --业务流水号
        ,OLD_BRANCH              --变更前机构
        ,BALANCE_CHANGE_TYPE     --余额变化类型
        ,DEAL_FLAG               --处理标识
        ,RULE_NO                 --规则编号
        ,ETL_DT                  --ETL处理日期
        ,ETL_TIMESTAMP           --ETL处理时间戳
    )
  SELECT 
         ACCT_SEQ_NO              --账户子账号
        ,AMOUNT                  --金额
        ,AMT_TYPE                --金额类型
        ,BASE_ACCT_NO            --交易账号/卡号
        ,BUSINESS_UNIT           --账套
        ,CCY                     --币种
        ,CLIENT_NO               --客户编号
        ,CLIENT_TYPE             --客户类型
        ,GL_CODE                 --科目代码
        ,INTERNAL_KEY            --账户内部键值
        ,PROD_TYPE               --产品编号
        ,PROFIT_CENTER           --利润中心
        ,REFERENCE               --交易参考号
        ,TRAN_TYPE               --交易类型
        ,USER_ID                 --交易柜员编号
        ,BANK_SEQ_NO             --银行交易序号
        ,CHANNEL_SEQ_NO          --全局流水号
        ,COMPANY                 --法人
        ,CR_DR_IND               --借贷标志
        ,EVENT_TYPE              --事件类型
        ,GL_POSTED_FLAG          --过账标记
        ,GL_SEQ_NO               --总账序号
        ,IN_STATUS               --入账方式
        ,INT_IND_FLAG            --是否计息
        ,MARKETING_PROD_DESC     --营销产品名称
        ,NARRATIVE               --摘要
        ,RESERVE1                --预留字段1
        ,REVERSAL_FLAG           --交易是否已冲正
        ,SEND_SYSTEM             --转发系统
        ,SOURCE_MODULE           --源模块
        ,SOURCE_TYPE             --渠道编号
        ,SUB_SEQ_NO              --系统流水号
        ,SYSTEM_ID               --系统id
        ,UN_REAL                 --虚拟标志
        ,TRAN_CATEGORY           --交易种类
        ,ACCOUNTING_STATUS       --核算状态
        ,CHANNEL_DATE            --渠道日期
        ,EFFECT_DATE             --产品生效日期
        ,TRAN_DATE               --交易日期
        ,TRAN_TIMESTAMP          --交易时间戳
        ,ACCT_BRANCH             --开户机构编号
        ,ACCT_CCY                --账户币种
        ,CONTRA_EQUIV_AMT        --对方等值金额
        ,CROSS_RATE              --交叉汇率
        ,INT_AMT                 --利息金额
        ,LOAN_PROD_TYPE          --贷款产品类型
        ,MARKETING_PROD          --营销产品
        ,ODI_AMT                 --复利金额
        ,ODP_AMT                 --罚息金额
        ,PRI_AMT                 --本金金额
        ,SPREAD_PERCENT          --浮动百分比
        ,TAX_AMT                 --税金
        ,TRAN_BRANCH             --核心交易机构编号
        ,TRAN_PROFIT_CENTER      --交易利润中心
        ,FLAT_RATE               --平盘汇率
        ,AMOUNT_NATURE           --资金性质
        ,BUS_SEQ_NO              --业务流水号
        ,OLD_BRANCH              --变更前机构
        ,BALANCE_CHANGE_TYPE     --余额变化类型
        ,DEAL_FLAG               --处理标识
        ,RULE_NO                 --规则编号
        ,ETL_DT                  --ETL处理日期
        ,ETL_TIMESTAMP           --ETL处理时间戳
    FROM IOL.V_NCBS_RB_GL_HIST --视图-核算流水表
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 3;
  V_STEP_DESC := '-- 表分析 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, V_PART_NAME, O_ERRCODE);
  V_ENDTIME  := SYSDATE;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  V_STEP := 4;
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_NCBS_RB_GL_HIST;
/

