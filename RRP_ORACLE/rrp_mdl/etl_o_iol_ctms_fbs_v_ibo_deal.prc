CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_O_IOL_CTMS_FBS_V_IBO_DEAL(I_P_DATE IN INTEGER,
                                                          O_ERRCODE OUT VARCHAR2
                                                          )
  /**************************************************************************
  *  程序名称：ETL_O_IOL_CTMS_FBS_V_IBO_DEAL
  *  功能描述：拆借视图
  *  创建日期：20220525
  *  开发人员：梅炜
  *  来源表：
  *  目标表： O_IOL_CTMS_FBS_V_IBO_DEAL
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220525  梅炜     首次创建
  *             2    20250610  YJY      剔除删除数据
  *             3    20250905  YJY      新增交易时间
  *************************************************************************/
AS
  -- 定义变量 --
  V_STEP      INTEGER := 0;               --处理步骤
  V_P_DATE    VARCHAR2(8);                --跑批数据日期
  V_STARTTIME DATE;                       --处理开始时间
  V_ENDTIME   DATE;                       --处理结束时间
  V_SQLCOUNT  INTEGER := 0;               --更新或删除影响的记录数
  V_SQLMSG    VARCHAR2(300);              --SQL执行描述信息
  V_STEP_DESC VARCHAR2(200);              --任务名称
  V_TAB_NAME  VARCHAR2(200) := 'O_IOL_CTMS_FBS_V_IBO_DEAL'; --表名
  V_PROC_NAME VARCHAR2(50) := 'ETL_O_IOL_CTMS_FBS_V_IBO_DEAL'; --程序名称
  V_SYSTEM    VARCHAR2(30) := '监管报送'; --来源系统 --默认写监管报送系统，有真实来源的按实际写
