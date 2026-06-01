/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_crbckm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_crbckm
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_crbckm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_crbckm(
    merchantid varchar2(96) -- 商户编号
    ,extkey varchar2(36) -- 客户号
    ,sellerid varchar2(60) -- 店铺ID
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
grant select on ${iol_schema}.isbs_crbckm to ${iml_schema};
grant select on ${iol_schema}.isbs_crbckm to ${icl_schema};
grant select on ${iol_schema}.isbs_crbckm to ${idl_schema};
grant select on ${iol_schema}.isbs_crbckm to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_crbckm is '跨境电商商户映射表';
comment on column ${iol_schema}.isbs_crbckm.merchantid is '商户编号';
comment on column ${iol_schema}.isbs_crbckm.extkey is '客户号';
comment on column ${iol_schema}.isbs_crbckm.sellerid is '店铺ID';
comment on column ${iol_schema}.isbs_crbckm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_crbckm.etl_timestamp is 'ETL处理时间戳';
