/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_new_party_resume
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_new_party_resume
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_new_party_resume purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_new_party_resume(
    party_id varchar2(30) -- 客户号
    ,resumeid varchar2(30) -- 序号
    ,content_id varchar2(30) -- 内容标识
    ,resume_date timestamp -- 简历登记日期
    ,work_unit_name varchar2(383) -- 工作单位名称
    ,work_unit_addr varchar2(383) -- 工作单位地址
    ,work_unit_phone varchar2(383) -- 工作单位电话
    ,work_unit_property varchar2(150) -- 工作单位性质
    ,work_unit_belong_industry varchar2(30) -- 工作单位所属行业
    ,work_unit_zip_code varchar2(30) -- 工作单位邮编
    ,work_permit_no varchar2(90) -- 工作证号
    ,industry varchar2(90) -- 职业
    ,title varchar2(150) -- 职称
    ,duty varchar2(150) -- 职务
    ,work_month_lyincome number(18,2) -- 工作月收入
    ,work_property varchar2(150) -- 工作性质
    ,entry_date varchar2(30) -- 入职日期
    ,quit_date varchar2(30) -- 离职日期
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,other_occupation varchar2(90) -- 
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
grant select on ${iol_schema}.eifs_new_party_resume to ${iml_schema};
grant select on ${iol_schema}.eifs_new_party_resume to ${icl_schema};
grant select on ${iol_schema}.eifs_new_party_resume to ${idl_schema};
grant select on ${iol_schema}.eifs_new_party_resume to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_new_party_resume is '简历表（反序列化）';
comment on column ${iol_schema}.eifs_new_party_resume.party_id is '客户号';
comment on column ${iol_schema}.eifs_new_party_resume.resumeid is '序号';
comment on column ${iol_schema}.eifs_new_party_resume.content_id is '内容标识';
comment on column ${iol_schema}.eifs_new_party_resume.resume_date is '简历登记日期';
comment on column ${iol_schema}.eifs_new_party_resume.work_unit_name is '工作单位名称';
comment on column ${iol_schema}.eifs_new_party_resume.work_unit_addr is '工作单位地址';
comment on column ${iol_schema}.eifs_new_party_resume.work_unit_phone is '工作单位电话';
comment on column ${iol_schema}.eifs_new_party_resume.work_unit_property is '工作单位性质';
comment on column ${iol_schema}.eifs_new_party_resume.work_unit_belong_industry is '工作单位所属行业';
comment on column ${iol_schema}.eifs_new_party_resume.work_unit_zip_code is '工作单位邮编';
comment on column ${iol_schema}.eifs_new_party_resume.work_permit_no is '工作证号';
comment on column ${iol_schema}.eifs_new_party_resume.industry is '职业';
comment on column ${iol_schema}.eifs_new_party_resume.title is '职称';
comment on column ${iol_schema}.eifs_new_party_resume.duty is '职务';
comment on column ${iol_schema}.eifs_new_party_resume.work_month_lyincome is '工作月收入';
comment on column ${iol_schema}.eifs_new_party_resume.work_property is '工作性质';
comment on column ${iol_schema}.eifs_new_party_resume.entry_date is '入职日期';
comment on column ${iol_schema}.eifs_new_party_resume.quit_date is '离职日期';
comment on column ${iol_schema}.eifs_new_party_resume.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_new_party_resume.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_new_party_resume.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_new_party_resume.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_new_party_resume.other_occupation is '';
comment on column ${iol_schema}.eifs_new_party_resume.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_new_party_resume.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_new_party_resume.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_new_party_resume.etl_timestamp is 'ETL处理时间戳';
