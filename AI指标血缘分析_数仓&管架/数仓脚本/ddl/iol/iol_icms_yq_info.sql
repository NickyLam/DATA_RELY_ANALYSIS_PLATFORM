/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_yq_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_yq_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_yq_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_yq_info(
    doc_id varchar2(100) -- 文章号
    ,customer_id varchar2(100) -- 客户id
    ,label_id varchar2(100) -- 标签号
    ,topic_label varchar2(2000) -- 话题
    ,score varchar2(100) -- 舆情得分
    ,publish_time varchar2(100) -- 文章发表时间
    ,customer_name varchar2(256) -- 客户名称
    ,update_date date -- 修改日期
    ,create_date date -- 记录日期
    ,migtflag varchar2(80) -- 
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
grant select on ${iol_schema}.icms_yq_info to ${iml_schema};
grant select on ${iol_schema}.icms_yq_info to ${icl_schema};
grant select on ${iol_schema}.icms_yq_info to ${idl_schema};
grant select on ${iol_schema}.icms_yq_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_yq_info is '舆情信息';
comment on column ${iol_schema}.icms_yq_info.doc_id is '文章号';
comment on column ${iol_schema}.icms_yq_info.customer_id is '客户id';
comment on column ${iol_schema}.icms_yq_info.label_id is '标签号';
comment on column ${iol_schema}.icms_yq_info.topic_label is '话题';
comment on column ${iol_schema}.icms_yq_info.score is '舆情得分';
comment on column ${iol_schema}.icms_yq_info.publish_time is '文章发表时间';
comment on column ${iol_schema}.icms_yq_info.customer_name is '客户名称';
comment on column ${iol_schema}.icms_yq_info.update_date is '修改日期';
comment on column ${iol_schema}.icms_yq_info.create_date is '记录日期';
comment on column ${iol_schema}.icms_yq_info.migtflag is '';
comment on column ${iol_schema}.icms_yq_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_yq_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_yq_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_yq_info.etl_timestamp is 'ETL处理时间戳';
