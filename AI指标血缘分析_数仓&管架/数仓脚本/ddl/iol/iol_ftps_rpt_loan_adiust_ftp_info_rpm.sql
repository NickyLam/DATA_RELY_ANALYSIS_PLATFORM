/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ftps_rpt_loan_adiust_ftp_info_rpm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm
whenever sqlerror continue none;
drop table ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm(
    data_date date -- 数据日期
    ,adjust_num varchar2(100) -- 调整编号
    ,adjust_name varchar2(300) -- 调整项名称
    ,pre_object varchar2(20) -- 优惠对象 CORP-对公 RETL-零售
    ,is_add varchar2(10) -- 是否可叠加 1-是，0-否
    ,adjust_ftp_rate number(22,6) -- FTP调整项值(BP)
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
grant select on ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm to ${iml_schema};
grant select on ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm to ${icl_schema};
grant select on ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm to ${idl_schema};
grant select on ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm to ${iel_schema};

-- comment
comment on table ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm is '贷款FTP调整项（下发外部定价）';
comment on column ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm.data_date is '数据日期';
comment on column ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm.adjust_num is '调整编号';
comment on column ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm.adjust_name is '调整项名称';
comment on column ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm.pre_object is '优惠对象 CORP-对公 RETL-零售';
comment on column ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm.is_add is '是否可叠加 1-是，0-否';
comment on column ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm.adjust_ftp_rate is 'FTP调整项值(BP)';
comment on column ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ftps_rpt_loan_adiust_ftp_info_rpm.etl_timestamp is 'ETL处理时间戳';
