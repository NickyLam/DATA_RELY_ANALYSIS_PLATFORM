/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol crps_d_crdt_distr_degree_stat
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.crps_d_crdt_distr_degree_stat
whenever sqlerror continue none;
drop table ${iol_schema}.crps_d_crdt_distr_degree_stat purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.crps_d_crdt_distr_degree_stat(
    etl_dt_ora date -- 数据日期
    ,belong_brch_id varchar2(150) -- 所属分行编号
    ,belong_brch_name varchar2(1000) -- 所属分行名称
    ,less_or_equal_250_bilon number(38,8) -- 小于等于2.5亿
    ,full_amt number(38,8) -- 全额
    ,decrs_part number(38,8) -- 减美化部分
    ,decrs_full_amt number(38,8) -- 减全额
    ,less_or_equal_250_bilon_pct number(38,8) -- 小于等于2.5亿占比
    ,curr_id varchar2(150) -- 币种编号
    ,curr_name varchar2(1000) -- 币种名称
    ,etl_timestamp_ora timestamp -- ETL处理时间
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
grant select on ${iol_schema}.crps_d_crdt_distr_degree_stat to ${iml_schema};
grant select on ${iol_schema}.crps_d_crdt_distr_degree_stat to ${icl_schema};
grant select on ${iol_schema}.crps_d_crdt_distr_degree_stat to ${idl_schema};
grant select on ${iol_schema}.crps_d_crdt_distr_degree_stat to ${iel_schema};

-- comment
comment on table ${iol_schema}.crps_d_crdt_distr_degree_stat is '授信分散度统计表';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.etl_dt_ora is '数据日期';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.belong_brch_id is '所属分行编号';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.belong_brch_name is '所属分行名称';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.less_or_equal_250_bilon is '小于等于2.5亿';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.full_amt is '全额';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.decrs_part is '减美化部分';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.decrs_full_amt is '减全额';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.less_or_equal_250_bilon_pct is '小于等于2.5亿占比';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.curr_id is '币种编号';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.curr_name is '币种名称';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.etl_timestamp_ora is 'ETL处理时间';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.crps_d_crdt_distr_degree_stat.etl_timestamp is 'ETL处理时间戳';
