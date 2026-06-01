/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tcs_tbtainfo
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
create table ${iol_schema}.nfss_tcs_tbtainfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tcs_tbtainfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tcs_tbtainfo_op purge;
drop table ${iol_schema}.nfss_tcs_tbtainfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbtainfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tcs_tbtainfo where 0=1;

create table ${iol_schema}.nfss_tcs_tbtainfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tcs_tbtainfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tcs_tbtainfo_cl(
            ta_code -- TA代码
            ,ta_shortname -- TA简称
            ,ta_name -- TA名称
            ,comp_mode -- 对账模式
            ,templet -- 接口模板
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,status -- TA状态
            ,prd_type -- 产品类别
            ,sum_flag -- 确认汇总标志
            ,muti_acc -- 多账号模式
            ,clear_type -- 清算方式
            ,real_cfm_flag -- TA类交易是否实时确认
            ,sub_deal_mode -- 认购确认是否解冻扣款
            ,cfm_fail_intere_in -- 募集失败确认金额里面包含利息
            ,host_check_date -- 主机对帐日期
            ,first_invest_flags -- 首次投资控制标识
            ,clear_table_flag -- 清算是否使用独立表
            ,control_flag -- BTA参数控制位#
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tcs_tbtainfo_op(
            ta_code -- TA代码
            ,ta_shortname -- TA简称
            ,ta_name -- TA名称
            ,comp_mode -- 对账模式
            ,templet -- 接口模板
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,status -- TA状态
            ,prd_type -- 产品类别
            ,sum_flag -- 确认汇总标志
            ,muti_acc -- 多账号模式
            ,clear_type -- 清算方式
            ,real_cfm_flag -- TA类交易是否实时确认
            ,sub_deal_mode -- 认购确认是否解冻扣款
            ,cfm_fail_intere_in -- 募集失败确认金额里面包含利息
            ,host_check_date -- 主机对帐日期
            ,first_invest_flags -- 首次投资控制标识
            ,clear_table_flag -- 清算是否使用独立表
            ,control_flag -- BTA参数控制位#
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.ta_shortname, o.ta_shortname) as ta_shortname -- TA简称
    ,nvl(n.ta_name, o.ta_name) as ta_name -- TA名称
    ,nvl(n.comp_mode, o.comp_mode) as comp_mode -- 对账模式
    ,nvl(n.templet, o.templet) as templet -- 接口模板
    ,nvl(n.open_time, o.open_time) as open_time -- 开市时间
    ,nvl(n.close_time, o.close_time) as close_time -- 闭市时间
    ,nvl(n.status, o.status) as status -- TA状态
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 产品类别
    ,nvl(n.sum_flag, o.sum_flag) as sum_flag -- 确认汇总标志
    ,nvl(n.muti_acc, o.muti_acc) as muti_acc -- 多账号模式
    ,nvl(n.clear_type, o.clear_type) as clear_type -- 清算方式
    ,nvl(n.real_cfm_flag, o.real_cfm_flag) as real_cfm_flag -- TA类交易是否实时确认
    ,nvl(n.sub_deal_mode, o.sub_deal_mode) as sub_deal_mode -- 认购确认是否解冻扣款
    ,nvl(n.cfm_fail_intere_in, o.cfm_fail_intere_in) as cfm_fail_intere_in -- 募集失败确认金额里面包含利息
    ,nvl(n.host_check_date, o.host_check_date) as host_check_date -- 主机对帐日期
    ,nvl(n.first_invest_flags, o.first_invest_flags) as first_invest_flags -- 首次投资控制标识
    ,nvl(n.clear_table_flag, o.clear_table_flag) as clear_table_flag -- 清算是否使用独立表
    ,nvl(n.control_flag, o.control_flag) as control_flag -- BTA参数控制位#
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留域1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留域2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 保留域3
    ,case when
            n.ta_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ta_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ta_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tcs_tbtainfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tcs_tbtainfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ta_code = n.ta_code
where (
        o.ta_code is null
    )
    or (
        n.ta_code is null
    )
    or (
        o.ta_shortname <> n.ta_shortname
        or o.ta_name <> n.ta_name
        or o.comp_mode <> n.comp_mode
        or o.templet <> n.templet
        or o.open_time <> n.open_time
        or o.close_time <> n.close_time
        or o.status <> n.status
        or o.prd_type <> n.prd_type
        or o.sum_flag <> n.sum_flag
        or o.muti_acc <> n.muti_acc
        or o.clear_type <> n.clear_type
        or o.real_cfm_flag <> n.real_cfm_flag
        or o.sub_deal_mode <> n.sub_deal_mode
        or o.cfm_fail_intere_in <> n.cfm_fail_intere_in
        or o.host_check_date <> n.host_check_date
        or o.first_invest_flags <> n.first_invest_flags
        or o.clear_table_flag <> n.clear_table_flag
        or o.control_flag <> n.control_flag
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tcs_tbtainfo_cl(
            ta_code -- TA代码
            ,ta_shortname -- TA简称
            ,ta_name -- TA名称
            ,comp_mode -- 对账模式
            ,templet -- 接口模板
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,status -- TA状态
            ,prd_type -- 产品类别
            ,sum_flag -- 确认汇总标志
            ,muti_acc -- 多账号模式
            ,clear_type -- 清算方式
            ,real_cfm_flag -- TA类交易是否实时确认
            ,sub_deal_mode -- 认购确认是否解冻扣款
            ,cfm_fail_intere_in -- 募集失败确认金额里面包含利息
            ,host_check_date -- 主机对帐日期
            ,first_invest_flags -- 首次投资控制标识
            ,clear_table_flag -- 清算是否使用独立表
            ,control_flag -- BTA参数控制位#
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tcs_tbtainfo_op(
            ta_code -- TA代码
            ,ta_shortname -- TA简称
            ,ta_name -- TA名称
            ,comp_mode -- 对账模式
            ,templet -- 接口模板
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,status -- TA状态
            ,prd_type -- 产品类别
            ,sum_flag -- 确认汇总标志
            ,muti_acc -- 多账号模式
            ,clear_type -- 清算方式
            ,real_cfm_flag -- TA类交易是否实时确认
            ,sub_deal_mode -- 认购确认是否解冻扣款
            ,cfm_fail_intere_in -- 募集失败确认金额里面包含利息
            ,host_check_date -- 主机对帐日期
            ,first_invest_flags -- 首次投资控制标识
            ,clear_table_flag -- 清算是否使用独立表
            ,control_flag -- BTA参数控制位#
            ,reserve1 -- 保留域1
            ,reserve2 -- 保留域2
            ,reserve3 -- 保留域3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_code -- TA代码
    ,o.ta_shortname -- TA简称
    ,o.ta_name -- TA名称
    ,o.comp_mode -- 对账模式
    ,o.templet -- 接口模板
    ,o.open_time -- 开市时间
    ,o.close_time -- 闭市时间
    ,o.status -- TA状态
    ,o.prd_type -- 产品类别
    ,o.sum_flag -- 确认汇总标志
    ,o.muti_acc -- 多账号模式
    ,o.clear_type -- 清算方式
    ,o.real_cfm_flag -- TA类交易是否实时确认
    ,o.sub_deal_mode -- 认购确认是否解冻扣款
    ,o.cfm_fail_intere_in -- 募集失败确认金额里面包含利息
    ,o.host_check_date -- 主机对帐日期
    ,o.first_invest_flags -- 首次投资控制标识
    ,o.clear_table_flag -- 清算是否使用独立表
    ,o.control_flag -- BTA参数控制位#
    ,o.reserve1 -- 保留域1
    ,o.reserve2 -- 保留域2
    ,o.reserve3 -- 保留域3
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tcs_tbtainfo_bk o
    left join ${iol_schema}.nfss_tcs_tbtainfo_op n
        on
            o.ta_code = n.ta_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tcs_tbtainfo_cl d
        on
            o.ta_code = d.ta_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tcs_tbtainfo;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tcs_tbtainfo exchange partition p_19000101 with table ${iol_schema}.nfss_tcs_tbtainfo_cl;
alter table ${iol_schema}.nfss_tcs_tbtainfo exchange partition p_20991231 with table ${iol_schema}.nfss_tcs_tbtainfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tcs_tbtainfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tcs_tbtainfo_op purge;
drop table ${iol_schema}.nfss_tcs_tbtainfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tcs_tbtainfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tcs_tbtainfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
