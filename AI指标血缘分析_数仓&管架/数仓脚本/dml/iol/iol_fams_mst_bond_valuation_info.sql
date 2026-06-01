/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_mst_bond_valuation_info
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
create table ${iol_schema}.fams_mst_bond_valuation_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_mst_bond_valuation_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_bond_valuation_info_op purge;
drop table ${iol_schema}.fams_mst_bond_valuation_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_bond_valuation_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_bond_valuation_info where 0=1;

create table ${iol_schema}.fams_mst_bond_valuation_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_bond_valuation_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_mst_bond_valuation_info_cl(
            sec_id -- 债券代码，市场代码
            ,value_date -- 估值日
            ,value_source -- 估值来源，中债、中证等
            ,last_period -- 剩余期限
            ,price -- 市价全价
            ,netprice -- 市价净价
            ,m_duration -- 市价久期
            ,m_convexity -- 市价凸性
            ,bpvalue -- 基点价值
            ,sduration -- 利差久期
            ,scnvxty -- 利差凸性
            ,interest_duration -- 利率久期
            ,interest_cnvxty -- 利率凸性
            ,bpyield -- 市价收益率
            ,input_type -- 录入方式，接口、手工等
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,mbpvalue -- 估价基点价值
            ,var -- 风险价值
            ,cvar -- 条件风险价值
            ,mduration -- 麦考利久期
            ,implicit_grade -- 市价隐含评级（中债）
            ,implicit_hgrade -- 市价历史隐含评级（中债）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_mst_bond_valuation_info_op(
            sec_id -- 债券代码，市场代码
            ,value_date -- 估值日
            ,value_source -- 估值来源，中债、中证等
            ,last_period -- 剩余期限
            ,price -- 市价全价
            ,netprice -- 市价净价
            ,m_duration -- 市价久期
            ,m_convexity -- 市价凸性
            ,bpvalue -- 基点价值
            ,sduration -- 利差久期
            ,scnvxty -- 利差凸性
            ,interest_duration -- 利率久期
            ,interest_cnvxty -- 利率凸性
            ,bpyield -- 市价收益率
            ,input_type -- 录入方式，接口、手工等
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,mbpvalue -- 估价基点价值
            ,var -- 风险价值
            ,cvar -- 条件风险价值
            ,mduration -- 麦考利久期
            ,implicit_grade -- 市价隐含评级（中债）
            ,implicit_hgrade -- 市价历史隐含评级（中债）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sec_id, o.sec_id) as sec_id -- 债券代码，市场代码
    ,nvl(n.value_date, o.value_date) as value_date -- 估值日
    ,nvl(n.value_source, o.value_source) as value_source -- 估值来源，中债、中证等
    ,nvl(n.last_period, o.last_period) as last_period -- 剩余期限
    ,nvl(n.price, o.price) as price -- 市价全价
    ,nvl(n.netprice, o.netprice) as netprice -- 市价净价
    ,nvl(n.m_duration, o.m_duration) as m_duration -- 市价久期
    ,nvl(n.m_convexity, o.m_convexity) as m_convexity -- 市价凸性
    ,nvl(n.bpvalue, o.bpvalue) as bpvalue -- 基点价值
    ,nvl(n.sduration, o.sduration) as sduration -- 利差久期
    ,nvl(n.scnvxty, o.scnvxty) as scnvxty -- 利差凸性
    ,nvl(n.interest_duration, o.interest_duration) as interest_duration -- 利率久期
    ,nvl(n.interest_cnvxty, o.interest_cnvxty) as interest_cnvxty -- 利率凸性
    ,nvl(n.bpyield, o.bpyield) as bpyield -- 市价收益率
    ,nvl(n.input_type, o.input_type) as input_type -- 录入方式，接口、手工等
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.mbpvalue, o.mbpvalue) as mbpvalue -- 估价基点价值
    ,nvl(n.var, o.var) as var -- 风险价值
    ,nvl(n.cvar, o.cvar) as cvar -- 条件风险价值
    ,nvl(n.mduration, o.mduration) as mduration -- 麦考利久期
    ,nvl(n.implicit_grade, o.implicit_grade) as implicit_grade -- 市价隐含评级（中债）
    ,nvl(n.implicit_hgrade, o.implicit_hgrade) as implicit_hgrade -- 市价历史隐含评级（中债）
    ,case when
            n.sec_id is null
            and n.value_date is null
            and n.value_source is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sec_id is null
            and n.value_date is null
            and n.value_source is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sec_id is null
            and n.value_date is null
            and n.value_source is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_mst_bond_valuation_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_mst_bond_valuation_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sec_id = n.sec_id
            and o.value_date = n.value_date
            and o.value_source = n.value_source
