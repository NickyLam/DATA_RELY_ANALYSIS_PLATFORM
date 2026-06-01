/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_corp_group_members
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_corp_group_members
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_corp_group_members purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_group_members(
    party_id varchar2(45) -- 参与人ID
    ,member_id varchar2(45) -- 成员ID
    ,mem_cust_num varchar2(24) -- 成员客户编号
    ,belong_group_num varchar2(45) -- 所属集团编号
    ,mem_type_cd varchar2(30) -- 成员类型
    ,grcorp_ind varchar2(6) -- 母公司标志
    ,member_status varchar2(2) -- 成员状态
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
grant select on ${iol_schema}.eifs_t01_corp_group_members to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_corp_group_members to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_corp_group_members to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_corp_group_members to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_corp_group_members is '集团与成员的关系信息';
comment on column ${iol_schema}.eifs_t01_corp_group_members.party_id is '参与人ID';
comment on column ${iol_schema}.eifs_t01_corp_group_members.member_id is '成员ID';
comment on column ${iol_schema}.eifs_t01_corp_group_members.mem_cust_num is '成员客户编号';
comment on column ${iol_schema}.eifs_t01_corp_group_members.belong_group_num is '所属集团编号';
comment on column ${iol_schema}.eifs_t01_corp_group_members.mem_type_cd is '成员类型';
comment on column ${iol_schema}.eifs_t01_corp_group_members.grcorp_ind is '母公司标志';
comment on column ${iol_schema}.eifs_t01_corp_group_members.member_status is '成员状态';
comment on column ${iol_schema}.eifs_t01_corp_group_members.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t01_corp_group_members.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_corp_group_members.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_corp_group_members.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_corp_group_members.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t01_corp_group_members.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t01_corp_group_members.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_corp_group_members.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_corp_group_members.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_corp_group_members.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_corp_group_members.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_group_members.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_group_members.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_corp_group_members.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_corp_group_members.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_corp_group_members.etl_timestamp is 'ETL处理时间戳';
