CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CTMS_VI_CMS_AVG_COST_ANALYSE_DTL_BOND(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CTMS_VI_CMS_AVG_COST_ANALYSE_DTL_BOND
  *  功能描述：平均成本损益分析
  *  创建日期：20250707
  *  开发人员：YJY
  *  来源表： IOL.V_CTMS_VI_CMS_AVG_COST_ANALYSE_DTL_BOND
  *  目标表： O_IOL_CTMS_VI_CMS_AVG_COST_ANALYSE_DTL_BOND
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20250707  YJY     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IOL_CTMS_VI_CMS_AVG_COST_ANALYSE_DTL_BOND'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CTMS_VI_CMS_AVG_COST_ANALYSE_DTL_BOND'; --程序名称
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
  V_STEP_DESC := '数据落地-平均成本损益分析';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_CTMS_VI_CMS_AVG_COST_ANALYSE_DTL_BOND
    ( QUERY_END_DATE       --数据日期
     ,SECURITY_ID          --债券代码
     ,SECURITY_NAME        --债券名称
     ,START_DATE           --起息日
     ,END_DATE             --到期日
     ,POSITION             --面额
     ,RESIDUALQTY          --剩余本金
     ,AVERAGECOST          --平均成本
     ,DPAPRICE             --折溢摊净价
     ,ACCRUEDINTEREST      --应计利息
     ,ASSETTYPE            --资产负债分类
     ,CNAME                --债券代码名称
     ,CURRENCY             --币别
     ,MDURATION            --修正久期
     ,PVBP                 --DV01
     ,PFOLIO_ID            --投组id
     ,PFOLIO_NAME          --交易投组名称
     ,BUZTYPE              --投组三分类
     ,KEEPFOLDER_ID        --账户ID
     ,KEEPFOLDER_CODE      --账户代码
     ,KEEPFOLDER_SHORTNAME --账户名称
     ,ORG_ID               --部门机构
     ,PRODUCT_CODE         --标准产品
     ,YIELD                --到期收益率
     ,SECURITY_TERM_TO_MATURITY      --待偿期
     ,SECURITY_TYPE        --债券类型
     ,COUPONINTERESTAMT    --利息收入
     ,DPA                  --折溢摊
     ,SPREAD               --买卖价差
     ,URPL                 --浮动盈亏
     ,ETL_DT               --ETL处理日期
     ,ETL_TIMESTAMP        --ETL处理时间戳
    )
  SELECT 
      QUERY_END_DATE       --数据日期
     ,SECURITY_ID          --债券代码
     ,SECURITY_NAME        --债券名称
     ,START_DATE           --起息日
     ,END_DATE             --到期日
     ,POSITION             --面额
     ,RESIDUALQTY          --剩余本金
     ,AVERAGECOST          --平均成本
     ,DPAPRICE             --折溢摊净价
     ,ACCRUEDINTEREST      --应计利息
     ,ASSETTYPE            --资产负债分类
     ,CNAME                --债券代码名称
     ,CURRENCY             --币别
     ,MDURATION            --修正久期
     ,PVBP                 --DV01
     ,PFOLIO_ID            --投组id
     ,PFOLIO_NAME          --交易投组名称
     ,BUZTYPE              --投组三分类
     ,KEEPFOLDER_ID        --账户ID
     ,KEEPFOLDER_CODE      --账户代码
     ,KEEPFOLDER_SHORTNAME --账户名称
     ,ORG_ID               --部门机构
     ,PRODUCT_CODE         --标准产品
     ,YIELD                --到期收益率
     ,SECURITY_TERM_TO_MATURITY      --待偿期
     ,SECURITY_TYPE        --债券类型
     ,COUPONINTERESTAMT    --利息收入
     ,DPA                  --折溢摊
     ,SPREAD               --买卖价差
     ,URPL                 --浮动盈亏
     ,ETL_DT               --ETL处理日期
     ,ETL_TIMESTAMP        --ETL处理时间戳
    FROM IOL.V_CTMS_VI_CMS_AVG_COST_ANALYSE_DTL_BOND --视图-平均成本损益分析
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

END ETL_O_IOL_CTMS_VI_CMS_AVG_COST_ANALYSE_DTL_BOND;
/

