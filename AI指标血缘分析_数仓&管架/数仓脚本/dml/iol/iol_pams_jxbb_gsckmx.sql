/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pams_jxbb_gsckmx
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
create table ${iol_schema}.pams_jxbb_gsckmx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pams_jxbb_gsckmx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_gsckmx_op purge;
drop table ${iol_schema}.pams_jxbb_gsckmx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_gsckmx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_gsckmx where 0=1;

create table ${iol_schema}.pams_jxbb_gsckmx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pams_jxbb_gsckmx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_gsckmx_cl(
            tjrq -- 统计日期
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,zhdh -- 账户代号
            ,zhhm -- 账户名
            ,zzh -- 子账号
            ,zhid -- 卡号
            ,jgkhdxdh -- 机构考核对象代号
            ,khjgh -- 开户机构号
            ,khjgmc -- 开户机构名称
            ,hbf -- 货币符
            ,kmh -- 科目号
            ,kmmc -- 科目名称
            ,czdm -- 业务编号
            ,cz -- 储种
            ,czqx -- 储种期限
            ,ye -- 余额
            ,yrj -- 月日均
            ,jrj -- 季日均
            ,nrj -- 年日均
            ,qxr -- 起息日
            ,dqr -- 到期日
            ,sjxhr -- 实际销户日
            ,ckll -- 存款利率(%)
            ,khjlgh -- 客户经理工号
            ,khjlmc -- 客户经理姓名
            ,ssjgh -- 所属机构号
            ,ssjgmc -- 所属机构名称
            ,fpbl -- 分配比例
            ,fphye -- 分配后余额
            ,fphyrj -- 分配后月日均
            ,fphjrj -- 分配后季日均
            ,fphnrj -- 分配后年日均
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_gsckmx_op(
            tjrq -- 统计日期
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,zhdh -- 账户代号
            ,zhhm -- 账户名
            ,zzh -- 子账号
            ,zhid -- 卡号
            ,jgkhdxdh -- 机构考核对象代号
            ,khjgh -- 开户机构号
            ,khjgmc -- 开户机构名称
            ,hbf -- 货币符
            ,kmh -- 科目号
            ,kmmc -- 科目名称
            ,czdm -- 业务编号
            ,cz -- 储种
            ,czqx -- 储种期限
            ,ye -- 余额
            ,yrj -- 月日均
            ,jrj -- 季日均
            ,nrj -- 年日均
            ,qxr -- 起息日
            ,dqr -- 到期日
            ,sjxhr -- 实际销户日
            ,ckll -- 存款利率(%)
            ,khjlgh -- 客户经理工号
            ,khjlmc -- 客户经理姓名
            ,ssjgh -- 所属机构号
            ,ssjgmc -- 所属机构名称
            ,fpbl -- 分配比例
            ,fphye -- 分配后余额
            ,fphyrj -- 分配后月日均
            ,fphjrj -- 分配后季日均
            ,fphnrj -- 分配后年日均
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.tjrq, o.tjrq) as tjrq -- 统计日期
    ,nvl(n.khh, o.khh) as khh -- 客户号
    ,nvl(n.khmc, o.khmc) as khmc -- 客户名称
    ,nvl(n.zhdh, o.zhdh) as zhdh -- 账户代号
    ,nvl(n.zhhm, o.zhhm) as zhhm -- 账户名
    ,nvl(n.zzh, o.zzh) as zzh -- 子账号
    ,nvl(n.zhid, o.zhid) as zhid -- 卡号
    ,nvl(n.jgkhdxdh, o.jgkhdxdh) as jgkhdxdh -- 机构考核对象代号
    ,nvl(n.khjgh, o.khjgh) as khjgh -- 开户机构号
    ,nvl(n.khjgmc, o.khjgmc) as khjgmc -- 开户机构名称
    ,nvl(n.hbf, o.hbf) as hbf -- 货币符
    ,nvl(n.kmh, o.kmh) as kmh -- 科目号
    ,nvl(n.kmmc, o.kmmc) as kmmc -- 科目名称
    ,nvl(n.czdm, o.czdm) as czdm -- 业务编号
    ,nvl(n.cz, o.cz) as cz -- 储种
    ,nvl(n.czqx, o.czqx) as czqx -- 储种期限
    ,nvl(n.ye, o.ye) as ye -- 余额
    ,nvl(n.yrj, o.yrj) as yrj -- 月日均
    ,nvl(n.jrj, o.jrj) as jrj -- 季日均
    ,nvl(n.nrj, o.nrj) as nrj -- 年日均
    ,nvl(n.qxr, o.qxr) as qxr -- 起息日
    ,nvl(n.dqr, o.dqr) as dqr -- 到期日
    ,nvl(n.sjxhr, o.sjxhr) as sjxhr -- 实际销户日
    ,nvl(n.ckll, o.ckll) as ckll -- 存款利率(%)
    ,nvl(n.khjlgh, o.khjlgh) as khjlgh -- 客户经理工号
    ,nvl(n.khjlmc, o.khjlmc) as khjlmc -- 客户经理姓名
    ,nvl(n.ssjgh, o.ssjgh) as ssjgh -- 所属机构号
    ,nvl(n.ssjgmc, o.ssjgmc) as ssjgmc -- 所属机构名称
    ,nvl(n.fpbl, o.fpbl) as fpbl -- 分配比例
    ,nvl(n.fphye, o.fphye) as fphye -- 分配后余额
    ,nvl(n.fphyrj, o.fphyrj) as fphyrj -- 分配后月日均
    ,nvl(n.fphjrj, o.fphjrj) as fphjrj -- 分配后季日均
    ,nvl(n.fphnrj, o.fphnrj) as fphnrj -- 分配后年日均
    ,case when
            n.tjrq is null
            and n.zhdh is null
            and n.jgkhdxdh is null
            and n.kmh is null
            and n.khjlgh is null
            and n.ssjgh is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.tjrq is null
            and n.zhdh is null
            and n.jgkhdxdh is null
            and n.kmh is null
            and n.khjlgh is null
            and n.ssjgh is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.tjrq is null
            and n.zhdh is null
            and n.jgkhdxdh is null
            and n.kmh is null
            and n.khjlgh is null
            and n.ssjgh is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pams_jxbb_gsckmx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pams_jxbb_gsckmx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.tjrq = n.tjrq
            and o.zhdh = n.zhdh
            and o.jgkhdxdh = n.jgkhdxdh
            and o.kmh = n.kmh
            and o.khjlgh = n.khjlgh
            and o.ssjgh = n.ssjgh
where (
        o.tjrq is null
        and o.zhdh is null
        and o.jgkhdxdh is null
        and o.kmh is null
        and o.khjlgh is null
        and o.ssjgh is null
    )
    or (
        n.tjrq is null
        and n.zhdh is null
        and n.jgkhdxdh is null
        and n.kmh is null
        and n.khjlgh is null
        and n.ssjgh is null
    )
    or (
        o.khh <> n.khh
        or o.khmc <> n.khmc
        or o.zhhm <> n.zhhm
        or o.zzh <> n.zzh
        or o.zhid <> n.zhid
        or o.khjgh <> n.khjgh
        or o.khjgmc <> n.khjgmc
        or o.hbf <> n.hbf
        or o.kmmc <> n.kmmc
        or o.czdm <> n.czdm
        or o.cz <> n.cz
        or o.czqx <> n.czqx
        or o.ye <> n.ye
        or o.yrj <> n.yrj
        or o.jrj <> n.jrj
        or o.nrj <> n.nrj
        or o.qxr <> n.qxr
        or o.dqr <> n.dqr
        or o.sjxhr <> n.sjxhr
        or o.ckll <> n.ckll
        or o.khjlmc <> n.khjlmc
        or o.ssjgmc <> n.ssjgmc
        or o.fpbl <> n.fpbl
        or o.fphye <> n.fphye
        or o.fphyrj <> n.fphyrj
        or o.fphjrj <> n.fphjrj
        or o.fphnrj <> n.fphnrj
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pams_jxbb_gsckmx_cl(
            tjrq -- 统计日期
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,zhdh -- 账户代号
            ,zhhm -- 账户名
            ,zzh -- 子账号
            ,zhid -- 卡号
            ,jgkhdxdh -- 机构考核对象代号
            ,khjgh -- 开户机构号
            ,khjgmc -- 开户机构名称
            ,hbf -- 货币符
            ,kmh -- 科目号
            ,kmmc -- 科目名称
            ,czdm -- 业务编号
            ,cz -- 储种
            ,czqx -- 储种期限
            ,ye -- 余额
            ,yrj -- 月日均
            ,jrj -- 季日均
            ,nrj -- 年日均
            ,qxr -- 起息日
            ,dqr -- 到期日
            ,sjxhr -- 实际销户日
            ,ckll -- 存款利率(%)
            ,khjlgh -- 客户经理工号
            ,khjlmc -- 客户经理姓名
            ,ssjgh -- 所属机构号
            ,ssjgmc -- 所属机构名称
            ,fpbl -- 分配比例
            ,fphye -- 分配后余额
            ,fphyrj -- 分配后月日均
            ,fphjrj -- 分配后季日均
            ,fphnrj -- 分配后年日均
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pams_jxbb_gsckmx_op(
            tjrq -- 统计日期
            ,khh -- 客户号
            ,khmc -- 客户名称
            ,zhdh -- 账户代号
            ,zhhm -- 账户名
            ,zzh -- 子账号
            ,zhid -- 卡号
            ,jgkhdxdh -- 机构考核对象代号
            ,khjgh -- 开户机构号
            ,khjgmc -- 开户机构名称
            ,hbf -- 货币符
            ,kmh -- 科目号
            ,kmmc -- 科目名称
            ,czdm -- 业务编号
            ,cz -- 储种
            ,czqx -- 储种期限
            ,ye -- 余额
            ,yrj -- 月日均
            ,jrj -- 季日均
            ,nrj -- 年日均
            ,qxr -- 起息日
            ,dqr -- 到期日
            ,sjxhr -- 实际销户日
            ,ckll -- 存款利率(%)
            ,khjlgh -- 客户经理工号
            ,khjlmc -- 客户经理姓名
            ,ssjgh -- 所属机构号
            ,ssjgmc -- 所属机构名称
            ,fpbl -- 分配比例
            ,fphye -- 分配后余额
            ,fphyrj -- 分配后月日均
            ,fphjrj -- 分配后季日均
            ,fphnrj -- 分配后年日均
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.tjrq -- 统计日期
    ,o.khh -- 客户号
    ,o.khmc -- 客户名称
    ,o.zhdh -- 账户代号
    ,o.zhhm -- 账户名
    ,o.zzh -- 子账号
    ,o.zhid -- 卡号
    ,o.jgkhdxdh -- 机构考核对象代号
    ,o.khjgh -- 开户机构号
    ,o.khjgmc -- 开户机构名称
    ,o.hbf -- 货币符
    ,o.kmh -- 科目号
    ,o.kmmc -- 科目名称
    ,o.czdm -- 业务编号
    ,o.cz -- 储种
    ,o.czqx -- 储种期限
    ,o.ye -- 余额
    ,o.yrj -- 月日均
    ,o.jrj -- 季日均
    ,o.nrj -- 年日均
    ,o.qxr -- 起息日
    ,o.dqr -- 到期日
    ,o.sjxhr -- 实际销户日
    ,o.ckll -- 存款利率(%)
    ,o.khjlgh -- 客户经理工号
    ,o.khjlmc -- 客户经理姓名
    ,o.ssjgh -- 所属机构号
    ,o.ssjgmc -- 所属机构名称
    ,o.fpbl -- 分配比例
    ,o.fphye -- 分配后余额
    ,o.fphyrj -- 分配后月日均
    ,o.fphjrj -- 分配后季日均
    ,o.fphnrj -- 分配后年日均
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
from ${iol_schema}.pams_jxbb_gsckmx_bk o
    left join ${iol_schema}.pams_jxbb_gsckmx_op n
        on
            o.tjrq = n.tjrq
            and o.zhdh = n.zhdh
            and o.jgkhdxdh = n.jgkhdxdh
            and o.kmh = n.kmh
            and o.khjlgh = n.khjlgh
            and o.ssjgh = n.ssjgh
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pams_jxbb_gsckmx_cl d
        on
            o.tjrq = d.tjrq
            and o.zhdh = d.zhdh
            and o.jgkhdxdh = d.jgkhdxdh
            and o.kmh = d.kmh
            and o.khjlgh = d.khjlgh
            and o.ssjgh = d.ssjgh
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pams_jxbb_gsckmx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pams_jxbb_gsckmx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pams_jxbb_gsckmx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pams_jxbb_gsckmx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pams_jxbb_gsckmx exchange partition p_${batch_date} with table ${iol_schema}.pams_jxbb_gsckmx_cl;
alter table ${iol_schema}.pams_jxbb_gsckmx exchange partition p_20991231 with table ${iol_schema}.pams_jxbb_gsckmx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pams_jxbb_gsckmx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pams_jxbb_gsckmx_op purge;
drop table ${iol_schema}.pams_jxbb_gsckmx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pams_jxbb_gsckmx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pams_jxbb_gsckmx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
