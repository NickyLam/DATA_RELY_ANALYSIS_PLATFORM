/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_transcode_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_transcode_inf
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_transcode_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_transcode_inf(
    cti_transcode varchar2(60) -- 交易码
    ,cti_transname varchar2(200) -- 交易名称
    ,cti_transflag varchar2(1) -- 对应功能菜单ID
    ,cti_menuid varchar2(20) -- 金融交易标志(0:非金融；1:金融交易)
    ,cti_channel varchar2(4) -- 渠道(PC)
    ,cti_menuname varchar2(200) -- 菜单名称
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbps_cpr_transcode_inf to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_transcode_inf to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_transcode_inf to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_transcode_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_transcode_inf is '交易码表';
comment on column ${iol_schema}.tbps_cpr_transcode_inf.cti_transcode is '交易码';
comment on column ${iol_schema}.tbps_cpr_transcode_inf.cti_transname is '交易名称';
comment on column ${iol_schema}.tbps_cpr_transcode_inf.cti_transflag is '对应功能菜单ID';
comment on column ${iol_schema}.tbps_cpr_transcode_inf.cti_menuid is '金融交易标志(0:非金融；1:金融交易)';
comment on column ${iol_schema}.tbps_cpr_transcode_inf.cti_channel is '渠道(PC)';
comment on column ${iol_schema}.tbps_cpr_transcode_inf.cti_menuname is '菜单名称';
comment on column ${iol_schema}.tbps_cpr_transcode_inf.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_transcode_inf.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_transcode_inf.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_transcode_inf.etl_timestamp is 'ETL处理时间戳';
