/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_misc_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_misc_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_misc_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_misc_hist(
    amt_type varchar2(10) -- 金额类型
    ,business_unit varchar2(10) -- 账套
    ,ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,country varchar2(3) -- 国家
    ,doc_type varchar2(10) -- 凭证类型
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,br_seq_no varchar2(50) -- 前端流水号
    ,cash_item varchar2(10) -- 现金项目
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,conv_base varchar2(10) -- 转换基础
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,dept_code varchar2(10) -- 现金支出项目编码
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,main_seq_no varchar2(50) -- 主流水号
    ,medium_flag varchar2(1) -- 介质标志
    ,medium_type varchar2(1) -- 存款介质类型
    ,narrative varchar2(400) -- 摘要
    ,oth_acct_desc varchar2(600) -- 对方账户描述
    ,oth_branch_regionalism_code varchar2(10) -- 对方金融机构行政区划代码
    ,oth_real_branch_region_code varchar2(10) -- 真实对方金融机构行政区划代码
    ,oth_seq_no varchar2(50) -- 对方交易流水号
    ,prefix varchar2(10) -- 前缀
    ,primary_event_type varchar2(5) -- 主事件类型
    ,primary_tran_seq_no varchar2(50) -- 主交易序号
    ,print_cnt number(5) -- 打印次数
    ,rate_type varchar2(10) -- 汇率类型
    ,rec_pay_flag varchar2(1) -- 柜面收付标志
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,reversal_tran_type varchar2(10) -- 冲正交易类型
    ,seq_no varchar2(50) -- 序号
    ,serv_charge varchar2(1) -- 服务费标识
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,system_id varchar2(20) -- 系统id
    ,tae_sub_seq_no varchar2(200) -- tae子流水序号
    ,terminal_id varchar2(50) -- 交易终端编号
    ,trace_id varchar2(200) -- 跟踪id
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_hist_seq_no varchar2(33) -- 交易流水号
    ,tran_note varchar2(1000) -- 交易附言
    ,tran_status varchar2(1) -- 冲补抹标志
    ,accounting_status varchar2(3) -- 核算状态
    ,channel_date date -- 渠道日期
    ,effect_date date -- 产品生效日期
    ,post_date date -- 入账日期
    ,reversal_tran_date date -- 冲正交易日期
    ,settlement_date date -- 清算日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,base_equiv_amt number(17,2) -- 基础等值金额
    ,contra_acct_ccy varchar2(3) -- 对方币种
    ,contra_equiv_amt number(17,2) -- 对方等值金额
    ,credit_card_no varchar2(50) -- 信用卡号
    ,cross_rate number(15,8) -- 交叉汇率
    ,d2_reference varchar2(50) -- d2参考号
    ,float_days number(5) -- 浮动天数
    ,oth_acct_ccy varchar2(3) -- 对方账户币种
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_bank_code varchar2(20) -- 对方银行代码
    ,oth_bank_name varchar2(400) -- 对方银行名称
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_branch varchar2(20) -- 对方账户开户机构
    ,oth_document_id varchar2(60) -- 交易对手证件号码
    ,oth_document_type varchar2(4) -- 交易对手证件类型
    ,oth_internal_key number(15) -- 对手账户内部键
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,oth_real_bank_code varchar2(30) -- 真实对方金融机构代码
    ,oth_real_bank_name varchar2(200) -- 真实对方金融机构名称
    ,oth_real_base_acct_no varchar2(50) -- 真实交易对手账号
    ,oth_real_document_id varchar2(60) -- 真实交易对手证件号码
    ,oth_real_document_type varchar2(4) -- 真实交易对手证件类型
    ,oth_real_tran_addr varchar2(400) -- 真实交易发生地
    ,oth_real_tran_name varchar2(200) -- 真实交易对手名称
    ,oth_reference varchar2(50) -- 对方交易参考号
    ,oth_tran_addr varchar2(400) -- 交易发生地
    ,oth_tran_name varchar2(200) -- 交易对手名称
    ,spread_percent number(11,7) -- 浮动百分比
    ,tfr_branch varchar2(12) -- 对方交易机构
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,flat_rate number(15,8) -- 平盘汇率
    ,reaccount_cd varchar2(20) -- 对账代码
    ,bus_seq_no varchar2(33) -- 业务流水号
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
grant select on ${iol_schema}.ncbs_rb_misc_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_misc_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_misc_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_misc_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_misc_hist is '现金交易流水表';
comment on column ${iol_schema}.ncbs_rb_misc_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_misc_hist.business_unit is '账套';
comment on column ${iol_schema}.ncbs_rb_misc_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_misc_hist.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_rb_misc_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.country is '国家';
comment on column ${iol_schema}.ncbs_rb_misc_hist.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_misc_hist.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_misc_hist.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_misc_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_rb_misc_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_misc_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_misc_hist.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.br_seq_no is '前端流水号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.cash_item is '现金项目';
comment on column ${iol_schema}.ncbs_rb_misc_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_misc_hist.conv_base is '转换基础';
comment on column ${iol_schema}.ncbs_rb_misc_hist.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_misc_hist.dept_code is '现金支出项目编码';
comment on column ${iol_schema}.ncbs_rb_misc_hist.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_rb_misc_hist.main_seq_no is '主流水号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.medium_flag is '介质标志';
comment on column ${iol_schema}.ncbs_rb_misc_hist.medium_type is '存款介质类型';
comment on column ${iol_schema}.ncbs_rb_misc_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_acct_desc is '对方账户描述';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_branch_regionalism_code is '对方金融机构行政区划代码';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_real_branch_region_code is '真实对方金融机构行政区划代码';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_seq_no is '对方交易流水号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_misc_hist.primary_event_type is '主事件类型';
comment on column ${iol_schema}.ncbs_rb_misc_hist.primary_tran_seq_no is '主交易序号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.print_cnt is '打印次数';
comment on column ${iol_schema}.ncbs_rb_misc_hist.rate_type is '汇率类型';
comment on column ${iol_schema}.ncbs_rb_misc_hist.rec_pay_flag is '柜面收付标志';
comment on column ${iol_schema}.ncbs_rb_misc_hist.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_misc_hist.reversal_tran_type is '冲正交易类型';
comment on column ${iol_schema}.ncbs_rb_misc_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.serv_charge is '服务费标识';
comment on column ${iol_schema}.ncbs_rb_misc_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_misc_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.system_id is '系统id';
comment on column ${iol_schema}.ncbs_rb_misc_hist.tae_sub_seq_no is 'tae子流水序号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.trace_id is '跟踪id';
comment on column ${iol_schema}.ncbs_rb_misc_hist.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_rb_misc_hist.tran_hist_seq_no is '交易流水号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.tran_note is '交易附言';
comment on column ${iol_schema}.ncbs_rb_misc_hist.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_rb_misc_hist.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_rb_misc_hist.channel_date is '渠道日期';
comment on column ${iol_schema}.ncbs_rb_misc_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_misc_hist.post_date is '入账日期';
comment on column ${iol_schema}.ncbs_rb_misc_hist.reversal_tran_date is '冲正交易日期';
comment on column ${iol_schema}.ncbs_rb_misc_hist.settlement_date is '清算日期';
comment on column ${iol_schema}.ncbs_rb_misc_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_misc_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_misc_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_misc_hist.base_equiv_amt is '基础等值金额';
comment on column ${iol_schema}.ncbs_rb_misc_hist.contra_acct_ccy is '对方币种';
comment on column ${iol_schema}.ncbs_rb_misc_hist.contra_equiv_amt is '对方等值金额';
comment on column ${iol_schema}.ncbs_rb_misc_hist.credit_card_no is '信用卡号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.cross_rate is '交叉汇率';
comment on column ${iol_schema}.ncbs_rb_misc_hist.d2_reference is 'd2参考号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.float_days is '浮动天数';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_acct_ccy is '对方账户币种';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_bank_code is '对方银行代码';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_bank_name is '对方银行名称';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_branch is '对方账户开户机构';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_document_id is '交易对手证件号码';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_document_type is '交易对手证件类型';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_real_bank_code is '真实对方金融机构代码';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_real_bank_name is '真实对方金融机构名称';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_real_base_acct_no is '真实交易对手账号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_real_document_id is '真实交易对手证件号码';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_real_document_type is '真实交易对手证件类型';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_real_tran_addr is '真实交易发生地';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_real_tran_name is '真实交易对手名称';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_reference is '对方交易参考号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_tran_addr is '交易发生地';
comment on column ${iol_schema}.ncbs_rb_misc_hist.oth_tran_name is '交易对手名称';
comment on column ${iol_schema}.ncbs_rb_misc_hist.spread_percent is '浮动百分比';
comment on column ${iol_schema}.ncbs_rb_misc_hist.tfr_branch is '对方交易机构';
comment on column ${iol_schema}.ncbs_rb_misc_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_misc_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.flat_rate is '平盘汇率';
comment on column ${iol_schema}.ncbs_rb_misc_hist.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_rb_misc_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_rb_misc_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_misc_hist.etl_timestamp is 'ETL处理时间戳';
