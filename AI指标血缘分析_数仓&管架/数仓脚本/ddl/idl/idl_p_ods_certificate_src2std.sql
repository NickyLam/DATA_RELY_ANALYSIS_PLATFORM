/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl p_ods_certificate_src2std
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.p_ods_certificate_src2std
whenever sqlerror continue none;
drop table ${idl_schema}.p_ods_certificate_src2std purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.p_ods_certificate_src2std(
    src_system_id varchar2(8) -- 源系统简称
    ,source_cd varchar2(100) -- 源系统代码
    ,ep_flag char(1) -- 公私标志
    ,sourcd_cd_desc varchar2(100) -- 源系统代码说明
    ,ods_std_cd varchar2(10) -- 标准代码
    ,ods_std_desc varchar2(100) -- 标准代码说明
    ,ods_eff_dt date -- 生效日期
    ,ods_disc_dt date -- 失效日期
    --,etl_dt date -- ETL处理日期
    --,etl_timestamp timestamp -- ETL处理时间戳
)
;

-- grant
grant select on ${idl_schema}.p_ods_certificate_src2std to ${iel_schema};

-- comment
comment on table ${idl_schema}.p_ods_certificate_src2std is '证件类型编码标准对照表';
comment on column ${idl_schema}.p_ods_certificate_src2std.src_system_id is '源系统简称';
comment on column ${idl_schema}.p_ods_certificate_src2std.source_cd is '源系统代码';
comment on column ${idl_schema}.p_ods_certificate_src2std.ep_flag is '公私标志';
comment on column ${idl_schema}.p_ods_certificate_src2std.sourcd_cd_desc is '源系统代码说明';
comment on column ${idl_schema}.p_ods_certificate_src2std.ods_std_cd is '标准代码';
comment on column ${idl_schema}.p_ods_certificate_src2std.ods_std_desc is '标准代码说明';
comment on column ${idl_schema}.p_ods_certificate_src2std.ods_eff_dt is '生效日期';
comment on column ${idl_schema}.p_ods_certificate_src2std.ods_disc_dt is '失效日期';
--comment on column ${idl_schema}.p_ods_certificate_src2std.etl_dt is 'ETL处理日期';
--comment on column ${idl_schema}.p_ods_certificate_src2std.etl_timestamp is 'ETL处理时间戳';