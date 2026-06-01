/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_yp_g13relation
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_yp_g13relation
whenever sqlerror continue none;
drop table ${iol_schema}.mims_yp_g13relation purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_yp_g13relation(
    id varchar2(8) -- id
    ,name varchar2(75) -- 名称
    ,guartype varchar2(30) -- 押品类型
    ,fieldidx number(22,0) -- 排序
    ,preid varchar2(8) -- 包含下层统计id
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
grant select on ${iol_schema}.mims_yp_g13relation to ${iml_schema};
grant select on ${iol_schema}.mims_yp_g13relation to ${icl_schema};
grant select on ${iol_schema}.mims_yp_g13relation to ${idl_schema};
grant select on ${iol_schema}.mims_yp_g13relation to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_yp_g13relation is 'G13报表分配关系明细表';
comment on column ${iol_schema}.mims_yp_g13relation.id is 'id';
comment on column ${iol_schema}.mims_yp_g13relation.name is '名称';
comment on column ${iol_schema}.mims_yp_g13relation.guartype is '押品类型';
comment on column ${iol_schema}.mims_yp_g13relation.fieldidx is '排序';
comment on column ${iol_schema}.mims_yp_g13relation.preid is '包含下层统计id';
comment on column ${iol_schema}.mims_yp_g13relation.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mims_yp_g13relation.etl_timestamp is 'ETL处理时间戳';
