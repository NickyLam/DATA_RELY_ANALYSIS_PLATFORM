/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_ssjg_scjr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,companycode varchar2(4000) -- 公司代码
    ,punishmentorgan varchar2(4000) -- 处罚机关
    ,personnelinvolved varchar2(4000) -- 涉及对象
    ,datakeyid varchar2(4000) -- 数据主键id
    ,punishmenttitle varchar2(4000) -- 案件名称
    ,datatype varchar2(4000) -- 数据类型值
    ,punishmentbasis varchar2(4000) -- 处罚依据
    ,idnumber varchar2(4000) -- 身份证号码
    ,punishcause varchar2(4000) -- 处罚事由
    ,punishresult varchar2(4000) -- 处罚结果
    ,penaltytime varchar2(4000) -- 处罚决定日期
    ,replies varchar2(4000) -- 公司回复函
    ,casenumber varchar2(4000) -- 处罚决定书文号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,ssjg_scjr varchar2(4000) -- 关联标签
    ,name varchar2(4000) -- 处罚对象名称
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,companyabbreviation varchar2(4000) -- 公司简称
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr is '上市监管-市场禁入';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.companycode is '公司代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.punishmentorgan is '处罚机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.personnelinvolved is '涉及对象';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.punishmenttitle is '案件名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.punishmentbasis is '处罚依据';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.punishcause is '处罚事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.punishresult is '处罚结果';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.penaltytime is '处罚决定日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.replies is '公司回复函';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.casenumber is '处罚决定书文号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.ssjg_scjr is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.name is '处罚对象名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.companyabbreviation is '公司简称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_scjr.etl_timestamp is 'ETL处理时间戳';
