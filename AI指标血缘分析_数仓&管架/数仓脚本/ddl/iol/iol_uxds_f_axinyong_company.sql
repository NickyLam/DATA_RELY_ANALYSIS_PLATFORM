/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,code varchar2(4000) -- 响应码
    ,success varchar2(4000) -- 查询状态
    ,data_items varchar2(4000) -- data_items
    ,data_pagination varchar2(4000) -- data_pagination
    ,message varchar2(4000) -- 响应信息
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
grant select on ${iol_schema}.uxds_f_axinyong_company to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company is '全民信-行政处罚数据(企业查询)';
comment on column ${iol_schema}.uxds_f_axinyong_company.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company.code is '响应码';
comment on column ${iol_schema}.uxds_f_axinyong_company.success is '查询状态';
comment on column ${iol_schema}.uxds_f_axinyong_company.data_items is 'data_items';
comment on column ${iol_schema}.uxds_f_axinyong_company.data_pagination is 'data_pagination';
comment on column ${iol_schema}.uxds_f_axinyong_company.message is '响应信息';
comment on column ${iol_schema}.uxds_f_axinyong_company.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company.etl_timestamp is 'ETL处理时间戳';
