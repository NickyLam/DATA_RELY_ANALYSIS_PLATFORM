/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_bu_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_bu_detail
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_bu_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_bu_detail(
 etl_dt        DATE,
  bu_org_no     VARCHAR2(20),
  bu_no         VARCHAR2(200),
  bu_dt         VARCHAR2(30),
  index_no      VARCHAR2(30),
  etl_timestamp TIMESTAMP(6),
  source_sys    VARCHAR2(60),
  DATA_SOURCE   VARCHAR2(60)
)
partition by list(etl_dt)
subpartition by list(source_sys)
(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
    (
        subpartition p_19000101_d values ('ACCT_OPEN')
    )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_bu_detail to ${idl_schema};

-- comment
comment on table mcyy_bu_detail
  is '业务明细表';
-- Add comments to the columns 
comment on column mcyy_bu_detail.etl_dt
  is '数据日期';
comment on column mcyy_bu_detail.bu_org_no
  is '业务发生机构编号';
comment on column mcyy_bu_detail.bu_no
  is '业务主体识别编号';
comment on column mcyy_bu_detail.bu_dt
  is '业务发生日期';
comment on column mcyy_bu_detail.index_no
  is '业务指标编号';
comment on column mcyy_bu_detail.etl_timestamp
  is 'ETL时间戳';
comment on column mcyy_bu_detail.source_sys
  is '来源系统';
comment on column mcyy_bu_detail.DATA_SOURCE
  is '数据来源渠道(针对开户渠道)';