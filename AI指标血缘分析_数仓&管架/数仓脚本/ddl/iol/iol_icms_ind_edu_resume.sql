/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_edu_resume
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_edu_resume
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_edu_resume purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_edu_resume(
    serialno varchar2(64) -- 流水号
    ,specialty varchar2(160) -- 专业
    ,degree varchar2(18) -- 最高学位
    ,school varchar2(160) -- 所在学校
    ,inputuserid varchar2(64) -- 登记人
    ,updateuserid varchar2(64) -- 更新人
    ,degreeno varchar2(64) -- 学位证书号
    ,department varchar2(160) -- 所在院系
    ,remark varchar2(1000) -- 备注
    ,customerid varchar2(16) -- 客户编号
    ,migtflag varchar2(80) -- 
    ,corporgid varchar2(64) -- 法人机构编号
    ,begindate date -- 开始日
    ,enddate date -- 结束日
    ,inputorgid varchar2(64) -- 登记机构
    ,updateorgid varchar2(64) -- 更新机构
    ,eduexperience varchar2(18) -- 最高学历
    ,diplomano varchar2(64) -- 学历证书号
    ,inputdate date -- 登记日期
    ,schoollength number(18,2) -- 学制
    ,updatedate date -- 更新日期
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
grant select on ${iol_schema}.icms_ind_edu_resume to ${iml_schema};
grant select on ${iol_schema}.icms_ind_edu_resume to ${icl_schema};
grant select on ${iol_schema}.icms_ind_edu_resume to ${idl_schema};
grant select on ${iol_schema}.icms_ind_edu_resume to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_edu_resume is '个人学业履历个人学业履历';
comment on column ${iol_schema}.icms_ind_edu_resume.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_edu_resume.specialty is '专业';
comment on column ${iol_schema}.icms_ind_edu_resume.degree is '最高学位';
comment on column ${iol_schema}.icms_ind_edu_resume.school is '所在学校';
comment on column ${iol_schema}.icms_ind_edu_resume.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_edu_resume.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_edu_resume.degreeno is '学位证书号';
comment on column ${iol_schema}.icms_ind_edu_resume.department is '所在院系';
comment on column ${iol_schema}.icms_ind_edu_resume.remark is '备注';
comment on column ${iol_schema}.icms_ind_edu_resume.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_edu_resume.migtflag is '';
comment on column ${iol_schema}.icms_ind_edu_resume.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_edu_resume.begindate is '开始日';
comment on column ${iol_schema}.icms_ind_edu_resume.enddate is '结束日';
comment on column ${iol_schema}.icms_ind_edu_resume.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_edu_resume.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_edu_resume.eduexperience is '最高学历';
comment on column ${iol_schema}.icms_ind_edu_resume.diplomano is '学历证书号';
comment on column ${iol_schema}.icms_ind_edu_resume.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_edu_resume.schoollength is '学制';
comment on column ${iol_schema}.icms_ind_edu_resume.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_edu_resume.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_edu_resume.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_edu_resume.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_edu_resume.etl_timestamp is 'ETL处理时间戳';
