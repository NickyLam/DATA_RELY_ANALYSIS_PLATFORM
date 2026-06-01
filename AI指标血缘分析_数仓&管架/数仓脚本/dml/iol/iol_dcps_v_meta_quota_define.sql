/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_dcps_v_meta_quota_define
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.dcps_v_meta_quota_define_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.dcps_v_meta_quota_define;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.dcps_v_meta_quota_define_op purge;
drop table ${iol_schema}.dcps_v_meta_quota_define_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.dcps_v_meta_quota_define_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.dcps_v_meta_quota_define where 0=1;

create table ${iol_schema}.dcps_v_meta_quota_define_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.dcps_v_meta_quota_define where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.dcps_v_meta_quota_define_cl(
            quota_id -- 指标内部id
            ,quota_type -- 指标大类
            ,quota_class1 -- 指标一级分类
            ,quota_class2 -- 指标二级分类
            ,quota_class3 -- 指标三级分类
            ,quota_code -- 指标编号
            ,quota_name -- 指标名称
            ,busmean -- 指标描述
            ,quotameasure -- 指标度量
            ,derivemeasure -- 指标衍生度量
            ,dataattr -- 数值属性
            ,dimension_num -- 指标维度
            ,common_units_of_measurement -- 度量单位
            ,countcycle -- 统计周期
            ,dataformat -- 数据格式
            ,protype -- 产生方式
            ,busncore -- 业务口径
            ,techcore -- 技术口径
            ,range -- 发布范围
            ,mainsys -- 主系统
            ,warn_value -- 预警值
            ,alarm_value -- 报警值
            ,owner -- 所有者
            ,userfillin -- 填写人
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,defenduser -- 维护人
            ,defenddate -- 维护日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.dcps_v_meta_quota_define_op(
            quota_id -- 指标内部id
            ,quota_type -- 指标大类
            ,quota_class1 -- 指标一级分类
            ,quota_class2 -- 指标二级分类
            ,quota_class3 -- 指标三级分类
            ,quota_code -- 指标编号
            ,quota_name -- 指标名称
            ,busmean -- 指标描述
            ,quotameasure -- 指标度量
            ,derivemeasure -- 指标衍生度量
            ,dataattr -- 数值属性
            ,dimension_num -- 指标维度
            ,common_units_of_measurement -- 度量单位
            ,countcycle -- 统计周期
            ,dataformat -- 数据格式
            ,protype -- 产生方式
            ,busncore -- 业务口径
            ,techcore -- 技术口径
            ,range -- 发布范围
            ,mainsys -- 主系统
            ,warn_value -- 预警值
            ,alarm_value -- 报警值
            ,owner -- 所有者
            ,userfillin -- 填写人
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,defenduser -- 维护人
            ,defenddate -- 维护日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.quota_id, o.quota_id) as quota_id -- 指标内部id
    ,nvl(n.quota_type, o.quota_type) as quota_type -- 指标大类
    ,nvl(n.quota_class1, o.quota_class1) as quota_class1 -- 指标一级分类
    ,nvl(n.quota_class2, o.quota_class2) as quota_class2 -- 指标二级分类
    ,nvl(n.quota_class3, o.quota_class3) as quota_class3 -- 指标三级分类
    ,nvl(n.quota_code, o.quota_code) as quota_code -- 指标编号
    ,nvl(n.quota_name, o.quota_name) as quota_name -- 指标名称
    ,nvl(n.busmean, o.busmean) as busmean -- 指标描述
    ,nvl(n.quotameasure, o.quotameasure) as quotameasure -- 指标度量
    ,nvl(n.derivemeasure, o.derivemeasure) as derivemeasure -- 指标衍生度量
    ,nvl(n.dataattr, o.dataattr) as dataattr -- 数值属性
    ,nvl(n.dimension_num, o.dimension_num) as dimension_num -- 指标维度
    ,nvl(n.common_units_of_measurement, o.common_units_of_measurement) as common_units_of_measurement -- 度量单位
    ,nvl(n.countcycle, o.countcycle) as countcycle -- 统计周期
    ,nvl(n.dataformat, o.dataformat) as dataformat -- 数据格式
    ,nvl(n.protype, o.protype) as protype -- 产生方式
    ,nvl(n.busncore, o.busncore) as busncore -- 业务口径
    ,nvl(n.techcore, o.techcore) as techcore -- 技术口径
    ,nvl(n.range, o.range) as range -- 发布范围
    ,nvl(n.mainsys, o.mainsys) as mainsys -- 主系统
    ,nvl(n.warn_value, o.warn_value) as warn_value -- 预警值
    ,nvl(n.alarm_value, o.alarm_value) as alarm_value -- 报警值
    ,nvl(n.owner, o.owner) as owner -- 所有者
    ,nvl(n.userfillin, o.userfillin) as userfillin -- 填写人
    ,nvl(n.effectivedate, o.effectivedate) as effectivedate -- 生效日期
    ,nvl(n.expirydate, o.expirydate) as expirydate -- 失效日期
    ,nvl(n.defenduser, o.defenduser) as defenduser -- 维护人
    ,nvl(n.defenddate, o.defenddate) as defenddate -- 维护日期
    ,case when
            n.quota_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.quota_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.quota_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.dcps_v_meta_quota_define_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.dcps_v_meta_quota_define where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.quota_id = n.quota_id
where (
        o.quota_id is null
    )
    or (
        n.quota_id is null
    )
    or (
        o.quota_type <> n.quota_type
        or o.quota_class1 <> n.quota_class1
        or o.quota_class2 <> n.quota_class2
        or o.quota_class3 <> n.quota_class3
        or o.quota_code <> n.quota_code
        or o.quota_name <> n.quota_name
        or o.busmean <> n.busmean
        or o.quotameasure <> n.quotameasure
        or o.derivemeasure <> n.derivemeasure
        or o.dataattr <> n.dataattr
        or o.dimension_num <> n.dimension_num
        or o.common_units_of_measurement <> n.common_units_of_measurement
        or o.countcycle <> n.countcycle
        or o.dataformat <> n.dataformat
        or o.protype <> n.protype
        or o.busncore <> n.busncore
        or o.techcore <> n.techcore
        or o.range <> n.range
        or o.mainsys <> n.mainsys
        or o.warn_value <> n.warn_value
        or o.alarm_value <> n.alarm_value
        or o.owner <> n.owner
        or o.userfillin <> n.userfillin
        or o.effectivedate <> n.effectivedate
        or o.expirydate <> n.expirydate
        or o.defenduser <> n.defenduser
        or o.defenddate <> n.defenddate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.dcps_v_meta_quota_define_cl(
            quota_id -- 指标内部id
            ,quota_type -- 指标大类
            ,quota_class1 -- 指标一级分类
            ,quota_class2 -- 指标二级分类
            ,quota_class3 -- 指标三级分类
            ,quota_code -- 指标编号
            ,quota_name -- 指标名称
            ,busmean -- 指标描述
            ,quotameasure -- 指标度量
            ,derivemeasure -- 指标衍生度量
            ,dataattr -- 数值属性
            ,dimension_num -- 指标维度
            ,common_units_of_measurement -- 度量单位
            ,countcycle -- 统计周期
            ,dataformat -- 数据格式
            ,protype -- 产生方式
            ,busncore -- 业务口径
            ,techcore -- 技术口径
            ,range -- 发布范围
            ,mainsys -- 主系统
            ,warn_value -- 预警值
            ,alarm_value -- 报警值
            ,owner -- 所有者
            ,userfillin -- 填写人
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,defenduser -- 维护人
            ,defenddate -- 维护日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.dcps_v_meta_quota_define_op(
            quota_id -- 指标内部id
            ,quota_type -- 指标大类
            ,quota_class1 -- 指标一级分类
            ,quota_class2 -- 指标二级分类
            ,quota_class3 -- 指标三级分类
            ,quota_code -- 指标编号
            ,quota_name -- 指标名称
            ,busmean -- 指标描述
            ,quotameasure -- 指标度量
            ,derivemeasure -- 指标衍生度量
            ,dataattr -- 数值属性
            ,dimension_num -- 指标维度
            ,common_units_of_measurement -- 度量单位
            ,countcycle -- 统计周期
            ,dataformat -- 数据格式
            ,protype -- 产生方式
            ,busncore -- 业务口径
            ,techcore -- 技术口径
            ,range -- 发布范围
            ,mainsys -- 主系统
            ,warn_value -- 预警值
            ,alarm_value -- 报警值
            ,owner -- 所有者
            ,userfillin -- 填写人
            ,effectivedate -- 生效日期
            ,expirydate -- 失效日期
            ,defenduser -- 维护人
            ,defenddate -- 维护日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.quota_id -- 指标内部id
    ,o.quota_type -- 指标大类
    ,o.quota_class1 -- 指标一级分类
    ,o.quota_class2 -- 指标二级分类
    ,o.quota_class3 -- 指标三级分类
    ,o.quota_code -- 指标编号
    ,o.quota_name -- 指标名称
    ,o.busmean -- 指标描述
    ,o.quotameasure -- 指标度量
    ,o.derivemeasure -- 指标衍生度量
    ,o.dataattr -- 数值属性
    ,o.dimension_num -- 指标维度
    ,o.common_units_of_measurement -- 度量单位
    ,o.countcycle -- 统计周期
    ,o.dataformat -- 数据格式
    ,o.protype -- 产生方式
    ,o.busncore -- 业务口径
    ,o.techcore -- 技术口径
    ,o.range -- 发布范围
    ,o.mainsys -- 主系统
    ,o.warn_value -- 预警值
    ,o.alarm_value -- 报警值
    ,o.owner -- 所有者
    ,o.userfillin -- 填写人
    ,o.effectivedate -- 生效日期
    ,o.expirydate -- 失效日期
    ,o.defenduser -- 维护人
    ,o.defenddate -- 维护日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.dcps_v_meta_quota_define_bk o
    left join ${iol_schema}.dcps_v_meta_quota_define_op n
        on
            o.quota_id = n.quota_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.dcps_v_meta_quota_define_cl d
        on
            o.quota_id = d.quota_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.dcps_v_meta_quota_define;

-- 4.2 exchange partition
alter table ${iol_schema}.dcps_v_meta_quota_define exchange partition p_19000101 with table ${iol_schema}.dcps_v_meta_quota_define_cl;
alter table ${iol_schema}.dcps_v_meta_quota_define exchange partition p_20991231 with table ${iol_schema}.dcps_v_meta_quota_define_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.dcps_v_meta_quota_define to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.dcps_v_meta_quota_define_op purge;
drop table ${iol_schema}.dcps_v_meta_quota_define_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.dcps_v_meta_quota_define_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'dcps_v_meta_quota_define',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
