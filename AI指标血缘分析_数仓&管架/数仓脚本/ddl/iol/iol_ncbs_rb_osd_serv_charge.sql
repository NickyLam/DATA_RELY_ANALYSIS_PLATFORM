/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_osd_serv_charge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_osd_serv_charge
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_osd_serv_charge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_osd_serv_charge(
    acct_name varchar2(200) -- 账户名称
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,agreement_id varchar2(50) -- 协议编号
    ,bo_ind varchar2(1) -- 日终/联机标志
    ,charge_way varchar2(1) -- 收费方式
    ,company varchar2(20) -- 法人
    ,delay_flag varchar2(1) -- 宽限标志
    ,end_no varchar2(50) -- 终止号码数字串
    ,fee_type varchar2(20) -- 费率类型
    ,osd_seq_no varchar2(50) -- 应收费用序号
    ,osd_status varchar2(1) -- 欠费状态
    ,oth_business_no varchar2(200) -- 对手业务编号
    ,prefix varchar2(10) -- 前缀
    ,primary_tran_seq_no varchar2(50) -- 主交易序号
    ,priority varchar2(20) -- 优先级
    ,profit_allot_flag varchar2(1) -- 是否需要分润
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,sc_discount_type varchar2(10) -- 费用折扣类型
    ,seq_no varchar2(50) -- 序号
    ,tax_type varchar2(2) -- 税种
    ,voucher_sum number(5) -- 凭证合计数
    ,effect_date date -- 产品生效日期
    ,last_change_date date -- 最后修改日期
    ,last_charge_date date -- 上一收费日期
    ,next_charge_date date -- 下一收费日期
    ,reversal_date date -- 冲正日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,charge_day varchar2(2) -- 收费日
    ,charge_period_freq varchar2(5) -- 收费频率
    ,charge_to_acct_seq_no varchar2(5) -- 收费账户序号
    ,charge_to_base_acct_no varchar2(50) -- 收费账号
    ,charge_to_ccy varchar2(3) -- 收费账户币种符
    ,charge_to_internal_key number(15) -- 收费账户标识符
    ,charge_to_prod_type varchar2(12) -- 收费账户产品类型
    ,disc_fee_amt number(17,2) -- 折扣金额
    ,fee_amt number(17,2) -- 费用金额
    ,fee_ccy varchar2(3) -- 收费币种
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,open_branch_percent number(11,7) -- 账户行比例
    ,open_profit_amt number(17,2) -- 账户行分润金额
    ,orig_fee_amt number(17,2) -- 原始费用金额,即折扣前的费用金额
    ,oth_name varchar2(200) -- 对手名称
    ,reversal_auth_user_id varchar2(8) -- 冲正授权柜员
    ,reversal_branch varchar2(12) -- 冲正机构
    ,reversal_user_id varchar2(8) -- 冲正柜员
    ,sc_discount_rate number(11,7) -- 费用折扣率
    ,tax_amt number(17,2) -- 税金
    ,tax_rate number(15,8) -- 税率
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_branch_percent number(11,7) -- 交易行比例,记录百分数
    ,tran_fee_amt number(17,2) -- 原应收费用金额
    ,tran_profit_amt number(17,2) -- 交易行分润金额
    ,unit_price number(17,2) -- 单价
    ,voucher_start_no varchar2(50) -- 凭证起始号码
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
grant select on ${iol_schema}.ncbs_rb_osd_serv_charge to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_osd_serv_charge to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_osd_serv_charge to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_osd_serv_charge to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_osd_serv_charge is '应收费用表';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.bo_ind is '日终/联机标志';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.charge_way is '收费方式';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.company is '法人';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.delay_flag is '宽限标志';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.end_no is '终止号码数字串';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.fee_type is '费率类型';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.osd_seq_no is '应收费用序号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.osd_status is '欠费状态';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.oth_business_no is '对手业务编号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.primary_tran_seq_no is '主交易序号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.priority is '优先级';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.profit_allot_flag is '是否需要分润';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.sc_discount_type is '费用折扣类型';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.tax_type is '税种';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.voucher_sum is '凭证合计数';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.last_charge_date is '上一收费日期';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.next_charge_date is '下一收费日期';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.charge_day is '收费日';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.charge_period_freq is '收费频率';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.charge_to_acct_seq_no is '收费账户序号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.charge_to_base_acct_no is '收费账号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.charge_to_ccy is '收费账户币种符';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.charge_to_internal_key is '收费账户标识符';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.charge_to_prod_type is '收费账户产品类型';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.disc_fee_amt is '折扣金额';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.fee_amt is '费用金额';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.fee_ccy is '收费币种';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.open_branch_percent is '账户行比例';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.open_profit_amt is '账户行分润金额';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.orig_fee_amt is '原始费用金额,即折扣前的费用金额';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.oth_name is '对手名称';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.reversal_auth_user_id is '冲正授权柜员';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.reversal_branch is '冲正机构';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.reversal_user_id is '冲正柜员';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.sc_discount_rate is '费用折扣率';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.tran_branch_percent is '交易行比例,记录百分数';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.tran_fee_amt is '原应收费用金额';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.tran_profit_amt is '交易行分润金额';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.unit_price is '单价';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_osd_serv_charge.etl_timestamp is 'ETL处理时间戳';
