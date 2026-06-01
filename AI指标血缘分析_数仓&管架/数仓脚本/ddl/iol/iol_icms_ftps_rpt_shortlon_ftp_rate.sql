/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ftps_rpt_shortlon_ftp_rate
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate(
    serialno varchar2(32) -- 流水号
    ,term_cd varchar2(20) -- 档次编号
    ,data_dt date -- 日期
    ,term number(10,0) -- 靠档期限
    ,ftp_rate number(10,4) -- FTP价格
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,term_desc varchar2(60) -- 档次描述
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate to ${iml_schema};
grant select on ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate to ${icl_schema};
grant select on ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate to ${idl_schema};
grant select on ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate is '超短贷档次ftp试算表';
comment on column ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate.serialno is '流水号';
comment on column ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate.term_cd is '档次编号';
comment on column ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate.data_dt is '日期';
comment on column ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate.term is '靠档期限';
comment on column ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate.ftp_rate is 'FTP价格';
comment on column ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate.term_desc is '档次描述';
comment on column ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ftps_rpt_shortlon_ftp_rate.etl_timestamp is 'ETL处理时间戳';
