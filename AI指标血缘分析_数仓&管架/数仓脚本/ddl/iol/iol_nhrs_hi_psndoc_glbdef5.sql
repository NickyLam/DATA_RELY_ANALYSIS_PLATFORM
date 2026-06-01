/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psndoc_glbdef5
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psndoc_glbdef5
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef5 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_glbdef5(
    pk_psndoc_sub varchar2(30) -- 人员子表主键
    ,pk_psndoc varchar2(30) -- 人员档案主键
    ,begindate varchar2(15) -- 开始日期
    ,enddate varchar2(15) -- 结束日期
    ,recordnum number(22,0) -- 记录序号
    ,lastflag varchar2(2) -- 最近记录标志
    ,creator varchar2(30) -- 创建人
    ,creationtime varchar2(29) -- 创建时间
    ,modifier varchar2(30) -- 修改人
    ,modifiedtime varchar2(29) -- 修改时间
    ,glbdef1 varchar2(192) -- 工作单位
    ,glbdef2 varchar2(192) -- 部门
    ,glbdef3 varchar2(192) -- 岗位
    ,glbdef4 varchar2(192) -- 证明人
    ,glbdef11 varchar2(192) -- 职务
    ,glbdef5 varchar2(192) -- 工作城市
    ,glbdef6 varchar2(192) -- 离职原因
    ,glbdef7 varchar2(192) -- 证明人电话
    ,glbdef9 varchar2(192) -- 备注
    ,glbdef10 varchar2(30) -- 是否进行背景调查
    ,ts varchar2(29) -- 时间戳
    ,dr number(10,0) -- 备用dr
    ,glbdef8 varchar2(192) -- 备用glbdef8
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
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef5 to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef5 to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef5 to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef5 to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psndoc_glbdef5 is '履历记录（新）';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.pk_psndoc_sub is '人员子表主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.pk_psndoc is '人员档案主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.begindate is '开始日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.enddate is '结束日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.lastflag is '最近记录标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.glbdef1 is '工作单位';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.glbdef2 is '部门';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.glbdef3 is '岗位';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.glbdef4 is '证明人';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.glbdef11 is '职务';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.glbdef5 is '工作城市';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.glbdef6 is '离职原因';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.glbdef7 is '证明人电话';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.glbdef9 is '备注';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.glbdef10 is '是否进行背景调查';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.glbdef8 is '备用glbdef8';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef5.etl_timestamp is 'ETL处理时间戳';
