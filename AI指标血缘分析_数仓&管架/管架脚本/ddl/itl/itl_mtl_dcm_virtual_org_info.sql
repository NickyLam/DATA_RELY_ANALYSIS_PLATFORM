/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_dcm_virtual_org_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_dcm_virtual_org_info
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_dcm_virtual_org_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_dcm_virtual_org_info(
     ORG_NO        VARCHAR2(60)   --机构编号
    ,ORG_NAME      VARCHAR2(100)  --机构名称
    ,SUPER_ORG_NO  VARCHAR2(60)   --上级机构编号
    ,etl_dt        DATE           -- ETL处理日期
    ,etl_timestamp timestamp      -- ETL处理时间
    
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.mtl_dcm_virtual_org_info to ${iol_schema};

-- comment
comment on table ${itl_schema}.mtl_dcm_virtual_org_info is '虚拟机构补录表';
comment on column ${itl_schema}.mtl_dcm_virtual_org_info.org_no is '机构编号';
comment on column ${itl_schema}.mtl_dcm_virtual_org_info.org_name is '机构名称';
comment on column ${itl_schema}.mtl_dcm_virtual_org_info.super_org_no is '上级机构编号';
comment on column ${itl_schema}.mtl_dcm_virtual_org_info.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_dcm_virtual_org_info.etl_timestamp is 'ETL处理时间戳';
