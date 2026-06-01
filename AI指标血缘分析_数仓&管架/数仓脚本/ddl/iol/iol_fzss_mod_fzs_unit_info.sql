/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fzss_mod_fzs_unit_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fzss_mod_fzs_unit_info
whenever sqlerror continue none;
drop table ${iol_schema}.fzss_mod_fzs_unit_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_unit_info(
    corp_id varchar2(10) -- 平台商户号
    ,mybank varchar2(20) -- 法人标识代码
    ,zone_no varchar2(6) -- 分行号
    ,vbrno varchar2(6) -- 虚拟机构号
    ,tellerno varchar2(8) -- 柜员号
    ,open_brno varchar2(6) -- 子账户开户机构号
    ,cache_status varchar2(1) -- 缓存状态 [枚举: 1-初始态,2-失效态]
    ,data_version varchar2(3) -- 数据版本
    ,data_cache_version varchar2(3) -- 数据缓存版本
    ,create_timestamp timestamp -- 创建时间戳
    ,update_timestamp timestamp -- 更新时间戳
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
grant select on ${iol_schema}.fzss_mod_fzs_unit_info to ${iml_schema};
grant select on ${iol_schema}.fzss_mod_fzs_unit_info to ${icl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_unit_info to ${idl_schema};
grant select on ${iol_schema}.fzss_mod_fzs_unit_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fzss_mod_fzs_unit_info is '平台商户信息表';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.corp_id is '平台商户号';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.mybank is '法人标识代码';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.zone_no is '分行号';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.vbrno is '虚拟机构号';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.tellerno is '柜员号';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.open_brno is '子账户开户机构号';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.cache_status is '缓存状态 [枚举: 1-初始态,2-失效态]';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.data_version is '数据版本';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.data_cache_version is '数据缓存版本';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.create_timestamp is '创建时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.update_timestamp is '更新时间戳';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.start_dt is '开始时间';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.end_dt is '结束时间';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.id_mark is '增删标志';
comment on column ${iol_schema}.fzss_mod_fzs_unit_info.etl_timestamp is 'ETL处理时间戳';
