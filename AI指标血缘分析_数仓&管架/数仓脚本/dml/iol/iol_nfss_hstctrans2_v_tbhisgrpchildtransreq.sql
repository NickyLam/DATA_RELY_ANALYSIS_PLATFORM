/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_hstctrans2_v_tbhisgrpchildtransreq
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
drop table ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq_ex purge;
alter table ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq;

-- 2.3 insert data to ex table
create table ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq_ex nologging
compress
as
select * from ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq where 0=1;

insert /*+ append */ into ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq_ex(
    serial_no -- 
    ,ex_serial -- 
    ,model -- 
    ,trans_code -- 
    ,group_code -- 
    ,prd_type -- 
    ,trans_date -- 
    ,trans_time -- 
    ,child_serial_no -- 
    ,sub_trans_code -- 
    ,prd_code -- 
    ,amt -- 
    ,vol -- 
    ,cfm_vol -- 
    ,cfm_amt -- 
    ,fee -- 
    ,err_code -- 
    ,err_msg -- 
    ,child_status -- 
    ,summary -- 
    ,to_host_serial -- 
    ,check_date -- 
    ,ori_host_chk_date -- 
    ,host_trans_code -- 
    ,host_date -- 
    ,host_serial -- 
    ,liqu_status -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,reserve3 -- 
    ,reserve4 -- 
    ,reserve5 -- 
    ,amt1 -- 
    ,amt2 -- 
    ,amt3 -- 
    ,amt4 -- 
    ,amt5 -- 
    ,amt6 -- 
    ,cancel_date -- 
    ,cancel_time -- 
    ,cfm_fee -- 
    ,cfm_nav -- 
    ,double1 -- 
    ,double2 -- 
    ,double3 -- 
    ,double4 -- 
    ,double5 -- 
    ,asso_serial -- 
    ,asso_serial2 -- 
    ,asso_serial3 -- 
    ,agio -- 
    ,square_date -- 
    ,in_client_no -- 
    ,phy_date -- 
    ,modify_timestamp -- 
    ,cancel_amt -- 
    ,cfm_date -- 
    ,client_manager -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    serial_no -- 
    ,ex_serial -- 
    ,model -- 
    ,trans_code -- 
    ,group_code -- 
    ,prd_type -- 
    ,trans_date -- 
    ,trans_time -- 
    ,child_serial_no -- 
    ,sub_trans_code -- 
    ,prd_code -- 
    ,amt -- 
    ,vol -- 
    ,cfm_vol -- 
    ,cfm_amt -- 
    ,fee -- 
    ,err_code -- 
    ,err_msg -- 
    ,child_status -- 
    ,summary -- 
    ,to_host_serial -- 
    ,check_date -- 
    ,ori_host_chk_date -- 
    ,host_trans_code -- 
    ,host_date -- 
    ,host_serial -- 
    ,liqu_status -- 
    ,reserve1 -- 
    ,reserve2 -- 
    ,reserve3 -- 
    ,reserve4 -- 
    ,reserve5 -- 
    ,amt1 -- 
    ,amt2 -- 
    ,amt3 -- 
    ,amt4 -- 
    ,amt5 -- 
    ,amt6 -- 
    ,cancel_date -- 
    ,cancel_time -- 
    ,cfm_fee -- 
    ,cfm_nav -- 
    ,double1 -- 
    ,double2 -- 
    ,double3 -- 
    ,double4 -- 
    ,double5 -- 
    ,asso_serial -- 
    ,asso_serial2 -- 
    ,asso_serial3 -- 
    ,agio -- 
    ,square_date -- 
    ,in_client_no -- 
    ,phy_date -- 
    ,modify_timestamp -- 
    ,cancel_amt -- 
    ,cfm_date -- 
    ,client_manager -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq exchange partition p_${batch_date} with table ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nfss_hstctrans2_v_tbhisgrpchildtransreq_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_hstctrans2_v_tbhisgrpchildtransreq',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);