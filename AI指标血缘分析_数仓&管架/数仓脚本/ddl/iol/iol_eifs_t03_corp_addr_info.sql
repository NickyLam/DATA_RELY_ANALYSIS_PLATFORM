/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t03_corp_addr_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t03_corp_addr_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t03_corp_addr_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t03_corp_addr_info(
    addr_id varchar2(45) -- 地址id
    ,party_id varchar2(45) -- 参与人id
    ,phys_addr_type_cd varchar2(3) -- 物理地址类型
    ,phys_addr_cty_zone_cd varchar2(30) -- 国家和地区
    ,prov_cd varchar2(9) -- 省
    ,city_cd varchar2(9) -- 市
    ,county_cd varchar2(9) -- 县
    ,street varchar2(135) -- 街道
    ,addr_detail varchar2(600) -- 详细地址
    ,post_code varchar2(15) -- 邮政编码
    ,prefereed_flag varchar2(2) -- 首选标志
    ,create_te varchar2(12) -- 创建柜员
    ,create_org varchar2(15) -- 创建机构号
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ecif的时间
    ,updated_ts timestamp -- 在ecif中失效的时间
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
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
grant select on ${iol_schema}.eifs_t03_corp_addr_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t03_corp_addr_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t03_corp_addr_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t03_corp_addr_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t03_corp_addr_info is '对公地址信息';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.addr_id is '地址id';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.phys_addr_type_cd is '物理地址类型';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.phys_addr_cty_zone_cd is '国家和地区';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.prov_cd is '省';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.city_cd is '市';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.county_cd is '县';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.street is '街道';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.addr_detail is '详细地址';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.post_code is '邮政编码';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.prefereed_flag is '首选标志';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t03_corp_addr_info.etl_timestamp is 'ETL处理时间戳';
