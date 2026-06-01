/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_dkftphz
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
create table ${iol_schema}.pams_jxbb_dkftphz_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxbb_dkftphz
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_dkftphz_op purge;
drop table ${iol_schema}.pams_jxbb_dkftphz_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_dkftphz_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_dkftphz where 0=1;

create table ${iol_schema}.pams_jxbb_dkftphz_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_dkftphz where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_dkftphz_cl(
            tjrq -- 统计日期
            ,kmh -- 科目号
            ,kmmc -- 科目名称
            ,cpbh -- 标准产品编号
            ,cpzwmc -- 产品中文名称
            ,ye -- 余额
            ,yrj -- 月日均
            ,nrj -- 年日均
            ,jqll -- 加权利率
            ,ylx -- 月利息
            ,nlx -- 年利息
            ,jqftpjg -- 加权ftp价格
            ,dyftpzycb -- 当月FTP转移成本
            ,ljftpzycb -- 累计FTP转移成本
            ,dyftpjsy -- 当月FTP净收益
            ,ljftpjsy -- 累计FTP净收益
            ,lxkm -- 利息科目
            ,lxkmmc -- 利息科目名称
            ,khjgh -- 开户机构号
            ,khjgmc -- 开户机构名称
            ,ssjgh -- 所属机构号
            ,ssjgmc -- 所属机构名称
            ,yqxyss -- 预计信用损失
            ,fxjqzcje -- 风险加权资产金额
            ,bz -- 币种
            ,frje -- 分润金额
            ,hyfrje -- 行员分润金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_dkftphz_op(
            tjrq -- 统计日期
            ,kmh -- 科目号
            ,kmmc -- 科目名称
            ,cpbh -- 标准产品编号
            ,cpzwmc -- 产品中文名称
            ,ye -- 余额
            ,yrj -- 月日均
            ,nrj -- 年日均
            ,jqll -- 加权利率
            ,ylx -- 月利息
            ,nlx -- 年利息
            ,jqftpjg -- 加权ftp价格
            ,dyftpzycb -- 当月FTP转移成本
            ,ljftpzycb -- 累计FTP转移成本
            ,dyftpjsy -- 当月FTP净收益
            ,ljftpjsy -- 累计FTP净收益
            ,lxkm -- 利息科目
            ,lxkmmc -- 利息科目名称
            ,khjgh -- 开户机构号
            ,khjgmc -- 开户机构名称
            ,ssjgh -- 所属机构号
            ,ssjgmc -- 所属机构名称
            ,yqxyss -- 预计信用损失
            ,fxjqzcje -- 风险加权资产金额
            ,bz -- 币种
            ,frje -- 分润金额
            ,hyfrje -- 行员分润金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.kmh, o.kmh) as kmh -- 科目号
    ,nvl(n.kmmc, o.kmmc) as kmmc -- 科目名称
    ,nvl(n.cpbh, o.cpbh) as cpbh -- 标准产品编号
    ,nvl(n.cpzwmc, o.cpzwmc) as cpzwmc -- 产品中文名称
    ,nvl(n.ye, o.ye) as ye -- 余额
    ,nvl(n.yrj, o.yrj) as yrj -- 月日均
    ,nvl(n.nrj, o.nrj) as nrj -- 年日均
    ,nvl(n.jqll, o.jqll) as jqll -- 加权利率
    ,nvl(n.ylx, o.ylx) as ylx -- 月利息
    ,nvl(n.nlx, o.nlx) as nlx -- 年利息
    ,nvl(n.jqftpjg, o.jqftpjg) as jqftpjg -- 加权ftp价格
    ,nvl(n.dyftpzycb, o.dyftpzycb) as dyftpzycb -- 当月FTP转移成本
    ,nvl(n.ljftpzycb, o.ljftpzycb) as ljftpzycb -- 累计FTP转移成本
    ,nvl(n.dyftpjsy, o.dyftpjsy) as dyftpjsy -- 当月FTP净收益
    ,nvl(n.ljftpjsy, o.ljftpjsy) as ljftpjsy -- 累计FTP净收益
    ,nvl(n.lxkm, o.lxkm) as lxkm -- 利息科目
    ,nvl(n.lxkmmc, o.lxkmmc) as lxkmmc -- 利息科目名称
    ,nvl(n.khjgh, o.khjgh) as khjgh -- 开户机构号
    ,nvl(n.khjgmc, o.khjgmc) as khjgmc -- 开户机构名称
    ,nvl(n.ssjgh, o.ssjgh) as ssjgh -- 所属机构号
    ,nvl(n.ssjgmc, o.ssjgmc) as ssjgmc -- 所属机构名称
    ,nvl(n.yqxyss, o.yqxyss) as yqxyss -- 预计信用损失
    ,nvl(n.fxjqzcje, o.fxjqzcje) as fxjqzcje -- 风险加权资产金额
    ,nvl(n.bz, o.bz) as bz -- 币种
    ,nvl(n.frje, o.frje) as frje -- 分润金额
    ,nvl(n.hyfrje, o.hyfrje) as hyfrje -- 行员分润金额
    ,case when
            n.tjrq is null
            and n.kmh is null
            and n.cpbh is null
            and n.lxkm is null
            and n.khjgh is null
            and n.ssjgh is null
            and n.bz is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tjrq is null
            and n.kmh is null
            and n.cpbh is null
            and n.lxkm is null
            and n.khjgh is null
            and n.ssjgh is null
            and n.bz is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tjrq is null
            and n.kmh is null
            and n.cpbh is null
            and n.lxkm is null
            and n.khjgh is null
            and n.ssjgh is null
            and n.bz is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_jxbb_dkftphz_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxbb_dkftphz where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tjrq = n.tjrq
            and o.kmh = n.kmh
            and o.cpbh = n.cpbh
            and o.lxkm = n.lxkm
            and o.khjgh = n.khjgh
            and o.ssjgh = n.ssjgh
            and o.bz = n.bz
where (
        o.tjrq is null
        and o.kmh is null
        and o.cpbh is null
        and o.lxkm is null
        and o.khjgh is null
        and o.ssjgh is null
        and o.bz is null
    )
    or (
        n.tjrq is null
        and n.kmh is null
        and n.cpbh is null
        and n.lxkm is null
        and n.khjgh is null
        and n.ssjgh is null
        and n.bz is null
    )
    or (
        o.kmmc <> n.kmmc
        or o.cpzwmc <> n.cpzwmc
        or o.ye <> n.ye
        or o.yrj <> n.yrj
        or o.nrj <> n.nrj
        or o.jqll <> n.jqll
        or o.ylx <> n.ylx
        or o.nlx <> n.nlx
        or o.jqftpjg <> n.jqftpjg
        or o.dyftpzycb <> n.dyftpzycb
        or o.ljftpzycb <> n.ljftpzycb
        or o.dyftpjsy <> n.dyftpjsy
        or o.ljftpjsy <> n.ljftpjsy
        or o.lxkmmc <> n.lxkmmc
        or o.khjgmc <> n.khjgmc
        or o.ssjgmc <> n.ssjgmc
        or o.yqxyss <> n.yqxyss
        or o.fxjqzcje <> n.fxjqzcje
        or o.frje <> n.frje
        or o.hyfrje <> n.hyfrje
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_dkftphz_cl(
            tjrq -- 统计日期
            ,kmh -- 科目号
            ,kmmc -- 科目名称
            ,cpbh -- 标准产品编号
            ,cpzwmc -- 产品中文名称
            ,ye -- 余额
            ,yrj -- 月日均
            ,nrj -- 年日均
            ,jqll -- 加权利率
            ,ylx -- 月利息
            ,nlx -- 年利息
            ,jqftpjg -- 加权ftp价格
            ,dyftpzycb -- 当月FTP转移成本
            ,ljftpzycb -- 累计FTP转移成本
            ,dyftpjsy -- 当月FTP净收益
            ,ljftpjsy -- 累计FTP净收益
            ,lxkm -- 利息科目
            ,lxkmmc -- 利息科目名称
            ,khjgh -- 开户机构号
            ,khjgmc -- 开户机构名称
            ,ssjgh -- 所属机构号
            ,ssjgmc -- 所属机构名称
            ,yqxyss -- 预计信用损失
            ,fxjqzcje -- 风险加权资产金额
            ,bz -- 币种
            ,frje -- 分润金额
            ,hyfrje -- 行员分润金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_dkftphz_op(
            tjrq -- 统计日期
            ,kmh -- 科目号
            ,kmmc -- 科目名称
            ,cpbh -- 标准产品编号
            ,cpzwmc -- 产品中文名称
            ,ye -- 余额
            ,yrj -- 月日均
            ,nrj -- 年日均
            ,jqll -- 加权利率
            ,ylx -- 月利息
            ,nlx -- 年利息
            ,jqftpjg -- 加权ftp价格
            ,dyftpzycb -- 当月FTP转移成本
            ,ljftpzycb -- 累计FTP转移成本
            ,dyftpjsy -- 当月FTP净收益
            ,ljftpjsy -- 累计FTP净收益
            ,lxkm -- 利息科目
            ,lxkmmc -- 利息科目名称
            ,khjgh -- 开户机构号
            ,khjgmc -- 开户机构名称
            ,ssjgh -- 所属机构号
            ,ssjgmc -- 所属机构名称
            ,yqxyss -- 预计信用损失
            ,fxjqzcje -- 风险加权资产金额
            ,bz -- 币种
            ,frje -- 分润金额
            ,hyfrje -- 行员分润金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tjrq -- 统计日期
    ,o.kmh -- 科目号
    ,o.kmmc -- 科目名称
    ,o.cpbh -- 标准产品编号
    ,o.cpzwmc -- 产品中文名称
    ,o.ye -- 余额
    ,o.yrj -- 月日均
    ,o.nrj -- 年日均
    ,o.jqll -- 加权利率
    ,o.ylx -- 月利息
    ,o.nlx -- 年利息
    ,o.jqftpjg -- 加权ftp价格
    ,o.dyftpzycb -- 当月FTP转移成本
    ,o.ljftpzycb -- 累计FTP转移成本
    ,o.dyftpjsy -- 当月FTP净收益
    ,o.ljftpjsy -- 累计FTP净收益
    ,o.lxkm -- 利息科目
    ,o.lxkmmc -- 利息科目名称
    ,o.khjgh -- 开户机构号
    ,o.khjgmc -- 开户机构名称
    ,o.ssjgh -- 所属机构号
    ,o.ssjgmc -- 所属机构名称
    ,o.yqxyss -- 预计信用损失
    ,o.fxjqzcje -- 风险加权资产金额
    ,o.bz -- 币种
    ,o.frje -- 分润金额
    ,o.hyfrje -- 行员分润金额
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
from ${iol_schema}.pams_jxbb_dkftphz_bk o
    left join ${iol_schema}.pams_jxbb_dkftphz_op n
        on
            o.tjrq = n.tjrq
            and o.kmh = n.kmh
            and o.cpbh = n.cpbh
            and o.lxkm = n.lxkm
            and o.khjgh = n.khjgh
            and o.ssjgh = n.ssjgh
            and o.bz = n.bz
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxbb_dkftphz_cl d
        on
            o.tjrq = d.tjrq
            and o.kmh = d.kmh
            and o.cpbh = d.cpbh
            and o.lxkm = d.lxkm
            and o.khjgh = d.khjgh
            and o.ssjgh = d.ssjgh
            and o.bz = d.bz
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_jxbb_dkftphz;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxbb_dkftphz') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxbb_dkftphz drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxbb_dkftphz add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxbb_dkftphz exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_dkftphz_cl;
alter table ${iol_schema}.pams_jxbb_dkftphz exchange partition p_20991231 with table ${iol_schema}.pams_jxbb_dkftphz_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_dkftphz to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_dkftphz_op purge;
drop table ${iol_schema}.pams_jxbb_dkftphz_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxbb_dkftphz_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_dkftphz',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
