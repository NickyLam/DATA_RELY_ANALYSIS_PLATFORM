/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myjb_loan_calc3
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myjb_loan_calc3
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myjb_loan_calc3 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_loan_calc3(
    contractno varchar2(64) -- 借呗平台贷款合同号
    ,calcdate varchar2(8) -- 计息日期
    ,accruedstatus varchar2(2) -- 应计非应计标识
    ,prinbal number(12,0) -- 正常本金余额（单位分）
    ,ovdintbal number(12,0) -- 逾期利息余额（单位分）
    ,ovdprinbal number(12,0) -- 逾期本金余额（单位分）
    ,pnltrate number(15,8) -- 贷款罚息日利率，为日利率的1.5倍，保留6位小数
    ,ovdintpnltamt number(12,0) -- 逾期利息罚息（单位分）
    ,intamt number(24,6) -- 正常利息（单位分）
    ,writeoff varchar2(2) -- 核销标识，已核销为Y，否则为N
    ,realrate number(9,6) -- 贷款实际日利率
    ,ovdprinpnltamt number(24,6) -- 逾期本金罚息（单位分），宽限期内金额为0
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
grant select on ${iol_schema}.icms_myjb_loan_calc3 to ${iml_schema};
grant select on ${iol_schema}.icms_myjb_loan_calc3 to ${icl_schema};
grant select on ${iol_schema}.icms_myjb_loan_calc3 to ${idl_schema};
grant select on ${iol_schema}.icms_myjb_loan_calc3 to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myjb_loan_calc3 is '蚂蚁借呗3期利息计提明细';
comment on column ${iol_schema}.icms_myjb_loan_calc3.contractno is '借呗平台贷款合同号';
comment on column ${iol_schema}.icms_myjb_loan_calc3.calcdate is '计息日期';
comment on column ${iol_schema}.icms_myjb_loan_calc3.accruedstatus is '应计非应计标识';
comment on column ${iol_schema}.icms_myjb_loan_calc3.prinbal is '正常本金余额（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_calc3.ovdintbal is '逾期利息余额（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_calc3.ovdprinbal is '逾期本金余额（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_calc3.pnltrate is '贷款罚息日利率，为日利率的1.5倍，保留6位小数';
comment on column ${iol_schema}.icms_myjb_loan_calc3.ovdintpnltamt is '逾期利息罚息（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_calc3.intamt is '正常利息（单位分）';
comment on column ${iol_schema}.icms_myjb_loan_calc3.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_myjb_loan_calc3.realrate is '贷款实际日利率';
comment on column ${iol_schema}.icms_myjb_loan_calc3.ovdprinpnltamt is '逾期本金罚息（单位分），宽限期内金额为0';
comment on column ${iol_schema}.icms_myjb_loan_calc3.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_myjb_loan_calc3.etl_timestamp is 'ETL处理时间戳';
