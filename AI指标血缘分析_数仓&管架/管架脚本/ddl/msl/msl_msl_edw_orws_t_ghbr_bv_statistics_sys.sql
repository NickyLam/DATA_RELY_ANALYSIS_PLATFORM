/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_orws_t_ghbr_bv_statistics_sys
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys(
    etl_dt date
    ,statistics_id number(18,0)
    ,sys_name varchar2(255)
    ,id number(18,0)
    ,sys_weight_txnvol number(18,0)
    ,sys_txnvol number(18,0)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys is '业务量系统统计表';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys.statistics_id is '主键';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys.sys_name is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys.id is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys.sys_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics_sys.sys_txnvol is '';
