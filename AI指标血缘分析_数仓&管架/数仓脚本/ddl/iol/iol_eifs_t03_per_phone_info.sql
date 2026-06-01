/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t03_per_phone_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t03_per_phone_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t03_per_phone_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t03_per_phone_info(
    phone_id varchar2(45) -- 电话id
    ,party_id varchar2(45) -- 参与人id
    ,tel_type_cd varchar2(30) -- 电话类型
    ,long_path_zone_code varchar2(45) -- 长途区号
    ,tel_propterty varchar2(2) -- 号码性质
    ,tel_num varchar2(45) -- 电话号码
    ,ext_num varchar2(45) -- 分机号
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
    ,rel_name_auth_query_resu varchar2(450) -- 
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
grant select on ${iol_schema}.eifs_t03_per_phone_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t03_per_phone_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t03_per_phone_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t03_per_phone_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t03_per_phone_info is '对私电话信息';
comment on column ${iol_schema}.eifs_t03_per_phone_info.phone_id is '电话id';
comment on column ${iol_schema}.eifs_t03_per_phone_info.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t03_per_phone_info.tel_type_cd is '电话类型';
comment on column ${iol_schema}.eifs_t03_per_phone_info.long_path_zone_code is '长途区号';
comment on column ${iol_schema}.eifs_t03_per_phone_info.tel_propterty is '号码性质';
comment on column ${iol_schema}.eifs_t03_per_phone_info.tel_num is '电话号码';
comment on column ${iol_schema}.eifs_t03_per_phone_info.ext_num is '分机号';
comment on column ${iol_schema}.eifs_t03_per_phone_info.prefereed_flag is '首选标志';
comment on column ${iol_schema}.eifs_t03_per_phone_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t03_per_phone_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t03_per_phone_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t03_per_phone_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t03_per_phone_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t03_per_phone_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t03_per_phone_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t03_per_phone_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t03_per_phone_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t03_per_phone_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t03_per_phone_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t03_per_phone_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t03_per_phone_info.rel_name_auth_query_resu is '';
comment on column ${iol_schema}.eifs_t03_per_phone_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t03_per_phone_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t03_per_phone_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t03_per_phone_info.etl_timestamp is 'ETL处理时间戳';
