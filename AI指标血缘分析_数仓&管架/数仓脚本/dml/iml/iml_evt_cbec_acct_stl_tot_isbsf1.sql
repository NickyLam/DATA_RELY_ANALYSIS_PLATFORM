/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_cbec_acct_stl_tot_isbsf1
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
drop table ${iml_schema}.evt_cbec_acct_stl_tot_isbsf1_tm purge;
alter table ${iml_schema}.evt_cbec_acct_stl_tot add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_cbec_acct_stl_tot modify partition p_isbsf1
    add subpartition p_isbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cbec_acct_stl_tot_isbsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,tot_mon -- 汇总月份
    ,acm_abmt -- 累计汇入
    ,acm_remit_out -- 累计汇出
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cbec_acct_stl_tot
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- isbs_crball
insert into ${iml_schema}.evt_cbec_acct_stl_tot_isbsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,tot_mon -- 汇总月份
    ,acm_abmt -- 累计汇入
    ,acm_remit_out -- 累计汇出
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401049'||P1.ACT||P1.MON -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ACT -- 账户编号
    ,P1.EXTKEY -- 客户编号
    ,P1.MON -- 汇总月份
    ,P1.IRAMT -- 累计汇入
    ,P1.ORAMT -- 累计汇出
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_crball' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_crball p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_cbec_acct_stl_tot truncate partition p_isbsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_cbec_acct_stl_tot exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.evt_cbec_acct_stl_tot_isbsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_cbec_acct_stl_tot to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_cbec_acct_stl_tot_isbsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_cbec_acct_stl_tot', partname => 'p_isbsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);