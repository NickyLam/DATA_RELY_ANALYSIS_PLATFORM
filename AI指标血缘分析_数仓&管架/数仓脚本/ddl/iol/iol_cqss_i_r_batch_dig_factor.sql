/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol cqss_i_r_batch_dig_factor
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.cqss_i_r_batch_dig_factor
whenever sqlerror continue none;
drop table ${iol_schema}.cqss_i_r_batch_dig_factor purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.cqss_i_r_batch_dig_factor(
    tsk_seq_no number(10,0) -- 任务顺序号
    ,inf_rcrd_idr_no number(10,0) -- 信息记录标识号
    ,aft_rmrk varchar2(2250) -- 影响因素
    ,crt_dt_tm date -- 创建日期时间
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
grant select on ${iol_schema}.cqss_i_r_batch_dig_factor to ${iml_schema};
grant select on ${iol_schema}.cqss_i_r_batch_dig_factor to ${icl_schema};
grant select on ${iol_schema}.cqss_i_r_batch_dig_factor to ${idl_schema};
grant select on ${iol_schema}.cqss_i_r_batch_dig_factor to ${iel_schema};

-- comment
comment on table ${iol_schema}.cqss_i_r_batch_dig_factor is '个人数字解读影响因素表';
comment on column ${iol_schema}.cqss_i_r_batch_dig_factor.tsk_seq_no is '任务顺序号';
comment on column ${iol_schema}.cqss_i_r_batch_dig_factor.inf_rcrd_idr_no is '信息记录标识号';
comment on column ${iol_schema}.cqss_i_r_batch_dig_factor.aft_rmrk is '影响因素';
comment on column ${iol_schema}.cqss_i_r_batch_dig_factor.crt_dt_tm is '创建日期时间';
comment on column ${iol_schema}.cqss_i_r_batch_dig_factor.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.cqss_i_r_batch_dig_factor.etl_timestamp is 'ETL处理时间戳';
