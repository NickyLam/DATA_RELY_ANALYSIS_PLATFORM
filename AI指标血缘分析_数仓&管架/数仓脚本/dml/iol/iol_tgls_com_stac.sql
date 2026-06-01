/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_com_stac
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
create table ${iol_schema}.tgls_com_stac_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_com_stac
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_stac_op purge;
drop table ${iol_schema}.tgls_com_stac_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_stac_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_stac where 0=1;

create table ${iol_schema}.tgls_com_stac_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_com_stac where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_stac_cl(
            stacid -- 账套标记
            ,linkid -- 关联账套（目前不使用）
            ,stacna -- 账套名称
            ,brchna -- 机构名称
            ,crcycd -- 币种代码
            ,starmh -- 启用期间
            ,mesglt -- 日志保留长度
            ,autoup -- 账目时间自动更新
            ,stacst -- 交易状态(20、正常状态99、总账日终28、日终错误)
            ,curtmh -- 当前会计期间
            ,closmh -- 已结账期数
            ,glisdt -- 总账会计日期
            ,realbl -- 实时计算余额
            ,blncck -- 平衡检查
            ,rstrvc -- 限制制证
            ,stacmt -- 是否关联主账套(0－否，1－是)（目前不使用）
            ,keepac -- 是否需要记账(0－不需要，1－需要)
            ,vlidtg -- 0：未生效1：当前已生效9：已冻结
            ,bsnsdt -- 业务日期
            ,acctdt -- 账务会计日期
            ,crcyiv -- 开票币种
            ,acctsy -- 记账制
            ,musctg -- 多准则核算标志(n－否，y－是)
            ,stactp -- 账套类型
            ,linktp -- 关联账套类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_stac_op(
            stacid -- 账套标记
            ,linkid -- 关联账套（目前不使用）
            ,stacna -- 账套名称
            ,brchna -- 机构名称
            ,crcycd -- 币种代码
            ,starmh -- 启用期间
            ,mesglt -- 日志保留长度
            ,autoup -- 账目时间自动更新
            ,stacst -- 交易状态(20、正常状态99、总账日终28、日终错误)
            ,curtmh -- 当前会计期间
            ,closmh -- 已结账期数
            ,glisdt -- 总账会计日期
            ,realbl -- 实时计算余额
            ,blncck -- 平衡检查
            ,rstrvc -- 限制制证
            ,stacmt -- 是否关联主账套(0－否，1－是)（目前不使用）
            ,keepac -- 是否需要记账(0－不需要，1－需要)
            ,vlidtg -- 0：未生效1：当前已生效9：已冻结
            ,bsnsdt -- 业务日期
            ,acctdt -- 账务会计日期
            ,crcyiv -- 开票币种
            ,acctsy -- 记账制
            ,musctg -- 多准则核算标志(n－否，y－是)
            ,stactp -- 账套类型
            ,linktp -- 关联账套类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.linkid, o.linkid) as linkid -- 关联账套（目前不使用）
    ,nvl(n.stacna, o.stacna) as stacna -- 账套名称
    ,nvl(n.brchna, o.brchna) as brchna -- 机构名称
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种代码
    ,nvl(n.starmh, o.starmh) as starmh -- 启用期间
    ,nvl(n.mesglt, o.mesglt) as mesglt -- 日志保留长度
    ,nvl(n.autoup, o.autoup) as autoup -- 账目时间自动更新
    ,nvl(n.stacst, o.stacst) as stacst -- 交易状态(20、正常状态99、总账日终28、日终错误)
    ,nvl(n.curtmh, o.curtmh) as curtmh -- 当前会计期间
    ,nvl(n.closmh, o.closmh) as closmh -- 已结账期数
    ,nvl(n.glisdt, o.glisdt) as glisdt -- 总账会计日期
    ,nvl(n.realbl, o.realbl) as realbl -- 实时计算余额
    ,nvl(n.blncck, o.blncck) as blncck -- 平衡检查
    ,nvl(n.rstrvc, o.rstrvc) as rstrvc -- 限制制证
    ,nvl(n.stacmt, o.stacmt) as stacmt -- 是否关联主账套(0－否，1－是)（目前不使用）
    ,nvl(n.keepac, o.keepac) as keepac -- 是否需要记账(0－不需要，1－需要)
    ,nvl(n.vlidtg, o.vlidtg) as vlidtg -- 0：未生效1：当前已生效9：已冻结
    ,nvl(n.bsnsdt, o.bsnsdt) as bsnsdt -- 业务日期
    ,nvl(n.acctdt, o.acctdt) as acctdt -- 账务会计日期
    ,nvl(n.crcyiv, o.crcyiv) as crcyiv -- 开票币种
    ,nvl(n.acctsy, o.acctsy) as acctsy -- 记账制
    ,nvl(n.musctg, o.musctg) as musctg -- 多准则核算标志(n－否，y－是)
    ,nvl(n.stactp, o.stactp) as stactp -- 账套类型
    ,nvl(n.linktp, o.linktp) as linktp -- 关联账套类型
    ,case when
            n.stacid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_com_stac_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_com_stac where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
where (
        o.stacid is null
    )
    or (
        n.stacid is null
    )
    or (
        o.linkid <> n.linkid
        or o.stacna <> n.stacna
        or o.brchna <> n.brchna
        or o.crcycd <> n.crcycd
        or o.starmh <> n.starmh
        or o.mesglt <> n.mesglt
        or o.autoup <> n.autoup
        or o.stacst <> n.stacst
        or o.curtmh <> n.curtmh
        or o.closmh <> n.closmh
        or o.glisdt <> n.glisdt
        or o.realbl <> n.realbl
        or o.blncck <> n.blncck
        or o.rstrvc <> n.rstrvc
        or o.stacmt <> n.stacmt
        or o.keepac <> n.keepac
        or o.vlidtg <> n.vlidtg
        or o.bsnsdt <> n.bsnsdt
        or o.acctdt <> n.acctdt
        or o.crcyiv <> n.crcyiv
        or o.acctsy <> n.acctsy
        or o.musctg <> n.musctg
        or o.stactp <> n.stactp
        or o.linktp <> n.linktp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_com_stac_cl(
            stacid -- 账套标记
            ,linkid -- 关联账套（目前不使用）
            ,stacna -- 账套名称
            ,brchna -- 机构名称
            ,crcycd -- 币种代码
            ,starmh -- 启用期间
            ,mesglt -- 日志保留长度
            ,autoup -- 账目时间自动更新
            ,stacst -- 交易状态(20、正常状态99、总账日终28、日终错误)
            ,curtmh -- 当前会计期间
            ,closmh -- 已结账期数
            ,glisdt -- 总账会计日期
            ,realbl -- 实时计算余额
            ,blncck -- 平衡检查
            ,rstrvc -- 限制制证
            ,stacmt -- 是否关联主账套(0－否，1－是)（目前不使用）
            ,keepac -- 是否需要记账(0－不需要，1－需要)
            ,vlidtg -- 0：未生效1：当前已生效9：已冻结
            ,bsnsdt -- 业务日期
            ,acctdt -- 账务会计日期
            ,crcyiv -- 开票币种
            ,acctsy -- 记账制
            ,musctg -- 多准则核算标志(n－否，y－是)
            ,stactp -- 账套类型
            ,linktp -- 关联账套类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_com_stac_op(
            stacid -- 账套标记
            ,linkid -- 关联账套（目前不使用）
            ,stacna -- 账套名称
            ,brchna -- 机构名称
            ,crcycd -- 币种代码
            ,starmh -- 启用期间
            ,mesglt -- 日志保留长度
            ,autoup -- 账目时间自动更新
            ,stacst -- 交易状态(20、正常状态99、总账日终28、日终错误)
            ,curtmh -- 当前会计期间
            ,closmh -- 已结账期数
            ,glisdt -- 总账会计日期
            ,realbl -- 实时计算余额
            ,blncck -- 平衡检查
            ,rstrvc -- 限制制证
            ,stacmt -- 是否关联主账套(0－否，1－是)（目前不使用）
            ,keepac -- 是否需要记账(0－不需要，1－需要)
            ,vlidtg -- 0：未生效1：当前已生效9：已冻结
            ,bsnsdt -- 业务日期
            ,acctdt -- 账务会计日期
            ,crcyiv -- 开票币种
            ,acctsy -- 记账制
            ,musctg -- 多准则核算标志(n－否，y－是)
            ,stactp -- 账套类型
            ,linktp -- 关联账套类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.linkid -- 关联账套（目前不使用）
    ,o.stacna -- 账套名称
    ,o.brchna -- 机构名称
    ,o.crcycd -- 币种代码
    ,o.starmh -- 启用期间
    ,o.mesglt -- 日志保留长度
    ,o.autoup -- 账目时间自动更新
    ,o.stacst -- 交易状态(20、正常状态99、总账日终28、日终错误)
    ,o.curtmh -- 当前会计期间
    ,o.closmh -- 已结账期数
    ,o.glisdt -- 总账会计日期
    ,o.realbl -- 实时计算余额
    ,o.blncck -- 平衡检查
    ,o.rstrvc -- 限制制证
    ,o.stacmt -- 是否关联主账套(0－否，1－是)（目前不使用）
    ,o.keepac -- 是否需要记账(0－不需要，1－需要)
    ,o.vlidtg -- 0：未生效1：当前已生效9：已冻结
    ,o.bsnsdt -- 业务日期
    ,o.acctdt -- 账务会计日期
    ,o.crcyiv -- 开票币种
    ,o.acctsy -- 记账制
    ,o.musctg -- 多准则核算标志(n－否，y－是)
    ,o.stactp -- 账套类型
    ,o.linktp -- 关联账套类型
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
from ${iol_schema}.tgls_com_stac_bk o
    left join ${iol_schema}.tgls_com_stac_op n
        on
            o.stacid = n.stacid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_com_stac_cl d
        on
            o.stacid = d.stacid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_com_stac;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_com_stac') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_com_stac drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_com_stac add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_com_stac exchange partition p_${batch_date} with table ${iol_schema}.tgls_com_stac_cl;
alter table ${iol_schema}.tgls_com_stac exchange partition p_20991231 with table ${iol_schema}.tgls_com_stac_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_com_stac to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_com_stac_op purge;
drop table ${iol_schema}.tgls_com_stac_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_com_stac_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_com_stac',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
