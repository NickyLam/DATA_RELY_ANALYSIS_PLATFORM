/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_aqcf_gpdb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,announcecontent varchar2(4000) -- 通报内容
    ,datakeyid varchar2(4000) -- 数据主键id
    ,aqcf_gpdb varchar2(4000) -- 关联标签
    ,datatype varchar2(4000) -- 数据类型值
    ,arbitrationtime varchar2(4000) -- 通报时间
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,announcementorgan varchar2(4000) -- 通报单位
    ,announcedate varchar2(4000) -- 通报事由
    ,casenumber varchar2(4000) -- 文书号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 被通报单位/个人名称
    ,casename varchar2(4000) -- 案件名称
    ,usccode varchar2(4000) -- 统一社会信用代码
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb is '应急安监-挂牌督办';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.announcecontent is '通报内容';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.aqcf_gpdb is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.arbitrationtime is '通报时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.announcementorgan is '通报单位';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.announcedate is '通报事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.casenumber is '文书号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.name is '被通报单位/个人名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.casename is '案件名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_aqcf_gpdb.etl_timestamp is 'ETL处理时间戳';
