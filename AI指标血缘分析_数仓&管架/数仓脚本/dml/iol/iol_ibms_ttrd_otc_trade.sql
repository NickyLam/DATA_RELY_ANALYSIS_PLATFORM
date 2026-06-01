/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_otc_trade
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_otc_trade_ex purge;
alter table ${iol_schema}.ibms_ttrd_otc_trade add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.ibms_ttrd_otc_trade;

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_otc_trade_ex nologging
compress
as
select * from ${iol_schema}.ibms_ttrd_otc_trade where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_otc_trade_ex(
    sysordid -- 交易序号
    ,orddate -- 委托日期
    ,ordtime -- 委托时间
    ,condate -- 确认日期
    ,contime -- 确认时间
    ,insid -- 指令号，也叫审批号
    ,intordid -- 内部交易号
    ,extordid -- 外部交易号
    ,custordid -- 客户交易号
    ,extbizid -- 外部业务编号
    ,operator -- 操作人
    ,trdtype -- 交易类型
    ,cash_ext_accid -- 一级资金账户
    ,cash_accid -- 二级资金账户
    ,secu_ext_accid -- 一级证券账户
    ,secu_accid -- 二级证券账户
    ,partyid -- 交易对手
    ,cp_cash_accid -- 二级资金账户
    ,cp_secu_accid -- 二级证券账户
    ,i_code -- 金融工具代码
    ,a_type -- SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) SPT_ABS:资产证券化产品(ABS、MBS、CDO) SPT_CB:可转换债券 SPT_DB:债务 SPT_IBOR:同业拆借 SPT_IBDEPO:同业存款 SPT_C:现金 SPT_F1:封闭式基金 SPT_F2:开放式基金 SPT_F3:交易所交易基金 SPT_STG_1:期限套利 SPT_STG_2:跨期套利 SPT_PG:配股 SPT_IR:利率 SPT_CP:商业票据 SPT_DED:活期存款 SPT_NTD:通知存款(1天通知存款、7天通知存款) SPT_TMD:定期存款(3个月、半年、1年、3年、5年) SPT_NGD:协议存款(期限确定，利率协商确定的存款) SPT_REPO:回购 SPT_XR:汇率
    ,m_type -- XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
    ,i_name -- 金融工具名称
    ,ordcount -- 交易数量（应收本金）
    ,ordprice -- 交易价格
    ,ordamount -- 交易金额
    ,trdfee -- 交易费用
    ,setfee -- 结算费用
    ,setdays -- 清算速度
    ,setdate -- 结算日期
    ,thenmktprice -- 当时市场价
    ,thenmktprice_u -- 当时标的市场价
    ,ordstatus -- -2：未通过审批;-1：已通过审批;-3：部分成交的审批单 审批单更改后生成交易单,由于交易要素修改则新建交易单，原trade的状态改为-3;-4：审批单分多次成交完毕;0：新建;3：创建指令成功;4：成交确认;5：已撤销;6：成交失败
    ,errcode -- 错误代码
    ,errinfo -- 错误信息
    ,bnd_settype -- 结算方式
    ,bnd_netprice -- 净价金额
    ,bnd_aiamount -- 应收利息
    ,remark -- 备注信息
    ,reservetype -- 本方保证方式
    ,cp_reservetype -- 对方保证方式
    ,reservechg -- 本方保证可否变更
    ,cp_reservechg -- 对方保证可否变更
    ,reservevalue -- 本方保证总额
    ,cp_reservevalue -- 对方保证总额
    ,resolve -- 争议解决方式
    ,trade_grp_id -- 合并指令ID
    ,ref_orddate -- 等待补充
    ,ref_sysordid -- 引用交易流水号
    ,ignore_flag -- 1=忽略，0=不忽略，主要是针对开放式回购的现券交易
    ,exe_market -- 交易执行市场
    ,trader -- 经办人
    ,trader_cp -- 等待补充
    ,dealtype -- 成交方式
    ,agreenumber -- 大宗交易要素的约定号
    ,eval_netprice -- 净价跟中债估值净价的偏移度 【value=(中债估值净价-交易净价)/中债估值净价】
    ,ordsource -- 交易来源：-1：次交易；0：内部交易；1：外部交易
    ,deal_count -- 已成交数量
    ,deal_avg_netprice -- 平均成交净价价格
    ,deal_netamount -- 净价成交金额
    ,deal_aiamount -- 实收利息
    ,deal_amount -- 实收金额
    ,bidaskid -- 双边报价互存交易编号
    ,relatedparty -- 是否关联机构
    ,terminate_amount -- 等待补充
    ,setdate_terminate -- 等待补充
    ,agreementtype -- 等待补充
    ,partynametempority -- 等待补充
    ,party_zzdaccname -- 交易对手中债登名称
    ,seatno_cp -- 等待补充
    ,executor -- 交易员
    ,union_sysordid -- 等待补充
    ,party_zzdacccode -- 交易对手中债登账户
    ,party_bank_code -- 交易对手开户行号
    ,party_acct_code -- 交易对手帐号
    ,party_bank_name -- 交易对手开户行名
    ,party_acct_name -- 交易对手帐号名称
    ,dis_fee_kind_follow -- 尾随手续费返还方式
    ,dis_fee_kind -- 手续费返还方式
    ,grpid_sub -- 组合子交易号
    ,imp_time -- 导入时间
    ,eval_ytm -- 中债收益率
    ,bnd_ytm -- 到期收益率
    ,update_time -- 更新时间
    ,due_ai -- 应收未收利息
    ,operator_id -- 操作人id
    ,executor_id -- 成交确认人id
    ,due_cp -- 应收(付)未收(付)本金
    ,real_ai -- 实收(付)利息
    ,real_cp -- 实收(付)本金
    ,real_fee -- 实收(付)费用
    ,due_fee -- 应收(付)费用
    ,ref_type -- 交易类型：1：普通交易；2：父交易；3：子交易
    ,is_remain -- 是否保留应收未收本息 第一位本 第2位利息 ;1 保留2 不保留
    ,trader_id -- 交易员id
    ,trademodel -- 交易模式
    ,settlemodel -- 1：双边清算，2：净额清算
    ,ord_id -- 审批单号
    ,insstatus -- 1 - 未结算  2 - 结算中 699 - 结算完成
    ,entrust_ref_id -- 代理方关联的委托方ID
    ,close_trade_id -- 指定平仓时，指定核算的交易号
    ,ftprate -- FTP利率
    ,conn_ordid -- 关联的审批单号
    ,two_effective_contract -- 双边有效约定
    ,source_type -- 数据来源 1-手工新建|2-下行生成|3-期初余额导入
    ,settlestate -- 0：未结算  1：结算中  2：已结算
    ,navdate -- 净值日期
    ,qcurr_cash_ext_accid -- 计价货币本方外部资金账户表
    ,qcurr_party_bank_code -- 计价货币对手方银行行号（swiftCode）
    ,qcurr_party_bank_name -- 计价货币对手方银行行名
    ,qcurr_party_acct_code -- 计价货币对手方银行账号
    ,qcurr_party_acct_name -- 计价货币对手方银行账户名
    ,party_mid_bank_acct_code -- 基础货币中间行账号
    ,party_mid_bank_name -- 基础货币中间行名称
    ,party_mid_swift_code -- 基础货币中间行SWIFT代码
    ,qcurr_party_mid_bank_acct_code -- 计价货币中间行账号
    ,qcurr_party_mid_bank_name -- 计价货币中间行名称
    ,qcurr_party_mid_swift_code -- 计价货币中间行SWIFT代码
    ,party_swift_code -- 对手方基础货币swift代码
    ,qcurr_party_swift_code -- 对手方计价货币swift代码
    ,spv_id -- 清算路径标识
    ,his_tradeflag -- 历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改
    ,his_ref_tradeid -- 历史关联交易号
    ,his_trade_setdate -- 历史交易结算日
    ,party_pset -- 结算场所代码
    ,party_pset_country -- 国家代码
    ,party_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
    ,party_agent_code_dss -- 代理行代码编码集合名称
    ,party_agent_code -- 代理行代码
    ,party_agent_account -- 代理行账号
    ,party_code_type -- 交易主体代码类型,1:BIC,2:DSS
    ,party_code_dss -- 交易主体代码编码集合名称
    ,party_code -- 交易主体代码
    ,party_account -- 交易主体账号
    ,si_id -- 证券结算要素ID
    ,party_i_bank_code -- 交易对手银行行号
    ,party_i_swift_code -- 交易对手swiftCode
    ,split_inst_type -- 拆分类型：0不拆分（默认值）；1分拆（券优先）；2分拆（资金优先）
    ,cm_attr_parent -- 父子属性 	0：无父子关系的交易 -1：存在父子关系并且当前交易为父交易 >0：存在父子关系并且当前交易为子交易（填写父交易的交易号）
    ,cm_attr_master -- 主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
    ,cm_attr_merge -- 合并属性 	0：无合并属性 >0：合并交易的交易号，即生成的合并指令是挂在这个交易上的；具有相同合并交易号的一组交易需要做合并 -1：当前交易为合并交易，即这个交易本身不会结算生成指令，但所有明细交易的合并指令会挂在这个交易下
    ,cm_attr_mirror -- 镜像属性 	0：非镜像交易 >0：对应镜像交易的交易号
    ,cm_attr_relation -- 关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
    ,cal_start_date -- 计算开始日期
    ,cal_end_date -- 计算结束日期
    ,strike_ytm -- 行权收益率
    ,settlement_type -- 交割方式，仅用于前台显示
    ,aio_acct_no -- AIO账号
    ,acct_type -- 产品类型
    ,user_name -- 客户经理
    ,contractparty -- 签约方
    ,marketing_manager_id -- 客户经理ID
    ,marketing_org_id -- 营销机构编号
    ,com_date -- 赎回提醒确认日期
    ,party_branch -- 交易对手分支机构
    ,max_val -- 上限
    ,min_val -- 下限
    ,collection_fst_fee -- 分销交易折扣费用
    ,transfer_type -- 转账方式
    ,secu_setdate -- 券交割日
    ,csdc_netprice -- 中证估值
    ,ccdc_netprice -- 中债估值
    ,shch_netprice -- 清算所估值
    ,se_netprice -- 交易所估值
    ,ctrct_id -- 合同编号
    ,platform -- 平台
    ,invest_direction -- 投向
    ,contractversion -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
    ,final_invest -- 最终投向类型
    ,associatednumber -- 关联序列号
    ,fiveclass -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
    ,prod_nature -- 产品性质
    ,trd_acc_code -- 交易账号
    ,store_code -- 存单号
    ,quote_type -- 报价方式(1:对话报价 105:点击成交 107:做市报价 2:限价报价 112:请求报价 113:请求回复报价)
    ,unit_id -- 投组单元
    ,curcount -- 当前份额（货币基金份额结转用）
    ,can_div_amount -- 未结转份额（货币基金份额结转用）
    ,is_remain_due_ai -- 是否保留剩余收益
    ,is_impair -- 金融工具是否减值 1:是 0:否
    ,option_group -- 期权组合，详见字典fxOptionGroup
    ,entry_date -- 交易录入业务日期
    ,party_pset_name -- 结算场所名称
    ,relate_invest -- 是否关联投金风控系统
    ,settlement_place -- 交割场所 1:LONDON 2:SHANGHAI 3:ZURICH 4:NEW YORK
    ,trdfee_notset -- 不结算手续费字段
    ,daycounter -- 计息基准
    ,remain_due_cp -- 是否保留应收未收成本
    ,include_inte -- 是否含息转入,0为否，1为是
    ,exh_extordid -- 交易所委托编号
    ,exrcise_state -- 外汇期权行权状态：0:未处理，1:已行权，-1:不行权
    ,sppiresult -- SPPI测试结果
    ,sppiclass -- SPPI业务模式
    ,mergeno -- 交易所流水合并号
    ,resource_id -- 对应菜单resourceId
    ,party_relevance_info -- 关联方信息(华兴需求)
    ,full_flag -- 1:全部赎回，2:部分赎回
    ,brokerage_id -- 券商ID
    ,brokerage_fee_info -- 券商费用信息
    ,released_credit_line -- 桂林银行用释放的授信额度
    ,out_range -- 转出范围：0只转本金1本息转出
    ,interest_out -- 转出利息
    ,book -- 会计分类
    ,xcc_trade_grp_id -- 交易组合号
    ,xcc_pre_sysordid -- 前一个交易号
    ,cash_setdate -- 资金交割日
    ,bnd_ytm_deviate -- 国债收益率偏离
    ,trd_fee_ext_secu_acct_id -- 费用外部证券账户
    ,pre_bnt_ord_id -- 关联事前审批单号
    ,pre_remain_count -- 预审批剩余券面总额
    ,p_id -- 智能活期产品编号
    ,party_acc_code_type -- 代码类型
    ,qcurr_party_acc_code_type -- 代码类型
    ,ftp_code -- 方案编号
    ,pc1 -- 
    ,yhf -- 
    ,jsf -- 
    ,ghf -- 
    ,zgf -- 
    ,sxf -- 
    ,brkfee -- 
    ,yjf -- 
    ,netyjf -- 
    ,con_update_time -- 
    ,qcurr_party_recv_bank_name -- 
    ,qcurr_party_recv_bank_swift -- 
    ,party_recv_bank_name -- 
    ,party_recv_bank_swift_code -- 
    ,other_fee -- 
    ,cli_ord_id -- 
    ,party_swift_type -- 
    ,qcurr_party_swift_type -- 
    ,back_bank_code -- 
    ,back_acct_code -- 
    ,back_bank_name -- 
    ,back_acct_name -- 
    ,other_agree_item -- 
    ,bank_group_mode -- 
    ,apr_txn -- 批复编号
    ,reply_code -- 额度合同编号
    ,incomeaccount -- 入息账户
    ,credit_occupation_type -- 授信占用类型:1(白名单额度)2(授信批复额度)
    ,is_appoint_time -- 是否约期
    ,appoint_start_date -- 约期开始日,是否约期选择是显示且必填
    ,appoint_end_date -- 约期结束日,是否约期选择是显示且必填
    ,is_quarter_redeem -- 是否当季赎回
    ,redeem_date -- 计划赎回日期
    ,min_rate -- 
    ,max_rate -- 
    ,min_repo_interest -- 
    ,max_repo_interest -- 
    ,credit_id -- 
    ,confirm_status -- 
    ,confirmor -- 
    ,confirm_i_id -- 
    ,guest_agreement_num -- 
    ,guest_business_num -- 
    ,credit_secu_type -- 
    ,ai -- 应计利息
    ,swift_ids -- swift报文id，逗号隔开
    ,set_price -- 现券结算价格，0:净价结算,结算金额=净价*份额+总应计利息；1:全价结算,结算金额=全价*份额
    ,sub_acct -- 子户号,调用接口返回字段保存
    ,search_ai -- 调用接口返回利息
    ,search_balance -- 调用接口返回余额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    sysordid -- 交易序号
    ,orddate -- 委托日期
    ,ordtime -- 委托时间
    ,condate -- 确认日期
    ,contime -- 确认时间
    ,insid -- 指令号，也叫审批号
    ,intordid -- 内部交易号
    ,extordid -- 外部交易号
    ,custordid -- 客户交易号
    ,extbizid -- 外部业务编号
    ,operator -- 操作人
    ,trdtype -- 交易类型
    ,cash_ext_accid -- 一级资金账户
    ,cash_accid -- 二级资金账户
    ,secu_ext_accid -- 一级证券账户
    ,secu_accid -- 二级证券账户
    ,partyid -- 交易对手
    ,cp_cash_accid -- 二级资金账户
    ,cp_secu_accid -- 二级证券账户
    ,i_code -- 金融工具代码
    ,a_type -- SPT_BD:债券(国债、企业债、金融债、次级债券等,央行票据) SPT_ABS:资产证券化产品(ABS、MBS、CDO) SPT_CB:可转换债券 SPT_DB:债务 SPT_IBOR:同业拆借 SPT_IBDEPO:同业存款 SPT_C:现金 SPT_F1:封闭式基金 SPT_F2:开放式基金 SPT_F3:交易所交易基金 SPT_STG_1:期限套利 SPT_STG_2:跨期套利 SPT_PG:配股 SPT_IR:利率 SPT_CP:商业票据 SPT_DED:活期存款 SPT_NTD:通知存款(1天通知存款、7天通知存款) SPT_TMD:定期存款(3个月、半年、1年、3年、5年) SPT_NGD:协议存款(期限确定，利率协商确定的存款) SPT_REPO:回购 SPT_XR:汇率
    ,m_type -- XSHG: 上交所 XSHE:深交所 X_CNFFEX;中金所 X_CNBD;银行间
    ,i_name -- 金融工具名称
    ,ordcount -- 交易数量（应收本金）
    ,ordprice -- 交易价格
    ,ordamount -- 交易金额
    ,trdfee -- 交易费用
    ,setfee -- 结算费用
    ,setdays -- 清算速度
    ,setdate -- 结算日期
    ,thenmktprice -- 当时市场价
    ,thenmktprice_u -- 当时标的市场价
    ,ordstatus -- -2：未通过审批;-1：已通过审批;-3：部分成交的审批单 审批单更改后生成交易单,由于交易要素修改则新建交易单，原trade的状态改为-3;-4：审批单分多次成交完毕;0：新建;3：创建指令成功;4：成交确认;5：已撤销;6：成交失败
    ,errcode -- 错误代码
    ,errinfo -- 错误信息
    ,bnd_settype -- 结算方式
    ,bnd_netprice -- 净价金额
    ,bnd_aiamount -- 应收利息
    ,remark -- 备注信息
    ,reservetype -- 本方保证方式
    ,cp_reservetype -- 对方保证方式
    ,reservechg -- 本方保证可否变更
    ,cp_reservechg -- 对方保证可否变更
    ,reservevalue -- 本方保证总额
    ,cp_reservevalue -- 对方保证总额
    ,resolve -- 争议解决方式
    ,trade_grp_id -- 合并指令ID
    ,ref_orddate -- 等待补充
    ,ref_sysordid -- 引用交易流水号
    ,ignore_flag -- 1=忽略，0=不忽略，主要是针对开放式回购的现券交易
    ,exe_market -- 交易执行市场
    ,trader -- 经办人
    ,trader_cp -- 等待补充
    ,dealtype -- 成交方式
    ,agreenumber -- 大宗交易要素的约定号
    ,eval_netprice -- 净价跟中债估值净价的偏移度 【value=(中债估值净价-交易净价)/中债估值净价】
    ,ordsource -- 交易来源：-1：次交易；0：内部交易；1：外部交易
    ,deal_count -- 已成交数量
    ,deal_avg_netprice -- 平均成交净价价格
    ,deal_netamount -- 净价成交金额
    ,deal_aiamount -- 实收利息
    ,deal_amount -- 实收金额
    ,bidaskid -- 双边报价互存交易编号
    ,relatedparty -- 是否关联机构
    ,terminate_amount -- 等待补充
    ,setdate_terminate -- 等待补充
    ,agreementtype -- 等待补充
    ,partynametempority -- 等待补充
    ,party_zzdaccname -- 交易对手中债登名称
    ,seatno_cp -- 等待补充
    ,executor -- 交易员
    ,union_sysordid -- 等待补充
    ,party_zzdacccode -- 交易对手中债登账户
    ,party_bank_code -- 交易对手开户行号
    ,party_acct_code -- 交易对手帐号
    ,party_bank_name -- 交易对手开户行名
    ,party_acct_name -- 交易对手帐号名称
    ,dis_fee_kind_follow -- 尾随手续费返还方式
    ,dis_fee_kind -- 手续费返还方式
    ,grpid_sub -- 组合子交易号
    ,imp_time -- 导入时间
    ,eval_ytm -- 中债收益率
    ,bnd_ytm -- 到期收益率
    ,update_time -- 更新时间
    ,due_ai -- 应收未收利息
    ,operator_id -- 操作人id
    ,executor_id -- 成交确认人id
    ,due_cp -- 应收(付)未收(付)本金
    ,real_ai -- 实收(付)利息
    ,real_cp -- 实收(付)本金
    ,real_fee -- 实收(付)费用
    ,due_fee -- 应收(付)费用
    ,ref_type -- 交易类型：1：普通交易；2：父交易；3：子交易
    ,is_remain -- 是否保留应收未收本息 第一位本 第2位利息 ;1 保留2 不保留
    ,trader_id -- 交易员id
    ,trademodel -- 交易模式
    ,settlemodel -- 1：双边清算，2：净额清算
    ,ord_id -- 审批单号
    ,insstatus -- 1 - 未结算  2 - 结算中 699 - 结算完成
    ,entrust_ref_id -- 代理方关联的委托方ID
    ,close_trade_id -- 指定平仓时，指定核算的交易号
    ,ftprate -- FTP利率
    ,conn_ordid -- 关联的审批单号
    ,two_effective_contract -- 双边有效约定
    ,source_type -- 数据来源 1-手工新建|2-下行生成|3-期初余额导入
    ,settlestate -- 0：未结算  1：结算中  2：已结算
    ,navdate -- 净值日期
    ,qcurr_cash_ext_accid -- 计价货币本方外部资金账户表
    ,qcurr_party_bank_code -- 计价货币对手方银行行号（swiftCode）
    ,qcurr_party_bank_name -- 计价货币对手方银行行名
    ,qcurr_party_acct_code -- 计价货币对手方银行账号
    ,qcurr_party_acct_name -- 计价货币对手方银行账户名
    ,party_mid_bank_acct_code -- 基础货币中间行账号
    ,party_mid_bank_name -- 基础货币中间行名称
    ,party_mid_swift_code -- 基础货币中间行SWIFT代码
    ,qcurr_party_mid_bank_acct_code -- 计价货币中间行账号
    ,qcurr_party_mid_bank_name -- 计价货币中间行名称
    ,qcurr_party_mid_swift_code -- 计价货币中间行SWIFT代码
    ,party_swift_code -- 对手方基础货币swift代码
    ,qcurr_party_swift_code -- 对手方计价货币swift代码
    ,spv_id -- 清算路径标识
    ,his_tradeflag -- 历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改
    ,his_ref_tradeid -- 历史关联交易号
    ,his_trade_setdate -- 历史交易结算日
    ,party_pset -- 结算场所代码
    ,party_pset_country -- 国家代码
    ,party_agent_code_type -- 代理行代码类型,1:BIC,2:DSS
    ,party_agent_code_dss -- 代理行代码编码集合名称
    ,party_agent_code -- 代理行代码
    ,party_agent_account -- 代理行账号
    ,party_code_type -- 交易主体代码类型,1:BIC,2:DSS
    ,party_code_dss -- 交易主体代码编码集合名称
    ,party_code -- 交易主体代码
    ,party_account -- 交易主体账号
    ,si_id -- 证券结算要素ID
    ,party_i_bank_code -- 交易对手银行行号
    ,party_i_swift_code -- 交易对手swiftCode
    ,split_inst_type -- 拆分类型：0不拆分（默认值）；1分拆（券优先）；2分拆（资金优先）
    ,cm_attr_parent -- 父子属性 	0：无父子关系的交易 -1：存在父子关系并且当前交易为父交易 >0：存在父子关系并且当前交易为子交易（填写父交易的交易号）
    ,cm_attr_master -- 主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
    ,cm_attr_merge -- 合并属性 	0：无合并属性 >0：合并交易的交易号，即生成的合并指令是挂在这个交易上的；具有相同合并交易号的一组交易需要做合并 -1：当前交易为合并交易，即这个交易本身不会结算生成指令，但所有明细交易的合并指令会挂在这个交易下
    ,cm_attr_mirror -- 镜像属性 	0：非镜像交易 >0：对应镜像交易的交易号
    ,cm_attr_relation -- 关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
    ,cal_start_date -- 计算开始日期
    ,cal_end_date -- 计算结束日期
    ,strike_ytm -- 行权收益率
    ,settlement_type -- 交割方式，仅用于前台显示
    ,aio_acct_no -- AIO账号
    ,acct_type -- 产品类型
    ,user_name -- 客户经理
    ,contractparty -- 签约方
    ,marketing_manager_id -- 客户经理ID
    ,marketing_org_id -- 营销机构编号
    ,com_date -- 赎回提醒确认日期
    ,party_branch -- 交易对手分支机构
    ,max_val -- 上限
    ,min_val -- 下限
    ,collection_fst_fee -- 分销交易折扣费用
    ,transfer_type -- 转账方式
    ,secu_setdate -- 券交割日
    ,csdc_netprice -- 中证估值
    ,ccdc_netprice -- 中债估值
    ,shch_netprice -- 清算所估值
    ,se_netprice -- 交易所估值
    ,ctrct_id -- 合同编号
    ,platform -- 平台
    ,invest_direction -- 投向
    ,contractversion -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
    ,final_invest -- 最终投向类型
    ,associatednumber -- 关联序列号
    ,fiveclass -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
    ,prod_nature -- 产品性质
    ,trd_acc_code -- 交易账号
    ,store_code -- 存单号
    ,quote_type -- 报价方式(1:对话报价 105:点击成交 107:做市报价 2:限价报价 112:请求报价 113:请求回复报价)
    ,unit_id -- 投组单元
    ,curcount -- 当前份额（货币基金份额结转用）
    ,can_div_amount -- 未结转份额（货币基金份额结转用）
    ,is_remain_due_ai -- 是否保留剩余收益
    ,is_impair -- 金融工具是否减值 1:是 0:否
    ,option_group -- 期权组合，详见字典fxOptionGroup
    ,entry_date -- 交易录入业务日期
    ,party_pset_name -- 结算场所名称
    ,relate_invest -- 是否关联投金风控系统
    ,settlement_place -- 交割场所 1:LONDON 2:SHANGHAI 3:ZURICH 4:NEW YORK
    ,trdfee_notset -- 不结算手续费字段
    ,daycounter -- 计息基准
    ,remain_due_cp -- 是否保留应收未收成本
    ,include_inte -- 是否含息转入,0为否，1为是
    ,exh_extordid -- 交易所委托编号
    ,exrcise_state -- 外汇期权行权状态：0:未处理，1:已行权，-1:不行权
    ,sppiresult -- SPPI测试结果
    ,sppiclass -- SPPI业务模式
    ,mergeno -- 交易所流水合并号
    ,resource_id -- 对应菜单resourceId
    ,party_relevance_info -- 关联方信息(华兴需求)
    ,full_flag -- 1:全部赎回，2:部分赎回
    ,brokerage_id -- 券商ID
    ,brokerage_fee_info -- 券商费用信息
    ,released_credit_line -- 桂林银行用释放的授信额度
    ,out_range -- 转出范围：0只转本金1本息转出
    ,interest_out -- 转出利息
    ,book -- 会计分类
    ,xcc_trade_grp_id -- 交易组合号
    ,xcc_pre_sysordid -- 前一个交易号
    ,cash_setdate -- 资金交割日
    ,bnd_ytm_deviate -- 国债收益率偏离
    ,trd_fee_ext_secu_acct_id -- 费用外部证券账户
    ,pre_bnt_ord_id -- 关联事前审批单号
    ,pre_remain_count -- 预审批剩余券面总额
    ,p_id -- 智能活期产品编号
    ,party_acc_code_type -- 代码类型
    ,qcurr_party_acc_code_type -- 代码类型
    ,ftp_code -- 方案编号
    ,pc1 -- 
    ,yhf -- 
    ,jsf -- 
    ,ghf -- 
    ,zgf -- 
    ,sxf -- 
    ,brkfee -- 
    ,yjf -- 
    ,netyjf -- 
    ,con_update_time -- 
    ,qcurr_party_recv_bank_name -- 
    ,qcurr_party_recv_bank_swift -- 
    ,party_recv_bank_name -- 
    ,party_recv_bank_swift_code -- 
    ,other_fee -- 
    ,cli_ord_id -- 
    ,party_swift_type -- 
    ,qcurr_party_swift_type -- 
    ,back_bank_code -- 
    ,back_acct_code -- 
    ,back_bank_name -- 
    ,back_acct_name -- 
    ,other_agree_item -- 
    ,bank_group_mode -- 
    ,apr_txn -- 批复编号
    ,reply_code -- 额度合同编号
    ,incomeaccount -- 入息账户
    ,credit_occupation_type -- 授信占用类型:1(白名单额度)2(授信批复额度)
    ,is_appoint_time -- 是否约期
    ,appoint_start_date -- 约期开始日,是否约期选择是显示且必填
    ,appoint_end_date -- 约期结束日,是否约期选择是显示且必填
    ,is_quarter_redeem -- 是否当季赎回
    ,redeem_date -- 计划赎回日期
    ,min_rate -- 
    ,max_rate -- 
    ,min_repo_interest -- 
    ,max_repo_interest -- 
    ,credit_id -- 
    ,confirm_status -- 
    ,confirmor -- 
    ,confirm_i_id -- 
    ,guest_agreement_num -- 
    ,guest_business_num -- 
    ,credit_secu_type -- 
    ,ai -- 应计利息
    ,swift_ids -- swift报文id，逗号隔开
    ,set_price -- 现券结算价格，0:净价结算,结算金额=净价*份额+总应计利息；1:全价结算,结算金额=全价*份额
    ,sub_acct -- 子户号,调用接口返回字段保存
    ,search_ai -- 调用接口返回利息
    ,search_balance -- 调用接口返回余额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_otc_trade
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_otc_trade exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_otc_trade_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_otc_trade to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_otc_trade_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_otc_trade',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);