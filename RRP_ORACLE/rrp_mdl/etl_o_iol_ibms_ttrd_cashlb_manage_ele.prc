CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_IBMS_TTRD_CASHLB_MANAGE_ELE(I_P_DATE IN INTEGER, --跑批日期
                                                 O_ERRCODE  OUT VARCHAR2 --错误代码
                                                 )
 /*******************************************************************
  **存储过程详细说明：
  **存储过程名称：    ETL_O_IOL_IBMS_TTRD_CASHLB_MANAGE_ELE
  **存储过程创建日期：20221128
  **存储过程创建人：  HULIJUAN
  **输入参数：        I_P_DATE
  **输出参数：        O_ERRCODE
  **返回值：           O_ERRCODE
  ** 修改日期    修改人     修改原因
  *  20241220    YJY        优化脚本
  *  20251114    YJY        新增字段
  ******************************************************************/
 AS
  -- 定义变量 --

  V_STEP      INTEGER := '0'; -- 处理步骤
  V_P_DATE    VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME   DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_IBMS_TTRD_CASHLB_MANAGE_ELE'; -- 程序名称
  V_SYSTEM VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
  BEGIN

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  O_ERRCODE := '0';


  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE O_IOL_IBMS_TTRD_CASHLB_MANAGE_ELE';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
  
  
  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1; -- 小于10步骤直接写数字，大于10步用V_STEP := V_STEP + 1;描述每一步骤的作用，如加工处理核心系统个人客户信息。
  V_STEP_DESC := '数据落地-POS商户信息';
  V_STARTTIME := SYSDATE;
   INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_CASHLB_MANAGE_ELE NOLOGGING
    (    
        I_CODE			             --金融工具代码
        ,A_TYPE			             --资产类型
        ,M_TYPE			             --市场类型
        ,COUPON			             --执行利率
        ,FINAL_USE_COMP			     --最终用款企业
        ,BUSINESS_CATEGORY			 --行业归属
        ,IS_TWO_HIGH_ONE_LEFT		 --是否“两高一剩”，1是，0否
        ,IS_GOVERNMENT_PLATFORM	 --是否政府融资平台，1是，0否
        ,IS_INDUSTRY_FUND			   --是否产业基金，1是，0否
        ,OUT_GRADE		       	   --外部评级
        ,IN_GRADE			           --内部评级
        ,IN_GRADE_MTR_DATE			 --内部评级到期日
        ,COMP_AREA_PROVINCE			 --用款企业所属区域（省）
        ,COMP_AREA_CITY			     --用款企业所属区域（市）
        ,IS_CONVERT_DEBT_PRO		 --是否投向市场化债转股相关产品
        ,UND_ASSET_TYPE_OPT			 --底层资产类型
        ,MANAGEMENT_MODE			   --管理方式
        ,IS_ENTRUSTED_LOAN			 --是否委托贷款
        ,NUM_OF_CARRIES			     --spv载体个数
        ,APPROVAL_ID			       --核准件编号
        ,TOTAL_GOODS_AMOUNT			 --产品总金额
        ,APPROVAL_AMOUNT			   --批复金额
        ,RISK_WEIGHT			       --风险权重
        ,IS_MULTI_FINANCIER			 --是否多融资人
        ,ACTUAL_FINANCIER_ID		 --实际融资人客户号
        ,FINANCIER_NATURE			   --实际融资人客户性质
        ,PARENT_GROUP			       --实际融资人所属集团
        ,IS_ASSET_BASE_SECURITIES			--是否资产证券化产品
        ,IS_CREDIT_ITEM			     --是否信贷类项目
        ,INVESTMENT_TYPE			   --按投资产品类型划分
        ,RAISE_WAY			         --产品募集方式
        ,RISK_ASSETS_WEIGHT			 --风险权重
        ,RISKY_ASSETS_CLASSIFY	 --风险资产分类
        ,G31_CLASSIFY			       --g31产品分类
        ,FINAL_USE_COMP_RELEVANCE_INFO			--最终用款企业关联方信息(华兴需求)
        ,BUSINESS_CATEGORY_MIN	 --行业细类
        ,MITIGATION_FREQ			   --缓释频率
        ,NOT_UNDASSET_TYPE			 --非底层资产分类
        ,NOT_UNDASSET_TYPE_TWO	 --非底层资产分类2
        ,INVEST_FUND_PART			   --投向产业基金的部分
        ,INVEST_MARKET_PART			 --投向市场化债转股相关产品的部分
        ,INVEST_FINANCE_FORMANAGEPART			 --投向金融资产投资公司发行的私募资产管理产品
        ,INVEST_FINANCE_FORCAPITALPART		 --投向金融资产投资公司或其附属机构发行的私募股权投资基金
        ,IS_UNDASSET_LOAN			   --底层资产是否为投放贷款
        ,MIDDLE_CLASS			       --业务种类
        ,IS_EQUITY_PRODUCT			 --是否为净值型产品
        ,SPECIAL_PURPOSE_VEHICLE_TYPE			--特定目的载体类型
        ,ASSET_PRODUCT_STATISTICS_CODE		--资管产品统计编码
        ,ISSUER_REGION_CODE			 --发行人地区代码
        ,EXCUTE_MODE			       --运行方式
        ,SPECIAL_PURPOSE_VEHICLE_CODE			--特定目的载体代码
        ,ISSUER_CODE			       --发行人代码
        ,ENSURE_CODES			
        ,IS_NONSTANDARD			
        ,IS_PUBLICOFFER			
        ,FUND_USE			           --资金用途和来源
        ,IS_DECIDE_OPENBUSINESS	 --是否定开业务
        ,OPENBUSINESS_BEGDATE		 --开放周期
        ,EXCUTE_MODE_HX		       --运行方式（华兴）
        ,SPECIAL_PURPOSE_VEHICLE_HX			--特定目的载体代码（华兴）
        ,PRODUCT_MANAGER			   --产品管理方
        ,GUARANTEE_DESCRIPTION	 --担保描述
        ,INVESTMENT_DIRECTION_MAX			--资金投向大类
        ,INVESTMENT_DIRECTION_MIN			--资金投向小类
        ,UNDER_DEBT_CLASS			   --底层为债券的债券分类
        ,UNDER_DEBT_RATING		 	 --底层为债券的评级
        ,IS_GOVERMENT_INVEST_FUND --是否政府投资基金
        ,IS_PIONEER_INVEST_FUND	 --是否创业投资基金
        ,IS_REMOTE_BUSINESS			 --是否异地业务
        ,IS_LOCAL_GOVER_INVEST_PLATFORM			--是否地方政府融资平台
        ,ADD_CREDIT_WAY			     --增信方式
        ,ADD_CREDIT_SUBJECT_NAME --增信主体名称
        ,UPDATE_TIME		       	 --更新时间
        ,SCALE			             --企业规模
        ,PAY_MODE			           --还本付息方式
        ,INDUSTRY_FUND_AMOUNT		 --投向产业基金部分金额
        ,TRADE_PLATFORM			     --交易平台
        ,IS_OVER_CAPACITY			   --是否产能过剩行业
        ,IS_SHAREHOLDER			     --是否本行股东及其关联方
        ,STRUCTURE_TYPE			     --产品结构类型
        ,PRODUCT_SIZE			       --产品总规模
        ,SENIOR_SIZE			       --劣后规模
        ,INVESTMENT_SHARE_TYPE	 --我行投资份额属于优先还是夹层
        ,PRIVATE_FUND_AMOUNT		 --投向金融资产投资公司或其附属机构发行的私募股权投资基金金额
        ,PRIVATE_PRODUCT_AMOUNT	 --投向金融资产投资公司发行的私募资产管理产品金额
        ,BUSINESS_CATEGORY_MID	 --投向行业中类
        ,THROUGH_TYPE			       --穿透类型
        ,IS_INVEST_DEBT			     --是否投向市场化债转股
        ,IS_CONSUMER_SERVICE		 --是否为消费服务类融资
        ,BUSINESS_CATEGORY_SMALL --投向行业细类
        ,IS_ASSET_SECU			     --是否资产支持证券(1:是 0:否）
        ,IS_NO_GRADE_SECU			   --是否无评级资产证券化(1:是 0:否）
        ,START_DT			           --起始日期
        ,END_DT			             --截止日期
        ,ID_MARK			           --增删标志
        ,IS_GREEN_FINANCE        --是否属于绿色融资  ADD BY YJY 20251114
        ,FIRST_OPTION_TYPE       --  ADD BY YJY 20251114
        ,SECOND_OPTION_TYPE       --  ADD BY YJY 20251114
    )
  SELECT /*+PARALLEL*/
       I_CODE			             --金融工具代码
        ,A_TYPE			             --资产类型
        ,M_TYPE			             --市场类型
        ,COUPON			             --执行利率
        ,FINAL_USE_COMP			     --最终用款企业
        ,BUSINESS_CATEGORY			 --行业归属
        ,IS_TWO_HIGH_ONE_LEFT		 --是否“两高一剩”，1是，0否
        ,IS_GOVERNMENT_PLATFORM	 --是否政府融资平台，1是，0否
        ,IS_INDUSTRY_FUND			   --是否产业基金，1是，0否
        ,OUT_GRADE		       	   --外部评级
        ,IN_GRADE			           --内部评级
        ,IN_GRADE_MTR_DATE			 --内部评级到期日
        ,COMP_AREA_PROVINCE			 --用款企业所属区域（省）
        ,COMP_AREA_CITY			     --用款企业所属区域（市）
        ,IS_CONVERT_DEBT_PRO		 --是否投向市场化债转股相关产品
        ,UND_ASSET_TYPE_OPT			 --底层资产类型
        ,MANAGEMENT_MODE			   --管理方式
        ,IS_ENTRUSTED_LOAN			 --是否委托贷款
        ,NUM_OF_CARRIES			     --spv载体个数
        ,APPROVAL_ID			       --核准件编号
        ,TOTAL_GOODS_AMOUNT			 --产品总金额
        ,APPROVAL_AMOUNT			   --批复金额
        ,RISK_WEIGHT			       --风险权重
        ,IS_MULTI_FINANCIER			 --是否多融资人
        ,ACTUAL_FINANCIER_ID		 --实际融资人客户号
        ,FINANCIER_NATURE			   --实际融资人客户性质
        ,PARENT_GROUP			       --实际融资人所属集团
        ,IS_ASSET_BASE_SECURITIES			--是否资产证券化产品
        ,IS_CREDIT_ITEM			     --是否信贷类项目
        ,INVESTMENT_TYPE			   --按投资产品类型划分
        ,RAISE_WAY			         --产品募集方式
        ,RISK_ASSETS_WEIGHT			 --风险权重
        ,RISKY_ASSETS_CLASSIFY	 --风险资产分类
        ,G31_CLASSIFY			       --g31产品分类
        ,FINAL_USE_COMP_RELEVANCE_INFO			--最终用款企业关联方信息(华兴需求)
        ,BUSINESS_CATEGORY_MIN	 --行业细类
        ,MITIGATION_FREQ			   --缓释频率
        ,NOT_UNDASSET_TYPE			 --非底层资产分类
        ,NOT_UNDASSET_TYPE_TWO	 --非底层资产分类2
        ,INVEST_FUND_PART			   --投向产业基金的部分
        ,INVEST_MARKET_PART			 --投向市场化债转股相关产品的部分
        ,INVEST_FINANCE_FORMANAGEPART			 --投向金融资产投资公司发行的私募资产管理产品
        ,INVEST_FINANCE_FORCAPITALPART		 --投向金融资产投资公司或其附属机构发行的私募股权投资基金
        ,IS_UNDASSET_LOAN			   --底层资产是否为投放贷款
        ,MIDDLE_CLASS			       --业务种类
        ,IS_EQUITY_PRODUCT			 --是否为净值型产品
        ,SPECIAL_PURPOSE_VEHICLE_TYPE			--特定目的载体类型
        ,ASSET_PRODUCT_STATISTICS_CODE		--资管产品统计编码
        ,ISSUER_REGION_CODE			 --发行人地区代码
        ,EXCUTE_MODE			       --运行方式
        ,SPECIAL_PURPOSE_VEHICLE_CODE			--特定目的载体代码
        ,ISSUER_CODE			       --发行人代码
        ,ENSURE_CODES			
        ,IS_NONSTANDARD			
        ,IS_PUBLICOFFER			
        ,FUND_USE			           --资金用途和来源
        ,IS_DECIDE_OPENBUSINESS	 --是否定开业务
        ,OPENBUSINESS_BEGDATE		 --开放周期
        ,EXCUTE_MODE_HX		       --运行方式（华兴）
        ,SPECIAL_PURPOSE_VEHICLE_HX			--特定目的载体代码（华兴）
        ,PRODUCT_MANAGER			   --产品管理方
        ,GUARANTEE_DESCRIPTION	 --担保描述
        ,INVESTMENT_DIRECTION_MAX			--资金投向大类
        ,INVESTMENT_DIRECTION_MIN			--资金投向小类
        ,UNDER_DEBT_CLASS			   --底层为债券的债券分类
        ,UNDER_DEBT_RATING		 	 --底层为债券的评级
        ,IS_GOVERMENT_INVEST_FUND --是否政府投资基金
        ,IS_PIONEER_INVEST_FUND	 --是否创业投资基金
        ,IS_REMOTE_BUSINESS			 --是否异地业务
        ,IS_LOCAL_GOVER_INVEST_PLATFORM			--是否地方政府融资平台
        ,ADD_CREDIT_WAY			     --增信方式
        ,ADD_CREDIT_SUBJECT_NAME --增信主体名称
        ,UPDATE_TIME		       	 --更新时间
        ,SCALE			             --企业规模
        ,PAY_MODE			           --还本付息方式
        ,INDUSTRY_FUND_AMOUNT		 --投向产业基金部分金额
        ,TRADE_PLATFORM			     --交易平台
        ,IS_OVER_CAPACITY			   --是否产能过剩行业
        ,IS_SHAREHOLDER			     --是否本行股东及其关联方
        ,STRUCTURE_TYPE			     --产品结构类型
        ,PRODUCT_SIZE			       --产品总规模
        ,SENIOR_SIZE			       --劣后规模
        ,INVESTMENT_SHARE_TYPE	 --我行投资份额属于优先还是夹层
        ,PRIVATE_FUND_AMOUNT		 --投向金融资产投资公司或其附属机构发行的私募股权投资基金金额
        ,PRIVATE_PRODUCT_AMOUNT	 --投向金融资产投资公司发行的私募资产管理产品金额
        ,BUSINESS_CATEGORY_MID	 --投向行业中类
        ,THROUGH_TYPE			       --穿透类型
        ,IS_INVEST_DEBT			     --是否投向市场化债转股
        ,IS_CONSUMER_SERVICE		 --是否为消费服务类融资
        ,BUSINESS_CATEGORY_SMALL --投向行业细类
        ,IS_ASSET_SECU			     --是否资产支持证券(1:是 0:否）
        ,IS_NO_GRADE_SECU			   --是否无评级资产证券化(1:是 0:否）
        ,START_DT			           --起始日期
        ,END_DT			             --截止日期
        ,ID_MARK			           --增删标志
        ,IS_GREEN_FINANCE        --是否属于绿色融资  ADD BY YJY 20251114
        ,FIRST_OPTION_TYPE       --  ADD BY YJY 20251114
        ,SECOND_OPTION_TYPE       --  ADD BY YJY 20251114
    FROM IOL.V_IBMS_TTRD_CASHLB_MANAGE_ELE   --视图
    WHERE ID_MARK <> 'D'
   ;
   
   V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);
   
   
 -- 如需要分析表，请用如下代码 --
   -- DBMS_STATS.GATHER_TABLE_STATS(OWNNAME=>'写上数据库用户名',TABLENAME => '写上表名字',PARTNAME => 'P_'||V_P_DATE||'',DEGREE => 16,CASCATE => TRUE);
   --ETL_DBMS_STATS(V_P_DATE, V_TAB_NAME, ‘, O_ERRCODE);

   INSERT INTO RRP_MDL.ETL_STATE(ETL_DATE, PROC_NAME,END_TIME)
   VALUES (V_P_DATE,V_PROC_NAME,TO_CHAR(SYSTIMESTAMP,'YYYYMMDD HH24:MI:SS'));
   COMMIT;
   ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,V_SQLMSG);

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


END ETL_O_IOL_IBMS_TTRD_CASHLB_MANAGE_ELE;
/

