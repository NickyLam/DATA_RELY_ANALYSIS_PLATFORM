/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tmss_sys_corp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tmss_sys_corp
whenever sqlerror continue none;
drop table ${iol_schema}.tmss_sys_corp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tmss_sys_corp(
    id varchar2(96) -- 
    ,account_licence varchar2(90) -- 
    ,address varchar2(600) -- 
    ,city varchar2(96) -- 
    ,code varchar2(96) -- 
    ,collect_flag number(10,0) -- collectFlag
    ,ctl_budget number(10,0) -- 
    ,head_person varchar2(90) -- 
    ,listed_company number(10,0) -- listedCompany
    ,name varchar2(600) -- 
    ,parent_id varchar2(96) -- 
    ,parent_ids varchar2(4000) -- 
    ,province varchar2(96) -- 
    ,sort number(10,0) -- sort
    ,status number(10,0) -- status
    ,type number(10,0) -- 
    ,use_account_code varchar2(3000) -- 
    ,net_id varchar2(96) -- 
    ,rat_group number(1,0) -- 集团统一授信主体
    ,create_time date -- 
    ,create_by varchar2(96) -- 
    ,update_time date -- 
    ,update_by varchar2(96) -- 
    ,is_limit_quota varchar2(3) -- 
    ,day_limit_quota number(15,2) -- 
    ,month_limit_quota number(15,2) -- 
    ,name_en varchar2(3000) -- 
    ,address_en varchar2(3000) -- 
    ,cur_id varchar2(96) -- 
    ,unit_attribute varchar2(6) -- 
    ,unit_cm varchar2(4000) -- 
    ,country_id varchar2(96) -- 
    ,tenant_id varchar2(96) -- 租户ID
    ,soc_code varchar2(96) -- 统一社会信用代码
    ,corp_tenant_code varchar2(150) -- 单位客户号
    ,bank_code varchar2(150) -- 银行端成员单位对应的联行号
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
grant select on ${iol_schema}.tmss_sys_corp to ${iml_schema};
grant select on ${iol_schema}.tmss_sys_corp to ${icl_schema};
grant select on ${iol_schema}.tmss_sys_corp to ${idl_schema};
grant select on ${iol_schema}.tmss_sys_corp to ${iel_schema};

-- comment
comment on table ${iol_schema}.tmss_sys_corp is '系统单位表';
comment on column ${iol_schema}.tmss_sys_corp.id is '';
comment on column ${iol_schema}.tmss_sys_corp.account_licence is '';
comment on column ${iol_schema}.tmss_sys_corp.address is '';
comment on column ${iol_schema}.tmss_sys_corp.city is '';
comment on column ${iol_schema}.tmss_sys_corp.code is '';
comment on column ${iol_schema}.tmss_sys_corp.collect_flag is 'collectFlag';
comment on column ${iol_schema}.tmss_sys_corp.ctl_budget is '';
comment on column ${iol_schema}.tmss_sys_corp.head_person is '';
comment on column ${iol_schema}.tmss_sys_corp.listed_company is 'listedCompany';
comment on column ${iol_schema}.tmss_sys_corp.name is '';
comment on column ${iol_schema}.tmss_sys_corp.parent_id is '';
comment on column ${iol_schema}.tmss_sys_corp.parent_ids is '';
comment on column ${iol_schema}.tmss_sys_corp.province is '';
comment on column ${iol_schema}.tmss_sys_corp.sort is 'sort';
comment on column ${iol_schema}.tmss_sys_corp.status is 'status';
comment on column ${iol_schema}.tmss_sys_corp.type is '';
comment on column ${iol_schema}.tmss_sys_corp.use_account_code is '';
comment on column ${iol_schema}.tmss_sys_corp.net_id is '';
comment on column ${iol_schema}.tmss_sys_corp.rat_group is '集团统一授信主体';
comment on column ${iol_schema}.tmss_sys_corp.create_time is '';
comment on column ${iol_schema}.tmss_sys_corp.create_by is '';
comment on column ${iol_schema}.tmss_sys_corp.update_time is '';
comment on column ${iol_schema}.tmss_sys_corp.update_by is '';
comment on column ${iol_schema}.tmss_sys_corp.is_limit_quota is '';
comment on column ${iol_schema}.tmss_sys_corp.day_limit_quota is '';
comment on column ${iol_schema}.tmss_sys_corp.month_limit_quota is '';
comment on column ${iol_schema}.tmss_sys_corp.name_en is '';
comment on column ${iol_schema}.tmss_sys_corp.address_en is '';
comment on column ${iol_schema}.tmss_sys_corp.cur_id is '';
comment on column ${iol_schema}.tmss_sys_corp.unit_attribute is '';
comment on column ${iol_schema}.tmss_sys_corp.unit_cm is '';
comment on column ${iol_schema}.tmss_sys_corp.country_id is '';
comment on column ${iol_schema}.tmss_sys_corp.tenant_id is '租户ID';
comment on column ${iol_schema}.tmss_sys_corp.soc_code is '统一社会信用代码';
comment on column ${iol_schema}.tmss_sys_corp.corp_tenant_code is '单位客户号';
comment on column ${iol_schema}.tmss_sys_corp.bank_code is '银行端成员单位对应的联行号';
comment on column ${iol_schema}.tmss_sys_corp.start_dt is '开始时间';
comment on column ${iol_schema}.tmss_sys_corp.end_dt is '结束时间';
comment on column ${iol_schema}.tmss_sys_corp.id_mark is '增删标志';
comment on column ${iol_schema}.tmss_sys_corp.etl_timestamp is 'ETL处理时间戳';
