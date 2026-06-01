/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_orws_t_ghbr_bv_statistics
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_orws_t_ghbr_bv_statistics partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,id  -- 主键
    ,data_date  -- 
    ,data_type  -- 
    ,is_shield  -- 
    ,hb_num  -- 
    ,hb_name  -- 
    ,bb_num  -- 
    ,bb_name  -- 
    ,sb_num  -- 
    ,sb_name  -- 
    ,organ_num  -- 
    ,organ_name  -- 
    ,display_num  -- 
    ,display_name  -- 
    ,total_txnvol  -- 
    ,total_weight_txnvol  -- 
    ,cbss_txnvol  -- 
    ,cbss_weight_txnvol  -- 
    ,pwbs_txnvol  -- 
    ,pwbs_weight_txnvol  -- 
    ,ifms_txnvol  -- 
    ,ifms_weight_txnvol  -- 
    ,pbss_txnvol  -- 
    ,pbss_weight_txnvol  -- 
    ,isbs_txnvol  -- 
    ,isbs_weight_txnvol  -- 
    ,crss_txnvol  -- 
    ,crss_weight_txnvol  -- 
    ,svss_txnvol  -- 
    ,svss_weight_txnvol  -- 
    ,amls_txnvol  -- 
    ,amls_weight_txnvol  -- 
    ,bdms_txnvol  -- 
    ,bdms_weight_txnvol  -- 
    ,mpcs_txnvol  -- 
    ,mpcs_weight_txnvol  -- 
    ,ma_txnvol  -- 
    ,ma_weight_txnvol  -- 
    ,period_type  -- 
    ,teller_type  -- 
    ,auto_txnvol  -- 
    ,auto_weight_txnvol  -- 
    ,etl_timestamp  -- ETL处理时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,t1.id  -- 主键
    ,t1.data_date  -- 
    ,replace(replace(t1.data_type,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.is_shield,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.hb_num,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.hb_name,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bb_num,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.bb_name,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sb_num,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.sb_name,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.organ_num,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.organ_name,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.display_num,chr(13),''),chr(10),'')  -- 
    ,replace(replace(t1.display_name,chr(13),''),chr(10),'')  -- 
    ,t1.total_txnvol  -- 
    ,t1.total_weight_txnvol  -- 
    ,t1.cbss_txnvol  -- 
    ,t1.cbss_weight_txnvol  -- 
    ,t1.pwbs_txnvol  -- 
    ,t1.pwbs_weight_txnvol  -- 
    ,t1.ifms_txnvol  -- 
    ,t1.ifms_weight_txnvol  -- 
    ,t1.pbss_txnvol  -- 
    ,t1.pbss_weight_txnvol  -- 
    ,t1.isbs_txnvol  -- 
    ,t1.isbs_weight_txnvol  -- 
    ,t1.crss_txnvol  -- 
    ,t1.crss_weight_txnvol  -- 
    ,t1.svss_txnvol  -- 
    ,t1.svss_weight_txnvol  -- 
    ,t1.amls_txnvol  -- 
    ,t1.amls_weight_txnvol  -- 
    ,t1.bdms_txnvol  -- 
    ,t1.bdms_weight_txnvol  -- 
    ,t1.mpcs_txnvol  -- 
    ,t1.mpcs_weight_txnvol  -- 
    ,t1.ma_txnvol  -- 
    ,t1.ma_weight_txnvol  -- 
    ,t1.period_type  -- 
    ,t1.teller_type  -- 
    ,t1.auto_txnvol  -- 
    ,t1.auto_weight_txnvol  -- 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- ETL处理时间戳
from ${msl_schema}.msl_edw_orws_t_ghbr_bv_statistics t1    --业务量统计表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_orws_t_ghbr_bv_statistics',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);