/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_huikehongye_document_topic_label_arr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr(
    gendate varchar2(4000) -- 生成时间
    ,sequenceid varchar2(4000) -- 系统流水号
    ,name varchar2(4000) -- 话题标签
    ,top5 varchar2(4000) -- 排名前5 的话题标签
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
grant select on ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr to ${iml_schema};
grant select on ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr to ${icl_schema};
grant select on ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr to ${idl_schema};
grant select on ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr is '慧科讯业关联公司表';
comment on column ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr.name is '话题标签';
comment on column ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr.top5 is '排名前5 的话题标签';
comment on column ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_huikehongye_document_topic_label_arr.etl_timestamp is 'ETL处理时间戳';
