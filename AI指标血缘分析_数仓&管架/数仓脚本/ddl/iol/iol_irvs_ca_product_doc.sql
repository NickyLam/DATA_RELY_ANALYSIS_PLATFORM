/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol irvs_ca_product_doc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.irvs_ca_product_doc
whenever sqlerror continue none;
drop table ${iol_schema}.irvs_ca_product_doc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.irvs_ca_product_doc(
    id varchar2(50) -- 主键
    ,prod_id varchar2(50) -- 关联表主键ID，例产品表ID
    ,prd_cd varchar2(50) -- 产品编码
    ,doc_id varchar2(200) -- 文件ID
    ,doc_name varchar2(1000) -- 文件名称
    ,doc_url varchar2(200) -- 文件地址
    ,file_id varchar2(50) -- 文件表关联ID
    ,file_type varchar2(20) -- 01-信托合同,02-认购风险申明书,03-认购风险申明书之补充协议,04-信托计划说明书,05-产品发行公告,06-电子签名约定书,07-推介视频,08-其他
    ,created_time date -- 创建时间
    ,created_by varchar2(50) -- 创建人
    ,updated_time date -- 更新时间
    ,updated_by varchar2(50) -- 更新人
    ,sign_type varchar2(10) -- 文件类别 00文件 01签字文件 02已签署文件  03压缩包
    ,parent_id varchar2(50) -- 父id
    ,sign_status varchar2(10) -- 文件类别 00不需要签署 01需要签署
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.irvs_ca_product_doc to ${iml_schema};
grant select on ${iol_schema}.irvs_ca_product_doc to ${icl_schema};
grant select on ${iol_schema}.irvs_ca_product_doc to ${idl_schema};
grant select on ${iol_schema}.irvs_ca_product_doc to ${iel_schema};

-- comment
comment on table ${iol_schema}.irvs_ca_product_doc is '产品附件表';
comment on column ${iol_schema}.irvs_ca_product_doc.id is '主键';
comment on column ${iol_schema}.irvs_ca_product_doc.prod_id is '关联表主键ID，例产品表ID';
comment on column ${iol_schema}.irvs_ca_product_doc.prd_cd is '产品编码';
comment on column ${iol_schema}.irvs_ca_product_doc.doc_id is '文件ID';
comment on column ${iol_schema}.irvs_ca_product_doc.doc_name is '文件名称';
comment on column ${iol_schema}.irvs_ca_product_doc.doc_url is '文件地址';
comment on column ${iol_schema}.irvs_ca_product_doc.file_id is '文件表关联ID';
comment on column ${iol_schema}.irvs_ca_product_doc.file_type is '01-信托合同,02-认购风险申明书,03-认购风险申明书之补充协议,04-信托计划说明书,05-产品发行公告,06-电子签名约定书,07-推介视频,08-其他';
comment on column ${iol_schema}.irvs_ca_product_doc.created_time is '创建时间';
comment on column ${iol_schema}.irvs_ca_product_doc.created_by is '创建人';
comment on column ${iol_schema}.irvs_ca_product_doc.updated_time is '更新时间';
comment on column ${iol_schema}.irvs_ca_product_doc.updated_by is '更新人';
comment on column ${iol_schema}.irvs_ca_product_doc.sign_type is '文件类别 00文件 01签字文件 02已签署文件  03压缩包';
comment on column ${iol_schema}.irvs_ca_product_doc.parent_id is '父id';
comment on column ${iol_schema}.irvs_ca_product_doc.sign_status is '文件类别 00不需要签署 01需要签署';
comment on column ${iol_schema}.irvs_ca_product_doc.start_dt is '开始时间';
comment on column ${iol_schema}.irvs_ca_product_doc.end_dt is '结束时间';
comment on column ${iol_schema}.irvs_ca_product_doc.id_mark is '增删标志';
comment on column ${iol_schema}.irvs_ca_product_doc.etl_timestamp is 'ETL处理时间戳';
