/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_loan_collect
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_loan_collect
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_loan_collect purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_loan_collect(
    org_id varchar2(150) -- 机构编号
    ,org_name varchar2(500) -- 机构名称
    ,month_due varchar2(10) -- 统计月份
    ,prin_amt number(38,2) -- 应收金额
    ,dpd1_amt number(38,2) -- DPD1金额
    ,dpd4_amt number(38,2) -- DPD4金额
    ,dpd8_amt number(38,2) -- DPD8金额
    ,dpd1_cnt number(20) -- DPD1客户数
    ,dpd4_cnt number(20) -- DPD4客户数
    ,dpd8_cnt number(20) -- DPD8客户数
    ,delinquency_rate number(38,4) -- 入催率
    ,delinquency_3_rate number(38,4) -- 逾期3天转移率
    ,delinquency_7_rate number(38,4) -- 逾期7天转移率
    ,prod_cls_name varchar2(150) -- 产品分类(易贷，字节)
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mckb_loan_collect to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_loan_collect is '贷后入催表';
comment on column ${idl_schema}.mckb_loan_collect.org_id is '机构编号';
comment on column ${idl_schema}.mckb_loan_collect.org_name is '机构名称';
comment on column ${idl_schema}.mckb_loan_collect.month_due is '统计月份';
comment on column ${idl_schema}.mckb_loan_collect.prin_amt is '应收金额';
comment on column ${idl_schema}.mckb_loan_collect.dpd1_amt is 'DPD1金额';
comment on column ${idl_schema}.mckb_loan_collect.dpd4_amt is 'DPD4金额';
comment on column ${idl_schema}.mckb_loan_collect.dpd8_amt is 'DPD8金额';
comment on column ${idl_schema}.mckb_loan_collect.dpd1_cnt is 'DPD1客户数';
comment on column ${idl_schema}.mckb_loan_collect.dpd4_cnt is 'DPD4客户数';
comment on column ${idl_schema}.mckb_loan_collect.dpd8_cnt is 'DPD8客户数';
comment on column ${idl_schema}.mckb_loan_collect.delinquency_rate is '入催率';
comment on column ${idl_schema}.mckb_loan_collect.delinquency_3_rate is '逾期3天转移率';
comment on column ${idl_schema}.mckb_loan_collect.delinquency_7_rate is '逾期7天转移率';
comment on column ${idl_schema}.mckb_loan_collect.prod_cls_name is '产品分类(易贷，字节)';
comment on column ${idl_schema}.mckb_loan_collect.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_loan_collect.etl_timestamp is 'ETL处理时间戳';