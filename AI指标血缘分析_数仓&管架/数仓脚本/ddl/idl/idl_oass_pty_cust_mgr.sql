/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_cust_mgr
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_cust_mgr purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_cust_mgr(
etl_dt date --ETL处理日期
,party_type_cd varchar2(10) --当事人类型代码
,cust_mgr_id varchar2(60) --客户经理编号
,cust_mgr_name varchar2(250) --客户经理姓名
,create_dt date --创建日期
,update_dt date --更新日期
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
grant select on ${idl_schema}.oass_pty_cust_mgr to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_cust_mgr is '客户经理';
comment on column ${idl_schema}.oass_pty_cust_mgr.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_pty_cust_mgr.party_type_cd is '当事人类型代码';
comment on column ${idl_schema}.oass_pty_cust_mgr.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.oass_pty_cust_mgr.cust_mgr_name is '客户经理姓名';
comment on column ${idl_schema}.oass_pty_cust_mgr.create_dt is '创建日期';
comment on column ${idl_schema}.oass_pty_cust_mgr.update_dt is '更新日期';
comment on column ${idl_schema}.oass_pty_cust_mgr.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_cust_mgr.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_cust_mgr.lp_id is '法人编号';

