/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_mst_customer_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_mst_customer_info
whenever sqlerror continue none;
drop table ${iol_schema}.fams_mst_customer_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_customer_info(
    customer_id varchar2(32) -- 客户代码
    ,customer_name varchar2(200) -- 客户名称
    ,customer_abbr varchar2(200) -- 客户简称
    ,customer_type varchar2(50) -- 客户类型，企业法人、自然人
    ,is_issuer varchar2(50) -- 是否发行人
    ,is_asste_manager varchar2(50) -- 是否管理人
    ,is_truster varchar2(50) -- 是否托管人
    ,is_saler varchar2(50) -- 是否承销商
    ,is_financier varchar2(50) -- 是否融资人
    ,is_guarantee varchar2(50) -- 是否担保人
    ,is_rating_agencies varchar2(50) -- 是否评级机构
    ,is_pledgor varchar2(50) -- 是否出质人
    ,is_deposit_bank varchar2(50) -- 是否存放行
    ,is_invest_adviser varchar2(50) -- 是否投资顾问
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_mst_customer_info to ${iml_schema};
grant select on ${iol_schema}.fams_mst_customer_info to ${icl_schema};
grant select on ${iol_schema}.fams_mst_customer_info to ${idl_schema};
grant select on ${iol_schema}.fams_mst_customer_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_mst_customer_info is '客户信息表';
comment on column ${iol_schema}.fams_mst_customer_info.customer_id is '客户代码';
comment on column ${iol_schema}.fams_mst_customer_info.customer_name is '客户名称';
comment on column ${iol_schema}.fams_mst_customer_info.customer_abbr is '客户简称';
comment on column ${iol_schema}.fams_mst_customer_info.customer_type is '客户类型，企业法人、自然人';
comment on column ${iol_schema}.fams_mst_customer_info.is_issuer is '是否发行人';
comment on column ${iol_schema}.fams_mst_customer_info.is_asste_manager is '是否管理人';
comment on column ${iol_schema}.fams_mst_customer_info.is_truster is '是否托管人';
comment on column ${iol_schema}.fams_mst_customer_info.is_saler is '是否承销商';
comment on column ${iol_schema}.fams_mst_customer_info.is_financier is '是否融资人';
comment on column ${iol_schema}.fams_mst_customer_info.is_guarantee is '是否担保人';
comment on column ${iol_schema}.fams_mst_customer_info.is_rating_agencies is '是否评级机构';
comment on column ${iol_schema}.fams_mst_customer_info.is_pledgor is '是否出质人';
comment on column ${iol_schema}.fams_mst_customer_info.is_deposit_bank is '是否存放行';
comment on column ${iol_schema}.fams_mst_customer_info.is_invest_adviser is '是否投资顾问';
comment on column ${iol_schema}.fams_mst_customer_info.create_user is '创建人';
comment on column ${iol_schema}.fams_mst_customer_info.create_dept is '创建部门';
comment on column ${iol_schema}.fams_mst_customer_info.create_time is '创建时间';
comment on column ${iol_schema}.fams_mst_customer_info.update_user is '更新人';
comment on column ${iol_schema}.fams_mst_customer_info.update_time is '更新时间';
comment on column ${iol_schema}.fams_mst_customer_info.start_dt is '开始时间';
comment on column ${iol_schema}.fams_mst_customer_info.end_dt is '结束时间';
comment on column ${iol_schema}.fams_mst_customer_info.id_mark is '增删标志';
comment on column ${iol_schema}.fams_mst_customer_info.etl_timestamp is 'ETL处理时间戳';
