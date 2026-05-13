CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_RWAS_RPT_ASSET_BASE_ASSET_INFO(I_P_DATE IN INTEGER,
                                                                 O_ERRCODE OUT VARCHAR2
                                                                )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_RWAS_RPT_ASSET_BASE_ASSET_INFO
  *  功能描述：内部管理报表_资管产品基础资产明细
  *  创建日期：20251202
  *  开发人员：YJY
  *  来源表： IOL.V_RWAS_RPT_ASSET_BASE_ASSET_INFO
  *  目标表： O_IOL_RWAS_RPT_ASSET_BASE_ASSET_INFO
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20251202  YJY     首次创建
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
  V_TAB_NAME  VARCHAR2(50) := 'O_IOL_RWAS_RPT_ASSET_BASE_ASSET_INFO'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_RWAS_RPT_ASSET_BASE_ASSET_INFO'; --程序名称
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
  V_STEP_DESC := '数据落地-内部管理报表_资管产品基础资产明细';
  V_STARTTIME := SYSDATE;
   INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_RWAS_RPT_ASSET_BASE_ASSET_INFO NOLOGGING
    (       DATA_DATE                   --数据日期
           ,PK_COL                      --PK_COL
           ,LOAN_REF_NO                 --债项编号
           ,FUND_CD                     --资产管理产品编号
           ,FUND_NAME                   --资产管理产品名称
           ,BASE_LOAN_REF_NO            --基础资产债项编号
           ,BASE_PRODUCT_CD             --基础资产描述
           ,BASE_PRODUCT_TYPE           --基础资产产品类型
           ,BASE_PRODUCT_NAME           --基础资产产品名称
           ,FINANCIAL_ASSET_CLASS       --金融资产三分类
           ,CCY_CD                      --币种代码
           ,PRIC_BAL                    --本金余额本币
           ,ACCRUED_INT                 --应计利息本币
           ,RECEIVABLE_INT              --应收利息本币
           ,INT_ADJ                     --利息调整本币
           ,FAIRVALUE_CHANGES           --公允价值变动本币
           ,ACCRUED_RECEIV_INT          --应收未收利息本币
           ,PROVISION                   --准备金本币
           ,EAD_ORIG                    --原始风险暴露本币
           ,ASSET_NET_PER               --占资产比例%
           ,TRUE_INVEST_RATIO           --投资比例
           ,MIN_INVEST_RATIO            --最小投资比例
           ,MAX_INVEST_RATIO            --最大投资比例
           ,AUTHORIZED_BY_THIRD_PARTY   --定期报告是否经过第三方托管人确认
           ,RISK_WEIGHT                 --权重
           ,FM_AVG_RW                   --资管产品基础资产平均权重
           ,FM_ALVG_RW                  --资管产品调整杠杆率后的权重
           ,BASE_SEC_NAME               --基础资产债券名称
           ,ACCORG_NO                   --入账机构
           ,ACCORG_NAME                 --入账机构名称
           ,ASSET_TYPE_NAME             --资产大类名称
           ,REPORT_LINE_NO              --G4B_1报表栏位号
           ,REPORT_LINE_NAME            --G4B_1栏位名称
           ,LOAD_DATE                   --加载日期
           ,RWA_BEFORE_ADJ              --调整前风险加权资产
           ,RWA_AFTER_ADJ               --调整后风险加权资产
           ,G4B_R_ITEM_CODE             --G4B-5项目
           ,ETL_DT                      --ETL处理日期
           ,ETL_TIMESTAMP               --ETL处理时间戳
     )
  SELECT /*+PARALLEL*/
            DATA_DATE                   --数据日期
           ,PK_COL                      --PK_COL
           ,LOAN_REF_NO                 --债项编号
           ,FUND_CD                     --资产管理产品编号
           ,FUND_NAME                   --资产管理产品名称
           ,BASE_LOAN_REF_NO            --基础资产债项编号
           ,BASE_PRODUCT_CD             --基础资产描述
           ,BASE_PRODUCT_TYPE           --基础资产产品类型
           ,BASE_PRODUCT_NAME           --基础资产产品名称
           ,FINANCIAL_ASSET_CLASS       --金融资产三分类
           ,CCY_CD                      --币种代码
           ,PRIC_BAL                    --本金余额本币
           ,ACCRUED_INT                 --应计利息本币
           ,RECEIVABLE_INT              --应收利息本币
           ,INT_ADJ                     --利息调整本币
           ,FAIRVALUE_CHANGES           --公允价值变动本币
           ,ACCRUED_RECEIV_INT          --应收未收利息本币
           ,PROVISION                   --准备金本币
           ,EAD_ORIG                    --原始风险暴露本币
           ,ASSET_NET_PER               --占资产比例%
           ,TRUE_INVEST_RATIO           --投资比例
           ,MIN_INVEST_RATIO            --最小投资比例
           ,MAX_INVEST_RATIO            --最大投资比例
           ,AUTHORIZED_BY_THIRD_PARTY   --定期报告是否经过第三方托管人确认
           ,RISK_WEIGHT                 --权重
           ,FM_AVG_RW                   --资管产品基础资产平均权重
           ,FM_ALVG_RW                  --资管产品调整杠杆率后的权重
           ,BASE_SEC_NAME               --基础资产债券名称
           ,ACCORG_NO                   --入账机构
           ,ACCORG_NAME                 --入账机构名称
           ,ASSET_TYPE_NAME             --资产大类名称
           ,REPORT_LINE_NO              --G4B_1报表栏位号
           ,REPORT_LINE_NAME            --G4B_1栏位名称
           ,LOAD_DATE                   --加载日期
           ,RWA_BEFORE_ADJ              --调整前风险加权资产
           ,RWA_AFTER_ADJ               --调整后风险加权资产
           ,G4B_R_ITEM_CODE             --G4B-5项目
           ,ETL_DT                      --ETL处理日期
           ,ETL_TIMESTAMP               --ETL处理时间戳
    FROM IOL.V_RWAS_RPT_ASSET_BASE_ASSET_INFO   --内部管理报表_资管产品基础资产明细
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ;  

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

END ETL_O_IOL_RWAS_RPT_ASSET_BASE_ASSET_INFO;
/

