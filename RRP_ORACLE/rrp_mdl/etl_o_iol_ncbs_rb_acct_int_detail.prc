CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_NCBS_RB_ACCT_INT_DETAIL(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_NCBS_RB_ACCT_INT_DETAIL
  *  功能描述：利息明细表
  *  创建日期：20251217
  *  开发人员：YJY
  *  来源表： IOL.V_NCBS_RB_ACCT_INT_DETAIL
  *  目标表： O_IOL_NCBS_RB_ACCT_INT_DETAIL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251217  YJY     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IOL_NCBS_RB_ACCT_INT_DETAIL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_NCBS_RB_ACCT_INT_DETAIL'; --程序名称
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
  V_STEP_DESC := '数据落地-利息明细表';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_NCBS_RB_ACCT_INT_DETAIL
  (   
            AGG                              --积数
           ,CLIENT_NO                        --客户编号
           ,INT_TYPE                         --利率类型
           ,INTERNAL_KEY                     --账户内部键值
           ,AGREE_CHANGE_TYPE                --协议变动方式
           ,CALC_BY_INT                      --是否按正常利率浮动
           ,COMPANY                          --法人
           ,CYCLE_FLAG                       --是否结息
           ,CYCLE_FREQ                       --结息频率
           ,DAC_VALUE                        --dac值防篡改加密
           ,DISCNT_UI_FLAG                   --折扣利息标志
           ,FLOAT_TYPE                       --利率浮动方式
           ,FOLLOW_INT_DAY_TYPE              --后续变动日利率取值日类型
           ,INT_ACCRUED_DIFF                 --计提金额差额
           ,INT_APPL_TYPE                    --利率启用方式
           ,INT_APPL_TYPE_PREV               --上一利率启用方式
           ,INT_CALC_BAL                     --计息方式
           ,INT_CAP_FLAG                     --资本化标志
           ,INT_FLAG                         --是否扣划利息标志
           ,LAYER_AGREEMENT                  --签约分层利率类型
           ,MONTH_BASIS                      --月基准
           ,PENALTY_ODI_RATE_TYPE            --罚息利率使用方式
           ,RATE_CHANGE_IND                  --利率变化标志
           ,RATE_EFFECT_TYPE                 --利率生效方式
           ,RETRY_FLAG                       --是否重算
           ,ROLL_FREQ                        --利率变更周期
           ,SPLIT_RATE_FLAG                  --利率分段标志
           ,SYSTEM_ID                        --系统id
           ,TAX_ACCRUED_DIFF                 --利息税差额
           ,TAX_TYPE                         --税种
           ,YEAR_BASIS                       --年基准天数
           ,INT_CLASS                        --利息分类
           ,CALC_BEGIN_DATE                  --利息计算起始日
           ,CALC_END_DATE                    --利息计算截止日
           ,LAST_ACCRUAL_DATE                --上一利息计提日
           ,LAST_CHANGE_DATE                 --最后修改日期
           ,LAST_CYCLE_DATE                  --上一结息日
           ,LAST_CYCLE_DATE_PRE              --日切前上一结息日
           ,LAST_ROLL_DATE                   --上一个利率变更日期
           ,LAST_TRUE_CYCLE_DATE             --上一真实结息日
           ,NEXT_ACCR_DATE                   --下一计提日期
           ,NEXT_CYCLE_DATE                  --下一结息日
           ,NEXT_ROLL_DATE                   --下一个利率变更日期
           ,SETTLE_CYCLE_DATE                --账户结算日期
           ,TD_LAST_ACCR_DATE                --当期上一计提日
           ,TRAN_TIMESTAMP                   --交易时间戳
           ,ACCR_INT_DAY                     --计提日
           ,ACCR_PERIOD_FREQ                 --计提周期
           ,ACCT_FIXED_RATE                  --分户级固定利率
           ,ACCT_FIXED_TAX_RATE              --分户级固定税率
           ,ACCT_PERCENT_RATE                --分户级利率浮动百分比
           ,ACCT_PERCENT_TAX_RATE            --分户级税率浮动百分比
           ,ACCT_SPREAD_RATE                 --分户级利率浮动百分点
           ,ACCT_SPREAD_TAX_RATE             --分户级税率浮动百分点
           ,ACTUAL_RATE                      --行内利率
           ,AGREE_AGG                        --协议积数
           ,AGREE_FIXED_RATE                 --协议固定利率
           ,AGREE_INT                        --协议利息
           ,AGREE_PERCENT_RATE               --协议浮动百分比
           ,AGREE_REDUCE_AMT                 --协议优惠金额
           ,AGREE_SPREAD_RATE                --协议浮动百分点
           ,DISCNT_INT                       --折扣利息
           ,DISCNT_INT_PREV                  --上日前付息
           ,DISCNT_RETAIN_INT                --未实现利息
           ,FLOAT_RATE                       --浮动利率
           ,FOLLOW_TRACE_NATURAL_DAYS        --回溯自然日天数
           ,FOLLOW_TRACE_WORKDAY_DAYS        --回溯工作日天数
           ,INT_ACCRUED                      --累计计提
           ,INT_ACCRUED_CALC_CTD             --计提日计提实际金额
           ,INT_ACCRUED_CTD                  --计提日计提利息
           ,INT_ACCRUED_PREV                 --上日累计计提利息
           ,INT_ACCRUED_T                    --存期计提累计利息
           ,INT_ADJ                          --利息调增金额
           ,INT_ADJ_CTD                      --计提日利息调整
           ,INT_ADJ_PREV                     --上日利息调整(累计)
           ,INT_AMT                          --利息金额
           ,INT_CAP_AMT                      --利息资本化金额
           ,INT_PAST_DUE                     --逾期利息值
           ,INT_POSTED                       --结息金额
           ,INT_POSTED_CTD                   --结息日利息金额
           ,INT_REM_DAYS                     --计息剩余天数
           ,INT_TAX_T                        --存量利息税
           ,LAST_CHANGE_USER_ID              --最后修改柜员
           ,LAST_INT_PAST_DUE                --上日逾期利息
           ,MAX_INT_RATE                     --执行利率上限
           ,MIN_INT_RATE                     --执行利率下限
           ,REAL_RATE                        --执行利率
           ,ROLL_DAY                         --利率变更日
           ,SPREAD_PERCENT                   --浮动百分比
           ,SPREAD_RATE                      --浮动点数
           ,TAX_ACCRUED                      --结息周期内利息税累计金额
           ,TAX_ACCRUED_CALC_CTD             --计提日利息税原金额
           ,TAX_ACCRUED_CTD                  --计提日利息税
           ,TAX_POSTED                       --利息税累计金额
           ,TAX_POSTED_CTD                   --结息日利息税
           ,TAX_RATE                         --税率
           ,TD_ACCR_INT_DAY                  --计提起始日
           ,TD_INT_NUM_DAYS                  --当期累计计息天数
           ,UI_INT                           --折扣付出利息
           ,UI_PENALTY_AMT                   --折扣罚息金额
           ,INT_DAY                          --存贷结息日期
           ,ADV_UPD_LAST_DATE                --上日累计已付备份日期
           ,ADJ_UPD_LAST_DATE                --上日累计调整备份日期
           ,PAST_FAD_RATE                    --违约利率
           ,DELAY_TOTAL_AMT                  --延迟付息累计金额
           ,DISCNT_INT_LAST_PREV             --上上日前付息
           ,INT_ACCRUED_LAST_PREV            --上上日累计计提利息
           ,INT_ADJ_LAST_PREV                --上上日利息调整
           ,TOTAL_AGG                        --总累计积数
           ,DELAY_INT_AMOUNT                 --延迟付息累计供核算金额
           ,DELAY_INT_AMOUNT_PREV            --延迟付息累计供核算金额-上日
           ,DELAY_INT_AMOUNT_LAST_PREV      
           ,MONTH_TOTAL_AMOUNT      
           ,LAST_MONTH_TOTAL_AMOUNT      
           ,ETL_DT                           --ETL处理日期
           ,ETL_TIMESTAMP                    --ETL处理时间戳
   )
  SELECT 
       AGG                              --积数
           ,CLIENT_NO                        --客户编号
           ,INT_TYPE                         --利率类型
           ,INTERNAL_KEY                     --账户内部键值
           ,AGREE_CHANGE_TYPE                --协议变动方式
           ,CALC_BY_INT                      --是否按正常利率浮动
           ,COMPANY                          --法人
           ,CYCLE_FLAG                       --是否结息
           ,CYCLE_FREQ                       --结息频率
           ,DAC_VALUE                        --dac值防篡改加密
           ,DISCNT_UI_FLAG                   --折扣利息标志
           ,FLOAT_TYPE                       --利率浮动方式
           ,FOLLOW_INT_DAY_TYPE              --后续变动日利率取值日类型
           ,INT_ACCRUED_DIFF                 --计提金额差额
           ,INT_APPL_TYPE                    --利率启用方式
           ,INT_APPL_TYPE_PREV               --上一利率启用方式
           ,INT_CALC_BAL                     --计息方式
           ,INT_CAP_FLAG                     --资本化标志
           ,INT_FLAG                         --是否扣划利息标志
           ,LAYER_AGREEMENT                  --签约分层利率类型
           ,MONTH_BASIS                      --月基准
           ,PENALTY_ODI_RATE_TYPE            --罚息利率使用方式
           ,RATE_CHANGE_IND                  --利率变化标志
           ,RATE_EFFECT_TYPE                 --利率生效方式
           ,RETRY_FLAG                       --是否重算
           ,ROLL_FREQ                        --利率变更周期
           ,SPLIT_RATE_FLAG                  --利率分段标志
           ,SYSTEM_ID                        --系统id
           ,TAX_ACCRUED_DIFF                 --利息税差额
           ,TAX_TYPE                         --税种
           ,YEAR_BASIS                       --年基准天数
           ,INT_CLASS                        --利息分类
           ,CALC_BEGIN_DATE                  --利息计算起始日
           ,CALC_END_DATE                    --利息计算截止日
           ,LAST_ACCRUAL_DATE                --上一利息计提日
           ,LAST_CHANGE_DATE                 --最后修改日期
           ,LAST_CYCLE_DATE                  --上一结息日
           ,LAST_CYCLE_DATE_PRE              --日切前上一结息日
           ,LAST_ROLL_DATE                   --上一个利率变更日期
           ,LAST_TRUE_CYCLE_DATE             --上一真实结息日
           ,NEXT_ACCR_DATE                   --下一计提日期
           ,NEXT_CYCLE_DATE                  --下一结息日
           ,NEXT_ROLL_DATE                   --下一个利率变更日期
           ,SETTLE_CYCLE_DATE                --账户结算日期
           ,TD_LAST_ACCR_DATE                --当期上一计提日
           ,TRAN_TIMESTAMP                   --交易时间戳
           ,ACCR_INT_DAY                     --计提日
           ,ACCR_PERIOD_FREQ                 --计提周期
           ,ACCT_FIXED_RATE                  --分户级固定利率
           ,ACCT_FIXED_TAX_RATE              --分户级固定税率
           ,ACCT_PERCENT_RATE                --分户级利率浮动百分比
           ,ACCT_PERCENT_TAX_RATE            --分户级税率浮动百分比
           ,ACCT_SPREAD_RATE                 --分户级利率浮动百分点
           ,ACCT_SPREAD_TAX_RATE             --分户级税率浮动百分点
           ,ACTUAL_RATE                      --行内利率
           ,AGREE_AGG                        --协议积数
           ,AGREE_FIXED_RATE                 --协议固定利率
           ,AGREE_INT                        --协议利息
           ,AGREE_PERCENT_RATE               --协议浮动百分比
           ,AGREE_REDUCE_AMT                 --协议优惠金额
           ,AGREE_SPREAD_RATE                --协议浮动百分点
           ,DISCNT_INT                       --折扣利息
           ,DISCNT_INT_PREV                  --上日前付息
           ,DISCNT_RETAIN_INT                --未实现利息
           ,FLOAT_RATE                       --浮动利率
           ,FOLLOW_TRACE_NATURAL_DAYS        --回溯自然日天数
           ,FOLLOW_TRACE_WORKDAY_DAYS        --回溯工作日天数
           ,INT_ACCRUED                      --累计计提
           ,INT_ACCRUED_CALC_CTD             --计提日计提实际金额
           ,INT_ACCRUED_CTD                  --计提日计提利息
           ,INT_ACCRUED_PREV                 --上日累计计提利息
           ,INT_ACCRUED_T                    --存期计提累计利息
           ,INT_ADJ                          --利息调增金额
           ,INT_ADJ_CTD                      --计提日利息调整
           ,INT_ADJ_PREV                     --上日利息调整(累计)
           ,INT_AMT                          --利息金额
           ,INT_CAP_AMT                      --利息资本化金额
           ,INT_PAST_DUE                     --逾期利息值
           ,INT_POSTED                       --结息金额
           ,INT_POSTED_CTD                   --结息日利息金额
           ,INT_REM_DAYS                     --计息剩余天数
           ,INT_TAX_T                        --存量利息税
           ,LAST_CHANGE_USER_ID              --最后修改柜员
           ,LAST_INT_PAST_DUE                --上日逾期利息
           ,MAX_INT_RATE                     --执行利率上限
           ,MIN_INT_RATE                     --执行利率下限
           ,REAL_RATE                        --执行利率
           ,ROLL_DAY                         --利率变更日
           ,SPREAD_PERCENT                   --浮动百分比
           ,SPREAD_RATE                      --浮动点数
           ,TAX_ACCRUED                      --结息周期内利息税累计金额
           ,TAX_ACCRUED_CALC_CTD             --计提日利息税原金额
           ,TAX_ACCRUED_CTD                  --计提日利息税
           ,TAX_POSTED                       --利息税累计金额
           ,TAX_POSTED_CTD                   --结息日利息税
           ,TAX_RATE                         --税率
           ,TD_ACCR_INT_DAY                  --计提起始日
           ,TD_INT_NUM_DAYS                  --当期累计计息天数
           ,UI_INT                           --折扣付出利息
           ,UI_PENALTY_AMT                   --折扣罚息金额
           ,INT_DAY                          --存贷结息日期
           ,ADV_UPD_LAST_DATE                --上日累计已付备份日期
           ,ADJ_UPD_LAST_DATE                --上日累计调整备份日期
           ,PAST_FAD_RATE                    --违约利率
           ,DELAY_TOTAL_AMT                  --延迟付息累计金额
           ,DISCNT_INT_LAST_PREV             --上上日前付息
           ,INT_ACCRUED_LAST_PREV            --上上日累计计提利息
           ,INT_ADJ_LAST_PREV                --上上日利息调整
           ,TOTAL_AGG                        --总累计积数
           ,DELAY_INT_AMOUNT                 --延迟付息累计供核算金额
           ,DELAY_INT_AMOUNT_PREV            --延迟付息累计供核算金额-上日
           ,DELAY_INT_AMOUNT_LAST_PREV      
           ,MONTH_TOTAL_AMOUNT      
           ,LAST_MONTH_TOTAL_AMOUNT      
           ,ETL_DT                           --ETL处理日期
           ,ETL_TIMESTAMP                    --ETL处理时间戳
    FROM IOL.V_NCBS_RB_ACCT_INT_DETAIL --视图-利息明细表
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
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  V_ENDTIME := SYSDATE;
  O_ERRCODE := '0';
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

-- 程序异常处理部分 --
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    ROLLBACK;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IOL_NCBS_RB_ACCT_INT_DETAIL;
/

