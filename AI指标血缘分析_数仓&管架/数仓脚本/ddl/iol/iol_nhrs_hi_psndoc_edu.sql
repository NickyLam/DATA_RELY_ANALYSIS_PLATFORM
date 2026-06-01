/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_hi_psndoc_edu
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_hi_psndoc_edu
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_hi_psndoc_edu purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_hi_psndoc_edu(
    approveflag number(38,0) -- 审批标志
    ,begindate varchar2(15) -- 入学日期
    ,certifcode varchar2(63) -- 学位证书编号
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,degreedate varchar2(15) -- 学位授予日期
    ,degreeunit varchar2(576) -- 学位授予单位
    ,dr number(10,0) -- 备用dr
    ,education varchar2(30) -- 学历
    ,educationctifcode varchar2(63) -- 学历证书编号
    ,edusystem number(20,8) -- 学制
    ,enddate varchar2(15) -- 毕业日期
    ,lasteducation varchar2(2) -- 最高学历
    ,lastflag varchar2(2) -- 最近记录标志
    ,major varchar2(450) -- 专业
    ,majortype varchar2(30) -- 学历专业类别
    ,memo varchar2(2304) -- 备注
    ,modifiedtime varchar2(29) -- 修改时间
    ,modifier varchar2(30) -- 修改人
    ,period varchar2(15) -- 期间
    ,pk_degree varchar2(30) -- 学位
    ,pk_group varchar2(30) -- 所属集团
    ,pk_org varchar2(30) -- 所属组织
    ,pk_psndoc varchar2(30) -- 人员主键
    ,pk_psndoc_sub varchar2(30) -- 人员子表主键
    ,recordnum number(38,0) -- 记录序号
    ,school varchar2(1350) -- 学校
    ,schooltype varchar2(288) -- 学校类型
    ,studymode varchar2(30) -- 学习方式
    ,ts varchar2(29) -- 时间戳
    ,glbdef1 varchar2(30) -- 院校性质
    ,glbdef2 varchar2(30) -- 毕业/结业
    ,glbdef3 varchar2(2) -- 最高学位
    ,glbdef4 varchar2(2) -- 第一学历
    ,glbdef5 varchar2(2) -- 第一学位
    ,glbdef6 varchar2(30) -- 是否已获得学历证书
    ,glbdef7 varchar2(30) -- 是否已获得学位证书
    ,glbdef8 varchar2(30) -- 备用glbdef8
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
grant select on ${iol_schema}.nhrs_hi_psndoc_edu to ${iml_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_edu to ${icl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_edu to ${idl_schema};
grant select on ${iol_schema}.nhrs_hi_psndoc_edu to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_hi_psndoc_edu is '学历信息';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.approveflag is '审批标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.begindate is '入学日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.certifcode is '学位证书编号';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.creationtime is '创建时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.creator is '创建人';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.degreedate is '学位授予日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.degreeunit is '学位授予单位';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.dr is '备用dr';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.education is '学历';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.educationctifcode is '学历证书编号';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.edusystem is '学制';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.enddate is '毕业日期';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.lasteducation is '最高学历';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.lastflag is '最近记录标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.major is '专业';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.majortype is '学历专业类别';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.memo is '备注';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.modifiedtime is '修改时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.modifier is '修改人';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.period is '期间';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.pk_degree is '学位';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.pk_group is '所属集团';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.pk_org is '所属组织';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.pk_psndoc is '人员主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.pk_psndoc_sub is '人员子表主键';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.recordnum is '记录序号';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.school is '学校';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.schooltype is '学校类型';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.studymode is '学习方式';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.ts is '时间戳';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.glbdef1 is '院校性质';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.glbdef2 is '毕业/结业';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.glbdef3 is '最高学位';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.glbdef4 is '第一学历';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.glbdef5 is '第一学位';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.glbdef6 is '是否已获得学历证书';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.glbdef7 is '是否已获得学位证书';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.glbdef8 is '备用glbdef8';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_hi_psndoc_edu.etl_timestamp is 'ETL处理时间戳';
