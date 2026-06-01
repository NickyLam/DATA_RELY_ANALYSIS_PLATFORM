/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbhisaccreqext
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
create table ${iol_schema}.ifms_tbhisaccreqext_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbhisaccreqext
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbhisaccreqext_op purge;
drop table ${iol_schema}.ifms_tbhisaccreqext_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbhisaccreqext_op nologging
for exchange with table
${iol_schema}.ifms_tbhisaccreqext;

create table ${iol_schema}.ifms_tbhisaccreqext_cl nologging
for exchange with table
${iol_schema}.ifms_tbhisaccreqext;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbhisaccreqext_cl(
            serial_no -- 流水号
            ,ex_serial -- 渠道流水号
            ,cfm_no -- 确认编号
            ,cfm_date -- 确认日期
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,ta_code -- TA代码
            ,in_client_no -- 内部客户号
            ,glblsrlno -- 全局流水号
            ,cnsmrsysid -- 系统ID
            ,cnltxncd -- 渠道号
            ,reserve1 -- 备用字段
            ,reserve2 -- 备用字段
            ,reserve3 -- 备用字段
            ,reserve4 -- 备用字段
            ,reserve5 -- 备用字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbhisaccreqext_op(
            serial_no -- 流水号
            ,ex_serial -- 渠道流水号
            ,cfm_no -- 确认编号
            ,cfm_date -- 确认日期
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,ta_code -- TA代码
            ,in_client_no -- 内部客户号
            ,glblsrlno -- 全局流水号
            ,cnsmrsysid -- 系统ID
            ,cnltxncd -- 渠道号
            ,reserve1 -- 备用字段
            ,reserve2 -- 备用字段
            ,reserve3 -- 备用字段
            ,reserve4 -- 备用字段
            ,reserve5 -- 备用字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serial_no, o.serial_no) as serial_no -- 流水号
    ,nvl(n.ex_serial, o.ex_serial) as ex_serial -- 渠道流水号
    ,nvl(n.cfm_no, o.cfm_no) as cfm_no -- 确认编号
    ,nvl(n.cfm_date, o.cfm_date) as cfm_date -- 确认日期
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 交易日期
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 交易时间
    ,nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.in_client_no, o.in_client_no) as in_client_no -- 内部客户号
    ,nvl(n.glblsrlno, o.glblsrlno) as glblsrlno -- 全局流水号
    ,nvl(n.cnsmrsysid, o.cnsmrsysid) as cnsmrsysid -- 系统ID
    ,nvl(n.cnltxncd, o.cnltxncd) as cnltxncd -- 渠道号
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备用字段
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 备用字段
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 备用字段
    ,case when
            n.serial_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serial_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serial_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbhisaccreqext_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbhisaccreqext where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serial_no = n.serial_no
where (
        o.serial_no is null
    )
    or (
        n.serial_no is null
    )
    or (
        o.ex_serial <> n.ex_serial
        or o.cfm_no <> n.cfm_no
        or o.cfm_date <> n.cfm_date
        or o.trans_date <> n.trans_date
        or o.trans_time <> n.trans_time
        or o.ta_code <> n.ta_code
        or o.in_client_no <> n.in_client_no
        or o.glblsrlno <> n.glblsrlno
        or o.cnsmrsysid <> n.cnsmrsysid
        or o.cnltxncd <> n.cnltxncd
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbhisaccreqext_cl(
            serial_no -- 流水号
            ,ex_serial -- 渠道流水号
            ,cfm_no -- 确认编号
            ,cfm_date -- 确认日期
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,ta_code -- TA代码
            ,in_client_no -- 内部客户号
            ,glblsrlno -- 全局流水号
            ,cnsmrsysid -- 系统ID
            ,cnltxncd -- 渠道号
            ,reserve1 -- 备用字段
            ,reserve2 -- 备用字段
            ,reserve3 -- 备用字段
            ,reserve4 -- 备用字段
            ,reserve5 -- 备用字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbhisaccreqext_op(
            serial_no -- 流水号
            ,ex_serial -- 渠道流水号
            ,cfm_no -- 确认编号
            ,cfm_date -- 确认日期
            ,trans_date -- 交易日期
            ,trans_time -- 交易时间
            ,ta_code -- TA代码
            ,in_client_no -- 内部客户号
            ,glblsrlno -- 全局流水号
            ,cnsmrsysid -- 系统ID
            ,cnltxncd -- 渠道号
            ,reserve1 -- 备用字段
            ,reserve2 -- 备用字段
            ,reserve3 -- 备用字段
            ,reserve4 -- 备用字段
            ,reserve5 -- 备用字段
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serial_no -- 流水号
    ,o.ex_serial -- 渠道流水号
    ,o.cfm_no -- 确认编号
    ,o.cfm_date -- 确认日期
    ,o.trans_date -- 交易日期
    ,o.trans_time -- 交易时间
    ,o.ta_code -- TA代码
    ,o.in_client_no -- 内部客户号
    ,o.glblsrlno -- 全局流水号
    ,o.cnsmrsysid -- 系统ID
    ,o.cnltxncd -- 渠道号
    ,o.reserve1 -- 备用字段
    ,o.reserve2 -- 备用字段
    ,o.reserve3 -- 备用字段
    ,o.reserve4 -- 备用字段
    ,o.reserve5 -- 备用字段
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
from ${iol_schema}.ifms_tbhisaccreqext_bk o
    left join ${iol_schema}.ifms_tbhisaccreqext_op n
        on
            o.serial_no = n.serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbhisaccreqext_cl d
        on
            o.serial_no = d.serial_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifms_tbhisaccreqext;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifms_tbhisaccreqext') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifms_tbhisaccreqext drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifms_tbhisaccreqext add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifms_tbhisaccreqext exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbhisaccreqext_cl;
alter table ${iol_schema}.ifms_tbhisaccreqext exchange partition p_20991231 with table ${iol_schema}.ifms_tbhisaccreqext_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbhisaccreqext to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbhisaccreqext_op purge;
drop table ${iol_schema}.ifms_tbhisaccreqext_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbhisaccreqext_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbhisaccreqext',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
