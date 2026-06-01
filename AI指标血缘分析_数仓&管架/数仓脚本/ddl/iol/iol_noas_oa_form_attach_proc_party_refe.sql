/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_oa_form_attach_proc_party_refe
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_oa_form_attach_proc_party_refe
whenever sqlerror continue none;
drop table ${iol_schema}.noas_oa_form_attach_proc_party_refe purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_form_attach_proc_party_refe(
    reference_id varchar2(30) -- 主键
    ,attachment_id varchar2(90) -- 附件id
    ,process_ins_id varchar2(90) -- 流程实例id
    ,form_def_id varchar2(30) -- 表单id
    ,last_updated_stamp timestamp -- bosent自带最后修改时间
    ,last_updated_tx_stamp timestamp -- bosent自带最后修改时间
    ,created_stamp timestamp -- bosent自带创建时间
    ,created_tx_stamp timestamp -- bosent自带创建时间
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
grant select on ${iol_schema}.noas_oa_form_attach_proc_party_refe to ${iml_schema};
grant select on ${iol_schema}.noas_oa_form_attach_proc_party_refe to ${icl_schema};
grant select on ${iol_schema}.noas_oa_form_attach_proc_party_refe to ${idl_schema};
grant select on ${iol_schema}.noas_oa_form_attach_proc_party_refe to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_oa_form_attach_proc_party_refe is '规章制度与附件关联信息';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.reference_id is '主键';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.attachment_id is '附件id';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.process_ins_id is '流程实例id';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.form_def_id is '表单id';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.last_updated_stamp is 'bosent自带最后修改时间';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.last_updated_tx_stamp is 'bosent自带最后修改时间';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.created_stamp is 'bosent自带创建时间';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.created_tx_stamp is 'bosent自带创建时间';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.start_dt is '开始时间';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.end_dt is '结束时间';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.id_mark is '增删标志';
comment on column ${iol_schema}.noas_oa_form_attach_proc_party_refe.etl_timestamp is 'ETL处理时间戳';
