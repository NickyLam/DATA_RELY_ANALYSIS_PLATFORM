/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_sfxgbzxrdgjk_data_xgbzxr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,qyfr varchar2(4000) -- 企业法人
    ,fbrq varchar2(4000) -- 发布时间（日期）
    ,larq varchar2(4000) -- 立案时间（日期）
    ,ah varchar2(4000) -- 案号
    ,zxfy varchar2(4000) -- 执行法院
    ,id varchar2(4000) -- 标识
    ,data_xgbzxr varchar2(4000) -- 关联标签
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
grant select on ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr to ${iml_schema};
grant select on ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr to ${icl_schema};
grant select on ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr to ${idl_schema};
grant select on ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr is '司法研究院监控接口相关数据';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.qyfr is '企业法人';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.fbrq is '发布时间（日期）';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.larq is '立案时间（日期）';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.ah is '案号';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.zxfy is '执行法院';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.id is '标识';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.data_xgbzxr is '关联标签';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_sfxgbzxrdgjk_data_xgbzxr.etl_timestamp is 'ETL处理时间戳';
