/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifcs_acct_bal_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifcs_acct_bal_info
whenever sqlerror continue none;
drop table ${iol_schema}.ifcs_acct_bal_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifcs_acct_bal_info(
    tran_dt varchar2(30) -- 交易日期
    ,org_id varchar2(30) -- 机构号
    ,acct_id varchar2(90) -- 账号
    ,bal number(18,2) -- 余额
    ,deposit_amount number(18,2) -- 总存款金额
    ,withdrawal_amount number(18,2) -- 总支取金额
    ,dps_type_cd varchar2(15) -- 储种 s01-储蓄活期  s02-储蓄定期
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
grant select on ${iol_schema}.ifcs_acct_bal_info to ${iml_schema};
grant select on ${iol_schema}.ifcs_acct_bal_info to ${icl_schema};
grant select on ${iol_schema}.ifcs_acct_bal_info to ${idl_schema};
grant select on ${iol_schema}.ifcs_acct_bal_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifcs_acct_bal_info is '账户余额统计表';
comment on column ${iol_schema}.ifcs_acct_bal_info.tran_dt is '交易日期';
comment on column ${iol_schema}.ifcs_acct_bal_info.org_id is '机构号';
comment on column ${iol_schema}.ifcs_acct_bal_info.acct_id is '账号';
comment on column ${iol_schema}.ifcs_acct_bal_info.bal is '余额';
comment on column ${iol_schema}.ifcs_acct_bal_info.deposit_amount is '总存款金额';
comment on column ${iol_schema}.ifcs_acct_bal_info.withdrawal_amount is '总支取金额';
comment on column ${iol_schema}.ifcs_acct_bal_info.dps_type_cd is '储种 s01-储蓄活期  s02-储蓄定期';
comment on column ${iol_schema}.ifcs_acct_bal_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifcs_acct_bal_info.etl_timestamp is 'ETL处理时间戳';
