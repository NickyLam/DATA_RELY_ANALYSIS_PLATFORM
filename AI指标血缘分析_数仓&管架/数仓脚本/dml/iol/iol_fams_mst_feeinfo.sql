/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_mst_feeinfo
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
create table ${iol_schema}.fams_mst_feeinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_mst_feeinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_feeinfo_op purge;
drop table ${iol_schema}.fams_mst_feeinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_feeinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_feeinfo where 0=1;

create table ${iol_schema}.fams_mst_feeinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_feeinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_mst_feeinfo_cl(
            fee_id -- 费用代码
            ,fee_name -- 费用名称
            ,apply_type -- 关联范围，产品、通道、其他
            ,fee_type -- 费用类型，托管费、管理费、增加附加税等
            ,basic_bill -- 计费基数，存续本金、资产规模
            ,basis -- 计息基准
            ,charge_type -- 收费类型，计提费用，不规则费用
            ,org_type -- 机构类型
            ,org_type2 -- 机构二级类型
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
        into ${iol_schema}.fams_mst_feeinfo_op(
            fee_id -- 费用代码
            ,fee_name -- 费用名称
            ,apply_type -- 关联范围，产品、通道、其他
            ,fee_type -- 费用类型，托管费、管理费、增加附加税等
            ,basic_bill -- 计费基数，存续本金、资产规模
            ,basis -- 计息基准
            ,charge_type -- 收费类型，计提费用，不规则费用
            ,org_type -- 机构类型
            ,org_type2 -- 机构二级类型
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
    nvl(n.fee_id, o.fee_id) as fee_id -- 费用代码
    ,nvl(n.fee_name, o.fee_name) as fee_name -- 费用名称
    ,nvl(n.apply_type, o.apply_type) as apply_type -- 关联范围，产品、通道、其他
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费用类型，托管费、管理费、增加附加税等
    ,nvl(n.basic_bill, o.basic_bill) as basic_bill -- 计费基数，存续本金、资产规模
    ,nvl(n.basis, o.basis) as basis -- 计息基准
    ,nvl(n.charge_type, o.charge_type) as charge_type -- 收费类型，计提费用，不规则费用
    ,nvl(n.org_type, o.org_type) as org_type -- 机构类型
    ,nvl(n.org_type2, o.org_type2) as org_type2 -- 机构二级类型
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.fee_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fee_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fee_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_mst_feeinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_mst_feeinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fee_id = n.fee_id
where (
        o.fee_id is null
    )
    or (
        n.fee_id is null
    )
    or (
        o.fee_name <> n.fee_name
        or o.apply_type <> n.apply_type
        or o.fee_type <> n.fee_type
        or o.basic_bill <> n.basic_bill
        or o.basis <> n.basis
        or o.charge_type <> n.charge_type
        or o.org_type <> n.org_type
        or o.org_type2 <> n.org_type2
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
        into ${iol_schema}.fams_mst_feeinfo_cl(
            fee_id -- 费用代码
            ,fee_name -- 费用名称
            ,apply_type -- 关联范围，产品、通道、其他
            ,fee_type -- 费用类型，托管费、管理费、增加附加税等
            ,basic_bill -- 计费基数，存续本金、资产规模
            ,basis -- 计息基准
            ,charge_type -- 收费类型，计提费用，不规则费用
            ,org_type -- 机构类型
            ,org_type2 -- 机构二级类型
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
        into ${iol_schema}.fams_mst_feeinfo_op(
            fee_id -- 费用代码
            ,fee_name -- 费用名称
            ,apply_type -- 关联范围，产品、通道、其他
            ,fee_type -- 费用类型，托管费、管理费、增加附加税等
            ,basic_bill -- 计费基数，存续本金、资产规模
            ,basis -- 计息基准
            ,charge_type -- 收费类型，计提费用，不规则费用
            ,org_type -- 机构类型
            ,org_type2 -- 机构二级类型
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
    o.fee_id -- 费用代码
    ,o.fee_name -- 费用名称
    ,o.apply_type -- 关联范围，产品、通道、其他
    ,o.fee_type -- 费用类型，托管费、管理费、增加附加税等
    ,o.basic_bill -- 计费基数，存续本金、资产规模
    ,o.basis -- 计息基准
    ,o.charge_type -- 收费类型，计提费用，不规则费用
    ,o.org_type -- 机构类型
    ,o.org_type2 -- 机构二级类型
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
from ${iol_schema}.fams_mst_feeinfo_bk o
    left join ${iol_schema}.fams_mst_feeinfo_op n
        on
            o.fee_id = n.fee_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_mst_feeinfo_cl d
        on
            o.fee_id = d.fee_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_mst_feeinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_mst_feeinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_mst_feeinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_mst_feeinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_mst_feeinfo exchange partition p_${batch_date} with table ${iol_schema}.fams_mst_feeinfo_cl;
alter table ${iol_schema}.fams_mst_feeinfo exchange partition p_20991231 with table ${iol_schema}.fams_mst_feeinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_mst_feeinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_feeinfo_op purge;
drop table ${iol_schema}.fams_mst_feeinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_mst_feeinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_mst_feeinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
