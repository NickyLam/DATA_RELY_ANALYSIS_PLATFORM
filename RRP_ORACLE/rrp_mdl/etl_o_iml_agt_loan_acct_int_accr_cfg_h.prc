CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_LOAN_ACCT_INT_ACCR_CFG_H(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
 /*******************************************************************
  **存储过程详细说明：贷款账户计息配置历史
  **存储过程名称：    ETL_O_IML_AGT_LOAN_ACCT_INT_ACCR_CFG_H
  **存储过程创建日期：20251229
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20251229    YJY        创建  
  *****************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_AGT_LOAN_ACCT_INT_ACCR_CFG_H'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_LOAN_ACCT_INT_ACCR_CFG_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-贷款账户计息配置历史';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_AGT_LOAN_ACCT_INT_ACCR_CFG_H NOLOGGING 
  (          AGT_ID                        --协议编号
            ,LP_ID                         --法人编号
            ,ACCT_ID                       --账户编号
            ,INT_CLS_CD                    --利息分类代码
            ,CUST_ID                       --客户编号
            ,INT_RAT_TYPE_CD               --利率类型代码
            ,BANK_INT_INT_RAT              --行内利率
            ,INT_RAT_FLOAT_POINT           --利率浮动点数
            ,INT_RAT_FLOAT_RATIO           --利率浮动比例
            ,FLOAT_INT_RAT                 --浮动利率
            ,SUB_ACCT_INT_RAT_FLOAT_POINT  --分户级利率浮动点数
            ,SUB_ACCT_INT_RAT_FLOAT_RATIO  --分户级利率浮动比例
            ,SUB_ACCT_FIX_INT_RAT          --分户级固定利率
            ,HIGT_EXEC_INT_RAT             --最高执行利率
            ,LOWT_EXEC_INT_RAT             --最低执行利率
            ,ACCRD_NOMAL_INT_RAT_FLOAT_FLG --按正常利率浮动标志
            ,EXEC_INT_RAT                  --执行利率
            ,INT_SET_FREQ_CD               --结息频率代码
            ,INT_SET_DAY                   --结息日
            ,INT_ACCR_WAY_CD               --计息方式代码
            ,YEAR_INT_ACCR_BASE_CD         --年计息基准代码
            ,MON_INT_ACCR_BASE_CD          --月计息基准代码
            ,INT_ACCR_BASE_CD              --计息基准代码
            ,INT_ACCR_FLG                  --计息标志
            ,CAP_FLG                       --资本化标志
            ,INT_SET_FLG                   --结息标志
            ,ACALC_FLG                     --重算标志
            ,INT_RAT_START_USE_WAY_CD      --利率启用方式代码
            ,INT_RAT_EFFECT_WAY_CD         --利率生效方式代码
            ,INT_RAT_MODIF_PED_CD          --利率变更周期代码
            ,INT_RAT_CHG_DT                --利率变动日期
            ,INT_RAT_MODIF_DAY             --利率变更日
            ,NEXT_INT_RAT_MODIF_DT         --下次重定价日期
            ,LAST_INT_RAT_MODIF_DT         --上次重定价日期
            ,EXEC_INT_RAT_CHG_FLG          --执行利率变化标志
            ,TAX_CATEGORY_CD               --税种代码
            ,TAX_RAT                       --税率
            ,PNLT_INT_RAT_USE_WAY_CD       --罚息利率使用方式代码
            ,INT_PROVI_DAY                 --利息计提日
            ,INT_PROVI_PED                 --利息计提周期
            ,AGT_CHG_WAY_CD                --协议变动方式代码
            ,AGT_FIX_INT_RAT               --协议固定利率
            ,AGT_FLOAT_RATIO               --协议浮动比例
            ,AGT_FLOAT_POINT               --协议浮动点数
            ,SUB_ACCT_FIX_TAX_RAT          --分户级固定税率
            ,SUB_ACCT_TAX_RAT_FLOAT_POINT  --分户级税率浮动点数
            ,SUB_ACCT_TAX_RAT_FLOAT_RATIO  --分户级税率浮动比例
            ,EXCH_RAT_FLOAT_CATE_CD        --汇率浮动类别代码
            ,INT_RAT_DAY_TYPE_CD           --利率日类型代码
            ,ACRS_PED_FLG                  --跨周期标志
            ,START_DT                      --开始时间
            ,END_DT                        --结束时间
            ,ID_MARK                       --增删标志
            ,SRC_TABLE_NAME                --源表名称
            ,JOB_CD                        --任务编码
            ,ETL_TIMESTAMP                 --ETL处理时间戳
    )
  SELECT 
            AGT_ID                        --协议编号
            ,LP_ID                         --法人编号
            ,ACCT_ID                       --账户编号
            ,INT_CLS_CD                    --利息分类代码
            ,CUST_ID                       --客户编号
            ,INT_RAT_TYPE_CD               --利率类型代码
            ,BANK_INT_INT_RAT              --行内利率
            ,INT_RAT_FLOAT_POINT           --利率浮动点数
            ,INT_RAT_FLOAT_RATIO           --利率浮动比例
            ,FLOAT_INT_RAT                 --浮动利率
            ,SUB_ACCT_INT_RAT_FLOAT_POINT  --分户级利率浮动点数
            ,SUB_ACCT_INT_RAT_FLOAT_RATIO  --分户级利率浮动比例
            ,SUB_ACCT_FIX_INT_RAT          --分户级固定利率
            ,HIGT_EXEC_INT_RAT             --最高执行利率
            ,LOWT_EXEC_INT_RAT             --最低执行利率
            ,ACCRD_NOMAL_INT_RAT_FLOAT_FLG --按正常利率浮动标志
            ,EXEC_INT_RAT                  --执行利率
            ,INT_SET_FREQ_CD               --结息频率代码
            ,INT_SET_DAY                   --结息日
            ,INT_ACCR_WAY_CD               --计息方式代码
            ,YEAR_INT_ACCR_BASE_CD         --年计息基准代码
            ,MON_INT_ACCR_BASE_CD          --月计息基准代码
            ,INT_ACCR_BASE_CD              --计息基准代码
            ,INT_ACCR_FLG                  --计息标志
            ,CAP_FLG                       --资本化标志
            ,INT_SET_FLG                   --结息标志
            ,ACALC_FLG                     --重算标志
            ,INT_RAT_START_USE_WAY_CD      --利率启用方式代码
            ,INT_RAT_EFFECT_WAY_CD         --利率生效方式代码
            ,INT_RAT_MODIF_PED_CD          --利率变更周期代码
            ,INT_RAT_CHG_DT                --利率变动日期
            ,INT_RAT_MODIF_DAY             --利率变更日
            ,NEXT_INT_RAT_MODIF_DT         --下次重定价日期
            ,LAST_INT_RAT_MODIF_DT         --上次重定价日期
            ,EXEC_INT_RAT_CHG_FLG          --执行利率变化标志
            ,TAX_CATEGORY_CD               --税种代码
            ,TAX_RAT                       --税率
            ,PNLT_INT_RAT_USE_WAY_CD       --罚息利率使用方式代码
            ,INT_PROVI_DAY                 --利息计提日
            ,INT_PROVI_PED                 --利息计提周期
            ,AGT_CHG_WAY_CD                --协议变动方式代码
            ,AGT_FIX_INT_RAT               --协议固定利率
            ,AGT_FLOAT_RATIO               --协议浮动比例
            ,AGT_FLOAT_POINT               --协议浮动点数
            ,SUB_ACCT_FIX_TAX_RAT          --分户级固定税率
            ,SUB_ACCT_TAX_RAT_FLOAT_POINT  --分户级税率浮动点数
            ,SUB_ACCT_TAX_RAT_FLOAT_RATIO  --分户级税率浮动比例
            ,EXCH_RAT_FLOAT_CATE_CD        --汇率浮动类别代码
            ,INT_RAT_DAY_TYPE_CD           --利率日类型代码
            ,ACRS_PED_FLG                  --跨周期标志
            ,START_DT                      --开始时间
            ,END_DT                        --结束时间
            ,ID_MARK                       --增删标志
            ,SRC_TABLE_NAME                --源表名称
            ,JOB_CD                        --任务编码
            ,ETL_TIMESTAMP                 --ETL处理时间戳
    FROM IML.V_AGT_LOAN_ACCT_INT_ACCR_CFG_H --视图-贷款账户计息配置历史
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_LOAN_ACCT_INT_ACCR_CFG_H', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

--程序异常处理部分
EXCEPTION
  WHEN OTHERS THEN
    V_SQLMSG  := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
    O_ERRCODE := '1';
    V_ENDTIME := SYSDATE;
    ROLLBACK;
    ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

END ETL_O_IML_AGT_LOAN_ACCT_INT_ACCR_CFG_H;
/

