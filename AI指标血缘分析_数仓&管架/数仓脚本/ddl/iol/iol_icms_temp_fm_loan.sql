/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_fm_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_fm_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_fm_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_fm_loan(
    business_date varchar2(8) -- 业务日期 D日
    ,loan_id varchar2(64) -- 借据号
    ,start_date varchar2(8) -- 开始日期 起息日期
    ,end_date varchar2(8) -- 到期日期
    ,settle_date varchar2(8) -- 结清日期 贷款实际结清日期，结清前为空
    ,loan_amt varchar2(32) -- 借据金额 （单位：元）
    ,periods varchar2(32) -- 总期数
    ,cur_period varchar2(32) -- 当前期数
    ,unclear_periods varchar2(32) -- 未结清期数
    ,ovd_periods varchar2(32) -- 逾期期次数
    ,ovd_days varchar2(32) -- 逾期天数
    ,prin_bal varchar2(32) -- 本金余额 （单位：元）
    ,loan_status varchar2(1) -- 贷款状态 1-正常 2-逾期 3-结清 4-冲销
    ,norm_pri_bal varchar2(32) -- 正常本金余额 （单位：元）
    ,ovd_pri_bal varchar2(32) -- 逾期本金余额 （单位：元）
    ,norm_int_bal varchar2(32) -- 正常利息余额 （单位：元）
    ,ovd_int_bal varchar2(32) -- 逾期利息余额 （单位：元）
    ,pin_bal varchar2(32) -- 罚息余额 （单位：元）
    ,cin_bal varchar2(32) -- 复利余额 （单位：元）
    ,repay_way varchar2(2) -- 还款方式 01--等额本息
    ,finance_type varchar2(1) -- 资产类型 1-联合出资 2-机构全资
    ,asset_identification varchar2(16) -- 资产标识
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
grant select on ${iol_schema}.icms_temp_fm_loan to ${iml_schema};
grant select on ${iol_schema}.icms_temp_fm_loan to ${icl_schema};
grant select on ${iol_schema}.icms_temp_fm_loan to ${idl_schema};
grant select on ${iol_schema}.icms_temp_fm_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_fm_loan is '富民日初借据信息中间表';
comment on column ${iol_schema}.icms_temp_fm_loan.business_date is '业务日期 D日';
comment on column ${iol_schema}.icms_temp_fm_loan.loan_id is '借据号';
comment on column ${iol_schema}.icms_temp_fm_loan.start_date is '开始日期 起息日期';
comment on column ${iol_schema}.icms_temp_fm_loan.end_date is '到期日期';
comment on column ${iol_schema}.icms_temp_fm_loan.settle_date is '结清日期 贷款实际结清日期，结清前为空';
comment on column ${iol_schema}.icms_temp_fm_loan.loan_amt is '借据金额 （单位：元）';
comment on column ${iol_schema}.icms_temp_fm_loan.periods is '总期数';
comment on column ${iol_schema}.icms_temp_fm_loan.cur_period is '当前期数';
comment on column ${iol_schema}.icms_temp_fm_loan.unclear_periods is '未结清期数';
comment on column ${iol_schema}.icms_temp_fm_loan.ovd_periods is '逾期期次数';
comment on column ${iol_schema}.icms_temp_fm_loan.ovd_days is '逾期天数';
comment on column ${iol_schema}.icms_temp_fm_loan.prin_bal is '本金余额 （单位：元）';
comment on column ${iol_schema}.icms_temp_fm_loan.loan_status is '贷款状态 1-正常 2-逾期 3-结清 4-冲销';
comment on column ${iol_schema}.icms_temp_fm_loan.norm_pri_bal is '正常本金余额 （单位：元）';
comment on column ${iol_schema}.icms_temp_fm_loan.ovd_pri_bal is '逾期本金余额 （单位：元）';
comment on column ${iol_schema}.icms_temp_fm_loan.norm_int_bal is '正常利息余额 （单位：元）';
comment on column ${iol_schema}.icms_temp_fm_loan.ovd_int_bal is '逾期利息余额 （单位：元）';
comment on column ${iol_schema}.icms_temp_fm_loan.pin_bal is '罚息余额 （单位：元）';
comment on column ${iol_schema}.icms_temp_fm_loan.cin_bal is '复利余额 （单位：元）';
comment on column ${iol_schema}.icms_temp_fm_loan.repay_way is '还款方式 01--等额本息';
comment on column ${iol_schema}.icms_temp_fm_loan.finance_type is '资产类型 1-联合出资 2-机构全资';
comment on column ${iol_schema}.icms_temp_fm_loan.asset_identification is '资产标识';
comment on column ${iol_schema}.icms_temp_fm_loan.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_fm_loan.etl_timestamp is 'ETL处理时间戳';
