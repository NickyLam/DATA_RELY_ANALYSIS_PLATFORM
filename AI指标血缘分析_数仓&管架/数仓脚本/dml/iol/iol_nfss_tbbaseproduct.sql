/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbbaseproduct
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
create table ${iol_schema}.nfss_tbbaseproduct_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbbaseproduct
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbbaseproduct_op purge;
drop table ${iol_schema}.nfss_tbbaseproduct_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbbaseproduct_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbbaseproduct where 0=1;

create table ${iol_schema}.nfss_tbbaseproduct_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbbaseproduct where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbbaseproduct_cl(
            prd_code -- 产品代码
            ,prd_name -- 产品名称
            ,prd_manager -- 产品管理人代码
            ,manager_name -- 产品管理人姓名
            ,nav -- 单位净值
            ,risk_level -- 风险级别:风险等级 [K_KHFXDJ] K_KHFXDJ	客户风险等级	0	未评定	0	0 K_KHFXDJ	客户风险等级	1	低风险	0	0 K_KHFXDJ	客户风险等级	2	中低风险	0	0 K_KHFXDJ	客户风险等级	3	中风险	0	0 K_KHFXDJ	客户风险等级	4	中高风险	0	0 K_KHFXDJ	客户风险等级	5	高风险	0	0
            ,prd_status -- 产品状态:确认日期的状态 *：准备期 0：认购期 1：正常开放 3：暂停赎回 4：暂停申购 5：暂停交易 6：基金终止 9：发行失败
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,pmax_accu_amt -- 个人单户累计最大购买金额
            ,pdaily_red_maxvol -- 个人单日单户赎回份额上限
            ,ta_code -- TA代码
            ,yield -- 七日年化收益率
            ,income_unit -- 万份收益
            ,prd_type -- 产品类型:1-基金
            ,remark1 -- 备用字段1
            ,remark2 -- 备用字段2
            ,remark3 -- 备用字段3
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,double1 -- 扩展浮点数1
            ,double2 -- 备用double2
            ,double3 -- 备用double3
            ,prd_flag -- 产品标志
            ,iss_date -- 发布日期
            ,nav_date -- 净值日期
            ,clt_rapid_pmaxvol -- 个人单日单户实时赎回金额
            ,daily_buy_pmaxvol -- 个人当日累计最大购买
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbbaseproduct_op(
            prd_code -- 产品代码
            ,prd_name -- 产品名称
            ,prd_manager -- 产品管理人代码
            ,manager_name -- 产品管理人姓名
            ,nav -- 单位净值
            ,risk_level -- 风险级别:风险等级 [K_KHFXDJ] K_KHFXDJ	客户风险等级	0	未评定	0	0 K_KHFXDJ	客户风险等级	1	低风险	0	0 K_KHFXDJ	客户风险等级	2	中低风险	0	0 K_KHFXDJ	客户风险等级	3	中风险	0	0 K_KHFXDJ	客户风险等级	4	中高风险	0	0 K_KHFXDJ	客户风险等级	5	高风险	0	0
            ,prd_status -- 产品状态:确认日期的状态 *：准备期 0：认购期 1：正常开放 3：暂停赎回 4：暂停申购 5：暂停交易 6：基金终止 9：发行失败
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,pmax_accu_amt -- 个人单户累计最大购买金额
            ,pdaily_red_maxvol -- 个人单日单户赎回份额上限
            ,ta_code -- TA代码
            ,yield -- 七日年化收益率
            ,income_unit -- 万份收益
            ,prd_type -- 产品类型:1-基金
            ,remark1 -- 备用字段1
            ,remark2 -- 备用字段2
            ,remark3 -- 备用字段3
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,double1 -- 扩展浮点数1
            ,double2 -- 备用double2
            ,double3 -- 备用double3
            ,prd_flag -- 产品标志
            ,iss_date -- 发布日期
            ,nav_date -- 净值日期
            ,clt_rapid_pmaxvol -- 个人单日单户实时赎回金额
            ,daily_buy_pmaxvol -- 个人当日累计最大购买
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.prd_name, o.prd_name) as prd_name -- 产品名称
    ,nvl(n.prd_manager, o.prd_manager) as prd_manager -- 产品管理人代码
    ,nvl(n.manager_name, o.manager_name) as manager_name -- 产品管理人姓名
    ,nvl(n.nav, o.nav) as nav -- 单位净值
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 风险级别:风险等级 [K_KHFXDJ] K_KHFXDJ	客户风险等级	0	未评定	0	0 K_KHFXDJ	客户风险等级	1	低风险	0	0 K_KHFXDJ	客户风险等级	2	中低风险	0	0 K_KHFXDJ	客户风险等级	3	中风险	0	0 K_KHFXDJ	客户风险等级	4	中高风险	0	0 K_KHFXDJ	客户风险等级	5	高风险	0	0
    ,nvl(n.prd_status, o.prd_status) as prd_status -- 产品状态:确认日期的状态 *：准备期 0：认购期 1：正常开放 3：暂停赎回 4：暂停申购 5：暂停交易 6：基金终止 9：发行失败
    ,nvl(n.open_time, o.open_time) as open_time -- 开市时间
    ,nvl(n.close_time, o.close_time) as close_time -- 闭市时间
    ,nvl(n.pmax_accu_amt, o.pmax_accu_amt) as pmax_accu_amt -- 个人单户累计最大购买金额
    ,nvl(n.pdaily_red_maxvol, o.pdaily_red_maxvol) as pdaily_red_maxvol -- 个人单日单户赎回份额上限
    ,nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.yield, o.yield) as yield -- 七日年化收益率
    ,nvl(n.income_unit, o.income_unit) as income_unit -- 万份收益
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 产品类型:1-基金
    ,nvl(n.remark1, o.remark1) as remark1 -- 备用字段1
    ,nvl(n.remark2, o.remark2) as remark2 -- 备用字段2
    ,nvl(n.remark3, o.remark3) as remark3 -- 备用字段3
    ,nvl(n.integer1, o.integer1) as integer1 -- 备用整型1
    ,nvl(n.integer2, o.integer2) as integer2 -- 备用整型2
    ,nvl(n.double1, o.double1) as double1 -- 扩展浮点数1
    ,nvl(n.double2, o.double2) as double2 -- 备用double2
    ,nvl(n.double3, o.double3) as double3 -- 备用double3
    ,nvl(n.prd_flag, o.prd_flag) as prd_flag -- 产品标志
    ,nvl(n.iss_date, o.iss_date) as iss_date -- 发布日期
    ,nvl(n.nav_date, o.nav_date) as nav_date -- 净值日期
    ,nvl(n.clt_rapid_pmaxvol, o.clt_rapid_pmaxvol) as clt_rapid_pmaxvol -- 个人单日单户实时赎回金额
    ,nvl(n.daily_buy_pmaxvol, o.daily_buy_pmaxvol) as daily_buy_pmaxvol -- 个人当日累计最大购买
    ,case when
            n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbbaseproduct_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbbaseproduct where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_code = n.prd_code
