/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_tbm_psndoc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_tbm_psndoc
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_tbm_psndoc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_tbm_psndoc(
    begindate varchar2(15) -- 档案开始日期
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dr number(10,0) -- 备用dr
    ,enddate varchar2(15) -- 档案结束日期
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,pk_adminorg varchar2(30) -- 管理组织
    ,pk_group varchar2(30) -- 集团主键
    ,pk_org varchar2(30) -- 组织主键
    ,pk_place varchar2(30) -- 考勤地点
    ,pk_psndoc varchar2(30) -- 人员基本信息
    ,pk_psnjob varchar2(30) -- 人员工作记录
    ,pk_psnorg varchar2(30) -- 组织关系主键
    ,pk_tbm_psndoc varchar2(30) -- 考勤档案主键
    ,pk_team varchar2(30) -- 所属班组
    ,secondcardid varchar2(150) -- 副卡号
    ,tbm_prop number(38,0) -- 考勤方式
    ,timecardid varchar2(150) -- 考勤卡号
    ,ts varchar2(29) -- 备用ts
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
grant select on ${iol_schema}.nhrs_tbm_psndoc to ${iml_schema};
grant select on ${iol_schema}.nhrs_tbm_psndoc to ${icl_schema};
grant select on ${iol_schema}.nhrs_tbm_psndoc to ${idl_schema};
grant select on ${iol_schema}.nhrs_tbm_psndoc to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_tbm_psndoc is '考勤档案';
comment on column ${iol_schema}.nhrs_tbm_psndoc.begindate is '档案开始日期';
comment on column ${iol_schema}.nhrs_tbm_psndoc.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_tbm_psndoc.creator is '创建人';
comment on column ${iol_schema}.nhrs_tbm_psndoc.dr is '备用dr';
comment on column ${iol_schema}.nhrs_tbm_psndoc.enddate is '档案结束日期';
comment on column ${iol_schema}.nhrs_tbm_psndoc.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_tbm_psndoc.modifier is '修改人';
comment on column ${iol_schema}.nhrs_tbm_psndoc.pk_adminorg is '管理组织';
comment on column ${iol_schema}.nhrs_tbm_psndoc.pk_group is '集团主键';
comment on column ${iol_schema}.nhrs_tbm_psndoc.pk_org is '组织主键';
comment on column ${iol_schema}.nhrs_tbm_psndoc.pk_place is '考勤地点';
comment on column ${iol_schema}.nhrs_tbm_psndoc.pk_psndoc is '人员基本信息';
comment on column ${iol_schema}.nhrs_tbm_psndoc.pk_psnjob is '人员工作记录';
comment on column ${iol_schema}.nhrs_tbm_psndoc.pk_psnorg is '组织关系主键';
comment on column ${iol_schema}.nhrs_tbm_psndoc.pk_tbm_psndoc is '考勤档案主键';
comment on column ${iol_schema}.nhrs_tbm_psndoc.pk_team is '所属班组';
comment on column ${iol_schema}.nhrs_tbm_psndoc.secondcardid is '副卡号';
comment on column ${iol_schema}.nhrs_tbm_psndoc.tbm_prop is '考勤方式';
comment on column ${iol_schema}.nhrs_tbm_psndoc.timecardid is '考勤卡号';
comment on column ${iol_schema}.nhrs_tbm_psndoc.ts is '备用ts';
comment on column ${iol_schema}.nhrs_tbm_psndoc.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_tbm_psndoc.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_tbm_psndoc.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_tbm_psndoc.etl_timestamp is 'ETL处理时间戳';
