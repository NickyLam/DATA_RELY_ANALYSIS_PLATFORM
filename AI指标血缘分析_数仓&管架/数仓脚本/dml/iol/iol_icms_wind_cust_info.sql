/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wind_cust_info
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
create table ${iol_schema}.icms_wind_cust_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wind_cust_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wind_cust_info_op purge;
drop table ${iol_schema}.icms_wind_cust_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wind_cust_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wind_cust_info where 0=1;

create table ${iol_schema}.icms_wind_cust_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wind_cust_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wind_cust_info_cl(
            compcode -- 上市、非上市公司代码
            ,islisted -- 是否上市
            ,totalassets -- 资产合计
            ,inputuserid -- 新增员工编号
            ,registercapital -- 注册资本
            ,totalrights -- 所有者权益合计
            ,inputdate -- 新增日期
            ,updateuserid -- 更新员工编号
            ,country -- 国家名称
            ,registarea -- 注册区域
            ,banktype -- 银行类型:national-全国性的local-地区性的
            ,city -- 城市名称
            ,customername -- 关联客户名称
            ,bankclass -- 银行性质:国有银行/政策银行/邮储银行/上市全国股份制银行/上市非全国性股份制银行/城商行/农商行
            ,updateorgid -- 更新机构编号
            ,migtflag -- 
            ,province -- 省份名称
            ,reportperiod -- 最新一期资产负债表合并报表
            ,sharecode -- 上市代码
            ,updatedate -- 更新日期
            ,updateflag -- 操作标志:A-手动新增U-手动更新
            ,customerid -- 关联客户编号
            ,clearassets -- 净资产
            ,outdate -- 退出日期
            ,compname -- 公司名称
            ,inputorgid -- 新增机构编号
            ,addflag -- 新增标志：A-人工新增
            ,givencreditlimit -- 他行给我行的授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wind_cust_info_op(
            compcode -- 上市、非上市公司代码
            ,islisted -- 是否上市
            ,totalassets -- 资产合计
            ,inputuserid -- 新增员工编号
            ,registercapital -- 注册资本
            ,totalrights -- 所有者权益合计
            ,inputdate -- 新增日期
            ,updateuserid -- 更新员工编号
            ,country -- 国家名称
            ,registarea -- 注册区域
            ,banktype -- 银行类型:national-全国性的local-地区性的
            ,city -- 城市名称
            ,customername -- 关联客户名称
            ,bankclass -- 银行性质:国有银行/政策银行/邮储银行/上市全国股份制银行/上市非全国性股份制银行/城商行/农商行
            ,updateorgid -- 更新机构编号
            ,migtflag -- 
            ,province -- 省份名称
            ,reportperiod -- 最新一期资产负债表合并报表
            ,sharecode -- 上市代码
            ,updatedate -- 更新日期
            ,updateflag -- 操作标志:A-手动新增U-手动更新
            ,customerid -- 关联客户编号
            ,clearassets -- 净资产
            ,outdate -- 退出日期
            ,compname -- 公司名称
            ,inputorgid -- 新增机构编号
            ,addflag -- 新增标志：A-人工新增
            ,givencreditlimit -- 他行给我行的授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.compcode, o.compcode) as compcode -- 上市、非上市公司代码
    ,nvl(n.islisted, o.islisted) as islisted -- 是否上市
    ,nvl(n.totalassets, o.totalassets) as totalassets -- 资产合计
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 新增员工编号
    ,nvl(n.registercapital, o.registercapital) as registercapital -- 注册资本
    ,nvl(n.totalrights, o.totalrights) as totalrights -- 所有者权益合计
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 新增日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新员工编号
    ,nvl(n.country, o.country) as country -- 国家名称
    ,nvl(n.registarea, o.registarea) as registarea -- 注册区域
    ,nvl(n.banktype, o.banktype) as banktype -- 银行类型:national-全国性的local-地区性的
    ,nvl(n.city, o.city) as city -- 城市名称
    ,nvl(n.customername, o.customername) as customername -- 关联客户名称
    ,nvl(n.bankclass, o.bankclass) as bankclass -- 银行性质:国有银行/政策银行/邮储银行/上市全国股份制银行/上市非全国性股份制银行/城商行/农商行
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.province, o.province) as province -- 省份名称
    ,nvl(n.reportperiod, o.reportperiod) as reportperiod -- 最新一期资产负债表合并报表
    ,nvl(n.sharecode, o.sharecode) as sharecode -- 上市代码
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updateflag, o.updateflag) as updateflag -- 操作标志:A-手动新增U-手动更新
    ,nvl(n.customerid, o.customerid) as customerid -- 关联客户编号
    ,nvl(n.clearassets, o.clearassets) as clearassets -- 净资产
    ,nvl(n.outdate, o.outdate) as outdate -- 退出日期
    ,nvl(n.compname, o.compname) as compname -- 公司名称
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 新增机构编号
    ,nvl(n.addflag, o.addflag) as addflag -- 新增标志：A-人工新增
    ,nvl(n.givencreditlimit, o.givencreditlimit) as givencreditlimit -- 他行给我行的授信额度
    ,case when
            n.compcode is null
            and n.islisted is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.compcode is null
            and n.islisted is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.compcode is null
            and n.islisted is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wind_cust_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wind_cust_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.compcode = n.compcode
            and o.islisted = n.islisted
