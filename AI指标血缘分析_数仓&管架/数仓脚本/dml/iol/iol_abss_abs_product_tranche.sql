/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_abss_abs_product_tranche
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
create table ${iol_schema}.abss_abs_product_tranche_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.abss_abs_product_tranche;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_abs_product_tranche_op purge;
drop table ${iol_schema}.abss_abs_product_tranche_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_abs_product_tranche_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_abs_product_tranche where 0=1;

create table ${iol_schema}.abss_abs_product_tranche_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_abs_product_tranche where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_abs_product_tranche_cl(
            trancheid -- 分档编号
            ,productid -- 产品编号
            ,tranchetype -- 分档类型
            ,tranchename -- 分档名称
            ,currency -- 币种
            ,trancheamountratio -- 分档金额占比
            ,trancheamount -- 分档金额
            ,selfholdratio -- 自持比例
            ,maturity -- 法定到期日
            ,ratinglevel1 -- 评级级别1
            ,ratingagency1 -- 评级机构1
            ,ratinglevel2 -- 评级级别2
            ,ratingagency2 -- 评级机构2
            ,remark -- 备注
            ,exchangeservicefee -- 兑换服务费
            ,premiumdiscountrate -- 溢价折价率
            ,tempsaveflag -- 暂存标识
            ,begindate -- 起始日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_abs_product_tranche_op(
            trancheid -- 分档编号
            ,productid -- 产品编号
            ,tranchetype -- 分档类型
            ,tranchename -- 分档名称
            ,currency -- 币种
            ,trancheamountratio -- 分档金额占比
            ,trancheamount -- 分档金额
            ,selfholdratio -- 自持比例
            ,maturity -- 法定到期日
            ,ratinglevel1 -- 评级级别1
            ,ratingagency1 -- 评级机构1
            ,ratinglevel2 -- 评级级别2
            ,ratingagency2 -- 评级机构2
            ,remark -- 备注
            ,exchangeservicefee -- 兑换服务费
            ,premiumdiscountrate -- 溢价折价率
            ,tempsaveflag -- 暂存标识
            ,begindate -- 起始日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trancheid, o.trancheid) as trancheid -- 分档编号
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.tranchetype, o.tranchetype) as tranchetype -- 分档类型
    ,nvl(n.tranchename, o.tranchename) as tranchename -- 分档名称
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.trancheamountratio, o.trancheamountratio) as trancheamountratio -- 分档金额占比
    ,nvl(n.trancheamount, o.trancheamount) as trancheamount -- 分档金额
    ,nvl(n.selfholdratio, o.selfholdratio) as selfholdratio -- 自持比例
    ,nvl(n.maturity, o.maturity) as maturity -- 法定到期日
    ,nvl(n.ratinglevel1, o.ratinglevel1) as ratinglevel1 -- 评级级别1
    ,nvl(n.ratingagency1, o.ratingagency1) as ratingagency1 -- 评级机构1
    ,nvl(n.ratinglevel2, o.ratinglevel2) as ratinglevel2 -- 评级级别2
    ,nvl(n.ratingagency2, o.ratingagency2) as ratingagency2 -- 评级机构2
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.exchangeservicefee, o.exchangeservicefee) as exchangeservicefee -- 兑换服务费
    ,nvl(n.premiumdiscountrate, o.premiumdiscountrate) as premiumdiscountrate -- 溢价折价率
    ,nvl(n.tempsaveflag, o.tempsaveflag) as tempsaveflag -- 暂存标识
    ,nvl(n.begindate, o.begindate) as begindate -- 起始日期
    ,case when
            n.trancheid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trancheid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trancheid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.abss_abs_product_tranche_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.abss_abs_product_tranche where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trancheid = n.trancheid
