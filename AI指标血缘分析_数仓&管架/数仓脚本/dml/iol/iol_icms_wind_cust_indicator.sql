/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wind_cust_indicator
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
create table ${iol_schema}.icms_wind_cust_indicator_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wind_cust_indicator
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wind_cust_indicator_op purge;
drop table ${iol_schema}.icms_wind_cust_indicator_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wind_cust_indicator_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wind_cust_indicator where 0=1;

create table ${iol_schema}.icms_wind_cust_indicator_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wind_cust_indicator where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wind_cust_indicator_cl(
            compcode -- 上市、非上市公司代码
            ,islisted -- 是否上市
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,singlegrouprate -- 单一集团贷款集中度
            ,assetprofitrate -- 资本利润率
            ,coreyicapirate -- 核心一级资本充足率
            ,yicapirate -- 一级资本充足率
            ,leverrate -- 杠杆率
            ,badrate -- 不良贷款率
            ,reportperiod -- 最新一期监管指标期次
            ,capirate -- 资本充足率
            ,core1jassets -- 核心一级资本净额
            ,updateorgid -- 更新机构编号
            ,provisionrate -- 不良贷款拨备覆盖率(拨备覆盖率)
            ,inputdate -- 新增日期
            ,loanprovisionrate -- 贷款拨备率
            ,assetliqrate -- 短期资产流动性比例(人民币)(流动性比例)
            ,assetliqcoverrate -- 流动性覆盖率
            ,attentionrate -- 关注类贷款占比
            ,costincomerate -- 成本收入比
            ,updateuserid -- 更新员工编号
            ,updateflag -- 操作标志:A-手动新增U-手动更新
            ,inputuserid -- 新增员工编号
            ,inputorgid -- 新增机构编号
            ,compname -- 公司名称
            ,totalassets -- 总资产
            ,clearassets -- 净资产
            ,banktype -- 银行类型
            ,bankclass -- 银行性质
            ,province -- 省份名称
            ,city -- 城市名称
            ,customerid -- 关联客户编号
            ,customername -- 关联客户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wind_cust_indicator_op(
            compcode -- 上市、非上市公司代码
            ,islisted -- 是否上市
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,singlegrouprate -- 单一集团贷款集中度
            ,assetprofitrate -- 资本利润率
            ,coreyicapirate -- 核心一级资本充足率
            ,yicapirate -- 一级资本充足率
            ,leverrate -- 杠杆率
            ,badrate -- 不良贷款率
            ,reportperiod -- 最新一期监管指标期次
            ,capirate -- 资本充足率
            ,core1jassets -- 核心一级资本净额
            ,updateorgid -- 更新机构编号
            ,provisionrate -- 不良贷款拨备覆盖率(拨备覆盖率)
            ,inputdate -- 新增日期
            ,loanprovisionrate -- 贷款拨备率
            ,assetliqrate -- 短期资产流动性比例(人民币)(流动性比例)
            ,assetliqcoverrate -- 流动性覆盖率
            ,attentionrate -- 关注类贷款占比
            ,costincomerate -- 成本收入比
            ,updateuserid -- 更新员工编号
            ,updateflag -- 操作标志:A-手动新增U-手动更新
            ,inputuserid -- 新增员工编号
            ,inputorgid -- 新增机构编号
            ,compname -- 公司名称
            ,totalassets -- 总资产
            ,clearassets -- 净资产
            ,banktype -- 银行类型
            ,bankclass -- 银行性质
            ,province -- 省份名称
            ,city -- 城市名称
            ,customerid -- 关联客户编号
            ,customername -- 关联客户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.compcode, o.compcode) as compcode -- 上市、非上市公司代码
    ,nvl(n.islisted, o.islisted) as islisted -- 是否上市
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.singlegrouprate, o.singlegrouprate) as singlegrouprate -- 单一集团贷款集中度
    ,nvl(n.assetprofitrate, o.assetprofitrate) as assetprofitrate -- 资本利润率
    ,nvl(n.coreyicapirate, o.coreyicapirate) as coreyicapirate -- 核心一级资本充足率
    ,nvl(n.yicapirate, o.yicapirate) as yicapirate -- 一级资本充足率
    ,nvl(n.leverrate, o.leverrate) as leverrate -- 杠杆率
    ,nvl(n.badrate, o.badrate) as badrate -- 不良贷款率
    ,nvl(n.reportperiod, o.reportperiod) as reportperiod -- 最新一期监管指标期次
    ,nvl(n.capirate, o.capirate) as capirate -- 资本充足率
    ,nvl(n.core1jassets, o.core1jassets) as core1jassets -- 核心一级资本净额
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.provisionrate, o.provisionrate) as provisionrate -- 不良贷款拨备覆盖率(拨备覆盖率)
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 新增日期
    ,nvl(n.loanprovisionrate, o.loanprovisionrate) as loanprovisionrate -- 贷款拨备率
    ,nvl(n.assetliqrate, o.assetliqrate) as assetliqrate -- 短期资产流动性比例(人民币)(流动性比例)
    ,nvl(n.assetliqcoverrate, o.assetliqcoverrate) as assetliqcoverrate -- 流动性覆盖率
    ,nvl(n.attentionrate, o.attentionrate) as attentionrate -- 关注类贷款占比
    ,nvl(n.costincomerate, o.costincomerate) as costincomerate -- 成本收入比
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新员工编号
    ,nvl(n.updateflag, o.updateflag) as updateflag -- 操作标志:A-手动新增U-手动更新
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 新增员工编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 新增机构编号
    ,nvl(n.compname, o.compname) as compname -- 公司名称
    ,nvl(n.totalassets, o.totalassets) as totalassets -- 总资产
    ,nvl(n.clearassets, o.clearassets) as clearassets -- 净资产
    ,nvl(n.banktype, o.banktype) as banktype -- 银行类型
    ,nvl(n.bankclass, o.bankclass) as bankclass -- 银行性质
    ,nvl(n.province, o.province) as province -- 省份名称
    ,nvl(n.city, o.city) as city -- 城市名称
    ,nvl(n.customerid, o.customerid) as customerid -- 关联客户编号
    ,nvl(n.customername, o.customername) as customername -- 关联客户名称
    ,case when
            n.compcode is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.compcode is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.compcode is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wind_cust_indicator_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wind_cust_indicator where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.compcode = n.compcode
