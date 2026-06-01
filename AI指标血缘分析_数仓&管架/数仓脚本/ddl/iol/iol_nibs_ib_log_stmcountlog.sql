/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nibs_ib_log_stmcountlog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nibs_ib_log_stmcountlog
whenever sqlerror continue none;
drop table ${iol_schema}.nibs_ib_log_stmcountlog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_log_stmcountlog(
    tx_seq_num varchar2(33) -- 业务流水号
    ,channeldate date -- 交易日期|yyyyMMdd
    ,channeltime date -- 交易时间|HHmmss
    ,worktime date -- 平台时间|yyyyMMdd HHmmss
    ,menunum varchar2(32) -- 交易码
    ,menuname varchar2(200) -- 交易名称
    ,branchnum varchar2(12) -- 交易机构编号
    ,branchname varchar2(200) -- 交易机构名称
    ,usernum varchar2(8) -- 交易柜员
    ,username varchar2(200) -- 交易柜员名称
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
grant select on ${iol_schema}.nibs_ib_log_stmcountlog to ${iml_schema};
grant select on ${iol_schema}.nibs_ib_log_stmcountlog to ${icl_schema};
grant select on ${iol_schema}.nibs_ib_log_stmcountlog to ${idl_schema};
grant select on ${iol_schema}.nibs_ib_log_stmcountlog to ${iel_schema};

-- comment
comment on table ${iol_schema}.nibs_ib_log_stmcountlog is '智能网点-stm替代率统计表';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.tx_seq_num is '业务流水号';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.channeldate is '交易日期|yyyyMMdd';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.channeltime is '交易时间|HHmmss';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.worktime is '平台时间|yyyyMMdd HHmmss';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.menunum is '交易码';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.menuname is '交易名称';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.branchnum is '交易机构编号';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.branchname is '交易机构名称';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.usernum is '交易柜员';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.username is '交易柜员名称';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nibs_ib_log_stmcountlog.etl_timestamp is 'ETL处理时间戳';
