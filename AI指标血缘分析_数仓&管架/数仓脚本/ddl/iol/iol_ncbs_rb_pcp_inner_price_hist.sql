/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_inner_price_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_inner_price_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_inner_price_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_inner_price_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,day_expense_diff number(15,10) -- 当日应付差额
    ,day_income_diff number(15,10) -- 当日应收差额
    ,int_calc_bal varchar2(2) -- 计息方式
    ,pcp_group_id varchar2(30) -- 资金池账户组id
    ,seq_no varchar2(50) -- 序号
    ,transfer_cnt number(5) -- 周期内已划拨次数
    ,last_price_date date -- 上一计价日
    ,next_price_date date -- 下一计价日
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,auth_user_id varchar2(8) -- 授权柜员
    ,cr_rate number(15,8) -- 贷方利率
    ,day_int_expense number(17,2) -- 当日应付利息
    ,day_int_income number(17,2) -- 当日应收利息
    ,dr_rate number(15,8) -- 借方利率
    ,now_balance_agg number(38,2) -- 当前余额积数
    ,now_down_agg number(38,2) -- 当前下拨积数
    ,now_up_agg number(38,2) -- 当前归集积数
    ,period_int_expense number(17,2) -- 当期累计利息支出
    ,period_int_income number(17,2) -- 当期累计利息收入
    ,total_arre_expense number(17,2) -- 欠付
    ,total_arre_income number(17,2) -- 欠收
    ,total_int_expense number(17,2) -- 累计利息支出
    ,total_int_income number(17,2) -- 累计利息收入
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_pcp_inner_price_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_inner_price_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_inner_price_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_inner_price_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_inner_price_hist is '资金池账户计价表历史表';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.day_expense_diff is '当日应付差额';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.day_income_diff is '当日应收差额';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.int_calc_bal is '计息方式';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.pcp_group_id is '资金池账户组id';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.transfer_cnt is '周期内已划拨次数';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.last_price_date is '上一计价日';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.next_price_date is '下一计价日';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.cr_rate is '贷方利率';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.day_int_expense is '当日应付利息';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.day_int_income is '当日应收利息';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.dr_rate is '借方利率';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.now_balance_agg is '当前余额积数';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.now_down_agg is '当前下拨积数';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.now_up_agg is '当前归集积数';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.period_int_expense is '当期累计利息支出';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.period_int_income is '当期累计利息收入';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.total_arre_expense is '欠付';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.total_arre_income is '欠收';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.total_int_expense is '累计利息支出';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.total_int_income is '累计利息收入';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_pcp_inner_price_hist.etl_timestamp is 'ETL处理时间戳';
