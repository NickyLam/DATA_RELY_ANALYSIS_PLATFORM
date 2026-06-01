/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_oa_form_item_data_extend
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_oa_form_item_data_extend
whenever sqlerror continue none;
drop table ${iol_schema}.noas_oa_form_item_data_extend purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_form_item_data_extend(
    extend_id varchar2(30) -- 主键
    ,item_content varchar2(4000) -- 内容
    ,status varchar2(90) -- 状态
    ,batch_no varchar2(90) -- 批号
    ,party_id varchar2(30) -- 人员id
    ,process_ins_id varchar2(90) -- 流程实例id
    ,flow_type_id varchar2(30) -- 流程类型id
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,item_key varchar2(90) -- 表单key
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
grant select on ${iol_schema}.noas_oa_form_item_data_extend to ${iml_schema};
grant select on ${iol_schema}.noas_oa_form_item_data_extend to ${icl_schema};
grant select on ${iol_schema}.noas_oa_form_item_data_extend to ${idl_schema};
grant select on ${iol_schema}.noas_oa_form_item_data_extend to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_oa_form_item_data_extend is '表单扩展表';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.extend_id is '主键';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.item_content is '内容';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.status is '状态';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.batch_no is '批号';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.party_id is '人员id';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.process_ins_id is '流程实例id';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.flow_type_id is '流程类型id';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.created_stamp is '创建时间';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.item_key is '表单key';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.start_dt is '开始时间';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.end_dt is '结束时间';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.id_mark is '增删标志';
comment on column ${iol_schema}.noas_oa_form_item_data_extend.etl_timestamp is 'ETL处理时间戳';
