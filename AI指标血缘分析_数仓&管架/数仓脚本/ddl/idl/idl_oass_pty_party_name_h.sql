/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_party_name_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_party_name_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_party_name_h(
etl_dt date --数据日期
,src_sys_cd varchar2(10) --源系统代码
,party_name_type_cd varchar2(10) --当事人名称类型代码
,party_name varchar2(500) --当事人名称
,party_abbr varchar2(500) --当事人简称
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,party_id varchar2(60) --当事人编号
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
grant select on ${idl_schema}.oass_pty_party_name_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_party_name_h is '当事人名称历史';
comment on column ${idl_schema}.oass_pty_party_name_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_party_name_h.src_sys_cd is '源系统代码';
comment on column ${idl_schema}.oass_pty_party_name_h.party_name_type_cd is '当事人名称类型代码';
comment on column ${idl_schema}.oass_pty_party_name_h.party_name is '当事人名称';
comment on column ${idl_schema}.oass_pty_party_name_h.party_abbr is '当事人简称';
comment on column ${idl_schema}.oass_pty_party_name_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_party_name_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_party_name_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_party_name_h.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_party_name_h.lp_id is '法人编号';

