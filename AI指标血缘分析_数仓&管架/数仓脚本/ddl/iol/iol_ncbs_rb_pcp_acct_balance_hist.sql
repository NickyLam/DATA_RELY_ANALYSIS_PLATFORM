/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_acct_balance_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_acct_balance_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_acct_balance_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_acct_balance_hist(
    client_no varchar2(16) -- 客户编号
    ,company varchar2(20) -- 法人
    ,pcp_group_id varchar2(30) -- 资金池账户组id
    ,seq_no varchar2(50) -- 序号
    ,last_change_date date -- 最后修改日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,last_pcp_balance number(17,2) -- 上日账户余额
    ,last_total_down_amt number(17,2) -- 上日累计下拨金额
    ,last_total_up_amt number(17,2) -- 上日累计归集金额
    ,pcp_balance number(17,2) -- 资金池账户余额
    ,total_down_amt number(17,2) -- 累计下拨金额
    ,total_up_amt number(17,2) -- 累计归集金额
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
grant select on ${iol_schema}.ncbs_rb_pcp_acct_balance_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_acct_balance_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_acct_balance_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_acct_balance_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_acct_balance_hist is '资金池账户余额表历史表';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.pcp_group_id is '资金池账户组id';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.last_pcp_balance is '上日账户余额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.last_total_down_amt is '上日累计下拨金额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.last_total_up_amt is '上日累计归集金额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.pcp_balance is '资金池账户余额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.total_down_amt is '累计下拨金额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.total_up_amt is '累计归集金额';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_pcp_acct_balance_hist.etl_timestamp is 'ETL处理时间戳';
