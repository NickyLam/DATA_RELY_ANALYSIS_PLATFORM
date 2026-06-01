/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_pty_corp_bank_acct_info_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_pty_corp_bank_acct_info_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_pty_corp_bank_acct_info_h(
etl_dt date --数据日期
,sorc_sys_cd varchar2(10) --源系统代码
,basic_open_bank_no varchar2(100) --基本开户行行号
,basic_open_bank_name varchar2(250) --基本账户开户行名称
,basic_acct_id varchar2(60) --基本账户账号
,basic_open_acct_dt date --基本账户开户日期
,obank_acct_num varchar2(60) --他行账号
,obank_acct_bank_name varchar2(100) --他行账户行名称
,hxb_acct_num varchar2(60) --我行账号
,hxb_acct_bank_name varchar2(100) --我行账户行名称
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
grant select on ${idl_schema}.oass_pty_corp_bank_acct_info_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_pty_corp_bank_acct_info_h is '公司银行账户信息历史';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.sorc_sys_cd is '源系统代码';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.basic_open_bank_no is '基本开户行行号';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.basic_open_bank_name is '基本账户开户行名称';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.basic_acct_id is '基本账户账号';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.basic_open_acct_dt is '基本账户开户日期';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.obank_acct_num is '他行账号';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.obank_acct_bank_name is '他行账户行名称';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.hxb_acct_num is '我行账号';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.hxb_acct_bank_name is '我行账户行名称';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.party_id is '当事人编号';
comment on column ${idl_schema}.oass_pty_corp_bank_acct_info_h.lp_id is '法人编号';

