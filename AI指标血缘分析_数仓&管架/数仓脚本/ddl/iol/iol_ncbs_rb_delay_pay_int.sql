/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_delay_pay_int
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_delay_pay_int
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_delay_pay_int purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_delay_pay_int(
    internal_key number(15,0) -- 账户内部键值
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,prod_type varchar2(12) -- 产品编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,spec_rate number(15,8) -- 指定收益率
    ,delay_pay_int_type varchar2(1) -- 延迟付息时间类型
    ,spec_day varchar2(2) -- 指定日
    ,calc_days number(5,0) -- 算息天数
    ,effect_date date -- 产品生效日期
    ,expire_date date -- 失效日期
    ,client_no varchar2(16) -- 客户编号
    ,delay_pay_int_amt number(25,10) -- 延期付息利息
    ,delay_total_amt number(17,2) -- 延迟付息累计金额
    ,delay_int_amt_diff number(15,10) -- 延迟付息昨日今日值差额
    ,next_cycle_date date -- 下一结息日
    ,last_cycle_date date -- 上一结息日
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,company varchar2(20) -- 法人
    ,past_interest number(17,2) -- 累计已付利息
    ,user_id varchar2(8) -- 交易柜员编号
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,status varchar2(1) -- 状态
    ,pay_interest number(17,2) -- 应付利息
    ,calc_delay_int_amt number(17,2) -- 当日累计延期付息计算金额
    ,acct_type varchar2(1) -- 账户类型
    ,oth_internal_key number(15,0) -- 对手账户内部键
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_acct_ccy varchar2(3) -- 对方账户币种
    ,reference varchar2(50) -- 交易参考号
    ,min_deposit_amt number(17,2) -- 起点存款金额
    ,min_deposit_term varchar2(5) -- 起点存款期限
    ,merge_cycle_flag varchar2(2) -- 合并结息标识 Y-合并  N-不合并
    ,max_amt number(17,2) -- 最大金额
    ,approval_no varchar2(50) -- 审批单号
    ,idep_agreement_flag varchar2(1) -- 智能存款签约标志
    ,int_float_point number(15,8) -- 利息浮动点
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
grant select on ${iol_schema}.ncbs_rb_delay_pay_int to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_delay_pay_int to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_delay_pay_int to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_delay_pay_int to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_delay_pay_int is '延迟付息登记表';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.spec_rate is '指定收益率';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.delay_pay_int_type is '延迟付息时间类型';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.spec_day is '指定日';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.calc_days is '算息天数';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.expire_date is '失效日期';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.delay_pay_int_amt is '延期付息利息';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.delay_total_amt is '延迟付息累计金额';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.delay_int_amt_diff is '延迟付息昨日今日值差额';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.next_cycle_date is '下一结息日';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.last_cycle_date is '上一结息日';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.company is '法人';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.past_interest is '累计已付利息';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.status is '状态';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.pay_interest is '应付利息';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.calc_delay_int_amt is '当日累计延期付息计算金额';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.acct_type is '账户类型';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.oth_acct_ccy is '对方账户币种';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.min_deposit_amt is '起点存款金额';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.min_deposit_term is '起点存款期限';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.merge_cycle_flag is '合并结息标识 Y-合并  N-不合并';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.max_amt is '最大金额';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.approval_no is '审批单号';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.idep_agreement_flag is '智能存款签约标志';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.int_float_point is '利息浮动点';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_delay_pay_int.etl_timestamp is 'ETL处理时间戳';
