/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_cpr_model_index_map
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
create table ${iol_schema}.rsts_cpr_model_index_map_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rsts_cpr_model_index_map
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_cpr_model_index_map_op purge;
drop table ${iol_schema}.rsts_cpr_model_index_map_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_model_index_map_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_cpr_model_index_map where 0=1;

create table ${iol_schema}.rsts_cpr_model_index_map_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_cpr_model_index_map where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rsts_cpr_model_index_map_cl(
            uuid -- UUID
            ,businessexposure -- 业务敞口
            ,modelcode -- 模型标识
            ,modelname -- 模型名称
            ,indexclass -- 指标分类
            ,ratename -- 评级维度
            ,indexcode -- 指标标识
            ,indexname -- 指标名称
            ,indexexplain -- 指标说明
            ,source -- 数据来源
            ,grad -- 分档
            ,score -- 得分
            ,weight -- 权重
            ,commonlycalculationnew -- 一般计算公式(新)
            ,commonlycalculationold -- 一般计算公式(旧)
            ,specialcalculationnew -- 特殊计算公式(新)
            ,specialcalculationold -- 特殊计算公式(旧)
            ,accountfieldnew -- 科目号校验字段(新)
            ,accountfieldold -- 科目号校验字段(旧)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rsts_cpr_model_index_map_op(
            uuid -- UUID
            ,businessexposure -- 业务敞口
            ,modelcode -- 模型标识
            ,modelname -- 模型名称
            ,indexclass -- 指标分类
            ,ratename -- 评级维度
            ,indexcode -- 指标标识
            ,indexname -- 指标名称
            ,indexexplain -- 指标说明
            ,source -- 数据来源
            ,grad -- 分档
            ,score -- 得分
            ,weight -- 权重
            ,commonlycalculationnew -- 一般计算公式(新)
            ,commonlycalculationold -- 一般计算公式(旧)
            ,specialcalculationnew -- 特殊计算公式(新)
            ,specialcalculationold -- 特殊计算公式(旧)
            ,accountfieldnew -- 科目号校验字段(新)
            ,accountfieldold -- 科目号校验字段(旧)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.uuid, o.uuid) as uuid -- UUID
    ,nvl(n.businessexposure, o.businessexposure) as businessexposure -- 业务敞口
    ,nvl(n.modelcode, o.modelcode) as modelcode -- 模型标识
    ,nvl(n.modelname, o.modelname) as modelname -- 模型名称
    ,nvl(n.indexclass, o.indexclass) as indexclass -- 指标分类
    ,nvl(n.ratename, o.ratename) as ratename -- 评级维度
    ,nvl(n.indexcode, o.indexcode) as indexcode -- 指标标识
    ,nvl(n.indexname, o.indexname) as indexname -- 指标名称
    ,nvl(n.indexexplain, o.indexexplain) as indexexplain -- 指标说明
    ,nvl(n.source, o.source) as source -- 数据来源
    ,nvl(n.grad, o.grad) as grad -- 分档
    ,nvl(n.score, o.score) as score -- 得分
    ,nvl(n.weight, o.weight) as weight -- 权重
    ,nvl(n.commonlycalculationnew, o.commonlycalculationnew) as commonlycalculationnew -- 一般计算公式(新)
    ,nvl(n.commonlycalculationold, o.commonlycalculationold) as commonlycalculationold -- 一般计算公式(旧)
    ,nvl(n.specialcalculationnew, o.specialcalculationnew) as specialcalculationnew -- 特殊计算公式(新)
    ,nvl(n.specialcalculationold, o.specialcalculationold) as specialcalculationold -- 特殊计算公式(旧)
    ,nvl(n.accountfieldnew, o.accountfieldnew) as accountfieldnew -- 科目号校验字段(新)
    ,nvl(n.accountfieldold, o.accountfieldold) as accountfieldold -- 科目号校验字段(旧)
    ,case when
            n.uuid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.uuid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.uuid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rsts_cpr_model_index_map_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rsts_cpr_model_index_map where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.uuid = n.uuid
where (
        o.uuid is null
    )
    or (
        n.uuid is null
    )
    or (
        o.businessexposure <> n.businessexposure
        or o.modelcode <> n.modelcode
        or o.modelname <> n.modelname
        or o.indexclass <> n.indexclass
        or o.ratename <> n.ratename
        or o.indexcode <> n.indexcode
        or o.indexname <> n.indexname
        or o.indexexplain <> n.indexexplain
        or o.source <> n.source
        or o.grad <> n.grad
        or o.score <> n.score
        or o.weight <> n.weight
        or o.commonlycalculationnew <> n.commonlycalculationnew
        or o.commonlycalculationold <> n.commonlycalculationold
        or o.specialcalculationnew <> n.specialcalculationnew
        or o.specialcalculationold <> n.specialcalculationold
        or o.accountfieldnew <> n.accountfieldnew
        or o.accountfieldold <> n.accountfieldold
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rsts_cpr_model_index_map_cl(
            uuid -- UUID
            ,businessexposure -- 业务敞口
            ,modelcode -- 模型标识
            ,modelname -- 模型名称
            ,indexclass -- 指标分类
            ,ratename -- 评级维度
            ,indexcode -- 指标标识
            ,indexname -- 指标名称
            ,indexexplain -- 指标说明
            ,source -- 数据来源
            ,grad -- 分档
            ,score -- 得分
            ,weight -- 权重
            ,commonlycalculationnew -- 一般计算公式(新)
            ,commonlycalculationold -- 一般计算公式(旧)
            ,specialcalculationnew -- 特殊计算公式(新)
            ,specialcalculationold -- 特殊计算公式(旧)
            ,accountfieldnew -- 科目号校验字段(新)
            ,accountfieldold -- 科目号校验字段(旧)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rsts_cpr_model_index_map_op(
            uuid -- UUID
            ,businessexposure -- 业务敞口
            ,modelcode -- 模型标识
            ,modelname -- 模型名称
            ,indexclass -- 指标分类
            ,ratename -- 评级维度
            ,indexcode -- 指标标识
            ,indexname -- 指标名称
            ,indexexplain -- 指标说明
            ,source -- 数据来源
            ,grad -- 分档
            ,score -- 得分
            ,weight -- 权重
            ,commonlycalculationnew -- 一般计算公式(新)
            ,commonlycalculationold -- 一般计算公式(旧)
            ,specialcalculationnew -- 特殊计算公式(新)
            ,specialcalculationold -- 特殊计算公式(旧)
            ,accountfieldnew -- 科目号校验字段(新)
            ,accountfieldold -- 科目号校验字段(旧)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.uuid -- UUID
    ,o.businessexposure -- 业务敞口
    ,o.modelcode -- 模型标识
    ,o.modelname -- 模型名称
    ,o.indexclass -- 指标分类
    ,o.ratename -- 评级维度
    ,o.indexcode -- 指标标识
    ,o.indexname -- 指标名称
    ,o.indexexplain -- 指标说明
    ,o.source -- 数据来源
    ,o.grad -- 分档
    ,o.score -- 得分
    ,o.weight -- 权重
    ,o.commonlycalculationnew -- 一般计算公式(新)
    ,o.commonlycalculationold -- 一般计算公式(旧)
    ,o.specialcalculationnew -- 特殊计算公式(新)
    ,o.specialcalculationold -- 特殊计算公式(旧)
    ,o.accountfieldnew -- 科目号校验字段(新)
    ,o.accountfieldold -- 科目号校验字段(旧)
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.rsts_cpr_model_index_map_bk o
    left join ${iol_schema}.rsts_cpr_model_index_map_op n
        on
            o.uuid = n.uuid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rsts_cpr_model_index_map_cl d
        on
            o.uuid = d.uuid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rsts_cpr_model_index_map;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rsts_cpr_model_index_map') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rsts_cpr_model_index_map drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rsts_cpr_model_index_map add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rsts_cpr_model_index_map exchange partition p_${batch_date} with table ${iol_schema}.rsts_cpr_model_index_map_cl;
alter table ${iol_schema}.rsts_cpr_model_index_map exchange partition p_20991231 with table ${iol_schema}.rsts_cpr_model_index_map_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_cpr_model_index_map to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rsts_cpr_model_index_map_op purge;
drop table ${iol_schema}.rsts_cpr_model_index_map_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rsts_cpr_model_index_map_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_cpr_model_index_map',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
