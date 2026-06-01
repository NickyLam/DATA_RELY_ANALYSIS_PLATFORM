/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rwa_sl_stdrwband
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rwa_sl_stdrwband
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rwa_sl_stdrwband purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rwa_sl_stdrwband(
    stdrwbandid number(9,0) -- 标准法下风险权重等级标识
    ,reportid number(9,0) -- 监管机关报表标识
    ,stdrwbanddesc varchar2(1125) -- 标准法下风险权重等级描述
    ,stdrwbandfloor number(10,8) -- 标准法下风险权重等级下限
    ,stdrwbandceiling number(10,8) -- 标准法下风险权重等级上限
    ,creationdate date -- 创建日期
    ,lastupdatedate date -- 上次更新日期
    ,stdrwbandgroupid number(9,0) -- 标准法下风险权重等级组标识
    ,stdrwbandgroupdesc varchar2(1125) -- 标准法下风险权重等级组描述
    ,stdrwbandlcldsc varchar2(1125) -- 标准法下风险权重等级中文描述
    ,stdrwband number(18,3) -- 风险权重数值
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
grant select on ${iol_schema}.rwas_rwa_sl_stdrwband to ${iml_schema};
grant select on ${iol_schema}.rwas_rwa_sl_stdrwband to ${icl_schema};
grant select on ${iol_schema}.rwas_rwa_sl_stdrwband to ${idl_schema};
grant select on ${iol_schema}.rwas_rwa_sl_stdrwband to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rwa_sl_stdrwband is '权重等级表';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.stdrwbandid is '标准法下风险权重等级标识';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.reportid is '监管机关报表标识';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.stdrwbanddesc is '标准法下风险权重等级描述';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.stdrwbandfloor is '标准法下风险权重等级下限';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.stdrwbandceiling is '标准法下风险权重等级上限';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.creationdate is '创建日期';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.lastupdatedate is '上次更新日期';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.stdrwbandgroupid is '标准法下风险权重等级组标识';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.stdrwbandgroupdesc is '标准法下风险权重等级组描述';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.stdrwbandlcldsc is '标准法下风险权重等级中文描述';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.stdrwband is '风险权重数值';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.start_dt is '开始时间';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.end_dt is '结束时间';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.id_mark is '增删标志';
comment on column ${iol_schema}.rwas_rwa_sl_stdrwband.etl_timestamp is 'ETL处理时间戳';
