/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_capt_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_capt_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_capt_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_capt_hist(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,agreement_id varchar2(50) -- 协议编号
    ,capt_status varchar2(1) -- 结息状态
    ,company varchar2(20) -- 法人
    ,inner_price_way varchar2(1) -- 计价方式
    ,pcp_group_id varchar2(30) -- 资金池账户组id
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,cr_rate number(15,8) -- 贷方利率
    ,dr_rate number(15,8) -- 借方利率
    ,now_down_agg number(38,2) -- 当前下拨积数
    ,now_up_agg number(38,2) -- 当前归集积数
    ,oth_internal_key number(15) -- 对手账户内部键
    ,price_day varchar2(2) -- 报价日
    ,total_int_expense number(17,2) -- 累计利息支出
    ,total_int_income number(17,2) -- 累计利息收入
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
grant select on ${iol_schema}.ncbs_rb_pcp_capt_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_capt_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_capt_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_capt_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_capt_hist is '资金池结息流水表';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.capt_status is '结息状态';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.inner_price_way is '计价方式';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.pcp_group_id is '资金池账户组id';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.cr_rate is '贷方利率';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.dr_rate is '借方利率';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.now_down_agg is '当前下拨积数';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.now_up_agg is '当前归集积数';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.price_day is '报价日';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.total_int_expense is '累计利息支出';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.total_int_income is '累计利息收入';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_pcp_capt_hist.etl_timestamp is 'ETL处理时间戳';
