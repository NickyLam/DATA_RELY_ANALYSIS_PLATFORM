/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_hkincomesimple
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
create table ${iol_schema}.wind_hkincomesimple_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_hkincomesimple;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hkincomesimple_op purge;
drop table ${iol_schema}.wind_hkincomesimple_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_hkincomesimple_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_hkincomesimple where 0=1;

create table ${iol_schema}.wind_hkincomesimple_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_hkincomesimple where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_hkincomesimple_op(
        object_id -- 对象ID
        ,s_info_compcode -- 公司id
        ,report_type -- 报告类型
        ,statement_type -- 报表类型代码
        ,fiscalyear -- 会计年度
        ,begindate -- 起始日期
        ,enddate -- 截止日期
        ,tot_oper_rev -- 总营业收入
        ,tot_oper_cost -- 总营业支出
        ,opprofit -- 营业利润
        ,profit_bef_tax -- 除税前利润(除税前盈利)
        ,less_tax -- 所得税
        ,minority_int_inc -- 少数股东损益
        ,net_profit_cs -- 净利润
        ,np_belongto_commonsh -- 归属普通股东净利润
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
    ,n.report_type -- 报告类型
    ,n.statement_type -- 报表类型代码
    ,n.fiscalyear -- 会计年度
    ,n.begindate -- 起始日期
    ,n.enddate -- 截止日期
    ,n.tot_oper_rev -- 总营业收入
    ,n.tot_oper_cost -- 总营业支出
    ,n.opprofit -- 营业利润
    ,n.profit_bef_tax -- 除税前利润(除税前盈利)
    ,n.less_tax -- 所得税
    ,n.minority_int_inc -- 少数股东损益
    ,n.net_profit_cs -- 净利润
    ,n.np_belongto_commonsh -- 归属普通股东净利润
    ,n.crncy_code -- 货币代码
    ,n.ann_dt -- 公告日期
    ,n.acc_sta_code -- 会计准则类型代码
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_hkincomesimple_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.wind_hkincomesimple where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        o.s_info_compcode <> n.s_info_compcode
        or o.report_type <> n.report_type
        or o.statement_type <> n.statement_type
        or o.fiscalyear <> n.fiscalyear
        or o.begindate <> n.begindate
        or o.enddate <> n.enddate
        or o.tot_oper_rev <> n.tot_oper_rev
        or o.tot_oper_cost <> n.tot_oper_cost
        or o.opprofit <> n.opprofit
        or o.profit_bef_tax <> n.profit_bef_tax
        or o.less_tax <> n.less_tax
        or o.minority_int_inc <> n.minority_int_inc
        or o.net_profit_cs <> n.net_profit_cs
        or o.np_belongto_commonsh <> n.np_belongto_commonsh
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
        into ${iol_schema}.wind_hkincomesimple_cl(
            object_id -- 对象ID
        ,s_info_compcode -- 公司id
        ,report_type -- 报告类型
        ,statement_type -- 报表类型代码
        ,fiscalyear -- 会计年度
        ,begindate -- 起始日期
        ,enddate -- 截止日期
        ,tot_oper_rev -- 总营业收入
        ,tot_oper_cost -- 总营业支出
        ,opprofit -- 营业利润
        ,profit_bef_tax -- 除税前利润(除税前盈利)
        ,less_tax -- 所得税
        ,minority_int_inc -- 少数股东损益
        ,net_profit_cs -- 净利润
        ,np_belongto_commonsh -- 归属普通股东净利润
        ,crncy_code -- 货币代码
        ,ann_dt -- 公告日期
        ,acc_sta_code -- 会计准则类型代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_hkincomesimple_op(
            object_id -- 对象ID
        ,s_info_compcode -- 公司id
        ,report_type -- 报告类型
        ,statement_type -- 报表类型代码
        ,fiscalyear -- 会计年度
        ,begindate -- 起始日期
        ,enddate -- 截止日期
        ,tot_oper_rev -- 总营业收入
        ,tot_oper_cost -- 总营业支出
        ,opprofit -- 营业利润
        ,profit_bef_tax -- 除税前利润(除税前盈利)
        ,less_tax -- 所得税
        ,minority_int_inc -- 少数股东损益
        ,net_profit_cs -- 净利润
        ,np_belongto_commonsh -- 归属普通股东净利润
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
    ,o.report_type -- 报告类型
    ,o.statement_type -- 报表类型代码
    ,o.fiscalyear -- 会计年度
    ,o.begindate -- 起始日期
    ,o.enddate -- 截止日期
    ,o.tot_oper_rev -- 总营业收入
    ,o.tot_oper_cost -- 总营业支出
    ,o.opprofit -- 营业利润
    ,o.profit_bef_tax -- 除税前利润(除税前盈利)
    ,o.less_tax -- 所得税
    ,o.minority_int_inc -- 少数股东损益
    ,o.net_profit_cs -- 净利润
    ,o.np_belongto_commonsh -- 归属普通股东净利润
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
from ${iol_schema}.wind_hkincomesimple_bk o
    left join ${iol_schema}.wind_hkincomesimple_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_hkincomesimple;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_hkincomesimple exchange partition p_19000101 with table ${iol_schema}.wind_hkincomesimple_cl;
alter table ${iol_schema}.wind_hkincomesimple exchange partition p_20991231 with table ${iol_schema}.wind_hkincomesimple_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_hkincomesimple to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_hkincomesimple_op purge;
drop table ${iol_schema}.wind_hkincomesimple_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_hkincomesimple_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_hkincomesimple',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
