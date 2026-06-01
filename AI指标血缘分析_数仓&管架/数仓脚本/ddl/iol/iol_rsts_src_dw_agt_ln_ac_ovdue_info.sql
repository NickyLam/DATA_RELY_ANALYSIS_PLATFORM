/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_src_dw_agt_ln_ac_ovdue_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info(
    loan_acct_id varchar2(60) -- 贷款账户编号
    ,etl_dt_ora date -- 数据日期
    ,ovdue_flg varchar2(1) -- 逾期标志
    ,ovdue_princp_amt number(18,2) -- 逾期本金金额
    ,ovdue_int_amt number(18,2) -- 逾期利息金额
    ,ovdue_int_compd_int number(18,2) -- 逾期利息复利
    ,rcva_owe_int_bal number(18,2) -- 欠息余额
    ,rcva_pnlt_bal number(18,2) -- 罚息余额
    ,princp_ovdue_dt date -- 本金逾期日期
    ,int_ovdue_dt date -- 利息逾期日期
    ,ovdue_term number -- 逾期期数
    ,sub_term number -- 子期数
    ,ovdue_days number -- 逾期天数
    ,dull_bal number(18,2) -- 呆滞余额
    ,bad_debt_bal number(18,2) -- 呆账余额
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
grant select on ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info to ${iml_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info to ${icl_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info to ${idl_schema};
grant select on ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info is '数仓_贷款逾期信息';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.loan_acct_id is '贷款账户编号';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.ovdue_flg is '逾期标志';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.ovdue_princp_amt is '逾期本金金额';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.ovdue_int_amt is '逾期利息金额';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.ovdue_int_compd_int is '逾期利息复利';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.rcva_owe_int_bal is '欠息余额';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.rcva_pnlt_bal is '罚息余额';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.princp_ovdue_dt is '本金逾期日期';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.int_ovdue_dt is '利息逾期日期';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.ovdue_term is '逾期期数';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.sub_term is '子期数';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.ovdue_days is '逾期天数';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.dull_bal is '呆滞余额';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.bad_debt_bal is '呆账余额';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.data_src_cd is '数据来源代码';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.del_flg is '删除标志';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_src_dw_agt_ln_ac_ovdue_info.etl_timestamp is 'ETL处理时间戳';
