/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_oa_form_item_data
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_oa_form_item_data
whenever sqlerror continue none;
drop table ${iol_schema}.noas_oa_form_item_data purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_form_item_data(
    form_item_data_id varchar2(30) -- 主键
    ,process_ins_id varchar2(90) -- 流程实体id
    ,item_key varchar2(90) -- 表单key
    ,item_value varchar2(4000) -- 表单value
    ,form_def_id varchar2(30) -- 表单定义id
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,process_status varchar2(30) -- 1,审批中，2审批通过，3，已拒绝
    ,data_year varchar2(15) -- 数据年份
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
grant select on ${iol_schema}.noas_oa_form_item_data to ${iml_schema};
grant select on ${iol_schema}.noas_oa_form_item_data to ${icl_schema};
grant select on ${iol_schema}.noas_oa_form_item_data to ${idl_schema};
grant select on ${iol_schema}.noas_oa_form_item_data to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_oa_form_item_data is '表单表';
comment on column ${iol_schema}.noas_oa_form_item_data.form_item_data_id is '主键';
comment on column ${iol_schema}.noas_oa_form_item_data.process_ins_id is '流程实体id';
comment on column ${iol_schema}.noas_oa_form_item_data.item_key is '表单key';
comment on column ${iol_schema}.noas_oa_form_item_data.item_value is '表单value';
comment on column ${iol_schema}.noas_oa_form_item_data.form_def_id is '表单定义id';
comment on column ${iol_schema}.noas_oa_form_item_data.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.noas_oa_form_item_data.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.noas_oa_form_item_data.created_stamp is '创建时间';
comment on column ${iol_schema}.noas_oa_form_item_data.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.noas_oa_form_item_data.process_status is '1,审批中，2审批通过，3，已拒绝';
comment on column ${iol_schema}.noas_oa_form_item_data.data_year is '数据年份';
comment on column ${iol_schema}.noas_oa_form_item_data.start_dt is '开始时间';
comment on column ${iol_schema}.noas_oa_form_item_data.end_dt is '结束时间';
comment on column ${iol_schema}.noas_oa_form_item_data.id_mark is '增删标志';
comment on column ${iol_schema}.noas_oa_form_item_data.etl_timestamp is 'ETL处理时间戳';
