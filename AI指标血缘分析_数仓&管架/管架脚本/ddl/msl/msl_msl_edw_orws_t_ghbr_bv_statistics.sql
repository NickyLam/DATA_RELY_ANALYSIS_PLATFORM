/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_orws_t_ghbr_bv_statistics
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics(
    etl_dt date
    ,id number(18,0)
    ,data_date timestamp(6)
    ,data_type varchar2(2)
    ,is_shield varchar2(2)
    ,hb_num varchar2(50)
    ,hb_name varchar2(255)
    ,bb_num varchar2(50)
    ,bb_name varchar2(255)
    ,sb_num varchar2(50)
    ,sb_name varchar2(255)
    ,organ_num varchar2(50)
    ,organ_name varchar2(255)
    ,display_num varchar2(50)
    ,display_name varchar2(255)
    ,total_txnvol varchar2(18)
    ,total_weight_txnvol varchar2(18)
    ,cbss_txnvol varchar2(18)
    ,cbss_weight_txnvol varchar2(18)
    ,pwbs_txnvol varchar2(18)
    ,pwbs_weight_txnvol varchar2(18)
    ,ifms_txnvol varchar2(18)
    ,ifms_weight_txnvol varchar2(18)
    ,pbss_txnvol varchar2(18)
    ,pbss_weight_txnvol varchar2(18)
    ,isbs_txnvol varchar2(18)
    ,isbs_weight_txnvol varchar2(18)
    ,crss_txnvol varchar2(18)
    ,crss_weight_txnvol varchar2(18)
    ,svss_txnvol varchar2(18)
    ,svss_weight_txnvol varchar2(18)
    ,amls_txnvol varchar2(18)
    ,amls_weight_txnvol varchar2(18)
    ,bdms_txnvol varchar2(18)
    ,bdms_weight_txnvol varchar2(18)
    ,mpcs_txnvol varchar2(18)
    ,mpcs_weight_txnvol varchar2(18)
    ,ma_txnvol varchar2(18)
    ,ma_weight_txnvol varchar2(18)
    ,period_type number(3,0)
    ,teller_type number(3,0)
    ,auto_txnvol varchar2(18)
    ,auto_weight_txnvol varchar2(18)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics is '业务量统计表';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.etl_dt is '数据日期';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.id is '主键';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.data_date is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.data_type is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.is_shield is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.hb_num is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.hb_name is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.bb_num is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.bb_name is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.sb_num is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.sb_name is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.organ_num is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.organ_name is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.display_num is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.display_name is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.total_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.total_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.cbss_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.cbss_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.pwbs_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.pwbs_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.ifms_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.ifms_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.pbss_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.pbss_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.isbs_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.isbs_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.crss_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.crss_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.svss_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.svss_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.amls_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.amls_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.bdms_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.bdms_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.mpcs_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.mpcs_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.ma_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.ma_weight_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.period_type is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.teller_type is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.auto_txnvol is '';
comment on column ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics.auto_weight_txnvol is '';
