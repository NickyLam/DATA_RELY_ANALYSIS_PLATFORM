/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_org_int_org_addr_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_org_int_org_addr_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_org_int_org_addr_h(
etl_dt date --数据日期
,tel_num varchar2(60) --电话号码
,zip_cd varchar2(10) --邮政编码
,cty_or_rg_cd varchar2(10) --国家或地区代码
,prov_cd varchar2(10) --省代码
,city_cd varchar2(10) --市代码
,county_cd varchar2(10) --县代码
,dtl_addr varchar2(500) --详细地址
,princ_emply_id varchar2(60) --负责人员工编号
,princ_name varchar2(100) --负责人姓名
,ddd_area_cd varchar2(60) --国内长途区号
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,org_id varchar2(60) --机构编号
,lp_id varchar2(60) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_org_int_org_addr_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_org_int_org_addr_h is '内部机构地址历史';
comment on column ${idl_schema}.oass_org_int_org_addr_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_org_int_org_addr_h.tel_num is '电话号码';
comment on column ${idl_schema}.oass_org_int_org_addr_h.zip_cd is '邮政编码';
comment on column ${idl_schema}.oass_org_int_org_addr_h.cty_or_rg_cd is '国家或地区代码';
comment on column ${idl_schema}.oass_org_int_org_addr_h.prov_cd is '省代码';
comment on column ${idl_schema}.oass_org_int_org_addr_h.city_cd is '市代码';
comment on column ${idl_schema}.oass_org_int_org_addr_h.county_cd is '县代码';
comment on column ${idl_schema}.oass_org_int_org_addr_h.dtl_addr is '详细地址';
comment on column ${idl_schema}.oass_org_int_org_addr_h.princ_emply_id is '负责人员工编号';
comment on column ${idl_schema}.oass_org_int_org_addr_h.princ_name is '负责人姓名';
comment on column ${idl_schema}.oass_org_int_org_addr_h.ddd_area_cd is '国内长途区号';
comment on column ${idl_schema}.oass_org_int_org_addr_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_org_int_org_addr_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_org_int_org_addr_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_org_int_org_addr_h.org_id is '机构编号';
comment on column ${idl_schema}.oass_org_int_org_addr_h.lp_id is '法人编号';

