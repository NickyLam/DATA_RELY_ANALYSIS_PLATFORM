/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psnorg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psnorg
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psnorg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psnorg(
    begindate varchar2(10) -- 进入日期
    ,creationtime varchar2(19) -- 创建时间
    ,creator varchar2(20) -- 创建人
    ,dr number(10,0) -- 备用DR
    ,empforms varchar2(20) -- 用工形式
    ,enddate varchar2(10) -- 退出日期
    ,endflag varchar2(1) -- 是否终止
    ,indoc_source number(38,0) -- 入职来源
    ,indocflag varchar2(1) -- 是否转入人员档案
    ,joinsysdate varchar2(10) -- 进入集团日期
    ,lastflag varchar2(1) -- 最新标志
    ,modifiedtime varchar2(19) -- 修改时间
    ,modifier varchar2(20) -- 修改人
    ,orgrelaid number(38,0) -- 组织关系ID
    ,pk_group varchar2(20) -- 所属集团
    ,pk_hrorg varchar2(20) -- 人力资源组织
    ,pk_org varchar2(20) -- 组织
    ,pk_psndoc varchar2(20) -- 人员主键
    ,pk_psnorg varchar2(20) -- 组织关系主键
    ,psntype number(38,0) -- 人员类型
    ,startpaydate varchar2(10) -- 薪资开始日期
    ,stoppaydate varchar2(10) -- 薪资停发日期
    ,ts varchar2(19) -- 备用TS
    ,workage number(38,0) -- 备用WORKAGE
    ,orgglbdef1 varchar2(19) -- 备用ORGGLBDEF1
    ,orgglbdef2 varchar2(10) -- 备用ORGGLBDEF2
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
grant select on ${iol_schema}.nhrs_hi_psnorg to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psnorg to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psnorg to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psnorg to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psnorg is '组织关系';
comment on column ${iol_schema}.nhrs_hi_psnorg.begindate is '进入日期';
comment on column ${iol_schema}.nhrs_hi_psnorg.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psnorg.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psnorg.dr is '备用DR';
comment on column ${iol_schema}.nhrs_hi_psnorg.empforms is '用工形式';
comment on column ${iol_schema}.nhrs_hi_psnorg.enddate is '退出日期';
comment on column ${iol_schema}.nhrs_hi_psnorg.endflag is '是否终止';
comment on column ${iol_schema}.nhrs_hi_psnorg.indoc_source is '入职来源';
comment on column ${iol_schema}.nhrs_hi_psnorg.indocflag is '是否转入人员档案';
comment on column ${iol_schema}.nhrs_hi_psnorg.joinsysdate is '进入集团日期';
comment on column ${iol_schema}.nhrs_hi_psnorg.lastflag is '最新标志';
comment on column ${iol_schema}.nhrs_hi_psnorg.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psnorg.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psnorg.orgrelaid is '组织关系ID';
comment on column ${iol_schema}.nhrs_hi_psnorg.pk_group is '所属集团';
comment on column ${iol_schema}.nhrs_hi_psnorg.pk_hrorg is '人力资源组织';
comment on column ${iol_schema}.nhrs_hi_psnorg.pk_org is '组织';
comment on column ${iol_schema}.nhrs_hi_psnorg.pk_psndoc is '人员主键';
comment on column ${iol_schema}.nhrs_hi_psnorg.pk_psnorg is '组织关系主键';
comment on column ${iol_schema}.nhrs_hi_psnorg.psntype is '人员类型';
comment on column ${iol_schema}.nhrs_hi_psnorg.startpaydate is '薪资开始日期';
comment on column ${iol_schema}.nhrs_hi_psnorg.stoppaydate is '薪资停发日期';
comment on column ${iol_schema}.nhrs_hi_psnorg.ts is '备用TS';
comment on column ${iol_schema}.nhrs_hi_psnorg.workage is '备用WORKAGE';
comment on column ${iol_schema}.nhrs_hi_psnorg.orgglbdef1 is '备用ORGGLBDEF1';
comment on column ${iol_schema}.nhrs_hi_psnorg.orgglbdef2 is '备用ORGGLBDEF2';
comment on column ${iol_schema}.nhrs_hi_psnorg.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psnorg.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psnorg.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psnorg.etl_timestamp is 'ETL处理时间戳';
