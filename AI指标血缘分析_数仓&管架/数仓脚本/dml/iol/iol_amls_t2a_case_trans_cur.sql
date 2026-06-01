/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t2a_case_trans_cur
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
create table ${iol_schema}.amls_t2a_case_trans_cur_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t2a_case_trans_cur
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2a_case_trans_cur_op purge;
drop table ${iol_schema}.amls_t2a_case_trans_cur_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2a_case_trans_cur_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2a_case_trans_cur where 0=1;

create table ${iol_schema}.amls_t2a_case_trans_cur_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2a_case_trans_cur where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2a_case_trans_cur_cl(
            bh_valid -- 大额验证（参见[字典:AML0041]）
            ,non_dept_type -- 非柜台交易方式（参见[字典:AML0332]）
            ,oth_opp_cert_type -- 其他对手证件类型
            ,oth_non_dept_type -- 其他非柜台交易方式
            ,card_no -- 卡号/折号
            ,is_cross -- 是否跨境（参见[字典:T00002]）
            ,pbc_rltp -- 金融机构与客户的关系
            ,is_3rd_pay -- 是否第三方支付（参见[字典:T00002]）
            ,pay_type -- 支付工具及结算方式
            ,opp_name -- 对方名称
            ,opp_org_id -- 对方金融机构编号
            ,cert_type -- 客户证件类型
            ,oth_opp_card_style -- 其他对手银行卡类型
            ,rcv_pay_no -- 收付款方匹配号
            ,curr_cd -- 币种
            ,agent_cert_type -- 代办人证件种类（参见[字典:AML0051]）
            ,opp_acct_id -- 对方账号
            ,tr_go_country -- 交易去向国家
            ,clct_sts -- 筛查前补录状态（参见[字典:AML0040]）
            ,cert_no -- 客户证件号码
            ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
            ,opp_cert_type -- 对方证件类型（参见[字典:AML0051]）
            ,opp_cert_no -- 对方证件号码
            ,tr_mac -- 交易MAC地址
            ,tr_id -- 业务标识号
            ,tr_tm -- 交易日期和时间
            ,cust_name -- 客户名称
            ,s_tr_cd -- 源系统交易代码
            ,tr_country -- 交易发生国家
            ,fund_use -- 资金用途和来源
            ,agent_name -- 代办人姓名
            ,agent_cert_no -- 代办人证件号码
            ,opp_off_shore -- 对方是否离岸账户（参见[字典:T00002]）
            ,opp_card_style -- 对方卡片类型（参见[字典:AML0031]）
            ,oth_card_style -- 其他银行卡类型
            ,prd_id -- 产品编号
            ,rcv_pay -- 收付标志（参见[字典:AML0036]）
            ,tr_cny_amt -- 折人民币交易金额
            ,opp_card_no -- 对方卡号/折号
            ,rev_cd -- 冲正标志（参见[字典:AML0037]）
            ,opp_is_cust -- 对方是否我行客户（参见[字典:T00002]）
            ,opp_org_name -- 对方金融机构名称
            ,tr_crt_type -- 交易创建方式（参见[字典:AML0038]）
            ,rsrv_01 -- 备用字段1
            ,tr_no -- 交易流水号
            ,cust_id -- 客户编号
            ,tr_area -- 交易发生地区
            ,sys_id -- 发起系统编码
            ,eqpt_cd -- 非柜台交易介质的设备代码
            ,bs_exec -- 参与可疑计算（参见[字典:AML0039]）
            ,rsrv_03 -- 备用字段3
            ,is_cadr_trans -- 是否有卡交易（11：有卡交易；12：无卡交易（网银交易）；13无卡交易（非网银交易））
            ,atm_bank_code -- ATM机具所属行行号
            ,tr_dt -- 交易日期
            ,rcv_pay_type -- 收付款方匹配号类型（参见[字典:AML0333]）
            ,s_tr_chnl -- 源系统交易渠道
            ,tr_usd_amt -- 折美元交易金额
            ,agent_nat -- 代办人国籍
            ,opr_id -- 交易操作员
            ,tr_note2 -- 交易信息备注2
            ,agent_tel -- 代理人联系方式
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,tr_chnl -- AML交易渠道（参见[字典:AML0032]）
            ,opp_org_area -- 对方金融机构网点地区
            ,opp_acct_type1 -- 对手账户类型1(11：银行账户；12：支付账户等非银行账户)
            ,biz_type -- PBC业务类型（参见[字典:AML0033]）
            ,pos_owner -- 信用卡消费商户名称
            ,oth_agent_cert_type -- 其他代理人证件类型
            ,oth_cert_type -- 其他证件类型
            ,tr_org_id -- 交易机构编号
            ,acct_id -- 账号
            ,debit_credit -- 借贷标志（参见[字典:AML0035]）
            ,tr_bal_amt -- 交易余额
            ,opp_cust_type -- 对方客户类型（参见[字典:AML0030]）
            ,opp_org_type -- 对方金融机构类型
            ,merch_type -- 收单商户类型
            ,due_dt -- 处理期限
            ,rsrv_04 -- 备用字段4
            ,is_cash -- 现转标志（参见[字典:AML0034]）
            ,opp_org_country -- 对方金融机构网点国家
            ,bh_exec -- 参与大额计算（参见[字典:T00002]）
            ,bs_valid -- 可疑验证（参见[字典:AML0042]）
            ,rela_orgkey -- 金融机构网点代码,和PBC_RLTP 配套使用，PBC_RLTP为00 这个值写账户的开户机构，01，02 的写交易机构。
            ,main_acct_id -- 主账号
            ,tr_cd -- AML交易代码
            ,ip -- IP地址
            ,tr_ipv6 -- 交易IPv6地址
            ,bank_pay_cd -- 银行与支付机构之间的业务交易编码
            ,card_style -- 卡片类型（参见[字典:AML0031]）
            ,subject_id -- 科目编号
            ,opp_acct_type -- 对手PBC账户类型
            ,opp_cust_id -- 对方客户编号
            ,tr_go_area -- 交易去向地区
            ,re_opr_id -- 交易复核员
            ,tr_note1 -- 交易信息备注1
            ,rsrv_02 -- 备用字段2
            ,tr_amt -- 原币种交易金额
            ,pbc_tsct -- 涉外收支交易代码  t1p_tsct
            ,merch_id -- 收单商户编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2a_case_trans_cur_op(
            bh_valid -- 大额验证（参见[字典:AML0041]）
            ,non_dept_type -- 非柜台交易方式（参见[字典:AML0332]）
            ,oth_opp_cert_type -- 其他对手证件类型
            ,oth_non_dept_type -- 其他非柜台交易方式
            ,card_no -- 卡号/折号
            ,is_cross -- 是否跨境（参见[字典:T00002]）
            ,pbc_rltp -- 金融机构与客户的关系
            ,is_3rd_pay -- 是否第三方支付（参见[字典:T00002]）
            ,pay_type -- 支付工具及结算方式
            ,opp_name -- 对方名称
            ,opp_org_id -- 对方金融机构编号
            ,cert_type -- 客户证件类型
            ,oth_opp_card_style -- 其他对手银行卡类型
            ,rcv_pay_no -- 收付款方匹配号
            ,curr_cd -- 币种
            ,agent_cert_type -- 代办人证件种类（参见[字典:AML0051]）
            ,opp_acct_id -- 对方账号
            ,tr_go_country -- 交易去向国家
            ,clct_sts -- 筛查前补录状态（参见[字典:AML0040]）
            ,cert_no -- 客户证件号码
            ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
            ,opp_cert_type -- 对方证件类型（参见[字典:AML0051]）
            ,opp_cert_no -- 对方证件号码
            ,tr_mac -- 交易MAC地址
            ,tr_id -- 业务标识号
            ,tr_tm -- 交易日期和时间
            ,cust_name -- 客户名称
            ,s_tr_cd -- 源系统交易代码
            ,tr_country -- 交易发生国家
            ,fund_use -- 资金用途和来源
            ,agent_name -- 代办人姓名
            ,agent_cert_no -- 代办人证件号码
            ,opp_off_shore -- 对方是否离岸账户（参见[字典:T00002]）
            ,opp_card_style -- 对方卡片类型（参见[字典:AML0031]）
            ,oth_card_style -- 其他银行卡类型
            ,prd_id -- 产品编号
            ,rcv_pay -- 收付标志（参见[字典:AML0036]）
            ,tr_cny_amt -- 折人民币交易金额
            ,opp_card_no -- 对方卡号/折号
            ,rev_cd -- 冲正标志（参见[字典:AML0037]）
            ,opp_is_cust -- 对方是否我行客户（参见[字典:T00002]）
            ,opp_org_name -- 对方金融机构名称
            ,tr_crt_type -- 交易创建方式（参见[字典:AML0038]）
            ,rsrv_01 -- 备用字段1
            ,tr_no -- 交易流水号
            ,cust_id -- 客户编号
            ,tr_area -- 交易发生地区
            ,sys_id -- 发起系统编码
            ,eqpt_cd -- 非柜台交易介质的设备代码
            ,bs_exec -- 参与可疑计算（参见[字典:AML0039]）
            ,rsrv_03 -- 备用字段3
            ,is_cadr_trans -- 是否有卡交易（11：有卡交易；12：无卡交易（网银交易）；13无卡交易（非网银交易））
            ,atm_bank_code -- ATM机具所属行行号
            ,tr_dt -- 交易日期
            ,rcv_pay_type -- 收付款方匹配号类型（参见[字典:AML0333]）
            ,s_tr_chnl -- 源系统交易渠道
            ,tr_usd_amt -- 折美元交易金额
            ,agent_nat -- 代办人国籍
            ,opr_id -- 交易操作员
            ,tr_note2 -- 交易信息备注2
            ,agent_tel -- 代理人联系方式
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,tr_chnl -- AML交易渠道（参见[字典:AML0032]）
            ,opp_org_area -- 对方金融机构网点地区
            ,opp_acct_type1 -- 对手账户类型1(11：银行账户；12：支付账户等非银行账户)
            ,biz_type -- PBC业务类型（参见[字典:AML0033]）
            ,pos_owner -- 信用卡消费商户名称
            ,oth_agent_cert_type -- 其他代理人证件类型
            ,oth_cert_type -- 其他证件类型
            ,tr_org_id -- 交易机构编号
            ,acct_id -- 账号
            ,debit_credit -- 借贷标志（参见[字典:AML0035]）
            ,tr_bal_amt -- 交易余额
            ,opp_cust_type -- 对方客户类型（参见[字典:AML0030]）
            ,opp_org_type -- 对方金融机构类型
            ,merch_type -- 收单商户类型
            ,due_dt -- 处理期限
            ,rsrv_04 -- 备用字段4
            ,is_cash -- 现转标志（参见[字典:AML0034]）
            ,opp_org_country -- 对方金融机构网点国家
            ,bh_exec -- 参与大额计算（参见[字典:T00002]）
            ,bs_valid -- 可疑验证（参见[字典:AML0042]）
            ,rela_orgkey -- 金融机构网点代码,和PBC_RLTP 配套使用，PBC_RLTP为00 这个值写账户的开户机构，01，02 的写交易机构。
            ,main_acct_id -- 主账号
            ,tr_cd -- AML交易代码
            ,ip -- IP地址
            ,tr_ipv6 -- 交易IPv6地址
            ,bank_pay_cd -- 银行与支付机构之间的业务交易编码
            ,card_style -- 卡片类型（参见[字典:AML0031]）
            ,subject_id -- 科目编号
            ,opp_acct_type -- 对手PBC账户类型
            ,opp_cust_id -- 对方客户编号
            ,tr_go_area -- 交易去向地区
            ,re_opr_id -- 交易复核员
            ,tr_note1 -- 交易信息备注1
            ,rsrv_02 -- 备用字段2
            ,tr_amt -- 原币种交易金额
            ,pbc_tsct -- 涉外收支交易代码  t1p_tsct
            ,merch_id -- 收单商户编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bh_valid, o.bh_valid) as bh_valid -- 大额验证（参见[字典:AML0041]）
    ,nvl(n.non_dept_type, o.non_dept_type) as non_dept_type -- 非柜台交易方式（参见[字典:AML0332]）
    ,nvl(n.oth_opp_cert_type, o.oth_opp_cert_type) as oth_opp_cert_type -- 其他对手证件类型
    ,nvl(n.oth_non_dept_type, o.oth_non_dept_type) as oth_non_dept_type -- 其他非柜台交易方式
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号/折号
    ,nvl(n.is_cross, o.is_cross) as is_cross -- 是否跨境（参见[字典:T00002]）
    ,nvl(n.pbc_rltp, o.pbc_rltp) as pbc_rltp -- 金融机构与客户的关系
    ,nvl(n.is_3rd_pay, o.is_3rd_pay) as is_3rd_pay -- 是否第三方支付（参见[字典:T00002]）
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 支付工具及结算方式
    ,nvl(n.opp_name, o.opp_name) as opp_name -- 对方名称
    ,nvl(n.opp_org_id, o.opp_org_id) as opp_org_id -- 对方金融机构编号
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 客户证件类型
    ,nvl(n.oth_opp_card_style, o.oth_opp_card_style) as oth_opp_card_style -- 其他对手银行卡类型
    ,nvl(n.rcv_pay_no, o.rcv_pay_no) as rcv_pay_no -- 收付款方匹配号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种
    ,nvl(n.agent_cert_type, o.agent_cert_type) as agent_cert_type -- 代办人证件种类（参见[字典:AML0051]）
    ,nvl(n.opp_acct_id, o.opp_acct_id) as opp_acct_id -- 对方账号
    ,nvl(n.tr_go_country, o.tr_go_country) as tr_go_country -- 交易去向国家
    ,nvl(n.clct_sts, o.clct_sts) as clct_sts -- 筛查前补录状态（参见[字典:AML0040]）
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 客户证件号码
    ,nvl(n.is_local_curr, o.is_local_curr) as is_local_curr -- 本外币标志（参见[字典:AML0015]）
    ,nvl(n.opp_cert_type, o.opp_cert_type) as opp_cert_type -- 对方证件类型（参见[字典:AML0051]）
    ,nvl(n.opp_cert_no, o.opp_cert_no) as opp_cert_no -- 对方证件号码
    ,nvl(n.tr_mac, o.tr_mac) as tr_mac -- 交易MAC地址
    ,nvl(n.tr_id, o.tr_id) as tr_id -- 业务标识号
    ,nvl(n.tr_tm, o.tr_tm) as tr_tm -- 交易日期和时间
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.s_tr_cd, o.s_tr_cd) as s_tr_cd -- 源系统交易代码
    ,nvl(n.tr_country, o.tr_country) as tr_country -- 交易发生国家
    ,nvl(n.fund_use, o.fund_use) as fund_use -- 资金用途和来源
    ,nvl(n.agent_name, o.agent_name) as agent_name -- 代办人姓名
    ,nvl(n.agent_cert_no, o.agent_cert_no) as agent_cert_no -- 代办人证件号码
    ,nvl(n.opp_off_shore, o.opp_off_shore) as opp_off_shore -- 对方是否离岸账户（参见[字典:T00002]）
    ,nvl(n.opp_card_style, o.opp_card_style) as opp_card_style -- 对方卡片类型（参见[字典:AML0031]）
    ,nvl(n.oth_card_style, o.oth_card_style) as oth_card_style -- 其他银行卡类型
    ,nvl(n.prd_id, o.prd_id) as prd_id -- 产品编号
    ,nvl(n.rcv_pay, o.rcv_pay) as rcv_pay -- 收付标志（参见[字典:AML0036]）
    ,nvl(n.tr_cny_amt, o.tr_cny_amt) as tr_cny_amt -- 折人民币交易金额
    ,nvl(n.opp_card_no, o.opp_card_no) as opp_card_no -- 对方卡号/折号
    ,nvl(n.rev_cd, o.rev_cd) as rev_cd -- 冲正标志（参见[字典:AML0037]）
    ,nvl(n.opp_is_cust, o.opp_is_cust) as opp_is_cust -- 对方是否我行客户（参见[字典:T00002]）
    ,nvl(n.opp_org_name, o.opp_org_name) as opp_org_name -- 对方金融机构名称
    ,nvl(n.tr_crt_type, o.tr_crt_type) as tr_crt_type -- 交易创建方式（参见[字典:AML0038]）
    ,nvl(n.rsrv_01, o.rsrv_01) as rsrv_01 -- 备用字段1
    ,nvl(n.tr_no, o.tr_no) as tr_no -- 交易流水号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.tr_area, o.tr_area) as tr_area -- 交易发生地区
    ,nvl(n.sys_id, o.sys_id) as sys_id -- 发起系统编码
    ,nvl(n.eqpt_cd, o.eqpt_cd) as eqpt_cd -- 非柜台交易介质的设备代码
    ,nvl(n.bs_exec, o.bs_exec) as bs_exec -- 参与可疑计算（参见[字典:AML0039]）
    ,nvl(n.rsrv_03, o.rsrv_03) as rsrv_03 -- 备用字段3
    ,nvl(n.is_cadr_trans, o.is_cadr_trans) as is_cadr_trans -- 是否有卡交易（11：有卡交易；12：无卡交易（网银交易）；13无卡交易（非网银交易））
    ,nvl(n.atm_bank_code, o.atm_bank_code) as atm_bank_code -- ATM机具所属行行号
    ,nvl(n.tr_dt, o.tr_dt) as tr_dt -- 交易日期
    ,nvl(n.rcv_pay_type, o.rcv_pay_type) as rcv_pay_type -- 收付款方匹配号类型（参见[字典:AML0333]）
    ,nvl(n.s_tr_chnl, o.s_tr_chnl) as s_tr_chnl -- 源系统交易渠道
    ,nvl(n.tr_usd_amt, o.tr_usd_amt) as tr_usd_amt -- 折美元交易金额
    ,nvl(n.agent_nat, o.agent_nat) as agent_nat -- 代办人国籍
    ,nvl(n.opr_id, o.opr_id) as opr_id -- 交易操作员
    ,nvl(n.tr_note2, o.tr_note2) as tr_note2 -- 交易信息备注2
    ,nvl(n.agent_tel, o.agent_tel) as agent_tel -- 代理人联系方式
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 客户类型（参见[字典:AML0030]）
    ,nvl(n.tr_chnl, o.tr_chnl) as tr_chnl -- AML交易渠道（参见[字典:AML0032]）
    ,nvl(n.opp_org_area, o.opp_org_area) as opp_org_area -- 对方金融机构网点地区
    ,nvl(n.opp_acct_type1, o.opp_acct_type1) as opp_acct_type1 -- 对手账户类型1(11：银行账户；12：支付账户等非银行账户)
    ,nvl(n.biz_type, o.biz_type) as biz_type -- PBC业务类型（参见[字典:AML0033]）
    ,nvl(n.pos_owner, o.pos_owner) as pos_owner -- 信用卡消费商户名称
    ,nvl(n.oth_agent_cert_type, o.oth_agent_cert_type) as oth_agent_cert_type -- 其他代理人证件类型
    ,nvl(n.oth_cert_type, o.oth_cert_type) as oth_cert_type -- 其他证件类型
    ,nvl(n.tr_org_id, o.tr_org_id) as tr_org_id -- 交易机构编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账号
    ,nvl(n.debit_credit, o.debit_credit) as debit_credit -- 借贷标志（参见[字典:AML0035]）
    ,nvl(n.tr_bal_amt, o.tr_bal_amt) as tr_bal_amt -- 交易余额
    ,nvl(n.opp_cust_type, o.opp_cust_type) as opp_cust_type -- 对方客户类型（参见[字典:AML0030]）
    ,nvl(n.opp_org_type, o.opp_org_type) as opp_org_type -- 对方金融机构类型
    ,nvl(n.merch_type, o.merch_type) as merch_type -- 收单商户类型
    ,nvl(n.due_dt, o.due_dt) as due_dt -- 处理期限
    ,nvl(n.rsrv_04, o.rsrv_04) as rsrv_04 -- 备用字段4
    ,nvl(n.is_cash, o.is_cash) as is_cash -- 现转标志（参见[字典:AML0034]）
    ,nvl(n.opp_org_country, o.opp_org_country) as opp_org_country -- 对方金融机构网点国家
    ,nvl(n.bh_exec, o.bh_exec) as bh_exec -- 参与大额计算（参见[字典:T00002]）
    ,nvl(n.bs_valid, o.bs_valid) as bs_valid -- 可疑验证（参见[字典:AML0042]）
    ,nvl(n.rela_orgkey, o.rela_orgkey) as rela_orgkey -- 金融机构网点代码,和PBC_RLTP 配套使用，PBC_RLTP为00 这个值写账户的开户机构，01，02 的写交易机构。
    ,nvl(n.main_acct_id, o.main_acct_id) as main_acct_id -- 主账号
    ,nvl(n.tr_cd, o.tr_cd) as tr_cd -- AML交易代码
    ,nvl(n.ip, o.ip) as ip -- IP地址
    ,nvl(n.tr_ipv6, o.tr_ipv6) as tr_ipv6 -- 交易IPv6地址
    ,nvl(n.bank_pay_cd, o.bank_pay_cd) as bank_pay_cd -- 银行与支付机构之间的业务交易编码
    ,nvl(n.card_style, o.card_style) as card_style -- 卡片类型（参见[字典:AML0031]）
    ,nvl(n.subject_id, o.subject_id) as subject_id -- 科目编号
    ,nvl(n.opp_acct_type, o.opp_acct_type) as opp_acct_type -- 对手PBC账户类型
    ,nvl(n.opp_cust_id, o.opp_cust_id) as opp_cust_id -- 对方客户编号
    ,nvl(n.tr_go_area, o.tr_go_area) as tr_go_area -- 交易去向地区
    ,nvl(n.re_opr_id, o.re_opr_id) as re_opr_id -- 交易复核员
    ,nvl(n.tr_note1, o.tr_note1) as tr_note1 -- 交易信息备注1
    ,nvl(n.rsrv_02, o.rsrv_02) as rsrv_02 -- 备用字段2
    ,nvl(n.tr_amt, o.tr_amt) as tr_amt -- 原币种交易金额
    ,nvl(n.pbc_tsct, o.pbc_tsct) as pbc_tsct -- 涉外收支交易代码  t1p_tsct
    ,nvl(n.merch_id, o.merch_id) as merch_id -- 收单商户编码
    ,case when
            n.tr_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tr_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tr_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t2a_case_trans_cur_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t2a_case_trans_cur where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tr_id = n.tr_id
