CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_RWAS_RPT_TRAN_SECURITIES(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：内部管理报表_交易债券
  **存储过程名称：    ETL_O_IOL_RWAS_RPT_TRAN_SECURITIES
  **存储过程创建日期：20241127
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20241127    YJY        创建
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_RWAS_RPT_TRAN_SECURITIES'; --程序名称
  V_TAB_NAME  VARCHAR2(500) := 'O_IOL_RWAS_RPT_TRAN_SECURITIES';     --表名
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_RWAS_RPT_TRAN_SECURITIES';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-内部管理报表_交易债券';
  V_STARTTIME := SYSDATE;
  INSERT INTO RRP_MDL.O_IOL_RWAS_RPT_TRAN_SECURITIES
  (     
      DATA_DATE                    --数据日期
     ,LOAN_REF_NO                  --借据号
     ,SEC_NO                       --债券编号
     ,SEC_NAME                     --债券名称
     ,PRODUCT_NO                   --标准产品编号
     ,PRODUCT_NAME                 --标准产品名称
     ,LOAN_REF_DESC                --债项描述
     ,TRADETYPEID                  --多空头标志
     ,ASSET_THD_CLS_CD             --金融资产分类
     ,S_GRADE                      --主体评级
     ,GRADE                        --债券评级
     ,INT_RAT_ADJ_WAY_CD           --利率类别
     ,COUPON                       --债券利率
     ,START_DATE                   --起息日
     ,DUE_DATE                     --到期日期
     ,NEXT_REVAL_DATE              --下一重定价日期
     ,REMA__REVAL_DATE             --剩余重定价期限(月)
     ,REMAININGMATURITY            --剩余期限(月)
     ,ORG_CD                       --入账机构编号
     ,ORG_NAME                     --入账机构名称
     ,CUST_NO                      --发行人客户号
     ,CUST_NAME                    --发行人名称
     ,CCP_TYPE_CD                  --交易对手类型
     ,CCP_TYPE_NAME                --交易对手类型名称
     ,SEC_TYPE_CD                  --债券类型
     ,SUBJECT_CD                   --本金科目代码
     ,SUBJECT_NAME                 --本金科目名称
     ,ACCRUED_SUBJECT_CD           --应计利息科目
     ,ACCRUED_SUBJECT_NAME         --应计利息科目名称
     ,RECEIVABLE_SUBJECT_CD        --应收利息科目
     ,RECEIVABLE_SUBJECT_NAME      --应收利息科目名称
     ,ACCRUED_RECEIV_SUBJECT_CD    --应收未收利息科目
     ,ACCRUED_RECEIV_SUBJECT_NAME  --应收未收利息名称
     ,INTADJ_SUBJECT_CD            --利息调整科目
     ,INTADJ_SUBJECT_NAME          --利息调整科目名称
     ,FAIRCHANGE_SUBJECT_CD        --公允价值变动科目
     ,FAIRCHANGE_SUBJECT_NAME      --公允价值变动科目名称
     ,PROVISION_SUBJECT_CD         --准备金科目代码
     ,PROVISION_SUBJECT_NAME       --准备金科目名称
     ,CCY_CD                       --币种代码
     ,CCY_NAME                     --币种名称
     ,BALANCE                      --本金余额(原币)
     ,BALANCE_HCURR                --本金余额(本币)
     ,RECEIVABLE_INT               --应收利息(本币)
     ,ACCRUED_RECEIV_INT           --应收未收利息（本币）
     ,ACCRUED_INT                  --应计利息(本币)
     ,INT_ADJ                      --利息调整(本币)
     ,FAIR_VALUE_CHANGE            --公允价值变动(本币)
     ,PROVISION                    --计提准备金(本币)
     ,ASSET_BALANCE                --资产余额(本币）
     ,EAD_ORIG                     --原始风险暴露（本币）
     ,RATE_SEC_TYPE_CD             --特定利率风险债券类型
     ,SPECIFIC_RISK_RATIO          --利率特定风险资本计提比率
     ,SPEC_RISK_CAPITAL_AMOUNT     --利率特定风险资本
     ,COUPON_FLAG                  --年息票率大于等于3%标志
     ,MAT_BUCKETID                 --时段
     ,SPECIFIC_RISK_CHARGE         --风险权重
     ,EXPOSUREAMOUNT               --一般市场风险的资本要求总额
     ,GENERAL_RISK_CAPITAL_AMOUNT  --一般利率风险资本
     ,DUE_DATE_RISK                --到期日风险资本
     ,RWAAMOUNT                    --RWA
     ,SCRA_RATING                  --SCRA评级
     ,ORIG_MATURITY                --原始期限
     ,LOAD_DATE                    --加载日期
     ,ETL_DT                       --ETL处理日期
     ,ETL_TIMESTAMP                --ETL处理时间戳
    )
    SELECT
      DATA_DATE                    --数据日期
     ,LOAN_REF_NO                  --借据号
     ,SEC_NO                       --债券编号
     ,SEC_NAME                     --债券名称
     ,PRODUCT_NO                   --标准产品编号
     ,PRODUCT_NAME                 --标准产品名称
     ,LOAN_REF_DESC                --债项描述
     ,TRADETYPEID                  --多空头标志
     ,ASSET_THD_CLS_CD             --金融资产分类
     ,S_GRADE                      --主体评级
     ,GRADE                        --债券评级
     ,INT_RAT_ADJ_WAY_CD           --利率类别
     ,COUPON                       --债券利率
     ,START_DATE                   --起息日
     ,DUE_DATE                     --到期日期
     ,NEXT_REVAL_DATE              --下一重定价日期
     ,REMA__REVAL_DATE             --剩余重定价期限(月)
     ,REMAININGMATURITY            --剩余期限(月)
     ,ORG_CD                       --入账机构编号
     ,ORG_NAME                     --入账机构名称
     ,CUST_NO                      --发行人客户号
     ,CUST_NAME                    --发行人名称
     ,CCP_TYPE_CD                  --交易对手类型
     ,CCP_TYPE_NAME                --交易对手类型名称
     ,SEC_TYPE_CD                  --债券类型
     ,SUBJECT_CD                   --本金科目代码
     ,SUBJECT_NAME                 --本金科目名称
     ,ACCRUED_SUBJECT_CD           --应计利息科目
     ,ACCRUED_SUBJECT_NAME         --应计利息科目名称
     ,RECEIVABLE_SUBJECT_CD        --应收利息科目
     ,RECEIVABLE_SUBJECT_NAME      --应收利息科目名称
     ,ACCRUED_RECEIV_SUBJECT_CD    --应收未收利息科目
     ,ACCRUED_RECEIV_SUBJECT_NAME  --应收未收利息名称
     ,INTADJ_SUBJECT_CD            --利息调整科目
     ,INTADJ_SUBJECT_NAME          --利息调整科目名称
     ,FAIRCHANGE_SUBJECT_CD        --公允价值变动科目
     ,FAIRCHANGE_SUBJECT_NAME      --公允价值变动科目名称
     ,PROVISION_SUBJECT_CD         --准备金科目代码
     ,PROVISION_SUBJECT_NAME       --准备金科目名称
     ,CCY_CD                       --币种代码
     ,CCY_NAME                     --币种名称
     ,BALANCE                      --本金余额(原币)
     ,BALANCE_HCURR                --本金余额(本币)
     ,RECEIVABLE_INT               --应收利息(本币)
     ,ACCRUED_RECEIV_INT           --应收未收利息（本币）
     ,ACCRUED_INT                  --应计利息(本币)
     ,INT_ADJ                      --利息调整(本币)
     ,FAIR_VALUE_CHANGE            --公允价值变动(本币)
     ,PROVISION                    --计提准备金(本币)
     ,ASSET_BALANCE                --资产余额(本币）
     ,EAD_ORIG                     --原始风险暴露（本币）
     ,RATE_SEC_TYPE_CD             --特定利率风险债券类型
     ,SPECIFIC_RISK_RATIO          --利率特定风险资本计提比率
     ,SPEC_RISK_CAPITAL_AMOUNT     --利率特定风险资本
     ,COUPON_FLAG                  --年息票率大于等于3%标志
     ,MAT_BUCKETID                 --时段
     ,SPECIFIC_RISK_CHARGE         --风险权重
     ,EXPOSUREAMOUNT               --一般市场风险的资本要求总额
     ,GENERAL_RISK_CAPITAL_AMOUNT  --一般利率风险资本
     ,DUE_DATE_RISK                --到期日风险资本
     ,RWAAMOUNT                    --RWA
     ,SCRA_RATING                  --SCRA评级
     ,ORIG_MATURITY                --原始期限
     ,LOAD_DATE                    --加载日期
     ,ETL_DT                       --ETL处理日期
     ,ETL_TIMESTAMP                --ETL处理时间戳
    FROM IOL.V_RWAS_RPT_TRAN_SECURITIES  --视图-内部管理报表_交易债券
    WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_RWAS_RPT_TRAN_SECURITIES', '', O_ERRCODE);

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

END ETL_O_IOL_RWAS_RPT_TRAN_SECURITIES;
/

