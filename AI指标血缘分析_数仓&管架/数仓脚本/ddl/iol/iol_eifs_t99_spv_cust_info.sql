/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t99_spv_cust_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t99_spv_cust_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t99_spv_cust_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t99_spv_cust_info(
    cust_num varchar2(24) -- spv客户号
    ,org_cust_num varchar2(24) -- 主机构客户号
    ,cust_name varchar2(300) -- spv名称
    ,spv_ytpe varchar2(5) -- spv类型
    ,prod_stat_cd varchar2(9) -- 资管产品统计编码
    ,spv_cd varchar2(150) -- spv代码
    ,create_te varchar2(15) -- 创建柜员
    ,create_org varchar2(15) -- 创建机构号
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ecif的时间
    ,updated_ts timestamp -- 在ecif中失效的时间
    ,last_updated_te varchar2(30) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,is_cash_magm varchar2(3) -- 是否现金管理类理财
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
grant select on ${iol_schema}.eifs_t99_spv_cust_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t99_spv_cust_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t99_spv_cust_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t99_spv_cust_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t99_spv_cust_info is 'SPV客户信息';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.cust_num is 'spv客户号';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.org_cust_num is '主机构客户号';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.cust_name is 'spv名称';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.spv_ytpe is 'spv类型';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.prod_stat_cd is '资管产品统计编码';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.spv_cd is 'spv代码';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.is_cash_magm is '是否现金管理类理财';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t99_spv_cust_info.etl_timestamp is 'ETL处理时间戳';
