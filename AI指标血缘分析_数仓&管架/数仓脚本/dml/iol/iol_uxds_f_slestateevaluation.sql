/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_f_slestateevaluation
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
drop table ${iol_schema}.uxds_f_slestateevaluation_ex purge;
alter table ${iol_schema}.uxds_f_slestateevaluation add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.uxds_f_slestateevaluation;

-- 2.3 insert data to ex table
create table ${iol_schema}.uxds_f_slestateevaluation_ex nologging
compress
as
select * from ${iol_schema}.uxds_f_slestateevaluation where 0=1;

insert /*+ append */ into ${iol_schema}.uxds_f_slestateevaluation_ex(
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,caseid -- 案例编号
    ,divisionid -- 行政区划编码
    ,address -- 物业地址
    ,unitprice -- 评估单价
    ,totalprice -- 评估总价
    ,priceringrate -- 环比
    ,priceyearrate -- 同比
    ,querydate -- 询价时间
    ,avgunitprice -- 案例均价
    ,avgprice -- 楼盘均价
    ,maxprice -- 最大值
    ,minprice -- 最小值
    ,mangerprice -- 物业费
    ,liveness -- 活跃度
    ,totalcellnumber -- 总套数
    ,querycount -- 近3个月被查询次数（不含机构
    ,returncode -- 估价状态
    ,remark -- 返回信息
    ,enddate -- 建成年代
    ,constructionname -- 楼盘名称
    ,constructionalias -- 楼盘别名
    ,buildingname -- 楼栋名称
    ,housename -- 房号名称
    ,propertytype -- 房屋用途
    ,quotationcount -- 案例数量
    ,genmonth -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    gendate -- 生成时间
    ,serialnumber -- 业务系统流水号
    ,sequenceid -- 系统流水号
    ,caseid -- 案例编号
    ,divisionid -- 行政区划编码
    ,address -- 物业地址
    ,unitprice -- 评估单价
    ,totalprice -- 评估总价
    ,priceringrate -- 环比
    ,priceyearrate -- 同比
    ,querydate -- 询价时间
    ,avgunitprice -- 案例均价
    ,avgprice -- 楼盘均价
    ,maxprice -- 最大值
    ,minprice -- 最小值
    ,mangerprice -- 物业费
    ,liveness -- 活跃度
    ,totalcellnumber -- 总套数
    ,querycount -- 近3个月被查询次数（不含机构
    ,returncode -- 估价状态
    ,remark -- 返回信息
    ,enddate -- 建成年代
    ,constructionname -- 楼盘名称
    ,constructionalias -- 楼盘别名
    ,buildingname -- 楼栋名称
    ,housename -- 房号名称
    ,propertytype -- 房屋用途
    ,quotationcount -- 案例数量
    ,genmonth -- 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.uxds_f_slestateevaluation
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.uxds_f_slestateevaluation exchange partition p_${batch_date} with table ${iol_schema}.uxds_f_slestateevaluation_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_f_slestateevaluation to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.uxds_f_slestateevaluation_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_f_slestateevaluation',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);