/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_ashare_broker_monthly_report
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_ashare_broker_monthly_report
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_ashare_broker_monthly_report purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_ashare_broker_monthly_report(
    seq number(20,0) -- 记录唯一标识
    ,ctime date -- 记录创建日期
    ,mtime date -- 记录修改日期
    ,rtime date -- 记录通讯到用户端日期
    ,broker_id varchar2(60) -- 券商id
    ,net_asset number(24,4) -- 净资产
    ,monthly_revenue number(24,4) -- 营业收入-当月值
    ,broker_name varchar2(1500) -- 券商名称
    ,mnth number(10,0) -- 月份
    ,monthly_net_profit number(24,4) -- 净利润-当月值
    ,isvalid number(1,0) -- 是否有效
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
grant select on ${iol_schema}.uxds_ashare_broker_monthly_report to ${iml_schema};
grant select on ${iol_schema}.uxds_ashare_broker_monthly_report to ${icl_schema};
grant select on ${iol_schema}.uxds_ashare_broker_monthly_report to ${idl_schema};
grant select on ${iol_schema}.uxds_ashare_broker_monthly_report to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_ashare_broker_monthly_report is '证券公司月报';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.ctime is '记录创建日期';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.mtime is '记录修改日期';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.rtime is '记录通讯到用户端日期';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.broker_id is '券商id';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.net_asset is '净资产';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.monthly_revenue is '营业收入-当月值';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.broker_name is '券商名称';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.mnth is '月份';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.monthly_net_profit is '净利润-当月值';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_ashare_broker_monthly_report.etl_timestamp is 'ETL处理时间戳';
