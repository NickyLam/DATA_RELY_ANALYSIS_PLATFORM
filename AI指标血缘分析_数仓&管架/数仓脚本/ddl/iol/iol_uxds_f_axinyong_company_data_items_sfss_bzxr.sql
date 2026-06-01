/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_sfss_bzxr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 执行法院
    ,targetamount varchar2(4000) -- 执行标的
    ,casenumber varchar2(4000) -- 执行案号
    ,datakeyid varchar2(4000) -- 数据主键ID
    ,sfss_bzxr varchar2(4000) -- 关联标签
    ,datatype varchar2(4000) -- 数据类型值
    ,name varchar2(4000) -- 被执行人姓名/名称
    ,remark varchar2(4000) -- 备注
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,idnumber varchar2(4000) -- 身份证号码
    ,filingtime varchar2(4000) -- 立案时间
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr is '司法涉诉-被执行人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.punishmentorgan is '执行法院';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.targetamount is '执行标的';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.casenumber is '执行案号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.datakeyid is '数据主键ID';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.sfss_bzxr is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.name is '被执行人姓名/名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.filingtime is '立案时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_bzxr.etl_timestamp is 'ETL处理时间戳';
