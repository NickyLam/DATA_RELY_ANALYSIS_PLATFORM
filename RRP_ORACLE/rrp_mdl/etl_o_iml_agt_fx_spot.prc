CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_AGT_FX_SPOT(I_P_DATE IN INTEGER,O_ERRCODE OUT VARCHAR2)
  /**************************************************************************
  *  程序名称：ETL_O_IML_AGT_FX_SPOT
  *  功能描述：外汇即期交易
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IML_AGT_FX_SPOT
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250107  YJY      优化脚本
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
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IML_AGT_FX_SPOT'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  --DELETE FROM RRP_MDL.O_IML_AGT_FX_SPOT T WHERE T.ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_AGT_FX_SPOT';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-外汇即期交易';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_AGT_FX_SPOT
    (ETL_DT              --数据日期
    ,AGT_ID              --协议编号
    ,LP_ID               --法人编号
    ,BUS_ID              --业务编号
    ,DEPT_ID             --部门编号
    ,ORG_ID              --机构编号
    ,INPUT_DT            --录入日期
    ,TRAN_DT             --交易日期
    ,VALUE_DT            --起息日期
    ,CURR_PAIRS_ID       --货币对编号
    ,BAG_EXCH_RAT        --成交汇率
    ,BRCH_EXCH_RAT       --分行汇率
    ,COST_EXCH_RAT       --成本汇率
    ,FST_CURR_CD         --第一币种代码
    ,SECD_CURR_CD        --第二货币代码
    ,FST_CURR_TRAN_AMT   --第一币种交易金额
    ,SECD_CURR_TRAN_AMT  --第二币种交易金额
    ,TRAN_AIM_CD         --交易目的代码
    ,CNTPTY_ID           --交易对手编号
    ,CNTPTY_ABBR         --交易对手简称
    ,TRAN_SPLT_TYPE_CD   --交易拆分类型代码
    ,TRAN_DIR_CD         --交易方向代码
    ,TRAN_FLOW_NUM       --交易流水号
    ,CTR_NT_STATUS_CD    --成交单状态代码
    ,BAG_ID              --成交编号
    ,TRAN_MODE_CD        --交易模式代码
    ,TRAN_SRC_CD         --交易来源代码
    ,TRAN_SITE_CD        --交易场所代码
    ,CLEAR_WAY_CD        --清算方式代码
    ,RELA_TRAN_ID        --关联交易编号
    ,PORTF_TRAN_ID       --投组交易编号
    ,PORTF_ID            --投组编号
    ,PORTF_NAME          --投组名称
    ,PORTF_TYPE_NAME     --投组类型名称
    ,PORTF_STATUS_CD     --投组状态代码
    ,PORTF_RELA_TRAN_ID  --投组关联交易编号
    ,CLEAR_ORG_CD        --清算机构代码
    ,MODIF_RELA_FLOW_NUM --交易修改关联流水号
    ,CREATE_DT           --创建日期
    ,UPDATE_DT           --更新日期
    ,ID_MARK             --删除标识
    ,JOB_CD              --任务代码
    ,DEALER_ACCT_NUM     --交易员账号
    )
  SELECT ETL_DT              --数据日期
    ,AGT_ID              --协议编号
    ,LP_ID               --法人编号
    ,BUS_ID              --业务编号
    ,DEPT_ID             --部门编号
    ,ORG_ID              --机构编号
    ,INPUT_DT            --录入日期
    ,TRAN_DT             --交易日期
    ,VALUE_DT            --起息日期
    ,CURR_PAIRS_ID       --货币对编号
    ,BAG_EXCH_RAT        --成交汇率
    ,BRCH_EXCH_RAT       --分行汇率
    ,COST_EXCH_RAT       --成本汇率
    ,FST_CURR_CD         --第一币种代码
    ,SECD_CURR_CD        --第二货币代码
    ,FST_CURR_TRAN_AMT   --第一币种交易金额
    ,SECD_CURR_TRAN_AMT  --第二币种交易金额
    ,TRAN_AIM_CD         --交易目的代码
    ,CNTPTY_ID           --交易对手编号
    ,CNTPTY_ABBR         --交易对手简称
    ,TRAN_SPLT_TYPE_CD   --交易拆分类型代码
    ,TRAN_DIR_CD         --交易方向代码
    ,TRAN_FLOW_NUM       --交易流水号
    ,CTR_NT_STATUS_CD    --成交单状态代码
    ,BAG_ID              --成交编号
    ,TRAN_MODE_CD        --交易模式代码
    ,TRAN_SRC_CD         --交易来源代码
    ,TRAN_SITE_CD        --交易场所代码
    ,CLEAR_WAY_CD        --清算方式代码
    ,RELA_TRAN_ID        --关联交易编号
    ,PORTF_TRAN_ID       --投组交易编号
    ,PORTF_ID            --投组编号
    ,PORTF_NAME          --投组名称
    ,PORTF_TYPE_NAME     --投组类型名称
    ,PORTF_STATUS_CD     --投组状态代码
    ,PORTF_RELA_TRAN_ID  --投组关联交易编号
    ,CLEAR_ORG_CD        --清算机构代码
    ,MODIF_RELA_FLOW_NUM --交易修改关联流水号
    ,CREATE_DT           --创建日期
    ,UPDATE_DT           --更新日期
    ,ID_MARK             --删除标识
    ,JOB_CD              --任务代码
    ,DEALER_ACCT_NUM     --交易员账号
    FROM IML.V_AGT_FX_SPOT  --视图-外汇即期交易
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);

  -- 程序跑批结束记录 --
  V_STEP_DESC := '-- 程序跑批结束 --';
  V_STARTTIME := SYSDATE;
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_AGT_FX_SPOT', '', O_ERRCODE);--表分析
  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
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

END ETL_O_IML_AGT_FX_SPOT;
/

