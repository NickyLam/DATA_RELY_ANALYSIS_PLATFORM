/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ftps_rpt_ftp_lon_jx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ftps_rpt_ftp_lon_jx
whenever sqlerror continue none;
drop table ${iol_schema}.ftps_rpt_ftp_lon_jx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ftps_rpt_ftp_lon_jx(
    data_dt date -- 数据日期
    ,tp_code varchar2(64) -- 类型编号
    ,tp_desc varchar2(400) -- 类型描述
    ,currency_cd varchar2(20) -- 币种
    ,term number(5) -- 期限
    ,term_cd varchar2(20) -- 期限类型代码
    ,base_ftp_rate number(10,4) -- FTP价格(%)
    ,adj01 number(10,4) -- 调整项1(%)
    ,adj02 number(10,4) -- 调整项2(%)
    ,adj03 number(10,4) -- 调整项3(%)
    ,adj04 number(10,4) -- 调整项4(%)
    ,adj05 number(10,4) -- 调整项5(%)
    ,adj06 number(10,4) -- 调整项6(%)
    ,adj07 number(10,4) -- 调整项7(%)
    ,adj08 number(10,4) -- 调整项8(%)
    ,adj09 number(10,4) -- 调整项9(%)
    ,adj10 number(10,4) -- 调整项10(%)
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
grant select on ${iol_schema}.ftps_rpt_ftp_lon_jx to ${iml_schema};
grant select on ${iol_schema}.ftps_rpt_ftp_lon_jx to ${icl_schema};
grant select on ${iol_schema}.ftps_rpt_ftp_lon_jx to ${idl_schema};
grant select on ${iol_schema}.ftps_rpt_ftp_lon_jx to ${iel_schema};

-- comment
comment on table ${iol_schema}.ftps_rpt_ftp_lon_jx is '绩效创收测算ftp接口表（贷款）';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.data_dt is '数据日期';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.tp_code is '类型编号';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.tp_desc is '类型描述';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.currency_cd is '币种';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.term is '期限';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.term_cd is '期限类型代码';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.base_ftp_rate is 'FTP价格(%)';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.adj01 is '调整项1(%)';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.adj02 is '调整项2(%)';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.adj03 is '调整项3(%)';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.adj04 is '调整项4(%)';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.adj05 is '调整项5(%)';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.adj06 is '调整项6(%)';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.adj07 is '调整项7(%)';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.adj08 is '调整项8(%)';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.adj09 is '调整项9(%)';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.adj10 is '调整项10(%)';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ftps_rpt_ftp_lon_jx.etl_timestamp is 'ETL处理时间戳';
