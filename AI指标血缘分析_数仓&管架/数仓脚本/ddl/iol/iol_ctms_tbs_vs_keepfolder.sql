/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_vs_keepfolder
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_vs_keepfolder
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_vs_keepfolder purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_keepfolder(
    keepfolder_id number -- 账户ID
    ,aspclient_id number -- 部门ID
    ,keepfolder_code varchar2(30) -- 账户代码
    ,keepfolder_shortname varchar2(75) -- 账户简称
    ,lastmodified timestamp -- 最后修改时间
    ,costmethod varchar2(2) -- 核算方式
    ,calcdayenddate1 number -- 收盘日
    ,calcdayenddate2 number -- 交易日
    ,controlfactor varchar2(30) -- 控制因素
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
grant select on ${iol_schema}.ctms_tbs_vs_keepfolder to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_vs_keepfolder to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_keepfolder to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_vs_keepfolder to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_vs_keepfolder is '账户视图';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.keepfolder_id is '账户ID';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.aspclient_id is '部门ID';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.keepfolder_code is '账户代码';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.keepfolder_shortname is '账户简称';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.lastmodified is '最后修改时间';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.costmethod is '核算方式';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.calcdayenddate1 is '收盘日';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.calcdayenddate2 is '交易日';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.controlfactor is '控制因素';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_vs_keepfolder.etl_timestamp is 'ETL处理时间戳';
