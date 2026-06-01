/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_attach
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_attach
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_attach purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_attach(
    internal_key number(15,0) -- 账户内部键值
    ,gl_code varchar2(20) -- 科目代码
    ,acct_proof_status varchar2(2) -- 账户验证状态
    ,acct_proof_reason varchar2(200) -- 验证失败原因
    ,acct_property varchar2(4) -- 外汇账户性质
    ,bal_chg_ind varchar2(1) -- 余额联动变动标识
    ,bal_upd_type varchar2(1) -- 余额更新类型
    ,balance_way varchar2(1) -- 余额方向
    ,od_facility varchar2(1) -- 是否可透支
    ,cycle_int_flag varchar2(1) -- 按频率付息标志
    ,auto_settle_flag varchar2(1) -- 自动结清标志
    ,auto_dep varchar2(1) -- 是否自动续存
    ,manual_account_flag varchar2(1) -- 是否允许手工记账标识
    ,fta_acct_flag varchar2(1) -- 是否自贸区账户标识
    ,fta_code varchar2(10) -- 自贸区代码
    ,contra_base_acct_no varchar2(50) -- 交易对手账号
    ,contra_acct_name varchar2(200) -- 对手账号名称
    ,contra_branch varchar2(12) -- 对手账户开户行
    ,contra_branch_name varchar2(200) -- 对手账户开户行名称
    ,hang_write_off_flag varchar2(1) -- 挂销账标志
    ,hang_term varchar2(5) -- 挂账期限
    ,write_off_way varchar2(3) -- 销账方式
    ,agreement_status varchar2(2) -- 协议状态
    ,prod_class varchar2(20) -- 产品分类
    ,special_prod_class varchar2(1) -- 签约产品分类
    ,stage_code varchar2(50) -- 期次代码
    ,annual_flag varchar2(1) -- 证件年检标志
    ,annual_status varchar2(1) -- 年检通过状态
    ,last_reset_date date -- 上一年检重置日期
    ,last_stop_date date -- 上一年检截止日期
    ,blacklist_status varchar2(2) -- 黑名单状态
    ,last_blacklist_date date -- 最后黑名单日期
    ,free_sum number(5,0) -- 手续费免费次数
    ,impound_fad varchar2(1) -- 强制扣划导致违约状态
    ,msg_status varchar2(1) -- 短信签约状态
    ,client_no varchar2(16) -- 客户编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
    ,auto_renew_term varchar2(5) -- 账户转存期限
    ,auto_renew_term_type varchar2(1) -- 账户转存存期类型
    ,total_draw_amt number(17,2) -- 累计可支取本金金额
    ,allow_suspend_flag varchar2(1) -- 是否允许账户转久悬
    ,all_dra_int_branch varchar2(200) -- 通兑机构
    ,deposit_nature varchar2(10) -- 核心存款性质
    ,acct_verify_status varchar2(2) -- 账户核实状态
    ,is_sell_cheque varchar2(1) -- 是否允许出售支票标识
    ,acct_verify_status_prev varchar2(2) -- 账户上一核实状态
    ,private_acct_flag varchar2(1) -- 隐私账户标志
    ,case_involved_date date -- 客户涉案日期
    ,case_involved_reason varchar2(200) -- 客户涉案原因
    ,treatment varchar2(2) -- 处理种类
    ,agreement_id varchar2(50) -- 协议编号
    ,approval_no varchar2(50) -- 审批单号
    ,contra_client_no varchar2(16) -- 对方客户号
    ,contra_area_code varchar2(6) -- 对手行开立机构所属区域代码
    ,contra_country varchar2(3) -- 交易对手行所属国家/地区
    ,swift_id varchar2(3) -- 银行国际代码
    ,counter_dep_flag varchar2(1) -- 是否允许柜面跨行存入许可标识
    ,counter_debt_flag varchar2(1) -- 是否允许柜面跨行支取许可标识
    ,pre_debt_date date -- 定期提前支取日期
    ,online_flag varchar2(1) -- 是否联机
    ,check_certificate_amt number(17,2) -- 查证金额
    ,manage_flag varchar2(1) -- 监管标志
    ,check_certificate_type varchar2(10) -- 查证类型
    ,manage_content varchar2(200) -- 监管内容
    ,agreement_deposit_type varchar2(1) -- 协议存款类型
    ,next_dep_day varchar2(2) -- 下一续存日
    ,acct_open_mode varchar2(3) -- 开户模式
    ,manage_type varchar2(10) -- 监管类型
    ,back_to_date date -- 转回日期
    ,amount_nature varchar2(10) -- 资金性质
    ,int_tax_levy varchar2(1) -- 利息税征收标志
    ,re_open_date date -- 销户重开日期和时间
    ,acct_open_type varchar2(1) -- 开户方式
    ,contra_acct_open_date date -- 对手账户开户日期
    ,first_draw_date date -- 最早可支取日
    ,tax_rate number(15,8) -- 税率
    ,acct_channel_flag varchar2(2) -- 账户渠道标识
    ,fast_open_acct_flag varchar2(1) -- 是否一键开户标识
    ,acct_property2 varchar2(10) -- 账户性质2
    ,case_involved_flag varchar2(10) -- 涉案标识及暂停非柜原因
    ,delay_pay_int varchar2(1) -- 延期付息标志
    ,spec_day varchar2(2) -- 指定日
    ,tax_discount_maturity_date date -- 优惠利息税率到期日
    ,both_limit_flag varchar2(1) -- 双边限额限制标识
    ,fund_from_acct_no varchar2(30) -- 资金来源账号
    ,fund_from_acct_seq_no varchar2(5) -- 资金来源账户子序号
    ,is_effect_document varchar2(1) -- 是否有有效身份证件
    ,dc_prod_change_flag varchar2(1) -- 大额存单产品变更标志|是否为大额存单产品变更的账户
    ,pcp_delay_int_flag varchar2(1) -- 兴惠存标识|是否签约集团资金池或延期付息
    ,open_acct_prov varchar2(50) -- 开户省份|开户省份(用于二三类开户使用)
    ,open_acct_city varchar2(50) -- 开户城市|开户城市(用于二三类开户使用)
    ,off_site_sign varchar2(1) -- 本异地标识|用于二三类户开户1-异地,0-本地
    ,fix_rate_period_freq varchar2(5) -- 固定利率周期|固定利率周期
    ,book_settele_date date -- 预约结清日
    ,apply_debt_date date -- 预约支取日期
    ,apply_debt_flag varchar2(1) -- 是否预约支取
    ,allow_print_certificate_flag varchar2(1) -- 打印证实书标志
    ,cash_manage_product varchar2(1) -- 是否现金管理类产品
    ,int_rate_form_no varchar2(50) -- 利率审批单单号
    ,manage_start_date date -- 监管标识设置日期
    ,manage_end_date date -- 取消监管标识日期
    ,bal_int_split varchar2(3) -- 本息分离标志
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
grant select on ${iol_schema}.ncbs_rb_acct_attach to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_attach to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_attach to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_attach to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_attach is '账户辅助信息表';
comment on column ${iol_schema}.ncbs_rb_acct_attach.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_attach.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_rb_acct_attach.acct_proof_status is '账户验证状态';
comment on column ${iol_schema}.ncbs_rb_acct_attach.acct_proof_reason is '验证失败原因';
comment on column ${iol_schema}.ncbs_rb_acct_attach.acct_property is '外汇账户性质';
comment on column ${iol_schema}.ncbs_rb_acct_attach.bal_chg_ind is '余额联动变动标识';
comment on column ${iol_schema}.ncbs_rb_acct_attach.bal_upd_type is '余额更新类型';
comment on column ${iol_schema}.ncbs_rb_acct_attach.balance_way is '余额方向';
comment on column ${iol_schema}.ncbs_rb_acct_attach.od_facility is '是否可透支';
comment on column ${iol_schema}.ncbs_rb_acct_attach.cycle_int_flag is '按频率付息标志';
comment on column ${iol_schema}.ncbs_rb_acct_attach.auto_settle_flag is '自动结清标志';
comment on column ${iol_schema}.ncbs_rb_acct_attach.auto_dep is '是否自动续存';
comment on column ${iol_schema}.ncbs_rb_acct_attach.manual_account_flag is '是否允许手工记账标识';
comment on column ${iol_schema}.ncbs_rb_acct_attach.fta_acct_flag is '是否自贸区账户标识';
comment on column ${iol_schema}.ncbs_rb_acct_attach.fta_code is '自贸区代码';
comment on column ${iol_schema}.ncbs_rb_acct_attach.contra_base_acct_no is '交易对手账号';
comment on column ${iol_schema}.ncbs_rb_acct_attach.contra_acct_name is '对手账号名称';
comment on column ${iol_schema}.ncbs_rb_acct_attach.contra_branch is '对手账户开户行';
comment on column ${iol_schema}.ncbs_rb_acct_attach.contra_branch_name is '对手账户开户行名称';
comment on column ${iol_schema}.ncbs_rb_acct_attach.hang_write_off_flag is '挂销账标志';
comment on column ${iol_schema}.ncbs_rb_acct_attach.hang_term is '挂账期限';
comment on column ${iol_schema}.ncbs_rb_acct_attach.write_off_way is '销账方式';
comment on column ${iol_schema}.ncbs_rb_acct_attach.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_acct_attach.prod_class is '产品分类';
comment on column ${iol_schema}.ncbs_rb_acct_attach.special_prod_class is '签约产品分类';
comment on column ${iol_schema}.ncbs_rb_acct_attach.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_acct_attach.annual_flag is '证件年检标志';
comment on column ${iol_schema}.ncbs_rb_acct_attach.annual_status is '年检通过状态';
comment on column ${iol_schema}.ncbs_rb_acct_attach.last_reset_date is '上一年检重置日期';
comment on column ${iol_schema}.ncbs_rb_acct_attach.last_stop_date is '上一年检截止日期';
comment on column ${iol_schema}.ncbs_rb_acct_attach.blacklist_status is '黑名单状态';
comment on column ${iol_schema}.ncbs_rb_acct_attach.last_blacklist_date is '最后黑名单日期';
comment on column ${iol_schema}.ncbs_rb_acct_attach.free_sum is '手续费免费次数';
comment on column ${iol_schema}.ncbs_rb_acct_attach.impound_fad is '强制扣划导致违约状态';
comment on column ${iol_schema}.ncbs_rb_acct_attach.msg_status is '短信签约状态';
comment on column ${iol_schema}.ncbs_rb_acct_attach.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_attach.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_attach.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_attach.auto_renew_term is '账户转存期限';
comment on column ${iol_schema}.ncbs_rb_acct_attach.auto_renew_term_type is '账户转存存期类型';
comment on column ${iol_schema}.ncbs_rb_acct_attach.total_draw_amt is '累计可支取本金金额';
comment on column ${iol_schema}.ncbs_rb_acct_attach.allow_suspend_flag is '是否允许账户转久悬';
comment on column ${iol_schema}.ncbs_rb_acct_attach.all_dra_int_branch is '通兑机构';
comment on column ${iol_schema}.ncbs_rb_acct_attach.deposit_nature is '核心存款性质';
comment on column ${iol_schema}.ncbs_rb_acct_attach.acct_verify_status is '账户核实状态';
comment on column ${iol_schema}.ncbs_rb_acct_attach.is_sell_cheque is '是否允许出售支票标识';
comment on column ${iol_schema}.ncbs_rb_acct_attach.acct_verify_status_prev is '账户上一核实状态';
comment on column ${iol_schema}.ncbs_rb_acct_attach.private_acct_flag is '隐私账户标志';
comment on column ${iol_schema}.ncbs_rb_acct_attach.case_involved_date is '客户涉案日期';
comment on column ${iol_schema}.ncbs_rb_acct_attach.case_involved_reason is '客户涉案原因';
comment on column ${iol_schema}.ncbs_rb_acct_attach.treatment is '处理种类';
comment on column ${iol_schema}.ncbs_rb_acct_attach.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_acct_attach.approval_no is '审批单号';
comment on column ${iol_schema}.ncbs_rb_acct_attach.contra_client_no is '对方客户号';
comment on column ${iol_schema}.ncbs_rb_acct_attach.contra_area_code is '对手行开立机构所属区域代码';
comment on column ${iol_schema}.ncbs_rb_acct_attach.contra_country is '交易对手行所属国家/地区';
comment on column ${iol_schema}.ncbs_rb_acct_attach.swift_id is '银行国际代码';
comment on column ${iol_schema}.ncbs_rb_acct_attach.counter_dep_flag is '是否允许柜面跨行存入许可标识';
comment on column ${iol_schema}.ncbs_rb_acct_attach.counter_debt_flag is '是否允许柜面跨行支取许可标识';
comment on column ${iol_schema}.ncbs_rb_acct_attach.pre_debt_date is '定期提前支取日期';
comment on column ${iol_schema}.ncbs_rb_acct_attach.online_flag is '是否联机';
comment on column ${iol_schema}.ncbs_rb_acct_attach.check_certificate_amt is '查证金额';
comment on column ${iol_schema}.ncbs_rb_acct_attach.manage_flag is '监管标志';
comment on column ${iol_schema}.ncbs_rb_acct_attach.check_certificate_type is '查证类型';
comment on column ${iol_schema}.ncbs_rb_acct_attach.manage_content is '监管内容';
comment on column ${iol_schema}.ncbs_rb_acct_attach.agreement_deposit_type is '协议存款类型';
comment on column ${iol_schema}.ncbs_rb_acct_attach.next_dep_day is '下一续存日';
comment on column ${iol_schema}.ncbs_rb_acct_attach.acct_open_mode is '开户模式';
comment on column ${iol_schema}.ncbs_rb_acct_attach.manage_type is '监管类型';
comment on column ${iol_schema}.ncbs_rb_acct_attach.back_to_date is '转回日期';
comment on column ${iol_schema}.ncbs_rb_acct_attach.amount_nature is '资金性质';
comment on column ${iol_schema}.ncbs_rb_acct_attach.int_tax_levy is '利息税征收标志';
comment on column ${iol_schema}.ncbs_rb_acct_attach.re_open_date is '销户重开日期和时间';
comment on column ${iol_schema}.ncbs_rb_acct_attach.acct_open_type is '开户方式';
comment on column ${iol_schema}.ncbs_rb_acct_attach.contra_acct_open_date is '对手账户开户日期';
comment on column ${iol_schema}.ncbs_rb_acct_attach.first_draw_date is '最早可支取日';
comment on column ${iol_schema}.ncbs_rb_acct_attach.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_rb_acct_attach.acct_channel_flag is '账户渠道标识';
comment on column ${iol_schema}.ncbs_rb_acct_attach.fast_open_acct_flag is '是否一键开户标识';
comment on column ${iol_schema}.ncbs_rb_acct_attach.acct_property2 is '账户性质2';
comment on column ${iol_schema}.ncbs_rb_acct_attach.case_involved_flag is '涉案标识及暂停非柜原因';
comment on column ${iol_schema}.ncbs_rb_acct_attach.delay_pay_int is '延期付息标志';
comment on column ${iol_schema}.ncbs_rb_acct_attach.spec_day is '指定日';
comment on column ${iol_schema}.ncbs_rb_acct_attach.tax_discount_maturity_date is '优惠利息税率到期日';
comment on column ${iol_schema}.ncbs_rb_acct_attach.both_limit_flag is '双边限额限制标识';
comment on column ${iol_schema}.ncbs_rb_acct_attach.fund_from_acct_no is '资金来源账号';
comment on column ${iol_schema}.ncbs_rb_acct_attach.fund_from_acct_seq_no is '资金来源账户子序号';
comment on column ${iol_schema}.ncbs_rb_acct_attach.is_effect_document is '是否有有效身份证件';
comment on column ${iol_schema}.ncbs_rb_acct_attach.dc_prod_change_flag is '大额存单产品变更标志|是否为大额存单产品变更的账户';
comment on column ${iol_schema}.ncbs_rb_acct_attach.pcp_delay_int_flag is '兴惠存标识|是否签约集团资金池或延期付息';
comment on column ${iol_schema}.ncbs_rb_acct_attach.open_acct_prov is '开户省份|开户省份(用于二三类开户使用)';
comment on column ${iol_schema}.ncbs_rb_acct_attach.open_acct_city is '开户城市|开户城市(用于二三类开户使用)';
comment on column ${iol_schema}.ncbs_rb_acct_attach.off_site_sign is '本异地标识|用于二三类户开户1-异地,0-本地';
comment on column ${iol_schema}.ncbs_rb_acct_attach.fix_rate_period_freq is '固定利率周期|固定利率周期';
comment on column ${iol_schema}.ncbs_rb_acct_attach.book_settele_date is '预约结清日';
comment on column ${iol_schema}.ncbs_rb_acct_attach.apply_debt_date is '预约支取日期';
comment on column ${iol_schema}.ncbs_rb_acct_attach.apply_debt_flag is '是否预约支取';
comment on column ${iol_schema}.ncbs_rb_acct_attach.allow_print_certificate_flag is '打印证实书标志';
comment on column ${iol_schema}.ncbs_rb_acct_attach.cash_manage_product is '是否现金管理类产品';
comment on column ${iol_schema}.ncbs_rb_acct_attach.int_rate_form_no is '利率审批单单号';
comment on column ${iol_schema}.ncbs_rb_acct_attach.manage_start_date is '监管标识设置日期';
comment on column ${iol_schema}.ncbs_rb_acct_attach.manage_end_date is '取消监管标识日期';
comment on column ${iol_schema}.ncbs_rb_acct_attach.bal_int_split is '本息分离标志';
comment on column ${iol_schema}.ncbs_rb_acct_attach.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct_attach.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct_attach.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct_attach.etl_timestamp is 'ETL处理时间戳';
