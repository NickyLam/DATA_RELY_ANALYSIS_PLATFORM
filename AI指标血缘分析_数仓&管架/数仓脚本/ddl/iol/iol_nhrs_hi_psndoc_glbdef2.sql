/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psndoc_glbdef2
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psndoc_glbdef2
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psndoc_glbdef2 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_glbdef2(
    begindate varchar2(15) -- 开始日期
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,enddate varchar2(15) -- 结束日期
    ,glbdef1 varchar2(192) -- 姓名
    ,glbdef2 varchar2(192) -- 员工编号
    ,glbdef3 varchar2(192) -- 考核年度
    ,glbdef4 varchar2(192) -- 考核所在单位
    ,glbdef5 varchar2(192) -- 考核所在部门
    ,glbdef6 varchar2(192) -- 考核岗位
    ,glbdef7 varchar2(192) -- 绩效考核等级
    ,glbdef8 varchar2(192) -- 评优评先
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
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef2 to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef2 to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef2 to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_glbdef2 to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psndoc_glbdef2 is '年度绩效考核';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.begindate is '开始日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.enddate is '结束日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.glbdef1 is '姓名';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.glbdef2 is '员工编号';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.glbdef3 is '考核年度';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.glbdef4 is '考核所在单位';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.glbdef5 is '考核所在部门';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.glbdef6 is '考核岗位';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.glbdef7 is '绩效考核等级';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.glbdef8 is '评优评先';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.lastflag is '最近记录标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.pk_psndoc is '人员档案主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.pk_psndoc_sub is '人员子表主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_glbdef2.etl_timestamp is 'ETL处理时间戳';
