/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_hbjg_zdpw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,punishmentorgan varchar2(4000) -- 公示单位
    ,hbjg_zdpw varchar2(4000) -- 关联标签
    ,datakeyid varchar2(4000) -- 数据主键id
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,datatype varchar2(4000) -- 数据类型值
    ,name varchar2(4000) -- 企业名称
    ,announcetime varchar2(4000) -- 公示时间
    ,pollutiontype varchar2(4000) -- 污染类型
    ,remark varchar2(4000) -- 备注
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw is '环保监管-重点排污';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.punishmentorgan is '公示单位';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.hbjg_zdpw is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.name is '企业名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.announcetime is '公示时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.pollutiontype is '污染类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_hbjg_zdpw.etl_timestamp is 'ETL处理时间戳';
