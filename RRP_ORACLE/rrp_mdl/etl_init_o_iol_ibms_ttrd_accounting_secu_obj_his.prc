CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS
  *  功能描述：中国债券信用评级表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS'; -- 程序名称
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

 --清理当天数据
  V_STEP_DESC  := '清理当天数据';
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS NOLOGGING
    ( OBJ_ID,                       --对象ID
      TSK_ID,                       --任务ID
      BEG_DATE,                     --开始日期
      END_DATE,                     --结束日期
      EXT_SECU_ACCT_ID,             --外部券账户
      SECU_ACCT_ID,                 --内部券账户
      TRADE_GRP_ID,                 --组合交易号
      I_CODE,                       --金融工具代码
      A_TYPE,                       --金融工具资产类型
      M_TYPE,                       --金融工具资产类型
      TRADE_ID,                     --交易号
      EXTRA_DIM,                    --额外维度
      REAL_VOLUME,                  --数量
      REAL_AMOUNT,                  --余额
      REAL_CP,                      --净价成本
      AI,                           --应计利息
      AI_COST,                      --利息成本
      CHG_FV,                       --公允价值变动
      DUE_AMOUNT,                   --应收未收余额
      DUE_CP,                       --应收未收净价成本
      DUE_AI,                       --应收未收应计利息
      AMRT_COUNT,                   --当天摊销业务次数
      AMRT_DATE,                    --摊销日期
      AMRT_IR,                      --利息调整
      PRFT_FV,                      --公允价值损益
      PRFT_TRD,                     --买卖损益
      PRFT_IR,                      --利息收入
      PRFT_IR_AI,                   --应计利息利息收入
      PRFT_IR_AMRT,                 --摊销利息收入
      PRFT_IR_AI_HLD,               --当前持仓应计利息利息收入
      PRFT_IR_AMRT_HLD,             --当前持仓摊销利息收入
      RECLASS_PRFT_FV,              --重分类公允价值损益
      IMPAIR,                       --减值准备
      PRFT_IMPAIR,                  --减值损失
      REAL_MARGIN,                  --期货保证金
      OPEN_TIME,                    --开仓时间
      UPDATE_TIME,                  --更新时间
      PRFT_FEE,                     --费用
      DUE_FEE,                      --应付费用
      FEE,                          --费用成本
      AMRT_COST_CP,                 --摊余净价成本
      AMRT_COST_AI,                 --摊余利息成本
      AMRT_IR_HP,                   --利息调整(高精度)
      AMRT_YTM,                     --实际利率
      INVEST_YTM,                   --投资收益率
      OPEN_YTM,                     --开仓收益率
      FUTURE_AI,                    --预收息
      REAL_CP_NOAMRT,               --不摊销净价成本
      CHG_FV_NOAMRT,                --不摊销公允价值变动
      PRFT_FV_NOAMRT,               --不摊销公允价值损益
      PRFT_TRD_NOAMRT,              --不摊销买卖损益
      AMRT_METHOD,                  --摊销算法
      REAL_VOLUME_TERMCUR,          --货币对反向实际数量
      REAL_AMOUNT_TERMCUR,          --货币对反向实际面值
      DUE_AMOUNT_TERMCUR,           --货币对反向结转面值
      REAL_CP_TERMCUR,              --货币对反向实际成本
      DUE_CP_TERMCUR,               --货币对反向结转成本
      PRFT_IR_AMRT_RC,              --重分类利息收入（摊销部分）
      PRFT_IR_AMRT_HLD_RC,          --重分类利息收入（当前持仓摊销部分）
      AMRT_COST_CP_RC,              --重分类摊余净价成本
      AMRT_YTM_RC,                  --重分类实际利率
      AMRT_IR_HP_RC,                --重分类利息调整（高精度）
      CALC_DATE,                    --计提摊销截止日期
      IPR_STATE,                    --减值状态：0-未减值，1-减值，2-核销
      IPR_PRFT_CP,                  --成本减值损失
      IPR_PRFT_AI,                  --利息减值损失
      IPR_CP,                       --成本减值准备
      IPR_HX_CP,                    --已核销成本
      IPR_HX_AI,                    --已核销应计利息
      IPR_HX_DUE_AI,                --已核销应收未收利息
      IPR_BW_AI,                    --表外应计利息
      IPR_BW_DUE_AI,                --表外应收未收利息
      AMRT_DATE_RC,                 --重分类摊销开始日期
      AMRT_COST_AI_RC,              --重分类摊销开始日期利息成本
      OPEN_DATE_RC,                 --重分类开仓日期
      PRFT_IR_AI_CALC_TAX,          --应计利息收入增量
      TAX_AI,                       --应计增值税
      TAX_DUE_AI,                   --应付增值税
      TAX_FEE,                      --费用收入税/支出税
      FV_CURRENCY,                  --估值币种
      SET_DATE,                     --结算日期
      PRFT_FV_CASH,                 --已实现公允价值变动损益
      TAX_AI_HLD,                   --当前持仓利息收入税/支出税
      OPEN_AI,                      --开仓利息成本
      OPEN_YTM_OPT,                 --开仓行权收益率
      PRFT_IR_AI_FUT,               --预收利息收入
      PRFT_IR_AI_CUR,               --计提利息收入
      PRFT_IR_AI_DUE,               --应收利息收入
      PRFT_IR_AI_CASH,              --实收利息收入
      TAX_FUT_AI,                   --计提利息收入预收税
      TAX_DUE_AMRT,                 --摊销利息收入应付增值税
      TAX_DUE_AMRT_RC,              --重分类后资本公积摊销收入应付增值税
      TAX_DUE_TRD,                  --买卖损益应付增值税
      TAX_DUE_FV,                   --公允价值损益应付增值税
      TAX_DUE_FV_RECLASS,           --重分类公允价值损益应付增值税
      TAX_DUE_FV_CASH,              --已实现公允价值损益应付增值税
      TAX_DUE_FEE,                  --费用损益应付增值税
      DUE_CHG_FV,                   --结转公允价值变动
      DUE_VOLUME,                   --结转数量
      AMRT_VERIFY_CODE,             --摊销验证码
      AMRT_VERIFY_DATE,             --摊销验证日期
      PRFT_RECLASS,                 --重分类损益
      CLOSE_SET_DATE,               --平仓交割日期
      TRADE_INST_ID,                --交易指令号
      CUSTOM_DIM1,                  --扩展维度1
      IPR_PERIOD,                   --减值阶段
      IPR_CP1,                      --阶段一减值准备
      IPR_CP2,                      --阶段二减值准备
      IPR_CP3,                      --阶段三减值准备
      IPR_PRFT_CP1,                 --阶段一减值损失
      IPR_PRFT_CP2,                 --阶段二减值损失
      IPR_PRFT_CP3,                 --阶段三减值损失
      AMRT_START_IR_HP,             --摊销开始日期初利息调整余额(高精度)
      TAX_AMRT,                     --摊销利息收入暂估税
      CALC_TAX_AMRT_CUR,            --计提摊销利息收入
      CALC_TAX_AMRT_DUE,            --应收摊销利息收入
      CALC_TAX_AMRT_CASH,           --实收摊销利息收入
      TAX_FV,                       --未实现损益暂估税
      TAX_IR,                       --利息收入暂估税
      TAX_DUE_IR,                   --利息收入应付增值税
      PRFT_ID,                      --损益对象ID
      DEVIATION,                    --偏离金额
      PRFT_IR_FUT_AI,               --预收息利息收入
      ETL_DT                        --ETL处理日期
     )
  SELECT /*+PARALLEL*/
          OBJ_ID,                       --对象ID
          TSK_ID,                       --任务ID
          BEG_DATE,                     --开始日期
          END_DATE,                     --结束日期
          EXT_SECU_ACCT_ID,             --外部券账户
          SECU_ACCT_ID,                 --内部券账户
          TRADE_GRP_ID,                 --组合交易号
          I_CODE,                       --金融工具代码
          A_TYPE,                       --金融工具资产类型
          M_TYPE,                       --金融工具资产类型
          TRADE_ID,                     --交易号
          EXTRA_DIM,                    --额外维度
          REAL_VOLUME,                  --数量
          REAL_AMOUNT,                  --余额
          REAL_CP,                      --净价成本
          AI,                           --应计利息
          AI_COST,                      --利息成本
          CHG_FV,                       --公允价值变动
          DUE_AMOUNT,                   --应收未收余额
          DUE_CP,                       --应收未收净价成本
          DUE_AI,                       --应收未收应计利息
          AMRT_COUNT,                   --当天摊销业务次数
          AMRT_DATE,                    --摊销日期
          AMRT_IR,                      --利息调整
          PRFT_FV,                      --公允价值损益
          PRFT_TRD,                     --买卖损益
          PRFT_IR,                      --利息收入
          PRFT_IR_AI,                   --应计利息利息收入
          PRFT_IR_AMRT,                 --摊销利息收入
          PRFT_IR_AI_HLD,               --当前持仓应计利息利息收入
          PRFT_IR_AMRT_HLD,             --当前持仓摊销利息收入
          RECLASS_PRFT_FV,              --重分类公允价值损益
          IMPAIR,                       --减值准备
          PRFT_IMPAIR,                  --减值损失
          REAL_MARGIN,                  --期货保证金
          OPEN_TIME,                    --开仓时间
          UPDATE_TIME,                  --更新时间
          PRFT_FEE,                     --费用
          DUE_FEE,                      --应付费用
          FEE,                          --费用成本
          AMRT_COST_CP,                 --摊余净价成本
          AMRT_COST_AI,                 --摊余利息成本
          AMRT_IR_HP,                   --利息调整(高精度)
          AMRT_YTM,                     --实际利率
          INVEST_YTM,                   --投资收益率
          OPEN_YTM,                     --开仓收益率
          FUTURE_AI,                    --预收息
          REAL_CP_NOAMRT,               --不摊销净价成本
          CHG_FV_NOAMRT,                --不摊销公允价值变动
          PRFT_FV_NOAMRT,               --不摊销公允价值损益
          PRFT_TRD_NOAMRT,              --不摊销买卖损益
          AMRT_METHOD,                  --摊销算法
          REAL_VOLUME_TERMCUR,          --货币对反向实际数量
          REAL_AMOUNT_TERMCUR,          --货币对反向实际面值
          DUE_AMOUNT_TERMCUR,           --货币对反向结转面值
          REAL_CP_TERMCUR,              --货币对反向实际成本
          DUE_CP_TERMCUR,               --货币对反向结转成本
          PRFT_IR_AMRT_RC,              --重分类利息收入（摊销部分）
          PRFT_IR_AMRT_HLD_RC,          --重分类利息收入（当前持仓摊销部分）
          AMRT_COST_CP_RC,              --重分类摊余净价成本
          AMRT_YTM_RC,                  --重分类实际利率
          AMRT_IR_HP_RC,                --重分类利息调整（高精度）
          CALC_DATE,                    --计提摊销截止日期
          IPR_STATE,                    --减值状态：0-未减值，1-减值，2-核销
          IPR_PRFT_CP,                  --成本减值损失
          IPR_PRFT_AI,                  --利息减值损失
          IPR_CP,                       --成本减值准备
          IPR_HX_CP,                    --已核销成本
          IPR_HX_AI,                    --已核销应计利息
          IPR_HX_DUE_AI,                --已核销应收未收利息
          IPR_BW_AI,                    --表外应计利息
          IPR_BW_DUE_AI,                --表外应收未收利息
          AMRT_DATE_RC,                 --重分类摊销开始日期
          AMRT_COST_AI_RC,              --重分类摊销开始日期利息成本
          OPEN_DATE_RC,                 --重分类开仓日期
          PRFT_IR_AI_CALC_TAX,          --应计利息收入增量
          TAX_AI,                       --应计增值税
          TAX_DUE_AI,                   --应付增值税
          TAX_FEE,                      --费用收入税/支出税
          FV_CURRENCY,                  --估值币种
          SET_DATE,                     --结算日期
          PRFT_FV_CASH,                 --已实现公允价值变动损益
          TAX_AI_HLD,                   --当前持仓利息收入税/支出税
          OPEN_AI,                      --开仓利息成本
          OPEN_YTM_OPT,                 --开仓行权收益率
          PRFT_IR_AI_FUT,               --预收利息收入
          PRFT_IR_AI_CUR,               --计提利息收入
          PRFT_IR_AI_DUE,               --应收利息收入
          PRFT_IR_AI_CASH,              --实收利息收入
          TAX_FUT_AI,                   --计提利息收入预收税
          TAX_DUE_AMRT,                 --摊销利息收入应付增值税
          TAX_DUE_AMRT_RC,              --重分类后资本公积摊销收入应付增值税
          TAX_DUE_TRD,                  --买卖损益应付增值税
          TAX_DUE_FV,                   --公允价值损益应付增值税
          TAX_DUE_FV_RECLASS,           --重分类公允价值损益应付增值税
          TAX_DUE_FV_CASH,              --已实现公允价值损益应付增值税
          TAX_DUE_FEE,                  --费用损益应付增值税
          DUE_CHG_FV,                   --结转公允价值变动
          DUE_VOLUME,                   --结转数量
          AMRT_VERIFY_CODE,             --摊销验证码
          AMRT_VERIFY_DATE,             --摊销验证日期
          PRFT_RECLASS,                 --重分类损益
          CLOSE_SET_DATE,               --平仓交割日期
          TRADE_INST_ID,                --交易指令号
          CUSTOM_DIM1,                  --扩展维度1
          IPR_PERIOD,                   --减值阶段
          IPR_CP1,                      --阶段一减值准备
          IPR_CP2,                      --阶段二减值准备
          IPR_CP3,                      --阶段三减值准备
          IPR_PRFT_CP1,                 --阶段一减值损失
          IPR_PRFT_CP2,                 --阶段二减值损失
          IPR_PRFT_CP3,                 --阶段三减值损失
          AMRT_START_IR_HP,             --摊销开始日期初利息调整余额(高精度)
          TAX_AMRT,                     --摊销利息收入暂估税
          CALC_TAX_AMRT_CUR,            --计提摊销利息收入
          CALC_TAX_AMRT_DUE,            --应收摊销利息收入
          CALC_TAX_AMRT_CASH,           --实收摊销利息收入
          TAX_FV,                       --未实现损益暂估税
          TAX_IR,                       --利息收入暂估税
          TAX_DUE_IR,                   --利息收入应付增值税
          PRFT_ID,                      --损益对象ID
          DEVIATION,                    --偏离金额
          PRFT_IR_FUT_AI,               --预收息利息收入
          ETL_DT                        --ETL处理日期
    FROM IOL.V_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS   --券核算余额历史表_视图
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

  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  END ETL_INIT_O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_HIS;
/

