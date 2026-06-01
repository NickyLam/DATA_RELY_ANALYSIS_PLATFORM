/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t2a_trans
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t2a_trans
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t2a_trans purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t2a_trans(
    tr_id varchar2(384) -- 业务标识号
    ,tr_dt date -- 交易时间
    ,tr_tm date -- 交易日期和时间
    ,tr_no varchar2(75) -- 交易流水号
    ,rcv_pay_type varchar2(3) -- 收付款方匹配号类型aml0333
    ,rcv_pay_no varchar2(750) -- 收付款方匹配号
    ,tr_org_id varchar2(24) -- 交易机构编号
    ,cust_id varchar2(48) -- 客户编号
    ,cust_name varchar2(768) -- 客户名称
    ,cust_type varchar2(2) -- 客户类型（参见[字典:aml0030]）
    ,acct_id varchar2(96) -- 账号
    ,card_no varchar2(96) -- 卡号/折号
    ,card_style varchar2(3) -- 卡片类型（参见[字典:aml0031]）
    ,oth_card_style varchar2(192) -- 其他卡片类型
    ,subject_id varchar2(30) -- 科目编号
    ,prd_id varchar2(30) -- 产品编号
    ,tr_chnl varchar2(48) -- aml交易渠道（参见[字典:aml0032]）
    ,s_tr_chnl varchar2(15) -- 源系统交易渠道
    ,tr_cd varchar2(6) -- aml交易代码
    ,s_tr_cd varchar2(45) -- 源系统交易代码
    ,biz_type varchar2(3) -- pbc业务类型（参见[字典:aml0033]）
    ,is_cash varchar2(3) -- 现转标志（参见[字典:aml0034]）
    ,pay_type varchar2(6) -- 支付工具及结算方式
    ,debit_credit varchar2(2) -- 借贷标志（参见[字典:aml0035]）
    ,rcv_pay varchar2(3) -- 收付标志（参见[字典:aml0036]）
    ,curr_cd varchar2(5) -- 币种
    ,is_local_curr varchar2(2) -- 本外币标志（参见[字典:aml0015]）
    ,tr_amt number(30,4) -- 原币种交易金额
    ,tr_cny_amt number(30,4) -- 折人民币交易金额
    ,tr_usd_amt number(30,4) -- 折美元交易金额
    ,tr_bal_amt number(30,4) -- 交易余额
    ,tr_country varchar2(5) -- 交易发生国家
    ,tr_area varchar2(9) -- 交易发生地区
    ,fund_use varchar2(768) -- 资金用途和来源
    ,agent_name varchar2(192) -- 代办人姓名
    ,agent_nat varchar2(5) -- 代办人国籍
    ,agent_cert_type varchar2(72) -- 代办人证件种类（参见[字典:aml0051]）
    ,oth_agent_cert_type varchar2(192) -- 代办人其他证件种类
    ,agent_cert_no varchar2(192) -- 代办人证件号码
    ,opp_name varchar2(192) -- 对方名称
    ,opp_acct_id varchar2(96) -- 对方账号
    ,opp_acct_type varchar2(9) -- 对手pbc账户类型
    ,opp_is_cust varchar2(2) -- 对方是否我行客户（参见[字典:t00002]）
    ,opp_cust_id varchar2(96) -- 对方客户编号
    ,opp_cust_type varchar2(2) -- 对方客户类型（参见[字典:aml0030]）
    ,opp_off_shore varchar2(2) -- 对方是否离岸账户（参见[字典:t00002]）
    ,opp_card_no varchar2(96) -- 对方卡号/折号
    ,opp_card_style varchar2(3) -- 对方卡片类型（参见[字典:aml0031]）
    ,oth_opp_card_style varchar2(192) -- 对方卡片其它类型
    ,opp_cert_type varchar2(72) -- 对方证件类型（参见[字典:aml0051]）
    ,oth_opp_cert_type varchar2(192) -- 对方其他身份证件/证明文件类型编码
    ,opp_cert_no varchar2(192) -- 对方证件号码
    ,opp_org_id varchar2(24) -- 对方金融机构编号
    ,opp_org_name varchar2(192) -- 对方金融机构名称
    ,opp_org_type varchar2(3) -- 对方金融机构类型 t1p_other  cfct
    ,opp_org_country varchar2(5) -- 对方金融机构网点国家
    ,opp_org_area varchar2(9) -- 对方金融机构网点地区
    ,tr_go_country varchar2(5) -- 交易去向国家
    ,tr_go_area varchar2(9) -- 交易去向地区
    ,is_cross varchar2(2) -- 是否跨境（参见[字典:t00002]）
    ,opr_id varchar2(48) -- 交易操作员
    ,re_opr_id varchar2(48) -- 交易复核员
    ,rev_cd varchar2(2) -- 冲正标志（参见[字典:aml0037]）
    ,pbc_rltp varchar2(23) -- 金融机构与客户的关系t1p_other  rltp
    ,pbc_tsct varchar2(24) -- 涉外收支交易代码  t1p_tsct
    ,sys_id varchar2(48) -- 发起系统编码
    ,ip varchar2(96) -- ip地址
    ,tr_ipv6 varchar2(48) -- 交易ipv6地址
    ,tr_mac varchar2(48) -- 交易mac地址
    ,tr_note1 varchar2(384) -- 交易信息备注1
    ,tr_note2 varchar2(384) -- 交易信息备注2
    ,bank_pay_cd varchar2(192) -- 银行与支付机构之间的业务交易编码
    ,eqpt_cd varchar2(750) -- 非柜台交易介质的设备代码
    ,merch_id varchar2(30) -- 收单商户编码
    ,merch_type varchar2(6) -- 收单商户类型
    ,is_3rd_pay varchar2(2) -- 是否第三方支付（参见[字典:t00002]）
    ,tr_crt_type varchar2(2) -- 交易创建方式（参见[字典:aml0038]）
    ,bh_exec varchar2(2) -- 参与大额计算（参见[字典:t00002]）
    ,bs_exec varchar2(2) -- 参与可疑计算（参见[字典:aml0039]）
    ,clct_sts varchar2(2) -- 筛查前补录状态（参见[字典:aml0040]）
    ,bh_valid varchar2(2) -- 大额验证（参见[字典:aml0041]）
    ,bs_valid varchar2(2) -- 可疑验证（参见[字典:aml0042]）
    ,due_dt date -- 处理期限
    ,rsrv_01 varchar2(72) -- 备用字段1
    ,rsrv_02 varchar2(72) -- 备用字段2
    ,rsrv_03 varchar2(144) -- 备用字段3
    ,rsrv_04 varchar2(375) -- 备用字段4
    ,pbc_chnl varchar2(75) -- pbc交易渠道（参见[字典:aml0032]）
    ,non_dept_type varchar2(3) -- 非柜台交易方式 aml0332
    ,oth_non_dept_type varchar2(96) -- 非柜台其他交易方式代码
    ,pbc_orgkey varchar2(24) -- 金融机构网点代码
    ,main_acct_id varchar2(96) -- 主账号
    ,agent_tel varchar2(90) -- 代理人联系方式
    ,opp_acct_type1 varchar2(9) -- 对手账户类型1(11：银行账户；12：支付账户等非银行账户)
    ,pos_owner varchar2(60) -- 信用卡消费商户名称
    ,is_cadr_trans varchar2(3) -- 是否有卡交易（11：有卡交易；12：无卡交易（网银交易）；13无卡交易（非网银交易））
    ,cert_no varchar2(192) -- 客户证件号码
    ,cert_type varchar2(9) -- 客户证件类型
    ,oth_cert_type varchar2(192) -- 客户其它证件类型
    ,atm_bank_code varchar2(30) -- atm机具所属行行号
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
grant select on ${iol_schema}.amls_t2a_trans to ${iml_schema};
grant select on ${iol_schema}.amls_t2a_trans to ${icl_schema};
grant select on ${iol_schema}.amls_t2a_trans to ${idl_schema};
grant select on ${iol_schema}.amls_t2a_trans to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t2a_trans is 't2a_交易流水表';
comment on column ${iol_schema}.amls_t2a_trans.tr_id is '业务标识号';
comment on column ${iol_schema}.amls_t2a_trans.tr_dt is '交易时间';
comment on column ${iol_schema}.amls_t2a_trans.tr_tm is '交易日期和时间';
comment on column ${iol_schema}.amls_t2a_trans.tr_no is '交易流水号';
comment on column ${iol_schema}.amls_t2a_trans.rcv_pay_type is '收付款方匹配号类型aml0333';
comment on column ${iol_schema}.amls_t2a_trans.rcv_pay_no is '收付款方匹配号';
comment on column ${iol_schema}.amls_t2a_trans.tr_org_id is '交易机构编号';
comment on column ${iol_schema}.amls_t2a_trans.cust_id is '客户编号';
comment on column ${iol_schema}.amls_t2a_trans.cust_name is '客户名称';
comment on column ${iol_schema}.amls_t2a_trans.cust_type is '客户类型（参见[字典:aml0030]）';
comment on column ${iol_schema}.amls_t2a_trans.acct_id is '账号';
comment on column ${iol_schema}.amls_t2a_trans.card_no is '卡号/折号';
comment on column ${iol_schema}.amls_t2a_trans.card_style is '卡片类型（参见[字典:aml0031]）';
comment on column ${iol_schema}.amls_t2a_trans.oth_card_style is '其他卡片类型';
comment on column ${iol_schema}.amls_t2a_trans.subject_id is '科目编号';
comment on column ${iol_schema}.amls_t2a_trans.prd_id is '产品编号';
comment on column ${iol_schema}.amls_t2a_trans.tr_chnl is 'aml交易渠道（参见[字典:aml0032]）';
comment on column ${iol_schema}.amls_t2a_trans.s_tr_chnl is '源系统交易渠道';
comment on column ${iol_schema}.amls_t2a_trans.tr_cd is 'aml交易代码';
comment on column ${iol_schema}.amls_t2a_trans.s_tr_cd is '源系统交易代码';
comment on column ${iol_schema}.amls_t2a_trans.biz_type is 'pbc业务类型（参见[字典:aml0033]）';
comment on column ${iol_schema}.amls_t2a_trans.is_cash is '现转标志（参见[字典:aml0034]）';
comment on column ${iol_schema}.amls_t2a_trans.pay_type is '支付工具及结算方式';
comment on column ${iol_schema}.amls_t2a_trans.debit_credit is '借贷标志（参见[字典:aml0035]）';
comment on column ${iol_schema}.amls_t2a_trans.rcv_pay is '收付标志（参见[字典:aml0036]）';
comment on column ${iol_schema}.amls_t2a_trans.curr_cd is '币种';
comment on column ${iol_schema}.amls_t2a_trans.is_local_curr is '本外币标志（参见[字典:aml0015]）';
comment on column ${iol_schema}.amls_t2a_trans.tr_amt is '原币种交易金额';
comment on column ${iol_schema}.amls_t2a_trans.tr_cny_amt is '折人民币交易金额';
comment on column ${iol_schema}.amls_t2a_trans.tr_usd_amt is '折美元交易金额';
comment on column ${iol_schema}.amls_t2a_trans.tr_bal_amt is '交易余额';
comment on column ${iol_schema}.amls_t2a_trans.tr_country is '交易发生国家';
comment on column ${iol_schema}.amls_t2a_trans.tr_area is '交易发生地区';
comment on column ${iol_schema}.amls_t2a_trans.fund_use is '资金用途和来源';
comment on column ${iol_schema}.amls_t2a_trans.agent_name is '代办人姓名';
comment on column ${iol_schema}.amls_t2a_trans.agent_nat is '代办人国籍';
comment on column ${iol_schema}.amls_t2a_trans.agent_cert_type is '代办人证件种类（参见[字典:aml0051]）';
comment on column ${iol_schema}.amls_t2a_trans.oth_agent_cert_type is '代办人其他证件种类';
comment on column ${iol_schema}.amls_t2a_trans.agent_cert_no is '代办人证件号码';
comment on column ${iol_schema}.amls_t2a_trans.opp_name is '对方名称';
comment on column ${iol_schema}.amls_t2a_trans.opp_acct_id is '对方账号';
comment on column ${iol_schema}.amls_t2a_trans.opp_acct_type is '对手pbc账户类型';
comment on column ${iol_schema}.amls_t2a_trans.opp_is_cust is '对方是否我行客户（参见[字典:t00002]）';
comment on column ${iol_schema}.amls_t2a_trans.opp_cust_id is '对方客户编号';
comment on column ${iol_schema}.amls_t2a_trans.opp_cust_type is '对方客户类型（参见[字典:aml0030]）';
comment on column ${iol_schema}.amls_t2a_trans.opp_off_shore is '对方是否离岸账户（参见[字典:t00002]）';
comment on column ${iol_schema}.amls_t2a_trans.opp_card_no is '对方卡号/折号';
comment on column ${iol_schema}.amls_t2a_trans.opp_card_style is '对方卡片类型（参见[字典:aml0031]）';
comment on column ${iol_schema}.amls_t2a_trans.oth_opp_card_style is '对方卡片其它类型';
comment on column ${iol_schema}.amls_t2a_trans.opp_cert_type is '对方证件类型（参见[字典:aml0051]）';
comment on column ${iol_schema}.amls_t2a_trans.oth_opp_cert_type is '对方其他身份证件/证明文件类型编码';
comment on column ${iol_schema}.amls_t2a_trans.opp_cert_no is '对方证件号码';
comment on column ${iol_schema}.amls_t2a_trans.opp_org_id is '对方金融机构编号';
comment on column ${iol_schema}.amls_t2a_trans.opp_org_name is '对方金融机构名称';
comment on column ${iol_schema}.amls_t2a_trans.opp_org_type is '对方金融机构类型 t1p_other  cfct';
comment on column ${iol_schema}.amls_t2a_trans.opp_org_country is '对方金融机构网点国家';
comment on column ${iol_schema}.amls_t2a_trans.opp_org_area is '对方金融机构网点地区';
comment on column ${iol_schema}.amls_t2a_trans.tr_go_country is '交易去向国家';
comment on column ${iol_schema}.amls_t2a_trans.tr_go_area is '交易去向地区';
comment on column ${iol_schema}.amls_t2a_trans.is_cross is '是否跨境（参见[字典:t00002]）';
comment on column ${iol_schema}.amls_t2a_trans.opr_id is '交易操作员';
comment on column ${iol_schema}.amls_t2a_trans.re_opr_id is '交易复核员';
comment on column ${iol_schema}.amls_t2a_trans.rev_cd is '冲正标志（参见[字典:aml0037]）';
comment on column ${iol_schema}.amls_t2a_trans.pbc_rltp is '金融机构与客户的关系t1p_other  rltp';
comment on column ${iol_schema}.amls_t2a_trans.pbc_tsct is '涉外收支交易代码  t1p_tsct';
comment on column ${iol_schema}.amls_t2a_trans.sys_id is '发起系统编码';
comment on column ${iol_schema}.amls_t2a_trans.ip is 'ip地址';
comment on column ${iol_schema}.amls_t2a_trans.tr_ipv6 is '交易ipv6地址';
comment on column ${iol_schema}.amls_t2a_trans.tr_mac is '交易mac地址';
comment on column ${iol_schema}.amls_t2a_trans.tr_note1 is '交易信息备注1';
comment on column ${iol_schema}.amls_t2a_trans.tr_note2 is '交易信息备注2';
comment on column ${iol_schema}.amls_t2a_trans.bank_pay_cd is '银行与支付机构之间的业务交易编码';
comment on column ${iol_schema}.amls_t2a_trans.eqpt_cd is '非柜台交易介质的设备代码';
comment on column ${iol_schema}.amls_t2a_trans.merch_id is '收单商户编码';
comment on column ${iol_schema}.amls_t2a_trans.merch_type is '收单商户类型';
comment on column ${iol_schema}.amls_t2a_trans.is_3rd_pay is '是否第三方支付（参见[字典:t00002]）';
comment on column ${iol_schema}.amls_t2a_trans.tr_crt_type is '交易创建方式（参见[字典:aml0038]）';
comment on column ${iol_schema}.amls_t2a_trans.bh_exec is '参与大额计算（参见[字典:t00002]）';
comment on column ${iol_schema}.amls_t2a_trans.bs_exec is '参与可疑计算（参见[字典:aml0039]）';
comment on column ${iol_schema}.amls_t2a_trans.clct_sts is '筛查前补录状态（参见[字典:aml0040]）';
comment on column ${iol_schema}.amls_t2a_trans.bh_valid is '大额验证（参见[字典:aml0041]）';
comment on column ${iol_schema}.amls_t2a_trans.bs_valid is '可疑验证（参见[字典:aml0042]）';
comment on column ${iol_schema}.amls_t2a_trans.due_dt is '处理期限';
comment on column ${iol_schema}.amls_t2a_trans.rsrv_01 is '备用字段1';
comment on column ${iol_schema}.amls_t2a_trans.rsrv_02 is '备用字段2';
comment on column ${iol_schema}.amls_t2a_trans.rsrv_03 is '备用字段3';
comment on column ${iol_schema}.amls_t2a_trans.rsrv_04 is '备用字段4';
comment on column ${iol_schema}.amls_t2a_trans.pbc_chnl is 'pbc交易渠道（参见[字典:aml0032]）';
comment on column ${iol_schema}.amls_t2a_trans.non_dept_type is '非柜台交易方式 aml0332';
comment on column ${iol_schema}.amls_t2a_trans.oth_non_dept_type is '非柜台其他交易方式代码';
comment on column ${iol_schema}.amls_t2a_trans.pbc_orgkey is '金融机构网点代码';
comment on column ${iol_schema}.amls_t2a_trans.main_acct_id is '主账号';
comment on column ${iol_schema}.amls_t2a_trans.agent_tel is '代理人联系方式';
comment on column ${iol_schema}.amls_t2a_trans.opp_acct_type1 is '对手账户类型1(11：银行账户；12：支付账户等非银行账户)';
comment on column ${iol_schema}.amls_t2a_trans.pos_owner is '信用卡消费商户名称';
comment on column ${iol_schema}.amls_t2a_trans.is_cadr_trans is '是否有卡交易（11：有卡交易；12：无卡交易（网银交易）；13无卡交易（非网银交易））';
comment on column ${iol_schema}.amls_t2a_trans.cert_no is '客户证件号码';
comment on column ${iol_schema}.amls_t2a_trans.cert_type is '客户证件类型';
comment on column ${iol_schema}.amls_t2a_trans.oth_cert_type is '客户其它证件类型';
comment on column ${iol_schema}.amls_t2a_trans.atm_bank_code is 'atm机具所属行行号';
comment on column ${iol_schema}.amls_t2a_trans.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t2a_trans.etl_timestamp is 'ETL处理时间戳';
