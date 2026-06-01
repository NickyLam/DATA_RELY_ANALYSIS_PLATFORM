/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_eqpt_cash_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist(
    amount number(17,2) -- 金额
    ,branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,company varchar2(20) -- 法人
    ,reserve_flag varchar2(1) -- 冲正标志
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,eqpt_seq_no varchar2(50) -- 自助设备交易编号
    ,virtual_user_id varchar2(8) -- 虚拟柜员代号
    ,virtual_tailbox_id varchar2(20) -- 虚拟柜员柜员尾箱id
    ,teller_user_id varchar2(8) -- 自助设备出库真实柜员
    ,teller_trailbox_id varchar2(50) -- 自助设备出库真实柜员尾箱
    ,rec_amount number(17,2) -- 收入金额
    ,pay_amount number(17,2) -- 付出金额
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
grant select on ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist is '自助设备收支余额历史表';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.amount is '金额';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.branch is '机构编号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.reserve_flag is '冲正标志';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.eqpt_seq_no is '自助设备交易编号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.virtual_user_id is '虚拟柜员代号';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.virtual_tailbox_id is '虚拟柜员柜员尾箱id';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.teller_user_id is '自助设备出库真实柜员';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.teller_trailbox_id is '自助设备出库真实柜员尾箱';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.rec_amount is '收入金额';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.pay_amount is '付出金额';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_tb_eqpt_cash_tran_hist.etl_timestamp is 'ETL处理时间戳';
