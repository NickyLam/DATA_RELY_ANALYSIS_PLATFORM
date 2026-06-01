/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_uxds_bond_sc_actual_strike
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
create table ${iol_schema}.uxds_bond_sc_actual_strike_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.uxds_bond_sc_actual_strike
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_bond_sc_actual_strike_op purge;
drop table ${iol_schema}.uxds_bond_sc_actual_strike_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_bond_sc_actual_strike_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_bond_sc_actual_strike where 0=1;

create table ${iol_schema}.uxds_bond_sc_actual_strike_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.uxds_bond_sc_actual_strike where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uxds_bond_sc_actual_strike_cl(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,record_sd -- 登记起始日
            ,record_ed -- 登记截止日
            ,strike_date -- 行权日
            ,clause_type_code -- 条款类型编码
            ,clause_type -- 条款类型
            ,strike_price -- 行权价
            ,strike_num -- 行权数量
            ,capital_to_account_date -- 资金到账日
            ,introduction -- 说明
            ,margin_after_strike -- 行权后利差
            ,resale_code -- 回售代码
            ,resale_name -- 回售简称
            ,strike_result_ad -- 行权结果公告日
            ,notice_date -- 提示公告日
            ,redemp_stop_td_date -- 赎回停止交易日
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uxds_bond_sc_actual_strike_op(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,record_sd -- 登记起始日
            ,record_ed -- 登记截止日
            ,strike_date -- 行权日
            ,clause_type_code -- 条款类型编码
            ,clause_type -- 条款类型
            ,strike_price -- 行权价
            ,strike_num -- 行权数量
            ,capital_to_account_date -- 资金到账日
            ,introduction -- 说明
            ,margin_after_strike -- 行权后利差
            ,resale_code -- 回售代码
            ,resale_name -- 回售简称
            ,strike_result_ad -- 行权结果公告日
            ,notice_date -- 提示公告日
            ,redemp_stop_td_date -- 赎回停止交易日
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.seq, o.seq) as seq -- 记录唯一标识
    ,nvl(n.ctime, o.ctime) as ctime -- 记录创建日期
    ,nvl(n.mtime, o.mtime) as mtime -- 记录修改日期
    ,nvl(n.rtime, o.rtime) as rtime -- 记录通讯到用户端日期
    ,nvl(n.bond_id, o.bond_id) as bond_id -- 债券id
    ,nvl(n.record_sd, o.record_sd) as record_sd -- 登记起始日
    ,nvl(n.record_ed, o.record_ed) as record_ed -- 登记截止日
    ,nvl(n.strike_date, o.strike_date) as strike_date -- 行权日
    ,nvl(n.clause_type_code, o.clause_type_code) as clause_type_code -- 条款类型编码
    ,nvl(n.clause_type, o.clause_type) as clause_type -- 条款类型
    ,nvl(n.strike_price, o.strike_price) as strike_price -- 行权价
    ,nvl(n.strike_num, o.strike_num) as strike_num -- 行权数量
    ,nvl(n.capital_to_account_date, o.capital_to_account_date) as capital_to_account_date -- 资金到账日
    ,nvl(n.introduction, o.introduction) as introduction -- 说明
    ,nvl(n.margin_after_strike, o.margin_after_strike) as margin_after_strike -- 行权后利差
    ,nvl(n.resale_code, o.resale_code) as resale_code -- 回售代码
    ,nvl(n.resale_name, o.resale_name) as resale_name -- 回售简称
    ,nvl(n.strike_result_ad, o.strike_result_ad) as strike_result_ad -- 行权结果公告日
    ,nvl(n.notice_date, o.notice_date) as notice_date -- 提示公告日
    ,nvl(n.redemp_stop_td_date, o.redemp_stop_td_date) as redemp_stop_td_date -- 赎回停止交易日
    ,nvl(n.isvalid, o.isvalid) as isvalid -- 是否有效
    ,case when
            n.seq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.seq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.seq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.uxds_bond_sc_actual_strike_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.uxds_bond_sc_actual_strike where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seq = n.seq
where (
        o.seq is null
    )
    or (
        n.seq is null
    )
    or (
        o.ctime <> n.ctime
        or o.mtime <> n.mtime
        or o.rtime <> n.rtime
        or o.bond_id <> n.bond_id
        or o.record_sd <> n.record_sd
        or o.record_ed <> n.record_ed
        or o.strike_date <> n.strike_date
        or o.clause_type_code <> n.clause_type_code
        or o.clause_type <> n.clause_type
        or o.strike_price <> n.strike_price
        or o.strike_num <> n.strike_num
        or o.capital_to_account_date <> n.capital_to_account_date
        or o.introduction <> n.introduction
        or o.margin_after_strike <> n.margin_after_strike
        or o.resale_code <> n.resale_code
        or o.resale_name <> n.resale_name
        or o.strike_result_ad <> n.strike_result_ad
        or o.notice_date <> n.notice_date
        or o.redemp_stop_td_date <> n.redemp_stop_td_date
        or o.isvalid <> n.isvalid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.uxds_bond_sc_actual_strike_cl(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,record_sd -- 登记起始日
            ,record_ed -- 登记截止日
            ,strike_date -- 行权日
            ,clause_type_code -- 条款类型编码
            ,clause_type -- 条款类型
            ,strike_price -- 行权价
            ,strike_num -- 行权数量
            ,capital_to_account_date -- 资金到账日
            ,introduction -- 说明
            ,margin_after_strike -- 行权后利差
            ,resale_code -- 回售代码
            ,resale_name -- 回售简称
            ,strike_result_ad -- 行权结果公告日
            ,notice_date -- 提示公告日
            ,redemp_stop_td_date -- 赎回停止交易日
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.uxds_bond_sc_actual_strike_op(
            seq -- 记录唯一标识
            ,ctime -- 记录创建日期
            ,mtime -- 记录修改日期
            ,rtime -- 记录通讯到用户端日期
            ,bond_id -- 债券id
            ,record_sd -- 登记起始日
            ,record_ed -- 登记截止日
            ,strike_date -- 行权日
            ,clause_type_code -- 条款类型编码
            ,clause_type -- 条款类型
            ,strike_price -- 行权价
            ,strike_num -- 行权数量
            ,capital_to_account_date -- 资金到账日
            ,introduction -- 说明
            ,margin_after_strike -- 行权后利差
            ,resale_code -- 回售代码
            ,resale_name -- 回售简称
            ,strike_result_ad -- 行权结果公告日
            ,notice_date -- 提示公告日
            ,redemp_stop_td_date -- 赎回停止交易日
            ,isvalid -- 是否有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seq -- 记录唯一标识
    ,o.ctime -- 记录创建日期
    ,o.mtime -- 记录修改日期
    ,o.rtime -- 记录通讯到用户端日期
    ,o.bond_id -- 债券id
    ,o.record_sd -- 登记起始日
    ,o.record_ed -- 登记截止日
    ,o.strike_date -- 行权日
    ,o.clause_type_code -- 条款类型编码
    ,o.clause_type -- 条款类型
    ,o.strike_price -- 行权价
    ,o.strike_num -- 行权数量
    ,o.capital_to_account_date -- 资金到账日
    ,o.introduction -- 说明
    ,o.margin_after_strike -- 行权后利差
    ,o.resale_code -- 回售代码
    ,o.resale_name -- 回售简称
    ,o.strike_result_ad -- 行权结果公告日
    ,o.notice_date -- 提示公告日
    ,o.redemp_stop_td_date -- 赎回停止交易日
    ,o.isvalid -- 是否有效
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
from ${iol_schema}.uxds_bond_sc_actual_strike_bk o
    left join ${iol_schema}.uxds_bond_sc_actual_strike_op n
        on
            o.seq = n.seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.uxds_bond_sc_actual_strike_cl d
        on
            o.seq = d.seq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.uxds_bond_sc_actual_strike;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('uxds_bond_sc_actual_strike') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.uxds_bond_sc_actual_strike drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.uxds_bond_sc_actual_strike add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.uxds_bond_sc_actual_strike exchange partition p_${batch_date} with table ${iol_schema}.uxds_bond_sc_actual_strike_cl;
alter table ${iol_schema}.uxds_bond_sc_actual_strike exchange partition p_20991231 with table ${iol_schema}.uxds_bond_sc_actual_strike_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.uxds_bond_sc_actual_strike to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.uxds_bond_sc_actual_strike_op purge;
drop table ${iol_schema}.uxds_bond_sc_actual_strike_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.uxds_bond_sc_actual_strike_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'uxds_bond_sc_actual_strike',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
