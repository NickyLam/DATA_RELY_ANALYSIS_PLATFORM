/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_org_intnal_org_addit_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_org_intnal_org_addit_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_org_intnal_org_addit_info(
etl_dt date --ETL处理日期
,bus_lics_num varchar2(60) --营业执照号码
,work_start_tm varchar2(10) --工作开始时间
,work_end_tm varchar2(10) --工作结束时间
,create_dt date --创建日期
,update_dt date --更新日期
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
grant select on ${idl_schema}.oass_org_intnal_org_addit_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_org_intnal_org_addit_info is '内部机构附加信息';
comment on column ${idl_schema}.oass_org_intnal_org_addit_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_org_intnal_org_addit_info.bus_lics_num is '营业执照号码';
comment on column ${idl_schema}.oass_org_intnal_org_addit_info.work_start_tm is '工作开始时间';
comment on column ${idl_schema}.oass_org_intnal_org_addit_info.work_end_tm is '工作结束时间';
comment on column ${idl_schema}.oass_org_intnal_org_addit_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_org_intnal_org_addit_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_org_intnal_org_addit_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_org_intnal_org_addit_info.org_id is '机构编号';
comment on column ${idl_schema}.oass_org_intnal_org_addit_info.lp_id is '法人编号';

