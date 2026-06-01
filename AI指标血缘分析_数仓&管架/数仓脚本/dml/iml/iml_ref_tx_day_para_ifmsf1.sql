/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_tx_day_para_ifmsf1
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
drop table ${iml_schema}.ref_tx_day_para_ifmsf1_tm purge;
alter table ${iml_schema}.ref_tx_day_para add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_tx_day_para modify partition p_ifmsf1
    add subpartition p_ifmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tx_day_para_ifmsf1_tm
compress ${option_switch} for query high
as
select
     tx_dt          --交易日期    
    ,rela_id        --关联编号    
    ,dt_type_cd     --日期类别代码      
    ,etl_dt         -- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tx_day_para
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
insert into ${iml_schema}.ref_tx_day_para_ifmsf1_tm(
     tx_dt          --交易日期    
    ,rela_id        --关联编号    
    ,dt_type_cd     --日期类别代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
     ${iml_schema}.dateformat_min(p1.TRANS_DATE)      --交易日期    
    ,p1.ASSO_CODE       --关联编号    
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DATE_TYPE END -- 日期类别代码    
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbtransday' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbtransday p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DATE_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'IFMS'
        AND R1.SRC_TAB_EN_NAME= 'IFMS_TBTRANSDAY'
        AND R1.SRC_FIELD_EN_NAME= 'DATE_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'REF_TX_DAY_PARA'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'DT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- 3.2 truncate target table
alter table ${iml_schema}.ref_tx_day_para truncate partition p_ifmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.ref_tx_day_para exchange subpartition p_ifmsf1_${batch_date} with table ${iml_schema}.ref_tx_day_para_ifmsf1_tm;

-- 4.2 drop tm table
drop table ${iml_schema}.ref_tx_day_para_ifmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_tx_day_para', partname => 'p_ifmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
