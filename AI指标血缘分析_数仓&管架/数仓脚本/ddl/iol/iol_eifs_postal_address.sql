/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_postal_address
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_postal_address
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_postal_address purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_postal_address(
    contact_mech_id varchar2(30) -- 联系机制编号
    ,to_name varchar2(150) -- 目标名称
    ,attn_name varchar2(150) -- 附加名称
    ,address1 varchar2(383) -- 地址1
    ,address2 varchar2(383) -- 地址2
    ,directions varchar2(383) -- 方位
    ,city varchar2(150) -- 城市
    ,postal_code varchar2(90) -- 邮编
    ,postal_code_ext varchar2(90) -- 邮编扩展
    ,country_geo_id varchar2(30) -- 国家地理标识
    ,state_province_geo_id varchar2(30) -- 区域
    ,county_geo_id varchar2(30) -- 县地理标识
    ,postal_code_geo_id varchar2(30) -- 邮编地理标识
    ,geo_point_id varchar2(30) -- 地理位置标识
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,dont_use_s varchar2(30) -- 无法送达
    ,address_status varchar2(30) -- 
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
grant select on ${iol_schema}.eifs_postal_address to ${iml_schema};
grant select on ${iol_schema}.eifs_postal_address to ${icl_schema};
grant select on ${iol_schema}.eifs_postal_address to ${idl_schema};
grant select on ${iol_schema}.eifs_postal_address to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_postal_address is '地址信息表';
comment on column ${iol_schema}.eifs_postal_address.contact_mech_id is '联系机制编号';
comment on column ${iol_schema}.eifs_postal_address.to_name is '目标名称';
comment on column ${iol_schema}.eifs_postal_address.attn_name is '附加名称';
comment on column ${iol_schema}.eifs_postal_address.address1 is '地址1';
comment on column ${iol_schema}.eifs_postal_address.address2 is '地址2';
comment on column ${iol_schema}.eifs_postal_address.directions is '方位';
comment on column ${iol_schema}.eifs_postal_address.city is '城市';
comment on column ${iol_schema}.eifs_postal_address.postal_code is '邮编';
comment on column ${iol_schema}.eifs_postal_address.postal_code_ext is '邮编扩展';
comment on column ${iol_schema}.eifs_postal_address.country_geo_id is '国家地理标识';
comment on column ${iol_schema}.eifs_postal_address.state_province_geo_id is '区域';
comment on column ${iol_schema}.eifs_postal_address.county_geo_id is '县地理标识';
comment on column ${iol_schema}.eifs_postal_address.postal_code_geo_id is '邮编地理标识';
comment on column ${iol_schema}.eifs_postal_address.geo_point_id is '地理位置标识';
comment on column ${iol_schema}.eifs_postal_address.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.eifs_postal_address.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.eifs_postal_address.created_stamp is '创建时间';
comment on column ${iol_schema}.eifs_postal_address.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.eifs_postal_address.dont_use_s is '无法送达';
comment on column ${iol_schema}.eifs_postal_address.address_status is '';
comment on column ${iol_schema}.eifs_postal_address.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_postal_address.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_postal_address.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_postal_address.etl_timestamp is 'ETL处理时间戳';
