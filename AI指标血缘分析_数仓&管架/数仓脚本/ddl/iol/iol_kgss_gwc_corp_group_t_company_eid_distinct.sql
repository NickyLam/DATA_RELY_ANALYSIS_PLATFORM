/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol kgss_gwc_corp_group_t_company_eid_distinct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct
whenever sqlerror continue none;
drop table ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct(
    object_key varchar2(4000) -- 主键
    ,format_name varchar2(4000) -- 公司名称
    ,eid varchar2(4000) -- 企业EID
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
grant select on ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct to ${iml_schema};
grant select on ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct to ${icl_schema};
grant select on ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct to ${idl_schema};
grant select on ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct to ${iel_schema};

-- comment
comment on table ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct is '企业信息表(eid去重)';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct.object_key is '主键';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct.format_name is '公司名称';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct.eid is '企业EID';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.kgss_gwc_corp_group_t_company_eid_distinct.etl_timestamp is 'ETL处理时间戳';
