/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_otc_trade
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_otc_trade
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_otc_trade purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_otc_trade(
    sysordid number(16,0) -- 交易序号
    ,orddate varchar2(15) -- 委托日期
    ,ordtime varchar2(30) -- 委托时间
    ,condate varchar2(15) -- 确认日期
    ,contime varchar2(30) -- 确认时间
    ,insid varchar2(30) -- 指令号，也叫审批号
    ,intordid varchar2(50) -- 内部交易号
    ,extordid varchar2(75) -- 外部交易号
    ,custordid varchar2(30) -- 客户交易号
    ,extbizid varchar2(90) -- 外部业务编号
    ,operator varchar2(150) -- 操作人
    ,trdtype varchar2(15) -- 交易类型
    ,cash_ext_accid varchar2(30) -- 一级资金账户
    ,cash_accid varchar2(45) -- 二级资金账户
    ,secu_ext_accid varchar2(30) -- 一级证券账户
    ,secu_accid varchar2(45) -- 二级证券账户
    ,partyid number(22) -- 交易对手
    ,cp_cash_accid varchar2(45) -- 二级资金账户
    ,cp_secu_accid varchar2(45) -- 二级证券账户
    ,i_code varchar2(75) -- 金融工具代码
    ,a_type varchar2(30) -- spt_bd:债券(国债、企业债、金融债、次级债券等,央行票据) spt_abs:资产证券化产品(abs、mbs、cdo) spt_cb:可转换债券 spt_db:债务 spt_ibor:同业拆借 spt_ibdepo:同业存款 spt_c:现金 spt_f1:封闭式基金 spt_f2:开放式基金 spt_f3:交易所交易基金 spt_stg_1:期限套利 spt_stg_2:跨期套利 spt_pg:配股 spt_ir:利率 spt_cp:商业票据 spt_ded:活期存款 spt_ntd:通知存款(1天通知存款、7天通知存款) spt_tmd:定期存款(3个月、半年、1年、3年、5年) spt_ngd:协议存款(期限确定，利率协商确定的存款) spt_repo:回购 spt_xr:汇率
    ,m_type varchar2(30) -- xshg: 上交所 xshe:深交所 x_cnffex;中金所 x_cnbd;银行间
    ,i_name varchar2(300) -- 金融工具名称
    ,ordcount number(38,4) -- 交易数量（应收本金）
    ,ordprice number(31,12) -- 交易价格
    ,ordamount number(31,4) -- 交易金额
    ,trdfee number(31,4) -- 交易费用
    ,setfee number(31,4) -- 结算费用
    ,setdays number(22) -- 清算速度
    ,setdate varchar2(15) -- 结算日期
    ,thenmktprice number(10,3) -- 当时市场价
    ,thenmktprice_u number(10,3) -- 当时标的市场价
    ,ordstatus number(22) -- -2：未通过审批;-1：已通过审批;-3：部分成交的审批单 审批单更改后生成交易单,由于交易要素修改则新建交易单，原trade的状态改为-3;-4：审批单分多次成交完毕;0：新建;3：创建指令成功;4：成交确认;5：已撤销;6：成交失败
    ,errcode number(22) -- 错误代码
    ,errinfo varchar2(1500) -- 错误信息
    ,bnd_settype varchar2(30) -- 结算方式
    ,bnd_netprice number(31,6) -- 净价金额
    ,bnd_aiamount number(31,4) -- 应收利息
    ,remark varchar2(3000) -- 备注信息
    ,reservetype varchar2(2) -- 本方保证方式
    ,cp_reservetype varchar2(2) -- 对方保证方式
    ,reservechg varchar2(2) -- 本方保证可否变更
    ,cp_reservechg varchar2(2) -- 对方保证可否变更
    ,reservevalue number(31,4) -- 本方保证总额
    ,cp_reservevalue number(31,4) -- 对方保证总额
    ,resolve varchar2(150) -- 争议解决方式
    ,trade_grp_id varchar2(30) -- 合并指令id
    ,ref_orddate varchar2(15) -- 等待补充
    ,ref_sysordid number(17,0) -- 引用交易流水号
    ,ignore_flag varchar2(2) -- 1=忽略，0=不忽略，主要是针对开放式回购的现券交易
    ,exe_market varchar2(30) -- 交易执行市场
    ,trader varchar2(150) -- 经办人
    ,trader_cp varchar2(150) -- 等待补充
    ,dealtype number(22) -- 成交方式
    ,agreenumber varchar2(75) -- 大宗交易要素的约定号
    ,eval_netprice number(12,6) -- 净价跟中债估值净价的偏移度 【value=(中债估值净价-交易净价)/中债估值净价】
    ,ordsource number(22) -- 交易来源：-1：次交易；0：内部交易；1：外部交易
    ,deal_count number(38,4) -- 已成交数量
    ,deal_avg_netprice number(14,8) -- 平均成交净价价格
    ,deal_netamount number(31,4) -- 净价成交金额
    ,deal_aiamount number(31,4) -- 实收利息
    ,deal_amount number(31,4) -- 实收金额
    ,bidaskid number(17,0) -- 双边报价互存交易编号
    ,relatedparty varchar2(2) -- 是否关联机构
    ,terminate_amount number(31,4) -- 等待补充
    ,setdate_terminate varchar2(15) -- 等待补充
    ,agreementtype number(22) -- 等待补充
    ,partynametempority varchar2(150) -- 等待补充
    ,party_zzdaccname varchar2(300) -- 交易对手中债登名称
    ,seatno_cp varchar2(75) -- 等待补充
    ,executor varchar2(150) -- 交易员
    ,union_sysordid number(17,0) -- 等待补充
    ,party_zzdacccode varchar2(300) -- 交易对手中债登账户
    ,party_bank_code varchar2(300) -- 交易对手开户行号
    ,party_acct_code varchar2(300) -- 交易对手帐号
    ,party_bank_name varchar2(300) -- 交易对手开户行名
    ,party_acct_name varchar2(300) -- 交易对手帐号名称
    ,dis_fee_kind_follow varchar2(2) -- 尾随手续费返还方式
    ,dis_fee_kind varchar2(2) -- 手续费返还方式
    ,grpid_sub varchar2(30) -- 组合子交易号
    ,imp_time varchar2(29) -- 导入时间
    ,eval_ytm number(12,6) -- 中债收益率
    ,bnd_ytm number(30,15) -- 到期收益率
    ,update_time varchar2(35) -- 更新时间
    ,due_ai number(31,4) -- 应收未收利息
    ,operator_id varchar2(45) -- 操作人id
    ,executor_id varchar2(45) -- 成交确认人id
    ,due_cp number(38,4) -- 应收(付)未收(付)本金
    ,real_ai number(38,4) -- 实收(付)利息
    ,real_cp number(38,4) -- 实收(付)本金
    ,real_fee number(38,4) -- 实收(付)费用
    ,due_fee number(31,8) -- 应收(付)费用
    ,ref_type number(22) -- 交易类型：1：普通交易；2：父交易；3：子交易
    ,is_remain number(4,0) -- 是否保留应收未收本息 第一位本 第2位利息 ;1 保留2 不保留
    ,trader_id varchar2(45) -- 交易员id
    ,trademodel varchar2(3) -- 交易模式
    ,settlemodel varchar2(6) -- 1：双边清算，2：净额清算
    ,ord_id varchar2(75) -- 审批单号
    ,insstatus number(16,0) -- 1 - 未结算  2 - 结算中 699 - 结算完成
    ,entrust_ref_id number(16,0) -- 代理方关联的委托方id
    ,close_trade_id varchar2(45) -- 指定平仓时，指定核算的交易号
    ,ftprate number(12,6) -- ftp利率
    ,conn_ordid varchar2(75) -- 关联的审批单号
    ,two_effective_contract varchar2(300) -- 双边有效约定
    ,source_type number(2,0) -- 数据来源 1-手工新建|2-下行生成|3-期初余额导入
    ,settlestate number(16,0) -- 0：未结算  1：结算中  2：已结算
    ,navdate varchar2(15) -- 净值日期
    ,qcurr_cash_ext_accid varchar2(30) -- 计价货币本方外部资金账户表
    ,qcurr_party_bank_code varchar2(300) -- 计价货币对手方银行行号（swiftcode）
    ,qcurr_party_bank_name varchar2(300) -- 计价货币对手方银行行名
    ,qcurr_party_acct_code varchar2(300) -- 计价货币对手方银行账号
    ,qcurr_party_acct_name varchar2(300) -- 计价货币对手方银行账户名
    ,party_mid_bank_acct_code varchar2(75) -- 基础货币中间行账号
    ,party_mid_bank_name varchar2(75) -- 基础货币中间行名称
    ,party_mid_swift_code varchar2(75) -- 基础货币中间行swift代码
    ,qcurr_party_mid_bank_acct_code varchar2(75) -- 计价货币中间行账号
    ,qcurr_party_mid_bank_name varchar2(75) -- 计价货币中间行名称
    ,qcurr_party_mid_swift_code varchar2(75) -- 计价货币中间行swift代码
    ,party_swift_code varchar2(75) -- 对手方基础货币swift代码
    ,qcurr_party_swift_code varchar2(75) -- 对手方计价货币swift代码
    ,spv_id number(16,0) -- 清算路径标识
    ,his_tradeflag number(16,0) -- 历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改
    ,his_ref_tradeid number(31,0) -- 历史关联交易号
    ,his_trade_setdate varchar2(15) -- 历史交易结算日
    ,party_pset varchar2(33) -- 结算场所代码
    ,party_pset_country varchar2(15) -- 国家代码
    ,party_agent_code_type varchar2(2) -- 代理行代码类型,1:bic,2:dss
    ,party_agent_code_dss varchar2(270) -- 代理行代码编码集合名称
    ,party_agent_code varchar2(420) -- 代理行代码
    ,party_agent_account varchar2(150) -- 代理行账号
    ,party_code_type varchar2(2) -- 交易主体代码类型,1:bic,2:dss
    ,party_code_dss varchar2(270) -- 交易主体代码编码集合名称
    ,party_code varchar2(420) -- 交易主体代码
    ,party_account varchar2(150) -- 交易主体账号
    ,si_id number(16,0) -- 证券结算要素id
    ,party_i_bank_code varchar2(75) -- 交易对手银行行号
    ,party_i_swift_code varchar2(75) -- 交易对手swiftcode
    ,split_inst_type varchar2(2) -- 拆分类型：0不拆分（默认值）；1分拆（券优先）；2分拆（资金优先）
    ,cm_attr_parent number(31,0) -- 父子属性 	0：无父子关系的交易 -1：存在父子关系并且当前交易为父交易 >0：存在父子关系并且当前交易为子交易（填写父交易的交易号）
    ,cm_attr_master number(31,0) -- 主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）
    ,cm_attr_merge number(31,0) -- 合并属性 	0：无合并属性 >0：合并交易的交易号，即生成的合并指令是挂在这个交易上的；具有相同合并交易号的一组交易需要做合并 -1：当前交易为合并交易，即这个交易本身不会结算生成指令，但所有明细交易的合并指令会挂在这个交易下
    ,cm_attr_mirror number(31,0) -- 镜像属性 	0：非镜像交易 >0：对应镜像交易的交易号
    ,cm_attr_relation number(31,0) -- 关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认
    ,cal_start_date varchar2(15) -- 计算开始日期
    ,cal_end_date varchar2(15) -- 计算结束日期
    ,strike_ytm number(12,6) -- 行权收益率
    ,settlement_type varchar2(150) -- 交割方式，仅用于前台显示
    ,aio_acct_no varchar2(150) -- aio账号
    ,acct_type varchar2(5) -- 产品类型
    ,user_name varchar2(150) -- 客户经理
    ,contractparty varchar2(300) -- 签约方
    ,marketing_manager_id varchar2(30) -- 客户经理id
    ,marketing_org_id varchar2(30) -- 营销机构编号
    ,com_date varchar2(15) -- 赎回提醒确认日期
    ,party_branch varchar2(150) -- 交易对手分支机构
    ,max_val number(31,6) -- 上限
    ,min_val number(31,6) -- 下限
    ,collection_fst_fee number(31,4) -- 分销交易折扣费用
    ,transfer_type varchar2(30) -- 转账方式
    ,secu_setdate varchar2(15) -- 券交割日
    ,csdc_netprice number(31,6) -- 中证估值
    ,ccdc_netprice number(31,6) -- 中债估值
    ,shch_netprice number(31,6) -- 清算所估值
    ,se_netprice number(31,6) -- 交易所估值
    ,ctrct_id varchar2(75) -- 合同编号
    ,platform varchar2(3) -- 平台
    ,invest_direction varchar2(750) -- 投向
    ,contractversion number(31,0) -- 合同版本号（已审合同:0,送审合同:1,标准合同:2）
    ,final_invest varchar2(15) -- 最终投向类型
    ,associatednumber varchar2(300) -- 关联序列号
    ,fiveclass number(31,0) -- 五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）
    ,prod_nature varchar2(3) -- 产品性质
    ,trd_acc_code varchar2(50) -- 交易账号
    ,store_code varchar2(30) -- 存单号
    ,quote_type varchar2(15) -- 报价方式(1:对话报价 105:点击成交 107:做市报价 2:限价报价 112:请求报价 113:请求回复报价)
    ,unit_id varchar2(45) -- 投组单元
    ,curcount number(38,4) -- 当前份额（货币基金份额结转用）
    ,can_div_amount number(38,4) -- 未结转份额（货币基金份额结转用）
    ,is_remain_due_ai varchar2(3) -- 是否保留剩余收益
    ,is_impair varchar2(2) -- 金融工具是否减值 1:是 0:否
    ,option_group varchar2(2) -- 期权组合，详见字典fxoptiongroup
    ,entry_date varchar2(15) -- 交易录入业务日期
    ,party_pset_name varchar2(75) -- 结算场所名称
    ,relate_invest varchar2(2) -- 是否关联投金风控系统
    ,settlement_place number(4,0) -- 交割场所 1:london 2:shanghai 3:zurich 4:new york
    ,trdfee_notset number(31,4) -- 不结算手续费字段
    ,daycounter varchar2(45) -- 计息基准
    ,remain_due_cp varchar2(2) -- 是否保留应收未收成本
    ,include_inte varchar2(2) -- 是否含息转入,0为否，1为是
    ,exh_extordid varchar2(75) -- 交易所委托编号
    ,exrcise_state number(1,0) -- 外汇期权行权状态：0:未处理，1:已行权，-1:不行权
    ,sppiresult varchar2(3) -- sppi测试结果
    ,sppiclass varchar2(3) -- sppi业务模式
    ,mergeno varchar2(75) -- 交易所流水合并号
    ,resource_id varchar2(75) -- 对应菜单resourceid
    ,party_relevance_info varchar2(3000) -- 关联方信息(华兴需求)
    ,full_flag varchar2(9) -- 1:全部赎回，2:部分赎回
    ,brokerage_id number(32,0) -- 券商id
    ,brokerage_fee_info varchar2(3000) -- 券商费用信息
    ,released_credit_line number(31,4) -- 桂林银行用释放的授信额度
    ,out_range varchar2(2) -- 转出范围：0只转本金1本息转出
    ,interest_out number(38,4) -- 转出利息
    ,book varchar2(45) -- 会计分类
    ,xcc_trade_grp_id varchar2(30) -- 交易组合号
    ,xcc_pre_sysordid number(16,0) -- 前一个交易号
    ,cash_setdate varchar2(15) -- 资金交割日
    ,bnd_ytm_deviate number(31,6) -- 国债收益率偏离
    ,trd_fee_ext_secu_acct_id varchar2(30) -- 费用外部证券账户
    ,pre_bnt_ord_id varchar2(75) -- 关联事前审批单号
    ,pre_remain_count number(19,0) -- 预审批剩余券面总额
    ,p_id varchar2(75) -- 智能活期产品编号
    ,party_acc_code_type varchar2(45) -- 代码类型
    ,qcurr_party_acc_code_type varchar2(45) -- 代码类型
    ,ftp_code varchar2(90) -- 方案编号
    ,pc1 varchar2(45) -- 
    ,yhf number(31,4) -- 
    ,jsf number(31,4) -- 
    ,ghf number(31,4) -- 
    ,zgf number(31,4) -- 
    ,sxf number(31,4) -- 
    ,brkfee number(31,4) -- 
    ,yjf number(31,4) -- 
    ,netyjf number(31,4) -- 
    ,con_update_time varchar2(35) -- 
    ,qcurr_party_recv_bank_name varchar2(75) -- 
    ,qcurr_party_recv_bank_swift varchar2(75) -- 
    ,party_recv_bank_name varchar2(75) -- 
    ,party_recv_bank_swift_code varchar2(75) -- 
    ,other_fee number(31,4) -- 
    ,cli_ord_id varchar2(75) -- 
    ,party_swift_type varchar2(15) -- 
    ,qcurr_party_swift_type varchar2(15) -- 
    ,back_bank_code varchar2(300) -- 
    ,back_acct_code varchar2(300) -- 
    ,back_bank_name varchar2(300) -- 
    ,back_acct_name varchar2(300) -- 
    ,other_agree_item varchar2(3000) -- 
    ,bank_group_mode varchar2(2) -- 
    ,apr_txn varchar2(150) -- 批复编号
    ,reply_code varchar2(192) -- 额度合同编号
    ,incomeaccount varchar2(150) -- 入息账户
    ,credit_occupation_type varchar2(2) -- 授信占用类型:1(白名单额度)2(授信批复额度)
    ,is_appoint_time varchar2(2) -- 是否约期
    ,appoint_start_date varchar2(17) -- 约期开始日,是否约期选择是显示且必填
    ,appoint_end_date varchar2(17) -- 约期结束日,是否约期选择是显示且必填
    ,is_quarter_redeem varchar2(2) -- 是否当季赎回
    ,redeem_date varchar2(15) -- 计划赎回日期
    ,min_rate number(15,8) -- 
    ,max_rate number(15,8) -- 
    ,min_repo_interest number(19,2) -- 
    ,max_repo_interest number(19,2) -- 
    ,credit_id varchar2(15) -- 
    ,confirm_status number(1,0) -- 
    ,confirmor number(19,0) -- 
    ,confirm_i_id number(22,0) -- 
    ,guest_agreement_num varchar2(75) -- 
    ,guest_business_num varchar2(75) -- 
    ,credit_secu_type varchar2(15) -- 
    ,ai number(31,4) -- 应计利息
    ,swift_ids varchar2(300) -- swift报文id，逗号隔开
    ,set_price number(1,0) -- 现券结算价格，0:净价结算,结算金额=净价*份额+总应计利息；1:全价结算,结算金额=全价*份额
    ,sub_acct varchar2(75) -- 子户号,调用接口返回字段保存
    ,search_ai number(31,4) -- 调用接口返回利息
    ,search_balance number(31,4) -- 调用接口返回余额
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ibms_ttrd_otc_trade to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_trade to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_trade to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_otc_trade to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_otc_trade is '交易单表';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.sysordid is '交易序号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.orddate is '委托日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ordtime is '委托时间';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.condate is '确认日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.contime is '确认时间';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.insid is '指令号，也叫审批号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.intordid is '内部交易号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.extordid is '外部交易号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.custordid is '客户交易号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.extbizid is '外部业务编号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.operator is '操作人';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.trdtype is '交易类型';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cash_ext_accid is '一级资金账户';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cash_accid is '二级资金账户';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.secu_ext_accid is '一级证券账户';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.secu_accid is '二级证券账户';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.partyid is '交易对手';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cp_cash_accid is '二级资金账户';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cp_secu_accid is '二级证券账户';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.i_code is '金融工具代码';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.a_type is 'spt_bd:债券(国债、企业债、金融债、次级债券等,央行票据) spt_abs:资产证券化产品(abs、mbs、cdo) spt_cb:可转换债券 spt_db:债务 spt_ibor:同业拆借 spt_ibdepo:同业存款 spt_c:现金 spt_f1:封闭式基金 spt_f2:开放式基金 spt_f3:交易所交易基金 spt_stg_1:期限套利 spt_stg_2:跨期套利 spt_pg:配股 spt_ir:利率 spt_cp:商业票据 spt_ded:活期存款 spt_ntd:通知存款(1天通知存款、7天通知存款) spt_tmd:定期存款(3个月、半年、1年、3年、5年) spt_ngd:协议存款(期限确定，利率协商确定的存款) spt_repo:回购 spt_xr:汇率';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.m_type is 'xshg: 上交所 xshe:深交所 x_cnffex;中金所 x_cnbd;银行间';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.i_name is '金融工具名称';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ordcount is '交易数量（应收本金）';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ordprice is '交易价格';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ordamount is '交易金额';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.trdfee is '交易费用';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.setfee is '结算费用';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.setdays is '清算速度';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.setdate is '结算日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.thenmktprice is '当时市场价';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.thenmktprice_u is '当时标的市场价';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ordstatus is '-2：未通过审批;-1：已通过审批;-3：部分成交的审批单 审批单更改后生成交易单,由于交易要素修改则新建交易单，原trade的状态改为-3;-4：审批单分多次成交完毕;0：新建;3：创建指令成功;4：成交确认;5：已撤销;6：成交失败';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.errcode is '错误代码';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.errinfo is '错误信息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.bnd_settype is '结算方式';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.bnd_netprice is '净价金额';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.bnd_aiamount is '应收利息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.remark is '备注信息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.reservetype is '本方保证方式';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cp_reservetype is '对方保证方式';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.reservechg is '本方保证可否变更';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cp_reservechg is '对方保证可否变更';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.reservevalue is '本方保证总额';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cp_reservevalue is '对方保证总额';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.resolve is '争议解决方式';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.trade_grp_id is '合并指令id';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ref_orddate is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ref_sysordid is '引用交易流水号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ignore_flag is '1=忽略，0=不忽略，主要是针对开放式回购的现券交易';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.exe_market is '交易执行市场';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.trader is '经办人';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.trader_cp is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.dealtype is '成交方式';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.agreenumber is '大宗交易要素的约定号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.eval_netprice is '净价跟中债估值净价的偏移度 【value=(中债估值净价-交易净价)/中债估值净价】';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ordsource is '交易来源：-1：次交易；0：内部交易；1：外部交易';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.deal_count is '已成交数量';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.deal_avg_netprice is '平均成交净价价格';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.deal_netamount is '净价成交金额';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.deal_aiamount is '实收利息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.deal_amount is '实收金额';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.bidaskid is '双边报价互存交易编号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.relatedparty is '是否关联机构';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.terminate_amount is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.setdate_terminate is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.agreementtype is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.partynametempority is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_zzdaccname is '交易对手中债登名称';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.seatno_cp is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.executor is '交易员';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.union_sysordid is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_zzdacccode is '交易对手中债登账户';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_bank_code is '交易对手开户行号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_acct_code is '交易对手帐号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_bank_name is '交易对手开户行名';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_acct_name is '交易对手帐号名称';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.dis_fee_kind_follow is '尾随手续费返还方式';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.dis_fee_kind is '手续费返还方式';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.grpid_sub is '组合子交易号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.imp_time is '导入时间';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.eval_ytm is '中债收益率';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.bnd_ytm is '到期收益率';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.due_ai is '应收未收利息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.operator_id is '操作人id';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.executor_id is '成交确认人id';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.due_cp is '应收(付)未收(付)本金';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.real_ai is '实收(付)利息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.real_cp is '实收(付)本金';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.real_fee is '实收(付)费用';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.due_fee is '应收(付)费用';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ref_type is '交易类型：1：普通交易；2：父交易；3：子交易';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.is_remain is '是否保留应收未收本息 第一位本 第2位利息 ;1 保留2 不保留';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.trader_id is '交易员id';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.trademodel is '交易模式';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.settlemodel is '1：双边清算，2：净额清算';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ord_id is '审批单号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.insstatus is '1 - 未结算  2 - 结算中 699 - 结算完成';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.entrust_ref_id is '代理方关联的委托方id';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.close_trade_id is '指定平仓时，指定核算的交易号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ftprate is 'ftp利率';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.conn_ordid is '关联的审批单号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.two_effective_contract is '双边有效约定';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.source_type is '数据来源 1-手工新建|2-下行生成|3-期初余额导入';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.settlestate is '0：未结算  1：结算中  2：已结算';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.navdate is '净值日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_cash_ext_accid is '计价货币本方外部资金账户表';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_bank_code is '计价货币对手方银行行号（swiftcode）';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_bank_name is '计价货币对手方银行行名';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_acct_code is '计价货币对手方银行账号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_acct_name is '计价货币对手方银行账户名';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_mid_bank_acct_code is '基础货币中间行账号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_mid_bank_name is '基础货币中间行名称';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_mid_swift_code is '基础货币中间行swift代码';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_mid_bank_acct_code is '计价货币中间行账号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_mid_bank_name is '计价货币中间行名称';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_mid_swift_code is '计价货币中间行swift代码';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_swift_code is '对手方基础货币swift代码';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_swift_code is '对手方计价货币swift代码';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.spv_id is '清算路径标识';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.his_tradeflag is '历史交易表示0.普通交易（默认）1.补录 2.撤销 3.反冲 4。修改';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.his_ref_tradeid is '历史关联交易号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.his_trade_setdate is '历史交易结算日';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_pset is '结算场所代码';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_pset_country is '国家代码';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_agent_code_type is '代理行代码类型,1:bic,2:dss';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_agent_code_dss is '代理行代码编码集合名称';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_agent_code is '代理行代码';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_agent_account is '代理行账号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_code_type is '交易主体代码类型,1:bic,2:dss';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_code_dss is '交易主体代码编码集合名称';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_code is '交易主体代码';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_account is '交易主体账号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.si_id is '证券结算要素id';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_i_bank_code is '交易对手银行行号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_i_swift_code is '交易对手swiftcode';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.split_inst_type is '拆分类型：0不拆分（默认值）；1分拆（券优先）；2分拆（资金优先）';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cm_attr_parent is '父子属性 	0：无父子关系的交易 -1：存在父子关系并且当前交易为父交易 >0：存在父子关系并且当前交易为子交易（填写父交易的交易号）';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cm_attr_master is '主从属性	0：无主从关系的交易 -1：存在主从关系的交易且当前交易为主交易 >0：存在主从关系并且当前交易为从交易（填写主交易的交易号）';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cm_attr_merge is '合并属性 	0：无合并属性 >0：合并交易的交易号，即生成的合并指令是挂在这个交易上的；具有相同合并交易号的一组交易需要做合并 -1：当前交易为合并交易，即这个交易本身不会结算生成指令，但所有明细交易的合并指令会挂在这个交易下';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cm_attr_mirror is '镜像属性 	0：非镜像交易 >0：对应镜像交易的交易号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cm_attr_relation is '关联属性 0：无关联属性 >0：具有相同的关联号的交易需要一起成交确认';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cal_start_date is '计算开始日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cal_end_date is '计算结束日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.strike_ytm is '行权收益率';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.settlement_type is '交割方式，仅用于前台显示';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.aio_acct_no is 'aio账号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.acct_type is '产品类型';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.user_name is '客户经理';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.contractparty is '签约方';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.marketing_manager_id is '客户经理id';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.marketing_org_id is '营销机构编号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.com_date is '赎回提醒确认日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_branch is '交易对手分支机构';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.max_val is '上限';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.min_val is '下限';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.collection_fst_fee is '分销交易折扣费用';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.transfer_type is '转账方式';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.secu_setdate is '券交割日';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.csdc_netprice is '中证估值';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ccdc_netprice is '中债估值';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.shch_netprice is '清算所估值';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.se_netprice is '交易所估值';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ctrct_id is '合同编号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.platform is '平台';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.invest_direction is '投向';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.contractversion is '合同版本号（已审合同:0,送审合同:1,标准合同:2）';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.final_invest is '最终投向类型';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.associatednumber is '关联序列号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.fiveclass is '五级分类（正常:0,关注:1,次级:2,可疑:3,损失:4）';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.prod_nature is '产品性质';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.trd_acc_code is '交易账号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.store_code is '存单号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.quote_type is '报价方式(1:对话报价 105:点击成交 107:做市报价 2:限价报价 112:请求报价 113:请求回复报价)';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.unit_id is '投组单元';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.curcount is '当前份额（货币基金份额结转用）';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.can_div_amount is '未结转份额（货币基金份额结转用）';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.is_remain_due_ai is '是否保留剩余收益';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.is_impair is '金融工具是否减值 1:是 0:否';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.option_group is '期权组合，详见字典fxoptiongroup';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.entry_date is '交易录入业务日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_pset_name is '结算场所名称';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.relate_invest is '是否关联投金风控系统';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.settlement_place is '交割场所 1:london 2:shanghai 3:zurich 4:new york';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.trdfee_notset is '不结算手续费字段';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.daycounter is '计息基准';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.remain_due_cp is '是否保留应收未收成本';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.include_inte is '是否含息转入,0为否，1为是';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.exh_extordid is '交易所委托编号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.exrcise_state is '外汇期权行权状态：0:未处理，1:已行权，-1:不行权';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.sppiresult is 'sppi测试结果';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.sppiclass is 'sppi业务模式';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.mergeno is '交易所流水合并号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.resource_id is '对应菜单resourceid';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_relevance_info is '关联方信息(华兴需求)';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.full_flag is '1:全部赎回，2:部分赎回';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.brokerage_id is '券商id';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.brokerage_fee_info is '券商费用信息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.released_credit_line is '桂林银行用释放的授信额度';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.out_range is '转出范围：0只转本金1本息转出';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.interest_out is '转出利息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.book is '会计分类';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.xcc_trade_grp_id is '交易组合号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.xcc_pre_sysordid is '前一个交易号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cash_setdate is '资金交割日';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.bnd_ytm_deviate is '国债收益率偏离';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.trd_fee_ext_secu_acct_id is '费用外部证券账户';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.pre_bnt_ord_id is '关联事前审批单号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.pre_remain_count is '预审批剩余券面总额';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.p_id is '智能活期产品编号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_acc_code_type is '代码类型';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_acc_code_type is '代码类型';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ftp_code is '方案编号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.pc1 is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.yhf is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.jsf is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ghf is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.zgf is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.sxf is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.brkfee is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.yjf is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.netyjf is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.con_update_time is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_recv_bank_name is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_recv_bank_swift is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_recv_bank_name is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_recv_bank_swift_code is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.other_fee is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.cli_ord_id is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.party_swift_type is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.qcurr_party_swift_type is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.back_bank_code is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.back_acct_code is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.back_bank_name is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.back_acct_name is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.other_agree_item is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.bank_group_mode is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.apr_txn is '批复编号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.reply_code is '额度合同编号';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.incomeaccount is '入息账户';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.credit_occupation_type is '授信占用类型:1(白名单额度)2(授信批复额度)';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.is_appoint_time is '是否约期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.appoint_start_date is '约期开始日,是否约期选择是显示且必填';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.appoint_end_date is '约期结束日,是否约期选择是显示且必填';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.is_quarter_redeem is '是否当季赎回';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.redeem_date is '计划赎回日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.min_rate is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.max_rate is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.min_repo_interest is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.max_repo_interest is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.credit_id is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.confirm_status is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.confirmor is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.confirm_i_id is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.guest_agreement_num is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.guest_business_num is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.credit_secu_type is '';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.ai is '应计利息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.swift_ids is 'swift报文id，逗号隔开';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.set_price is '现券结算价格，0:净价结算,结算金额=净价*份额+总应计利息；1:全价结算,结算金额=全价*份额';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.sub_acct is '子户号,调用接口返回字段保存';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.search_ai is '调用接口返回利息';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.search_balance is '调用接口返回余额';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ibms_ttrd_otc_trade.etl_timestamp is 'ETL处理时间戳';
