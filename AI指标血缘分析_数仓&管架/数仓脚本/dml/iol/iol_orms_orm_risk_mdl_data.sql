/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orms_orm_risk_mdl_data
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
create table ${iol_schema}.orms_orm_risk_mdl_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orms_orm_risk_mdl_data;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orms_orm_risk_mdl_data_op purge;
drop table ${iol_schema}.orms_orm_risk_mdl_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orms_orm_risk_mdl_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orms_orm_risk_mdl_data where 0=1;

create table ${iol_schema}.orms_orm_risk_mdl_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orms_orm_risk_mdl_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orms_orm_risk_mdl_data_cl(
            opriskincomeid -- id
            ,timeid -- 20181231 日期
            ,grossincome -- 总收入
            ,currencyid -- 货币代码
            ,businesslineid -- 条线代码
            ,businesslinedesc -- 条线说明:1.零售银行,2.商业银行,3.公司金融,4.交易和销售,5.支付和结算,6.代理服务,7.资产管理,8.零售经纪,12.其他业务
            ,incometypeid -- 收入类型代码
            ,incometypedesc -- 收入类型说明:10.净利息收入,20.净非利息收入
            ,orgstrucid -- 我行总分行机构代码。 如未取到机构代码 赋默认值 999999
            ,legalentityid -- 法律实体标识 默认值 10 华兴银行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orms_orm_risk_mdl_data_op(
            opriskincomeid -- id
            ,timeid -- 20181231 日期
            ,grossincome -- 总收入
            ,currencyid -- 货币代码
            ,businesslineid -- 条线代码
            ,businesslinedesc -- 条线说明:1.零售银行,2.商业银行,3.公司金融,4.交易和销售,5.支付和结算,6.代理服务,7.资产管理,8.零售经纪,12.其他业务
            ,incometypeid -- 收入类型代码
            ,incometypedesc -- 收入类型说明:10.净利息收入,20.净非利息收入
            ,orgstrucid -- 我行总分行机构代码。 如未取到机构代码 赋默认值 999999
            ,legalentityid -- 法律实体标识 默认值 10 华兴银行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.opriskincomeid, o.opriskincomeid) as opriskincomeid -- id
    ,nvl(n.timeid, o.timeid) as timeid -- 20181231 日期
    ,nvl(n.grossincome, o.grossincome) as grossincome -- 总收入
    ,nvl(n.currencyid, o.currencyid) as currencyid -- 货币代码
    ,nvl(n.businesslineid, o.businesslineid) as businesslineid -- 条线代码
    ,nvl(n.businesslinedesc, o.businesslinedesc) as businesslinedesc -- 条线说明:1.零售银行,2.商业银行,3.公司金融,4.交易和销售,5.支付和结算,6.代理服务,7.资产管理,8.零售经纪,12.其他业务
    ,nvl(n.incometypeid, o.incometypeid) as incometypeid -- 收入类型代码
    ,nvl(n.incometypedesc, o.incometypedesc) as incometypedesc -- 收入类型说明:10.净利息收入,20.净非利息收入
    ,nvl(n.orgstrucid, o.orgstrucid) as orgstrucid -- 我行总分行机构代码。 如未取到机构代码 赋默认值 999999
    ,nvl(n.legalentityid, o.legalentityid) as legalentityid -- 法律实体标识 默认值 10 华兴银行
    ,case when
            n.opriskincomeid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.opriskincomeid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.opriskincomeid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.orms_orm_risk_mdl_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orms_orm_risk_mdl_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.opriskincomeid = n.opriskincomeid
where (
        o.opriskincomeid is null
    )
    or (
        n.opriskincomeid is null
    )
    or (
        o.timeid <> n.timeid
        or o.grossincome <> n.grossincome
        or o.currencyid <> n.currencyid
        or o.businesslineid <> n.businesslineid
        or o.businesslinedesc <> n.businesslinedesc
        or o.incometypeid <> n.incometypeid
        or o.incometypedesc <> n.incometypedesc
        or o.orgstrucid <> n.orgstrucid
        or o.legalentityid <> n.legalentityid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orms_orm_risk_mdl_data_cl(
            opriskincomeid -- id
            ,timeid -- 20181231 日期
            ,grossincome -- 总收入
            ,currencyid -- 货币代码
            ,businesslineid -- 条线代码
            ,businesslinedesc -- 条线说明:1.零售银行,2.商业银行,3.公司金融,4.交易和销售,5.支付和结算,6.代理服务,7.资产管理,8.零售经纪,12.其他业务
            ,incometypeid -- 收入类型代码
            ,incometypedesc -- 收入类型说明:10.净利息收入,20.净非利息收入
            ,orgstrucid -- 我行总分行机构代码。 如未取到机构代码 赋默认值 999999
            ,legalentityid -- 法律实体标识 默认值 10 华兴银行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orms_orm_risk_mdl_data_op(
            opriskincomeid -- id
            ,timeid -- 20181231 日期
            ,grossincome -- 总收入
            ,currencyid -- 货币代码
            ,businesslineid -- 条线代码
            ,businesslinedesc -- 条线说明:1.零售银行,2.商业银行,3.公司金融,4.交易和销售,5.支付和结算,6.代理服务,7.资产管理,8.零售经纪,12.其他业务
            ,incometypeid -- 收入类型代码
            ,incometypedesc -- 收入类型说明:10.净利息收入,20.净非利息收入
            ,orgstrucid -- 我行总分行机构代码。 如未取到机构代码 赋默认值 999999
            ,legalentityid -- 法律实体标识 默认值 10 华兴银行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.opriskincomeid -- id
    ,o.timeid -- 20181231 日期
    ,o.grossincome -- 总收入
    ,o.currencyid -- 货币代码
    ,o.businesslineid -- 条线代码
    ,o.businesslinedesc -- 条线说明:1.零售银行,2.商业银行,3.公司金融,4.交易和销售,5.支付和结算,6.代理服务,7.资产管理,8.零售经纪,12.其他业务
    ,o.incometypeid -- 收入类型代码
    ,o.incometypedesc -- 收入类型说明:10.净利息收入,20.净非利息收入
    ,o.orgstrucid -- 我行总分行机构代码。 如未取到机构代码 赋默认值 999999
    ,o.legalentityid -- 法律实体标识 默认值 10 华兴银行
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.orms_orm_risk_mdl_data_bk o
    left join ${iol_schema}.orms_orm_risk_mdl_data_op n
        on
            o.opriskincomeid = n.opriskincomeid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orms_orm_risk_mdl_data_cl d
        on
            o.opriskincomeid = d.opriskincomeid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.orms_orm_risk_mdl_data;

-- 4.2 exchange partition
alter table ${iol_schema}.orms_orm_risk_mdl_data exchange partition p_19000101 with table ${iol_schema}.orms_orm_risk_mdl_data_cl;
alter table ${iol_schema}.orms_orm_risk_mdl_data exchange partition p_20991231 with table ${iol_schema}.orms_orm_risk_mdl_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orms_orm_risk_mdl_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orms_orm_risk_mdl_data_op purge;
drop table ${iol_schema}.orms_orm_risk_mdl_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orms_orm_risk_mdl_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orms_orm_risk_mdl_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
