/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a92fundmarket
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
create table ${iol_schema}.mpcs_a92fundmarket_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a92fundmarket;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92fundmarket_op purge;
drop table ${iol_schema}.mpcs_a92fundmarket_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92fundmarket_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a92fundmarket where 0=1;

create table ${iol_schema}.mpcs_a92fundmarket_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.mpcs_a92fundmarket where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.mpcs_a92fundmarket_op(
        paysys -- 服务方简称
        ,instid -- 接入商户号
        ,navdate -- 净值日期
        ,fundcode -- 基金代码
        ,nav -- 单位净值
        ,accumulatednav -- 累计净值
        ,returnday -- 日涨幅
        ,unityield -- 万份收益
        ,yearlyroe -- 七日年化收益率
        ,statusdate -- 状态日期
        ,fundstatus -- 基金状态0：可申购赎回1：发行中4：停止申购赎回5：停止申购6：停止赎回8：基金终止9：封闭期
        ,convertstatus -- 基金转换状态
        ,investplanstatus -- 定投状态
        ,uptdatetime -- 更新日期
        ,reserve1 -- 备用字段1
        ,reserve2 -- 备用字段2
        ,reserve3 -- 备用字段3
        ,reserve4 -- 备用字段4
        ,reserve5 -- 备用字段5
        ,reserve6 -- 备用字段6
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.paysys -- 服务方简称
    ,n.instid -- 接入商户号
    ,n.navdate -- 净值日期
    ,n.fundcode -- 基金代码
    ,n.nav -- 单位净值
    ,n.accumulatednav -- 累计净值
    ,n.returnday -- 日涨幅
    ,n.unityield -- 万份收益
    ,n.yearlyroe -- 七日年化收益率
    ,n.statusdate -- 状态日期
    ,n.fundstatus -- 基金状态0：可申购赎回1：发行中4：停止申购赎回5：停止申购6：停止赎回8：基金终止9：封闭期
    ,n.convertstatus -- 基金转换状态
    ,n.investplanstatus -- 定投状态
    ,n.uptdatetime -- 更新日期
    ,n.reserve1 -- 备用字段1
    ,n.reserve2 -- 备用字段2
    ,n.reserve3 -- 备用字段3
    ,n.reserve4 -- 备用字段4
    ,n.reserve5 -- 备用字段5
    ,n.reserve6 -- 备用字段6
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a92fundmarket_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.mpcs_a92fundmarket where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.navdate = n.navdate
            and o.fundcode = n.fundcode
where (
        o.navdate is null
        and o.fundcode is null
    )
    or (
        o.paysys <> n.paysys
        or o.instid <> n.instid
        or o.nav <> n.nav
        or o.accumulatednav <> n.accumulatednav
        or o.returnday <> n.returnday
        or o.unityield <> n.unityield
        or o.yearlyroe <> n.yearlyroe
        or o.statusdate <> n.statusdate
        or o.fundstatus <> n.fundstatus
        or o.convertstatus <> n.convertstatus
        or o.investplanstatus <> n.investplanstatus
        or o.uptdatetime <> n.uptdatetime
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.reserve6 <> n.reserve6
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a92fundmarket_cl(
            paysys -- 服务方简称
        ,instid -- 接入商户号
        ,navdate -- 净值日期
        ,fundcode -- 基金代码
        ,nav -- 单位净值
        ,accumulatednav -- 累计净值
        ,returnday -- 日涨幅
        ,unityield -- 万份收益
        ,yearlyroe -- 七日年化收益率
        ,statusdate -- 状态日期
        ,fundstatus -- 基金状态0：可申购赎回1：发行中4：停止申购赎回5：停止申购6：停止赎回8：基金终止9：封闭期
        ,convertstatus -- 基金转换状态
        ,investplanstatus -- 定投状态
        ,uptdatetime -- 更新日期
        ,reserve1 -- 备用字段1
        ,reserve2 -- 备用字段2
        ,reserve3 -- 备用字段3
        ,reserve4 -- 备用字段4
        ,reserve5 -- 备用字段5
        ,reserve6 -- 备用字段6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a92fundmarket_op(
            paysys -- 服务方简称
        ,instid -- 接入商户号
        ,navdate -- 净值日期
        ,fundcode -- 基金代码
        ,nav -- 单位净值
        ,accumulatednav -- 累计净值
        ,returnday -- 日涨幅
        ,unityield -- 万份收益
        ,yearlyroe -- 七日年化收益率
        ,statusdate -- 状态日期
        ,fundstatus -- 基金状态0：可申购赎回1：发行中4：停止申购赎回5：停止申购6：停止赎回8：基金终止9：封闭期
        ,convertstatus -- 基金转换状态
        ,investplanstatus -- 定投状态
        ,uptdatetime -- 更新日期
        ,reserve1 -- 备用字段1
        ,reserve2 -- 备用字段2
        ,reserve3 -- 备用字段3
        ,reserve4 -- 备用字段4
        ,reserve5 -- 备用字段5
        ,reserve6 -- 备用字段6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.paysys -- 服务方简称
    ,o.instid -- 接入商户号
    ,o.navdate -- 净值日期
    ,o.fundcode -- 基金代码
    ,o.nav -- 单位净值
    ,o.accumulatednav -- 累计净值
    ,o.returnday -- 日涨幅
    ,o.unityield -- 万份收益
    ,o.yearlyroe -- 七日年化收益率
    ,o.statusdate -- 状态日期
    ,o.fundstatus -- 基金状态0：可申购赎回1：发行中4：停止申购赎回5：停止申购6：停止赎回8：基金终止9：封闭期
    ,o.convertstatus -- 基金转换状态
    ,o.investplanstatus -- 定投状态
    ,o.uptdatetime -- 更新日期
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
    ,o.reserve3 -- 备用字段3
    ,o.reserve4 -- 备用字段4
    ,o.reserve5 -- 备用字段5
    ,o.reserve6 -- 备用字段6
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
from ${iol_schema}.mpcs_a92fundmarket_bk o
    left join ${iol_schema}.mpcs_a92fundmarket_op n
        on
            o.navdate = n.navdate
            and o.fundcode = n.fundcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a92fundmarket;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a92fundmarket exchange partition p_19000101 with table ${iol_schema}.mpcs_a92fundmarket_cl;
alter table ${iol_schema}.mpcs_a92fundmarket exchange partition p_20991231 with table ${iol_schema}.mpcs_a92fundmarket_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a92fundmarket to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a92fundmarket_op purge;
drop table ${iol_schema}.mpcs_a92fundmarket_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a92fundmarket_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a92fundmarket',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