BEGIN
  -- 处理参数及月末等判断逻辑 --
  V_P_DATE := TO_CHAR(I_P_DATE); --获取跑批日期

  -- 支持重跑 --
  V_STEP := 1;
  V_STEP_DESC := '-- 程序跑批开始 --';
  V_STARTTIME := SYSDATE;
  EXECUTE IMMEDIATE 'TRUNCATE TABLE RRP_MDL.O_IOL_CTMS_FBS_V_IBO_DEAL';
  V_SQLCOUNT := SQL%ROWCOUNT;
  V_SQLMSG := '返回值：['||SQLCODE||'],执行信息：'||SQLERRM;
  O_ERRCODE := '0';
  V_ENDTIME := SYSDATE;
  COMMIT;
  ETL_YUSYS_LOG(V_P_DATE,V_SYSTEM,V_PROC_NAME,V_STARTTIME,V_ENDTIME,V_STEP,V_STEP_DESC,V_SQLCOUNT,O_ERRCODE,'');

  -- 程序业务逻辑处理主体部分 --
  V_STEP := V_STEP + 1;
  V_STEP_DESC := '数据落地-拆借视图';
  V_STARTTIME := SYSDATE;
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_CTMS_FBS_V_IBO_DEAL NOLOGGING
    ( CUS_NUMBER			    --机构的唯一标识号
      ,BRANCH_NUMBER	    --分支机构的唯一标识号
      ,DEAL_SQNO			    --投组交易流水号，交易的FMS内部唯一编号
      ,DEAL_DATE			    --交易日期和时间
      ,VALUE_DATE			    --起息日
      ,MATURITY_DATE		  --到期日
      ,CRNCY_CODE			    --货币
      ,RATE			          --拆借利率。如果为浮动利率或变动利率，则为首期利率。
      ,FIRST_AMNT			    --拆借金额，负数为拆出，正数为拆入
      ,MATURITY_AMNT		  --期末结算金额
      ,DAY_ACCRD_INTRST_AMNT	--每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整
      ,RATE_TYPE			    --利率类型 0：固定利率 1：浮动利率  2：变动利率
      ,INTEREST_BASE		  --计息基准 0：ACT/360 1: ACT/365  2: 30/360 3： ACT/365F  4: ACT/ACT 对应FMS_CRNCY_BASE_DTLS.CBD_INTRST_BASIS_INDC（2）
      ,CURRENT_RATE		    --当前计息周期的利率  固定利率：等于DMA_DEAL_NUMBER(20,12) 浮动利率、变动利率：在利率重置日进行调整
      ,ACCRUED_AMNT		    --应计利息总额
      ,TRADE_PURPOSE		  --交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
      ,BUSINESS_DATE		  --系统交易日，交易录入时的系统日期和时间
      ,COUNTER_PARTY_ID	  --交易对手的SRNO
      ,COUNTER_PARTY_SCNAME	--交易对手中文简称
      ,UPDATE_TIME		    --记录修改日期
      ,PDD_DEAL_SQNO		  --原始交易流水号，交易的FMS内部唯一编号
      ,DEAL_STATUS		    --成交单状态
      ,DEAL_DIR			      --交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业
      ,CLIENT_DEAL_SQNO	  --业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. CSTP下载交易中的成交编号。
      ,TRADE_TYPE			    --交易模式 ZZ：其它 A：匿名（对应TradeInstrument=3） B：双边（对应TradeInstrument=1） GB：黄金.询价模式（对应TradeInstrument=6）
      ,DEAL_SOURCE		    --交易来源 C：CSTP，CSTP下载交易 E：External API，银行接口下载交易 F：File，文件导入交易 M：Manual，手工录入交易
      ,DEAL_MARKET		    --交易场所： 其它 CFETS R：（保留） E：（保留） B：银行 S：模拟交易 V：虚拟交易（多笔交易组合出来的）（2.0.0）
      ,SETTLE_TYPE		    --清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
      ,DEAL_LINK_SQNO		  --交易修改删除的序列关系。 1. 交易修改时，通过本字段，R交易关联到U交易，A交易关联到R交易。 2. 交易删除时，通过本字段，R交易关联到D交易。 3. 无修改删除时，本字段为NULL
      ,MODIFY_DATE		    --更新日期
      ,PORTFOLIO_SQNO		  --投组交易编号
      ,PORTFOLIO_ID		    --投资组合ID
      ,PORTFOLIO_NAME	  	--投资组合名称
      ,PORTFOLIO_TYPE		  --投组类型： 交易 对冲  自营买卖 市场平盘
      ,PORTFOLIO_STATUS	  --投资组合状态： A：新交易 U：交易被修改 D：CSTP下载交易或第三方接口下载交易根据规则自动分配入投组 R：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 M：已到期交易，交易全部完成交割后，由A状态置为M状态 C：取消投组
      ,PORTFOLIO_LINK_SQNO --交易链接编号
      ,IBO_TYPE			      --拆借类型 0：拆借 1：同存
      ,CLEAR_DEP		    	--清算机构 ZZ：其它； AA：上清所
      ,RSDL_AMNT			    --剩余金额
      ,FLOAT_DIRECTION	  --利率的浮动方向， 0：正浮动； 1：负浮动；
      ,INTRST_BNCHMRK_SRNO	--浮动利率指标
      ,INTRST_BNCHMRK_NAME	--浮动利率指标前台转换为指标名称
      ,INTRST_TERM	      --利率期限
      ,SPREAD_RATE		    --BP，带方向
      ,PMNT_FREQ			    --付息频率
      ,PMNT_STUB_RULE		  --付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。
      ,UNWIND_CNFRM_RATE	--约定提前支取利率。
      ,FIXING_FREQ	    	--定息频率
      ,FIXING_DAY_COUNT	  --定价日调整天数
      ,FRST_PMNT_DATE		  --首次付息日
      ,DAY_COUNT			    --拆借天数
      ,IMPS_RATE			    --约定罚息日利率(影响后台)。
      ,USD_CRNCY_AMNT		  --折USD货币金额
      ,EVENT_MASK			    --NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
      ,EVENT_TYPE			    --NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
      ,EVENT_LINK_SQNO	  --事件(违约，展期，提前交割)关联交易编号
      ,EVENT_DATE			    --事件日期
      ,RO_ROLL_TYPE		    --展期方式
      ,RO_CALC_AMOUNT		  --展期本金
      ,RO_INTRST_AMOUNT	  --展期利息
      ,CONFIRM_INDC		    --交易后确认标识
      ,COLLATERAL_METHOD	--质押方式 1：买断 2：质押
      ,DELIVERY_TYPE		  --首次结算方式 0：券款对付 4：见券付款 5：见款付券
      ,DELIVERY_TYPE2		  --到期结算方式 0：券款对付 4：见券付款 5：见款付券
      ,UNDERLYING_CURRENCY	  --债券币种
      ,UNDERLYING_STIP_VALUE	--折算比例
      ,UNDERLYING_DISCOUNTAMT	--折算金额1
      ,UNDERLYING_QTY			    --券面总额
      ,UNDERLYING_SECURITYID	--债券代码
      ,UNDERLYING_DIRTY_PRICE	--债券全价
      ,UNDERLYING_VALUE		    --债券价值
      ,FACE_VALUE			        --面值
      ,UNDERLYING_STIP_RATE 	--折算汇率2
      ,UNDERLYING_DISCOUNTAMT2	--折算金额2
      ,REMARK			        --备注
     -- ,MA_BANK_CN			    --本方经办行中文名称
     -- ,MA_BANK_EN			    --本方经办行英文名称
     -- ,CP_MA_BANK_CN		  --对手方经办行中文名称
     -- ,CP_MA_BANK_EN		  --对手方经办行英文名称
      ,DEALER			        --交易员
      --,DELIVERY_TYPE_IBO	--结算方式 13: SISS 支付直连
      ,START_DT			      --开始时间
      ,END_DT			        --结束时间
      ,ID_MARK			      --增删标志
      ,ETL_TIMESTAMP		  --ETL处理时间戳
      ,DEAL_TIME          --交易时间  ADD BY YJY 20250905
    )
  SELECT /*+PARALLEL*/
       CUS_NUMBER			    --机构的唯一标识号
      ,BRANCH_NUMBER	    --分支机构的唯一标识号
      ,DEAL_SQNO			    --投组交易流水号，交易的FMS内部唯一编号
      ,DEAL_DATE			    --交易日期和时间
      ,VALUE_DATE			    --起息日
      ,MATURITY_DATE		  --到期日
      ,CRNCY_CODE			    --货币
      ,RATE			          --拆借利率。如果为浮动利率或变动利率，则为首期利率。
      ,FIRST_AMNT			    --拆借金额，负数为拆出，正数为拆入
      ,MATURITY_AMNT		  --期末结算金额
      ,DAY_ACCRD_INTRST_AMNT	--每日应当计提的利息  固定利率：保持不变 浮动利率、变动利率：在利率重置日进行调整
      ,RATE_TYPE			    --利率类型 0：固定利率 1：浮动利率  2：变动利率
      ,INTEREST_BASE		  --计息基准 0：ACT/360 1: ACT/365  2: 30/360 3： ACT/365F  4: ACT/ACT 对应FMS_CRNCY_BASE_DTLS.CBD_INTRST_BASIS_INDC（2）
      ,CURRENT_RATE		    --当前计息周期的利率  固定利率：等于DMA_DEAL_NUMBER(20,12) 浮动利率、变动利率：在利率重置日进行调整
      ,ACCRUED_AMNT		    --应计利息总额
      ,TRADE_PURPOSE		  --交易目的 0：其他 1：自营交易 2：代客交易 3：内部交易 4：经纪交易
      ,BUSINESS_DATE		  --系统交易日，交易录入时的系统日期和时间
      ,COUNTER_PARTY_ID	  --交易对手的SRNO
      ,COUNTER_PARTY_SCNAME	--交易对手中文简称
      ,UPDATE_TIME		    --记录修改日期
      ,PDD_DEAL_SQNO		  --原始交易流水号，交易的FMS内部唯一编号
      ,DEAL_STATUS		    --成交单状态
      ,DEAL_DIR			      --交易方向  拆借：1拆入 -1 拆出 同业：1同业存放 -1 存放同业
      ,CLIENT_DEAL_SQNO	  --业务成交编号，来源如下： 1. 手工可不输入。 2. 文件导入，必须包含业务成交编号，且必须唯一。 3. 外部接口导入交易中，必须包含成交编号，且必须唯一。 4. CSTP下载交易中的成交编号。
      ,TRADE_TYPE			    --交易模式 ZZ：其它 A：匿名（对应TradeInstrument=3） B：双边（对应TradeInstrument=1） GB：黄金.询价模式（对应TradeInstrument=6）
      ,DEAL_SOURCE		    --交易来源 C：CSTP，CSTP下载交易 E：External API，银行接口下载交易 F：File，文件导入交易 M：Manual，手工录入交易
      ,DEAL_MARKET		    --交易场所： 其它 CFETS R：（保留） E：（保留） B：银行 S：模拟交易 V：虚拟交易（多笔交易组合出来的）（2.0.0）
      ,SETTLE_TYPE		    --清算方式 0：不用清算 1：双边净额清算，即集中净额清算（询价） 2：双边全额清算 3：集中净额清算（竞价） 4：净额+全额（暂时不使用）
      ,DEAL_LINK_SQNO		  --交易修改删除的序列关系。 1. 交易修改时，通过本字段，R交易关联到U交易，A交易关联到R交易。 2. 交易删除时，通过本字段，R交易关联到D交易。 3. 无修改删除时，本字段为NULL
      ,MODIFY_DATE		    --更新日期
      ,PORTFOLIO_SQNO		  --投组交易编号
      ,PORTFOLIO_ID		    --投资组合ID
      ,PORTFOLIO_NAME	  	--投资组合名称
      ,PORTFOLIO_TYPE		  --投组类型： 交易 对冲  自营买卖 市场平盘
      ,PORTFOLIO_STATUS	  --投资组合状态： A：新交易 U：交易被修改 D：CSTP下载交易或第三方接口下载交易根据规则自动分配入投组 R：反向交易，用来通知周边系统，自己的原交易被删除，并反向对冲原交易的头寸和损益 M：已到期交易，交易全部完成交割后，由A状态置为M状态 C：取消投组
      ,PORTFOLIO_LINK_SQNO --交易链接编号
      ,IBO_TYPE			      --拆借类型 0：拆借 1：同存
      ,CLEAR_DEP		    	--清算机构 ZZ：其它； AA：上清所
      ,RSDL_AMNT			    --剩余金额
      ,FLOAT_DIRECTION	  --利率的浮动方向， 0：正浮动； 1：负浮动；
      ,INTRST_BNCHMRK_SRNO	--浮动利率指标
      ,INTRST_BNCHMRK_NAME	--浮动利率指标前台转换为指标名称
      ,INTRST_TERM	      --利率期限
      ,SPREAD_RATE		    --BP，带方向
      ,PMNT_FREQ			    --付息频率
      ,PMNT_STUB_RULE		  --付息残段处理方式，0：自成一期；1：并入前期；2：自成一期（超短期并入前期）；超短期：小于等于15天。
      ,UNWIND_CNFRM_RATE	--约定提前支取利率。
      ,FIXING_FREQ	    	--定息频率
      ,FIXING_DAY_COUNT	  --定价日调整天数
      ,FRST_PMNT_DATE		  --首次付息日
      ,DAY_COUNT			    --拆借天数
      ,IMPS_RATE			    --约定罚息日利率(影响后台)。
      ,USD_CRNCY_AMNT		  --折USD货币金额
      ,EVENT_MASK			    --NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
      ,EVENT_TYPE			    --NM 正常。DV 交割衍生,可拆分。SP 注销衍生,可拆分。BK 违约衍生,可拆分。RO 展期衍生,可拆分。RB 提前交割衍,可拆分。EX 期权行
      ,EVENT_LINK_SQNO	  --事件(违约，展期，提前交割)关联交易编号
      ,EVENT_DATE			    --事件日期
      ,RO_ROLL_TYPE		    --展期方式
      ,RO_CALC_AMOUNT		  --展期本金
      ,RO_INTRST_AMOUNT	  --展期利息
      ,CONFIRM_INDC		    --交易后确认标识
      ,COLLATERAL_METHOD	--质押方式 1：买断 2：质押
      ,DELIVERY_TYPE		  --首次结算方式 0：券款对付 4：见券付款 5：见款付券
      ,DELIVERY_TYPE2		  --到期结算方式 0：券款对付 4：见券付款 5：见款付券
      ,UNDERLYING_CURRENCY	  --债券币种
      ,UNDERLYING_STIP_VALUE	--折算比例
      ,UNDERLYING_DISCOUNTAMT	--折算金额1
      ,UNDERLYING_QTY			    --券面总额
      ,UNDERLYING_SECURITYID	--债券代码
      ,UNDERLYING_DIRTY_PRICE	--债券全价
      ,UNDERLYING_VALUE		    --债券价值
      ,FACE_VALUE			        --面值
      ,UNDERLYING_STIP_RATE 	--折算汇率2
      ,UNDERLYING_DISCOUNTAMT2	--折算金额2
      ,REMARK			        --备注
     -- ,MA_BANK_CN			    --本方经办行中文名称
     -- ,MA_BANK_EN			    --本方经办行英文名称
     -- ,CP_MA_BANK_CN		  --对手方经办行中文名称
     -- ,CP_MA_BANK_EN		  --对手方经办行英文名称
      ,DEALER			        --交易员
     -- ,DELIVERY_TYPE_IBO	--结算方式 13: SISS 支付直连
      ,START_DT			      --开始时间
      ,END_DT			        --结束时间
      ,ID_MARK			      --增删标志
      ,ETL_TIMESTAMP		  --ETL处理时间戳
      ,DEAL_TIME          --交易时间  ADD BY YJY 20250905
    FROM IOL.V_CTMS_FBS_V_IBO_DEAL   --拆借视图_视图
   WHERE START_DT <= TO_DATE(V_P_DATE,'YYYYMMDD')
     AND END_DT > TO_DATE(V_P_DATE,'YYYYMMDD')
     AND ID_MARK <> 'D' ; --MOD BY YJY 20250610

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

END ETL_O_IOL_CTMS_FBS_V_IBO_DEAL;
/

