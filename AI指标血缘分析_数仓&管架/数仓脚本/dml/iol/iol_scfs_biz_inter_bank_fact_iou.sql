/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scfs_biz_inter_bank_fact_iou
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
create table ${iol_schema}.scfs_biz_inter_bank_fact_iou_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scfs_biz_inter_bank_fact_iou
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_iou_op purge;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_iou_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scfs_biz_inter_bank_fact_iou_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scfs_biz_inter_bank_fact_iou where 0=1;

create table ${iol_schema}.scfs_biz_inter_bank_fact_iou_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scfs_biz_inter_bank_fact_iou where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scfs_biz_inter_bank_fact_iou_cl(
            id -- 主键id
            ,bank_fact_id -- 跨行再保理编号
            ,fnc_jrnl_id -- 融资申请编号
            ,iou_id -- 借据号
            ,pd_id -- 产品编号
            ,pd_nm -- 产品名称
            ,cst_id -- 客户编号
            ,cst_nm -- 客户名称
            ,ths_fnc_amt -- 融资金额
            ,fnc_bg_dt -- 融资起始日期
            ,fnc_ex_dt -- 融资结束日期
            ,st_cd -- 生效状态
            ,tenant_id -- 租户id
            ,create_time -- 创建时间
            ,create_user -- 创建人
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,version -- 版本号
            ,del_ind -- 删除标志
            ,iou_bay_out_net_amt -- 转让净价
            ,iou_sell_interest -- 卖出利息
            ,iou_fee_amt -- 卖出手续费
            ,iou_exchange_amt -- 转让对价
            ,iou_sell_org -- 卖出机构
            ,expd_id -- 扩展编号
            ,fnc_dt -- 融资日期
            ,maturity -- 融资到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scfs_biz_inter_bank_fact_iou_op(
            id -- 主键id
            ,bank_fact_id -- 跨行再保理编号
            ,fnc_jrnl_id -- 融资申请编号
            ,iou_id -- 借据号
            ,pd_id -- 产品编号
            ,pd_nm -- 产品名称
            ,cst_id -- 客户编号
            ,cst_nm -- 客户名称
            ,ths_fnc_amt -- 融资金额
            ,fnc_bg_dt -- 融资起始日期
            ,fnc_ex_dt -- 融资结束日期
            ,st_cd -- 生效状态
            ,tenant_id -- 租户id
            ,create_time -- 创建时间
            ,create_user -- 创建人
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,version -- 版本号
            ,del_ind -- 删除标志
            ,iou_bay_out_net_amt -- 转让净价
            ,iou_sell_interest -- 卖出利息
            ,iou_fee_amt -- 卖出手续费
            ,iou_exchange_amt -- 转让对价
            ,iou_sell_org -- 卖出机构
            ,expd_id -- 扩展编号
            ,fnc_dt -- 融资日期
            ,maturity -- 融资到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键id
    ,nvl(n.bank_fact_id, o.bank_fact_id) as bank_fact_id -- 跨行再保理编号
    ,nvl(n.fnc_jrnl_id, o.fnc_jrnl_id) as fnc_jrnl_id -- 融资申请编号
    ,nvl(n.iou_id, o.iou_id) as iou_id -- 借据号
    ,nvl(n.pd_id, o.pd_id) as pd_id -- 产品编号
    ,nvl(n.pd_nm, o.pd_nm) as pd_nm -- 产品名称
    ,nvl(n.cst_id, o.cst_id) as cst_id -- 客户编号
    ,nvl(n.cst_nm, o.cst_nm) as cst_nm -- 客户名称
    ,nvl(n.ths_fnc_amt, o.ths_fnc_amt) as ths_fnc_amt -- 融资金额
    ,nvl(n.fnc_bg_dt, o.fnc_bg_dt) as fnc_bg_dt -- 融资起始日期
    ,nvl(n.fnc_ex_dt, o.fnc_ex_dt) as fnc_ex_dt -- 融资结束日期
    ,nvl(n.st_cd, o.st_cd) as st_cd -- 生效状态
    ,nvl(n.tenant_id, o.tenant_id) as tenant_id -- 租户id
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.version, o.version) as version -- 版本号
    ,nvl(n.del_ind, o.del_ind) as del_ind -- 删除标志
    ,nvl(n.iou_bay_out_net_amt, o.iou_bay_out_net_amt) as iou_bay_out_net_amt -- 转让净价
    ,nvl(n.iou_sell_interest, o.iou_sell_interest) as iou_sell_interest -- 卖出利息
    ,nvl(n.iou_fee_amt, o.iou_fee_amt) as iou_fee_amt -- 卖出手续费
    ,nvl(n.iou_exchange_amt, o.iou_exchange_amt) as iou_exchange_amt -- 转让对价
    ,nvl(n.iou_sell_org, o.iou_sell_org) as iou_sell_org -- 卖出机构
    ,nvl(n.expd_id, o.expd_id) as expd_id -- 扩展编号
    ,nvl(n.fnc_dt, o.fnc_dt) as fnc_dt -- 融资日期
    ,nvl(n.maturity, o.maturity) as maturity -- 融资到期日
    ,case when
            n.id is null
            and n.version is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
            and n.version is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
            and n.version is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scfs_biz_inter_bank_fact_iou_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scfs_biz_inter_bank_fact_iou where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
            and o.version = n.version
where (
        o.id is null
        and o.version is null
    )
    or (
        n.id is null
        and n.version is null
    )
    or (
        o.bank_fact_id <> n.bank_fact_id
        or o.fnc_jrnl_id <> n.fnc_jrnl_id
        or o.iou_id <> n.iou_id
        or o.pd_id <> n.pd_id
        or o.pd_nm <> n.pd_nm
        or o.cst_id <> n.cst_id
        or o.cst_nm <> n.cst_nm
        or o.ths_fnc_amt <> n.ths_fnc_amt
        or o.fnc_bg_dt <> n.fnc_bg_dt
        or o.fnc_ex_dt <> n.fnc_ex_dt
        or o.st_cd <> n.st_cd
        or o.tenant_id <> n.tenant_id
        or o.create_time <> n.create_time
        or o.create_user <> n.create_user
        or o.update_time <> n.update_time
        or o.update_user <> n.update_user
        or o.del_ind <> n.del_ind
        or o.iou_bay_out_net_amt <> n.iou_bay_out_net_amt
        or o.iou_sell_interest <> n.iou_sell_interest
        or o.iou_fee_amt <> n.iou_fee_amt
        or o.iou_exchange_amt <> n.iou_exchange_amt
        or o.iou_sell_org <> n.iou_sell_org
        or o.expd_id <> n.expd_id
        or o.fnc_dt <> n.fnc_dt
        or o.maturity <> n.maturity
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scfs_biz_inter_bank_fact_iou_cl(
            id -- 主键id
            ,bank_fact_id -- 跨行再保理编号
            ,fnc_jrnl_id -- 融资申请编号
            ,iou_id -- 借据号
            ,pd_id -- 产品编号
            ,pd_nm -- 产品名称
            ,cst_id -- 客户编号
            ,cst_nm -- 客户名称
            ,ths_fnc_amt -- 融资金额
            ,fnc_bg_dt -- 融资起始日期
            ,fnc_ex_dt -- 融资结束日期
            ,st_cd -- 生效状态
            ,tenant_id -- 租户id
            ,create_time -- 创建时间
            ,create_user -- 创建人
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,version -- 版本号
            ,del_ind -- 删除标志
            ,iou_bay_out_net_amt -- 转让净价
            ,iou_sell_interest -- 卖出利息
            ,iou_fee_amt -- 卖出手续费
            ,iou_exchange_amt -- 转让对价
            ,iou_sell_org -- 卖出机构
            ,expd_id -- 扩展编号
            ,fnc_dt -- 融资日期
            ,maturity -- 融资到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scfs_biz_inter_bank_fact_iou_op(
            id -- 主键id
            ,bank_fact_id -- 跨行再保理编号
            ,fnc_jrnl_id -- 融资申请编号
            ,iou_id -- 借据号
            ,pd_id -- 产品编号
            ,pd_nm -- 产品名称
            ,cst_id -- 客户编号
            ,cst_nm -- 客户名称
            ,ths_fnc_amt -- 融资金额
            ,fnc_bg_dt -- 融资起始日期
            ,fnc_ex_dt -- 融资结束日期
            ,st_cd -- 生效状态
            ,tenant_id -- 租户id
            ,create_time -- 创建时间
            ,create_user -- 创建人
            ,update_time -- 更新时间
            ,update_user -- 更新人
            ,version -- 版本号
            ,del_ind -- 删除标志
            ,iou_bay_out_net_amt -- 转让净价
            ,iou_sell_interest -- 卖出利息
            ,iou_fee_amt -- 卖出手续费
            ,iou_exchange_amt -- 转让对价
            ,iou_sell_org -- 卖出机构
            ,expd_id -- 扩展编号
            ,fnc_dt -- 融资日期
            ,maturity -- 融资到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键id
    ,o.bank_fact_id -- 跨行再保理编号
    ,o.fnc_jrnl_id -- 融资申请编号
    ,o.iou_id -- 借据号
    ,o.pd_id -- 产品编号
    ,o.pd_nm -- 产品名称
    ,o.cst_id -- 客户编号
    ,o.cst_nm -- 客户名称
    ,o.ths_fnc_amt -- 融资金额
    ,o.fnc_bg_dt -- 融资起始日期
    ,o.fnc_ex_dt -- 融资结束日期
    ,o.st_cd -- 生效状态
    ,o.tenant_id -- 租户id
    ,o.create_time -- 创建时间
    ,o.create_user -- 创建人
    ,o.update_time -- 更新时间
    ,o.update_user -- 更新人
    ,o.version -- 版本号
    ,o.del_ind -- 删除标志
    ,o.iou_bay_out_net_amt -- 转让净价
    ,o.iou_sell_interest -- 卖出利息
    ,o.iou_fee_amt -- 卖出手续费
    ,o.iou_exchange_amt -- 转让对价
    ,o.iou_sell_org -- 卖出机构
    ,o.expd_id -- 扩展编号
    ,o.fnc_dt -- 融资日期
    ,o.maturity -- 融资到期日
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
from ${iol_schema}.scfs_biz_inter_bank_fact_iou_bk o
    left join ${iol_schema}.scfs_biz_inter_bank_fact_iou_op n
        on
            o.id = n.id
            and o.version = n.version
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scfs_biz_inter_bank_fact_iou_cl d
        on
            o.id = d.id
            and o.version = d.version
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scfs_biz_inter_bank_fact_iou;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scfs_biz_inter_bank_fact_iou') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scfs_biz_inter_bank_fact_iou drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scfs_biz_inter_bank_fact_iou add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scfs_biz_inter_bank_fact_iou exchange partition p_${batch_date} with table ${iol_schema}.scfs_biz_inter_bank_fact_iou_cl;
alter table ${iol_schema}.scfs_biz_inter_bank_fact_iou exchange partition p_20991231 with table ${iol_schema}.scfs_biz_inter_bank_fact_iou_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scfs_biz_inter_bank_fact_iou to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_iou_op purge;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_iou_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scfs_biz_inter_bank_fact_iou_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scfs_biz_inter_bank_fact_iou',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
