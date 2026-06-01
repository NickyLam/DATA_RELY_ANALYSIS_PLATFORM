/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_personal_tb
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.scps_bp_personal_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_personal_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_personal_tb_op purge;
drop table ${iol_schema}.scps_bp_personal_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_personal_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_personal_tb where 0=1;

create table ${iol_schema}.scps_bp_personal_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_personal_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_personal_tb_cl(
            id -- 逻辑主键
            ,process_inst_id -- 
            ,main_flow_id -- 
            ,scan_seq_no -- 流水号
            ,fr_org_code -- 前台机构编码
            ,tr_date -- 客户开户日期
            ,biz_code -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
            ,voucher_no -- 凭证号码
            ,cust_id -- 客户编号
            ,cust_name -- 客户名称
            ,english_name -- 客户英文名称
            ,sex -- 性别
            ,cert_type -- 证件类型[代码0009][A-公民身份号码B-军官证C-解放军文职干部证D-警官证E-解放军士兵证F-户口簿G-(港、澳)回乡证、通行证H-(台)通行证、其他有效旅行证I-(外国)护照J-(中国)护照K-武警文职干部证L-武警士兵证P-全国组织机构代码Q-海外客户编号R-营业执照号码X-其它有效证件Z-其它]
            ,cert_code -- 证件号码
            ,crt_cert_organ -- 发证机关地区代码
            ,birthday -- 出生日期
            ,weblock_flag -- 婚姻状况[代码0007][10-未婚 20-已婚 21-初婚 22-再婚 23-复婚 40-离婚 90-未说明的婚姻状况 30-丧偶5-已婚有子女6-已婚无子女7-其他]
            ,education -- 学历
            ,occupation -- 职业[代码0048][]
            ,rank -- 职务
            ,income -- 月收入[代码0046][1-1500以下 2-1500到2000 3-2000到3000 4-3000到5000 5-5000到8000 6-8000到10000 7-10000到30000 8-30000以上]
            ,company -- 工作单位名称
            ,home_address -- 家庭地址
            ,fix_telephone -- 固定电话
            ,office_phone -- 办公电话
            ,home_phone -- 家庭电话
            ,mobile -- 移动电话
            ,contact_address -- 联系地址
            ,postcode -- 邮政编码
            ,acct_type -- 交易对手账户类型
            ,spec_type -- 存款账户类型
            ,sf_scp_flag -- 通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]
            ,curr_type -- 币种[代码T003][参考CFG_T_CURRENCY_TYPE]
            ,cf_flag -- 钞汇鉴别[代码0011][0-钞1-汇]
            ,fee_drw_type -- 费用支取别[代码0012][0-不收1-现金2-转账]
            ,spec_time -- 存期
            ,amount -- 金额
            ,biz_password -- 交易密码
            ,biz_account -- 交易账号
            ,open_acct_password -- 开户密码
            ,tr_account -- 转帐账号
            ,tr_password -- 转账密码
            ,attor_opr_code -- 客户经理编号
            ,attor_opr_name -- 客户经理姓名
            ,attor_org_code -- 客户经理所在网点
            ,level_b_pin -- 前台机构编码
            ,fr_tlr_opr_no -- 前台柜员号
            ,puc_check_flag -- 人行核查标志[代码0039][0-不用人行核查1-人行核查]
            ,check_option -- 身份核查意见
            ,check_remark -- 身份核查意见备注
            ,check_opr_code -- 核查操作员
            ,puc_chk_date -- 人行身份核查时间
            ,update_flag -- 客户信息更新标志
            ,check_status -- 审批状态
            ,check_fall_reason -- 审批未通过原因
            ,succ_flag -- 成功标志
            ,status -- 流程状态
            ,home_addr_type -- 住宅类型[代码0106][1-自置2-公积金贷款3-商业贷款4-租用5-其他]
            ,company_type -- 单位性质[代码0107][01-国家机关02-事业单位03-国有企业04-私营，民营企业05-中外合资，合作，外资企业06-其他]
            ,obtain_opr_code -- 任务获取柜员号
            ,commission -- 代办事由
            ,email -- 邮箱
            ,often_site -- 经常居住地
            ,relation -- 与被代理人关系
            ,nationality -- 国籍
            ,pro_name -- 代理人姓名(中文)
            ,pro_type -- 代理人证件类型
            ,pro_fashion -- 代理人联系方式
            ,is_porxy -- 是否代办(0 否 1 是)
            ,accept_no -- 受理号(任务号)
            ,trane_code -- 交易代码
            ,idtfna_name -- 证件姓名
            ,pro_cert_code -- 代理人证件号码
            ,is_net_silver_contract -- 是否操作网银(0-否 1-是)
            ,open_flag -- 开户标志(0:无卡介质也无客户信息,1:有卡介质的2:无卡介质，但在我行有客户信息)
            ,group_flag -- 分组标志(预留扩展，暂时送99)
            ,netb_passwd -- 网银初始登录密码
            ,netb_left_msg -- 预留信息
            ,netb_sign_mobile -- 签约手机号码
            ,netb_sec_model -- 安全工具型号(0-飞天  1-捷德)
            ,netb_sec_type -- 安全工具类型(0-个人，1-企业)
            ,netb_sec_no -- 安全工具编号
            ,netb_dynamic_opt_no -- 动态口令编号
            ,netb_dynamic_card_no -- 口令卡编号
            ,netb_is_transfer -- 账号开通权限(0-查询 1-转账)
            ,netb_ac_limit_pertrs -- 账户级单笔限额
            ,netb_ac_limit_perday -- 账户级日累计限额
            ,cert_date -- 证件到期日
            ,id_address -- 户籍地址
            ,is_sms_contract -- 是否操作短信通(0-否 1-是)
            ,is_tel_n_trnsf -- 非定向转账是否开通（1-开通）
            ,is_tel_n_trnsf_default_limit -- 非定向转账默认额度（1-默认额度）
            ,tel_n_trnsf_single_limit -- 非定向转账单笔额度
            ,tel_n_trnsf_day_limit -- 非定向转账单日额度
            ,is_tel_d_trnsf -- 定向转账是否开通（1-开通）
            ,is_tel_d_trnsf_no_limit -- 定向转账无限额度（1-无限额）
            ,tel_d_trnsf_single_limit -- 定向转账单笔额度
            ,tel_d_trnsf_day_limit -- 定向转账单日额度
            ,payee_name1 -- 定向转账收款人全称1
            ,payee_accno1 -- 定向转账收款人账号1
            ,payee_bank_name1 -- 定向转账开户银行全称1
            ,payee_name2 -- 定向转账收款人全称2
            ,payee_accno2 -- 定向转账收款人账号2
            ,payee_bank_name2 -- 定向转账开户银行全称2
            ,sms_notice_limit -- 账户变动短信通知起点金额
            ,sec_node_id -- 加密结点号
            ,proxy_sex -- 代理人性别
            ,proxy_idtdt -- 证件失效日期
            ,proxy_id_address -- 代理人证件地址
            ,sms_contract_if_succeed -- 短信通签约是否成功(0-失败 1-成功)
            ,net_silver_contract_succeed -- 网银签约是否成功(0-失败 1-成功)
            ,is_netb_default_limit -- 网银签约是否默认限额(1-是)
            ,prsntg -- 居民性质代码
            ,staffflag -- 员工标志(默认0)
            ,custlv -- 客户级别(默认00)
            ,risklv -- 客户风险承受能力评估等级（1-保守型 2-谨慎型 3-稳健型 4-进取型 5-激进型）
            ,wkutad -- 工作单位地址
            ,roleid -- 职称等级
            ,worktx -- 其他职业
            ,csec_node_id -- 转加密结点号
            ,netb_csec_passwd -- 转加密网银初始密码
            ,transfer_channel -- 转账渠道（1-手机银行定向转账2-电话银行定向转账）
            ,mobile_ac_limit_pertrs -- 手机银行账户级单笔限额
            ,mobile_ac_limit_perday -- 手机银行账户级日累计限额
            ,is_mobile_default_limit -- 手机银行是否默认限额(1-是)
            ,fax -- 传真
            ,area_code -- 地区代码
            ,truth_flag -- 实名标志
            ,trnamt -- 转存金额
            ,voucherty -- 凭证类型    738-华兴卡 741-借记芯片卡
            ,id_check_result -- 身份证联网核查结果[00-公民身份证号码与姓名一致，且存在照片01-公民身份证号码与姓名一致，但不存在照片02-公民身份号码存在，但与姓名不匹配03-公民身份号码不存在04-其他错误]
            ,mobile_open_status -- 移动业务审批状态 0处理中 1审批通过 2审批不通过(开卡、网银签约、短信通签约)
            ,account_update_flag -- 账户更新标志[0：删除 1：更新 2：增加 为空表示不操作账户]
            ,submit_status -- 移动综合签约提交状态[提交锁定字段 0：未处理1：处理中2：提交成功]
            ,netb_biz_type -- 网银签约业务类型[0：新增1：变更]
            ,often_site_eq_id_addr -- 经常居住地同身份证件地址（0否 1是）
            ,net_ukey -- 开通华兴U盾（0否 1是2关联）
            ,card_type -- 卡产品
            ,card_rank -- 卡等级
            ,is_finance_contract -- 是否操作理财(0-否 1-是)
            ,sendfreq -- 对账单发送频率[0-有交易发生寄送1-不寄送2-按月3-按季4-半年5-一年]
            ,sendmode -- 对账单寄送方式(共8个字符，每个字符代表一种交易手段，其含义为：第1位：邮寄第2位：传真第3位：E-mail第4位：短消息第5~8位：保留。每位字符取1表示采用此种手段，取0表示不使用)
            ,risklevel -- 理财产品风险等级（0-未评定 1-低风险2-较低风险3-中风险4-较高风险5-高风险）
            ,clientgroup -- 客户分组[a-	群客户Z- 其他客户]
            ,chnlflag -- 高风险产品柜台以外渠道允许购买标志(0-不允许 1-允许 默认0)
            ,finance_contract_succeed -- 理财签约是否成功(0-失败 1-成功)
            ,finance_acctno -- 理财签约账号
            ,open_brcno -- 开卡机构
            ,cust_mgrno -- 客户经理代码
            ,sms_cust_sign -- 短信通客户是否已签约(0:未签约1:已签约)
            ,fee_acct_no -- 扣费账号
            ,fee_acct_brcno -- 扣费账号分行号
            ,fee_acct_nodeno -- 扣费账号行所号
            ,contact_phone -- 联系手机号码
            ,attbrn -- 业务归属机构
            ,new_password -- 新交易密码
            ,new_account -- 新账号
            ,chactg -- 更换类型
            ,stpytg -- 挂失类型
            ,rplsfs -- 挂失形式
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,netopflag -- 网银操作类型[0-开通1-维护 2-解约（注销）3-暂停4-恢复5开通以下服务]
            ,smsopflag -- 短信通操作类型[0-签约 1-解约 2-短信通手机号码新增 3-短信通手机号码修改 4-短信通手机号码取消]
            ,finopflag -- 理财操作类型[0-签约  1-解约 2-更换账户  3-银行帐号登记取消]
            ,delukey -- 是否删除Ukey(0-否 1-是)
            ,bgnamt -- 短信通知起点金额
            ,trtmrs -- 核实结果  01未核实，02真实
            ,loss_date -- 挂失日期(yyyymmdd)
            ,loss_reg_no -- 挂失登记号
            ,undays -- 挂失天数    临时挂失5天，正式挂失7天
            ,payway -- 支取方式 S-凭印鉴支取 P-凭密码支取 W-无密码无印鉴支取 B-凭印鉴和密码支取 O-凭证件支取 R-支付密码器和印鉴
            ,is_fund_contract -- 是否操作基金(0-否 1-是)
            ,fundopflag -- 基金操作类型[ 1-开通 2-银行卡号变更 3-解约]
            ,fin_manager_id -- 理财经理编号
            ,szsecno -- 深交所证券账号
            ,shsecno -- 上交所证券账号
            ,minorflag -- 是否成年人标志 1-否，0-是
            ,fundnewacct -- 基金新银行卡号
            ,fund_contract_if_succeed -- 基金签约操作是否成功(0-失败 1-成功)
            ,is_third_manage_contract -- 是否三方存管签约操作
            ,cobank -- 合作行
            ,ori_acct -- 三方存管原结算账号
            ,ori_brcode -- 三方存管原结算账号开户机构
            ,bond_acct -- 证券资金台账账号
            ,bond_pass -- 证券资金台账密码
            ,bond_code -- 券商代码
            ,bond_name -- 券商名称
            ,third_manage_if_succeed -- 三方存管签约操作是否成功(0-失败 1-成功)
            ,is_invest_contract -- 是否储蓄定投签约操作 0-否，1-是
            ,invest_opflag -- 储蓄定投操作类型 1-签约 2-维护 3-解约
            ,invest_contract_if_succeed -- 储蓄定投签约操作是否成功(0-失败 1-成功)
            ,is_quickin_contract -- 是否灵活盈签约操作 0-否，1-是
            ,quickin_opflag -- 灵活盈签约操作类型 1-签约 2-维护 3-解约
            ,chan_save_tp -- 转存类型 1-活期转双整 2-活期转通知
            ,chan_save_deadline -- 灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年
            ,chan_save_amt -- 转存起点金额
            ,save_low_amt -- 最低留存金额
            ,quickin_contract_if_succeed -- 灵活盈签约操作是否成功(0-失败 1-成功)
            ,sign_type -- 签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5
            ,third_ma_apply_tp -- 三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
            ,third_ma_new_acct -- 三方存管新账号
            ,is_acctfund_contract -- 基金代销账户类签约操作 0-否，1-是
            ,acctfund_sign_type -- 基金代销账户类签约种类 1-签约2-解约3-维护
            ,is_bill_send -- 对账单寄送要求 1-寄送0-不寄送
            ,acctfund_ori_acct -- 交易账户变更原账号 默认前“签约账号”项
            ,is_tradefund_contract -- 基金代销交易类签约操作 0-否，1-是
            ,tradefund_sign_type -- 基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更
            ,tradefund_name -- 基金名称
            ,tradefund_code -- 基金代码
            ,savings_invest_optp -- 储蓄定投操作类型 1-终止 2-暂停 3-恢复
            ,time_invest_code -- 定投编号
            ,third_manage_optp -- 三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]
            ,fund_acct -- 基金签约操作账号
            ,fund_acct_brcno -- 基金签约账号开卡网点
            ,quickin_leave_amt -- 灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)
            ,quickin_leave_amt_other -- 灵活盈—活期账户留存金额_其它
            ,netb_op_choice -- 网银修改服务选项(1登录密码 2手机动态密码)
            ,netb_password_optp -- 网银登录密码操作类型(1重置 2解锁)
            ,netb_netphone_optp -- 手机动态密码操作类型(0-不开通1开通2注销3指定手机号4变更手机号5关联)
            ,ukey_optp -- 华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)
            ,is_sms_set_phone -- 短信通是否设置签约手机号 0-否，1-是
            ,is_net_trans_limit_set -- 是否网银转账限额设置 0-否，1-是
            ,is_mob_trans_limit_set -- 手机银行是否非定向转账限额设置 0-否，1-是
            ,direct_trans_optp -- 定向转账操作类型[1开通2修改3注销]
            ,is_direct_trans_ac_set -- 是否定向收款账户设置[0-否，1-是]
            ,sms_set_phone_optp -- 短信通设置签约手机号操作类型[1-开通 3-注销]
            ,fin_new_acct -- 理财银行卡号变更新账号
            ,fin_new_open_brcno -- 理财银行卡号变更新账号所属机构
            ,quickin_pass -- 灵活盈交易密码(带账号转加密)
            ,cust_changes -- 客户信息变更内容1.通讯地址2.邮政编码3.联系电话4.手机5.EMAIL
            ,tlr_mobile -- 前台柜员手机号码
            ,deposit_trade_no -- 交易单编号
            ,acct_type_m -- 账号类型:0: 人民币个人非结算户1: 人民币个人结算户A: 外汇结算账户B: 乙种储蓄存款账户C: 丙种储蓄存款账户
            ,dsp_type -- 储种:S01储蓄活期S02	储蓄双整S03	零存整取S04	整存零取S05	存本取息S06	定活两便S07	储蓄通知S08	教育储蓄S18:财富宝
            ,dsp_period -- 存期:203-三个月、206-六个月、301-一年、302-二年、303-三年、305-五年、000-活期、101-一天、107-七天 、203-三个月、206-六个月、301-一年
            ,dsp_flag -- 转存标识:1:自动转存0:非自动转存
            ,tran_type -- 交易类型:CO-现开TO-转开
            ,to_acct_no -- 转出账号
            ,to_acct_name -- 转出账号名称
            ,to_pswd -- 转出账号密码
            ,to_idtp -- 转出证件类型:A:身份证,B:外国公民护照,C:户口薄,D:港澳居民通行证,E:还乡证,F:边民出入境通行证,G:军官证,H:士兵证,I:军事院校学员证,J:军队离休干部荣誉证,K:军官退休证,L:军人文职干部退休证,P:其他,Q:武警身份证,R:台湾居民通行证,S:中国公民护照,U:临时身份证
            ,to_idno -- 转出证件号码
            ,to_dwfs -- 转出支取方式：A:密码 D:印鉴 E:证件
            ,prcsna -- 交易类型
            ,nwinrt -- 利率
            ,matudt -- 到期日
            ,valuedt -- 起息日
            ,proxy_flag -- 代办人类型（0-否 1-监护代理 2-普通代理）
            ,quickin_type -- 灵活盈-储种（1-三个月 2-六个月 3-一年 4-二年 5-三年 6-五年 7-不约定存期 8-七天通知）
            ,acctlv -- 账户分类
            ,is_card -- 是否有卡
            ,regoresult -- 1识别失败，0识别成功
            ,similarity -- 0%~100%，>=80%为认定为本人
            ,issetnewpwd -- 是否设置新密码
            ,isfcfnoper -- 是否操作非柜面非同名限额签约(0-否,1-是)
            ,isfcfntype -- 非柜面非同名账户限额签约操作类型(0-签约 1-维护)
            ,isfcfnct -- 是否非柜面非同名账户限额签约(0-否,1-是)
            ,daylimit -- 日累计限额(非柜面非同名账户限额签约)
            ,txntimeslimit -- 日笔数限额(非柜面非同名账户限额签约)
            ,yearlimit -- 年累计限额(非柜面非同名账户限额签约)
            ,is_fcfnct_succeed -- 非柜面非同名账户限额签约是否成功(0-失败,1-成功)
            ,agreementid -- ECIF签约协议号
            ,custom_daylimit -- 自定义-日累计限额(万元)
            ,custom_txntimeslimit -- 自定义-日累计笔数
            ,custom_yearlimit -- 自定义-年累计限额(万元)
            ,pro_nationality -- 代理人国籍
            ,mobile_type -- 号码性质 0--本人1--监护人
            ,outflg -- 外出标注-0，默认网点0：网点凭证 1：外出凭证
            ,netstate -- 网银密码重置--状态默认送0
            ,logonpwnew -- 网银密码重置--新登陆密码
            ,netreset -- 是否网银密码重置
            ,relativetp -- 监护人/亲属证件类型
            ,relativena -- 监护人/亲属姓名
            ,relativeno -- 监护人/亲属号码
            ,taxresident -- 税收居民身份（1仅为中国税收居民2仅为非居民3既是中国税收居民又是其他国家（地区）税收居民4无需声明5空）
            ,birthplace -- 纳税人出生地（中英文字符）
            ,taxarea -- 税收居民国（地区）
            ,taxnumber -- 纳税人识别号
            ,taxarea2 -- 纳税居民国家（地区）2（发送报文时整合在TAXAREA）
            ,taxarea3 -- 纳税居民国家（地区）3（发送报文时整合在TAXAREA）
            ,taxnumber2 -- 纳税人识别号2（发送报文时整合在TAXNUMBER）
            ,taxnumber3 -- 纳税人识别号3（发送报文时整合在TAXNUMBER）
            ,taxnullreason -- 纳税人识别号为空原因
            ,taxstatement -- 是否取得自证声明（0-未取得自证声明1-取得自证声明）
            ,customersurname -- 客户_姓（字母）
            ,customergivenname -- 客户_名（字母）
            ,taxnullreason2 -- 纳税人识别号为空原因2
            ,taxnullreason3 -- 纳税人识别号为空原因3
            ,boundaccno -- 绑定账号
            ,boundbank -- 绑定账号开户行
            ,checkcase -- 落地审核原因
            ,ocridtdt -- 证件生效日期
            ,yflag -- 手机盾标志 Y:为是手机盾，N:为不是手机盾
            ,phoneoperate -- 手机盾操作类型0：开通
            ,camp_emp_id -- 营销工号
            ,notemessagephone1 -- 短信通签约号码1
            ,notemessagephone2 -- 短信通签约号码2
            ,notemessagephone3 -- 短信通签约号码3
            ,notemessagephone4 -- 短信通签约号码4
            ,notemessagephone5 -- 短信通签约号码5
            ,isagtsch -- 是否个人扣款协议签约(0-否,1-是)
            ,proxy_idtdt_sl -- 是否云闪付绑定签约
            ,is_flashpay_contract -- 云闪付绑定签约是否成功  0-失败 1-成功
            ,flashpay_contract_if_succeed -- 
            ,local_ip -- 开户IP
            ,local_mac -- 开户MAC
            ,uuid -- UUID
            ,ukey_modify_if_succeed -- U盾管理状态
            ,is_send_message -- 是否发送营销短信
            ,phonepay_contract_if_succeed -- 手机转账签约是否成功(0-失败 1-成功)
            ,is_phonepay_contract -- 是否手机转账签约(0-否 1-是)
            ,regedittype -- 登记注册类型
            ,sco -- 
            ,is_phonepay_contract1 -- 是否手机转账签约(0-否 1-是)
            ,phonepay_contract_if_succeed1 -- 手机转账签约是否成功(0-失败 1-成功)
            ,regedittype1 -- 登记注册类型
            ,limit_oper_type -- 非柜面签约
            ,limit_oper_channel -- 
            ,day_transfer_count -- 非柜面签约-日总笔数
            ,day_transfer_amount -- 非柜面签约-日总限额
            ,year_transfer_count -- 非柜面签约-年总笔数
            ,year_transfer_amount -- 非柜面签约-年总限额
            ,limit_oper_result -- 
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 记账失败
            ,agt_num -- 协议号
            ,dspbgndt -- 转存起始日期
            ,dspenddt -- 转存截止日期
            ,dsptyper -- 转存类型 1 转存双整 2 转存通知
            ,invest_account -- 储蓄定投签约账户
            ,invest_trnamt -- 转存金额
            ,prd_id -- 产品编号
            ,quickin_agreement_id -- 灵活盈协议编号
            ,quickin_agreement_status -- 灵活盈协议状态
            ,quickin_agreement_type -- 灵活盈协议类型
            ,quickin_fin_fixed_amt -- 灵活盈理财固定金额
            ,quickin_int_min_amt -- 灵活盈最小起存金额
            ,quickin_remain_amt -- 灵活盈协议留存金额
            ,quickin_start_amt -- 灵活盈起始金额
            ,quickin_transfer_day -- 划转日
            ,quickin_transfer_freq -- 灵活盈划转频率
            ,redep_freq -- 转存频率
            ,renew_corp -- 转存单位
            ,rpdsp -- 转存周期 Y-年 Q-季 M-月 W-周 D-天
            ,sub_acct_num -- 子账号
            ,sum_sub_num -- 汇总子户号
            ,biz_type -- 业务种类
            ,biz_dt -- 交易日期（yyyy-MM-dd hh:mm:ss）
            ,finance_card_type -- 理财账户类型
            ,fin_new_acct_crspd_pty_id -- 新账号对应客户号
            ,custchnlid -- 开通渠道
            ,riskmonths -- 风险有效期月数
            ,rskcd -- 风险等级代码
            ,oper_flag -- 1 客户级 2账户级
            ,third_chg_card_id -- 三方存管换卡标识
            ,third_open_org_id -- 三方存管开户机构
            ,usb_key_cert_id -- USBKey证书编号
            ,old_cert_key_id -- 旧证书KEYID
            ,safe_instr_model -- 安全工具型号(0：飞天1：捷德)
            ,u_brch_num -- U盾网点号
            ,u_oper_typ -- U盾操作类型（2：注销 3：损坏更换 4：挂失更换 5：发放）
            ,wthr_out -- 是否出库 默认Y Y：是 N：否
            ,lost_operate_method -- 挂失操作方式，比如书面挂失、口头挂失UV-口头解挂 UW-正式解挂 VL-口挂 WL-书挂
            ,lost_no -- 账户/凭证/结算卡挂失号码
            ,acct_name -- 账户名称
            ,loss_id -- 挂失编号
            ,acct_seq_no -- 账户序列号
            ,acct_password -- 账户密码
            ,voucher_change_type -- 凭证更换类型，比如挂失补发、损坏更换等，不同的更换类型会对应不同的处理流程 01-挂失补发 02-凭证更换 03-损坏更换 04-同号换卡领卡/记名卡领卡 05-单位存单置换 06-单位存单收回如果补开、凭证更换必传
            ,new_vchr_typ -- 新凭证类型
            ,new_vchr_num -- 新凭证号码
            ,voucher_change_reason -- 更换原因
            ,td_inout_operate_type -- 存单移入必传 定期账户转入转出操作类型 01-转入 02-互转 03-转出
            ,in_base_acct_no -- 移入账号
            ,in_prod_type -- 转入账户产品类型
            ,enter_acct_ccy -- 转入账户币种
            ,target_acct_class -- 目标账户类别（一二三类户），即账户升级后的账户类别，满足人行对于电子账户的管理办法1-一类账户 2-二类账户 3-三类账户
            ,password_operate_type -- 账户密码操作类型 账户密码操作类型01-新建 02-重置 03-修改 04-解锁 05-校验 06-激活 07-凭证解挂场景密码重置 08-弱密码校验
            ,password_type -- 密码类型，目前核心只支持WD，接口未上送则默认为WDWD-支取密码 QY-查询密码 MA-账户管理密码
            ,password_old -- 旧密码
            ,iss_country -- 发证国家
            ,password_effect_date -- 密码生效日期
            ,lost_reason -- 挂失原因
            ,res_flag -- 标识挂失账户是N进行账户止付,挂失时必输，解挂时不需要输入Y-是 N-不是
            ,pause_post -- 暂停附言
            ,channel -- 渠道
            ,ntw_ceph_bank_pause_type -- 网银手机银行管理 业务类型 01：个人动态密码管理 02：解锁登录密码 03：网银/手机银行暂停/恢复 04：登录密码和用户状态重置 05：客户手机盾信息维护 06：账户暂停/恢复
            ,ntw_ceph_bank_pause_pwd_status -- 网银手机银行管理 密码状态：0:正常 7：重置网银密码 8：重置交易密码 9 : 柜面开户重置密码
            ,tfr_encry_ind -- 转加密标识  1:数字加字母组合 0:纯数字(柜面调用)
            ,cfm_new_logon_pwd -- 确认新登录密码
            ,pwd_keyb_node_id -- 密码键盘节点ID
            ,safe_ceph_num -- 安全手机号
            ,dynamic_password_status -- 个人动态密码状态 ： 0---开 1---关
            ,pause_status -- 网银/手机银行暂停/恢复 状态 0-正常 1-永久停止 2-临时暂停
            ,dynamic_password_ind_id -- 个人动态密码标识编号 1：查询 2：新增 3：修改 4: 删除
            ,clous_shield_ind_id -- 华兴云盾标识编号 1：设置密码 0：重置密码
            ,deft_safe_instr -- 默认安全工具 1：华兴U盾 2：手机短信密码
            ,indv_act_status -- 个人账户状态
            ,acct_pause_rsns -- 账户暂停原因
            ,ntw_ceph_bank_pause_resu_status -- 网银/手机银行暂停/恢复状态 0-正常 1-永久停止 2-临时暂停
            ,pause_with_resu_oper_typ -- 暂停/恢复操作类型 0-网银 1-手机银行 2-网银手机银行
            ,temp_pause_start_tm -- 临时暂停开始时间，格式为yyyyMMddHHmmss
            ,temp_pause_cncl_tm -- 临时暂停结束时间，格式为yyyyMMddHHmmss
            ,ceph_cs_oper_typ -- 手机盾信息操作类型 开通：0 停用：1 启用：2 注销：4
            ,cs_ord_nbr -- 云盾序号
            ,open_br_node_num -- 开通网点号
            ,key_name -- 密钥名称
            ,total_cnt -- 网银签约总笔数
            ,reg_typ -- 手机号码支付协议注册类型 DFLT 默认账户 NDFT 非默认账户
            ,narrative1 -- 备注
            ,prest_flg -- 赠送标志 0-正常开通 1-赠送开通
            ,prest_mon -- 赠送月份 如果是赠送服务（赠送标志为1），则填入赠送的月份数。没有此信息填空或“00”
            ,vip_flg -- VIP标志 0-非VIP服务， 1-VIP服务，（默认填0，如果操作员选择了VIP服务标志，则填1），VIP针对客户而言。
            ,chrg_pkg_typ -- 收费套餐类型 01包月/ 12包年。
            ,chrg_mode -- 收费模式 1-按账户数收费 2-按服务数收费 3-按短信条数收费 4-按定额收费
            ,chrg_amt -- 收费金额 请按字符串格式传输，如”RATE”:”0.56987” 当收费模式为定额收费时填写
            ,disct -- 折扣 客户收费折扣
            ,disct_mon -- 折扣月份 当存在折扣时，填写折扣有效月份，没有此信息则填空或00
            ,acct_purp -- 账户用途
            ,acct_attr -- 账户属性
            ,agtsch_prd_id -- 个人扣款协议-产品编号
            ,agtsch_prd_type -- 个人扣款协议  C-签约U-维护D-解约
            ,payer_acct -- 付款人账号
            ,payer_acct_typ -- 付款人账户类型
            ,payer_act_nm -- 付款人账户户名
            ,payer_cert_typ -- 付款人证件类型
            ,payer_cert_num -- 付款人证件号
            ,payer_ceph_num -- 付款人手机号
            ,payer_bank -- 付款人开户行行号
            ,rcver_acct_typ -- 收款人账户类型
            ,payee_base_acct_no -- 收款人账号
            ,rcver_act_nm -- 收款人账户户名
            ,chn_num -- 渠道号
            ,sign_dtl -- 签约明细
            ,dsp_trnamt -- 转存周期 Y    年 Q    季 M    月 W    周 D    天
            ,redep_start_dt -- 转存起始日期
            ,redep_end_dt -- 转存截止日期
            ,pause_flg -- 暂停标志 0 否 1 是
            ,node_num -- 节点号
            ,third_chg_sign_prd -- 签约产品 SV014银银合作代理第三方存管协议
            ,agt_typ -- 协议类型CLD-存立得 DC-大额存单 DLS-贷利省 HQB-活期宝 JDL-加多利 KDT-卡贷通 KYD-卡易贷 PCP-资金池 WDL-稳得利 XDB-协定宝 XDCK-协定存款产品 XDL-先得利 YBWL-一本万利 YCD-英才贷 YDT-易贷通 YHT-一户通 ZHY-周享赢 ZXY-坐享其盈 ZZB-至尊宝 LOA-贷款 ODF-法人透支协议 FIN-卡理财协议 SMS-短信 PKG-费用套餐 FEE-暂不收费 PCD-周期性强制扣划 ACC-协定存款协议 SWP-账户清扫协议 ID-智能存款协议 SL-金额补足协议 REC-回单签约 ES-电票签约 YD-约定 NTE-活期智能存款 PAS-隐私账户签约 TXY1-同兴赢活期签约 TXY2-跨境资金融入签约 CXDT-储蓄定投 TBCK-跳板存款 LHY-灵活盈 P2P-P2P协议 JZG-建筑港 ZCG-资产存管 ZQS-资金清算 LYE-财政零余额
            ,agt_id -- 协议编号
            ,agt_status_cd -- 协议状态 普通协议使用，可应用于大部分场景，贷款模块用于资产证券化合同状态A-生效 E-失效 YB-赎回 YS-发行 YP-已封包 NP-未封包 NS-未发行 YC-已撤包
            ,st_dt -- 开始日期
            ,end_dt_ora -- 结束日期
            ,sign_prod_type -- 签约产品类型
            ,remain_amt -- 协议留存金额 请按字符串格式传输，如”RATE”:”0.56987” 协议留存金额
            ,start_amt -- 起始金额 请按字符串格式传输，如”RATE”:”0.56987” 起始金额
            ,transfer_freq_type -- 划转频率类型 Y-年 Q-季 M-月 W-周 D-日
            ,acct_movt_date -- 转存交易日期
            ,peri -- 存期
            ,term_type -- 期限单位 Y-年 Q-季 M-月 W-周 D-日
            ,acct_exec -- 银行客户经理
            ,transfer_end_date -- 转存结束日期
            ,transfer_day -- 划转日
            ,transfer_freq -- 划转频率
            ,fin_fixed_amt -- 理财固定金额 请按字符串格式传输，如”RATE”:”0.56987”
            ,min_depo_amt -- 最小起存金额 请按字符串格式传输，如”RATE”:”0.56987” 最小起存金额
            ,opt_type -- 资管信托代销协议操作类型 01签约 02解约 03维护
            ,matn_oper_typ -- 维护操作类型 0-客户信息维护 1-客户经理代码维护
            ,actl_benef -- 实际受益人 0-本人（默认） 1-他人
            ,wthr_exist_actl_ctrl_rela -- 是否存在实际控制关系 0-否（默认） 1-是
            ,wthr_is_np_integrity_rec -- 是否有不良诚信记录 0-否（默认） 1-是
            ,ori_pty_mgr_cd -- 原客户经理代码
            ,new_pty_mgr_cd -- 新客户经理代码
            ,pty_mgr_adj_flg -- 客户经理调整标志 0－全部（将原客户经理替换成新客经理） 1－调整客户所属客户经理代码 2－理财账号客户经理代码 3－按流水客户经理 4－调整定投客户经理代码 5－调整定赎客户经理代码 8－调整客户对应所有客户经理
            ,spec_seq_num -- 指定流水号
            ,enro_ceph_num -- 注册手机号
            ,acct_typ -- 账户类型 01 - 为Ⅰ类户（非信用卡） 02 - 为Ⅱ类户 03 - 为Ⅲ类户 04-准贷记卡 05-借贷合一卡 不填-信用卡
            ,zone_num -- 地区码 建议需求方至少定位到省市、直辖市级地区区位。默认为0000，长度为4 位
            ,scene_num -- 云闪付场景码
            ,card_prd_id -- 卡产品编号
            ,txn_equip_info -- 交易设备信息
            ,put_new_fld -- 拉新字段
            ,cvn_num -- CVN码
            ,valid_dt -- 有效期
            ,bcs_res_ceph_num_flg -- 核心预留手机号标志 1代表是核心预留手机号 0代表非核心预留手机号
            ,short_lett_srv_type -- 短信服务类 短信服务类，以逗号分隔（A,B）
            ,ceph_num_app_scope -- 手机号码应用范围 1-只修改该账号下对应的手机号码 2-修改客户所有账号对应的手机号码，填1时必须填写签约账号
            ,old_ceph_num -- 旧手机号码
            ,new_ceph_num -- 新手机号码
            ,ceph_num_qty -- 手机号码个数
            ,direct_sign_matn_flg -- 定向转账签约维护标志 0-解约, 1-更新, 2-签约
            ,direct_sign_typ -- 定向转账签约类型 0-综合柜面, 1-流程银行
            ,ghb_out_ind -- 行内外标识 0-行内 1-行外
            ,bank_id -- 银行编号
            ,bank_name -- 银行名称
            ,provin_cd -- 省份代码
            ,city_cd -- 城市代码
            ,rcv_open_brch_id -- 收款方开户网点编号
            ,rcv_open_brch_name -- 收款方开户网点名称
            ,rcver_ceph_num -- 收款人手机号码
            ,recv_acct_upda_flg -- 收款账户更新标志 收款账户更新标志0：删除 1：更新,2：增加（SIGNUPDATEFLAG=0时，系统默认0，SIGNUPDATEFLAG=2时，系统默认为2）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_personal_tb_op(
            id -- 逻辑主键
            ,process_inst_id -- 
            ,main_flow_id -- 
            ,scan_seq_no -- 流水号
            ,fr_org_code -- 前台机构编码
            ,tr_date -- 客户开户日期
            ,biz_code -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
            ,voucher_no -- 凭证号码
            ,cust_id -- 客户编号
            ,cust_name -- 客户名称
            ,english_name -- 客户英文名称
            ,sex -- 性别
            ,cert_type -- 证件类型[代码0009][A-公民身份号码B-军官证C-解放军文职干部证D-警官证E-解放军士兵证F-户口簿G-(港、澳)回乡证、通行证H-(台)通行证、其他有效旅行证I-(外国)护照J-(中国)护照K-武警文职干部证L-武警士兵证P-全国组织机构代码Q-海外客户编号R-营业执照号码X-其它有效证件Z-其它]
            ,cert_code -- 证件号码
            ,crt_cert_organ -- 发证机关地区代码
            ,birthday -- 出生日期
            ,weblock_flag -- 婚姻状况[代码0007][10-未婚 20-已婚 21-初婚 22-再婚 23-复婚 40-离婚 90-未说明的婚姻状况 30-丧偶5-已婚有子女6-已婚无子女7-其他]
            ,education -- 学历
            ,occupation -- 职业[代码0048][]
            ,rank -- 职务
            ,income -- 月收入[代码0046][1-1500以下 2-1500到2000 3-2000到3000 4-3000到5000 5-5000到8000 6-8000到10000 7-10000到30000 8-30000以上]
            ,company -- 工作单位名称
            ,home_address -- 家庭地址
            ,fix_telephone -- 固定电话
            ,office_phone -- 办公电话
            ,home_phone -- 家庭电话
            ,mobile -- 移动电话
            ,contact_address -- 联系地址
            ,postcode -- 邮政编码
            ,acct_type -- 交易对手账户类型
            ,spec_type -- 存款账户类型
            ,sf_scp_flag -- 通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]
            ,curr_type -- 币种[代码T003][参考CFG_T_CURRENCY_TYPE]
            ,cf_flag -- 钞汇鉴别[代码0011][0-钞1-汇]
            ,fee_drw_type -- 费用支取别[代码0012][0-不收1-现金2-转账]
            ,spec_time -- 存期
            ,amount -- 金额
            ,biz_password -- 交易密码
            ,biz_account -- 交易账号
            ,open_acct_password -- 开户密码
            ,tr_account -- 转帐账号
            ,tr_password -- 转账密码
            ,attor_opr_code -- 客户经理编号
            ,attor_opr_name -- 客户经理姓名
            ,attor_org_code -- 客户经理所在网点
            ,level_b_pin -- 前台机构编码
            ,fr_tlr_opr_no -- 前台柜员号
            ,puc_check_flag -- 人行核查标志[代码0039][0-不用人行核查1-人行核查]
            ,check_option -- 身份核查意见
            ,check_remark -- 身份核查意见备注
            ,check_opr_code -- 核查操作员
            ,puc_chk_date -- 人行身份核查时间
            ,update_flag -- 客户信息更新标志
            ,check_status -- 审批状态
            ,check_fall_reason -- 审批未通过原因
            ,succ_flag -- 成功标志
            ,status -- 流程状态
            ,home_addr_type -- 住宅类型[代码0106][1-自置2-公积金贷款3-商业贷款4-租用5-其他]
            ,company_type -- 单位性质[代码0107][01-国家机关02-事业单位03-国有企业04-私营，民营企业05-中外合资，合作，外资企业06-其他]
            ,obtain_opr_code -- 任务获取柜员号
            ,commission -- 代办事由
            ,email -- 邮箱
            ,often_site -- 经常居住地
            ,relation -- 与被代理人关系
            ,nationality -- 国籍
            ,pro_name -- 代理人姓名(中文)
            ,pro_type -- 代理人证件类型
            ,pro_fashion -- 代理人联系方式
            ,is_porxy -- 是否代办(0 否 1 是)
            ,accept_no -- 受理号(任务号)
            ,trane_code -- 交易代码
            ,idtfna_name -- 证件姓名
            ,pro_cert_code -- 代理人证件号码
            ,is_net_silver_contract -- 是否操作网银(0-否 1-是)
            ,open_flag -- 开户标志(0:无卡介质也无客户信息,1:有卡介质的2:无卡介质，但在我行有客户信息)
            ,group_flag -- 分组标志(预留扩展，暂时送99)
            ,netb_passwd -- 网银初始登录密码
            ,netb_left_msg -- 预留信息
            ,netb_sign_mobile -- 签约手机号码
            ,netb_sec_model -- 安全工具型号(0-飞天  1-捷德)
            ,netb_sec_type -- 安全工具类型(0-个人，1-企业)
            ,netb_sec_no -- 安全工具编号
            ,netb_dynamic_opt_no -- 动态口令编号
            ,netb_dynamic_card_no -- 口令卡编号
            ,netb_is_transfer -- 账号开通权限(0-查询 1-转账)
            ,netb_ac_limit_pertrs -- 账户级单笔限额
            ,netb_ac_limit_perday -- 账户级日累计限额
            ,cert_date -- 证件到期日
            ,id_address -- 户籍地址
            ,is_sms_contract -- 是否操作短信通(0-否 1-是)
            ,is_tel_n_trnsf -- 非定向转账是否开通（1-开通）
            ,is_tel_n_trnsf_default_limit -- 非定向转账默认额度（1-默认额度）
            ,tel_n_trnsf_single_limit -- 非定向转账单笔额度
            ,tel_n_trnsf_day_limit -- 非定向转账单日额度
            ,is_tel_d_trnsf -- 定向转账是否开通（1-开通）
            ,is_tel_d_trnsf_no_limit -- 定向转账无限额度（1-无限额）
            ,tel_d_trnsf_single_limit -- 定向转账单笔额度
            ,tel_d_trnsf_day_limit -- 定向转账单日额度
            ,payee_name1 -- 定向转账收款人全称1
            ,payee_accno1 -- 定向转账收款人账号1
            ,payee_bank_name1 -- 定向转账开户银行全称1
            ,payee_name2 -- 定向转账收款人全称2
            ,payee_accno2 -- 定向转账收款人账号2
            ,payee_bank_name2 -- 定向转账开户银行全称2
            ,sms_notice_limit -- 账户变动短信通知起点金额
            ,sec_node_id -- 加密结点号
            ,proxy_sex -- 代理人性别
            ,proxy_idtdt -- 证件失效日期
            ,proxy_id_address -- 代理人证件地址
            ,sms_contract_if_succeed -- 短信通签约是否成功(0-失败 1-成功)
            ,net_silver_contract_succeed -- 网银签约是否成功(0-失败 1-成功)
            ,is_netb_default_limit -- 网银签约是否默认限额(1-是)
            ,prsntg -- 居民性质代码
            ,staffflag -- 员工标志(默认0)
            ,custlv -- 客户级别(默认00)
            ,risklv -- 客户风险承受能力评估等级（1-保守型 2-谨慎型 3-稳健型 4-进取型 5-激进型）
            ,wkutad -- 工作单位地址
            ,roleid -- 职称等级
            ,worktx -- 其他职业
            ,csec_node_id -- 转加密结点号
            ,netb_csec_passwd -- 转加密网银初始密码
            ,transfer_channel -- 转账渠道（1-手机银行定向转账2-电话银行定向转账）
            ,mobile_ac_limit_pertrs -- 手机银行账户级单笔限额
            ,mobile_ac_limit_perday -- 手机银行账户级日累计限额
            ,is_mobile_default_limit -- 手机银行是否默认限额(1-是)
            ,fax -- 传真
            ,area_code -- 地区代码
            ,truth_flag -- 实名标志
            ,trnamt -- 转存金额
            ,voucherty -- 凭证类型    738-华兴卡 741-借记芯片卡
            ,id_check_result -- 身份证联网核查结果[00-公民身份证号码与姓名一致，且存在照片01-公民身份证号码与姓名一致，但不存在照片02-公民身份号码存在，但与姓名不匹配03-公民身份号码不存在04-其他错误]
            ,mobile_open_status -- 移动业务审批状态 0处理中 1审批通过 2审批不通过(开卡、网银签约、短信通签约)
            ,account_update_flag -- 账户更新标志[0：删除 1：更新 2：增加 为空表示不操作账户]
            ,submit_status -- 移动综合签约提交状态[提交锁定字段 0：未处理1：处理中2：提交成功]
            ,netb_biz_type -- 网银签约业务类型[0：新增1：变更]
            ,often_site_eq_id_addr -- 经常居住地同身份证件地址（0否 1是）
            ,net_ukey -- 开通华兴U盾（0否 1是2关联）
            ,card_type -- 卡产品
            ,card_rank -- 卡等级
            ,is_finance_contract -- 是否操作理财(0-否 1-是)
            ,sendfreq -- 对账单发送频率[0-有交易发生寄送1-不寄送2-按月3-按季4-半年5-一年]
            ,sendmode -- 对账单寄送方式(共8个字符，每个字符代表一种交易手段，其含义为：第1位：邮寄第2位：传真第3位：E-mail第4位：短消息第5~8位：保留。每位字符取1表示采用此种手段，取0表示不使用)
            ,risklevel -- 理财产品风险等级（0-未评定 1-低风险2-较低风险3-中风险4-较高风险5-高风险）
            ,clientgroup -- 客户分组[a-	群客户Z- 其他客户]
            ,chnlflag -- 高风险产品柜台以外渠道允许购买标志(0-不允许 1-允许 默认0)
            ,finance_contract_succeed -- 理财签约是否成功(0-失败 1-成功)
            ,finance_acctno -- 理财签约账号
            ,open_brcno -- 开卡机构
            ,cust_mgrno -- 客户经理代码
            ,sms_cust_sign -- 短信通客户是否已签约(0:未签约1:已签约)
            ,fee_acct_no -- 扣费账号
            ,fee_acct_brcno -- 扣费账号分行号
            ,fee_acct_nodeno -- 扣费账号行所号
            ,contact_phone -- 联系手机号码
            ,attbrn -- 业务归属机构
            ,new_password -- 新交易密码
            ,new_account -- 新账号
            ,chactg -- 更换类型
            ,stpytg -- 挂失类型
            ,rplsfs -- 挂失形式
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,netopflag -- 网银操作类型[0-开通1-维护 2-解约（注销）3-暂停4-恢复5开通以下服务]
            ,smsopflag -- 短信通操作类型[0-签约 1-解约 2-短信通手机号码新增 3-短信通手机号码修改 4-短信通手机号码取消]
            ,finopflag -- 理财操作类型[0-签约  1-解约 2-更换账户  3-银行帐号登记取消]
            ,delukey -- 是否删除Ukey(0-否 1-是)
            ,bgnamt -- 短信通知起点金额
            ,trtmrs -- 核实结果  01未核实，02真实
            ,loss_date -- 挂失日期(yyyymmdd)
            ,loss_reg_no -- 挂失登记号
            ,undays -- 挂失天数    临时挂失5天，正式挂失7天
            ,payway -- 支取方式 S-凭印鉴支取 P-凭密码支取 W-无密码无印鉴支取 B-凭印鉴和密码支取 O-凭证件支取 R-支付密码器和印鉴
            ,is_fund_contract -- 是否操作基金(0-否 1-是)
            ,fundopflag -- 基金操作类型[ 1-开通 2-银行卡号变更 3-解约]
            ,fin_manager_id -- 理财经理编号
            ,szsecno -- 深交所证券账号
            ,shsecno -- 上交所证券账号
            ,minorflag -- 是否成年人标志 1-否，0-是
            ,fundnewacct -- 基金新银行卡号
            ,fund_contract_if_succeed -- 基金签约操作是否成功(0-失败 1-成功)
            ,is_third_manage_contract -- 是否三方存管签约操作
            ,cobank -- 合作行
            ,ori_acct -- 三方存管原结算账号
            ,ori_brcode -- 三方存管原结算账号开户机构
            ,bond_acct -- 证券资金台账账号
            ,bond_pass -- 证券资金台账密码
            ,bond_code -- 券商代码
            ,bond_name -- 券商名称
            ,third_manage_if_succeed -- 三方存管签约操作是否成功(0-失败 1-成功)
            ,is_invest_contract -- 是否储蓄定投签约操作 0-否，1-是
            ,invest_opflag -- 储蓄定投操作类型 1-签约 2-维护 3-解约
            ,invest_contract_if_succeed -- 储蓄定投签约操作是否成功(0-失败 1-成功)
            ,is_quickin_contract -- 是否灵活盈签约操作 0-否，1-是
            ,quickin_opflag -- 灵活盈签约操作类型 1-签约 2-维护 3-解约
            ,chan_save_tp -- 转存类型 1-活期转双整 2-活期转通知
            ,chan_save_deadline -- 灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年
            ,chan_save_amt -- 转存起点金额
            ,save_low_amt -- 最低留存金额
            ,quickin_contract_if_succeed -- 灵活盈签约操作是否成功(0-失败 1-成功)
            ,sign_type -- 签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5
            ,third_ma_apply_tp -- 三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
            ,third_ma_new_acct -- 三方存管新账号
            ,is_acctfund_contract -- 基金代销账户类签约操作 0-否，1-是
            ,acctfund_sign_type -- 基金代销账户类签约种类 1-签约2-解约3-维护
            ,is_bill_send -- 对账单寄送要求 1-寄送0-不寄送
            ,acctfund_ori_acct -- 交易账户变更原账号 默认前“签约账号”项
            ,is_tradefund_contract -- 基金代销交易类签约操作 0-否，1-是
            ,tradefund_sign_type -- 基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更
            ,tradefund_name -- 基金名称
            ,tradefund_code -- 基金代码
            ,savings_invest_optp -- 储蓄定投操作类型 1-终止 2-暂停 3-恢复
            ,time_invest_code -- 定投编号
            ,third_manage_optp -- 三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]
            ,fund_acct -- 基金签约操作账号
            ,fund_acct_brcno -- 基金签约账号开卡网点
            ,quickin_leave_amt -- 灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)
            ,quickin_leave_amt_other -- 灵活盈—活期账户留存金额_其它
            ,netb_op_choice -- 网银修改服务选项(1登录密码 2手机动态密码)
            ,netb_password_optp -- 网银登录密码操作类型(1重置 2解锁)
            ,netb_netphone_optp -- 手机动态密码操作类型(0-不开通1开通2注销3指定手机号4变更手机号5关联)
            ,ukey_optp -- 华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)
            ,is_sms_set_phone -- 短信通是否设置签约手机号 0-否，1-是
            ,is_net_trans_limit_set -- 是否网银转账限额设置 0-否，1-是
            ,is_mob_trans_limit_set -- 手机银行是否非定向转账限额设置 0-否，1-是
            ,direct_trans_optp -- 定向转账操作类型[1开通2修改3注销]
            ,is_direct_trans_ac_set -- 是否定向收款账户设置[0-否，1-是]
            ,sms_set_phone_optp -- 短信通设置签约手机号操作类型[1-开通 3-注销]
            ,fin_new_acct -- 理财银行卡号变更新账号
            ,fin_new_open_brcno -- 理财银行卡号变更新账号所属机构
            ,quickin_pass -- 灵活盈交易密码(带账号转加密)
            ,cust_changes -- 客户信息变更内容1.通讯地址2.邮政编码3.联系电话4.手机5.EMAIL
            ,tlr_mobile -- 前台柜员手机号码
            ,deposit_trade_no -- 交易单编号
            ,acct_type_m -- 账号类型:0: 人民币个人非结算户1: 人民币个人结算户A: 外汇结算账户B: 乙种储蓄存款账户C: 丙种储蓄存款账户
            ,dsp_type -- 储种:S01储蓄活期S02	储蓄双整S03	零存整取S04	整存零取S05	存本取息S06	定活两便S07	储蓄通知S08	教育储蓄S18:财富宝
            ,dsp_period -- 存期:203-三个月、206-六个月、301-一年、302-二年、303-三年、305-五年、000-活期、101-一天、107-七天 、203-三个月、206-六个月、301-一年
            ,dsp_flag -- 转存标识:1:自动转存0:非自动转存
            ,tran_type -- 交易类型:CO-现开TO-转开
            ,to_acct_no -- 转出账号
            ,to_acct_name -- 转出账号名称
            ,to_pswd -- 转出账号密码
            ,to_idtp -- 转出证件类型:A:身份证,B:外国公民护照,C:户口薄,D:港澳居民通行证,E:还乡证,F:边民出入境通行证,G:军官证,H:士兵证,I:军事院校学员证,J:军队离休干部荣誉证,K:军官退休证,L:军人文职干部退休证,P:其他,Q:武警身份证,R:台湾居民通行证,S:中国公民护照,U:临时身份证
            ,to_idno -- 转出证件号码
            ,to_dwfs -- 转出支取方式：A:密码 D:印鉴 E:证件
            ,prcsna -- 交易类型
            ,nwinrt -- 利率
            ,matudt -- 到期日
            ,valuedt -- 起息日
            ,proxy_flag -- 代办人类型（0-否 1-监护代理 2-普通代理）
            ,quickin_type -- 灵活盈-储种（1-三个月 2-六个月 3-一年 4-二年 5-三年 6-五年 7-不约定存期 8-七天通知）
            ,acctlv -- 账户分类
            ,is_card -- 是否有卡
            ,regoresult -- 1识别失败，0识别成功
            ,similarity -- 0%~100%，>=80%为认定为本人
            ,issetnewpwd -- 是否设置新密码
            ,isfcfnoper -- 是否操作非柜面非同名限额签约(0-否,1-是)
            ,isfcfntype -- 非柜面非同名账户限额签约操作类型(0-签约 1-维护)
            ,isfcfnct -- 是否非柜面非同名账户限额签约(0-否,1-是)
            ,daylimit -- 日累计限额(非柜面非同名账户限额签约)
            ,txntimeslimit -- 日笔数限额(非柜面非同名账户限额签约)
            ,yearlimit -- 年累计限额(非柜面非同名账户限额签约)
            ,is_fcfnct_succeed -- 非柜面非同名账户限额签约是否成功(0-失败,1-成功)
            ,agreementid -- ECIF签约协议号
            ,custom_daylimit -- 自定义-日累计限额(万元)
            ,custom_txntimeslimit -- 自定义-日累计笔数
            ,custom_yearlimit -- 自定义-年累计限额(万元)
            ,pro_nationality -- 代理人国籍
            ,mobile_type -- 号码性质 0--本人1--监护人
            ,outflg -- 外出标注-0，默认网点0：网点凭证 1：外出凭证
            ,netstate -- 网银密码重置--状态默认送0
            ,logonpwnew -- 网银密码重置--新登陆密码
            ,netreset -- 是否网银密码重置
            ,relativetp -- 监护人/亲属证件类型
            ,relativena -- 监护人/亲属姓名
            ,relativeno -- 监护人/亲属号码
            ,taxresident -- 税收居民身份（1仅为中国税收居民2仅为非居民3既是中国税收居民又是其他国家（地区）税收居民4无需声明5空）
            ,birthplace -- 纳税人出生地（中英文字符）
            ,taxarea -- 税收居民国（地区）
            ,taxnumber -- 纳税人识别号
            ,taxarea2 -- 纳税居民国家（地区）2（发送报文时整合在TAXAREA）
            ,taxarea3 -- 纳税居民国家（地区）3（发送报文时整合在TAXAREA）
            ,taxnumber2 -- 纳税人识别号2（发送报文时整合在TAXNUMBER）
            ,taxnumber3 -- 纳税人识别号3（发送报文时整合在TAXNUMBER）
            ,taxnullreason -- 纳税人识别号为空原因
            ,taxstatement -- 是否取得自证声明（0-未取得自证声明1-取得自证声明）
            ,customersurname -- 客户_姓（字母）
            ,customergivenname -- 客户_名（字母）
            ,taxnullreason2 -- 纳税人识别号为空原因2
            ,taxnullreason3 -- 纳税人识别号为空原因3
            ,boundaccno -- 绑定账号
            ,boundbank -- 绑定账号开户行
            ,checkcase -- 落地审核原因
            ,ocridtdt -- 证件生效日期
            ,yflag -- 手机盾标志 Y:为是手机盾，N:为不是手机盾
            ,phoneoperate -- 手机盾操作类型0：开通
            ,camp_emp_id -- 营销工号
            ,notemessagephone1 -- 短信通签约号码1
            ,notemessagephone2 -- 短信通签约号码2
            ,notemessagephone3 -- 短信通签约号码3
            ,notemessagephone4 -- 短信通签约号码4
            ,notemessagephone5 -- 短信通签约号码5
            ,isagtsch -- 是否个人扣款协议签约(0-否,1-是)
            ,proxy_idtdt_sl -- 是否云闪付绑定签约
            ,is_flashpay_contract -- 云闪付绑定签约是否成功  0-失败 1-成功
            ,flashpay_contract_if_succeed -- 
            ,local_ip -- 开户IP
            ,local_mac -- 开户MAC
            ,uuid -- UUID
            ,ukey_modify_if_succeed -- U盾管理状态
            ,is_send_message -- 是否发送营销短信
            ,phonepay_contract_if_succeed -- 手机转账签约是否成功(0-失败 1-成功)
            ,is_phonepay_contract -- 是否手机转账签约(0-否 1-是)
            ,regedittype -- 登记注册类型
            ,sco -- 
            ,is_phonepay_contract1 -- 是否手机转账签约(0-否 1-是)
            ,phonepay_contract_if_succeed1 -- 手机转账签约是否成功(0-失败 1-成功)
            ,regedittype1 -- 登记注册类型
            ,limit_oper_type -- 非柜面签约
            ,limit_oper_channel -- 
            ,day_transfer_count -- 非柜面签约-日总笔数
            ,day_transfer_amount -- 非柜面签约-日总限额
            ,year_transfer_count -- 非柜面签约-年总笔数
            ,year_transfer_amount -- 非柜面签约-年总限额
            ,limit_oper_result -- 
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 记账失败
            ,agt_num -- 协议号
            ,dspbgndt -- 转存起始日期
            ,dspenddt -- 转存截止日期
            ,dsptyper -- 转存类型 1 转存双整 2 转存通知
            ,invest_account -- 储蓄定投签约账户
            ,invest_trnamt -- 转存金额
            ,prd_id -- 产品编号
            ,quickin_agreement_id -- 灵活盈协议编号
            ,quickin_agreement_status -- 灵活盈协议状态
            ,quickin_agreement_type -- 灵活盈协议类型
            ,quickin_fin_fixed_amt -- 灵活盈理财固定金额
            ,quickin_int_min_amt -- 灵活盈最小起存金额
            ,quickin_remain_amt -- 灵活盈协议留存金额
            ,quickin_start_amt -- 灵活盈起始金额
            ,quickin_transfer_day -- 划转日
            ,quickin_transfer_freq -- 灵活盈划转频率
            ,redep_freq -- 转存频率
            ,renew_corp -- 转存单位
            ,rpdsp -- 转存周期 Y-年 Q-季 M-月 W-周 D-天
            ,sub_acct_num -- 子账号
            ,sum_sub_num -- 汇总子户号
            ,biz_type -- 业务种类
            ,biz_dt -- 交易日期（yyyy-MM-dd hh:mm:ss）
            ,finance_card_type -- 理财账户类型
            ,fin_new_acct_crspd_pty_id -- 新账号对应客户号
            ,custchnlid -- 开通渠道
            ,riskmonths -- 风险有效期月数
            ,rskcd -- 风险等级代码
            ,oper_flag -- 1 客户级 2账户级
            ,third_chg_card_id -- 三方存管换卡标识
            ,third_open_org_id -- 三方存管开户机构
            ,usb_key_cert_id -- USBKey证书编号
            ,old_cert_key_id -- 旧证书KEYID
            ,safe_instr_model -- 安全工具型号(0：飞天1：捷德)
            ,u_brch_num -- U盾网点号
            ,u_oper_typ -- U盾操作类型（2：注销 3：损坏更换 4：挂失更换 5：发放）
            ,wthr_out -- 是否出库 默认Y Y：是 N：否
            ,lost_operate_method -- 挂失操作方式，比如书面挂失、口头挂失UV-口头解挂 UW-正式解挂 VL-口挂 WL-书挂
            ,lost_no -- 账户/凭证/结算卡挂失号码
            ,acct_name -- 账户名称
            ,loss_id -- 挂失编号
            ,acct_seq_no -- 账户序列号
            ,acct_password -- 账户密码
            ,voucher_change_type -- 凭证更换类型，比如挂失补发、损坏更换等，不同的更换类型会对应不同的处理流程 01-挂失补发 02-凭证更换 03-损坏更换 04-同号换卡领卡/记名卡领卡 05-单位存单置换 06-单位存单收回如果补开、凭证更换必传
            ,new_vchr_typ -- 新凭证类型
            ,new_vchr_num -- 新凭证号码
            ,voucher_change_reason -- 更换原因
            ,td_inout_operate_type -- 存单移入必传 定期账户转入转出操作类型 01-转入 02-互转 03-转出
            ,in_base_acct_no -- 移入账号
            ,in_prod_type -- 转入账户产品类型
            ,enter_acct_ccy -- 转入账户币种
            ,target_acct_class -- 目标账户类别（一二三类户），即账户升级后的账户类别，满足人行对于电子账户的管理办法1-一类账户 2-二类账户 3-三类账户
            ,password_operate_type -- 账户密码操作类型 账户密码操作类型01-新建 02-重置 03-修改 04-解锁 05-校验 06-激活 07-凭证解挂场景密码重置 08-弱密码校验
            ,password_type -- 密码类型，目前核心只支持WD，接口未上送则默认为WDWD-支取密码 QY-查询密码 MA-账户管理密码
            ,password_old -- 旧密码
            ,iss_country -- 发证国家
            ,password_effect_date -- 密码生效日期
            ,lost_reason -- 挂失原因
            ,res_flag -- 标识挂失账户是N进行账户止付,挂失时必输，解挂时不需要输入Y-是 N-不是
            ,pause_post -- 暂停附言
            ,channel -- 渠道
            ,ntw_ceph_bank_pause_type -- 网银手机银行管理 业务类型 01：个人动态密码管理 02：解锁登录密码 03：网银/手机银行暂停/恢复 04：登录密码和用户状态重置 05：客户手机盾信息维护 06：账户暂停/恢复
            ,ntw_ceph_bank_pause_pwd_status -- 网银手机银行管理 密码状态：0:正常 7：重置网银密码 8：重置交易密码 9 : 柜面开户重置密码
            ,tfr_encry_ind -- 转加密标识  1:数字加字母组合 0:纯数字(柜面调用)
            ,cfm_new_logon_pwd -- 确认新登录密码
            ,pwd_keyb_node_id -- 密码键盘节点ID
            ,safe_ceph_num -- 安全手机号
            ,dynamic_password_status -- 个人动态密码状态 ： 0---开 1---关
            ,pause_status -- 网银/手机银行暂停/恢复 状态 0-正常 1-永久停止 2-临时暂停
            ,dynamic_password_ind_id -- 个人动态密码标识编号 1：查询 2：新增 3：修改 4: 删除
            ,clous_shield_ind_id -- 华兴云盾标识编号 1：设置密码 0：重置密码
            ,deft_safe_instr -- 默认安全工具 1：华兴U盾 2：手机短信密码
            ,indv_act_status -- 个人账户状态
            ,acct_pause_rsns -- 账户暂停原因
            ,ntw_ceph_bank_pause_resu_status -- 网银/手机银行暂停/恢复状态 0-正常 1-永久停止 2-临时暂停
            ,pause_with_resu_oper_typ -- 暂停/恢复操作类型 0-网银 1-手机银行 2-网银手机银行
            ,temp_pause_start_tm -- 临时暂停开始时间，格式为yyyyMMddHHmmss
            ,temp_pause_cncl_tm -- 临时暂停结束时间，格式为yyyyMMddHHmmss
            ,ceph_cs_oper_typ -- 手机盾信息操作类型 开通：0 停用：1 启用：2 注销：4
            ,cs_ord_nbr -- 云盾序号
            ,open_br_node_num -- 开通网点号
            ,key_name -- 密钥名称
            ,total_cnt -- 网银签约总笔数
            ,reg_typ -- 手机号码支付协议注册类型 DFLT 默认账户 NDFT 非默认账户
            ,narrative1 -- 备注
            ,prest_flg -- 赠送标志 0-正常开通 1-赠送开通
            ,prest_mon -- 赠送月份 如果是赠送服务（赠送标志为1），则填入赠送的月份数。没有此信息填空或“00”
            ,vip_flg -- VIP标志 0-非VIP服务， 1-VIP服务，（默认填0，如果操作员选择了VIP服务标志，则填1），VIP针对客户而言。
            ,chrg_pkg_typ -- 收费套餐类型 01包月/ 12包年。
            ,chrg_mode -- 收费模式 1-按账户数收费 2-按服务数收费 3-按短信条数收费 4-按定额收费
            ,chrg_amt -- 收费金额 请按字符串格式传输，如”RATE”:”0.56987” 当收费模式为定额收费时填写
            ,disct -- 折扣 客户收费折扣
            ,disct_mon -- 折扣月份 当存在折扣时，填写折扣有效月份，没有此信息则填空或00
            ,acct_purp -- 账户用途
            ,acct_attr -- 账户属性
            ,agtsch_prd_id -- 个人扣款协议-产品编号
            ,agtsch_prd_type -- 个人扣款协议  C-签约U-维护D-解约
            ,payer_acct -- 付款人账号
            ,payer_acct_typ -- 付款人账户类型
            ,payer_act_nm -- 付款人账户户名
            ,payer_cert_typ -- 付款人证件类型
            ,payer_cert_num -- 付款人证件号
            ,payer_ceph_num -- 付款人手机号
            ,payer_bank -- 付款人开户行行号
            ,rcver_acct_typ -- 收款人账户类型
            ,payee_base_acct_no -- 收款人账号
            ,rcver_act_nm -- 收款人账户户名
            ,chn_num -- 渠道号
            ,sign_dtl -- 签约明细
            ,dsp_trnamt -- 转存周期 Y    年 Q    季 M    月 W    周 D    天
            ,redep_start_dt -- 转存起始日期
            ,redep_end_dt -- 转存截止日期
            ,pause_flg -- 暂停标志 0 否 1 是
            ,node_num -- 节点号
            ,third_chg_sign_prd -- 签约产品 SV014银银合作代理第三方存管协议
            ,agt_typ -- 协议类型CLD-存立得 DC-大额存单 DLS-贷利省 HQB-活期宝 JDL-加多利 KDT-卡贷通 KYD-卡易贷 PCP-资金池 WDL-稳得利 XDB-协定宝 XDCK-协定存款产品 XDL-先得利 YBWL-一本万利 YCD-英才贷 YDT-易贷通 YHT-一户通 ZHY-周享赢 ZXY-坐享其盈 ZZB-至尊宝 LOA-贷款 ODF-法人透支协议 FIN-卡理财协议 SMS-短信 PKG-费用套餐 FEE-暂不收费 PCD-周期性强制扣划 ACC-协定存款协议 SWP-账户清扫协议 ID-智能存款协议 SL-金额补足协议 REC-回单签约 ES-电票签约 YD-约定 NTE-活期智能存款 PAS-隐私账户签约 TXY1-同兴赢活期签约 TXY2-跨境资金融入签约 CXDT-储蓄定投 TBCK-跳板存款 LHY-灵活盈 P2P-P2P协议 JZG-建筑港 ZCG-资产存管 ZQS-资金清算 LYE-财政零余额
            ,agt_id -- 协议编号
            ,agt_status_cd -- 协议状态 普通协议使用，可应用于大部分场景，贷款模块用于资产证券化合同状态A-生效 E-失效 YB-赎回 YS-发行 YP-已封包 NP-未封包 NS-未发行 YC-已撤包
            ,st_dt -- 开始日期
            ,end_dt_ora -- 结束日期
            ,sign_prod_type -- 签约产品类型
            ,remain_amt -- 协议留存金额 请按字符串格式传输，如”RATE”:”0.56987” 协议留存金额
            ,start_amt -- 起始金额 请按字符串格式传输，如”RATE”:”0.56987” 起始金额
            ,transfer_freq_type -- 划转频率类型 Y-年 Q-季 M-月 W-周 D-日
            ,acct_movt_date -- 转存交易日期
            ,peri -- 存期
            ,term_type -- 期限单位 Y-年 Q-季 M-月 W-周 D-日
            ,acct_exec -- 银行客户经理
            ,transfer_end_date -- 转存结束日期
            ,transfer_day -- 划转日
            ,transfer_freq -- 划转频率
            ,fin_fixed_amt -- 理财固定金额 请按字符串格式传输，如”RATE”:”0.56987”
            ,min_depo_amt -- 最小起存金额 请按字符串格式传输，如”RATE”:”0.56987” 最小起存金额
            ,opt_type -- 资管信托代销协议操作类型 01签约 02解约 03维护
            ,matn_oper_typ -- 维护操作类型 0-客户信息维护 1-客户经理代码维护
            ,actl_benef -- 实际受益人 0-本人（默认） 1-他人
            ,wthr_exist_actl_ctrl_rela -- 是否存在实际控制关系 0-否（默认） 1-是
            ,wthr_is_np_integrity_rec -- 是否有不良诚信记录 0-否（默认） 1-是
            ,ori_pty_mgr_cd -- 原客户经理代码
            ,new_pty_mgr_cd -- 新客户经理代码
            ,pty_mgr_adj_flg -- 客户经理调整标志 0－全部（将原客户经理替换成新客经理） 1－调整客户所属客户经理代码 2－理财账号客户经理代码 3－按流水客户经理 4－调整定投客户经理代码 5－调整定赎客户经理代码 8－调整客户对应所有客户经理
            ,spec_seq_num -- 指定流水号
            ,enro_ceph_num -- 注册手机号
            ,acct_typ -- 账户类型 01 - 为Ⅰ类户（非信用卡） 02 - 为Ⅱ类户 03 - 为Ⅲ类户 04-准贷记卡 05-借贷合一卡 不填-信用卡
            ,zone_num -- 地区码 建议需求方至少定位到省市、直辖市级地区区位。默认为0000，长度为4 位
            ,scene_num -- 云闪付场景码
            ,card_prd_id -- 卡产品编号
            ,txn_equip_info -- 交易设备信息
            ,put_new_fld -- 拉新字段
            ,cvn_num -- CVN码
            ,valid_dt -- 有效期
            ,bcs_res_ceph_num_flg -- 核心预留手机号标志 1代表是核心预留手机号 0代表非核心预留手机号
            ,short_lett_srv_type -- 短信服务类 短信服务类，以逗号分隔（A,B）
            ,ceph_num_app_scope -- 手机号码应用范围 1-只修改该账号下对应的手机号码 2-修改客户所有账号对应的手机号码，填1时必须填写签约账号
            ,old_ceph_num -- 旧手机号码
            ,new_ceph_num -- 新手机号码
            ,ceph_num_qty -- 手机号码个数
            ,direct_sign_matn_flg -- 定向转账签约维护标志 0-解约, 1-更新, 2-签约
            ,direct_sign_typ -- 定向转账签约类型 0-综合柜面, 1-流程银行
            ,ghb_out_ind -- 行内外标识 0-行内 1-行外
            ,bank_id -- 银行编号
            ,bank_name -- 银行名称
            ,provin_cd -- 省份代码
            ,city_cd -- 城市代码
            ,rcv_open_brch_id -- 收款方开户网点编号
            ,rcv_open_brch_name -- 收款方开户网点名称
            ,rcver_ceph_num -- 收款人手机号码
            ,recv_acct_upda_flg -- 收款账户更新标志 收款账户更新标志0：删除 1：更新,2：增加（SIGNUPDATEFLAG=0时，系统默认0，SIGNUPDATEFLAG=2时，系统默认为2）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 逻辑主键
    ,nvl(n.process_inst_id, o.process_inst_id) as process_inst_id -- 
    ,nvl(n.main_flow_id, o.main_flow_id) as main_flow_id -- 
    ,nvl(n.scan_seq_no, o.scan_seq_no) as scan_seq_no -- 流水号
    ,nvl(n.fr_org_code, o.fr_org_code) as fr_org_code -- 前台机构编码
    ,nvl(n.tr_date, o.tr_date) as tr_date -- 客户开户日期
    ,nvl(n.biz_code, o.biz_code) as biz_code -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
    ,nvl(n.voucher_no, o.voucher_no) as voucher_no -- 凭证号码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.english_name, o.english_name) as english_name -- 客户英文名称
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 证件类型[代码0009][A-公民身份号码B-军官证C-解放军文职干部证D-警官证E-解放军士兵证F-户口簿G-(港、澳)回乡证、通行证H-(台)通行证、其他有效旅行证I-(外国)护照J-(中国)护照K-武警文职干部证L-武警士兵证P-全国组织机构代码Q-海外客户编号R-营业执照号码X-其它有效证件Z-其它]
    ,nvl(n.cert_code, o.cert_code) as cert_code -- 证件号码
    ,nvl(n.crt_cert_organ, o.crt_cert_organ) as crt_cert_organ -- 发证机关地区代码
    ,nvl(n.birthday, o.birthday) as birthday -- 出生日期
    ,nvl(n.weblock_flag, o.weblock_flag) as weblock_flag -- 婚姻状况[代码0007][10-未婚 20-已婚 21-初婚 22-再婚 23-复婚 40-离婚 90-未说明的婚姻状况 30-丧偶5-已婚有子女6-已婚无子女7-其他]
    ,nvl(n.education, o.education) as education -- 学历
    ,nvl(n.occupation, o.occupation) as occupation -- 职业[代码0048][]
    ,nvl(n.rank, o.rank) as rank -- 职务
    ,nvl(n.income, o.income) as income -- 月收入[代码0046][1-1500以下 2-1500到2000 3-2000到3000 4-3000到5000 5-5000到8000 6-8000到10000 7-10000到30000 8-30000以上]
    ,nvl(n.company, o.company) as company -- 工作单位名称
    ,nvl(n.home_address, o.home_address) as home_address -- 家庭地址
    ,nvl(n.fix_telephone, o.fix_telephone) as fix_telephone -- 固定电话
    ,nvl(n.office_phone, o.office_phone) as office_phone -- 办公电话
    ,nvl(n.home_phone, o.home_phone) as home_phone -- 家庭电话
    ,nvl(n.mobile, o.mobile) as mobile -- 移动电话
    ,nvl(n.contact_address, o.contact_address) as contact_address -- 联系地址
    ,nvl(n.postcode, o.postcode) as postcode -- 邮政编码
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 交易对手账户类型
    ,nvl(n.spec_type, o.spec_type) as spec_type -- 存款账户类型
    ,nvl(n.sf_scp_flag, o.sf_scp_flag) as sf_scp_flag -- 通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]
    ,nvl(n.curr_type, o.curr_type) as curr_type -- 币种[代码T003][参考CFG_T_CURRENCY_TYPE]
    ,nvl(n.cf_flag, o.cf_flag) as cf_flag -- 钞汇鉴别[代码0011][0-钞1-汇]
    ,nvl(n.fee_drw_type, o.fee_drw_type) as fee_drw_type -- 费用支取别[代码0012][0-不收1-现金2-转账]
    ,nvl(n.spec_time, o.spec_time) as spec_time -- 存期
    ,nvl(n.amount, o.amount) as amount -- 金额
    ,nvl(n.biz_password, o.biz_password) as biz_password -- 交易密码
    ,nvl(n.biz_account, o.biz_account) as biz_account -- 交易账号
    ,nvl(n.open_acct_password, o.open_acct_password) as open_acct_password -- 开户密码
    ,nvl(n.tr_account, o.tr_account) as tr_account -- 转帐账号
    ,nvl(n.tr_password, o.tr_password) as tr_password -- 转账密码
    ,nvl(n.attor_opr_code, o.attor_opr_code) as attor_opr_code -- 客户经理编号
    ,nvl(n.attor_opr_name, o.attor_opr_name) as attor_opr_name -- 客户经理姓名
    ,nvl(n.attor_org_code, o.attor_org_code) as attor_org_code -- 客户经理所在网点
    ,nvl(n.level_b_pin, o.level_b_pin) as level_b_pin -- 前台机构编码
    ,nvl(n.fr_tlr_opr_no, o.fr_tlr_opr_no) as fr_tlr_opr_no -- 前台柜员号
    ,nvl(n.puc_check_flag, o.puc_check_flag) as puc_check_flag -- 人行核查标志[代码0039][0-不用人行核查1-人行核查]
    ,nvl(n.check_option, o.check_option) as check_option -- 身份核查意见
    ,nvl(n.check_remark, o.check_remark) as check_remark -- 身份核查意见备注
    ,nvl(n.check_opr_code, o.check_opr_code) as check_opr_code -- 核查操作员
    ,nvl(n.puc_chk_date, o.puc_chk_date) as puc_chk_date -- 人行身份核查时间
    ,nvl(n.update_flag, o.update_flag) as update_flag -- 客户信息更新标志
    ,nvl(n.check_status, o.check_status) as check_status -- 审批状态
    ,nvl(n.check_fall_reason, o.check_fall_reason) as check_fall_reason -- 审批未通过原因
    ,nvl(n.succ_flag, o.succ_flag) as succ_flag -- 成功标志
    ,nvl(n.status, o.status) as status -- 流程状态
    ,nvl(n.home_addr_type, o.home_addr_type) as home_addr_type -- 住宅类型[代码0106][1-自置2-公积金贷款3-商业贷款4-租用5-其他]
    ,nvl(n.company_type, o.company_type) as company_type -- 单位性质[代码0107][01-国家机关02-事业单位03-国有企业04-私营，民营企业05-中外合资，合作，外资企业06-其他]
    ,nvl(n.obtain_opr_code, o.obtain_opr_code) as obtain_opr_code -- 任务获取柜员号
    ,nvl(n.commission, o.commission) as commission -- 代办事由
    ,nvl(n.email, o.email) as email -- 邮箱
    ,nvl(n.often_site, o.often_site) as often_site -- 经常居住地
    ,nvl(n.relation, o.relation) as relation -- 与被代理人关系
    ,nvl(n.nationality, o.nationality) as nationality -- 国籍
    ,nvl(n.pro_name, o.pro_name) as pro_name -- 代理人姓名(中文)
    ,nvl(n.pro_type, o.pro_type) as pro_type -- 代理人证件类型
    ,nvl(n.pro_fashion, o.pro_fashion) as pro_fashion -- 代理人联系方式
    ,nvl(n.is_porxy, o.is_porxy) as is_porxy -- 是否代办(0 否 1 是)
    ,nvl(n.accept_no, o.accept_no) as accept_no -- 受理号(任务号)
    ,nvl(n.trane_code, o.trane_code) as trane_code -- 交易代码
    ,nvl(n.idtfna_name, o.idtfna_name) as idtfna_name -- 证件姓名
    ,nvl(n.pro_cert_code, o.pro_cert_code) as pro_cert_code -- 代理人证件号码
    ,nvl(n.is_net_silver_contract, o.is_net_silver_contract) as is_net_silver_contract -- 是否操作网银(0-否 1-是)
    ,nvl(n.open_flag, o.open_flag) as open_flag -- 开户标志(0:无卡介质也无客户信息,1:有卡介质的2:无卡介质，但在我行有客户信息)
    ,nvl(n.group_flag, o.group_flag) as group_flag -- 分组标志(预留扩展，暂时送99)
    ,nvl(n.netb_passwd, o.netb_passwd) as netb_passwd -- 网银初始登录密码
    ,nvl(n.netb_left_msg, o.netb_left_msg) as netb_left_msg -- 预留信息
    ,nvl(n.netb_sign_mobile, o.netb_sign_mobile) as netb_sign_mobile -- 签约手机号码
    ,nvl(n.netb_sec_model, o.netb_sec_model) as netb_sec_model -- 安全工具型号(0-飞天  1-捷德)
    ,nvl(n.netb_sec_type, o.netb_sec_type) as netb_sec_type -- 安全工具类型(0-个人，1-企业)
    ,nvl(n.netb_sec_no, o.netb_sec_no) as netb_sec_no -- 安全工具编号
    ,nvl(n.netb_dynamic_opt_no, o.netb_dynamic_opt_no) as netb_dynamic_opt_no -- 动态口令编号
    ,nvl(n.netb_dynamic_card_no, o.netb_dynamic_card_no) as netb_dynamic_card_no -- 口令卡编号
    ,nvl(n.netb_is_transfer, o.netb_is_transfer) as netb_is_transfer -- 账号开通权限(0-查询 1-转账)
    ,nvl(n.netb_ac_limit_pertrs, o.netb_ac_limit_pertrs) as netb_ac_limit_pertrs -- 账户级单笔限额
    ,nvl(n.netb_ac_limit_perday, o.netb_ac_limit_perday) as netb_ac_limit_perday -- 账户级日累计限额
    ,nvl(n.cert_date, o.cert_date) as cert_date -- 证件到期日
    ,nvl(n.id_address, o.id_address) as id_address -- 户籍地址
    ,nvl(n.is_sms_contract, o.is_sms_contract) as is_sms_contract -- 是否操作短信通(0-否 1-是)
    ,nvl(n.is_tel_n_trnsf, o.is_tel_n_trnsf) as is_tel_n_trnsf -- 非定向转账是否开通（1-开通）
    ,nvl(n.is_tel_n_trnsf_default_limit, o.is_tel_n_trnsf_default_limit) as is_tel_n_trnsf_default_limit -- 非定向转账默认额度（1-默认额度）
    ,nvl(n.tel_n_trnsf_single_limit, o.tel_n_trnsf_single_limit) as tel_n_trnsf_single_limit -- 非定向转账单笔额度
    ,nvl(n.tel_n_trnsf_day_limit, o.tel_n_trnsf_day_limit) as tel_n_trnsf_day_limit -- 非定向转账单日额度
    ,nvl(n.is_tel_d_trnsf, o.is_tel_d_trnsf) as is_tel_d_trnsf -- 定向转账是否开通（1-开通）
    ,nvl(n.is_tel_d_trnsf_no_limit, o.is_tel_d_trnsf_no_limit) as is_tel_d_trnsf_no_limit -- 定向转账无限额度（1-无限额）
    ,nvl(n.tel_d_trnsf_single_limit, o.tel_d_trnsf_single_limit) as tel_d_trnsf_single_limit -- 定向转账单笔额度
    ,nvl(n.tel_d_trnsf_day_limit, o.tel_d_trnsf_day_limit) as tel_d_trnsf_day_limit -- 定向转账单日额度
    ,nvl(n.payee_name1, o.payee_name1) as payee_name1 -- 定向转账收款人全称1
    ,nvl(n.payee_accno1, o.payee_accno1) as payee_accno1 -- 定向转账收款人账号1
    ,nvl(n.payee_bank_name1, o.payee_bank_name1) as payee_bank_name1 -- 定向转账开户银行全称1
    ,nvl(n.payee_name2, o.payee_name2) as payee_name2 -- 定向转账收款人全称2
    ,nvl(n.payee_accno2, o.payee_accno2) as payee_accno2 -- 定向转账收款人账号2
    ,nvl(n.payee_bank_name2, o.payee_bank_name2) as payee_bank_name2 -- 定向转账开户银行全称2
    ,nvl(n.sms_notice_limit, o.sms_notice_limit) as sms_notice_limit -- 账户变动短信通知起点金额
    ,nvl(n.sec_node_id, o.sec_node_id) as sec_node_id -- 加密结点号
    ,nvl(n.proxy_sex, o.proxy_sex) as proxy_sex -- 代理人性别
    ,nvl(n.proxy_idtdt, o.proxy_idtdt) as proxy_idtdt -- 证件失效日期
    ,nvl(n.proxy_id_address, o.proxy_id_address) as proxy_id_address -- 代理人证件地址
    ,nvl(n.sms_contract_if_succeed, o.sms_contract_if_succeed) as sms_contract_if_succeed -- 短信通签约是否成功(0-失败 1-成功)
    ,nvl(n.net_silver_contract_succeed, o.net_silver_contract_succeed) as net_silver_contract_succeed -- 网银签约是否成功(0-失败 1-成功)
    ,nvl(n.is_netb_default_limit, o.is_netb_default_limit) as is_netb_default_limit -- 网银签约是否默认限额(1-是)
    ,nvl(n.prsntg, o.prsntg) as prsntg -- 居民性质代码
    ,nvl(n.staffflag, o.staffflag) as staffflag -- 员工标志(默认0)
    ,nvl(n.custlv, o.custlv) as custlv -- 客户级别(默认00)
    ,nvl(n.risklv, o.risklv) as risklv -- 客户风险承受能力评估等级（1-保守型 2-谨慎型 3-稳健型 4-进取型 5-激进型）
    ,nvl(n.wkutad, o.wkutad) as wkutad -- 工作单位地址
    ,nvl(n.roleid, o.roleid) as roleid -- 职称等级
    ,nvl(n.worktx, o.worktx) as worktx -- 其他职业
    ,nvl(n.csec_node_id, o.csec_node_id) as csec_node_id -- 转加密结点号
    ,nvl(n.netb_csec_passwd, o.netb_csec_passwd) as netb_csec_passwd -- 转加密网银初始密码
    ,nvl(n.transfer_channel, o.transfer_channel) as transfer_channel -- 转账渠道（1-手机银行定向转账2-电话银行定向转账）
    ,nvl(n.mobile_ac_limit_pertrs, o.mobile_ac_limit_pertrs) as mobile_ac_limit_pertrs -- 手机银行账户级单笔限额
    ,nvl(n.mobile_ac_limit_perday, o.mobile_ac_limit_perday) as mobile_ac_limit_perday -- 手机银行账户级日累计限额
    ,nvl(n.is_mobile_default_limit, o.is_mobile_default_limit) as is_mobile_default_limit -- 手机银行是否默认限额(1-是)
    ,nvl(n.fax, o.fax) as fax -- 传真
    ,nvl(n.area_code, o.area_code) as area_code -- 地区代码
    ,nvl(n.truth_flag, o.truth_flag) as truth_flag -- 实名标志
    ,nvl(n.trnamt, o.trnamt) as trnamt -- 转存金额
    ,nvl(n.voucherty, o.voucherty) as voucherty -- 凭证类型    738-华兴卡 741-借记芯片卡
    ,nvl(n.id_check_result, o.id_check_result) as id_check_result -- 身份证联网核查结果[00-公民身份证号码与姓名一致，且存在照片01-公民身份证号码与姓名一致，但不存在照片02-公民身份号码存在，但与姓名不匹配03-公民身份号码不存在04-其他错误]
    ,nvl(n.mobile_open_status, o.mobile_open_status) as mobile_open_status -- 移动业务审批状态 0处理中 1审批通过 2审批不通过(开卡、网银签约、短信通签约)
    ,nvl(n.account_update_flag, o.account_update_flag) as account_update_flag -- 账户更新标志[0：删除 1：更新 2：增加 为空表示不操作账户]
    ,nvl(n.submit_status, o.submit_status) as submit_status -- 移动综合签约提交状态[提交锁定字段 0：未处理1：处理中2：提交成功]
    ,nvl(n.netb_biz_type, o.netb_biz_type) as netb_biz_type -- 网银签约业务类型[0：新增1：变更]
    ,nvl(n.often_site_eq_id_addr, o.often_site_eq_id_addr) as often_site_eq_id_addr -- 经常居住地同身份证件地址（0否 1是）
    ,nvl(n.net_ukey, o.net_ukey) as net_ukey -- 开通华兴U盾（0否 1是2关联）
    ,nvl(n.card_type, o.card_type) as card_type -- 卡产品
    ,nvl(n.card_rank, o.card_rank) as card_rank -- 卡等级
    ,nvl(n.is_finance_contract, o.is_finance_contract) as is_finance_contract -- 是否操作理财(0-否 1-是)
    ,nvl(n.sendfreq, o.sendfreq) as sendfreq -- 对账单发送频率[0-有交易发生寄送1-不寄送2-按月3-按季4-半年5-一年]
    ,nvl(n.sendmode, o.sendmode) as sendmode -- 对账单寄送方式(共8个字符，每个字符代表一种交易手段，其含义为：第1位：邮寄第2位：传真第3位：E-mail第4位：短消息第5~8位：保留。每位字符取1表示采用此种手段，取0表示不使用)
    ,nvl(n.risklevel, o.risklevel) as risklevel -- 理财产品风险等级（0-未评定 1-低风险2-较低风险3-中风险4-较高风险5-高风险）
    ,nvl(n.clientgroup, o.clientgroup) as clientgroup -- 客户分组[a-	群客户Z- 其他客户]
    ,nvl(n.chnlflag, o.chnlflag) as chnlflag -- 高风险产品柜台以外渠道允许购买标志(0-不允许 1-允许 默认0)
    ,nvl(n.finance_contract_succeed, o.finance_contract_succeed) as finance_contract_succeed -- 理财签约是否成功(0-失败 1-成功)
    ,nvl(n.finance_acctno, o.finance_acctno) as finance_acctno -- 理财签约账号
    ,nvl(n.open_brcno, o.open_brcno) as open_brcno -- 开卡机构
    ,nvl(n.cust_mgrno, o.cust_mgrno) as cust_mgrno -- 客户经理代码
    ,nvl(n.sms_cust_sign, o.sms_cust_sign) as sms_cust_sign -- 短信通客户是否已签约(0:未签约1:已签约)
    ,nvl(n.fee_acct_no, o.fee_acct_no) as fee_acct_no -- 扣费账号
    ,nvl(n.fee_acct_brcno, o.fee_acct_brcno) as fee_acct_brcno -- 扣费账号分行号
    ,nvl(n.fee_acct_nodeno, o.fee_acct_nodeno) as fee_acct_nodeno -- 扣费账号行所号
    ,nvl(n.contact_phone, o.contact_phone) as contact_phone -- 联系手机号码
    ,nvl(n.attbrn, o.attbrn) as attbrn -- 业务归属机构
    ,nvl(n.new_password, o.new_password) as new_password -- 新交易密码
    ,nvl(n.new_account, o.new_account) as new_account -- 新账号
    ,nvl(n.chactg, o.chactg) as chactg -- 更换类型
    ,nvl(n.stpytg, o.stpytg) as stpytg -- 挂失类型
    ,nvl(n.rplsfs, o.rplsfs) as rplsfs -- 挂失形式
    ,nvl(n.submit_state, o.submit_state) as submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,nvl(n.netopflag, o.netopflag) as netopflag -- 网银操作类型[0-开通1-维护 2-解约（注销）3-暂停4-恢复5开通以下服务]
    ,nvl(n.smsopflag, o.smsopflag) as smsopflag -- 短信通操作类型[0-签约 1-解约 2-短信通手机号码新增 3-短信通手机号码修改 4-短信通手机号码取消]
    ,nvl(n.finopflag, o.finopflag) as finopflag -- 理财操作类型[0-签约  1-解约 2-更换账户  3-银行帐号登记取消]
    ,nvl(n.delukey, o.delukey) as delukey -- 是否删除Ukey(0-否 1-是)
    ,nvl(n.bgnamt, o.bgnamt) as bgnamt -- 短信通知起点金额
    ,nvl(n.trtmrs, o.trtmrs) as trtmrs -- 核实结果  01未核实，02真实
    ,nvl(n.loss_date, o.loss_date) as loss_date -- 挂失日期(yyyymmdd)
    ,nvl(n.loss_reg_no, o.loss_reg_no) as loss_reg_no -- 挂失登记号
    ,nvl(n.undays, o.undays) as undays -- 挂失天数    临时挂失5天，正式挂失7天
    ,nvl(n.payway, o.payway) as payway -- 支取方式 S-凭印鉴支取 P-凭密码支取 W-无密码无印鉴支取 B-凭印鉴和密码支取 O-凭证件支取 R-支付密码器和印鉴
    ,nvl(n.is_fund_contract, o.is_fund_contract) as is_fund_contract -- 是否操作基金(0-否 1-是)
    ,nvl(n.fundopflag, o.fundopflag) as fundopflag -- 基金操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,nvl(n.fin_manager_id, o.fin_manager_id) as fin_manager_id -- 理财经理编号
    ,nvl(n.szsecno, o.szsecno) as szsecno -- 深交所证券账号
    ,nvl(n.shsecno, o.shsecno) as shsecno -- 上交所证券账号
    ,nvl(n.minorflag, o.minorflag) as minorflag -- 是否成年人标志 1-否，0-是
    ,nvl(n.fundnewacct, o.fundnewacct) as fundnewacct -- 基金新银行卡号
    ,nvl(n.fund_contract_if_succeed, o.fund_contract_if_succeed) as fund_contract_if_succeed -- 基金签约操作是否成功(0-失败 1-成功)
    ,nvl(n.is_third_manage_contract, o.is_third_manage_contract) as is_third_manage_contract -- 是否三方存管签约操作
    ,nvl(n.cobank, o.cobank) as cobank -- 合作行
    ,nvl(n.ori_acct, o.ori_acct) as ori_acct -- 三方存管原结算账号
    ,nvl(n.ori_brcode, o.ori_brcode) as ori_brcode -- 三方存管原结算账号开户机构
    ,nvl(n.bond_acct, o.bond_acct) as bond_acct -- 证券资金台账账号
    ,nvl(n.bond_pass, o.bond_pass) as bond_pass -- 证券资金台账密码
    ,nvl(n.bond_code, o.bond_code) as bond_code -- 券商代码
    ,nvl(n.bond_name, o.bond_name) as bond_name -- 券商名称
    ,nvl(n.third_manage_if_succeed, o.third_manage_if_succeed) as third_manage_if_succeed -- 三方存管签约操作是否成功(0-失败 1-成功)
    ,nvl(n.is_invest_contract, o.is_invest_contract) as is_invest_contract -- 是否储蓄定投签约操作 0-否，1-是
    ,nvl(n.invest_opflag, o.invest_opflag) as invest_opflag -- 储蓄定投操作类型 1-签约 2-维护 3-解约
    ,nvl(n.invest_contract_if_succeed, o.invest_contract_if_succeed) as invest_contract_if_succeed -- 储蓄定投签约操作是否成功(0-失败 1-成功)
    ,nvl(n.is_quickin_contract, o.is_quickin_contract) as is_quickin_contract -- 是否灵活盈签约操作 0-否，1-是
    ,nvl(n.quickin_opflag, o.quickin_opflag) as quickin_opflag -- 灵活盈签约操作类型 1-签约 2-维护 3-解约
    ,nvl(n.chan_save_tp, o.chan_save_tp) as chan_save_tp -- 转存类型 1-活期转双整 2-活期转通知
    ,nvl(n.chan_save_deadline, o.chan_save_deadline) as chan_save_deadline -- 灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年
    ,nvl(n.chan_save_amt, o.chan_save_amt) as chan_save_amt -- 转存起点金额
    ,nvl(n.save_low_amt, o.save_low_amt) as save_low_amt -- 最低留存金额
    ,nvl(n.quickin_contract_if_succeed, o.quickin_contract_if_succeed) as quickin_contract_if_succeed -- 灵活盈签约操作是否成功(0-失败 1-成功)
    ,nvl(n.sign_type, o.sign_type) as sign_type -- 签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5
    ,nvl(n.third_ma_apply_tp, o.third_ma_apply_tp) as third_ma_apply_tp -- 三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
    ,nvl(n.third_ma_new_acct, o.third_ma_new_acct) as third_ma_new_acct -- 三方存管新账号
    ,nvl(n.is_acctfund_contract, o.is_acctfund_contract) as is_acctfund_contract -- 基金代销账户类签约操作 0-否，1-是
    ,nvl(n.acctfund_sign_type, o.acctfund_sign_type) as acctfund_sign_type -- 基金代销账户类签约种类 1-签约2-解约3-维护
    ,nvl(n.is_bill_send, o.is_bill_send) as is_bill_send -- 对账单寄送要求 1-寄送0-不寄送
    ,nvl(n.acctfund_ori_acct, o.acctfund_ori_acct) as acctfund_ori_acct -- 交易账户变更原账号 默认前“签约账号”项
    ,nvl(n.is_tradefund_contract, o.is_tradefund_contract) as is_tradefund_contract -- 基金代销交易类签约操作 0-否，1-是
    ,nvl(n.tradefund_sign_type, o.tradefund_sign_type) as tradefund_sign_type -- 基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更
    ,nvl(n.tradefund_name, o.tradefund_name) as tradefund_name -- 基金名称
    ,nvl(n.tradefund_code, o.tradefund_code) as tradefund_code -- 基金代码
    ,nvl(n.savings_invest_optp, o.savings_invest_optp) as savings_invest_optp -- 储蓄定投操作类型 1-终止 2-暂停 3-恢复
    ,nvl(n.time_invest_code, o.time_invest_code) as time_invest_code -- 定投编号
    ,nvl(n.third_manage_optp, o.third_manage_optp) as third_manage_optp -- 三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,nvl(n.fund_acct, o.fund_acct) as fund_acct -- 基金签约操作账号
    ,nvl(n.fund_acct_brcno, o.fund_acct_brcno) as fund_acct_brcno -- 基金签约账号开卡网点
    ,nvl(n.quickin_leave_amt, o.quickin_leave_amt) as quickin_leave_amt -- 灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)
    ,nvl(n.quickin_leave_amt_other, o.quickin_leave_amt_other) as quickin_leave_amt_other -- 灵活盈—活期账户留存金额_其它
    ,nvl(n.netb_op_choice, o.netb_op_choice) as netb_op_choice -- 网银修改服务选项(1登录密码 2手机动态密码)
    ,nvl(n.netb_password_optp, o.netb_password_optp) as netb_password_optp -- 网银登录密码操作类型(1重置 2解锁)
    ,nvl(n.netb_netphone_optp, o.netb_netphone_optp) as netb_netphone_optp -- 手机动态密码操作类型(0-不开通1开通2注销3指定手机号4变更手机号5关联)
    ,nvl(n.ukey_optp, o.ukey_optp) as ukey_optp -- 华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)
    ,nvl(n.is_sms_set_phone, o.is_sms_set_phone) as is_sms_set_phone -- 短信通是否设置签约手机号 0-否，1-是
    ,nvl(n.is_net_trans_limit_set, o.is_net_trans_limit_set) as is_net_trans_limit_set -- 是否网银转账限额设置 0-否，1-是
    ,nvl(n.is_mob_trans_limit_set, o.is_mob_trans_limit_set) as is_mob_trans_limit_set -- 手机银行是否非定向转账限额设置 0-否，1-是
    ,nvl(n.direct_trans_optp, o.direct_trans_optp) as direct_trans_optp -- 定向转账操作类型[1开通2修改3注销]
    ,nvl(n.is_direct_trans_ac_set, o.is_direct_trans_ac_set) as is_direct_trans_ac_set -- 是否定向收款账户设置[0-否，1-是]
    ,nvl(n.sms_set_phone_optp, o.sms_set_phone_optp) as sms_set_phone_optp -- 短信通设置签约手机号操作类型[1-开通 3-注销]
    ,nvl(n.fin_new_acct, o.fin_new_acct) as fin_new_acct -- 理财银行卡号变更新账号
    ,nvl(n.fin_new_open_brcno, o.fin_new_open_brcno) as fin_new_open_brcno -- 理财银行卡号变更新账号所属机构
    ,nvl(n.quickin_pass, o.quickin_pass) as quickin_pass -- 灵活盈交易密码(带账号转加密)
    ,nvl(n.cust_changes, o.cust_changes) as cust_changes -- 客户信息变更内容1.通讯地址2.邮政编码3.联系电话4.手机5.EMAIL
    ,nvl(n.tlr_mobile, o.tlr_mobile) as tlr_mobile -- 前台柜员手机号码
    ,nvl(n.deposit_trade_no, o.deposit_trade_no) as deposit_trade_no -- 交易单编号
    ,nvl(n.acct_type_m, o.acct_type_m) as acct_type_m -- 账号类型:0: 人民币个人非结算户1: 人民币个人结算户A: 外汇结算账户B: 乙种储蓄存款账户C: 丙种储蓄存款账户
    ,nvl(n.dsp_type, o.dsp_type) as dsp_type -- 储种:S01储蓄活期S02	储蓄双整S03	零存整取S04	整存零取S05	存本取息S06	定活两便S07	储蓄通知S08	教育储蓄S18:财富宝
    ,nvl(n.dsp_period, o.dsp_period) as dsp_period -- 存期:203-三个月、206-六个月、301-一年、302-二年、303-三年、305-五年、000-活期、101-一天、107-七天 、203-三个月、206-六个月、301-一年
    ,nvl(n.dsp_flag, o.dsp_flag) as dsp_flag -- 转存标识:1:自动转存0:非自动转存
    ,nvl(n.tran_type, o.tran_type) as tran_type -- 交易类型:CO-现开TO-转开
    ,nvl(n.to_acct_no, o.to_acct_no) as to_acct_no -- 转出账号
    ,nvl(n.to_acct_name, o.to_acct_name) as to_acct_name -- 转出账号名称
    ,nvl(n.to_pswd, o.to_pswd) as to_pswd -- 转出账号密码
    ,nvl(n.to_idtp, o.to_idtp) as to_idtp -- 转出证件类型:A:身份证,B:外国公民护照,C:户口薄,D:港澳居民通行证,E:还乡证,F:边民出入境通行证,G:军官证,H:士兵证,I:军事院校学员证,J:军队离休干部荣誉证,K:军官退休证,L:军人文职干部退休证,P:其他,Q:武警身份证,R:台湾居民通行证,S:中国公民护照,U:临时身份证
    ,nvl(n.to_idno, o.to_idno) as to_idno -- 转出证件号码
    ,nvl(n.to_dwfs, o.to_dwfs) as to_dwfs -- 转出支取方式：A:密码 D:印鉴 E:证件
    ,nvl(n.prcsna, o.prcsna) as prcsna -- 交易类型
    ,nvl(n.nwinrt, o.nwinrt) as nwinrt -- 利率
    ,nvl(n.matudt, o.matudt) as matudt -- 到期日
    ,nvl(n.valuedt, o.valuedt) as valuedt -- 起息日
    ,nvl(n.proxy_flag, o.proxy_flag) as proxy_flag -- 代办人类型（0-否 1-监护代理 2-普通代理）
    ,nvl(n.quickin_type, o.quickin_type) as quickin_type -- 灵活盈-储种（1-三个月 2-六个月 3-一年 4-二年 5-三年 6-五年 7-不约定存期 8-七天通知）
    ,nvl(n.acctlv, o.acctlv) as acctlv -- 账户分类
    ,nvl(n.is_card, o.is_card) as is_card -- 是否有卡
    ,nvl(n.regoresult, o.regoresult) as regoresult -- 1识别失败，0识别成功
    ,nvl(n.similarity, o.similarity) as similarity -- 0%~100%，>=80%为认定为本人
    ,nvl(n.issetnewpwd, o.issetnewpwd) as issetnewpwd -- 是否设置新密码
    ,nvl(n.isfcfnoper, o.isfcfnoper) as isfcfnoper -- 是否操作非柜面非同名限额签约(0-否,1-是)
    ,nvl(n.isfcfntype, o.isfcfntype) as isfcfntype -- 非柜面非同名账户限额签约操作类型(0-签约 1-维护)
    ,nvl(n.isfcfnct, o.isfcfnct) as isfcfnct -- 是否非柜面非同名账户限额签约(0-否,1-是)
    ,nvl(n.daylimit, o.daylimit) as daylimit -- 日累计限额(非柜面非同名账户限额签约)
    ,nvl(n.txntimeslimit, o.txntimeslimit) as txntimeslimit -- 日笔数限额(非柜面非同名账户限额签约)
    ,nvl(n.yearlimit, o.yearlimit) as yearlimit -- 年累计限额(非柜面非同名账户限额签约)
    ,nvl(n.is_fcfnct_succeed, o.is_fcfnct_succeed) as is_fcfnct_succeed -- 非柜面非同名账户限额签约是否成功(0-失败,1-成功)
    ,nvl(n.agreementid, o.agreementid) as agreementid -- ECIF签约协议号
    ,nvl(n.custom_daylimit, o.custom_daylimit) as custom_daylimit -- 自定义-日累计限额(万元)
    ,nvl(n.custom_txntimeslimit, o.custom_txntimeslimit) as custom_txntimeslimit -- 自定义-日累计笔数
    ,nvl(n.custom_yearlimit, o.custom_yearlimit) as custom_yearlimit -- 自定义-年累计限额(万元)
    ,nvl(n.pro_nationality, o.pro_nationality) as pro_nationality -- 代理人国籍
    ,nvl(n.mobile_type, o.mobile_type) as mobile_type -- 号码性质 0--本人1--监护人
    ,nvl(n.outflg, o.outflg) as outflg -- 外出标注-0，默认网点0：网点凭证 1：外出凭证
    ,nvl(n.netstate, o.netstate) as netstate -- 网银密码重置--状态默认送0
    ,nvl(n.logonpwnew, o.logonpwnew) as logonpwnew -- 网银密码重置--新登陆密码
    ,nvl(n.netreset, o.netreset) as netreset -- 是否网银密码重置
    ,nvl(n.relativetp, o.relativetp) as relativetp -- 监护人/亲属证件类型
    ,nvl(n.relativena, o.relativena) as relativena -- 监护人/亲属姓名
    ,nvl(n.relativeno, o.relativeno) as relativeno -- 监护人/亲属号码
    ,nvl(n.taxresident, o.taxresident) as taxresident -- 税收居民身份（1仅为中国税收居民2仅为非居民3既是中国税收居民又是其他国家（地区）税收居民4无需声明5空）
    ,nvl(n.birthplace, o.birthplace) as birthplace -- 纳税人出生地（中英文字符）
    ,nvl(n.taxarea, o.taxarea) as taxarea -- 税收居民国（地区）
    ,nvl(n.taxnumber, o.taxnumber) as taxnumber -- 纳税人识别号
    ,nvl(n.taxarea2, o.taxarea2) as taxarea2 -- 纳税居民国家（地区）2（发送报文时整合在TAXAREA）
    ,nvl(n.taxarea3, o.taxarea3) as taxarea3 -- 纳税居民国家（地区）3（发送报文时整合在TAXAREA）
    ,nvl(n.taxnumber2, o.taxnumber2) as taxnumber2 -- 纳税人识别号2（发送报文时整合在TAXNUMBER）
    ,nvl(n.taxnumber3, o.taxnumber3) as taxnumber3 -- 纳税人识别号3（发送报文时整合在TAXNUMBER）
    ,nvl(n.taxnullreason, o.taxnullreason) as taxnullreason -- 纳税人识别号为空原因
    ,nvl(n.taxstatement, o.taxstatement) as taxstatement -- 是否取得自证声明（0-未取得自证声明1-取得自证声明）
    ,nvl(n.customersurname, o.customersurname) as customersurname -- 客户_姓（字母）
    ,nvl(n.customergivenname, o.customergivenname) as customergivenname -- 客户_名（字母）
    ,nvl(n.taxnullreason2, o.taxnullreason2) as taxnullreason2 -- 纳税人识别号为空原因2
    ,nvl(n.taxnullreason3, o.taxnullreason3) as taxnullreason3 -- 纳税人识别号为空原因3
    ,nvl(n.boundaccno, o.boundaccno) as boundaccno -- 绑定账号
    ,nvl(n.boundbank, o.boundbank) as boundbank -- 绑定账号开户行
    ,nvl(n.checkcase, o.checkcase) as checkcase -- 落地审核原因
    ,nvl(n.ocridtdt, o.ocridtdt) as ocridtdt -- 证件生效日期
    ,nvl(n.yflag, o.yflag) as yflag -- 手机盾标志 Y:为是手机盾，N:为不是手机盾
    ,nvl(n.phoneoperate, o.phoneoperate) as phoneoperate -- 手机盾操作类型0：开通
    ,nvl(n.camp_emp_id, o.camp_emp_id) as camp_emp_id -- 营销工号
    ,nvl(n.notemessagephone1, o.notemessagephone1) as notemessagephone1 -- 短信通签约号码1
    ,nvl(n.notemessagephone2, o.notemessagephone2) as notemessagephone2 -- 短信通签约号码2
    ,nvl(n.notemessagephone3, o.notemessagephone3) as notemessagephone3 -- 短信通签约号码3
    ,nvl(n.notemessagephone4, o.notemessagephone4) as notemessagephone4 -- 短信通签约号码4
    ,nvl(n.notemessagephone5, o.notemessagephone5) as notemessagephone5 -- 短信通签约号码5
    ,nvl(n.isagtsch, o.isagtsch) as isagtsch -- 是否个人扣款协议签约(0-否,1-是)
    ,nvl(n.proxy_idtdt_sl, o.proxy_idtdt_sl) as proxy_idtdt_sl -- 是否云闪付绑定签约
    ,nvl(n.is_flashpay_contract, o.is_flashpay_contract) as is_flashpay_contract -- 云闪付绑定签约是否成功  0-失败 1-成功
    ,nvl(n.flashpay_contract_if_succeed, o.flashpay_contract_if_succeed) as flashpay_contract_if_succeed -- 
    ,nvl(n.local_ip, o.local_ip) as local_ip -- 开户IP
    ,nvl(n.local_mac, o.local_mac) as local_mac -- 开户MAC
    ,nvl(n.uuid, o.uuid) as uuid -- UUID
    ,nvl(n.ukey_modify_if_succeed, o.ukey_modify_if_succeed) as ukey_modify_if_succeed -- U盾管理状态
    ,nvl(n.is_send_message, o.is_send_message) as is_send_message -- 是否发送营销短信
    ,nvl(n.phonepay_contract_if_succeed, o.phonepay_contract_if_succeed) as phonepay_contract_if_succeed -- 手机转账签约是否成功(0-失败 1-成功)
    ,nvl(n.is_phonepay_contract, o.is_phonepay_contract) as is_phonepay_contract -- 是否手机转账签约(0-否 1-是)
    ,nvl(n.regedittype, o.regedittype) as regedittype -- 登记注册类型
    ,nvl(n.sco, o.sco) as sco -- 
    ,nvl(n.is_phonepay_contract1, o.is_phonepay_contract1) as is_phonepay_contract1 -- 是否手机转账签约(0-否 1-是)
    ,nvl(n.phonepay_contract_if_succeed1, o.phonepay_contract_if_succeed1) as phonepay_contract_if_succeed1 -- 手机转账签约是否成功(0-失败 1-成功)
    ,nvl(n.regedittype1, o.regedittype1) as regedittype1 -- 登记注册类型
    ,nvl(n.limit_oper_type, o.limit_oper_type) as limit_oper_type -- 非柜面签约
    ,nvl(n.limit_oper_channel, o.limit_oper_channel) as limit_oper_channel -- 
    ,nvl(n.day_transfer_count, o.day_transfer_count) as day_transfer_count -- 非柜面签约-日总笔数
    ,nvl(n.day_transfer_amount, o.day_transfer_amount) as day_transfer_amount -- 非柜面签约-日总限额
    ,nvl(n.year_transfer_count, o.year_transfer_count) as year_transfer_count -- 非柜面签约-年总笔数
    ,nvl(n.year_transfer_amount, o.year_transfer_amount) as year_transfer_amount -- 非柜面签约-年总限额
    ,nvl(n.limit_oper_result, o.limit_oper_result) as limit_oper_result -- 
    ,nvl(n.tally_state, o.tally_state) as tally_state -- 记账状态 0 未记账 1 记账成功 2 记账失败
    ,nvl(n.agt_num, o.agt_num) as agt_num -- 协议号
    ,nvl(n.dspbgndt, o.dspbgndt) as dspbgndt -- 转存起始日期
    ,nvl(n.dspenddt, o.dspenddt) as dspenddt -- 转存截止日期
    ,nvl(n.dsptyper, o.dsptyper) as dsptyper -- 转存类型 1 转存双整 2 转存通知
    ,nvl(n.invest_account, o.invest_account) as invest_account -- 储蓄定投签约账户
    ,nvl(n.invest_trnamt, o.invest_trnamt) as invest_trnamt -- 转存金额
    ,nvl(n.prd_id, o.prd_id) as prd_id -- 产品编号
    ,nvl(n.quickin_agreement_id, o.quickin_agreement_id) as quickin_agreement_id -- 灵活盈协议编号
    ,nvl(n.quickin_agreement_status, o.quickin_agreement_status) as quickin_agreement_status -- 灵活盈协议状态
    ,nvl(n.quickin_agreement_type, o.quickin_agreement_type) as quickin_agreement_type -- 灵活盈协议类型
    ,nvl(n.quickin_fin_fixed_amt, o.quickin_fin_fixed_amt) as quickin_fin_fixed_amt -- 灵活盈理财固定金额
    ,nvl(n.quickin_int_min_amt, o.quickin_int_min_amt) as quickin_int_min_amt -- 灵活盈最小起存金额
    ,nvl(n.quickin_remain_amt, o.quickin_remain_amt) as quickin_remain_amt -- 灵活盈协议留存金额
    ,nvl(n.quickin_start_amt, o.quickin_start_amt) as quickin_start_amt -- 灵活盈起始金额
    ,nvl(n.quickin_transfer_day, o.quickin_transfer_day) as quickin_transfer_day -- 划转日
    ,nvl(n.quickin_transfer_freq, o.quickin_transfer_freq) as quickin_transfer_freq -- 灵活盈划转频率
    ,nvl(n.redep_freq, o.redep_freq) as redep_freq -- 转存频率
    ,nvl(n.renew_corp, o.renew_corp) as renew_corp -- 转存单位
    ,nvl(n.rpdsp, o.rpdsp) as rpdsp -- 转存周期 Y-年 Q-季 M-月 W-周 D-天
    ,nvl(n.sub_acct_num, o.sub_acct_num) as sub_acct_num -- 子账号
    ,nvl(n.sum_sub_num, o.sum_sub_num) as sum_sub_num -- 汇总子户号
    ,nvl(n.biz_type, o.biz_type) as biz_type -- 业务种类
    ,nvl(n.biz_dt, o.biz_dt) as biz_dt -- 交易日期（yyyy-MM-dd hh:mm:ss）
    ,nvl(n.finance_card_type, o.finance_card_type) as finance_card_type -- 理财账户类型
    ,nvl(n.fin_new_acct_crspd_pty_id, o.fin_new_acct_crspd_pty_id) as fin_new_acct_crspd_pty_id -- 新账号对应客户号
    ,nvl(n.custchnlid, o.custchnlid) as custchnlid -- 开通渠道
    ,nvl(n.riskmonths, o.riskmonths) as riskmonths -- 风险有效期月数
    ,nvl(n.rskcd, o.rskcd) as rskcd -- 风险等级代码
    ,nvl(n.oper_flag, o.oper_flag) as oper_flag -- 1 客户级 2账户级
    ,nvl(n.third_chg_card_id, o.third_chg_card_id) as third_chg_card_id -- 三方存管换卡标识
    ,nvl(n.third_open_org_id, o.third_open_org_id) as third_open_org_id -- 三方存管开户机构
    ,nvl(n.usb_key_cert_id, o.usb_key_cert_id) as usb_key_cert_id -- USBKey证书编号
    ,nvl(n.old_cert_key_id, o.old_cert_key_id) as old_cert_key_id -- 旧证书KEYID
    ,nvl(n.safe_instr_model, o.safe_instr_model) as safe_instr_model -- 安全工具型号(0：飞天1：捷德)
    ,nvl(n.u_brch_num, o.u_brch_num) as u_brch_num -- U盾网点号
    ,nvl(n.u_oper_typ, o.u_oper_typ) as u_oper_typ -- U盾操作类型（2：注销 3：损坏更换 4：挂失更换 5：发放）
    ,nvl(n.wthr_out, o.wthr_out) as wthr_out -- 是否出库 默认Y Y：是 N：否
    ,nvl(n.lost_operate_method, o.lost_operate_method) as lost_operate_method -- 挂失操作方式，比如书面挂失、口头挂失UV-口头解挂 UW-正式解挂 VL-口挂 WL-书挂
    ,nvl(n.lost_no, o.lost_no) as lost_no -- 账户/凭证/结算卡挂失号码
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.loss_id, o.loss_id) as loss_id -- 挂失编号
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户序列号
    ,nvl(n.acct_password, o.acct_password) as acct_password -- 账户密码
    ,nvl(n.voucher_change_type, o.voucher_change_type) as voucher_change_type -- 凭证更换类型，比如挂失补发、损坏更换等，不同的更换类型会对应不同的处理流程 01-挂失补发 02-凭证更换 03-损坏更换 04-同号换卡领卡/记名卡领卡 05-单位存单置换 06-单位存单收回如果补开、凭证更换必传
    ,nvl(n.new_vchr_typ, o.new_vchr_typ) as new_vchr_typ -- 新凭证类型
    ,nvl(n.new_vchr_num, o.new_vchr_num) as new_vchr_num -- 新凭证号码
    ,nvl(n.voucher_change_reason, o.voucher_change_reason) as voucher_change_reason -- 更换原因
    ,nvl(n.td_inout_operate_type, o.td_inout_operate_type) as td_inout_operate_type -- 存单移入必传 定期账户转入转出操作类型 01-转入 02-互转 03-转出
    ,nvl(n.in_base_acct_no, o.in_base_acct_no) as in_base_acct_no -- 移入账号
    ,nvl(n.in_prod_type, o.in_prod_type) as in_prod_type -- 转入账户产品类型
    ,nvl(n.enter_acct_ccy, o.enter_acct_ccy) as enter_acct_ccy -- 转入账户币种
    ,nvl(n.target_acct_class, o.target_acct_class) as target_acct_class -- 目标账户类别（一二三类户），即账户升级后的账户类别，满足人行对于电子账户的管理办法1-一类账户 2-二类账户 3-三类账户
    ,nvl(n.password_operate_type, o.password_operate_type) as password_operate_type -- 账户密码操作类型 账户密码操作类型01-新建 02-重置 03-修改 04-解锁 05-校验 06-激活 07-凭证解挂场景密码重置 08-弱密码校验
    ,nvl(n.password_type, o.password_type) as password_type -- 密码类型，目前核心只支持WD，接口未上送则默认为WDWD-支取密码 QY-查询密码 MA-账户管理密码
    ,nvl(n.password_old, o.password_old) as password_old -- 旧密码
    ,nvl(n.iss_country, o.iss_country) as iss_country -- 发证国家
    ,nvl(n.password_effect_date, o.password_effect_date) as password_effect_date -- 密码生效日期
    ,nvl(n.lost_reason, o.lost_reason) as lost_reason -- 挂失原因
    ,nvl(n.res_flag, o.res_flag) as res_flag -- 标识挂失账户是N进行账户止付,挂失时必输，解挂时不需要输入Y-是 N-不是
    ,nvl(n.pause_post, o.pause_post) as pause_post -- 暂停附言
    ,nvl(n.channel, o.channel) as channel -- 渠道
    ,nvl(n.ntw_ceph_bank_pause_type, o.ntw_ceph_bank_pause_type) as ntw_ceph_bank_pause_type -- 网银手机银行管理 业务类型 01：个人动态密码管理 02：解锁登录密码 03：网银/手机银行暂停/恢复 04：登录密码和用户状态重置 05：客户手机盾信息维护 06：账户暂停/恢复
    ,nvl(n.ntw_ceph_bank_pause_pwd_status, o.ntw_ceph_bank_pause_pwd_status) as ntw_ceph_bank_pause_pwd_status -- 网银手机银行管理 密码状态：0:正常 7：重置网银密码 8：重置交易密码 9 : 柜面开户重置密码
    ,nvl(n.tfr_encry_ind, o.tfr_encry_ind) as tfr_encry_ind -- 转加密标识  1:数字加字母组合 0:纯数字(柜面调用)
    ,nvl(n.cfm_new_logon_pwd, o.cfm_new_logon_pwd) as cfm_new_logon_pwd -- 确认新登录密码
    ,nvl(n.pwd_keyb_node_id, o.pwd_keyb_node_id) as pwd_keyb_node_id -- 密码键盘节点ID
    ,nvl(n.safe_ceph_num, o.safe_ceph_num) as safe_ceph_num -- 安全手机号
    ,nvl(n.dynamic_password_status, o.dynamic_password_status) as dynamic_password_status -- 个人动态密码状态 ： 0---开 1---关
    ,nvl(n.pause_status, o.pause_status) as pause_status -- 网银/手机银行暂停/恢复 状态 0-正常 1-永久停止 2-临时暂停
    ,nvl(n.dynamic_password_ind_id, o.dynamic_password_ind_id) as dynamic_password_ind_id -- 个人动态密码标识编号 1：查询 2：新增 3：修改 4: 删除
    ,nvl(n.clous_shield_ind_id, o.clous_shield_ind_id) as clous_shield_ind_id -- 华兴云盾标识编号 1：设置密码 0：重置密码
    ,nvl(n.deft_safe_instr, o.deft_safe_instr) as deft_safe_instr -- 默认安全工具 1：华兴U盾 2：手机短信密码
    ,nvl(n.indv_act_status, o.indv_act_status) as indv_act_status -- 个人账户状态
    ,nvl(n.acct_pause_rsns, o.acct_pause_rsns) as acct_pause_rsns -- 账户暂停原因
    ,nvl(n.ntw_ceph_bank_pause_resu_status, o.ntw_ceph_bank_pause_resu_status) as ntw_ceph_bank_pause_resu_status -- 网银/手机银行暂停/恢复状态 0-正常 1-永久停止 2-临时暂停
    ,nvl(n.pause_with_resu_oper_typ, o.pause_with_resu_oper_typ) as pause_with_resu_oper_typ -- 暂停/恢复操作类型 0-网银 1-手机银行 2-网银手机银行
    ,nvl(n.temp_pause_start_tm, o.temp_pause_start_tm) as temp_pause_start_tm -- 临时暂停开始时间，格式为yyyyMMddHHmmss
    ,nvl(n.temp_pause_cncl_tm, o.temp_pause_cncl_tm) as temp_pause_cncl_tm -- 临时暂停结束时间，格式为yyyyMMddHHmmss
    ,nvl(n.ceph_cs_oper_typ, o.ceph_cs_oper_typ) as ceph_cs_oper_typ -- 手机盾信息操作类型 开通：0 停用：1 启用：2 注销：4
    ,nvl(n.cs_ord_nbr, o.cs_ord_nbr) as cs_ord_nbr -- 云盾序号
    ,nvl(n.open_br_node_num, o.open_br_node_num) as open_br_node_num -- 开通网点号
    ,nvl(n.key_name, o.key_name) as key_name -- 密钥名称
    ,nvl(n.total_cnt, o.total_cnt) as total_cnt -- 网银签约总笔数
    ,nvl(n.reg_typ, o.reg_typ) as reg_typ -- 手机号码支付协议注册类型 DFLT 默认账户 NDFT 非默认账户
    ,nvl(n.narrative1, o.narrative1) as narrative1 -- 备注
    ,nvl(n.prest_flg, o.prest_flg) as prest_flg -- 赠送标志 0-正常开通 1-赠送开通
    ,nvl(n.prest_mon, o.prest_mon) as prest_mon -- 赠送月份 如果是赠送服务（赠送标志为1），则填入赠送的月份数。没有此信息填空或“00”
    ,nvl(n.vip_flg, o.vip_flg) as vip_flg -- VIP标志 0-非VIP服务， 1-VIP服务，（默认填0，如果操作员选择了VIP服务标志，则填1），VIP针对客户而言。
    ,nvl(n.chrg_pkg_typ, o.chrg_pkg_typ) as chrg_pkg_typ -- 收费套餐类型 01包月/ 12包年。
    ,nvl(n.chrg_mode, o.chrg_mode) as chrg_mode -- 收费模式 1-按账户数收费 2-按服务数收费 3-按短信条数收费 4-按定额收费
    ,nvl(n.chrg_amt, o.chrg_amt) as chrg_amt -- 收费金额 请按字符串格式传输，如”RATE”:”0.56987” 当收费模式为定额收费时填写
    ,nvl(n.disct, o.disct) as disct -- 折扣 客户收费折扣
    ,nvl(n.disct_mon, o.disct_mon) as disct_mon -- 折扣月份 当存在折扣时，填写折扣有效月份，没有此信息则填空或00
    ,nvl(n.acct_purp, o.acct_purp) as acct_purp -- 账户用途
    ,nvl(n.acct_attr, o.acct_attr) as acct_attr -- 账户属性
    ,nvl(n.agtsch_prd_id, o.agtsch_prd_id) as agtsch_prd_id -- 个人扣款协议-产品编号
    ,nvl(n.agtsch_prd_type, o.agtsch_prd_type) as agtsch_prd_type -- 个人扣款协议  C-签约U-维护D-解约
    ,nvl(n.payer_acct, o.payer_acct) as payer_acct -- 付款人账号
    ,nvl(n.payer_acct_typ, o.payer_acct_typ) as payer_acct_typ -- 付款人账户类型
    ,nvl(n.payer_act_nm, o.payer_act_nm) as payer_act_nm -- 付款人账户户名
    ,nvl(n.payer_cert_typ, o.payer_cert_typ) as payer_cert_typ -- 付款人证件类型
    ,nvl(n.payer_cert_num, o.payer_cert_num) as payer_cert_num -- 付款人证件号
    ,nvl(n.payer_ceph_num, o.payer_ceph_num) as payer_ceph_num -- 付款人手机号
    ,nvl(n.payer_bank, o.payer_bank) as payer_bank -- 付款人开户行行号
    ,nvl(n.rcver_acct_typ, o.rcver_acct_typ) as rcver_acct_typ -- 收款人账户类型
    ,nvl(n.payee_base_acct_no, o.payee_base_acct_no) as payee_base_acct_no -- 收款人账号
    ,nvl(n.rcver_act_nm, o.rcver_act_nm) as rcver_act_nm -- 收款人账户户名
    ,nvl(n.chn_num, o.chn_num) as chn_num -- 渠道号
    ,nvl(n.sign_dtl, o.sign_dtl) as sign_dtl -- 签约明细
    ,nvl(n.dsp_trnamt, o.dsp_trnamt) as dsp_trnamt -- 转存周期 Y    年 Q    季 M    月 W    周 D    天
    ,nvl(n.redep_start_dt, o.redep_start_dt) as redep_start_dt -- 转存起始日期
    ,nvl(n.redep_end_dt, o.redep_end_dt) as redep_end_dt -- 转存截止日期
    ,nvl(n.pause_flg, o.pause_flg) as pause_flg -- 暂停标志 0 否 1 是
    ,nvl(n.node_num, o.node_num) as node_num -- 节点号
    ,nvl(n.third_chg_sign_prd, o.third_chg_sign_prd) as third_chg_sign_prd -- 签约产品 SV014银银合作代理第三方存管协议
    ,nvl(n.agt_typ, o.agt_typ) as agt_typ -- 协议类型CLD-存立得 DC-大额存单 DLS-贷利省 HQB-活期宝 JDL-加多利 KDT-卡贷通 KYD-卡易贷 PCP-资金池 WDL-稳得利 XDB-协定宝 XDCK-协定存款产品 XDL-先得利 YBWL-一本万利 YCD-英才贷 YDT-易贷通 YHT-一户通 ZHY-周享赢 ZXY-坐享其盈 ZZB-至尊宝 LOA-贷款 ODF-法人透支协议 FIN-卡理财协议 SMS-短信 PKG-费用套餐 FEE-暂不收费 PCD-周期性强制扣划 ACC-协定存款协议 SWP-账户清扫协议 ID-智能存款协议 SL-金额补足协议 REC-回单签约 ES-电票签约 YD-约定 NTE-活期智能存款 PAS-隐私账户签约 TXY1-同兴赢活期签约 TXY2-跨境资金融入签约 CXDT-储蓄定投 TBCK-跳板存款 LHY-灵活盈 P2P-P2P协议 JZG-建筑港 ZCG-资产存管 ZQS-资金清算 LYE-财政零余额
    ,nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.agt_status_cd, o.agt_status_cd) as agt_status_cd -- 协议状态 普通协议使用，可应用于大部分场景，贷款模块用于资产证券化合同状态A-生效 E-失效 YB-赎回 YS-发行 YP-已封包 NP-未封包 NS-未发行 YC-已撤包
    ,nvl(n.st_dt, o.st_dt) as st_dt -- 开始日期
    ,nvl(n.end_dt_ora, o.end_dt_ora) as end_dt_ora -- 结束日期
    ,nvl(n.sign_prod_type, o.sign_prod_type) as sign_prod_type -- 签约产品类型
    ,nvl(n.remain_amt, o.remain_amt) as remain_amt -- 协议留存金额 请按字符串格式传输，如”RATE”:”0.56987” 协议留存金额
    ,nvl(n.start_amt, o.start_amt) as start_amt -- 起始金额 请按字符串格式传输，如”RATE”:”0.56987” 起始金额
    ,nvl(n.transfer_freq_type, o.transfer_freq_type) as transfer_freq_type -- 划转频率类型 Y-年 Q-季 M-月 W-周 D-日
    ,nvl(n.acct_movt_date, o.acct_movt_date) as acct_movt_date -- 转存交易日期
    ,nvl(n.peri, o.peri) as peri -- 存期
    ,nvl(n.term_type, o.term_type) as term_type -- 期限单位 Y-年 Q-季 M-月 W-周 D-日
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理
    ,nvl(n.transfer_end_date, o.transfer_end_date) as transfer_end_date -- 转存结束日期
    ,nvl(n.transfer_day, o.transfer_day) as transfer_day -- 划转日
    ,nvl(n.transfer_freq, o.transfer_freq) as transfer_freq -- 划转频率
    ,nvl(n.fin_fixed_amt, o.fin_fixed_amt) as fin_fixed_amt -- 理财固定金额 请按字符串格式传输，如”RATE”:”0.56987”
    ,nvl(n.min_depo_amt, o.min_depo_amt) as min_depo_amt -- 最小起存金额 请按字符串格式传输，如”RATE”:”0.56987” 最小起存金额
    ,nvl(n.opt_type, o.opt_type) as opt_type -- 资管信托代销协议操作类型 01签约 02解约 03维护
    ,nvl(n.matn_oper_typ, o.matn_oper_typ) as matn_oper_typ -- 维护操作类型 0-客户信息维护 1-客户经理代码维护
    ,nvl(n.actl_benef, o.actl_benef) as actl_benef -- 实际受益人 0-本人（默认） 1-他人
    ,nvl(n.wthr_exist_actl_ctrl_rela, o.wthr_exist_actl_ctrl_rela) as wthr_exist_actl_ctrl_rela -- 是否存在实际控制关系 0-否（默认） 1-是
    ,nvl(n.wthr_is_np_integrity_rec, o.wthr_is_np_integrity_rec) as wthr_is_np_integrity_rec -- 是否有不良诚信记录 0-否（默认） 1-是
    ,nvl(n.ori_pty_mgr_cd, o.ori_pty_mgr_cd) as ori_pty_mgr_cd -- 原客户经理代码
    ,nvl(n.new_pty_mgr_cd, o.new_pty_mgr_cd) as new_pty_mgr_cd -- 新客户经理代码
    ,nvl(n.pty_mgr_adj_flg, o.pty_mgr_adj_flg) as pty_mgr_adj_flg -- 客户经理调整标志 0－全部（将原客户经理替换成新客经理） 1－调整客户所属客户经理代码 2－理财账号客户经理代码 3－按流水客户经理 4－调整定投客户经理代码 5－调整定赎客户经理代码 8－调整客户对应所有客户经理
    ,nvl(n.spec_seq_num, o.spec_seq_num) as spec_seq_num -- 指定流水号
    ,nvl(n.enro_ceph_num, o.enro_ceph_num) as enro_ceph_num -- 注册手机号
    ,nvl(n.acct_typ, o.acct_typ) as acct_typ -- 账户类型 01 - 为Ⅰ类户（非信用卡） 02 - 为Ⅱ类户 03 - 为Ⅲ类户 04-准贷记卡 05-借贷合一卡 不填-信用卡
    ,nvl(n.zone_num, o.zone_num) as zone_num -- 地区码 建议需求方至少定位到省市、直辖市级地区区位。默认为0000，长度为4 位
    ,nvl(n.scene_num, o.scene_num) as scene_num -- 云闪付场景码
    ,nvl(n.card_prd_id, o.card_prd_id) as card_prd_id -- 卡产品编号
    ,nvl(n.txn_equip_info, o.txn_equip_info) as txn_equip_info -- 交易设备信息
    ,nvl(n.put_new_fld, o.put_new_fld) as put_new_fld -- 拉新字段
    ,nvl(n.cvn_num, o.cvn_num) as cvn_num -- CVN码
    ,nvl(n.valid_dt, o.valid_dt) as valid_dt -- 有效期
    ,nvl(n.bcs_res_ceph_num_flg, o.bcs_res_ceph_num_flg) as bcs_res_ceph_num_flg -- 核心预留手机号标志 1代表是核心预留手机号 0代表非核心预留手机号
    ,nvl(n.short_lett_srv_type, o.short_lett_srv_type) as short_lett_srv_type -- 短信服务类 短信服务类，以逗号分隔（A,B）
    ,nvl(n.ceph_num_app_scope, o.ceph_num_app_scope) as ceph_num_app_scope -- 手机号码应用范围 1-只修改该账号下对应的手机号码 2-修改客户所有账号对应的手机号码，填1时必须填写签约账号
    ,nvl(n.old_ceph_num, o.old_ceph_num) as old_ceph_num -- 旧手机号码
    ,nvl(n.new_ceph_num, o.new_ceph_num) as new_ceph_num -- 新手机号码
    ,nvl(n.ceph_num_qty, o.ceph_num_qty) as ceph_num_qty -- 手机号码个数
    ,nvl(n.direct_sign_matn_flg, o.direct_sign_matn_flg) as direct_sign_matn_flg -- 定向转账签约维护标志 0-解约, 1-更新, 2-签约
    ,nvl(n.direct_sign_typ, o.direct_sign_typ) as direct_sign_typ -- 定向转账签约类型 0-综合柜面, 1-流程银行
    ,nvl(n.ghb_out_ind, o.ghb_out_ind) as ghb_out_ind -- 行内外标识 0-行内 1-行外
    ,nvl(n.bank_id, o.bank_id) as bank_id -- 银行编号
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 银行名称
    ,nvl(n.provin_cd, o.provin_cd) as provin_cd -- 省份代码
    ,nvl(n.city_cd, o.city_cd) as city_cd -- 城市代码
    ,nvl(n.rcv_open_brch_id, o.rcv_open_brch_id) as rcv_open_brch_id -- 收款方开户网点编号
    ,nvl(n.rcv_open_brch_name, o.rcv_open_brch_name) as rcv_open_brch_name -- 收款方开户网点名称
    ,nvl(n.rcver_ceph_num, o.rcver_ceph_num) as rcver_ceph_num -- 收款人手机号码
    ,nvl(n.recv_acct_upda_flg, o.recv_acct_upda_flg) as recv_acct_upda_flg -- 收款账户更新标志 收款账户更新标志0：删除 1：更新,2：增加（SIGNUPDATEFLAG=0时，系统默认0，SIGNUPDATEFLAG=2时，系统默认为2）
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_personal_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_personal_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.process_inst_id <> n.process_inst_id
        or o.main_flow_id <> n.main_flow_id
        or o.scan_seq_no <> n.scan_seq_no
        or o.fr_org_code <> n.fr_org_code
        or o.tr_date <> n.tr_date
        or o.biz_code <> n.biz_code
        or o.voucher_no <> n.voucher_no
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.english_name <> n.english_name
        or o.sex <> n.sex
        or o.cert_type <> n.cert_type
        or o.cert_code <> n.cert_code
        or o.crt_cert_organ <> n.crt_cert_organ
        or o.birthday <> n.birthday
        or o.weblock_flag <> n.weblock_flag
        or o.education <> n.education
        or o.occupation <> n.occupation
        or o.rank <> n.rank
        or o.income <> n.income
        or o.company <> n.company
        or o.home_address <> n.home_address
        or o.fix_telephone <> n.fix_telephone
        or o.office_phone <> n.office_phone
        or o.home_phone <> n.home_phone
        or o.mobile <> n.mobile
        or o.contact_address <> n.contact_address
        or o.postcode <> n.postcode
        or o.acct_type <> n.acct_type
        or o.spec_type <> n.spec_type
        or o.sf_scp_flag <> n.sf_scp_flag
        or o.curr_type <> n.curr_type
        or o.cf_flag <> n.cf_flag
        or o.fee_drw_type <> n.fee_drw_type
        or o.spec_time <> n.spec_time
        or o.amount <> n.amount
        or o.biz_password <> n.biz_password
        or o.biz_account <> n.biz_account
        or o.open_acct_password <> n.open_acct_password
        or o.tr_account <> n.tr_account
        or o.tr_password <> n.tr_password
        or o.attor_opr_code <> n.attor_opr_code
        or o.attor_opr_name <> n.attor_opr_name
        or o.attor_org_code <> n.attor_org_code
        or o.level_b_pin <> n.level_b_pin
        or o.fr_tlr_opr_no <> n.fr_tlr_opr_no
        or o.puc_check_flag <> n.puc_check_flag
        or o.check_option <> n.check_option
        or o.check_remark <> n.check_remark
        or o.check_opr_code <> n.check_opr_code
        or o.puc_chk_date <> n.puc_chk_date
        or o.update_flag <> n.update_flag
        or o.check_status <> n.check_status
        or o.check_fall_reason <> n.check_fall_reason
        or o.succ_flag <> n.succ_flag
        or o.status <> n.status
        or o.home_addr_type <> n.home_addr_type
        or o.company_type <> n.company_type
        or o.obtain_opr_code <> n.obtain_opr_code
        or o.commission <> n.commission
        or o.email <> n.email
        or o.often_site <> n.often_site
        or o.relation <> n.relation
        or o.nationality <> n.nationality
        or o.pro_name <> n.pro_name
        or o.pro_type <> n.pro_type
        or o.pro_fashion <> n.pro_fashion
        or o.is_porxy <> n.is_porxy
        or o.accept_no <> n.accept_no
        or o.trane_code <> n.trane_code
        or o.idtfna_name <> n.idtfna_name
        or o.pro_cert_code <> n.pro_cert_code
        or o.is_net_silver_contract <> n.is_net_silver_contract
        or o.open_flag <> n.open_flag
        or o.group_flag <> n.group_flag
        or o.netb_passwd <> n.netb_passwd
        or o.netb_left_msg <> n.netb_left_msg
        or o.netb_sign_mobile <> n.netb_sign_mobile
        or o.netb_sec_model <> n.netb_sec_model
        or o.netb_sec_type <> n.netb_sec_type
        or o.netb_sec_no <> n.netb_sec_no
        or o.netb_dynamic_opt_no <> n.netb_dynamic_opt_no
        or o.netb_dynamic_card_no <> n.netb_dynamic_card_no
        or o.netb_is_transfer <> n.netb_is_transfer
        or o.netb_ac_limit_pertrs <> n.netb_ac_limit_pertrs
        or o.netb_ac_limit_perday <> n.netb_ac_limit_perday
        or o.cert_date <> n.cert_date
        or o.id_address <> n.id_address
        or o.is_sms_contract <> n.is_sms_contract
        or o.is_tel_n_trnsf <> n.is_tel_n_trnsf
        or o.is_tel_n_trnsf_default_limit <> n.is_tel_n_trnsf_default_limit
        or o.tel_n_trnsf_single_limit <> n.tel_n_trnsf_single_limit
        or o.tel_n_trnsf_day_limit <> n.tel_n_trnsf_day_limit
        or o.is_tel_d_trnsf <> n.is_tel_d_trnsf
        or o.is_tel_d_trnsf_no_limit <> n.is_tel_d_trnsf_no_limit
        or o.tel_d_trnsf_single_limit <> n.tel_d_trnsf_single_limit
        or o.tel_d_trnsf_day_limit <> n.tel_d_trnsf_day_limit
        or o.payee_name1 <> n.payee_name1
        or o.payee_accno1 <> n.payee_accno1
        or o.payee_bank_name1 <> n.payee_bank_name1
        or o.payee_name2 <> n.payee_name2
        or o.payee_accno2 <> n.payee_accno2
        or o.payee_bank_name2 <> n.payee_bank_name2
        or o.sms_notice_limit <> n.sms_notice_limit
        or o.sec_node_id <> n.sec_node_id
        or o.proxy_sex <> n.proxy_sex
        or o.proxy_idtdt <> n.proxy_idtdt
        or o.proxy_id_address <> n.proxy_id_address
        or o.sms_contract_if_succeed <> n.sms_contract_if_succeed
        or o.net_silver_contract_succeed <> n.net_silver_contract_succeed
        or o.is_netb_default_limit <> n.is_netb_default_limit
        or o.prsntg <> n.prsntg
        or o.staffflag <> n.staffflag
        or o.custlv <> n.custlv
        or o.risklv <> n.risklv
        or o.wkutad <> n.wkutad
        or o.roleid <> n.roleid
        or o.worktx <> n.worktx
        or o.csec_node_id <> n.csec_node_id
        or o.netb_csec_passwd <> n.netb_csec_passwd
        or o.transfer_channel <> n.transfer_channel
        or o.mobile_ac_limit_pertrs <> n.mobile_ac_limit_pertrs
        or o.mobile_ac_limit_perday <> n.mobile_ac_limit_perday
        or o.is_mobile_default_limit <> n.is_mobile_default_limit
        or o.fax <> n.fax
        or o.area_code <> n.area_code
        or o.truth_flag <> n.truth_flag
        or o.trnamt <> n.trnamt
        or o.voucherty <> n.voucherty
        or o.id_check_result <> n.id_check_result
        or o.mobile_open_status <> n.mobile_open_status
        or o.account_update_flag <> n.account_update_flag
        or o.submit_status <> n.submit_status
        or o.netb_biz_type <> n.netb_biz_type
        or o.often_site_eq_id_addr <> n.often_site_eq_id_addr
        or o.net_ukey <> n.net_ukey
        or o.card_type <> n.card_type
        or o.card_rank <> n.card_rank
        or o.is_finance_contract <> n.is_finance_contract
        or o.sendfreq <> n.sendfreq
        or o.sendmode <> n.sendmode
        or o.risklevel <> n.risklevel
        or o.clientgroup <> n.clientgroup
        or o.chnlflag <> n.chnlflag
        or o.finance_contract_succeed <> n.finance_contract_succeed
        or o.finance_acctno <> n.finance_acctno
        or o.open_brcno <> n.open_brcno
        or o.cust_mgrno <> n.cust_mgrno
        or o.sms_cust_sign <> n.sms_cust_sign
        or o.fee_acct_no <> n.fee_acct_no
        or o.fee_acct_brcno <> n.fee_acct_brcno
        or o.fee_acct_nodeno <> n.fee_acct_nodeno
        or o.contact_phone <> n.contact_phone
        or o.attbrn <> n.attbrn
        or o.new_password <> n.new_password
        or o.new_account <> n.new_account
        or o.chactg <> n.chactg
        or o.stpytg <> n.stpytg
        or o.rplsfs <> n.rplsfs
        or o.submit_state <> n.submit_state
        or o.netopflag <> n.netopflag
        or o.smsopflag <> n.smsopflag
        or o.finopflag <> n.finopflag
        or o.delukey <> n.delukey
        or o.bgnamt <> n.bgnamt
        or o.trtmrs <> n.trtmrs
        or o.loss_date <> n.loss_date
        or o.loss_reg_no <> n.loss_reg_no
        or o.undays <> n.undays
        or o.payway <> n.payway
        or o.is_fund_contract <> n.is_fund_contract
        or o.fundopflag <> n.fundopflag
        or o.fin_manager_id <> n.fin_manager_id
        or o.szsecno <> n.szsecno
        or o.shsecno <> n.shsecno
        or o.minorflag <> n.minorflag
        or o.fundnewacct <> n.fundnewacct
        or o.fund_contract_if_succeed <> n.fund_contract_if_succeed
        or o.is_third_manage_contract <> n.is_third_manage_contract
        or o.cobank <> n.cobank
        or o.ori_acct <> n.ori_acct
        or o.ori_brcode <> n.ori_brcode
        or o.bond_acct <> n.bond_acct
        or o.bond_pass <> n.bond_pass
        or o.bond_code <> n.bond_code
        or o.bond_name <> n.bond_name
        or o.third_manage_if_succeed <> n.third_manage_if_succeed
        or o.is_invest_contract <> n.is_invest_contract
        or o.invest_opflag <> n.invest_opflag
        or o.invest_contract_if_succeed <> n.invest_contract_if_succeed
        or o.is_quickin_contract <> n.is_quickin_contract
        or o.quickin_opflag <> n.quickin_opflag
        or o.chan_save_tp <> n.chan_save_tp
        or o.chan_save_deadline <> n.chan_save_deadline
        or o.chan_save_amt <> n.chan_save_amt
        or o.save_low_amt <> n.save_low_amt
        or o.quickin_contract_if_succeed <> n.quickin_contract_if_succeed
        or o.sign_type <> n.sign_type
        or o.third_ma_apply_tp <> n.third_ma_apply_tp
        or o.third_ma_new_acct <> n.third_ma_new_acct
        or o.is_acctfund_contract <> n.is_acctfund_contract
        or o.acctfund_sign_type <> n.acctfund_sign_type
        or o.is_bill_send <> n.is_bill_send
        or o.acctfund_ori_acct <> n.acctfund_ori_acct
        or o.is_tradefund_contract <> n.is_tradefund_contract
        or o.tradefund_sign_type <> n.tradefund_sign_type
        or o.tradefund_name <> n.tradefund_name
        or o.tradefund_code <> n.tradefund_code
        or o.savings_invest_optp <> n.savings_invest_optp
        or o.time_invest_code <> n.time_invest_code
        or o.third_manage_optp <> n.third_manage_optp
        or o.fund_acct <> n.fund_acct
        or o.fund_acct_brcno <> n.fund_acct_brcno
        or o.quickin_leave_amt <> n.quickin_leave_amt
        or o.quickin_leave_amt_other <> n.quickin_leave_amt_other
        or o.netb_op_choice <> n.netb_op_choice
        or o.netb_password_optp <> n.netb_password_optp
        or o.netb_netphone_optp <> n.netb_netphone_optp
        or o.ukey_optp <> n.ukey_optp
        or o.is_sms_set_phone <> n.is_sms_set_phone
        or o.is_net_trans_limit_set <> n.is_net_trans_limit_set
        or o.is_mob_trans_limit_set <> n.is_mob_trans_limit_set
        or o.direct_trans_optp <> n.direct_trans_optp
        or o.is_direct_trans_ac_set <> n.is_direct_trans_ac_set
        or o.sms_set_phone_optp <> n.sms_set_phone_optp
        or o.fin_new_acct <> n.fin_new_acct
        or o.fin_new_open_brcno <> n.fin_new_open_brcno
        or o.quickin_pass <> n.quickin_pass
        or o.cust_changes <> n.cust_changes
        or o.tlr_mobile <> n.tlr_mobile
        or o.deposit_trade_no <> n.deposit_trade_no
        or o.acct_type_m <> n.acct_type_m
        or o.dsp_type <> n.dsp_type
        or o.dsp_period <> n.dsp_period
        or o.dsp_flag <> n.dsp_flag
        or o.tran_type <> n.tran_type
        or o.to_acct_no <> n.to_acct_no
        or o.to_acct_name <> n.to_acct_name
        or o.to_pswd <> n.to_pswd
        or o.to_idtp <> n.to_idtp
        or o.to_idno <> n.to_idno
        or o.to_dwfs <> n.to_dwfs
        or o.prcsna <> n.prcsna
        or o.nwinrt <> n.nwinrt
        or o.matudt <> n.matudt
        or o.valuedt <> n.valuedt
        or o.proxy_flag <> n.proxy_flag
        or o.quickin_type <> n.quickin_type
        or o.acctlv <> n.acctlv
        or o.is_card <> n.is_card
        or o.regoresult <> n.regoresult
        or o.similarity <> n.similarity
        or o.issetnewpwd <> n.issetnewpwd
        or o.isfcfnoper <> n.isfcfnoper
        or o.isfcfntype <> n.isfcfntype
        or o.isfcfnct <> n.isfcfnct
        or o.daylimit <> n.daylimit
        or o.txntimeslimit <> n.txntimeslimit
        or o.yearlimit <> n.yearlimit
        or o.is_fcfnct_succeed <> n.is_fcfnct_succeed
        or o.agreementid <> n.agreementid
        or o.custom_daylimit <> n.custom_daylimit
        or o.custom_txntimeslimit <> n.custom_txntimeslimit
        or o.custom_yearlimit <> n.custom_yearlimit
        or o.pro_nationality <> n.pro_nationality
        or o.mobile_type <> n.mobile_type
        or o.outflg <> n.outflg
        or o.netstate <> n.netstate
        or o.logonpwnew <> n.logonpwnew
        or o.netreset <> n.netreset
        or o.relativetp <> n.relativetp
        or o.relativena <> n.relativena
        or o.relativeno <> n.relativeno
        or o.taxresident <> n.taxresident
        or o.birthplace <> n.birthplace
        or o.taxarea <> n.taxarea
        or o.taxnumber <> n.taxnumber
        or o.taxarea2 <> n.taxarea2
        or o.taxarea3 <> n.taxarea3
        or o.taxnumber2 <> n.taxnumber2
        or o.taxnumber3 <> n.taxnumber3
        or o.taxnullreason <> n.taxnullreason
        or o.taxstatement <> n.taxstatement
        or o.customersurname <> n.customersurname
        or o.customergivenname <> n.customergivenname
        or o.taxnullreason2 <> n.taxnullreason2
        or o.taxnullreason3 <> n.taxnullreason3
        or o.boundaccno <> n.boundaccno
        or o.boundbank <> n.boundbank
        or o.checkcase <> n.checkcase
        or o.ocridtdt <> n.ocridtdt
        or o.yflag <> n.yflag
        or o.phoneoperate <> n.phoneoperate
        or o.camp_emp_id <> n.camp_emp_id
        or o.notemessagephone1 <> n.notemessagephone1
        or o.notemessagephone2 <> n.notemessagephone2
        or o.notemessagephone3 <> n.notemessagephone3
        or o.notemessagephone4 <> n.notemessagephone4
        or o.notemessagephone5 <> n.notemessagephone5
        or o.isagtsch <> n.isagtsch
        or o.proxy_idtdt_sl <> n.proxy_idtdt_sl
        or o.is_flashpay_contract <> n.is_flashpay_contract
        or o.flashpay_contract_if_succeed <> n.flashpay_contract_if_succeed
        or o.local_ip <> n.local_ip
        or o.local_mac <> n.local_mac
        or o.uuid <> n.uuid
        or o.ukey_modify_if_succeed <> n.ukey_modify_if_succeed
        or o.is_send_message <> n.is_send_message
        or o.phonepay_contract_if_succeed <> n.phonepay_contract_if_succeed
        or o.is_phonepay_contract <> n.is_phonepay_contract
        or o.regedittype <> n.regedittype
        or o.sco <> n.sco
        or o.is_phonepay_contract1 <> n.is_phonepay_contract1
        or o.phonepay_contract_if_succeed1 <> n.phonepay_contract_if_succeed1
        or o.regedittype1 <> n.regedittype1
        or o.limit_oper_type <> n.limit_oper_type
        or o.limit_oper_channel <> n.limit_oper_channel
        or o.day_transfer_count <> n.day_transfer_count
        or o.day_transfer_amount <> n.day_transfer_amount
        or o.year_transfer_count <> n.year_transfer_count
        or o.year_transfer_amount <> n.year_transfer_amount
        or o.limit_oper_result <> n.limit_oper_result
        or o.tally_state <> n.tally_state
        or o.agt_num <> n.agt_num
        or o.dspbgndt <> n.dspbgndt
        or o.dspenddt <> n.dspenddt
        or o.dsptyper <> n.dsptyper
        or o.invest_account <> n.invest_account
        or o.invest_trnamt <> n.invest_trnamt
        or o.prd_id <> n.prd_id
        or o.quickin_agreement_id <> n.quickin_agreement_id
        or o.quickin_agreement_status <> n.quickin_agreement_status
        or o.quickin_agreement_type <> n.quickin_agreement_type
        or o.quickin_fin_fixed_amt <> n.quickin_fin_fixed_amt
        or o.quickin_int_min_amt <> n.quickin_int_min_amt
        or o.quickin_remain_amt <> n.quickin_remain_amt
        or o.quickin_start_amt <> n.quickin_start_amt
        or o.quickin_transfer_day <> n.quickin_transfer_day
        or o.quickin_transfer_freq <> n.quickin_transfer_freq
        or o.redep_freq <> n.redep_freq
        or o.renew_corp <> n.renew_corp
        or o.rpdsp <> n.rpdsp
        or o.sub_acct_num <> n.sub_acct_num
        or o.sum_sub_num <> n.sum_sub_num
        or o.biz_type <> n.biz_type
        or o.biz_dt <> n.biz_dt
        or o.finance_card_type <> n.finance_card_type
        or o.fin_new_acct_crspd_pty_id <> n.fin_new_acct_crspd_pty_id
        or o.custchnlid <> n.custchnlid
        or o.riskmonths <> n.riskmonths
        or o.rskcd <> n.rskcd
        or o.oper_flag <> n.oper_flag
        or o.third_chg_card_id <> n.third_chg_card_id
        or o.third_open_org_id <> n.third_open_org_id
        or o.usb_key_cert_id <> n.usb_key_cert_id
        or o.old_cert_key_id <> n.old_cert_key_id
        or o.safe_instr_model <> n.safe_instr_model
        or o.u_brch_num <> n.u_brch_num
        or o.u_oper_typ <> n.u_oper_typ
        or o.wthr_out <> n.wthr_out
        or o.lost_operate_method <> n.lost_operate_method
        or o.lost_no <> n.lost_no
        or o.acct_name <> n.acct_name
        or o.loss_id <> n.loss_id
        or o.acct_seq_no <> n.acct_seq_no
        or o.acct_password <> n.acct_password
        or o.voucher_change_type <> n.voucher_change_type
        or o.new_vchr_typ <> n.new_vchr_typ
        or o.new_vchr_num <> n.new_vchr_num
        or o.voucher_change_reason <> n.voucher_change_reason
        or o.td_inout_operate_type <> n.td_inout_operate_type
        or o.in_base_acct_no <> n.in_base_acct_no
        or o.in_prod_type <> n.in_prod_type
        or o.enter_acct_ccy <> n.enter_acct_ccy
        or o.target_acct_class <> n.target_acct_class
        or o.password_operate_type <> n.password_operate_type
        or o.password_type <> n.password_type
        or o.password_old <> n.password_old
        or o.iss_country <> n.iss_country
        or o.password_effect_date <> n.password_effect_date
        or o.lost_reason <> n.lost_reason
        or o.res_flag <> n.res_flag
        or o.pause_post <> n.pause_post
        or o.channel <> n.channel
        or o.ntw_ceph_bank_pause_type <> n.ntw_ceph_bank_pause_type
        or o.ntw_ceph_bank_pause_pwd_status <> n.ntw_ceph_bank_pause_pwd_status
        or o.tfr_encry_ind <> n.tfr_encry_ind
        or o.cfm_new_logon_pwd <> n.cfm_new_logon_pwd
        or o.pwd_keyb_node_id <> n.pwd_keyb_node_id
        or o.safe_ceph_num <> n.safe_ceph_num
        or o.dynamic_password_status <> n.dynamic_password_status
        or o.pause_status <> n.pause_status
        or o.dynamic_password_ind_id <> n.dynamic_password_ind_id
        or o.clous_shield_ind_id <> n.clous_shield_ind_id
        or o.deft_safe_instr <> n.deft_safe_instr
        or o.indv_act_status <> n.indv_act_status
        or o.acct_pause_rsns <> n.acct_pause_rsns
        or o.ntw_ceph_bank_pause_resu_status <> n.ntw_ceph_bank_pause_resu_status
        or o.pause_with_resu_oper_typ <> n.pause_with_resu_oper_typ
        or o.temp_pause_start_tm <> n.temp_pause_start_tm
        or o.temp_pause_cncl_tm <> n.temp_pause_cncl_tm
        or o.ceph_cs_oper_typ <> n.ceph_cs_oper_typ
        or o.cs_ord_nbr <> n.cs_ord_nbr
        or o.open_br_node_num <> n.open_br_node_num
        or o.key_name <> n.key_name
        or o.total_cnt <> n.total_cnt
        or o.reg_typ <> n.reg_typ
        or o.narrative1 <> n.narrative1
        or o.prest_flg <> n.prest_flg
        or o.prest_mon <> n.prest_mon
        or o.vip_flg <> n.vip_flg
        or o.chrg_pkg_typ <> n.chrg_pkg_typ
        or o.chrg_mode <> n.chrg_mode
        or o.chrg_amt <> n.chrg_amt
        or o.disct <> n.disct
        or o.disct_mon <> n.disct_mon
        or o.acct_purp <> n.acct_purp
        or o.acct_attr <> n.acct_attr
        or o.agtsch_prd_id <> n.agtsch_prd_id
        or o.agtsch_prd_type <> n.agtsch_prd_type
        or o.payer_acct <> n.payer_acct
        or o.payer_acct_typ <> n.payer_acct_typ
        or o.payer_act_nm <> n.payer_act_nm
        or o.payer_cert_typ <> n.payer_cert_typ
        or o.payer_cert_num <> n.payer_cert_num
        or o.payer_ceph_num <> n.payer_ceph_num
        or o.payer_bank <> n.payer_bank
        or o.rcver_acct_typ <> n.rcver_acct_typ
        or o.payee_base_acct_no <> n.payee_base_acct_no
        or o.rcver_act_nm <> n.rcver_act_nm
        or o.chn_num <> n.chn_num
        or o.sign_dtl <> n.sign_dtl
        or o.dsp_trnamt <> n.dsp_trnamt
        or o.redep_start_dt <> n.redep_start_dt
        or o.redep_end_dt <> n.redep_end_dt
        or o.pause_flg <> n.pause_flg
        or o.node_num <> n.node_num
        or o.third_chg_sign_prd <> n.third_chg_sign_prd
        or o.agt_typ <> n.agt_typ
        or o.agt_id <> n.agt_id
        or o.agt_status_cd <> n.agt_status_cd
        or o.st_dt <> n.st_dt
        or o.end_dt_ora <> n.end_dt_ora
        or o.sign_prod_type <> n.sign_prod_type
        or o.remain_amt <> n.remain_amt
        or o.start_amt <> n.start_amt
        or o.transfer_freq_type <> n.transfer_freq_type
        or o.acct_movt_date <> n.acct_movt_date
        or o.peri <> n.peri
        or o.term_type <> n.term_type
        or o.acct_exec <> n.acct_exec
        or o.transfer_end_date <> n.transfer_end_date
        or o.transfer_day <> n.transfer_day
        or o.transfer_freq <> n.transfer_freq
        or o.fin_fixed_amt <> n.fin_fixed_amt
        or o.min_depo_amt <> n.min_depo_amt
        or o.opt_type <> n.opt_type
        or o.matn_oper_typ <> n.matn_oper_typ
        or o.actl_benef <> n.actl_benef
        or o.wthr_exist_actl_ctrl_rela <> n.wthr_exist_actl_ctrl_rela
        or o.wthr_is_np_integrity_rec <> n.wthr_is_np_integrity_rec
        or o.ori_pty_mgr_cd <> n.ori_pty_mgr_cd
        or o.new_pty_mgr_cd <> n.new_pty_mgr_cd
        or o.pty_mgr_adj_flg <> n.pty_mgr_adj_flg
        or o.spec_seq_num <> n.spec_seq_num
        or o.enro_ceph_num <> n.enro_ceph_num
        or o.acct_typ <> n.acct_typ
        or o.zone_num <> n.zone_num
        or o.scene_num <> n.scene_num
        or o.card_prd_id <> n.card_prd_id
        or o.txn_equip_info <> n.txn_equip_info
        or o.put_new_fld <> n.put_new_fld
        or o.cvn_num <> n.cvn_num
        or o.valid_dt <> n.valid_dt
        or o.bcs_res_ceph_num_flg <> n.bcs_res_ceph_num_flg
        or o.short_lett_srv_type <> n.short_lett_srv_type
        or o.ceph_num_app_scope <> n.ceph_num_app_scope
        or o.old_ceph_num <> n.old_ceph_num
        or o.new_ceph_num <> n.new_ceph_num
        or o.ceph_num_qty <> n.ceph_num_qty
        or o.direct_sign_matn_flg <> n.direct_sign_matn_flg
        or o.direct_sign_typ <> n.direct_sign_typ
        or o.ghb_out_ind <> n.ghb_out_ind
        or o.bank_id <> n.bank_id
        or o.bank_name <> n.bank_name
        or o.provin_cd <> n.provin_cd
        or o.city_cd <> n.city_cd
        or o.rcv_open_brch_id <> n.rcv_open_brch_id
        or o.rcv_open_brch_name <> n.rcv_open_brch_name
        or o.rcver_ceph_num <> n.rcver_ceph_num
        or o.recv_acct_upda_flg <> n.recv_acct_upda_flg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_personal_tb_cl(
            id -- 逻辑主键
            ,process_inst_id -- 
            ,main_flow_id -- 
            ,scan_seq_no -- 流水号
            ,fr_org_code -- 前台机构编码
            ,tr_date -- 客户开户日期
            ,biz_code -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
            ,voucher_no -- 凭证号码
            ,cust_id -- 客户编号
            ,cust_name -- 客户名称
            ,english_name -- 客户英文名称
            ,sex -- 性别
            ,cert_type -- 证件类型[代码0009][A-公民身份号码B-军官证C-解放军文职干部证D-警官证E-解放军士兵证F-户口簿G-(港、澳)回乡证、通行证H-(台)通行证、其他有效旅行证I-(外国)护照J-(中国)护照K-武警文职干部证L-武警士兵证P-全国组织机构代码Q-海外客户编号R-营业执照号码X-其它有效证件Z-其它]
            ,cert_code -- 证件号码
            ,crt_cert_organ -- 发证机关地区代码
            ,birthday -- 出生日期
            ,weblock_flag -- 婚姻状况[代码0007][10-未婚 20-已婚 21-初婚 22-再婚 23-复婚 40-离婚 90-未说明的婚姻状况 30-丧偶5-已婚有子女6-已婚无子女7-其他]
            ,education -- 学历
            ,occupation -- 职业[代码0048][]
            ,rank -- 职务
            ,income -- 月收入[代码0046][1-1500以下 2-1500到2000 3-2000到3000 4-3000到5000 5-5000到8000 6-8000到10000 7-10000到30000 8-30000以上]
            ,company -- 工作单位名称
            ,home_address -- 家庭地址
            ,fix_telephone -- 固定电话
            ,office_phone -- 办公电话
            ,home_phone -- 家庭电话
            ,mobile -- 移动电话
            ,contact_address -- 联系地址
            ,postcode -- 邮政编码
            ,acct_type -- 交易对手账户类型
            ,spec_type -- 存款账户类型
            ,sf_scp_flag -- 通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]
            ,curr_type -- 币种[代码T003][参考CFG_T_CURRENCY_TYPE]
            ,cf_flag -- 钞汇鉴别[代码0011][0-钞1-汇]
            ,fee_drw_type -- 费用支取别[代码0012][0-不收1-现金2-转账]
            ,spec_time -- 存期
            ,amount -- 金额
            ,biz_password -- 交易密码
            ,biz_account -- 交易账号
            ,open_acct_password -- 开户密码
            ,tr_account -- 转帐账号
            ,tr_password -- 转账密码
            ,attor_opr_code -- 客户经理编号
            ,attor_opr_name -- 客户经理姓名
            ,attor_org_code -- 客户经理所在网点
            ,level_b_pin -- 前台机构编码
            ,fr_tlr_opr_no -- 前台柜员号
            ,puc_check_flag -- 人行核查标志[代码0039][0-不用人行核查1-人行核查]
            ,check_option -- 身份核查意见
            ,check_remark -- 身份核查意见备注
            ,check_opr_code -- 核查操作员
            ,puc_chk_date -- 人行身份核查时间
            ,update_flag -- 客户信息更新标志
            ,check_status -- 审批状态
            ,check_fall_reason -- 审批未通过原因
            ,succ_flag -- 成功标志
            ,status -- 流程状态
            ,home_addr_type -- 住宅类型[代码0106][1-自置2-公积金贷款3-商业贷款4-租用5-其他]
            ,company_type -- 单位性质[代码0107][01-国家机关02-事业单位03-国有企业04-私营，民营企业05-中外合资，合作，外资企业06-其他]
            ,obtain_opr_code -- 任务获取柜员号
            ,commission -- 代办事由
            ,email -- 邮箱
            ,often_site -- 经常居住地
            ,relation -- 与被代理人关系
            ,nationality -- 国籍
            ,pro_name -- 代理人姓名(中文)
            ,pro_type -- 代理人证件类型
            ,pro_fashion -- 代理人联系方式
            ,is_porxy -- 是否代办(0 否 1 是)
            ,accept_no -- 受理号(任务号)
            ,trane_code -- 交易代码
            ,idtfna_name -- 证件姓名
            ,pro_cert_code -- 代理人证件号码
            ,is_net_silver_contract -- 是否操作网银(0-否 1-是)
            ,open_flag -- 开户标志(0:无卡介质也无客户信息,1:有卡介质的2:无卡介质，但在我行有客户信息)
            ,group_flag -- 分组标志(预留扩展，暂时送99)
            ,netb_passwd -- 网银初始登录密码
            ,netb_left_msg -- 预留信息
            ,netb_sign_mobile -- 签约手机号码
            ,netb_sec_model -- 安全工具型号(0-飞天  1-捷德)
            ,netb_sec_type -- 安全工具类型(0-个人，1-企业)
            ,netb_sec_no -- 安全工具编号
            ,netb_dynamic_opt_no -- 动态口令编号
            ,netb_dynamic_card_no -- 口令卡编号
            ,netb_is_transfer -- 账号开通权限(0-查询 1-转账)
            ,netb_ac_limit_pertrs -- 账户级单笔限额
            ,netb_ac_limit_perday -- 账户级日累计限额
            ,cert_date -- 证件到期日
            ,id_address -- 户籍地址
            ,is_sms_contract -- 是否操作短信通(0-否 1-是)
            ,is_tel_n_trnsf -- 非定向转账是否开通（1-开通）
            ,is_tel_n_trnsf_default_limit -- 非定向转账默认额度（1-默认额度）
            ,tel_n_trnsf_single_limit -- 非定向转账单笔额度
            ,tel_n_trnsf_day_limit -- 非定向转账单日额度
            ,is_tel_d_trnsf -- 定向转账是否开通（1-开通）
            ,is_tel_d_trnsf_no_limit -- 定向转账无限额度（1-无限额）
            ,tel_d_trnsf_single_limit -- 定向转账单笔额度
            ,tel_d_trnsf_day_limit -- 定向转账单日额度
            ,payee_name1 -- 定向转账收款人全称1
            ,payee_accno1 -- 定向转账收款人账号1
            ,payee_bank_name1 -- 定向转账开户银行全称1
            ,payee_name2 -- 定向转账收款人全称2
            ,payee_accno2 -- 定向转账收款人账号2
            ,payee_bank_name2 -- 定向转账开户银行全称2
            ,sms_notice_limit -- 账户变动短信通知起点金额
            ,sec_node_id -- 加密结点号
            ,proxy_sex -- 代理人性别
            ,proxy_idtdt -- 证件失效日期
            ,proxy_id_address -- 代理人证件地址
            ,sms_contract_if_succeed -- 短信通签约是否成功(0-失败 1-成功)
            ,net_silver_contract_succeed -- 网银签约是否成功(0-失败 1-成功)
            ,is_netb_default_limit -- 网银签约是否默认限额(1-是)
            ,prsntg -- 居民性质代码
            ,staffflag -- 员工标志(默认0)
            ,custlv -- 客户级别(默认00)
            ,risklv -- 客户风险承受能力评估等级（1-保守型 2-谨慎型 3-稳健型 4-进取型 5-激进型）
            ,wkutad -- 工作单位地址
            ,roleid -- 职称等级
            ,worktx -- 其他职业
            ,csec_node_id -- 转加密结点号
            ,netb_csec_passwd -- 转加密网银初始密码
            ,transfer_channel -- 转账渠道（1-手机银行定向转账2-电话银行定向转账）
            ,mobile_ac_limit_pertrs -- 手机银行账户级单笔限额
            ,mobile_ac_limit_perday -- 手机银行账户级日累计限额
            ,is_mobile_default_limit -- 手机银行是否默认限额(1-是)
            ,fax -- 传真
            ,area_code -- 地区代码
            ,truth_flag -- 实名标志
            ,trnamt -- 转存金额
            ,voucherty -- 凭证类型    738-华兴卡 741-借记芯片卡
            ,id_check_result -- 身份证联网核查结果[00-公民身份证号码与姓名一致，且存在照片01-公民身份证号码与姓名一致，但不存在照片02-公民身份号码存在，但与姓名不匹配03-公民身份号码不存在04-其他错误]
            ,mobile_open_status -- 移动业务审批状态 0处理中 1审批通过 2审批不通过(开卡、网银签约、短信通签约)
            ,account_update_flag -- 账户更新标志[0：删除 1：更新 2：增加 为空表示不操作账户]
            ,submit_status -- 移动综合签约提交状态[提交锁定字段 0：未处理1：处理中2：提交成功]
            ,netb_biz_type -- 网银签约业务类型[0：新增1：变更]
            ,often_site_eq_id_addr -- 经常居住地同身份证件地址（0否 1是）
            ,net_ukey -- 开通华兴U盾（0否 1是2关联）
            ,card_type -- 卡产品
            ,card_rank -- 卡等级
            ,is_finance_contract -- 是否操作理财(0-否 1-是)
            ,sendfreq -- 对账单发送频率[0-有交易发生寄送1-不寄送2-按月3-按季4-半年5-一年]
            ,sendmode -- 对账单寄送方式(共8个字符，每个字符代表一种交易手段，其含义为：第1位：邮寄第2位：传真第3位：E-mail第4位：短消息第5~8位：保留。每位字符取1表示采用此种手段，取0表示不使用)
            ,risklevel -- 理财产品风险等级（0-未评定 1-低风险2-较低风险3-中风险4-较高风险5-高风险）
            ,clientgroup -- 客户分组[a-	群客户Z- 其他客户]
            ,chnlflag -- 高风险产品柜台以外渠道允许购买标志(0-不允许 1-允许 默认0)
            ,finance_contract_succeed -- 理财签约是否成功(0-失败 1-成功)
            ,finance_acctno -- 理财签约账号
            ,open_brcno -- 开卡机构
            ,cust_mgrno -- 客户经理代码
            ,sms_cust_sign -- 短信通客户是否已签约(0:未签约1:已签约)
            ,fee_acct_no -- 扣费账号
            ,fee_acct_brcno -- 扣费账号分行号
            ,fee_acct_nodeno -- 扣费账号行所号
            ,contact_phone -- 联系手机号码
            ,attbrn -- 业务归属机构
            ,new_password -- 新交易密码
            ,new_account -- 新账号
            ,chactg -- 更换类型
            ,stpytg -- 挂失类型
            ,rplsfs -- 挂失形式
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,netopflag -- 网银操作类型[0-开通1-维护 2-解约（注销）3-暂停4-恢复5开通以下服务]
            ,smsopflag -- 短信通操作类型[0-签约 1-解约 2-短信通手机号码新增 3-短信通手机号码修改 4-短信通手机号码取消]
            ,finopflag -- 理财操作类型[0-签约  1-解约 2-更换账户  3-银行帐号登记取消]
            ,delukey -- 是否删除Ukey(0-否 1-是)
            ,bgnamt -- 短信通知起点金额
            ,trtmrs -- 核实结果  01未核实，02真实
            ,loss_date -- 挂失日期(yyyymmdd)
            ,loss_reg_no -- 挂失登记号
            ,undays -- 挂失天数    临时挂失5天，正式挂失7天
            ,payway -- 支取方式 S-凭印鉴支取 P-凭密码支取 W-无密码无印鉴支取 B-凭印鉴和密码支取 O-凭证件支取 R-支付密码器和印鉴
            ,is_fund_contract -- 是否操作基金(0-否 1-是)
            ,fundopflag -- 基金操作类型[ 1-开通 2-银行卡号变更 3-解约]
            ,fin_manager_id -- 理财经理编号
            ,szsecno -- 深交所证券账号
            ,shsecno -- 上交所证券账号
            ,minorflag -- 是否成年人标志 1-否，0-是
            ,fundnewacct -- 基金新银行卡号
            ,fund_contract_if_succeed -- 基金签约操作是否成功(0-失败 1-成功)
            ,is_third_manage_contract -- 是否三方存管签约操作
            ,cobank -- 合作行
            ,ori_acct -- 三方存管原结算账号
            ,ori_brcode -- 三方存管原结算账号开户机构
            ,bond_acct -- 证券资金台账账号
            ,bond_pass -- 证券资金台账密码
            ,bond_code -- 券商代码
            ,bond_name -- 券商名称
            ,third_manage_if_succeed -- 三方存管签约操作是否成功(0-失败 1-成功)
            ,is_invest_contract -- 是否储蓄定投签约操作 0-否，1-是
            ,invest_opflag -- 储蓄定投操作类型 1-签约 2-维护 3-解约
            ,invest_contract_if_succeed -- 储蓄定投签约操作是否成功(0-失败 1-成功)
            ,is_quickin_contract -- 是否灵活盈签约操作 0-否，1-是
            ,quickin_opflag -- 灵活盈签约操作类型 1-签约 2-维护 3-解约
            ,chan_save_tp -- 转存类型 1-活期转双整 2-活期转通知
            ,chan_save_deadline -- 灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年
            ,chan_save_amt -- 转存起点金额
            ,save_low_amt -- 最低留存金额
            ,quickin_contract_if_succeed -- 灵活盈签约操作是否成功(0-失败 1-成功)
            ,sign_type -- 签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5
            ,third_ma_apply_tp -- 三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
            ,third_ma_new_acct -- 三方存管新账号
            ,is_acctfund_contract -- 基金代销账户类签约操作 0-否，1-是
            ,acctfund_sign_type -- 基金代销账户类签约种类 1-签约2-解约3-维护
            ,is_bill_send -- 对账单寄送要求 1-寄送0-不寄送
            ,acctfund_ori_acct -- 交易账户变更原账号 默认前“签约账号”项
            ,is_tradefund_contract -- 基金代销交易类签约操作 0-否，1-是
            ,tradefund_sign_type -- 基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更
            ,tradefund_name -- 基金名称
            ,tradefund_code -- 基金代码
            ,savings_invest_optp -- 储蓄定投操作类型 1-终止 2-暂停 3-恢复
            ,time_invest_code -- 定投编号
            ,third_manage_optp -- 三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]
            ,fund_acct -- 基金签约操作账号
            ,fund_acct_brcno -- 基金签约账号开卡网点
            ,quickin_leave_amt -- 灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)
            ,quickin_leave_amt_other -- 灵活盈—活期账户留存金额_其它
            ,netb_op_choice -- 网银修改服务选项(1登录密码 2手机动态密码)
            ,netb_password_optp -- 网银登录密码操作类型(1重置 2解锁)
            ,netb_netphone_optp -- 手机动态密码操作类型(0-不开通1开通2注销3指定手机号4变更手机号5关联)
            ,ukey_optp -- 华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)
            ,is_sms_set_phone -- 短信通是否设置签约手机号 0-否，1-是
            ,is_net_trans_limit_set -- 是否网银转账限额设置 0-否，1-是
            ,is_mob_trans_limit_set -- 手机银行是否非定向转账限额设置 0-否，1-是
            ,direct_trans_optp -- 定向转账操作类型[1开通2修改3注销]
            ,is_direct_trans_ac_set -- 是否定向收款账户设置[0-否，1-是]
            ,sms_set_phone_optp -- 短信通设置签约手机号操作类型[1-开通 3-注销]
            ,fin_new_acct -- 理财银行卡号变更新账号
            ,fin_new_open_brcno -- 理财银行卡号变更新账号所属机构
            ,quickin_pass -- 灵活盈交易密码(带账号转加密)
            ,cust_changes -- 客户信息变更内容1.通讯地址2.邮政编码3.联系电话4.手机5.EMAIL
            ,tlr_mobile -- 前台柜员手机号码
            ,deposit_trade_no -- 交易单编号
            ,acct_type_m -- 账号类型:0: 人民币个人非结算户1: 人民币个人结算户A: 外汇结算账户B: 乙种储蓄存款账户C: 丙种储蓄存款账户
            ,dsp_type -- 储种:S01储蓄活期S02	储蓄双整S03	零存整取S04	整存零取S05	存本取息S06	定活两便S07	储蓄通知S08	教育储蓄S18:财富宝
            ,dsp_period -- 存期:203-三个月、206-六个月、301-一年、302-二年、303-三年、305-五年、000-活期、101-一天、107-七天 、203-三个月、206-六个月、301-一年
            ,dsp_flag -- 转存标识:1:自动转存0:非自动转存
            ,tran_type -- 交易类型:CO-现开TO-转开
            ,to_acct_no -- 转出账号
            ,to_acct_name -- 转出账号名称
            ,to_pswd -- 转出账号密码
            ,to_idtp -- 转出证件类型:A:身份证,B:外国公民护照,C:户口薄,D:港澳居民通行证,E:还乡证,F:边民出入境通行证,G:军官证,H:士兵证,I:军事院校学员证,J:军队离休干部荣誉证,K:军官退休证,L:军人文职干部退休证,P:其他,Q:武警身份证,R:台湾居民通行证,S:中国公民护照,U:临时身份证
            ,to_idno -- 转出证件号码
            ,to_dwfs -- 转出支取方式：A:密码 D:印鉴 E:证件
            ,prcsna -- 交易类型
            ,nwinrt -- 利率
            ,matudt -- 到期日
            ,valuedt -- 起息日
            ,proxy_flag -- 代办人类型（0-否 1-监护代理 2-普通代理）
            ,quickin_type -- 灵活盈-储种（1-三个月 2-六个月 3-一年 4-二年 5-三年 6-五年 7-不约定存期 8-七天通知）
            ,acctlv -- 账户分类
            ,is_card -- 是否有卡
            ,regoresult -- 1识别失败，0识别成功
            ,similarity -- 0%~100%，>=80%为认定为本人
            ,issetnewpwd -- 是否设置新密码
            ,isfcfnoper -- 是否操作非柜面非同名限额签约(0-否,1-是)
            ,isfcfntype -- 非柜面非同名账户限额签约操作类型(0-签约 1-维护)
            ,isfcfnct -- 是否非柜面非同名账户限额签约(0-否,1-是)
            ,daylimit -- 日累计限额(非柜面非同名账户限额签约)
            ,txntimeslimit -- 日笔数限额(非柜面非同名账户限额签约)
            ,yearlimit -- 年累计限额(非柜面非同名账户限额签约)
            ,is_fcfnct_succeed -- 非柜面非同名账户限额签约是否成功(0-失败,1-成功)
            ,agreementid -- ECIF签约协议号
            ,custom_daylimit -- 自定义-日累计限额(万元)
            ,custom_txntimeslimit -- 自定义-日累计笔数
            ,custom_yearlimit -- 自定义-年累计限额(万元)
            ,pro_nationality -- 代理人国籍
            ,mobile_type -- 号码性质 0--本人1--监护人
            ,outflg -- 外出标注-0，默认网点0：网点凭证 1：外出凭证
            ,netstate -- 网银密码重置--状态默认送0
            ,logonpwnew -- 网银密码重置--新登陆密码
            ,netreset -- 是否网银密码重置
            ,relativetp -- 监护人/亲属证件类型
            ,relativena -- 监护人/亲属姓名
            ,relativeno -- 监护人/亲属号码
            ,taxresident -- 税收居民身份（1仅为中国税收居民2仅为非居民3既是中国税收居民又是其他国家（地区）税收居民4无需声明5空）
            ,birthplace -- 纳税人出生地（中英文字符）
            ,taxarea -- 税收居民国（地区）
            ,taxnumber -- 纳税人识别号
            ,taxarea2 -- 纳税居民国家（地区）2（发送报文时整合在TAXAREA）
            ,taxarea3 -- 纳税居民国家（地区）3（发送报文时整合在TAXAREA）
            ,taxnumber2 -- 纳税人识别号2（发送报文时整合在TAXNUMBER）
            ,taxnumber3 -- 纳税人识别号3（发送报文时整合在TAXNUMBER）
            ,taxnullreason -- 纳税人识别号为空原因
            ,taxstatement -- 是否取得自证声明（0-未取得自证声明1-取得自证声明）
            ,customersurname -- 客户_姓（字母）
            ,customergivenname -- 客户_名（字母）
            ,taxnullreason2 -- 纳税人识别号为空原因2
            ,taxnullreason3 -- 纳税人识别号为空原因3
            ,boundaccno -- 绑定账号
            ,boundbank -- 绑定账号开户行
            ,checkcase -- 落地审核原因
            ,ocridtdt -- 证件生效日期
            ,yflag -- 手机盾标志 Y:为是手机盾，N:为不是手机盾
            ,phoneoperate -- 手机盾操作类型0：开通
            ,camp_emp_id -- 营销工号
            ,notemessagephone1 -- 短信通签约号码1
            ,notemessagephone2 -- 短信通签约号码2
            ,notemessagephone3 -- 短信通签约号码3
            ,notemessagephone4 -- 短信通签约号码4
            ,notemessagephone5 -- 短信通签约号码5
            ,isagtsch -- 是否个人扣款协议签约(0-否,1-是)
            ,proxy_idtdt_sl -- 是否云闪付绑定签约
            ,is_flashpay_contract -- 云闪付绑定签约是否成功  0-失败 1-成功
            ,flashpay_contract_if_succeed -- 
            ,local_ip -- 开户IP
            ,local_mac -- 开户MAC
            ,uuid -- UUID
            ,ukey_modify_if_succeed -- U盾管理状态
            ,is_send_message -- 是否发送营销短信
            ,phonepay_contract_if_succeed -- 手机转账签约是否成功(0-失败 1-成功)
            ,is_phonepay_contract -- 是否手机转账签约(0-否 1-是)
            ,regedittype -- 登记注册类型
            ,sco -- 
            ,is_phonepay_contract1 -- 是否手机转账签约(0-否 1-是)
            ,phonepay_contract_if_succeed1 -- 手机转账签约是否成功(0-失败 1-成功)
            ,regedittype1 -- 登记注册类型
            ,limit_oper_type -- 非柜面签约
            ,limit_oper_channel -- 
            ,day_transfer_count -- 非柜面签约-日总笔数
            ,day_transfer_amount -- 非柜面签约-日总限额
            ,year_transfer_count -- 非柜面签约-年总笔数
            ,year_transfer_amount -- 非柜面签约-年总限额
            ,limit_oper_result -- 
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 记账失败
            ,agt_num -- 协议号
            ,dspbgndt -- 转存起始日期
            ,dspenddt -- 转存截止日期
            ,dsptyper -- 转存类型 1 转存双整 2 转存通知
            ,invest_account -- 储蓄定投签约账户
            ,invest_trnamt -- 转存金额
            ,prd_id -- 产品编号
            ,quickin_agreement_id -- 灵活盈协议编号
            ,quickin_agreement_status -- 灵活盈协议状态
            ,quickin_agreement_type -- 灵活盈协议类型
            ,quickin_fin_fixed_amt -- 灵活盈理财固定金额
            ,quickin_int_min_amt -- 灵活盈最小起存金额
            ,quickin_remain_amt -- 灵活盈协议留存金额
            ,quickin_start_amt -- 灵活盈起始金额
            ,quickin_transfer_day -- 划转日
            ,quickin_transfer_freq -- 灵活盈划转频率
            ,redep_freq -- 转存频率
            ,renew_corp -- 转存单位
            ,rpdsp -- 转存周期 Y-年 Q-季 M-月 W-周 D-天
            ,sub_acct_num -- 子账号
            ,sum_sub_num -- 汇总子户号
            ,biz_type -- 业务种类
            ,biz_dt -- 交易日期（yyyy-MM-dd hh:mm:ss）
            ,finance_card_type -- 理财账户类型
            ,fin_new_acct_crspd_pty_id -- 新账号对应客户号
            ,custchnlid -- 开通渠道
            ,riskmonths -- 风险有效期月数
            ,rskcd -- 风险等级代码
            ,oper_flag -- 1 客户级 2账户级
            ,third_chg_card_id -- 三方存管换卡标识
            ,third_open_org_id -- 三方存管开户机构
            ,usb_key_cert_id -- USBKey证书编号
            ,old_cert_key_id -- 旧证书KEYID
            ,safe_instr_model -- 安全工具型号(0：飞天1：捷德)
            ,u_brch_num -- U盾网点号
            ,u_oper_typ -- U盾操作类型（2：注销 3：损坏更换 4：挂失更换 5：发放）
            ,wthr_out -- 是否出库 默认Y Y：是 N：否
            ,lost_operate_method -- 挂失操作方式，比如书面挂失、口头挂失UV-口头解挂 UW-正式解挂 VL-口挂 WL-书挂
            ,lost_no -- 账户/凭证/结算卡挂失号码
            ,acct_name -- 账户名称
            ,loss_id -- 挂失编号
            ,acct_seq_no -- 账户序列号
            ,acct_password -- 账户密码
            ,voucher_change_type -- 凭证更换类型，比如挂失补发、损坏更换等，不同的更换类型会对应不同的处理流程 01-挂失补发 02-凭证更换 03-损坏更换 04-同号换卡领卡/记名卡领卡 05-单位存单置换 06-单位存单收回如果补开、凭证更换必传
            ,new_vchr_typ -- 新凭证类型
            ,new_vchr_num -- 新凭证号码
            ,voucher_change_reason -- 更换原因
            ,td_inout_operate_type -- 存单移入必传 定期账户转入转出操作类型 01-转入 02-互转 03-转出
            ,in_base_acct_no -- 移入账号
            ,in_prod_type -- 转入账户产品类型
            ,enter_acct_ccy -- 转入账户币种
            ,target_acct_class -- 目标账户类别（一二三类户），即账户升级后的账户类别，满足人行对于电子账户的管理办法1-一类账户 2-二类账户 3-三类账户
            ,password_operate_type -- 账户密码操作类型 账户密码操作类型01-新建 02-重置 03-修改 04-解锁 05-校验 06-激活 07-凭证解挂场景密码重置 08-弱密码校验
            ,password_type -- 密码类型，目前核心只支持WD，接口未上送则默认为WDWD-支取密码 QY-查询密码 MA-账户管理密码
            ,password_old -- 旧密码
            ,iss_country -- 发证国家
            ,password_effect_date -- 密码生效日期
            ,lost_reason -- 挂失原因
            ,res_flag -- 标识挂失账户是N进行账户止付,挂失时必输，解挂时不需要输入Y-是 N-不是
            ,pause_post -- 暂停附言
            ,channel -- 渠道
            ,ntw_ceph_bank_pause_type -- 网银手机银行管理 业务类型 01：个人动态密码管理 02：解锁登录密码 03：网银/手机银行暂停/恢复 04：登录密码和用户状态重置 05：客户手机盾信息维护 06：账户暂停/恢复
            ,ntw_ceph_bank_pause_pwd_status -- 网银手机银行管理 密码状态：0:正常 7：重置网银密码 8：重置交易密码 9 : 柜面开户重置密码
            ,tfr_encry_ind -- 转加密标识  1:数字加字母组合 0:纯数字(柜面调用)
            ,cfm_new_logon_pwd -- 确认新登录密码
            ,pwd_keyb_node_id -- 密码键盘节点ID
            ,safe_ceph_num -- 安全手机号
            ,dynamic_password_status -- 个人动态密码状态 ： 0---开 1---关
            ,pause_status -- 网银/手机银行暂停/恢复 状态 0-正常 1-永久停止 2-临时暂停
            ,dynamic_password_ind_id -- 个人动态密码标识编号 1：查询 2：新增 3：修改 4: 删除
            ,clous_shield_ind_id -- 华兴云盾标识编号 1：设置密码 0：重置密码
            ,deft_safe_instr -- 默认安全工具 1：华兴U盾 2：手机短信密码
            ,indv_act_status -- 个人账户状态
            ,acct_pause_rsns -- 账户暂停原因
            ,ntw_ceph_bank_pause_resu_status -- 网银/手机银行暂停/恢复状态 0-正常 1-永久停止 2-临时暂停
            ,pause_with_resu_oper_typ -- 暂停/恢复操作类型 0-网银 1-手机银行 2-网银手机银行
            ,temp_pause_start_tm -- 临时暂停开始时间，格式为yyyyMMddHHmmss
            ,temp_pause_cncl_tm -- 临时暂停结束时间，格式为yyyyMMddHHmmss
            ,ceph_cs_oper_typ -- 手机盾信息操作类型 开通：0 停用：1 启用：2 注销：4
            ,cs_ord_nbr -- 云盾序号
            ,open_br_node_num -- 开通网点号
            ,key_name -- 密钥名称
            ,total_cnt -- 网银签约总笔数
            ,reg_typ -- 手机号码支付协议注册类型 DFLT 默认账户 NDFT 非默认账户
            ,narrative1 -- 备注
            ,prest_flg -- 赠送标志 0-正常开通 1-赠送开通
            ,prest_mon -- 赠送月份 如果是赠送服务（赠送标志为1），则填入赠送的月份数。没有此信息填空或“00”
            ,vip_flg -- VIP标志 0-非VIP服务， 1-VIP服务，（默认填0，如果操作员选择了VIP服务标志，则填1），VIP针对客户而言。
            ,chrg_pkg_typ -- 收费套餐类型 01包月/ 12包年。
            ,chrg_mode -- 收费模式 1-按账户数收费 2-按服务数收费 3-按短信条数收费 4-按定额收费
            ,chrg_amt -- 收费金额 请按字符串格式传输，如”RATE”:”0.56987” 当收费模式为定额收费时填写
            ,disct -- 折扣 客户收费折扣
            ,disct_mon -- 折扣月份 当存在折扣时，填写折扣有效月份，没有此信息则填空或00
            ,acct_purp -- 账户用途
            ,acct_attr -- 账户属性
            ,agtsch_prd_id -- 个人扣款协议-产品编号
            ,agtsch_prd_type -- 个人扣款协议  C-签约U-维护D-解约
            ,payer_acct -- 付款人账号
            ,payer_acct_typ -- 付款人账户类型
            ,payer_act_nm -- 付款人账户户名
            ,payer_cert_typ -- 付款人证件类型
            ,payer_cert_num -- 付款人证件号
            ,payer_ceph_num -- 付款人手机号
            ,payer_bank -- 付款人开户行行号
            ,rcver_acct_typ -- 收款人账户类型
            ,payee_base_acct_no -- 收款人账号
            ,rcver_act_nm -- 收款人账户户名
            ,chn_num -- 渠道号
            ,sign_dtl -- 签约明细
            ,dsp_trnamt -- 转存周期 Y    年 Q    季 M    月 W    周 D    天
            ,redep_start_dt -- 转存起始日期
            ,redep_end_dt -- 转存截止日期
            ,pause_flg -- 暂停标志 0 否 1 是
            ,node_num -- 节点号
            ,third_chg_sign_prd -- 签约产品 SV014银银合作代理第三方存管协议
            ,agt_typ -- 协议类型CLD-存立得 DC-大额存单 DLS-贷利省 HQB-活期宝 JDL-加多利 KDT-卡贷通 KYD-卡易贷 PCP-资金池 WDL-稳得利 XDB-协定宝 XDCK-协定存款产品 XDL-先得利 YBWL-一本万利 YCD-英才贷 YDT-易贷通 YHT-一户通 ZHY-周享赢 ZXY-坐享其盈 ZZB-至尊宝 LOA-贷款 ODF-法人透支协议 FIN-卡理财协议 SMS-短信 PKG-费用套餐 FEE-暂不收费 PCD-周期性强制扣划 ACC-协定存款协议 SWP-账户清扫协议 ID-智能存款协议 SL-金额补足协议 REC-回单签约 ES-电票签约 YD-约定 NTE-活期智能存款 PAS-隐私账户签约 TXY1-同兴赢活期签约 TXY2-跨境资金融入签约 CXDT-储蓄定投 TBCK-跳板存款 LHY-灵活盈 P2P-P2P协议 JZG-建筑港 ZCG-资产存管 ZQS-资金清算 LYE-财政零余额
            ,agt_id -- 协议编号
            ,agt_status_cd -- 协议状态 普通协议使用，可应用于大部分场景，贷款模块用于资产证券化合同状态A-生效 E-失效 YB-赎回 YS-发行 YP-已封包 NP-未封包 NS-未发行 YC-已撤包
            ,st_dt -- 开始日期
            ,end_dt_ora -- 结束日期
            ,sign_prod_type -- 签约产品类型
            ,remain_amt -- 协议留存金额 请按字符串格式传输，如”RATE”:”0.56987” 协议留存金额
            ,start_amt -- 起始金额 请按字符串格式传输，如”RATE”:”0.56987” 起始金额
            ,transfer_freq_type -- 划转频率类型 Y-年 Q-季 M-月 W-周 D-日
            ,acct_movt_date -- 转存交易日期
            ,peri -- 存期
            ,term_type -- 期限单位 Y-年 Q-季 M-月 W-周 D-日
            ,acct_exec -- 银行客户经理
            ,transfer_end_date -- 转存结束日期
            ,transfer_day -- 划转日
            ,transfer_freq -- 划转频率
            ,fin_fixed_amt -- 理财固定金额 请按字符串格式传输，如”RATE”:”0.56987”
            ,min_depo_amt -- 最小起存金额 请按字符串格式传输，如”RATE”:”0.56987” 最小起存金额
            ,opt_type -- 资管信托代销协议操作类型 01签约 02解约 03维护
            ,matn_oper_typ -- 维护操作类型 0-客户信息维护 1-客户经理代码维护
            ,actl_benef -- 实际受益人 0-本人（默认） 1-他人
            ,wthr_exist_actl_ctrl_rela -- 是否存在实际控制关系 0-否（默认） 1-是
            ,wthr_is_np_integrity_rec -- 是否有不良诚信记录 0-否（默认） 1-是
            ,ori_pty_mgr_cd -- 原客户经理代码
            ,new_pty_mgr_cd -- 新客户经理代码
            ,pty_mgr_adj_flg -- 客户经理调整标志 0－全部（将原客户经理替换成新客经理） 1－调整客户所属客户经理代码 2－理财账号客户经理代码 3－按流水客户经理 4－调整定投客户经理代码 5－调整定赎客户经理代码 8－调整客户对应所有客户经理
            ,spec_seq_num -- 指定流水号
            ,enro_ceph_num -- 注册手机号
            ,acct_typ -- 账户类型 01 - 为Ⅰ类户（非信用卡） 02 - 为Ⅱ类户 03 - 为Ⅲ类户 04-准贷记卡 05-借贷合一卡 不填-信用卡
            ,zone_num -- 地区码 建议需求方至少定位到省市、直辖市级地区区位。默认为0000，长度为4 位
            ,scene_num -- 云闪付场景码
            ,card_prd_id -- 卡产品编号
            ,txn_equip_info -- 交易设备信息
            ,put_new_fld -- 拉新字段
            ,cvn_num -- CVN码
            ,valid_dt -- 有效期
            ,bcs_res_ceph_num_flg -- 核心预留手机号标志 1代表是核心预留手机号 0代表非核心预留手机号
            ,short_lett_srv_type -- 短信服务类 短信服务类，以逗号分隔（A,B）
            ,ceph_num_app_scope -- 手机号码应用范围 1-只修改该账号下对应的手机号码 2-修改客户所有账号对应的手机号码，填1时必须填写签约账号
            ,old_ceph_num -- 旧手机号码
            ,new_ceph_num -- 新手机号码
            ,ceph_num_qty -- 手机号码个数
            ,direct_sign_matn_flg -- 定向转账签约维护标志 0-解约, 1-更新, 2-签约
            ,direct_sign_typ -- 定向转账签约类型 0-综合柜面, 1-流程银行
            ,ghb_out_ind -- 行内外标识 0-行内 1-行外
            ,bank_id -- 银行编号
            ,bank_name -- 银行名称
            ,provin_cd -- 省份代码
            ,city_cd -- 城市代码
            ,rcv_open_brch_id -- 收款方开户网点编号
            ,rcv_open_brch_name -- 收款方开户网点名称
            ,rcver_ceph_num -- 收款人手机号码
            ,recv_acct_upda_flg -- 收款账户更新标志 收款账户更新标志0：删除 1：更新,2：增加（SIGNUPDATEFLAG=0时，系统默认0，SIGNUPDATEFLAG=2时，系统默认为2）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_personal_tb_op(
            id -- 逻辑主键
            ,process_inst_id -- 
            ,main_flow_id -- 
            ,scan_seq_no -- 流水号
            ,fr_org_code -- 前台机构编码
            ,tr_date -- 客户开户日期
            ,biz_code -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
            ,voucher_no -- 凭证号码
            ,cust_id -- 客户编号
            ,cust_name -- 客户名称
            ,english_name -- 客户英文名称
            ,sex -- 性别
            ,cert_type -- 证件类型[代码0009][A-公民身份号码B-军官证C-解放军文职干部证D-警官证E-解放军士兵证F-户口簿G-(港、澳)回乡证、通行证H-(台)通行证、其他有效旅行证I-(外国)护照J-(中国)护照K-武警文职干部证L-武警士兵证P-全国组织机构代码Q-海外客户编号R-营业执照号码X-其它有效证件Z-其它]
            ,cert_code -- 证件号码
            ,crt_cert_organ -- 发证机关地区代码
            ,birthday -- 出生日期
            ,weblock_flag -- 婚姻状况[代码0007][10-未婚 20-已婚 21-初婚 22-再婚 23-复婚 40-离婚 90-未说明的婚姻状况 30-丧偶5-已婚有子女6-已婚无子女7-其他]
            ,education -- 学历
            ,occupation -- 职业[代码0048][]
            ,rank -- 职务
            ,income -- 月收入[代码0046][1-1500以下 2-1500到2000 3-2000到3000 4-3000到5000 5-5000到8000 6-8000到10000 7-10000到30000 8-30000以上]
            ,company -- 工作单位名称
            ,home_address -- 家庭地址
            ,fix_telephone -- 固定电话
            ,office_phone -- 办公电话
            ,home_phone -- 家庭电话
            ,mobile -- 移动电话
            ,contact_address -- 联系地址
            ,postcode -- 邮政编码
            ,acct_type -- 交易对手账户类型
            ,spec_type -- 存款账户类型
            ,sf_scp_flag -- 通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]
            ,curr_type -- 币种[代码T003][参考CFG_T_CURRENCY_TYPE]
            ,cf_flag -- 钞汇鉴别[代码0011][0-钞1-汇]
            ,fee_drw_type -- 费用支取别[代码0012][0-不收1-现金2-转账]
            ,spec_time -- 存期
            ,amount -- 金额
            ,biz_password -- 交易密码
            ,biz_account -- 交易账号
            ,open_acct_password -- 开户密码
            ,tr_account -- 转帐账号
            ,tr_password -- 转账密码
            ,attor_opr_code -- 客户经理编号
            ,attor_opr_name -- 客户经理姓名
            ,attor_org_code -- 客户经理所在网点
            ,level_b_pin -- 前台机构编码
            ,fr_tlr_opr_no -- 前台柜员号
            ,puc_check_flag -- 人行核查标志[代码0039][0-不用人行核查1-人行核查]
            ,check_option -- 身份核查意见
            ,check_remark -- 身份核查意见备注
            ,check_opr_code -- 核查操作员
            ,puc_chk_date -- 人行身份核查时间
            ,update_flag -- 客户信息更新标志
            ,check_status -- 审批状态
            ,check_fall_reason -- 审批未通过原因
            ,succ_flag -- 成功标志
            ,status -- 流程状态
            ,home_addr_type -- 住宅类型[代码0106][1-自置2-公积金贷款3-商业贷款4-租用5-其他]
            ,company_type -- 单位性质[代码0107][01-国家机关02-事业单位03-国有企业04-私营，民营企业05-中外合资，合作，外资企业06-其他]
            ,obtain_opr_code -- 任务获取柜员号
            ,commission -- 代办事由
            ,email -- 邮箱
            ,often_site -- 经常居住地
            ,relation -- 与被代理人关系
            ,nationality -- 国籍
            ,pro_name -- 代理人姓名(中文)
            ,pro_type -- 代理人证件类型
            ,pro_fashion -- 代理人联系方式
            ,is_porxy -- 是否代办(0 否 1 是)
            ,accept_no -- 受理号(任务号)
            ,trane_code -- 交易代码
            ,idtfna_name -- 证件姓名
            ,pro_cert_code -- 代理人证件号码
            ,is_net_silver_contract -- 是否操作网银(0-否 1-是)
            ,open_flag -- 开户标志(0:无卡介质也无客户信息,1:有卡介质的2:无卡介质，但在我行有客户信息)
            ,group_flag -- 分组标志(预留扩展，暂时送99)
            ,netb_passwd -- 网银初始登录密码
            ,netb_left_msg -- 预留信息
            ,netb_sign_mobile -- 签约手机号码
            ,netb_sec_model -- 安全工具型号(0-飞天  1-捷德)
            ,netb_sec_type -- 安全工具类型(0-个人，1-企业)
            ,netb_sec_no -- 安全工具编号
            ,netb_dynamic_opt_no -- 动态口令编号
            ,netb_dynamic_card_no -- 口令卡编号
            ,netb_is_transfer -- 账号开通权限(0-查询 1-转账)
            ,netb_ac_limit_pertrs -- 账户级单笔限额
            ,netb_ac_limit_perday -- 账户级日累计限额
            ,cert_date -- 证件到期日
            ,id_address -- 户籍地址
            ,is_sms_contract -- 是否操作短信通(0-否 1-是)
            ,is_tel_n_trnsf -- 非定向转账是否开通（1-开通）
            ,is_tel_n_trnsf_default_limit -- 非定向转账默认额度（1-默认额度）
            ,tel_n_trnsf_single_limit -- 非定向转账单笔额度
            ,tel_n_trnsf_day_limit -- 非定向转账单日额度
            ,is_tel_d_trnsf -- 定向转账是否开通（1-开通）
            ,is_tel_d_trnsf_no_limit -- 定向转账无限额度（1-无限额）
            ,tel_d_trnsf_single_limit -- 定向转账单笔额度
            ,tel_d_trnsf_day_limit -- 定向转账单日额度
            ,payee_name1 -- 定向转账收款人全称1
            ,payee_accno1 -- 定向转账收款人账号1
            ,payee_bank_name1 -- 定向转账开户银行全称1
            ,payee_name2 -- 定向转账收款人全称2
            ,payee_accno2 -- 定向转账收款人账号2
            ,payee_bank_name2 -- 定向转账开户银行全称2
            ,sms_notice_limit -- 账户变动短信通知起点金额
            ,sec_node_id -- 加密结点号
            ,proxy_sex -- 代理人性别
            ,proxy_idtdt -- 证件失效日期
            ,proxy_id_address -- 代理人证件地址
            ,sms_contract_if_succeed -- 短信通签约是否成功(0-失败 1-成功)
            ,net_silver_contract_succeed -- 网银签约是否成功(0-失败 1-成功)
            ,is_netb_default_limit -- 网银签约是否默认限额(1-是)
            ,prsntg -- 居民性质代码
            ,staffflag -- 员工标志(默认0)
            ,custlv -- 客户级别(默认00)
            ,risklv -- 客户风险承受能力评估等级（1-保守型 2-谨慎型 3-稳健型 4-进取型 5-激进型）
            ,wkutad -- 工作单位地址
            ,roleid -- 职称等级
            ,worktx -- 其他职业
            ,csec_node_id -- 转加密结点号
            ,netb_csec_passwd -- 转加密网银初始密码
            ,transfer_channel -- 转账渠道（1-手机银行定向转账2-电话银行定向转账）
            ,mobile_ac_limit_pertrs -- 手机银行账户级单笔限额
            ,mobile_ac_limit_perday -- 手机银行账户级日累计限额
            ,is_mobile_default_limit -- 手机银行是否默认限额(1-是)
            ,fax -- 传真
            ,area_code -- 地区代码
            ,truth_flag -- 实名标志
            ,trnamt -- 转存金额
            ,voucherty -- 凭证类型    738-华兴卡 741-借记芯片卡
            ,id_check_result -- 身份证联网核查结果[00-公民身份证号码与姓名一致，且存在照片01-公民身份证号码与姓名一致，但不存在照片02-公民身份号码存在，但与姓名不匹配03-公民身份号码不存在04-其他错误]
            ,mobile_open_status -- 移动业务审批状态 0处理中 1审批通过 2审批不通过(开卡、网银签约、短信通签约)
            ,account_update_flag -- 账户更新标志[0：删除 1：更新 2：增加 为空表示不操作账户]
            ,submit_status -- 移动综合签约提交状态[提交锁定字段 0：未处理1：处理中2：提交成功]
            ,netb_biz_type -- 网银签约业务类型[0：新增1：变更]
            ,often_site_eq_id_addr -- 经常居住地同身份证件地址（0否 1是）
            ,net_ukey -- 开通华兴U盾（0否 1是2关联）
            ,card_type -- 卡产品
            ,card_rank -- 卡等级
            ,is_finance_contract -- 是否操作理财(0-否 1-是)
            ,sendfreq -- 对账单发送频率[0-有交易发生寄送1-不寄送2-按月3-按季4-半年5-一年]
            ,sendmode -- 对账单寄送方式(共8个字符，每个字符代表一种交易手段，其含义为：第1位：邮寄第2位：传真第3位：E-mail第4位：短消息第5~8位：保留。每位字符取1表示采用此种手段，取0表示不使用)
            ,risklevel -- 理财产品风险等级（0-未评定 1-低风险2-较低风险3-中风险4-较高风险5-高风险）
            ,clientgroup -- 客户分组[a-	群客户Z- 其他客户]
            ,chnlflag -- 高风险产品柜台以外渠道允许购买标志(0-不允许 1-允许 默认0)
            ,finance_contract_succeed -- 理财签约是否成功(0-失败 1-成功)
            ,finance_acctno -- 理财签约账号
            ,open_brcno -- 开卡机构
            ,cust_mgrno -- 客户经理代码
            ,sms_cust_sign -- 短信通客户是否已签约(0:未签约1:已签约)
            ,fee_acct_no -- 扣费账号
            ,fee_acct_brcno -- 扣费账号分行号
            ,fee_acct_nodeno -- 扣费账号行所号
            ,contact_phone -- 联系手机号码
            ,attbrn -- 业务归属机构
            ,new_password -- 新交易密码
            ,new_account -- 新账号
            ,chactg -- 更换类型
            ,stpytg -- 挂失类型
            ,rplsfs -- 挂失形式
            ,submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
            ,netopflag -- 网银操作类型[0-开通1-维护 2-解约（注销）3-暂停4-恢复5开通以下服务]
            ,smsopflag -- 短信通操作类型[0-签约 1-解约 2-短信通手机号码新增 3-短信通手机号码修改 4-短信通手机号码取消]
            ,finopflag -- 理财操作类型[0-签约  1-解约 2-更换账户  3-银行帐号登记取消]
            ,delukey -- 是否删除Ukey(0-否 1-是)
            ,bgnamt -- 短信通知起点金额
            ,trtmrs -- 核实结果  01未核实，02真实
            ,loss_date -- 挂失日期(yyyymmdd)
            ,loss_reg_no -- 挂失登记号
            ,undays -- 挂失天数    临时挂失5天，正式挂失7天
            ,payway -- 支取方式 S-凭印鉴支取 P-凭密码支取 W-无密码无印鉴支取 B-凭印鉴和密码支取 O-凭证件支取 R-支付密码器和印鉴
            ,is_fund_contract -- 是否操作基金(0-否 1-是)
            ,fundopflag -- 基金操作类型[ 1-开通 2-银行卡号变更 3-解约]
            ,fin_manager_id -- 理财经理编号
            ,szsecno -- 深交所证券账号
            ,shsecno -- 上交所证券账号
            ,minorflag -- 是否成年人标志 1-否，0-是
            ,fundnewacct -- 基金新银行卡号
            ,fund_contract_if_succeed -- 基金签约操作是否成功(0-失败 1-成功)
            ,is_third_manage_contract -- 是否三方存管签约操作
            ,cobank -- 合作行
            ,ori_acct -- 三方存管原结算账号
            ,ori_brcode -- 三方存管原结算账号开户机构
            ,bond_acct -- 证券资金台账账号
            ,bond_pass -- 证券资金台账密码
            ,bond_code -- 券商代码
            ,bond_name -- 券商名称
            ,third_manage_if_succeed -- 三方存管签约操作是否成功(0-失败 1-成功)
            ,is_invest_contract -- 是否储蓄定投签约操作 0-否，1-是
            ,invest_opflag -- 储蓄定投操作类型 1-签约 2-维护 3-解约
            ,invest_contract_if_succeed -- 储蓄定投签约操作是否成功(0-失败 1-成功)
            ,is_quickin_contract -- 是否灵活盈签约操作 0-否，1-是
            ,quickin_opflag -- 灵活盈签约操作类型 1-签约 2-维护 3-解约
            ,chan_save_tp -- 转存类型 1-活期转双整 2-活期转通知
            ,chan_save_deadline -- 灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年
            ,chan_save_amt -- 转存起点金额
            ,save_low_amt -- 最低留存金额
            ,quickin_contract_if_succeed -- 灵活盈签约操作是否成功(0-失败 1-成功)
            ,sign_type -- 签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5
            ,third_ma_apply_tp -- 三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
            ,third_ma_new_acct -- 三方存管新账号
            ,is_acctfund_contract -- 基金代销账户类签约操作 0-否，1-是
            ,acctfund_sign_type -- 基金代销账户类签约种类 1-签约2-解约3-维护
            ,is_bill_send -- 对账单寄送要求 1-寄送0-不寄送
            ,acctfund_ori_acct -- 交易账户变更原账号 默认前“签约账号”项
            ,is_tradefund_contract -- 基金代销交易类签约操作 0-否，1-是
            ,tradefund_sign_type -- 基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更
            ,tradefund_name -- 基金名称
            ,tradefund_code -- 基金代码
            ,savings_invest_optp -- 储蓄定投操作类型 1-终止 2-暂停 3-恢复
            ,time_invest_code -- 定投编号
            ,third_manage_optp -- 三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]
            ,fund_acct -- 基金签约操作账号
            ,fund_acct_brcno -- 基金签约账号开卡网点
            ,quickin_leave_amt -- 灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)
            ,quickin_leave_amt_other -- 灵活盈—活期账户留存金额_其它
            ,netb_op_choice -- 网银修改服务选项(1登录密码 2手机动态密码)
            ,netb_password_optp -- 网银登录密码操作类型(1重置 2解锁)
            ,netb_netphone_optp -- 手机动态密码操作类型(0-不开通1开通2注销3指定手机号4变更手机号5关联)
            ,ukey_optp -- 华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)
            ,is_sms_set_phone -- 短信通是否设置签约手机号 0-否，1-是
            ,is_net_trans_limit_set -- 是否网银转账限额设置 0-否，1-是
            ,is_mob_trans_limit_set -- 手机银行是否非定向转账限额设置 0-否，1-是
            ,direct_trans_optp -- 定向转账操作类型[1开通2修改3注销]
            ,is_direct_trans_ac_set -- 是否定向收款账户设置[0-否，1-是]
            ,sms_set_phone_optp -- 短信通设置签约手机号操作类型[1-开通 3-注销]
            ,fin_new_acct -- 理财银行卡号变更新账号
            ,fin_new_open_brcno -- 理财银行卡号变更新账号所属机构
            ,quickin_pass -- 灵活盈交易密码(带账号转加密)
            ,cust_changes -- 客户信息变更内容1.通讯地址2.邮政编码3.联系电话4.手机5.EMAIL
            ,tlr_mobile -- 前台柜员手机号码
            ,deposit_trade_no -- 交易单编号
            ,acct_type_m -- 账号类型:0: 人民币个人非结算户1: 人民币个人结算户A: 外汇结算账户B: 乙种储蓄存款账户C: 丙种储蓄存款账户
            ,dsp_type -- 储种:S01储蓄活期S02	储蓄双整S03	零存整取S04	整存零取S05	存本取息S06	定活两便S07	储蓄通知S08	教育储蓄S18:财富宝
            ,dsp_period -- 存期:203-三个月、206-六个月、301-一年、302-二年、303-三年、305-五年、000-活期、101-一天、107-七天 、203-三个月、206-六个月、301-一年
            ,dsp_flag -- 转存标识:1:自动转存0:非自动转存
            ,tran_type -- 交易类型:CO-现开TO-转开
            ,to_acct_no -- 转出账号
            ,to_acct_name -- 转出账号名称
            ,to_pswd -- 转出账号密码
            ,to_idtp -- 转出证件类型:A:身份证,B:外国公民护照,C:户口薄,D:港澳居民通行证,E:还乡证,F:边民出入境通行证,G:军官证,H:士兵证,I:军事院校学员证,J:军队离休干部荣誉证,K:军官退休证,L:军人文职干部退休证,P:其他,Q:武警身份证,R:台湾居民通行证,S:中国公民护照,U:临时身份证
            ,to_idno -- 转出证件号码
            ,to_dwfs -- 转出支取方式：A:密码 D:印鉴 E:证件
            ,prcsna -- 交易类型
            ,nwinrt -- 利率
            ,matudt -- 到期日
            ,valuedt -- 起息日
            ,proxy_flag -- 代办人类型（0-否 1-监护代理 2-普通代理）
            ,quickin_type -- 灵活盈-储种（1-三个月 2-六个月 3-一年 4-二年 5-三年 6-五年 7-不约定存期 8-七天通知）
            ,acctlv -- 账户分类
            ,is_card -- 是否有卡
            ,regoresult -- 1识别失败，0识别成功
            ,similarity -- 0%~100%，>=80%为认定为本人
            ,issetnewpwd -- 是否设置新密码
            ,isfcfnoper -- 是否操作非柜面非同名限额签约(0-否,1-是)
            ,isfcfntype -- 非柜面非同名账户限额签约操作类型(0-签约 1-维护)
            ,isfcfnct -- 是否非柜面非同名账户限额签约(0-否,1-是)
            ,daylimit -- 日累计限额(非柜面非同名账户限额签约)
            ,txntimeslimit -- 日笔数限额(非柜面非同名账户限额签约)
            ,yearlimit -- 年累计限额(非柜面非同名账户限额签约)
            ,is_fcfnct_succeed -- 非柜面非同名账户限额签约是否成功(0-失败,1-成功)
            ,agreementid -- ECIF签约协议号
            ,custom_daylimit -- 自定义-日累计限额(万元)
            ,custom_txntimeslimit -- 自定义-日累计笔数
            ,custom_yearlimit -- 自定义-年累计限额(万元)
            ,pro_nationality -- 代理人国籍
            ,mobile_type -- 号码性质 0--本人1--监护人
            ,outflg -- 外出标注-0，默认网点0：网点凭证 1：外出凭证
            ,netstate -- 网银密码重置--状态默认送0
            ,logonpwnew -- 网银密码重置--新登陆密码
            ,netreset -- 是否网银密码重置
            ,relativetp -- 监护人/亲属证件类型
            ,relativena -- 监护人/亲属姓名
            ,relativeno -- 监护人/亲属号码
            ,taxresident -- 税收居民身份（1仅为中国税收居民2仅为非居民3既是中国税收居民又是其他国家（地区）税收居民4无需声明5空）
            ,birthplace -- 纳税人出生地（中英文字符）
            ,taxarea -- 税收居民国（地区）
            ,taxnumber -- 纳税人识别号
            ,taxarea2 -- 纳税居民国家（地区）2（发送报文时整合在TAXAREA）
            ,taxarea3 -- 纳税居民国家（地区）3（发送报文时整合在TAXAREA）
            ,taxnumber2 -- 纳税人识别号2（发送报文时整合在TAXNUMBER）
            ,taxnumber3 -- 纳税人识别号3（发送报文时整合在TAXNUMBER）
            ,taxnullreason -- 纳税人识别号为空原因
            ,taxstatement -- 是否取得自证声明（0-未取得自证声明1-取得自证声明）
            ,customersurname -- 客户_姓（字母）
            ,customergivenname -- 客户_名（字母）
            ,taxnullreason2 -- 纳税人识别号为空原因2
            ,taxnullreason3 -- 纳税人识别号为空原因3
            ,boundaccno -- 绑定账号
            ,boundbank -- 绑定账号开户行
            ,checkcase -- 落地审核原因
            ,ocridtdt -- 证件生效日期
            ,yflag -- 手机盾标志 Y:为是手机盾，N:为不是手机盾
            ,phoneoperate -- 手机盾操作类型0：开通
            ,camp_emp_id -- 营销工号
            ,notemessagephone1 -- 短信通签约号码1
            ,notemessagephone2 -- 短信通签约号码2
            ,notemessagephone3 -- 短信通签约号码3
            ,notemessagephone4 -- 短信通签约号码4
            ,notemessagephone5 -- 短信通签约号码5
            ,isagtsch -- 是否个人扣款协议签约(0-否,1-是)
            ,proxy_idtdt_sl -- 是否云闪付绑定签约
            ,is_flashpay_contract -- 云闪付绑定签约是否成功  0-失败 1-成功
            ,flashpay_contract_if_succeed -- 
            ,local_ip -- 开户IP
            ,local_mac -- 开户MAC
            ,uuid -- UUID
            ,ukey_modify_if_succeed -- U盾管理状态
            ,is_send_message -- 是否发送营销短信
            ,phonepay_contract_if_succeed -- 手机转账签约是否成功(0-失败 1-成功)
            ,is_phonepay_contract -- 是否手机转账签约(0-否 1-是)
            ,regedittype -- 登记注册类型
            ,sco -- 
            ,is_phonepay_contract1 -- 是否手机转账签约(0-否 1-是)
            ,phonepay_contract_if_succeed1 -- 手机转账签约是否成功(0-失败 1-成功)
            ,regedittype1 -- 登记注册类型
            ,limit_oper_type -- 非柜面签约
            ,limit_oper_channel -- 
            ,day_transfer_count -- 非柜面签约-日总笔数
            ,day_transfer_amount -- 非柜面签约-日总限额
            ,year_transfer_count -- 非柜面签约-年总笔数
            ,year_transfer_amount -- 非柜面签约-年总限额
            ,limit_oper_result -- 
            ,tally_state -- 记账状态 0 未记账 1 记账成功 2 记账失败
            ,agt_num -- 协议号
            ,dspbgndt -- 转存起始日期
            ,dspenddt -- 转存截止日期
            ,dsptyper -- 转存类型 1 转存双整 2 转存通知
            ,invest_account -- 储蓄定投签约账户
            ,invest_trnamt -- 转存金额
            ,prd_id -- 产品编号
            ,quickin_agreement_id -- 灵活盈协议编号
            ,quickin_agreement_status -- 灵活盈协议状态
            ,quickin_agreement_type -- 灵活盈协议类型
            ,quickin_fin_fixed_amt -- 灵活盈理财固定金额
            ,quickin_int_min_amt -- 灵活盈最小起存金额
            ,quickin_remain_amt -- 灵活盈协议留存金额
            ,quickin_start_amt -- 灵活盈起始金额
            ,quickin_transfer_day -- 划转日
            ,quickin_transfer_freq -- 灵活盈划转频率
            ,redep_freq -- 转存频率
            ,renew_corp -- 转存单位
            ,rpdsp -- 转存周期 Y-年 Q-季 M-月 W-周 D-天
            ,sub_acct_num -- 子账号
            ,sum_sub_num -- 汇总子户号
            ,biz_type -- 业务种类
            ,biz_dt -- 交易日期（yyyy-MM-dd hh:mm:ss）
            ,finance_card_type -- 理财账户类型
            ,fin_new_acct_crspd_pty_id -- 新账号对应客户号
            ,custchnlid -- 开通渠道
            ,riskmonths -- 风险有效期月数
            ,rskcd -- 风险等级代码
            ,oper_flag -- 1 客户级 2账户级
            ,third_chg_card_id -- 三方存管换卡标识
            ,third_open_org_id -- 三方存管开户机构
            ,usb_key_cert_id -- USBKey证书编号
            ,old_cert_key_id -- 旧证书KEYID
            ,safe_instr_model -- 安全工具型号(0：飞天1：捷德)
            ,u_brch_num -- U盾网点号
            ,u_oper_typ -- U盾操作类型（2：注销 3：损坏更换 4：挂失更换 5：发放）
            ,wthr_out -- 是否出库 默认Y Y：是 N：否
            ,lost_operate_method -- 挂失操作方式，比如书面挂失、口头挂失UV-口头解挂 UW-正式解挂 VL-口挂 WL-书挂
            ,lost_no -- 账户/凭证/结算卡挂失号码
            ,acct_name -- 账户名称
            ,loss_id -- 挂失编号
            ,acct_seq_no -- 账户序列号
            ,acct_password -- 账户密码
            ,voucher_change_type -- 凭证更换类型，比如挂失补发、损坏更换等，不同的更换类型会对应不同的处理流程 01-挂失补发 02-凭证更换 03-损坏更换 04-同号换卡领卡/记名卡领卡 05-单位存单置换 06-单位存单收回如果补开、凭证更换必传
            ,new_vchr_typ -- 新凭证类型
            ,new_vchr_num -- 新凭证号码
            ,voucher_change_reason -- 更换原因
            ,td_inout_operate_type -- 存单移入必传 定期账户转入转出操作类型 01-转入 02-互转 03-转出
            ,in_base_acct_no -- 移入账号
            ,in_prod_type -- 转入账户产品类型
            ,enter_acct_ccy -- 转入账户币种
            ,target_acct_class -- 目标账户类别（一二三类户），即账户升级后的账户类别，满足人行对于电子账户的管理办法1-一类账户 2-二类账户 3-三类账户
            ,password_operate_type -- 账户密码操作类型 账户密码操作类型01-新建 02-重置 03-修改 04-解锁 05-校验 06-激活 07-凭证解挂场景密码重置 08-弱密码校验
            ,password_type -- 密码类型，目前核心只支持WD，接口未上送则默认为WDWD-支取密码 QY-查询密码 MA-账户管理密码
            ,password_old -- 旧密码
            ,iss_country -- 发证国家
            ,password_effect_date -- 密码生效日期
            ,lost_reason -- 挂失原因
            ,res_flag -- 标识挂失账户是N进行账户止付,挂失时必输，解挂时不需要输入Y-是 N-不是
            ,pause_post -- 暂停附言
            ,channel -- 渠道
            ,ntw_ceph_bank_pause_type -- 网银手机银行管理 业务类型 01：个人动态密码管理 02：解锁登录密码 03：网银/手机银行暂停/恢复 04：登录密码和用户状态重置 05：客户手机盾信息维护 06：账户暂停/恢复
            ,ntw_ceph_bank_pause_pwd_status -- 网银手机银行管理 密码状态：0:正常 7：重置网银密码 8：重置交易密码 9 : 柜面开户重置密码
            ,tfr_encry_ind -- 转加密标识  1:数字加字母组合 0:纯数字(柜面调用)
            ,cfm_new_logon_pwd -- 确认新登录密码
            ,pwd_keyb_node_id -- 密码键盘节点ID
            ,safe_ceph_num -- 安全手机号
            ,dynamic_password_status -- 个人动态密码状态 ： 0---开 1---关
            ,pause_status -- 网银/手机银行暂停/恢复 状态 0-正常 1-永久停止 2-临时暂停
            ,dynamic_password_ind_id -- 个人动态密码标识编号 1：查询 2：新增 3：修改 4: 删除
            ,clous_shield_ind_id -- 华兴云盾标识编号 1：设置密码 0：重置密码
            ,deft_safe_instr -- 默认安全工具 1：华兴U盾 2：手机短信密码
            ,indv_act_status -- 个人账户状态
            ,acct_pause_rsns -- 账户暂停原因
            ,ntw_ceph_bank_pause_resu_status -- 网银/手机银行暂停/恢复状态 0-正常 1-永久停止 2-临时暂停
            ,pause_with_resu_oper_typ -- 暂停/恢复操作类型 0-网银 1-手机银行 2-网银手机银行
            ,temp_pause_start_tm -- 临时暂停开始时间，格式为yyyyMMddHHmmss
            ,temp_pause_cncl_tm -- 临时暂停结束时间，格式为yyyyMMddHHmmss
            ,ceph_cs_oper_typ -- 手机盾信息操作类型 开通：0 停用：1 启用：2 注销：4
            ,cs_ord_nbr -- 云盾序号
            ,open_br_node_num -- 开通网点号
            ,key_name -- 密钥名称
            ,total_cnt -- 网银签约总笔数
            ,reg_typ -- 手机号码支付协议注册类型 DFLT 默认账户 NDFT 非默认账户
            ,narrative1 -- 备注
            ,prest_flg -- 赠送标志 0-正常开通 1-赠送开通
            ,prest_mon -- 赠送月份 如果是赠送服务（赠送标志为1），则填入赠送的月份数。没有此信息填空或“00”
            ,vip_flg -- VIP标志 0-非VIP服务， 1-VIP服务，（默认填0，如果操作员选择了VIP服务标志，则填1），VIP针对客户而言。
            ,chrg_pkg_typ -- 收费套餐类型 01包月/ 12包年。
            ,chrg_mode -- 收费模式 1-按账户数收费 2-按服务数收费 3-按短信条数收费 4-按定额收费
            ,chrg_amt -- 收费金额 请按字符串格式传输，如”RATE”:”0.56987” 当收费模式为定额收费时填写
            ,disct -- 折扣 客户收费折扣
            ,disct_mon -- 折扣月份 当存在折扣时，填写折扣有效月份，没有此信息则填空或00
            ,acct_purp -- 账户用途
            ,acct_attr -- 账户属性
            ,agtsch_prd_id -- 个人扣款协议-产品编号
            ,agtsch_prd_type -- 个人扣款协议  C-签约U-维护D-解约
            ,payer_acct -- 付款人账号
            ,payer_acct_typ -- 付款人账户类型
            ,payer_act_nm -- 付款人账户户名
            ,payer_cert_typ -- 付款人证件类型
            ,payer_cert_num -- 付款人证件号
            ,payer_ceph_num -- 付款人手机号
            ,payer_bank -- 付款人开户行行号
            ,rcver_acct_typ -- 收款人账户类型
            ,payee_base_acct_no -- 收款人账号
            ,rcver_act_nm -- 收款人账户户名
            ,chn_num -- 渠道号
            ,sign_dtl -- 签约明细
            ,dsp_trnamt -- 转存周期 Y    年 Q    季 M    月 W    周 D    天
            ,redep_start_dt -- 转存起始日期
            ,redep_end_dt -- 转存截止日期
            ,pause_flg -- 暂停标志 0 否 1 是
            ,node_num -- 节点号
            ,third_chg_sign_prd -- 签约产品 SV014银银合作代理第三方存管协议
            ,agt_typ -- 协议类型CLD-存立得 DC-大额存单 DLS-贷利省 HQB-活期宝 JDL-加多利 KDT-卡贷通 KYD-卡易贷 PCP-资金池 WDL-稳得利 XDB-协定宝 XDCK-协定存款产品 XDL-先得利 YBWL-一本万利 YCD-英才贷 YDT-易贷通 YHT-一户通 ZHY-周享赢 ZXY-坐享其盈 ZZB-至尊宝 LOA-贷款 ODF-法人透支协议 FIN-卡理财协议 SMS-短信 PKG-费用套餐 FEE-暂不收费 PCD-周期性强制扣划 ACC-协定存款协议 SWP-账户清扫协议 ID-智能存款协议 SL-金额补足协议 REC-回单签约 ES-电票签约 YD-约定 NTE-活期智能存款 PAS-隐私账户签约 TXY1-同兴赢活期签约 TXY2-跨境资金融入签约 CXDT-储蓄定投 TBCK-跳板存款 LHY-灵活盈 P2P-P2P协议 JZG-建筑港 ZCG-资产存管 ZQS-资金清算 LYE-财政零余额
            ,agt_id -- 协议编号
            ,agt_status_cd -- 协议状态 普通协议使用，可应用于大部分场景，贷款模块用于资产证券化合同状态A-生效 E-失效 YB-赎回 YS-发行 YP-已封包 NP-未封包 NS-未发行 YC-已撤包
            ,st_dt -- 开始日期
            ,end_dt_ora -- 结束日期
            ,sign_prod_type -- 签约产品类型
            ,remain_amt -- 协议留存金额 请按字符串格式传输，如”RATE”:”0.56987” 协议留存金额
            ,start_amt -- 起始金额 请按字符串格式传输，如”RATE”:”0.56987” 起始金额
            ,transfer_freq_type -- 划转频率类型 Y-年 Q-季 M-月 W-周 D-日
            ,acct_movt_date -- 转存交易日期
            ,peri -- 存期
            ,term_type -- 期限单位 Y-年 Q-季 M-月 W-周 D-日
            ,acct_exec -- 银行客户经理
            ,transfer_end_date -- 转存结束日期
            ,transfer_day -- 划转日
            ,transfer_freq -- 划转频率
            ,fin_fixed_amt -- 理财固定金额 请按字符串格式传输，如”RATE”:”0.56987”
            ,min_depo_amt -- 最小起存金额 请按字符串格式传输，如”RATE”:”0.56987” 最小起存金额
            ,opt_type -- 资管信托代销协议操作类型 01签约 02解约 03维护
            ,matn_oper_typ -- 维护操作类型 0-客户信息维护 1-客户经理代码维护
            ,actl_benef -- 实际受益人 0-本人（默认） 1-他人
            ,wthr_exist_actl_ctrl_rela -- 是否存在实际控制关系 0-否（默认） 1-是
            ,wthr_is_np_integrity_rec -- 是否有不良诚信记录 0-否（默认） 1-是
            ,ori_pty_mgr_cd -- 原客户经理代码
            ,new_pty_mgr_cd -- 新客户经理代码
            ,pty_mgr_adj_flg -- 客户经理调整标志 0－全部（将原客户经理替换成新客经理） 1－调整客户所属客户经理代码 2－理财账号客户经理代码 3－按流水客户经理 4－调整定投客户经理代码 5－调整定赎客户经理代码 8－调整客户对应所有客户经理
            ,spec_seq_num -- 指定流水号
            ,enro_ceph_num -- 注册手机号
            ,acct_typ -- 账户类型 01 - 为Ⅰ类户（非信用卡） 02 - 为Ⅱ类户 03 - 为Ⅲ类户 04-准贷记卡 05-借贷合一卡 不填-信用卡
            ,zone_num -- 地区码 建议需求方至少定位到省市、直辖市级地区区位。默认为0000，长度为4 位
            ,scene_num -- 云闪付场景码
            ,card_prd_id -- 卡产品编号
            ,txn_equip_info -- 交易设备信息
            ,put_new_fld -- 拉新字段
            ,cvn_num -- CVN码
            ,valid_dt -- 有效期
            ,bcs_res_ceph_num_flg -- 核心预留手机号标志 1代表是核心预留手机号 0代表非核心预留手机号
            ,short_lett_srv_type -- 短信服务类 短信服务类，以逗号分隔（A,B）
            ,ceph_num_app_scope -- 手机号码应用范围 1-只修改该账号下对应的手机号码 2-修改客户所有账号对应的手机号码，填1时必须填写签约账号
            ,old_ceph_num -- 旧手机号码
            ,new_ceph_num -- 新手机号码
            ,ceph_num_qty -- 手机号码个数
            ,direct_sign_matn_flg -- 定向转账签约维护标志 0-解约, 1-更新, 2-签约
            ,direct_sign_typ -- 定向转账签约类型 0-综合柜面, 1-流程银行
            ,ghb_out_ind -- 行内外标识 0-行内 1-行外
            ,bank_id -- 银行编号
            ,bank_name -- 银行名称
            ,provin_cd -- 省份代码
            ,city_cd -- 城市代码
            ,rcv_open_brch_id -- 收款方开户网点编号
            ,rcv_open_brch_name -- 收款方开户网点名称
            ,rcver_ceph_num -- 收款人手机号码
            ,recv_acct_upda_flg -- 收款账户更新标志 收款账户更新标志0：删除 1：更新,2：增加（SIGNUPDATEFLAG=0时，系统默认0，SIGNUPDATEFLAG=2时，系统默认为2）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 逻辑主键
    ,o.process_inst_id -- 
    ,o.main_flow_id -- 
    ,o.scan_seq_no -- 流水号
    ,o.fr_org_code -- 前台机构编码
    ,o.tr_date -- 客户开户日期
    ,o.biz_code -- 业务编码[代码T007][参考CFG_T_BIZ_CODE]
    ,o.voucher_no -- 凭证号码
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.english_name -- 客户英文名称
    ,o.sex -- 性别
    ,o.cert_type -- 证件类型[代码0009][A-公民身份号码B-军官证C-解放军文职干部证D-警官证E-解放军士兵证F-户口簿G-(港、澳)回乡证、通行证H-(台)通行证、其他有效旅行证I-(外国)护照J-(中国)护照K-武警文职干部证L-武警士兵证P-全国组织机构代码Q-海外客户编号R-营业执照号码X-其它有效证件Z-其它]
    ,o.cert_code -- 证件号码
    ,o.crt_cert_organ -- 发证机关地区代码
    ,o.birthday -- 出生日期
    ,o.weblock_flag -- 婚姻状况[代码0007][10-未婚 20-已婚 21-初婚 22-再婚 23-复婚 40-离婚 90-未说明的婚姻状况 30-丧偶5-已婚有子女6-已婚无子女7-其他]
    ,o.education -- 学历
    ,o.occupation -- 职业[代码0048][]
    ,o.rank -- 职务
    ,o.income -- 月收入[代码0046][1-1500以下 2-1500到2000 3-2000到3000 4-3000到5000 5-5000到8000 6-8000到10000 7-10000到30000 8-30000以上]
    ,o.company -- 工作单位名称
    ,o.home_address -- 家庭地址
    ,o.fix_telephone -- 固定电话
    ,o.office_phone -- 办公电话
    ,o.home_phone -- 家庭电话
    ,o.mobile -- 移动电话
    ,o.contact_address -- 联系地址
    ,o.postcode -- 邮政编码
    ,o.acct_type -- 交易对手账户类型
    ,o.spec_type -- 存款账户类型
    ,o.sf_scp_flag -- 通存通兑方式[代码0104][0-不通存通兑1-通存通兑2-通存不通兑3-通兑不通存]
    ,o.curr_type -- 币种[代码T003][参考CFG_T_CURRENCY_TYPE]
    ,o.cf_flag -- 钞汇鉴别[代码0011][0-钞1-汇]
    ,o.fee_drw_type -- 费用支取别[代码0012][0-不收1-现金2-转账]
    ,o.spec_time -- 存期
    ,o.amount -- 金额
    ,o.biz_password -- 交易密码
    ,o.biz_account -- 交易账号
    ,o.open_acct_password -- 开户密码
    ,o.tr_account -- 转帐账号
    ,o.tr_password -- 转账密码
    ,o.attor_opr_code -- 客户经理编号
    ,o.attor_opr_name -- 客户经理姓名
    ,o.attor_org_code -- 客户经理所在网点
    ,o.level_b_pin -- 前台机构编码
    ,o.fr_tlr_opr_no -- 前台柜员号
    ,o.puc_check_flag -- 人行核查标志[代码0039][0-不用人行核查1-人行核查]
    ,o.check_option -- 身份核查意见
    ,o.check_remark -- 身份核查意见备注
    ,o.check_opr_code -- 核查操作员
    ,o.puc_chk_date -- 人行身份核查时间
    ,o.update_flag -- 客户信息更新标志
    ,o.check_status -- 审批状态
    ,o.check_fall_reason -- 审批未通过原因
    ,o.succ_flag -- 成功标志
    ,o.status -- 流程状态
    ,o.home_addr_type -- 住宅类型[代码0106][1-自置2-公积金贷款3-商业贷款4-租用5-其他]
    ,o.company_type -- 单位性质[代码0107][01-国家机关02-事业单位03-国有企业04-私营，民营企业05-中外合资，合作，外资企业06-其他]
    ,o.obtain_opr_code -- 任务获取柜员号
    ,o.commission -- 代办事由
    ,o.email -- 邮箱
    ,o.often_site -- 经常居住地
    ,o.relation -- 与被代理人关系
    ,o.nationality -- 国籍
    ,o.pro_name -- 代理人姓名(中文)
    ,o.pro_type -- 代理人证件类型
    ,o.pro_fashion -- 代理人联系方式
    ,o.is_porxy -- 是否代办(0 否 1 是)
    ,o.accept_no -- 受理号(任务号)
    ,o.trane_code -- 交易代码
    ,o.idtfna_name -- 证件姓名
    ,o.pro_cert_code -- 代理人证件号码
    ,o.is_net_silver_contract -- 是否操作网银(0-否 1-是)
    ,o.open_flag -- 开户标志(0:无卡介质也无客户信息,1:有卡介质的2:无卡介质，但在我行有客户信息)
    ,o.group_flag -- 分组标志(预留扩展，暂时送99)
    ,o.netb_passwd -- 网银初始登录密码
    ,o.netb_left_msg -- 预留信息
    ,o.netb_sign_mobile -- 签约手机号码
    ,o.netb_sec_model -- 安全工具型号(0-飞天  1-捷德)
    ,o.netb_sec_type -- 安全工具类型(0-个人，1-企业)
    ,o.netb_sec_no -- 安全工具编号
    ,o.netb_dynamic_opt_no -- 动态口令编号
    ,o.netb_dynamic_card_no -- 口令卡编号
    ,o.netb_is_transfer -- 账号开通权限(0-查询 1-转账)
    ,o.netb_ac_limit_pertrs -- 账户级单笔限额
    ,o.netb_ac_limit_perday -- 账户级日累计限额
    ,o.cert_date -- 证件到期日
    ,o.id_address -- 户籍地址
    ,o.is_sms_contract -- 是否操作短信通(0-否 1-是)
    ,o.is_tel_n_trnsf -- 非定向转账是否开通（1-开通）
    ,o.is_tel_n_trnsf_default_limit -- 非定向转账默认额度（1-默认额度）
    ,o.tel_n_trnsf_single_limit -- 非定向转账单笔额度
    ,o.tel_n_trnsf_day_limit -- 非定向转账单日额度
    ,o.is_tel_d_trnsf -- 定向转账是否开通（1-开通）
    ,o.is_tel_d_trnsf_no_limit -- 定向转账无限额度（1-无限额）
    ,o.tel_d_trnsf_single_limit -- 定向转账单笔额度
    ,o.tel_d_trnsf_day_limit -- 定向转账单日额度
    ,o.payee_name1 -- 定向转账收款人全称1
    ,o.payee_accno1 -- 定向转账收款人账号1
    ,o.payee_bank_name1 -- 定向转账开户银行全称1
    ,o.payee_name2 -- 定向转账收款人全称2
    ,o.payee_accno2 -- 定向转账收款人账号2
    ,o.payee_bank_name2 -- 定向转账开户银行全称2
    ,o.sms_notice_limit -- 账户变动短信通知起点金额
    ,o.sec_node_id -- 加密结点号
    ,o.proxy_sex -- 代理人性别
    ,o.proxy_idtdt -- 证件失效日期
    ,o.proxy_id_address -- 代理人证件地址
    ,o.sms_contract_if_succeed -- 短信通签约是否成功(0-失败 1-成功)
    ,o.net_silver_contract_succeed -- 网银签约是否成功(0-失败 1-成功)
    ,o.is_netb_default_limit -- 网银签约是否默认限额(1-是)
    ,o.prsntg -- 居民性质代码
    ,o.staffflag -- 员工标志(默认0)
    ,o.custlv -- 客户级别(默认00)
    ,o.risklv -- 客户风险承受能力评估等级（1-保守型 2-谨慎型 3-稳健型 4-进取型 5-激进型）
    ,o.wkutad -- 工作单位地址
    ,o.roleid -- 职称等级
    ,o.worktx -- 其他职业
    ,o.csec_node_id -- 转加密结点号
    ,o.netb_csec_passwd -- 转加密网银初始密码
    ,o.transfer_channel -- 转账渠道（1-手机银行定向转账2-电话银行定向转账）
    ,o.mobile_ac_limit_pertrs -- 手机银行账户级单笔限额
    ,o.mobile_ac_limit_perday -- 手机银行账户级日累计限额
    ,o.is_mobile_default_limit -- 手机银行是否默认限额(1-是)
    ,o.fax -- 传真
    ,o.area_code -- 地区代码
    ,o.truth_flag -- 实名标志
    ,o.trnamt -- 转存金额
    ,o.voucherty -- 凭证类型    738-华兴卡 741-借记芯片卡
    ,o.id_check_result -- 身份证联网核查结果[00-公民身份证号码与姓名一致，且存在照片01-公民身份证号码与姓名一致，但不存在照片02-公民身份号码存在，但与姓名不匹配03-公民身份号码不存在04-其他错误]
    ,o.mobile_open_status -- 移动业务审批状态 0处理中 1审批通过 2审批不通过(开卡、网银签约、短信通签约)
    ,o.account_update_flag -- 账户更新标志[0：删除 1：更新 2：增加 为空表示不操作账户]
    ,o.submit_status -- 移动综合签约提交状态[提交锁定字段 0：未处理1：处理中2：提交成功]
    ,o.netb_biz_type -- 网银签约业务类型[0：新增1：变更]
    ,o.often_site_eq_id_addr -- 经常居住地同身份证件地址（0否 1是）
    ,o.net_ukey -- 开通华兴U盾（0否 1是2关联）
    ,o.card_type -- 卡产品
    ,o.card_rank -- 卡等级
    ,o.is_finance_contract -- 是否操作理财(0-否 1-是)
    ,o.sendfreq -- 对账单发送频率[0-有交易发生寄送1-不寄送2-按月3-按季4-半年5-一年]
    ,o.sendmode -- 对账单寄送方式(共8个字符，每个字符代表一种交易手段，其含义为：第1位：邮寄第2位：传真第3位：E-mail第4位：短消息第5~8位：保留。每位字符取1表示采用此种手段，取0表示不使用)
    ,o.risklevel -- 理财产品风险等级（0-未评定 1-低风险2-较低风险3-中风险4-较高风险5-高风险）
    ,o.clientgroup -- 客户分组[a-	群客户Z- 其他客户]
    ,o.chnlflag -- 高风险产品柜台以外渠道允许购买标志(0-不允许 1-允许 默认0)
    ,o.finance_contract_succeed -- 理财签约是否成功(0-失败 1-成功)
    ,o.finance_acctno -- 理财签约账号
    ,o.open_brcno -- 开卡机构
    ,o.cust_mgrno -- 客户经理代码
    ,o.sms_cust_sign -- 短信通客户是否已签约(0:未签约1:已签约)
    ,o.fee_acct_no -- 扣费账号
    ,o.fee_acct_brcno -- 扣费账号分行号
    ,o.fee_acct_nodeno -- 扣费账号行所号
    ,o.contact_phone -- 联系手机号码
    ,o.attbrn -- 业务归属机构
    ,o.new_password -- 新交易密码
    ,o.new_account -- 新账号
    ,o.chactg -- 更换类型
    ,o.stpytg -- 挂失类型
    ,o.rplsfs -- 挂失形式
    ,o.submit_state -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,o.netopflag -- 网银操作类型[0-开通1-维护 2-解约（注销）3-暂停4-恢复5开通以下服务]
    ,o.smsopflag -- 短信通操作类型[0-签约 1-解约 2-短信通手机号码新增 3-短信通手机号码修改 4-短信通手机号码取消]
    ,o.finopflag -- 理财操作类型[0-签约  1-解约 2-更换账户  3-银行帐号登记取消]
    ,o.delukey -- 是否删除Ukey(0-否 1-是)
    ,o.bgnamt -- 短信通知起点金额
    ,o.trtmrs -- 核实结果  01未核实，02真实
    ,o.loss_date -- 挂失日期(yyyymmdd)
    ,o.loss_reg_no -- 挂失登记号
    ,o.undays -- 挂失天数    临时挂失5天，正式挂失7天
    ,o.payway -- 支取方式 S-凭印鉴支取 P-凭密码支取 W-无密码无印鉴支取 B-凭印鉴和密码支取 O-凭证件支取 R-支付密码器和印鉴
    ,o.is_fund_contract -- 是否操作基金(0-否 1-是)
    ,o.fundopflag -- 基金操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,o.fin_manager_id -- 理财经理编号
    ,o.szsecno -- 深交所证券账号
    ,o.shsecno -- 上交所证券账号
    ,o.minorflag -- 是否成年人标志 1-否，0-是
    ,o.fundnewacct -- 基金新银行卡号
    ,o.fund_contract_if_succeed -- 基金签约操作是否成功(0-失败 1-成功)
    ,o.is_third_manage_contract -- 是否三方存管签约操作
    ,o.cobank -- 合作行
    ,o.ori_acct -- 三方存管原结算账号
    ,o.ori_brcode -- 三方存管原结算账号开户机构
    ,o.bond_acct -- 证券资金台账账号
    ,o.bond_pass -- 证券资金台账密码
    ,o.bond_code -- 券商代码
    ,o.bond_name -- 券商名称
    ,o.third_manage_if_succeed -- 三方存管签约操作是否成功(0-失败 1-成功)
    ,o.is_invest_contract -- 是否储蓄定投签约操作 0-否，1-是
    ,o.invest_opflag -- 储蓄定投操作类型 1-签约 2-维护 3-解约
    ,o.invest_contract_if_succeed -- 储蓄定投签约操作是否成功(0-失败 1-成功)
    ,o.is_quickin_contract -- 是否灵活盈签约操作 0-否，1-是
    ,o.quickin_opflag -- 灵活盈签约操作类型 1-签约 2-维护 3-解约
    ,o.chan_save_tp -- 转存类型 1-活期转双整 2-活期转通知
    ,o.chan_save_deadline -- 灵活盈转存期限 107-七天 203-三个月206-六个月301-一年302-二年303-三年305-五年
    ,o.chan_save_amt -- 转存起点金额
    ,o.save_low_amt -- 最低留存金额
    ,o.quickin_contract_if_succeed -- 灵活盈签约操作是否成功(0-失败 1-成功)
    ,o.sign_type -- 签约业务种类1. 三方存管  2. 基金代销账户类3. 基金代销交易类4. 理财 5. 个人电子银行业务 多个用逗号隔开如1,2,3,4,5
    ,o.third_ma_apply_tp -- 三方存管申请业务种类 1建立结算账户资金转账对应关系2修改结算账户资金转账对应关系3更新账户客户基本信息
    ,o.third_ma_new_acct -- 三方存管新账号
    ,o.is_acctfund_contract -- 基金代销账户类签约操作 0-否，1-是
    ,o.acctfund_sign_type -- 基金代销账户类签约种类 1-签约2-解约3-维护
    ,o.is_bill_send -- 对账单寄送要求 1-寄送0-不寄送
    ,o.acctfund_ori_acct -- 交易账户变更原账号 默认前“签约账号”项
    ,o.is_tradefund_contract -- 基金代销交易类签约操作 0-否，1-是
    ,o.tradefund_sign_type -- 基金代销交易类签约种类 基金认购  1-基金申购2-基金赎回3-智能定投赎回4-基金转换5-基金转托管6-当日交易撤单7-分红方式变更
    ,o.tradefund_name -- 基金名称
    ,o.tradefund_code -- 基金代码
    ,o.savings_invest_optp -- 储蓄定投操作类型 1-终止 2-暂停 3-恢复
    ,o.time_invest_code -- 定投编号
    ,o.third_manage_optp -- 三方存管签约操作类型[ 1-开通 2-银行卡号变更 3-解约]
    ,o.fund_acct -- 基金签约操作账号
    ,o.fund_acct_brcno -- 基金签约账号开卡网点
    ,o.quickin_leave_amt -- 灵活盈—活期账户留存金额(1-1000元2-3000元3-5000元4-10000元5-其它)
    ,o.quickin_leave_amt_other -- 灵活盈—活期账户留存金额_其它
    ,o.netb_op_choice -- 网银修改服务选项(1登录密码 2手机动态密码)
    ,o.netb_password_optp -- 网银登录密码操作类型(1重置 2解锁)
    ,o.netb_netphone_optp -- 手机动态密码操作类型(0-不开通1开通2注销3指定手机号4变更手机号5关联)
    ,o.ukey_optp -- 华兴U盾操作类型(1开通2注销3更换4证书更新5密码重置)
    ,o.is_sms_set_phone -- 短信通是否设置签约手机号 0-否，1-是
    ,o.is_net_trans_limit_set -- 是否网银转账限额设置 0-否，1-是
    ,o.is_mob_trans_limit_set -- 手机银行是否非定向转账限额设置 0-否，1-是
    ,o.direct_trans_optp -- 定向转账操作类型[1开通2修改3注销]
    ,o.is_direct_trans_ac_set -- 是否定向收款账户设置[0-否，1-是]
    ,o.sms_set_phone_optp -- 短信通设置签约手机号操作类型[1-开通 3-注销]
    ,o.fin_new_acct -- 理财银行卡号变更新账号
    ,o.fin_new_open_brcno -- 理财银行卡号变更新账号所属机构
    ,o.quickin_pass -- 灵活盈交易密码(带账号转加密)
    ,o.cust_changes -- 客户信息变更内容1.通讯地址2.邮政编码3.联系电话4.手机5.EMAIL
    ,o.tlr_mobile -- 前台柜员手机号码
    ,o.deposit_trade_no -- 交易单编号
    ,o.acct_type_m -- 账号类型:0: 人民币个人非结算户1: 人民币个人结算户A: 外汇结算账户B: 乙种储蓄存款账户C: 丙种储蓄存款账户
    ,o.dsp_type -- 储种:S01储蓄活期S02	储蓄双整S03	零存整取S04	整存零取S05	存本取息S06	定活两便S07	储蓄通知S08	教育储蓄S18:财富宝
    ,o.dsp_period -- 存期:203-三个月、206-六个月、301-一年、302-二年、303-三年、305-五年、000-活期、101-一天、107-七天 、203-三个月、206-六个月、301-一年
    ,o.dsp_flag -- 转存标识:1:自动转存0:非自动转存
    ,o.tran_type -- 交易类型:CO-现开TO-转开
    ,o.to_acct_no -- 转出账号
    ,o.to_acct_name -- 转出账号名称
    ,o.to_pswd -- 转出账号密码
    ,o.to_idtp -- 转出证件类型:A:身份证,B:外国公民护照,C:户口薄,D:港澳居民通行证,E:还乡证,F:边民出入境通行证,G:军官证,H:士兵证,I:军事院校学员证,J:军队离休干部荣誉证,K:军官退休证,L:军人文职干部退休证,P:其他,Q:武警身份证,R:台湾居民通行证,S:中国公民护照,U:临时身份证
    ,o.to_idno -- 转出证件号码
    ,o.to_dwfs -- 转出支取方式：A:密码 D:印鉴 E:证件
    ,o.prcsna -- 交易类型
    ,o.nwinrt -- 利率
    ,o.matudt -- 到期日
    ,o.valuedt -- 起息日
    ,o.proxy_flag -- 代办人类型（0-否 1-监护代理 2-普通代理）
    ,o.quickin_type -- 灵活盈-储种（1-三个月 2-六个月 3-一年 4-二年 5-三年 6-五年 7-不约定存期 8-七天通知）
    ,o.acctlv -- 账户分类
    ,o.is_card -- 是否有卡
    ,o.regoresult -- 1识别失败，0识别成功
    ,o.similarity -- 0%~100%，>=80%为认定为本人
    ,o.issetnewpwd -- 是否设置新密码
    ,o.isfcfnoper -- 是否操作非柜面非同名限额签约(0-否,1-是)
    ,o.isfcfntype -- 非柜面非同名账户限额签约操作类型(0-签约 1-维护)
    ,o.isfcfnct -- 是否非柜面非同名账户限额签约(0-否,1-是)
    ,o.daylimit -- 日累计限额(非柜面非同名账户限额签约)
    ,o.txntimeslimit -- 日笔数限额(非柜面非同名账户限额签约)
    ,o.yearlimit -- 年累计限额(非柜面非同名账户限额签约)
    ,o.is_fcfnct_succeed -- 非柜面非同名账户限额签约是否成功(0-失败,1-成功)
    ,o.agreementid -- ECIF签约协议号
    ,o.custom_daylimit -- 自定义-日累计限额(万元)
    ,o.custom_txntimeslimit -- 自定义-日累计笔数
    ,o.custom_yearlimit -- 自定义-年累计限额(万元)
    ,o.pro_nationality -- 代理人国籍
    ,o.mobile_type -- 号码性质 0--本人1--监护人
    ,o.outflg -- 外出标注-0，默认网点0：网点凭证 1：外出凭证
    ,o.netstate -- 网银密码重置--状态默认送0
    ,o.logonpwnew -- 网银密码重置--新登陆密码
    ,o.netreset -- 是否网银密码重置
    ,o.relativetp -- 监护人/亲属证件类型
    ,o.relativena -- 监护人/亲属姓名
    ,o.relativeno -- 监护人/亲属号码
    ,o.taxresident -- 税收居民身份（1仅为中国税收居民2仅为非居民3既是中国税收居民又是其他国家（地区）税收居民4无需声明5空）
    ,o.birthplace -- 纳税人出生地（中英文字符）
    ,o.taxarea -- 税收居民国（地区）
    ,o.taxnumber -- 纳税人识别号
    ,o.taxarea2 -- 纳税居民国家（地区）2（发送报文时整合在TAXAREA）
    ,o.taxarea3 -- 纳税居民国家（地区）3（发送报文时整合在TAXAREA）
    ,o.taxnumber2 -- 纳税人识别号2（发送报文时整合在TAXNUMBER）
    ,o.taxnumber3 -- 纳税人识别号3（发送报文时整合在TAXNUMBER）
    ,o.taxnullreason -- 纳税人识别号为空原因
    ,o.taxstatement -- 是否取得自证声明（0-未取得自证声明1-取得自证声明）
    ,o.customersurname -- 客户_姓（字母）
    ,o.customergivenname -- 客户_名（字母）
    ,o.taxnullreason2 -- 纳税人识别号为空原因2
    ,o.taxnullreason3 -- 纳税人识别号为空原因3
    ,o.boundaccno -- 绑定账号
    ,o.boundbank -- 绑定账号开户行
    ,o.checkcase -- 落地审核原因
    ,o.ocridtdt -- 证件生效日期
    ,o.yflag -- 手机盾标志 Y:为是手机盾，N:为不是手机盾
    ,o.phoneoperate -- 手机盾操作类型0：开通
    ,o.camp_emp_id -- 营销工号
    ,o.notemessagephone1 -- 短信通签约号码1
    ,o.notemessagephone2 -- 短信通签约号码2
    ,o.notemessagephone3 -- 短信通签约号码3
    ,o.notemessagephone4 -- 短信通签约号码4
    ,o.notemessagephone5 -- 短信通签约号码5
    ,o.isagtsch -- 是否个人扣款协议签约(0-否,1-是)
    ,o.proxy_idtdt_sl -- 是否云闪付绑定签约
    ,o.is_flashpay_contract -- 云闪付绑定签约是否成功  0-失败 1-成功
    ,o.flashpay_contract_if_succeed -- 
    ,o.local_ip -- 开户IP
    ,o.local_mac -- 开户MAC
    ,o.uuid -- UUID
    ,o.ukey_modify_if_succeed -- U盾管理状态
    ,o.is_send_message -- 是否发送营销短信
    ,o.phonepay_contract_if_succeed -- 手机转账签约是否成功(0-失败 1-成功)
    ,o.is_phonepay_contract -- 是否手机转账签约(0-否 1-是)
    ,o.regedittype -- 登记注册类型
    ,o.sco -- 
    ,o.is_phonepay_contract1 -- 是否手机转账签约(0-否 1-是)
    ,o.phonepay_contract_if_succeed1 -- 手机转账签约是否成功(0-失败 1-成功)
    ,o.regedittype1 -- 登记注册类型
    ,o.limit_oper_type -- 非柜面签约
    ,o.limit_oper_channel -- 
    ,o.day_transfer_count -- 非柜面签约-日总笔数
    ,o.day_transfer_amount -- 非柜面签约-日总限额
    ,o.year_transfer_count -- 非柜面签约-年总笔数
    ,o.year_transfer_amount -- 非柜面签约-年总限额
    ,o.limit_oper_result -- 
    ,o.tally_state -- 记账状态 0 未记账 1 记账成功 2 记账失败
    ,o.agt_num -- 协议号
    ,o.dspbgndt -- 转存起始日期
    ,o.dspenddt -- 转存截止日期
    ,o.dsptyper -- 转存类型 1 转存双整 2 转存通知
    ,o.invest_account -- 储蓄定投签约账户
    ,o.invest_trnamt -- 转存金额
    ,o.prd_id -- 产品编号
    ,o.quickin_agreement_id -- 灵活盈协议编号
    ,o.quickin_agreement_status -- 灵活盈协议状态
    ,o.quickin_agreement_type -- 灵活盈协议类型
    ,o.quickin_fin_fixed_amt -- 灵活盈理财固定金额
    ,o.quickin_int_min_amt -- 灵活盈最小起存金额
    ,o.quickin_remain_amt -- 灵活盈协议留存金额
    ,o.quickin_start_amt -- 灵活盈起始金额
    ,o.quickin_transfer_day -- 划转日
    ,o.quickin_transfer_freq -- 灵活盈划转频率
    ,o.redep_freq -- 转存频率
    ,o.renew_corp -- 转存单位
    ,o.rpdsp -- 转存周期 Y-年 Q-季 M-月 W-周 D-天
    ,o.sub_acct_num -- 子账号
    ,o.sum_sub_num -- 汇总子户号
    ,o.biz_type -- 业务种类
    ,o.biz_dt -- 交易日期（yyyy-MM-dd hh:mm:ss）
    ,o.finance_card_type -- 理财账户类型
    ,o.fin_new_acct_crspd_pty_id -- 新账号对应客户号
    ,o.custchnlid -- 开通渠道
    ,o.riskmonths -- 风险有效期月数
    ,o.rskcd -- 风险等级代码
    ,o.oper_flag -- 1 客户级 2账户级
    ,o.third_chg_card_id -- 三方存管换卡标识
    ,o.third_open_org_id -- 三方存管开户机构
    ,o.usb_key_cert_id -- USBKey证书编号
    ,o.old_cert_key_id -- 旧证书KEYID
    ,o.safe_instr_model -- 安全工具型号(0：飞天1：捷德)
    ,o.u_brch_num -- U盾网点号
    ,o.u_oper_typ -- U盾操作类型（2：注销 3：损坏更换 4：挂失更换 5：发放）
    ,o.wthr_out -- 是否出库 默认Y Y：是 N：否
    ,o.lost_operate_method -- 挂失操作方式，比如书面挂失、口头挂失UV-口头解挂 UW-正式解挂 VL-口挂 WL-书挂
    ,o.lost_no -- 账户/凭证/结算卡挂失号码
    ,o.acct_name -- 账户名称
    ,o.loss_id -- 挂失编号
    ,o.acct_seq_no -- 账户序列号
    ,o.acct_password -- 账户密码
    ,o.voucher_change_type -- 凭证更换类型，比如挂失补发、损坏更换等，不同的更换类型会对应不同的处理流程 01-挂失补发 02-凭证更换 03-损坏更换 04-同号换卡领卡/记名卡领卡 05-单位存单置换 06-单位存单收回如果补开、凭证更换必传
    ,o.new_vchr_typ -- 新凭证类型
    ,o.new_vchr_num -- 新凭证号码
    ,o.voucher_change_reason -- 更换原因
    ,o.td_inout_operate_type -- 存单移入必传 定期账户转入转出操作类型 01-转入 02-互转 03-转出
    ,o.in_base_acct_no -- 移入账号
    ,o.in_prod_type -- 转入账户产品类型
    ,o.enter_acct_ccy -- 转入账户币种
    ,o.target_acct_class -- 目标账户类别（一二三类户），即账户升级后的账户类别，满足人行对于电子账户的管理办法1-一类账户 2-二类账户 3-三类账户
    ,o.password_operate_type -- 账户密码操作类型 账户密码操作类型01-新建 02-重置 03-修改 04-解锁 05-校验 06-激活 07-凭证解挂场景密码重置 08-弱密码校验
    ,o.password_type -- 密码类型，目前核心只支持WD，接口未上送则默认为WDWD-支取密码 QY-查询密码 MA-账户管理密码
    ,o.password_old -- 旧密码
    ,o.iss_country -- 发证国家
    ,o.password_effect_date -- 密码生效日期
    ,o.lost_reason -- 挂失原因
    ,o.res_flag -- 标识挂失账户是N进行账户止付,挂失时必输，解挂时不需要输入Y-是 N-不是
    ,o.pause_post -- 暂停附言
    ,o.channel -- 渠道
    ,o.ntw_ceph_bank_pause_type -- 网银手机银行管理 业务类型 01：个人动态密码管理 02：解锁登录密码 03：网银/手机银行暂停/恢复 04：登录密码和用户状态重置 05：客户手机盾信息维护 06：账户暂停/恢复
    ,o.ntw_ceph_bank_pause_pwd_status -- 网银手机银行管理 密码状态：0:正常 7：重置网银密码 8：重置交易密码 9 : 柜面开户重置密码
    ,o.tfr_encry_ind -- 转加密标识  1:数字加字母组合 0:纯数字(柜面调用)
    ,o.cfm_new_logon_pwd -- 确认新登录密码
    ,o.pwd_keyb_node_id -- 密码键盘节点ID
    ,o.safe_ceph_num -- 安全手机号
    ,o.dynamic_password_status -- 个人动态密码状态 ： 0---开 1---关
    ,o.pause_status -- 网银/手机银行暂停/恢复 状态 0-正常 1-永久停止 2-临时暂停
    ,o.dynamic_password_ind_id -- 个人动态密码标识编号 1：查询 2：新增 3：修改 4: 删除
    ,o.clous_shield_ind_id -- 华兴云盾标识编号 1：设置密码 0：重置密码
    ,o.deft_safe_instr -- 默认安全工具 1：华兴U盾 2：手机短信密码
    ,o.indv_act_status -- 个人账户状态
    ,o.acct_pause_rsns -- 账户暂停原因
    ,o.ntw_ceph_bank_pause_resu_status -- 网银/手机银行暂停/恢复状态 0-正常 1-永久停止 2-临时暂停
    ,o.pause_with_resu_oper_typ -- 暂停/恢复操作类型 0-网银 1-手机银行 2-网银手机银行
    ,o.temp_pause_start_tm -- 临时暂停开始时间，格式为yyyyMMddHHmmss
    ,o.temp_pause_cncl_tm -- 临时暂停结束时间，格式为yyyyMMddHHmmss
    ,o.ceph_cs_oper_typ -- 手机盾信息操作类型 开通：0 停用：1 启用：2 注销：4
    ,o.cs_ord_nbr -- 云盾序号
    ,o.open_br_node_num -- 开通网点号
    ,o.key_name -- 密钥名称
    ,o.total_cnt -- 网银签约总笔数
    ,o.reg_typ -- 手机号码支付协议注册类型 DFLT 默认账户 NDFT 非默认账户
    ,o.narrative1 -- 备注
    ,o.prest_flg -- 赠送标志 0-正常开通 1-赠送开通
    ,o.prest_mon -- 赠送月份 如果是赠送服务（赠送标志为1），则填入赠送的月份数。没有此信息填空或“00”
    ,o.vip_flg -- VIP标志 0-非VIP服务， 1-VIP服务，（默认填0，如果操作员选择了VIP服务标志，则填1），VIP针对客户而言。
    ,o.chrg_pkg_typ -- 收费套餐类型 01包月/ 12包年。
    ,o.chrg_mode -- 收费模式 1-按账户数收费 2-按服务数收费 3-按短信条数收费 4-按定额收费
    ,o.chrg_amt -- 收费金额 请按字符串格式传输，如”RATE”:”0.56987” 当收费模式为定额收费时填写
    ,o.disct -- 折扣 客户收费折扣
    ,o.disct_mon -- 折扣月份 当存在折扣时，填写折扣有效月份，没有此信息则填空或00
    ,o.acct_purp -- 账户用途
    ,o.acct_attr -- 账户属性
    ,o.agtsch_prd_id -- 个人扣款协议-产品编号
    ,o.agtsch_prd_type -- 个人扣款协议  C-签约U-维护D-解约
    ,o.payer_acct -- 付款人账号
    ,o.payer_acct_typ -- 付款人账户类型
    ,o.payer_act_nm -- 付款人账户户名
    ,o.payer_cert_typ -- 付款人证件类型
    ,o.payer_cert_num -- 付款人证件号
    ,o.payer_ceph_num -- 付款人手机号
    ,o.payer_bank -- 付款人开户行行号
    ,o.rcver_acct_typ -- 收款人账户类型
    ,o.payee_base_acct_no -- 收款人账号
    ,o.rcver_act_nm -- 收款人账户户名
    ,o.chn_num -- 渠道号
    ,o.sign_dtl -- 签约明细
    ,o.dsp_trnamt -- 转存周期 Y    年 Q    季 M    月 W    周 D    天
    ,o.redep_start_dt -- 转存起始日期
    ,o.redep_end_dt -- 转存截止日期
    ,o.pause_flg -- 暂停标志 0 否 1 是
    ,o.node_num -- 节点号
    ,o.third_chg_sign_prd -- 签约产品 SV014银银合作代理第三方存管协议
    ,o.agt_typ -- 协议类型CLD-存立得 DC-大额存单 DLS-贷利省 HQB-活期宝 JDL-加多利 KDT-卡贷通 KYD-卡易贷 PCP-资金池 WDL-稳得利 XDB-协定宝 XDCK-协定存款产品 XDL-先得利 YBWL-一本万利 YCD-英才贷 YDT-易贷通 YHT-一户通 ZHY-周享赢 ZXY-坐享其盈 ZZB-至尊宝 LOA-贷款 ODF-法人透支协议 FIN-卡理财协议 SMS-短信 PKG-费用套餐 FEE-暂不收费 PCD-周期性强制扣划 ACC-协定存款协议 SWP-账户清扫协议 ID-智能存款协议 SL-金额补足协议 REC-回单签约 ES-电票签约 YD-约定 NTE-活期智能存款 PAS-隐私账户签约 TXY1-同兴赢活期签约 TXY2-跨境资金融入签约 CXDT-储蓄定投 TBCK-跳板存款 LHY-灵活盈 P2P-P2P协议 JZG-建筑港 ZCG-资产存管 ZQS-资金清算 LYE-财政零余额
    ,o.agt_id -- 协议编号
    ,o.agt_status_cd -- 协议状态 普通协议使用，可应用于大部分场景，贷款模块用于资产证券化合同状态A-生效 E-失效 YB-赎回 YS-发行 YP-已封包 NP-未封包 NS-未发行 YC-已撤包
    ,o.st_dt -- 开始日期
    ,o.end_dt_ora -- 结束日期
    ,o.sign_prod_type -- 签约产品类型
    ,o.remain_amt -- 协议留存金额 请按字符串格式传输，如”RATE”:”0.56987” 协议留存金额
    ,o.start_amt -- 起始金额 请按字符串格式传输，如”RATE”:”0.56987” 起始金额
    ,o.transfer_freq_type -- 划转频率类型 Y-年 Q-季 M-月 W-周 D-日
    ,o.acct_movt_date -- 转存交易日期
    ,o.peri -- 存期
    ,o.term_type -- 期限单位 Y-年 Q-季 M-月 W-周 D-日
    ,o.acct_exec -- 银行客户经理
    ,o.transfer_end_date -- 转存结束日期
    ,o.transfer_day -- 划转日
    ,o.transfer_freq -- 划转频率
    ,o.fin_fixed_amt -- 理财固定金额 请按字符串格式传输，如”RATE”:”0.56987”
    ,o.min_depo_amt -- 最小起存金额 请按字符串格式传输，如”RATE”:”0.56987” 最小起存金额
    ,o.opt_type -- 资管信托代销协议操作类型 01签约 02解约 03维护
    ,o.matn_oper_typ -- 维护操作类型 0-客户信息维护 1-客户经理代码维护
    ,o.actl_benef -- 实际受益人 0-本人（默认） 1-他人
    ,o.wthr_exist_actl_ctrl_rela -- 是否存在实际控制关系 0-否（默认） 1-是
    ,o.wthr_is_np_integrity_rec -- 是否有不良诚信记录 0-否（默认） 1-是
    ,o.ori_pty_mgr_cd -- 原客户经理代码
    ,o.new_pty_mgr_cd -- 新客户经理代码
    ,o.pty_mgr_adj_flg -- 客户经理调整标志 0－全部（将原客户经理替换成新客经理） 1－调整客户所属客户经理代码 2－理财账号客户经理代码 3－按流水客户经理 4－调整定投客户经理代码 5－调整定赎客户经理代码 8－调整客户对应所有客户经理
    ,o.spec_seq_num -- 指定流水号
    ,o.enro_ceph_num -- 注册手机号
    ,o.acct_typ -- 账户类型 01 - 为Ⅰ类户（非信用卡） 02 - 为Ⅱ类户 03 - 为Ⅲ类户 04-准贷记卡 05-借贷合一卡 不填-信用卡
    ,o.zone_num -- 地区码 建议需求方至少定位到省市、直辖市级地区区位。默认为0000，长度为4 位
    ,o.scene_num -- 云闪付场景码
    ,o.card_prd_id -- 卡产品编号
    ,o.txn_equip_info -- 交易设备信息
    ,o.put_new_fld -- 拉新字段
    ,o.cvn_num -- CVN码
    ,o.valid_dt -- 有效期
    ,o.bcs_res_ceph_num_flg -- 核心预留手机号标志 1代表是核心预留手机号 0代表非核心预留手机号
    ,o.short_lett_srv_type -- 短信服务类 短信服务类，以逗号分隔（A,B）
    ,o.ceph_num_app_scope -- 手机号码应用范围 1-只修改该账号下对应的手机号码 2-修改客户所有账号对应的手机号码，填1时必须填写签约账号
    ,o.old_ceph_num -- 旧手机号码
    ,o.new_ceph_num -- 新手机号码
    ,o.ceph_num_qty -- 手机号码个数
    ,o.direct_sign_matn_flg -- 定向转账签约维护标志 0-解约, 1-更新, 2-签约
    ,o.direct_sign_typ -- 定向转账签约类型 0-综合柜面, 1-流程银行
    ,o.ghb_out_ind -- 行内外标识 0-行内 1-行外
    ,o.bank_id -- 银行编号
    ,o.bank_name -- 银行名称
    ,o.provin_cd -- 省份代码
    ,o.city_cd -- 城市代码
    ,o.rcv_open_brch_id -- 收款方开户网点编号
    ,o.rcv_open_brch_name -- 收款方开户网点名称
    ,o.rcver_ceph_num -- 收款人手机号码
    ,o.recv_acct_upda_flg -- 收款账户更新标志 收款账户更新标志0：删除 1：更新,2：增加（SIGNUPDATEFLAG=0时，系统默认0，SIGNUPDATEFLAG=2时，系统默认为2）
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.scps_bp_personal_tb_bk o
    left join ${iol_schema}.scps_bp_personal_tb_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_personal_tb_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_personal_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_personal_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_personal_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_personal_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_personal_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_personal_tb_cl;
alter table ${iol_schema}.scps_bp_personal_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_personal_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_personal_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_personal_tb_op purge;
drop table ${iol_schema}.scps_bp_personal_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_personal_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_personal_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
