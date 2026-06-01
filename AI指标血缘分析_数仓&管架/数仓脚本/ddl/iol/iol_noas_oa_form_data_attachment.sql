/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_oa_form_data_attachment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_oa_form_data_attachment
whenever sqlerror continue none;
drop table ${iol_schema}.noas_oa_form_data_attachment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_form_data_attachment(
    attachment_id varchar2(90) -- 主键
    ,attach_name varchar2(1500) -- 附件唯一名
    ,attach_path varchar2(1500) -- 附件实际存放路径
    ,attach_order varchar2(15) -- 附件顺序
    ,show_attach_name varchar2(1500) -- 附件显示名
    ,party_id varchar2(30) -- 上传人
    ,attachment_type varchar2(15) -- 文件类型：0正文类型，1附件类型,2合成文件，3，表单附件
    ,last_updated_stamp timestamp -- bosent自带最后修改时间
    ,last_updated_tx_stamp timestamp -- bosent自带最后修改时间
    ,created_stamp timestamp -- bosent自带创建时间
    ,created_tx_stamp timestamp -- bosent自带创建时间
    ,content_type_id varchar2(30) -- 文号类型，用于记录当前合成文件所用的模板类型
    ,is_cheack_stlye varchar2(15) -- 排版环节标记是否已重新合成
    ,upper_level_id varchar2(30) -- 父级id
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
grant select on ${iol_schema}.noas_oa_form_data_attachment to ${iml_schema};
grant select on ${iol_schema}.noas_oa_form_data_attachment to ${icl_schema};
grant select on ${iol_schema}.noas_oa_form_data_attachment to ${idl_schema};
grant select on ${iol_schema}.noas_oa_form_data_attachment to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_oa_form_data_attachment is '规章制度附件信息';
comment on column ${iol_schema}.noas_oa_form_data_attachment.attachment_id is '主键';
comment on column ${iol_schema}.noas_oa_form_data_attachment.attach_name is '附件唯一名';
comment on column ${iol_schema}.noas_oa_form_data_attachment.attach_path is '附件实际存放路径';
comment on column ${iol_schema}.noas_oa_form_data_attachment.attach_order is '附件顺序';
comment on column ${iol_schema}.noas_oa_form_data_attachment.show_attach_name is '附件显示名';
comment on column ${iol_schema}.noas_oa_form_data_attachment.party_id is '上传人';
comment on column ${iol_schema}.noas_oa_form_data_attachment.attachment_type is '文件类型：0正文类型，1附件类型,2合成文件，3，表单附件';
comment on column ${iol_schema}.noas_oa_form_data_attachment.last_updated_stamp is 'bosent自带最后修改时间';
comment on column ${iol_schema}.noas_oa_form_data_attachment.last_updated_tx_stamp is 'bosent自带最后修改时间';
comment on column ${iol_schema}.noas_oa_form_data_attachment.created_stamp is 'bosent自带创建时间';
comment on column ${iol_schema}.noas_oa_form_data_attachment.created_tx_stamp is 'bosent自带创建时间';
comment on column ${iol_schema}.noas_oa_form_data_attachment.content_type_id is '文号类型，用于记录当前合成文件所用的模板类型';
comment on column ${iol_schema}.noas_oa_form_data_attachment.is_cheack_stlye is '排版环节标记是否已重新合成';
comment on column ${iol_schema}.noas_oa_form_data_attachment.upper_level_id is '父级id';
comment on column ${iol_schema}.noas_oa_form_data_attachment.start_dt is '开始时间';
comment on column ${iol_schema}.noas_oa_form_data_attachment.end_dt is '结束时间';
comment on column ${iol_schema}.noas_oa_form_data_attachment.id_mark is '增删标志';
comment on column ${iol_schema}.noas_oa_form_data_attachment.etl_timestamp is 'ETL处理时间戳';