where (
        o.compcode is null
    )
    or (
        n.compcode is null
    )
    or (
        o.islisted <> n.islisted
        or o.updatedate <> n.updatedate
        or o.migtflag <> n.migtflag
        or o.singlegrouprate <> n.singlegrouprate
        or o.assetprofitrate <> n.assetprofitrate
        or o.coreyicapirate <> n.coreyicapirate
        or o.yicapirate <> n.yicapirate
        or o.leverrate <> n.leverrate
        or o.badrate <> n.badrate
        or o.reportperiod <> n.reportperiod
        or o.capirate <> n.capirate
        or o.core1jassets <> n.core1jassets
        or o.updateorgid <> n.updateorgid
        or o.provisionrate <> n.provisionrate
        or o.inputdate <> n.inputdate
        or o.loanprovisionrate <> n.loanprovisionrate
        or o.assetliqrate <> n.assetliqrate
        or o.assetliqcoverrate <> n.assetliqcoverrate
        or o.attentionrate <> n.attentionrate
        or o.costincomerate <> n.costincomerate
        or o.updateuserid <> n.updateuserid
        or o.updateflag <> n.updateflag
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.compname <> n.compname
        or o.totalassets <> n.totalassets
        or o.clearassets <> n.clearassets
        or o.banktype <> n.banktype
        or o.bankclass <> n.bankclass
        or o.province <> n.province
        or o.city <> n.city
        or o.customerid <> n.customerid
        or o.customername <> n.customername
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wind_cust_indicator_cl(
            compcode -- 上市、非上市公司代码
            ,islisted -- 是否上市
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,singlegrouprate -- 单一集团贷款集中度
            ,assetprofitrate -- 资本利润率
            ,coreyicapirate -- 核心一级资本充足率
            ,yicapirate -- 一级资本充足率
            ,leverrate -- 杠杆率
            ,badrate -- 不良贷款率
            ,reportperiod -- 最新一期监管指标期次
            ,capirate -- 资本充足率
            ,core1jassets -- 核心一级资本净额
            ,updateorgid -- 更新机构编号
            ,provisionrate -- 不良贷款拨备覆盖率(拨备覆盖率)
            ,inputdate -- 新增日期
            ,loanprovisionrate -- 贷款拨备率
            ,assetliqrate -- 短期资产流动性比例(人民币)(流动性比例)
            ,assetliqcoverrate -- 流动性覆盖率
            ,attentionrate -- 关注类贷款占比
            ,costincomerate -- 成本收入比
            ,updateuserid -- 更新员工编号
            ,updateflag -- 操作标志:A-手动新增U-手动更新
            ,inputuserid -- 新增员工编号
            ,inputorgid -- 新增机构编号
            ,compname -- 公司名称
            ,totalassets -- 总资产
            ,clearassets -- 净资产
            ,banktype -- 银行类型
            ,bankclass -- 银行性质
            ,province -- 省份名称
            ,city -- 城市名称
            ,customerid -- 关联客户编号
            ,customername -- 关联客户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wind_cust_indicator_op(
            compcode -- 上市、非上市公司代码
            ,islisted -- 是否上市
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,singlegrouprate -- 单一集团贷款集中度
            ,assetprofitrate -- 资本利润率
            ,coreyicapirate -- 核心一级资本充足率
            ,yicapirate -- 一级资本充足率
            ,leverrate -- 杠杆率
            ,badrate -- 不良贷款率
            ,reportperiod -- 最新一期监管指标期次
            ,capirate -- 资本充足率
            ,core1jassets -- 核心一级资本净额
            ,updateorgid -- 更新机构编号
            ,provisionrate -- 不良贷款拨备覆盖率(拨备覆盖率)
            ,inputdate -- 新增日期
            ,loanprovisionrate -- 贷款拨备率
            ,assetliqrate -- 短期资产流动性比例(人民币)(流动性比例)
            ,assetliqcoverrate -- 流动性覆盖率
            ,attentionrate -- 关注类贷款占比
            ,costincomerate -- 成本收入比
            ,updateuserid -- 更新员工编号
            ,updateflag -- 操作标志:A-手动新增U-手动更新
            ,inputuserid -- 新增员工编号
            ,inputorgid -- 新增机构编号
            ,compname -- 公司名称
            ,totalassets -- 总资产
            ,clearassets -- 净资产
            ,banktype -- 银行类型
            ,bankclass -- 银行性质
            ,province -- 省份名称
            ,city -- 城市名称
            ,customerid -- 关联客户编号
            ,customername -- 关联客户名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.compcode -- 上市、非上市公司代码
    ,o.islisted -- 是否上市
    ,o.updatedate -- 更新日期
    ,o.migtflag -- 
    ,o.singlegrouprate -- 单一集团贷款集中度
    ,o.assetprofitrate -- 资本利润率
    ,o.coreyicapirate -- 核心一级资本充足率
    ,o.yicapirate -- 一级资本充足率
    ,o.leverrate -- 杠杆率
    ,o.badrate -- 不良贷款率
    ,o.reportperiod -- 最新一期监管指标期次
    ,o.capirate -- 资本充足率
    ,o.core1jassets -- 核心一级资本净额
    ,o.updateorgid -- 更新机构编号
    ,o.provisionrate -- 不良贷款拨备覆盖率(拨备覆盖率)
    ,o.inputdate -- 新增日期
    ,o.loanprovisionrate -- 贷款拨备率
    ,o.assetliqrate -- 短期资产流动性比例(人民币)(流动性比例)
    ,o.assetliqcoverrate -- 流动性覆盖率
    ,o.attentionrate -- 关注类贷款占比
    ,o.costincomerate -- 成本收入比
    ,o.updateuserid -- 更新员工编号
    ,o.updateflag -- 操作标志:A-手动新增U-手动更新
    ,o.inputuserid -- 新增员工编号
    ,o.inputorgid -- 新增机构编号
    ,o.compname -- 公司名称
    ,o.totalassets -- 总资产
    ,o.clearassets -- 净资产
    ,o.banktype -- 银行类型
    ,o.bankclass -- 银行性质
    ,o.province -- 省份名称
    ,o.city -- 城市名称
    ,o.customerid -- 关联客户编号
    ,o.customername -- 关联客户名称
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
from ${iol_schema}.icms_wind_cust_indicator_bk o
    left join ${iol_schema}.icms_wind_cust_indicator_op n
        on
            o.compcode = n.compcode
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wind_cust_indicator_cl d
        on
            o.compcode = d.compcode
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wind_cust_indicator;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wind_cust_indicator') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wind_cust_indicator drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wind_cust_indicator add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wind_cust_indicator exchange partition p_${batch_date} with table ${iol_schema}.icms_wind_cust_indicator_cl;
alter table ${iol_schema}.icms_wind_cust_indicator exchange partition p_20991231 with table ${iol_schema}.icms_wind_cust_indicator_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wind_cust_indicator to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wind_cust_indicator_op purge;
drop table ${iol_schema}.icms_wind_cust_indicator_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wind_cust_indicator_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wind_cust_indicator',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
