/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_scjg_wfsx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishcause varchar2(4000) -- 列入原因
    ,punishmentorgan varchar2(4000) -- 处罚机关
    ,penaltytime varchar2(4000) -- 列入日期
    ,casenumber varchar2(4000) -- 文书字号
    ,datakeyid varchar2(4000) -- 数据主键id
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,datatype varchar2(4000) -- 数据类型值
    ,name varchar2(4000) -- 企业名称
    ,remark varchar2(4000) -- 备注
    ,scjg_wfsx varchar2(4000) -- 关联标签
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,idnumber varchar2(4000) -- 身份证号码
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx is '市场监管-违法失信企业';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.punishcause is '列入原因';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.punishmentorgan is '处罚机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.penaltytime is '列入日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.casenumber is '文书字号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.name is '企业名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.scjg_wfsx is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_wfsx.etl_timestamp is 'ETL处理时间戳';
