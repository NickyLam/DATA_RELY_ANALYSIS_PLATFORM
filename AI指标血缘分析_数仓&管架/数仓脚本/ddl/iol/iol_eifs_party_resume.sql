/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_party_resume
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_party_resume
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_party_resume purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_party_resume(
    resume_id varchar2(30) -- 工作信息序号标识
    ,party_id varchar2(30) -- 当事人标识
    ,content_id varchar2(30) -- 内容标识
    ,resume_date timestamp -- 简历登记日期
    ,resume_text varchar2(4000) -- 工作文本信息
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
grant select on ${iol_schema}.eifs_party_resume to ${iml_schema};
grant select on ${iol_schema}.eifs_party_resume to ${icl_schema};
grant select on ${iol_schema}.eifs_party_resume to ${idl_schema};
grant select on ${iol_schema}.eifs_party_resume to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_party_resume is '当事人关系人记录表';
comment on column ${iol_schema}.eifs_party_resume.resume_id is '工作信息序号标识';
comment on column ${iol_schema}.eifs_party_resume.party_id is '当事人标识';
comment on column ${iol_schema}.eifs_party_resume.content_id is '内容标识';
comment on column ${iol_schema}.eifs_party_resume.resume_date is '简历登记日期';
comment on column ${iol_schema}.eifs_party_resume.resume_text is '工作文本信息';
comment on column ${iol_schema}.eifs_party_resume.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_party_resume.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_party_resume.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_party_resume.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_party_resume.other_occupation is '';
comment on column ${iol_schema}.eifs_party_resume.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_party_resume.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_party_resume.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_party_resume.etl_timestamp is 'ETL处理时间戳';
