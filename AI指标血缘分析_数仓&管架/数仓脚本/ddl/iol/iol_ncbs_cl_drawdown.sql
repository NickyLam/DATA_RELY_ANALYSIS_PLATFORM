/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_drawdown
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_drawdown
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_drawdown purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_drawdown(
    ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,dd_no number(5) -- 发放号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,cmisloan_no varchar2(60) -- 客户借据编号
    ,company varchar2(20) -- 法人
    ,counter number(5) -- 序号
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,dd_method varchar2(2) -- 发放方式
    ,event_type varchar2(20) -- 事件类型
    ,is_one_dd_flag varchar2(1) -- 是否一次性开立发放
    ,lender varchar2(100) -- 贷款人
    ,reversal varchar2(1) -- 是否冲正标志
    ,dd_date date -- 贷款发放日期
    ,maturity_date date -- 到期日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,dd_amt number(17,2) -- 发放金额
    ,distinct_int number(17,2) -- 贷款贴现利息
    ,loan_no varchar2(50) -- 贷款号
    ,reversal_reason varchar2(200) -- 冲正原因
    ,reversal_user_id varchar2(8) -- 冲正柜员
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_cl_drawdown to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_drawdown to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_drawdown to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_drawdown to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_drawdown is '贷款发放表';
comment on column ${iol_schema}.ncbs_cl_drawdown.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_drawdown.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_drawdown.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_drawdown.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_drawdown.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_drawdown.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_drawdown.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cl_drawdown.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_drawdown.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_cl_drawdown.company is '法人';
comment on column ${iol_schema}.ncbs_cl_drawdown.counter is '序号';
comment on column ${iol_schema}.ncbs_cl_drawdown.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_cl_drawdown.dd_method is '发放方式';
comment on column ${iol_schema}.ncbs_cl_drawdown.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_cl_drawdown.is_one_dd_flag is '是否一次性开立发放';
comment on column ${iol_schema}.ncbs_cl_drawdown.lender is '贷款人';
comment on column ${iol_schema}.ncbs_cl_drawdown.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_cl_drawdown.dd_date is '贷款发放日期';
comment on column ${iol_schema}.ncbs_cl_drawdown.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_cl_drawdown.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_drawdown.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_drawdown.dd_amt is '发放金额';
comment on column ${iol_schema}.ncbs_cl_drawdown.distinct_int is '贷款贴现利息';
comment on column ${iol_schema}.ncbs_cl_drawdown.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_drawdown.reversal_reason is '冲正原因';
comment on column ${iol_schema}.ncbs_cl_drawdown.reversal_user_id is '冲正柜员';
comment on column ${iol_schema}.ncbs_cl_drawdown.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cl_drawdown.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_drawdown.etl_timestamp is 'ETL处理时间戳';
