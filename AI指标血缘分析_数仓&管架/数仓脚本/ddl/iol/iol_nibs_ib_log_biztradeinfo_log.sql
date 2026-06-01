/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_log_biztradeinfo_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_log_biztradeinfo_log
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_log_biztradeinfo_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_biztradeinfo_log(
    channeltranname varchar2(128) -- 渠道交易名称（菜单名称）
    ,channeltrancode varchar2(32) -- 渠道交易编号（菜单码）
    ,tx_seq_num varchar2(33) -- 业务流水号(交易订单号)
    ,note1 varchar2(512) -- 备用1
    ,channeltrandata varchar2(4000) -- 交易内容信息
    ,channeltranpath varchar2(128) -- 交易路径
    ,tx_dt date -- 交易日期
    ,note2 varchar2(512) -- 备用2
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
grant select on ${iol_schema}.nibs_ib_log_biztradeinfo_log to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_log_biztradeinfo_log to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_log_biztradeinfo_log to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_log_biztradeinfo_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_log_biztradeinfo_log is '业务流水交易内容表';
comment on column ${iol_schema}.nibs_ib_log_biztradeinfo_log.channeltranname is '渠道交易名称（菜单名称）';
comment on column ${iol_schema}.nibs_ib_log_biztradeinfo_log.channeltrancode is '渠道交易编号（菜单码）';
comment on column ${iol_schema}.nibs_ib_log_biztradeinfo_log.tx_seq_num is '业务流水号(交易订单号)';
comment on column ${iol_schema}.nibs_ib_log_biztradeinfo_log.note1 is '备用1';
comment on column ${iol_schema}.nibs_ib_log_biztradeinfo_log.channeltrandata is '交易内容信息';
comment on column ${iol_schema}.nibs_ib_log_biztradeinfo_log.channeltranpath is '交易路径';
comment on column ${iol_schema}.nibs_ib_log_biztradeinfo_log.tx_dt is '交易日期';
comment on column ${iol_schema}.nibs_ib_log_biztradeinfo_log.note2 is '备用2';
comment on column ${iol_schema}.nibs_ib_log_biztradeinfo_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ib_log_biztradeinfo_log.etl_timestamp is 'ETL处理时间戳';
