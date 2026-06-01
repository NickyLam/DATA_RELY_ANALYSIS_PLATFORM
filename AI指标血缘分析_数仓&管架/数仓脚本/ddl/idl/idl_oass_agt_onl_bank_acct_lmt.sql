/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_onl_bank_acct_lmt
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_onl_bank_acct_lmt purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_onl_bank_acct_lmt(
etl_dt date --数据日期
,acct_id varchar2(60) --账户编号
,cust_id varchar2(60) --客户编号
,user_seq_num varchar2(60) --用户顺序号
,lmt_attr_name varchar2(100) --限额属性名称
,lmt_attr_val varchar2(2000) --限额属性值
,tran_chn_cd varchar2(30) --交易渠道代码
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(250) --协议编号
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
grant select on ${idl_schema}.oass_agt_onl_bank_acct_lmt to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_onl_bank_acct_lmt is '网上银行账户限额';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.acct_id is '账户编号';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.user_seq_num is '用户顺序号';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.lmt_attr_name is '限额属性名称';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.lmt_attr_val is '限额属性值';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.tran_chn_cd is '交易渠道代码';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_onl_bank_acct_lmt.lp_id is '法人编号';

