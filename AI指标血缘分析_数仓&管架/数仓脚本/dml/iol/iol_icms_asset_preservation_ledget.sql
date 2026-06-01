/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_asset_preservation_ledget
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
create table ${iol_schema}.icms_asset_preservation_ledget_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_asset_preservation_ledget
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_asset_preservation_ledget_op purge;
drop table ${iol_schema}.icms_asset_preservation_ledget_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_asset_preservation_ledget_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_asset_preservation_ledget where 0=1;

create table ${iol_schema}.icms_asset_preservation_ledget_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_asset_preservation_ledget where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_asset_preservation_ledget_cl(
            serialno -- 流水号
            ,branchbusinessdivision -- 分行/事业部
            ,inputorgid -- 经办机构名称
            ,inputuserid -- 客户经理
            ,customerid -- 客户编号
            ,duebillid -- 借据号
            ,customername -- 客户名称
            ,customertype -- 客户类型
            ,industry -- 行业
            ,entscale -- 企业规模
            ,assettype -- 资产类型
            ,begincreditbalance -- 年初授信余额折人民币
            ,beginriskclassify -- 年初风险分类
            ,firsttimedesc -- 第一次下调不良时间
            ,riskisolationresults -- 风险排查结果
            ,ironridetime -- 列入铁骑名单时间
            ,handleriskclassify -- 处置时点风险分类
            ,handletype -- 处置（含重组）方式
            ,typeassettransfer -- 资产转让类型
            ,handletime -- 处置（含重组）时间
            ,handlebalance -- 处置金额
            ,repaymentresource -- 还款来源
            ,handleinterestbalance -- 处置欠息金额
            ,handlechargedbalance -- 处置罚息金额
            ,handlereinterestedbalance -- 处置复息金额
            ,handlesubstitutecushion -- 处置代垫费用
            ,beforeclassifyresult -- 变动前五级分类
            ,beforebalance -- 变动前余额
            ,afterclassifyresult -- 变动后五级分类
            ,cashoffdate -- 核销/抵债后收现日期（元）
            ,recoveroffbalance -- 核销/抵债后收回金额（元）
            ,normalrecoverbalance -- 调回正常后收回金额
            ,remark -- 备注
            ,businesstype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_asset_preservation_ledget_op(
            serialno -- 流水号
            ,branchbusinessdivision -- 分行/事业部
            ,inputorgid -- 经办机构名称
            ,inputuserid -- 客户经理
            ,customerid -- 客户编号
            ,duebillid -- 借据号
            ,customername -- 客户名称
            ,customertype -- 客户类型
            ,industry -- 行业
            ,entscale -- 企业规模
            ,assettype -- 资产类型
            ,begincreditbalance -- 年初授信余额折人民币
            ,beginriskclassify -- 年初风险分类
            ,firsttimedesc -- 第一次下调不良时间
            ,riskisolationresults -- 风险排查结果
            ,ironridetime -- 列入铁骑名单时间
            ,handleriskclassify -- 处置时点风险分类
            ,handletype -- 处置（含重组）方式
            ,typeassettransfer -- 资产转让类型
            ,handletime -- 处置（含重组）时间
            ,handlebalance -- 处置金额
            ,repaymentresource -- 还款来源
            ,handleinterestbalance -- 处置欠息金额
            ,handlechargedbalance -- 处置罚息金额
            ,handlereinterestedbalance -- 处置复息金额
            ,handlesubstitutecushion -- 处置代垫费用
            ,beforeclassifyresult -- 变动前五级分类
            ,beforebalance -- 变动前余额
            ,afterclassifyresult -- 变动后五级分类
            ,cashoffdate -- 核销/抵债后收现日期（元）
            ,recoveroffbalance -- 核销/抵债后收回金额（元）
            ,normalrecoverbalance -- 调回正常后收回金额
            ,remark -- 备注
            ,businesstype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.branchbusinessdivision, o.branchbusinessdivision) as branchbusinessdivision -- 分行/事业部
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 经办机构名称
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 客户经理
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.duebillid, o.duebillid) as duebillid -- 借据号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.industry, o.industry) as industry -- 行业
    ,nvl(n.entscale, o.entscale) as entscale -- 企业规模
    ,nvl(n.assettype, o.assettype) as assettype -- 资产类型
    ,nvl(n.begincreditbalance, o.begincreditbalance) as begincreditbalance -- 年初授信余额折人民币
    ,nvl(n.beginriskclassify, o.beginriskclassify) as beginriskclassify -- 年初风险分类
    ,nvl(n.firsttimedesc, o.firsttimedesc) as firsttimedesc -- 第一次下调不良时间
    ,nvl(n.riskisolationresults, o.riskisolationresults) as riskisolationresults -- 风险排查结果
    ,nvl(n.ironridetime, o.ironridetime) as ironridetime -- 列入铁骑名单时间
    ,nvl(n.handleriskclassify, o.handleriskclassify) as handleriskclassify -- 处置时点风险分类
    ,nvl(n.handletype, o.handletype) as handletype -- 处置（含重组）方式
    ,nvl(n.typeassettransfer, o.typeassettransfer) as typeassettransfer -- 资产转让类型
    ,nvl(n.handletime, o.handletime) as handletime -- 处置（含重组）时间
    ,nvl(n.handlebalance, o.handlebalance) as handlebalance -- 处置金额
    ,nvl(n.repaymentresource, o.repaymentresource) as repaymentresource -- 还款来源
    ,nvl(n.handleinterestbalance, o.handleinterestbalance) as handleinterestbalance -- 处置欠息金额
    ,nvl(n.handlechargedbalance, o.handlechargedbalance) as handlechargedbalance -- 处置罚息金额
    ,nvl(n.handlereinterestedbalance, o.handlereinterestedbalance) as handlereinterestedbalance -- 处置复息金额
    ,nvl(n.handlesubstitutecushion, o.handlesubstitutecushion) as handlesubstitutecushion -- 处置代垫费用
    ,nvl(n.beforeclassifyresult, o.beforeclassifyresult) as beforeclassifyresult -- 变动前五级分类
    ,nvl(n.beforebalance, o.beforebalance) as beforebalance -- 变动前余额
    ,nvl(n.afterclassifyresult, o.afterclassifyresult) as afterclassifyresult -- 变动后五级分类
    ,nvl(n.cashoffdate, o.cashoffdate) as cashoffdate -- 核销/抵债后收现日期（元）
    ,nvl(n.recoveroffbalance, o.recoveroffbalance) as recoveroffbalance -- 核销/抵债后收回金额（元）
    ,nvl(n.normalrecoverbalance, o.normalrecoverbalance) as normalrecoverbalance -- 调回正常后收回金额
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_asset_preservation_ledget_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_asset_preservation_ledget where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.branchbusinessdivision <> n.branchbusinessdivision
        or o.inputorgid <> n.inputorgid
        or o.inputuserid <> n.inputuserid
        or o.customerid <> n.customerid
        or o.duebillid <> n.duebillid
        or o.customername <> n.customername
        or o.customertype <> n.customertype
        or o.industry <> n.industry
        or o.entscale <> n.entscale
        or o.assettype <> n.assettype
        or o.begincreditbalance <> n.begincreditbalance
        or o.beginriskclassify <> n.beginriskclassify
        or o.firsttimedesc <> n.firsttimedesc
        or o.riskisolationresults <> n.riskisolationresults
        or o.ironridetime <> n.ironridetime
        or o.handleriskclassify <> n.handleriskclassify
        or o.handletype <> n.handletype
        or o.typeassettransfer <> n.typeassettransfer
        or o.handletime <> n.handletime
        or o.handlebalance <> n.handlebalance
        or o.repaymentresource <> n.repaymentresource
        or o.handleinterestbalance <> n.handleinterestbalance
        or o.handlechargedbalance <> n.handlechargedbalance
        or o.handlereinterestedbalance <> n.handlereinterestedbalance
        or o.handlesubstitutecushion <> n.handlesubstitutecushion
        or o.beforeclassifyresult <> n.beforeclassifyresult
        or o.beforebalance <> n.beforebalance
        or o.afterclassifyresult <> n.afterclassifyresult
        or o.cashoffdate <> n.cashoffdate
        or o.recoveroffbalance <> n.recoveroffbalance
        or o.normalrecoverbalance <> n.normalrecoverbalance
        or o.remark <> n.remark
        or o.businesstype <> n.businesstype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_asset_preservation_ledget_cl(
            serialno -- 流水号
            ,branchbusinessdivision -- 分行/事业部
            ,inputorgid -- 经办机构名称
            ,inputuserid -- 客户经理
            ,customerid -- 客户编号
            ,duebillid -- 借据号
            ,customername -- 客户名称
            ,customertype -- 客户类型
            ,industry -- 行业
            ,entscale -- 企业规模
            ,assettype -- 资产类型
            ,begincreditbalance -- 年初授信余额折人民币
            ,beginriskclassify -- 年初风险分类
            ,firsttimedesc -- 第一次下调不良时间
            ,riskisolationresults -- 风险排查结果
            ,ironridetime -- 列入铁骑名单时间
            ,handleriskclassify -- 处置时点风险分类
            ,handletype -- 处置（含重组）方式
            ,typeassettransfer -- 资产转让类型
            ,handletime -- 处置（含重组）时间
            ,handlebalance -- 处置金额
            ,repaymentresource -- 还款来源
            ,handleinterestbalance -- 处置欠息金额
            ,handlechargedbalance -- 处置罚息金额
            ,handlereinterestedbalance -- 处置复息金额
            ,handlesubstitutecushion -- 处置代垫费用
            ,beforeclassifyresult -- 变动前五级分类
            ,beforebalance -- 变动前余额
            ,afterclassifyresult -- 变动后五级分类
            ,cashoffdate -- 核销/抵债后收现日期（元）
            ,recoveroffbalance -- 核销/抵债后收回金额（元）
            ,normalrecoverbalance -- 调回正常后收回金额
            ,remark -- 备注
            ,businesstype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_asset_preservation_ledget_op(
            serialno -- 流水号
            ,branchbusinessdivision -- 分行/事业部
            ,inputorgid -- 经办机构名称
            ,inputuserid -- 客户经理
            ,customerid -- 客户编号
            ,duebillid -- 借据号
            ,customername -- 客户名称
            ,customertype -- 客户类型
            ,industry -- 行业
            ,entscale -- 企业规模
            ,assettype -- 资产类型
            ,begincreditbalance -- 年初授信余额折人民币
            ,beginriskclassify -- 年初风险分类
            ,firsttimedesc -- 第一次下调不良时间
            ,riskisolationresults -- 风险排查结果
            ,ironridetime -- 列入铁骑名单时间
            ,handleriskclassify -- 处置时点风险分类
            ,handletype -- 处置（含重组）方式
            ,typeassettransfer -- 资产转让类型
            ,handletime -- 处置（含重组）时间
            ,handlebalance -- 处置金额
            ,repaymentresource -- 还款来源
            ,handleinterestbalance -- 处置欠息金额
            ,handlechargedbalance -- 处置罚息金额
            ,handlereinterestedbalance -- 处置复息金额
            ,handlesubstitutecushion -- 处置代垫费用
            ,beforeclassifyresult -- 变动前五级分类
            ,beforebalance -- 变动前余额
            ,afterclassifyresult -- 变动后五级分类
            ,cashoffdate -- 核销/抵债后收现日期（元）
            ,recoveroffbalance -- 核销/抵债后收回金额（元）
            ,normalrecoverbalance -- 调回正常后收回金额
            ,remark -- 备注
            ,businesstype -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.branchbusinessdivision -- 分行/事业部
    ,o.inputorgid -- 经办机构名称
    ,o.inputuserid -- 客户经理
    ,o.customerid -- 客户编号
    ,o.duebillid -- 借据号
    ,o.customername -- 客户名称
    ,o.customertype -- 客户类型
    ,o.industry -- 行业
    ,o.entscale -- 企业规模
    ,o.assettype -- 资产类型
    ,o.begincreditbalance -- 年初授信余额折人民币
    ,o.beginriskclassify -- 年初风险分类
    ,o.firsttimedesc -- 第一次下调不良时间
    ,o.riskisolationresults -- 风险排查结果
    ,o.ironridetime -- 列入铁骑名单时间
    ,o.handleriskclassify -- 处置时点风险分类
    ,o.handletype -- 处置（含重组）方式
    ,o.typeassettransfer -- 资产转让类型
    ,o.handletime -- 处置（含重组）时间
    ,o.handlebalance -- 处置金额
    ,o.repaymentresource -- 还款来源
    ,o.handleinterestbalance -- 处置欠息金额
    ,o.handlechargedbalance -- 处置罚息金额
    ,o.handlereinterestedbalance -- 处置复息金额
    ,o.handlesubstitutecushion -- 处置代垫费用
    ,o.beforeclassifyresult -- 变动前五级分类
    ,o.beforebalance -- 变动前余额
    ,o.afterclassifyresult -- 变动后五级分类
    ,o.cashoffdate -- 核销/抵债后收现日期（元）
    ,o.recoveroffbalance -- 核销/抵债后收回金额（元）
    ,o.normalrecoverbalance -- 调回正常后收回金额
    ,o.remark -- 备注
    ,o.businesstype -- 
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
from ${iol_schema}.icms_asset_preservation_ledget_bk o
    left join ${iol_schema}.icms_asset_preservation_ledget_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_asset_preservation_ledget_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_asset_preservation_ledget;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_asset_preservation_ledget') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_asset_preservation_ledget drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_asset_preservation_ledget add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_asset_preservation_ledget exchange partition p_${batch_date} with table ${iol_schema}.icms_asset_preservation_ledget_cl;
alter table ${iol_schema}.icms_asset_preservation_ledget exchange partition p_20991231 with table ${iol_schema}.icms_asset_preservation_ledget_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_asset_preservation_ledget to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_asset_preservation_ledget_op purge;
drop table ${iol_schema}.icms_asset_preservation_ledget_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_asset_preservation_ledget_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_asset_preservation_ledget',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
