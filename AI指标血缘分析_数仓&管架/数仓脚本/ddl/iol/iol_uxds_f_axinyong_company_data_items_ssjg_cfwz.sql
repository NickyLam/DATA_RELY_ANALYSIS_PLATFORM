/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_ssjg_cfwz
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz(
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
    ,ssjg_cfwz varchar2(4000) -- 关联标签
    ,punishcause varchar2(4000) -- 处罚事由
    ,punishresult varchar2(4000) -- 处罚结果
    ,penaltytime varchar2(4000) -- 处罚决定日期
    ,replies varchar2(4000) -- 公司回复函
    ,casenumber varchar2(4000) -- 处罚决定书文号
    ,legalperson varchar2(4000) -- 法定代表人姓名
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz is '上市监管-处罚问责';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.companycode is '公司代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.punishmentorgan is '处罚机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.personnelinvolved is '涉及对象';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.punishmenttitle is '案件名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.punishmentbasis is '处罚依据';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.ssjg_cfwz is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.punishcause is '处罚事由';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.punishresult is '处罚结果';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.penaltytime is '处罚决定日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.replies is '公司回复函';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.casenumber is '处罚决定书文号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.name is '处罚对象名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.companyabbreviation is '公司简称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_ssjg_cfwz.etl_timestamp is 'ETL处理时间戳';
