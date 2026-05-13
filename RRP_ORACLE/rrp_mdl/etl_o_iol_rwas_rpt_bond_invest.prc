CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_RWAS_RPT_BOND_INVEST(I_P_DATE IN INTEGER, --跑批日期
                                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                               )
 /*******************************************************************
  **存储过程详细说明：内部管理报表_债券投资
  **存储过程名称：    ETL_O_IOL_RWAS_RPT_BOND_INVEST
  **存储过程创建日期：20250910
  **存储过程创建人：  YUJINGYI
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：          O_ERRCODE
  ** 修改日期    修改人     修改原因
  ** 20250910    YJY        创建  
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
  V_PROC_NAME VARCHAR2(100) := 'ETL_O_IOL_RWAS_RPT_BOND_INVEST'; --程序名称
  V_SYSTEM    VARCHAR2(30)  := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP      := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_RWAS_RPT_BOND_INVEST';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],执行信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 程序业务逻辑处理主体部分 --
  V_STEP      := V_STEP + 1;
  V_STEP_DESC := '数据落地-内部管理报表_债券投资';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_RWAS_RPT_BOND_INVEST NOLOGGING 
  (        DATA_DATE                 --数据日期
          ,LOAN_REF_NO               --债项编号
          ,LOAN_REF_DESC             --债项描述
          ,CONTRACT_NO               --合同编号
          ,SRC_SYSTEM_ID             --来源系统标识
          ,ACCORG_NO                 --账务机构
          ,ACCORG_NAME               --账务机构名称
          ,FIVE_CLASS_CD             --五级分类代码
          ,FIVE_CLASS_NAME           --五级分类名称
          ,PRODUCT_CD                --产品代码
          ,PRODUCT_NAME              --产品名称
          ,BIS_PRODUCT_TYPE_CD       --监管产品类型代码
          ,BIS_PRODUCT_TYPE_NAME     --监管产品类型名称
          ,BIS_PRODUCT_BTYPE_CD      --监管产品大类代码
          ,BIS_PRODUCT_BTYPE_NAME    --监管产品大类名称
          ,BUSS_TYPE_CD              --业务类型
          ,BUSS_TYPE_NAME            --业务名称
          ,START_DATE                --起息日
          ,DUE_DATE                  --到期日期
          ,ORIG_MATURITY             --原始期限
          ,OVERDUE_DAYS              --逾期天数
          ,STD_DEFAULT_FLAG          --权重法违约标志
          ,BOOK_TYPE_ID              --账簿类型
          ,BOOK_TYPE_NAME            --账簿名称
          ,ON_OFF_ID                 --表内外资产标志
          ,BIS_CCY_CD                --计量币种代码
          ,BIS_CCY_NAME              --计量币种名称
          ,EXCHANGE_RATE             --汇率
          ,SUBJECT_CD                --本金科目代码
          ,SUBJECT_NAME              --本金科目名称
          ,PRIC_BAL_ORIGCURR         --本金余额（原币）
          ,PRIC_BAL                  --本金余额（本币）
          ,ASSET_BALANCE             --资产余额（本币）
          ,ACCRUED_SUBJECT_CD        --应计利息科目
          ,ACCRUED_SUBJECT_NAME      --应计利息科目名称
          ,ACCRUED_INT               --应计利息（本币）
          ,RECEIVABLE_SUBJECT_CD     --应收利息科目
          ,RECEIVABLE_SUBJECT_NAME   --应收利息科目名称
          ,RECEIVABLE_INT            --应收利息（本币）
          ,ACCRUED_RECEIV_SUBJECT_CD      --应收未收利息科目
          ,ACCRUED_RECEIV_SUBJECT_NAME    --应收未收利息名称
          ,ACCRUED_RECEIV_INT        --应收未收利息（本币）
          ,INTADJ_SUBJECT_CD         --利息调整科目
          ,INTADJ_SUBJECT_NAME       --利息调整科目名称
          ,INT_ADJ                   --利息调整（本币）
          ,FAIRCHANGE_SUBJECT_CD     --公允价值变动科目
          ,FAIRCHANGE_SUBJECT_NAME   --公允价值变动科目名称
          ,FAIRVALUE_CHANGES         --公允价值变动（本币）
          ,DEPREAMOR_SUBJECT_CD      --折旧科目
          ,DEPREAMOR_SUBJECT_NAME    --折旧科目名称
          ,DEPRE_AMORTIZAT           --折旧金额（本币）
          ,OTHER_SUBJECT_CD          --其他科目
          ,OTHER_SUBJECT_NAME        --其他科目名称
          ,OTHER_AMT                 --其他金额（本币）
          ,PROVISION_SUBJECT_CD      --准备金科目代码
          ,PROVISION_SUBJECT_NAME    --准备金科目名称
          ,PROVISION                 --准备金（本币）
          ,PROVESION_RATIO           --准备金计提比例
          ,ACCOUNT_CLASSIFICATION    --金融资产分类
          ,CUST_NO                   --客户号
          ,CUST_NAME                 --客户名称
          ,CCP_TYPE_CD               --交易对手类型代码
          ,CCP_TYPE_NAME             --交易对手类型名称
          ,CCP_BTYPE_CD              --交易对手大类代码
          ,CCP_BTYPE_NAME            --交易对手大类名称
          ,SPE_LENDING_FLAG          --专业贷款标志
          ,SPE_LENDING_TYPE          --专业贷款分类
          ,BIS_COUNTRY_NAME          --注册国名称
          ,SOV_SP_LT_RATING_CD       --注册国标普评级代码
          ,CUST_SP_LT_RATING_CD      --客户标普评级
          ,SCRA_RATING               --SCRA评级
          ,INT_TRADE_FLAG            --内部交易标志
          ,SOLO_INT_TRADE_FLAG       --法人内部交易标志
          ,INVESTMENT_CUST_FLAG      --投资级客户标志
          ,CCY_MISMATCH_FLAG         --币种错配标志
          ,ACCEPT_CREDIT_SELF_FLAG   --自开信用证标志
          ,REAL_ESTATE_TYPE_CD       --房地产风险暴露类型名称
          ,LTV                       --LTV规则
          ,ACCEPT_DISCOUNT_SELF_FLAG --自承自贴标志
          ,OPERATION_PF_FLAG         --项目融资运营阶段标识
          ,CANCEL_FLAG               --随时可撤销标志
          ,OFF_ASSET_UNMEASURED_FLAG --表外资产不计量标志
          ,UNUSED_PRL_TMEET_FLAG     --符合标准的未使用额度标志
          ,EAD_ORIG                  --原始风险暴露
          ,CCF                       --表外信用风险转换系数
          ,EAD_AFTERCCF              --转换后的风险暴露
          ,EAD_AFTERPRO              --扣减准备金后的风险暴露
          ,RW                        --权重
          ,CRM_CCY_MIS_FLAG          --是否存在缓释币种错配
          ,CRM_AMT_RMB               --缓释金额折本币
          ,CRM_AMT_SPLIT             --缓释金额拆分本币
          ,CRM_CCY_MIS_COEFF         --缓释币种错配折扣系数
          ,CRM_MAT_MIS_COEFF         --缓释期限错配系数
          ,CRM_FLOOR_MIS_COEFF       --底线折扣系数
          ,CRM_WEIGHTING_RW          --缓释加权权重
          ,RWA_UCOVERED              --缓释未覆盖部分的RWA
          ,RWA_COVERED               --缓释覆盖部分的RWA
          ,RWA                       --风险加权资产
          ,C_ITEM_E                  --现金类资产
          ,C_ITEM_F                  --我国中央政府
          ,C_ITEM_G                  --中国人民银行
          ,C_ITEM_H                  --我国开发性金融机构和政策性银行
          ,C_ITEM_I                  --省级（自治区、直辖市）及计划单列市人民政府-一般债券
          ,C_ITEM_J                  --省级（自治区、直辖市）及计划单列市人民政府-专项债券
          ,C_ITEM_K                  --其他收入主要源于中央财政的公共部门实体
          ,C_ITEM_L                  --经金融监管总局认定的我国一般公共部门实体
          ,C_ITEM_M                  --金融资产管理公司为收购国有银行不良贷款而定向发行的债券
          ,C_ITEM_N                  --评级AA-以上（含）的国家和地区的中央政府和中央银行
          ,C_ITEM_O                  --评级AA-以下，A-（含）以上的国家和地区的中央政府和中央银行
          ,C_ITEM_P                  --评级A-以下，BBB-（含）以上的国家和地区的中央政府和中央银行
          ,C_ITEM_Q                  --评级AA-（含）及以上国家和地区注册的公共部门实体
          ,C_ITEM_R                  --评级AA-以下，A-（含）以上国家和地区注册的公共部门实体
          ,C_ITEM_S                  --A+级和A级境内外商业银行（短期）
          ,C_ITEM_T                  --A+级境内外商业银行
          ,C_ITEM_U                  --A级境内外商业银行
          ,C_ITEM_V                  --合格多边开发银行
          ,C_ITEM_W                  --评级AA-（含）以上的其他多边开发银行
          ,C_ITEM_X                  --对评级AA-以下，A-（含）以上的其他多边开发银行
          ,C_ITEM_Y                  --评级A-以下，BBB-（含）以上的其他多边开发银行
          ,C_ITEM_Z                  --国际清算银行、国际货币基金组织、欧洲中央银行、欧盟、欧洲稳定机制和欧洲金融稳定机制
          ,REPORT_NO                 --报表编号
          ,REPORT_LINE_NO            --报表栏位号
          ,REPORT_LINE_NAME          --G4B栏位名称
          ,INVESTMENT_VAILD_FLAG     --投资级认定是否在有效期内
          ,RECOGNITION_DATE          --认定日期
          ,SEC_NO                    --债券编号
          ,SEC_NAME                  --债券名称
          ,LOAD_DATE                 --加载日期
          ,FINAL_WEIGHT              --最终风险权重
          ,NVESTMENT_REMA_MATURITY   --投资级认定剩余有效期限天数
          ,ETL_DT                    --ETL处理日期
          ,ETL_TIMESTAMP             --ETL处理时间戳
    )
    SELECT
           DATA_DATE                 --数据日期
          ,LOAN_REF_NO               --债项编号
          ,LOAN_REF_DESC             --债项描述
          ,CONTRACT_NO               --合同编号
          ,SRC_SYSTEM_ID             --来源系统标识
          ,ACCORG_NO                 --账务机构
          ,ACCORG_NAME               --账务机构名称
          ,FIVE_CLASS_CD             --五级分类代码
          ,FIVE_CLASS_NAME           --五级分类名称
          ,PRODUCT_CD                --产品代码
          ,PRODUCT_NAME              --产品名称
          ,BIS_PRODUCT_TYPE_CD       --监管产品类型代码
          ,BIS_PRODUCT_TYPE_NAME     --监管产品类型名称
          ,BIS_PRODUCT_BTYPE_CD      --监管产品大类代码
          ,BIS_PRODUCT_BTYPE_NAME    --监管产品大类名称
          ,BUSS_TYPE_CD              --业务类型
          ,BUSS_TYPE_NAME            --业务名称
          ,START_DATE                --起息日
          ,DUE_DATE                  --到期日期
          ,ORIG_MATURITY             --原始期限
          ,OVERDUE_DAYS              --逾期天数
          ,STD_DEFAULT_FLAG          --权重法违约标志
          ,BOOK_TYPE_ID              --账簿类型
          ,BOOK_TYPE_NAME            --账簿名称
          ,ON_OFF_ID                 --表内外资产标志
          ,BIS_CCY_CD                --计量币种代码
          ,BIS_CCY_NAME              --计量币种名称
          ,EXCHANGE_RATE             --汇率
          ,SUBJECT_CD                --本金科目代码
          ,SUBJECT_NAME              --本金科目名称
          ,PRIC_BAL_ORIGCURR         --本金余额（原币）
          ,PRIC_BAL                  --本金余额（本币）
          ,ASSET_BALANCE             --资产余额（本币）
          ,ACCRUED_SUBJECT_CD        --应计利息科目
          ,ACCRUED_SUBJECT_NAME      --应计利息科目名称
          ,ACCRUED_INT               --应计利息（本币）
          ,RECEIVABLE_SUBJECT_CD     --应收利息科目
          ,RECEIVABLE_SUBJECT_NAME   --应收利息科目名称
          ,RECEIVABLE_INT            --应收利息（本币）
          ,ACCRUED_RECEIV_SUBJECT_CD      --应收未收利息科目
          ,ACCRUED_RECEIV_SUBJECT_NAME    --应收未收利息名称
          ,ACCRUED_RECEIV_INT        --应收未收利息（本币）
          ,INTADJ_SUBJECT_CD         --利息调整科目
          ,INTADJ_SUBJECT_NAME       --利息调整科目名称
          ,INT_ADJ                   --利息调整（本币）
          ,FAIRCHANGE_SUBJECT_CD     --公允价值变动科目
          ,FAIRCHANGE_SUBJECT_NAME   --公允价值变动科目名称
          ,FAIRVALUE_CHANGES         --公允价值变动（本币）
          ,DEPREAMOR_SUBJECT_CD      --折旧科目
          ,DEPREAMOR_SUBJECT_NAME    --折旧科目名称
          ,DEPRE_AMORTIZAT           --折旧金额（本币）
          ,OTHER_SUBJECT_CD          --其他科目
          ,OTHER_SUBJECT_NAME        --其他科目名称
          ,OTHER_AMT                 --其他金额（本币）
          ,PROVISION_SUBJECT_CD      --准备金科目代码
          ,PROVISION_SUBJECT_NAME    --准备金科目名称
          ,PROVISION                 --准备金（本币）
          ,PROVESION_RATIO           --准备金计提比例
          ,ACCOUNT_CLASSIFICATION    --金融资产分类
          ,CUST_NO                   --客户号
          ,CUST_NAME                 --客户名称
          ,CCP_TYPE_CD               --交易对手类型代码
          ,CCP_TYPE_NAME             --交易对手类型名称
          ,CCP_BTYPE_CD              --交易对手大类代码
          ,CCP_BTYPE_NAME            --交易对手大类名称
          ,SPE_LENDING_FLAG          --专业贷款标志
          ,SPE_LENDING_TYPE          --专业贷款分类
          ,BIS_COUNTRY_NAME          --注册国名称
          ,SOV_SP_LT_RATING_CD       --注册国标普评级代码
          ,CUST_SP_LT_RATING_CD      --客户标普评级
          ,SCRA_RATING               --SCRA评级
          ,INT_TRADE_FLAG            --内部交易标志
          ,SOLO_INT_TRADE_FLAG       --法人内部交易标志
          ,INVESTMENT_CUST_FLAG      --投资级客户标志
          ,CCY_MISMATCH_FLAG         --币种错配标志
          ,ACCEPT_CREDIT_SELF_FLAG   --自开信用证标志
          ,REAL_ESTATE_TYPE_CD       --房地产风险暴露类型名称
          ,LTV                       --LTV规则
          ,ACCEPT_DISCOUNT_SELF_FLAG --自承自贴标志
          ,OPERATION_PF_FLAG         --项目融资运营阶段标识
          ,CANCEL_FLAG               --随时可撤销标志
          ,OFF_ASSET_UNMEASURED_FLAG --表外资产不计量标志
          ,UNUSED_PRL_TMEET_FLAG     --符合标准的未使用额度标志
          ,EAD_ORIG                  --原始风险暴露
          ,CCF                       --表外信用风险转换系数
          ,EAD_AFTERCCF              --转换后的风险暴露
          ,EAD_AFTERPRO              --扣减准备金后的风险暴露
          ,RW                        --权重
          ,CRM_CCY_MIS_FLAG          --是否存在缓释币种错配
          ,CRM_AMT_RMB               --缓释金额折本币
          ,CRM_AMT_SPLIT             --缓释金额拆分本币
          ,CRM_CCY_MIS_COEFF         --缓释币种错配折扣系数
          ,CRM_MAT_MIS_COEFF         --缓释期限错配系数
          ,CRM_FLOOR_MIS_COEFF       --底线折扣系数
          ,CRM_WEIGHTING_RW          --缓释加权权重
          ,RWA_UCOVERED              --缓释未覆盖部分的RWA
          ,RWA_COVERED               --缓释覆盖部分的RWA
          ,RWA                       --风险加权资产
          ,C_ITEM_E                  --现金类资产
          ,C_ITEM_F                  --我国中央政府
          ,C_ITEM_G                  --中国人民银行
          ,C_ITEM_H                  --我国开发性金融机构和政策性银行
          ,C_ITEM_I                  --省级（自治区、直辖市）及计划单列市人民政府-一般债券
          ,C_ITEM_J                  --省级（自治区、直辖市）及计划单列市人民政府-专项债券
          ,C_ITEM_K                  --其他收入主要源于中央财政的公共部门实体
          ,C_ITEM_L                  --经金融监管总局认定的我国一般公共部门实体
          ,C_ITEM_M                  --金融资产管理公司为收购国有银行不良贷款而定向发行的债券
          ,C_ITEM_N                  --评级AA-以上（含）的国家和地区的中央政府和中央银行
          ,C_ITEM_O                  --评级AA-以下，A-（含）以上的国家和地区的中央政府和中央银行
          ,C_ITEM_P                  --评级A-以下，BBB-（含）以上的国家和地区的中央政府和中央银行
          ,C_ITEM_Q                  --评级AA-（含）及以上国家和地区注册的公共部门实体
          ,C_ITEM_R                  --评级AA-以下，A-（含）以上国家和地区注册的公共部门实体
          ,C_ITEM_S                  --A+级和A级境内外商业银行（短期）
          ,C_ITEM_T                  --A+级境内外商业银行
          ,C_ITEM_U                  --A级境内外商业银行
          ,C_ITEM_V                  --合格多边开发银行
          ,C_ITEM_W                  --评级AA-（含）以上的其他多边开发银行
          ,C_ITEM_X                  --对评级AA-以下，A-（含）以上的其他多边开发银行
          ,C_ITEM_Y                  --评级A-以下，BBB-（含）以上的其他多边开发银行
          ,C_ITEM_Z                  --国际清算银行、国际货币基金组织、欧洲中央银行、欧盟、欧洲稳定机制和欧洲金融稳定机制
          ,REPORT_NO                 --报表编号
          ,REPORT_LINE_NO            --报表栏位号
          ,REPORT_LINE_NAME          --G4B栏位名称
          ,INVESTMENT_VAILD_FLAG     --投资级认定是否在有效期内
          ,RECOGNITION_DATE          --认定日期
          ,SEC_NO                    --债券编号
          ,SEC_NAME                  --债券名称
          ,LOAD_DATE                 --加载日期
          ,FINAL_WEIGHT              --最终风险权重
          ,NVESTMENT_REMA_MATURITY   --投资级认定剩余有效期限天数
          ,ETL_DT                    --ETL处理日期
          ,ETL_TIMESTAMP             --ETL处理时间戳
  FROM IOL.V_RWAS_RPT_BOND_INVEST --视图-内部管理报表_债券投资
 WHERE ETL_DT = TO_DATE(V_P_DATE,'YYYYMMDD') ;
    
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG   := '返回值：[' || SQLCODE || '],描述信息：' || SQLERRM;
  O_ERRCODE  := '0';
  V_ENDTIME  := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

  -- 如需要分析表，请用如下代码 --
  -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
  ETL_DBMS_STATS(V_P_DATE, 'O_IOL_RWAS_RPT_BOND_INVEST', '', O_ERRCODE);

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

END ETL_O_IOL_RWAS_RPT_BOND_INVEST;
/

