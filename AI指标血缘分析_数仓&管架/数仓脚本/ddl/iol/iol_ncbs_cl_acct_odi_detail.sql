/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_odi_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_odi_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_odi_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_odi_detail(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,int_accrued_diff number(15,10) -- 计提金额差额
    ,narrative varchar2(400) -- 摘要
    ,stage_no number(5) -- 期次
    ,tax_type varchar2(2) -- 税种
    ,int_class varchar2(6) -- 利息分类
    ,calc_begin_date date -- 利息计算起始日
    ,calc_end_date date -- 利息计算截止日
    ,last_accrual_date date -- 上一利息计提日
    ,last_change_date date -- 最后修改日期
    ,last_cycle_date date -- 上一结息日
    ,next_cycle_date date -- 下一结息日
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,int_accrued number(17,2) -- 累计计提
    ,int_accrued_calc_ctd number(25,10) -- 计提日计提实际金额
    ,int_accrued_ctd number(17,2) -- 计提日计提利息
    ,int_adj number(17,2) -- 利息调增金额
    ,int_adj_ctd number(17,2) -- 计提日利息调整
    ,int_adj_prev number(17,2) -- 上日利息调整(累计)
    ,int_amt number(17,2) -- 利息金额
    ,int_posted number(17,2) -- 结息金额
    ,int_posted_ctd number(17,2) -- 结息日利息金额
    ,tax_posted number(17,2) -- 利息税累计金额
    ,tax_posted_ctd number(17,2) -- 结息日利息税
    ,tax_rate number(15,8) -- 税率
    ,wrn_amt number(17,2) -- 贷款核销本金
    ,int_accrued_prev number(17,2) -- 上日累计计提利息|上日累计计提利息
    ,last_bal_upd_date date -- 上次动户日期
    ,last_int_accrued_prev number(17,2) -- 上上日累计计提利息
    ,last_int_adj_prev number(17,2) -- 上上日利息累计计提调整
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
grant select on ${iol_schema}.ncbs_cl_acct_odi_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_odi_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_odi_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_odi_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_odi_detail is '复利计息表';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_accrued_diff is '计提金额差额';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.stage_no is '期次';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.tax_type is '税种';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.calc_begin_date is '利息计算起始日';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.calc_end_date is '利息计算截止日';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.last_accrual_date is '上一利息计提日';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.last_cycle_date is '上一结息日';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.next_cycle_date is '下一结息日';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_accrued is '累计计提';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_accrued_calc_ctd is '计提日计提实际金额';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_accrued_ctd is '计提日计提利息';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_adj is '利息调增金额';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_adj_ctd is '计提日利息调整';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_adj_prev is '上日利息调整(累计)';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_posted is '结息金额';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_posted_ctd is '结息日利息金额';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.tax_posted is '利息税累计金额';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.tax_posted_ctd is '结息日利息税';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.wrn_amt is '贷款核销本金';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.int_accrued_prev is '上日累计计提利息|上日累计计提利息';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.last_bal_upd_date is '上次动户日期';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.last_int_accrued_prev is '上上日累计计提利息';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.last_int_adj_prev is '上上日利息累计计提调整';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_odi_detail.etl_timestamp is 'ETL处理时间戳';
