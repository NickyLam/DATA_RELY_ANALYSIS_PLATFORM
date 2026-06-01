/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_dep_main_acct_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_dep_main_acct_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_dep_main_acct_info_h(
etl_dt date --数据日期
,lp_id varchar2(100) --法人编号
,cust_id varchar2(100) --客户编号
,card_no varchar2(60) --卡号
,open_acct_chn_id varchar2(100) --开户渠道编号
,cust_acct_num varchar2(60) --客户账号
,acct_prod_id varchar2(100) --账户产品编号
,acct_sub_acct_num varchar2(60) --账户子账号
,acct_curr_cd varchar2(30) --账户币种代码
,open_acct_org_id varchar2(100) --开户机构编号
,cust_acct_open_acct_dt date --客户账户开户日期
,core_acct_type_cd varchar2(30) --核心账户类型代码
,acct_name varchar2(500) --账户名称
,acct_status_cd varchar2(30) --账户状态代码
,last_acct_status_cd varchar2(30) --上一账户状态代码
,acct_status_modif_dt date --账户状态变更日期
,clos_acct_rs varchar2(500) --销户原因
,clos_acct_teller_id varchar2(100) --销户柜员编号
,acct_lmt_flg varchar2(10) --账户限制标志
,reg_acct_type_cd varchar2(30) --定期账户类型代码
,dep_vouch_cate_cd varchar2(30) --存款凭证类别代码
,vouch_no varchar2(60) --凭证号码
,vouch_status_cd varchar2(30) --凭证状态代码
,init_prod_id varchar2(100) --原产品编号
,cust_mgr_id varchar2(100) --客户经理编号
,general_storage_flg varchar2(10) --通存标志
,general_exch_flg varchar2(10) --通兑标志
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(250) --协议编号
,acct_id varchar2(100) --账户编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_dep_main_acct_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_dep_main_acct_info_h is '存款主账户信息历史';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.card_no is '卡号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.open_acct_chn_id is '开户渠道编号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.cust_acct_num is '客户账号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.acct_prod_id is '账户产品编号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.acct_sub_acct_num is '账户子账号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.acct_curr_cd is '账户币种代码';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.open_acct_org_id is '开户机构编号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.cust_acct_open_acct_dt is '客户账户开户日期';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.core_acct_type_cd is '核心账户类型代码';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.acct_name is '账户名称';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.acct_status_cd is '账户状态代码';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.last_acct_status_cd is '上一账户状态代码';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.acct_status_modif_dt is '账户状态变更日期';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.clos_acct_rs is '销户原因';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.clos_acct_teller_id is '销户柜员编号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.acct_lmt_flg is '账户限制标志';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.reg_acct_type_cd is '定期账户类型代码';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.dep_vouch_cate_cd is '存款凭证类别代码';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.vouch_no is '凭证号码';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.vouch_status_cd is '凭证状态代码';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.init_prod_id is '原产品编号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.cust_mgr_id is '客户经理编号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.general_storage_flg is '通存标志';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.general_exch_flg is '通兑标志';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_dep_main_acct_info_h.acct_id is '账户编号';

