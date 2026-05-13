CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP
  *  功能描述：中国债券信用评级表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(30); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  BEGIN

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
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP NOLOGGING
    ( OBJ_ID,                          --
      TSK_ID,                          --
      BEG_DATE,                        --
      END_DATE,                        --
      EXT_SECU_ACCT_ID,                --
      SECU_ACCT_ID,                    --
      TRADE_GRP_ID,                    --
      I_CODE,                          --
      A_TYPE,                          --
      M_TYPE,                          --
      TRADE_ID,                        --
      EXTRA_DIM,                       --
      REAL_VOLUME,                     --
      REAL_AMOUNT,                     --
      REAL_CP,                         --
      AI,                              --
      AI_COST,                         --
      CHG_FV,                          --
      DUE_AMOUNT,                      --
      DUE_CP,                          --
      DUE_AI,                          --
      AMRT_COUNT,                      --
      AMRT_DATE,                       --
      AMRT_IR,                         --
      PRFT_FV,                         --
      PRFT_TRD,                        --
      PRFT_IR,                         --
      PRFT_IR_AI,                      --
      PRFT_IR_AMRT,                    --
      PRFT_IR_AI_HLD,                  --
      PRFT_IR_AMRT_HLD,                --
      RECLASS_PRFT_FV,                 --
      IMPAIR,                          --
      PRFT_IMPAIR,                     --
      REAL_MARGIN,                     --
      OPEN_TIME,                       --
      UPDATE_TIME,                     --
      PRFT_FEE,                        --
      DUE_FEE,                         --
      FEE,                             --
      AMRT_COST_CP,                    --
      AMRT_COST_AI,                    --
      AMRT_IR_HP,                      --
      AMRT_YTM,                        --
      INVEST_YTM,                      --
      OPEN_YTM,                        --
      FUTURE_AI,                       --
      REAL_CP_NOAMRT,                  --
      CHG_FV_NOAMRT,                   --
      PRFT_FV_NOAMRT,                  --
      PRFT_TRD_NOAMRT,                 --
      AMRT_METHOD,                     --
      REAL_VOLUME_TERMCUR,             --
      REAL_AMOUNT_TERMCUR,             --
      DUE_AMOUNT_TERMCUR,              --
      REAL_CP_TERMCUR,                 --
      DUE_CP_TERMCUR,                  --
      PRFT_IR_AMRT_RC,                 --
      PRFT_IR_AMRT_HLD_RC,             --
      AMRT_COST_CP_RC,                 --
      AMRT_YTM_RC,                     --
      AMRT_IR_HP_RC,                   --
      CALC_DATE,                       --
      IPR_STATE,                       --
      IPR_PRFT_CP,                     --
      IPR_PRFT_AI,                     --
      IPR_CP,                          --
      IPR_HX_CP,                       --
      IPR_HX_AI,                       --
      IPR_HX_DUE_AI,                   --
      IPR_BW_AI,                       --
      IPR_BW_DUE_AI,                   --
      AMRT_DATE_RC,                    --
      AMRT_COST_AI_RC,                 --
      OPEN_DATE_RC,                    --
      PRFT_IR_AI_CALC_TAX,             --应计利息收入增量
      TAX_AI,                          --应计增值税
      TAX_DUE_AI,                      --应付增值税
      TAX_FEE,                         --费用收入税/支出税
      FV_CURRENCY,                     --估值币种
      SET_DATE,                        --结算日期
      PRFT_FV_CASH,                    --已实现公允价值变动损益
      TAX_AI_HLD,                      --当前持仓利息收入税/支出税
      OPEN_AI,                         --开仓利息成本
      OPEN_YTM_OPT,                    --开仓行权收益率
      PRFT_IR_AI_FUT,                  --预收利息收入
      PRFT_IR_AI_CUR,                  --计提利息收入
      PRFT_IR_AI_DUE,                  --应收利息收入
      PRFT_IR_AI_CASH,                 --实收利息收入
      TAX_FUT_AI,                      --计提利息收入预收税
      TAX_DUE_AMRT,                    --摊销利息收入应付增值税
      TAX_DUE_AMRT_RC,                 --重分类后资本公积摊销收入应付增值税
      TAX_DUE_TRD,                     --买卖损益应付增值税
      TAX_DUE_FV,                      --公允价值损益应付增值税
      TAX_DUE_FV_RECLASS,              --重分类公允价值损益应付增值税
      TAX_DUE_FV_CASH,                 --已实现公允价值损益应付增值税
      TAX_DUE_FEE,                     --费用损益应付增值税
      DUE_CHG_FV,                      --结转公允价值变动
      DUE_VOLUME,                      --结转数量
      AMRT_VERIFY_CODE,                --摊销验证码
      AMRT_VERIFY_DATE,                --摊销验证日期
      PRFT_RECLASS,                    --重分类损益
      CLOSE_SET_DATE,                  --平仓交割日期
      TRADE_INST_ID,                   --交易指令号
      CUSTOM_DIM1,                     --扩展维度1
      IPR_PERIOD,                      --减值阶段
      IPR_CP1,                         --阶段一减值准备
      IPR_CP2,                         --阶段二减值准备
      IPR_CP3,                         --阶段三减值准备
      IPR_PRFT_CP1,                    --阶段一减值损失
      IPR_PRFT_CP2,                    --阶段二减值损失
      IPR_PRFT_CP3,                    --阶段三减值损失
      AMRT_START_IR_HP,                --摊销开始日期初利息调整余额(高精度)
      TAX_AMRT,                        --摊销利息收入暂估税
      CALC_TAX_AMRT_CUR,               --计提摊销利息收入税
      CALC_TAX_AMRT_DUE,               --应收摊销利息收入税
      CALC_TAX_AMRT_CASH,              --实收摊销利息收入税
      TAX_FV,                          --未实现损益暂估税
      DISCOUNT_AI,                     --贴现利息单张值
      TAX_DUE_AI_AMRT,                 --存储到期、行权、赎回摊销部分拆出来的税
      PRFT_IR_TRD,                     --买卖损益计为利息收入
      TAX_DUE_AI_TRD,                  --买卖损益计入利息收入产生的税
      PRFT_IR_AMRT_CUR,                --计提摊销利息收入
      PRFT_IR_AMRT_DUE,                --应收摊销利息收入
      PRFT_IR_AMRT_CASH,               --实收摊销利息收入
      TAX_IR,                          --利息收入暂估税
      TAX_DUE_IR,                      --利息收入应付增值税
      PRFT_ID,                         --损益对象ID
      DEVIATION,                       --偏离金额
      PRFT_IR_FUT_AI,                  --预收息利息收入
      IS_AI_TRANSFERED,                --计利息是否结转
      IPR_AI3,                         --阶段三减值利息
      IPR_PRFT_AI3,                    --阶段三利息减值损失
      DEFERRED_FV_TAX,                 --估值递延税
      DEFERRED_PROFIT_FV_TAX,          --损益递延税
      IPR_AI,                          --利息减值准备
      ETL_DT                           --ETL处理日期
     )
  SELECT /*+PARALLEL*/
          OBJ_ID,                          --
          TSK_ID,                          --
          BEG_DATE,                        --
          END_DATE,                        --
          EXT_SECU_ACCT_ID,                --
          SECU_ACCT_ID,                    --
          TRADE_GRP_ID,                    --
          I_CODE,                          --
          A_TYPE,                          --
          M_TYPE,                          --
          TRADE_ID,                        --
          EXTRA_DIM,                       --
          REAL_VOLUME,                     --
          REAL_AMOUNT,                     --
          REAL_CP,                         --
          AI,                              --
          AI_COST,                         --
          CHG_FV,                          --
          DUE_AMOUNT,                      --
          DUE_CP,                          --
          DUE_AI,                          --
          AMRT_COUNT,                      --
          AMRT_DATE,                       --
          AMRT_IR,                         --
          PRFT_FV,                         --
          PRFT_TRD,                        --
          PRFT_IR,                         --
          PRFT_IR_AI,                      --
          PRFT_IR_AMRT,                    --
          PRFT_IR_AI_HLD,                  --
          PRFT_IR_AMRT_HLD,                --
          RECLASS_PRFT_FV,                 --
          IMPAIR,                          --
          PRFT_IMPAIR,                     --
          REAL_MARGIN,                     --
          OPEN_TIME,                       --
          UPDATE_TIME,                     --
          PRFT_FEE,                        --
          DUE_FEE,                         --
          FEE,                             --
          AMRT_COST_CP,                    --
          AMRT_COST_AI,                    --
          AMRT_IR_HP,                      --
          AMRT_YTM,                        --
          INVEST_YTM,                      --
          OPEN_YTM,                        --
          FUTURE_AI,                       --
          REAL_CP_NOAMRT,                  --
          CHG_FV_NOAMRT,                   --
          PRFT_FV_NOAMRT,                  --
          PRFT_TRD_NOAMRT,                 --
          AMRT_METHOD,                     --
          REAL_VOLUME_TERMCUR,             --
          REAL_AMOUNT_TERMCUR,             --
          DUE_AMOUNT_TERMCUR,              --
          REAL_CP_TERMCUR,                 --
          DUE_CP_TERMCUR,                  --
          PRFT_IR_AMRT_RC,                 --
          PRFT_IR_AMRT_HLD_RC,             --
          AMRT_COST_CP_RC,                 --
          AMRT_YTM_RC,                     --
          AMRT_IR_HP_RC,                   --
          CALC_DATE,                       --
          IPR_STATE,                       --
          IPR_PRFT_CP,                     --
          IPR_PRFT_AI,                     --
          IPR_CP,                          --
          IPR_HX_CP,                       --
          IPR_HX_AI,                       --
          IPR_HX_DUE_AI,                   --
          IPR_BW_AI,                       --
          IPR_BW_DUE_AI,                   --
          AMRT_DATE_RC,                    --
          AMRT_COST_AI_RC,                 --
          OPEN_DATE_RC,                    --
          PRFT_IR_AI_CALC_TAX,             --应计利息收入增量
          TAX_AI,                          --应计增值税
          TAX_DUE_AI,                      --应付增值税
          TAX_FEE,                         --费用收入税/支出税
          FV_CURRENCY,                     --估值币种
          SET_DATE,                        --结算日期
          PRFT_FV_CASH,                    --已实现公允价值变动损益
          TAX_AI_HLD,                      --当前持仓利息收入税/支出税
          OPEN_AI,                         --开仓利息成本
          OPEN_YTM_OPT,                    --开仓行权收益率
          PRFT_IR_AI_FUT,                  --预收利息收入
          PRFT_IR_AI_CUR,                  --计提利息收入
          PRFT_IR_AI_DUE,                  --应收利息收入
          PRFT_IR_AI_CASH,                 --实收利息收入
          TAX_FUT_AI,                      --计提利息收入预收税
          TAX_DUE_AMRT,                    --摊销利息收入应付增值税
          TAX_DUE_AMRT_RC,                 --重分类后资本公积摊销收入应付增值税
          TAX_DUE_TRD,                     --买卖损益应付增值税
          TAX_DUE_FV,                      --公允价值损益应付增值税
          TAX_DUE_FV_RECLASS,              --重分类公允价值损益应付增值税
          TAX_DUE_FV_CASH,                 --已实现公允价值损益应付增值税
          TAX_DUE_FEE,                     --费用损益应付增值税
          DUE_CHG_FV,                      --结转公允价值变动
          DUE_VOLUME,                      --结转数量
          AMRT_VERIFY_CODE,                --摊销验证码
          AMRT_VERIFY_DATE,                --摊销验证日期
          PRFT_RECLASS,                    --重分类损益
          CLOSE_SET_DATE,                  --平仓交割日期
          TRADE_INST_ID,                   --交易指令号
          CUSTOM_DIM1,                     --扩展维度1
          IPR_PERIOD,                      --减值阶段
          IPR_CP1,                         --阶段一减值准备
          IPR_CP2,                         --阶段二减值准备
          IPR_CP3,                         --阶段三减值准备
          IPR_PRFT_CP1,                    --阶段一减值损失
          IPR_PRFT_CP2,                    --阶段二减值损失
          IPR_PRFT_CP3,                    --阶段三减值损失
          AMRT_START_IR_HP,                --摊销开始日期初利息调整余额(高精度)
          TAX_AMRT,                        --摊销利息收入暂估税
          CALC_TAX_AMRT_CUR,               --计提摊销利息收入税
          CALC_TAX_AMRT_DUE,               --应收摊销利息收入税
          CALC_TAX_AMRT_CASH,              --实收摊销利息收入税
          TAX_FV,                          --未实现损益暂估税
          DISCOUNT_AI,                     --贴现利息单张值
          TAX_DUE_AI_AMRT,                 --存储到期、行权、赎回摊销部分拆出来的税
          PRFT_IR_TRD,                     --买卖损益计为利息收入
          TAX_DUE_AI_TRD,                  --买卖损益计入利息收入产生的税
          PRFT_IR_AMRT_CUR,                --计提摊销利息收入
          PRFT_IR_AMRT_DUE,                --应收摊销利息收入
          PRFT_IR_AMRT_CASH,               --实收摊销利息收入
          TAX_IR,                          --利息收入暂估税
          TAX_DUE_IR,                      --利息收入应付增值税
          PRFT_ID,                         --损益对象ID
          DEVIATION,                       --偏离金额
          PRFT_IR_FUT_AI,                  --预收息利息收入
          IS_AI_TRANSFERED,                --计利息是否结转
          IPR_AI3,                         --阶段三减值利息
          IPR_PRFT_AI3,                    --阶段三利息减值损失
          DEFERRED_FV_TAX,                 --估值递延税
          DEFERRED_PROFIT_FV_TAX,          --损益递延税
          IPR_AI,                          --利息减值准备
          ETL_DT                           --ETL处理日期
    FROM IOL.V_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP   --_视图
   /*WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')*/;

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

  END ETL_O_IOL_IBMS_TTRD_ACCOUNTING_SECU_OBJ_COMP;
/

