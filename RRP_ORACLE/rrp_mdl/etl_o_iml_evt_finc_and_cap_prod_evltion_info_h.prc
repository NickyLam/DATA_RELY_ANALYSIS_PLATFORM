CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H(I_P_DATE IN INTEGER,
                                                                           O_ERRCODE OUT VARCHAR2
                                                                           )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H
  *  功能描述：理财与资金产品估值信息历史
  *  创建日期：20221008
  *  开发人员：MW
  *  来源表：
  *  目标表：  O_IML_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H
  *  配置表：  IML.V_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220611  梅炜     首次创建
  *             2    20250610  YJY      剔除删除数据
  **************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(50) := 'O_IML_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H T WHERE T.BATCH_DT = TO_DATE(V_P_DATE,'YYYYMMDD');--普通表的重跑处理
  --EXECUTE IMMEDIATE ('ALTER TABLE '||V_TAB_NAME||' TRUNCATE PARTITION '||'写上分区名');--分区表的重跑处理*/
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H'; --MOD BY YJY 20260212
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-理财与资金产品估值信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H
    (EVT_ID                --事件编号
    ,LP_ID                 --法人编号
    ,BATCH_DT              --跑批日期
    ,COMB_PROD_CD_DESCB    --组合产品代码描述
    ,FIN_PROD_CD_DESCB     --金融产品代码描述
    ,INVEST_AIM_CD         --投资目的代码
    ,CURR_CD               --币种代码
    ,ASSET_QTTY            --资产数量
    ,EVHA_VAL_CHAG         --公允价值变动
    ,AMORT_TOT_COST        --摊销总成本
    ,AMORT_COST_NET_PRICE  --摊销成本净价
    ,TD_ACRU_INT           --当日应计利息
    ,CREATE_TM             --创建时间
    ,UPDATE_TM             --更新时间
    ,AMORT_ACTL_DAY_INT_RAT  --摊销实际日利率
    ,SECU_ACCT_ID          --证券账户编号
    ,OVDUE_ASSET_PREP_CLEAR_CAP  --逾期资产待清算资金
    ,SURP_TENOR            --剩余期限
    ,SURP_SURVIV_TENOR     --剩余存续期限
    ,PROVI_INT_RAT         --计提利率
    ,TD_SPD_INCO           --当日价差收入
    ,START_DT              --开始时间
    ,END_DT                --结束时间
    ,ID_MARK               --增删标志
    ,SRC_TABLE_NAME        --源表名称
    ,JOB_CD                --任务编码
    )
  SELECT 
     EVT_ID                --事件编号
    ,LP_ID                 --法人编号
    ,BATCH_DT              --跑批日期
    ,COMB_PROD_CD_DESCB    --组合产品代码描述
    ,FIN_PROD_CD_DESCB     --金融产品代码描述
    ,INVEST_AIM_CD         --投资目的代码
    ,CURR_CD               --币种代码
    ,ASSET_QTTY            --资产数量
    ,EVHA_VAL_CHAG         --公允价值变动
    ,AMORT_TOT_COST        --摊销总成本
    ,AMORT_COST_NET_PRICE  --摊销成本净价
    ,TD_ACRU_INT           --当日应计利息
    ,CREATE_TM             --创建时间
    ,UPDATE_TM             --更新时间
    ,AMORT_ACTL_DAY_INT_RAT  --摊销实际日利率
    ,SECU_ACCT_ID          --证券账户编号
    ,OVDUE_ASSET_PREP_CLEAR_CAP  --逾期资产待清算资金
    ,SURP_TENOR            --剩余期限
    ,SURP_SURVIV_TENOR     --剩余存续期限
    ,PROVI_INT_RAT         --计提利率
    ,TD_SPD_INCO           --当日价差收入
    ,START_DT              --开始时间
    ,END_DT                --结束时间
    ,ID_MARK               --增删标志
    ,SRC_TABLE_NAME        --源表名称
    ,JOB_CD                --任务编码
    FROM IML.V_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H  --视图-理财与资金产品估值信息历史
   WHERE ID_MARK <> 'D'
     AND BATCH_DT = TO_DATE(V_P_DATE,'YYYYMMDD') 
     AND START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');  --MOD BY YJY 20250610

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

 --程序跑批结束记录
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '程序跑批结束';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H', '', O_ERRCODE); --表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE,PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
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

END ETL_O_IML_EVT_FINC_AND_CAP_PROD_EVLTION_INFO_H;
/

