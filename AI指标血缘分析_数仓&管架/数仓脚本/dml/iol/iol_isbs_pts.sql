/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_pts
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
create table ${iol_schema}.isbs_pts_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_pts;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_pts_op purge;
drop table ${iol_schema}.isbs_pts_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_pts_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_pts where 0=1;

create table ${iol_schema}.isbs_pts_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_pts where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_pts_cl(
            inr -- 内部唯一ID号
            ,objtyp -- 联系实体类型
            ,objinr -- 联系实体INR
            ,rol -- 角色类型
            ,ptainr -- 关联地址的INR
            ,ptyinr -- 关联当事人INR
            ,extkey -- 联系地址外部关键字
            ,adrblk -- 地址信息
            ,ref -- 地址参考
            ,nam -- 当事人基本名称
            ,ownref -- 交易参考号和角色
            ,dftcur -- 默认货币种类
            ,dftdsp -- 默认的角色等级
            ,dftact -- 默认账户种类
            ,dftfeecur -- 默认费用使用的货币种类
            ,dftactptainr -- 默认帐户
            ,glggrpflg -- 费用合计方式标志
            ,extact -- 帐号
            ,ver -- 版本号
            ,bankno -- 银行号
            ,issbaninf -- 
            ,adrblkcn -- 
            ,bankno1  -- 人行行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_pts_op(
            inr -- 内部唯一ID号
            ,objtyp -- 联系实体类型
            ,objinr -- 联系实体INR
            ,rol -- 角色类型
            ,ptainr -- 关联地址的INR
            ,ptyinr -- 关联当事人INR
            ,extkey -- 联系地址外部关键字
            ,adrblk -- 地址信息
            ,ref -- 地址参考
            ,nam -- 当事人基本名称
            ,ownref -- 交易参考号和角色
            ,dftcur -- 默认货币种类
            ,dftdsp -- 默认的角色等级
            ,dftact -- 默认账户种类
            ,dftfeecur -- 默认费用使用的货币种类
            ,dftactptainr -- 默认帐户
            ,glggrpflg -- 费用合计方式标志
            ,extact -- 帐号
            ,ver -- 版本号
            ,bankno -- 银行号
            ,issbaninf -- 
            ,adrblkcn -- 
            ,bankno1  -- 人行行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一ID号
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 联系实体类型
    ,nvl(n.objinr, o.objinr) as objinr -- 联系实体INR
    ,nvl(n.rol, o.rol) as rol -- 角色类型
    ,nvl(n.ptainr, o.ptainr) as ptainr -- 关联地址的INR
    ,nvl(n.ptyinr, o.ptyinr) as ptyinr -- 关联当事人INR
    ,nvl(n.extkey, o.extkey) as extkey -- 联系地址外部关键字
    ,nvl(n.adrblk, o.adrblk) as adrblk -- 地址信息
    ,nvl(n.ref, o.ref) as ref -- 地址参考
    ,nvl(n.nam, o.nam) as nam -- 当事人基本名称
    ,nvl(n.ownref, o.ownref) as ownref -- 交易参考号和角色
    ,nvl(n.dftcur, o.dftcur) as dftcur -- 默认货币种类
    ,nvl(n.dftdsp, o.dftdsp) as dftdsp -- 默认的角色等级
    ,nvl(n.dftact, o.dftact) as dftact -- 默认账户种类
    ,nvl(n.dftfeecur, o.dftfeecur) as dftfeecur -- 默认费用使用的货币种类
    ,nvl(n.dftactptainr, o.dftactptainr) as dftactptainr -- 默认帐户
    ,nvl(n.glggrpflg, o.glggrpflg) as glggrpflg -- 费用合计方式标志
    ,nvl(n.extact, o.extact) as extact -- 帐号
    ,nvl(n.ver, o.ver) as ver -- 版本号
    ,nvl(n.bankno, o.bankno) as bankno -- 银行号
    ,nvl(n.issbaninf, o.issbaninf) as issbaninf -- 
    ,nvl(n.adrblkcn, o.adrblkcn) as adrblkcn -- 
    ,nvl(n.bankno1 , o.bankno1 ) as bankno1  -- 人行行号
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
from (select * from ${iol_schema}.isbs_pts_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_pts where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.rol <> n.rol
        or o.ptainr <> n.ptainr
        or o.ptyinr <> n.ptyinr
        or o.extkey <> n.extkey
        or o.adrblk <> n.adrblk
        or o.ref <> n.ref
        or o.nam <> n.nam
        or o.ownref <> n.ownref
        or o.dftcur <> n.dftcur
        or o.dftdsp <> n.dftdsp
        or o.dftact <> n.dftact
        or o.dftfeecur <> n.dftfeecur
        or o.dftactptainr <> n.dftactptainr
        or o.glggrpflg <> n.glggrpflg
        or o.extact <> n.extact
        or o.ver <> n.ver
        or o.bankno <> n.bankno
        or o.issbaninf <> n.issbaninf
        or o.adrblkcn <> n.adrblkcn
        or o.bankno1  <> n.bankno1 
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_pts_cl(
            inr -- 内部唯一ID号
            ,objtyp -- 联系实体类型
            ,objinr -- 联系实体INR
            ,rol -- 角色类型
            ,ptainr -- 关联地址的INR
            ,ptyinr -- 关联当事人INR
            ,extkey -- 联系地址外部关键字
            ,adrblk -- 地址信息
            ,ref -- 地址参考
            ,nam -- 当事人基本名称
            ,ownref -- 交易参考号和角色
            ,dftcur -- 默认货币种类
            ,dftdsp -- 默认的角色等级
            ,dftact -- 默认账户种类
            ,dftfeecur -- 默认费用使用的货币种类
            ,dftactptainr -- 默认帐户
            ,glggrpflg -- 费用合计方式标志
            ,extact -- 帐号
            ,ver -- 版本号
            ,bankno -- 银行号
            ,issbaninf -- 
            ,adrblkcn -- 
            ,bankno1  -- 人行行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_pts_op(
            inr -- 内部唯一ID号
            ,objtyp -- 联系实体类型
            ,objinr -- 联系实体INR
            ,rol -- 角色类型
            ,ptainr -- 关联地址的INR
            ,ptyinr -- 关联当事人INR
            ,extkey -- 联系地址外部关键字
            ,adrblk -- 地址信息
            ,ref -- 地址参考
            ,nam -- 当事人基本名称
            ,ownref -- 交易参考号和角色
            ,dftcur -- 默认货币种类
            ,dftdsp -- 默认的角色等级
            ,dftact -- 默认账户种类
            ,dftfeecur -- 默认费用使用的货币种类
            ,dftactptainr -- 默认帐户
            ,glggrpflg -- 费用合计方式标志
            ,extact -- 帐号
            ,ver -- 版本号
            ,bankno -- 银行号
            ,issbaninf -- 
            ,adrblkcn -- 
            ,bankno1  -- 人行行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一ID号
    ,o.objtyp -- 联系实体类型
    ,o.objinr -- 联系实体INR
    ,o.rol -- 角色类型
    ,o.ptainr -- 关联地址的INR
    ,o.ptyinr -- 关联当事人INR
    ,o.extkey -- 联系地址外部关键字
    ,o.adrblk -- 地址信息
    ,o.ref -- 地址参考
    ,o.nam -- 当事人基本名称
    ,o.ownref -- 交易参考号和角色
    ,o.dftcur -- 默认货币种类
    ,o.dftdsp -- 默认的角色等级
    ,o.dftact -- 默认账户种类
    ,o.dftfeecur -- 默认费用使用的货币种类
    ,o.dftactptainr -- 默认帐户
    ,o.glggrpflg -- 费用合计方式标志
    ,o.extact -- 帐号
    ,o.ver -- 版本号
    ,o.bankno -- 银行号
    ,o.issbaninf -- 
    ,o.adrblkcn -- 
    ,o.bankno1  -- 人行行号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_pts_bk o
    left join ${iol_schema}.isbs_pts_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_pts_cl d
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
-- truncate table ${iol_schema}.isbs_pts;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_pts exchange partition p_19000101 with table ${iol_schema}.isbs_pts_cl;
alter table ${iol_schema}.isbs_pts exchange partition p_20991231 with table ${iol_schema}.isbs_pts_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_pts to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_pts_op purge;
drop table ${iol_schema}.isbs_pts_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_pts_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_pts',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
