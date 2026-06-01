/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_icl_batch_jnl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_icl_batch_jnl
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_icl_batch_jnl purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_icl_batch_jnl(
    etl_dt date -- 数据日期
    ,tab_name varchar2(100) -- 表名
    ,batch_status varchar2(10) -- 跑批状态
    ,batch_tm timestamp -- 跑批时间
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_icl_batch_jnl to ${idl_schema};
grant select on ${icl_schema}.cmm_icl_batch_jnl to ${iel_schema};
grant select on ${icl_schema}.cmm_icl_batch_jnl to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_icl_batch_jnl is '共性加工层跑批日志表';
comment on column ${icl_schema}.cmm_icl_batch_jnl.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_icl_batch_jnl.tab_name is '表名';
comment on column ${icl_schema}.cmm_icl_batch_jnl.batch_status is '跑批状态';
comment on column ${icl_schema}.cmm_icl_batch_jnl.batch_tm is '跑批时间';
comment on column ${icl_schema}.cmm_icl_batch_jnl.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_icl_batch_jnl.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_icl_batch_jnl.etl_timestamp is 'ETL处理时间戳';