where (
        o.compcode is null
        and o.islisted is null
    )
    or (
        n.compcode is null
        and n.islisted is null
    )
    or (
        o.totalassets <> n.totalassets
        or o.inputuserid <> n.inputuserid
        or o.registercapital <> n.registercapital
        or o.totalrights <> n.totalrights
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.country <> n.country
        or o.registarea <> n.registarea
        or o.banktype <> n.banktype
        or o.city <> n.city
        or o.customername <> n.customername
        or o.bankclass <> n.bankclass
        or o.updateorgid <> n.updateorgid
        or o.migtflag <> n.migtflag
        or o.province <> n.province
        or o.reportperiod <> n.reportperiod
        or o.sharecode <> n.sharecode
        or o.updatedate <> n.updatedate
        or o.updateflag <> n.updateflag
        or o.customerid <> n.customerid
        or o.clearassets <> n.clearassets
        or o.outdate <> n.outdate
        or o.compname <> n.compname
        or o.inputorgid <> n.inputorgid
        or o.addflag <> n.addflag
        or o.givencreditlimit <> n.givencreditlimit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wind_cust_info_cl(
            compcode -- 上市、非上市公司代码
            ,islisted -- 是否上市
            ,totalassets -- 资产合计
            ,inputuserid -- 新增员工编号
            ,registercapital -- 注册资本
            ,totalrights -- 所有者权益合计
            ,inputdate -- 新增日期
            ,updateuserid -- 更新员工编号
            ,country -- 国家名称
            ,registarea -- 注册区域
            ,banktype -- 银行类型:national-全国性的local-地区性的
            ,city -- 城市名称
            ,customername -- 关联客户名称
            ,bankclass -- 银行性质:国有银行/政策银行/邮储银行/上市全国股份制银行/上市非全国性股份制银行/城商行/农商行
            ,updateorgid -- 更新机构编号
            ,migtflag -- 
            ,province -- 省份名称
            ,reportperiod -- 最新一期资产负债表合并报表
            ,sharecode -- 上市代码
            ,updatedate -- 更新日期
            ,updateflag -- 操作标志:A-手动新增U-手动更新
            ,customerid -- 关联客户编号
            ,clearassets -- 净资产
            ,outdate -- 退出日期
            ,compname -- 公司名称
            ,inputorgid -- 新增机构编号
            ,addflag -- 新增标志：A-人工新增
            ,givencreditlimit -- 他行给我行的授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wind_cust_info_op(
            compcode -- 上市、非上市公司代码
            ,islisted -- 是否上市
            ,totalassets -- 资产合计
            ,inputuserid -- 新增员工编号
            ,registercapital -- 注册资本
            ,totalrights -- 所有者权益合计
            ,inputdate -- 新增日期
            ,updateuserid -- 更新员工编号
            ,country -- 国家名称
            ,registarea -- 注册区域
            ,banktype -- 银行类型:national-全国性的local-地区性的
            ,city -- 城市名称
            ,customername -- 关联客户名称
            ,bankclass -- 银行性质:国有银行/政策银行/邮储银行/上市全国股份制银行/上市非全国性股份制银行/城商行/农商行
            ,updateorgid -- 更新机构编号
            ,migtflag -- 
            ,province -- 省份名称
            ,reportperiod -- 最新一期资产负债表合并报表
            ,sharecode -- 上市代码
            ,updatedate -- 更新日期
            ,updateflag -- 操作标志:A-手动新增U-手动更新
            ,customerid -- 关联客户编号
            ,clearassets -- 净资产
            ,outdate -- 退出日期
            ,compname -- 公司名称
            ,inputorgid -- 新增机构编号
            ,addflag -- 新增标志：A-人工新增
            ,givencreditlimit -- 他行给我行的授信额度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.compcode -- 上市、非上市公司代码
    ,o.islisted -- 是否上市
    ,o.totalassets -- 资产合计
    ,o.inputuserid -- 新增员工编号
    ,o.registercapital -- 注册资本
    ,o.totalrights -- 所有者权益合计
    ,o.inputdate -- 新增日期
    ,o.updateuserid -- 更新员工编号
    ,o.country -- 国家名称
    ,o.registarea -- 注册区域
    ,o.banktype -- 银行类型:national-全国性的local-地区性的
    ,o.city -- 城市名称
    ,o.customername -- 关联客户名称
    ,o.bankclass -- 银行性质:国有银行/政策银行/邮储银行/上市全国股份制银行/上市非全国性股份制银行/城商行/农商行
    ,o.updateorgid -- 更新机构编号
    ,o.migtflag -- 
    ,o.province -- 省份名称
    ,o.reportperiod -- 最新一期资产负债表合并报表
    ,o.sharecode -- 上市代码
    ,o.updatedate -- 更新日期
    ,o.updateflag -- 操作标志:A-手动新增U-手动更新
    ,o.customerid -- 关联客户编号
    ,o.clearassets -- 净资产
    ,o.outdate -- 退出日期
    ,o.compname -- 公司名称
    ,o.inputorgid -- 新增机构编号
    ,o.addflag -- 新增标志：A-人工新增
    ,o.givencreditlimit -- 他行给我行的授信额度
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
from ${iol_schema}.icms_wind_cust_info_bk o
    left join ${iol_schema}.icms_wind_cust_info_op n
        on
            o.compcode = n.compcode
            and o.islisted = n.islisted
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wind_cust_info_cl d
        on
            o.compcode = d.compcode
            and o.islisted = d.islisted
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wind_cust_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wind_cust_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wind_cust_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wind_cust_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wind_cust_info exchange partition p_${batch_date} with table ${iol_schema}.icms_wind_cust_info_cl;
alter table ${iol_schema}.icms_wind_cust_info exchange partition p_20991231 with table ${iol_schema}.icms_wind_cust_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wind_cust_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wind_cust_info_op purge;
drop table ${iol_schema}.icms_wind_cust_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wind_cust_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wind_cust_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
