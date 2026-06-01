/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_finc_acct
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_finc_acct purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_finc_acct(
etl_dt date --数据日期
,lp_id varchar2(60) --法人编号
,ta_cd varchar2(10) --TA代码
,finc_acct_id varchar2(60) --理财账户编号
,belong_org_id varchar2(60) --所属机构编号
,ta_tran_acct_id varchar2(60) --TA交易账户编号
,cust_mgr_id varchar2(60) --客户经理编号
,open_acct_way_cd varchar2(10) --开户方式代码
,cust_type_cd varchar2(10) --客户类型代码
,bus_cate_cd varchar2(10) --业务类别代码
,acct_status_cd varchar2(10) --账户状态代码
,open_dt date --开通日期
,sign_acct_id varchar2(60) --签约账户编号
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(60) --协议编号
,intnal_cust_acct varchar2(60) --内部客户账户

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_finc_acct to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_finc_acct is '理财账户';
comment on column ${idl_schema}.oass_agt_finc_acct.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_finc_acct.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_finc_acct.ta_cd is 'TA代码';
comment on column ${idl_schema}.oass_agt_finc_acct.finc_acct_id is '理财账户编号';
comment on column ${idl_schema}.oass_agt_finc_acct.belong_org_id is '所属机构编号';
comment on column ${idl_schema}.oass_agt_finc_acct.ta_tran_acct_id is 'TA交易账户编号';
comment on column ${idl_schema}.oass_agt_finc_acct.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.oass_agt_finc_acct.open_acct_way_cd is '开户方式代码';
comment on column ${idl_schema}.oass_agt_finc_acct.cust_type_cd is '客户类型代码';
comment on column ${idl_schema}.oass_agt_finc_acct.bus_cate_cd is '业务类别代码';
comment on column ${idl_schema}.oass_agt_finc_acct.acct_status_cd is '账户状态代码';
comment on column ${idl_schema}.oass_agt_finc_acct.open_dt is '开通日期';
comment on column ${idl_schema}.oass_agt_finc_acct.sign_acct_id is '签约账户编号';
comment on column ${idl_schema}.oass_agt_finc_acct.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_finc_acct.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_finc_acct.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_finc_acct.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_finc_acct.intnal_cust_acct is '内部客户账户';

