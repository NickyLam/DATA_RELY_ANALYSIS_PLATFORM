/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_party
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_party purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_party(
etl_dt date --ETL处理日期
,src_party_id varchar2(60) --源当事人编号
,party_name varchar2(500) --当事人名称
,party_type_cd varchar2(20) --当事人类型代码
,effect_dt date --客户开户日期
,invalid_dt date --客户销户日期
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,src_party_type_cd varchar2(20) --源当事人类型代码
,party_id varchar2(60) --当事人编号
,lp_id varchar2(60) --法人编号
,job_cd varchar2(60) --系统来源

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_pty_party to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_party is '当事人';
comment on column ${idl_schema}.oass_pty_party.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_pty_party.src_party_id is '源当事人编号';
comment on column ${idl_schema}.oass_pty_party.party_name is '当事人名称';
comment on column ${idl_schema}.oass_pty_party.party_type_cd is '当事人类型代码';
comment on column ${idl_schema}.oass_pty_party.effect_dt is '客户开户日期';
comment on column ${idl_schema}.oass_pty_party.invalid_dt is '客户销户日期';
comment on column ${idl_schema}.oass_pty_party.create_dt is '创建日期';
comment on column ${idl_schema}.oass_pty_party.update_dt is '更新日期';
comment on column ${idl_schema}.oass_pty_party.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_party.src_party_type_cd is '源当事人类型代码';
comment on column ${idl_schema}.oass_pty_party.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_party.lp_id is '法人编号';

