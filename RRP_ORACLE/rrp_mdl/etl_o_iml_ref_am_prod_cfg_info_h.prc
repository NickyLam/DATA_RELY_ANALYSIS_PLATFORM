CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IML_REF_AM_PROD_CFG_INFO_H(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：资管产品配置信息历史
  **存储过程名称：    ETL_O_IML_REF_AM_PROD_CFG_INFO_H
  **存储过程创建日期：20241126
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20241126    YJY        创建
  ******************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := '0';             --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IML_REF_AM_PROD_CFG_INFO_H'; --程序名称
  V_TAB_NAME  VARCHAR2(500) := 'O_IML_REF_AM_PROD_CFG_INFO_H';     --表名
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IML_REF_AM_PROD_CFG_INFO_H';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-资管产品配置信息历史';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IML_REF_AM_PROD_CFG_INFO_H
  (     
      FINC_PROD_ID                      --理财产品编号
      ,LP_ID                          --法人编号
      ,ACCTNT_CLS                      --会计分类
      ,ASSET_ID                          --资产编号
      ,STAT_DT                          --统计日期
      ,PROD_TYPE                      --产品类型
      ,PROD_NAME                      --产品名称
      ,PROD_VALUE_DT                  --产品起息日期
      ,PROD_EXP_DT                      --产品到期日期
      ,PAID_IN_CAPITAL                  --实收资本
      ,CUST_YLD_RAT                      --客户收益率
      ,ASSET_TYPE                      --资产类型
      ,ASSET_NAME                      --资产名称
      ,FAC_VAL                          --面值
      ,BUY_NET_PRICE_COST                --买入净价成本
      ,INT_ADJ                          --利息调整
      ,FST_STL_AMT                      --首期结算金额
      ,EXP_STL_AMT                      --到期结算金额
      ,INT_RECVBL                      --应收利息
      ,ACRU_INT                          --应计利息
      ,BOND_EVLTION_NET_PRICE               --债券估值净价
      ,ASSET_IMPAM_AMT                  --资产减值金额
      ,EVHA_VAL_CHAG                  --公允价值变动
      ,FAC_VAL_INT_RAT                  --票面利率
      ,ACTL_INT_RAT                      --实际利率
      ,REPO_INT_RAT                      --回购利率
      ,ASSET_VALUE_DT                  --资产起息日期
      ,ASSET_MATU_DT                  --资产到期日期
      ,ISSUE_PRICE                      --发行价格
      ,PAY_INT_FREQ                      --付息频率
      ,RPP_FREQ                          --还本频率
      ,LAST_PAY_INT_DT                  --上一付息日期
      ,INT_ACCR_BASE                  --计息基准
      ,PAY_STATUS                      --支付状态
      ,LAST_INT_ACCR_BEGIN_DT              --上一计息起始日期
      ,LAST_INT_ACCR_END_DT                  --上一计息结束日期
      ,PRFT_TYPE_CD                      --收益类型代码
      ,G06_PENTE_BF_ASSET_CLS_CD      --G06穿透前资产分类代码
      ,G06_PENTE_POST_ASSET_CLS_CD      --G06穿透后资产分类代码
      ,EXP_YLD_RAT                      --到期收益率
      ,ASSET_LEVEL1_CLS_CD              --资产一级分类代码
      ,ASSET_LEVEL2_CLS_CD              --资产二级分类代码
      ,ASSET_LEVEL3_CLS_CD              --资产三级分类代码
      ,ASSET_LEVEL4_CLS_CD              --资产四级分类代码
      ,ETL_DT                          --ETL处理日期
      ,SRC_TABLE_NAME                  --源表名称
      ,JOB_CD                          --任务编码
      ,ETL_TIMESTAMP                  --ETL处理时间戳
    )
    SELECT
       FINC_PROD_ID                      --理财产品编号
      ,LP_ID                          --法人编号
      ,ACCTNT_CLS                      --会计分类
      ,ASSET_ID                          --资产编号
      ,STAT_DT                          --统计日期
      ,PROD_TYPE                      --产品类型
      ,PROD_NAME                      --产品名称
      ,PROD_VALUE_DT                  --产品起息日期
      ,PROD_EXP_DT                      --产品到期日期
      ,PAID_IN_CAPITAL                  --实收资本
      ,CUST_YLD_RAT                      --客户收益率
      ,ASSET_TYPE                      --资产类型
      ,ASSET_NAME                      --资产名称
      ,FAC_VAL                          --面值
      ,BUY_NET_PRICE_COST                --买入净价成本
      ,INT_ADJ                          --利息调整
      ,FST_STL_AMT                      --首期结算金额
      ,EXP_STL_AMT                      --到期结算金额
      ,INT_RECVBL                      --应收利息
      ,ACRU_INT                          --应计利息
      ,BOND_EVLTION_NET_PRICE               --债券估值净价
      ,ASSET_IMPAM_AMT                  --资产减值金额
      ,EVHA_VAL_CHAG                  --公允价值变动
      ,FAC_VAL_INT_RAT                  --票面利率
      ,ACTL_INT_RAT                      --实际利率
      ,REPO_INT_RAT                      --回购利率
      ,ASSET_VALUE_DT                  --资产起息日期
      ,ASSET_MATU_DT                  --资产到期日期
      ,ISSUE_PRICE                      --发行价格
      ,PAY_INT_FREQ                      --付息频率
      ,RPP_FREQ                          --还本频率
      ,LAST_PAY_INT_DT                  --上一付息日期
      ,INT_ACCR_BASE                  --计息基准
      ,PAY_STATUS                      --支付状态
      ,LAST_INT_ACCR_BEGIN_DT              --上一计息起始日期
      ,LAST_INT_ACCR_END_DT                  --上一计息结束日期
      ,PRFT_TYPE_CD                      --收益类型代码
      ,G06_PENTE_BF_ASSET_CLS_CD      --G06穿透前资产分类代码
      ,G06_PENTE_POST_ASSET_CLS_CD      --G06穿透后资产分类代码
      ,EXP_YLD_RAT                      --到期收益率
      ,ASSET_LEVEL1_CLS_CD              --资产一级分类代码
      ,ASSET_LEVEL2_CLS_CD              --资产二级分类代码
      ,ASSET_LEVEL3_CLS_CD              --资产三级分类代码
      ,ASSET_LEVEL4_CLS_CD              --资产四级分类代码
      ,ETL_DT                          --ETL处理日期
      ,SRC_TABLE_NAME                  --源表名称
      ,JOB_CD                          --任务编码
      ,ETL_TIMESTAMP                  --ETL处理时间戳
    FROM IML.V_REF_AM_PROD_CFG_INFO_H  --视图-资管产品配置信息历史
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IML_REF_AM_PROD_CFG_INFO_H', '', O_ERRCODE);

  INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
  VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
  COMMIT;
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

END ETL_O_IML_REF_AM_PROD_CFG_INFO_H;
/

