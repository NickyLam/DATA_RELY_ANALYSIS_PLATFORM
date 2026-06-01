/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hkcashflowsimple
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
whenever sqlerror continue none ;
create table ${iol_schema}.wind_hkcashflowsimple_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_hkcashflowsimple;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hkcashflowsimple_op purge;
drop table ${iol_schema}.wind_hkcashflowsimple_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkcashflowsimple_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_hkcashflowsimple where 0=1;

create table ${iol_schema}.wind_hkcashflowsimple_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_hkcashflowsimple where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_hkcashflowsimple_op(
        object_id -- 对象ID
        ,s_info_compcode -- 公司id
        ,report_type -- 报告类型代码
        ,statement_type -- 报表类型代码
        ,begindate -- 起始日期
        ,enddate -- 截止日期
        ,net_cash_flows_oper_act -- 经营活动产生的现金流量净额
        ,net_cash_flows_inv_act -- 投资活动产生的现金流量净额
        ,net_cash_flows_fund_act -- 筹资活动产生现金流量净额(融资活动产生的现金流量净额)
        ,net_incr_cash_cash_equ -- 现金及现金等价物净增加额
        ,crncy_code -- 货币代码
        ,ann_dt -- 公告日期
        ,acc_sta_code -- 会计准则类型代码
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 对象ID
    ,n.s_info_compcode -- 公司id
    ,n.report_type -- 报告类型代码
    ,n.statement_type -- 报表类型代码
    ,n.begindate -- 起始日期
    ,n.enddate -- 截止日期
    ,n.net_cash_flows_oper_act -- 经营活动产生的现金流量净额
    ,n.net_cash_flows_inv_act -- 投资活动产生的现金流量净额
    ,n.net_cash_flows_fund_act -- 筹资活动产生现金流量净额(融资活动产生的现金流量净额)
    ,n.net_incr_cash_cash_equ -- 现金及现金等价物净增加额
    ,n.crncy_code -- 货币代码
    ,n.ann_dt -- 公告日期
    ,n.acc_sta_code -- 会计准则类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_hkcashflowsimple_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.wind_hkcashflowsimple where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        o.s_info_compcode <> n.s_info_compcode
        or o.report_type <> n.report_type
        or o.statement_type <> n.statement_type
        or o.begindate <> n.begindate
        or o.enddate <> n.enddate
        or o.net_cash_flows_oper_act <> n.net_cash_flows_oper_act
        or o.net_cash_flows_inv_act <> n.net_cash_flows_inv_act
        or o.net_cash_flows_fund_act <> n.net_cash_flows_fund_act
        or o.net_incr_cash_cash_equ <> n.net_incr_cash_cash_equ
        or o.crncy_code <> n.crncy_code
        or o.ann_dt <> n.ann_dt
        or o.acc_sta_code <> n.acc_sta_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_hkcashflowsimple_cl(
            object_id -- 对象ID
        ,s_info_compcode -- 公司id
        ,report_type -- 报告类型代码
        ,statement_type -- 报表类型代码
        ,begindate -- 起始日期
        ,enddate -- 截止日期
        ,net_cash_flows_oper_act -- 经营活动产生的现金流量净额
        ,net_cash_flows_inv_act -- 投资活动产生的现金流量净额
        ,net_cash_flows_fund_act -- 筹资活动产生现金流量净额(融资活动产生的现金流量净额)
        ,net_incr_cash_cash_equ -- 现金及现金等价物净增加额
        ,crncy_code -- 货币代码
        ,ann_dt -- 公告日期
        ,acc_sta_code -- 会计准则类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_hkcashflowsimple_op(
            object_id -- 对象ID
        ,s_info_compcode -- 公司id
        ,report_type -- 报告类型代码
        ,statement_type -- 报表类型代码
        ,begindate -- 起始日期
        ,enddate -- 截止日期
        ,net_cash_flows_oper_act -- 经营活动产生的现金流量净额
        ,net_cash_flows_inv_act -- 投资活动产生的现金流量净额
        ,net_cash_flows_fund_act -- 筹资活动产生现金流量净额(融资活动产生的现金流量净额)
        ,net_incr_cash_cash_equ -- 现金及现金等价物净增加额
        ,crncy_code -- 货币代码
        ,ann_dt -- 公告日期
        ,acc_sta_code -- 会计准则类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.s_info_compcode -- 公司id
    ,o.report_type -- 报告类型代码
    ,o.statement_type -- 报表类型代码
    ,o.begindate -- 起始日期
    ,o.enddate -- 截止日期
    ,o.net_cash_flows_oper_act -- 经营活动产生的现金流量净额
    ,o.net_cash_flows_inv_act -- 投资活动产生的现金流量净额
    ,o.net_cash_flows_fund_act -- 筹资活动产生现金流量净额(融资活动产生的现金流量净额)
    ,o.net_incr_cash_cash_equ -- 现金及现金等价物净增加额
    ,o.crncy_code -- 货币代码
    ,o.ann_dt -- 公告日期
    ,o.acc_sta_code -- 会计准则类型代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_hkcashflowsimple_bk o
    left join ${iol_schema}.wind_hkcashflowsimple_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_hkcashflowsimple;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_hkcashflowsimple exchange partition p_19000101 with table ${iol_schema}.wind_hkcashflowsimple_cl;
alter table ${iol_schema}.wind_hkcashflowsimple exchange partition p_20991231 with table ${iol_schema}.wind_hkcashflowsimple_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hkcashflowsimple to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hkcashflowsimple_op purge;
drop table ${iol_schema}.wind_hkcashflowsimple_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_hkcashflowsimple_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hkcashflowsimple',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
