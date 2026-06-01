/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ftps_rpt_rst_ftp261_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ftps_rpt_rst_ftp261_info
whenever sqlerror continue none;
drop table ${iol_schema}.ftps_rpt_rst_ftp261_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ftps_rpt_rst_ftp261_info(
    data_date date -- 数据日期
    ,soc_cre_code varchar2(36) -- 统一社会信用代码
    ,ftp_bus_type varchar2(40) -- FTP业务类型
    ,term_type_cd varchar2(200) -- 期限类型
    ,cha_date date -- 变动日期
    ,ftp_rate number(30,5) -- FTP价格
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
grant select on ${iol_schema}.ftps_rpt_rst_ftp261_info to ${iml_schema};
grant select on ${iol_schema}.ftps_rpt_rst_ftp261_info to ${icl_schema};
grant select on ${iol_schema}.ftps_rpt_rst_ftp261_info to ${idl_schema};
grant select on ${iol_schema}.ftps_rpt_rst_ftp261_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ftps_rpt_rst_ftp261_info is 'FTP定价变动明细信息表';
comment on column ${iol_schema}.ftps_rpt_rst_ftp261_info.data_date is '数据日期';
comment on column ${iol_schema}.ftps_rpt_rst_ftp261_info.soc_cre_code is '统一社会信用代码';
comment on column ${iol_schema}.ftps_rpt_rst_ftp261_info.ftp_bus_type is 'FTP业务类型';
comment on column ${iol_schema}.ftps_rpt_rst_ftp261_info.term_type_cd is '期限类型';
comment on column ${iol_schema}.ftps_rpt_rst_ftp261_info.cha_date is '变动日期';
comment on column ${iol_schema}.ftps_rpt_rst_ftp261_info.ftp_rate is 'FTP价格';
comment on column ${iol_schema}.ftps_rpt_rst_ftp261_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ftps_rpt_rst_ftp261_info.etl_timestamp is 'ETL处理时间戳';
