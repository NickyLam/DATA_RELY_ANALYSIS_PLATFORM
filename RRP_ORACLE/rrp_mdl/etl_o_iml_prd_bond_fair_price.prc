CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_PRD_BOND_FAIR_PRICE(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
  /**************************************************************************
  *  程序名称：ETL_O_IML_PRD_BOND_FAIR_PRICE
  *  功能描述：贵金属产品信息
  *  创建日期：20220317
  *  开发人员：YWZ
  *  来源表： IML.V_PRD_BOND_FAIR_PRICE
  *  目标表： O_IML_PRD_BOND_FAIR_PRICE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220317  YWZ    首次创建
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
  V_TAB_NAME  VARCHAR2(200) := 'O_IML_PRD_BOND_FAIR_PRICE'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_PRD_BOND_FAIR_PRICE'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_PRD_BOND_FAIR_PRICE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-贵金属产品信息';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IML_PRD_BOND_FAIR_PRICE NOLOGGING
    (BOND_ID             --债券编号
    ,LP_ID               --法人编号
    ,PRICE_DT            --价格日期
    ,TRAN_MARKET_NAME    --交易市场名称
    ,SURP_TENOR          --剩余期限
    ,RECMD_FLG           --推荐标志
    ,FULL_PRICE          --全价
    ,NET_PRICE           --净价
    ,EXP_YLD_RAT         --到期收益率
    ,DURAN               --久期
    ,CORET_DURAN         --修正久期
    ,VALID_FLG           --有效标志
    --,ACRU_INT            --应计利息
    ,END_DAY_FULL_PRICE  --日终全价
    ,ESTIM_YLD_RAT       --估价收益率
    ,ESTIM_CORET_DURAN   --估价修正久期
    ,ESTIM_CVTY          --估价凸性
    ,START_DT            --开始时间
    ,END_DT              --结束时间
    ,ID_MARK             --增删标志
    ,SRC_TABLE_NAME      --源表名称
    ,JOB_CD              --任务编码
    )
  SELECT /*+PARALLEL*/
         BOND_ID             --债券编号
        ,LP_ID               --法人编号
        ,PRICE_DT            --价格日期
        ,TRAN_MARKET_NAME    --交易市场名称
        ,SURP_TENOR          --剩余期限
        ,RECMD_FLG           --推荐标志
        ,FULL_PRICE          --全价
        ,NET_PRICE           --净价
        ,EXP_YLD_RAT         --到期收益率
        ,DURAN               --久期
        ,CORET_DURAN         --修正久期
        ,VALID_FLG           --有效标志
        --,ACRU_INT            --应计利息
        ,END_DAY_FULL_PRICE  --日终全价
        ,ESTIM_YLD_RAT       --估价收益率
        ,ESTIM_CORET_DURAN   --估价修正久期
        ,ESTIM_CVTY          --估价凸性
        ,START_DT            --开始时间
        ,END_DT              --结束时间
        ,ID_MARK             --增删标志
        ,SRC_TABLE_NAME      --源表名称
        ,JOB_CD              --任务编码
    FROM IML.V_PRD_BOND_FAIR_PRICE   --贵金属产品信息_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序跑批结束记录 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批结束 --';
  ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, '', O_ERRCODE);

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

END ETL_O_IML_PRD_BOND_FAIR_PRICE;
/

