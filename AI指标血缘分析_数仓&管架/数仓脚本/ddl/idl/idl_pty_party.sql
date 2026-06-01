/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl pty_party
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.pty_party
whenever sqlerror continue none;
drop table ${idl_schema}.pty_party purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.pty_party(
    etl_dt date -- 数据日期   
    ,party_id varchar2(60) -- 当事人编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,src_party_id varchar2(60) -- 源当事人编号   
    ,party_name varchar2(500) -- 当事人名称   
    ,party_type_cd varchar2(20) -- 当事人类型代码   
    ,effect_dt date -- 生效日期   
    ,invalid_dt date -- 失效日期   
    ,src_party_type_cd varchar2(20) -- 源当事人类型代码   
    ,create_dt date -- 创建日期   
    ,update_dt date -- 更新日期   
    ,id_mark varchar2(10) -- 删除标识   
	  ,job_cd varchar2(10) --任务代码
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.pty_party to ${iel_schema};

-- comment
comment on table ${idl_schema}.pty_party is '当事人';
comment on column ${idl_schema}.pty_party.etl_dt is '数据日期';
comment on column ${idl_schema}.pty_party.party_id is '当事人编号';
comment on column ${idl_schema}.pty_party.lp_id is '法人编号';
comment on column ${idl_schema}.pty_party.src_party_id is '源当事人编号';
comment on column ${idl_schema}.pty_party.party_name is '当事人名称';
comment on column ${idl_schema}.pty_party.party_type_cd is '当事人类型代码';
comment on column ${idl_schema}.pty_party.effect_dt is '生效日期';
comment on column ${idl_schema}.pty_party.invalid_dt is '失效日期';
comment on column ${idl_schema}.pty_party.src_party_type_cd is '源当事人类型代码';
comment on column ${idl_schema}.pty_party.create_dt is '创建日期';
comment on column ${idl_schema}.pty_party.update_dt is '更新日期';
comment on column ${idl_schema}.pty_party.id_mark is '删除标识';
comment on column ${idl_schema}.pty_party.job_cd is '任务代码';