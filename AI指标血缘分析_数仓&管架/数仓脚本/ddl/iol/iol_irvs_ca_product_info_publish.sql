/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol irvs_ca_product_info_publish
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.irvs_ca_product_info_publish
whenever sqlerror continue none;
drop table ${iol_schema}.irvs_ca_product_info_publish purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.irvs_ca_product_info_publish(
    id varchar2(50) -- 主键
    ,prd_cd varchar2(50) -- 产品编码
    ,title varchar2(1000) -- 标题
    ,content varchar2(4000) -- 内容
    ,doc_id varchar2(200) -- 文件ID
    ,doc_name varchar2(1000) -- 文件名称
    ,doc_url varchar2(200) -- 文件地址
    ,created_time date -- 创建时间
    ,created_by varchar2(50) -- 创建人
    ,updated_time date -- 更新时间
    ,updated_by varchar2(50) -- 更新人
    ,report_period varchar2(50) -- 报告期时间段
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
grant select on ${iol_schema}.irvs_ca_product_info_publish to ${iml_schema};
grant select on ${iol_schema}.irvs_ca_product_info_publish to ${icl_schema};
grant select on ${iol_schema}.irvs_ca_product_info_publish to ${idl_schema};
grant select on ${iol_schema}.irvs_ca_product_info_publish to ${iel_schema};

-- comment
comment on table ${iol_schema}.irvs_ca_product_info_publish is '产品信息披露表';
comment on column ${iol_schema}.irvs_ca_product_info_publish.id is '主键';
comment on column ${iol_schema}.irvs_ca_product_info_publish.prd_cd is '产品编码';
comment on column ${iol_schema}.irvs_ca_product_info_publish.title is '标题';
comment on column ${iol_schema}.irvs_ca_product_info_publish.content is '内容';
comment on column ${iol_schema}.irvs_ca_product_info_publish.doc_id is '文件ID';
comment on column ${iol_schema}.irvs_ca_product_info_publish.doc_name is '文件名称';
comment on column ${iol_schema}.irvs_ca_product_info_publish.doc_url is '文件地址';
comment on column ${iol_schema}.irvs_ca_product_info_publish.created_time is '创建时间';
comment on column ${iol_schema}.irvs_ca_product_info_publish.created_by is '创建人';
comment on column ${iol_schema}.irvs_ca_product_info_publish.updated_time is '更新时间';
comment on column ${iol_schema}.irvs_ca_product_info_publish.updated_by is '更新人';
comment on column ${iol_schema}.irvs_ca_product_info_publish.report_period is '报告期时间段';
comment on column ${iol_schema}.irvs_ca_product_info_publish.start_dt is '开始时间';
comment on column ${iol_schema}.irvs_ca_product_info_publish.end_dt is '结束时间';
comment on column ${iol_schema}.irvs_ca_product_info_publish.id_mark is '增删标志';
comment on column ${iol_schema}.irvs_ca_product_info_publish.etl_timestamp is 'ETL处理时间戳';
