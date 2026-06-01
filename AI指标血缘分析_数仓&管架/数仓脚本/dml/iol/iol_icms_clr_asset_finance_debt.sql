/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_finance_debt
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
create table ${iol_schema}.icms_clr_asset_finance_debt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_finance_debt
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_debt_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_debt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_debt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_debt where 0=1;

create table ${iol_schema}.icms_clr_asset_finance_debt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_debt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_debt_cl(
            clrid -- 押品编号
            ,debtcode -- 国债代码/债券代码
            ,issuanceformat -- 国债发放形式
            ,debtsubtype -- 债券细类
            ,certificatecode -- 债券凭证号
            ,debtname -- 债券名称
            ,amount -- 数量
            ,issuercode -- 发行人组织机构代码
            ,issuername -- 发行人名称
            ,issuertype -- 发行人类型
            ,isborrower -- 发行人是否为借款人
            ,ishaveoutrating -- 债券是否有外部债项评级
            ,outratingresult -- 债券外部评级结果
            ,issueroutorg -- 发行人发行的同一级别债券外部评级机构
            ,issueroutresult -- 发行人发行的同一级别债券外部评级结果
            ,issuercountry -- 发行人注册地所在国家或地区
            ,issuercountryresult -- 发行人注册地所在国家或地区外部评级结果
            ,issuerresult -- 发行人外部评级结果
            ,faceamount -- 票面金额
            ,actuallyamount -- 票面净值
            ,tdcurrency -- 币种
            ,stoppayment -- 国债冻结/止付金额
            ,paytype -- 利息支付方式
            ,rate -- 利率
            ,startdate -- 发行日期
            ,enddate -- 到期日期
            ,isfirst -- 是否优先债券
            ,publishreson -- 发行目的
            ,deadlinetype -- 债券期限类型
            ,ismarket -- 是否主要交易所交易
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_debt_op(
            clrid -- 押品编号
            ,debtcode -- 国债代码/债券代码
            ,issuanceformat -- 国债发放形式
            ,debtsubtype -- 债券细类
            ,certificatecode -- 债券凭证号
            ,debtname -- 债券名称
            ,amount -- 数量
            ,issuercode -- 发行人组织机构代码
            ,issuername -- 发行人名称
            ,issuertype -- 发行人类型
            ,isborrower -- 发行人是否为借款人
            ,ishaveoutrating -- 债券是否有外部债项评级
            ,outratingresult -- 债券外部评级结果
            ,issueroutorg -- 发行人发行的同一级别债券外部评级机构
            ,issueroutresult -- 发行人发行的同一级别债券外部评级结果
            ,issuercountry -- 发行人注册地所在国家或地区
            ,issuercountryresult -- 发行人注册地所在国家或地区外部评级结果
            ,issuerresult -- 发行人外部评级结果
            ,faceamount -- 票面金额
            ,actuallyamount -- 票面净值
            ,tdcurrency -- 币种
            ,stoppayment -- 国债冻结/止付金额
            ,paytype -- 利息支付方式
            ,rate -- 利率
            ,startdate -- 发行日期
            ,enddate -- 到期日期
            ,isfirst -- 是否优先债券
            ,publishreson -- 发行目的
            ,deadlinetype -- 债券期限类型
            ,ismarket -- 是否主要交易所交易
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.debtcode, o.debtcode) as debtcode -- 国债代码/债券代码
    ,nvl(n.issuanceformat, o.issuanceformat) as issuanceformat -- 国债发放形式
    ,nvl(n.debtsubtype, o.debtsubtype) as debtsubtype -- 债券细类
    ,nvl(n.certificatecode, o.certificatecode) as certificatecode -- 债券凭证号
    ,nvl(n.debtname, o.debtname) as debtname -- 债券名称
    ,nvl(n.amount, o.amount) as amount -- 数量
    ,nvl(n.issuercode, o.issuercode) as issuercode -- 发行人组织机构代码
    ,nvl(n.issuername, o.issuername) as issuername -- 发行人名称
    ,nvl(n.issuertype, o.issuertype) as issuertype -- 发行人类型
    ,nvl(n.isborrower, o.isborrower) as isborrower -- 发行人是否为借款人
    ,nvl(n.ishaveoutrating, o.ishaveoutrating) as ishaveoutrating -- 债券是否有外部债项评级
    ,nvl(n.outratingresult, o.outratingresult) as outratingresult -- 债券外部评级结果
    ,nvl(n.issueroutorg, o.issueroutorg) as issueroutorg -- 发行人发行的同一级别债券外部评级机构
    ,nvl(n.issueroutresult, o.issueroutresult) as issueroutresult -- 发行人发行的同一级别债券外部评级结果
    ,nvl(n.issuercountry, o.issuercountry) as issuercountry -- 发行人注册地所在国家或地区
    ,nvl(n.issuercountryresult, o.issuercountryresult) as issuercountryresult -- 发行人注册地所在国家或地区外部评级结果
    ,nvl(n.issuerresult, o.issuerresult) as issuerresult -- 发行人外部评级结果
    ,nvl(n.faceamount, o.faceamount) as faceamount -- 票面金额
    ,nvl(n.actuallyamount, o.actuallyamount) as actuallyamount -- 票面净值
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,nvl(n.stoppayment, o.stoppayment) as stoppayment -- 国债冻结/止付金额
    ,nvl(n.paytype, o.paytype) as paytype -- 利息支付方式
    ,nvl(n.rate, o.rate) as rate -- 利率
    ,nvl(n.startdate, o.startdate) as startdate -- 发行日期
    ,nvl(n.enddate, o.enddate) as enddate -- 到期日期
    ,nvl(n.isfirst, o.isfirst) as isfirst -- 是否优先债券
    ,nvl(n.publishreson, o.publishreson) as publishreson -- 发行目的
    ,nvl(n.deadlinetype, o.deadlinetype) as deadlinetype -- 债券期限类型
    ,nvl(n.ismarket, o.ismarket) as ismarket -- 是否主要交易所交易
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
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
from (select * from ${iol_schema}.icms_clr_asset_finance_debt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_finance_debt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.debtcode <> n.debtcode
        or o.issuanceformat <> n.issuanceformat
        or o.debtsubtype <> n.debtsubtype
        or o.certificatecode <> n.certificatecode
        or o.debtname <> n.debtname
        or o.amount <> n.amount
        or o.issuercode <> n.issuercode
        or o.issuername <> n.issuername
        or o.issuertype <> n.issuertype
        or o.isborrower <> n.isborrower
        or o.ishaveoutrating <> n.ishaveoutrating
        or o.outratingresult <> n.outratingresult
        or o.issueroutorg <> n.issueroutorg
        or o.issueroutresult <> n.issueroutresult
        or o.issuercountry <> n.issuercountry
        or o.issuercountryresult <> n.issuercountryresult
        or o.issuerresult <> n.issuerresult
        or o.faceamount <> n.faceamount
        or o.actuallyamount <> n.actuallyamount
        or o.tdcurrency <> n.tdcurrency
        or o.stoppayment <> n.stoppayment
        or o.paytype <> n.paytype
        or o.rate <> n.rate
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.isfirst <> n.isfirst
        or o.publishreson <> n.publishreson
        or o.deadlinetype <> n.deadlinetype
        or o.ismarket <> n.ismarket
        or o.remark <> n.remark
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_debt_cl(
            clrid -- 押品编号
            ,debtcode -- 国债代码/债券代码
            ,issuanceformat -- 国债发放形式
            ,debtsubtype -- 债券细类
            ,certificatecode -- 债券凭证号
            ,debtname -- 债券名称
            ,amount -- 数量
            ,issuercode -- 发行人组织机构代码
            ,issuername -- 发行人名称
            ,issuertype -- 发行人类型
            ,isborrower -- 发行人是否为借款人
            ,ishaveoutrating -- 债券是否有外部债项评级
            ,outratingresult -- 债券外部评级结果
            ,issueroutorg -- 发行人发行的同一级别债券外部评级机构
            ,issueroutresult -- 发行人发行的同一级别债券外部评级结果
            ,issuercountry -- 发行人注册地所在国家或地区
            ,issuercountryresult -- 发行人注册地所在国家或地区外部评级结果
            ,issuerresult -- 发行人外部评级结果
            ,faceamount -- 票面金额
            ,actuallyamount -- 票面净值
            ,tdcurrency -- 币种
            ,stoppayment -- 国债冻结/止付金额
            ,paytype -- 利息支付方式
            ,rate -- 利率
            ,startdate -- 发行日期
            ,enddate -- 到期日期
            ,isfirst -- 是否优先债券
            ,publishreson -- 发行目的
            ,deadlinetype -- 债券期限类型
            ,ismarket -- 是否主要交易所交易
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_debt_op(
            clrid -- 押品编号
            ,debtcode -- 国债代码/债券代码
            ,issuanceformat -- 国债发放形式
            ,debtsubtype -- 债券细类
            ,certificatecode -- 债券凭证号
            ,debtname -- 债券名称
            ,amount -- 数量
            ,issuercode -- 发行人组织机构代码
            ,issuername -- 发行人名称
            ,issuertype -- 发行人类型
            ,isborrower -- 发行人是否为借款人
            ,ishaveoutrating -- 债券是否有外部债项评级
            ,outratingresult -- 债券外部评级结果
            ,issueroutorg -- 发行人发行的同一级别债券外部评级机构
            ,issueroutresult -- 发行人发行的同一级别债券外部评级结果
            ,issuercountry -- 发行人注册地所在国家或地区
            ,issuercountryresult -- 发行人注册地所在国家或地区外部评级结果
            ,issuerresult -- 发行人外部评级结果
            ,faceamount -- 票面金额
            ,actuallyamount -- 票面净值
            ,tdcurrency -- 币种
            ,stoppayment -- 国债冻结/止付金额
            ,paytype -- 利息支付方式
            ,rate -- 利率
            ,startdate -- 发行日期
            ,enddate -- 到期日期
            ,isfirst -- 是否优先债券
            ,publishreson -- 发行目的
            ,deadlinetype -- 债券期限类型
            ,ismarket -- 是否主要交易所交易
            ,remark -- 其他说明
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.debtcode -- 国债代码/债券代码
    ,o.issuanceformat -- 国债发放形式
    ,o.debtsubtype -- 债券细类
    ,o.certificatecode -- 债券凭证号
    ,o.debtname -- 债券名称
    ,o.amount -- 数量
    ,o.issuercode -- 发行人组织机构代码
    ,o.issuername -- 发行人名称
    ,o.issuertype -- 发行人类型
    ,o.isborrower -- 发行人是否为借款人
    ,o.ishaveoutrating -- 债券是否有外部债项评级
    ,o.outratingresult -- 债券外部评级结果
    ,o.issueroutorg -- 发行人发行的同一级别债券外部评级机构
    ,o.issueroutresult -- 发行人发行的同一级别债券外部评级结果
    ,o.issuercountry -- 发行人注册地所在国家或地区
    ,o.issuercountryresult -- 发行人注册地所在国家或地区外部评级结果
    ,o.issuerresult -- 发行人外部评级结果
    ,o.faceamount -- 票面金额
    ,o.actuallyamount -- 票面净值
    ,o.tdcurrency -- 币种
    ,o.stoppayment -- 国债冻结/止付金额
    ,o.paytype -- 利息支付方式
    ,o.rate -- 利率
    ,o.startdate -- 发行日期
    ,o.enddate -- 到期日期
    ,o.isfirst -- 是否优先债券
    ,o.publishreson -- 发行目的
    ,o.deadlinetype -- 债券期限类型
    ,o.ismarket -- 是否主要交易所交易
    ,o.remark -- 其他说明
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
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
from ${iol_schema}.icms_clr_asset_finance_debt_bk o
    left join ${iol_schema}.icms_clr_asset_finance_debt_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_finance_debt_cl d
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
--truncate table ${iol_schema}.icms_clr_asset_finance_debt;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_finance_debt') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_finance_debt drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_finance_debt add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_finance_debt exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_finance_debt_cl;
alter table ${iol_schema}.icms_clr_asset_finance_debt exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_finance_debt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_finance_debt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_debt_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_debt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_finance_debt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_finance_debt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
