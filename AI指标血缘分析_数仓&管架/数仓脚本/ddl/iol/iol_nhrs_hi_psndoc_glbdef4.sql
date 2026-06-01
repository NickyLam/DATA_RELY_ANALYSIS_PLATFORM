/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psndoc_glbdef4
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psndoc_glbdef4
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef4 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_glbdef4(
    begindate varchar2(15) -- 开始日期
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,enddate varchar2(15) -- 结束日期
    ,glbdef1 varchar2(192) -- 资格名称
    ,glbdef2 varchar2(192) -- 取得资格途径
    ,glbdef3 varchar2(15) -- 取得时间
    ,glbdef4 varchar2(192) -- 批准单位
    ,glbdef5 varchar2(192) -- 备注
    ,lastflag varchar2(2) -- 最近记录标志
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,pk_psndoc varchar2(30) -- 人员档案主键
    ,pk_psndoc_sub varchar2(30) -- 人员子表主键
    ,recordnum number(22,0) -- 记录序号
    ,ts varchar2(29) -- 时间戳
    ,dr number(10,0) -- 备用dr
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
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef4 to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef4 to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef4 to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef4 to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psndoc_glbdef4 is '资格证书';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.begindate is '开始日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.enddate is '结束日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.glbdef1 is '资格名称';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.glbdef2 is '取得资格途径';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.glbdef3 is '取得时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.glbdef4 is '批准单位';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.glbdef5 is '备注';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.lastflag is '最近记录标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.pk_psndoc is '人员档案主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.pk_psndoc_sub is '人员子表主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef4.etl_timestamp is 'ETL处理时间戳';
