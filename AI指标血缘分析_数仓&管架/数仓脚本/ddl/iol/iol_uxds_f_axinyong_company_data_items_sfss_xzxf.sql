/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_sfss_xzxf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 执行法院
    ,datakeyid varchar2(4000) -- 数据主键id
    ,sex varchar2(4000) -- 性别
    ,implementation varchar2(4000) -- 执行内容
    ,datatype varchar2(4000) -- 数据类型值
    ,cause varchar2(4000) -- 案由
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,filingtime varchar2(4000) -- 立案时间
    ,sfss_xzxf varchar2(4000) -- 关联标签
    ,casenumber varchar2(4000) -- 案号
    ,name varchar2(4000) -- 限制消费人员姓名
    ,zqr varchar2(4000) -- 申请执行人
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,bzxr varchar2(4000) -- 失信被执行人
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf is '司法涉诉-限制高消费';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.punishmentorgan is '执行法院';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.sex is '性别';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.implementation is '执行内容';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.cause is '案由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.filingtime is '立案时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.sfss_xzxf is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.casenumber is '案号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.name is '限制消费人员姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.zqr is '申请执行人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.bzxr is '失信被执行人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_sfss_xzxf.etl_timestamp is 'ETL处理时间戳';
