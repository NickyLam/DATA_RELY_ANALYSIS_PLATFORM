/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,acct_status varchar2(1) -- 账户状态
    ,acct_type varchar2(1) -- 账户类型
    ,base_acct_no varchar2(64) -- 交易账号/卡号
    ,business_unit varchar2(10) -- 账套
    ,card_no varchar2(50) -- 卡号
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,doc_type varchar2(10) -- 凭证类型
    ,document_id varchar2(60) -- 证件号码
    ,document_type varchar2(4) -- 客户证件类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reason_code varchar2(10) -- 账户用途
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_status varchar2(3) -- 凭证状态
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,acct_class varchar2(1) -- 账户等级
    ,acct_desc varchar2(200) -- 账户描述
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,acct_license_no varchar2(50) -- 账户许可证号
    ,acct_nature varchar2(10) -- 存款账户类型
    ,acct_real_flag varchar2(1) -- 账户虚实标志
    ,acct_res_status varchar2(1) -- 账户限制标志
    ,acct_status_prev varchar2(1) -- 账户上一状态
    ,acct_stop_pay varchar2(1) -- 账户余额止付标志
    ,addtl_principal varchar2(1) -- 是否允许增加本金
    ,agreement_id varchar2(50) -- 协议编号
    ,all_dep_ind varchar2(1) -- 通存标志
    ,all_dra_ind varchar2(1) -- 通兑标志
    ,appr_flag varchar2(1) -- 复核标志
    ,appr_letter_no varchar2(30) -- 核准件编号
    ,auto_renew_rollover varchar2(1) -- 自动转存方式
    ,auto_settle_flag varchar2(1) -- 自动结清标志
    ,bal_type varchar2(2) -- 余额类型
    ,checked_flag varchar2(1) -- 黑名单是否已检查标志位
    ,company varchar2(20) -- 法人
    ,cur_stage_no number(4) -- 当前期数
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,gl_type varchar2(1) -- 总账类型
    ,impound_fad varchar2(1) -- 强制扣划导致违约状态
    ,individual_flag varchar2(1) -- 对公对私标志
    ,int_ind_flag varchar2(1) -- 是否计息
    ,joint_acct_flag varchar2(1) -- 联合账户标志
    ,last_mvmt_status varchar2(1) -- 定期账户上一次更改状态
    ,lead_acct_flag varchar2(1) -- 主账户标志
    ,main_bal_flag varchar2(1) -- 主账户是否带余额
    ,main_int_flag varchar2(1) -- 主账户是否带利息
    ,management_free_flag varchar2(1) -- 对公免收管理费标志，对私免收管理费和卡年费标识
    ,multi_bal_type_flag varchar2(1) -- 是否多余额
    ,no_tran_flag varchar2(1) -- 6个月无交易标志
    ,osa_flag varchar2(1) -- 离岸标记
    ,ownership_type varchar2(2) -- 归属种类
    ,partial_renew_roll varchar2(1) -- 是否部分本金转存
    ,prefix varchar2(10) -- 前缀
    ,recover_flag varchar2(1) -- 实时追缴标志字段
    ,region_flag varchar2(1) -- 区内区外标记
    ,renew_no number(5) -- 本金转存次数
    ,rollover_no number(5) -- 本息转存次数
    ,settle varchar2(1) -- 结算标志
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,terminal_id varchar2(50) -- 交易终端编号
    ,times_renewed number(5) -- 已本金转存次数
    ,times_rolledover number(5) -- 已本息转存次数
    ,xrate_id varchar2(1) -- 汇兑方式
    ,accounting_status varchar2(3) -- 核算状态
    ,accounting_status_prev varchar2(3) -- 上次核算状态
    ,fixed_call varchar2(1) -- 定期账户细类
    ,accounting_status_upd_date date -- 核算状态变更日期
    ,acct_close_date date -- 销户日期
    ,acct_due_date date -- 账户有效日期
    ,acct_license_date date -- 账户许可证签发日期
    ,acct_open_date date -- 账户开户日期
    ,acct_status_upd_date date -- 账户状态变更日期
    ,approval_date date -- 复核日期
    ,dormant_date date -- 转不动户日期
    ,effect_date date -- 产品生效日期
    ,last_change_date date -- 最后修改日期
    ,last_tran_date date -- 最后交易日期
    ,maturity_date date -- 到期日期
    ,open_tran_date date -- 开户后首次交易日期
    ,ori_maturity_date date -- 账户原始到期日期
    ,orig_acct_open_date date -- 账户原始开立日期
    ,settle_date date -- 结算日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,iss_country varchar2(3) -- 发证国家
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,acct_close_reason varchar2(300) -- 关闭原因
    ,acct_close_user_id varchar2(8) -- 账户销户操作柜员
    ,alt_acct_name varchar2(200) -- 备用账户名称
    ,appr_user_id varchar2(8) -- 复核柜员
    ,home_branch varchar2(12) -- 客户管理行
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,main_prod_type varchar2(12) -- 卡产品代码
    ,mm_ref_no varchar2(50) -- 资金交易参考号
    ,notice_period varchar2(5) -- 通知期限
    ,old_prod_type varchar2(12) -- 原产品类型
    ,parent_internal_key number(15) -- 上级账户标识符
    ,settle_user_id varchar2(8) -- 结算柜员
    ,voucher_start_no varchar2(50) -- 凭证起始号码
    ,xrate number(15,8) -- 汇率
    ,apply_branch varchar2(12) -- 申请机构
    ,acct_name_prefix varchar2(50) -- 账户名称前缀
    ,acct_name_suffix varchar2(500) -- 账户名称后缀
    ,open_user_id varchar2(8) -- 开户柜员编号
    ,acct_property2 varchar2(10) -- 账户性质2
    ,amend_date date -- 变更日期
    ,is_med_ins_flag varchar2(1) -- 是否医保账户标志
    ,is_travel_card_flag varchar2(1) -- 是否旅行通账户标志
    ,travel_due_date date -- 旅行通卡有效期
    ,is_soc_fin_flag varchar2(1) -- 是否为社保卡下金融账户标志
    ,to_out_flag varchar2(3) -- 
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
grant select on ${iol_schema}.ncbs_rb_acct to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct is '账户基本信息表';
comment on column ${iol_schema}.ncbs_rb_acct.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_acct.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_acct.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_acct.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct.business_unit is '账套';
comment on column ${iol_schema}.ncbs_rb_acct.card_no is '卡号';
comment on column ${iol_schema}.ncbs_rb_acct.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_acct.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_acct.document_id is '证件号码';
comment on column ${iol_schema}.ncbs_rb_acct.document_type is '客户证件类型';
comment on column ${iol_schema}.ncbs_rb_acct.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_rb_acct.reason_code is '账户用途';
comment on column ${iol_schema}.ncbs_rb_acct.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct.voucher_status is '凭证状态';
comment on column ${iol_schema}.ncbs_rb_acct.term is '存期';
comment on column ${iol_schema}.ncbs_rb_acct.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_acct.acct_class is '账户等级';
comment on column ${iol_schema}.ncbs_rb_acct.acct_desc is '账户描述';
comment on column ${iol_schema}.ncbs_rb_acct.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_rb_acct.acct_license_no is '账户许可证号';
comment on column ${iol_schema}.ncbs_rb_acct.acct_nature is '存款账户类型';
comment on column ${iol_schema}.ncbs_rb_acct.acct_real_flag is '账户虚实标志';
comment on column ${iol_schema}.ncbs_rb_acct.acct_res_status is '账户限制标志';
comment on column ${iol_schema}.ncbs_rb_acct.acct_status_prev is '账户上一状态';
comment on column ${iol_schema}.ncbs_rb_acct.acct_stop_pay is '账户余额止付标志';
comment on column ${iol_schema}.ncbs_rb_acct.addtl_principal is '是否允许增加本金';
comment on column ${iol_schema}.ncbs_rb_acct.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_acct.all_dep_ind is '通存标志';
comment on column ${iol_schema}.ncbs_rb_acct.all_dra_ind is '通兑标志';
comment on column ${iol_schema}.ncbs_rb_acct.appr_flag is '复核标志';
comment on column ${iol_schema}.ncbs_rb_acct.appr_letter_no is '核准件编号';
comment on column ${iol_schema}.ncbs_rb_acct.auto_renew_rollover is '自动转存方式';
comment on column ${iol_schema}.ncbs_rb_acct.auto_settle_flag is '自动结清标志';
comment on column ${iol_schema}.ncbs_rb_acct.bal_type is '余额类型';
comment on column ${iol_schema}.ncbs_rb_acct.checked_flag is '黑名单是否已检查标志位';
comment on column ${iol_schema}.ncbs_rb_acct.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct.cur_stage_no is '当前期数';
comment on column ${iol_schema}.ncbs_rb_acct.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_rb_acct.gl_type is '总账类型';
comment on column ${iol_schema}.ncbs_rb_acct.impound_fad is '强制扣划导致违约状态';
comment on column ${iol_schema}.ncbs_rb_acct.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_rb_acct.int_ind_flag is '是否计息';
comment on column ${iol_schema}.ncbs_rb_acct.joint_acct_flag is '联合账户标志';
comment on column ${iol_schema}.ncbs_rb_acct.last_mvmt_status is '定期账户上一次更改状态';
comment on column ${iol_schema}.ncbs_rb_acct.lead_acct_flag is '主账户标志';
comment on column ${iol_schema}.ncbs_rb_acct.main_bal_flag is '主账户是否带余额';
comment on column ${iol_schema}.ncbs_rb_acct.main_int_flag is '主账户是否带利息';
comment on column ${iol_schema}.ncbs_rb_acct.management_free_flag is '对公免收管理费标志，对私免收管理费和卡年费标识';
comment on column ${iol_schema}.ncbs_rb_acct.multi_bal_type_flag is '是否多余额';
comment on column ${iol_schema}.ncbs_rb_acct.no_tran_flag is '6个月无交易标志';
comment on column ${iol_schema}.ncbs_rb_acct.osa_flag is '离岸标记';
comment on column ${iol_schema}.ncbs_rb_acct.ownership_type is '归属种类';
comment on column ${iol_schema}.ncbs_rb_acct.partial_renew_roll is '是否部分本金转存';
comment on column ${iol_schema}.ncbs_rb_acct.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_acct.recover_flag is '实时追缴标志字段';
comment on column ${iol_schema}.ncbs_rb_acct.region_flag is '区内区外标记';
comment on column ${iol_schema}.ncbs_rb_acct.renew_no is '本金转存次数';
comment on column ${iol_schema}.ncbs_rb_acct.rollover_no is '本息转存次数';
comment on column ${iol_schema}.ncbs_rb_acct.settle is '结算标志';
comment on column ${iol_schema}.ncbs_rb_acct.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_acct.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_acct.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_rb_acct.times_renewed is '已本金转存次数';
comment on column ${iol_schema}.ncbs_rb_acct.times_rolledover is '已本息转存次数';
comment on column ${iol_schema}.ncbs_rb_acct.xrate_id is '汇兑方式';
comment on column ${iol_schema}.ncbs_rb_acct.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_rb_acct.accounting_status_prev is '上次核算状态';
comment on column ${iol_schema}.ncbs_rb_acct.fixed_call is '定期账户细类';
comment on column ${iol_schema}.ncbs_rb_acct.accounting_status_upd_date is '核算状态变更日期';
comment on column ${iol_schema}.ncbs_rb_acct.acct_close_date is '销户日期';
comment on column ${iol_schema}.ncbs_rb_acct.acct_due_date is '账户有效日期';
comment on column ${iol_schema}.ncbs_rb_acct.acct_license_date is '账户许可证签发日期';
comment on column ${iol_schema}.ncbs_rb_acct.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_rb_acct.acct_status_upd_date is '账户状态变更日期';
comment on column ${iol_schema}.ncbs_rb_acct.approval_date is '复核日期';
comment on column ${iol_schema}.ncbs_rb_acct.dormant_date is '转不动户日期';
comment on column ${iol_schema}.ncbs_rb_acct.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_acct.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_acct.last_tran_date is '最后交易日期';
comment on column ${iol_schema}.ncbs_rb_acct.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_rb_acct.open_tran_date is '开户后首次交易日期';
comment on column ${iol_schema}.ncbs_rb_acct.ori_maturity_date is '账户原始到期日期';
comment on column ${iol_schema}.ncbs_rb_acct.orig_acct_open_date is '账户原始开立日期';
comment on column ${iol_schema}.ncbs_rb_acct.settle_date is '结算日期';
comment on column ${iol_schema}.ncbs_rb_acct.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct.iss_country is '发证国家';
comment on column ${iol_schema}.ncbs_rb_acct.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_acct.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct.acct_close_reason is '关闭原因';
comment on column ${iol_schema}.ncbs_rb_acct.acct_close_user_id is '账户销户操作柜员';
comment on column ${iol_schema}.ncbs_rb_acct.alt_acct_name is '备用账户名称';
comment on column ${iol_schema}.ncbs_rb_acct.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_acct.home_branch is '客户管理行';
comment on column ${iol_schema}.ncbs_rb_acct.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_acct.main_prod_type is '卡产品代码';
comment on column ${iol_schema}.ncbs_rb_acct.mm_ref_no is '资金交易参考号';
comment on column ${iol_schema}.ncbs_rb_acct.notice_period is '通知期限';
comment on column ${iol_schema}.ncbs_rb_acct.old_prod_type is '原产品类型';
comment on column ${iol_schema}.ncbs_rb_acct.parent_internal_key is '上级账户标识符';
comment on column ${iol_schema}.ncbs_rb_acct.settle_user_id is '结算柜员';
comment on column ${iol_schema}.ncbs_rb_acct.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_rb_acct.xrate is '汇率';
comment on column ${iol_schema}.ncbs_rb_acct.apply_branch is '申请机构';
comment on column ${iol_schema}.ncbs_rb_acct.acct_name_prefix is '账户名称前缀';
comment on column ${iol_schema}.ncbs_rb_acct.acct_name_suffix is '账户名称后缀';
comment on column ${iol_schema}.ncbs_rb_acct.open_user_id is '开户柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct.acct_property2 is '账户性质2';
comment on column ${iol_schema}.ncbs_rb_acct.amend_date is '变更日期';
comment on column ${iol_schema}.ncbs_rb_acct.is_med_ins_flag is '是否医保账户标志';
comment on column ${iol_schema}.ncbs_rb_acct.is_travel_card_flag is '是否旅行通账户标志';
comment on column ${iol_schema}.ncbs_rb_acct.travel_due_date is '旅行通卡有效期';
comment on column ${iol_schema}.ncbs_rb_acct.is_soc_fin_flag is '是否为社保卡下金融账户标志';
comment on column ${iol_schema}.ncbs_rb_acct.to_out_flag is '';
comment on column ${iol_schema}.ncbs_rb_acct.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_acct.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_acct.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_acct.etl_timestamp is 'ETL处理时间戳';
