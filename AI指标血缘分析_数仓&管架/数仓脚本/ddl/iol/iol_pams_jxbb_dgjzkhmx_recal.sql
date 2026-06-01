/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_dgjzkhmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_dgjzkhmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_dgjzkhmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_dgjzkhmx_recal(
    tjrq number -- 统计日期
    ,hydh varchar2(60) -- 行员代号
    ,hymc varchar2(300) -- 行员名称
    ,jgdh varchar2(60) -- 机构代号
    ,jgmc varchar2(300) -- 机构名称
    ,khh varchar2(150) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,hyljrj number(25,4) -- 行员累计日均
    ,hyftpsynlj number(25,4) -- 行员收入年累计
    ,khljrj number(25,4) -- 客户累计日均
    ,khftpsynlj number(25,4) -- 客户收入年累计
    ,zjywsr number(25,4) -- 中间业务收入
    ,khzjywsr number(25,4) -- 客户中间业务收入
    ,jzkhs number(25,4) -- 价值客户数
    ,fhjzkhs number(25,4) -- 分行价值客户数
    ,recal_dt number -- 重算日期
    ,ckye number(25,4) -- 存款余额
    ,ckzb number(25,4) -- 存款占比
    ,yszb number(25,4) -- 营收占比
    ,ld varchar2(6) -- 粒度:01-行员;02-分行;03-全行
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
grant select on ${iol_schema}.pams_jxbb_dgjzkhmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_dgjzkhmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_dgjzkhmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_dgjzkhmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_dgjzkhmx_recal is '绩效报表_对公价值客户明细(26年口径)_重算';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.hyljrj is '行员累计日均';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.hyftpsynlj is '行员收入年累计';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.khljrj is '客户累计日均';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.khftpsynlj is '客户收入年累计';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.zjywsr is '中间业务收入';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.khzjywsr is '客户中间业务收入';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.jzkhs is '价值客户数';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.fhjzkhs is '分行价值客户数';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.ckye is '存款余额';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.ckzb is '存款占比';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.yszb is '营收占比';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.ld is '粒度:01-行员;02-分行;03-全行';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_dgjzkhmx_recal.etl_timestamp is 'ETL处理时间戳';
