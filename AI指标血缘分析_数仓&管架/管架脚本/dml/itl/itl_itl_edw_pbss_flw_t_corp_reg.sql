/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_pbss_flw_t_corp_reg
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--营运管驾Itl层存放历史数据
alter table ${itl_schema}.itl_edw_pbss_flw_t_corp_reg drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_pbss_flw_t_corp_reg drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_pbss_flw_t_corp_reg add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_pbss_flw_t_corp_reg partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt -- 数据日期
    ,accredit_id_type1 -- 被受权人证件类型1
    ,accredit_id_no1 -- 被受权人证件号码1
    ,accredit_name2 -- 被受权人姓名2
    ,accredit_id_type2 -- 被受权人证件类型2
    ,accredit_id_no2 -- 被受权人证件号码2
    ,proxy_items -- 受委托人代理权限，多选逗号分隔：1-办理银行开户事宜，2-办理单位网上银行开通事宜，3-办理单位短信通开通事宜，4-办理签收华兴U盾及密码信封，10-其它
    ,reg_depm -- 登记部门：1-工商部门，2-机构编制部门，3-民政部门，4-司法行政部门，5-宗教管理部门，6-外交部门，7-人民银行，8-其他
    ,organiz_tp -- 组织机构类别：1-企业法人，2-个人独资企业，3-合伙企业，4-企业的分支机构，5-其他企业，6-农民专业合作社，7-事业法人，8-未登记的事业单位，9-事业单位的分支机构，10-机关法人，11-机关的内设机构，12-机关的下设机构，13-社会团体法人，14-社会团体分支机构，15-民办非企业，16-基金会，17-居委会，18-村委会，19-律师事务所，20-司法鉴定所，21-宗教活动场所，22-境外在境内成立的组织机构，23-个体工商户，24-其他
    ,reg_notp -- 登记注册号类型：1-工商注册号，2-机关和事业单位登记号，3-社会团体登记号，4-民办非企业登记号，5-基金会登记号，6-宗教证书登记号，7-其他
    ,reg_no -- 登记注册号码
    ,econ_tp -- 经济类型：1-内资，2-国有全资，3-集体全资，4-股份合作，5-联营，6-有限责任公司，7-股份有限公司，8-私有，9-其他内资，10-港澳台投资，11-内地和港澳台投资，12-内地和港澳台合作，13-港澳台独资，14-港澳台投资股份有限公司，15-其他港澳台投资，16-国外投资，17-中外合资，18-中外合作，19-外资，20-国外投资股份有限公司，21-其他国外投资，22-其他
    ,found_date -- 成立日期
    ,up_reg_notp -- 上级机构登记注册号类型：1-工商注册号，2-机关和事业单位登记号，3-社会团体登记号，4-民办非企业登记号，5-基金会登记号，6-宗教证书登记号，7-其他
    ,up_reg_no -- 上级机构登记注册号码
    ,up_organiz_credit_code -- 上级机构信用代码
    ,accredit_legalname -- 授权委托书上法人姓名
    ,accredit_legalidtype -- 授权委托书上法人证件类型
    ,accredit_legalidno -- 授权委托书上法人证件号码
    ,proxy_items_other -- 受委托人代理权限_其它
    ,acsttg -- 账户用途 00-无特殊用途 11-结算性 12-投融资性
    ,funds_escape_check -- 小于等于多少人民币的转账和提现业务免予查证（0否 1是）
    ,call_orders -- 查证顺序
    ,all_escape_check -- 所有业务无需查证（0否 1是）
    ,not_funds_escape_check -- 非资金类业务免予查证（0否 1是）
    ,other_busi_check -- 其它业务给予查证
    ,principal_funds_check -- 资金类法人查证标志（1指定查证）
    ,fin_contect_funds_check -- 资金类财务负责人查证标志（1指定查证）
    ,chrg_funds_check1 -- 资金类主管1查证标志（1指定查证）
    ,chrg_funds_check2 -- 资金类主管2查证标志（1指定查证）
    ,funds_must_check -- 资金类业务是否指定人员查证（0否 1是）
    ,produce_addr -- 生产经营地址
    ,credit_no -- 中征（贷款卡）号码
    ,workers -- 职工人数
    ,income -- 营业收入
    ,properties -- 资产总额
    ,organ_type -- 组织机构类别[  1-企业、2-事业单位、3-机关、4-社会团体、5-个体工商户、6-其他]
    ,up_organiz_name -- 上级机构名称
    ,up_organiz_code -- 上级组织机构号码
    ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,trade_type_detail -- 行业细分[见数据字典]
    ,sign_type -- 签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5
    ,is_other_manage -- 是否三方存管--0-否 1-是
    ,apply_type -- 申请业务种类--1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
    ,bond_code -- 券商代码
    ,bond_name -- 券商名称
    ,bond_acct -- 证券资金台账账号
    ,bond_new_acct -- 新账号
    ,is_fund_acct -- 基金代销-账户类签约--0-否 1-是
    ,fund_acct_type -- 基金代销-账户类签约 业务类型--1签约 2解约 3开户 4销户   5基金账户登记 6基金账户取消登记        7客户信息变更 8更换银行卡号 9非交易过户
    ,send_type -- 对账单寄送要求--1-寄送 0-不寄送
    ,old_acct -- 旧卡号/账号--默认前“签约账号”项 （交易账户变更填写）
    ,new_acct -- 新账号（交易账户变更填写）
    ,transfer_reason -- 过户原因--1继承 2捐赠 3司法判决 (非交易过户填写)
    ,low_paper_id -- 法律文本编号(非交易过户填写)
    ,trun_in_acct -- 转入方账号(非交易过户填写)
    ,transfer_fund_code -- 过户基金代码(非交易过户填写)
    ,transfer_fund_lot -- 过户基金份额(非交易过户填写)
    ,is_fund_trade -- 基金代销-交易类 签约--0-否 1-是
    ,fund_trade_type -- 基金代销-交易类 签约类型1基金认购 2基金申购 3基金赎回  4智能定投赎回 5基金转换 6基金转托管7当日交易撤单 8分红方式变更
    ,fund_name -- 基金名称
    ,fund_code -- 基金代码
    ,is_subscribe -- 是否基金认购/申购 0-否，1-是
    ,subscribe_amt -- 基金认购/申购金额
    ,is_redeem -- 是否基金赎回 0-否，1-是
    ,redeem_sum -- 赎回份额
    ,huge_redeem_tpye -- 巨额赎回处理方式 1-取消2-顺延
    ,is_smart_invest -- 智能定投 0-否，1-是
    ,first_invest_amt -- 首次投资金额
    ,invest_date -- 投资日(投资日为1-28日，任选)
    ,later_invest_type -- 后续投资方式 1固定金额 2账户余额比例 3每期递增金额
    ,later_invest_optp -- 后续投资方式操作类型 1-开通2-修改
    ,invest_fixed_amt -- 后续投资固定金额（元）
    ,invest_remain_ratio -- 后续投资账户余额比例(%)
    ,invest_per_add_amt -- 后续投资每期递增金额(元)
    ,invest_period_opyp -- 投资周期操作类型
    ,invest_period_type -- 投资周期类型 1-月 2-周 3-日
    ,later_invest_period -- 投资周期(数值)
    ,invest_deadline_optp -- 投资期限操作类型 1-开通2-修改
    ,invest_deadline_type -- 投资期限类型 1终止日期 2投资期数 3累计投资金额
    ,time_invest_deadline -- 投资期限终止日期
    ,invest_number -- 投资期限投资期数
    ,invest_amt_sum -- 投资期限累计投资金额
    ,savings_invest_optp -- 储蓄定投操作类型 1-终止 2-暂停 3-恢复
    ,invest_code -- 定投编号
    ,is_smart_redeem -- 智能定赎开通(或修改)  0-否，1-是
    ,first_redeem_sum -- 首次赎回份额
    ,redeem_date -- 赎回日 (赎回日为1-28日，任选)
    ,later_redeem_type -- 后续赎回方式 1固定份额 2账户余额比例 3每期递增金额
    ,later_redeem_optp -- 后续赎回方式操作类型 1-开通 2-修改
    ,redeem_fixed_amt -- 后续赎回固定金额（元）
    ,redeem_remain_ratio -- 后续赎回账户余额比例(%)
    ,redeem_per_add_amt -- 后续赎回每期递增金额(元)
    ,redeem_period_opyp -- 赎回周期操作类型 1-开通2-修改
    ,redeem_period_type -- 赎回周期类型 1-月 2-周 3-日
    ,redeem_period -- 赎回周期(数值)
    ,redeem_deadline_optp -- 赎回期限操作类型 1-开通2-修改
    ,redeem_deadline_type -- 赎回期限类型 1终止日期 2赎回期数 3累计赎回金额
    ,redeem_deadline -- 赎回期限终止日期
    ,redeem_number -- 赎回期限赎回期数
    ,redeem_amt_sum -- 赎回期限累计赎回金额
    ,smart_redeem_optp -- 智能定赎操作类型 1终止2暂停3恢复
    ,redeem_code -- 定赎编号
    ,is_fund_change -- 是否资金转换  0-否，1-是
    ,changed_fund_name -- 转换后基金名称
    ,changed_fund_code -- 转换后基金代码
    ,changed_fund_sum -- 转换基金份额
    ,is_fund_deposit -- 是否资金转托管  0-否，1-是
    ,deposit_fund_name -- 基金名称(资金转托管)
    ,deposit_fund_code -- 基金代码(资金转托管)
    ,deposit_fund_sum -- 基金份额
    ,deposit_brcna -- 对方机构名称
    ,is_day_withdraw -- 是否当日交易撤单   0-否，1-是
    ,ori_scan_seqno -- 原流水号
    ,is_share_change -- 是否分红方式变更 0-否 1-是
    ,is_cash_share -- 是否现金分红 0-否 1-是
    ,is_share_invest -- 是否红利再投资 0-否 1-是
    ,is_finance -- 是否理财签约操作--0-否 1-是
    ,finance_optp -- 理财操作类型--4购买 5赎回 6预约撤单
    ,finance_apply -- 理财业务申请
    ,finance_product_name -- 理财产品名称
    ,finance_product_code -- 理财产品编号
    ,finance_product_deadline -- 期限
    ,finance_product_curr -- 币种--参考币种字典
    ,finance_amt -- 理财签约金额
    ,finance_amt_zh -- 金额(大写)
    ,netb_acct1 -- 账号（1）
    ,netb_acct1_optp -- 账号（1）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号①不为空必送
    ,netb_acct2 -- 账号（2）
    ,netb_acct2_optp -- 账号（2）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号②不为空必送
    ,netb_acct3 -- 账号（3）
    ,netb_acct3_optp -- 账号（3）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号③不为空必送
    ,netbapplys -- 网银服务申请--1 开通 2 注销 3 暂停 4 恢复 5新增 6取消
    ,netb_add_type -- 网银服务新增类型--1全选 2单项或多项
    ,netb_add_apps -- 网银服务新增集合--1查询 2转账汇款 3发工资4费用报销5定活互转6通知存款7打印8其他
    ,netb_cancel_type -- 网银服务取消类型--1全选 2单项或多项
    ,netb_cancel_apps -- 网银服务取消集合--1查询 2转账汇款3发工资4费用报销5定活互转6通知存款7打印8其他
    ,peoxy_phone -- 代理人手机
    ,peoxy_email -- 代理人E-MAIL
    ,acct -- 结算账号--默认为前签约账户
    ,fin_quotient -- 理财 购买/赎回份数
    ,fin_ori_entrust_no -- 理财撤单 原委托流水号
    ,fin_ori_entrust_date -- 理财撤单 原委托日期
    ,is_fund_contract -- 是否操作基金(0-否 1-是)
    ,fundopflag -- 基金操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,fin_manager_id -- 理财经理编号
    ,szsecno -- 深交所证券账号
    ,shsecno -- 上交所证券账号
    ,minorflag -- 是否成年人标志 0-否，1-是
    ,fundnewacct -- 基金新银行卡号
    ,fund_contract_if_succeed -- 基金签约操作是否成功(0-失败 1-成功)
    ,is_third_manage_contract -- 是否三方存管签约操作
    ,cobank -- 合作行
    ,ori_acct -- 三方存管原结算账号
    ,ori_brcode -- 三方存管原结算账号开户机构
    ,bond_pass -- 证券资金台账密码
    ,third_manage_if_succeed -- 三方存管签约操作是否成功(0-失败 1-成功)
    ,is_smart_cat_contract -- 是否招财猫|智能存款签约操作 0-否，1-是
    ,smart_cat_opflag -- 招财猫|智能存款签约操作类型 1.签约(开通)2. 维护(变更)3. 撤销(解约)
    ,smart_cat_sign_kind -- 招财猫|智能存款签约种类 1-灵活盈 2-储蓄定投 3-滚存储蓄 4-滚动储蓄
    ,is_invest_contract -- 是否储蓄定投签约操作 0-否，1-是
    ,invest_opflag -- 储蓄定投操作类型 1-签约 2-维护 3-解约
    ,invest_contract_if_succeed -- 储蓄定投签约操作是否成功(0-失败 1-成功)
    ,is_quickin_contract -- 是否灵活盈签约操作 0-否，1-是
    ,quickin_opflag -- 灵活盈签约操作类型 1-签约 2-维护 3-解约
    ,chan_save_tp -- 灵活盈转存类型 1-活期转双整 2-活期转通知
    ,chan_save_deadline -- 灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年
    ,chan_save_amt -- 转存起点金额
    ,save_low_amt -- 最低留存金额
    ,chan_save_multiple -- 转存基数倍额
    ,quickin_contract_if_succeed -- 灵活盈签约操作是否成功(0-失败 1-成功)
    ,third_ma_apply_tp -- 三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
    ,third_ma_new_acct -- 三方存管新账号
    ,is_acctfund_contract -- 基金代销账户类签约操作 0-否，1-是
    ,acctfund_sign_type -- 基金代销账户类签约种类 1-签约2-解约3-开户 4-销户5-基金账户登记6-基金账户取消登记7-客户信息变更8-更换银行卡号9-非交易过户
    ,is_bill_send -- 对账单寄送要求 1-寄送0-不寄送
    ,acctfund_ori_acct -- 交易账户变更原账号 默认前“签约账号”项
    ,nontrade_chan_reason -- 非交易过户原因 1-继承2-捐赠3-司法判决
    ,legal_paper_id -- 法律文本编号
    ,nontrade_to_acct -- 转入方账号
    ,chan_fund_code -- 过户基金代码
    ,chan_fund_sum -- 过户基金份额
    ,is_tradefund_contract -- 基金代销交易类签约操作 0-否，1-是
    ,tradefund_sign_type -- 基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更
    ,tradefund_name -- 基金名称
    ,tradefund_code -- 基金代码
    ,invest_period_optp -- 投资周期操作类型 1-开通2-修改
    ,time_invest_code -- 定投编号
    ,time_redeem_code -- 定赎编号
    ,third_manage_optp -- 三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,finance_deadline -- 理财期限
    ,is_cat_sign -- 是否招财猫签约 0-否，1-是
    ,fund_acct -- 基金签约操作账号
    ,fund_acct_brcno -- 基金签约账号开卡网点
    ,finance_amt_ch -- 理财签约金额大写
    ,quickin_leave_amt -- 灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)
    ,quickin_leave_amt_other -- 灵活盈—活期账户留存金额_其它
    ,netb_apply_ac_info -- 网银申请服务账户信息(1存折或银行卡账户 2 全部账户)
    ,netb_ac_backs -- 网银申请服务账号后六位列表(逗号隔开)
    ,netb_op_choice -- 网银修改服务选项(1登录密码 2手机动态密码)
    ,netb_password_optp -- 网银登录密码操作类型(1重置 2解锁)
    ,netb_netphone_optp -- 手机动态密码操作类型(1开通2注销3指定手机号4变更手机号)
    ,ukey_optp -- 华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)
    ,is_sms_set_phone -- 短信通是否设置签约手机号 0-否，1-是
    ,is_net_trans_limit_set -- 是否网银转账限额设置 0-否，1-是
    ,is_mob_trans_limit_set -- 手机银行是否非定向转账限额设置 0-否，1-是
    ,telb_sign_type -- 电话银行签约服务操作类型[1开通2修改3注销]
    ,is_telb_appoint_phone -- 电话银行是否指定交易电话号码 0-否，1-是
    ,telb_appoint_phone_optp -- 交易电话号码操作类型[1无限制2指定3注销]
    ,direct_trans_optp -- 定向转账操作类型[1开通2修改3注销]
    ,is_direct_trans_ac_set -- 是否定向收款账户设置[0-否，1-是]
    ,sms_set_phone_optp -- 短信通设置签约手机号操作类型[1-开通 3-注销]
    ,tel_n_trnsf_optp -- 电话银行非定向转账操作类型[1-开通 2-维护 3-解约]
    ,fin_new_acct -- 理财银行卡号变更新账号
    ,fin_new_open_brcno -- 理财银行卡号变更新账号所属机构
    ,cust_changes -- 客户信息变更内容--1经办人姓名  2证件类型 3证件号码 4经办人手机 5经办人EMAIL 6通讯地址 7邮编 8联系电话  9传真电话  客户信息变更必填
    ,redeem_back_tp -- 智能定赎巨额赎回处理方式   0-取消1-顺延
    ,changed_back_tp -- 基金转换巨额赎回处理方式   0-取消1-顺延
    ,deposit_trade_no -- 交易单编号
    ,finance_contract_if_succeed -- 理财签约是否成功(0-失败 1-成功)
    ,clientgroup -- 客户分组[a-  群客户Z- 其他客户]
    ,acccycle -- 对账周期  1 表示按月对账 2 表示季度对账
    ,check_contact -- 资金类业务指定查证联系人
    ,isfcfnct -- 是否非柜面非同名账户限额签约(0-否,1-是)
    ,daylimit -- 日累计限额(非柜面非同名账户限额签约)
    ,txntimeslimit -- 日笔数限额(非柜面非同名账户限额签约)
    ,yearlimit -- 年累计限额(非柜面非同名账户限额签约)
    ,is_fcfnct_succeed -- 非柜面非同名账户限额签约是否成功(0-失败,1-成功)
    ,custom_daylimit -- 日累计限额(非柜面非同名账户限额签约)--要素扩展收集使用
    ,custom_txntimeslimit -- 日笔数限额(非柜面非同名账户限额签约)--要素扩展收集使用
    ,custom_yearlimit -- 年累计限额(非柜面非同名账户限额签约)--要素扩展收集使用
    ,ifchangecorpseal -- 是否变更公章--0-否 1-是
    ,taxresident -- 机构税收居民身份（1仅为中国税收居民；2仅为非居民；3既是中国税收居民又是其他国家（地区）税收居民；4无需声明；5空）
    ,taxarea -- 机构税收居民国（地区）
    ,taxarea2 -- 机构税收居民国（地区）2
    ,taxarea3 -- 机构税收居民国（地区）3
    ,taxnumber -- 机构纳税人识别号
    ,taxnumber2 -- 机构纳税人识别号2
    ,taxnumber3 -- 机构纳税人识别号3
    ,taxnullreason -- 机构纳税人识别号为空原因
    ,taxstatement -- 机构是否取得自证声明（0未取得 1取得）
    ,corporgtype -- 机构类别
    ,taxnullreason2 -- 机构纳税人识别号为空原因2
    ,taxnullreason3 -- 机构纳税人识别号为空原因3
    ,other_reason_1 -- 
    ,other_reason_2 -- 
    ,other_reason_3 -- 
    ,holdna3 -- 股东姓名3
    ,controller_1_surname -- 【控制人一】姓（英文或拼音）
    ,controller_1_givenname -- 【控制人一】名（英文或拼音）
    ,controller_1_taxresident -- 【控制人一】税收居民身份
    ,controller_1_birthdate -- 【控制人一】出生日期
    ,controller_1_taxarea_1 -- 【控制人一】税收居民国（地区）①
    ,controller_1_taxnumber_1 -- 【控制人一】纳税人识别号①
    ,controller_1_taxnullreason_1 -- 【控制人一】不能提供识别号的原因①
    ,controller_1_other_reason_1 -- 【控制人一】其它不能提供识别号的原因①
    ,controller_1_taxarea_2 -- 【控制人一】税收居民国（地区）②
    ,controller_1_taxnumber_2 -- 【控制人一】纳税人识别号②
    ,controller_1_taxnullreason_2 -- 【控制人一】不能提供识别号的原因②
    ,controller_1_other_reason_2 -- 【控制人一】其它不能提供识别号的原因②
    ,controller_1_taxarea_3 -- 【控制人一】税收居民国（地区）③
    ,controller_1_taxnumber_3 -- 【控制人一】纳税人识别号③
    ,controller_1_taxnullreason_3 -- 【控制人一】不能提供识别号的原因③
    ,controller_1_other_reason_3 -- 【控制人一】其它不能提供识别号的原因③
    ,controller_1_type -- 【控制人一】控制人类型
    ,id -- 逻辑主键
    ,main_flow_id -- 核心流水表ID
    ,scan_seq_no -- 扫描流水号
    ,process_inst_id -- 流程实例id
    ,fun_code -- 功能码[01-单位开户管理,02-单位信息变更,03-单位印鉴变更,04-单位开户缺件补扫,05-单位开户批扫开户许可证]
    ,fr_org_code -- 前台机构编码
    ,tr_date -- 交易日期
    ,biz_code -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
    ,voucher_code -- HXYH凭证代码
    ,voucher_no -- 凭证号码
    ,cust_id -- 客户编号
    ,chs_acct_flag -- 账号自选标志[代码0014][0-随机账号1-账号自选]
    ,chs_account -- 自选账号
    ,biz_cd_flag -- 业务收付标志[代码0015][D-借C-贷]
    ,spec_acct_type -- 存贷款种类[代码0016][1-活期存款 2- 定期存款3-贷款]
    ,rcv_pay_rang -- 收支范围
    ,biz_account -- 交易账号
    ,acct_type -- 账号类别[A活期结算户 B-验资户 C-普通定期户 D-同业定期户]
    ,acct_char -- 帐户性质[4-基本账户 5-临时账户 6-一般账户 7-专用账户 0-同业定期户开立]
    ,acct_specie -- 核准类型[0-无意义 1-自动核准 2-人工核准]
    ,chk_fund_flag -- 验资户标志[代码0097][1-验资户2-非验资户]
    ,cust_name -- 客户名称
    ,ab_cust_name -- 单位名简称
    ,english_name -- 英文/拼音名称
    ,cst_corp_code -- 单位企业代码
    ,seal_cr_code -- 印鉴卡编号
    ,telephone -- 电话号码
    ,addr_type -- 地址类型[代码0050][OFF-单位地址 HOM-家庭地址 AD1-地址1 AD2-地址2 AD3-地址3 AD4-地址4]
    ,postcode -- 邮政编码
    ,contact_address -- 联系地址
    ,fin_contect_name -- 财务联系人
    ,pst_bll_address -- 对账单地址码
    ,curr_type -- 币别[代码T003][参考CFG_T_CURRENCY_TYPE]
    ,amount -- 金额
    ,draw_reason -- 支取依据[代码0103][0010-仅凭印0012-凭印支付密码1000-凭单1100-凭证件1010-凭单印1001-凭密1002-凭单支付密码1110-凭证印1111-凭证印密1112-凭证印支付密码1011-凭印密1012-凭印密支付密码1101-凭证密1102-凭单证支付密码]
    ,sf_scp_flag -- 通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]
    ,cal_accr_flag -- 记息标志[代码0034][0-否1-是]
    ,pst_bll_flag -- 寄对账单标志[代码0037][N-不寄对帐单Y-寄对帐单]
    ,cur_acct_type -- 账本别
    ,pndg_rec_methoed -- 手续费收取方式[代码0036][0-集中收取1-分散收取]
    ,sf_scope -- 通兑范围[代码0100][1-全国2-全省3-全市4-全国通存（对公）5-全省通存（对公）6-全市通存（对公）7-不通存（定点存）（对公）]
    ,acct_status -- 账户状态[代码0017][0-正常（正常户及部份冻结）2-冻结（全部冻结）3-结清7-单向冻结]
    ,attor_opr_code -- 客户经理编号
    ,attor_opr_name -- 客户经理姓名
    ,attor_org_code -- 客户经理所在网点
    ,renw_scan_flag -- 补扫标志[代码0018][0-初始化1-补扫开户资料2-补扫核查清单]
    ,print_count -- 打印次数
    ,acct_open_date -- 开户日期
    ,cf_flag -- 钞汇标识[代码0011][0-钞1-汇]
    ,cf_properies -- 钞汇属性
    ,tr_account -- 转账账号
    ,accpt_accr_account -- 收息账号
    ,int_rate_cert -- 利率依据[代码0033][00-固定利率01-牌告利率02-浮动利率]
    ,int_rt_operation -- 浮动利率加减码符号位[代码0099][1-‘+’ 2-‘-’ 3-‘*’]
    ,int_rt_cal_code -- 浮动利率加减码
    ,int_rt -- 利率
    ,fee_ratio -- 费率
    ,reserve_amt -- 备用金额
    ,inval_date -- 失效日期
    ,cls_acct_date -- 销户日期
    ,update_time -- 更新时间
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(etl_dt, to_date('00010101', 'yyyymmdd')) as etl_dt -- 数据日期
    ,nvl(trim(accredit_id_type1), ' ') as accredit_id_type1 -- 被受权人证件类型1
    ,nvl(trim(accredit_id_no1), ' ') as accredit_id_no1 -- 被受权人证件号码1
    ,nvl(trim(accredit_name2), ' ') as accredit_name2 -- 被受权人姓名2
    ,nvl(trim(accredit_id_type2), ' ') as accredit_id_type2 -- 被受权人证件类型2
    ,nvl(trim(accredit_id_no2), ' ') as accredit_id_no2 -- 被受权人证件号码2
    ,nvl(trim(proxy_items), ' ') as proxy_items -- 受委托人代理权限，多选逗号分隔：1-办理银行开户事宜，2-办理单位网上银行开通事宜，3-办理单位短信通开通事宜，4-办理签收华兴U盾及密码信封，10-其它
    ,nvl(trim(reg_depm), ' ') as reg_depm -- 登记部门：1-工商部门，2-机构编制部门，3-民政部门，4-司法行政部门，5-宗教管理部门，6-外交部门，7-人民银行，8-其他
    ,nvl(trim(organiz_tp), ' ') as organiz_tp -- 组织机构类别：1-企业法人，2-个人独资企业，3-合伙企业，4-企业的分支机构，5-其他企业，6-农民专业合作社，7-事业法人，8-未登记的事业单位，9-事业单位的分支机构，10-机关法人，11-机关的内设机构，12-机关的下设机构，13-社会团体法人，14-社会团体分支机构，15-民办非企业，16-基金会，17-居委会，18-村委会，19-律师事务所，20-司法鉴定所，21-宗教活动场所，22-境外在境内成立的组织机构，23-个体工商户，24-其他
    ,nvl(trim(reg_notp), ' ') as reg_notp -- 登记注册号类型：1-工商注册号，2-机关和事业单位登记号，3-社会团体登记号，4-民办非企业登记号，5-基金会登记号，6-宗教证书登记号，7-其他
    ,nvl(trim(reg_no), ' ') as reg_no -- 登记注册号码
    ,nvl(trim(econ_tp), ' ') as econ_tp -- 经济类型：1-内资，2-国有全资，3-集体全资，4-股份合作，5-联营，6-有限责任公司，7-股份有限公司，8-私有，9-其他内资，10-港澳台投资，11-内地和港澳台投资，12-内地和港澳台合作，13-港澳台独资，14-港澳台投资股份有限公司，15-其他港澳台投资，16-国外投资，17-中外合资，18-中外合作，19-外资，20-国外投资股份有限公司，21-其他国外投资，22-其他
    ,nvl(trim(found_date), ' ') as found_date -- 成立日期
    ,nvl(trim(up_reg_notp), ' ') as up_reg_notp -- 上级机构登记注册号类型：1-工商注册号，2-机关和事业单位登记号，3-社会团体登记号，4-民办非企业登记号，5-基金会登记号，6-宗教证书登记号，7-其他
    ,nvl(trim(up_reg_no), ' ') as up_reg_no -- 上级机构登记注册号码
    ,nvl(trim(up_organiz_credit_code), ' ') as up_organiz_credit_code -- 上级机构信用代码
    ,nvl(trim(accredit_legalname), ' ') as accredit_legalname -- 授权委托书上法人姓名
    ,nvl(trim(accredit_legalidtype), ' ') as accredit_legalidtype -- 授权委托书上法人证件类型
    ,nvl(trim(accredit_legalidno), ' ') as accredit_legalidno -- 授权委托书上法人证件号码
    ,nvl(trim(proxy_items_other), ' ') as proxy_items_other -- 受委托人代理权限_其它
    ,nvl(trim(acsttg), ' ') as acsttg -- 账户用途 00-无特殊用途 11-结算性 12-投融资性
    ,nvl(trim(funds_escape_check), ' ') as funds_escape_check -- 小于等于多少人民币的转账和提现业务免予查证（0否 1是）
    ,nvl(trim(call_orders), ' ') as call_orders -- 查证顺序
    ,nvl(trim(all_escape_check), ' ') as all_escape_check -- 所有业务无需查证（0否 1是）
    ,nvl(trim(not_funds_escape_check), ' ') as not_funds_escape_check -- 非资金类业务免予查证（0否 1是）
    ,nvl(trim(other_busi_check), ' ') as other_busi_check -- 其它业务给予查证
    ,nvl(trim(principal_funds_check), ' ') as principal_funds_check -- 资金类法人查证标志（1指定查证）
    ,nvl(trim(fin_contect_funds_check), ' ') as fin_contect_funds_check -- 资金类财务负责人查证标志（1指定查证）
    ,nvl(trim(chrg_funds_check1), ' ') as chrg_funds_check1 -- 资金类主管1查证标志（1指定查证）
    ,nvl(trim(chrg_funds_check2), ' ') as chrg_funds_check2 -- 资金类主管2查证标志（1指定查证）
    ,nvl(trim(funds_must_check), ' ') as funds_must_check -- 资金类业务是否指定人员查证（0否 1是）
    ,nvl(trim(produce_addr), ' ') as produce_addr -- 生产经营地址
    ,nvl(trim(credit_no), ' ') as credit_no -- 中征（贷款卡）号码
    ,nvl(trim(workers), ' ') as workers -- 职工人数
    ,nvl(trim(income), 0) as income -- 营业收入
    ,nvl(trim(properties), 0) as properties -- 资产总额
    ,nvl(trim(organ_type), ' ') as organ_type -- 组织机构类别[  1-企业、2-事业单位、3-机关、4-社会团体、5-个体工商户、6-其他]
    ,nvl(trim(up_organiz_name), ' ') as up_organiz_name -- 上级机构名称
    ,nvl(trim(up_organiz_code), ' ') as up_organiz_code -- 上级组织机构号码
    ,nvl(trim(submit_state), ' ') as submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,nvl(trim(trade_type_detail), ' ') as trade_type_detail -- 行业细分[见数据字典]
    ,nvl(trim(sign_type), ' ') as sign_type -- 签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5
    ,nvl(trim(is_other_manage), ' ') as is_other_manage -- 是否三方存管--0-否 1-是
    ,nvl(trim(apply_type), ' ') as apply_type -- 申请业务种类--1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
    ,nvl(trim(bond_code), ' ') as bond_code -- 券商代码
    ,nvl(trim(bond_name), ' ') as bond_name -- 券商名称
    ,nvl(trim(bond_acct), ' ') as bond_acct -- 证券资金台账账号
    ,nvl(trim(bond_new_acct), ' ') as bond_new_acct -- 新账号
    ,nvl(trim(is_fund_acct), ' ') as is_fund_acct -- 基金代销-账户类签约--0-否 1-是
    ,nvl(trim(fund_acct_type), ' ') as fund_acct_type -- 基金代销-账户类签约 业务类型--1签约 2解约 3开户 4销户   5基金账户登记 6基金账户取消登记        7客户信息变更 8更换银行卡号 9非交易过户
    ,nvl(trim(send_type), ' ') as send_type -- 对账单寄送要求--1-寄送 0-不寄送
    ,nvl(trim(old_acct), ' ') as old_acct -- 旧卡号/账号--默认前“签约账号”项 （交易账户变更填写）
    ,nvl(trim(new_acct), ' ') as new_acct -- 新账号（交易账户变更填写）
    ,nvl(trim(transfer_reason), ' ') as transfer_reason -- 过户原因--1继承 2捐赠 3司法判决 (非交易过户填写)
    ,nvl(trim(low_paper_id), ' ') as low_paper_id -- 法律文本编号(非交易过户填写)
    ,nvl(trim(trun_in_acct), ' ') as trun_in_acct -- 转入方账号(非交易过户填写)
    ,nvl(trim(transfer_fund_code), ' ') as transfer_fund_code -- 过户基金代码(非交易过户填写)
    ,nvl(trim(transfer_fund_lot), ' ') as transfer_fund_lot -- 过户基金份额(非交易过户填写)
    ,nvl(trim(is_fund_trade), ' ') as is_fund_trade -- 基金代销-交易类 签约--0-否 1-是
    ,nvl(trim(fund_trade_type), ' ') as fund_trade_type -- 基金代销-交易类 签约类型1基金认购 2基金申购 3基金赎回  4智能定投赎回 5基金转换 6基金转托管7当日交易撤单 8分红方式变更
    ,nvl(trim(fund_name), ' ') as fund_name -- 基金名称
    ,nvl(trim(fund_code), ' ') as fund_code -- 基金代码
    ,nvl(trim(is_subscribe), ' ') as is_subscribe -- 是否基金认购/申购 0-否，1-是
    ,nvl(trim(subscribe_amt), 0) as subscribe_amt -- 基金认购/申购金额
    ,nvl(trim(is_redeem), ' ') as is_redeem -- 是否基金赎回 0-否，1-是
    ,nvl(trim(redeem_sum), ' ') as redeem_sum -- 赎回份额
    ,nvl(trim(huge_redeem_tpye), ' ') as huge_redeem_tpye -- 巨额赎回处理方式 1-取消2-顺延
    ,nvl(trim(is_smart_invest), ' ') as is_smart_invest -- 智能定投 0-否，1-是
    ,nvl(trim(first_invest_amt), 0) as first_invest_amt -- 首次投资金额
    ,nvl(trim(invest_date), ' ') as invest_date -- 投资日(投资日为1-28日，任选)
    ,nvl(trim(later_invest_type), ' ') as later_invest_type -- 后续投资方式 1固定金额 2账户余额比例 3每期递增金额
    ,nvl(trim(later_invest_optp), ' ') as later_invest_optp -- 后续投资方式操作类型 1-开通2-修改
    ,nvl(trim(invest_fixed_amt), 0) as invest_fixed_amt -- 后续投资固定金额（元）
    ,nvl(trim(invest_remain_ratio), ' ') as invest_remain_ratio -- 后续投资账户余额比例(%)
    ,nvl(trim(invest_per_add_amt), 0) as invest_per_add_amt -- 后续投资每期递增金额(元)
    ,nvl(trim(invest_period_opyp), ' ') as invest_period_opyp -- 投资周期操作类型
    ,nvl(trim(invest_period_type), ' ') as invest_period_type -- 投资周期类型 1-月 2-周 3-日
    ,nvl(trim(later_invest_period), ' ') as later_invest_period -- 投资周期(数值)
    ,nvl(trim(invest_deadline_optp), ' ') as invest_deadline_optp -- 投资期限操作类型 1-开通2-修改
    ,nvl(trim(invest_deadline_type), ' ') as invest_deadline_type -- 投资期限类型 1终止日期 2投资期数 3累计投资金额
    ,nvl(trim(time_invest_deadline), ' ') as time_invest_deadline -- 投资期限终止日期
    ,nvl(trim(invest_number), ' ') as invest_number -- 投资期限投资期数
    ,nvl(trim(invest_amt_sum), 0) as invest_amt_sum -- 投资期限累计投资金额
    ,nvl(trim(savings_invest_optp), ' ') as savings_invest_optp -- 储蓄定投操作类型 1-终止 2-暂停 3-恢复
    ,nvl(trim(invest_code), ' ') as invest_code -- 定投编号
    ,nvl(trim(is_smart_redeem), ' ') as is_smart_redeem -- 智能定赎开通(或修改)  0-否，1-是
    ,nvl(trim(first_redeem_sum), ' ') as first_redeem_sum -- 首次赎回份额
    ,nvl(trim(redeem_date), ' ') as redeem_date -- 赎回日 (赎回日为1-28日，任选)
    ,nvl(trim(later_redeem_type), ' ') as later_redeem_type -- 后续赎回方式 1固定份额 2账户余额比例 3每期递增金额
    ,nvl(trim(later_redeem_optp), ' ') as later_redeem_optp -- 后续赎回方式操作类型 1-开通 2-修改
    ,nvl(trim(redeem_fixed_amt), 0) as redeem_fixed_amt -- 后续赎回固定金额（元）
    ,nvl(trim(redeem_remain_ratio), ' ') as redeem_remain_ratio -- 后续赎回账户余额比例(%)
    ,nvl(trim(redeem_per_add_amt), 0) as redeem_per_add_amt -- 后续赎回每期递增金额(元)
    ,nvl(trim(redeem_period_opyp), ' ') as redeem_period_opyp -- 赎回周期操作类型 1-开通2-修改
    ,nvl(trim(redeem_period_type), ' ') as redeem_period_type -- 赎回周期类型 1-月 2-周 3-日
    ,nvl(trim(redeem_period), ' ') as redeem_period -- 赎回周期(数值)
    ,nvl(trim(redeem_deadline_optp), ' ') as redeem_deadline_optp -- 赎回期限操作类型 1-开通2-修改
    ,nvl(trim(redeem_deadline_type), ' ') as redeem_deadline_type -- 赎回期限类型 1终止日期 2赎回期数 3累计赎回金额
    ,nvl(trim(redeem_deadline), ' ') as redeem_deadline -- 赎回期限终止日期
    ,nvl(trim(redeem_number), ' ') as redeem_number -- 赎回期限赎回期数
    ,nvl(trim(redeem_amt_sum), 0) as redeem_amt_sum -- 赎回期限累计赎回金额
    ,nvl(trim(smart_redeem_optp), ' ') as smart_redeem_optp -- 智能定赎操作类型 1终止2暂停3恢复
    ,nvl(trim(redeem_code), ' ') as redeem_code -- 定赎编号
    ,nvl(trim(is_fund_change), ' ') as is_fund_change -- 是否资金转换  0-否，1-是
    ,nvl(trim(changed_fund_name), ' ') as changed_fund_name -- 转换后基金名称
    ,nvl(trim(changed_fund_code), ' ') as changed_fund_code -- 转换后基金代码
    ,nvl(trim(changed_fund_sum), ' ') as changed_fund_sum -- 转换基金份额
    ,nvl(trim(is_fund_deposit), ' ') as is_fund_deposit -- 是否资金转托管  0-否，1-是
    ,nvl(trim(deposit_fund_name), ' ') as deposit_fund_name -- 基金名称(资金转托管)
    ,nvl(trim(deposit_fund_code), ' ') as deposit_fund_code -- 基金代码(资金转托管)
    ,nvl(trim(deposit_fund_sum), ' ') as deposit_fund_sum -- 基金份额
    ,nvl(trim(deposit_brcna), ' ') as deposit_brcna -- 对方机构名称
    ,nvl(trim(is_day_withdraw), ' ') as is_day_withdraw -- 是否当日交易撤单   0-否，1-是
    ,nvl(trim(ori_scan_seqno), ' ') as ori_scan_seqno -- 原流水号
    ,nvl(trim(is_share_change), ' ') as is_share_change -- 是否分红方式变更 0-否 1-是
    ,nvl(trim(is_cash_share), ' ') as is_cash_share -- 是否现金分红 0-否 1-是
    ,nvl(trim(is_share_invest), ' ') as is_share_invest -- 是否红利再投资 0-否 1-是
    ,nvl(trim(is_finance), ' ') as is_finance -- 是否理财签约操作--0-否 1-是
    ,nvl(trim(finance_optp), ' ') as finance_optp -- 理财操作类型--4购买 5赎回 6预约撤单
    ,nvl(trim(finance_apply), ' ') as finance_apply -- 理财业务申请
    ,nvl(trim(finance_product_name), ' ') as finance_product_name -- 理财产品名称
    ,nvl(trim(finance_product_code), ' ') as finance_product_code -- 理财产品编号
    ,nvl(trim(finance_product_deadline), ' ') as finance_product_deadline -- 期限
    ,nvl(trim(finance_product_curr), ' ') as finance_product_curr -- 币种--参考币种字典
    ,nvl(trim(finance_amt), 0) as finance_amt -- 理财签约金额
    ,nvl(trim(finance_amt_zh), ' ') as finance_amt_zh -- 金额(大写)
    ,nvl(trim(netb_acct1), ' ') as netb_acct1 -- 账号（1）
    ,nvl(trim(netb_acct1_optp), ' ') as netb_acct1_optp -- 账号（1）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号①不为空必送
    ,nvl(trim(netb_acct2), ' ') as netb_acct2 -- 账号（2）
    ,nvl(trim(netb_acct2_optp), ' ') as netb_acct2_optp -- 账号（2）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号②不为空必送
    ,nvl(trim(netb_acct3), ' ') as netb_acct3 -- 账号（3）
    ,nvl(trim(netb_acct3_optp), ' ') as netb_acct3_optp -- 账号（3）操作标志--1首次开通 2关联 3删除 4暂停 5恢复 账号③不为空必送
    ,nvl(trim(netbapplys), ' ') as netbapplys -- 网银服务申请--1 开通 2 注销 3 暂停 4 恢复 5新增 6取消
    ,nvl(trim(netb_add_type), ' ') as netb_add_type -- 网银服务新增类型--1全选 2单项或多项
    ,nvl(trim(netb_add_apps), ' ') as netb_add_apps -- 网银服务新增集合--1查询 2转账汇款 3发工资4费用报销5定活互转6通知存款7打印8其他
    ,nvl(trim(netb_cancel_type), ' ') as netb_cancel_type -- 网银服务取消类型--1全选 2单项或多项
    ,nvl(trim(netb_cancel_apps), ' ') as netb_cancel_apps -- 网银服务取消集合--1查询 2转账汇款3发工资4费用报销5定活互转6通知存款7打印8其他
    ,nvl(trim(peoxy_phone), ' ') as peoxy_phone -- 代理人手机
    ,nvl(trim(peoxy_email), ' ') as peoxy_email -- 代理人E-MAIL
    ,nvl(trim(acct), ' ') as acct -- 结算账号--默认为前签约账户
    ,nvl(trim(fin_quotient), ' ') as fin_quotient -- 理财 购买/赎回份数
    ,nvl(trim(fin_ori_entrust_no), ' ') as fin_ori_entrust_no -- 理财撤单 原委托流水号
    ,nvl(trim(fin_ori_entrust_date), ' ') as fin_ori_entrust_date -- 理财撤单 原委托日期
    ,nvl(trim(is_fund_contract), ' ') as is_fund_contract -- 是否操作基金(0-否 1-是)
    ,nvl(trim(fundopflag), ' ') as fundopflag -- 基金操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,nvl(trim(fin_manager_id), ' ') as fin_manager_id -- 理财经理编号
    ,nvl(trim(szsecno), ' ') as szsecno -- 深交所证券账号
    ,nvl(trim(shsecno), ' ') as shsecno -- 上交所证券账号
    ,nvl(trim(minorflag), ' ') as minorflag -- 是否成年人标志 0-否，1-是
    ,nvl(trim(fundnewacct), ' ') as fundnewacct -- 基金新银行卡号
    ,nvl(trim(fund_contract_if_succeed), ' ') as fund_contract_if_succeed -- 基金签约操作是否成功(0-失败 1-成功)
    ,nvl(trim(is_third_manage_contract), ' ') as is_third_manage_contract -- 是否三方存管签约操作
    ,nvl(trim(cobank), ' ') as cobank -- 合作行
    ,nvl(trim(ori_acct), ' ') as ori_acct -- 三方存管原结算账号
    ,nvl(trim(ori_brcode), ' ') as ori_brcode -- 三方存管原结算账号开户机构
    ,nvl(trim(bond_pass), ' ') as bond_pass -- 证券资金台账密码
    ,nvl(trim(third_manage_if_succeed), ' ') as third_manage_if_succeed -- 三方存管签约操作是否成功(0-失败 1-成功)
    ,nvl(trim(is_smart_cat_contract), ' ') as is_smart_cat_contract -- 是否招财猫|智能存款签约操作 0-否，1-是
    ,nvl(trim(smart_cat_opflag), ' ') as smart_cat_opflag -- 招财猫|智能存款签约操作类型 1.签约(开通)2. 维护(变更)3. 撤销(解约)
    ,nvl(trim(smart_cat_sign_kind), ' ') as smart_cat_sign_kind -- 招财猫|智能存款签约种类 1-灵活盈 2-储蓄定投 3-滚存储蓄 4-滚动储蓄
    ,nvl(trim(is_invest_contract), ' ') as is_invest_contract -- 是否储蓄定投签约操作 0-否，1-是
    ,nvl(trim(invest_opflag), ' ') as invest_opflag -- 储蓄定投操作类型 1-签约 2-维护 3-解约
    ,nvl(trim(invest_contract_if_succeed), ' ') as invest_contract_if_succeed -- 储蓄定投签约操作是否成功(0-失败 1-成功)
    ,nvl(trim(is_quickin_contract), ' ') as is_quickin_contract -- 是否灵活盈签约操作 0-否，1-是
    ,nvl(trim(quickin_opflag), ' ') as quickin_opflag -- 灵活盈签约操作类型 1-签约 2-维护 3-解约
    ,nvl(trim(chan_save_tp), ' ') as chan_save_tp -- 灵活盈转存类型 1-活期转双整 2-活期转通知
    ,nvl(trim(chan_save_deadline), ' ') as chan_save_deadline -- 灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年
    ,nvl(trim(chan_save_amt), 0) as chan_save_amt -- 转存起点金额
    ,nvl(trim(save_low_amt), 0) as save_low_amt -- 最低留存金额
    ,nvl(trim(chan_save_multiple), 0) as chan_save_multiple -- 转存基数倍额
    ,nvl(trim(quickin_contract_if_succeed), ' ') as quickin_contract_if_succeed -- 灵活盈签约操作是否成功(0-失败 1-成功)
    ,nvl(trim(third_ma_apply_tp), ' ') as third_ma_apply_tp -- 三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
    ,nvl(trim(third_ma_new_acct), ' ') as third_ma_new_acct -- 三方存管新账号
    ,nvl(trim(is_acctfund_contract), ' ') as is_acctfund_contract -- 基金代销账户类签约操作 0-否，1-是
    ,nvl(trim(acctfund_sign_type), ' ') as acctfund_sign_type -- 基金代销账户类签约种类 1-签约2-解约3-开户 4-销户5-基金账户登记6-基金账户取消登记7-客户信息变更8-更换银行卡号9-非交易过户
    ,nvl(trim(is_bill_send), ' ') as is_bill_send -- 对账单寄送要求 1-寄送0-不寄送
    ,nvl(trim(acctfund_ori_acct), ' ') as acctfund_ori_acct -- 交易账户变更原账号 默认前“签约账号”项
    ,nvl(trim(nontrade_chan_reason), ' ') as nontrade_chan_reason -- 非交易过户原因 1-继承2-捐赠3-司法判决
    ,nvl(trim(legal_paper_id), ' ') as legal_paper_id -- 法律文本编号
    ,nvl(trim(nontrade_to_acct), ' ') as nontrade_to_acct -- 转入方账号
    ,nvl(trim(chan_fund_code), ' ') as chan_fund_code -- 过户基金代码
    ,nvl(trim(chan_fund_sum), ' ') as chan_fund_sum -- 过户基金份额
    ,nvl(trim(is_tradefund_contract), ' ') as is_tradefund_contract -- 基金代销交易类签约操作 0-否，1-是
    ,nvl(trim(tradefund_sign_type), ' ') as tradefund_sign_type -- 基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更
    ,nvl(trim(tradefund_name), ' ') as tradefund_name -- 基金名称
    ,nvl(trim(tradefund_code), ' ') as tradefund_code -- 基金代码
    ,nvl(trim(invest_period_optp), ' ') as invest_period_optp -- 投资周期操作类型 1-开通2-修改
    ,nvl(trim(time_invest_code), ' ') as time_invest_code -- 定投编号
    ,nvl(trim(time_redeem_code), ' ') as time_redeem_code -- 定赎编号
    ,nvl(trim(third_manage_optp), ' ') as third_manage_optp -- 三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,nvl(trim(finance_deadline), ' ') as finance_deadline -- 理财期限
    ,nvl(trim(is_cat_sign), ' ') as is_cat_sign -- 是否招财猫签约 0-否，1-是
    ,nvl(trim(fund_acct), ' ') as fund_acct -- 基金签约操作账号
    ,nvl(trim(fund_acct_brcno), ' ') as fund_acct_brcno -- 基金签约账号开卡网点
    ,nvl(trim(finance_amt_ch), ' ') as finance_amt_ch -- 理财签约金额大写
    ,nvl(trim(quickin_leave_amt), ' ') as quickin_leave_amt -- 灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)
    ,nvl(trim(quickin_leave_amt_other), 0) as quickin_leave_amt_other -- 灵活盈—活期账户留存金额_其它
    ,nvl(trim(netb_apply_ac_info), ' ') as netb_apply_ac_info -- 网银申请服务账户信息(1存折或银行卡账户 2 全部账户)
    ,nvl(trim(netb_ac_backs), ' ') as netb_ac_backs -- 网银申请服务账号后六位列表(逗号隔开)
    ,nvl(trim(netb_op_choice), ' ') as netb_op_choice -- 网银修改服务选项(1登录密码 2手机动态密码)
    ,nvl(trim(netb_password_optp), ' ') as netb_password_optp -- 网银登录密码操作类型(1重置 2解锁)
    ,nvl(trim(netb_netphone_optp), ' ') as netb_netphone_optp -- 手机动态密码操作类型(1开通2注销3指定手机号4变更手机号)
    ,nvl(trim(ukey_optp), ' ') as ukey_optp -- 华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)
    ,nvl(trim(is_sms_set_phone), ' ') as is_sms_set_phone -- 短信通是否设置签约手机号 0-否，1-是
    ,nvl(trim(is_net_trans_limit_set), ' ') as is_net_trans_limit_set -- 是否网银转账限额设置 0-否，1-是
    ,nvl(trim(is_mob_trans_limit_set), ' ') as is_mob_trans_limit_set -- 手机银行是否非定向转账限额设置 0-否，1-是
    ,nvl(trim(telb_sign_type), ' ') as telb_sign_type -- 电话银行签约服务操作类型[1开通2修改3注销]
    ,nvl(trim(is_telb_appoint_phone), ' ') as is_telb_appoint_phone -- 电话银行是否指定交易电话号码 0-否，1-是
    ,nvl(trim(telb_appoint_phone_optp), ' ') as telb_appoint_phone_optp -- 交易电话号码操作类型[1无限制2指定3注销]
    ,nvl(trim(direct_trans_optp), ' ') as direct_trans_optp -- 定向转账操作类型[1开通2修改3注销]
    ,nvl(trim(is_direct_trans_ac_set), ' ') as is_direct_trans_ac_set -- 是否定向收款账户设置[0-否，1-是]
    ,nvl(trim(sms_set_phone_optp), ' ') as sms_set_phone_optp -- 短信通设置签约手机号操作类型[1-开通 3-注销]
    ,nvl(trim(tel_n_trnsf_optp), ' ') as tel_n_trnsf_optp -- 电话银行非定向转账操作类型[1-开通 2-维护 3-解约]
    ,nvl(trim(fin_new_acct), ' ') as fin_new_acct -- 理财银行卡号变更新账号
    ,nvl(trim(fin_new_open_brcno), ' ') as fin_new_open_brcno -- 理财银行卡号变更新账号所属机构
    ,nvl(trim(cust_changes), ' ') as cust_changes -- 客户信息变更内容--1经办人姓名  2证件类型 3证件号码 4经办人手机 5经办人EMAIL 6通讯地址 7邮编 8联系电话  9传真电话  客户信息变更必填
    ,nvl(trim(redeem_back_tp), ' ') as redeem_back_tp -- 智能定赎巨额赎回处理方式   0-取消1-顺延
    ,nvl(trim(changed_back_tp), ' ') as changed_back_tp -- 基金转换巨额赎回处理方式   0-取消1-顺延
    ,nvl(trim(deposit_trade_no), ' ') as deposit_trade_no -- 交易单编号
    ,nvl(trim(finance_contract_if_succeed), ' ') as finance_contract_if_succeed -- 理财签约是否成功(0-失败 1-成功)
    ,nvl(trim(clientgroup), ' ') as clientgroup -- 客户分组[a-  群客户Z- 其他客户]
    ,nvl(trim(acccycle), ' ') as acccycle -- 对账周期  1 表示按月对账 2 表示季度对账
    ,nvl(trim(check_contact), ' ') as check_contact -- 资金类业务指定查证联系人
    ,nvl(trim(isfcfnct), ' ') as isfcfnct -- 是否非柜面非同名账户限额签约(0-否,1-是)
    ,nvl(trim(daylimit), ' ') as daylimit -- 日累计限额(非柜面非同名账户限额签约)
    ,nvl(trim(txntimeslimit), ' ') as txntimeslimit -- 日笔数限额(非柜面非同名账户限额签约)
    ,nvl(trim(yearlimit), ' ') as yearlimit -- 年累计限额(非柜面非同名账户限额签约)
    ,nvl(trim(is_fcfnct_succeed), ' ') as is_fcfnct_succeed -- 非柜面非同名账户限额签约是否成功(0-失败,1-成功)
    ,nvl(trim(custom_daylimit), ' ') as custom_daylimit -- 日累计限额(非柜面非同名账户限额签约)--要素扩展收集使用
    ,nvl(trim(custom_txntimeslimit), ' ') as custom_txntimeslimit -- 日笔数限额(非柜面非同名账户限额签约)--要素扩展收集使用
    ,nvl(trim(custom_yearlimit), ' ') as custom_yearlimit -- 年累计限额(非柜面非同名账户限额签约)--要素扩展收集使用
    ,nvl(trim(ifchangecorpseal), ' ') as ifchangecorpseal -- 是否变更公章--0-否 1-是
    ,nvl(trim(taxresident), ' ') as taxresident -- 机构税收居民身份（1仅为中国税收居民；2仅为非居民；3既是中国税收居民又是其他国家（地区）税收居民；4无需声明；5空）
    ,nvl(trim(taxarea), ' ') as taxarea -- 机构税收居民国（地区）
    ,nvl(trim(taxarea2), ' ') as taxarea2 -- 机构税收居民国（地区）2
    ,nvl(trim(taxarea3), ' ') as taxarea3 -- 机构税收居民国（地区）3
    ,nvl(trim(taxnumber), ' ') as taxnumber -- 机构纳税人识别号
    ,nvl(trim(taxnumber2), ' ') as taxnumber2 -- 机构纳税人识别号2
    ,nvl(trim(taxnumber3), ' ') as taxnumber3 -- 机构纳税人识别号3
    ,nvl(trim(taxnullreason), ' ') as taxnullreason -- 机构纳税人识别号为空原因
    ,nvl(trim(taxstatement), ' ') as taxstatement -- 机构是否取得自证声明（0未取得 1取得）
    ,nvl(trim(corporgtype), ' ') as corporgtype -- 机构类别
    ,nvl(trim(taxnullreason2), ' ') as taxnullreason2 -- 机构纳税人识别号为空原因2
    ,nvl(trim(taxnullreason3), ' ') as taxnullreason3 -- 机构纳税人识别号为空原因3
    ,nvl(trim(other_reason_1), ' ') as other_reason_1 -- 
    ,nvl(trim(other_reason_2), ' ') as other_reason_2 -- 
    ,nvl(trim(other_reason_3), ' ') as other_reason_3 -- 
    ,nvl(trim(holdna3), ' ') as holdna3 -- 股东姓名3
    ,nvl(trim(controller_1_surname), ' ') as controller_1_surname -- 【控制人一】姓（英文或拼音）
    ,nvl(trim(controller_1_givenname), ' ') as controller_1_givenname -- 【控制人一】名（英文或拼音）
    ,nvl(trim(controller_1_taxresident), ' ') as controller_1_taxresident -- 【控制人一】税收居民身份
    ,nvl(trim(controller_1_birthdate), ' ') as controller_1_birthdate -- 【控制人一】出生日期
    ,nvl(trim(controller_1_taxarea_1), ' ') as controller_1_taxarea_1 -- 【控制人一】税收居民国（地区）①
    ,nvl(trim(controller_1_taxnumber_1), ' ') as controller_1_taxnumber_1 -- 【控制人一】纳税人识别号①
    ,nvl(trim(controller_1_taxnullreason_1), ' ') as controller_1_taxnullreason_1 -- 【控制人一】不能提供识别号的原因①
    ,nvl(trim(controller_1_other_reason_1), ' ') as controller_1_other_reason_1 -- 【控制人一】其它不能提供识别号的原因①
    ,nvl(trim(controller_1_taxarea_2), ' ') as controller_1_taxarea_2 -- 【控制人一】税收居民国（地区）②
    ,nvl(trim(controller_1_taxnumber_2), ' ') as controller_1_taxnumber_2 -- 【控制人一】纳税人识别号②
    ,nvl(trim(controller_1_taxnullreason_2), ' ') as controller_1_taxnullreason_2 -- 【控制人一】不能提供识别号的原因②
    ,nvl(trim(controller_1_other_reason_2), ' ') as controller_1_other_reason_2 -- 【控制人一】其它不能提供识别号的原因②
    ,nvl(trim(controller_1_taxarea_3), ' ') as controller_1_taxarea_3 -- 【控制人一】税收居民国（地区）③
    ,nvl(trim(controller_1_taxnumber_3), ' ') as controller_1_taxnumber_3 -- 【控制人一】纳税人识别号③
    ,nvl(trim(controller_1_taxnullreason_3), ' ') as controller_1_taxnullreason_3 -- 【控制人一】不能提供识别号的原因③
    ,nvl(trim(controller_1_other_reason_3), ' ') as controller_1_other_reason_3 -- 【控制人一】其它不能提供识别号的原因③
    ,nvl(trim(controller_1_type), ' ') as controller_1_type -- 【控制人一】控制人类型
    ,nvl(trim(id), ' ') as id -- 逻辑主键
    ,nvl(trim(main_flow_id), ' ') as main_flow_id -- 核心流水表ID
    ,nvl(trim(scan_seq_no), ' ') as scan_seq_no -- 扫描流水号
    ,nvl(trim(process_inst_id), ' ') as process_inst_id -- 流程实例id
    ,nvl(trim(fun_code), ' ') as fun_code -- 功能码[01-单位开户管理,02-单位信息变更,03-单位印鉴变更,04-单位开户缺件补扫,05-单位开户批扫开户许可证]
    ,nvl(trim(fr_org_code), ' ') as fr_org_code -- 前台机构编码
    ,nvl(tr_date, to_date('00010101', 'yyyymmdd')) as tr_date -- 交易日期
    ,nvl(trim(biz_code), ' ') as biz_code -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
    ,nvl(trim(voucher_code), ' ') as voucher_code -- HXYH凭证代码
    ,nvl(trim(voucher_no), ' ') as voucher_no -- 凭证号码
    ,nvl(trim(cust_id), ' ') as cust_id -- 客户编号
    ,nvl(trim(chs_acct_flag), ' ') as chs_acct_flag -- 账号自选标志[代码0014][0-随机账号1-账号自选]
    ,nvl(trim(chs_account), ' ') as chs_account -- 自选账号
    ,nvl(trim(biz_cd_flag), ' ') as biz_cd_flag -- 业务收付标志[代码0015][D-借C-贷]
    ,nvl(trim(spec_acct_type), ' ') as spec_acct_type -- 存贷款种类[代码0016][1-活期存款 2- 定期存款3-贷款]
    ,nvl(trim(rcv_pay_rang), ' ') as rcv_pay_rang -- 收支范围
    ,nvl(trim(biz_account), ' ') as biz_account -- 交易账号
    ,nvl(trim(acct_type), ' ') as acct_type -- 账号类别[A活期结算户 B-验资户 C-普通定期户 D-同业定期户]
    ,nvl(trim(acct_char), ' ') as acct_char -- 帐户性质[4-基本账户 5-临时账户 6-一般账户 7-专用账户 0-同业定期户开立]
    ,nvl(trim(acct_specie), ' ') as acct_specie -- 核准类型[0-无意义 1-自动核准 2-人工核准]
    ,nvl(trim(chk_fund_flag), ' ') as chk_fund_flag -- 验资户标志[代码0097][1-验资户2-非验资户]
    ,nvl(trim(cust_name), ' ') as cust_name -- 客户名称
    ,nvl(trim(ab_cust_name), ' ') as ab_cust_name -- 单位名简称
    ,nvl(trim(english_name), ' ') as english_name -- 英文/拼音名称
    ,nvl(trim(cst_corp_code), ' ') as cst_corp_code -- 单位企业代码
    ,nvl(trim(seal_cr_code), ' ') as seal_cr_code -- 印鉴卡编号
    ,nvl(trim(telephone), ' ') as telephone -- 电话号码
    ,nvl(trim(addr_type), ' ') as addr_type -- 地址类型[代码0050][OFF-单位地址 HOM-家庭地址 AD1-地址1 AD2-地址2 AD3-地址3 AD4-地址4]
    ,nvl(trim(postcode), ' ') as postcode -- 邮政编码
    ,nvl(trim(contact_address), ' ') as contact_address -- 联系地址
    ,nvl(trim(fin_contect_name), ' ') as fin_contect_name -- 财务联系人
    ,nvl(trim(pst_bll_address), ' ') as pst_bll_address -- 对账单地址码
    ,nvl(trim(curr_type), ' ') as curr_type -- 币别[代码T003][参考CFG_T_CURRENCY_TYPE]
    ,nvl(trim(amount), 0) as amount -- 金额
    ,nvl(trim(draw_reason), ' ') as draw_reason -- 支取依据[代码0103][0010-仅凭印0012-凭印支付密码1000-凭单1100-凭证件1010-凭单印1001-凭密1002-凭单支付密码1110-凭证印1111-凭证印密1112-凭证印支付密码1011-凭印密1012-凭印密支付密码1101-凭证密1102-凭单证支付密码]
    ,nvl(trim(sf_scp_flag), ' ') as sf_scp_flag -- 通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]
    ,nvl(trim(cal_accr_flag), ' ') as cal_accr_flag -- 记息标志[代码0034][0-否1-是]
    ,nvl(trim(pst_bll_flag), ' ') as pst_bll_flag -- 寄对账单标志[代码0037][N-不寄对帐单Y-寄对帐单]
    ,nvl(trim(cur_acct_type), ' ') as cur_acct_type -- 账本别
    ,nvl(trim(pndg_rec_methoed), ' ') as pndg_rec_methoed -- 手续费收取方式[代码0036][0-集中收取1-分散收取]
    ,nvl(trim(sf_scope), ' ') as sf_scope -- 通兑范围[代码0100][1-全国2-全省3-全市4-全国通存（对公）5-全省通存（对公）6-全市通存（对公）7-不通存（定点存）（对公）]
    ,nvl(trim(acct_status), ' ') as acct_status -- 账户状态[代码0017][0-正常（正常户及部份冻结）2-冻结（全部冻结）3-结清7-单向冻结]
    ,nvl(trim(attor_opr_code), ' ') as attor_opr_code -- 客户经理编号
    ,nvl(trim(attor_opr_name), ' ') as attor_opr_name -- 客户经理姓名
    ,nvl(trim(attor_org_code), ' ') as attor_org_code -- 客户经理所在网点
    ,nvl(trim(renw_scan_flag), ' ') as renw_scan_flag -- 补扫标志[代码0018][0-初始化1-补扫开户资料2-补扫核查清单]
    ,nvl(trim(print_count), 0) as print_count -- 打印次数
    ,nvl(acct_open_date, to_date('00010101', 'yyyymmdd')) as acct_open_date -- 开户日期
    ,nvl(trim(cf_flag), ' ') as cf_flag -- 钞汇标识[代码0011][0-钞1-汇]
    ,nvl(trim(cf_properies), ' ') as cf_properies -- 钞汇属性
    ,nvl(trim(tr_account), ' ') as tr_account -- 转账账号
    ,nvl(trim(accpt_accr_account), ' ') as accpt_accr_account -- 收息账号
    ,nvl(trim(int_rate_cert), ' ') as int_rate_cert -- 利率依据[代码0033][00-固定利率01-牌告利率02-浮动利率]
    ,nvl(trim(int_rt_operation), ' ') as int_rt_operation -- 浮动利率加减码符号位[代码0099][1-‘+’ 2-‘-’ 3-‘*’]
    ,nvl(trim(int_rt_cal_code), ' ') as int_rt_cal_code -- 浮动利率加减码
    ,nvl(trim(int_rt), 0) as int_rt -- 利率
    ,nvl(trim(fee_ratio), 0) as fee_ratio -- 费率
    ,nvl(trim(reserve_amt), 0) as reserve_amt -- 备用金额
    ,nvl(trim(inval_date), ' ') as inval_date -- 失效日期
    ,nvl(cls_acct_date, to_date('00010101', 'yyyymmdd')) as cls_acct_date -- 销户日期
    ,nvl(update_time, to_date('00010101', 'yyyymmdd')) as update_time -- 更新时间
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_pbss_flw_t_corp_reg
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_pbss_flw_t_corp_reg to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_pbss_flw_t_corp_reg',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);