where (
        o.tr_id is null
    )
    or (
        n.tr_id is null
    )
    or (
        o.bh_valid <> n.bh_valid
        or o.non_dept_type <> n.non_dept_type
        or o.oth_opp_cert_type <> n.oth_opp_cert_type
        or o.oth_non_dept_type <> n.oth_non_dept_type
        or o.card_no <> n.card_no
        or o.is_cross <> n.is_cross
        or o.pbc_rltp <> n.pbc_rltp
        or o.is_3rd_pay <> n.is_3rd_pay
        or o.pay_type <> n.pay_type
        or o.opp_name <> n.opp_name
        or o.opp_org_id <> n.opp_org_id
        or o.cert_type <> n.cert_type
        or o.oth_opp_card_style <> n.oth_opp_card_style
        or o.rcv_pay_no <> n.rcv_pay_no
        or o.curr_cd <> n.curr_cd
        or o.agent_cert_type <> n.agent_cert_type
        or o.opp_acct_id <> n.opp_acct_id
        or o.tr_go_country <> n.tr_go_country
        or o.clct_sts <> n.clct_sts
        or o.cert_no <> n.cert_no
        or o.is_local_curr <> n.is_local_curr
        or o.opp_cert_type <> n.opp_cert_type
        or o.opp_cert_no <> n.opp_cert_no
        or o.tr_mac <> n.tr_mac
        or o.tr_tm <> n.tr_tm
        or o.cust_name <> n.cust_name
        or o.s_tr_cd <> n.s_tr_cd
        or o.tr_country <> n.tr_country
        or o.fund_use <> n.fund_use
        or o.agent_name <> n.agent_name
        or o.agent_cert_no <> n.agent_cert_no
        or o.opp_off_shore <> n.opp_off_shore
        or o.opp_card_style <> n.opp_card_style
        or o.oth_card_style <> n.oth_card_style
        or o.prd_id <> n.prd_id
        or o.rcv_pay <> n.rcv_pay
        or o.tr_cny_amt <> n.tr_cny_amt
        or o.opp_card_no <> n.opp_card_no
        or o.rev_cd <> n.rev_cd
        or o.opp_is_cust <> n.opp_is_cust
        or o.opp_org_name <> n.opp_org_name
        or o.tr_crt_type <> n.tr_crt_type
        or o.rsrv_01 <> n.rsrv_01
        or o.tr_no <> n.tr_no
        or o.cust_id <> n.cust_id
        or o.tr_area <> n.tr_area
        or o.sys_id <> n.sys_id
        or o.eqpt_cd <> n.eqpt_cd
        or o.bs_exec <> n.bs_exec
        or o.rsrv_03 <> n.rsrv_03
        or o.is_cadr_trans <> n.is_cadr_trans
        or o.atm_bank_code <> n.atm_bank_code
        or o.tr_dt <> n.tr_dt
        or o.rcv_pay_type <> n.rcv_pay_type
        or o.s_tr_chnl <> n.s_tr_chnl
        or o.tr_usd_amt <> n.tr_usd_amt
        or o.agent_nat <> n.agent_nat
        or o.opr_id <> n.opr_id
        or o.tr_note2 <> n.tr_note2
        or o.agent_tel <> n.agent_tel
        or o.cust_type <> n.cust_type
        or o.tr_chnl <> n.tr_chnl
        or o.opp_org_area <> n.opp_org_area
        or o.opp_acct_type1 <> n.opp_acct_type1
        or o.biz_type <> n.biz_type
        or o.pos_owner <> n.pos_owner
        or o.oth_agent_cert_type <> n.oth_agent_cert_type
        or o.oth_cert_type <> n.oth_cert_type
        or o.tr_org_id <> n.tr_org_id
        or o.acct_id <> n.acct_id
        or o.debit_credit <> n.debit_credit
        or o.tr_bal_amt <> n.tr_bal_amt
        or o.opp_cust_type <> n.opp_cust_type
        or o.opp_org_type <> n.opp_org_type
        or o.merch_type <> n.merch_type
        or o.due_dt <> n.due_dt
        or o.rsrv_04 <> n.rsrv_04
        or o.is_cash <> n.is_cash
        or o.opp_org_country <> n.opp_org_country
        or o.bh_exec <> n.bh_exec
        or o.bs_valid <> n.bs_valid
        or o.rela_orgkey <> n.rela_orgkey
        or o.main_acct_id <> n.main_acct_id
        or o.tr_cd <> n.tr_cd
        or o.ip <> n.ip
        or o.tr_ipv6 <> n.tr_ipv6
        or o.bank_pay_cd <> n.bank_pay_cd
        or o.card_style <> n.card_style
        or o.subject_id <> n.subject_id
        or o.opp_acct_type <> n.opp_acct_type
        or o.opp_cust_id <> n.opp_cust_id
        or o.tr_go_area <> n.tr_go_area
        or o.re_opr_id <> n.re_opr_id
        or o.tr_note1 <> n.tr_note1
        or o.rsrv_02 <> n.rsrv_02
        or o.tr_amt <> n.tr_amt
        or o.pbc_tsct <> n.pbc_tsct
        or o.merch_id <> n.merch_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t2a_case_trans_cur_cl(
            bh_valid -- 大额验证（参见[字典:AML0041]）
            ,non_dept_type -- 非柜台交易方式（参见[字典:AML0332]）
            ,oth_opp_cert_type -- 其他对手证件类型
            ,oth_non_dept_type -- 其他非柜台交易方式
            ,card_no -- 卡号/折号
            ,is_cross -- 是否跨境（参见[字典:T00002]）
            ,pbc_rltp -- 金融机构与客户的关系
            ,is_3rd_pay -- 是否第三方支付（参见[字典:T00002]）
            ,pay_type -- 支付工具及结算方式
            ,opp_name -- 对方名称
            ,opp_org_id -- 对方金融机构编号
            ,cert_type -- 客户证件类型
            ,oth_opp_card_style -- 其他对手银行卡类型
            ,rcv_pay_no -- 收付款方匹配号
            ,curr_cd -- 币种
            ,agent_cert_type -- 代办人证件种类（参见[字典:AML0051]）
            ,opp_acct_id -- 对方账号
            ,tr_go_country -- 交易去向国家
            ,clct_sts -- 筛查前补录状态（参见[字典:AML0040]）
            ,cert_no -- 客户证件号码
            ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
            ,opp_cert_type -- 对方证件类型（参见[字典:AML0051]）
            ,opp_cert_no -- 对方证件号码
            ,tr_mac -- 交易MAC地址
            ,tr_id -- 业务标识号
            ,tr_tm -- 交易日期和时间
            ,cust_name -- 客户名称
            ,s_tr_cd -- 源系统交易代码
            ,tr_country -- 交易发生国家
            ,fund_use -- 资金用途和来源
            ,agent_name -- 代办人姓名
            ,agent_cert_no -- 代办人证件号码
            ,opp_off_shore -- 对方是否离岸账户（参见[字典:T00002]）
            ,opp_card_style -- 对方卡片类型（参见[字典:AML0031]）
            ,oth_card_style -- 其他银行卡类型
            ,prd_id -- 产品编号
            ,rcv_pay -- 收付标志（参见[字典:AML0036]）
            ,tr_cny_amt -- 折人民币交易金额
            ,opp_card_no -- 对方卡号/折号
            ,rev_cd -- 冲正标志（参见[字典:AML0037]）
            ,opp_is_cust -- 对方是否我行客户（参见[字典:T00002]）
            ,opp_org_name -- 对方金融机构名称
            ,tr_crt_type -- 交易创建方式（参见[字典:AML0038]）
            ,rsrv_01 -- 备用字段1
            ,tr_no -- 交易流水号
            ,cust_id -- 客户编号
            ,tr_area -- 交易发生地区
            ,sys_id -- 发起系统编码
            ,eqpt_cd -- 非柜台交易介质的设备代码
            ,bs_exec -- 参与可疑计算（参见[字典:AML0039]）
            ,rsrv_03 -- 备用字段3
            ,is_cadr_trans -- 是否有卡交易（11：有卡交易；12：无卡交易（网银交易）；13无卡交易（非网银交易））
            ,atm_bank_code -- ATM机具所属行行号
            ,tr_dt -- 交易日期
            ,rcv_pay_type -- 收付款方匹配号类型（参见[字典:AML0333]）
            ,s_tr_chnl -- 源系统交易渠道
            ,tr_usd_amt -- 折美元交易金额
            ,agent_nat -- 代办人国籍
            ,opr_id -- 交易操作员
            ,tr_note2 -- 交易信息备注2
            ,agent_tel -- 代理人联系方式
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,tr_chnl -- AML交易渠道（参见[字典:AML0032]）
            ,opp_org_area -- 对方金融机构网点地区
            ,opp_acct_type1 -- 对手账户类型1(11：银行账户；12：支付账户等非银行账户)
            ,biz_type -- PBC业务类型（参见[字典:AML0033]）
            ,pos_owner -- 信用卡消费商户名称
            ,oth_agent_cert_type -- 其他代理人证件类型
            ,oth_cert_type -- 其他证件类型
            ,tr_org_id -- 交易机构编号
            ,acct_id -- 账号
            ,debit_credit -- 借贷标志（参见[字典:AML0035]）
            ,tr_bal_amt -- 交易余额
            ,opp_cust_type -- 对方客户类型（参见[字典:AML0030]）
            ,opp_org_type -- 对方金融机构类型
            ,merch_type -- 收单商户类型
            ,due_dt -- 处理期限
            ,rsrv_04 -- 备用字段4
            ,is_cash -- 现转标志（参见[字典:AML0034]）
            ,opp_org_country -- 对方金融机构网点国家
            ,bh_exec -- 参与大额计算（参见[字典:T00002]）
            ,bs_valid -- 可疑验证（参见[字典:AML0042]）
            ,rela_orgkey -- 金融机构网点代码,和PBC_RLTP 配套使用，PBC_RLTP为00 这个值写账户的开户机构，01，02 的写交易机构。
            ,main_acct_id -- 主账号
            ,tr_cd -- AML交易代码
            ,ip -- IP地址
            ,tr_ipv6 -- 交易IPv6地址
            ,bank_pay_cd -- 银行与支付机构之间的业务交易编码
            ,card_style -- 卡片类型（参见[字典:AML0031]）
            ,subject_id -- 科目编号
            ,opp_acct_type -- 对手PBC账户类型
            ,opp_cust_id -- 对方客户编号
            ,tr_go_area -- 交易去向地区
            ,re_opr_id -- 交易复核员
            ,tr_note1 -- 交易信息备注1
            ,rsrv_02 -- 备用字段2
            ,tr_amt -- 原币种交易金额
            ,pbc_tsct -- 涉外收支交易代码  t1p_tsct
            ,merch_id -- 收单商户编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t2a_case_trans_cur_op(
            bh_valid -- 大额验证（参见[字典:AML0041]）
            ,non_dept_type -- 非柜台交易方式（参见[字典:AML0332]）
            ,oth_opp_cert_type -- 其他对手证件类型
            ,oth_non_dept_type -- 其他非柜台交易方式
            ,card_no -- 卡号/折号
            ,is_cross -- 是否跨境（参见[字典:T00002]）
            ,pbc_rltp -- 金融机构与客户的关系
            ,is_3rd_pay -- 是否第三方支付（参见[字典:T00002]）
            ,pay_type -- 支付工具及结算方式
            ,opp_name -- 对方名称
            ,opp_org_id -- 对方金融机构编号
            ,cert_type -- 客户证件类型
            ,oth_opp_card_style -- 其他对手银行卡类型
            ,rcv_pay_no -- 收付款方匹配号
            ,curr_cd -- 币种
            ,agent_cert_type -- 代办人证件种类（参见[字典:AML0051]）
            ,opp_acct_id -- 对方账号
            ,tr_go_country -- 交易去向国家
            ,clct_sts -- 筛查前补录状态（参见[字典:AML0040]）
            ,cert_no -- 客户证件号码
            ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
            ,opp_cert_type -- 对方证件类型（参见[字典:AML0051]）
            ,opp_cert_no -- 对方证件号码
            ,tr_mac -- 交易MAC地址
            ,tr_id -- 业务标识号
            ,tr_tm -- 交易日期和时间
            ,cust_name -- 客户名称
            ,s_tr_cd -- 源系统交易代码
            ,tr_country -- 交易发生国家
            ,fund_use -- 资金用途和来源
            ,agent_name -- 代办人姓名
            ,agent_cert_no -- 代办人证件号码
            ,opp_off_shore -- 对方是否离岸账户（参见[字典:T00002]）
            ,opp_card_style -- 对方卡片类型（参见[字典:AML0031]）
            ,oth_card_style -- 其他银行卡类型
            ,prd_id -- 产品编号
            ,rcv_pay -- 收付标志（参见[字典:AML0036]）
            ,tr_cny_amt -- 折人民币交易金额
            ,opp_card_no -- 对方卡号/折号
            ,rev_cd -- 冲正标志（参见[字典:AML0037]）
            ,opp_is_cust -- 对方是否我行客户（参见[字典:T00002]）
            ,opp_org_name -- 对方金融机构名称
            ,tr_crt_type -- 交易创建方式（参见[字典:AML0038]）
            ,rsrv_01 -- 备用字段1
            ,tr_no -- 交易流水号
            ,cust_id -- 客户编号
            ,tr_area -- 交易发生地区
            ,sys_id -- 发起系统编码
            ,eqpt_cd -- 非柜台交易介质的设备代码
            ,bs_exec -- 参与可疑计算（参见[字典:AML0039]）
            ,rsrv_03 -- 备用字段3
            ,is_cadr_trans -- 是否有卡交易（11：有卡交易；12：无卡交易（网银交易）；13无卡交易（非网银交易））
            ,atm_bank_code -- ATM机具所属行行号
            ,tr_dt -- 交易日期
            ,rcv_pay_type -- 收付款方匹配号类型（参见[字典:AML0333]）
            ,s_tr_chnl -- 源系统交易渠道
            ,tr_usd_amt -- 折美元交易金额
            ,agent_nat -- 代办人国籍
            ,opr_id -- 交易操作员
            ,tr_note2 -- 交易信息备注2
            ,agent_tel -- 代理人联系方式
            ,cust_type -- 客户类型（参见[字典:AML0030]）
            ,tr_chnl -- AML交易渠道（参见[字典:AML0032]）
            ,opp_org_area -- 对方金融机构网点地区
            ,opp_acct_type1 -- 对手账户类型1(11：银行账户；12：支付账户等非银行账户)
            ,biz_type -- PBC业务类型（参见[字典:AML0033]）
            ,pos_owner -- 信用卡消费商户名称
            ,oth_agent_cert_type -- 其他代理人证件类型
            ,oth_cert_type -- 其他证件类型
            ,tr_org_id -- 交易机构编号
            ,acct_id -- 账号
            ,debit_credit -- 借贷标志（参见[字典:AML0035]）
            ,tr_bal_amt -- 交易余额
            ,opp_cust_type -- 对方客户类型（参见[字典:AML0030]）
            ,opp_org_type -- 对方金融机构类型
            ,merch_type -- 收单商户类型
            ,due_dt -- 处理期限
            ,rsrv_04 -- 备用字段4
            ,is_cash -- 现转标志（参见[字典:AML0034]）
            ,opp_org_country -- 对方金融机构网点国家
            ,bh_exec -- 参与大额计算（参见[字典:T00002]）
            ,bs_valid -- 可疑验证（参见[字典:AML0042]）
            ,rela_orgkey -- 金融机构网点代码,和PBC_RLTP 配套使用，PBC_RLTP为00 这个值写账户的开户机构，01，02 的写交易机构。
            ,main_acct_id -- 主账号
            ,tr_cd -- AML交易代码
            ,ip -- IP地址
            ,tr_ipv6 -- 交易IPv6地址
            ,bank_pay_cd -- 银行与支付机构之间的业务交易编码
            ,card_style -- 卡片类型（参见[字典:AML0031]）
            ,subject_id -- 科目编号
            ,opp_acct_type -- 对手PBC账户类型
            ,opp_cust_id -- 对方客户编号
            ,tr_go_area -- 交易去向地区
            ,re_opr_id -- 交易复核员
            ,tr_note1 -- 交易信息备注1
            ,rsrv_02 -- 备用字段2
            ,tr_amt -- 原币种交易金额
            ,pbc_tsct -- 涉外收支交易代码  t1p_tsct
            ,merch_id -- 收单商户编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bh_valid -- 大额验证（参见[字典:AML0041]）
    ,o.non_dept_type -- 非柜台交易方式（参见[字典:AML0332]）
    ,o.oth_opp_cert_type -- 其他对手证件类型
    ,o.oth_non_dept_type -- 其他非柜台交易方式
    ,o.card_no -- 卡号/折号
    ,o.is_cross -- 是否跨境（参见[字典:T00002]）
    ,o.pbc_rltp -- 金融机构与客户的关系
    ,o.is_3rd_pay -- 是否第三方支付（参见[字典:T00002]）
    ,o.pay_type -- 支付工具及结算方式
    ,o.opp_name -- 对方名称
    ,o.opp_org_id -- 对方金融机构编号
    ,o.cert_type -- 客户证件类型
    ,o.oth_opp_card_style -- 其他对手银行卡类型
    ,o.rcv_pay_no -- 收付款方匹配号
    ,o.curr_cd -- 币种
    ,o.agent_cert_type -- 代办人证件种类（参见[字典:AML0051]）
    ,o.opp_acct_id -- 对方账号
    ,o.tr_go_country -- 交易去向国家
    ,o.clct_sts -- 筛查前补录状态（参见[字典:AML0040]）
    ,o.cert_no -- 客户证件号码
    ,o.is_local_curr -- 本外币标志（参见[字典:AML0015]）
    ,o.opp_cert_type -- 对方证件类型（参见[字典:AML0051]）
    ,o.opp_cert_no -- 对方证件号码
    ,o.tr_mac -- 交易MAC地址
    ,o.tr_id -- 业务标识号
    ,o.tr_tm -- 交易日期和时间
    ,o.cust_name -- 客户名称
    ,o.s_tr_cd -- 源系统交易代码
    ,o.tr_country -- 交易发生国家
    ,o.fund_use -- 资金用途和来源
    ,o.agent_name -- 代办人姓名
    ,o.agent_cert_no -- 代办人证件号码
    ,o.opp_off_shore -- 对方是否离岸账户（参见[字典:T00002]）
    ,o.opp_card_style -- 对方卡片类型（参见[字典:AML0031]）
    ,o.oth_card_style -- 其他银行卡类型
    ,o.prd_id -- 产品编号
    ,o.rcv_pay -- 收付标志（参见[字典:AML0036]）
    ,o.tr_cny_amt -- 折人民币交易金额
    ,o.opp_card_no -- 对方卡号/折号
    ,o.rev_cd -- 冲正标志（参见[字典:AML0037]）
    ,o.opp_is_cust -- 对方是否我行客户（参见[字典:T00002]）
    ,o.opp_org_name -- 对方金融机构名称
    ,o.tr_crt_type -- 交易创建方式（参见[字典:AML0038]）
    ,o.rsrv_01 -- 备用字段1
    ,o.tr_no -- 交易流水号
    ,o.cust_id -- 客户编号
    ,o.tr_area -- 交易发生地区
    ,o.sys_id -- 发起系统编码
    ,o.eqpt_cd -- 非柜台交易介质的设备代码
    ,o.bs_exec -- 参与可疑计算（参见[字典:AML0039]）
    ,o.rsrv_03 -- 备用字段3
    ,o.is_cadr_trans -- 是否有卡交易（11：有卡交易；12：无卡交易（网银交易）；13无卡交易（非网银交易））
    ,o.atm_bank_code -- ATM机具所属行行号
    ,o.tr_dt -- 交易日期
    ,o.rcv_pay_type -- 收付款方匹配号类型（参见[字典:AML0333]）
    ,o.s_tr_chnl -- 源系统交易渠道
    ,o.tr_usd_amt -- 折美元交易金额
    ,o.agent_nat -- 代办人国籍
    ,o.opr_id -- 交易操作员
    ,o.tr_note2 -- 交易信息备注2
    ,o.agent_tel -- 代理人联系方式
    ,o.cust_type -- 客户类型（参见[字典:AML0030]）
    ,o.tr_chnl -- AML交易渠道（参见[字典:AML0032]）
    ,o.opp_org_area -- 对方金融机构网点地区
    ,o.opp_acct_type1 -- 对手账户类型1(11：银行账户；12：支付账户等非银行账户)
    ,o.biz_type -- PBC业务类型（参见[字典:AML0033]）
    ,o.pos_owner -- 信用卡消费商户名称
    ,o.oth_agent_cert_type -- 其他代理人证件类型
    ,o.oth_cert_type -- 其他证件类型
    ,o.tr_org_id -- 交易机构编号
    ,o.acct_id -- 账号
    ,o.debit_credit -- 借贷标志（参见[字典:AML0035]）
    ,o.tr_bal_amt -- 交易余额
    ,o.opp_cust_type -- 对方客户类型（参见[字典:AML0030]）
    ,o.opp_org_type -- 对方金融机构类型
    ,o.merch_type -- 收单商户类型
    ,o.due_dt -- 处理期限
    ,o.rsrv_04 -- 备用字段4
    ,o.is_cash -- 现转标志（参见[字典:AML0034]）
    ,o.opp_org_country -- 对方金融机构网点国家
    ,o.bh_exec -- 参与大额计算（参见[字典:T00002]）
    ,o.bs_valid -- 可疑验证（参见[字典:AML0042]）
    ,o.rela_orgkey -- 金融机构网点代码,和PBC_RLTP 配套使用，PBC_RLTP为00 这个值写账户的开户机构，01，02 的写交易机构。
    ,o.main_acct_id -- 主账号
    ,o.tr_cd -- AML交易代码
    ,o.ip -- IP地址
    ,o.tr_ipv6 -- 交易IPv6地址
    ,o.bank_pay_cd -- 银行与支付机构之间的业务交易编码
    ,o.card_style -- 卡片类型（参见[字典:AML0031]）
    ,o.subject_id -- 科目编号
    ,o.opp_acct_type -- 对手PBC账户类型
    ,o.opp_cust_id -- 对方客户编号
    ,o.tr_go_area -- 交易去向地区
    ,o.re_opr_id -- 交易复核员
    ,o.tr_note1 -- 交易信息备注1
    ,o.rsrv_02 -- 备用字段2
    ,o.tr_amt -- 原币种交易金额
    ,o.pbc_tsct -- 涉外收支交易代码  t1p_tsct
    ,o.merch_id -- 收单商户编码
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
from ${iol_schema}.amls_t2a_case_trans_cur_bk o
    left join ${iol_schema}.amls_t2a_case_trans_cur_op n
        on
            o.tr_id = n.tr_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t2a_case_trans_cur_cl d
        on
            o.tr_id = d.tr_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amls_t2a_case_trans_cur;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amls_t2a_case_trans_cur') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amls_t2a_case_trans_cur drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amls_t2a_case_trans_cur add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amls_t2a_case_trans_cur exchange partition p_${batch_date} with table ${iol_schema}.amls_t2a_case_trans_cur_cl;
alter table ${iol_schema}.amls_t2a_case_trans_cur exchange partition p_20991231 with table ${iol_schema}.amls_t2a_case_trans_cur_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t2a_case_trans_cur to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t2a_case_trans_cur_op purge;
drop table ${iol_schema}.amls_t2a_case_trans_cur_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t2a_case_trans_cur_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t2a_case_trans_cur',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
