/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cchs_uomp_workbill_callback
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cchs_uomp_workbill_callback
whenever sqlerror continue none;
drop table ${iol_schema}.cchs_uomp_workbill_callback purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cchs_uomp_workbill_callback(
    code varchar2(50) -- 工单回访流水号
    ,workbill_no varchar2(30) -- 工单编号
    ,return_visit_date varchar2(30) -- 回访时间
    ,create_name varchar2(30) -- 创建者名称
    ,return_visit_content varchar2(1000) -- 回访内容
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
grant select on ${iol_schema}.cchs_uomp_workbill_callback to ${iml_schema};
grant select on ${iol_schema}.cchs_uomp_workbill_callback to ${icl_schema};
grant select on ${iol_schema}.cchs_uomp_workbill_callback to ${idl_schema};
grant select on ${iol_schema}.cchs_uomp_workbill_callback to ${iel_schema};

-- comment
comment on table ${iol_schema}.cchs_uomp_workbill_callback is '工单回访表';
comment on column ${iol_schema}.cchs_uomp_workbill_callback.code is '工单回访流水号';
comment on column ${iol_schema}.cchs_uomp_workbill_callback.workbill_no is '工单编号';
comment on column ${iol_schema}.cchs_uomp_workbill_callback.return_visit_date is '回访时间';
comment on column ${iol_schema}.cchs_uomp_workbill_callback.create_name is '创建者名称';
comment on column ${iol_schema}.cchs_uomp_workbill_callback.return_visit_content is '回访内容';
comment on column ${iol_schema}.cchs_uomp_workbill_callback.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cchs_uomp_workbill_callback.etl_timestamp is 'ETL处理时间戳';
