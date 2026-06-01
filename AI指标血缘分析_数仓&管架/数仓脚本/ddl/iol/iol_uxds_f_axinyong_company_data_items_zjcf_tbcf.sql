/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_zjcf_tbcf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,announcecontent varchar2(4000) -- 通报内容
    ,datakeyid varchar2(4000) -- 数据主键id
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
    ,zjcf_tbcf varchar2(4000) -- 关联标签
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf is '住建处罚-通报处罚';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.announcecontent is '通报内容';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.arbitrationtime is '通报时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.announcementorgan is '通报单位';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.announcedate is '通报事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.casenumber is '文书号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.name is '被通报单位/个人名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.casename is '案件名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.zjcf_tbcf is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zjcf_tbcf.etl_timestamp is 'ETL处理时间戳';
