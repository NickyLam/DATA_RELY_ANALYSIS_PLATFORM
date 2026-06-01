/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_abss_abs_asset_pool
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
create table ${iol_schema}.abss_abs_asset_pool_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.abss_abs_asset_pool
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_abs_asset_pool_op purge;
drop table ${iol_schema}.abss_abs_asset_pool_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_asset_pool_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_abs_asset_pool where 0=1;

create table ${iol_schema}.abss_abs_asset_pool_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_abs_asset_pool where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_abs_asset_pool_cl(
            assetpoolno -- 资产池编号
            ,assetpoolname -- 资产池名称
            ,parentassetpoolno -- 父资产池编号
            ,assetpooltype -- 资产池类型
            ,assetpoolnature -- 资产池性质
            ,assetpoolstatus -- 资产池状态
            ,packetflag -- 是否封包
            ,packetdate -- 封包日
            ,transferdate -- 转让日
            ,collectiondate -- 收款日
            ,packetnum -- 封包日数量
            ,packetsize -- 封包日规模
            ,transferprin -- 转让日本金
            ,collectionprin -- 收款日本金
            ,actualcollection -- 实际收款
            ,assetpoolsize -- 资产池规模
            ,updateuserid -- 更新人ID
            ,updateorgid -- 更新机构ID
            ,updatetime -- 更新时间
            ,unpacketdate -- 解包日
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,newpacketassetcount -- 新增封包申请时资产个数
            ,arearatio -- 区域集中度筛选
            ,industryratio -- 行业集中度
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记时间
            ,packetaccsize -- 封包日累计规模
            ,packetaccnum -- 资产池累计资产个数
            ,collectionaccountname -- 收款账户名称
            ,collectionaccountid -- 收款账户账号
            ,collectionaccountorgid -- 收款账户所属机构
            ,recollectionaccountname -- 回款归集账户名称
            ,recollectionaccountid -- 回款归集账户账号
            ,recollectionaccountorgid -- 回款归集账户所属机构
            ,packetwaremamaturity -- 封包时加权剩余期限
            ,packetwarate -- 封包时加权平均利率
            ,accruedchargedate -- 费用计提日
            ,totalassetpoolsize -- 实时资产池规模
            ,isbad -- 不良资产标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_abs_asset_pool_op(
            assetpoolno -- 资产池编号
            ,assetpoolname -- 资产池名称
            ,parentassetpoolno -- 父资产池编号
            ,assetpooltype -- 资产池类型
            ,assetpoolnature -- 资产池性质
            ,assetpoolstatus -- 资产池状态
            ,packetflag -- 是否封包
            ,packetdate -- 封包日
            ,transferdate -- 转让日
            ,collectiondate -- 收款日
            ,packetnum -- 封包日数量
            ,packetsize -- 封包日规模
            ,transferprin -- 转让日本金
            ,collectionprin -- 收款日本金
            ,actualcollection -- 实际收款
            ,assetpoolsize -- 资产池规模
            ,updateuserid -- 更新人ID
            ,updateorgid -- 更新机构ID
            ,updatetime -- 更新时间
            ,unpacketdate -- 解包日
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,newpacketassetcount -- 新增封包申请时资产个数
            ,arearatio -- 区域集中度筛选
            ,industryratio -- 行业集中度
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记时间
            ,packetaccsize -- 封包日累计规模
            ,packetaccnum -- 资产池累计资产个数
            ,collectionaccountname -- 收款账户名称
            ,collectionaccountid -- 收款账户账号
            ,collectionaccountorgid -- 收款账户所属机构
            ,recollectionaccountname -- 回款归集账户名称
            ,recollectionaccountid -- 回款归集账户账号
            ,recollectionaccountorgid -- 回款归集账户所属机构
            ,packetwaremamaturity -- 封包时加权剩余期限
            ,packetwarate -- 封包时加权平均利率
            ,accruedchargedate -- 费用计提日
            ,totalassetpoolsize -- 实时资产池规模
            ,isbad -- 不良资产标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.assetpoolno, o.assetpoolno) as assetpoolno -- 资产池编号
    ,nvl(n.assetpoolname, o.assetpoolname) as assetpoolname -- 资产池名称
    ,nvl(n.parentassetpoolno, o.parentassetpoolno) as parentassetpoolno -- 父资产池编号
    ,nvl(n.assetpooltype, o.assetpooltype) as assetpooltype -- 资产池类型
    ,nvl(n.assetpoolnature, o.assetpoolnature) as assetpoolnature -- 资产池性质
    ,nvl(n.assetpoolstatus, o.assetpoolstatus) as assetpoolstatus -- 资产池状态
    ,nvl(n.packetflag, o.packetflag) as packetflag -- 是否封包
    ,nvl(n.packetdate, o.packetdate) as packetdate -- 封包日
    ,nvl(n.transferdate, o.transferdate) as transferdate -- 转让日
    ,nvl(n.collectiondate, o.collectiondate) as collectiondate -- 收款日
    ,nvl(n.packetnum, o.packetnum) as packetnum -- 封包日数量
    ,nvl(n.packetsize, o.packetsize) as packetsize -- 封包日规模
    ,nvl(n.transferprin, o.transferprin) as transferprin -- 转让日本金
    ,nvl(n.collectionprin, o.collectionprin) as collectionprin -- 收款日本金
    ,nvl(n.actualcollection, o.actualcollection) as actualcollection -- 实际收款
    ,nvl(n.assetpoolsize, o.assetpoolsize) as assetpoolsize -- 资产池规模
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人ID
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构ID
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.unpacketdate, o.unpacketdate) as unpacketdate -- 解包日
    ,nvl(n.finishtype, o.finishtype) as finishtype -- 终结类型
    ,nvl(n.finishdate, o.finishdate) as finishdate -- 终结日期
    ,nvl(n.newpacketassetcount, o.newpacketassetcount) as newpacketassetcount -- 新增封包申请时资产个数
    ,nvl(n.arearatio, o.arearatio) as arearatio -- 区域集中度筛选
    ,nvl(n.industryratio, o.industryratio) as industryratio -- 行业集中度
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 登记时间
    ,nvl(n.packetaccsize, o.packetaccsize) as packetaccsize -- 封包日累计规模
    ,nvl(n.packetaccnum, o.packetaccnum) as packetaccnum -- 资产池累计资产个数
    ,nvl(n.collectionaccountname, o.collectionaccountname) as collectionaccountname -- 收款账户名称
    ,nvl(n.collectionaccountid, o.collectionaccountid) as collectionaccountid -- 收款账户账号
    ,nvl(n.collectionaccountorgid, o.collectionaccountorgid) as collectionaccountorgid -- 收款账户所属机构
    ,nvl(n.recollectionaccountname, o.recollectionaccountname) as recollectionaccountname -- 回款归集账户名称
    ,nvl(n.recollectionaccountid, o.recollectionaccountid) as recollectionaccountid -- 回款归集账户账号
    ,nvl(n.recollectionaccountorgid, o.recollectionaccountorgid) as recollectionaccountorgid -- 回款归集账户所属机构
    ,nvl(n.packetwaremamaturity, o.packetwaremamaturity) as packetwaremamaturity -- 封包时加权剩余期限
    ,nvl(n.packetwarate, o.packetwarate) as packetwarate -- 封包时加权平均利率
    ,nvl(n.accruedchargedate, o.accruedchargedate) as accruedchargedate -- 费用计提日
    ,nvl(n.totalassetpoolsize, o.totalassetpoolsize) as totalassetpoolsize -- 实时资产池规模
    ,nvl(n.isbad, o.isbad) as isbad -- 不良资产标志
    ,case when
            n.assetpoolno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.assetpoolno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.assetpoolno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.abss_abs_asset_pool_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.abss_abs_asset_pool where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.assetpoolno = n.assetpoolno
