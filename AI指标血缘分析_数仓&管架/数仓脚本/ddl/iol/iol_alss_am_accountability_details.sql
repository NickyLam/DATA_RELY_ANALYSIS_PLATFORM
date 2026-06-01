/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_am_accountability_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_am_accountability_details
whenever sqlerror continue none;
drop table ${iol_schema}.alss_am_accountability_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_am_accountability_details(
    wthsa varchar2(180) -- 是否问责
    ,cta_num varchar2(180) -- 问责人数
    ,cta_m varchar2(180) -- 问责方式
    ,cta_dfa varchar2(180) -- 问责扣罚金额（元）
    ,cta_user varchar2(4000) -- 问责人员
    ,cta_desc varchar2(4000) -- 说明
    ,cta_doc_id varchar2(180) -- 附件
    ,data_release_id varchar2(180) -- 发布数据主键
    ,cta_doc_name varchar2(4000) -- 附件名称
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.alss_am_accountability_details to ${iml_schema};
grant select on ${iol_schema}.alss_am_accountability_details to ${icl_schema};
grant select on ${iol_schema}.alss_am_accountability_details to ${idl_schema};
grant select on ${iol_schema}.alss_am_accountability_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_am_accountability_details is '';
comment on column ${iol_schema}.alss_am_accountability_details.wthsa is '是否问责';
comment on column ${iol_schema}.alss_am_accountability_details.cta_num is '问责人数';
comment on column ${iol_schema}.alss_am_accountability_details.cta_m is '问责方式';
comment on column ${iol_schema}.alss_am_accountability_details.cta_dfa is '问责扣罚金额（元）';
comment on column ${iol_schema}.alss_am_accountability_details.cta_user is '问责人员';
comment on column ${iol_schema}.alss_am_accountability_details.cta_desc is '说明';
comment on column ${iol_schema}.alss_am_accountability_details.cta_doc_id is '附件';
comment on column ${iol_schema}.alss_am_accountability_details.data_release_id is '发布数据主键';
comment on column ${iol_schema}.alss_am_accountability_details.cta_doc_name is '附件名称';
comment on column ${iol_schema}.alss_am_accountability_details.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_am_accountability_details.etl_timestamp is 'ETL处理时间戳';
