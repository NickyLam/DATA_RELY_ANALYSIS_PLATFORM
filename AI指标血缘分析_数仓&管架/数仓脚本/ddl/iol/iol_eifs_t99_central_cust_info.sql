/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t99_central_cust_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t99_central_cust_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t99_central_cust_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t99_central_cust_info(
    cust_num varchar2(24) -- 客户编号
    ,cust_name varchar2(300) -- 客户名称
    ,org_type_cd varchar2(9) -- 组织机构类型代码
    ,rgst_type_cd varchar2(9) -- 登记注册类型代码
    ,nation_eco_dept_cd varchar2(9) -- 国民经济部门代码
    ,belong_indus_cd varchar2(9) -- 所属行业代码
    ,corp_size_cd varchar2(2) -- 企业规模
    ,addr_detail varchar2(600) -- 注册地址
    ,phys_addr_cty_zone_cd varchar2(5) -- 注册地国家
    ,prov_cd varchar2(9) -- 注册地省份
    ,city_cd varchar2(9) -- 注册地市级
    ,county_cd varchar2(9) -- 注册地区级
    ,economic_org_form varchar2(9) -- 控股类型
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
grant select on ${iol_schema}.eifs_t99_central_cust_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t99_central_cust_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t99_central_cust_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t99_central_cust_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t99_central_cust_info is '中央客户信息';
comment on column ${iol_schema}.eifs_t99_central_cust_info.cust_num is '客户编号';
comment on column ${iol_schema}.eifs_t99_central_cust_info.cust_name is '客户名称';
comment on column ${iol_schema}.eifs_t99_central_cust_info.org_type_cd is '组织机构类型代码';
comment on column ${iol_schema}.eifs_t99_central_cust_info.rgst_type_cd is '登记注册类型代码';
comment on column ${iol_schema}.eifs_t99_central_cust_info.nation_eco_dept_cd is '国民经济部门代码';
comment on column ${iol_schema}.eifs_t99_central_cust_info.belong_indus_cd is '所属行业代码';
comment on column ${iol_schema}.eifs_t99_central_cust_info.corp_size_cd is '企业规模';
comment on column ${iol_schema}.eifs_t99_central_cust_info.addr_detail is '注册地址';
comment on column ${iol_schema}.eifs_t99_central_cust_info.phys_addr_cty_zone_cd is '注册地国家';
comment on column ${iol_schema}.eifs_t99_central_cust_info.prov_cd is '注册地省份';
comment on column ${iol_schema}.eifs_t99_central_cust_info.city_cd is '注册地市级';
comment on column ${iol_schema}.eifs_t99_central_cust_info.county_cd is '注册地区级';
comment on column ${iol_schema}.eifs_t99_central_cust_info.economic_org_form is '控股类型';
comment on column ${iol_schema}.eifs_t99_central_cust_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t99_central_cust_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t99_central_cust_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t99_central_cust_info.etl_timestamp is 'ETL处理时间戳';
