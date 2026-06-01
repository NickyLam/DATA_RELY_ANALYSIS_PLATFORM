/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_corp_group_ctrl_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_corp_group_ctrl_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_corp_group_ctrl_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_group_ctrl_info(
    ctrl_id varchar2(96) -- 实控人ID
    ,belong_group_num varchar2(45) -- 所属集团编号
    ,ctrl_type varchar2(8) -- 实控人类型
    ,ctrl_cust_num varchar2(45) -- 实控人客户号
    ,ctrl_cust_name varchar2(300) -- 实控人名称
    ,ctrl_cert_type_cd varchar2(6) -- 实控人证件类型
    ,ctrl_cert_num varchar2(90) -- 实控人证件号码
    ,ctrl_cert_effect_dt varchar2(12) -- 实控人证件生效日期
    ,ctrl_cert_invalid_dt varchar2(12) -- 实控人证件失效日期
    ,ctrl_nation_cd varchar2(5) -- 实控人国籍
    ,create_te varchar2(12) -- 开户柜员编号
    ,create_org varchar2(15) -- 创建机构号
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,created_ts timestamp -- 进入ECIF的时间
    ,updated_ts timestamp -- 在ECIF中失效的时间
    ,init_system_id varchar2(15) -- 创建渠道编号
    ,init_created_ts timestamp -- 源系统创建时间
    ,last_system_id varchar2(15) -- 最新更新渠道编号
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
grant select on ${iol_schema}.eifs_t01_corp_group_ctrl_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_corp_group_ctrl_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_corp_group_ctrl_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_corp_group_ctrl_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_corp_group_ctrl_info is '集团客户实控人信息';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.ctrl_id is '实控人ID';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.belong_group_num is '所属集团编号';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.ctrl_type is '实控人类型';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.ctrl_cust_num is '实控人客户号';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.ctrl_cust_name is '实控人名称';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.ctrl_cert_type_cd is '实控人证件类型';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.ctrl_cert_num is '实控人证件号码';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.ctrl_cert_effect_dt is '实控人证件生效日期';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.ctrl_cert_invalid_dt is '实控人证件失效日期';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.ctrl_nation_cd is '实控人国籍';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.create_te is '开户柜员编号';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.created_ts is '进入ECIF的时间';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.updated_ts is '在ECIF中失效的时间';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.init_system_id is '创建渠道编号';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.last_system_id is '最新更新渠道编号';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_corp_group_ctrl_info.etl_timestamp is 'ETL处理时间戳';
