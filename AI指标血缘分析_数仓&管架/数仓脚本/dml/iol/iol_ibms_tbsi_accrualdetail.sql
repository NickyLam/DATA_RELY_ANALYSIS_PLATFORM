/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_tbsi_accrualdetail
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
create table ${iol_schema}.ibms_tbsi_accrualdetail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_tbsi_accrualdetail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbsi_accrualdetail_op purge;
drop table ${iol_schema}.ibms_tbsi_accrualdetail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_tbsi_accrualdetail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbsi_accrualdetail where 0=1;

create table ${iol_schema}.ibms_tbsi_accrualdetail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_tbsi_accrualdetail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbsi_accrualdetail_cl(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,tg_code -- 
            ,ad_cfid -- 现金流ID
            ,stream_id -- 利率流ID
            ,ad_startdate -- 计息开始日期
            ,ad_enddate -- 计息结束日期
            ,ad_fixingdate -- 定息日期
            ,self_id -- 计息明细ID
            ,ad_actualrate -- 实际利率
            ,ad_yearfraction -- 年化时间
            ,ad_fixingrate -- 定息利率
            ,ad_spread -- 利差
            ,ad_caprate -- 利率上限
            ,ad_floorrate -- 利率下限
            ,ad_multiplier -- 基准利率倍数
            ,imp_time -- 更新时间
            ,real_i_code -- 
            ,ad_paymentdate -- 支付日期
            ,ad_interestamount -- 计息区间利息
            ,pe_code -- 定价环境代码
            ,i_code_rpt -- 
            ,ad_notionalamount -- 计息区间本金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbsi_accrualdetail_op(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,tg_code -- 
            ,ad_cfid -- 现金流ID
            ,stream_id -- 利率流ID
            ,ad_startdate -- 计息开始日期
            ,ad_enddate -- 计息结束日期
            ,ad_fixingdate -- 定息日期
            ,self_id -- 计息明细ID
            ,ad_actualrate -- 实际利率
            ,ad_yearfraction -- 年化时间
            ,ad_fixingrate -- 定息利率
            ,ad_spread -- 利差
            ,ad_caprate -- 利率上限
            ,ad_floorrate -- 利率下限
            ,ad_multiplier -- 基准利率倍数
            ,imp_time -- 更新时间
            ,real_i_code -- 
            ,ad_paymentdate -- 支付日期
            ,ad_interestamount -- 计息区间利息
            ,pe_code -- 定价环境代码
            ,i_code_rpt -- 
            ,ad_notionalamount -- 计息区间本金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 
    ,nvl(n.a_type, o.a_type) as a_type -- 
    ,nvl(n.m_type, o.m_type) as m_type -- 
    ,nvl(n.tg_code, o.tg_code) as tg_code -- 
    ,nvl(n.ad_cfid, o.ad_cfid) as ad_cfid -- 现金流ID
    ,nvl(n.stream_id, o.stream_id) as stream_id -- 利率流ID
    ,nvl(n.ad_startdate, o.ad_startdate) as ad_startdate -- 计息开始日期
    ,nvl(n.ad_enddate, o.ad_enddate) as ad_enddate -- 计息结束日期
    ,nvl(n.ad_fixingdate, o.ad_fixingdate) as ad_fixingdate -- 定息日期
    ,nvl(n.self_id, o.self_id) as self_id -- 计息明细ID
    ,nvl(n.ad_actualrate, o.ad_actualrate) as ad_actualrate -- 实际利率
    ,nvl(n.ad_yearfraction, o.ad_yearfraction) as ad_yearfraction -- 年化时间
    ,nvl(n.ad_fixingrate, o.ad_fixingrate) as ad_fixingrate -- 定息利率
    ,nvl(n.ad_spread, o.ad_spread) as ad_spread -- 利差
    ,nvl(n.ad_caprate, o.ad_caprate) as ad_caprate -- 利率上限
    ,nvl(n.ad_floorrate, o.ad_floorrate) as ad_floorrate -- 利率下限
    ,nvl(n.ad_multiplier, o.ad_multiplier) as ad_multiplier -- 基准利率倍数
    ,nvl(n.imp_time, o.imp_time) as imp_time -- 更新时间
    ,nvl(n.real_i_code, o.real_i_code) as real_i_code -- 
    ,nvl(n.ad_paymentdate, o.ad_paymentdate) as ad_paymentdate -- 支付日期
    ,nvl(n.ad_interestamount, o.ad_interestamount) as ad_interestamount -- 计息区间利息
    ,nvl(n.pe_code, o.pe_code) as pe_code -- 定价环境代码
    ,nvl(n.i_code_rpt, o.i_code_rpt) as i_code_rpt -- 
    ,nvl(n.ad_notionalamount, o.ad_notionalamount) as ad_notionalamount -- 计息区间本金
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.tg_code is null
            and n.ad_cfid is null
            and n.stream_id is null
            and n.self_id is null
            and n.pe_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.tg_code is null
            and n.ad_cfid is null
            and n.stream_id is null
            and n.self_id is null
            and n.pe_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.tg_code is null
            and n.ad_cfid is null
            and n.stream_id is null
            and n.self_id is null
            and n.pe_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_tbsi_accrualdetail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_tbsi_accrualdetail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.tg_code = n.tg_code
            and o.ad_cfid = n.ad_cfid
            and o.stream_id = n.stream_id
            and o.self_id = n.self_id
            and o.pe_code = n.pe_code
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
        and o.tg_code is null
        and o.ad_cfid is null
        and o.stream_id is null
        and o.self_id is null
        and o.pe_code is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
        and n.tg_code is null
        and n.ad_cfid is null
        and n.stream_id is null
        and n.self_id is null
        and n.pe_code is null
    )
    or (
        o.ad_startdate <> n.ad_startdate
        or o.ad_enddate <> n.ad_enddate
        or o.ad_fixingdate <> n.ad_fixingdate
        or o.ad_actualrate <> n.ad_actualrate
        or o.ad_yearfraction <> n.ad_yearfraction
        or o.ad_fixingrate <> n.ad_fixingrate
        or o.ad_spread <> n.ad_spread
        or o.ad_caprate <> n.ad_caprate
        or o.ad_floorrate <> n.ad_floorrate
        or o.ad_multiplier <> n.ad_multiplier
        or o.imp_time <> n.imp_time
        or o.real_i_code <> n.real_i_code
        or o.ad_paymentdate <> n.ad_paymentdate
        or o.ad_interestamount <> n.ad_interestamount
        or o.i_code_rpt <> n.i_code_rpt
        or o.ad_notionalamount <> n.ad_notionalamount
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_tbsi_accrualdetail_cl(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,tg_code -- 
            ,ad_cfid -- 现金流ID
            ,stream_id -- 利率流ID
            ,ad_startdate -- 计息开始日期
            ,ad_enddate -- 计息结束日期
            ,ad_fixingdate -- 定息日期
            ,self_id -- 计息明细ID
            ,ad_actualrate -- 实际利率
            ,ad_yearfraction -- 年化时间
            ,ad_fixingrate -- 定息利率
            ,ad_spread -- 利差
            ,ad_caprate -- 利率上限
            ,ad_floorrate -- 利率下限
            ,ad_multiplier -- 基准利率倍数
            ,imp_time -- 更新时间
            ,real_i_code -- 
            ,ad_paymentdate -- 支付日期
            ,ad_interestamount -- 计息区间利息
            ,pe_code -- 定价环境代码
            ,i_code_rpt -- 
            ,ad_notionalamount -- 计息区间本金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_tbsi_accrualdetail_op(
            i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,tg_code -- 
            ,ad_cfid -- 现金流ID
            ,stream_id -- 利率流ID
            ,ad_startdate -- 计息开始日期
            ,ad_enddate -- 计息结束日期
            ,ad_fixingdate -- 定息日期
            ,self_id -- 计息明细ID
            ,ad_actualrate -- 实际利率
            ,ad_yearfraction -- 年化时间
            ,ad_fixingrate -- 定息利率
            ,ad_spread -- 利差
            ,ad_caprate -- 利率上限
            ,ad_floorrate -- 利率下限
            ,ad_multiplier -- 基准利率倍数
            ,imp_time -- 更新时间
            ,real_i_code -- 
            ,ad_paymentdate -- 支付日期
            ,ad_interestamount -- 计息区间利息
            ,pe_code -- 定价环境代码
            ,i_code_rpt -- 
            ,ad_notionalamount -- 计息区间本金
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 
    ,o.a_type -- 
    ,o.m_type -- 
    ,o.tg_code -- 
    ,o.ad_cfid -- 现金流ID
    ,o.stream_id -- 利率流ID
    ,o.ad_startdate -- 计息开始日期
    ,o.ad_enddate -- 计息结束日期
    ,o.ad_fixingdate -- 定息日期
    ,o.self_id -- 计息明细ID
    ,o.ad_actualrate -- 实际利率
    ,o.ad_yearfraction -- 年化时间
    ,o.ad_fixingrate -- 定息利率
    ,o.ad_spread -- 利差
    ,o.ad_caprate -- 利率上限
    ,o.ad_floorrate -- 利率下限
    ,o.ad_multiplier -- 基准利率倍数
    ,o.imp_time -- 更新时间
    ,o.real_i_code -- 
    ,o.ad_paymentdate -- 支付日期
    ,o.ad_interestamount -- 计息区间利息
    ,o.pe_code -- 定价环境代码
    ,o.i_code_rpt -- 
    ,o.ad_notionalamount -- 计息区间本金
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
from ${iol_schema}.ibms_tbsi_accrualdetail_bk o
    left join ${iol_schema}.ibms_tbsi_accrualdetail_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.tg_code = n.tg_code
            and o.ad_cfid = n.ad_cfid
            and o.stream_id = n.stream_id
            and o.self_id = n.self_id
            and o.pe_code = n.pe_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_tbsi_accrualdetail_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
            and o.tg_code = d.tg_code
            and o.ad_cfid = d.ad_cfid
            and o.stream_id = d.stream_id
            and o.self_id = d.self_id
            and o.pe_code = d.pe_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ibms_tbsi_accrualdetail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_tbsi_accrualdetail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_tbsi_accrualdetail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_tbsi_accrualdetail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_tbsi_accrualdetail exchange partition p_${batch_date} with table ${iol_schema}.ibms_tbsi_accrualdetail_cl;
alter table ${iol_schema}.ibms_tbsi_accrualdetail exchange partition p_20991231 with table ${iol_schema}.ibms_tbsi_accrualdetail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_tbsi_accrualdetail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_tbsi_accrualdetail_op purge;
drop table ${iol_schema}.ibms_tbsi_accrualdetail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_tbsi_accrualdetail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_tbsi_accrualdetail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
