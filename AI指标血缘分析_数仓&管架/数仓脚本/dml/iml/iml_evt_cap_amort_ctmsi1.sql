/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_cap_amort_ctmsi1
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
drop table ${iml_schema}.evt_cap_amort_ctmsi1_tm purge;
alter table ${iml_schema}.evt_cap_amort add partition p_ctmsi1 values ('ctmsi1')(
        subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_cap_amort modify partition p_ctmsi1
    add subpartition p_ctmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cap_amort_ctmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,amort_dt -- 摊销日期
    ,asset_bal_id -- 资产余额编号
    ,post_qtty -- 持仓数量
    ,net_price_cost -- 净价成本
    ,amort_amt -- 摊销金额
    ,amort_post_net_price_cost -- 摊销后净价成本
    ,actl_int_rat -- 实际利率
    ,acct_b_id -- 账簿编号
    ,asset_type_name -- 资产类型名称
    ,main_asset_id -- 主资产编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cap_amort
where 0=1;

-- 3.1 truncate target table batch_date partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_cap_amort truncate subpartition p_ctmsi1_${batch_date} reuse storage;

-- 3.2 insert data to tm table
-- ctms_tbs_v_amortizationdeals-
insert into ${iml_schema}.evt_cap_amort_ctmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,bus_id -- 业务编号
    ,bus_table_name -- 业务表名称
    ,dept_id -- 部门编号
    ,amort_dt -- 摊销日期
    ,asset_bal_id -- 资产余额编号
    ,post_qtty -- 持仓数量
    ,net_price_cost -- 净价成本
    ,amort_amt -- 摊销金额
    ,amort_post_net_price_cost -- 摊销后净价成本
    ,actl_int_rat -- 实际利率
    ,acct_b_id -- 账簿编号
    ,asset_type_name -- 资产类型名称
    ,main_asset_id -- 主资产编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104001'||TO_CHAR(P1.CALCDATE)||TO_CHAR(P1.DEAL_ID) -- 事件编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DEAL_ID) -- 业务编号
    ,P1.DEAL_NAME -- 业务表名称
    ,TO_CHAR(P1.ASPCLIENT_ID) -- 部门编号
    ,${iml_schema}.DATEFORMAT_MAX(TO_CHAR(P1.CALCDATE)) -- 摊销日期
    ,TO_CHAR(P1.BALANCE_ID) -- 资产余额编号
    ,P1.HOLDAMOUNT -- 持仓数量
    ,TRUNC(P1.CLEANPRICECOST,8) -- 净价成本
    ,TRUNC(P1.AMORTIZEAMOUNT,8) -- 摊销金额
    ,TRUNC(P1.CLEANPRICECOST2,8) -- 摊销后净价成本
    ,TRUNC(P1.ERATE,8) -- 实际利率
    ,TO_CHAR(P1.KEEPFOLDER_ID) -- 账簿编号
    ,P1.ASSETTYPE -- 资产类型名称
    ,P1.MAJORASSETCODE -- 主资产编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_v_amortizationdeals' -- 源表名称
    ,'ctmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_v_amortizationdeals p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TO_CHAR(P1.CALCDATE)='${batch_date}'
;
commit;



-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_cap_amort exchange subpartition p_ctmsi1_${batch_date} with table ${iml_schema}.evt_cap_amort_ctmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_cap_amort to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_cap_amort_ctmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_cap_amort', partname => 'p_ctmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);