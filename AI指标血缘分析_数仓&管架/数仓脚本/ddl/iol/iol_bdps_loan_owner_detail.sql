/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_loan_owner_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_loan_owner_detail
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_loan_owner_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_loan_owner_detail(
    id number(22) -- 
    ,totalamt number(18,2) -- 金额
    ,ocptype varchar2(2) -- 占用标识(0-自身，1-集团)
    ,loanno varchar2(60) -- 合同号
    ,guarno varchar2(60) -- 押品号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdps_loan_owner_detail to ${iml_schema};
grant select on ${iol_schema}.bdps_loan_owner_detail to ${icl_schema};
grant select on ${iol_schema}.bdps_loan_owner_detail to ${idl_schema};
grant select on ${iol_schema}.bdps_loan_owner_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_loan_owner_detail is '额度占用明细表';
comment on column ${iol_schema}.bdps_loan_owner_detail.id is '';
comment on column ${iol_schema}.bdps_loan_owner_detail.totalamt is '金额';
comment on column ${iol_schema}.bdps_loan_owner_detail.ocptype is '占用标识(0-自身，1-集团)';
comment on column ${iol_schema}.bdps_loan_owner_detail.loanno is '合同号';
comment on column ${iol_schema}.bdps_loan_owner_detail.guarno is '押品号';
comment on column ${iol_schema}.bdps_loan_owner_detail.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_loan_owner_detail.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_loan_owner_detail.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_loan_owner_detail.etl_timestamp is 'ETL处理时间戳';
