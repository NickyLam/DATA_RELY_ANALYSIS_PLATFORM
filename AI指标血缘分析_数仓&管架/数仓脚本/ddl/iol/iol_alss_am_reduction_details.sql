/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_am_reduction_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_am_reduction_details
whenever sqlerror continue none;
drop table ${iol_schema}.alss_am_reduction_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_am_reduction_details(
    wtafr varchar2(180) -- 是否申请核减
    ,adfr_date varchar2(180) -- 申请核减日期
    ,wtris varchar2(180) -- 是否核减成功
    ,var_type varchar2(180) -- 核减类型
    ,wticl varchar2(180) -- 是否出具解除函
    ,doc_l_name varchar2(3000) -- 解除函详情（附件名称）
    ,var_doc_id varchar2(180) -- 影像批次号
    ,data_release_id varchar2(180) -- 发布数据主键
    ,var_doc_name varchar2(3000) -- 核减附件名
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
grant select on ${iol_schema}.alss_am_reduction_details to ${iml_schema};
grant select on ${iol_schema}.alss_am_reduction_details to ${icl_schema};
grant select on ${iol_schema}.alss_am_reduction_details to ${idl_schema};
grant select on ${iol_schema}.alss_am_reduction_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_am_reduction_details is '';
comment on column ${iol_schema}.alss_am_reduction_details.wtafr is '是否申请核减';
comment on column ${iol_schema}.alss_am_reduction_details.adfr_date is '申请核减日期';
comment on column ${iol_schema}.alss_am_reduction_details.wtris is '是否核减成功';
comment on column ${iol_schema}.alss_am_reduction_details.var_type is '核减类型';
comment on column ${iol_schema}.alss_am_reduction_details.wticl is '是否出具解除函';
comment on column ${iol_schema}.alss_am_reduction_details.doc_l_name is '解除函详情（附件名称）';
comment on column ${iol_schema}.alss_am_reduction_details.var_doc_id is '影像批次号';
comment on column ${iol_schema}.alss_am_reduction_details.data_release_id is '发布数据主键';
comment on column ${iol_schema}.alss_am_reduction_details.var_doc_name is '核减附件名';
comment on column ${iol_schema}.alss_am_reduction_details.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.alss_am_reduction_details.etl_timestamp is 'ETL处理时间戳';
