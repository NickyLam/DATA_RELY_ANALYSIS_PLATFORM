/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol orws_t_ghbr_bv_statistics_sys
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.orws_t_ghbr_bv_statistics_sys
whenever sqlerror continue none;
drop table ${iol_schema}.orws_t_ghbr_bv_statistics_sys purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_ghbr_bv_statistics_sys(
    statistics_id number(18,0) -- 主键
    ,sys_name varchar2(383) -- 
    ,id number(18,0) -- 
    ,sys_weight_txnvol number(18,0) -- 
    ,sys_txnvol number(18,0) -- 
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
grant select on ${iol_schema}.orws_t_ghbr_bv_statistics_sys to ${iml_schema};
grant select on ${iol_schema}.orws_t_ghbr_bv_statistics_sys to ${icl_schema};
grant select on ${iol_schema}.orws_t_ghbr_bv_statistics_sys to ${idl_schema};
grant select on ${iol_schema}.orws_t_ghbr_bv_statistics_sys to ${iel_schema};

-- comment
comment on table ${iol_schema}.orws_t_ghbr_bv_statistics_sys is '业务量系统统计表';
comment on column ${iol_schema}.orws_t_ghbr_bv_statistics_sys.statistics_id is '主键';
comment on column ${iol_schema}.orws_t_ghbr_bv_statistics_sys.sys_name is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_statistics_sys.id is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_statistics_sys.sys_weight_txnvol is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_statistics_sys.sys_txnvol is '';
comment on column ${iol_schema}.orws_t_ghbr_bv_statistics_sys.start_dt is '开始时间';
comment on column ${iol_schema}.orws_t_ghbr_bv_statistics_sys.end_dt is '结束时间';
comment on column ${iol_schema}.orws_t_ghbr_bv_statistics_sys.id_mark is '增删标志';
comment on column ${iol_schema}.orws_t_ghbr_bv_statistics_sys.etl_timestamp is 'ETL处理时间戳';
