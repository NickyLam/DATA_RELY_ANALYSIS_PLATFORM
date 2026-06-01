/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_jrhmd_jrhmd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 执行法院/作出判决机构
    ,jrhmd_jrhmd varchar2(4000) -- 关联标签
    ,datakeyid varchar2(4000) -- 数据主键id
    ,punishcategory varchar2(4000) -- 类型
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,penaltytime varchar2(4000) -- 列入日期
    ,province varchar2(4000) -- 省份
    ,wantedcircular varchar2(4000) -- 罪名
    ,casenumber varchar2(4000) -- 案号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 企业名称/自然人姓名
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd is '涉金融黑名单';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.punishmentorgan is '执行法院/作出判决机构';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.jrhmd_jrhmd is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.punishcategory is '类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.penaltytime is '列入日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.province is '省份';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.wantedcircular is '罪名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.casenumber is '案号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.name is '企业名称/自然人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_jrhmd_jrhmd.etl_timestamp is 'ETL处理时间戳';
