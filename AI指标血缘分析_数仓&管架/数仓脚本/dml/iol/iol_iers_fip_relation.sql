/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_fip_relation
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
create table ${iol_schema}.iers_fip_relation_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_fip_relation
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fip_relation_op purge;
drop table ${iol_schema}.iers_fip_relation_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fip_relation_op nologging
for exchange with table
${iol_schema}.iers_fip_relation;

create table ${iol_schema}.iers_fip_relation_cl nologging
for exchange with table
${iol_schema}.iers_fip_relation;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fip_relation_cl(
            batchno -- 
            ,busimessage1 -- 业务关联信息1
            ,busimessage2 -- 业务关联信息2
            ,busimessage3 -- 业务关联信息3
            ,des_billtype -- 目标单据类型
            ,des_busidate -- 目标业务日期
            ,des_defdoc1 -- 目标分组档案1
            ,des_defdoc2 -- 目标分组档案2
            ,des_defdoc3 -- 目标分组档案3
            ,des_freedef1 -- 目标辅助信息1
            ,des_freedef2 -- 目标辅助信息2
            ,des_freedef3 -- 目标辅助信息3
            ,des_freedef4 -- 目标辅助信息4
            ,des_freedef5 -- 目标辅助信息5
            ,des_group -- 目标集团
            ,des_operator -- 目标操作员
            ,des_org -- 目标组织
            ,des_relationid -- 目标单据关联号
            ,des_system -- 目标系统
            ,dr -- 删除标志
            ,pk_relation -- 对象标识
            ,saga_btxid -- 
            ,saga_frozen -- 
            ,saga_gtxid -- 
            ,saga_status -- 
            ,src_billtype -- 来源单据类型
            ,src_busidate -- 来源业务日期
            ,src_defdoc1 -- 来源分组档案1
            ,src_defdoc2 -- 来源分组档案2
            ,src_defdoc3 -- 来源分组档案3
            ,src_freedef1 -- 来源辅助信息1
            ,src_freedef2 -- 来源辅助信息2
            ,src_freedef3 -- 来源辅助信息3
            ,src_freedef4 -- 来源辅助信息4
            ,src_freedef5 -- 来源辅助信息5
            ,src_group -- 来源集团
            ,src_operator -- 来源操作员
            ,src_org -- 来源组织
            ,src_relationid -- 来源单据关联号
            ,src_system -- 来源系统
            ,sumflag -- 来源单据是否汇总
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fip_relation_op(
            batchno -- 
            ,busimessage1 -- 业务关联信息1
            ,busimessage2 -- 业务关联信息2
            ,busimessage3 -- 业务关联信息3
            ,des_billtype -- 目标单据类型
            ,des_busidate -- 目标业务日期
            ,des_defdoc1 -- 目标分组档案1
            ,des_defdoc2 -- 目标分组档案2
            ,des_defdoc3 -- 目标分组档案3
            ,des_freedef1 -- 目标辅助信息1
            ,des_freedef2 -- 目标辅助信息2
            ,des_freedef3 -- 目标辅助信息3
            ,des_freedef4 -- 目标辅助信息4
            ,des_freedef5 -- 目标辅助信息5
            ,des_group -- 目标集团
            ,des_operator -- 目标操作员
            ,des_org -- 目标组织
            ,des_relationid -- 目标单据关联号
            ,des_system -- 目标系统
            ,dr -- 删除标志
            ,pk_relation -- 对象标识
            ,saga_btxid -- 
            ,saga_frozen -- 
            ,saga_gtxid -- 
            ,saga_status -- 
            ,src_billtype -- 来源单据类型
            ,src_busidate -- 来源业务日期
            ,src_defdoc1 -- 来源分组档案1
            ,src_defdoc2 -- 来源分组档案2
            ,src_defdoc3 -- 来源分组档案3
            ,src_freedef1 -- 来源辅助信息1
            ,src_freedef2 -- 来源辅助信息2
            ,src_freedef3 -- 来源辅助信息3
            ,src_freedef4 -- 来源辅助信息4
            ,src_freedef5 -- 来源辅助信息5
            ,src_group -- 来源集团
            ,src_operator -- 来源操作员
            ,src_org -- 来源组织
            ,src_relationid -- 来源单据关联号
            ,src_system -- 来源系统
            ,sumflag -- 来源单据是否汇总
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.batchno, o.batchno) as batchno -- 
    ,nvl(n.busimessage1, o.busimessage1) as busimessage1 -- 业务关联信息1
    ,nvl(n.busimessage2, o.busimessage2) as busimessage2 -- 业务关联信息2
    ,nvl(n.busimessage3, o.busimessage3) as busimessage3 -- 业务关联信息3
    ,nvl(n.des_billtype, o.des_billtype) as des_billtype -- 目标单据类型
    ,nvl(n.des_busidate, o.des_busidate) as des_busidate -- 目标业务日期
    ,nvl(n.des_defdoc1, o.des_defdoc1) as des_defdoc1 -- 目标分组档案1
    ,nvl(n.des_defdoc2, o.des_defdoc2) as des_defdoc2 -- 目标分组档案2
    ,nvl(n.des_defdoc3, o.des_defdoc3) as des_defdoc3 -- 目标分组档案3
    ,nvl(n.des_freedef1, o.des_freedef1) as des_freedef1 -- 目标辅助信息1
    ,nvl(n.des_freedef2, o.des_freedef2) as des_freedef2 -- 目标辅助信息2
    ,nvl(n.des_freedef3, o.des_freedef3) as des_freedef3 -- 目标辅助信息3
    ,nvl(n.des_freedef4, o.des_freedef4) as des_freedef4 -- 目标辅助信息4
    ,nvl(n.des_freedef5, o.des_freedef5) as des_freedef5 -- 目标辅助信息5
    ,nvl(n.des_group, o.des_group) as des_group -- 目标集团
    ,nvl(n.des_operator, o.des_operator) as des_operator -- 目标操作员
    ,nvl(n.des_org, o.des_org) as des_org -- 目标组织
    ,nvl(n.des_relationid, o.des_relationid) as des_relationid -- 目标单据关联号
    ,nvl(n.des_system, o.des_system) as des_system -- 目标系统
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.pk_relation, o.pk_relation) as pk_relation -- 对象标识
    ,nvl(n.saga_btxid, o.saga_btxid) as saga_btxid -- 
    ,nvl(n.saga_frozen, o.saga_frozen) as saga_frozen -- 
    ,nvl(n.saga_gtxid, o.saga_gtxid) as saga_gtxid -- 
    ,nvl(n.saga_status, o.saga_status) as saga_status -- 
    ,nvl(n.src_billtype, o.src_billtype) as src_billtype -- 来源单据类型
    ,nvl(n.src_busidate, o.src_busidate) as src_busidate -- 来源业务日期
    ,nvl(n.src_defdoc1, o.src_defdoc1) as src_defdoc1 -- 来源分组档案1
    ,nvl(n.src_defdoc2, o.src_defdoc2) as src_defdoc2 -- 来源分组档案2
    ,nvl(n.src_defdoc3, o.src_defdoc3) as src_defdoc3 -- 来源分组档案3
    ,nvl(n.src_freedef1, o.src_freedef1) as src_freedef1 -- 来源辅助信息1
    ,nvl(n.src_freedef2, o.src_freedef2) as src_freedef2 -- 来源辅助信息2
    ,nvl(n.src_freedef3, o.src_freedef3) as src_freedef3 -- 来源辅助信息3
    ,nvl(n.src_freedef4, o.src_freedef4) as src_freedef4 -- 来源辅助信息4
    ,nvl(n.src_freedef5, o.src_freedef5) as src_freedef5 -- 来源辅助信息5
    ,nvl(n.src_group, o.src_group) as src_group -- 来源集团
    ,nvl(n.src_operator, o.src_operator) as src_operator -- 来源操作员
    ,nvl(n.src_org, o.src_org) as src_org -- 来源组织
    ,nvl(n.src_relationid, o.src_relationid) as src_relationid -- 来源单据关联号
    ,nvl(n.src_system, o.src_system) as src_system -- 来源系统
    ,nvl(n.sumflag, o.sumflag) as sumflag -- 来源单据是否汇总
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,case when
            n.pk_relation is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_relation is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_relation is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_fip_relation_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_fip_relation where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_relation = n.pk_relation
