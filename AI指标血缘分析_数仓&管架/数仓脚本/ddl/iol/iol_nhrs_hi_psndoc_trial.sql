/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psndoc_trial
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psndoc_trial
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psndoc_trial purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_trial(
    assgid number(38,0) -- 人员任职id
    ,begindate varchar2(15) -- 开始日期
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dr number(10,0) -- 备用dr
    ,enddate varchar2(15) -- 结束日期
    ,endflag varchar2(2) -- 是否结束
    ,lastflag varchar2(2) -- 最近记录标志
    ,memo varchar2(2304) -- 备注
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,pk_group varchar2(30) -- 所属集团
    ,pk_hrorg varchar2(30) -- 人力资源组织
    ,pk_org varchar2(30) -- 所属组织
    ,pk_psndoc varchar2(30) -- 人员主键
    ,pk_psndoc_sub varchar2(30) -- 人员子表主键
    ,pk_psnjob varchar2(30) -- 人员工作记录主键
    ,pk_psnorg varchar2(30) -- 组织关系主键
    ,recordnum number(38,0) -- 记录序号
    ,regulardate varchar2(15) -- 转正日期
    ,trial_type number(38,0) -- 试用类型(1=入职试用，2=转岗试用)
    ,trialresult number(38,0) -- 试用结果
    ,ts varchar2(29) -- 时间戳
    ,glbdef1 varchar2(192) -- 试用期限（月）
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
grant select on ${iol_schema}.nhrs_hi_psndoc_trial to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_trial to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_trial to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_trial to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psndoc_trial is '试用情况';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.assgid is '人员任职id';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.begindate is '开始日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.enddate is '结束日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.endflag is '是否结束';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.lastflag is '最近记录标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.memo is '备注';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.pk_group is '所属集团';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.pk_hrorg is '人力资源组织';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.pk_org is '所属组织';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.pk_psndoc is '人员主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.pk_psndoc_sub is '人员子表主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.pk_psnjob is '人员工作记录主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.pk_psnorg is '组织关系主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.regulardate is '转正日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.trial_type is '试用类型(1=入职试用，2=转岗试用)';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.trialresult is '试用结果';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.glbdef1 is '试用期限（月）';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_trial.etl_timestamp is 'ETL处理时间戳';
