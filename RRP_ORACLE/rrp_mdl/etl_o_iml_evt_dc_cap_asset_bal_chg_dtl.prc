CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL(I_P_DATE IN INTEGER,
                                                                   O_ERRCODE OUT VARCHAR2
                                                                   )
  /**************************************************************************
  *  程序名称：ETL_O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL
  *  功能描述：本币资金资产余额变动明细
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  DELETE FROM RRP_MDL.O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  --EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-本币资金资产余额变动明细';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL
    (ETL_DT                --数据日期
    ,EVT_ID                --事件编号
    ,LP_ID                 --法人编号
    ,BAL_CHG_DTL_ID        --余额变动明细编号
    ,BUS_ID                --业务编号
    ,BUS_TAB_NAME          --业务表名
    ,DEPT_ID               --部门编号
    ,ACCT_B_ID             --账簿编号
    ,ASSET_TYPE_NAME       --资产类型名称
    ,BUS_CATE_NAME         --业务类别名称
    ,MAIN_ASSET_ID         --主资产编号
    ,MINOR_ASSET_ID        --次资产编号
    ,ACTL_ACPT_PAY_DT      --实际收付日期
    ,HOLD_POS              --持有仓位
    ,HOLD_DENOM            --持有面额
    ,NET_PRICE_COST        --净价成本
    ,INT_ADJ               --利息调整
    ,EVHA_VAL_CHAG         --公允价值变动
    ,INT_COST              --利息成本
    ,FULL_PRICE_COST       --全价成本
    ,IMPAM_PREP            --减值准备
    ,SPD_PRFT              --价差收益
    ,AMORT_PRFT            --摊销收益
    ,INT_PRFT              --利息收益
    ,EVHA_VAL_CHAG_PL      --公允价值变动损益
    ,IMPAM_LOSS            --减值损失
    ,TRAN_FEE              --交易费用
    ,ACTL_INT_RAT          --实际利率
    ,VALUE_DT              --起息日期
    ,EXP_DT                --到期日期
    ,FINAL_UPDATE_TM       --最后更新时间
    ,HAPP_AMT              --发生金额
    ,LAST_BAL_CHG_DTL_ID   --上次余额变动明细编号
    ,STRK_BAL_FLG          --冲账标志
    ,JOB_CD                --任务代码
    )
  SELECT 
     ETL_DT                --数据日期
    ,EVT_ID                --事件编号
    ,LP_ID                 --法人编号
    ,BAL_CHG_DTL_ID        --余额变动明细编号
    ,BUS_ID                --业务编号
    ,BUS_TAB_NAME          --业务表名
    ,DEPT_ID               --部门编号
    ,ACCT_B_ID             --账簿编号
    ,ASSET_TYPE_NAME       --资产类型名称
    ,BUS_CATE_NAME         --业务类别名称
    ,MAIN_ASSET_ID         --主资产编号
    ,MINOR_ASSET_ID        --次资产编号
    ,ACTL_ACPT_PAY_DT      --实际收付日期
    ,HOLD_POS              --持有仓位
    ,HOLD_DENOM            --持有面额
    ,NET_PRICE_COST        --净价成本
    ,INT_ADJ               --利息调整
    ,EVHA_VAL_CHAG         --公允价值变动
    ,INT_COST              --利息成本
    ,FULL_PRICE_COST       --全价成本
    ,IMPAM_PREP            --减值准备
    ,SPD_PRFT              --价差收益
    ,AMORT_PRFT            --摊销收益
    ,INT_PRFT              --利息收益
    ,EVHA_VAL_CHAG_PL      --公允价值变动损益
    ,IMPAM_LOSS            --减值损失
    ,TRAN_FEE              --交易费用
    ,ACTL_INT_RAT          --实际利率
    ,VALUE_DT              --起息日期
    ,EXP_DT                --到期日期
    ,FINAL_UPDATE_TM       --最后更新时间
    ,HAPP_AMT              --发生金额
    ,LAST_BAL_CHG_DTL_ID   --上次余额变动明细编号
    ,STRK_BAL_FLG          --冲账标志
    ,JOB_CD                --任务代码
    FROM IML.V_EVT_DC_CAP_ASSET_BAL_CHG_DTL
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');  --视图-代理代销产品信息

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL', '', O_ERRCODE);

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

END ETL_O_IML_EVT_DC_CAP_ASSET_BAL_CHG_DTL;
/

