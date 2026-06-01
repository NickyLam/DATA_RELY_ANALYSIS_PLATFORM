/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_cl_prd_catalog_belong
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_cl_prd_catalog_belong
whenever sqlerror continue none;
drop table ${iol_schema}.icms_cl_prd_catalog_belong purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_cl_prd_catalog_belong(
    updatedate timestamp -- 更新日期
    ,updateuserid varchar2(64) -- 更新人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate timestamp -- 登记日期
    ,updateorgid varchar2(64) -- 更新机构
    ,inputuserid varchar2(64) -- 登记人
    ,productid varchar2(64) -- 产品编号
    ,belongproductid varchar2(64) -- 所属产品编号
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
grant select on ${iol_schema}.icms_cl_prd_catalog_belong to ${iml_schema};
grant select on ${iol_schema}.icms_cl_prd_catalog_belong to ${icl_schema};
grant select on ${iol_schema}.icms_cl_prd_catalog_belong to ${idl_schema};
grant select on ${iol_schema}.icms_cl_prd_catalog_belong to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_cl_prd_catalog_belong is '产品目录所属表';
comment on column ${iol_schema}.icms_cl_prd_catalog_belong.updatedate is '更新日期';
comment on column ${iol_schema}.icms_cl_prd_catalog_belong.updateuserid is '更新人';
comment on column ${iol_schema}.icms_cl_prd_catalog_belong.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_cl_prd_catalog_belong.inputdate is '登记日期';
comment on column ${iol_schema}.icms_cl_prd_catalog_belong.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_cl_prd_catalog_belong.inputuserid is '登记人';
comment on column ${iol_schema}.icms_cl_prd_catalog_belong.productid is '产品编号';
comment on column ${iol_schema}.icms_cl_prd_catalog_belong.belongproductid is '所属产品编号';
comment on column ${iol_schema}.icms_cl_prd_catalog_belong.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_cl_prd_catalog_belong.etl_timestamp is 'ETL处理时间戳';
