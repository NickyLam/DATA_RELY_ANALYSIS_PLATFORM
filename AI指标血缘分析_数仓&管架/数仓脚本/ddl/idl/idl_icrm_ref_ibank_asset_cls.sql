/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_ref_ibank_asset_cls
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_ref_ibank_asset_cls
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_ref_ibank_asset_cls purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_ref_ibank_asset_cls(
    etl_dt date -- 数据日期
    ,prod_cls_id varchar2(60) -- 产品分类编号
    ,lp_id varchar2(60) -- 法人编号
    ,asset_type_id varchar2(60) -- 资产类型编号
    ,prod_cls_name varchar2(100) -- 产品分类名称
    ,prod_type_id varchar2(60) -- 产品类型编号
    ,prod_type_name varchar2(100) -- 产品类型名称
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_ref_ibank_asset_cls to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_ref_ibank_asset_cls is '同业资产分类';
comment on column ${idl_schema}.icrm_ref_ibank_asset_cls.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_ref_ibank_asset_cls.prod_cls_id is '产品分类编号';
comment on column ${idl_schema}.icrm_ref_ibank_asset_cls.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_ref_ibank_asset_cls.asset_type_id is '资产类型编号';
comment on column ${idl_schema}.icrm_ref_ibank_asset_cls.prod_cls_name is '产品分类名称';
comment on column ${idl_schema}.icrm_ref_ibank_asset_cls.prod_type_id is '产品类型编号';
comment on column ${idl_schema}.icrm_ref_ibank_asset_cls.prod_type_name is '产品类型名称';
comment on column ${idl_schema}.icrm_ref_ibank_asset_cls.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_ref_ibank_asset_cls.etl_timestamp is '数据处理时间';