where (
        o.trancheid is null
    )
    or (
        n.trancheid is null
    )
    or (
        o.productid <> n.productid
        or o.tranchetype <> n.tranchetype
        or o.tranchename <> n.tranchename
        or o.currency <> n.currency
        or o.trancheamountratio <> n.trancheamountratio
        or o.trancheamount <> n.trancheamount
        or o.selfholdratio <> n.selfholdratio
        or o.maturity <> n.maturity
        or o.ratinglevel1 <> n.ratinglevel1
        or o.ratingagency1 <> n.ratingagency1
        or o.ratinglevel2 <> n.ratinglevel2
        or o.ratingagency2 <> n.ratingagency2
        or o.remark <> n.remark
        or o.exchangeservicefee <> n.exchangeservicefee
        or o.premiumdiscountrate <> n.premiumdiscountrate
        or o.tempsaveflag <> n.tempsaveflag
        or o.begindate <> n.begindate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_abs_product_tranche_cl(
            trancheid -- 分档编号
            ,productid -- 产品编号
            ,tranchetype -- 分档类型
            ,tranchename -- 分档名称
            ,currency -- 币种
            ,trancheamountratio -- 分档金额占比
            ,trancheamount -- 分档金额
            ,selfholdratio -- 自持比例
            ,maturity -- 法定到期日
            ,ratinglevel1 -- 评级级别1
            ,ratingagency1 -- 评级机构1
            ,ratinglevel2 -- 评级级别2
            ,ratingagency2 -- 评级机构2
            ,remark -- 备注
            ,exchangeservicefee -- 兑换服务费
            ,premiumdiscountrate -- 溢价折价率
            ,tempsaveflag -- 暂存标识
            ,begindate -- 起始日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_abs_product_tranche_op(
            trancheid -- 分档编号
            ,productid -- 产品编号
            ,tranchetype -- 分档类型
            ,tranchename -- 分档名称
            ,currency -- 币种
            ,trancheamountratio -- 分档金额占比
            ,trancheamount -- 分档金额
            ,selfholdratio -- 自持比例
            ,maturity -- 法定到期日
            ,ratinglevel1 -- 评级级别1
            ,ratingagency1 -- 评级机构1
            ,ratinglevel2 -- 评级级别2
            ,ratingagency2 -- 评级机构2
            ,remark -- 备注
            ,exchangeservicefee -- 兑换服务费
            ,premiumdiscountrate -- 溢价折价率
            ,tempsaveflag -- 暂存标识
            ,begindate -- 起始日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trancheid -- 分档编号
    ,o.productid -- 产品编号
    ,o.tranchetype -- 分档类型
    ,o.tranchename -- 分档名称
    ,o.currency -- 币种
    ,o.trancheamountratio -- 分档金额占比
    ,o.trancheamount -- 分档金额
    ,o.selfholdratio -- 自持比例
    ,o.maturity -- 法定到期日
    ,o.ratinglevel1 -- 评级级别1
    ,o.ratingagency1 -- 评级机构1
    ,o.ratinglevel2 -- 评级级别2
    ,o.ratingagency2 -- 评级机构2
    ,o.remark -- 备注
    ,o.exchangeservicefee -- 兑换服务费
    ,o.premiumdiscountrate -- 溢价折价率
    ,o.tempsaveflag -- 暂存标识
    ,o.begindate -- 起始日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.abss_abs_product_tranche_bk o
    left join ${iol_schema}.abss_abs_product_tranche_op n
        on
            o.trancheid = n.trancheid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.abss_abs_product_tranche_cl d
        on
            o.trancheid = d.trancheid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.abss_abs_product_tranche;

-- 4.2 exchange partition
alter table ${iol_schema}.abss_abs_product_tranche exchange partition p_19000101 with table ${iol_schema}.abss_abs_product_tranche_cl;
alter table ${iol_schema}.abss_abs_product_tranche exchange partition p_20991231 with table ${iol_schema}.abss_abs_product_tranche_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.abss_abs_product_tranche to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_abs_product_tranche_op purge;
drop table ${iol_schema}.abss_abs_product_tranche_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.abss_abs_product_tranche_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'abss_abs_product_tranche',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
