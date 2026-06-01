/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_prd_cl_control
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
create table ${iol_schema}.icms_prd_cl_control_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_prd_cl_control
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_cl_control_op purge;
drop table ${iol_schema}.icms_prd_cl_control_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_prd_cl_control_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_cl_control where 0=1;

create table ${iol_schema}.icms_prd_cl_control_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_prd_cl_control where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_cl_control_cl(
            productid -- 产品编号上层授信类型编号
            ,limitproductid -- 上层授信类型编号三
            ,corporgid -- 法人机构编号
            ,businessperiod -- 限制业务品种阶段
            ,message -- 检查提示语
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,occupyrole -- 占用角色
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,limitperiod -- 限制额度阶段	限制额度阶段
            ,inputorgid -- 登记机构
            ,priority -- 规则优先级
            ,serialno -- 流水号
            ,occupymod -- 占用上层授信模式
            ,inputuserid -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_cl_control_op(
            productid -- 产品编号上层授信类型编号
            ,limitproductid -- 上层授信类型编号三
            ,corporgid -- 法人机构编号
            ,businessperiod -- 限制业务品种阶段
            ,message -- 检查提示语
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,occupyrole -- 占用角色
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,limitperiod -- 限制额度阶段	限制额度阶段
            ,inputorgid -- 登记机构
            ,priority -- 规则优先级
            ,serialno -- 流水号
            ,occupymod -- 占用上层授信模式
            ,inputuserid -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.productid, o.productid) as productid -- 产品编号上层授信类型编号
    ,nvl(n.limitproductid, o.limitproductid) as limitproductid -- 上层授信类型编号三
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.businessperiod, o.businessperiod) as businessperiod -- 限制业务品种阶段
    ,nvl(n.message, o.message) as message -- 检查提示语
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.occupyrole, o.occupyrole) as occupyrole -- 占用角色
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.limitperiod, o.limitperiod) as limitperiod -- 限制额度阶段	限制额度阶段
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.priority, o.priority) as priority -- 规则优先级
    ,nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.occupymod, o.occupymod) as occupymod -- 占用上层授信模式
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,case when
            n.productid is null
            and n.limitproductid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.productid is null
            and n.limitproductid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.productid is null
            and n.limitproductid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_prd_cl_control_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_prd_cl_control where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.productid = n.productid
            and o.limitproductid = n.limitproductid
where (
        o.productid is null
        and o.limitproductid is null
    )
    or (
        n.productid is null
        and n.limitproductid is null
    )
    or (
        o.corporgid <> n.corporgid
        or o.businessperiod <> n.businessperiod
        or o.message <> n.message
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.occupyrole <> n.occupyrole
        or o.updateuserid <> n.updateuserid
        or o.updatedate <> n.updatedate
        or o.limitperiod <> n.limitperiod
        or o.inputorgid <> n.inputorgid
        or o.priority <> n.priority
        or o.serialno <> n.serialno
        or o.occupymod <> n.occupymod
        or o.inputuserid <> n.inputuserid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_prd_cl_control_cl(
            productid -- 产品编号上层授信类型编号
            ,limitproductid -- 上层授信类型编号三
            ,corporgid -- 法人机构编号
            ,businessperiod -- 限制业务品种阶段
            ,message -- 检查提示语
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,occupyrole -- 占用角色
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,limitperiod -- 限制额度阶段	限制额度阶段
            ,inputorgid -- 登记机构
            ,priority -- 规则优先级
            ,serialno -- 流水号
            ,occupymod -- 占用上层授信模式
            ,inputuserid -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_prd_cl_control_op(
            productid -- 产品编号上层授信类型编号
            ,limitproductid -- 上层授信类型编号三
            ,corporgid -- 法人机构编号
            ,businessperiod -- 限制业务品种阶段
            ,message -- 检查提示语
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,occupyrole -- 占用角色
            ,updateuserid -- 更新人
            ,updatedate -- 更新日期
            ,limitperiod -- 限制额度阶段	限制额度阶段
            ,inputorgid -- 登记机构
            ,priority -- 规则优先级
            ,serialno -- 流水号
            ,occupymod -- 占用上层授信模式
            ,inputuserid -- 登记人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.productid -- 产品编号上层授信类型编号
    ,o.limitproductid -- 上层授信类型编号三
    ,o.corporgid -- 法人机构编号
    ,o.businessperiod -- 限制业务品种阶段
    ,o.message -- 检查提示语
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.occupyrole -- 占用角色
    ,o.updateuserid -- 更新人
    ,o.updatedate -- 更新日期
    ,o.limitperiod -- 限制额度阶段	限制额度阶段
    ,o.inputorgid -- 登记机构
    ,o.priority -- 规则优先级
    ,o.serialno -- 流水号
    ,o.occupymod -- 占用上层授信模式
    ,o.inputuserid -- 登记人
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
from ${iol_schema}.icms_prd_cl_control_bk o
    left join ${iol_schema}.icms_prd_cl_control_op n
        on
            o.productid = n.productid
            and o.limitproductid = n.limitproductid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_prd_cl_control_cl d
        on
            o.productid = d.productid
            and o.limitproductid = d.limitproductid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_prd_cl_control;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_prd_cl_control') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_prd_cl_control drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_prd_cl_control add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_prd_cl_control exchange partition p_${batch_date} with table ${iol_schema}.icms_prd_cl_control_cl;
alter table ${iol_schema}.icms_prd_cl_control exchange partition p_20991231 with table ${iol_schema}.icms_prd_cl_control_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_prd_cl_control to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_prd_cl_control_op purge;
drop table ${iol_schema}.icms_prd_cl_control_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_prd_cl_control_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_prd_cl_control',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
