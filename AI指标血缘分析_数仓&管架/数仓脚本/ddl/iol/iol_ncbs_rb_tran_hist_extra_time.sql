/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_tran_hist_extra_time
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_tran_hist_extra_time
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_tran_hist_extra_time purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_tran_hist_extra_time(
    seq_no varchar2(50) -- 序号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,sub_seq_no varchar2(100) -- 系统子流水号
    ,reference varchar2(50) -- 交易参考号
    ,tran_date date -- 交易日期
    ,orig_tran_timestamp varchar2(26) -- 原始交易时间戳
    ,extra_tran_timestamp varchar2(26) -- 加工时间戳
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
grant select on ${iol_schema}.ncbs_rb_tran_hist_extra_time to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_tran_hist_extra_time to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_hist_extra_time to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_hist_extra_time to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_tran_hist_extra_time is '反洗钱时间加工表';
comment on column ${iol_schema}.ncbs_rb_tran_hist_extra_time.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_extra_time.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_extra_time.sub_seq_no is '系统子流水号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_extra_time.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_extra_time.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_tran_hist_extra_time.orig_tran_timestamp is '原始交易时间戳';
comment on column ${iol_schema}.ncbs_rb_tran_hist_extra_time.extra_tran_timestamp is '加工时间戳';
comment on column ${iol_schema}.ncbs_rb_tran_hist_extra_time.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_tran_hist_extra_time.etl_timestamp is 'ETL处理时间戳';
