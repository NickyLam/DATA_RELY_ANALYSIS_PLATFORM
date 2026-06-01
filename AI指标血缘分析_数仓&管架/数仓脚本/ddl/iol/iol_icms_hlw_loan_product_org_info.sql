/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_hlw_loan_product_org_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_hlw_loan_product_org_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_hlw_loan_product_org_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_hlw_loan_product_org_info(
    serialno varchar2(32) -- 流水号
    ,orgid varchar2(12) -- 机构编号
    ,orgname varchar2(200) -- 机构名称
    ,certid varchar2(60) -- 机构统一社会信用代码
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
grant select on ${iol_schema}.icms_hlw_loan_product_org_info to ${iml_schema};
grant select on ${iol_schema}.icms_hlw_loan_product_org_info to ${icl_schema};
grant select on ${iol_schema}.icms_hlw_loan_product_org_info to ${idl_schema};
grant select on ${iol_schema}.icms_hlw_loan_product_org_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_hlw_loan_product_org_info is '互联网贷款产品机构信息表';
comment on column ${iol_schema}.icms_hlw_loan_product_org_info.serialno is '流水号';
comment on column ${iol_schema}.icms_hlw_loan_product_org_info.orgid is '机构编号';
comment on column ${iol_schema}.icms_hlw_loan_product_org_info.orgname is '机构名称';
comment on column ${iol_schema}.icms_hlw_loan_product_org_info.certid is '机构统一社会信用代码';
comment on column ${iol_schema}.icms_hlw_loan_product_org_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_hlw_loan_product_org_info.etl_timestamp is 'ETL处理时间戳';
