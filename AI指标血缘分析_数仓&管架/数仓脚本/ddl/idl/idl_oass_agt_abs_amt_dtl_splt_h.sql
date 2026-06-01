/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_abs_amt_dtl_splt_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_abs_amt_dtl_splt_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_abs_amt_dtl_splt_h(
etl_dt date --数据日期
,agt_id varchar2(250) --协议编号
,lp_id varchar2(100) --法人编号
,asset_amt_dtl_seq_num varchar2(60) --资产金额明细序号
,asset_bag_cont_dtl_seq_num varchar2(60) --资产包合同明细序号
,cust_id varchar2(100) --客户编号
,amt_type_cd varchar2(30) --金额类型代码
,paybl_bank_int_amt number(30,2) --应付行内金额
,loan_surp_amt number(30,2) --贷款剩余金额
,redem_paybl_cntpty_int number(30,2) --赎回应付对手利息
,redem_surp_cntpty_int number(30,2) --赎回剩余对手利息
,pkg_tran_in_suspd_crdt_acct_amt number(30,2) --封包转入暂收款账户金额
,final_modif_dt date --最后修改日期
,tran_tm timestamp(6) --交易时间
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_abs_amt_dtl_splt_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_abs_amt_dtl_splt_h is '资产转让金额明细拆分历史';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.lp_id is '法人编号';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.asset_amt_dtl_seq_num is '资产金额明细序号';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.asset_bag_cont_dtl_seq_num is '资产包合同明细序号';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.amt_type_cd is '金额类型代码';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.paybl_bank_int_amt is '应付行内金额';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.loan_surp_amt is '贷款剩余金额';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.redem_paybl_cntpty_int is '赎回应付对手利息';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.redem_surp_cntpty_int is '赎回剩余对手利息';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.pkg_tran_in_suspd_crdt_acct_amt is '封包转入暂收款账户金额';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.final_modif_dt is '最后修改日期';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.tran_tm is '交易时间';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_abs_amt_dtl_splt_h.id_mark is '增删标志';

