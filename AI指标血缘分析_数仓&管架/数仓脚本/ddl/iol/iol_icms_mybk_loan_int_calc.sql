/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_loan_int_calc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_loan_int_calc
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_loan_int_calc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_loan_int_calc(
    contractno varchar2(64) -- 借据号
    ,accruedstatus varchar2(2) -- 应计非应计标识
    ,ovdintbal number(24,6) -- 逾期利息余额
    ,ovdprinpnltamt number(24,6) -- 逾期本金罚息
    ,bsntype varchar2(64) -- 产品业务类型
    ,ovdprinbal number(24,6) -- 逾期本金余额
    ,calcdate varchar2(64) -- 计息日期
    ,realrate number -- 贷款实际日利率
    ,intamt number(24,6) -- 正常利息
    ,ovdintpnltamt number(24,6) -- 逾期利息罚息
    ,pnltrate number -- 贷款罚息日利率
    ,writeoff varchar2(8) -- 核销标识，已核销为Y，否则为N
    ,prinbal number(24,6) -- 正常本金余额
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
grant select on ${iol_schema}.icms_mybk_loan_int_calc to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_loan_int_calc to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_loan_int_calc to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_loan_int_calc to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_loan_int_calc is '网商贷每日利息计提';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.contractno is '借据号';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.accruedstatus is '应计非应计标识';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.ovdintbal is '逾期利息余额';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.ovdprinpnltamt is '逾期本金罚息';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.ovdprinbal is '逾期本金余额';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.calcdate is '计息日期';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.realrate is '贷款实际日利率';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.intamt is '正常利息';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.ovdintpnltamt is '逾期利息罚息';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.pnltrate is '贷款罚息日利率';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.prinbal is '正常本金余额';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_loan_int_calc.etl_timestamp is 'ETL处理时间戳';
