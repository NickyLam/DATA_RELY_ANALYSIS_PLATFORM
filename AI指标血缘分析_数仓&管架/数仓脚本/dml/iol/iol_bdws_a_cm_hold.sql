/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdws_a_cm_hold
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdws_a_cm_hold_ex purge;
alter table ${iol_schema}.bdws_a_cm_hold add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.bdws_a_cm_hold truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.bdws_a_cm_hold_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdws_a_cm_hold where 0=1;

insert /*+ append */ into ${iol_schema}.bdws_a_cm_hold_ex(
    hold_id -- 
    ,cust_id -- 
    ,zg_hold -- 
    ,hq_ck_hold -- 
    ,dq_ck_hold -- 
    ,big_ck_hold -- 
    ,dk_hold -- 
    ,jj_hold -- 
    ,lc_hold -- 
    ,t0_lc_hold -- 
    ,bx_hold -- 
    ,gjs_hold -- 
    ,acct_hold -- 
    ,dsf_hold -- 
    ,et_date -- 
    ,dq_ck_once_hold -- 
    ,big_ck_once_hold -- 
    ,dk_once_hold -- 
    ,jj_once_hold -- 
    ,dsf_once_hold -- 
    ,lc_once_hold -- 
    ,zg_once_hold -- 
    ,t0_lc_once_hold -- 
    ,dq_ck_history_hold -- 
    ,big_ck_history_hold -- 
    ,dk_history_hold -- 
    ,jj_history_hold -- 
    ,dsf_history_hold -- 
    ,lc_history_hold -- 
    ,t0_lc_history_hold -- 
    ,zg_history_hold -- 
    ,acct_history_hold -- 
    ,if_xxc_dept_hold -- 
    ,if_tz_dept_hold -- 
    ,if_aj_lodn_hold -- 
    ,if_xf_lodn_hold -- 
    ,if_jy_lodn_hold -- 
    ,if_qt_lodn_hold -- 
    ,if_bb_finc_hold -- 
    ,if_nbb_gd_finc_hold -- 
    ,if_nbb_fx_finc_hold -- 
    ,if_nbb_qt_finc_hold -- 
    ,if_hb_fund_hold -- 
    ,if_zq_fund_hold -- 
    ,if_he_fund_hold -- 
    ,if_gp_fund_hold -- 
    ,if_qdii_fund_hold -- 
    ,if_zsh_fund_hold -- 
    ,if_shp_fund_hold -- 
    ,ft_hold -- 
    ,ft_history_hold -- 
    ,ft_once_hold -- 
    ,if_axc_dept_hold -- 
    ,comb_prod_once_hold -- 
    ,comb_prod_history_hold -- 
    ,if_comb_prod_hold -- 
    ,if_jsy_dept_hold -- 
    ,if_dollerxc_dept_hold -- 
    ,if_dollerxh_dept_hold -- 
    ,load_date -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    hold_id -- 
    ,cust_id -- 
    ,zg_hold -- 
    ,hq_ck_hold -- 
    ,dq_ck_hold -- 
    ,big_ck_hold -- 
    ,dk_hold -- 
    ,jj_hold -- 
    ,lc_hold -- 
    ,t0_lc_hold -- 
    ,bx_hold -- 
    ,gjs_hold -- 
    ,acct_hold -- 
    ,dsf_hold -- 
    ,et_date -- 
    ,dq_ck_once_hold -- 
    ,big_ck_once_hold -- 
    ,dk_once_hold -- 
    ,jj_once_hold -- 
    ,dsf_once_hold -- 
    ,lc_once_hold -- 
    ,zg_once_hold -- 
    ,t0_lc_once_hold -- 
    ,dq_ck_history_hold -- 
    ,big_ck_history_hold -- 
    ,dk_history_hold -- 
    ,jj_history_hold -- 
    ,dsf_history_hold -- 
    ,lc_history_hold -- 
    ,t0_lc_history_hold -- 
    ,zg_history_hold -- 
    ,acct_history_hold -- 
    ,if_xxc_dept_hold -- 
    ,if_tz_dept_hold -- 
    ,if_aj_lodn_hold -- 
    ,if_xf_lodn_hold -- 
    ,if_jy_lodn_hold -- 
    ,if_qt_lodn_hold -- 
    ,if_bb_finc_hold -- 
    ,if_nbb_gd_finc_hold -- 
    ,if_nbb_fx_finc_hold -- 
    ,if_nbb_qt_finc_hold -- 
    ,if_hb_fund_hold -- 
    ,if_zq_fund_hold -- 
    ,if_he_fund_hold -- 
    ,if_gp_fund_hold -- 
    ,if_qdii_fund_hold -- 
    ,if_zsh_fund_hold -- 
    ,if_shp_fund_hold -- 
    ,ft_hold -- 
    ,ft_history_hold -- 
    ,ft_once_hold -- 
    ,if_axc_dept_hold -- 
    ,comb_prod_once_hold -- 
    ,comb_prod_history_hold -- 
    ,if_comb_prod_hold -- 
    ,if_jsy_dept_hold -- 
    ,if_dollerxc_dept_hold -- 
    ,if_dollerxh_dept_hold -- 
    ,load_date -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.bdws_a_cm_hold
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.bdws_a_cm_hold exchange partition p_${batch_date} with table ${iol_schema}.bdws_a_cm_hold_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdws_a_cm_hold to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.bdws_a_cm_hold_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdws_a_cm_hold',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);