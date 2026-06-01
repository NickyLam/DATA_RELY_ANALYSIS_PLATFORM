/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_orws_t_ghbr_bv_statistics_sys
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics_sys
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics_sys purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics_sys(
     etl_dt date --数据日期
    ,statistics_id number(18,0) -- 主键
    ,sys_name varchar2(255) -- 
    ,id number(18,0) -- 
    ,sys_weight_txnvol number(18,0) -- 
    ,sys_txnvol number(18,0) -- 
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
grant select on ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics_sys to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics_sys is '业务量系统统计表';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics_sys.statistics_id is '主键';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics_sys.sys_name is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics_sys.id is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics_sys.sys_weight_txnvol is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics_sys.sys_txnvol is '';
comment on column ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics_sys.etl_timestamp is 'ETL处理时间戳';