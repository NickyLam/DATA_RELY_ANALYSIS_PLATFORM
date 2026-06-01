/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_syn_drawdown
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_syn_drawdown
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_syn_drawdown purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_syn_drawdown(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,lender varchar2(100) -- 贷款人
    ,mian_dd_no number(5) -- 银团贷款主发放号
    ,sub_dd_no number(5) -- 银团贷款子发放号
    ,syn_type varchar2(1) -- 银团贷款标志
    ,acct_open_date date -- 账户开户日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,contributive_ratio number(11,7) -- 出资比例
    ,dd_amt number(17,2) -- 发放金额
    ,loan_no varchar2(50) -- 贷款号
    ,main_internal_key number(15) -- 主账户内部键值
    ,lender_name varchar2(200) -- 贷款人名称
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
grant select on ${iol_schema}.ncbs_cl_syn_drawdown to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_syn_drawdown to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_syn_drawdown to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_syn_drawdown to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_syn_drawdown is '银团贷款发放表';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.company is '法人';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.lender is '贷款人';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.mian_dd_no is '银团贷款主发放号';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.sub_dd_no is '银团贷款子发放号';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.syn_type is '银团贷款标志';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.contributive_ratio is '出资比例';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.dd_amt is '发放金额';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.main_internal_key is '主账户内部键值';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.lender_name is '贷款人名称';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_syn_drawdown.etl_timestamp is 'ETL处理时间戳';