where (
        o.sec_id is null
        and o.value_date is null
        and o.value_source is null
    )
    or (
        n.sec_id is null
        and n.value_date is null
        and n.value_source is null
    )
    or (
        o.last_period <> n.last_period
        or o.price <> n.price
        or o.netprice <> n.netprice
        or o.m_duration <> n.m_duration
        or o.m_convexity <> n.m_convexity
        or o.bpvalue <> n.bpvalue
        or o.sduration <> n.sduration
        or o.scnvxty <> n.scnvxty
        or o.interest_duration <> n.interest_duration
        or o.interest_cnvxty <> n.interest_cnvxty
        or o.bpyield <> n.bpyield
        or o.input_type <> n.input_type
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.mbpvalue <> n.mbpvalue
        or o.var <> n.var
        or o.cvar <> n.cvar
        or o.mduration <> n.mduration
        or o.implicit_grade <> n.implicit_grade
        or o.implicit_hgrade <> n.implicit_hgrade
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_mst_bond_valuation_info_cl(
            sec_id -- 债券代码，市场代码
            ,value_date -- 估值日
            ,value_source -- 估值来源，中债、中证等
            ,last_period -- 剩余期限
            ,price -- 市价全价
            ,netprice -- 市价净价
            ,m_duration -- 市价久期
            ,m_convexity -- 市价凸性
            ,bpvalue -- 基点价值
            ,sduration -- 利差久期
            ,scnvxty -- 利差凸性
            ,interest_duration -- 利率久期
            ,interest_cnvxty -- 利率凸性
            ,bpyield -- 市价收益率
            ,input_type -- 录入方式，接口、手工等
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,mbpvalue -- 估价基点价值
            ,var -- 风险价值
            ,cvar -- 条件风险价值
            ,mduration -- 麦考利久期
            ,implicit_grade -- 市价隐含评级（中债）
            ,implicit_hgrade -- 市价历史隐含评级（中债）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_mst_bond_valuation_info_op(
            sec_id -- 债券代码，市场代码
            ,value_date -- 估值日
            ,value_source -- 估值来源，中债、中证等
            ,last_period -- 剩余期限
            ,price -- 市价全价
            ,netprice -- 市价净价
            ,m_duration -- 市价久期
            ,m_convexity -- 市价凸性
            ,bpvalue -- 基点价值
            ,sduration -- 利差久期
            ,scnvxty -- 利差凸性
            ,interest_duration -- 利率久期
            ,interest_cnvxty -- 利率凸性
            ,bpyield -- 市价收益率
            ,input_type -- 录入方式，接口、手工等
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,mbpvalue -- 估价基点价值
            ,var -- 风险价值
            ,cvar -- 条件风险价值
            ,mduration -- 麦考利久期
            ,implicit_grade -- 市价隐含评级（中债）
            ,implicit_hgrade -- 市价历史隐含评级（中债）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sec_id -- 债券代码，市场代码
    ,o.value_date -- 估值日
    ,o.value_source -- 估值来源，中债、中证等
    ,o.last_period -- 剩余期限
    ,o.price -- 市价全价
    ,o.netprice -- 市价净价
    ,o.m_duration -- 市价久期
    ,o.m_convexity -- 市价凸性
    ,o.bpvalue -- 基点价值
    ,o.sduration -- 利差久期
    ,o.scnvxty -- 利差凸性
    ,o.interest_duration -- 利率久期
    ,o.interest_cnvxty -- 利率凸性
    ,o.bpyield -- 市价收益率
    ,o.input_type -- 录入方式，接口、手工等
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.mbpvalue -- 估价基点价值
    ,o.var -- 风险价值
    ,o.cvar -- 条件风险价值
    ,o.mduration -- 麦考利久期
    ,o.implicit_grade -- 市价隐含评级（中债）
    ,o.implicit_hgrade -- 市价历史隐含评级（中债）
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
from ${iol_schema}.fams_mst_bond_valuation_info_bk o
    left join ${iol_schema}.fams_mst_bond_valuation_info_op n
        on
            o.sec_id = n.sec_id
            and o.value_date = n.value_date
            and o.value_source = n.value_source
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_mst_bond_valuation_info_cl d
        on
            o.sec_id = d.sec_id
            and o.value_date = d.value_date
            and o.value_source = d.value_source
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_mst_bond_valuation_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_mst_bond_valuation_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_mst_bond_valuation_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_mst_bond_valuation_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_mst_bond_valuation_info exchange partition p_${batch_date} with table ${iol_schema}.fams_mst_bond_valuation_info_cl;
alter table ${iol_schema}.fams_mst_bond_valuation_info exchange partition p_20991231 with table ${iol_schema}.fams_mst_bond_valuation_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_mst_bond_valuation_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_bond_valuation_info_op purge;
drop table ${iol_schema}.fams_mst_bond_valuation_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_mst_bond_valuation_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_mst_bond_valuation_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