where (
        o.pk_relation is null
    )
    or (
        n.pk_relation is null
    )
    or (
        o.batchno <> n.batchno
        or o.busimessage1 <> n.busimessage1
        or o.busimessage2 <> n.busimessage2
        or o.busimessage3 <> n.busimessage3
        or o.des_billtype <> n.des_billtype
        or o.des_busidate <> n.des_busidate
        or o.des_defdoc1 <> n.des_defdoc1
        or o.des_defdoc2 <> n.des_defdoc2
        or o.des_defdoc3 <> n.des_defdoc3
        or o.des_freedef1 <> n.des_freedef1
        or o.des_freedef2 <> n.des_freedef2
        or o.des_freedef3 <> n.des_freedef3
        or o.des_freedef4 <> n.des_freedef4
        or o.des_freedef5 <> n.des_freedef5
        or o.des_group <> n.des_group
        or o.des_operator <> n.des_operator
        or o.des_org <> n.des_org
        or o.des_relationid <> n.des_relationid
        or o.des_system <> n.des_system
        or o.dr <> n.dr
        or o.saga_btxid <> n.saga_btxid
        or o.saga_frozen <> n.saga_frozen
        or o.saga_gtxid <> n.saga_gtxid
        or o.saga_status <> n.saga_status
        or o.src_billtype <> n.src_billtype
        or o.src_busidate <> n.src_busidate
        or o.src_defdoc1 <> n.src_defdoc1
        or o.src_defdoc2 <> n.src_defdoc2
        or o.src_defdoc3 <> n.src_defdoc3
        or o.src_freedef1 <> n.src_freedef1
        or o.src_freedef2 <> n.src_freedef2
        or o.src_freedef3 <> n.src_freedef3
        or o.src_freedef4 <> n.src_freedef4
        or o.src_freedef5 <> n.src_freedef5
        or o.src_group <> n.src_group
        or o.src_operator <> n.src_operator
        or o.src_org <> n.src_org
        or o.src_relationid <> n.src_relationid
        or o.src_system <> n.src_system
        or o.sumflag <> n.sumflag
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fip_relation_cl(
            batchno -- 
            ,busimessage1 -- 业务关联信息1
            ,busimessage2 -- 业务关联信息2
            ,busimessage3 -- 业务关联信息3
            ,des_billtype -- 目标单据类型
            ,des_busidate -- 目标业务日期
            ,des_defdoc1 -- 目标分组档案1
            ,des_defdoc2 -- 目标分组档案2
            ,des_defdoc3 -- 目标分组档案3
            ,des_freedef1 -- 目标辅助信息1
            ,des_freedef2 -- 目标辅助信息2
            ,des_freedef3 -- 目标辅助信息3
            ,des_freedef4 -- 目标辅助信息4
            ,des_freedef5 -- 目标辅助信息5
            ,des_group -- 目标集团
            ,des_operator -- 目标操作员
            ,des_org -- 目标组织
            ,des_relationid -- 目标单据关联号
            ,des_system -- 目标系统
            ,dr -- 删除标志
            ,pk_relation -- 对象标识
            ,saga_btxid -- 
            ,saga_frozen -- 
            ,saga_gtxid -- 
            ,saga_status -- 
            ,src_billtype -- 来源单据类型
            ,src_busidate -- 来源业务日期
            ,src_defdoc1 -- 来源分组档案1
            ,src_defdoc2 -- 来源分组档案2
            ,src_defdoc3 -- 来源分组档案3
            ,src_freedef1 -- 来源辅助信息1
            ,src_freedef2 -- 来源辅助信息2
            ,src_freedef3 -- 来源辅助信息3
            ,src_freedef4 -- 来源辅助信息4
            ,src_freedef5 -- 来源辅助信息5
            ,src_group -- 来源集团
            ,src_operator -- 来源操作员
            ,src_org -- 来源组织
            ,src_relationid -- 来源单据关联号
            ,src_system -- 来源系统
            ,sumflag -- 来源单据是否汇总
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fip_relation_op(
            batchno -- 
            ,busimessage1 -- 业务关联信息1
            ,busimessage2 -- 业务关联信息2
            ,busimessage3 -- 业务关联信息3
            ,des_billtype -- 目标单据类型
            ,des_busidate -- 目标业务日期
            ,des_defdoc1 -- 目标分组档案1
            ,des_defdoc2 -- 目标分组档案2
            ,des_defdoc3 -- 目标分组档案3
            ,des_freedef1 -- 目标辅助信息1
            ,des_freedef2 -- 目标辅助信息2
            ,des_freedef3 -- 目标辅助信息3
            ,des_freedef4 -- 目标辅助信息4
            ,des_freedef5 -- 目标辅助信息5
            ,des_group -- 目标集团
            ,des_operator -- 目标操作员
            ,des_org -- 目标组织
            ,des_relationid -- 目标单据关联号
            ,des_system -- 目标系统
            ,dr -- 删除标志
            ,pk_relation -- 对象标识
            ,saga_btxid -- 
            ,saga_frozen -- 
            ,saga_gtxid -- 
            ,saga_status -- 
            ,src_billtype -- 来源单据类型
            ,src_busidate -- 来源业务日期
            ,src_defdoc1 -- 来源分组档案1
            ,src_defdoc2 -- 来源分组档案2
            ,src_defdoc3 -- 来源分组档案3
            ,src_freedef1 -- 来源辅助信息1
            ,src_freedef2 -- 来源辅助信息2
            ,src_freedef3 -- 来源辅助信息3
            ,src_freedef4 -- 来源辅助信息4
            ,src_freedef5 -- 来源辅助信息5
            ,src_group -- 来源集团
            ,src_operator -- 来源操作员
            ,src_org -- 来源组织
            ,src_relationid -- 来源单据关联号
            ,src_system -- 来源系统
            ,sumflag -- 来源单据是否汇总
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.batchno -- 
    ,o.busimessage1 -- 业务关联信息1
    ,o.busimessage2 -- 业务关联信息2
    ,o.busimessage3 -- 业务关联信息3
    ,o.des_billtype -- 目标单据类型
    ,o.des_busidate -- 目标业务日期
    ,o.des_defdoc1 -- 目标分组档案1
    ,o.des_defdoc2 -- 目标分组档案2
    ,o.des_defdoc3 -- 目标分组档案3
    ,o.des_freedef1 -- 目标辅助信息1
    ,o.des_freedef2 -- 目标辅助信息2
    ,o.des_freedef3 -- 目标辅助信息3
    ,o.des_freedef4 -- 目标辅助信息4
    ,o.des_freedef5 -- 目标辅助信息5
    ,o.des_group -- 目标集团
    ,o.des_operator -- 目标操作员
    ,o.des_org -- 目标组织
    ,o.des_relationid -- 目标单据关联号
    ,o.des_system -- 目标系统
    ,o.dr -- 删除标志
    ,o.pk_relation -- 对象标识
    ,o.saga_btxid -- 
    ,o.saga_frozen -- 
    ,o.saga_gtxid -- 
    ,o.saga_status -- 
    ,o.src_billtype -- 来源单据类型
    ,o.src_busidate -- 来源业务日期
    ,o.src_defdoc1 -- 来源分组档案1
    ,o.src_defdoc2 -- 来源分组档案2
    ,o.src_defdoc3 -- 来源分组档案3
    ,o.src_freedef1 -- 来源辅助信息1
    ,o.src_freedef2 -- 来源辅助信息2
    ,o.src_freedef3 -- 来源辅助信息3
    ,o.src_freedef4 -- 来源辅助信息4
    ,o.src_freedef5 -- 来源辅助信息5
    ,o.src_group -- 来源集团
    ,o.src_operator -- 来源操作员
    ,o.src_org -- 来源组织
    ,o.src_relationid -- 来源单据关联号
    ,o.src_system -- 来源系统
    ,o.sumflag -- 来源单据是否汇总
    ,o.ts -- 时间戳
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
from ${iol_schema}.iers_fip_relation_bk o
    left join ${iol_schema}.iers_fip_relation_op n
        on
            o.pk_relation = n.pk_relation
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_fip_relation_cl d
        on
            o.pk_relation = d.pk_relation
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_fip_relation;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_fip_relation') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_fip_relation drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_fip_relation add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_fip_relation exchange partition p_${batch_date} with table ${iol_schema}.iers_fip_relation_cl;
alter table ${iol_schema}.iers_fip_relation exchange partition p_20991231 with table ${iol_schema}.iers_fip_relation_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_fip_relation to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fip_relation_op purge;
drop table ${iol_schema}.iers_fip_relation_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_fip_relation_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_fip_relation',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
