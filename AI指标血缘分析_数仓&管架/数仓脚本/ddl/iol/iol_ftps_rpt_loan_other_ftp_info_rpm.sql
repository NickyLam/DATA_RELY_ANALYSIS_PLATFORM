/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ftps_rpt_loan_other_ftp_info_rpm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm
whenever sqlerror continue none;
drop table ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm(
    data_date date -- 数据日期 业务发生时间，取当前日期下的所有业务数据
    ,ftp_tp varchar2(20) -- FTP类型 RAFL：贷款FTP利率下限 REFI：再贷款FTP利率
    ,ftp_rate number(22,6) -- FTP价格(%)
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
grant select on ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm to ${iml_schema};
grant select on ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm to ${icl_schema};
grant select on ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm to ${idl_schema};
grant select on ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm to ${iel_schema};

-- comment
comment on table ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm is '其他FTP利率信息表（下发外部定价）';
comment on column ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm.data_date is '数据日期 业务发生时间，取当前日期下的所有业务数据';
comment on column ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm.ftp_tp is 'FTP类型 RAFL：贷款FTP利率下限 REFI：再贷款FTP利率';
comment on column ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm.ftp_rate is 'FTP价格(%)';
comment on column ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ftps_rpt_loan_other_ftp_info_rpm.etl_timestamp is 'ETL处理时间戳';
