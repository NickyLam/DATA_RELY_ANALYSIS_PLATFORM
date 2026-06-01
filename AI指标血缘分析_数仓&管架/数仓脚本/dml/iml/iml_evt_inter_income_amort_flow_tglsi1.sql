/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_inter_income_amort_flow_tglsi1
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
drop table ${iml_schema}.evt_inter_income_amort_flow_tglsi1_tm purge;
alter table ${iml_schema}.evt_inter_income_amort_flow add partition p_tglsi1 values ('tglsi1')(
        subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_inter_income_amort_flow modify partition p_tglsi1
    add subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_inter_income_amort_flow_tglsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_sys_id -- 业务系统编号
    ,doc_id -- 单据编号
    ,prod_id -- 产品编号
    ,fin_org_id -- 财务机构编号
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_inter_income_amort_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- tgls_ami_mdsr_tran-1
insert into ${iml_schema}.evt_inter_income_amort_flow_tglsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,bus_sys_id -- 业务系统编号
    ,doc_id -- 单据编号
    ,prod_id -- 产品编号
    ,fin_org_id -- 财务机构编号
    ,amort_start_dt -- 摊销开始日期
    ,amort_end_dt -- 摊销结束日期
    ,amorted_tot_amt -- 待摊总金额
    ,ths_tm_amort_amt -- 本次摊销金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '302002'||P1.TRANSQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRANSQ -- 交易流水号
    ,P1.SYSTID -- 业务系统编号
    ,P1.LOANNO -- 单据编号
    ,P1.PRDUCD -- 产品编号
    ,P1.DEPTCD -- 财务机构编号
    ,${iml_schema}.dateformat_min(P1.AMOTRBDT) -- 摊销开始日期
    ,${iml_schema}.dateformat_max2(P1.AMOTRODT) -- 摊销结束日期
    ,P1.NORMPR -- 待摊总金额
    ,P1.AMOU01 -- 本次摊销金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_ami_mdsr_tran' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_ami_mdsr_tran p1
where  1 = 1 
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_inter_income_amort_flow truncate subpartition p_tglsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_inter_income_amort_flow exchange subpartition p_tglsi1_${batch_date} with table ${iml_schema}.evt_inter_income_amort_flow_tglsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_inter_income_amort_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_inter_income_amort_flow_tglsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_inter_income_amort_flow', partname => 'p_tglsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);