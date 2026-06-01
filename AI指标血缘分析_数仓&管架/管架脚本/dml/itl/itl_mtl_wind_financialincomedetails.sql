/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_mtl_wind_financialincomedetails
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
-- alter table ${itl_schema}.mtl_wind_financialincomedetails drop partition p_${retain_day};
alter table ${itl_schema}.mtl_wind_financialincomedetails drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.mtl_wind_financialincomedetails add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.mtl_wind_financialincomedetails partition for (to_date('${batch_date}','yyyymmdd')) (
     object_id -- 对象ID
    ,s_info_compcode -- 公司id
    ,statement_type -- 报表类型
    ,report_period -- 报告期
    ,ann_dt -- 公告日期
    ,crncy_code -- 货币代码
    ,subject_name -- 科目名称
    ,item_amount -- 科目金额
    ,classification_number -- 序号
    ,publish_value -- 公布值
    ,publish_counitdimension -- 公布量纲
    ,is_listing_data -- 是否上市后数据
    ,acc_sta_code -- 会计准则类型
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
     nvl(trim(object_id), ' ') as object_id -- 对象ID
    ,nvl(trim(s_info_compcode), ' ') as s_info_compcode -- 公司id
    ,nvl(trim(statement_type), ' ') as statement_type -- 报表类型
    ,nvl(trim(report_period), ' ') as report_period -- 报告期
    ,nvl(trim(ann_dt), ' ') as ann_dt -- 公告日期
    ,nvl(trim(crncy_code), ' ') as crncy_code -- 货币代码
    ,nvl(trim(subject_name), ' ') as subject_name -- 科目名称
    ,nvl(trim(item_amount), 0) as item_amount -- 科目金额
    ,nvl(trim(classification_number), 0) as classification_number -- 序号
    ,nvl(trim(publish_value), ' ') as publish_value -- 公布值
    ,nvl(trim(publish_counitdimension), ' ') as publish_counitdimension -- 公布量纲
    ,nvl(trim(is_listing_data), 0) as is_listing_data -- 是否上市后数据
    ,nvl(trim(acc_sta_code), ' ') as acc_sta_code -- 会计准则类型
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_wind_financialincomedetails
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.mtl_wind_financialincomedetails to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'mtl_wind_financialincomedetails',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);