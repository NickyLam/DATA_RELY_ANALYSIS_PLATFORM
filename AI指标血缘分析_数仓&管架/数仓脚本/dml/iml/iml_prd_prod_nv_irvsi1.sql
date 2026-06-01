/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_prd_prod_nv_irvsi1
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
drop table ${iml_schema}.prd_prod_nv_irvsi1_tm purge;
alter table ${iml_schema}.prd_prod_nv add partition p_irvsi1 values ('irvsi1')(
        subpartition p_irvsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.prd_prod_nv modify partition p_irvsi1
    add subpartition p_irvsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_prod_nv_irvsi1_tm
compress ${option_switch} for query high
as
select
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,nv_id -- 净值编号
    ,nv_dt -- 净值日期
    ,corp_nv -- 单位净值
    ,acm_nv -- 累计净值
    ,aual_yld -- 年化收益率
    ,sevn_aual_yld -- 七日年化收益率
    ,ten_thous_prft -- 万份收益
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.prd_prod_nv
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- irvs_ft_networth-
insert into ${iml_schema}.prd_prod_nv_irvsi1_tm(
    prod_id -- 产品编号
    ,lp_id -- 法人编号
    ,nv_id -- 净值编号
    ,nv_dt -- 净值日期
    ,corp_nv -- 单位净值
    ,acm_nv -- 累计净值
    ,aual_yld -- 年化收益率
    ,sevn_aual_yld -- 七日年化收益率
    ,ten_thous_prft -- 万份收益
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '223010'||P2.PRODUCT_CODE -- 产品编号
    ,'9999' -- 法人编号
    ,P1.networth_id -- 净值编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.networth_time) -- 净值日期
    ,P1.networth_unit -- 单位净值
    ,'0' -- 累计净值
    ,'0' -- 年化收益率
    ,'0' -- 七日年化收益率
    ,'0' -- 万份收益
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'irvs_ft_networth' -- 源表名称
    ,'irvsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.irvs_ft_networth p1
left join ${iol_schema}.IRVS_FT_PRODUCT p2 on P1.product_id=P2.product_id
     AND P2.START_DT<=to_date('${batch_date}','YYYYMMDD')
     AND P2.END_DT > to_date('${batch_date}','YYYYMMDD')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND TRUNC(P1.CREATE_TIME,'DD')=to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.prd_prod_nv truncate subpartition p_irvsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.prd_prod_nv exchange subpartition p_irvsi1_${batch_date} with table ${iml_schema}.prd_prod_nv_irvsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.prd_prod_nv to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.prd_prod_nv_irvsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'prd_prod_nv', partname => 'p_irvsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);