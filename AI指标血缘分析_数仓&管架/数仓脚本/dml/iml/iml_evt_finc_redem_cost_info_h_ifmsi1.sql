/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_finc_redem_cost_info_h_ifmsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_finc_redem_cost_info_h_ifmsi1_tm purge;
alter table ${iml_schema}.evt_finc_redem_cost_info_h add partition p_ifmsi1 values ('ifmsi1')(
        subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_finc_redem_cost_info_h modify partition p_ifmsi1
    add subpartition p_ifmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_finc_redem_cost_info_h_ifmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,cfm_flow_num -- 确认流水号
    ,init_tot_lot -- 原总份额
    ,acm_flow_contri_gold_cors_cost -- 累计流出资金对应成本
    ,acm_put_into_cost -- 累计投入成本
    ,redem_or_exp_cost -- 赎回或到期成本
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_finc_redem_cost_info_h
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ifms_tbgdhxcostinfo-
insert into ${iml_schema}.evt_finc_redem_cost_info_h_ifmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ta_cd -- TA代码
    ,cfm_dt -- 确认日期
    ,cfm_flow_num -- 确认流水号
    ,init_tot_lot -- 原总份额
    ,acm_flow_contri_gold_cors_cost -- 累计流出资金对应成本
    ,acm_put_into_cost -- 累计投入成本
    ,redem_or_exp_cost -- 赎回或到期成本
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201015'||P1.TA_CODE||P1.CFM_NO||P1.CFM_DATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TA_CODE -- TA代码
    ,${iml_schema}.DATEFORMAT_MIN(TO_CHAR(P1.CFM_DATE)) -- 确认日期
    ,P1.CFM_NO -- 确认流水号
    ,P1.OLD_TOT_VOL -- 原总份额
    ,P1.BAG_COST -- 累计流出资金对应成本
    ,P1.TOTAL_COST -- 累计投入成本
    ,P1.REST_COST -- 赎回或到期成本
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbgdhxcostinfo' -- 源表名称
    ,'ifmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
 from ${iol_schema}.ifms_tbgdhxcostinfo p1
where 1 = 1 
  and p1.cfm_date = ${batch_date}
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_finc_redem_cost_info_h truncate subpartition p_ifmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_finc_redem_cost_info_h exchange subpartition p_ifmsi1_${batch_date} with table ${iml_schema}.evt_finc_redem_cost_info_h_ifmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_finc_redem_cost_info_h to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_finc_redem_cost_info_h_ifmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_finc_redem_cost_info_h', partname => 'p_ifmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);