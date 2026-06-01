/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t00_per_cust_cert_ref
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t00_per_cust_cert_ref
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t00_per_cust_cert_ref purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t00_per_cust_cert_ref(
    cert_index_seq varchar2(45) -- 证件序列号
    ,party_id varchar2(45) -- 参与人id
    ,cert_type_cd varchar2(6) -- 证件类型
    ,cert_num varchar2(90) -- 证件号码
    ,cust_name varchar2(300) -- 客户名称
    ,cert_effect_dt varchar2(12) -- 证件生效日期
    ,cert_valid varchar2(45) -- 证件有效期
    ,cert_invalid_dt varchar2(12) -- 证件失效日期
    ,cert_issue_cty_cd varchar2(5) -- 证件签发国家
    ,cert_issue_org_name varchar2(300) -- 证件签发机关名称
    ,cert_issue_zone_cd varchar2(6) -- 发证机关地区代码
    ,cert_rgst_addr varchar2(600) -- 证件注册地址
    ,is_main_cert varchar2(15) -- 是否主证件
    ,is_net_check varchar2(12) -- 是否联网核查
    ,network_verif varchar2(15) -- 联网核查结果
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
    ,cert_issue_zone_name varchar2(300) -- 发证机关地区中文名称
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
    ,cert_num_his varchar2(90) -- 既往证件号码
    ,cert_invalid_dt_his varchar2(12) -- 既往证件失效日期
    ,cert_effect_dt_his varchar2(12) -- 既往证件生效日期
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
grant select on ${iol_schema}.eifs_t00_per_cust_cert_ref to ${iml_schema};
grant select on ${iol_schema}.eifs_t00_per_cust_cert_ref to ${icl_schema};
grant select on ${iol_schema}.eifs_t00_per_cust_cert_ref to ${idl_schema};
grant select on ${iol_schema}.eifs_t00_per_cust_cert_ref to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t00_per_cust_cert_ref is '对私客户证件索引';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_index_seq is '证件序列号';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_type_cd is '证件类型';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_num is '证件号码';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cust_name is '客户名称';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_effect_dt is '证件生效日期';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_valid is '证件有效期';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_invalid_dt is '证件失效日期';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_issue_cty_cd is '证件签发国家';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_issue_org_name is '证件签发机关名称';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_issue_zone_cd is '发证机关地区代码';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_rgst_addr is '证件注册地址';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.is_main_cert is '是否主证件';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.is_net_check is '是否联网核查';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.network_verif is '联网核查结果';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_issue_zone_name is '发证机关地区中文名称';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_num_his is '既往证件号码';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_invalid_dt_his is '既往证件失效日期';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.cert_effect_dt_his is '既往证件生效日期';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t00_per_cust_cert_ref.etl_timestamp is 'ETL处理时间戳';
