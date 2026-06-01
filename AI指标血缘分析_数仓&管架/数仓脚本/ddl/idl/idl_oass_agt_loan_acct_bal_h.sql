/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_agt_loan_acct_bal_h
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_agt_loan_acct_bal_h purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_agt_loan_acct_bal_h(
etl_dt date --数据日期
,acct_id varchar2(100) --账户编号
,cust_id varchar2(100) --客户编号
,distr_amt number(30,2) --发放金额
,ld_distr_amt number(30,2) --上日发放金额
,nomal_pric number(30,2) --正常本金
,ld_nomal_pric number(30,2) --上日正常本金
,ovdue_pric number(30,2) --逾期本金
,ld_ovdue_pric number(30,2) --上日逾期本金
,ovdue_int number(30,2) --逾期利息
,ld_ovdue_int number(30,2) --上日逾期利息
,ovdue_pnlt number(30,2) --逾期罚息
,ld_ovdue_pnlt number(30,2) --上日逾期罚息
,ovdue_comp_int number(30,2) --逾期复利
,ld_ovdue_comp_int number(30,2) --上日逾期复利
,grace_period_pric number(30,2) --宽限期本金
,ld_grace_period_pric number(30,2) --上日宽限期本金
,grace_period_int number(30,2) --宽限期利息
,ld_grace_period_int number(30,2) --上日宽限期利息
,grace_period_pnlt number(30,2) --宽限期罚息
,ld_grace_period_pnlt number(30,2) --上日宽限期罚息
,grace_period_comp_int number(30,2) --宽限期复利
,ld_grace_period_comp_int number(30,2) --上日宽限期复利
,last_activ_acct_dt date --上一动户日期
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,agt_id varchar2(250) --协议编号
,lp_id varchar2(100) --法人编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_agt_loan_acct_bal_h to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_agt_loan_acct_bal_h is '贷款账户余额历史';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.acct_id is '账户编号';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.cust_id is '客户编号';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.distr_amt is '发放金额';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ld_distr_amt is '上日发放金额';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.nomal_pric is '正常本金';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ld_nomal_pric is '上日正常本金';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ovdue_pric is '逾期本金';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ld_ovdue_pric is '上日逾期本金';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ovdue_int is '逾期利息';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ld_ovdue_int is '上日逾期利息';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ovdue_pnlt is '逾期罚息';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ld_ovdue_pnlt is '上日逾期罚息';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ovdue_comp_int is '逾期复利';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ld_ovdue_comp_int is '上日逾期复利';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.grace_period_pric is '宽限期本金';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ld_grace_period_pric is '上日宽限期本金';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.grace_period_int is '宽限期利息';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ld_grace_period_int is '上日宽限期利息';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.grace_period_pnlt is '宽限期罚息';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ld_grace_period_pnlt is '上日宽限期罚息';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.grace_period_comp_int is '宽限期复利';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.ld_grace_period_comp_int is '上日宽限期复利';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.last_activ_acct_dt is '上一动户日期';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.start_dt is '开始时间';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.end_dt is '结束时间';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.id_mark is '增删标志';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.agt_id is '协议编号';
comment on column ${idl_schema}.oass_agt_loan_acct_bal_h.lp_id is '法人编号';

