/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_myrzftp_jzkhsmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal(
    tjrq number(22) -- 统计日期
    ,recal_dt number(22) -- 重算窗口日期
    ,khh varchar2(75) -- 客户号
    ,khmc varchar2(150) -- 客户名称
    ,jgdh varchar2(30) -- 机构代号
    ,jgmc varchar2(75) -- 机构名称
    ,gyllxmc_list varchar2(750) -- 供应链类型名称列表
    ,glhxqykhmc varchar2(150) -- 核心企业客户名称
    ,ftpsynlj number(25,4) -- 累计净收益
    ,nrj number(25,4) -- 存款年日均
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
grant select on ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal is '绩效报表_供应链价值客户数明细_重算';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.recal_dt is '重算窗口日期';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.gyllxmc_list is '供应链类型名称列表';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.glhxqykhmc is '核心企业客户名称';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.ftpsynlj is '累计净收益';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.nrj is '存款年日均';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_myrzftp_jzkhsmx_recal.etl_timestamp is 'ETL处理时间戳';
