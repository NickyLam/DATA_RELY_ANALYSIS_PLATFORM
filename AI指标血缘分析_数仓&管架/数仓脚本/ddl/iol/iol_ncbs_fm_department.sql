/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_department
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_department
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_department purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_department(
    profit_center varchar2(20) -- 利润中心
    ,company varchar2(20) -- 法人
    ,department varchar2(6) -- 部门
    ,department_desc varchar2(50) -- 部门名称
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ncbs_fm_department to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_department to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_department to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_department to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_department is '部门信息表';
comment on column ${iol_schema}.ncbs_fm_department.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_fm_department.company is '法人';
comment on column ${iol_schema}.ncbs_fm_department.department is '部门';
comment on column ${iol_schema}.ncbs_fm_department.department_desc is '部门名称';
comment on column ${iol_schema}.ncbs_fm_department.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_department.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_department.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_department.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_department.etl_timestamp is 'ETL处理时间戳';
