/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_gdwx_xzcf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 处罚机关
    ,datakeyid varchar2(4000) -- 数据主键id
    ,punishmenttitle varchar2(4000) -- 处罚名称
    ,datatype varchar2(4000) -- 数据类型值
    ,remark varchar2(4000) -- 备注
    ,punishmentbasis varchar2(4000) -- 处罚依据
    ,idnumber varchar2(4000) -- 身份证号码
    ,punishcause varchar2(4000) -- 处罚事由
    ,punishresult varchar2(4000) -- 处罚结果
    ,penaltytime varchar2(4000) -- 处罚时间
    ,casenumber varchar2(4000) -- 文书字号
    ,legalperson varchar2(4000) -- 法定代表人
    ,name varchar2(4000) -- 处罚对象名称
    ,gdwx_xzcf varchar2(4000) -- 关联标签
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf is '广电网信-行政处罚';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.punishmentorgan is '处罚机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.punishmenttitle is '处罚名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.punishmentbasis is '处罚依据';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.punishcause is '处罚事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.punishresult is '处罚结果';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.penaltytime is '处罚时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.casenumber is '文书字号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.legalperson is '法定代表人';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.name is '处罚对象名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.gdwx_xzcf is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_gdwx_xzcf.etl_timestamp is 'ETL处理时间戳';
