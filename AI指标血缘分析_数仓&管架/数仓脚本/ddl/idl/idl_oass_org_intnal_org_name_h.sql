/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_org_intnal_org_name_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_org_intnal_org_name_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_org_intnal_org_name_h(
etl_dt date --数据日期
,intnal_org_name_type_cd varchar2(10) --内部机构名称类型代码
,org_name varchar2(500) --机构名称
,org_abbr varchar2(100) --机构简称
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
grant select on ${idl_schema}.oass_org_intnal_org_name_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_org_intnal_org_name_h is '内部机构名称历史';
comment on column ${idl_schema}.oass_org_intnal_org_name_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_org_intnal_org_name_h.intnal_org_name_type_cd is '内部机构名称类型代码';
comment on column ${idl_schema}.oass_org_intnal_org_name_h.org_name is '机构名称';
comment on column ${idl_schema}.oass_org_intnal_org_name_h.org_abbr is '机构简称';
comment on column ${idl_schema}.oass_org_intnal_org_name_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_org_intnal_org_name_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_org_intnal_org_name_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_org_intnal_org_name_h.org_id is '机构编号';
comment on column ${idl_schema}.oass_org_intnal_org_name_h.lp_id is '法人编号';

