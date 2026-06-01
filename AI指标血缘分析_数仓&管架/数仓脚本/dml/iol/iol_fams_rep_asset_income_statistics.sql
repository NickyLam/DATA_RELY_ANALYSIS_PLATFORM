/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_rep_asset_income_statistics
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
create table ${iol_schema}.fams_rep_asset_income_statistics_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_rep_asset_income_statistics
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_rep_asset_income_statistics_op purge;
drop table ${iol_schema}.fams_rep_asset_income_statistics_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_rep_asset_income_statistics_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_rep_asset_income_statistics where 0=1;

create table ${iol_schema}.fams_rep_asset_income_statistics_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_rep_asset_income_statistics where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_rep_asset_income_statistics_cl(
            cdate -- 日期
            ,assetcode -- 资产编码
            ,assetname -- 资产名称
            ,vdate -- 资产起息日
            ,mdate -- 资产到期日
            ,cmdate -- 负债到期日
            ,basis_name -- 计息基础
            ,issue_amt -- 初始发行金额
            ,position -- 存续金额
            ,custrate -- 资产收益率%
            ,ratio_rate -- 分行分成比例%
            ,capital_rate -- 资金成本
            ,debt_cost -- 负债成本
            ,share_amt_pre_tax -- 分行分成金额
            ,share_amt -- 分行分成金额-税后
            ,adjust_amt_pre_tax -- 调整分成金额
            ,adjust_amt -- 调整分成金额-税后
            ,share_amount_pre_tax -- 分行分成合计
            ,share_amount -- 分行分成合计-税后
            ,org_code -- 机构代码
            ,org_name -- 机构名称
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_rep_asset_income_statistics_op(
            cdate -- 日期
            ,assetcode -- 资产编码
            ,assetname -- 资产名称
            ,vdate -- 资产起息日
            ,mdate -- 资产到期日
            ,cmdate -- 负债到期日
            ,basis_name -- 计息基础
            ,issue_amt -- 初始发行金额
            ,position -- 存续金额
            ,custrate -- 资产收益率%
            ,ratio_rate -- 分行分成比例%
            ,capital_rate -- 资金成本
            ,debt_cost -- 负债成本
            ,share_amt_pre_tax -- 分行分成金额
            ,share_amt -- 分行分成金额-税后
            ,adjust_amt_pre_tax -- 调整分成金额
            ,adjust_amt -- 调整分成金额-税后
            ,share_amount_pre_tax -- 分行分成合计
            ,share_amount -- 分行分成合计-税后
            ,org_code -- 机构代码
            ,org_name -- 机构名称
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cdate, o.cdate) as cdate -- 日期
    ,nvl(n.assetcode, o.assetcode) as assetcode -- 资产编码
    ,nvl(n.assetname, o.assetname) as assetname -- 资产名称
    ,nvl(n.vdate, o.vdate) as vdate -- 资产起息日
    ,nvl(n.mdate, o.mdate) as mdate -- 资产到期日
    ,nvl(n.cmdate, o.cmdate) as cmdate -- 负债到期日
    ,nvl(n.basis_name, o.basis_name) as basis_name -- 计息基础
    ,nvl(n.issue_amt, o.issue_amt) as issue_amt -- 初始发行金额
    ,nvl(n.position, o.position) as position -- 存续金额
    ,nvl(n.custrate, o.custrate) as custrate -- 资产收益率%
    ,nvl(n.ratio_rate, o.ratio_rate) as ratio_rate -- 分行分成比例%
    ,nvl(n.capital_rate, o.capital_rate) as capital_rate -- 资金成本
    ,nvl(n.debt_cost, o.debt_cost) as debt_cost -- 负债成本
    ,nvl(n.share_amt_pre_tax, o.share_amt_pre_tax) as share_amt_pre_tax -- 分行分成金额
    ,nvl(n.share_amt, o.share_amt) as share_amt -- 分行分成金额-税后
    ,nvl(n.adjust_amt_pre_tax, o.adjust_amt_pre_tax) as adjust_amt_pre_tax -- 调整分成金额
    ,nvl(n.adjust_amt, o.adjust_amt) as adjust_amt -- 调整分成金额-税后
    ,nvl(n.share_amount_pre_tax, o.share_amount_pre_tax) as share_amount_pre_tax -- 分行分成合计
    ,nvl(n.share_amount, o.share_amount) as share_amount -- 分行分成合计-税后
    ,nvl(n.org_code, o.org_code) as org_code -- 机构代码
    ,nvl(n.org_name, o.org_name) as org_name -- 机构名称
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.cdate is null
            and n.assetcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cdate is null
            and n.assetcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cdate is null
            and n.assetcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_rep_asset_income_statistics_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_rep_asset_income_statistics where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cdate = n.cdate
            and o.assetcode = n.assetcode
where (
        o.cdate is null
        and o.assetcode is null
    )
    or (
        n.cdate is null
        and n.assetcode is null
    )
    or (
        o.assetname <> n.assetname
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.cmdate <> n.cmdate
        or o.basis_name <> n.basis_name
        or o.issue_amt <> n.issue_amt
        or o.position <> n.position
        or o.custrate <> n.custrate
        or o.ratio_rate <> n.ratio_rate
        or o.capital_rate <> n.capital_rate
        or o.debt_cost <> n.debt_cost
        or o.share_amt_pre_tax <> n.share_amt_pre_tax
        or o.share_amt <> n.share_amt
        or o.adjust_amt_pre_tax <> n.adjust_amt_pre_tax
        or o.adjust_amt <> n.adjust_amt
        or o.share_amount_pre_tax <> n.share_amount_pre_tax
        or o.share_amount <> n.share_amount
        or o.org_code <> n.org_code
        or o.org_name <> n.org_name
        or o.remark <> n.remark
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_rep_asset_income_statistics_cl(
            cdate -- 日期
            ,assetcode -- 资产编码
            ,assetname -- 资产名称
            ,vdate -- 资产起息日
            ,mdate -- 资产到期日
            ,cmdate -- 负债到期日
            ,basis_name -- 计息基础
            ,issue_amt -- 初始发行金额
            ,position -- 存续金额
            ,custrate -- 资产收益率%
            ,ratio_rate -- 分行分成比例%
            ,capital_rate -- 资金成本
            ,debt_cost -- 负债成本
            ,share_amt_pre_tax -- 分行分成金额
            ,share_amt -- 分行分成金额-税后
            ,adjust_amt_pre_tax -- 调整分成金额
            ,adjust_amt -- 调整分成金额-税后
            ,share_amount_pre_tax -- 分行分成合计
            ,share_amount -- 分行分成合计-税后
            ,org_code -- 机构代码
            ,org_name -- 机构名称
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_rep_asset_income_statistics_op(
            cdate -- 日期
            ,assetcode -- 资产编码
            ,assetname -- 资产名称
            ,vdate -- 资产起息日
            ,mdate -- 资产到期日
            ,cmdate -- 负债到期日
            ,basis_name -- 计息基础
            ,issue_amt -- 初始发行金额
            ,position -- 存续金额
            ,custrate -- 资产收益率%
            ,ratio_rate -- 分行分成比例%
            ,capital_rate -- 资金成本
            ,debt_cost -- 负债成本
            ,share_amt_pre_tax -- 分行分成金额
            ,share_amt -- 分行分成金额-税后
            ,adjust_amt_pre_tax -- 调整分成金额
            ,adjust_amt -- 调整分成金额-税后
            ,share_amount_pre_tax -- 分行分成合计
            ,share_amount -- 分行分成合计-税后
            ,org_code -- 机构代码
            ,org_name -- 机构名称
            ,remark -- 备注
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cdate -- 日期
    ,o.assetcode -- 资产编码
    ,o.assetname -- 资产名称
    ,o.vdate -- 资产起息日
    ,o.mdate -- 资产到期日
    ,o.cmdate -- 负债到期日
    ,o.basis_name -- 计息基础
    ,o.issue_amt -- 初始发行金额
    ,o.position -- 存续金额
    ,o.custrate -- 资产收益率%
    ,o.ratio_rate -- 分行分成比例%
    ,o.capital_rate -- 资金成本
    ,o.debt_cost -- 负债成本
    ,o.share_amt_pre_tax -- 分行分成金额
    ,o.share_amt -- 分行分成金额-税后
    ,o.adjust_amt_pre_tax -- 调整分成金额
    ,o.adjust_amt -- 调整分成金额-税后
    ,o.share_amount_pre_tax -- 分行分成合计
    ,o.share_amount -- 分行分成合计-税后
    ,o.org_code -- 机构代码
    ,o.org_name -- 机构名称
    ,o.remark -- 备注
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
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
from ${iol_schema}.fams_rep_asset_income_statistics_bk o
    left join ${iol_schema}.fams_rep_asset_income_statistics_op n
        on
            o.cdate = n.cdate
            and o.assetcode = n.assetcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_rep_asset_income_statistics_cl d
        on
            o.cdate = d.cdate
            and o.assetcode = d.assetcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_rep_asset_income_statistics;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_rep_asset_income_statistics') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_rep_asset_income_statistics drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_rep_asset_income_statistics add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_rep_asset_income_statistics exchange partition p_${batch_date} with table ${iol_schema}.fams_rep_asset_income_statistics_cl;
alter table ${iol_schema}.fams_rep_asset_income_statistics exchange partition p_20991231 with table ${iol_schema}.fams_rep_asset_income_statistics_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_rep_asset_income_statistics to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_rep_asset_income_statistics_op purge;
drop table ${iol_schema}.fams_rep_asset_income_statistics_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_rep_asset_income_statistics_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_rep_asset_income_statistics',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
