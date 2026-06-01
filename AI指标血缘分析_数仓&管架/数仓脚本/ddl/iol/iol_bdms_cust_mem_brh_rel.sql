/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cust_mem_brh_rel
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cust_mem_brh_rel
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cust_mem_brh_rel purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cust_mem_brh_rel(
    id varchar2(60) -- id
    ,cust_id varchar2(60) -- 客户信息id
    ,brh_no varchar2(14) -- 会员机构编号
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
grant select on ${iol_schema}.bdms_cust_mem_brh_rel to ${iml_schema};
grant select on ${iol_schema}.bdms_cust_mem_brh_rel to ${icl_schema};
grant select on ${iol_schema}.bdms_cust_mem_brh_rel to ${idl_schema};
grant select on ${iol_schema}.bdms_cust_mem_brh_rel to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cust_mem_brh_rel is '客户信息与会员机构关联表';
comment on column ${iol_schema}.bdms_cust_mem_brh_rel.id is 'id';
comment on column ${iol_schema}.bdms_cust_mem_brh_rel.cust_id is '客户信息id';
comment on column ${iol_schema}.bdms_cust_mem_brh_rel.brh_no is '会员机构编号';
comment on column ${iol_schema}.bdms_cust_mem_brh_rel.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cust_mem_brh_rel.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cust_mem_brh_rel.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cust_mem_brh_rel.etl_timestamp is 'ETL处理时间戳';
