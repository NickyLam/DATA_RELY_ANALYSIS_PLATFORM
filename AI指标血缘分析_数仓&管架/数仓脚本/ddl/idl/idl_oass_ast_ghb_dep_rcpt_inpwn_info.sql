/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_ast_ghb_dep_rcpt_inpwn_info
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info(
etl_dt date --数据日期
,dep_rcpt_vouch_num varchar2(100) --存单凭证号
,aval_amt number(30,2) --可用金额
,cust_acct_num_id varchar2(100) --客户账号编号
,effect_dt date --生效日期
,exp_dt date --到期日期
,acct_bal number(30,2) --账户余额
,cust_sub_acct_num varchar2(60) --客户子账户号
,stop_pay_advise_id varchar2(100) --止付通知书编号
,curr_cd varchar2(10) --币种代码
,dep_term_cd varchar2(30) --存期代码
,int_rat number(18,8) --利率
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,remark varchar2(4000) --备注
,asset_id varchar2(60) --资产编号
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
grant select on ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info is '本行存单质押信息';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.dep_rcpt_vouch_num is '存单凭证号';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.aval_amt is '可用金额';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.cust_acct_num_id is '客户账号编号';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.effect_dt is '生效日期';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.exp_dt is '到期日期';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.acct_bal is '账户余额';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.cust_sub_acct_num is '客户子账户号';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.stop_pay_advise_id is '止付通知书编号';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.dep_term_cd is '存期代码';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.int_rat is '利率';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.start_dt is '开始时间';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.end_dt is '结束时间';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.id_mark is '增删标志';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.remark is '备注';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.asset_id is '资产编号';
comment on column ${idl_schema}.oass_ast_ghb_dep_rcpt_inpwn_info.lp_id is '法人编号';

