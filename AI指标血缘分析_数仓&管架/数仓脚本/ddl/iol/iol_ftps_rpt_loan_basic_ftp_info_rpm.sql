/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ftps_rpt_loan_basic_ftp_info_rpm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm
whenever sqlerror continue none;
drop table ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm(
    data_date date -- 数据日期
    ,term varchar2(20) -- 贷款期限
    ,rate_type varchar2(20) -- 利率类型 F-固定、A-浮动
    ,repricetype varchar2(20) -- 重定价周期
    ,loan_basic_ftp_rate number(22,6) -- FTP基础价格(%)
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
grant select on ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm to ${iml_schema};
grant select on ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm to ${icl_schema};
grant select on ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm to ${idl_schema};
grant select on ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm to ${iel_schema};

-- comment
comment on table ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm is '贷款FTP基础价格（下发外部定价）';
comment on column ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm.data_date is '数据日期';
comment on column ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm.term is '贷款期限';
comment on column ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm.rate_type is '利率类型 F-固定、A-浮动';
comment on column ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm.repricetype is '重定价周期';
comment on column ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm.loan_basic_ftp_rate is 'FTP基础价格(%)';
comment on column ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ftps_rpt_loan_basic_ftp_info_rpm.etl_timestamp is 'ETL处理时间戳';
