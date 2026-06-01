/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_tran_hist(
    acct_status varchar2(1) -- 账户状态
    ,amt_type varchar2(10) -- 金额类型
    ,branch varchar2(12) -- 机构编号
    ,business_unit varchar2(10) -- 账套
    ,ccy varchar2(3) -- 币种
    ,client_name varchar2(200) -- 客户名称
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,dd_no number(5) -- 发放号
    ,doc_type varchar2(10) -- 凭证类型
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,gl_code varchar2(20) -- 科目代码
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,withdrawal_type varchar2(1) -- 支取方式
    ,acct_desc varchar2(200) -- 账户描述
    ,acct_real_flag varchar2(1) -- 账户虚实标志
    ,acct_tran_flag varchar2(1) -- 账户交易标志
    ,amt_calc_type varchar2(1) -- 金额计算类型
    ,bal_type varchar2(2) -- 余额类型
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,batch_no varchar2(50) -- 批次号
    ,biz_type varchar2(10) -- 中间业务类型
    ,cash_item varchar2(10) -- 现金项目
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,channel_sub_seq_no varchar2(50) -- 渠道子流水号
    ,commission_phone varchar2(20) -- 代办人电话
    ,company varchar2(20) -- 法人
    ,cr_dr_maint_ind varchar2(1) -- 借贷标识
    ,event_type varchar2(20) -- 事件类型
    ,fh_seq_no varchar2(50) -- 资金冻结流水号
    ,from_rate_flag varchar2(1) -- 买方交易汇率标志
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,lender varchar2(100) -- 贷款人
    ,limit_ref varchar2(500) -- 限额编码
    ,marketing_prod_desc varchar2(500) -- 营销产品名称
    ,narrative varchar2(400) -- 摘要
    ,oth_acct_desc varchar2(600) -- 对方账户描述
    ,oth_seq_no varchar2(50) -- 对方交易流水号
    ,pay_unit varchar2(200) -- 交款单位
    ,pbk_upd_flag varchar2(1) -- 是否补登存
    ,prefix varchar2(10) -- 前缀
    ,primary_event_type varchar2(5) -- 主事件类型
    ,primary_tran_seq_no varchar2(50) -- 主交易序号
    ,print_cnt number(5) -- 打印次数
    ,priority varchar2(20) -- 优先级
    ,program_id varchar2(20) -- 交易代码
    ,quote_type varchar2(1) -- 牌价类型
    ,rate_flag varchar2(1) -- 汇率标志
    ,rate_type varchar2(10) -- 汇率类型
    ,receipt_no varchar2(50) -- 回收号
    ,reserve1 varchar2(50) -- 预留字段1
    ,reserve2 varchar2(50) -- 预留字段2
    ,reversal varchar2(1) -- 是否冲正标志
    ,reversal_seq_no varchar2(50) -- 冲正流水号
    ,reversal_tran_type varchar2(10) -- 冲正交易类型
    ,seq_no varchar2(50) -- 序号
    ,serv_charge varchar2(1) -- 服务费标识
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,terminal_id varchar2(50) -- 交易终端编号
    ,to_id varchar2(1) -- 卖方牌价类型
    ,to_rate_flag varchar2(1) -- 卖方交易汇率标志
    ,trace_id varchar2(200) -- 跟踪id
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_note varchar2(1000) -- 交易附言
    ,tran_status varchar2(1) -- 冲补抹标志
    ,tran_category varchar2(5) -- 交易种类
    ,accounting_status varchar2(3) -- 核算状态
    ,effect_date date -- 产品生效日期
    ,reversal_date date -- 冲正日期
    ,settlement_date date -- 清算日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,actual_bal number(17,2) -- 实际余额
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,base_equiv_amt number(17,2) -- 基础等值金额
    ,commission_client_name varchar2(200) -- 代办人名称
    ,contra_acct_ccy varchar2(3) -- 对方币种
    ,contra_equiv_amt number(17,2) -- 对方等值金额
    ,cross_rate number(15,8) -- 交叉汇率
    ,from_amount number(17,2) -- 移出金额
    ,from_ccy varchar2(3) -- 起始币种
    ,from_xrate number(15,8) -- 买方汇率值
    ,loan_no varchar2(50) -- 贷款号
    ,marketing_prod varchar2(12) -- 营销产品
    ,oth_acct_ccy varchar2(3) -- 对方账户币种
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_bank_code varchar2(20) -- 对方银行代码
    ,oth_bank_name varchar2(400) -- 对方银行名称
    ,oth_base_acct_no varchar2(64) -- 对方账号/卡号
    ,oth_branch varchar2(20) -- 对方账户开户机构
    ,oth_internal_key number(15) -- 对手账户内部键
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,oth_reference varchar2(50) -- 对方交易参考号
    ,ov_cross_rate number(15,8) -- 实际交易时修改交叉汇率
    ,ov_to_amount number(17,2) -- 根据实际交易时修改交叉汇率计算的金额
    ,previous_bal_amt number(17,2) -- 交易前余额
    ,to_amount number(17,2) -- 移入金额
    ,to_ccy varchar2(3) -- 目的币种
    ,to_xrate number(15,8) -- 卖方汇率值
    ,tran_amt number(17,2) -- 交易金额
    ,tran_method varchar2(2) -- 到账方式
    ,reaccount_cd varchar2(20) -- 对账代码
    ,client_econ_type varchar2(3) -- 客户经济类型
    ,bus_seq_no varchar2(33) -- 业务流水号
    ,sub_seq_no varchar2(100) -- 系统子流水号|系统子流水号
    ,main_source_module varchar2(3) -- 主模块
    ,system_code varchar2(30) -- 来源系统编号
    ,extra_tran_timestamp varchar2(26) -- 反洗钱加工时间戳
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
grant select on ${iol_schema}.ncbs_cl_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_tran_hist is '金融交易流水表';
comment on column ${iol_schema}.ncbs_cl_tran_hist.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_cl_tran_hist.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.business_unit is '账套';
comment on column ${iol_schema}.ncbs_cl_tran_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_tran_hist.client_name is '客户名称';
comment on column ${iol_schema}.ncbs_cl_tran_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_cl_tran_hist.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_cl_tran_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_tran_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_cl_tran_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_cl_tran_hist.withdrawal_type is '支取方式';
comment on column ${iol_schema}.ncbs_cl_tran_hist.acct_desc is '账户描述';
comment on column ${iol_schema}.ncbs_cl_tran_hist.acct_real_flag is '账户虚实标志';
comment on column ${iol_schema}.ncbs_cl_tran_hist.acct_tran_flag is '账户交易标志';
comment on column ${iol_schema}.ncbs_cl_tran_hist.amt_calc_type is '金额计算类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.bal_type is '余额类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.biz_type is '中间业务类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.cash_item is '现金项目';
comment on column ${iol_schema}.ncbs_cl_tran_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.channel_sub_seq_no is '渠道子流水号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.commission_phone is '代办人电话';
comment on column ${iol_schema}.ncbs_cl_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_cl_tran_hist.cr_dr_maint_ind is '借贷标识';
comment on column ${iol_schema}.ncbs_cl_tran_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.fh_seq_no is '资金冻结流水号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.from_rate_flag is '买方交易汇率标志';
comment on column ${iol_schema}.ncbs_cl_tran_hist.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_cl_tran_hist.lender is '贷款人';
comment on column ${iol_schema}.ncbs_cl_tran_hist.limit_ref is '限额编码';
comment on column ${iol_schema}.ncbs_cl_tran_hist.marketing_prod_desc is '营销产品名称';
comment on column ${iol_schema}.ncbs_cl_tran_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cl_tran_hist.oth_acct_desc is '对方账户描述';
comment on column ${iol_schema}.ncbs_cl_tran_hist.oth_seq_no is '对方交易流水号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.pay_unit is '交款单位';
comment on column ${iol_schema}.ncbs_cl_tran_hist.pbk_upd_flag is '是否补登存';
comment on column ${iol_schema}.ncbs_cl_tran_hist.prefix is '前缀';
comment on column ${iol_schema}.ncbs_cl_tran_hist.primary_event_type is '主事件类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.primary_tran_seq_no is '主交易序号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.print_cnt is '打印次数';
comment on column ${iol_schema}.ncbs_cl_tran_hist.priority is '优先级';
comment on column ${iol_schema}.ncbs_cl_tran_hist.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_cl_tran_hist.quote_type is '牌价类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.rate_flag is '汇率标志';
comment on column ${iol_schema}.ncbs_cl_tran_hist.rate_type is '汇率类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.receipt_no is '回收号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.reserve1 is '预留字段1';
comment on column ${iol_schema}.ncbs_cl_tran_hist.reserve2 is '预留字段2';
comment on column ${iol_schema}.ncbs_cl_tran_hist.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_cl_tran_hist.reversal_seq_no is '冲正流水号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.reversal_tran_type is '冲正交易类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.serv_charge is '服务费标识';
comment on column ${iol_schema}.ncbs_cl_tran_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_cl_tran_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.to_id is '卖方牌价类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.to_rate_flag is '卖方交易汇率标志';
comment on column ${iol_schema}.ncbs_cl_tran_hist.trace_id is '跟踪id';
comment on column ${iol_schema}.ncbs_cl_tran_hist.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_cl_tran_hist.tran_note is '交易附言';
comment on column ${iol_schema}.ncbs_cl_tran_hist.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_cl_tran_hist.tran_category is '交易种类';
comment on column ${iol_schema}.ncbs_cl_tran_hist.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_cl_tran_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_cl_tran_hist.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_cl_tran_hist.settlement_date is '清算日期';
comment on column ${iol_schema}.ncbs_cl_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_tran_hist.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_cl_tran_hist.actual_bal is '实际余额';
comment on column ${iol_schema}.ncbs_cl_tran_hist.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_cl_tran_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_cl_tran_hist.base_equiv_amt is '基础等值金额';
comment on column ${iol_schema}.ncbs_cl_tran_hist.commission_client_name is '代办人名称';
comment on column ${iol_schema}.ncbs_cl_tran_hist.contra_acct_ccy is '对方币种';
comment on column ${iol_schema}.ncbs_cl_tran_hist.contra_equiv_amt is '对方等值金额';
comment on column ${iol_schema}.ncbs_cl_tran_hist.cross_rate is '交叉汇率';
comment on column ${iol_schema}.ncbs_cl_tran_hist.from_amount is '移出金额';
comment on column ${iol_schema}.ncbs_cl_tran_hist.from_ccy is '起始币种';
comment on column ${iol_schema}.ncbs_cl_tran_hist.from_xrate is '买方汇率值';
comment on column ${iol_schema}.ncbs_cl_tran_hist.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.marketing_prod is '营销产品';
comment on column ${iol_schema}.ncbs_cl_tran_hist.oth_acct_ccy is '对方账户币种';
comment on column ${iol_schema}.ncbs_cl_tran_hist.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.oth_bank_code is '对方银行代码';
comment on column ${iol_schema}.ncbs_cl_tran_hist.oth_bank_name is '对方银行名称';
comment on column ${iol_schema}.ncbs_cl_tran_hist.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.oth_branch is '对方账户开户机构';
comment on column ${iol_schema}.ncbs_cl_tran_hist.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_cl_tran_hist.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.oth_reference is '对方交易参考号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.ov_cross_rate is '实际交易时修改交叉汇率';
comment on column ${iol_schema}.ncbs_cl_tran_hist.ov_to_amount is '根据实际交易时修改交叉汇率计算的金额';
comment on column ${iol_schema}.ncbs_cl_tran_hist.previous_bal_amt is '交易前余额';
comment on column ${iol_schema}.ncbs_cl_tran_hist.to_amount is '移入金额';
comment on column ${iol_schema}.ncbs_cl_tran_hist.to_ccy is '目的币种';
comment on column ${iol_schema}.ncbs_cl_tran_hist.to_xrate is '卖方汇率值';
comment on column ${iol_schema}.ncbs_cl_tran_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_cl_tran_hist.tran_method is '到账方式';
comment on column ${iol_schema}.ncbs_cl_tran_hist.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_cl_tran_hist.client_econ_type is '客户经济类型';
comment on column ${iol_schema}.ncbs_cl_tran_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.sub_seq_no is '系统子流水号|系统子流水号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.main_source_module is '主模块';
comment on column ${iol_schema}.ncbs_cl_tran_hist.system_code is '来源系统编号';
comment on column ${iol_schema}.ncbs_cl_tran_hist.extra_tran_timestamp is '反洗钱加工时间戳';
comment on column ${iol_schema}.ncbs_cl_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_tran_hist.etl_timestamp is 'ETL处理时间戳';
