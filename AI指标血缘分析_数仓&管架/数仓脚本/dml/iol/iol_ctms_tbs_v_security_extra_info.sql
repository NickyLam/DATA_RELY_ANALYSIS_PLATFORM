/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_security_extra_info
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
create table ${iol_schema}.ctms_tbs_v_security_extra_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_security_extra_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_extra_info_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_extra_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_extra_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security_extra_info where 0=1;

create table ${iol_schema}.ctms_tbs_v_security_extra_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_security_extra_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_extra_info_cl(
            security_code -- 债券代码
            ,payment_return_type -- 还款方式
            ,floating_rate_type -- 浮动公式
            ,payment_day -- 付息日调整至后第n个营业日
            ,selfdefineschd -- 不规则日程
            ,scan_modify -- 假日自动重展
            ,circ_market -- 自定义券流通市场
            ,calc_mthd -- 计算规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_extra_info_op(
            security_code -- 债券代码
            ,payment_return_type -- 还款方式
            ,floating_rate_type -- 浮动公式
            ,payment_day -- 付息日调整至后第n个营业日
            ,selfdefineschd -- 不规则日程
            ,scan_modify -- 假日自动重展
            ,circ_market -- 自定义券流通市场
            ,calc_mthd -- 计算规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.security_code, o.security_code) as security_code -- 债券代码
    ,nvl(n.payment_return_type, o.payment_return_type) as payment_return_type -- 还款方式
    ,nvl(n.floating_rate_type, o.floating_rate_type) as floating_rate_type -- 浮动公式
    ,nvl(n.payment_day, o.payment_day) as payment_day -- 付息日调整至后第n个营业日
    ,nvl(n.selfdefineschd, o.selfdefineschd) as selfdefineschd -- 不规则日程
    ,nvl(n.scan_modify, o.scan_modify) as scan_modify -- 假日自动重展
    ,nvl(n.circ_market, o.circ_market) as circ_market -- 自定义券流通市场
    ,nvl(n.calc_mthd, o.calc_mthd) as calc_mthd -- 计算规则
    ,case when
            n.security_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.security_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.security_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_security_extra_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_security_extra_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.security_code = n.security_code
where (
        o.security_code is null
    )
    or (
        n.security_code is null
    )
    or (
        o.payment_return_type <> n.payment_return_type
        or o.floating_rate_type <> n.floating_rate_type
        or o.payment_day <> n.payment_day
        or o.selfdefineschd <> n.selfdefineschd
        or o.scan_modify <> n.scan_modify
        or o.circ_market <> n.circ_market
        or o.calc_mthd <> n.calc_mthd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_security_extra_info_cl(
            security_code -- 债券代码
            ,payment_return_type -- 还款方式
            ,floating_rate_type -- 浮动公式
            ,payment_day -- 付息日调整至后第n个营业日
            ,selfdefineschd -- 不规则日程
            ,scan_modify -- 假日自动重展
            ,circ_market -- 自定义券流通市场
            ,calc_mthd -- 计算规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_security_extra_info_op(
            security_code -- 债券代码
            ,payment_return_type -- 还款方式
            ,floating_rate_type -- 浮动公式
            ,payment_day -- 付息日调整至后第n个营业日
            ,selfdefineschd -- 不规则日程
            ,scan_modify -- 假日自动重展
            ,circ_market -- 自定义券流通市场
            ,calc_mthd -- 计算规则
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.security_code -- 债券代码
    ,o.payment_return_type -- 还款方式
    ,o.floating_rate_type -- 浮动公式
    ,o.payment_day -- 付息日调整至后第n个营业日
    ,o.selfdefineschd -- 不规则日程
    ,o.scan_modify -- 假日自动重展
    ,o.circ_market -- 自定义券流通市场
    ,o.calc_mthd -- 计算规则
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_security_extra_info_bk o
    left join ${iol_schema}.ctms_tbs_v_security_extra_info_op n
        on
            o.security_code = n.security_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_security_extra_info_cl d
        on
            o.security_code = d.security_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_v_security_extra_info;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_security_extra_info exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_security_extra_info_cl;
alter table ${iol_schema}.ctms_tbs_v_security_extra_info exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_security_extra_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_security_extra_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_security_extra_info_op purge;
drop table ${iol_schema}.ctms_tbs_v_security_extra_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_security_extra_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_security_extra_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
