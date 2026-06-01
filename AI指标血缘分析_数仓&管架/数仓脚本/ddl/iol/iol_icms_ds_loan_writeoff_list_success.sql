/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ds_loan_writeoff_list_success
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ds_loan_writeoff_list_success
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ds_loan_writeoff_list_success purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ds_loan_writeoff_list_success(
    writeoffdate varchar2(10) -- 核销日期
    ,name varchar2(200) -- 姓名
    ,custid varchar2(20) -- 客户号
    ,bankno varchar2(20) -- 银行号
    ,bankgroupid varchar2(5) -- 参贷方案号
    ,productcd varchar2(6) -- 产品号
    ,logicalcardno varchar2(19) -- 卡号
    ,refnbr varchar2(23) -- 参考号
    ,writeoffprocstatus varchar2(20) -- 核销状态
    ,loaninitprin number(15,2) -- 本金
    ,loanintrpenalty number(15,2) -- 利息罚息
    ,bankproportion number(5,2) -- 参贷方案比例
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
grant select on ${iol_schema}.icms_ds_loan_writeoff_list_success to ${iml_schema};
grant select on ${iol_schema}.icms_ds_loan_writeoff_list_success to ${icl_schema};
grant select on ${iol_schema}.icms_ds_loan_writeoff_list_success to ${idl_schema};
grant select on ${iol_schema}.icms_ds_loan_writeoff_list_success to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ds_loan_writeoff_list_success is '微粒贷已核销借据清单表';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.writeoffdate is '核销日期';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.name is '姓名';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.custid is '客户号';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.bankno is '银行号';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.bankgroupid is '参贷方案号';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.productcd is '产品号';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.logicalcardno is '卡号';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.refnbr is '参考号';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.writeoffprocstatus is '核销状态';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.loaninitprin is '本金';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.loanintrpenalty is '利息罚息';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.bankproportion is '参贷方案比例';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_ds_loan_writeoff_list_success.etl_timestamp is 'ETL处理时间戳';
