/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myjb_loan_calc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myjb_loan_calc
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myjb_loan_calc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_loan_calc(
    contract_no varchar2(64) -- 借呗平台贷款合同号
    ,calc_date varchar2(8) -- 计息日期
    ,accrued_status varchar2(2) -- 应计非应计标识
    ,ovd_prin_pnlt_amt number(24,6) -- 逾期本金罚息（单位分），宽限期内金额为0
    ,ovd_int_pnlt_amt number(12,0) -- 逾期利息罚息（单位分）
    ,prin_bal number(12,0) -- 正常本金余额（单位分）
    ,ovd_int_bal number(12,0) -- 逾期利息余额（单位分）
    ,ovd_prin_bal number(12,0) -- 逾期本金余额（单位分）
    ,write_off varchar2(2) -- 核销标识，已核销为Y，否则为N
    ,int_amt number(24,6) -- 正常利息（单位分）
    ,real_rate number(9,6) -- 贷款实际日利率
    ,pnlt_rate number(15,8) -- 贷款罚息日利率，为日利率的1.5倍，保留6位小数
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
grant select on ${iol_schema}.icms_myjb_loan_calc to ${iml_schema};
grant select on ${iol_schema}.icms_myjb_loan_calc to ${icl_schema};
grant select on ${iol_schema}.icms_myjb_loan_calc to ${idl_schema};
grant select on ${iol_schema}.icms_myjb_loan_calc to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myjb_loan_calc is '蚂蚁借呗利息计提明细';
comment on column ${iol_schema}.icms_myjb_loan_calc.contract_no is '借呗平台贷款合同号';
comment on column ${iol_schema}.icms_myjb_loan_calc.calc_date is '计息日期';
comment on column ${iol_schema}.icms_myjb_loan_calc.accrued_status is '应计非应计标识';
comment on column ${iol_schema}.icms_myjb_loan_calc.ovd_prin_pnlt_amt is '逾期本金罚息（单位分），宽限期内金额为0';
comment on column ${iol_schema}.icms_myjb_loan_calc.ovd_int_pnlt_amt is '逾期利息罚息（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_calc.prin_bal is '正常本金余额（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_calc.ovd_int_bal is '逾期利息余额（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_calc.ovd_prin_bal is '逾期本金余额（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_calc.write_off is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_myjb_loan_calc.int_amt is '正常利息（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_calc.real_rate is '贷款实际日利率';
comment on column ${iol_schema}.icms_myjb_loan_calc.pnlt_rate is '贷款罚息日利率，为日利率的1.5倍，保留6位小数';
comment on column ${iol_schema}.icms_myjb_loan_calc.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_myjb_loan_calc.etl_timestamp is 'ETL处理时间戳';
