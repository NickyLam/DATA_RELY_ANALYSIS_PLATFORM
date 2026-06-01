/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_appl_status_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_appl_status_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_appl_status_h(
etl_dt date --数据日期
,appl_status_type_cd varchar2(10) --申请状态类型代码
,appl_status_cd varchar2(60) --申请状态代码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,appl_id varchar2(100) --申请编号
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
grant select on ${idl_schema}.oass_agt_appl_status_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_appl_status_h is '申请状态历史';
comment on column ${idl_schema}.oass_agt_appl_status_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_appl_status_h.appl_status_type_cd is '申请状态类型代码';
comment on column ${idl_schema}.oass_agt_appl_status_h.appl_status_cd is '申请状态代码';
comment on column ${idl_schema}.oass_agt_appl_status_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_appl_status_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_appl_status_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_appl_status_h.appl_id is '申请编号';
comment on column ${idl_schema}.oass_agt_appl_status_h.lp_id is '法人编号';

