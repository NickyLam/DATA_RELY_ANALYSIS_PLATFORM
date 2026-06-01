/*
Purpose:    整全模型层-全量切片脚本，清空目标表当天分区数据，把源表当天数据全量数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_am_prod_coll_amt_info_h_famsf1
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
drop table ${iml_schema}.prd_am_prod_coll_amt_info_h_famsf1_tm purge;
alter table ${iml_schema}.prd_am_prod_coll_amt_info_h add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_am_prod_coll_amt_info_h modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_am_prod_coll_amt_info_h_famsf1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,calc_start_dt -- 计算开始日期
    ,begin_dt -- 起始日期
    ,coll_amt -- 募集金额
    ,td_coll_amt -- 当日募集金额
    ,prft_type_cd -- 收益类型代码
    ,creator_name -- 创建人名称
    ,create_dept -- 创建部门
    ,init_create_dt -- 最初创建日期
    ,updater_name -- 更新人名称
    ,latest_update_dt -- 最新更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_am_prod_coll_amt_info_h
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fams_ptl_raised_amt-1
insert into ${iml_schema}.prd_am_prod_coll_amt_info_h_famsf1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,finc_prod_id -- 理财产品编号
    ,calc_start_dt -- 计算开始日期
    ,begin_dt -- 起始日期
    ,coll_amt -- 募集金额
    ,td_coll_amt -- 当日募集金额
    ,prft_type_cd -- 收益类型代码
    ,creator_name -- 创建人名称
    ,create_dept -- 创建部门
    ,init_create_dt -- 最初创建日期
    ,updater_name -- 更新人名称
    ,latest_update_dt -- 最新更新日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223002'||P1.PORTFOLIO_ID -- 产品编号
    ,'9999' -- 法人编号
    ,P1.PORTFOLIO_ID -- 理财产品编号
    ,${iml_schema}.dateformat_min(P1.CDATE) -- 计算开始日期
    ,${iml_schema}.dateformat_min(P1.VDATE) -- 起始日期
    ,P1.RAISE_AMT -- 募集金额
    ,P1.TDY_RAISE_AMT -- 当日募集金额
    ,nvl(trim(P1.PROFIT_TYPE),'-') -- 收益类型代码
    ,P1.CREATE_USER -- 创建人名称
    ,P1.CREATE_DEPT -- 创建部门
    ,${iml_schema}.dateformat_min(P1.CREATE_TIME) -- 最初创建日期
    ,P1.UPDATE_USER -- 更新人名称
    ,${iml_schema}.dateformat_max2(P1.UPDATE_TIME) -- 最新更新日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_ptl_raised_amt' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_ptl_raised_amt p1
where p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.prd_am_prod_coll_amt_info_h truncate subpartition p_famsf1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.prd_am_prod_coll_amt_info_h exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.prd_am_prod_coll_amt_info_h_famsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_am_prod_coll_amt_info_h to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_am_prod_coll_amt_info_h_famsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_am_prod_coll_amt_info_h', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);