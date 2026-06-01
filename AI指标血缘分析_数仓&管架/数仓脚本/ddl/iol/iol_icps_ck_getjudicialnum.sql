/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icps_ck_getjudicialnum
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icps_ck_getjudicialnum
whenever sqlerror continue none;
drop table ${iol_schema}.icps_ck_getjudicialnum purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icps_ck_getjudicialnum(
    cnt number(20) -- 数据统计
    ,accountno varchar2(50) -- 卡号
    ,opttype varchar2(20) -- 常规查询
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
grant select on ${iol_schema}.icps_ck_getjudicialnum to ${iml_schema};
grant select on ${iol_schema}.icps_ck_getjudicialnum to ${icl_schema};
grant select on ${iol_schema}.icps_ck_getjudicialnum to ${idl_schema};
grant select on ${iol_schema}.icps_ck_getjudicialnum to ${iel_schema};

-- comment
comment on table ${iol_schema}.icps_ck_getjudicialnum is '账户信息统计(视图)';
comment on column ${iol_schema}.icps_ck_getjudicialnum.cnt is '数据统计';
comment on column ${iol_schema}.icps_ck_getjudicialnum.accountno is '卡号';
comment on column ${iol_schema}.icps_ck_getjudicialnum.opttype is '常规查询';
comment on column ${iol_schema}.icps_ck_getjudicialnum.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icps_ck_getjudicialnum.etl_timestamp is 'ETL处理时间戳';
