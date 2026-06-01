/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_teller_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_teller_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_teller_info_h(
etl_dt date --数据日期
,teller_id varchar2(100) --柜员编号
,teller_name varchar2(250) --柜员名称
,org_id varchar2(100) --机构编号
,teller_status_cd varchar2(30) --柜员状态代码
,teller_type_cd varchar2(30) --柜员类型代码
,emply_id varchar2(100) --员工编号
,cust_mgr_id varchar2(100) --客户经理编号
,cust_mgr_flg varchar2(10) --客户经理标志
,cust_mgr_lev_cd varchar2(30) --客户经理级别代码
,teller_lev_cd varchar2(30) --柜员级别代码
,teller_director_id varchar2(100) --柜员主管编号
,high_teller_flg varchar2(10) --高柜标志
,teller_create_dt date --柜员创建日期
,logon_dt date --登陆日期
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,teller_subclass_cd varchar2(10) --柜员细类代码
,party_id varchar2(100) --当事人编号
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
grant select on ${idl_schema}.oass_pty_teller_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_teller_info_h is '柜员信息历史';
comment on column ${idl_schema}.oass_pty_teller_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_teller_info_h.teller_id is '柜员编号';
comment on column ${idl_schema}.oass_pty_teller_info_h.teller_name is '柜员名称';
comment on column ${idl_schema}.oass_pty_teller_info_h.org_id is '机构编号';
comment on column ${idl_schema}.oass_pty_teller_info_h.teller_status_cd is '柜员状态代码';
comment on column ${idl_schema}.oass_pty_teller_info_h.teller_type_cd is '柜员类型代码';
comment on column ${idl_schema}.oass_pty_teller_info_h.emply_id is '员工编号';
comment on column ${idl_schema}.oass_pty_teller_info_h.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.oass_pty_teller_info_h.cust_mgr_flg is '客户经理标志';
comment on column ${idl_schema}.oass_pty_teller_info_h.cust_mgr_lev_cd is '客户经理级别代码';
comment on column ${idl_schema}.oass_pty_teller_info_h.teller_lev_cd is '柜员级别代码';
comment on column ${idl_schema}.oass_pty_teller_info_h.teller_director_id is '柜员主管编号';
comment on column ${idl_schema}.oass_pty_teller_info_h.high_teller_flg is '高柜标志';
comment on column ${idl_schema}.oass_pty_teller_info_h.teller_create_dt is '柜员创建日期';
comment on column ${idl_schema}.oass_pty_teller_info_h.logon_dt is '登陆日期';
comment on column ${idl_schema}.oass_pty_teller_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_teller_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_teller_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_teller_info_h.teller_subclass_cd is '柜员细类代码';
comment on column ${idl_schema}.oass_pty_teller_info_h.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_teller_info_h.lp_id is '法人编号';

