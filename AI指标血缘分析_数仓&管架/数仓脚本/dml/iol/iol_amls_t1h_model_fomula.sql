/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t1h_model_fomula
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
create table ${iol_schema}.amls_t1h_model_fomula_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amls_t1h_model_fomula
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t1h_model_fomula_op purge;
drop table ${iol_schema}.amls_t1h_model_fomula_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t1h_model_fomula_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t1h_model_fomula where 0=1;

create table ${iol_schema}.amls_t1h_model_fomula_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amls_t1h_model_fomula where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t1h_model_fomula_cl(
            fomula_id -- 公式编号
            ,model_id -- 模板编码
            ,fomula_name -- 公式名称
            ,level_id -- 等级编号
            ,fomula_des -- 描述
            ,fomula_freq -- 计算频度（参见[字典:t00026]）
            ,fomula_explain -- 公式说明
            ,exec_seq -- 计算顺序
            ,flag -- 是否启用
            ,cust_type -- 公式客户类型
            ,create_tm -- 创建时间
            ,creator -- 创建人
            ,create_org -- 创建机构
            ,modify_tm -- 修改时间
            ,modifier -- 修改人
            ,who_first -- 值为空正常熟高原则；此字段填数值时，评级结果为数值较小的那条指标结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t1h_model_fomula_op(
            fomula_id -- 公式编号
            ,model_id -- 模板编码
            ,fomula_name -- 公式名称
            ,level_id -- 等级编号
            ,fomula_des -- 描述
            ,fomula_freq -- 计算频度（参见[字典:t00026]）
            ,fomula_explain -- 公式说明
            ,exec_seq -- 计算顺序
            ,flag -- 是否启用
            ,cust_type -- 公式客户类型
            ,create_tm -- 创建时间
            ,creator -- 创建人
            ,create_org -- 创建机构
            ,modify_tm -- 修改时间
            ,modifier -- 修改人
            ,who_first -- 值为空正常熟高原则；此字段填数值时，评级结果为数值较小的那条指标结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fomula_id, o.fomula_id) as fomula_id -- 公式编号
    ,nvl(n.model_id, o.model_id) as model_id -- 模板编码
    ,nvl(n.fomula_name, o.fomula_name) as fomula_name -- 公式名称
    ,nvl(n.level_id, o.level_id) as level_id -- 等级编号
    ,nvl(n.fomula_des, o.fomula_des) as fomula_des -- 描述
    ,nvl(n.fomula_freq, o.fomula_freq) as fomula_freq -- 计算频度（参见[字典:t00026]）
    ,nvl(n.fomula_explain, o.fomula_explain) as fomula_explain -- 公式说明
    ,nvl(n.exec_seq, o.exec_seq) as exec_seq -- 计算顺序
    ,nvl(n.flag, o.flag) as flag -- 是否启用
    ,nvl(n.cust_type, o.cust_type) as cust_type -- 公式客户类型
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构
    ,nvl(n.modify_tm, o.modify_tm) as modify_tm -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.who_first, o.who_first) as who_first -- 值为空正常熟高原则；此字段填数值时，评级结果为数值较小的那条指标结果
    ,case when
            n.fomula_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fomula_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fomula_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amls_t1h_model_fomula_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amls_t1h_model_fomula where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fomula_id = n.fomula_id
where (
        o.fomula_id is null
    )
    or (
        n.fomula_id is null
    )
    or (
        o.model_id <> n.model_id
        or o.fomula_name <> n.fomula_name
        or o.level_id <> n.level_id
        or o.fomula_des <> n.fomula_des
        or o.fomula_freq <> n.fomula_freq
        or o.fomula_explain <> n.fomula_explain
        or o.exec_seq <> n.exec_seq
        or o.flag <> n.flag
        or o.cust_type <> n.cust_type
        or o.create_tm <> n.create_tm
        or o.creator <> n.creator
        or o.create_org <> n.create_org
        or o.modify_tm <> n.modify_tm
        or o.modifier <> n.modifier
        or o.who_first <> n.who_first
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amls_t1h_model_fomula_cl(
            fomula_id -- 公式编号
            ,model_id -- 模板编码
            ,fomula_name -- 公式名称
            ,level_id -- 等级编号
            ,fomula_des -- 描述
            ,fomula_freq -- 计算频度（参见[字典:t00026]）
            ,fomula_explain -- 公式说明
            ,exec_seq -- 计算顺序
            ,flag -- 是否启用
            ,cust_type -- 公式客户类型
            ,create_tm -- 创建时间
            ,creator -- 创建人
            ,create_org -- 创建机构
            ,modify_tm -- 修改时间
            ,modifier -- 修改人
            ,who_first -- 值为空正常熟高原则；此字段填数值时，评级结果为数值较小的那条指标结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amls_t1h_model_fomula_op(
            fomula_id -- 公式编号
            ,model_id -- 模板编码
            ,fomula_name -- 公式名称
            ,level_id -- 等级编号
            ,fomula_des -- 描述
            ,fomula_freq -- 计算频度（参见[字典:t00026]）
            ,fomula_explain -- 公式说明
            ,exec_seq -- 计算顺序
            ,flag -- 是否启用
            ,cust_type -- 公式客户类型
            ,create_tm -- 创建时间
            ,creator -- 创建人
            ,create_org -- 创建机构
            ,modify_tm -- 修改时间
            ,modifier -- 修改人
            ,who_first -- 值为空正常熟高原则；此字段填数值时，评级结果为数值较小的那条指标结果
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fomula_id -- 公式编号
    ,o.model_id -- 模板编码
    ,o.fomula_name -- 公式名称
    ,o.level_id -- 等级编号
    ,o.fomula_des -- 描述
    ,o.fomula_freq -- 计算频度（参见[字典:t00026]）
    ,o.fomula_explain -- 公式说明
    ,o.exec_seq -- 计算顺序
    ,o.flag -- 是否启用
    ,o.cust_type -- 公式客户类型
    ,o.create_tm -- 创建时间
    ,o.creator -- 创建人
    ,o.create_org -- 创建机构
    ,o.modify_tm -- 修改时间
    ,o.modifier -- 修改人
    ,o.who_first -- 值为空正常熟高原则；此字段填数值时，评级结果为数值较小的那条指标结果
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
from ${iol_schema}.amls_t1h_model_fomula_bk o
    left join ${iol_schema}.amls_t1h_model_fomula_op n
        on
            o.fomula_id = n.fomula_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amls_t1h_model_fomula_cl d
        on
            o.fomula_id = d.fomula_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amls_t1h_model_fomula;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amls_t1h_model_fomula') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amls_t1h_model_fomula drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amls_t1h_model_fomula add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amls_t1h_model_fomula exchange partition p_${batch_date} with table ${iol_schema}.amls_t1h_model_fomula_cl;
alter table ${iol_schema}.amls_t1h_model_fomula exchange partition p_20991231 with table ${iol_schema}.amls_t1h_model_fomula_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t1h_model_fomula to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t1h_model_fomula_op purge;
drop table ${iol_schema}.amls_t1h_model_fomula_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amls_t1h_model_fomula_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t1h_model_fomula',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