where (
        o.assetpoolno is null
    )
    or (
        n.assetpoolno is null
    )
    or (
        o.assetpoolname <> n.assetpoolname
        or o.parentassetpoolno <> n.parentassetpoolno
        or o.assetpooltype <> n.assetpooltype
        or o.assetpoolnature <> n.assetpoolnature
        or o.assetpoolstatus <> n.assetpoolstatus
        or o.packetflag <> n.packetflag
        or o.packetdate <> n.packetdate
        or o.transferdate <> n.transferdate
        or o.collectiondate <> n.collectiondate
        or o.packetnum <> n.packetnum
        or o.packetsize <> n.packetsize
        or o.transferprin <> n.transferprin
        or o.collectionprin <> n.collectionprin
        or o.actualcollection <> n.actualcollection
        or o.assetpoolsize <> n.assetpoolsize
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatetime <> n.updatetime
        or o.unpacketdate <> n.unpacketdate
        or o.finishtype <> n.finishtype
        or o.finishdate <> n.finishdate
        or o.newpacketassetcount <> n.newpacketassetcount
        or o.arearatio <> n.arearatio
        or o.industryratio <> n.industryratio
        or o.currency <> n.currency
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputtime <> n.inputtime
        or o.packetaccsize <> n.packetaccsize
        or o.packetaccnum <> n.packetaccnum
        or o.collectionaccountname <> n.collectionaccountname
        or o.collectionaccountid <> n.collectionaccountid
        or o.collectionaccountorgid <> n.collectionaccountorgid
        or o.recollectionaccountname <> n.recollectionaccountname
        or o.recollectionaccountid <> n.recollectionaccountid
        or o.recollectionaccountorgid <> n.recollectionaccountorgid
        or o.packetwaremamaturity <> n.packetwaremamaturity
        or o.packetwarate <> n.packetwarate
        or o.accruedchargedate <> n.accruedchargedate
        or o.totalassetpoolsize <> n.totalassetpoolsize
        or o.isbad <> n.isbad
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_abs_asset_pool_cl(
            assetpoolno -- 资产池编号
            ,assetpoolname -- 资产池名称
            ,parentassetpoolno -- 父资产池编号
            ,assetpooltype -- 资产池类型
            ,assetpoolnature -- 资产池性质
            ,assetpoolstatus -- 资产池状态
            ,packetflag -- 是否封包
            ,packetdate -- 封包日
            ,transferdate -- 转让日
            ,collectiondate -- 收款日
            ,packetnum -- 封包日数量
            ,packetsize -- 封包日规模
            ,transferprin -- 转让日本金
            ,collectionprin -- 收款日本金
            ,actualcollection -- 实际收款
            ,assetpoolsize -- 资产池规模
            ,updateuserid -- 更新人ID
            ,updateorgid -- 更新机构ID
            ,updatetime -- 更新时间
            ,unpacketdate -- 解包日
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,newpacketassetcount -- 新增封包申请时资产个数
            ,arearatio -- 区域集中度筛选
            ,industryratio -- 行业集中度
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记时间
            ,packetaccsize -- 封包日累计规模
            ,packetaccnum -- 资产池累计资产个数
            ,collectionaccountname -- 收款账户名称
            ,collectionaccountid -- 收款账户账号
            ,collectionaccountorgid -- 收款账户所属机构
            ,recollectionaccountname -- 回款归集账户名称
            ,recollectionaccountid -- 回款归集账户账号
            ,recollectionaccountorgid -- 回款归集账户所属机构
            ,packetwaremamaturity -- 封包时加权剩余期限
            ,packetwarate -- 封包时加权平均利率
            ,accruedchargedate -- 费用计提日
            ,totalassetpoolsize -- 实时资产池规模
            ,isbad -- 不良资产标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_abs_asset_pool_op(
            assetpoolno -- 资产池编号
            ,assetpoolname -- 资产池名称
            ,parentassetpoolno -- 父资产池编号
            ,assetpooltype -- 资产池类型
            ,assetpoolnature -- 资产池性质
            ,assetpoolstatus -- 资产池状态
            ,packetflag -- 是否封包
            ,packetdate -- 封包日
            ,transferdate -- 转让日
            ,collectiondate -- 收款日
            ,packetnum -- 封包日数量
            ,packetsize -- 封包日规模
            ,transferprin -- 转让日本金
            ,collectionprin -- 收款日本金
            ,actualcollection -- 实际收款
            ,assetpoolsize -- 资产池规模
            ,updateuserid -- 更新人ID
            ,updateorgid -- 更新机构ID
            ,updatetime -- 更新时间
            ,unpacketdate -- 解包日
            ,finishtype -- 终结类型
            ,finishdate -- 终结日期
            ,newpacketassetcount -- 新增封包申请时资产个数
            ,arearatio -- 区域集中度筛选
            ,industryratio -- 行业集中度
            ,currency -- 币种
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputtime -- 登记时间
            ,packetaccsize -- 封包日累计规模
            ,packetaccnum -- 资产池累计资产个数
            ,collectionaccountname -- 收款账户名称
            ,collectionaccountid -- 收款账户账号
            ,collectionaccountorgid -- 收款账户所属机构
            ,recollectionaccountname -- 回款归集账户名称
            ,recollectionaccountid -- 回款归集账户账号
            ,recollectionaccountorgid -- 回款归集账户所属机构
            ,packetwaremamaturity -- 封包时加权剩余期限
            ,packetwarate -- 封包时加权平均利率
            ,accruedchargedate -- 费用计提日
            ,totalassetpoolsize -- 实时资产池规模
            ,isbad -- 不良资产标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.assetpoolno -- 资产池编号
    ,o.assetpoolname -- 资产池名称
    ,o.parentassetpoolno -- 父资产池编号
    ,o.assetpooltype -- 资产池类型
    ,o.assetpoolnature -- 资产池性质
    ,o.assetpoolstatus -- 资产池状态
    ,o.packetflag -- 是否封包
    ,o.packetdate -- 封包日
    ,o.transferdate -- 转让日
    ,o.collectiondate -- 收款日
    ,o.packetnum -- 封包日数量
    ,o.packetsize -- 封包日规模
    ,o.transferprin -- 转让日本金
    ,o.collectionprin -- 收款日本金
    ,o.actualcollection -- 实际收款
    ,o.assetpoolsize -- 资产池规模
    ,o.updateuserid -- 更新人ID
    ,o.updateorgid -- 更新机构ID
    ,o.updatetime -- 更新时间
    ,o.unpacketdate -- 解包日
    ,o.finishtype -- 终结类型
    ,o.finishdate -- 终结日期
    ,o.newpacketassetcount -- 新增封包申请时资产个数
    ,o.arearatio -- 区域集中度筛选
    ,o.industryratio -- 行业集中度
    ,o.currency -- 币种
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputtime -- 登记时间
    ,o.packetaccsize -- 封包日累计规模
    ,o.packetaccnum -- 资产池累计资产个数
    ,o.collectionaccountname -- 收款账户名称
    ,o.collectionaccountid -- 收款账户账号
    ,o.collectionaccountorgid -- 收款账户所属机构
    ,o.recollectionaccountname -- 回款归集账户名称
    ,o.recollectionaccountid -- 回款归集账户账号
    ,o.recollectionaccountorgid -- 回款归集账户所属机构
    ,o.packetwaremamaturity -- 封包时加权剩余期限
    ,o.packetwarate -- 封包时加权平均利率
    ,o.accruedchargedate -- 费用计提日
    ,o.totalassetpoolsize -- 实时资产池规模
    ,o.isbad -- 不良资产标志
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
from ${iol_schema}.abss_abs_asset_pool_bk o
    left join ${iol_schema}.abss_abs_asset_pool_op n
        on
            o.assetpoolno = n.assetpoolno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.abss_abs_asset_pool_cl d
        on
            o.assetpoolno = d.assetpoolno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.abss_abs_asset_pool;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('abss_abs_asset_pool') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.abss_abs_asset_pool drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.abss_abs_asset_pool add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.abss_abs_asset_pool exchange partition p_${batch_date} with table ${iol_schema}.abss_abs_asset_pool_cl;
alter table ${iol_schema}.abss_abs_asset_pool exchange partition p_20991231 with table ${iol_schema}.abss_abs_asset_pool_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.abss_abs_asset_pool to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_abs_asset_pool_op purge;
drop table ${iol_schema}.abss_abs_asset_pool_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.abss_abs_asset_pool_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'abss_abs_asset_pool',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
