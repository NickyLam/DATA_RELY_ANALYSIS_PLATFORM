/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_inter_bank_balance
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_inter_bank_balance
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_inter_bank_balance purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_inter_bank_balance(
    sum_pay_agent_pri number(17,2) -- 累计已代付本金
    ,sum_pay_agent_odp number(17,2) -- 累计已代付罚息
    ,client_no varchar2(32) -- 客户编号
    ,cmisloan_no varchar2(60) -- 客户借据编号
    ,cr_int number(17,2) -- 当日计提利息
    ,pre_cr_int number(17,2) -- 上日计提利息
    ,sum_int_accrued number(17,2) -- 累计计提利息
    ,sum_pay_agent_int number(17,2) -- 累计已代付利息
    ,pay_agent_pri number(17,2) -- 代付本金
    ,cr_odp number(17,2) -- 当日计提罚息
    ,sum_odp number(17,2) -- 累计计提罚息
    ,sum_odp_adj_amt number(17,2) -- 累计罚息调整金额
    ,sum_interest_adj_amt number(17,2) -- 累计利息调整金额
    ,pre_cr_odp number(17,2) -- 上日计提罚息
    ,inter_bank_busi_no varchar2(400) -- 同业代付业务编号
    ,is_last_pay_agent varchar2(2) -- 是否最后一次代付
    ,timestamp varchar2(52) -- 时间戳
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
grant select on ${iol_schema}.ncbs_cl_inter_bank_balance to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_inter_bank_balance to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_inter_bank_balance to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_inter_bank_balance to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_inter_bank_balance is '同业代付登记簿余额表';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.sum_pay_agent_pri is '累计已代付本金';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.sum_pay_agent_odp is '累计已代付罚息';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.cr_int is '当日计提利息';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.pre_cr_int is '上日计提利息';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.sum_int_accrued is '累计计提利息';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.sum_pay_agent_int is '累计已代付利息';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.pay_agent_pri is '代付本金';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.cr_odp is '当日计提罚息';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.sum_odp is '累计计提罚息';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.sum_odp_adj_amt is '累计罚息调整金额';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.sum_interest_adj_amt is '累计利息调整金额';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.pre_cr_odp is '上日计提罚息';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.inter_bank_busi_no is '同业代付业务编号';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.is_last_pay_agent is '是否最后一次代付';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.timestamp is '时间戳';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_inter_bank_balance.etl_timestamp is 'ETL处理时间戳';
