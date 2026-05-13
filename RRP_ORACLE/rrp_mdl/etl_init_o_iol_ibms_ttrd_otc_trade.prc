CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_INIT_O_IOL_IBMS_TTRD_OTC_TRADE(I_P_DATE IN INTEGER,
                              O_ERRCODE OUT VARCHAR2
                               )
  /**************************************************************************
  *  程序名称：ETL_INIT_O_IOL_IBMS_TTRD_OTC_TRADE
  *  功能描述：中国债券信用评级表
  *  创建日期：20220820
  *  开发人员：梅炜
  *  来源表： IOL.V_WIND_CBONDRATING
  *  目标表： O_IOL_IBMS_TTRD_OTC_TRADE
  *  配置表：
  *  修改情况：序号  修改日期  修改人   修改原因
  *             1    20220619  梅炜     首次创建
  ***************************************************************************/
  AS
  -- 定义变量 --
  V_STEP      INTEGER := 0; -- 处理步骤
  V_PROC_NAME VARCHAR2(50) := 'ETL_INIT_O_IOL_IBMS_TTRD_OTC_TRADE'; -- 程序名称
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
   -- EXECUTE IMMEDIATE ' TRUNCATE TABLE RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE';

  V_STEP_DESC  := '装入目标表';
  INSERT /*+APPEND*/ INTO RRP_MDL.O_IOL_IBMS_TTRD_OTC_TRADE NOLOGGING
    ( SYSORDID,                               --交易序号
      ORDDATE,                                --委托日期
      ORDTIME,                                --委托时间
      CONDATE,                                --确认日期
      CONTIME,                                --确认时间
      INSID,                                  --指令号，也叫审批号
      INTORDID,                               --内部交易号
      EXTORDID,                               --外部交易号
      CUSTORDID,                              --客户交易号
      EXTBIZID,                               --外部业务编号
      OPERATOR,                               --操作人
      TRDTYPE,                                --交易类型
      CASH_EXT_ACCID,                         --一级资金账户
      CASH_ACCID,                             --二级资金账户
      SECU_EXT_ACCID,                         --一级证券账户
      SECU_ACCID,                             --二级证券账户
      PARTYID,                                --交易对手
      CP_CASH_ACCID,                          --二级资金账户
      CP_SECU_ACCID,                          --二级证券账户
      I_CODE,                                 --金融工具代码
      A_TYPE,                                 --SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) SPT_ABS:资产证券化产品(ABS、MBS、CDO) SPT_CB:可转换债券 SPT_DB:债务 SPT_IBOR:同业拆借 SPT_IBDEPO:同业存款 SPT_C:现金 SPT_F1:封闭式基金 SPT_F2:开放式基金 SPT_F3:交易所交易基金 SPT_STG_1:期限套利 SPT_STG_2:跨期套利 SPT_PG:配股 SPT_IR:利率 SPT_CP:商业票据 SPT_DED:活期存款 SPT_NTD:通知存款(1天通知存款、7天通知存款) SPT_TMD:定期存款(3个月、半年、1年、3年、5年) SPT_NGD:协议存款(期限确定，利率协商确定的存款) SPT_REPO:回购 SPT_XR:汇率
      M_TYPE,                                 --XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
      I_NAME,                                 --金融工具名称
      ORDCOUNT,                               --交易数量（应收本金）
      ORDPRICE,                               --交易价格
      ORDAMOUNT,                              --交易金额
      TRDFEE,                                 --交易费用
      SETFEE,                                 --结算费用
      SETDAYS,                                --清算速度
      SETDATE,                                --结算日期
      THENMKTPRICE,                           --当时市场价
      THENMKTPRICE_U,                         --当时标的市场价
      ORDSTATUS,                              ---2：未通过审批;-1：已通过审批;-3：部分成交的审批单 审批单更改后生成交易单,由于交易要素修改则新建交易单，原TRADE的状态改为-3;-4：审批单分多次成交完毕;0：新建;3：创建指令成功;4：成交确认;5：已撤销;6：成交失败
      ERRCODE,                                --错误代码
      ERRINFO,                                --错误信息
      BND_SETTYPE,                            --结算方式
      BND_NETPRICE,                           --净价金额
      BND_AIAMOUNT,                           --应收利息
      REMARK,                                 --备注信息
      RESERVETYPE,                            --本方保证方式
      CP_RESERVETYPE,                         --对方保证方式
      RESERVECHG,                             --本方保证可否变更
      CP_RESERVECHG,                          --对方保证可否变更
      RESERVEVALUE,                           --本方保证总额
      CP_RESERVEVALUE,                        --对方保证总额
      RESOLVE,                                --争议解决方式
      TRADE_GRP_ID,                           --合并指令ID
      REF_ORDDATE,                            --等待补充
      REF_SYSORDID,                           --引用交易流水号
      IGNORE_FLAG,                            --1=忽略，0=不忽略，主要是针对开放式回购的现券交易
      EXE_MARKET,                             --交易执行市场
      TRADER,                                 --经办人
      TRADER_CP,                              --等待补充
      DEALTYPE,                               --成交方式
      AGREENUMBER,                            --大宗交易要素的约定号
      EVAL_NETPRICE,                          --净价跟中债估值净价的偏移度 【VALUE=(中债估值净价-交易净价)/中债估值净价】
      ORDSOURCE,                              --交易来源：-1：次交易；0：内部交易；1：外部交易
      DEAL_COUNT,                             --已成交数量
      DEAL_AVG_NETPRICE,                      --平均成交净价价格
      DEAL_NETAMOUNT,                         --净价成交金额
      DEAL_AIAMOUNT,                          --实收利息
      DEAL_AMOUNT,                            --实收金额
      BIDASKID,                               --双边报价互存交易编号
      RELATEDPARTY,                           --是否关联机构
      TERMINATE_AMOUNT,                       --等待补充
      SETDATE_TERMINATE,                      --等待补充
      AGREEMENTTYPE,                          --等待补充
      PARTYNAMETEMPORITY,                     --等待补充
      PARTY_ZZDACCNAME,                       --交易对手中债登名称
      SEATNO_CP,                              --等待补充
      EXECUTOR,                               --交易员
      UNION_SYSORDID,                         --等待补充
      PARTY_ZZDACCCODE,                       --交易对手中债登账户
      PARTY_BANK_CODE,                        --交易对手开户行号
      PARTY_ACCT_CODE,                        --交易对手帐号
      PARTY_BANK_NAME,                        --交易对手开户行名
      PARTY_ACCT_NAME,                        --交易对手帐号名称
      DIS_FEE_KIND_FOLLOW,                    --尾随手续费返还方式
      DIS_FEE_KIND,                           --手续费返还方式
      GRPID_SUB,                              --组合子交易号
      IMP_TIME,                               --导入时间
      EVAL_YTM,                               --中债收益率
      BND_YTM,                                --到期收益率
      UPDATE_TIME,                            --更新时间
      DUE_AI,                                 --应收未收利息
      OPERATOR_ID,                            --操作人ID
      EXECUTOR_ID,                            --成交确认人ID
      DUE_CP,                                 --应收(付)未收(付)本金
      REAL_AI,                                --实收(付)利息
      REAL_CP,                                --实收(付)本金
      REAL_FEE,                               --实收(付)费用
      DUE_FEE,                                --应收(付)费用
      REF_TYPE,                               --交易类型：1：普通交易；2：父交易；3：子交易
      IS_REMAIN,                              --是否保留应收未收本息 第一位本 第2位利息 ;1 保留2 不保留
      TRADER_ID,                              --交易员ID
      TRADEMODEL,                             --交易模式
      SETTLEMODEL,                            --1：双边清算，2：净额清算
      ORD_ID,                                 --审批单号
      INSSTATUS,                              --1 - 未结算  2 - 结算中 699 - 结算完成
      ENTRUST_REF_ID,                         --代理方关联的委托方ID
      CLOSE_TRADE_ID,                         --指定平仓时，指定核算的交易号
      FTPRATE,                                --FTP利率
      CONN_ORDID,                             --关联的审批单号
      TWO_EFFECTIVE_CONTRACT,                 --双边有效约定
      SOURCE_TYPE,                            --数据来源 1-手工新建|2-下行生成|3-期初余额导入
      SETTLESTATE,                            --0：未结算  1：结算中  2：已结算
      NAVDATE,                                --净值日期
      QCURR_CASH_EXT_ACCID,                   --计价货币本方外部资金账户表
      QCURR_PARTY_BANK_CODE,                  --计价货币对手方银行行号（SWIFTCODE）
      QCURR_PARTY_BANK_NAME,                  --计价货币对手方银行行名
      QCURR_PARTY_ACCT_CODE,                  --计价货币对手方银行账号
      QCURR_PARTY_ACCT_NAME,                  --计价货币对手方银行账户名
      PARTY_MID_BANK_ACCT_CODE,               --基础货币中间行账号
      PARTY_MID_BANK_NAME,                    --基础货币中间行名称
      PARTY_MID_SWIFT_CODE,                   --基础货币中间行SWIFT代码
      QCURR_PARTY_MID_BANK_ACCT_CODE,         --计价货币中间行账号
      QCURR_PARTY_MID_BANK_NAME,              --计价货币中间行名称
      QCURR_PARTY_MID_SWIFT_CODE,             --计价货币中间行SWIFT代码
      PARTY_SWIFT_CODE,                       --对手方基础货币SWIFT代码
      QCURR_PARTY_SWIFT_CODE,                 --对手方计价货币SWIFT代码
      SPV_ID,                                 --清算路径标识
      HIS_TRADEFLAG,                          --历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改
      HIS_REF_TRADEID,                        --历史关联交易号
      HIS_TRADE_SETDATE,                      --历史交易结算日
      PARTY_PSET,                             --结算场所代码
      PARTY_PSET_COUNTRY,                     --国家代码
      PARTY_AGENT_CODE_TYPE,                  --代理行代码类型,1:BIC,2:DSS
      PARTY_AGENT_CODE_DSS,                   --代理行代码编码集合名称
      PARTY_AGENT_CODE,                       --代理行代码
      PARTY_AGENT_ACCOUNT,                    --代理行账号
      PARTY_CODE_TYPE,                        --交易主体代码类型,1:BIC,2:DSS
      PARTY_CODE_DSS,                         --交易主体代码编码集合名称
      PARTY_CODE,                             --交易主体代码
      PARTY_ACCOUNT,                          --交易主体账号
      SI_ID,                                  --证券结算要素ID
      PARTY_I_BANK_CODE,                      --交易对手银行行号
      PARTY_I_SWIFT_CODE,                     --交易对手SWIFTCODE
      SPLIT_INST_TYPE,                        --拆分类型：0不拆分（默认值）；1分拆（券优先）；2分拆（资金优先）
      CM_ATTR_PARENT,                         --父子属性   0：无父子关系的交易 -1：存在父子关系并且当前交易为父交易 >0：存在父子关系并且当前交易为子交易（填写父交易的交易号）
      CM_ATTR_MASTER,                         --主从属性  0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
      CM_ATTR_MERGE,                          --合并属性   0：无合并属性 >0：合并交易的交易号，即生成的合并指令是挂在这个交易上的；具有相同合并交易号的一组交易需要做合并 -1：当前交易为合并交易，即这个交易本身不会结算生成指令，但所有明细交易的合并指令会挂在这个交易下
      CM_ATTR_MIRROR,                         --镜像属性   0：非镜像交易 >0：对应镜像交易的交易号
      CM_ATTR_RELATION,                       --关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
      CAL_START_DATE,                         --计算开始日期
      CAL_END_DATE,                           --计算结束日期
      STRIKE_YTM,                             --行权收益率
      SETTLEMENT_TYPE,                        --交割方式，仅用于前台显示
      AIO_ACCT_NO,                            --AIO账号
      ACCT_TYPE,                              --产品类型
      USER_NAME,                              --客户经理
      CONTRACTPARTY,                          --签约方
      MARKETING_MANAGER_ID,                   --客户经理ID
      MARKETING_ORG_ID,                       --营销机构编号
      COM_DATE,                               --赎回提醒确认日期
      PARTY_BRANCH,                           --交易对手分支机构
      MAX_VAL,                                --上限
      MIN_VAL,                                --下限
      COLLECTION_FST_FEE,                     --分销交易折扣费用
      TRANSFER_TYPE,                          --转账方式
      SECU_SETDATE,                           --券交割日
      CSDC_NETPRICE,                          --中证估值
      CCDC_NETPRICE,                          --中债估值
      SHCH_NETPRICE,                          --清算所估值
      SE_NETPRICE,                            --交易所估值
      CTRCT_ID,                               --合同编号
      PLATFORM,                               --平台
      INVEST_DIRECTION,                       --投向
      CONTRACTVERSION,                        --合同版本号（已审合同:0,送审合同:1,标准合同:2）
      FINAL_INVEST,                           --最终投向类型
      ASSOCIATEDNUMBER,                       --关联序列号
      FIVECLASS,                              --五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
      PROD_NATURE,                            --产品性质
      TRD_ACC_CODE,                           --交易账号
      STORE_CODE,                             --存单号
      QUOTE_TYPE,                             --报价方式(1:对话报价 105:点击成交 107:做市报价 2:限价报价 112:请求报价 113:请求回复报价)
      UNIT_ID,                                --投组单元
      CURCOUNT,                               --当前份额（货币基金份额结转用）
      CAN_DIV_AMOUNT,                         --未结转份额（货币基金份额结转用）
      IS_REMAIN_DUE_AI,                       --是否保留剩余收益
      IS_IMPAIR,                              --金融工具是否减值 1:是 0:否
      OPTION_GROUP,                           --期权组合，详见字典FXOPTIONGROUP
      ENTRY_DATE,                             --交易录入业务日期
      PARTY_PSET_NAME,                        --结算场所名称
      RELATE_INVEST,                          --是否关联投金风控系统
      SETTLEMENT_PLACE,                       --交割场所 1:LONDON 2:SHANGHAI 3:ZURICH 4:NEW YORK
      TRDFEE_NOTSET,                          --不结算手续费字段
      DAYCOUNTER,                             --计息基准
      REMAIN_DUE_CP,                          --是否保留应收未收成本
      INCLUDE_INTE,                           --是否含息转入,0为否，1为是
      EXH_EXTORDID,                           --交易所委托编号
      EXRCISE_STATE,                          --外汇期权行权状态：0:未处理，1:已行权，-1:不行权
      SPPIRESULT,                             --SPPI测试结果
      SPPICLASS,                              --SPPI业务模式
      MERGENO,                                --交易所流水合并号
      RESOURCE_ID,                            --对应菜单RESOURCEID
      PARTY_RELEVANCE_INFO,                   --关联方信息(华兴需求)
      FULL_FLAG,                              --1:全部赎回，2:部分赎回
      BROKERAGE_ID,                           --券商ID
      BROKERAGE_FEE_INFO,                     --券商费用信息
      RELEASED_CREDIT_LINE,                   --桂林银行用释放的授信额度
      OUT_RANGE,                              --转出范围：0只转本金1本息转出
      INTEREST_OUT,                           --转出利息
      BOOK,                                   --会计分类
      XCC_TRADE_GRP_ID,                       --交易组合号
      XCC_PRE_SYSORDID,                       --前一个交易号
      CASH_SETDATE,                           --资金交割日
      BND_YTM_DEVIATE,                        --国债收益率偏离
      TRD_FEE_EXT_SECU_ACCT_ID,               --费用外部证券账户
      PRE_BNT_ORD_ID,                         --关联事前审批单号
      PRE_REMAIN_COUNT,                       --预审批剩余券面总额
      P_ID,                                   --智能活期产品编号
      PARTY_ACC_CODE_TYPE,                    --代码类型
      QCURR_PARTY_ACC_CODE_TYPE,              --代码类型
      FTP_CODE,                               --方案编号
      PC1,                                    --
      YHF,                                    --
      JSF,                                    --
      GHF,                                    --
      ZGF,                                    --
      SXF,                                    --
      BRKFEE,                                 --
      YJF,                                    --
      NETYJF,                                 --
      CON_UPDATE_TIME,                        --
      QCURR_PARTY_RECV_BANK_NAME,             --
      QCURR_PARTY_RECV_BANK_SWIFT,            --
      PARTY_RECV_BANK_NAME,                   --
      PARTY_RECV_BANK_SWIFT_CODE,             --
      OTHER_FEE,                              --
      CLI_ORD_ID,                             --
      PARTY_SWIFT_TYPE,                       --
      QCURR_PARTY_SWIFT_TYPE,                 --
      BACK_BANK_CODE,                         --
      BACK_ACCT_CODE,                         --
      BACK_BANK_NAME,                         --
      BACK_ACCT_NAME,                         --
      OTHER_AGREE_ITEM,                       --
      BANK_GROUP_MODE,                        --
      APR_TXN,                                --批复编号
      REPLY_CODE,                             --额度合同编号
      INCOMEACCOUNT,                          --入息账户
      CREDIT_OCCUPATION_TYPE,                 --授信占用类型:1(白名单额度)2(授信批复额度)
      IS_APPOINT_TIME,                        --是否约期
      APPOINT_START_DATE,                     --约期开始日,是否约期选择是显示且必填
      APPOINT_END_DATE,                       --约期结束日,是否约期选择是显示且必填
      IS_QUARTER_REDEEM,                      --是否当季赎回
      REDEEM_DATE,                            --计划赎回日期
      MIN_RATE,                               --
      MAX_RATE,                               --
      MIN_REPO_INTEREST,                      --
      MAX_REPO_INTEREST,                      --
      CREDIT_ID,                              --
      CONFIRM_STATUS,                         --
      CONFIRMOR,                              --
      CONFIRM_I_ID,                           --
      GUEST_AGREEMENT_NUM,                    --
      GUEST_BUSINESS_NUM,                     --
      CREDIT_SECU_TYPE,                       --
      ETL_DT                                  --ETL处理日期
     )
  SELECT /*+PARALLEL*/
          SYSORDID,                               --交易序号
          ORDDATE,                                --委托日期
          ORDTIME,                                --委托时间
          CONDATE,                                --确认日期
          CONTIME,                                --确认时间
          INSID,                                  --指令号，也叫审批号
          INTORDID,                               --内部交易号
          EXTORDID,                               --外部交易号
          CUSTORDID,                              --客户交易号
          EXTBIZID,                               --外部业务编号
          OPERATOR,                               --操作人
          TRDTYPE,                                --交易类型
          CASH_EXT_ACCID,                         --一级资金账户
          CASH_ACCID,                             --二级资金账户
          SECU_EXT_ACCID,                         --一级证券账户
          SECU_ACCID,                             --二级证券账户
          PARTYID,                                --交易对手
          CP_CASH_ACCID,                          --二级资金账户
          CP_SECU_ACCID,                          --二级证券账户
          I_CODE,                                 --金融工具代码
          A_TYPE,                                 --SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) SPT_ABS:资产证券化产品(ABS、MBS、CDO) SPT_CB:可转换债券 SPT_DB:债务 SPT_IBOR:同业拆借 SPT_IBDEPO:同业存款 SPT_C:现金 SPT_F1:封闭式基金 SPT_F2:开放式基金 SPT_F3:交易所交易基金 SPT_STG_1:期限套利 SPT_STG_2:跨期套利 SPT_PG:配股 SPT_IR:利率 SPT_CP:商业票据 SPT_DED:活期存款 SPT_NTD:通知存款(1天通知存款、7天通知存款) SPT_TMD:定期存款(3个月、半年、1年、3年、5年) SPT_NGD:协议存款(期限确定，利率协商确定的存款) SPT_REPO:回购 SPT_XR:汇率
          M_TYPE,                                 --XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
          I_NAME,                                 --金融工具名称
          ORDCOUNT,                               --交易数量（应收本金）
          ORDPRICE,                               --交易价格
          ORDAMOUNT,                              --交易金额
          TRDFEE,                                 --交易费用
          SETFEE,                                 --结算费用
          SETDAYS,                                --清算速度
          SETDATE,                                --结算日期
          THENMKTPRICE,                           --当时市场价
          THENMKTPRICE_U,                         --当时标的市场价
          ORDSTATUS,                              ---2：未通过审批;-1：已通过审批;-3：部分成交的审批单 审批单更改后生成交易单,由于交易要素修改则新建交易单，原TRADE的状态改为-3;-4：审批单分多次成交完毕;0：新建;3：创建指令成功;4：成交确认;5：已撤销;6：成交失败
          ERRCODE,                                --错误代码
          ERRINFO,                                --错误信息
          BND_SETTYPE,                            --结算方式
          BND_NETPRICE,                           --净价金额
          BND_AIAMOUNT,                           --应收利息
          REMARK,                                 --备注信息
          RESERVETYPE,                            --本方保证方式
          CP_RESERVETYPE,                         --对方保证方式
          RESERVECHG,                             --本方保证可否变更
          CP_RESERVECHG,                          --对方保证可否变更
          RESERVEVALUE,                           --本方保证总额
          CP_RESERVEVALUE,                        --对方保证总额
          RESOLVE,                                --争议解决方式
          TRADE_GRP_ID,                           --合并指令ID
          REF_ORDDATE,                            --等待补充
          REF_SYSORDID,                           --引用交易流水号
          IGNORE_FLAG,                            --1=忽略，0=不忽略，主要是针对开放式回购的现券交易
          EXE_MARKET,                             --交易执行市场
          TRADER,                                 --经办人
          TRADER_CP,                              --等待补充
          DEALTYPE,                               --成交方式
          AGREENUMBER,                            --大宗交易要素的约定号
          EVAL_NETPRICE,                          --净价跟中债估值净价的偏移度 【VALUE=(中债估值净价-交易净价)/中债估值净价】
          ORDSOURCE,                              --交易来源：-1：次交易；0：内部交易；1：外部交易
          DEAL_COUNT,                             --已成交数量
          DEAL_AVG_NETPRICE,                      --平均成交净价价格
          DEAL_NETAMOUNT,                         --净价成交金额
          DEAL_AIAMOUNT,                          --实收利息
          DEAL_AMOUNT,                            --实收金额
          BIDASKID,                               --双边报价互存交易编号
          RELATEDPARTY,                           --是否关联机构
          TERMINATE_AMOUNT,                       --等待补充
          SETDATE_TERMINATE,                      --等待补充
          AGREEMENTTYPE,                          --等待补充
          PARTYNAMETEMPORITY,                     --等待补充
          PARTY_ZZDACCNAME,                       --交易对手中债登名称
          SEATNO_CP,                              --等待补充
          EXECUTOR,                               --交易员
          UNION_SYSORDID,                         --等待补充
          PARTY_ZZDACCCODE,                       --交易对手中债登账户
          PARTY_BANK_CODE,                        --交易对手开户行号
          PARTY_ACCT_CODE,                        --交易对手帐号
          PARTY_BANK_NAME,                        --交易对手开户行名
          PARTY_ACCT_NAME,                        --交易对手帐号名称
          DIS_FEE_KIND_FOLLOW,                    --尾随手续费返还方式
          DIS_FEE_KIND,                           --手续费返还方式
          GRPID_SUB,                              --组合子交易号
          IMP_TIME,                               --导入时间
          EVAL_YTM,                               --中债收益率
          BND_YTM,                                --到期收益率
          UPDATE_TIME,                            --更新时间
          DUE_AI,                                 --应收未收利息
          OPERATOR_ID,                            --操作人ID
          EXECUTOR_ID,                            --成交确认人ID
          DUE_CP,                                 --应收(付)未收(付)本金
          REAL_AI,                                --实收(付)利息
          REAL_CP,                                --实收(付)本金
          REAL_FEE,                               --实收(付)费用
          DUE_FEE,                                --应收(付)费用
          REF_TYPE,                               --交易类型：1：普通交易；2：父交易；3：子交易
          IS_REMAIN,                              --是否保留应收未收本息 第一位本 第2位利息 ;1 保留2 不保留
          TRADER_ID,                              --交易员ID
          TRADEMODEL,                             --交易模式
          SETTLEMODEL,                            --1：双边清算，2：净额清算
          ORD_ID,                                 --审批单号
          INSSTATUS,                              --1 - 未结算  2 - 结算中 699 - 结算完成
          ENTRUST_REF_ID,                         --代理方关联的委托方ID
          CLOSE_TRADE_ID,                         --指定平仓时，指定核算的交易号
          FTPRATE,                                --FTP利率
          CONN_ORDID,                             --关联的审批单号
          TWO_EFFECTIVE_CONTRACT,                 --双边有效约定
          SOURCE_TYPE,                            --数据来源 1-手工新建|2-下行生成|3-期初余额导入
          SETTLESTATE,                            --0：未结算  1：结算中  2：已结算
          NAVDATE,                                --净值日期
          QCURR_CASH_EXT_ACCID,                   --计价货币本方外部资金账户表
          QCURR_PARTY_BANK_CODE,                  --计价货币对手方银行行号（SWIFTCODE）
          QCURR_PARTY_BANK_NAME,                  --计价货币对手方银行行名
          QCURR_PARTY_ACCT_CODE,                  --计价货币对手方银行账号
          QCURR_PARTY_ACCT_NAME,                  --计价货币对手方银行账户名
          PARTY_MID_BANK_ACCT_CODE,               --基础货币中间行账号
          PARTY_MID_BANK_NAME,                    --基础货币中间行名称
          PARTY_MID_SWIFT_CODE,                   --基础货币中间行SWIFT代码
          QCURR_PARTY_MID_BANK_ACCT_CODE,         --计价货币中间行账号
          QCURR_PARTY_MID_BANK_NAME,              --计价货币中间行名称
          QCURR_PARTY_MID_SWIFT_CODE,             --计价货币中间行SWIFT代码
          PARTY_SWIFT_CODE,                       --对手方基础货币SWIFT代码
          QCURR_PARTY_SWIFT_CODE,                 --对手方计价货币SWIFT代码
          SPV_ID,                                 --清算路径标识
          HIS_TRADEFLAG,                          --历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改
          HIS_REF_TRADEID,                        --历史关联交易号
          HIS_TRADE_SETDATE,                      --历史交易结算日
          PARTY_PSET,                             --结算场所代码
          PARTY_PSET_COUNTRY,                     --国家代码
          PARTY_AGENT_CODE_TYPE,                  --代理行代码类型,1:BIC,2:DSS
          PARTY_AGENT_CODE_DSS,                   --代理行代码编码集合名称
          PARTY_AGENT_CODE,                       --代理行代码
          PARTY_AGENT_ACCOUNT,                    --代理行账号
          PARTY_CODE_TYPE,                        --交易主体代码类型,1:BIC,2:DSS
          PARTY_CODE_DSS,                         --交易主体代码编码集合名称
          PARTY_CODE,                             --交易主体代码
          PARTY_ACCOUNT,                          --交易主体账号
          SI_ID,                                  --证券结算要素ID
          PARTY_I_BANK_CODE,                      --交易对手银行行号
          PARTY_I_SWIFT_CODE,                     --交易对手SWIFTCODE
          SPLIT_INST_TYPE,                        --拆分类型：0不拆分（默认值）；1分拆（券优先）；2分拆（资金优先）
          CM_ATTR_PARENT,                         --父子属性   0：无父子关系的交易 -1：存在父子关系并且当前交易为父交易 >0：存在父子关系并且当前交易为子交易（填写父交易的交易号）
          CM_ATTR_MASTER,                         --主从属性  0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
          CM_ATTR_MERGE,                          --合并属性   0：无合并属性 >0：合并交易的交易号，即生成的合并指令是挂在这个交易上的；具有相同合并交易号的一组交易需要做合并 -1：当前交易为合并交易，即这个交易本身不会结算生成指令，但所有明细交易的合并指令会挂在这个交易下
          CM_ATTR_MIRROR,                         --镜像属性   0：非镜像交易 >0：对应镜像交易的交易号
          CM_ATTR_RELATION,                       --关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
          CAL_START_DATE,                         --计算开始日期
          CAL_END_DATE,                           --计算结束日期
          STRIKE_YTM,                             --行权收益率
          SETTLEMENT_TYPE,                        --交割方式，仅用于前台显示
          AIO_ACCT_NO,                            --AIO账号
          ACCT_TYPE,                              --产品类型
          USER_NAME,                              --客户经理
          CONTRACTPARTY,                          --签约方
          MARKETING_MANAGER_ID,                   --客户经理ID
          MARKETING_ORG_ID,                       --营销机构编号
          COM_DATE,                               --赎回提醒确认日期
          PARTY_BRANCH,                           --交易对手分支机构
          MAX_VAL,                                --上限
          MIN_VAL,                                --下限
          COLLECTION_FST_FEE,                     --分销交易折扣费用
          TRANSFER_TYPE,                          --转账方式
          SECU_SETDATE,                           --券交割日
          CSDC_NETPRICE,                          --中证估值
          CCDC_NETPRICE,                          --中债估值
          SHCH_NETPRICE,                          --清算所估值
          SE_NETPRICE,                            --交易所估值
          CTRCT_ID,                               --合同编号
          PLATFORM,                               --平台
          INVEST_DIRECTION,                       --投向
          CONTRACTVERSION,                        --合同版本号（已审合同:0,送审合同:1,标准合同:2）
          FINAL_INVEST,                           --最终投向类型
          ASSOCIATEDNUMBER,                       --关联序列号
          FIVECLASS,                              --五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
          PROD_NATURE,                            --产品性质
          TRD_ACC_CODE,                           --交易账号
          STORE_CODE,                             --存单号
          QUOTE_TYPE,                             --报价方式(1:对话报价 105:点击成交 107:做市报价 2:限价报价 112:请求报价 113:请求回复报价)
          UNIT_ID,                                --投组单元
          CURCOUNT,                               --当前份额（货币基金份额结转用）
          CAN_DIV_AMOUNT,                         --未结转份额（货币基金份额结转用）
          IS_REMAIN_DUE_AI,                       --是否保留剩余收益
          IS_IMPAIR,                              --金融工具是否减值 1:是 0:否
          OPTION_GROUP,                           --期权组合，详见字典FXOPTIONGROUP
          ENTRY_DATE,                             --交易录入业务日期
          PARTY_PSET_NAME,                        --结算场所名称
          RELATE_INVEST,                          --是否关联投金风控系统
          SETTLEMENT_PLACE,                       --交割场所 1:LONDON 2:SHANGHAI 3:ZURICH 4:NEW YORK
          TRDFEE_NOTSET,                          --不结算手续费字段
          DAYCOUNTER,                             --计息基准
          REMAIN_DUE_CP,                          --是否保留应收未收成本
          INCLUDE_INTE,                           --是否含息转入,0为否，1为是
          EXH_EXTORDID,                           --交易所委托编号
          EXRCISE_STATE,                          --外汇期权行权状态：0:未处理，1:已行权，-1:不行权
          SPPIRESULT,                             --SPPI测试结果
          SPPICLASS,                              --SPPI业务模式
          MERGENO,                                --交易所流水合并号
          RESOURCE_ID,                            --对应菜单RESOURCEID
          PARTY_RELEVANCE_INFO,                   --关联方信息(华兴需求)
          FULL_FLAG,                              --1:全部赎回，2:部分赎回
          BROKERAGE_ID,                           --券商ID
          BROKERAGE_FEE_INFO,                     --券商费用信息
          RELEASED_CREDIT_LINE,                   --桂林银行用释放的授信额度
          OUT_RANGE,                              --转出范围：0只转本金1本息转出
          INTEREST_OUT,                           --转出利息
          BOOK,                                   --会计分类
          XCC_TRADE_GRP_ID,                       --交易组合号
          XCC_PRE_SYSORDID,                       --前一个交易号
          CASH_SETDATE,                           --资金交割日
          BND_YTM_DEVIATE,                        --国债收益率偏离
          TRD_FEE_EXT_SECU_ACCT_ID,               --费用外部证券账户
          PRE_BNT_ORD_ID,                         --关联事前审批单号
          PRE_REMAIN_COUNT,                       --预审批剩余券面总额
          P_ID,                                   --智能活期产品编号
          PARTY_ACC_CODE_TYPE,                    --代码类型
          QCURR_PARTY_ACC_CODE_TYPE,              --代码类型
          FTP_CODE,                               --方案编号
          PC1,                                    --
          YHF,                                    --
          JSF,                                    --
          GHF,                                    --
          ZGF,                                    --
          SXF,                                    --
          BRKFEE,                                 --
          YJF,                                    --
          NETYJF,                                 --
          CON_UPDATE_TIME,                        --
          QCURR_PARTY_RECV_BANK_NAME,             --
          QCURR_PARTY_RECV_BANK_SWIFT,            --
          PARTY_RECV_BANK_NAME,                   --
          PARTY_RECV_BANK_SWIFT_CODE,             --
          OTHER_FEE,                              --
          CLI_ORD_ID,                             --
          PARTY_SWIFT_TYPE,                       --
          QCURR_PARTY_SWIFT_TYPE,                 --
          BACK_BANK_CODE,                         --
          BACK_ACCT_CODE,                         --
          BACK_BANK_NAME,                         --
          BACK_ACCT_NAME,                         --
          OTHER_AGREE_ITEM,                       --
          BANK_GROUP_MODE,                        --
          APR_TXN,                                --批复编号
          REPLY_CODE,                             --额度合同编号
          INCOMEACCOUNT,                          --入息账户
          CREDIT_OCCUPATION_TYPE,                 --授信占用类型:1(白名单额度)2(授信批复额度)
          IS_APPOINT_TIME,                        --是否约期
          APPOINT_START_DATE,                     --约期开始日,是否约期选择是显示且必填
          APPOINT_END_DATE,                       --约期结束日,是否约期选择是显示且必填
          IS_QUARTER_REDEEM,                      --是否当季赎回
          REDEEM_DATE,                            --计划赎回日期
          MIN_RATE,                               --
          MAX_RATE,                               --
          MIN_REPO_INTEREST,                      --
          MAX_REPO_INTEREST,                      --
          CREDIT_ID,                              --
          CONFIRM_STATUS,                         --
          CONFIRMOR,                              --
          CONFIRM_I_ID,                           --
          GUEST_AGREEMENT_NUM,                    --
          GUEST_BUSINESS_NUM,                     --
          CREDIT_SECU_TYPE,                       --
          ETL_DT                                  --ETL处理日期
    FROM IOL.V_IBMS_TTRD_OTC_TRADE   --交易单表_视图
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

  END ETL_INIT_O_IOL_IBMS_TTRD_OTC_TRADE;
/

