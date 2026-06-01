/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_temp_wyd_loan_relative_rep_three
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_temp_wyd_loan_relative_rep_three
whenever sqlerror continue none;
drop table ${iol_schema}.icms_temp_wyd_loan_relative_rep_three purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_temp_wyd_loan_relative_rep_three(
    loanno varchar2(64) -- 主借据号
    ,relativeloanno varchar2(64) -- 关联主借据号
    ,businesstype varchar2(10) -- 业务类型
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
grant select on ${iol_schema}.icms_temp_wyd_loan_relative_rep_three to ${iml_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_relative_rep_three to ${icl_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_relative_rep_three to ${idl_schema};
grant select on ${iol_schema}.icms_temp_wyd_loan_relative_rep_three to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_temp_wyd_loan_relative_rep_three is '借据信息关联报表中间表03';
comment on column ${iol_schema}.icms_temp_wyd_loan_relative_rep_three.loanno is '主借据号';
comment on column ${iol_schema}.icms_temp_wyd_loan_relative_rep_three.relativeloanno is '关联主借据号';
comment on column ${iol_schema}.icms_temp_wyd_loan_relative_rep_three.businesstype is '业务类型';
comment on column ${iol_schema}.icms_temp_wyd_loan_relative_rep_three.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_temp_wyd_loan_relative_rep_three.etl_timestamp is 'ETL处理时间戳';
