/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t00_party_pub_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t00_party_pub_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t00_party_pub_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t00_party_pub_info(
    party_id varchar2(45) -- 参与人id
    ,cust_type_cd varchar2(3) -- 客户类型
    ,cust_name varchar2(300) -- 客户名称
    ,cust_num varchar2(24) -- 客户编号
    ,en_name varchar2(300) -- 英文名称
    ,short_name varchar2(90) -- 客户简称
    ,nation_cd varchar2(30) -- 国籍
    ,dom_forgn_cd varchar2(2) -- 境内外标志
    ,farmer_flag varchar2(2) -- 是否农户
    ,tax_pay_ctzn_idnt varchar2(11) -- 税收居民身份
    ,addr_dist_cd varchar2(30) -- 行政区划代码
    ,info_completed_flag varchar2(2) -- 信息完整性标志
    ,info_isnull_reason varchar2(4000) -- 信息项字段为空原因
    ,level_five_class_flag varchar2(15) -- 五级分类标志
    ,level_five_class_dt varchar2(12) -- 五级分类日期
    ,cust_open_dt varchar2(12) -- 开客户日期
    ,agent_acct_open varchar2(45) -- 代理开户类型
    ,cust_status_cd varchar2(30) -- 客户状态
    ,close_dt varchar2(12) -- 销户日期
    ,recommendation_type varchar2(11) -- 推荐人类型
    ,recommendation_num varchar2(60) -- 推荐人号码
    ,cust_mgr_num varchar2(90) -- 客户经理编号
    ,cust_mgr_name varchar2(300) -- 客户经理姓名
    ,mgmt_org_num varchar2(90) -- 管理机构编号
    ,mgmt_team_num varchar2(90) -- 管理团队编号
    ,create_te varchar2(15) -- 创建柜员
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
    ,cust_belong_org varchar2(18) -- 客户归属机构
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
grant select on ${iol_schema}.eifs_t00_party_pub_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t00_party_pub_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t00_party_pub_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t00_party_pub_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t00_party_pub_info is '对私对公客户公共信息';
comment on column ${iol_schema}.eifs_t00_party_pub_info.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t00_party_pub_info.cust_type_cd is '客户类型';
comment on column ${iol_schema}.eifs_t00_party_pub_info.cust_name is '客户名称';
comment on column ${iol_schema}.eifs_t00_party_pub_info.cust_num is '客户编号';
comment on column ${iol_schema}.eifs_t00_party_pub_info.en_name is '英文名称';
comment on column ${iol_schema}.eifs_t00_party_pub_info.short_name is '客户简称';
comment on column ${iol_schema}.eifs_t00_party_pub_info.nation_cd is '国籍';
comment on column ${iol_schema}.eifs_t00_party_pub_info.dom_forgn_cd is '境内外标志';
comment on column ${iol_schema}.eifs_t00_party_pub_info.farmer_flag is '是否农户';
comment on column ${iol_schema}.eifs_t00_party_pub_info.tax_pay_ctzn_idnt is '税收居民身份';
comment on column ${iol_schema}.eifs_t00_party_pub_info.addr_dist_cd is '行政区划代码';
comment on column ${iol_schema}.eifs_t00_party_pub_info.info_completed_flag is '信息完整性标志';
comment on column ${iol_schema}.eifs_t00_party_pub_info.info_isnull_reason is '信息项字段为空原因';
comment on column ${iol_schema}.eifs_t00_party_pub_info.level_five_class_flag is '五级分类标志';
comment on column ${iol_schema}.eifs_t00_party_pub_info.level_five_class_dt is '五级分类日期';
comment on column ${iol_schema}.eifs_t00_party_pub_info.cust_open_dt is '开客户日期';
comment on column ${iol_schema}.eifs_t00_party_pub_info.agent_acct_open is '代理开户类型';
comment on column ${iol_schema}.eifs_t00_party_pub_info.cust_status_cd is '客户状态';
comment on column ${iol_schema}.eifs_t00_party_pub_info.close_dt is '销户日期';
comment on column ${iol_schema}.eifs_t00_party_pub_info.recommendation_type is '推荐人类型';
comment on column ${iol_schema}.eifs_t00_party_pub_info.recommendation_num is '推荐人号码';
comment on column ${iol_schema}.eifs_t00_party_pub_info.cust_mgr_num is '客户经理编号';
comment on column ${iol_schema}.eifs_t00_party_pub_info.cust_mgr_name is '客户经理姓名';
comment on column ${iol_schema}.eifs_t00_party_pub_info.mgmt_org_num is '管理机构编号';
comment on column ${iol_schema}.eifs_t00_party_pub_info.mgmt_team_num is '管理团队编号';
comment on column ${iol_schema}.eifs_t00_party_pub_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t00_party_pub_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t00_party_pub_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t00_party_pub_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t00_party_pub_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t00_party_pub_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t00_party_pub_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t00_party_pub_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t00_party_pub_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t00_party_pub_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t00_party_pub_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t00_party_pub_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t00_party_pub_info.cust_belong_org is '客户归属机构';
comment on column ${iol_schema}.eifs_t00_party_pub_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t00_party_pub_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t00_party_pub_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t00_party_pub_info.etl_timestamp is 'ETL处理时间戳';
