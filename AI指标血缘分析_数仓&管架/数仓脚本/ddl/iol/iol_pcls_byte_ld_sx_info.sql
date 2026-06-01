/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pcls_byte_ld_sx_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pcls_byte_ld_sx_info
whenever sqlerror continue none;
drop table ${iol_schema}.pcls_byte_ld_sx_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pcls_byte_ld_sx_info(
    appl_dt number(22,0) -- 申请日期
    ,appl_cnt number(22,0) -- 申请笔数
    ,appl_pass_cnt number(22,0) -- 申请通过笔数
    ,appl_pass_percent number(38,6) -- 授信通过率（笔数）
    ,credit_amount number(38,6) -- 授信金额
    ,credit_amount_avg number(38,6) -- 笔均授信金额
    ,rate number(38,6) -- 定价
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
grant select on ${iol_schema}.pcls_byte_ld_sx_info to ${iml_schema};
grant select on ${iol_schema}.pcls_byte_ld_sx_info to ${icl_schema};
grant select on ${iol_schema}.pcls_byte_ld_sx_info to ${idl_schema};
grant select on ${iol_schema}.pcls_byte_ld_sx_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.pcls_byte_ld_sx_info is '字节小微联贷授信表';
comment on column ${iol_schema}.pcls_byte_ld_sx_info.appl_dt is '申请日期';
comment on column ${iol_schema}.pcls_byte_ld_sx_info.appl_cnt is '申请笔数';
comment on column ${iol_schema}.pcls_byte_ld_sx_info.appl_pass_cnt is '申请通过笔数';
comment on column ${iol_schema}.pcls_byte_ld_sx_info.appl_pass_percent is '授信通过率（笔数）';
comment on column ${iol_schema}.pcls_byte_ld_sx_info.credit_amount is '授信金额';
comment on column ${iol_schema}.pcls_byte_ld_sx_info.credit_amount_avg is '笔均授信金额';
comment on column ${iol_schema}.pcls_byte_ld_sx_info.rate is '定价';
comment on column ${iol_schema}.pcls_byte_ld_sx_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pcls_byte_ld_sx_info.etl_timestamp is 'ETL处理时间戳';
