/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_src_dw_agt_ln_ac_amt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info(
    loan_acct_id varchar2(60) -- 贷款账户编号
    ,etl_dt_ora date -- 数据日期
    ,loan_total_term number -- 贷款总期数
    ,loan_new_term number -- 贷款目前期数
    ,ccy_cd varchar2(3) -- 币种代码
    ,loan_total_bal number(18,2) -- 贷款余额
    ,loan_bal number(18,2) -- 正常本金余额
    ,day_accr_int number(18,2) -- 日应计利息
    ,paid_prcp number(18,2) -- 已偿还本金
    ,paid_int number(18,2) -- 已偿还利息
    ,paid_pnlt number(18,2) -- 已偿还罚息
    ,paid_compd_int number(18,2) -- 已偿还复利
    ,paid_cost number(18,2) -- 已偿还费用
    ,aggr_rcvable_int_amt number(18,2) -- 累计应收未收利息金额
    ,int_on_bs_bal number(18,2) -- 表内欠息余额
    ,int_off_bs_bal number(18,2) -- 表外欠息余额
    ,on_int number(18,2) -- 表内利息
    ,off_int number(18,2) -- 表外利息
    ,provn number(18,2) -- 准备金
    ,prev_adj_int_dt date -- 上次调息日期
    ,next_adj_int_dt date -- 下次调息日期
    ,next_stl_dt date -- 下次结息日期
    ,actl_write_off_prcp number(18,2) -- 实核本金
    ,actl_write_off_int number(18,2) -- 实核利息
    ,rcva_acr_intr number(18,2) -- 应收应计利息
    ,rcva_owe_int number(18,2) -- 应收欠息
    ,rcva_accr_pnlt number(18,2) -- 应收应计罚息
    ,rcva_pnlt number(18,2) -- 应收罚息
    ,accr_cmpd_intr number(18,2) -- 应计复息
    ,rcva_cmpd_intr number(18,2) -- 应收复息
    ,dun_acr_intr number(18,2) -- 催收应计利息
    ,dun_owe_int number(18,2) -- 催收欠息
    ,dun_accr_pnlt number(18,2) -- 催收应计罚息
    ,dun_pnlt number(18,2) -- 催收罚息
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
grant select on ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info to ${iml_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info to ${icl_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info to ${idl_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info is '数仓_贷款账户金额信息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.loan_acct_id is '贷款账户编号';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.loan_total_term is '贷款总期数';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.loan_new_term is '贷款目前期数';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.ccy_cd is '币种代码';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.loan_total_bal is '贷款余额';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.loan_bal is '正常本金余额';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.day_accr_int is '日应计利息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.paid_prcp is '已偿还本金';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.paid_int is '已偿还利息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.paid_pnlt is '已偿还罚息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.paid_compd_int is '已偿还复利';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.paid_cost is '已偿还费用';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.aggr_rcvable_int_amt is '累计应收未收利息金额';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.int_on_bs_bal is '表内欠息余额';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.int_off_bs_bal is '表外欠息余额';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.on_int is '表内利息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.off_int is '表外利息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.provn is '准备金';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.prev_adj_int_dt is '上次调息日期';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.next_adj_int_dt is '下次调息日期';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.next_stl_dt is '下次结息日期';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.actl_write_off_prcp is '实核本金';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.actl_write_off_int is '实核利息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.rcva_acr_intr is '应收应计利息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.rcva_owe_int is '应收欠息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.rcva_accr_pnlt is '应收应计罚息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.rcva_pnlt is '应收罚息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.accr_cmpd_intr is '应计复息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.rcva_cmpd_intr is '应收复息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.dun_acr_intr is '催收应计利息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.dun_owe_int is '催收欠息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.dun_accr_pnlt is '催收应计罚息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.dun_pnlt is '催收罚息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.data_src_cd is '数据来源代码';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.del_flg is '删除标志';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_amt_info.etl_timestamp is 'ETL处理时间戳';
