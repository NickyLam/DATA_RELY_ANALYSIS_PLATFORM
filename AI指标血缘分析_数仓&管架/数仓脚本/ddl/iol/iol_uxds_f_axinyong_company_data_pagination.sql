/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_pagination
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_pagination
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_pagination purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_pagination(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,total varchar2(4000) -- 总条数
    ,pagecount varchar2(4000) -- 总页数
    ,previouspage varchar2(4000) -- 上一页页码
    ,nextpage varchar2(4000) -- 下一页页码
    ,currentcount varchar2(4000) -- 当前页条数
    ,data_pagination varchar2(4000) -- 关联标签
    ,currentpage varchar2(4000) -- 当前页数
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
grant select on ${iol_schema}.uxds_f_axinyong_company_data_pagination to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_pagination to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_pagination to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_pagination to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_pagination is '全民信-行政处罚数据(企业查询)';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.total is '总条数';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.pagecount is '总页数';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.previouspage is '上一页页码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.nextpage is '下一页页码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.currentcount is '当前页条数';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.data_pagination is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.currentpage is '当前页数';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_pagination.etl_timestamp is 'ETL处理时间戳';
