/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_tran_control_hist
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
create table ${iol_schema}.ncbs_tb_tran_control_hist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_tran_control_hist
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_tran_control_hist_op purge;
drop table ${iol_schema}.ncbs_tb_tran_control_hist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_tran_control_hist_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_tran_control_hist where 0=1;

create table ${iol_schema}.ncbs_tb_tran_control_hist_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_tran_control_hist where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_tran_control_hist_cl(
            client_no -- 客户编号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,message_code -- 接口服务代码
            ,message_type -- 接口服务类型
            ,service_code -- 服务代码
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,sub_seq_no -- 系统流水号
            ,tran_status -- 冲补抹标志
            ,channel_date -- 渠道日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,bus_seq_no -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_tran_control_hist_op(
            client_no -- 客户编号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,message_code -- 接口服务代码
            ,message_type -- 接口服务类型
            ,service_code -- 服务代码
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,sub_seq_no -- 系统流水号
            ,tran_status -- 冲补抹标志
            ,channel_date -- 渠道日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,bus_seq_no -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.reference, o.reference) as reference -- 交易参考号
    ,nvl(n.channel_seq_no, o.channel_seq_no) as channel_seq_no -- 全局流水号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.message_code, o.message_code) as message_code -- 接口服务代码
    ,nvl(n.message_type, o.message_type) as message_type -- 接口服务类型
    ,nvl(n.service_code, o.service_code) as service_code -- 服务代码
    ,nvl(n.source_module, o.source_module) as source_module -- 源模块
    ,nvl(n.source_type, o.source_type) as source_type -- 渠道编号
    ,nvl(n.sub_seq_no, o.sub_seq_no) as sub_seq_no -- 系统流水号
    ,nvl(n.tran_status, o.tran_status) as tran_status -- 冲补抹标志
    ,nvl(n.channel_date, o.channel_date) as channel_date -- 渠道日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.bus_seq_no, o.bus_seq_no) as bus_seq_no -- 业务流水号
    ,case when
            n.channel_seq_no is null
            and n.source_type is null
            and n.sub_seq_no is null
            and n.channel_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.channel_seq_no is null
            and n.source_type is null
            and n.sub_seq_no is null
            and n.channel_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.channel_seq_no is null
            and n.source_type is null
            and n.sub_seq_no is null
            and n.channel_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_tran_control_hist_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_tran_control_hist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.channel_seq_no = n.channel_seq_no
            and o.source_type = n.source_type
            and o.sub_seq_no = n.sub_seq_no
            and o.channel_date = n.channel_date
where (
        o.channel_seq_no is null
        and o.source_type is null
        and o.sub_seq_no is null
        and o.channel_date is null
    )
    or (
        n.channel_seq_no is null
        and n.source_type is null
        and n.sub_seq_no is null
        and n.channel_date is null
    )
    or (
        o.client_no <> n.client_no
        or o.reference <> n.reference
        or o.company <> n.company
        or o.message_code <> n.message_code
        or o.message_type <> n.message_type
        or o.service_code <> n.service_code
        or o.source_module <> n.source_module
        or o.tran_status <> n.tran_status
        or o.tran_timestamp <> n.tran_timestamp
        or o.tran_branch <> n.tran_branch
        or o.bus_seq_no <> n.bus_seq_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_tran_control_hist_cl(
            client_no -- 客户编号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,message_code -- 接口服务代码
            ,message_type -- 接口服务类型
            ,service_code -- 服务代码
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,sub_seq_no -- 系统流水号
            ,tran_status -- 冲补抹标志
            ,channel_date -- 渠道日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,bus_seq_no -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_tran_control_hist_op(
            client_no -- 客户编号
            ,reference -- 交易参考号
            ,channel_seq_no -- 全局流水号
            ,company -- 法人
            ,message_code -- 接口服务代码
            ,message_type -- 接口服务类型
            ,service_code -- 服务代码
            ,source_module -- 源模块
            ,source_type -- 渠道编号
            ,sub_seq_no -- 系统流水号
            ,tran_status -- 冲补抹标志
            ,channel_date -- 渠道日期
            ,tran_timestamp -- 交易时间戳
            ,tran_branch -- 核心交易机构编号
            ,bus_seq_no -- 业务流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.client_no -- 客户编号
    ,o.reference -- 交易参考号
    ,o.channel_seq_no -- 全局流水号
    ,o.company -- 法人
    ,o.message_code -- 接口服务代码
    ,o.message_type -- 接口服务类型
    ,o.service_code -- 服务代码
    ,o.source_module -- 源模块
    ,o.source_type -- 渠道编号
    ,o.sub_seq_no -- 系统流水号
    ,o.tran_status -- 冲补抹标志
    ,o.channel_date -- 渠道日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.tran_branch -- 核心交易机构编号
    ,o.bus_seq_no -- 业务流水号
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
from ${iol_schema}.ncbs_tb_tran_control_hist_bk o
    left join ${iol_schema}.ncbs_tb_tran_control_hist_op n
        on
            o.channel_seq_no = n.channel_seq_no
            and o.source_type = n.source_type
            and o.sub_seq_no = n.sub_seq_no
            and o.channel_date = n.channel_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_tran_control_hist_cl d
        on
            o.channel_seq_no = d.channel_seq_no
            and o.source_type = d.source_type
            and o.sub_seq_no = d.sub_seq_no
            and o.channel_date = d.channel_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_tran_control_hist;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_tran_control_hist') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_tran_control_hist drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_tran_control_hist add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_tran_control_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_tran_control_hist_cl;
alter table ${iol_schema}.ncbs_tb_tran_control_hist exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_tran_control_hist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_tran_control_hist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_tran_control_hist_op purge;
drop table ${iol_schema}.ncbs_tb_tran_control_hist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_tran_control_hist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_tran_control_hist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
