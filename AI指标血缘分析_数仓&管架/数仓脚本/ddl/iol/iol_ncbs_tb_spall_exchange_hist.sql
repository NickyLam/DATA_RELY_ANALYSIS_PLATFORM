/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_spall_exchange_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_spall_exchange_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_spall_exchange_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_spall_exchange_hist(
    ccy varchar2(3) -- 币种
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,cash_num number(10) -- 现金数量
    ,company varchar2(20) -- 法人
    ,par_value_id varchar2(20) -- 券别代码
    ,seq_no varchar2(50) -- 序号
    ,tailbox_id varchar2(30) -- 尾箱代号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,spall_type varchar2(2) -- 残损币类型
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
grant select on ${iol_schema}.ncbs_tb_spall_exchange_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_spall_exchange_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_spall_exchange_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_spall_exchange_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_spall_exchange_hist is '残损币兑换历史表';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.cash_num is '现金数量';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.company is '法人';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.par_value_id is '券别代码';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.tailbox_id is '尾箱代号';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.spall_type is '残损币类型';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_spall_exchange_hist.etl_timestamp is 'ETL处理时间戳';
