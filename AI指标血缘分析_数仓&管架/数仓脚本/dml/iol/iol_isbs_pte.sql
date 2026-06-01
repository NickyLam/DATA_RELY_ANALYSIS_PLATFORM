/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_pte
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
create table ${iol_schema}.isbs_pte_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_pte;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_pte_op purge;
drop table ${iol_schema}.isbs_pte_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_pte_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_pte where 0=1;

create table ${iol_schema}.isbs_pte_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_pte where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_pte_cl(
            inr -- 内部唯一ID号
            ,objtyp -- 关联PTS的类型
            ,objinr -- 关联PTS的INR
            ,subid -- 标识PTS的多个PTE
            ,cbtpfx -- 表外风险类型
            ,grpkey -- 责任组
            ,extid -- 关联实体CBS
            ,liaptyinr -- 记账用户的PTY的唯一INR
            ,liaptainr -- 记账用户的PTA的唯一INR
            ,cdtptsinr -- 贷方INR
            ,ownref -- 参考号
            ,nam -- 帐务信息
            ,feeinr -- 费用INR
            ,begdat -- 开始日期
            ,clsdat -- 关闭日期
            ,setdat -- 结束日期
            ,nxtcomdat -- 下次费用计算时间
            ,rolpay -- 付费角色
            ,matdat -- 到期日
            ,covtyp -- 结帐类型
            ,prc -- 分配百分比
            ,amtflg -- 记账方式
            ,ver -- 版本号
            ,asgtxt -- 代理人信息
            ,asbtxt -- 代理银行信息
            ,tenday -- 最大到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_pte_op(
            inr -- 内部唯一ID号
            ,objtyp -- 关联PTS的类型
            ,objinr -- 关联PTS的INR
            ,subid -- 标识PTS的多个PTE
            ,cbtpfx -- 表外风险类型
            ,grpkey -- 责任组
            ,extid -- 关联实体CBS
            ,liaptyinr -- 记账用户的PTY的唯一INR
            ,liaptainr -- 记账用户的PTA的唯一INR
            ,cdtptsinr -- 贷方INR
            ,ownref -- 参考号
            ,nam -- 帐务信息
            ,feeinr -- 费用INR
            ,begdat -- 开始日期
            ,clsdat -- 关闭日期
            ,setdat -- 结束日期
            ,nxtcomdat -- 下次费用计算时间
            ,rolpay -- 付费角色
            ,matdat -- 到期日
            ,covtyp -- 结帐类型
            ,prc -- 分配百分比
            ,amtflg -- 记账方式
            ,ver -- 版本号
            ,asgtxt -- 代理人信息
            ,asbtxt -- 代理银行信息
            ,tenday -- 最大到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一ID号
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 关联PTS的类型
    ,nvl(n.objinr, o.objinr) as objinr -- 关联PTS的INR
    ,nvl(n.subid, o.subid) as subid -- 标识PTS的多个PTE
    ,nvl(n.cbtpfx, o.cbtpfx) as cbtpfx -- 表外风险类型
    ,nvl(n.grpkey, o.grpkey) as grpkey -- 责任组
    ,nvl(n.extid, o.extid) as extid -- 关联实体CBS
    ,nvl(n.liaptyinr, o.liaptyinr) as liaptyinr -- 记账用户的PTY的唯一INR
    ,nvl(n.liaptainr, o.liaptainr) as liaptainr -- 记账用户的PTA的唯一INR
    ,nvl(n.cdtptsinr, o.cdtptsinr) as cdtptsinr -- 贷方INR
    ,nvl(n.ownref, o.ownref) as ownref -- 参考号
    ,nvl(n.nam, o.nam) as nam -- 帐务信息
    ,nvl(n.feeinr, o.feeinr) as feeinr -- 费用INR
    ,nvl(n.begdat, o.begdat) as begdat -- 开始日期
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 关闭日期
    ,nvl(n.setdat, o.setdat) as setdat -- 结束日期
    ,nvl(n.nxtcomdat, o.nxtcomdat) as nxtcomdat -- 下次费用计算时间
    ,nvl(n.rolpay, o.rolpay) as rolpay -- 付费角色
    ,nvl(n.matdat, o.matdat) as matdat -- 到期日
    ,nvl(n.covtyp, o.covtyp) as covtyp -- 结帐类型
    ,nvl(n.prc, o.prc) as prc -- 分配百分比
    ,nvl(n.amtflg, o.amtflg) as amtflg -- 记账方式
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.asgtxt, o.asgtxt) as asgtxt -- 代理人信息
    ,nvl(n.asbtxt, o.asbtxt) as asbtxt -- 代理银行信息
    ,nvl(n.tenday, o.tenday) as tenday -- 最大到期日
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_pte_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_pte where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.objtyp <> n.objtyp
        or o.objinr <> n.objinr
        or o.subid <> n.subid
        or o.cbtpfx <> n.cbtpfx
        or o.grpkey <> n.grpkey
        or o.extid <> n.extid
        or o.liaptyinr <> n.liaptyinr
        or o.liaptainr <> n.liaptainr
        or o.cdtptsinr <> n.cdtptsinr
        or o.ownref <> n.ownref
        or o.nam <> n.nam
        or o.feeinr <> n.feeinr
        or o.begdat <> n.begdat
        or o.clsdat <> n.clsdat
        or o.setdat <> n.setdat
        or o.nxtcomdat <> n.nxtcomdat
        or o.rolpay <> n.rolpay
        or o.matdat <> n.matdat
        or o.covtyp <> n.covtyp
        or o.prc <> n.prc
        or o.amtflg <> n.amtflg
        or o.ver <> n.ver
        or o.asgtxt <> n.asgtxt
        or o.asbtxt <> n.asbtxt
        or o.tenday <> n.tenday
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_pte_cl(
            inr -- 内部唯一ID号
            ,objtyp -- 关联PTS的类型
            ,objinr -- 关联PTS的INR
            ,subid -- 标识PTS的多个PTE
            ,cbtpfx -- 表外风险类型
            ,grpkey -- 责任组
            ,extid -- 关联实体CBS
            ,liaptyinr -- 记账用户的PTY的唯一INR
            ,liaptainr -- 记账用户的PTA的唯一INR
            ,cdtptsinr -- 贷方INR
            ,ownref -- 参考号
            ,nam -- 帐务信息
            ,feeinr -- 费用INR
            ,begdat -- 开始日期
            ,clsdat -- 关闭日期
            ,setdat -- 结束日期
            ,nxtcomdat -- 下次费用计算时间
            ,rolpay -- 付费角色
            ,matdat -- 到期日
            ,covtyp -- 结帐类型
            ,prc -- 分配百分比
            ,amtflg -- 记账方式
            ,ver -- 版本号
            ,asgtxt -- 代理人信息
            ,asbtxt -- 代理银行信息
            ,tenday -- 最大到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_pte_op(
            inr -- 内部唯一ID号
            ,objtyp -- 关联PTS的类型
            ,objinr -- 关联PTS的INR
            ,subid -- 标识PTS的多个PTE
            ,cbtpfx -- 表外风险类型
            ,grpkey -- 责任组
            ,extid -- 关联实体CBS
            ,liaptyinr -- 记账用户的PTY的唯一INR
            ,liaptainr -- 记账用户的PTA的唯一INR
            ,cdtptsinr -- 贷方INR
            ,ownref -- 参考号
            ,nam -- 帐务信息
            ,feeinr -- 费用INR
            ,begdat -- 开始日期
            ,clsdat -- 关闭日期
            ,setdat -- 结束日期
            ,nxtcomdat -- 下次费用计算时间
            ,rolpay -- 付费角色
            ,matdat -- 到期日
            ,covtyp -- 结帐类型
            ,prc -- 分配百分比
            ,amtflg -- 记账方式
            ,ver -- 版本号
            ,asgtxt -- 代理人信息
            ,asbtxt -- 代理银行信息
            ,tenday -- 最大到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一ID号
    ,o.objtyp -- 关联PTS的类型
    ,o.objinr -- 关联PTS的INR
    ,o.subid -- 标识PTS的多个PTE
    ,o.cbtpfx -- 表外风险类型
    ,o.grpkey -- 责任组
    ,o.extid -- 关联实体CBS
    ,o.liaptyinr -- 记账用户的PTY的唯一INR
    ,o.liaptainr -- 记账用户的PTA的唯一INR
    ,o.cdtptsinr -- 贷方INR
    ,o.ownref -- 参考号
    ,o.nam -- 帐务信息
    ,o.feeinr -- 费用INR
    ,o.begdat -- 开始日期
    ,o.clsdat -- 关闭日期
    ,o.setdat -- 结束日期
    ,o.nxtcomdat -- 下次费用计算时间
    ,o.rolpay -- 付费角色
    ,o.matdat -- 到期日
    ,o.covtyp -- 结帐类型
    ,o.prc -- 分配百分比
    ,o.amtflg -- 记账方式
    ,o.ver -- 版本号
    ,o.asgtxt -- 代理人信息
    ,o.asbtxt -- 代理银行信息
    ,o.tenday -- 最大到期日
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_pte_bk o
    left join ${iol_schema}.isbs_pte_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_pte_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_pte;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_pte exchange partition p_19000101 with table ${iol_schema}.isbs_pte_cl;
alter table ${iol_schema}.isbs_pte exchange partition p_20991231 with table ${iol_schema}.isbs_pte_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_pte to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_pte_op purge;
drop table ${iol_schema}.isbs_pte_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_pte_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_pte',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
