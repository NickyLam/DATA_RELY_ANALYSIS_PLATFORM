/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_finance_listedstock
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
create table ${iol_schema}.icms_clr_asset_finance_listedstock_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_finance_listedstock
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_listedstock_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_listedstock_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_listedstock_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_listedstock where 0=1;

create table ${iol_schema}.icms_clr_asset_finance_listedstock_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_listedstock where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_listedstock_cl(
            clrid -- 押品编号
            ,stockcode -- 股票代码
            ,stockname -- 股票名称
            ,companyname -- 公司名称
            ,isborrower -- 发行人是否为借款人
            ,profits -- 公司上年度利润
            ,isnromal -- 股票状态是否正常
            ,bourse -- 交易所名称
            ,ispublic -- 是否公开交易
            ,exponent -- 主要指数成分股及其名称
            ,shareamount -- 持股数量
            ,stockamount -- 出质股权数额
            ,persharemarketprice -- 每股市价
            ,profitmoney -- 上年每股分红金额
            ,warningline -- 警戒线
            ,persharevalue -- 每股净资产
            ,liquidateline -- 平仓线
            ,totalvalue -- 质押总价值
            ,duedate -- 限售到期日
            ,remark -- 股票其他说明
            ,tdcurrency -- 币种
            ,stockidc -- 股票托管券商
            ,pledgeregistration -- 质押登记号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,pledgetag -- 场内外质押标签
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_listedstock_op(
            clrid -- 押品编号
            ,stockcode -- 股票代码
            ,stockname -- 股票名称
            ,companyname -- 公司名称
            ,isborrower -- 发行人是否为借款人
            ,profits -- 公司上年度利润
            ,isnromal -- 股票状态是否正常
            ,bourse -- 交易所名称
            ,ispublic -- 是否公开交易
            ,exponent -- 主要指数成分股及其名称
            ,shareamount -- 持股数量
            ,stockamount -- 出质股权数额
            ,persharemarketprice -- 每股市价
            ,profitmoney -- 上年每股分红金额
            ,warningline -- 警戒线
            ,persharevalue -- 每股净资产
            ,liquidateline -- 平仓线
            ,totalvalue -- 质押总价值
            ,duedate -- 限售到期日
            ,remark -- 股票其他说明
            ,tdcurrency -- 币种
            ,stockidc -- 股票托管券商
            ,pledgeregistration -- 质押登记号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,pledgetag -- 场内外质押标签
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.stockcode, o.stockcode) as stockcode -- 股票代码
    ,nvl(n.stockname, o.stockname) as stockname -- 股票名称
    ,nvl(n.companyname, o.companyname) as companyname -- 公司名称
    ,nvl(n.isborrower, o.isborrower) as isborrower -- 发行人是否为借款人
    ,nvl(n.profits, o.profits) as profits -- 公司上年度利润
    ,nvl(n.isnromal, o.isnromal) as isnromal -- 股票状态是否正常
    ,nvl(n.bourse, o.bourse) as bourse -- 交易所名称
    ,nvl(n.ispublic, o.ispublic) as ispublic -- 是否公开交易
    ,nvl(n.exponent, o.exponent) as exponent -- 主要指数成分股及其名称
    ,nvl(n.shareamount, o.shareamount) as shareamount -- 持股数量
    ,nvl(n.stockamount, o.stockamount) as stockamount -- 出质股权数额
    ,nvl(n.persharemarketprice, o.persharemarketprice) as persharemarketprice -- 每股市价
    ,nvl(n.profitmoney, o.profitmoney) as profitmoney -- 上年每股分红金额
    ,nvl(n.warningline, o.warningline) as warningline -- 警戒线
    ,nvl(n.persharevalue, o.persharevalue) as persharevalue -- 每股净资产
    ,nvl(n.liquidateline, o.liquidateline) as liquidateline -- 平仓线
    ,nvl(n.totalvalue, o.totalvalue) as totalvalue -- 质押总价值
    ,nvl(n.duedate, o.duedate) as duedate -- 限售到期日
    ,nvl(n.remark, o.remark) as remark -- 股票其他说明
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,nvl(n.stockidc, o.stockidc) as stockidc -- 股票托管券商
    ,nvl(n.pledgeregistration, o.pledgeregistration) as pledgeregistration -- 质押登记号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,nvl(n.pledgetag, o.pledgetag) as pledgetag -- 场内外质押标签
    ,case when
            n.clrid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clrid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clrid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_asset_finance_listedstock_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_finance_listedstock where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.stockcode <> n.stockcode
        or o.stockname <> n.stockname
        or o.companyname <> n.companyname
        or o.isborrower <> n.isborrower
        or o.profits <> n.profits
        or o.isnromal <> n.isnromal
        or o.bourse <> n.bourse
        or o.ispublic <> n.ispublic
        or o.exponent <> n.exponent
        or o.shareamount <> n.shareamount
        or o.stockamount <> n.stockamount
        or o.persharemarketprice <> n.persharemarketprice
        or o.profitmoney <> n.profitmoney
        or o.warningline <> n.warningline
        or o.persharevalue <> n.persharevalue
        or o.liquidateline <> n.liquidateline
        or o.totalvalue <> n.totalvalue
        or o.duedate <> n.duedate
        or o.remark <> n.remark
        or o.tdcurrency <> n.tdcurrency
        or o.stockidc <> n.stockidc
        or o.pledgeregistration <> n.pledgeregistration
        or o.migtflag <> n.migtflag
        or o.pledgetag <> n.pledgetag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_listedstock_cl(
            clrid -- 押品编号
            ,stockcode -- 股票代码
            ,stockname -- 股票名称
            ,companyname -- 公司名称
            ,isborrower -- 发行人是否为借款人
            ,profits -- 公司上年度利润
            ,isnromal -- 股票状态是否正常
            ,bourse -- 交易所名称
            ,ispublic -- 是否公开交易
            ,exponent -- 主要指数成分股及其名称
            ,shareamount -- 持股数量
            ,stockamount -- 出质股权数额
            ,persharemarketprice -- 每股市价
            ,profitmoney -- 上年每股分红金额
            ,warningline -- 警戒线
            ,persharevalue -- 每股净资产
            ,liquidateline -- 平仓线
            ,totalvalue -- 质押总价值
            ,duedate -- 限售到期日
            ,remark -- 股票其他说明
            ,tdcurrency -- 币种
            ,stockidc -- 股票托管券商
            ,pledgeregistration -- 质押登记号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,pledgetag -- 场内外质押标签
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_listedstock_op(
            clrid -- 押品编号
            ,stockcode -- 股票代码
            ,stockname -- 股票名称
            ,companyname -- 公司名称
            ,isborrower -- 发行人是否为借款人
            ,profits -- 公司上年度利润
            ,isnromal -- 股票状态是否正常
            ,bourse -- 交易所名称
            ,ispublic -- 是否公开交易
            ,exponent -- 主要指数成分股及其名称
            ,shareamount -- 持股数量
            ,stockamount -- 出质股权数额
            ,persharemarketprice -- 每股市价
            ,profitmoney -- 上年每股分红金额
            ,warningline -- 警戒线
            ,persharevalue -- 每股净资产
            ,liquidateline -- 平仓线
            ,totalvalue -- 质押总价值
            ,duedate -- 限售到期日
            ,remark -- 股票其他说明
            ,tdcurrency -- 币种
            ,stockidc -- 股票托管券商
            ,pledgeregistration -- 质押登记号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,pledgetag -- 场内外质押标签
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.stockcode -- 股票代码
    ,o.stockname -- 股票名称
    ,o.companyname -- 公司名称
    ,o.isborrower -- 发行人是否为借款人
    ,o.profits -- 公司上年度利润
    ,o.isnromal -- 股票状态是否正常
    ,o.bourse -- 交易所名称
    ,o.ispublic -- 是否公开交易
    ,o.exponent -- 主要指数成分股及其名称
    ,o.shareamount -- 持股数量
    ,o.stockamount -- 出质股权数额
    ,o.persharemarketprice -- 每股市价
    ,o.profitmoney -- 上年每股分红金额
    ,o.warningline -- 警戒线
    ,o.persharevalue -- 每股净资产
    ,o.liquidateline -- 平仓线
    ,o.totalvalue -- 质押总价值
    ,o.duedate -- 限售到期日
    ,o.remark -- 股票其他说明
    ,o.tdcurrency -- 币种
    ,o.stockidc -- 股票托管券商
    ,o.pledgeregistration -- 质押登记号
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
    ,o.pledgetag -- 场内外质押标签
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
from ${iol_schema}.icms_clr_asset_finance_listedstock_bk o
    left join ${iol_schema}.icms_clr_asset_finance_listedstock_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_finance_listedstock_cl d
        on
            o.clrid = d.clrid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_asset_finance_listedstock;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_finance_listedstock') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_finance_listedstock drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_finance_listedstock add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_finance_listedstock exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_finance_listedstock_cl;
alter table ${iol_schema}.icms_clr_asset_finance_listedstock exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_finance_listedstock_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_finance_listedstock to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_listedstock_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_listedstock_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_finance_listedstock_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_finance_listedstock',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
