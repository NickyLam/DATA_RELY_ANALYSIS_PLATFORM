CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_RWAS_RPT_ASSET_MANAGER_RESULT(I_P_DATE IN INTEGER, --跑批日期
                                                                    O_ERRCODE OUT VARCHAR2 --错误代码
                                                                    )
 /*******************************************************************
  **存储过程详细说明：内部管理报表_资管产品计量明细
  **存储过程名称：    ETL_O_IOL_RWAS_RPT_ASSET_MANAGER_RESULT
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_RWAS_RPT_ASSET_MANAGER_RESULT'; --程序名称
  V_TAB_NAME  VARCHAR2(500) := 'O_IOL_RWAS_RPT_ASSET_MANAGER_RESULT';     --表名
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_RWAS_RPT_ASSET_MANAGER_RESULT';

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-内部管理报表_资管产品计量明细';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_RWAS_RPT_ASSET_MANAGER_RESULT NOLOGGING 
    (DATA_DATE                           --数据日期
    ,PK_COL                              --PK_COL
    ,LOAN_REF_NO                         --债项编号
    ,FUND_CD                             --资产管理产品编号
    ,FUND_NAME                           --资产管理产品名称
    ,SA_CALCULATE_ID                     --标准法计量方法标识
    ,SA_CALCULATE_NAME                   --标准法计量方法名称
    ,ON_OFF_ID                           --表内外标志
    ,ACCORG_NO                           --入账机构
    ,ACCORG_NAME                         --入账机构名称
    ,PRODUCT_CD                          --产品编号
    ,PRODUCT_NAME                        --产品名称
    ,FIVE_CLASS_NAME                     --五级分类名称
    ,OVERDUE_DAYS                        --逾期天数
    ,STD_DEFAULT_FLAG                    --逾期标志
    ,CUST_NO                             --客户号
    ,CUST_NAME                           --客户名称
    ,CCP_TYPE_CD                         --交易对手类型
    ,CCP_TYPE_NAME                       --交易对手类型名称
    ,SCALE_CD                            --企业规模代码
    ,SCALE_NAME                          --企业规模代码名称
    ,EAD_TOT                             --客户总风险暴露(万)
    ,FM_ASSET_AMT                        --资管产品总资产
    ,FM_HOLD_RATIO                       --资管产品持有比例
    ,FM_FIN_PRODUCT_AMT                  --资管产品净资产
    ,FM_LVG                              --资管产品杠杆率
    ,FM_RWA_CCP                          --资管产品CCP风险加权资产
    ,FM_RWA_CVA                          --资管产品CVA
    ,FM_FLAG                             --资管产品标志
    ,FM_AVG_RW                           --资管产品基础资产平均权重
    ,FM_ALVG_RW                          --资管产品调整杠杆率后的权重
    ,CCF                                 --表外信用风险转换系数
    ,CCY_CD                              --币种代码
    ,SUBJECT_CD                          --本金科目代码
    ,SUBJECT_NAME                        --本金科目名称
    ,PRIC_BAL_ORIGCURR                   --本金余额（原币）
    ,PRIC_BAL                            --本金余额（本币）
    ,ASSET_BALANCE                       --资产余额（本币）
    ,ACCRUED_SUBJECT_CD                  --应计利息科目
    ,ACCRUED_SUBJECT_NAME                --应计利息科目名称
    ,ACCRUED_INT                         --应计利息（本币）
    ,RECEIVABLE_SUBJECT_CD               --应收利息科目
    ,RECEIVABLE_SUBJECT_NAME             --应收利息科目名称
    ,RECEIVABLE_INT                      --应收利息（本币）
    ,ACCRUED_RECEIV_SUBJECT_CD           --应收未收利息科目
    ,ACCRUED_RECEIV_SUBJECT_NAME         --应收未收利息名称
    ,ACCRUED_RECEIV_INT                  --应收未收利息（本币）
    ,INTADJ_SUBJECT_CD                   --利息调整科目
    ,INTADJ_SUBJECT_NAME                 --利息调整科目名称
    ,INT_ADJ                             --利息调整（本币）
    ,FAIRCHANGE_SUBJECT_CD               --公允价值变动科目
    ,FAIRCHANGE_SUBJECT_NAME             --公允价值变动科目名称
    ,FAIRVALUE_CHANGES                   --公允价值变动（本币）
    ,PROVISION_SUBJECT_CD                --准备金科目代码
    ,PROVISION_SUBJECT_NAME              --准备金科目名称
    ,PROVISION                           --准备金（本币）
    ,PROVESION_RATIO                     --准备金计提比例
    ,EAD_ORIG                            --原始风险暴露本币
    ,EAD_PEN                             --穿透法扣减准备金后EAD
    ,RWA_PEN                             --穿透法RWA
    ,EAD_PEN_THIRD                       --第三方穿透法EAD
    ,RWA_PEN_THIRD                       --第三方穿透法RWA
    ,EAD_ABL                             --授权基础法扣减准备金后EAD
    ,RWA_ABL                             --授权基础法RWA
    ,EAD_PULLB                           --适用于1250%部分扣减准备金后EAD
    ,RWA_PULLB                           --适用于1250%部分RWA
    ,RWA_BEFORE_ADJ                      --调整前风险加权资产
    ,RWA_AFTER_ADJ                       --调整后风险加权资产
    ,ADJ_FLAG                            --是否调整标志
    ,G4B_R_ITEM_CODE                     --G4B-5项目
    ,INVESTMENT_VAILD_FLAG               --投资级认定是否在有效期内
    ,RECOGNITION_DATE                    --认定日期
    ,LOAD_DATE                           --加载日期
    ,ETL_DT                              --ETL处理日期
    ,ETL_TIMESTAMP                       --ETL处理时间戳
    )
  SELECT /*+PARALLEL*/
     DATA_DATE                           --数据日期
    ,PK_COL                              --PK_COL
    ,LOAN_REF_NO                         --债项编号
    ,FUND_CD                             --资产管理产品编号
    ,FUND_NAME                           --资产管理产品名称
    ,SA_CALCULATE_ID                     --标准法计量方法标识
    ,SA_CALCULATE_NAME                   --标准法计量方法名称
    ,ON_OFF_ID                           --表内外标志
    ,ACCORG_NO                           --入账机构
    ,ACCORG_NAME                         --入账机构名称
    ,PRODUCT_CD                          --产品编号
    ,PRODUCT_NAME                        --产品名称
    ,FIVE_CLASS_NAME                     --五级分类名称
    ,OVERDUE_DAYS                        --逾期天数
    ,STD_DEFAULT_FLAG                    --逾期标志
    ,CUST_NO                             --客户号
    ,CUST_NAME                           --客户名称
    ,CCP_TYPE_CD                         --交易对手类型
    ,CCP_TYPE_NAME                       --交易对手类型名称
    ,SCALE_CD                            --企业规模代码
    ,SCALE_NAME                          --企业规模代码名称
    ,EAD_TOT                             --客户总风险暴露(万)
    ,FM_ASSET_AMT                        --资管产品总资产
    ,FM_HOLD_RATIO                       --资管产品持有比例
    ,FM_FIN_PRODUCT_AMT                  --资管产品净资产
    ,FM_LVG                              --资管产品杠杆率
    ,FM_RWA_CCP                          --资管产品CCP风险加权资产
    ,FM_RWA_CVA                          --资管产品CVA
    ,FM_FLAG                             --资管产品标志
    ,FM_AVG_RW                           --资管产品基础资产平均权重
    ,FM_ALVG_RW                          --资管产品调整杠杆率后的权重
    ,CCF                                 --表外信用风险转换系数
    ,CCY_CD                              --币种代码
    ,SUBJECT_CD                          --本金科目代码
    ,SUBJECT_NAME                        --本金科目名称
    ,PRIC_BAL_ORIGCURR                   --本金余额（原币）
    ,PRIC_BAL                            --本金余额（本币）
    ,ASSET_BALANCE                       --资产余额（本币）
    ,ACCRUED_SUBJECT_CD                  --应计利息科目
    ,ACCRUED_SUBJECT_NAME                --应计利息科目名称
    ,ACCRUED_INT                         --应计利息（本币）
    ,RECEIVABLE_SUBJECT_CD               --应收利息科目
    ,RECEIVABLE_SUBJECT_NAME             --应收利息科目名称
    ,RECEIVABLE_INT                      --应收利息（本币）
    ,ACCRUED_RECEIV_SUBJECT_CD           --应收未收利息科目
    ,ACCRUED_RECEIV_SUBJECT_NAME         --应收未收利息名称
    ,ACCRUED_RECEIV_INT                  --应收未收利息（本币）
    ,INTADJ_SUBJECT_CD                   --利息调整科目
    ,INTADJ_SUBJECT_NAME                 --利息调整科目名称
    ,INT_ADJ                             --利息调整（本币）
    ,FAIRCHANGE_SUBJECT_CD               --公允价值变动科目
    ,FAIRCHANGE_SUBJECT_NAME             --公允价值变动科目名称
    ,FAIRVALUE_CHANGES                   --公允价值变动（本币）
    ,PROVISION_SUBJECT_CD                --准备金科目代码
    ,PROVISION_SUBJECT_NAME              --准备金科目名称
    ,PROVISION                           --准备金（本币）
    ,PROVESION_RATIO                     --准备金计提比例
    ,EAD_ORIG                            --原始风险暴露本币
    ,EAD_PEN                             --穿透法扣减准备金后EAD
    ,RWA_PEN                             --穿透法RWA
    ,EAD_PEN_THIRD                       --第三方穿透法EAD
    ,RWA_PEN_THIRD                       --第三方穿透法RWA
    ,EAD_ABL                             --授权基础法扣减准备金后EAD
    ,RWA_ABL                             --授权基础法RWA
    ,EAD_PULLB                           --适用于1250%部分扣减准备金后EAD
    ,RWA_PULLB                           --适用于1250%部分RWA
    ,RWA_BEFORE_ADJ                      --调整前风险加权资产
    ,RWA_AFTER_ADJ                       --调整后风险加权资产
    ,ADJ_FLAG                            --是否调整标志
    ,G4B_R_ITEM_CODE                     --G4B-5项目
    ,INVESTMENT_VAILD_FLAG               --投资级认定是否在有效期内
    ,RECOGNITION_DATE                    --认定日期
    ,LOAD_DATE                           --加载日期
    ,ETL_DT                              --ETL处理日期
    ,ETL_TIMESTAMP                       --ETL处理时间戳
    FROM IOL.V_RWAS_RPT_ASSET_MANAGER_RESULT  --内部管理报表_资管产品计量明细_视图
   WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD');

  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_RWAS_RPT_ASSET_MANAGER_RESULT', '', O_ERRCODE);

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

END ETL_O_IOL_RWAS_RPT_ASSET_MANAGER_RESULT;
/

