CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_IBMS_TBND(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_IBMS_TBND
  *  功能描述：中国债券信用评级表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_IBMS_TBND
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_IBMS_TBND'; -- 程序名称
  V_P_DATE  VARCHAR2(8); -- 跑批数据日期
  V_STARTTIME DATE; -- 处理开始时间
  V_ENDTIME DATE;   -- 处理结束时间
  V_SQLCOUNT  INTEGER := 0; -- 更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300); -- SQL执行描述信息
  V_SYSTEM    VARCHAR2(100); -- 来源系统
  V_STEP_DESC VARCHAR2(200); --任务名称
  V_TABLE_NAME VARCHAR2(100); --表名
BEGIN
V_TABLE_NAME := REPLACE(V_PROC_NAME,'ETL_INIT_','');
--清空表
EXECUTE IMMEDIATE 'TRUNCATE TABLE '|| V_TABLE_NAME;

  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); -- 获取跑批日期
  V_SYSTEM := '监管报送'; -- 默认写监管报送系统，有真实来源的按实际写

  --IF V_P_DATE <> V_LAST_DAT THEN
  --  RETURN;
  --END IF;

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;

 --清理当天数据
  V_STEP_DESC  := '清理当天数据';
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TBND';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TBND NOLOGGING
    (  I_CODE  --金融工具代码
      ,A_TYPE  --资产类型
      ,M_TYPE  --市场类型
      ,SH_CODE  --上交所代码
      ,SZ_CODE  --深交所代码
      ,YH_CODE  --银行间代码
      ,CURRENCY  --币种
      ,COUNTRY  --国家
      ,Q_TYPE  --报价方式
      ,B_NAME  --债券名称
      ,P_TYPE  --产品类型
      ,P_CLASS  --产品分类
      ,B_PAR_VALUE  --面额
      ,B_ISSUE_PRICE  --发行价格
      ,B_ISSUE_DATE  --发行日期
      ,B_LIST_DATE  --上市时间
      ,B_START_DATE  --起息日
      ,B_MTR_DATE  --到期日
      ,B_TERM  --期限
      ,B_DAYCOUNT  --计息基准
      ,I_CODE_BENCH  --基准利率代码
      ,A_TYPE_BENCH  --基准利率资产类型
      ,M_TYPE_BENCH  --基准利率市场类型
      ,B_ISSUE_MODE  --发行方式
      ,B_COUPON_TYPE  --票息类型
      ,B_CASH_TIMES  --付息次数
      ,B_EMBOPT_TYPE  --含权类型
      ,B_AMORTIZING  --本金偿还类型
      ,B_AS_TYPE  --资产化类型
      ,B_ISSUER  --发行机构
      ,B_WARRANTOR  --担保机构
      ,B_SENIORITY  --清偿等级
      ,B_FPML  --条款FPML
      ,B_COUPON  --利率/利差
      ,B_NAME_FULL  --债券全称
      ,B_ACTUAL_MTR_DATE  --实际到期日
      ,D_CODE  --债券内部代码
      ,B_P_CLASS  --债券产品分类
      ,B_ACTUAL_ISSUE_AMOUNT  --实际发行量
      ,CHINESESPELL  --中文拼写
      ,B_COUPON_PREC  --利率精度
      ,HOST_MARKET  --托管市场
      ,BJ_MARKET  --薄记市场
      ,ISSUER_ID  --发行人ID
      ,WARRANTOR_ID  --担保人ID
      ,IS_DELETE  --是否删除
      ,USABLE_FLAG  --是否已生效：1： 正常 2： 新增
      ,MEMO  --备注
      ,UPDATE_USER  --更新人员
      ,ACCOUNT_USER  --复核人员
      ,UPDATE_TIME  --更新时间
      ,ACCOUNT_TIME  --复核时间
      ,IMP_DATE  --导入日期
      ,IMP_TIME  --导入时间
      ,PIPE_ID  --导入管道
      ,B_FST_PAY_DATE  --首个付息日
      ,B_FST_REG_CALC_START_DATE  --首个规则计息区间开始日
      ,B_INITIAL_FIXING_DATE  --首周期定息日
      ,B_PAY_FREQ  --支付频率
      ,B_PAY_BIZDAY_CONVERTION  --支付调整规则
      ,B_CALC_FREQ  --计息频率
      ,B_CALC_BIZDAY_CONVERTION  --计息调整规则
      ,B_RESET_FREQ  --重置频率
      ,B_RESET_BIZDAY_CONVERTION  --重置调整规则
      ,B_FIXING_DATES_OFFSET  --定息日偏移
      ,B_FIXING_BIZDAY_CONVERTION  --定息日调整规则
      ,B_FIXING_PRECISION  --定息精度，普通债券为4，少量债券为6
      ,B_INITIAL_RATE  --首周期定息利率
      ,B_MULTIPLIER  --初始利率倍数
      ,B_CAP_RATE  --初始利率上限
      ,B_FLOOR_RATE  --初始利率下限
      ,B_EXERCISE_STYLE  --行权类型，A：美式 B：百慕大 E：欧式
      ,B_EXERCISE_DATE  --首个行权日，含权债有效
      ,B_STRIKE_PRICE  --首个执行价格，含权债有效
      ,B_COMPENSATION_RATE  --首个补偿利率，含权债有效
      ,P_CLASS_ACT  --会计产品分类
      ,B_ISSUER_CODE  --发行人代码
      ,SPECIAL_DESC  --特殊条款说明
      ,B_ACTUAL_AMOUNT_RATE  --发行额度占比（%）
      ,TRUSTENHANCING_TYPE  --增信方式
      ,B_ISSUE_LIST_DATE  --上市公告日期
      ,ISSUE_FEERATE  --发行费率
      ,UNDERWRITING_TYPE  --承销方式
      ,B_EXTEND_TYPE  --债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记
      ,S_TYPE  --标准类型
      ,P_CLASS_DV  --数据厂商债券分类
      ,P_CLASS_CCDC  --中债债券分类
      ,Q_PAR_VALUE  --报价面值，0：报价以债券面值报价；其它值为报价面值
      ,CONFIRM_TERM  --是否完整条款，1：不完整条款；0或空值：完整条款
      ,SEC_CODE  --证券唯一编码
      ,PUBLIC_ISSUE  --是否公开发行，0：否；1：是
      ,B_USER_MTR_DATE  --用户指定到期日
      ,AI_DAYCOUNT  --应计利息计息基准
      ,YTM_DAYCOUNT  --到期收益率计息基准
      ,B_EARLY_MTR_DATE  --提前到期日
      ,MANAGE_MODE  --管理模式,1:自主管理；2:委托管理,默认1
      ,BOND_NATURE  --债券性质
      ,IS_CITY_INVESTMENT  --是否城投债
      ,PERPETUAL  --是否永续债
      ,LEGAL_MTR_DATE  --法定到期日
      ,B_PLAN_ISSUE_AMOUNT  --计划发行量
      ,IS_DEFAULT  --是否违约
      ,CF_DAYCOUNT  --前台现金流计息基准
      ,AI_DAYCOUNT_BACK  --后台应计利息计息基准
      ,YTM_DAYCOUNT_BACK  --后台到期收益率计息基准
      ,CF_DAYCOUNT_BACK  --后台现金流计息基准
      ,IS_TEMP  --是否临时代码，0：否；1：是
      ,B_EXT_RATING  --最新债项评级
      ,B_EXT_RATING_INSTITUTION  --最新债项评级机构
      ,B_ISSUER_EXT_RATING  --最新发行人评级
      ,B_ISSUER_EXT_R_INSTITUTION  --最新发行人评级机构
      ,B_FST_EXT_RATING  --债项首次评级
      ,B_FST_EXT_RATING_INST  --债项首次评级机构
      ,B_FST_ISSUER_EXT_RATING  --发行人首次评级
      ,B_FST_ISSUER_EXT_R_INST  --发行人首次评级机构
      ,B_AS_ASSET_TYPE_NAME  --基础资产类型名称(仅对ABS债券有效)
      ,REF_YIELD  --参考收益率
      ,WARRANTOR_RESPONSIBILITY  --担保人是否有连带责任,0-否,1-是
      ,DEBTS_REGISTRATION_DATE  --债权债务登记日
      ,GUARANTOR_RATING  --担保人评级
      ,START_DT  --开始时间
      ,END_DT  --结束时间
      ,ID_MARK  --增删标志


     )
  SELECT /*+PARALLEL*/
      I_CODE  --金融工具代码
      ,A_TYPE  --资产类型
      ,M_TYPE  --市场类型
      ,SH_CODE  --上交所代码
      ,SZ_CODE  --深交所代码
      ,YH_CODE  --银行间代码
      ,CURRENCY  --币种
      ,COUNTRY  --国家
      ,Q_TYPE  --报价方式
      ,B_NAME  --债券名称
      ,P_TYPE  --产品类型
      ,P_CLASS  --产品分类
      ,B_PAR_VALUE  --面额
      ,B_ISSUE_PRICE  --发行价格
      ,B_ISSUE_DATE  --发行日期
      ,B_LIST_DATE  --上市时间
      ,B_START_DATE  --起息日
      ,B_MTR_DATE  --到期日
      ,B_TERM  --期限
      ,B_DAYCOUNT  --计息基准
      ,I_CODE_BENCH  --基准利率代码
      ,A_TYPE_BENCH  --基准利率资产类型
      ,M_TYPE_BENCH  --基准利率市场类型
      ,B_ISSUE_MODE  --发行方式
      ,B_COUPON_TYPE  --票息类型
      ,B_CASH_TIMES  --付息次数
      ,B_EMBOPT_TYPE  --含权类型
      ,B_AMORTIZING  --本金偿还类型
      ,B_AS_TYPE  --资产化类型
      ,B_ISSUER  --发行机构
      ,B_WARRANTOR  --担保机构
      ,B_SENIORITY  --清偿等级
      ,B_FPML  --条款FPML
      ,B_COUPON  --利率/利差
      ,B_NAME_FULL  --债券全称
      ,B_ACTUAL_MTR_DATE  --实际到期日
      ,D_CODE  --债券内部代码
      ,B_P_CLASS  --债券产品分类
      ,B_ACTUAL_ISSUE_AMOUNT  --实际发行量
      ,CHINESESPELL  --中文拼写
      ,B_COUPON_PREC  --利率精度
      ,HOST_MARKET  --托管市场
      ,BJ_MARKET  --薄记市场
      ,ISSUER_ID  --发行人ID
      ,WARRANTOR_ID  --担保人ID
      ,IS_DELETE  --是否删除
      ,USABLE_FLAG  --是否已生效：1： 正常 2： 新增
      ,MEMO  --备注
      ,UPDATE_USER  --更新人员
      ,ACCOUNT_USER  --复核人员
      ,UPDATE_TIME  --更新时间
      ,ACCOUNT_TIME  --复核时间
      ,IMP_DATE  --导入日期
      ,IMP_TIME  --导入时间
      ,PIPE_ID  --导入管道
      ,B_FST_PAY_DATE  --首个付息日
      ,B_FST_REG_CALC_START_DATE  --首个规则计息区间开始日
      ,B_INITIAL_FIXING_DATE  --首周期定息日
      ,B_PAY_FREQ  --支付频率
      ,B_PAY_BIZDAY_CONVERTION  --支付调整规则
      ,B_CALC_FREQ  --计息频率
      ,B_CALC_BIZDAY_CONVERTION  --计息调整规则
      ,B_RESET_FREQ  --重置频率
      ,B_RESET_BIZDAY_CONVERTION  --重置调整规则
      ,B_FIXING_DATES_OFFSET  --定息日偏移
      ,B_FIXING_BIZDAY_CONVERTION  --定息日调整规则
      ,B_FIXING_PRECISION  --定息精度，普通债券为4，少量债券为6
      ,B_INITIAL_RATE  --首周期定息利率
      ,B_MULTIPLIER  --初始利率倍数
      ,B_CAP_RATE  --初始利率上限
      ,B_FLOOR_RATE  --初始利率下限
      ,B_EXERCISE_STYLE  --行权类型，A：美式 B：百慕大 E：欧式
      ,B_EXERCISE_DATE  --首个行权日，含权债有效
      ,B_STRIKE_PRICE  --首个执行价格，含权债有效
      ,B_COMPENSATION_RATE  --首个补偿利率，含权债有效
      ,P_CLASS_ACT  --会计产品分类
      ,B_ISSUER_CODE  --发行人代码
      ,SPECIAL_DESC  --特殊条款说明
      ,B_ACTUAL_AMOUNT_RATE  --发行额度占比（%）
      ,TRUSTENHANCING_TYPE  --增信方式
      ,B_ISSUE_LIST_DATE  --上市公告日期
      ,ISSUE_FEERATE  --发行费率
      ,UNDERWRITING_TYPE  --承销方式
      ,B_EXTEND_TYPE  --债券扩展字段 第1位：是否可转股；第2位：是否可赎回；第3位：是否可回售；第4位：是否可转为相关债券（固息转浮息、浮息转固息)；第5位: 是否公开发行；第6位：是否永续；第7位：是否自贸区；第8位：是否权益类标识；第9位：利率债/信用债；第10位：减记条款；第11位：违约标记；第12位：临时债券标记
      ,S_TYPE  --标准类型
      ,P_CLASS_DV  --数据厂商债券分类
      ,P_CLASS_CCDC	--中债债券分类
      ,Q_PAR_VALUE	--报价面值，0：报价以债券面值报价；其它值为报价面值
      ,CONFIRM_TERM	--是否完整条款，1：不完整条款；0或空值：完整条款
      ,SEC_CODE	--证券唯一编码
      ,PUBLIC_ISSUE	--是否公开发行，0：否；1：是
      ,B_USER_MTR_DATE	--用户指定到期日
      ,AI_DAYCOUNT	--应计利息计息基准
      ,YTM_DAYCOUNT	--到期收益率计息基准
      ,B_EARLY_MTR_DATE	--提前到期日
      ,MANAGE_MODE	--管理模式,1:自主管理；2:委托管理,默认1
      ,BOND_NATURE	--债券性质
      ,IS_CITY_INVESTMENT	--是否城投债
      ,PERPETUAL	--是否永续债
      ,LEGAL_MTR_DATE	--法定到期日
      ,B_PLAN_ISSUE_AMOUNT	--计划发行量
      ,IS_DEFAULT	--是否违约
      ,CF_DAYCOUNT	--前台现金流计息基准
      ,AI_DAYCOUNT_BACK	--后台应计利息计息基准
      ,YTM_DAYCOUNT_BACK	--后台到期收益率计息基准
      ,CF_DAYCOUNT_BACK	--后台现金流计息基准
      ,IS_TEMP	--是否临时代码，0：否；1：是
      ,B_EXT_RATING	--最新债项评级
      ,B_EXT_RATING_INSTITUTION	--最新债项评级机构
      ,B_ISSUER_EXT_RATING	--最新发行人评级
      ,B_ISSUER_EXT_R_INSTITUTION	--最新发行人评级机构
      ,B_FST_EXT_RATING	--债项首次评级
      ,B_FST_EXT_RATING_INST	--债项首次评级机构
      ,B_FST_ISSUER_EXT_RATING	--发行人首次评级
      ,B_FST_ISSUER_EXT_R_INST	--发行人首次评级机构
      ,B_AS_ASSET_TYPE_NAME	--基础资产类型名称(仅对ABS债券有效)
      ,REF_YIELD	--参考收益率
      ,WARRANTOR_RESPONSIBILITY	--担保人是否有连带责任,0-否,1-是
      ,DEBTS_REGISTRATION_DATE	--债权债务登记日
      ,GUARANTOR_RATING	--担保人评级
      ,START_DT	--开始时间
      ,END_DT	--结束时间
      ,ID_MARK	--增删标志

    FROM IOL.V_IBMS_TBND   --债券基本信息表_视图

   ;

 V_SQLCOUNT := SQL%ROWCOUNT;
   V_SQLMSG := '返回值：['||SQLCODE||'],描述信息：'||SQLERRM;
   O_ERRCODE := '0';
   V_ENDTIME := SYSDATE;
   COMMIT;


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

  END ETL_INIT_O_IOL_IBMS_TBND;
/

