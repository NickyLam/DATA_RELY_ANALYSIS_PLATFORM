/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_agreement
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_agreement
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_agreement purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_agreement(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_int_flag varchar2(1) -- 计息标志
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_status varchar2(2) -- 协议状态
    ,cash_pool_attr varchar2(1) -- 资金池属性
    ,company varchar2(20) -- 法人
    ,cyc_ctrl_flag varchar2(1) -- 是否循环使用限额标志
    ,down_max_senece varchar2(5) -- 下拨最大场次
    ,down_method varchar2(2) -- 下拨方法
    ,down_mod_unit varchar2(10) -- 取整单位
    ,down_plan varchar2(3) -- 下拨策略
    ,inner_price_flag varchar2(1) -- 是否开通内部计价
    ,inner_price_mode varchar2(1) -- 内部计价模式
    ,inner_price_way varchar2(1) -- 计价方式
    ,int_calc_bal varchar2(2) -- 计息方式
    ,limit_mode varchar2(2) -- 额度管理模式
    ,open_ctrl varchar2(1) -- 开户是否开通限额
    ,open_limit varchar2(1) -- 是否开通额度
    ,pcp_group_id varchar2(30) -- 资金池账户组id
    ,price_freq varchar2(5) -- 计价频率
    ,up_max_senece number(5) -- 归集最大场次
    ,up_method varchar2(2) -- 归集方法
    ,up_plan varchar2(3) -- 归集策略
    ,down_time varchar2(6) -- 下拨时点
    ,effect_date date -- 产品生效日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,up_time varchar2(6) -- 归集时点
    ,acct_ccy varchar2(3) -- 账户币种
    ,agree_int_rate number(15,8) -- 协议利率
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,cr_rate number(15,8) -- 贷方利率
    ,down_day varchar2(2) -- 下拨日
    ,down_fixed_amt number(17,2) -- 下拨固定金额
    ,down_freq varchar2(5) -- 下拨频率
    ,down_remain_amt number(17,2) -- 下拨留底金额
    ,dr_rate number(15,8) -- 借方利率
    ,new_settle_base_acct_no varchar2(50) -- 新利息入账账号
    ,over_limit_amt number(17,2) -- 超额额度
    ,pcp_prod_type varchar2(12) -- 资金池产品类型
    ,price_day varchar2(2) -- 报价日
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,up_day varchar2(2) -- 归集日
    ,up_fixed_amt number(17,2) -- 归集固定金额
    ,up_freq varchar2(5) -- 归集频率
    ,up_prop number(11,7) -- 归集比例
    ,up_remain_amt number(17,2) -- 归集留底金额
    ,approval_no varchar2(50) -- 审批单号
    ,merge_cycle_flag varchar2(2) -- 合并结息标识y-合并n-不合并
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
grant select on ${iol_schema}.ncbs_rb_pcp_agreement to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_agreement to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_agreement to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_agreement to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_agreement is '资金池协议表';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.acct_int_flag is '计息标志';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.cash_pool_attr is '资金池属性';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.cyc_ctrl_flag is '是否循环使用限额标志';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.down_max_senece is '下拨最大场次';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.down_method is '下拨方法';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.down_mod_unit is '取整单位';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.down_plan is '下拨策略';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.inner_price_flag is '是否开通内部计价';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.inner_price_mode is '内部计价模式';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.inner_price_way is '计价方式';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.int_calc_bal is '计息方式';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.limit_mode is '额度管理模式';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.open_ctrl is '开户是否开通限额';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.open_limit is '是否开通额度';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.pcp_group_id is '资金池账户组id';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.price_freq is '计价频率';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.up_max_senece is '归集最大场次';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.up_method is '归集方法';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.up_plan is '归集策略';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.down_time is '下拨时点';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.up_time is '归集时点';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.agree_int_rate is '协议利率';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.cr_rate is '贷方利率';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.down_day is '下拨日';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.down_fixed_amt is '下拨固定金额';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.down_freq is '下拨频率';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.down_remain_amt is '下拨留底金额';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.dr_rate is '借方利率';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.new_settle_base_acct_no is '新利息入账账号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.over_limit_amt is '超额额度';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.pcp_prod_type is '资金池产品类型';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.price_day is '报价日';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.up_day is '归集日';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.up_fixed_amt is '归集固定金额';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.up_freq is '归集频率';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.up_prop is '归集比例';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.up_remain_amt is '归集留底金额';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.approval_no is '审批单号';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.merge_cycle_flag is '合并结息标识y-合并n-不合并';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_pcp_agreement.etl_timestamp is 'ETL处理时间戳';
