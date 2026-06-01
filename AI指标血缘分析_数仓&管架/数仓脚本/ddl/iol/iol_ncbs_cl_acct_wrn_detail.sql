/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_wrn_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_wrn_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_wrn_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_wrn_detail(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,seq_no varchar2(50) -- 序号
    ,wrn_type varchar2(3) -- 核销类型
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,wrn_date date -- 贷款核销日期
    ,wrn_amt number(17,2) -- 贷款核销本金
    ,wrn_amt_prev number(17,2) -- 上日核销本金
    ,wrn_int_amt number(17,2) -- 核销正常利息
    ,wrn_int_amt_prev number(17,2) -- 上日核销正常利息
    ,wrn_odi_amt number(17,2) -- 核销复利利息
    ,wrn_odi_amt_prev number(17,2) -- 上日核销复利利息
    ,wrn_ododi_amt number(17,2) -- 核销复利的复利
    ,wrn_ododi_amt_prev number(17,2) -- 上日核销复利的复利
    ,wrn_ododp_amt number(17,2) -- 核销罚息的复利
    ,wrn_ododp_amt_prev number(17,2) -- 上日核销罚息的复利
    ,wrn_odp_amt number(17,2) -- 核销罚息利息
    ,wrn_odp_amt_prev number(17,2) -- 上日核销罚息利息
    ,wrn_time_ododi_amt number(17,2) -- 核销时点复利的复利金额
    ,wrn_time_ododp_amt number(17,2) -- 核销时点罚息的复利金额
    ,wrn_time_odi_amt number(17,2) -- 核销时点复利金额
    ,wrn_time_odp_amt number(17,2) -- 核销时点罚息金额
    ,wrn_time_int_amt number(17,2) -- 核销时点利息金额
    ,wrn_time_amt number(17,2) -- 核销时点金额
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
grant select on ${iol_schema}.ncbs_cl_acct_wrn_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_wrn_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_wrn_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_wrn_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_wrn_detail is '贷款核销信息登记表';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_type is '核销类型';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_date is '贷款核销日期';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_amt is '贷款核销本金';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_amt_prev is '上日核销本金';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_int_amt is '核销正常利息';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_int_amt_prev is '上日核销正常利息';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_odi_amt is '核销复利利息';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_odi_amt_prev is '上日核销复利利息';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_ododi_amt is '核销复利的复利';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_ododi_amt_prev is '上日核销复利的复利';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_ododp_amt is '核销罚息的复利';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_ododp_amt_prev is '上日核销罚息的复利';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_odp_amt is '核销罚息利息';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_odp_amt_prev is '上日核销罚息利息';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_time_ododi_amt is '核销时点复利的复利金额';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_time_ododp_amt is '核销时点罚息的复利金额';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_time_odi_amt is '核销时点复利金额';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_time_odp_amt is '核销时点罚息金额';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_time_int_amt is '核销时点利息金额';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.wrn_time_amt is '核销时点金额';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_wrn_detail.etl_timestamp is 'ETL处理时间戳';