where (
        o.prd_code is null
    )
    or (
        n.prd_code is null
    )
    or (
        o.prd_name <> n.prd_name
        or o.prd_manager <> n.prd_manager
        or o.manager_name <> n.manager_name
        or o.nav <> n.nav
        or o.risk_level <> n.risk_level
        or o.prd_status <> n.prd_status
        or o.open_time <> n.open_time
        or o.close_time <> n.close_time
        or o.pmax_accu_amt <> n.pmax_accu_amt
        or o.pdaily_red_maxvol <> n.pdaily_red_maxvol
        or o.ta_code <> n.ta_code
        or o.yield <> n.yield
        or o.income_unit <> n.income_unit
        or o.prd_type <> n.prd_type
        or o.remark1 <> n.remark1
        or o.remark2 <> n.remark2
        or o.remark3 <> n.remark3
        or o.integer1 <> n.integer1
        or o.integer2 <> n.integer2
        or o.double1 <> n.double1
        or o.double2 <> n.double2
        or o.double3 <> n.double3
        or o.prd_flag <> n.prd_flag
        or o.iss_date <> n.iss_date
        or o.nav_date <> n.nav_date
        or o.clt_rapid_pmaxvol <> n.clt_rapid_pmaxvol
        or o.daily_buy_pmaxvol <> n.daily_buy_pmaxvol
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbbaseproduct_cl(
            prd_code -- 产品代码
            ,prd_name -- 产品名称
            ,prd_manager -- 产品管理人代码
            ,manager_name -- 产品管理人姓名
            ,nav -- 单位净值
            ,risk_level -- 风险级别:风险等级 [K_KHFXDJ] K_KHFXDJ	客户风险等级	0	未评定	0	0 K_KHFXDJ	客户风险等级	1	低风险	0	0 K_KHFXDJ	客户风险等级	2	中低风险	0	0 K_KHFXDJ	客户风险等级	3	中风险	0	0 K_KHFXDJ	客户风险等级	4	中高风险	0	0 K_KHFXDJ	客户风险等级	5	高风险	0	0
            ,prd_status -- 产品状态:确认日期的状态 *：准备期 0：认购期 1：正常开放 3：暂停赎回 4：暂停申购 5：暂停交易 6：基金终止 9：发行失败
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,pmax_accu_amt -- 个人单户累计最大购买金额
            ,pdaily_red_maxvol -- 个人单日单户赎回份额上限
            ,ta_code -- TA代码
            ,yield -- 七日年化收益率
            ,income_unit -- 万份收益
            ,prd_type -- 产品类型:1-基金
            ,remark1 -- 备用字段1
            ,remark2 -- 备用字段2
            ,remark3 -- 备用字段3
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,double1 -- 扩展浮点数1
            ,double2 -- 备用double2
            ,double3 -- 备用double3
            ,prd_flag -- 产品标志
            ,iss_date -- 发布日期
            ,nav_date -- 净值日期
            ,clt_rapid_pmaxvol -- 个人单日单户实时赎回金额
            ,daily_buy_pmaxvol -- 个人当日累计最大购买
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbbaseproduct_op(
            prd_code -- 产品代码
            ,prd_name -- 产品名称
            ,prd_manager -- 产品管理人代码
            ,manager_name -- 产品管理人姓名
            ,nav -- 单位净值
            ,risk_level -- 风险级别:风险等级 [K_KHFXDJ] K_KHFXDJ	客户风险等级	0	未评定	0	0 K_KHFXDJ	客户风险等级	1	低风险	0	0 K_KHFXDJ	客户风险等级	2	中低风险	0	0 K_KHFXDJ	客户风险等级	3	中风险	0	0 K_KHFXDJ	客户风险等级	4	中高风险	0	0 K_KHFXDJ	客户风险等级	5	高风险	0	0
            ,prd_status -- 产品状态:确认日期的状态 *：准备期 0：认购期 1：正常开放 3：暂停赎回 4：暂停申购 5：暂停交易 6：基金终止 9：发行失败
            ,open_time -- 开市时间
            ,close_time -- 闭市时间
            ,pmax_accu_amt -- 个人单户累计最大购买金额
            ,pdaily_red_maxvol -- 个人单日单户赎回份额上限
            ,ta_code -- TA代码
            ,yield -- 七日年化收益率
            ,income_unit -- 万份收益
            ,prd_type -- 产品类型:1-基金
            ,remark1 -- 备用字段1
            ,remark2 -- 备用字段2
            ,remark3 -- 备用字段3
            ,integer1 -- 备用整型1
            ,integer2 -- 备用整型2
            ,double1 -- 扩展浮点数1
            ,double2 -- 备用double2
            ,double3 -- 备用double3
            ,prd_flag -- 产品标志
            ,iss_date -- 发布日期
            ,nav_date -- 净值日期
            ,clt_rapid_pmaxvol -- 个人单日单户实时赎回金额
            ,daily_buy_pmaxvol -- 个人当日累计最大购买
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prd_code -- 产品代码
    ,o.prd_name -- 产品名称
    ,o.prd_manager -- 产品管理人代码
    ,o.manager_name -- 产品管理人姓名
    ,o.nav -- 单位净值
    ,o.risk_level -- 风险级别:风险等级 [K_KHFXDJ] K_KHFXDJ	客户风险等级	0	未评定	0	0 K_KHFXDJ	客户风险等级	1	低风险	0	0 K_KHFXDJ	客户风险等级	2	中低风险	0	0 K_KHFXDJ	客户风险等级	3	中风险	0	0 K_KHFXDJ	客户风险等级	4	中高风险	0	0 K_KHFXDJ	客户风险等级	5	高风险	0	0
    ,o.prd_status -- 产品状态:确认日期的状态 *：准备期 0：认购期 1：正常开放 3：暂停赎回 4：暂停申购 5：暂停交易 6：基金终止 9：发行失败
    ,o.open_time -- 开市时间
    ,o.close_time -- 闭市时间
    ,o.pmax_accu_amt -- 个人单户累计最大购买金额
    ,o.pdaily_red_maxvol -- 个人单日单户赎回份额上限
    ,o.ta_code -- TA代码
    ,o.yield -- 七日年化收益率
    ,o.income_unit -- 万份收益
    ,o.prd_type -- 产品类型:1-基金
    ,o.remark1 -- 备用字段1
    ,o.remark2 -- 备用字段2
    ,o.remark3 -- 备用字段3
    ,o.integer1 -- 备用整型1
    ,o.integer2 -- 备用整型2
    ,o.double1 -- 扩展浮点数1
    ,o.double2 -- 备用double2
    ,o.double3 -- 备用double3
    ,o.prd_flag -- 产品标志
    ,o.iss_date -- 发布日期
    ,o.nav_date -- 净值日期
    ,o.clt_rapid_pmaxvol -- 个人单日单户实时赎回金额
    ,o.daily_buy_pmaxvol -- 个人当日累计最大购买
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
from ${iol_schema}.nfss_tbbaseproduct_bk o
    left join ${iol_schema}.nfss_tbbaseproduct_op n
        on
            o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbbaseproduct_cl d
        on
            o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nfss_tbbaseproduct;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nfss_tbbaseproduct') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nfss_tbbaseproduct drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nfss_tbbaseproduct add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nfss_tbbaseproduct exchange partition p_${batch_date} with table ${iol_schema}.nfss_tbbaseproduct_cl;
alter table ${iol_schema}.nfss_tbbaseproduct exchange partition p_20991231 with table ${iol_schema}.nfss_tbbaseproduct_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbbaseproduct to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbbaseproduct_op purge;
drop table ${iol_schema}.nfss_tbbaseproduct_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbbaseproduct_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbbaseproduct',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
