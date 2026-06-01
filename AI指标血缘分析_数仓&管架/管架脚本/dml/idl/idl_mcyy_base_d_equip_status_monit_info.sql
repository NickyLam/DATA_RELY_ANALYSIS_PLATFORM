/*
Purpose:    指标模型层-设备状态监控信息日报表，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_base_d_equip_status_monit_info
CreateDate: 20210705
修改记录：
    郑沛隆 2021-07-05 新建脚本 
    依赖于源表：
    DEV_STATUS_TABLE => MSL_ATMS_DEV_STATUS_TABLE
    DEV_BASE_INFO => MSL_ATMS_DEV_BASE_INFO
    DEV_CATALOG_TABLE => MSL_ATMS_DEV_CATALOG_TABLE
    DEV_RESPONSOR_TABLE => MSL_ATMS_DEV_RESPONSOR_TABLE
    bank_manager_persion => MSL_ATMS_bank_manager_persion
    rpt_open_rate_dev_date  => itl_edw_atms_rpt_open_rate_dev_date
    rpt_fault_dev_date => MSL_ATMS_rpt_fault_dev_date
    shorten_table => MSL_ATMS_shorten_table
    
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.base_d_equip_status_monit_info_${batch_date}_tm purge ;
alter table ${idl_schema}.base_d_equip_status_monit_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_equip_status_monit_info_${batch_date}_tm
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_equip_status_monit_info
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table

INSERT INTO ${idl_schema}.base_d_equip_status_monit_info_${batch_date}_tm
    (equip_brand --VARCHAR2(20)  设备品牌 
    ,equip_type --VARCHAR2(20)  设备类型 
    ,equip_model --VARCHAR2(20)  设备型号 
    ,equip_id --VARCHAR2(20)  设备编号 
    ,move_status --VARCHAR2(10)  运行状态 
    ,module_status --VARCHAR2(10)  模块状态 
    ,dev_status --VARCHAR2(10)  钱箱状态 
    ,web_status --VARCHAR2(10)  网络状态 
    ,capture_bin_count --NUMBER(16,2)  吞卡数量 
    ,equip_belong_org_code --VARCHAR2(20)  设备所属机构编码 
    ,inst_addr --VARCHAR2(2000)装机地址 
    ,mang_way --VARCHAR2(10)  经营方式 
    ,in_bank_out_bank_flg --VARCHAR2(10)  在行离行标志 
    ,dev_addr --VARCHAR2(20)  ip地址   
    ,self_equip_type --VARCHAR2(10)  自助设备类型 
    ,self_equip_type_name --VARCHAR2(20)  自助设备类型名称 
    ,equip_mger_member --VARCHAR2(200) 设备管理人员 
    ,equip_oper_status --VARCHAR2(10)  设备运营状态 
    ,last_update_tm --VARCHAR2(30)  上次更新时间 
    ,equip_status --VARCHAR2(10)  设备状态 
    ,denom --NUMBER(16,2)  分母     
    ,matn_stop_duran --NUMBER(16,2)  维护停机时长 
    ,fault_stop_duran --NUMBER(16,2)  故障停机时长 
    ,offline_stop_duran --NUMBER(16,2)  离线停机时长 
    ,fault_tot_cnt --NUMBER(16,2)  故障总次数 
    ,fault_tot_tm --NUMBER(16,2)  故障总时间 
    ,qz_duran --NUMBER(16,2)  缺纸时长 
    ,qz_cnt --NUMBER(16,2)  缺纸次数 
    ,qc_duran --NUMBER(16,2)  缺钞时长 
    ,qc_cnt --NUMBER(16,2)  缺钞次数 
    ,cm_duran --NUMBER(16,2)  钞满时长 
    ,cm_cnt --NUMBER(16,2)  钞满次数 
    ,etl_dt --DATE          ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)  ETL处理时间戳
     )

    SELECT t2.dev_vendor AS equip_brand --设备品牌
          ,t2.dev_catalog AS equip_type --设备类型
          ,t2.dev_type AS equip_model --设备型号
          ,t1.dev_no AS equip_id --设备号
          ,t1.dev_run_status AS move_status --运行状态
          ,t1.dev_mod_status AS module_status --模块状态
          ,t1.dev_cashbox_status AS dev_status --钱箱状态
          ,t1.dev_net_status AS web_status --网络状态
          ,t1.idc_capture_bin_count AS capture_bin_count --吞卡数量
          ,t2.org_no AS equip_belong_org_code --所属机构
          ,t2.address AS inst_addr --装机地址
          ,t2.work_type AS mang_way --经营方式
          ,t2.away_flag AS in_bank_out_bank_flg --在行离行标志
          ,t2.ip AS dev_addr --ip地址
          ,t3.name AS self_equip_type --自助设备类型
          ,t3.enname AS self_equip_type_name --自助设备类型名称
          ,t5.name AS equip_mger_member --设备管理人员
          ,t2.operate_status AS equip_oper_status --设备运营状态
          ,t1.status_last_time AS last_update_tm --上次更新时间
          ,t2.status AS equip_status --设备状态
          ,nvl(t6.work_time - t6.stop_time,0) AS denom --分母
          ,t6.maintenance_time AS matn_stop_duran --维护停机
          ,(t6.hard_fault_time + t6.soft_fault_time + t6.other_reason_time) AS fault_stop_duran --故障停机
          ,(t6.vcomm_failure_time + t6.close_time + t6.comm_failure_time) AS offline_stop_duran --离线停机
          ,t7.fault_times AS fault_tot_cnt --故障总次数
          ,t7.fault_time AS fault_tot_tm --故障总时间
          ,t8.qztime AS qz_duran --缺纸时长
          ,t8.qztimes AS qz_cnt --缺纸次数
          ,t8.qctime AS qc_duran --缺钞时长
          ,t8.qctimes AS qc_cnt --缺钞次数
          ,t8.cmtime AS cm_duran --钞满时长
          ,t8.cmtimes AS cm_cnt --钞满次数
          ,to_date('${batch_date}'
                  ,'yyyymmdd') AS etl_dt -- ETL处理日期
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   msl_atms_dev_status_table t1
    INNER  JOIN msl_atms_dev_base_info t2
    ON     t2.no = t1.dev_no
    LEFT   JOIN msl_atms_dev_catalog_table t3
    ON     t2.dev_catalog = t3.no
    LEFT   JOIN (SELECT d.dev_no
                       ,listagg(o.name
                               ,',') AS NAME
                 FROM   msl_atms_dev_responsor_table d, msl_atms_bank_manager_persion o
                 WHERE  to_char(d.RESPONSER_NO) = o.no
                 AND    d.catalog = 1
                 AND    d.grade = 1
                 GROUP  BY d.dev_no) t5
    ON     t5.dev_no = t1.dev_no
    LEFT   JOIN itl_edw_atms_rpt_open_rate_dev_date t6
    ON     t6.dev_no = t2.no
    --AND    to_date(t6.date_time,'yyyy-mm-dd') = to_date('${batch_date}' ,'yyyy-mm-dd')
    AND    t6.date_time='${batch_date}'
    and    t6.etl_dt=to_date('${batch_date}' ,'yyyy-mm-dd')
    LEFT   JOIN msl_atms_rpt_fault_dev_date t7
    ON     t7.dev_no = t2.no
    AND    t7.date_time = '${batch_date}'
    LEFT   JOIN (SELECT SUM(CASE
                                WHEN lack_type  IN ('2','3') THEN
                                 round(to_number(to_date(UNLACK_DATE||UNLACK_TIME,'yyyy-mm-dd hh24:mi:ss') -to_date(LACK_DATE||LACK_TIME,'yyyy-mm-dd hh24:mi:ss')) * 24 * 60)
                                ELSE
                                 0
                            END) AS qztime
                       ,SUM(CASE
                                WHEN lack_type IN ('2','3') THEN
                                 1
                                ELSE
                                 0
                            END) AS qztimes
                       ,SUM(CASE
                                WHEN lack_type = '1' THEN
                                 round(to_number(to_date(UNLACK_DATE||UNLACK_TIME,'yyyy-mm-dd hh24:mi:ss') -to_date(LACK_DATE||LACK_TIME,'yyyy-mm-dd hh24:mi:ss')) * 24 * 60)
                                ELSE
                                 0
                            END) AS qctime
                       ,SUM(CASE
                                WHEN lack_type = '1' THEN
                                 1
                                ELSE
                                 0
                            END) AS qctimes
                       ,SUM(CASE
                                WHEN lack_type = '4' THEN
                                 round(to_number(to_date(UNLACK_DATE||UNLACK_TIME,'yyyy-mm-dd hh24:mi:ss') -to_date(LACK_DATE||LACK_TIME,'yyyy-mm-dd hh24:mi:ss')) * 24 * 60)
                                ELSE
                                 0
                            END) AS cmtime
                       ,SUM(CASE
                                WHEN lack_type = '4' THEN
                                 1
                                ELSE
                                 0
                            END) AS cmtimes
                       ,dev_no
                 FROM   msl_atms_shorten_table
                 WHERE  to_date(LACK_DATE,'yyyy-mm-dd') = to_date('${batch_date}','yyyy-mm-dd')
                 GROUP  BY dev_no) t8
    ON     t8.dev_no = t2.no;
COMMIT;



-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.base_d_equip_status_monit_info truncate partition p_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${idl_schema}.base_d_equip_status_monit_info exchange partition p_${batch_date} with table ${idl_schema}.base_d_equip_status_monit_info_${batch_date}_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.base_d_equip_status_monit_info to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.base_d_equip_status_monit_info_${batch_date}_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_equip_status_monit_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);