/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_acct_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_acct_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_acct_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_acct_detail(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,agreement_id varchar2(50) -- 协议编号
    ,company varchar2(20) -- 法人
    ,cyc_ctrl_flag varchar2(1) -- 是否循环使用限额标志
    ,down_max_senece varchar2(5) -- 下拨最大场次
    ,down_method varchar2(2) -- 下拨方法
    ,down_mod_unit varchar2(10) -- 取整单位
    ,down_plan varchar2(3) -- 下拨策略
    ,effect_flag varchar2(1) -- 是否生效标志
    ,inc_exp_ind varchar2(1) -- 收支标志
    ,inner_price_flag varchar2(1) -- 是否开通内部计价
    ,inner_price_mode varchar2(1) -- 内部计价模式
    ,inner_price_way varchar2(1) -- 计价方式
    ,int_calc_bal varchar2(2) -- 计息方式
    ,limit_mode varchar2(2) -- 额度管理模式
    ,open_ctrl varchar2(1) -- 开户是否开通限额
    ,open_limit varchar2(1) -- 是否开通额度
    ,payment_flag varchar2(1) -- 备款顺序
    ,pcp_acct_status varchar2(1) -- 资金池账户状态
    ,pcp_agreement_flag varchar2(5) -- 现金池协议标志
    ,price_freq varchar2(5) -- 计价频率
    ,seq_no varchar2(50) -- 序号
    ,up_max_senece number(5) -- 归集最大场次
    ,up_method varchar2(2) -- 归集方法
    ,up_plan varchar2(3) -- 归集策略
    ,down_time varchar2(6) -- 下拨时点
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,up_time varchar2(6) -- 归集时点
    ,acct_ccy varchar2(3) -- 账户币种
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,cr_rate number(15,8) -- 贷方利率
    ,down_day varchar2(2) -- 下拨日
    ,down_fixed_amt number(17,2) -- 下拨固定金额
    ,down_freq varchar2(5) -- 下拨频率
    ,down_remain_amt number(17,2) -- 下拨留底金额
    ,dr_rate number(15,8) -- 借方利率
    ,over_limit_amt number(17,2) -- 超额额度
    ,price_day varchar2(2) -- 报价日
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,up_day varchar2(2) -- 归集日
    ,up_fixed_amt number(17,2) -- 归集固定金额
    ,up_freq varchar2(5) -- 归集频率
    ,up_prop number(11,7) -- 归集比例
    ,up_remain_amt number(17,2) -- 归集留底金额
    ,payment_method varchar2(2) -- 请款方法
    ,payment_plan varchar2(3) -- 请款策略
    ,up_limit_amt number(17,2) -- 归集限制金额
    ,min_exe_amt number(17,2) -- 最小执行额度
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
grant select on ${iol_schema}.ncbs_rb_pcp_acct_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_acct_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_acct_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_acct_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_acct_detail is '资金池分户信息表';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.cyc_ctrl_flag is '是否循环使用限额标志';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.down_max_senece is '下拨最大场次';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.down_method is '下拨方法';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.down_mod_unit is '取整单位';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.down_plan is '下拨策略';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.effect_flag is '是否生效标志';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.inc_exp_ind is '收支标志';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.inner_price_flag is '是否开通内部计价';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.inner_price_mode is '内部计价模式';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.inner_price_way is '计价方式';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.int_calc_bal is '计息方式';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.limit_mode is '额度管理模式';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.open_ctrl is '开户是否开通限额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.open_limit is '是否开通额度';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.payment_flag is '备款顺序';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.pcp_acct_status is '资金池账户状态';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.pcp_agreement_flag is '现金池协议标志';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.price_freq is '计价频率';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.up_max_senece is '归集最大场次';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.up_method is '归集方法';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.up_plan is '归集策略';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.down_time is '下拨时点';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.up_time is '归集时点';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.cr_rate is '贷方利率';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.down_day is '下拨日';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.down_fixed_amt is '下拨固定金额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.down_freq is '下拨频率';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.down_remain_amt is '下拨留底金额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.dr_rate is '借方利率';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.over_limit_amt is '超额额度';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.price_day is '报价日';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.up_day is '归集日';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.up_fixed_amt is '归集固定金额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.up_freq is '归集频率';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.up_prop is '归集比例';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.up_remain_amt is '归集留底金额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.payment_method is '请款方法';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.payment_plan is '请款策略';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.up_limit_amt is '归集限制金额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.min_exe_amt is '最小执行额度';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_detail.etl_timestamp is 'ETL处理时间戳';
