/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_heps_hep_house
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
drop table ${iol_schema}.heps_hep_house_ex purge;
alter table ${iol_schema}.heps_hep_house add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.heps_hep_house truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.heps_hep_house_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.heps_hep_house where 0=1;

insert /*+ append */ into ${iol_schema}.heps_hep_house_ex(
    house_id -- 房产id
    ,flow_id -- 业务流水号
    ,house_type -- 房产类型(0:普通住宅 1:商业住宅)
    ,is_basement -- 地下室(0:无  1:有)
    ,plot_name -- 小区名称
    ,online_valuation -- 线上评估价值
    ,house_area -- 房屋面积
    ,house_location -- 房产证位置
    ,completion_year -- 建成年份
    ,total_tier -- 总楼层
    ,spare_house -- 备用房数量
    ,property_start_time -- 土地使用权起始日期
    ,property_end_time -- 土地使用权到期日期
    ,is_vacancy -- 是否空置(0:否  1:是)
    ,start_obligee -- 上手权利人
    ,property_people_count -- 产权人人数
    ,property_common_relation -- 产权共有人关系
    ,property_prove -- 权属证明
    ,prove_no -- 证明编号
    ,durable_years -- 使用年限
    ,house_usage -- 房屋用途
    ,assess_way -- 评估方式
    ,official_valuation -- 正式评估价值
    ,status -- 状态
    ,house_use -- 房屋用途
    ,local_area -- 所在区域
    ,assessment_com -- 评估公司名称
    ,city_code -- 城市编码
    ,sub_divide_code -- 区名
    ,property_common_relation_des -- 产权共有人关系备注
    ,property_get_time -- 产权证书取得时间
    ,land_use -- 土地用途
    ,oloan_is_circle -- 原贷款是否循环
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    house_id -- 房产id
    ,flow_id -- 业务流水号
    ,house_type -- 房产类型(0:普通住宅 1:商业住宅)
    ,is_basement -- 地下室(0:无  1:有)
    ,plot_name -- 小区名称
    ,online_valuation -- 线上评估价值
    ,house_area -- 房屋面积
    ,house_location -- 房产证位置
    ,completion_year -- 建成年份
    ,total_tier -- 总楼层
    ,spare_house -- 备用房数量
    ,property_start_time -- 土地使用权起始日期
    ,property_end_time -- 土地使用权到期日期
    ,is_vacancy -- 是否空置(0:否  1:是)
    ,start_obligee -- 上手权利人
    ,property_people_count -- 产权人人数
    ,property_common_relation -- 产权共有人关系
    ,property_prove -- 权属证明
    ,prove_no -- 证明编号
    ,durable_years -- 使用年限
    ,house_usage -- 房屋用途
    ,assess_way -- 评估方式
    ,official_valuation -- 正式评估价值
    ,status -- 状态
    ,house_use -- 房屋用途
    ,local_area -- 所在区域
    ,assessment_com -- 评估公司名称
    ,city_code -- 城市编码
    ,sub_divide_code -- 区名
    ,property_common_relation_des -- 产权共有人关系备注
    ,property_get_time -- 产权证书取得时间
    ,land_use -- 土地用途
    ,oloan_is_circle -- 原贷款是否循环
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.heps_hep_house
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.heps_hep_house exchange partition p_${batch_date} with table ${iol_schema}.heps_hep_house_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.heps_hep_house to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.heps_hep_house_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'heps_hep_house',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);