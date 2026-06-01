/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_src_dw_agt_loan_actl_repay
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_src_dw_agt_loan_actl_repay
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_src_dw_agt_loan_actl_repay purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_src_dw_agt_loan_actl_repay(
    repay_seq_num varchar2(60) -- 还款流水号
    ,loan_acct_id varchar2(60) -- 贷款账户编号
    ,curr_term number -- 当前期数
    ,repay_dt date -- 还款日期
    ,etl_dt_ora date -- 数据日期
    ,blng_pty_id varchar2(60) -- 所属客户编号
    ,ccy_cd varchar2(3) -- 币种代码
    ,curr_repay_prcp number(18,2) -- 当期还款本金
    ,curr_repay_int number(18,2) -- 当期还款利息
    ,curr_repay_pnlt number(18,2) -- 当期还款罚息
    ,curr_repay_compd_int number(18,2) -- 当期还款复利
    ,curr_repay_cost number(18,2) -- 当期还款费用
    ,curr_bal number(18,2) -- 当前余额
    ,adv_repay_flg varchar2(1) -- 提前还款标志
    ,ovdue_repay_flg varchar2(1) -- 逾期还款标志
    ,comp_repay_flg varchar2(1) -- 代偿还款标志
    ,repay_acct_id varchar2(60) -- 还款账户编号
    ,repay_chn_cd varchar2(4) -- 还款渠道代码
    ,data_src_cd varchar2(4) -- 数据来源代码
    ,del_flg varchar2(1) -- 删除标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rsts_src_dw_agt_loan_actl_repay to ${iml_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_loan_actl_repay to ${icl_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_loan_actl_repay to ${idl_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_loan_actl_repay to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_src_dw_agt_loan_actl_repay is '数仓_贷款实际还款';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.repay_seq_num is '还款流水号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.loan_acct_id is '贷款账户编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.curr_term is '当前期数';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.repay_dt is '还款日期';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.blng_pty_id is '所属客户编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.ccy_cd is '币种代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.curr_repay_prcp is '当期还款本金';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.curr_repay_int is '当期还款利息';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.curr_repay_pnlt is '当期还款罚息';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.curr_repay_compd_int is '当期还款复利';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.curr_repay_cost is '当期还款费用';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.curr_bal is '当前余额';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.adv_repay_flg is '提前还款标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.ovdue_repay_flg is '逾期还款标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.comp_repay_flg is '代偿还款标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.repay_acct_id is '还款账户编号';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.repay_chn_cd is '还款渠道代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.data_src_cd is '数据来源代码';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.del_flg is '删除标志';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_src_dw_agt_loan_actl_repay.etl_timestamp is 'ETL处理时间戳';
