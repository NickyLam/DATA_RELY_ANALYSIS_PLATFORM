/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t2a_trans
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
drop table ${iol_schema}.amls_t2a_trans_ex purge;
alter table ${iol_schema}.amls_t2a_trans add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.amls_t2a_trans truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.amls_t2a_trans_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t2a_trans where 0=1;

insert /*+ append */ into ${iol_schema}.amls_t2a_trans_ex(
    tr_id -- 业务标识号
    ,tr_dt -- 交易时间
    ,tr_tm -- 交易日期和时间
    ,tr_no -- 交易流水号
    ,rcv_pay_type -- 收付款方匹配号类型AML0333
    ,rcv_pay_no -- 收付款方匹配号
    ,tr_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type -- 客户类型（参见[字典:AML0030]）
    ,acct_id -- 账号
    ,card_no -- 卡号/折号
    ,card_style -- 卡片类型（参见[字典:AML0031]）
    ,oth_card_style -- 其他卡片类型
    ,subject_id -- 科目编号
    ,prd_id -- 产品编号
    ,tr_chnl -- AML交易渠道（参见[字典:AML0032]）
    ,s_tr_chnl -- 源系统交易渠道
    ,tr_cd -- AML交易代码
    ,s_tr_cd -- 源系统交易代码
    ,biz_type -- PBC业务类型（参见[字典:AML0033]）
    ,is_cash -- 现转标志（参见[字典:AML0034]）
    ,pay_type -- 支付工具及结算方式
    ,debit_credit -- 借贷标志（参见[字典:AML0035]）
    ,rcv_pay -- 收付标志（参见[字典:AML0036]）
    ,curr_cd -- 币种
    ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
    ,tr_amt -- 原币种交易金额
    ,tr_cny_amt -- 折人民币交易金额
    ,tr_usd_amt -- 折美元交易金额
    ,tr_bal_amt -- 交易余额
    ,tr_country -- 交易发生国家
    ,tr_area -- 交易发生地区
    ,fund_use -- 资金用途和来源
    ,agent_name -- 代办人姓名
    ,agent_nat -- 代办人国籍
    ,agent_cert_type -- 代办人证件种类（参见[字典:AML0051]）
    ,oth_agent_cert_type -- 代办人其他证件种类
    ,agent_cert_no -- 代办人证件号码
    ,opp_name -- 对方名称
    ,opp_acct_id -- 对方账号
    ,opp_acct_type -- 对手PBC账户类型
    ,opp_is_cust -- 对方是否我行客户（参见[字典:T00002]）
    ,opp_cust_id -- 对方客户编号
    ,opp_cust_type -- 对方客户类型（参见[字典:AML0030]）
    ,opp_off_shore -- 对方是否离岸账户（参见[字典:T00002]）
    ,opp_card_no -- 对方卡号/折号
    ,opp_card_style -- 对方卡片类型（参见[字典:AML0031]）
    ,oth_opp_card_style -- 对方卡片其它类型
    ,opp_cert_type -- 对方证件类型（参见[字典:AML0051]）
    ,oth_opp_cert_type -- 对方其他身份证件/证明文件类型编码
    ,opp_cert_no -- 对方证件号码
    ,opp_org_id -- 对方金融机构编号
    ,opp_org_name -- 对方金融机构名称
    ,opp_org_type -- 对方金融机构类型 T1P_OTHER  CFCT
    ,opp_org_country -- 对方金融机构网点国家
    ,opp_org_area -- 对方金融机构网点地区
    ,tr_go_country -- 交易去向国家
    ,tr_go_area -- 交易去向地区
    ,is_cross -- 是否跨境（参见[字典:T00002]）
    ,opr_id -- 交易操作员
    ,re_opr_id -- 交易复核员
    ,rev_cd -- 冲正标志（参见[字典:AML0037]）
    ,pbc_rltp -- 金融机构与客户的关系t1p_other  RLTP
    ,pbc_tsct -- 涉外收支交易代码  t1p_tsct
    ,sys_id -- 发起系统编码
    ,ip -- IP地址
    ,tr_ipv6 -- 交易IPv6地址
    ,tr_mac -- 交易MAC地址
    ,tr_note1 -- 交易信息备注1
    ,tr_note2 -- 交易信息备注2
    ,bank_pay_cd -- 银行与支付机构之间的业务交易编码
    ,eqpt_cd -- 非柜台交易介质的设备代码
    ,merch_id -- 收单商户编码
    ,merch_type -- 收单商户类型
    ,is_3rd_pay -- 是否第三方支付（参见[字典:T00002]）
    ,tr_crt_type -- 交易创建方式（参见[字典:AML0038]）
    ,bh_exec -- 参与大额计算（参见[字典:T00002]）
    ,bs_exec -- 参与可疑计算（参见[字典:AML0039]）
    ,clct_sts -- 筛查前补录状态（参见[字典:AML0040]）
    ,bh_valid -- 大额验证（参见[字典:AML0041]）
    ,bs_valid -- 可疑验证（参见[字典:AML0042]）
    ,due_dt -- 处理期限
    ,rsrv_01 -- 备用字段1
    ,rsrv_02 -- 备用字段2
    ,rsrv_03 -- 备用字段3
    ,rsrv_04 -- 备用字段4
    ,pbc_chnl -- PBC交易渠道（参见[字典:AML0032]）
    ,non_dept_type -- 非柜台交易方式 AML0332
    ,oth_non_dept_type -- 非柜台其他交易方式代码
    ,pbc_orgkey -- 金融机构网点代码
    ,main_acct_id -- 主账号
    ,agent_tel -- 代理人联系方式
    ,opp_acct_type1 -- 对手账户类型1(11：银行账户；12：支付账户等非银行账户)
    ,pos_owner -- 信用卡消费商户名称
    ,is_cadr_trans -- 是否有卡交易（11：有卡交易；12：无卡交易（网银交易）；13无卡交易（非网银交易））
    ,cert_no -- 客户证件号码
    ,cert_type -- 客户证件类型
    ,oth_cert_type -- 客户其它证件类型
    ,atm_bank_code -- ATM机具所属行行号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    tr_id -- 业务标识号
    ,tr_dt -- 交易时间
    ,tr_tm -- 交易日期和时间
    ,tr_no -- 交易流水号
    ,rcv_pay_type -- 收付款方匹配号类型AML0333
    ,rcv_pay_no -- 收付款方匹配号
    ,tr_org_id -- 交易机构编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cust_type -- 客户类型（参见[字典:AML0030]）
    ,acct_id -- 账号
    ,card_no -- 卡号/折号
    ,card_style -- 卡片类型（参见[字典:AML0031]）
    ,oth_card_style -- 其他卡片类型
    ,subject_id -- 科目编号
    ,prd_id -- 产品编号
    ,tr_chnl -- AML交易渠道（参见[字典:AML0032]）
    ,s_tr_chnl -- 源系统交易渠道
    ,tr_cd -- AML交易代码
    ,s_tr_cd -- 源系统交易代码
    ,biz_type -- PBC业务类型（参见[字典:AML0033]）
    ,is_cash -- 现转标志（参见[字典:AML0034]）
    ,pay_type -- 支付工具及结算方式
    ,debit_credit -- 借贷标志（参见[字典:AML0035]）
    ,rcv_pay -- 收付标志（参见[字典:AML0036]）
    ,curr_cd -- 币种
    ,is_local_curr -- 本外币标志（参见[字典:AML0015]）
    ,tr_amt -- 原币种交易金额
    ,tr_cny_amt -- 折人民币交易金额
    ,tr_usd_amt -- 折美元交易金额
    ,tr_bal_amt -- 交易余额
    ,tr_country -- 交易发生国家
    ,tr_area -- 交易发生地区
    ,fund_use -- 资金用途和来源
    ,agent_name -- 代办人姓名
    ,agent_nat -- 代办人国籍
    ,agent_cert_type -- 代办人证件种类（参见[字典:AML0051]）
    ,oth_agent_cert_type -- 代办人其他证件种类
    ,agent_cert_no -- 代办人证件号码
    ,opp_name -- 对方名称
    ,opp_acct_id -- 对方账号
    ,opp_acct_type -- 对手PBC账户类型
    ,opp_is_cust -- 对方是否我行客户（参见[字典:T00002]）
    ,opp_cust_id -- 对方客户编号
    ,opp_cust_type -- 对方客户类型（参见[字典:AML0030]）
    ,opp_off_shore -- 对方是否离岸账户（参见[字典:T00002]）
    ,opp_card_no -- 对方卡号/折号
    ,opp_card_style -- 对方卡片类型（参见[字典:AML0031]）
    ,oth_opp_card_style -- 对方卡片其它类型
    ,opp_cert_type -- 对方证件类型（参见[字典:AML0051]）
    ,oth_opp_cert_type -- 对方其他身份证件/证明文件类型编码
    ,opp_cert_no -- 对方证件号码
    ,opp_org_id -- 对方金融机构编号
    ,opp_org_name -- 对方金融机构名称
    ,opp_org_type -- 对方金融机构类型 T1P_OTHER  CFCT
    ,opp_org_country -- 对方金融机构网点国家
    ,opp_org_area -- 对方金融机构网点地区
    ,tr_go_country -- 交易去向国家
    ,tr_go_area -- 交易去向地区
    ,is_cross -- 是否跨境（参见[字典:T00002]）
    ,opr_id -- 交易操作员
    ,re_opr_id -- 交易复核员
    ,rev_cd -- 冲正标志（参见[字典:AML0037]）
    ,pbc_rltp -- 金融机构与客户的关系t1p_other  RLTP
    ,pbc_tsct -- 涉外收支交易代码  t1p_tsct
    ,sys_id -- 发起系统编码
    ,ip -- IP地址
    ,tr_ipv6 -- 交易IPv6地址
    ,tr_mac -- 交易MAC地址
    ,tr_note1 -- 交易信息备注1
    ,tr_note2 -- 交易信息备注2
    ,bank_pay_cd -- 银行与支付机构之间的业务交易编码
    ,eqpt_cd -- 非柜台交易介质的设备代码
    ,merch_id -- 收单商户编码
    ,merch_type -- 收单商户类型
    ,is_3rd_pay -- 是否第三方支付（参见[字典:T00002]）
    ,tr_crt_type -- 交易创建方式（参见[字典:AML0038]）
    ,bh_exec -- 参与大额计算（参见[字典:T00002]）
    ,bs_exec -- 参与可疑计算（参见[字典:AML0039]）
    ,clct_sts -- 筛查前补录状态（参见[字典:AML0040]）
    ,bh_valid -- 大额验证（参见[字典:AML0041]）
    ,bs_valid -- 可疑验证（参见[字典:AML0042]）
    ,due_dt -- 处理期限
    ,rsrv_01 -- 备用字段1
    ,rsrv_02 -- 备用字段2
    ,rsrv_03 -- 备用字段3
    ,rsrv_04 -- 备用字段4
    ,pbc_chnl -- PBC交易渠道（参见[字典:AML0032]）
    ,non_dept_type -- 非柜台交易方式 AML0332
    ,oth_non_dept_type -- 非柜台其他交易方式代码
    ,pbc_orgkey -- 金融机构网点代码
    ,main_acct_id -- 主账号
    ,agent_tel -- 代理人联系方式
    ,opp_acct_type1 -- 对手账户类型1(11：银行账户；12：支付账户等非银行账户)
    ,pos_owner -- 信用卡消费商户名称
    ,is_cadr_trans -- 是否有卡交易（11：有卡交易；12：无卡交易（网银交易）；13无卡交易（非网银交易））
    ,cert_no -- 客户证件号码
    ,cert_type -- 客户证件类型
    ,oth_cert_type -- 客户其它证件类型
    ,atm_bank_code -- ATM机具所属行行号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.amls_t2a_trans
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.amls_t2a_trans exchange partition p_${batch_date} with table ${iol_schema}.amls_t2a_trans_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t2a_trans to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.amls_t2a_trans_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t2a_trans',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);