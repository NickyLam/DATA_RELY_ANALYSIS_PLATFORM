/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ftps_rpt_rst_ftp_fin_total
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ftps_rpt_rst_ftp_fin_total
whenever sqlerror continue none;
drop table ${iol_schema}.ftps_rpt_rst_ftp_fin_total purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ftps_rpt_rst_ftp_fin_total(
    data_dt date -- 数据日期
    ,org_code varchar2(80) -- 部门机构ID
    ,tp_pricing varchar2(40) -- 定价方案类型
    ,currency_code varchar2(80) -- 币种编号
    ,subject_type varchar2(10) -- 业务类型
    ,cur_bal number(32,2) -- 当前余额
    ,accbal_month number(32,2) -- 月累计余额
    ,accbal_quar number(32,2) -- 季累计余额
    ,accbal_year number(32,2) -- 年累计余额
    ,final_ftp_accint_day number(32,2) -- 最终FTP利息日累计
    ,final_ftp_accint_month number(32,2) -- 最终FTP利息月累计
    ,final_ftp_accint_quar number(32,2) -- 最终FTP利息季累计
    ,final_ftp_accint_year number(32,2) -- 最终FTP利息年累计
    ,accint_day number(32,2) -- 当日外部利息收支
    ,accint_month number(32,2) -- 当月累计外部利息收支
    ,accint_quar number(32,2) -- 当季累计外部利息收支
    ,accint_year number(32,2) -- 当年累计外部利息收支
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
grant select on ${iol_schema}.ftps_rpt_rst_ftp_fin_total to ${iml_schema};
grant select on ${iol_schema}.ftps_rpt_rst_ftp_fin_total to ${icl_schema};
grant select on ${iol_schema}.ftps_rpt_rst_ftp_fin_total to ${idl_schema};
grant select on ${iol_schema}.ftps_rpt_rst_ftp_fin_total to ${iel_schema};

-- comment
comment on table ${iol_schema}.ftps_rpt_rst_ftp_fin_total is '条线FTP收支统计表';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.data_dt is '数据日期';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.org_code is '部门机构ID';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.tp_pricing is '定价方案类型';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.currency_code is '币种编号';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.subject_type is '业务类型';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.cur_bal is '当前余额';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.accbal_month is '月累计余额';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.accbal_quar is '季累计余额';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.accbal_year is '年累计余额';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.final_ftp_accint_day is '最终FTP利息日累计';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.final_ftp_accint_month is '最终FTP利息月累计';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.final_ftp_accint_quar is '最终FTP利息季累计';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.final_ftp_accint_year is '最终FTP利息年累计';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.accint_day is '当日外部利息收支';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.accint_month is '当月累计外部利息收支';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.accint_quar is '当季累计外部利息收支';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.accint_year is '当年累计外部利息收支';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ftps_rpt_rst_ftp_fin_total.etl_timestamp is 'ETL处理时间戳';
