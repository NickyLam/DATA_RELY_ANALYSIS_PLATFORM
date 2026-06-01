/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mckb_credit_bucket
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mckb_credit_bucket
whenever sqlerror continue none;
drop table ${idl_schema}.mckb_credit_bucket purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mckb_credit_bucket(
    org_id varchar2(150) -- 机构编号
    ,org_name varchar2(500) -- 机构名称
    ,creditline_area varchar2(4000) -- 额度分箱
    ,datecreated1 varchar2(10) -- 申请日期
    ,appl_cnt number(20) -- 申请笔数
    ,app_pct number(38,4) -- 申请占比
    ,appl_pass_percent number(38,4) -- 通过率
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
grant select on ${idl_schema}.mckb_credit_bucket to ${iel_schema};

-- comment
comment on table ${idl_schema}.mckb_credit_bucket is '整体-额度分析';
comment on column ${idl_schema}.mckb_credit_bucket.org_id is '机构编号';
comment on column ${idl_schema}.mckb_credit_bucket.org_name is '机构名称';
comment on column ${idl_schema}.mckb_credit_bucket.creditline_area is '额度分箱';
comment on column ${idl_schema}.mckb_credit_bucket.datecreated1 is '申请日期';
comment on column ${idl_schema}.mckb_credit_bucket.appl_cnt is '申请笔数';
comment on column ${idl_schema}.mckb_credit_bucket.app_pct is '申请占比';
comment on column ${idl_schema}.mckb_credit_bucket.appl_pass_percent is '通过率';
comment on column ${idl_schema}.mckb_credit_bucket.prod_cls_name is '产品分类(易贷，字节)';
comment on column ${idl_schema}.mckb_credit_bucket.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.mckb_credit_bucket.etl_timestamp is 'ETL处理时间戳';