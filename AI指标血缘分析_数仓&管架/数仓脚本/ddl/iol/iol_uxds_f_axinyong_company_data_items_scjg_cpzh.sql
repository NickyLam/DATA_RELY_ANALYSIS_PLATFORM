/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_scjg_cpzh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,penaltytime varchar2(4000) -- 时间
    ,datakeyid varchar2(4000) -- 数据主键id
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,datatype varchar2(4000) -- 数据类型值
    ,name varchar2(4000) -- 企业名称
    ,remark varchar2(4000) -- 备注
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,idnumber varchar2(4000) -- 身份证号码
    ,announcementorgan varchar2(4000) -- 公布机关
    ,title varchar2(4000) -- 标题
    ,scjg_cpzh varchar2(4000) -- 关联标签
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh is '市场监管-产品召回';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.penaltytime is '时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.name is '企业名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.announcementorgan is '公布机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.title is '标题';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.scjg_cpzh is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_cpzh.etl_timestamp is 'ETL处理时间戳';
