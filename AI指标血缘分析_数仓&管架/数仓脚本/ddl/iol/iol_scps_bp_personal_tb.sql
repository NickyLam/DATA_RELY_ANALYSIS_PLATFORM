/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_personal_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_personal_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_personal_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_personal_tb(
    id varchar2(35) -- 逻辑主键
    ,process_inst_id varchar2(50) -- 
    ,main_flow_id varchar2(32) -- 
    ,scan_seq_no varchar2(34) -- 流水号
    ,fr_org_code varchar2(9) -- 前台机构编码
    ,tr_date date -- 客户开户日期
    ,biz_code varchar2(6) -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
    ,voucher_no varchar2(50) -- 凭证号码
    ,cust_id varchar2(16) -- 客户编号
    ,cust_name varchar2(200) -- 客户名称
    ,english_name varchar2(50) -- 客户英文名称
    ,sex varchar2(1) -- 性别
    ,cert_type varchar2(4) -- 证件类型[代码0009][A-公民身份号码B-军官证C-解放军文职干部证D-警官证E-解放军士兵证F-户口簿G-(港、澳)回乡证、通行证H-(台)通行证、其他有效旅行证I-(外国)护照J-(中国)护照K-武警文职干部证L-武警士兵证P-全国组织机构代码Q-海外客户编号R-营业执照号码X-其它有效证件Z-其它]
    ,cert_code varchar2(60) -- 证件号码
    ,crt_cert_organ varchar2(6) -- 发证机关地区代码
    ,birthday varchar2(8) -- 出生日期
    ,weblock_flag varchar2(2) -- 婚姻状况[代码0007][10-未婚 20-已婚 21-初婚 22-再婚 23-复婚 40-离婚 90-未说明的婚姻状况 30-丧偶5-已婚有子女6-已婚无子女7-其他]
    ,education varchar2(2) -- 学历
    ,occupation varchar2(5) -- 职业[代码0048][]
    ,rank varchar2(1) -- 职务
    ,income number(20,2) -- 月收入[代码0046][1-1500以下 2-1500到2000 3-2000到3000 4-3000到5000 5-5000到8000 6-8000到10000 7-10000到30000 8-30000以上]
    ,company varchar2(200) -- 工作单位名称
    ,home_address varchar2(400) -- 家庭地址
    ,fix_telephone varchar2(30) -- 固定电话
    ,office_phone varchar2(30) -- 办公电话
    ,home_phone varchar2(30) -- 家庭电话
    ,mobile varchar2(30) -- 移动电话
    ,contact_address varchar2(400) -- 联系地址
    ,postcode varchar2(6) -- 邮政编码
    ,acct_type varchar2(7) -- 交易对手账户类型
    ,spec_type varchar2(4) -- 存款账户类型
    ,sf_scp_flag varchar2(1) -- 通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]
    ,curr_type varchar2(3) -- 币种[代码T003][参考CFG_T_CURRENCY_TYPE]
    ,cf_flag varchar2(1) -- 钞汇鉴别[代码0011][0-钞1-汇]
    ,fee_drw_type varchar2(1) -- 费用支取别[代码0012][0-不收1-现金2-转账]
    ,spec_time number(2) -- 存期
    ,amount number(16,2) -- 金额
    ,biz_password varchar2(200) -- 交易密码
    ,biz_account varchar2(50) -- 交易账号
    ,open_acct_password varchar2(32) -- 开户密码
    ,tr_account varchar2(28) -- 转帐账号
    ,tr_password varchar2(32) -- 转账密码
    ,attor_opr_code varchar2(12) -- 客户经理编号
    ,attor_opr_name varchar2(30) -- 客户经理姓名
    ,attor_org_code varchar2(9) -- 客户经理所在网点
    ,level_b_pin varchar2(16) -- 前台机构编码
    ,fr_tlr_opr_no varchar2(12) -- 前台柜员号
    ,puc_check_flag varchar2(1) -- 人行核查标志[代码0039][0-不用人行核查1-人行核查]
    ,check_option varchar2(1) -- 身份核查意见
    ,check_remark varchar2(1024) -- 身份核查意见备注
    ,check_opr_code varchar2(12) -- 核查操作员
    ,puc_chk_date date -- 人行身份核查时间
    ,update_flag varchar2(1) -- 客户信息更新标志
    ,check_status varchar2(1) -- 审批状态
    ,check_fall_reason varchar2(256) -- 审批未通过原因
    ,succ_flag varchar2(1) -- 成功标志
    ,status varchar2(2) -- 流程状态
    ,home_addr_type varchar2(1) -- 住宅类型[代码0106][1-自置2-公积金贷款3-商业贷款4-租用5-其他]
    ,company_type varchar2(2) -- 单位性质[代码0107][01-国家机关02-事业单位03-国有企业04-私营，民营企业05-中外合资，合作，外资企业06-其他]
    ,obtain_opr_code varchar2(12) -- 任务获取柜员号
    ,commission varchar2(1028) -- 代办事由
    ,email varchar2(100) -- 邮箱
    ,often_site varchar2(1028) -- 经常居住地
    ,relation varchar2(100) -- 与被代理人关系
    ,nationality varchar2(15) -- 国籍
    ,pro_name varchar2(100) -- 代理人姓名(中文)
    ,pro_type varchar2(4) -- 代理人证件类型
    ,pro_fashion varchar2(100) -- 代理人联系方式
    ,is_porxy varchar2(1) -- 是否代办(0 否 1 是)
    ,accept_no varchar2(50) -- 受理号(任务号)
    ,trane_code varchar2(32) -- 交易代码
    ,idtfna_name varchar2(10) -- 证件姓名
    ,pro_cert_code varchar2(60) -- 代理人证件号码
    ,is_net_silver_contract varchar2(1) -- 是否操作网银(0-否 1-是)
    ,open_flag varchar2(1) -- 开户标志(0:无卡介质也无客户信息,1:有卡介质的2:无卡介质，但在我行有客户信息)
    ,group_flag varchar2(3) -- 分组标志(预留扩展，暂时送99)
    ,netb_passwd varchar2(32) -- 网银初始登录密码
    ,netb_left_msg varchar2(32) -- 预留信息
    ,netb_sign_mobile varchar2(30) -- 签约手机号码
    ,netb_sec_model varchar2(1) -- 安全工具型号(0-飞天  1-捷德)
    ,netb_sec_type varchar2(1) -- 安全工具类型(0-个人，1-企业)
    ,netb_sec_no varchar2(32) -- 安全工具编号
    ,netb_dynamic_opt_no varchar2(32) -- 动态口令编号
    ,netb_dynamic_card_no varchar2(32) -- 口令卡编号
    ,netb_is_transfer varchar2(32) -- 账号开通权限(0-查询 1-转账)
    ,netb_ac_limit_pertrs varchar2(32) -- 账户级单笔限额
    ,netb_ac_limit_perday varchar2(32) -- 账户级日累计限额
    ,cert_date varchar2(8) -- 证件到期日
    ,id_address varchar2(400) -- 户籍地址
    ,is_sms_contract varchar2(1) -- 是否操作短信通(0-否 1-是)
    ,is_tel_n_trnsf varchar2(1) -- 非定向转账是否开通（1-开通）
    ,is_tel_n_trnsf_default_limit varchar2(1) -- 非定向转账默认额度（1-默认额度）
    ,tel_n_trnsf_single_limit number(16,2) -- 非定向转账单笔额度
    ,tel_n_trnsf_day_limit number(16,2) -- 非定向转账单日额度
    ,is_tel_d_trnsf varchar2(1) -- 定向转账是否开通（1-开通）
    ,is_tel_d_trnsf_no_limit varchar2(1) -- 定向转账无限额度（1-无限额）
    ,tel_d_trnsf_single_limit number(16,2) -- 定向转账单笔额度
    ,tel_d_trnsf_day_limit number(16,2) -- 定向转账单日额度
    ,payee_name1 varchar2(50) -- 定向转账收款人全称1
    ,payee_accno1 varchar2(50) -- 定向转账收款人账号1
    ,payee_bank_name1 varchar2(50) -- 定向转账开户银行全称1
    ,payee_name2 varchar2(50) -- 定向转账收款人全称2
    ,payee_accno2 varchar2(50) -- 定向转账收款人账号2
    ,payee_bank_name2 varchar2(50) -- 定向转账开户银行全称2
    ,sms_notice_limit number(16,2) -- 账户变动短信通知起点金额
    ,sec_node_id varchar2(32) -- 加密结点号
    ,proxy_sex varchar2(1) -- 代理人性别
    ,proxy_idtdt date -- 证件失效日期
    ,proxy_id_address varchar2(400) -- 代理人证件地址
    ,sms_contract_if_succeed varchar2(1) -- 短信通签约是否成功(0-失败 1-成功)
    ,net_silver_contract_succeed varchar2(1) -- 网银签约是否成功(0-失败 1-成功)
    ,is_netb_default_limit varchar2(1) -- 网银签约是否默认限额(1-是)
    ,prsntg varchar2(1) -- 居民性质代码
    ,staffflag varchar2(1) -- 员工标志(默认0)
    ,custlv varchar2(2) -- 客户级别(默认00)
    ,risklv varchar2(1) -- 客户风险承受能力评估等级（1-保守型 2-谨慎型 3-稳健型 4-进取型 5-激进型）
    ,wkutad varchar2(400) -- 工作单位地址
    ,roleid varchar2(10) -- 职称等级
    ,worktx varchar2(124) -- 其他职业
    ,csec_node_id varchar2(32) -- 转加密结点号
    ,netb_csec_passwd varchar2(32) -- 转加密网银初始密码
    ,transfer_channel varchar2(11) -- 转账渠道（1-手机银行定向转账2-电话银行定向转账）
    ,mobile_ac_limit_pertrs number(16,2) -- 手机银行账户级单笔限额
    ,mobile_ac_limit_perday number(16,2) -- 手机银行账户级日累计限额
    ,is_mobile_default_limit varchar2(1) -- 手机银行是否默认限额(1-是)
    ,fax varchar2(30) -- 传真
    ,area_code varchar2(10) -- 地区代码
    ,truth_flag varchar2(1) -- 实名标志
    ,trnamt number(16,2) -- 转存金额
    ,voucherty varchar2(10) -- 凭证类型    738-华兴卡 741-借记芯片卡
    ,id_check_result varchar2(2) -- 身份证联网核查结果[00-公民身份证号码与姓名一致，且存在照片01-公民身份证号码与姓名一致，但不存在照片02-公民身份号码存在，但与姓名不匹配03-公民身份号码不存在04-其他错误]
    ,mobile_open_status varchar2(1) -- 移动业务审批状态 0处理中 1审批通过 2审批不通过(开卡、网银签约、短信通签约)
    ,account_update_flag varchar2(1) -- 账户更新标志[0：删除 1：更新 2：增加 为空表示不操作账户]
    ,submit_status varchar2(2) -- 移动综合签约提交状态[提交锁定字段 0：未处理1：处理中2：提交成功]
    ,netb_biz_type varchar2(1) -- 网银签约业务类型[0：新增1：变更]
    ,often_site_eq_id_addr varchar2(1) -- 经常居住地同身份证件地址（0否 1是）
    ,net_ukey varchar2(1) -- 开通华兴U盾（0否 1是2关联）
    ,card_type varchar2(20) -- 卡产品
    ,card_rank varchar2(1) -- 卡等级
    ,is_finance_contract varchar2(1) -- 是否操作理财(0-否 1-是)
    ,sendfreq varchar2(1) -- 对账单发送频率[0-有交易发生寄送1-不寄送2-按月3-按季4-半年5-一年]
    ,sendmode varchar2(8) -- 对账单寄送方式(共8个字符，每个字符代表一种交易手段，其含义为：第1位：邮寄第2位：传真第3位：E-mail第4位：短消息第5~8位：保留。每位字符取1表示采用此种手段，取0表示不使用)
    ,risklevel varchar2(1) -- 理财产品风险等级（0-未评定 1-低风险2-较低风险3-中风险4-较高风险5-高风险）
    ,clientgroup varchar2(1) -- 客户分组[a-	群客户Z- 其他客户]
    ,chnlflag varchar2(1) -- 高风险产品柜台以外渠道允许购买标志(0-不允许 1-允许 默认0)
    ,finance_contract_succeed varchar2(1) -- 理财签约是否成功(0-失败 1-成功)
    ,finance_acctno varchar2(28) -- 理财签约账号
    ,open_brcno varchar2(6) -- 开卡机构
    ,cust_mgrno varchar2(32) -- 客户经理代码
    ,sms_cust_sign varchar2(1) -- 短信通客户是否已签约(0:未签约1:已签约)
    ,fee_acct_no varchar2(28) -- 扣费账号
    ,fee_acct_brcno varchar2(3) -- 扣费账号分行号
    ,fee_acct_nodeno varchar2(6) -- 扣费账号行所号
    ,contact_phone varchar2(30) -- 联系手机号码
    ,attbrn varchar2(9) -- 业务归属机构
    ,new_password varchar2(200) -- 新交易密码
    ,new_account varchar2(50) -- 新账号
    ,chactg varchar2(20) -- 更换类型
    ,stpytg varchar2(1) -- 挂失类型
    ,rplsfs varchar2(2) -- 挂失形式
    ,submit_state varchar2(2) -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,netopflag varchar2(1) -- 网银操作类型[0-开通1-维护 2-解约（注销）3-暂停4-恢复5开通以下服务]
    ,smsopflag varchar2(1) -- 短信通操作类型[0-签约 1-解约 2-短信通手机号码新增 3-短信通手机号码修改 4-短信通手机号码取消]
    ,finopflag varchar2(1) -- 理财操作类型[0-签约  1-解约 2-更换账户  3-银行帐号登记取消]
    ,delukey varchar2(1) -- 是否删除Ukey(0-否 1-是)
    ,bgnamt number(16,2) -- 短信通知起点金额
    ,trtmrs varchar2(2) -- 核实结果  01未核实，02真实
    ,loss_date varchar2(20) -- 挂失日期(yyyymmdd)
    ,loss_reg_no varchar2(30) -- 挂失登记号
    ,undays varchar2(1) -- 挂失天数    临时挂失5天，正式挂失7天
    ,payway varchar2(1) -- 支取方式 S-凭印鉴支取 P-凭密码支取 W-无密码无印鉴支取 B-凭印鉴和密码支取 O-凭证件支取 R-支付密码器和印鉴
    ,is_fund_contract varchar2(1) -- 是否操作基金(0-否 1-是)
    ,fundopflag varchar2(1) -- 基金操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,fin_manager_id varchar2(10) -- 理财经理编号
    ,szsecno varchar2(30) -- 深交所证券账号
    ,shsecno varchar2(30) -- 上交所证券账号
    ,minorflag varchar2(1) -- 是否成年人标志 1-否，0-是
    ,fundnewacct varchar2(32) -- 基金新银行卡号
    ,fund_contract_if_succeed varchar2(1) -- 基金签约操作是否成功(0-失败 1-成功)
    ,is_third_manage_contract varchar2(1) -- 是否三方存管签约操作
    ,cobank varchar2(32) -- 合作行
    ,ori_acct varchar2(32) -- 三方存管原结算账号
    ,ori_brcode varchar2(10) -- 三方存管原结算账号开户机构
    ,bond_acct varchar2(30) -- 证券资金台账账号
    ,bond_pass varchar2(32) -- 证券资金台账密码
    ,bond_code varchar2(32) -- 券商代码
    ,bond_name varchar2(100) -- 券商名称
    ,third_manage_if_succeed varchar2(1) -- 三方存管签约操作是否成功(0-失败 1-成功)
    ,is_invest_contract varchar2(1) -- 是否储蓄定投签约操作 0-否，1-是
    ,invest_opflag varchar2(1) -- 储蓄定投操作类型 1-签约 2-维护 3-解约
    ,invest_contract_if_succeed varchar2(1) -- 储蓄定投签约操作是否成功(0-失败 1-成功)
    ,is_quickin_contract varchar2(1) -- 是否灵活盈签约操作 0-否，1-是
    ,quickin_opflag varchar2(1) -- 灵活盈签约操作类型 1-签约 2-维护 3-解约
    ,chan_save_tp varchar2(15) -- 转存类型 1-活期转双整 2-活期转通知
    ,chan_save_deadline varchar2(5) -- 灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年
    ,chan_save_amt number(18,2) -- 转存起点金额
    ,save_low_amt number(18,2) -- 最低留存金额
    ,quickin_contract_if_succeed varchar2(1) -- 灵活盈签约操作是否成功(0-失败 1-成功)
    ,sign_type varchar2(20) -- 签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5
    ,third_ma_apply_tp varchar2(1) -- 三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
    ,third_ma_new_acct varchar2(32) -- 三方存管新账号
    ,is_acctfund_contract varchar2(1) -- 基金代销账户类签约操作 0-否，1-是
    ,acctfund_sign_type varchar2(2) -- 基金代销账户类签约种类 1-签约2-解约3-维护
    ,is_bill_send varchar2(1) -- 对账单寄送要求 1-寄送0-不寄送
    ,acctfund_ori_acct varchar2(32) -- 交易账户变更原账号 默认前“签约账号”项
    ,is_tradefund_contract varchar2(1) -- 基金代销交易类签约操作 0-否，1-是
    ,tradefund_sign_type varchar2(20) -- 基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更
    ,tradefund_name varchar2(100) -- 基金名称
    ,tradefund_code varchar2(32) -- 基金代码
    ,savings_invest_optp varchar2(1) -- 储蓄定投操作类型 1-终止 2-暂停 3-恢复
    ,time_invest_code varchar2(32) -- 定投编号
    ,third_manage_optp varchar2(1) -- 三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,fund_acct varchar2(30) -- 基金签约操作账号
    ,fund_acct_brcno varchar2(10) -- 基金签约账号开卡网点
    ,quickin_leave_amt varchar2(1) -- 灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)
    ,quickin_leave_amt_other number(16,2) -- 灵活盈—活期账户留存金额_其它
    ,netb_op_choice varchar2(3) -- 网银修改服务选项(1登录密码 2手机动态密码)
    ,netb_password_optp varchar2(1) -- 网银登录密码操作类型(1重置 2解锁)
    ,netb_netphone_optp varchar2(1) -- 手机动态密码操作类型(0-不开通1开通2注销3指定手机号4变更手机号5关联)
    ,ukey_optp varchar2(1) -- 华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)
    ,is_sms_set_phone varchar2(1) -- 短信通是否设置签约手机号 0-否，1-是
    ,is_net_trans_limit_set varchar2(1) -- 是否网银转账限额设置 0-否，1-是
    ,is_mob_trans_limit_set varchar2(1) -- 手机银行是否非定向转账限额设置 0-否，1-是
    ,direct_trans_optp varchar2(1) -- 定向转账操作类型[1开通2修改3注销]
    ,is_direct_trans_ac_set varchar2(1) -- 是否定向收款账户设置[0-否，1-是]
    ,sms_set_phone_optp varchar2(1) -- 短信通设置签约手机号操作类型[1-开通 3-注销]
    ,fin_new_acct varchar2(30) -- 理财银行卡号变更新账号
    ,fin_new_open_brcno varchar2(10) -- 理财银行卡号变更新账号所属机构
    ,quickin_pass varchar2(20) -- 灵活盈交易密码(带账号转加密)
    ,cust_changes varchar2(30) -- 客户信息变更内容1.通讯地址2.邮政编码3.联系电话4.手机5.EMAIL
    ,tlr_mobile varchar2(30) -- 前台柜员手机号码
    ,deposit_trade_no varchar2(30) -- 交易单编号
    ,acct_type_m varchar2(2) -- 账号类型:0: 人民币个人非结算户1: 人民币个人结算户A: 外汇结算账户B: 乙种储蓄存款账户C: 丙种储蓄存款账户
    ,dsp_type varchar2(5) -- 储种:S01储蓄活期S02	储蓄双整S03	零存整取S04	整存零取S05	存本取息S06	定活两便S07	储蓄通知S08	教育储蓄S18:财富宝
    ,dsp_period varchar2(6) -- 存期:203-三个月、206-六个月、301-一年、302-二年、303-三年、305-五年、000-活期、101-一天、107-七天 、203-三个月、206-六个月、301-一年
    ,dsp_flag varchar2(1) -- 转存标识:1:自动转存0:非自动转存
    ,tran_type varchar2(3) -- 交易类型:CO-现开TO-转开
    ,to_acct_no varchar2(40) -- 转出账号
    ,to_acct_name varchar2(80) -- 转出账号名称
    ,to_pswd varchar2(40) -- 转出账号密码
    ,to_idtp varchar2(4) -- 转出证件类型:A:身份证,B:外国公民护照,C:户口薄,D:港澳居民通行证,E:还乡证,F:边民出入境通行证,G:军官证,H:士兵证,I:军事院校学员证,J:军队离休干部荣誉证,K:军官退休证,L:军人文职干部退休证,P:其他,Q:武警身份证,R:台湾居民通行证,S:中国公民护照,U:临时身份证
    ,to_idno varchar2(60) -- 转出证件号码
    ,to_dwfs varchar2(1) -- 转出支取方式：A:密码 D:印鉴 E:证件
    ,prcsna varchar2(30) -- 交易类型
    ,nwinrt number(15,8) -- 利率
    ,matudt varchar2(10) -- 到期日
    ,valuedt varchar2(10) -- 起息日
    ,proxy_flag varchar2(1) -- 代办人类型（0-否 1-监护代理 2-普通代理）
    ,quickin_type varchar2(1) -- 灵活盈-储种（1-三个月 2-六个月 3-一年 4-二年 5-三年 6-五年 7-不约定存期 8-七天通知）
    ,acctlv varchar2(10) -- 账户分类
    ,is_card varchar2(1) -- 是否有卡
    ,regoresult varchar2(2) -- 1识别失败，0识别成功
    ,similarity varchar2(10) -- 0%~100%，>=80%为认定为本人
    ,issetnewpwd number(1) -- 是否设置新密码
    ,isfcfnoper varchar2(1) -- 是否操作非柜面非同名限额签约(0-否,1-是)
    ,isfcfntype varchar2(1) -- 非柜面非同名账户限额签约操作类型(0-签约 1-维护)
    ,isfcfnct varchar2(1) -- 是否非柜面非同名账户限额签约(0-否,1-是)
    ,daylimit varchar2(32) -- 日累计限额(非柜面非同名账户限额签约)
    ,txntimeslimit varchar2(32) -- 日笔数限额(非柜面非同名账户限额签约)
    ,yearlimit varchar2(32) -- 年累计限额(非柜面非同名账户限额签约)
    ,is_fcfnct_succeed varchar2(1) -- 非柜面非同名账户限额签约是否成功(0-失败,1-成功)
    ,agreementid varchar2(32) -- ECIF签约协议号
    ,custom_daylimit varchar2(32) -- 自定义-日累计限额(万元)
    ,custom_txntimeslimit varchar2(32) -- 自定义-日累计笔数
    ,custom_yearlimit varchar2(32) -- 自定义-年累计限额(万元)
    ,pro_nationality varchar2(3) -- 代理人国籍
    ,mobile_type varchar2(1) -- 号码性质 0--本人1--监护人
    ,outflg varchar2(2) -- 外出标注-0，默认网点0：网点凭证 1：外出凭证
    ,netstate varchar2(1) -- 网银密码重置--状态默认送0
    ,logonpwnew varchar2(300) -- 网银密码重置--新登陆密码
    ,netreset varchar2(1) -- 是否网银密码重置
    ,relativetp varchar2(4) -- 监护人/亲属证件类型
    ,relativena varchar2(40) -- 监护人/亲属姓名
    ,relativeno varchar2(20) -- 监护人/亲属号码
    ,taxresident varchar2(1) -- 税收居民身份（1仅为中国税收居民2仅为非居民3既是中国税收居民又是其他国家（地区）税收居民4无需声明5空）
    ,birthplace varchar2(200) -- 纳税人出生地（中英文字符）
    ,taxarea varchar2(100) -- 税收居民国（地区）
    ,taxnumber varchar2(100) -- 纳税人识别号
    ,taxarea2 varchar2(100) -- 纳税居民国家（地区）2（发送报文时整合在TAXAREA）
    ,taxarea3 varchar2(100) -- 纳税居民国家（地区）3（发送报文时整合在TAXAREA）
    ,taxnumber2 varchar2(100) -- 纳税人识别号2（发送报文时整合在TAXNUMBER）
    ,taxnumber3 varchar2(100) -- 纳税人识别号3（发送报文时整合在TAXNUMBER）
    ,taxnullreason varchar2(65) -- 纳税人识别号为空原因
    ,taxstatement varchar2(1) -- 是否取得自证声明（0-未取得自证声明1-取得自证声明）
    ,customersurname varchar2(40) -- 客户_姓（字母）
    ,customergivenname varchar2(40) -- 客户_名（字母）
    ,taxnullreason2 varchar2(65) -- 纳税人识别号为空原因2
    ,taxnullreason3 varchar2(65) -- 纳税人识别号为空原因3
    ,boundaccno varchar2(28) -- 绑定账号
    ,boundbank varchar2(80) -- 绑定账号开户行
    ,checkcase varchar2(100) -- 落地审核原因
    ,ocridtdt date -- 证件生效日期
    ,yflag varchar2(1) -- 手机盾标志 Y:为是手机盾，N:为不是手机盾
    ,phoneoperate varchar2(1) -- 手机盾操作类型0：开通
    ,camp_emp_id varchar2(20) -- 营销工号
    ,notemessagephone1 varchar2(11) -- 短信通签约号码1
    ,notemessagephone2 varchar2(11) -- 短信通签约号码2
    ,notemessagephone3 varchar2(11) -- 短信通签约号码3
    ,notemessagephone4 varchar2(11) -- 短信通签约号码4
    ,notemessagephone5 varchar2(11) -- 短信通签约号码5
    ,isagtsch varchar2(1) -- 是否个人扣款协议签约(0-否,1-是)
    ,proxy_idtdt_sl varchar2(1) -- 是否云闪付绑定签约
    ,is_flashpay_contract varchar2(1) -- 云闪付绑定签约是否成功  0-失败 1-成功
    ,flashpay_contract_if_succeed varchar2(1) -- 
    ,local_ip varchar2(30) -- 开户IP
    ,local_mac varchar2(50) -- 开户MAC
    ,uuid varchar2(50) -- UUID
    ,ukey_modify_if_succeed varchar2(1) -- U盾管理状态
    ,is_send_message varchar2(1) -- 是否发送营销短信
    ,phonepay_contract_if_succeed varchar2(1) -- 手机转账签约是否成功(0-失败 1-成功)
    ,is_phonepay_contract varchar2(1) -- 是否手机转账签约(0-否 1-是)
    ,regedittype varchar2(3) -- 登记注册类型
    ,sco varchar2(3) -- 
    ,is_phonepay_contract1 varchar2(1) -- 是否手机转账签约(0-否 1-是)
    ,phonepay_contract_if_succeed1 varchar2(1) -- 手机转账签约是否成功(0-失败 1-成功)
    ,regedittype1 varchar2(3) -- 登记注册类型
    ,limit_oper_type varchar2(2) -- 非柜面签约
    ,limit_oper_channel varchar2(120) -- 
    ,day_transfer_count varchar2(120) -- 非柜面签约-日总笔数
    ,day_transfer_amount varchar2(120) -- 非柜面签约-日总限额
    ,year_transfer_count varchar2(120) -- 非柜面签约-年总笔数
    ,year_transfer_amount varchar2(120) -- 非柜面签约-年总限额
    ,limit_oper_result varchar2(1) -- 
    ,tally_state varchar2(1) -- 记账状态 0 未记账 1 记账成功 2 记账失败
    ,agt_num varchar2(30) -- 协议号
    ,dspbgndt varchar2(4) -- 转存起始日期
    ,dspenddt varchar2(4) -- 转存截止日期
    ,dsptyper varchar2(4) -- 转存类型 1 转存双整 2 转存通知
    ,invest_account varchar2(18) -- 储蓄定投签约账户
    ,invest_trnamt number(18,2) -- 转存金额
    ,prd_id varchar2(12) -- 产品编号
    ,quickin_agreement_id varchar2(4) -- 灵活盈协议编号
    ,quickin_agreement_status varchar2(4) -- 灵活盈协议状态
    ,quickin_agreement_type varchar2(4) -- 灵活盈协议类型
    ,quickin_fin_fixed_amt number(18,2) -- 灵活盈理财固定金额
    ,quickin_int_min_amt number(18,2) -- 灵活盈最小起存金额
    ,quickin_remain_amt number(18,2) -- 灵活盈协议留存金额
    ,quickin_start_amt number(18,2) -- 灵活盈起始金额
    ,quickin_transfer_day varchar2(4) -- 划转日
    ,quickin_transfer_freq varchar2(10) -- 灵活盈划转频率
    ,redep_freq varchar2(4) -- 转存频率
    ,renew_corp varchar2(10) -- 转存单位
    ,rpdsp varchar2(4) -- 转存周期 Y-年 Q-季 M-月 W-周 D-天
    ,sub_acct_num varchar2(34) -- 子账号
    ,sum_sub_num varchar2(32) -- 汇总子户号
    ,biz_type varchar2(4) -- 业务种类
    ,biz_dt varchar2(20) -- 交易日期（yyyy-MM-dd hh:mm:ss）
    ,finance_card_type varchar2(4) -- 理财账户类型
    ,fin_new_acct_crspd_pty_id varchar2(18) -- 新账号对应客户号
    ,custchnlid varchar2(8) -- 开通渠道
    ,riskmonths varchar2(8) -- 风险有效期月数
    ,rskcd varchar2(8) -- 风险等级代码
    ,oper_flag varchar2(2) -- 1 客户级 2账户级
    ,third_chg_card_id varchar2(4) -- 三方存管换卡标识
    ,third_open_org_id varchar2(16) -- 三方存管开户机构
    ,usb_key_cert_id varchar2(200) -- USBKey证书编号
    ,old_cert_key_id varchar2(200) -- 旧证书KEYID
    ,safe_instr_model varchar2(2) -- 安全工具型号(0：飞天1：捷德)
    ,u_brch_num varchar2(50) -- U盾网点号
    ,u_oper_typ varchar2(2) -- U盾操作类型（2：注销 3：损坏更换 4：挂失更换 5：发放）
    ,wthr_out varchar2(2) -- 是否出库 默认Y Y：是 N：否
    ,lost_operate_method varchar2(50) -- 挂失操作方式，比如书面挂失、口头挂失UV-口头解挂 UW-正式解挂 VL-口挂 WL-书挂
    ,lost_no varchar2(50) -- 账户/凭证/结算卡挂失号码
    ,acct_name varchar2(100) -- 账户名称
    ,loss_id varchar2(100) -- 挂失编号
    ,acct_seq_no varchar2(10) -- 账户序列号
    ,acct_password varchar2(200) -- 账户密码
    ,voucher_change_type varchar2(2) -- 凭证更换类型，比如挂失补发、损坏更换等，不同的更换类型会对应不同的处理流程 01-挂失补发 02-凭证更换 03-损坏更换 04-同号换卡领卡/记名卡领卡 05-单位存单置换 06-单位存单收回如果补开、凭证更换必传
    ,new_vchr_typ varchar2(10) -- 新凭证类型
    ,new_vchr_num varchar2(50) -- 新凭证号码
    ,voucher_change_reason varchar2(500) -- 更换原因
    ,td_inout_operate_type varchar2(2) -- 存单移入必传 定期账户转入转出操作类型 01-转入 02-互转 03-转出
    ,in_base_acct_no varchar2(50) -- 移入账号
    ,in_prod_type varchar2(20) -- 转入账户产品类型
    ,enter_acct_ccy varchar2(3) -- 转入账户币种
    ,target_acct_class varchar2(3) -- 目标账户类别（一二三类户），即账户升级后的账户类别，满足人行对于电子账户的管理办法1-一类账户 2-二类账户 3-三类账户
    ,password_operate_type varchar2(2) -- 账户密码操作类型 账户密码操作类型01-新建 02-重置 03-修改 04-解锁 05-校验 06-激活 07-凭证解挂场景密码重置 08-弱密码校验
    ,password_type varchar2(2) -- 密码类型，目前核心只支持WD，接口未上送则默认为WDWD-支取密码 QY-查询密码 MA-账户管理密码
    ,password_old varchar2(200) -- 旧密码
    ,iss_country varchar2(3) -- 发证国家
    ,password_effect_date varchar2(20) -- 密码生效日期
    ,lost_reason varchar2(200) -- 挂失原因
    ,res_flag varchar2(2) -- 标识挂失账户是N进行账户止付,挂失时必输，解挂时不需要输入Y-是 N-不是
    ,pause_post varchar2(200) -- 暂停附言
    ,channel varchar2(6) -- 渠道
    ,ntw_ceph_bank_pause_type varchar2(2) -- 网银手机银行管理 业务类型 01：个人动态密码管理 02：解锁登录密码 03：网银/手机银行暂停/恢复 04：登录密码和用户状态重置 05：客户手机盾信息维护 06：账户暂停/恢复
    ,ntw_ceph_bank_pause_pwd_status varchar2(2) -- 网银手机银行管理 密码状态：0:正常 7：重置网银密码 8：重置交易密码 9 : 柜面开户重置密码
    ,tfr_encry_ind varchar2(2) -- 转加密标识  1:数字加字母组合 0:纯数字(柜面调用)
    ,cfm_new_logon_pwd varchar2(50) -- 确认新登录密码
    ,pwd_keyb_node_id varchar2(50) -- 密码键盘节点ID
    ,safe_ceph_num varchar2(12) -- 安全手机号
    ,dynamic_password_status varchar2(2) -- 个人动态密码状态 ： 0---开 1---关
    ,pause_status varchar2(2) -- 网银/手机银行暂停/恢复 状态 0-正常 1-永久停止 2-临时暂停
    ,dynamic_password_ind_id varchar2(2) -- 个人动态密码标识编号 1：查询 2：新增 3：修改 4: 删除
    ,clous_shield_ind_id varchar2(2) -- 华兴云盾标识编号 1：设置密码 0：重置密码
    ,deft_safe_instr varchar2(2) -- 默认安全工具 1：华兴U盾 2：手机短信密码
    ,indv_act_status varchar2(2) -- 个人账户状态
    ,acct_pause_rsns varchar2(500) -- 账户暂停原因
    ,ntw_ceph_bank_pause_resu_status varchar2(2) -- 网银/手机银行暂停/恢复状态 0-正常 1-永久停止 2-临时暂停
    ,pause_with_resu_oper_typ varchar2(2) -- 暂停/恢复操作类型 0-网银 1-手机银行 2-网银手机银行
    ,temp_pause_start_tm varchar2(20) -- 临时暂停开始时间，格式为yyyyMMddHHmmss
    ,temp_pause_cncl_tm varchar2(20) -- 临时暂停结束时间，格式为yyyyMMddHHmmss
    ,ceph_cs_oper_typ varchar2(2) -- 手机盾信息操作类型 开通：0 停用：1 启用：2 注销：4
    ,cs_ord_nbr varchar2(50) -- 云盾序号
    ,open_br_node_num varchar2(32) -- 开通网点号
    ,key_name varchar2(200) -- 密钥名称
    ,total_cnt varchar2(10) -- 网银签约总笔数
    ,reg_typ varchar2(6) -- 手机号码支付协议注册类型 DFLT 默认账户 NDFT 非默认账户
    ,narrative1 varchar2(512) -- 备注
    ,prest_flg varchar2(1) -- 赠送标志 0-正常开通 1-赠送开通
    ,prest_mon varchar2(2) -- 赠送月份 如果是赠送服务（赠送标志为1），则填入赠送的月份数。没有此信息填空或“00”
    ,vip_flg varchar2(1) -- VIP标志 0-非VIP服务， 1-VIP服务，（默认填0，如果操作员选择了VIP服务标志，则填1），VIP针对客户而言。
    ,chrg_pkg_typ varchar2(2) -- 收费套餐类型 01包月/ 12包年。
    ,chrg_mode varchar2(1) -- 收费模式 1-按账户数收费 2-按服务数收费 3-按短信条数收费 4-按定额收费
    ,chrg_amt varchar2(20) -- 收费金额 请按字符串格式传输，如”RATE”:”0.56987” 当收费模式为定额收费时填写
    ,disct number(16,2) -- 折扣 客户收费折扣
    ,disct_mon varchar2(2) -- 折扣月份 当存在折扣时，填写折扣有效月份，没有此信息则填空或00
    ,acct_purp varchar2(10) -- 账户用途
    ,acct_attr varchar2(10) -- 账户属性
    ,agtsch_prd_id varchar2(12) -- 个人扣款协议-产品编号
    ,agtsch_prd_type varchar2(2) -- 个人扣款协议  C-签约U-维护D-解约
    ,payer_acct varchar2(50) -- 付款人账号
    ,payer_acct_typ varchar2(30) -- 付款人账户类型
    ,payer_act_nm varchar2(128) -- 付款人账户户名
    ,payer_cert_typ varchar2(4) -- 付款人证件类型
    ,payer_cert_num varchar2(60) -- 付款人证件号
    ,payer_ceph_num varchar2(11) -- 付款人手机号
    ,payer_bank varchar2(14) -- 付款人开户行行号
    ,rcver_acct_typ varchar2(30) -- 收款人账户类型
    ,payee_base_acct_no varchar2(50) -- 收款人账号
    ,rcver_act_nm varchar2(128) -- 收款人账户户名
    ,chn_num varchar2(10) -- 渠道号
    ,sign_dtl varchar2(256) -- 签约明细
    ,dsp_trnamt varchar2(2) -- 转存周期 Y    年 Q    季 M    月 W    周 D    天
    ,redep_start_dt date -- 转存起始日期
    ,redep_end_dt date -- 转存截止日期
    ,pause_flg varchar2(2) -- 暂停标志 0 否 1 是
    ,node_num varchar2(20) -- 节点号
    ,third_chg_sign_prd varchar2(20) -- 签约产品 SV014银银合作代理第三方存管协议
    ,agt_typ varchar2(5) -- 协议类型CLD-存立得 DC-大额存单 DLS-贷利省 HQB-活期宝 JDL-加多利 KDT-卡贷通 KYD-卡易贷 PCP-资金池 WDL-稳得利 XDB-协定宝 XDCK-协定存款产品 XDL-先得利 YBWL-一本万利 YCD-英才贷 YDT-易贷通 YHT-一户通 ZHY-周享赢 ZXY-坐享其盈 ZZB-至尊宝 LOA-贷款 ODF-法人透支协议 FIN-卡理财协议 SMS-短信 PKG-费用套餐 FEE-暂不收费 PCD-周期性强制扣划 ACC-协定存款协议 SWP-账户清扫协议 ID-智能存款协议 SL-金额补足协议 REC-回单签约 ES-电票签约 YD-约定 NTE-活期智能存款 PAS-隐私账户签约 TXY1-同兴赢活期签约 TXY2-跨境资金融入签约 CXDT-储蓄定投 TBCK-跳板存款 LHY-灵活盈 P2P-P2P协议 JZG-建筑港 ZCG-资产存管 ZQS-资金清算 LYE-财政零余额
    ,agt_id varchar2(50) -- 协议编号
    ,agt_status_cd varchar2(2) -- 协议状态 普通协议使用，可应用于大部分场景，贷款模块用于资产证券化合同状态A-生效 E-失效 YB-赎回 YS-发行 YP-已封包 NP-未封包 NS-未发行 YC-已撤包
    ,st_dt date -- 开始日期
    ,end_dt_ora date -- 结束日期
    ,sign_prod_type varchar2(20) -- 签约产品类型
    ,remain_amt varchar2(20) -- 协议留存金额 请按字符串格式传输，如”RATE”:”0.56987” 协议留存金额
    ,start_amt varchar2(20) -- 起始金额 请按字符串格式传输，如”RATE”:”0.56987” 起始金额
    ,transfer_freq_type varchar2(1) -- 划转频率类型 Y-年 Q-季 M-月 W-周 D-日
    ,acct_movt_date date -- 转存交易日期
    ,peri varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位 Y-年 Q-季 M-月 W-周 D-日
    ,acct_exec varchar2(30) -- 银行客户经理
    ,transfer_end_date date -- 转存结束日期
    ,transfer_day varchar2(2) -- 划转日
    ,transfer_freq varchar2(5) -- 划转频率
    ,fin_fixed_amt varchar2(20) -- 理财固定金额 请按字符串格式传输，如”RATE”:”0.56987”
    ,min_depo_amt varchar2(20) -- 最小起存金额 请按字符串格式传输，如”RATE”:”0.56987” 最小起存金额
    ,opt_type varchar2(2) -- 资管信托代销协议操作类型 01签约 02解约 03维护
    ,matn_oper_typ varchar2(2) -- 维护操作类型 0-客户信息维护 1-客户经理代码维护
    ,actl_benef varchar2(2) -- 实际受益人 0-本人（默认） 1-他人
    ,wthr_exist_actl_ctrl_rela varchar2(2) -- 是否存在实际控制关系 0-否（默认） 1-是
    ,wthr_is_np_integrity_rec varchar2(2) -- 是否有不良诚信记录 0-否（默认） 1-是
    ,ori_pty_mgr_cd varchar2(20) -- 原客户经理代码
    ,new_pty_mgr_cd varchar2(20) -- 新客户经理代码
    ,pty_mgr_adj_flg varchar2(2) -- 客户经理调整标志 0－全部（将原客户经理替换成新客经理） 1－调整客户所属客户经理代码 2－理财账号客户经理代码 3－按流水客户经理 4－调整定投客户经理代码 5－调整定赎客户经理代码 8－调整客户对应所有客户经理
    ,spec_seq_num varchar2(40) -- 指定流水号
    ,enro_ceph_num varchar2(13) -- 注册手机号
    ,acct_typ varchar2(3) -- 账户类型 01 - 为Ⅰ类户（非信用卡） 02 - 为Ⅱ类户 03 - 为Ⅲ类户 04-准贷记卡 05-借贷合一卡 不填-信用卡
    ,zone_num varchar2(20) -- 地区码 建议需求方至少定位到省市、直辖市级地区区位。默认为0000，长度为4 位
    ,scene_num varchar2(20) -- 云闪付场景码
    ,card_prd_id varchar2(20) -- 卡产品编号
    ,txn_equip_info varchar2(200) -- 交易设备信息
    ,put_new_fld varchar2(200) -- 拉新字段
    ,cvn_num varchar2(20) -- CVN码
    ,valid_dt date -- 有效期
    ,bcs_res_ceph_num_flg varchar2(1) -- 核心预留手机号标志 1代表是核心预留手机号 0代表非核心预留手机号
    ,short_lett_srv_type varchar2(100) -- 短信服务类 短信服务类，以逗号分隔（A,B）
    ,ceph_num_app_scope varchar2(1) -- 手机号码应用范围 1-只修改该账号下对应的手机号码 2-修改客户所有账号对应的手机号码，填1时必须填写签约账号
    ,old_ceph_num varchar2(13) -- 旧手机号码
    ,new_ceph_num varchar2(13) -- 新手机号码
    ,ceph_num_qty varchar2(2) -- 手机号码个数
    ,direct_sign_matn_flg varchar2(2) -- 定向转账签约维护标志 0-解约, 1-更新, 2-签约
    ,direct_sign_typ varchar2(2) -- 定向转账签约类型 0-综合柜面, 1-流程银行
    ,ghb_out_ind varchar2(2) -- 行内外标识 0-行内 1-行外
    ,bank_id varchar2(12) -- 银行编号
    ,bank_name varchar2(256) -- 银行名称
    ,provin_cd varchar2(10) -- 省份代码
    ,city_cd varchar2(10) -- 城市代码
    ,rcv_open_brch_id varchar2(12) -- 收款方开户网点编号
    ,rcv_open_brch_name varchar2(256) -- 收款方开户网点名称
    ,rcver_ceph_num varchar2(11) -- 收款人手机号码
    ,recv_acct_upda_flg varchar2(1) -- 收款账户更新标志 收款账户更新标志0：删除 1：更新,2：增加（SIGNUPDATEFLAG=0时，系统默认0，SIGNUPDATEFLAG=2时，系统默认为2）
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.scps_bp_personal_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_personal_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_personal_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_personal_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_personal_tb is '登记个人理财卡、定期存折存单交易信息';
comment on column ${iol_schema}.scps_bp_personal_tb.id is '逻辑主键';
comment on column ${iol_schema}.scps_bp_personal_tb.process_inst_id is '';
comment on column ${iol_schema}.scps_bp_personal_tb.main_flow_id is '';
comment on column ${iol_schema}.scps_bp_personal_tb.scan_seq_no is '流水号';
comment on column ${iol_schema}.scps_bp_personal_tb.fr_org_code is '前台机构编码';
comment on column ${iol_schema}.scps_bp_personal_tb.tr_date is '客户开户日期';
comment on column ${iol_schema}.scps_bp_personal_tb.biz_code is '业务编码[代码T007][参考CFG_T_BIZ_CODE]';
comment on column ${iol_schema}.scps_bp_personal_tb.voucher_no is '凭证号码';
comment on column ${iol_schema}.scps_bp_personal_tb.cust_id is '客户编号';
comment on column ${iol_schema}.scps_bp_personal_tb.cust_name is '客户名称';
comment on column ${iol_schema}.scps_bp_personal_tb.english_name is '客户英文名称';
comment on column ${iol_schema}.scps_bp_personal_tb.sex is '性别';
comment on column ${iol_schema}.scps_bp_personal_tb.cert_type is '证件类型[代码0009][A-公民身份号码B-军官证C-解放军文职干部证D-警官证E-解放军士兵证F-户口簿G-(港、澳)回乡证、通行证H-(台)通行证、其他有效旅行证I-(外国)护照J-(中国)护照K-武警文职干部证L-武警士兵证P-全国组织机构代码Q-海外客户编号R-营业执照号码X-其它有效证件Z-其它]';
comment on column ${iol_schema}.scps_bp_personal_tb.cert_code is '证件号码';
comment on column ${iol_schema}.scps_bp_personal_tb.crt_cert_organ is '发证机关地区代码';
comment on column ${iol_schema}.scps_bp_personal_tb.birthday is '出生日期';
comment on column ${iol_schema}.scps_bp_personal_tb.weblock_flag is '婚姻状况[代码0007][10-未婚 20-已婚 21-初婚 22-再婚 23-复婚 40-离婚 90-未说明的婚姻状况 30-丧偶5-已婚有子女6-已婚无子女7-其他]';
comment on column ${iol_schema}.scps_bp_personal_tb.education is '学历';
comment on column ${iol_schema}.scps_bp_personal_tb.occupation is '职业[代码0048][]';
comment on column ${iol_schema}.scps_bp_personal_tb.rank is '职务';
comment on column ${iol_schema}.scps_bp_personal_tb.income is '月收入[代码0046][1-1500以下 2-1500到2000 3-2000到3000 4-3000到5000 5-5000到8000 6-8000到10000 7-10000到30000 8-30000以上]';
comment on column ${iol_schema}.scps_bp_personal_tb.company is '工作单位名称';
comment on column ${iol_schema}.scps_bp_personal_tb.home_address is '家庭地址';
comment on column ${iol_schema}.scps_bp_personal_tb.fix_telephone is '固定电话';
comment on column ${iol_schema}.scps_bp_personal_tb.office_phone is '办公电话';
comment on column ${iol_schema}.scps_bp_personal_tb.home_phone is '家庭电话';
comment on column ${iol_schema}.scps_bp_personal_tb.mobile is '移动电话';
comment on column ${iol_schema}.scps_bp_personal_tb.contact_address is '联系地址';
comment on column ${iol_schema}.scps_bp_personal_tb.postcode is '邮政编码';
comment on column ${iol_schema}.scps_bp_personal_tb.acct_type is '交易对手账户类型';
comment on column ${iol_schema}.scps_bp_personal_tb.spec_type is '存款账户类型';
comment on column ${iol_schema}.scps_bp_personal_tb.sf_scp_flag is '通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]';
comment on column ${iol_schema}.scps_bp_personal_tb.curr_type is '币种[代码T003][参考CFG_T_CURRENCY_TYPE]';
comment on column ${iol_schema}.scps_bp_personal_tb.cf_flag is '钞汇鉴别[代码0011][0-钞1-汇]';
comment on column ${iol_schema}.scps_bp_personal_tb.fee_drw_type is '费用支取别[代码0012][0-不收1-现金2-转账]';
comment on column ${iol_schema}.scps_bp_personal_tb.spec_time is '存期';
comment on column ${iol_schema}.scps_bp_personal_tb.amount is '金额';
comment on column ${iol_schema}.scps_bp_personal_tb.biz_password is '交易密码';
comment on column ${iol_schema}.scps_bp_personal_tb.biz_account is '交易账号';
comment on column ${iol_schema}.scps_bp_personal_tb.open_acct_password is '开户密码';
comment on column ${iol_schema}.scps_bp_personal_tb.tr_account is '转帐账号';
comment on column ${iol_schema}.scps_bp_personal_tb.tr_password is '转账密码';
comment on column ${iol_schema}.scps_bp_personal_tb.attor_opr_code is '客户经理编号';
comment on column ${iol_schema}.scps_bp_personal_tb.attor_opr_name is '客户经理姓名';
comment on column ${iol_schema}.scps_bp_personal_tb.attor_org_code is '客户经理所在网点';
comment on column ${iol_schema}.scps_bp_personal_tb.level_b_pin is '前台机构编码';
comment on column ${iol_schema}.scps_bp_personal_tb.fr_tlr_opr_no is '前台柜员号';
comment on column ${iol_schema}.scps_bp_personal_tb.puc_check_flag is '人行核查标志[代码0039][0-不用人行核查1-人行核查]';
comment on column ${iol_schema}.scps_bp_personal_tb.check_option is '身份核查意见';
comment on column ${iol_schema}.scps_bp_personal_tb.check_remark is '身份核查意见备注';
comment on column ${iol_schema}.scps_bp_personal_tb.check_opr_code is '核查操作员';
comment on column ${iol_schema}.scps_bp_personal_tb.puc_chk_date is '人行身份核查时间';
comment on column ${iol_schema}.scps_bp_personal_tb.update_flag is '客户信息更新标志';
comment on column ${iol_schema}.scps_bp_personal_tb.check_status is '审批状态';
comment on column ${iol_schema}.scps_bp_personal_tb.check_fall_reason is '审批未通过原因';
comment on column ${iol_schema}.scps_bp_personal_tb.succ_flag is '成功标志';
comment on column ${iol_schema}.scps_bp_personal_tb.status is '流程状态';
comment on column ${iol_schema}.scps_bp_personal_tb.home_addr_type is '住宅类型[代码0106][1-自置2-公积金贷款3-商业贷款4-租用5-其他]';
comment on column ${iol_schema}.scps_bp_personal_tb.company_type is '单位性质[代码0107][01-国家机关02-事业单位03-国有企业04-私营，民营企业05-中外合资，合作，外资企业06-其他]';
comment on column ${iol_schema}.scps_bp_personal_tb.obtain_opr_code is '任务获取柜员号';
comment on column ${iol_schema}.scps_bp_personal_tb.commission is '代办事由';
comment on column ${iol_schema}.scps_bp_personal_tb.email is '邮箱';
comment on column ${iol_schema}.scps_bp_personal_tb.often_site is '经常居住地';
comment on column ${iol_schema}.scps_bp_personal_tb.relation is '与被代理人关系';
comment on column ${iol_schema}.scps_bp_personal_tb.nationality is '国籍';
comment on column ${iol_schema}.scps_bp_personal_tb.pro_name is '代理人姓名(中文)';
comment on column ${iol_schema}.scps_bp_personal_tb.pro_type is '代理人证件类型';
comment on column ${iol_schema}.scps_bp_personal_tb.pro_fashion is '代理人联系方式';
comment on column ${iol_schema}.scps_bp_personal_tb.is_porxy is '是否代办(0 否 1 是)';
comment on column ${iol_schema}.scps_bp_personal_tb.accept_no is '受理号(任务号)';
comment on column ${iol_schema}.scps_bp_personal_tb.trane_code is '交易代码';
comment on column ${iol_schema}.scps_bp_personal_tb.idtfna_name is '证件姓名';
comment on column ${iol_schema}.scps_bp_personal_tb.pro_cert_code is '代理人证件号码';
comment on column ${iol_schema}.scps_bp_personal_tb.is_net_silver_contract is '是否操作网银(0-否 1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.open_flag is '开户标志(0:无卡介质也无客户信息,1:有卡介质的2:无卡介质，但在我行有客户信息)';
comment on column ${iol_schema}.scps_bp_personal_tb.group_flag is '分组标志(预留扩展，暂时送99)';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_passwd is '网银初始登录密码';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_left_msg is '预留信息';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_sign_mobile is '签约手机号码';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_sec_model is '安全工具型号(0-飞天  1-捷德)';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_sec_type is '安全工具类型(0-个人，1-企业)';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_sec_no is '安全工具编号';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_dynamic_opt_no is '动态口令编号';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_dynamic_card_no is '口令卡编号';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_is_transfer is '账号开通权限(0-查询 1-转账)';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_ac_limit_pertrs is '账户级单笔限额';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_ac_limit_perday is '账户级日累计限额';
comment on column ${iol_schema}.scps_bp_personal_tb.cert_date is '证件到期日';
comment on column ${iol_schema}.scps_bp_personal_tb.id_address is '户籍地址';
comment on column ${iol_schema}.scps_bp_personal_tb.is_sms_contract is '是否操作短信通(0-否 1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.is_tel_n_trnsf is '非定向转账是否开通（1-开通）';
comment on column ${iol_schema}.scps_bp_personal_tb.is_tel_n_trnsf_default_limit is '非定向转账默认额度（1-默认额度）';
comment on column ${iol_schema}.scps_bp_personal_tb.tel_n_trnsf_single_limit is '非定向转账单笔额度';
comment on column ${iol_schema}.scps_bp_personal_tb.tel_n_trnsf_day_limit is '非定向转账单日额度';
comment on column ${iol_schema}.scps_bp_personal_tb.is_tel_d_trnsf is '定向转账是否开通（1-开通）';
comment on column ${iol_schema}.scps_bp_personal_tb.is_tel_d_trnsf_no_limit is '定向转账无限额度（1-无限额）';
comment on column ${iol_schema}.scps_bp_personal_tb.tel_d_trnsf_single_limit is '定向转账单笔额度';
comment on column ${iol_schema}.scps_bp_personal_tb.tel_d_trnsf_day_limit is '定向转账单日额度';
comment on column ${iol_schema}.scps_bp_personal_tb.payee_name1 is '定向转账收款人全称1';
comment on column ${iol_schema}.scps_bp_personal_tb.payee_accno1 is '定向转账收款人账号1';
comment on column ${iol_schema}.scps_bp_personal_tb.payee_bank_name1 is '定向转账开户银行全称1';
comment on column ${iol_schema}.scps_bp_personal_tb.payee_name2 is '定向转账收款人全称2';
comment on column ${iol_schema}.scps_bp_personal_tb.payee_accno2 is '定向转账收款人账号2';
comment on column ${iol_schema}.scps_bp_personal_tb.payee_bank_name2 is '定向转账开户银行全称2';
comment on column ${iol_schema}.scps_bp_personal_tb.sms_notice_limit is '账户变动短信通知起点金额';
comment on column ${iol_schema}.scps_bp_personal_tb.sec_node_id is '加密结点号';
comment on column ${iol_schema}.scps_bp_personal_tb.proxy_sex is '代理人性别';
comment on column ${iol_schema}.scps_bp_personal_tb.proxy_idtdt is '证件失效日期';
comment on column ${iol_schema}.scps_bp_personal_tb.proxy_id_address is '代理人证件地址';
comment on column ${iol_schema}.scps_bp_personal_tb.sms_contract_if_succeed is '短信通签约是否成功(0-失败 1-成功)';
comment on column ${iol_schema}.scps_bp_personal_tb.net_silver_contract_succeed is '网银签约是否成功(0-失败 1-成功)';
comment on column ${iol_schema}.scps_bp_personal_tb.is_netb_default_limit is '网银签约是否默认限额(1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.prsntg is '居民性质代码';
comment on column ${iol_schema}.scps_bp_personal_tb.staffflag is '员工标志(默认0)';
comment on column ${iol_schema}.scps_bp_personal_tb.custlv is '客户级别(默认00)';
comment on column ${iol_schema}.scps_bp_personal_tb.risklv is '客户风险承受能力评估等级（1-保守型 2-谨慎型 3-稳健型 4-进取型 5-激进型）';
comment on column ${iol_schema}.scps_bp_personal_tb.wkutad is '工作单位地址';
comment on column ${iol_schema}.scps_bp_personal_tb.roleid is '职称等级';
comment on column ${iol_schema}.scps_bp_personal_tb.worktx is '其他职业';
comment on column ${iol_schema}.scps_bp_personal_tb.csec_node_id is '转加密结点号';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_csec_passwd is '转加密网银初始密码';
comment on column ${iol_schema}.scps_bp_personal_tb.transfer_channel is '转账渠道（1-手机银行定向转账2-电话银行定向转账）';
comment on column ${iol_schema}.scps_bp_personal_tb.mobile_ac_limit_pertrs is '手机银行账户级单笔限额';
comment on column ${iol_schema}.scps_bp_personal_tb.mobile_ac_limit_perday is '手机银行账户级日累计限额';
comment on column ${iol_schema}.scps_bp_personal_tb.is_mobile_default_limit is '手机银行是否默认限额(1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.fax is '传真';
comment on column ${iol_schema}.scps_bp_personal_tb.area_code is '地区代码';
comment on column ${iol_schema}.scps_bp_personal_tb.truth_flag is '实名标志';
comment on column ${iol_schema}.scps_bp_personal_tb.trnamt is '转存金额';
comment on column ${iol_schema}.scps_bp_personal_tb.voucherty is '凭证类型    738-华兴卡 741-借记芯片卡';
comment on column ${iol_schema}.scps_bp_personal_tb.id_check_result is '身份证联网核查结果[00-公民身份证号码与姓名一致，且存在照片01-公民身份证号码与姓名一致，但不存在照片02-公民身份号码存在，但与姓名不匹配03-公民身份号码不存在04-其他错误]';
comment on column ${iol_schema}.scps_bp_personal_tb.mobile_open_status is '移动业务审批状态 0处理中 1审批通过 2审批不通过(开卡、网银签约、短信通签约)';
comment on column ${iol_schema}.scps_bp_personal_tb.account_update_flag is '账户更新标志[0：删除 1：更新 2：增加 为空表示不操作账户]';
comment on column ${iol_schema}.scps_bp_personal_tb.submit_status is '移动综合签约提交状态[提交锁定字段 0：未处理1：处理中2：提交成功]';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_biz_type is '网银签约业务类型[0：新增1：变更]';
comment on column ${iol_schema}.scps_bp_personal_tb.often_site_eq_id_addr is '经常居住地同身份证件地址（0否 1是）';
comment on column ${iol_schema}.scps_bp_personal_tb.net_ukey is '开通华兴U盾（0否 1是2关联）';
comment on column ${iol_schema}.scps_bp_personal_tb.card_type is '卡产品';
comment on column ${iol_schema}.scps_bp_personal_tb.card_rank is '卡等级';
comment on column ${iol_schema}.scps_bp_personal_tb.is_finance_contract is '是否操作理财(0-否 1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.sendfreq is '对账单发送频率[0-有交易发生寄送1-不寄送2-按月3-按季4-半年5-一年]';
comment on column ${iol_schema}.scps_bp_personal_tb.sendmode is '对账单寄送方式(共8个字符，每个字符代表一种交易手段，其含义为：第1位：邮寄第2位：传真第3位：E-mail第4位：短消息第5~8位：保留。每位字符取1表示采用此种手段，取0表示不使用)';
comment on column ${iol_schema}.scps_bp_personal_tb.risklevel is '理财产品风险等级（0-未评定 1-低风险2-较低风险3-中风险4-较高风险5-高风险）';
comment on column ${iol_schema}.scps_bp_personal_tb.clientgroup is '客户分组[a-	群客户Z- 其他客户]';
comment on column ${iol_schema}.scps_bp_personal_tb.chnlflag is '高风险产品柜台以外渠道允许购买标志(0-不允许 1-允许 默认0)';
comment on column ${iol_schema}.scps_bp_personal_tb.finance_contract_succeed is '理财签约是否成功(0-失败 1-成功)';
comment on column ${iol_schema}.scps_bp_personal_tb.finance_acctno is '理财签约账号';
comment on column ${iol_schema}.scps_bp_personal_tb.open_brcno is '开卡机构';
comment on column ${iol_schema}.scps_bp_personal_tb.cust_mgrno is '客户经理代码';
comment on column ${iol_schema}.scps_bp_personal_tb.sms_cust_sign is '短信通客户是否已签约(0:未签约1:已签约)';
comment on column ${iol_schema}.scps_bp_personal_tb.fee_acct_no is '扣费账号';
comment on column ${iol_schema}.scps_bp_personal_tb.fee_acct_brcno is '扣费账号分行号';
comment on column ${iol_schema}.scps_bp_personal_tb.fee_acct_nodeno is '扣费账号行所号';
comment on column ${iol_schema}.scps_bp_personal_tb.contact_phone is '联系手机号码';
comment on column ${iol_schema}.scps_bp_personal_tb.attbrn is '业务归属机构';
comment on column ${iol_schema}.scps_bp_personal_tb.new_password is '新交易密码';
comment on column ${iol_schema}.scps_bp_personal_tb.new_account is '新账号';
comment on column ${iol_schema}.scps_bp_personal_tb.chactg is '更换类型';
comment on column ${iol_schema}.scps_bp_personal_tb.stpytg is '挂失类型';
comment on column ${iol_schema}.scps_bp_personal_tb.rplsfs is '挂失形式';
comment on column ${iol_schema}.scps_bp_personal_tb.submit_state is '业务提交状态 0-未提交，1-处理中 2-提交成功';
comment on column ${iol_schema}.scps_bp_personal_tb.netopflag is '网银操作类型[0-开通1-维护 2-解约（注销）3-暂停4-恢复5开通以下服务]';
comment on column ${iol_schema}.scps_bp_personal_tb.smsopflag is '短信通操作类型[0-签约 1-解约 2-短信通手机号码新增 3-短信通手机号码修改 4-短信通手机号码取消]';
comment on column ${iol_schema}.scps_bp_personal_tb.finopflag is '理财操作类型[0-签约  1-解约 2-更换账户  3-银行帐号登记取消]';
comment on column ${iol_schema}.scps_bp_personal_tb.delukey is '是否删除Ukey(0-否 1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.bgnamt is '短信通知起点金额';
comment on column ${iol_schema}.scps_bp_personal_tb.trtmrs is '核实结果  01未核实，02真实';
comment on column ${iol_schema}.scps_bp_personal_tb.loss_date is '挂失日期(yyyymmdd)';
comment on column ${iol_schema}.scps_bp_personal_tb.loss_reg_no is '挂失登记号';
comment on column ${iol_schema}.scps_bp_personal_tb.undays is '挂失天数    临时挂失5天，正式挂失7天';
comment on column ${iol_schema}.scps_bp_personal_tb.payway is '支取方式 S-凭印鉴支取 P-凭密码支取 W-无密码无印鉴支取 B-凭印鉴和密码支取 O-凭证件支取 R-支付密码器和印鉴';
comment on column ${iol_schema}.scps_bp_personal_tb.is_fund_contract is '是否操作基金(0-否 1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.fundopflag is '基金操作类型[ 1-开通 2-银行卡号变更 3-解约]';
comment on column ${iol_schema}.scps_bp_personal_tb.fin_manager_id is '理财经理编号';
comment on column ${iol_schema}.scps_bp_personal_tb.szsecno is '深交所证券账号';
comment on column ${iol_schema}.scps_bp_personal_tb.shsecno is '上交所证券账号';
comment on column ${iol_schema}.scps_bp_personal_tb.minorflag is '是否成年人标志 1-否，0-是';
comment on column ${iol_schema}.scps_bp_personal_tb.fundnewacct is '基金新银行卡号';
comment on column ${iol_schema}.scps_bp_personal_tb.fund_contract_if_succeed is '基金签约操作是否成功(0-失败 1-成功)';
comment on column ${iol_schema}.scps_bp_personal_tb.is_third_manage_contract is '是否三方存管签约操作';
comment on column ${iol_schema}.scps_bp_personal_tb.cobank is '合作行';
comment on column ${iol_schema}.scps_bp_personal_tb.ori_acct is '三方存管原结算账号';
comment on column ${iol_schema}.scps_bp_personal_tb.ori_brcode is '三方存管原结算账号开户机构';
comment on column ${iol_schema}.scps_bp_personal_tb.bond_acct is '证券资金台账账号';
comment on column ${iol_schema}.scps_bp_personal_tb.bond_pass is '证券资金台账密码';
comment on column ${iol_schema}.scps_bp_personal_tb.bond_code is '券商代码';
comment on column ${iol_schema}.scps_bp_personal_tb.bond_name is '券商名称';
comment on column ${iol_schema}.scps_bp_personal_tb.third_manage_if_succeed is '三方存管签约操作是否成功(0-失败 1-成功)';
comment on column ${iol_schema}.scps_bp_personal_tb.is_invest_contract is '是否储蓄定投签约操作 0-否，1-是';
comment on column ${iol_schema}.scps_bp_personal_tb.invest_opflag is '储蓄定投操作类型 1-签约 2-维护 3-解约';
comment on column ${iol_schema}.scps_bp_personal_tb.invest_contract_if_succeed is '储蓄定投签约操作是否成功(0-失败 1-成功)';
comment on column ${iol_schema}.scps_bp_personal_tb.is_quickin_contract is '是否灵活盈签约操作 0-否，1-是';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_opflag is '灵活盈签约操作类型 1-签约 2-维护 3-解约';
comment on column ${iol_schema}.scps_bp_personal_tb.chan_save_tp is '转存类型 1-活期转双整 2-活期转通知';
comment on column ${iol_schema}.scps_bp_personal_tb.chan_save_deadline is '灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年';
comment on column ${iol_schema}.scps_bp_personal_tb.chan_save_amt is '转存起点金额';
comment on column ${iol_schema}.scps_bp_personal_tb.save_low_amt is '最低留存金额';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_contract_if_succeed is '灵活盈签约操作是否成功(0-失败 1-成功)';
comment on column ${iol_schema}.scps_bp_personal_tb.sign_type is '签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5';
comment on column ${iol_schema}.scps_bp_personal_tb.third_ma_apply_tp is '三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息';
comment on column ${iol_schema}.scps_bp_personal_tb.third_ma_new_acct is '三方存管新账号';
comment on column ${iol_schema}.scps_bp_personal_tb.is_acctfund_contract is '基金代销账户类签约操作 0-否，1-是';
comment on column ${iol_schema}.scps_bp_personal_tb.acctfund_sign_type is '基金代销账户类签约种类 1-签约2-解约3-维护';
comment on column ${iol_schema}.scps_bp_personal_tb.is_bill_send is '对账单寄送要求 1-寄送0-不寄送';
comment on column ${iol_schema}.scps_bp_personal_tb.acctfund_ori_acct is '交易账户变更原账号 默认前“签约账号”项';
comment on column ${iol_schema}.scps_bp_personal_tb.is_tradefund_contract is '基金代销交易类签约操作 0-否，1-是';
comment on column ${iol_schema}.scps_bp_personal_tb.tradefund_sign_type is '基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更';
comment on column ${iol_schema}.scps_bp_personal_tb.tradefund_name is '基金名称';
comment on column ${iol_schema}.scps_bp_personal_tb.tradefund_code is '基金代码';
comment on column ${iol_schema}.scps_bp_personal_tb.savings_invest_optp is '储蓄定投操作类型 1-终止 2-暂停 3-恢复';
comment on column ${iol_schema}.scps_bp_personal_tb.time_invest_code is '定投编号';
comment on column ${iol_schema}.scps_bp_personal_tb.third_manage_optp is '三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]';
comment on column ${iol_schema}.scps_bp_personal_tb.fund_acct is '基金签约操作账号';
comment on column ${iol_schema}.scps_bp_personal_tb.fund_acct_brcno is '基金签约账号开卡网点';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_leave_amt is '灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_leave_amt_other is '灵活盈—活期账户留存金额_其它';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_op_choice is '网银修改服务选项(1登录密码 2手机动态密码)';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_password_optp is '网银登录密码操作类型(1重置 2解锁)';
comment on column ${iol_schema}.scps_bp_personal_tb.netb_netphone_optp is '手机动态密码操作类型(0-不开通1开通2注销3指定手机号4变更手机号5关联)';
comment on column ${iol_schema}.scps_bp_personal_tb.ukey_optp is '华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)';
comment on column ${iol_schema}.scps_bp_personal_tb.is_sms_set_phone is '短信通是否设置签约手机号 0-否，1-是';
comment on column ${iol_schema}.scps_bp_personal_tb.is_net_trans_limit_set is '是否网银转账限额设置 0-否，1-是';
comment on column ${iol_schema}.scps_bp_personal_tb.is_mob_trans_limit_set is '手机银行是否非定向转账限额设置 0-否，1-是';
comment on column ${iol_schema}.scps_bp_personal_tb.direct_trans_optp is '定向转账操作类型[1开通2修改3注销]';
comment on column ${iol_schema}.scps_bp_personal_tb.is_direct_trans_ac_set is '是否定向收款账户设置[0-否，1-是]';
comment on column ${iol_schema}.scps_bp_personal_tb.sms_set_phone_optp is '短信通设置签约手机号操作类型[1-开通 3-注销]';
comment on column ${iol_schema}.scps_bp_personal_tb.fin_new_acct is '理财银行卡号变更新账号';
comment on column ${iol_schema}.scps_bp_personal_tb.fin_new_open_brcno is '理财银行卡号变更新账号所属机构';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_pass is '灵活盈交易密码(带账号转加密)';
comment on column ${iol_schema}.scps_bp_personal_tb.cust_changes is '客户信息变更内容1.通讯地址2.邮政编码3.联系电话4.手机5.EMAIL';
comment on column ${iol_schema}.scps_bp_personal_tb.tlr_mobile is '前台柜员手机号码';
comment on column ${iol_schema}.scps_bp_personal_tb.deposit_trade_no is '交易单编号';
comment on column ${iol_schema}.scps_bp_personal_tb.acct_type_m is '账号类型:0: 人民币个人非结算户1: 人民币个人结算户A: 外汇结算账户B: 乙种储蓄存款账户C: 丙种储蓄存款账户';
comment on column ${iol_schema}.scps_bp_personal_tb.dsp_type is '储种:S01储蓄活期S02	储蓄双整S03	零存整取S04	整存零取S05	存本取息S06	定活两便S07	储蓄通知S08	教育储蓄S18:财富宝';
comment on column ${iol_schema}.scps_bp_personal_tb.dsp_period is '存期:203-三个月、206-六个月、301-一年、302-二年、303-三年、305-五年、000-活期、101-一天、107-七天 、203-三个月、206-六个月、301-一年';
comment on column ${iol_schema}.scps_bp_personal_tb.dsp_flag is '转存标识:1:自动转存0:非自动转存';
comment on column ${iol_schema}.scps_bp_personal_tb.tran_type is '交易类型:CO-现开TO-转开';
comment on column ${iol_schema}.scps_bp_personal_tb.to_acct_no is '转出账号';
comment on column ${iol_schema}.scps_bp_personal_tb.to_acct_name is '转出账号名称';
comment on column ${iol_schema}.scps_bp_personal_tb.to_pswd is '转出账号密码';
comment on column ${iol_schema}.scps_bp_personal_tb.to_idtp is '转出证件类型:A:身份证,B:外国公民护照,C:户口薄,D:港澳居民通行证,E:还乡证,F:边民出入境通行证,G:军官证,H:士兵证,I:军事院校学员证,J:军队离休干部荣誉证,K:军官退休证,L:军人文职干部退休证,P:其他,Q:武警身份证,R:台湾居民通行证,S:中国公民护照,U:临时身份证';
comment on column ${iol_schema}.scps_bp_personal_tb.to_idno is '转出证件号码';
comment on column ${iol_schema}.scps_bp_personal_tb.to_dwfs is '转出支取方式：A:密码 D:印鉴 E:证件';
comment on column ${iol_schema}.scps_bp_personal_tb.prcsna is '交易类型';
comment on column ${iol_schema}.scps_bp_personal_tb.nwinrt is '利率';
comment on column ${iol_schema}.scps_bp_personal_tb.matudt is '到期日';
comment on column ${iol_schema}.scps_bp_personal_tb.valuedt is '起息日';
comment on column ${iol_schema}.scps_bp_personal_tb.proxy_flag is '代办人类型（0-否 1-监护代理 2-普通代理）';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_type is '灵活盈-储种（1-三个月 2-六个月 3-一年 4-二年 5-三年 6-五年 7-不约定存期 8-七天通知）';
comment on column ${iol_schema}.scps_bp_personal_tb.acctlv is '账户分类';
comment on column ${iol_schema}.scps_bp_personal_tb.is_card is '是否有卡';
comment on column ${iol_schema}.scps_bp_personal_tb.regoresult is '1识别失败，0识别成功';
comment on column ${iol_schema}.scps_bp_personal_tb.similarity is '0%~100%，>=80%为认定为本人';
comment on column ${iol_schema}.scps_bp_personal_tb.issetnewpwd is '是否设置新密码';
comment on column ${iol_schema}.scps_bp_personal_tb.isfcfnoper is '是否操作非柜面非同名限额签约(0-否,1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.isfcfntype is '非柜面非同名账户限额签约操作类型(0-签约 1-维护)';
comment on column ${iol_schema}.scps_bp_personal_tb.isfcfnct is '是否非柜面非同名账户限额签约(0-否,1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.daylimit is '日累计限额(非柜面非同名账户限额签约)';
comment on column ${iol_schema}.scps_bp_personal_tb.txntimeslimit is '日笔数限额(非柜面非同名账户限额签约)';
comment on column ${iol_schema}.scps_bp_personal_tb.yearlimit is '年累计限额(非柜面非同名账户限额签约)';
comment on column ${iol_schema}.scps_bp_personal_tb.is_fcfnct_succeed is '非柜面非同名账户限额签约是否成功(0-失败,1-成功)';
comment on column ${iol_schema}.scps_bp_personal_tb.agreementid is 'ECIF签约协议号';
comment on column ${iol_schema}.scps_bp_personal_tb.custom_daylimit is '自定义-日累计限额(万元)';
comment on column ${iol_schema}.scps_bp_personal_tb.custom_txntimeslimit is '自定义-日累计笔数';
comment on column ${iol_schema}.scps_bp_personal_tb.custom_yearlimit is '自定义-年累计限额(万元)';
comment on column ${iol_schema}.scps_bp_personal_tb.pro_nationality is '代理人国籍';
comment on column ${iol_schema}.scps_bp_personal_tb.mobile_type is '号码性质 0--本人1--监护人';
comment on column ${iol_schema}.scps_bp_personal_tb.outflg is '外出标注-0，默认网点0：网点凭证 1：外出凭证';
comment on column ${iol_schema}.scps_bp_personal_tb.netstate is '网银密码重置--状态默认送0';
comment on column ${iol_schema}.scps_bp_personal_tb.logonpwnew is '网银密码重置--新登陆密码';
comment on column ${iol_schema}.scps_bp_personal_tb.netreset is '是否网银密码重置';
comment on column ${iol_schema}.scps_bp_personal_tb.relativetp is '监护人/亲属证件类型';
comment on column ${iol_schema}.scps_bp_personal_tb.relativena is '监护人/亲属姓名';
comment on column ${iol_schema}.scps_bp_personal_tb.relativeno is '监护人/亲属号码';
comment on column ${iol_schema}.scps_bp_personal_tb.taxresident is '税收居民身份（1仅为中国税收居民2仅为非居民3既是中国税收居民又是其他国家（地区）税收居民4无需声明5空）';
comment on column ${iol_schema}.scps_bp_personal_tb.birthplace is '纳税人出生地（中英文字符）';
comment on column ${iol_schema}.scps_bp_personal_tb.taxarea is '税收居民国（地区）';
comment on column ${iol_schema}.scps_bp_personal_tb.taxnumber is '纳税人识别号';
comment on column ${iol_schema}.scps_bp_personal_tb.taxarea2 is '纳税居民国家（地区）2（发送报文时整合在TAXAREA）';
comment on column ${iol_schema}.scps_bp_personal_tb.taxarea3 is '纳税居民国家（地区）3（发送报文时整合在TAXAREA）';
comment on column ${iol_schema}.scps_bp_personal_tb.taxnumber2 is '纳税人识别号2（发送报文时整合在TAXNUMBER）';
comment on column ${iol_schema}.scps_bp_personal_tb.taxnumber3 is '纳税人识别号3（发送报文时整合在TAXNUMBER）';
comment on column ${iol_schema}.scps_bp_personal_tb.taxnullreason is '纳税人识别号为空原因';
comment on column ${iol_schema}.scps_bp_personal_tb.taxstatement is '是否取得自证声明（0-未取得自证声明1-取得自证声明）';
comment on column ${iol_schema}.scps_bp_personal_tb.customersurname is '客户_姓（字母）';
comment on column ${iol_schema}.scps_bp_personal_tb.customergivenname is '客户_名（字母）';
comment on column ${iol_schema}.scps_bp_personal_tb.taxnullreason2 is '纳税人识别号为空原因2';
comment on column ${iol_schema}.scps_bp_personal_tb.taxnullreason3 is '纳税人识别号为空原因3';
comment on column ${iol_schema}.scps_bp_personal_tb.boundaccno is '绑定账号';
comment on column ${iol_schema}.scps_bp_personal_tb.boundbank is '绑定账号开户行';
comment on column ${iol_schema}.scps_bp_personal_tb.checkcase is '落地审核原因';
comment on column ${iol_schema}.scps_bp_personal_tb.ocridtdt is '证件生效日期';
comment on column ${iol_schema}.scps_bp_personal_tb.yflag is '手机盾标志 Y:为是手机盾，N:为不是手机盾';
comment on column ${iol_schema}.scps_bp_personal_tb.phoneoperate is '手机盾操作类型0：开通';
comment on column ${iol_schema}.scps_bp_personal_tb.camp_emp_id is '营销工号';
comment on column ${iol_schema}.scps_bp_personal_tb.notemessagephone1 is '短信通签约号码1';
comment on column ${iol_schema}.scps_bp_personal_tb.notemessagephone2 is '短信通签约号码2';
comment on column ${iol_schema}.scps_bp_personal_tb.notemessagephone3 is '短信通签约号码3';
comment on column ${iol_schema}.scps_bp_personal_tb.notemessagephone4 is '短信通签约号码4';
comment on column ${iol_schema}.scps_bp_personal_tb.notemessagephone5 is '短信通签约号码5';
comment on column ${iol_schema}.scps_bp_personal_tb.isagtsch is '是否个人扣款协议签约(0-否,1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.proxy_idtdt_sl is '是否云闪付绑定签约';
comment on column ${iol_schema}.scps_bp_personal_tb.is_flashpay_contract is '云闪付绑定签约是否成功  0-失败 1-成功';
comment on column ${iol_schema}.scps_bp_personal_tb.flashpay_contract_if_succeed is '';
comment on column ${iol_schema}.scps_bp_personal_tb.local_ip is '开户IP';
comment on column ${iol_schema}.scps_bp_personal_tb.local_mac is '开户MAC';
comment on column ${iol_schema}.scps_bp_personal_tb.uuid is 'UUID';
comment on column ${iol_schema}.scps_bp_personal_tb.ukey_modify_if_succeed is 'U盾管理状态';
comment on column ${iol_schema}.scps_bp_personal_tb.is_send_message is '是否发送营销短信';
comment on column ${iol_schema}.scps_bp_personal_tb.phonepay_contract_if_succeed is '手机转账签约是否成功(0-失败 1-成功)';
comment on column ${iol_schema}.scps_bp_personal_tb.is_phonepay_contract is '是否手机转账签约(0-否 1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.regedittype is '登记注册类型';
comment on column ${iol_schema}.scps_bp_personal_tb.sco is '';
comment on column ${iol_schema}.scps_bp_personal_tb.is_phonepay_contract1 is '是否手机转账签约(0-否 1-是)';
comment on column ${iol_schema}.scps_bp_personal_tb.phonepay_contract_if_succeed1 is '手机转账签约是否成功(0-失败 1-成功)';
comment on column ${iol_schema}.scps_bp_personal_tb.regedittype1 is '登记注册类型';
comment on column ${iol_schema}.scps_bp_personal_tb.limit_oper_type is '非柜面签约';
comment on column ${iol_schema}.scps_bp_personal_tb.limit_oper_channel is '';
comment on column ${iol_schema}.scps_bp_personal_tb.day_transfer_count is '非柜面签约-日总笔数';
comment on column ${iol_schema}.scps_bp_personal_tb.day_transfer_amount is '非柜面签约-日总限额';
comment on column ${iol_schema}.scps_bp_personal_tb.year_transfer_count is '非柜面签约-年总笔数';
comment on column ${iol_schema}.scps_bp_personal_tb.year_transfer_amount is '非柜面签约-年总限额';
comment on column ${iol_schema}.scps_bp_personal_tb.limit_oper_result is '';
comment on column ${iol_schema}.scps_bp_personal_tb.tally_state is '记账状态 0 未记账 1 记账成功 2 记账失败';
comment on column ${iol_schema}.scps_bp_personal_tb.agt_num is '协议号';
comment on column ${iol_schema}.scps_bp_personal_tb.dspbgndt is '转存起始日期';
comment on column ${iol_schema}.scps_bp_personal_tb.dspenddt is '转存截止日期';
comment on column ${iol_schema}.scps_bp_personal_tb.dsptyper is '转存类型 1 转存双整 2 转存通知';
comment on column ${iol_schema}.scps_bp_personal_tb.invest_account is '储蓄定投签约账户';
comment on column ${iol_schema}.scps_bp_personal_tb.invest_trnamt is '转存金额';
comment on column ${iol_schema}.scps_bp_personal_tb.prd_id is '产品编号';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_agreement_id is '灵活盈协议编号';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_agreement_status is '灵活盈协议状态';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_agreement_type is '灵活盈协议类型';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_fin_fixed_amt is '灵活盈理财固定金额';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_int_min_amt is '灵活盈最小起存金额';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_remain_amt is '灵活盈协议留存金额';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_start_amt is '灵活盈起始金额';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_transfer_day is '划转日';
comment on column ${iol_schema}.scps_bp_personal_tb.quickin_transfer_freq is '灵活盈划转频率';
comment on column ${iol_schema}.scps_bp_personal_tb.redep_freq is '转存频率';
comment on column ${iol_schema}.scps_bp_personal_tb.renew_corp is '转存单位';
comment on column ${iol_schema}.scps_bp_personal_tb.rpdsp is '转存周期 Y-年 Q-季 M-月 W-周 D-天';
comment on column ${iol_schema}.scps_bp_personal_tb.sub_acct_num is '子账号';
comment on column ${iol_schema}.scps_bp_personal_tb.sum_sub_num is '汇总子户号';
comment on column ${iol_schema}.scps_bp_personal_tb.biz_type is '业务种类';
comment on column ${iol_schema}.scps_bp_personal_tb.biz_dt is '交易日期（yyyy-MM-dd hh:mm:ss）';
comment on column ${iol_schema}.scps_bp_personal_tb.finance_card_type is '理财账户类型';
comment on column ${iol_schema}.scps_bp_personal_tb.fin_new_acct_crspd_pty_id is '新账号对应客户号';
comment on column ${iol_schema}.scps_bp_personal_tb.custchnlid is '开通渠道';
comment on column ${iol_schema}.scps_bp_personal_tb.riskmonths is '风险有效期月数';
comment on column ${iol_schema}.scps_bp_personal_tb.rskcd is '风险等级代码';
comment on column ${iol_schema}.scps_bp_personal_tb.oper_flag is '1 客户级 2账户级';
comment on column ${iol_schema}.scps_bp_personal_tb.third_chg_card_id is '三方存管换卡标识';
comment on column ${iol_schema}.scps_bp_personal_tb.third_open_org_id is '三方存管开户机构';
comment on column ${iol_schema}.scps_bp_personal_tb.usb_key_cert_id is 'USBKey证书编号';
comment on column ${iol_schema}.scps_bp_personal_tb.old_cert_key_id is '旧证书KEYID';
comment on column ${iol_schema}.scps_bp_personal_tb.safe_instr_model is '安全工具型号(0：飞天1：捷德)';
comment on column ${iol_schema}.scps_bp_personal_tb.u_brch_num is 'U盾网点号';
comment on column ${iol_schema}.scps_bp_personal_tb.u_oper_typ is 'U盾操作类型（2：注销 3：损坏更换 4：挂失更换 5：发放）';
comment on column ${iol_schema}.scps_bp_personal_tb.wthr_out is '是否出库 默认Y Y：是 N：否';
comment on column ${iol_schema}.scps_bp_personal_tb.lost_operate_method is '挂失操作方式，比如书面挂失、口头挂失UV-口头解挂 UW-正式解挂 VL-口挂 WL-书挂';
comment on column ${iol_schema}.scps_bp_personal_tb.lost_no is '账户/凭证/结算卡挂失号码';
comment on column ${iol_schema}.scps_bp_personal_tb.acct_name is '账户名称';
comment on column ${iol_schema}.scps_bp_personal_tb.loss_id is '挂失编号';
comment on column ${iol_schema}.scps_bp_personal_tb.acct_seq_no is '账户序列号';
comment on column ${iol_schema}.scps_bp_personal_tb.acct_password is '账户密码';
comment on column ${iol_schema}.scps_bp_personal_tb.voucher_change_type is '凭证更换类型，比如挂失补发、损坏更换等，不同的更换类型会对应不同的处理流程 01-挂失补发 02-凭证更换 03-损坏更换 04-同号换卡领卡/记名卡领卡 05-单位存单置换 06-单位存单收回如果补开、凭证更换必传';
comment on column ${iol_schema}.scps_bp_personal_tb.new_vchr_typ is '新凭证类型';
comment on column ${iol_schema}.scps_bp_personal_tb.new_vchr_num is '新凭证号码';
comment on column ${iol_schema}.scps_bp_personal_tb.voucher_change_reason is '更换原因';
comment on column ${iol_schema}.scps_bp_personal_tb.td_inout_operate_type is '存单移入必传 定期账户转入转出操作类型 01-转入 02-互转 03-转出';
comment on column ${iol_schema}.scps_bp_personal_tb.in_base_acct_no is '移入账号';
comment on column ${iol_schema}.scps_bp_personal_tb.in_prod_type is '转入账户产品类型';
comment on column ${iol_schema}.scps_bp_personal_tb.enter_acct_ccy is '转入账户币种';
comment on column ${iol_schema}.scps_bp_personal_tb.target_acct_class is '目标账户类别（一二三类户），即账户升级后的账户类别，满足人行对于电子账户的管理办法1-一类账户 2-二类账户 3-三类账户';
comment on column ${iol_schema}.scps_bp_personal_tb.password_operate_type is '账户密码操作类型 账户密码操作类型01-新建 02-重置 03-修改 04-解锁 05-校验 06-激活 07-凭证解挂场景密码重置 08-弱密码校验';
comment on column ${iol_schema}.scps_bp_personal_tb.password_type is '密码类型，目前核心只支持WD，接口未上送则默认为WDWD-支取密码 QY-查询密码 MA-账户管理密码';
comment on column ${iol_schema}.scps_bp_personal_tb.password_old is '旧密码';
comment on column ${iol_schema}.scps_bp_personal_tb.iss_country is '发证国家';
comment on column ${iol_schema}.scps_bp_personal_tb.password_effect_date is '密码生效日期';
comment on column ${iol_schema}.scps_bp_personal_tb.lost_reason is '挂失原因';
comment on column ${iol_schema}.scps_bp_personal_tb.res_flag is '标识挂失账户是N进行账户止付,挂失时必输，解挂时不需要输入Y-是 N-不是';
comment on column ${iol_schema}.scps_bp_personal_tb.pause_post is '暂停附言';
comment on column ${iol_schema}.scps_bp_personal_tb.channel is '渠道';
comment on column ${iol_schema}.scps_bp_personal_tb.ntw_ceph_bank_pause_type is '网银手机银行管理 业务类型 01：个人动态密码管理 02：解锁登录密码 03：网银/手机银行暂停/恢复 04：登录密码和用户状态重置 05：客户手机盾信息维护 06：账户暂停/恢复';
comment on column ${iol_schema}.scps_bp_personal_tb.ntw_ceph_bank_pause_pwd_status is '网银手机银行管理 密码状态：0:正常 7：重置网银密码 8：重置交易密码 9 : 柜面开户重置密码';
comment on column ${iol_schema}.scps_bp_personal_tb.tfr_encry_ind is '转加密标识  1:数字加字母组合 0:纯数字(柜面调用)';
comment on column ${iol_schema}.scps_bp_personal_tb.cfm_new_logon_pwd is '确认新登录密码';
comment on column ${iol_schema}.scps_bp_personal_tb.pwd_keyb_node_id is '密码键盘节点ID';
comment on column ${iol_schema}.scps_bp_personal_tb.safe_ceph_num is '安全手机号';
comment on column ${iol_schema}.scps_bp_personal_tb.dynamic_password_status is '个人动态密码状态 ： 0---开 1---关';
comment on column ${iol_schema}.scps_bp_personal_tb.pause_status is '网银/手机银行暂停/恢复 状态 0-正常 1-永久停止 2-临时暂停';
comment on column ${iol_schema}.scps_bp_personal_tb.dynamic_password_ind_id is '个人动态密码标识编号 1：查询 2：新增 3：修改 4: 删除';
comment on column ${iol_schema}.scps_bp_personal_tb.clous_shield_ind_id is '华兴云盾标识编号 1：设置密码 0：重置密码';
comment on column ${iol_schema}.scps_bp_personal_tb.deft_safe_instr is '默认安全工具 1：华兴U盾 2：手机短信密码';
comment on column ${iol_schema}.scps_bp_personal_tb.indv_act_status is '个人账户状态';
comment on column ${iol_schema}.scps_bp_personal_tb.acct_pause_rsns is '账户暂停原因';
comment on column ${iol_schema}.scps_bp_personal_tb.ntw_ceph_bank_pause_resu_status is '网银/手机银行暂停/恢复状态 0-正常 1-永久停止 2-临时暂停';
comment on column ${iol_schema}.scps_bp_personal_tb.pause_with_resu_oper_typ is '暂停/恢复操作类型 0-网银 1-手机银行 2-网银手机银行';
comment on column ${iol_schema}.scps_bp_personal_tb.temp_pause_start_tm is '临时暂停开始时间，格式为yyyyMMddHHmmss';
comment on column ${iol_schema}.scps_bp_personal_tb.temp_pause_cncl_tm is '临时暂停结束时间，格式为yyyyMMddHHmmss';
comment on column ${iol_schema}.scps_bp_personal_tb.ceph_cs_oper_typ is '手机盾信息操作类型 开通：0 停用：1 启用：2 注销：4';
comment on column ${iol_schema}.scps_bp_personal_tb.cs_ord_nbr is '云盾序号';
comment on column ${iol_schema}.scps_bp_personal_tb.open_br_node_num is '开通网点号';
comment on column ${iol_schema}.scps_bp_personal_tb.key_name is '密钥名称';
comment on column ${iol_schema}.scps_bp_personal_tb.total_cnt is '网银签约总笔数';
comment on column ${iol_schema}.scps_bp_personal_tb.reg_typ is '手机号码支付协议注册类型 DFLT 默认账户 NDFT 非默认账户';
comment on column ${iol_schema}.scps_bp_personal_tb.narrative1 is '备注';
comment on column ${iol_schema}.scps_bp_personal_tb.prest_flg is '赠送标志 0-正常开通 1-赠送开通';
comment on column ${iol_schema}.scps_bp_personal_tb.prest_mon is '赠送月份 如果是赠送服务（赠送标志为1），则填入赠送的月份数。没有此信息填空或“00”';
comment on column ${iol_schema}.scps_bp_personal_tb.vip_flg is 'VIP标志 0-非VIP服务， 1-VIP服务，（默认填0，如果操作员选择了VIP服务标志，则填1），VIP针对客户而言。';
comment on column ${iol_schema}.scps_bp_personal_tb.chrg_pkg_typ is '收费套餐类型 01包月/ 12包年。';
comment on column ${iol_schema}.scps_bp_personal_tb.chrg_mode is '收费模式 1-按账户数收费 2-按服务数收费 3-按短信条数收费 4-按定额收费';
comment on column ${iol_schema}.scps_bp_personal_tb.chrg_amt is '收费金额 请按字符串格式传输，如”RATE”:”0.56987” 当收费模式为定额收费时填写';
comment on column ${iol_schema}.scps_bp_personal_tb.disct is '折扣 客户收费折扣';
comment on column ${iol_schema}.scps_bp_personal_tb.disct_mon is '折扣月份 当存在折扣时，填写折扣有效月份，没有此信息则填空或00';
comment on column ${iol_schema}.scps_bp_personal_tb.acct_purp is '账户用途';
comment on column ${iol_schema}.scps_bp_personal_tb.acct_attr is '账户属性';
comment on column ${iol_schema}.scps_bp_personal_tb.agtsch_prd_id is '个人扣款协议-产品编号';
comment on column ${iol_schema}.scps_bp_personal_tb.agtsch_prd_type is '个人扣款协议  C-签约U-维护D-解约';
comment on column ${iol_schema}.scps_bp_personal_tb.payer_acct is '付款人账号';
comment on column ${iol_schema}.scps_bp_personal_tb.payer_acct_typ is '付款人账户类型';
comment on column ${iol_schema}.scps_bp_personal_tb.payer_act_nm is '付款人账户户名';
comment on column ${iol_schema}.scps_bp_personal_tb.payer_cert_typ is '付款人证件类型';
comment on column ${iol_schema}.scps_bp_personal_tb.payer_cert_num is '付款人证件号';
comment on column ${iol_schema}.scps_bp_personal_tb.payer_ceph_num is '付款人手机号';
comment on column ${iol_schema}.scps_bp_personal_tb.payer_bank is '付款人开户行行号';
comment on column ${iol_schema}.scps_bp_personal_tb.rcver_acct_typ is '收款人账户类型';
comment on column ${iol_schema}.scps_bp_personal_tb.payee_base_acct_no is '收款人账号';
comment on column ${iol_schema}.scps_bp_personal_tb.rcver_act_nm is '收款人账户户名';
comment on column ${iol_schema}.scps_bp_personal_tb.chn_num is '渠道号';
comment on column ${iol_schema}.scps_bp_personal_tb.sign_dtl is '签约明细';
comment on column ${iol_schema}.scps_bp_personal_tb.dsp_trnamt is '转存周期 Y    年 Q    季 M    月 W    周 D    天';
comment on column ${iol_schema}.scps_bp_personal_tb.redep_start_dt is '转存起始日期';
comment on column ${iol_schema}.scps_bp_personal_tb.redep_end_dt is '转存截止日期';
comment on column ${iol_schema}.scps_bp_personal_tb.pause_flg is '暂停标志 0 否 1 是';
comment on column ${iol_schema}.scps_bp_personal_tb.node_num is '节点号';
comment on column ${iol_schema}.scps_bp_personal_tb.third_chg_sign_prd is '签约产品 SV014银银合作代理第三方存管协议';
comment on column ${iol_schema}.scps_bp_personal_tb.agt_typ is '协议类型CLD-存立得 DC-大额存单 DLS-贷利省 HQB-活期宝 JDL-加多利 KDT-卡贷通 KYD-卡易贷 PCP-资金池 WDL-稳得利 XDB-协定宝 XDCK-协定存款产品 XDL-先得利 YBWL-一本万利 YCD-英才贷 YDT-易贷通 YHT-一户通 ZHY-周享赢 ZXY-坐享其盈 ZZB-至尊宝 LOA-贷款 ODF-法人透支协议 FIN-卡理财协议 SMS-短信 PKG-费用套餐 FEE-暂不收费 PCD-周期性强制扣划 ACC-协定存款协议 SWP-账户清扫协议 ID-智能存款协议 SL-金额补足协议 REC-回单签约 ES-电票签约 YD-约定 NTE-活期智能存款 PAS-隐私账户签约 TXY1-同兴赢活期签约 TXY2-跨境资金融入签约 CXDT-储蓄定投 TBCK-跳板存款 LHY-灵活盈 P2P-P2P协议 JZG-建筑港 ZCG-资产存管 ZQS-资金清算 LYE-财政零余额';
comment on column ${iol_schema}.scps_bp_personal_tb.agt_id is '协议编号';
comment on column ${iol_schema}.scps_bp_personal_tb.agt_status_cd is '协议状态 普通协议使用，可应用于大部分场景，贷款模块用于资产证券化合同状态A-生效 E-失效 YB-赎回 YS-发行 YP-已封包 NP-未封包 NS-未发行 YC-已撤包';
comment on column ${iol_schema}.scps_bp_personal_tb.st_dt is '开始日期';
comment on column ${iol_schema}.scps_bp_personal_tb.end_dt_ora is '结束日期';
comment on column ${iol_schema}.scps_bp_personal_tb.sign_prod_type is '签约产品类型';
comment on column ${iol_schema}.scps_bp_personal_tb.remain_amt is '协议留存金额 请按字符串格式传输，如”RATE”:”0.56987” 协议留存金额';
comment on column ${iol_schema}.scps_bp_personal_tb.start_amt is '起始金额 请按字符串格式传输，如”RATE”:”0.56987” 起始金额';
comment on column ${iol_schema}.scps_bp_personal_tb.transfer_freq_type is '划转频率类型 Y-年 Q-季 M-月 W-周 D-日';
comment on column ${iol_schema}.scps_bp_personal_tb.acct_movt_date is '转存交易日期';
comment on column ${iol_schema}.scps_bp_personal_tb.peri is '存期';
comment on column ${iol_schema}.scps_bp_personal_tb.term_type is '期限单位 Y-年 Q-季 M-月 W-周 D-日';
comment on column ${iol_schema}.scps_bp_personal_tb.acct_exec is '银行客户经理';
comment on column ${iol_schema}.scps_bp_personal_tb.transfer_end_date is '转存结束日期';
comment on column ${iol_schema}.scps_bp_personal_tb.transfer_day is '划转日';
comment on column ${iol_schema}.scps_bp_personal_tb.transfer_freq is '划转频率';
comment on column ${iol_schema}.scps_bp_personal_tb.fin_fixed_amt is '理财固定金额 请按字符串格式传输，如”RATE”:”0.56987”';
comment on column ${iol_schema}.scps_bp_personal_tb.min_depo_amt is '最小起存金额 请按字符串格式传输，如”RATE”:”0.56987” 最小起存金额';
comment on column ${iol_schema}.scps_bp_personal_tb.opt_type is '资管信托代销协议操作类型 01签约 02解约 03维护';
comment on column ${iol_schema}.scps_bp_personal_tb.matn_oper_typ is '维护操作类型 0-客户信息维护 1-客户经理代码维护';
comment on column ${iol_schema}.scps_bp_personal_tb.actl_benef is '实际受益人 0-本人（默认） 1-他人';
comment on column ${iol_schema}.scps_bp_personal_tb.wthr_exist_actl_ctrl_rela is '是否存在实际控制关系 0-否（默认） 1-是';
comment on column ${iol_schema}.scps_bp_personal_tb.wthr_is_np_integrity_rec is '是否有不良诚信记录 0-否（默认） 1-是';
comment on column ${iol_schema}.scps_bp_personal_tb.ori_pty_mgr_cd is '原客户经理代码';
comment on column ${iol_schema}.scps_bp_personal_tb.new_pty_mgr_cd is '新客户经理代码';
comment on column ${iol_schema}.scps_bp_personal_tb.pty_mgr_adj_flg is '客户经理调整标志 0－全部（将原客户经理替换成新客经理） 1－调整客户所属客户经理代码 2－理财账号客户经理代码 3－按流水客户经理 4－调整定投客户经理代码 5－调整定赎客户经理代码 8－调整客户对应所有客户经理';
comment on column ${iol_schema}.scps_bp_personal_tb.spec_seq_num is '指定流水号';
comment on column ${iol_schema}.scps_bp_personal_tb.enro_ceph_num is '注册手机号';
comment on column ${iol_schema}.scps_bp_personal_tb.acct_typ is '账户类型 01 - 为Ⅰ类户（非信用卡） 02 - 为Ⅱ类户 03 - 为Ⅲ类户 04-准贷记卡 05-借贷合一卡 不填-信用卡';
comment on column ${iol_schema}.scps_bp_personal_tb.zone_num is '地区码 建议需求方至少定位到省市、直辖市级地区区位。默认为0000，长度为4 位';
comment on column ${iol_schema}.scps_bp_personal_tb.scene_num is '云闪付场景码';
comment on column ${iol_schema}.scps_bp_personal_tb.card_prd_id is '卡产品编号';
comment on column ${iol_schema}.scps_bp_personal_tb.txn_equip_info is '交易设备信息';
comment on column ${iol_schema}.scps_bp_personal_tb.put_new_fld is '拉新字段';
comment on column ${iol_schema}.scps_bp_personal_tb.cvn_num is 'CVN码';
comment on column ${iol_schema}.scps_bp_personal_tb.valid_dt is '有效期';
comment on column ${iol_schema}.scps_bp_personal_tb.bcs_res_ceph_num_flg is '核心预留手机号标志 1代表是核心预留手机号 0代表非核心预留手机号';
comment on column ${iol_schema}.scps_bp_personal_tb.short_lett_srv_type is '短信服务类 短信服务类，以逗号分隔（A,B）';
comment on column ${iol_schema}.scps_bp_personal_tb.ceph_num_app_scope is '手机号码应用范围 1-只修改该账号下对应的手机号码 2-修改客户所有账号对应的手机号码，填1时必须填写签约账号';
comment on column ${iol_schema}.scps_bp_personal_tb.old_ceph_num is '旧手机号码';
comment on column ${iol_schema}.scps_bp_personal_tb.new_ceph_num is '新手机号码';
comment on column ${iol_schema}.scps_bp_personal_tb.ceph_num_qty is '手机号码个数';
comment on column ${iol_schema}.scps_bp_personal_tb.direct_sign_matn_flg is '定向转账签约维护标志 0-解约, 1-更新, 2-签约';
comment on column ${iol_schema}.scps_bp_personal_tb.direct_sign_typ is '定向转账签约类型 0-综合柜面, 1-流程银行';
comment on column ${iol_schema}.scps_bp_personal_tb.ghb_out_ind is '行内外标识 0-行内 1-行外';
comment on column ${iol_schema}.scps_bp_personal_tb.bank_id is '银行编号';
comment on column ${iol_schema}.scps_bp_personal_tb.bank_name is '银行名称';
comment on column ${iol_schema}.scps_bp_personal_tb.provin_cd is '省份代码';
comment on column ${iol_schema}.scps_bp_personal_tb.city_cd is '城市代码';
comment on column ${iol_schema}.scps_bp_personal_tb.rcv_open_brch_id is '收款方开户网点编号';
comment on column ${iol_schema}.scps_bp_personal_tb.rcv_open_brch_name is '收款方开户网点名称';
comment on column ${iol_schema}.scps_bp_personal_tb.rcver_ceph_num is '收款人手机号码';
comment on column ${iol_schema}.scps_bp_personal_tb.recv_acct_upda_flg is '收款账户更新标志 收款账户更新标志0：删除 1：更新,2：增加（SIGNUPDATEFLAG=0时，系统默认0，SIGNUPDATEFLAG=2时，系统默认为2）';
comment on column ${iol_schema}.scps_bp_personal_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_personal_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_personal_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_personal_tb.etl_timestamp is 'ETL处理时间戳';
