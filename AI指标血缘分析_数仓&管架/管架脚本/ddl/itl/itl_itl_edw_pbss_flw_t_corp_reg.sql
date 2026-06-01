/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pbss_flw_t_corp_reg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pbss_flw_t_corp_reg
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pbss_flw_t_corp_reg purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pbss_flw_t_corp_reg(
    etl_dt date -- 数据日期
    ,accredit_id_type1 varchar2(1) -- 被受权人证件类型1
    ,accredit_id_no1 varchar2(20) -- 被受权人证件号码1
    ,accredit_name2 varchar2(40) -- 被受权人姓名2
    ,accredit_id_type2 varchar2(1) -- 被受权人证件类型2
    ,accredit_id_no2 varchar2(20) -- 被受权人证件号码2
    ,proxy_items varchar2(100) -- 受委托人代理权限，多选逗号分隔：1-办理银行开户事宜，2-办理单位网上银行开通事宜，3-办理单位短信通开通事宜，4-办理签收华兴U盾及密码信封，10-其它
    ,reg_depm varchar2(2) -- 登记部门：1-工商部门，2-机构编制部门，3-民政部门，4-司法行政部门，5-宗教管理部门，6-外交部门，7-人民银行，8-其他
    ,organiz_tp varchar2(2) -- 组织机构类别：1-企业法人，2-个人独资企业，3-合伙企业，4-企业的分支机构，5-其他企业，6-农民专业合作社，7-事业法人，8-未登记的事业单位，9-事业单位的分支机构，10-机关法人，11-机关的内设机构，12-机关的下设机构，13-社会团体法人，14-社会团体分支机构，15-民办非企业，16-基金会，17-居委会，18-村委会，19-律师事务所，20-司法鉴定所，21-宗教活动场所，22-境外在境内成立的组织机构，23-个体工商户，24-其他
    ,reg_notp varchar2(2) -- 登记注册号类型：1-工商注册号，2-机关和事业单位登记号，3-社会团体登记号，4-民办非企业登记号，5-基金会登记号，6-宗教证书登记号，7-其他
    ,reg_no varchar2(100) -- 登记注册号码
    ,econ_tp varchar2(2) -- 经济类型：1-内资，2-国有全资，3-集体全资，4-股份合作，5-联营，6-有限责任公司，7-股份有限公司，8-私有，9-其他内资，10-港澳台投资，11-内地和港澳台投资，12-内地和港澳台合作，13-港澳台独资，14-港澳台投资股份有限公司，15-其他港澳台投资，16-国外投资，17-中外合资，18-中外合作，19-外资，20-国外投资股份有限公司，21-其他国外投资，22-其他
    ,found_date varchar2(10) -- 成立日期
    ,up_reg_notp varchar2(2) -- 上级机构登记注册号类型：1-工商注册号，2-机关和事业单位登记号，3-社会团体登记号，4-民办非企业登记号，5-基金会登记号，6-宗教证书登记号，7-其他
    ,up_reg_no varchar2(100) -- 上级机构登记注册号码
    ,up_organiz_credit_code varchar2(32) -- 上级机构信用代码
    ,accredit_legalname varchar2(40) -- 授权委托书上法人姓名
    ,accredit_legalidtype varchar2(1) -- 授权委托书上法人证件类型
    ,accredit_legalidno varchar2(20) -- 授权委托书上法人证件号码
    ,proxy_items_other varchar2(40) -- 受委托人代理权限_其它
    ,acsttg varchar2(2) -- 账户用途 00-无特殊用途 11-结算性 12-投融资性
    ,funds_escape_check varchar2(1) -- 小于等于多少人民币的转账和提现业务免予查证（0否 1是）
    ,call_orders varchar2(4) -- 查证顺序
    ,all_escape_check varchar2(1) -- 所有业务无需查证（0否 1是）
    ,not_funds_escape_check varchar2(1) -- 非资金类业务免予查证（0否 1是）
    ,other_busi_check varchar2(200) -- 其它业务给予查证
    ,principal_funds_check varchar2(1) -- 资金类法人查证标志（1指定查证）
    ,fin_contect_funds_check varchar2(1) -- 资金类财务负责人查证标志（1指定查证）
    ,chrg_funds_check1 varchar2(1) -- 资金类主管1查证标志（1指定查证）
    ,chrg_funds_check2 varchar2(1) -- 资金类主管2查证标志（1指定查证）
    ,funds_must_check varchar2(1) -- 资金类业务是否指定人员查证（0否 1是）
    ,produce_addr varchar2(250) -- 生产经营地址
    ,credit_no varchar2(32) -- 中征（贷款卡）号码
    ,workers varchar2(10) -- 职工人数
    ,income number(16,2) -- 营业收入
    ,properties number(16,2) -- 资产总额
    ,organ_type varchar2(2) -- 组织机构类别[  1-企业、2-事业单位、3-机关、4-社会团体、5-个体工商户、6-其他]
    ,up_organiz_name varchar2(100) -- 上级机构名称
    ,up_organiz_code varchar2(32) -- 上级组织机构号码
    ,submit_state varchar2(1) -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,trade_type_detail varchar2(10) -- 行业细分[见数据字典]
    ,sign_type varchar2(10) -- 签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5
    ,is_other_manage varchar2(1) -- 是否三方存管--0-否 1-是
    ,apply_type varchar2(1) -- 申请业务种类--1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
    ,bond_code varchar2(30) -- 券商代码
    ,bond_name varchar2(100) -- 券商名称
    ,bond_acct varchar2(28) -- 证券资金台账账号
    ,bond_new_acct varchar2(28) -- 新账号
    ,is_fund_acct varchar2(1) -- 基金代销-账户类签约--0-否 1-是
    ,fund_acct_type varchar2(20) -- 基金代销-账户类签约 业务类型--1签约 2解约 3开户 4销户   5基金账户登记 6基金账户取消登记        7客户信息变更 8更换银行卡号 9非交易过户
    ,send_type varchar2(1) -- 对账单寄送要求--1-寄送 0-不寄送
    ,old_acct varchar2(28) -- 旧卡号/账号--默认前“签约账号”项 （交易账户变更填写）
    ,new_acct varchar2(28) -- 新账号（交易账户变更填写）
    ,transfer_reason varchar2(1) -- 过户原因--1继承 2捐赠 3司法判决 (非交易过户填写)
    ,low_paper_id varchar2(30) -- 法律文本编号(非交易过户填写)
    ,trun_in_acct varchar2(28) -- 转入方账号(非交易过户填写)
    ,transfer_fund_code varchar2(30) -- 过户基金代码(非交易过户填写)
    ,transfer_fund_lot varchar2(30) -- 过户基金份额(非交易过户填写)
    ,is_fund_trade varchar2(1) -- 基金代销-交易类 签约--0-否 1-是
    ,fund_trade_type varchar2(20) -- 基金代销-交易类 签约类型1基金认购 2基金申购 3基金赎回  4智能定投赎回 5基金转换 6基金转托管7当日交易撤单 8分红方式变更
    ,fund_name varchar2(100) -- 基金名称
    ,fund_code varchar2(30) -- 基金代码
    ,is_subscribe varchar2(1) -- 是否基金认购/申购 0-否，1-是
    ,subscribe_amt number(16,2) -- 基金认购/申购金额
    ,is_redeem varchar2(1) -- 是否基金赎回 0-否，1-是
    ,redeem_sum varchar2(10) -- 赎回份额
    ,huge_redeem_tpye varchar2(1) -- 巨额赎回处理方式 1-取消2-顺延
    ,is_smart_invest varchar2(1) -- 智能定投 0-否，1-是
    ,first_invest_amt number(16,2) -- 首次投资金额
    ,invest_date varchar2(2) -- 投资日(投资日为1-28日，任选)
    ,later_invest_type varchar2(1) -- 后续投资方式 1固定金额 2账户余额比例 3每期递增金额
    ,later_invest_optp varchar2(1) -- 后续投资方式操作类型 1-开通2-修改
    ,invest_fixed_amt number(16,2) -- 后续投资固定金额（元）
    ,invest_remain_ratio varchar2(10) -- 后续投资账户余额比例(%)
    ,invest_per_add_amt number(16,2) -- 后续投资每期递增金额(元)
    ,invest_period_opyp varchar2(1) -- 投资周期操作类型
    ,invest_period_type varchar2(1) -- 投资周期类型 1-月 2-周 3-日
    ,later_invest_period varchar2(2) -- 投资周期(数值)
    ,invest_deadline_optp varchar2(1) -- 投资期限操作类型 1-开通2-修改
    ,invest_deadline_type varchar2(1) -- 投资期限类型 1终止日期 2投资期数 3累计投资金额
    ,time_invest_deadline varchar2(8) -- 投资期限终止日期
    ,invest_number varchar2(6) -- 投资期限投资期数
    ,invest_amt_sum number(16,2) -- 投资期限累计投资金额
    ,savings_invest_optp varchar2(1) -- 储蓄定投操作类型 1-终止 2-暂停 3-恢复
    ,invest_code varchar2(30) -- 定投编号
    ,is_smart_redeem varchar2(1) -- 智能定赎开通(或修改)  0-否，1-是
    ,first_redeem_sum varchar2(10) -- 首次赎回份额
    ,redeem_date varchar2(2) -- 赎回日 (赎回日为1-28日，任选)
    ,later_redeem_type varchar2(1) -- 后续赎回方式 1固定份额 2账户余额比例 3每期递增金额
    ,later_redeem_optp varchar2(1) -- 后续赎回方式操作类型 1-开通 2-修改
    ,redeem_fixed_amt number(16,2) -- 后续赎回固定金额（元）
    ,redeem_remain_ratio varchar2(10) -- 后续赎回账户余额比例(%)
    ,redeem_per_add_amt number(16,2) -- 后续赎回每期递增金额(元)
    ,redeem_period_opyp varchar2(1) -- 赎回周期操作类型 1-开通2-修改
    ,redeem_period_type varchar2(1) -- 赎回周期类型 1-月 2-周 3-日
    ,redeem_period varchar2(2) -- 赎回周期(数值)
    ,redeem_deadline_optp varchar2(1) -- 赎回期限操作类型 1-开通2-修改
    ,redeem_deadline_type varchar2(1) -- 赎回期限类型 1终止日期 2赎回期数 3累计赎回金额
    ,redeem_deadline varchar2(8) -- 赎回期限终止日期
    ,redeem_number varchar2(6) -- 赎回期限赎回期数
    ,redeem_amt_sum number(16,2) -- 赎回期限累计赎回金额
    ,smart_redeem_optp varchar2(1) -- 智能定赎操作类型 1终止2暂停3恢复
    ,redeem_code varchar2(30) -- 定赎编号
    ,is_fund_change varchar2(1) -- 是否资金转换  0-否，1-是
    ,changed_fund_name varchar2(300) -- 转换后基金名称
    ,changed_fund_code varchar2(30) -- 转换后基金代码
    ,changed_fund_sum varchar2(10) -- 转换基金份额
    ,is_fund_deposit varchar2(1) -- 是否资金转托管  0-否，1-是
    ,deposit_fund_name varchar2(300) -- 基金名称(资金转托管)
    ,deposit_fund_code varchar2(30) -- 基金代码(资金转托管)
    ,deposit_fund_sum varchar2(10) -- 基金份额
    ,deposit_brcna varchar2(40) -- 对方机构名称
    ,is_day_withdraw varchar2(1) -- 是否当日交易撤单   0-否，1-是
    ,ori_scan_seqno varchar2(30) -- 原流水号
    ,is_share_change varchar2(1) -- 是否分红方式变更 0-否 1-是
    ,is_cash_share varchar2(1) -- 是否现金分红 0-否 1-是
    ,is_share_invest varchar2(1) -- 是否红利再投资 0-否 1-是
    ,is_finance varchar2(1) -- 是否理财签约操作--0-否 1-是
    ,finance_optp varchar2(1) -- 理财操作类型--4购买 5赎回 6预约撤单
    ,finance_apply varchar2(100) -- 理财业务申请
    ,finance_product_name varchar2(200) -- 理财产品名称
    ,finance_product_code varchar2(30) -- 理财产品编号
    ,finance_product_deadline varchar2(8) -- 期限
    ,finance_product_curr varchar2(3) -- 币种--参考币种字典
    ,finance_amt number(16,2) -- 理财签约金额
    ,finance_amt_zh varchar2(100) -- 金额(大写)
    ,netb_acct1 varchar2(28) -- 账号（1）
    ,netb_acct1_optp varchar2(1) -- 账号（1）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号①不为空必送
    ,netb_acct2 varchar2(28) -- 账号（2）
    ,netb_acct2_optp varchar2(1) -- 账号（2）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号②不为空必送
    ,netb_acct3 varchar2(28) -- 账号（3）
    ,netb_acct3_optp varchar2(1) -- 账号（3）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号③不为空必送
    ,netbapplys varchar2(1) -- 网银服务申请--1 开通 2 注销 3 暂停 4 恢复 5新增 6取消
    ,netb_add_type varchar2(1) -- 网银服务新增类型--1全选 2单项或多项
    ,netb_add_apps varchar2(30) -- 网银服务新增集合--1查询 2转账汇款 3发工资4费用报销5定活互转6通知存款7打印8其他
    ,netb_cancel_type varchar2(1) -- 网银服务取消类型--1全选 2单项或多项
    ,netb_cancel_apps varchar2(30) -- 网银服务取消集合--1查询 2转账汇款3发工资4费用报销5定活互转6通知存款7打印8其他
    ,peoxy_phone varchar2(20) -- 代理人手机
    ,peoxy_email varchar2(100) -- 代理人E-MAIL
    ,acct varchar2(30) -- 结算账号--默认为前签约账户
    ,fin_quotient varchar2(30) -- 理财 购买/赎回份数
    ,fin_ori_entrust_no varchar2(32) -- 理财撤单 原委托流水号
    ,fin_ori_entrust_date varchar2(8) -- 理财撤单 原委托日期
    ,is_fund_contract varchar2(1) -- 是否操作基金(0-否 1-是)
    ,fundopflag varchar2(1) -- 基金操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,fin_manager_id varchar2(10) -- 理财经理编号
    ,szsecno varchar2(30) -- 深交所证券账号
    ,shsecno varchar2(30) -- 上交所证券账号
    ,minorflag varchar2(1) -- 是否成年人标志 0-否，1-是
    ,fundnewacct varchar2(32) -- 基金新银行卡号
    ,fund_contract_if_succeed varchar2(1) -- 基金签约操作是否成功(0-失败 1-成功)
    ,is_third_manage_contract varchar2(1) -- 是否三方存管签约操作
    ,cobank varchar2(32) -- 合作行
    ,ori_acct varchar2(32) -- 三方存管原结算账号
    ,ori_brcode varchar2(10) -- 三方存管原结算账号开户机构
    ,bond_pass varchar2(32) -- 证券资金台账密码
    ,third_manage_if_succeed varchar2(1) -- 三方存管签约操作是否成功(0-失败 1-成功)
    ,is_smart_cat_contract varchar2(1) -- 是否招财猫|智能存款签约操作 0-否，1-是
    ,smart_cat_opflag varchar2(1) -- 招财猫|智能存款签约操作类型 1.签约(开通)2. 维护(变更)3. 撤销(解约)
    ,smart_cat_sign_kind varchar2(10) -- 招财猫|智能存款签约种类 1-灵活盈 2-储蓄定投 3-滚存储蓄 4-滚动储蓄
    ,is_invest_contract varchar2(1) -- 是否储蓄定投签约操作 0-否，1-是
    ,invest_opflag varchar2(1) -- 储蓄定投操作类型 1-签约 2-维护 3-解约
    ,invest_contract_if_succeed varchar2(1) -- 储蓄定投签约操作是否成功(0-失败 1-成功)
    ,is_quickin_contract varchar2(1) -- 是否灵活盈签约操作 0-否，1-是
    ,quickin_opflag varchar2(1) -- 灵活盈签约操作类型 1-签约 2-维护 3-解约
    ,chan_save_tp varchar2(1) -- 灵活盈转存类型 1-活期转双整 2-活期转通知
    ,chan_save_deadline varchar2(5) -- 灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年
    ,chan_save_amt number(18,2) -- 转存起点金额
    ,save_low_amt number(18,2) -- 最低留存金额
    ,chan_save_multiple number(18,2) -- 转存基数倍额
    ,quickin_contract_if_succeed varchar2(1) -- 灵活盈签约操作是否成功(0-失败 1-成功)
    ,third_ma_apply_tp varchar2(1) -- 三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
    ,third_ma_new_acct varchar2(32) -- 三方存管新账号
    ,is_acctfund_contract varchar2(1) -- 基金代销账户类签约操作 0-否，1-是
    ,acctfund_sign_type varchar2(20) -- 基金代销账户类签约种类 1-签约2-解约3-开户 4-销户5-基金账户登记6-基金账户取消登记7-客户信息变更8-更换银行卡号9-非交易过户
    ,is_bill_send varchar2(1) -- 对账单寄送要求 1-寄送0-不寄送
    ,acctfund_ori_acct varchar2(32) -- 交易账户变更原账号 默认前“签约账号”项
    ,nontrade_chan_reason varchar2(1) -- 非交易过户原因 1-继承2-捐赠3-司法判决
    ,legal_paper_id varchar2(32) -- 法律文本编号
    ,nontrade_to_acct varchar2(32) -- 转入方账号
    ,chan_fund_code varchar2(32) -- 过户基金代码
    ,chan_fund_sum varchar2(32) -- 过户基金份额
    ,is_tradefund_contract varchar2(1) -- 基金代销交易类签约操作 0-否，1-是
    ,tradefund_sign_type varchar2(20) -- 基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更
    ,tradefund_name varchar2(100) -- 基金名称
    ,tradefund_code varchar2(32) -- 基金代码
    ,invest_period_optp varchar2(1) -- 投资周期操作类型 1-开通2-修改
    ,time_invest_code varchar2(32) -- 定投编号
    ,time_redeem_code varchar2(32) -- 定赎编号
    ,third_manage_optp varchar2(1) -- 三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,finance_deadline varchar2(8) -- 理财期限
    ,is_cat_sign varchar2(1) -- 是否招财猫签约 0-否，1-是
    ,fund_acct varchar2(30) -- 基金签约操作账号
    ,fund_acct_brcno varchar2(10) -- 基金签约账号开卡网点
    ,finance_amt_ch varchar2(50) -- 理财签约金额大写
    ,quickin_leave_amt varchar2(1) -- 灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)
    ,quickin_leave_amt_other number(16,2) -- 灵活盈—活期账户留存金额_其它
    ,netb_apply_ac_info varchar2(1) -- 网银申请服务账户信息(1存折或银行卡账户 2 全部账户)
    ,netb_ac_backs varchar2(30) -- 网银申请服务账号后六位列表(逗号隔开)
    ,netb_op_choice varchar2(1) -- 网银修改服务选项(1登录密码 2手机动态密码)
    ,netb_password_optp varchar2(1) -- 网银登录密码操作类型(1重置 2解锁)
    ,netb_netphone_optp varchar2(1) -- 手机动态密码操作类型(1开通2注销3指定手机号4变更手机号)
    ,ukey_optp varchar2(1) -- 华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)
    ,is_sms_set_phone varchar2(1) -- 短信通是否设置签约手机号 0-否，1-是
    ,is_net_trans_limit_set varchar2(1) -- 是否网银转账限额设置 0-否，1-是
    ,is_mob_trans_limit_set varchar2(1) -- 手机银行是否非定向转账限额设置 0-否，1-是
    ,telb_sign_type varchar2(1) -- 电话银行签约服务操作类型[1开通2修改3注销]
    ,is_telb_appoint_phone varchar2(1) -- 电话银行是否指定交易电话号码 0-否，1-是
    ,telb_appoint_phone_optp varchar2(1) -- 交易电话号码操作类型[1无限制2指定3注销]
    ,direct_trans_optp varchar2(1) -- 定向转账操作类型[1开通2修改3注销]
    ,is_direct_trans_ac_set varchar2(1) -- 是否定向收款账户设置[0-否，1-是]
    ,sms_set_phone_optp varchar2(1) -- 短信通设置签约手机号操作类型[1-开通 3-注销]
    ,tel_n_trnsf_optp varchar2(1) -- 电话银行非定向转账操作类型[1-开通 2-维护 3-解约]
    ,fin_new_acct varchar2(30) -- 理财银行卡号变更新账号
    ,fin_new_open_brcno varchar2(10) -- 理财银行卡号变更新账号所属机构
    ,cust_changes varchar2(30) -- 客户信息变更内容--1经办人姓名  2证件类型 3证件号码 4经办人手机 5经办人EMAIL 6通讯地址 7邮编 8联系电话  9传真电话  客户信息变更必填
    ,redeem_back_tp varchar2(1) -- 智能定赎巨额赎回处理方式   0-取消1-顺延
    ,changed_back_tp varchar2(1) -- 基金转换巨额赎回处理方式   0-取消1-顺延
    ,deposit_trade_no varchar2(30) -- 交易单编号
    ,finance_contract_if_succeed varchar2(1) -- 理财签约是否成功(0-失败 1-成功)
    ,clientgroup varchar2(1) -- 客户分组[a-  群客户Z- 其他客户]
    ,acccycle varchar2(1) -- 对账周期  1 表示按月对账 2 表示季度对账
    ,check_contact varchar2(100) -- 资金类业务指定查证联系人
    ,isfcfnct varchar2(1) -- 是否非柜面非同名账户限额签约(0-否,1-是)
    ,daylimit varchar2(32) -- 日累计限额(非柜面非同名账户限额签约)
    ,txntimeslimit varchar2(32) -- 日笔数限额(非柜面非同名账户限额签约)
    ,yearlimit varchar2(32) -- 年累计限额(非柜面非同名账户限额签约)
    ,is_fcfnct_succeed varchar2(1) -- 非柜面非同名账户限额签约是否成功(0-失败,1-成功)
    ,custom_daylimit varchar2(32) -- 日累计限额(非柜面非同名账户限额签约)--要素扩展收集使用
    ,custom_txntimeslimit varchar2(32) -- 日笔数限额(非柜面非同名账户限额签约)--要素扩展收集使用
    ,custom_yearlimit varchar2(32) -- 年累计限额(非柜面非同名账户限额签约)--要素扩展收集使用
    ,ifchangecorpseal varchar2(1) -- 是否变更公章--0-否 1-是
    ,taxresident varchar2(1) -- 机构税收居民身份（1仅为中国税收居民；2仅为非居民；3既是中国税收居民又是其他国家（地区）税收居民；4无需声明；5空）
    ,taxarea varchar2(30) -- 机构税收居民国（地区）
    ,taxarea2 varchar2(30) -- 机构税收居民国（地区）2
    ,taxarea3 varchar2(30) -- 机构税收居民国（地区）3
    ,taxnumber varchar2(30) -- 机构纳税人识别号
    ,taxnumber2 varchar2(30) -- 机构纳税人识别号2
    ,taxnumber3 varchar2(30) -- 机构纳税人识别号3
    ,taxnullreason varchar2(65) -- 机构纳税人识别号为空原因
    ,taxstatement varchar2(1) -- 机构是否取得自证声明（0未取得 1取得）
    ,corporgtype varchar2(1) -- 机构类别
    ,taxnullreason2 varchar2(65) -- 机构纳税人识别号为空原因2
    ,taxnullreason3 varchar2(65) -- 机构纳税人识别号为空原因3
    ,other_reason_1 varchar2(65) -- 
    ,other_reason_2 varchar2(65) -- 
    ,other_reason_3 varchar2(65) -- 
    ,holdna3 varchar2(40) -- 股东姓名3
    ,controller_1_surname varchar2(40) -- 【控制人一】姓（英文或拼音）
    ,controller_1_givenname varchar2(40) -- 【控制人一】名（英文或拼音）
    ,controller_1_taxresident varchar2(1) -- 【控制人一】税收居民身份
    ,controller_1_birthdate varchar2(8) -- 【控制人一】出生日期
    ,controller_1_taxarea_1 varchar2(100) -- 【控制人一】税收居民国（地区）①
    ,controller_1_taxnumber_1 varchar2(100) -- 【控制人一】纳税人识别号①
    ,controller_1_taxnullreason_1 varchar2(200) -- 【控制人一】不能提供识别号的原因①
    ,controller_1_other_reason_1 varchar2(200) -- 【控制人一】其它不能提供识别号的原因①
    ,controller_1_taxarea_2 varchar2(100) -- 【控制人一】税收居民国（地区）②
    ,controller_1_taxnumber_2 varchar2(100) -- 【控制人一】纳税人识别号②
    ,controller_1_taxnullreason_2 varchar2(200) -- 【控制人一】不能提供识别号的原因②
    ,controller_1_other_reason_2 varchar2(200) -- 【控制人一】其它不能提供识别号的原因②
    ,controller_1_taxarea_3 varchar2(100) -- 【控制人一】税收居民国（地区）③
    ,controller_1_taxnumber_3 varchar2(100) -- 【控制人一】纳税人识别号③
    ,controller_1_taxnullreason_3 varchar2(200) -- 【控制人一】不能提供识别号的原因③
    ,controller_1_other_reason_3 varchar2(200) -- 【控制人一】其它不能提供识别号的原因③
    ,controller_1_type varchar2(6) -- 【控制人一】控制人类型
    ,id varchar2(32) -- 逻辑主键
    ,main_flow_id varchar2(32) -- 核心流水表ID
    ,scan_seq_no varchar2(30) -- 扫描流水号
    ,process_inst_id varchar2(50) -- 流程实例id
    ,fun_code varchar2(2) -- 功能码[01-单位开户管理,02-单位信息变更,03-单位印鉴变更,04-单位开户缺件补扫,05-单位开户批扫开户许可证]
    ,fr_org_code varchar2(9) -- 前台机构编码
    ,tr_date date -- 交易日期
    ,biz_code varchar2(6) -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
    ,voucher_code varchar2(4) -- HXYH凭证代码
    ,voucher_no varchar2(16) -- 凭证号码
    ,cust_id varchar2(30) -- 客户编号
    ,chs_acct_flag varchar2(1) -- 账号自选标志[代码0014][0-随机账号1-账号自选]
    ,chs_account varchar2(28) -- 自选账号
    ,biz_cd_flag varchar2(1) -- 业务收付标志[代码0015][D-借C-贷]
    ,spec_acct_type varchar2(2) -- 存贷款种类[代码0016][1-活期存款 2- 定期存款3-贷款]
    ,rcv_pay_rang varchar2(90) -- 收支范围
    ,biz_account varchar2(32) -- 交易账号
    ,acct_type varchar2(3) -- 账号类别[A活期结算户 B-验资户 C-普通定期户 D-同业定期户]
    ,acct_char varchar2(4) -- 帐户性质[4-基本账户 5-临时账户 6-一般账户 7-专用账户 0-同业定期户开立]
    ,acct_specie varchar2(1) -- 核准类型[0-无意义 1-自动核准 2-人工核准]
    ,chk_fund_flag varchar2(1) -- 验资户标志[代码0097][1-验资户2-非验资户]
    ,cust_name varchar2(128) -- 客户名称
    ,ab_cust_name varchar2(60) -- 单位名简称
    ,english_name varchar2(80) -- 英文/拼音名称
    ,cst_corp_code varchar2(20) -- 单位企业代码
    ,seal_cr_code varchar2(40) -- 印鉴卡编号
    ,telephone varchar2(20) -- 电话号码
    ,addr_type varchar2(3) -- 地址类型[代码0050][OFF-单位地址 HOM-家庭地址 AD1-地址1 AD2-地址2 AD3-地址3 AD4-地址4]
    ,postcode varchar2(8) -- 邮政编码
    ,contact_address varchar2(200) -- 联系地址
    ,fin_contect_name varchar2(40) -- 财务联系人
    ,pst_bll_address varchar2(60) -- 对账单地址码
    ,curr_type varchar2(2) -- 币别[代码T003][参考CFG_T_CURRENCY_TYPE]
    ,amount number(16,2) -- 金额
    ,draw_reason varchar2(4) -- 支取依据[代码0103][0010-仅凭印0012-凭印支付密码1000-凭单1100-凭证件1010-凭单印1001-凭密1002-凭单支付密码1110-凭证印1111-凭证印密1112-凭证印支付密码1011-凭印密1012-凭印密支付密码1101-凭证密1102-凭单证支付密码]
    ,sf_scp_flag varchar2(1) -- 通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]
    ,cal_accr_flag varchar2(1) -- 记息标志[代码0034][0-否1-是]
    ,pst_bll_flag varchar2(1) -- 寄对账单标志[代码0037][N-不寄对帐单Y-寄对帐单]
    ,cur_acct_type varchar2(3) -- 账本别
    ,pndg_rec_methoed varchar2(1) -- 手续费收取方式[代码0036][0-集中收取1-分散收取]
    ,sf_scope varchar2(2) -- 通兑范围[代码0100][1-全国2-全省3-全市4-全国通存（对公）5-全省通存（对公）6-全市通存（对公）7-不通存（定点存）（对公）]
    ,acct_status varchar2(1) -- 账户状态[代码0017][0-正常（正常户及部份冻结）2-冻结（全部冻结）3-结清7-单向冻结]
    ,attor_opr_code varchar2(12) -- 客户经理编号
    ,attor_opr_name varchar2(30) -- 客户经理姓名
    ,attor_org_code varchar2(9) -- 客户经理所在网点
    ,renw_scan_flag varchar2(1) -- 补扫标志[代码0018][0-初始化1-补扫开户资料2-补扫核查清单]
    ,print_count number(2,0) -- 打印次数
    ,acct_open_date date -- 开户日期
    ,cf_flag varchar2(1) -- 钞汇标识[代码0011][0-钞1-汇]
    ,cf_properies varchar2(90) -- 钞汇属性
    ,tr_account varchar2(28) -- 转账账号
    ,accpt_accr_account varchar2(28) -- 收息账号
    ,int_rate_cert varchar2(2) -- 利率依据[代码0033][00-固定利率01-牌告利率02-浮动利率]
    ,int_rt_operation varchar2(1) -- 浮动利率加减码符号位[代码0099][1-‘+’ 2-‘-’ 3-‘*’]
    ,int_rt_cal_code varchar2(20) -- 浮动利率加减码
    ,int_rt number(8,5) -- 利率
    ,fee_ratio number(8,5) -- 费率
    ,reserve_amt number(15,2) -- 备用金额
    ,inval_date varchar2(10) -- 失效日期
    ,cls_acct_date date -- 销户日期
    ,update_time date -- 更新时间
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_pbss_flw_t_corp_reg to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pbss_flw_t_corp_reg is '对公业务流水表';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.accredit_id_type1 is '被受权人证件类型1';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.accredit_id_no1 is '被受权人证件号码1';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.accredit_name2 is '被受权人姓名2';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.accredit_id_type2 is '被受权人证件类型2';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.accredit_id_no2 is '被受权人证件号码2';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.proxy_items is '受委托人代理权限，多选逗号分隔：1-办理银行开户事宜，2-办理单位网上银行开通事宜，3-办理单位短信通开通事宜，4-办理签收华兴U盾及密码信封，10-其它';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.reg_depm is '登记部门：1-工商部门，2-机构编制部门，3-民政部门，4-司法行政部门，5-宗教管理部门，6-外交部门，7-人民银行，8-其他';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.organiz_tp is '组织机构类别：1-企业法人，2-个人独资企业，3-合伙企业，4-企业的分支机构，5-其他企业，6-农民专业合作社，7-事业法人，8-未登记的事业单位，9-事业单位的分支机构，10-机关法人，11-机关的内设机构，12-机关的下设机构，13-社会团体法人，14-社会团体分支机构，15-民办非企业，16-基金会，17-居委会，18-村委会，19-律师事务所，20-司法鉴定所，21-宗教活动场所，22-境外在境内成立的组织机构，23-个体工商户，24-其他';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.reg_notp is '登记注册号类型：1-工商注册号，2-机关和事业单位登记号，3-社会团体登记号，4-民办非企业登记号，5-基金会登记号，6-宗教证书登记号，7-其他';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.reg_no is '登记注册号码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.econ_tp is '经济类型：1-内资，2-国有全资，3-集体全资，4-股份合作，5-联营，6-有限责任公司，7-股份有限公司，8-私有，9-其他内资，10-港澳台投资，11-内地和港澳台投资，12-内地和港澳台合作，13-港澳台独资，14-港澳台投资股份有限公司，15-其他港澳台投资，16-国外投资，17-中外合资，18-中外合作，19-外资，20-国外投资股份有限公司，21-其他国外投资，22-其他';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.found_date is '成立日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.up_reg_notp is '上级机构登记注册号类型：1-工商注册号，2-机关和事业单位登记号，3-社会团体登记号，4-民办非企业登记号，5-基金会登记号，6-宗教证书登记号，7-其他';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.up_reg_no is '上级机构登记注册号码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.up_organiz_credit_code is '上级机构信用代码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.accredit_legalname is '授权委托书上法人姓名';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.accredit_legalidtype is '授权委托书上法人证件类型';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.accredit_legalidno is '授权委托书上法人证件号码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.proxy_items_other is '受委托人代理权限_其它';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.acsttg is '账户用途 00-无特殊用途 11-结算性 12-投融资性';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.funds_escape_check is '小于等于多少人民币的转账和提现业务免予查证（0否 1是）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.call_orders is '查证顺序';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.all_escape_check is '所有业务无需查证（0否 1是）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.not_funds_escape_check is '非资金类业务免予查证（0否 1是）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.other_busi_check is '其它业务给予查证';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.principal_funds_check is '资金类法人查证标志（1指定查证）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fin_contect_funds_check is '资金类财务负责人查证标志（1指定查证）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.chrg_funds_check1 is '资金类主管1查证标志（1指定查证）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.chrg_funds_check2 is '资金类主管2查证标志（1指定查证）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.funds_must_check is '资金类业务是否指定人员查证（0否 1是）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.produce_addr is '生产经营地址';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.credit_no is '中征（贷款卡）号码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.workers is '职工人数';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.income is '营业收入';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.properties is '资产总额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.organ_type is '组织机构类别[  1-企业、2-事业单位、3-机关、4-社会团体、5-个体工商户、6-其他]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.up_organiz_name is '上级机构名称';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.up_organiz_code is '上级组织机构号码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.submit_state is '业务提交状态 0-未提交，1-处理中 2-提交成功';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.trade_type_detail is '行业细分[见数据字典]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.sign_type is '签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_other_manage is '是否三方存管--0-否 1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.apply_type is '申请业务种类--1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.bond_code is '券商代码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.bond_name is '券商名称';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.bond_acct is '证券资金台账账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.bond_new_acct is '新账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_fund_acct is '基金代销-账户类签约--0-否 1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fund_acct_type is '基金代销-账户类签约 业务类型--1签约 2解约 3开户 4销户   5基金账户登记 6基金账户取消登记        7客户信息变更 8更换银行卡号 9非交易过户';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.send_type is '对账单寄送要求--1-寄送 0-不寄送';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.old_acct is '旧卡号/账号--默认前“签约账号”项 （交易账户变更填写）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.new_acct is '新账号（交易账户变更填写）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.transfer_reason is '过户原因--1继承 2捐赠 3司法判决 (非交易过户填写)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.low_paper_id is '法律文本编号(非交易过户填写)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.trun_in_acct is '转入方账号(非交易过户填写)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.transfer_fund_code is '过户基金代码(非交易过户填写)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.transfer_fund_lot is '过户基金份额(非交易过户填写)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_fund_trade is '基金代销-交易类 签约--0-否 1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fund_trade_type is '基金代销-交易类 签约类型1基金认购 2基金申购 3基金赎回  4智能定投赎回 5基金转换 6基金转托管7当日交易撤单 8分红方式变更';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fund_name is '基金名称';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fund_code is '基金代码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_subscribe is '是否基金认购/申购 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.subscribe_amt is '基金认购/申购金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_redeem is '是否基金赎回 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_sum is '赎回份额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.huge_redeem_tpye is '巨额赎回处理方式 1-取消2-顺延';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_smart_invest is '智能定投 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.first_invest_amt is '首次投资金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_date is '投资日(投资日为1-28日，任选)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.later_invest_type is '后续投资方式 1固定金额 2账户余额比例 3每期递增金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.later_invest_optp is '后续投资方式操作类型 1-开通2-修改';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_fixed_amt is '后续投资固定金额（元）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_remain_ratio is '后续投资账户余额比例(%)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_per_add_amt is '后续投资每期递增金额(元)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_period_opyp is '投资周期操作类型';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_period_type is '投资周期类型 1-月 2-周 3-日';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.later_invest_period is '投资周期(数值)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_deadline_optp is '投资期限操作类型 1-开通2-修改';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_deadline_type is '投资期限类型 1终止日期 2投资期数 3累计投资金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.time_invest_deadline is '投资期限终止日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_number is '投资期限投资期数';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_amt_sum is '投资期限累计投资金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.savings_invest_optp is '储蓄定投操作类型 1-终止 2-暂停 3-恢复';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_code is '定投编号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_smart_redeem is '智能定赎开通(或修改)  0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.first_redeem_sum is '首次赎回份额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_date is '赎回日 (赎回日为1-28日，任选)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.later_redeem_type is '后续赎回方式 1固定份额 2账户余额比例 3每期递增金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.later_redeem_optp is '后续赎回方式操作类型 1-开通 2-修改';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_fixed_amt is '后续赎回固定金额（元）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_remain_ratio is '后续赎回账户余额比例(%)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_per_add_amt is '后续赎回每期递增金额(元)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_period_opyp is '赎回周期操作类型 1-开通2-修改';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_period_type is '赎回周期类型 1-月 2-周 3-日';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_period is '赎回周期(数值)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_deadline_optp is '赎回期限操作类型 1-开通2-修改';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_deadline_type is '赎回期限类型 1终止日期 2赎回期数 3累计赎回金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_deadline is '赎回期限终止日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_number is '赎回期限赎回期数';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_amt_sum is '赎回期限累计赎回金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.smart_redeem_optp is '智能定赎操作类型 1终止2暂停3恢复';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_code is '定赎编号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_fund_change is '是否资金转换  0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.changed_fund_name is '转换后基金名称';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.changed_fund_code is '转换后基金代码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.changed_fund_sum is '转换基金份额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_fund_deposit is '是否资金转托管  0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.deposit_fund_name is '基金名称(资金转托管)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.deposit_fund_code is '基金代码(资金转托管)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.deposit_fund_sum is '基金份额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.deposit_brcna is '对方机构名称';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_day_withdraw is '是否当日交易撤单   0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.ori_scan_seqno is '原流水号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_share_change is '是否分红方式变更 0-否 1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_cash_share is '是否现金分红 0-否 1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_share_invest is '是否红利再投资 0-否 1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_finance is '是否理财签约操作--0-否 1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.finance_optp is '理财操作类型--4购买 5赎回 6预约撤单';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.finance_apply is '理财业务申请';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.finance_product_name is '理财产品名称';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.finance_product_code is '理财产品编号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.finance_product_deadline is '期限';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.finance_product_curr is '币种--参考币种字典';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.finance_amt is '理财签约金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.finance_amt_zh is '金额(大写)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_acct1 is '账号（1）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_acct1_optp is '账号（1）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号①不为空必送';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_acct2 is '账号（2）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_acct2_optp is '账号（2）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号②不为空必送';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_acct3 is '账号（3）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_acct3_optp is '账号（3）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号③不为空必送';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netbapplys is '网银服务申请--1 开通 2 注销 3 暂停 4 恢复 5新增 6取消';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_add_type is '网银服务新增类型--1全选 2单项或多项';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_add_apps is '网银服务新增集合--1查询 2转账汇款 3发工资4费用报销5定活互转6通知存款7打印8其他';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_cancel_type is '网银服务取消类型--1全选 2单项或多项';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_cancel_apps is '网银服务取消集合--1查询 2转账汇款3发工资4费用报销5定活互转6通知存款7打印8其他';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.peoxy_phone is '代理人手机';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.peoxy_email is '代理人E-MAIL';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.acct is '结算账号--默认为前签约账户';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fin_quotient is '理财 购买/赎回份数';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fin_ori_entrust_no is '理财撤单 原委托流水号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fin_ori_entrust_date is '理财撤单 原委托日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_fund_contract is '是否操作基金(0-否 1-是)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fundopflag is '基金操作类型[ 1-开通 2-银行卡号变更 3-解约]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fin_manager_id is '理财经理编号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.szsecno is '深交所证券账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.shsecno is '上交所证券账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.minorflag is '是否成年人标志 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fundnewacct is '基金新银行卡号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fund_contract_if_succeed is '基金签约操作是否成功(0-失败 1-成功)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_third_manage_contract is '是否三方存管签约操作';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.cobank is '合作行';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.ori_acct is '三方存管原结算账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.ori_brcode is '三方存管原结算账号开户机构';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.bond_pass is '证券资金台账密码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.third_manage_if_succeed is '三方存管签约操作是否成功(0-失败 1-成功)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_smart_cat_contract is '是否招财猫|智能存款签约操作 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.smart_cat_opflag is '招财猫|智能存款签约操作类型 1.签约(开通)2. 维护(变更)3. 撤销(解约)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.smart_cat_sign_kind is '招财猫|智能存款签约种类 1-灵活盈 2-储蓄定投 3-滚存储蓄 4-滚动储蓄';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_invest_contract is '是否储蓄定投签约操作 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_opflag is '储蓄定投操作类型 1-签约 2-维护 3-解约';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_contract_if_succeed is '储蓄定投签约操作是否成功(0-失败 1-成功)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_quickin_contract is '是否灵活盈签约操作 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.quickin_opflag is '灵活盈签约操作类型 1-签约 2-维护 3-解约';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.chan_save_tp is '灵活盈转存类型 1-活期转双整 2-活期转通知';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.chan_save_deadline is '灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.chan_save_amt is '转存起点金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.save_low_amt is '最低留存金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.chan_save_multiple is '转存基数倍额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.quickin_contract_if_succeed is '灵活盈签约操作是否成功(0-失败 1-成功)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.third_ma_apply_tp is '三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.third_ma_new_acct is '三方存管新账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_acctfund_contract is '基金代销账户类签约操作 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.acctfund_sign_type is '基金代销账户类签约种类 1-签约2-解约3-开户 4-销户5-基金账户登记6-基金账户取消登记7-客户信息变更8-更换银行卡号9-非交易过户';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_bill_send is '对账单寄送要求 1-寄送0-不寄送';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.acctfund_ori_acct is '交易账户变更原账号 默认前“签约账号”项';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.nontrade_chan_reason is '非交易过户原因 1-继承2-捐赠3-司法判决';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.legal_paper_id is '法律文本编号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.nontrade_to_acct is '转入方账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.chan_fund_code is '过户基金代码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.chan_fund_sum is '过户基金份额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_tradefund_contract is '基金代销交易类签约操作 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.tradefund_sign_type is '基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.tradefund_name is '基金名称';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.tradefund_code is '基金代码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.invest_period_optp is '投资周期操作类型 1-开通2-修改';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.time_invest_code is '定投编号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.time_redeem_code is '定赎编号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.third_manage_optp is '三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.finance_deadline is '理财期限';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_cat_sign is '是否招财猫签约 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fund_acct is '基金签约操作账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fund_acct_brcno is '基金签约账号开卡网点';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.finance_amt_ch is '理财签约金额大写';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.quickin_leave_amt is '灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.quickin_leave_amt_other is '灵活盈—活期账户留存金额_其它';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_apply_ac_info is '网银申请服务账户信息(1存折或银行卡账户 2 全部账户)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_ac_backs is '网银申请服务账号后六位列表(逗号隔开)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_op_choice is '网银修改服务选项(1登录密码 2手机动态密码)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_password_optp is '网银登录密码操作类型(1重置 2解锁)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.netb_netphone_optp is '手机动态密码操作类型(1开通2注销3指定手机号4变更手机号)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.ukey_optp is '华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_sms_set_phone is '短信通是否设置签约手机号 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_net_trans_limit_set is '是否网银转账限额设置 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_mob_trans_limit_set is '手机银行是否非定向转账限额设置 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.telb_sign_type is '电话银行签约服务操作类型[1开通2修改3注销]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_telb_appoint_phone is '电话银行是否指定交易电话号码 0-否，1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.telb_appoint_phone_optp is '交易电话号码操作类型[1无限制2指定3注销]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.direct_trans_optp is '定向转账操作类型[1开通2修改3注销]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_direct_trans_ac_set is '是否定向收款账户设置[0-否，1-是]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.sms_set_phone_optp is '短信通设置签约手机号操作类型[1-开通 3-注销]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.tel_n_trnsf_optp is '电话银行非定向转账操作类型[1-开通 2-维护 3-解约]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fin_new_acct is '理财银行卡号变更新账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fin_new_open_brcno is '理财银行卡号变更新账号所属机构';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.cust_changes is '客户信息变更内容--1经办人姓名  2证件类型 3证件号码 4经办人手机 5经办人EMAIL 6通讯地址 7邮编 8联系电话  9传真电话  客户信息变更必填';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.redeem_back_tp is '智能定赎巨额赎回处理方式   0-取消1-顺延';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.changed_back_tp is '基金转换巨额赎回处理方式   0-取消1-顺延';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.deposit_trade_no is '交易单编号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.finance_contract_if_succeed is '理财签约是否成功(0-失败 1-成功)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.clientgroup is '客户分组[a-  群客户Z- 其他客户]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.acccycle is '对账周期  1 表示按月对账 2 表示季度对账';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.check_contact is '资金类业务指定查证联系人';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.isfcfnct is '是否非柜面非同名账户限额签约(0-否,1-是)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.daylimit is '日累计限额(非柜面非同名账户限额签约)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.txntimeslimit is '日笔数限额(非柜面非同名账户限额签约)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.yearlimit is '年累计限额(非柜面非同名账户限额签约)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.is_fcfnct_succeed is '非柜面非同名账户限额签约是否成功(0-失败,1-成功)';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.custom_daylimit is '日累计限额(非柜面非同名账户限额签约)--要素扩展收集使用';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.custom_txntimeslimit is '日笔数限额(非柜面非同名账户限额签约)--要素扩展收集使用';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.custom_yearlimit is '年累计限额(非柜面非同名账户限额签约)--要素扩展收集使用';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.ifchangecorpseal is '是否变更公章--0-否 1-是';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.taxresident is '机构税收居民身份（1仅为中国税收居民；2仅为非居民；3既是中国税收居民又是其他国家（地区）税收居民；4无需声明；5空）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.taxarea is '机构税收居民国（地区）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.taxarea2 is '机构税收居民国（地区）2';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.taxarea3 is '机构税收居民国（地区）3';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.taxnumber is '机构纳税人识别号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.taxnumber2 is '机构纳税人识别号2';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.taxnumber3 is '机构纳税人识别号3';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.taxnullreason is '机构纳税人识别号为空原因';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.taxstatement is '机构是否取得自证声明（0未取得 1取得）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.corporgtype is '机构类别';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.taxnullreason2 is '机构纳税人识别号为空原因2';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.taxnullreason3 is '机构纳税人识别号为空原因3';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.other_reason_1 is '';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.other_reason_2 is '';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.other_reason_3 is '';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.holdna3 is '股东姓名3';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_surname is '【控制人一】姓（英文或拼音）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_givenname is '【控制人一】名（英文或拼音）';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_taxresident is '【控制人一】税收居民身份';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_birthdate is '【控制人一】出生日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_taxarea_1 is '【控制人一】税收居民国（地区）①';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_taxnumber_1 is '【控制人一】纳税人识别号①';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_taxnullreason_1 is '【控制人一】不能提供识别号的原因①';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_other_reason_1 is '【控制人一】其它不能提供识别号的原因①';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_taxarea_2 is '【控制人一】税收居民国（地区）②';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_taxnumber_2 is '【控制人一】纳税人识别号②';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_taxnullreason_2 is '【控制人一】不能提供识别号的原因②';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_other_reason_2 is '【控制人一】其它不能提供识别号的原因②';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_taxarea_3 is '【控制人一】税收居民国（地区）③';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_taxnumber_3 is '【控制人一】纳税人识别号③';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_taxnullreason_3 is '【控制人一】不能提供识别号的原因③';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_other_reason_3 is '【控制人一】其它不能提供识别号的原因③';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.controller_1_type is '【控制人一】控制人类型';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.id is '逻辑主键';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.main_flow_id is '核心流水表ID';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.scan_seq_no is '扫描流水号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.process_inst_id is '流程实例id';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fun_code is '功能码[01-单位开户管理,02-单位信息变更,03-单位印鉴变更,04-单位开户缺件补扫,05-单位开户批扫开户许可证]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fr_org_code is '前台机构编码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.tr_date is '交易日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.biz_code is '业务编码[代码T007][参考CFG_T_BIZ_CODE]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.voucher_code is 'HXYH凭证代码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.voucher_no is '凭证号码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.cust_id is '客户编号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.chs_acct_flag is '账号自选标志[代码0014][0-随机账号1-账号自选]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.chs_account is '自选账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.biz_cd_flag is '业务收付标志[代码0015][D-借C-贷]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.spec_acct_type is '存贷款种类[代码0016][1-活期存款 2- 定期存款3-贷款]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.rcv_pay_rang is '收支范围';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.biz_account is '交易账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.acct_type is '账号类别[A活期结算户 B-验资户 C-普通定期户 D-同业定期户]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.acct_char is '帐户性质[4-基本账户 5-临时账户 6-一般账户 7-专用账户 0-同业定期户开立]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.acct_specie is '核准类型[0-无意义 1-自动核准 2-人工核准]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.chk_fund_flag is '验资户标志[代码0097][1-验资户2-非验资户]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.cust_name is '客户名称';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.ab_cust_name is '单位名简称';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.english_name is '英文/拼音名称';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.cst_corp_code is '单位企业代码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.seal_cr_code is '印鉴卡编号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.telephone is '电话号码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.addr_type is '地址类型[代码0050][OFF-单位地址 HOM-家庭地址 AD1-地址1 AD2-地址2 AD3-地址3 AD4-地址4]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.postcode is '邮政编码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.contact_address is '联系地址';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fin_contect_name is '财务联系人';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.pst_bll_address is '对账单地址码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.curr_type is '币别[代码T003][参考CFG_T_CURRENCY_TYPE]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.amount is '金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.draw_reason is '支取依据[代码0103][0010-仅凭印0012-凭印支付密码1000-凭单1100-凭证件1010-凭单印1001-凭密1002-凭单支付密码1110-凭证印1111-凭证印密1112-凭证印支付密码1011-凭印密1012-凭印密支付密码1101-凭证密1102-凭单证支付密码]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.sf_scp_flag is '通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.cal_accr_flag is '记息标志[代码0034][0-否1-是]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.pst_bll_flag is '寄对账单标志[代码0037][N-不寄对帐单Y-寄对帐单]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.cur_acct_type is '账本别';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.pndg_rec_methoed is '手续费收取方式[代码0036][0-集中收取1-分散收取]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.sf_scope is '通兑范围[代码0100][1-全国2-全省3-全市4-全国通存（对公）5-全省通存（对公）6-全市通存（对公）7-不通存（定点存）（对公）]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.acct_status is '账户状态[代码0017][0-正常（正常户及部份冻结）2-冻结（全部冻结）3-结清7-单向冻结]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.attor_opr_code is '客户经理编号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.attor_opr_name is '客户经理姓名';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.attor_org_code is '客户经理所在网点';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.renw_scan_flag is '补扫标志[代码0018][0-初始化1-补扫开户资料2-补扫核查清单]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.print_count is '打印次数';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.acct_open_date is '开户日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.cf_flag is '钞汇标识[代码0011][0-钞1-汇]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.cf_properies is '钞汇属性';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.tr_account is '转账账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.accpt_accr_account is '收息账号';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.int_rate_cert is '利率依据[代码0033][00-固定利率01-牌告利率02-浮动利率]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.int_rt_operation is '浮动利率加减码符号位[代码0099][1-‘+’ 2-‘-’ 3-‘*’]';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.int_rt_cal_code is '浮动利率加减码';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.int_rt is '利率';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.fee_ratio is '费率';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.reserve_amt is '备用金额';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.inval_date is '失效日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.cls_acct_date is '销户日期';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.update_time is '更新时间';
comment on column ${itl_schema}.itl_edw_pbss_flw_t_corp_reg.etl_timestamp is 'ETL处理时间戳';