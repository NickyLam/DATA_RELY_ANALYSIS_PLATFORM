/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_pcls_byte_repay_bucket
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_pcls_byte_repay_bucket
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_pcls_byte_repay_bucket purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_pcls_byte_repay_bucket(
    repay_area varchar2(4000) -- 定价区间
    ,datecreated1 varchar2(4000) -- 申请日期
    ,appl_cnt number(20) -- 申请笔数
    ,appl_pass_cnt number(20) -- 申请通过笔数
    ,appl_pass_percent number(20) -- 申请通过率
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
grant select on ${itl_schema}.itl_edw_pcls_byte_repay_bucket to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_pcls_byte_repay_bucket is '字节小微定价分箱表';
comment on column ${itl_schema}.itl_edw_pcls_byte_repay_bucket.repay_area is '定价区间';
comment on column ${itl_schema}.itl_edw_pcls_byte_repay_bucket.datecreated1 is '申请日期';
comment on column ${itl_schema}.itl_edw_pcls_byte_repay_bucket.appl_cnt is '申请笔数';
comment on column ${itl_schema}.itl_edw_pcls_byte_repay_bucket.appl_pass_cnt is '申请通过笔数';
comment on column ${itl_schema}.itl_edw_pcls_byte_repay_bucket.appl_pass_percent is '申请通过率';
comment on column ${itl_schema}.itl_edw_pcls_byte_repay_bucket.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_pcls_byte_repay_bucket.etl_timestamp is 'ETL处理时间戳';
