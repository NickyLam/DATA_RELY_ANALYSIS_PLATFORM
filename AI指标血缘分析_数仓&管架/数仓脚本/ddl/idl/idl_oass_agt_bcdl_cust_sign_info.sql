/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_bcdl_cust_sign_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_bcdl_cust_sign_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_bcdl_cust_sign_info(
etl_dt date --ETL处理日期
,cust_id varchar2(60) --客户编号
,cust_name varchar2(500) --客户名称
,sign_id varchar2(60) --签约编号
,sign_dt date --签约日期
,cust_open_acct_org_id varchar2(60) --客户开户机构编号
,sign_org_id varchar2(60) --签约机构编号
,cert_type_cd varchar2(60) --证件类型代码
,cert_no varchar2(60) --证件号码
,status_cd varchar2(10) --状态代码
,create_dt date --创建日期
,update_dt date --更新日期
,id_mark varchar2(10) --增删标志
,agt_id varchar2(60) --协议编号
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
grant select on ${idl_schema}.oass_agt_bcdl_cust_sign_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_bcdl_cust_sign_info is '银企直联客户签约信息';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.cust_name is '客户名称';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.sign_id is '签约编号';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.sign_dt is '签约日期';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.cust_open_acct_org_id is '客户开户机构编号';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.sign_org_id is '签约机构编号';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.cert_type_cd is '证件类型代码';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.cert_no is '证件号码';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.status_cd is '状态代码';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.create_dt is '创建日期';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.update_dt is '更新日期';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_bcdl_cust_sign_info.lp_id is '法人编号';

