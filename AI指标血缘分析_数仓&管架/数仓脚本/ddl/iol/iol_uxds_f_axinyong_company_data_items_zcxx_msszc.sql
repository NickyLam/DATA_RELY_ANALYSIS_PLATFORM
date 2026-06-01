/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_zcxx_msszc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,zcxx_msszc varchar2(4000) -- 关联标签
    ,disputecase varchar2(4000) -- 纠纷案由
    ,casenumber varchar2(4000) -- 案号
    ,datakeyid varchar2(4000) -- 数据主键ID
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,datatype varchar2(4000) -- 数据类型值
    ,name varchar2(4000) -- 被申请人
    ,arbitrationtime varchar2(4000) -- 仲裁时间
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,arbitralbody varchar2(4000) -- 仲裁机构
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc is '仲裁信息-民商事仲裁';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.zcxx_msszc is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.disputecase is '纠纷案由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.casenumber is '案号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.datakeyid is '数据主键ID';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.name is '被申请人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.arbitrationtime is '仲裁时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.arbitralbody is '仲裁机构';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_zcxx_msszc.etl_timestamp is 'ETL处理时间戳';
