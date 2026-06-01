/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_voucher_sell_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_voucher_sell_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_voucher_sell_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_voucher_sell_info(
    doc_type varchar2(10) -- 凭证类型
    ,voucher_status varchar2(3) -- 凭证状态
    ,company varchar2(20) -- 法人
    ,prefix varchar2(10) -- 前缀
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,voucher_status_pre varchar2(3) -- 凭证交易前状态
    ,channel_date date -- 渠道日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,voucher_end_no varchar2(50) -- 凭证终止号码
    ,voucher_start_no varchar2(50) -- 凭证起始号码
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
grant select on ${iol_schema}.ncbs_rb_voucher_sell_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_sell_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_sell_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_voucher_sell_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_voucher_sell_info is '凭证状态变化登记簿（外围专用）';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.voucher_status is '凭证状态';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.company is '法人';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.voucher_status_pre is '凭证交易前状态';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.channel_date is '渠道日期';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.voucher_end_no is '凭证终止号码';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.voucher_start_no is '凭证起始号码';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_voucher_sell_info.etl_timestamp is 'ETL处理时间戳';
