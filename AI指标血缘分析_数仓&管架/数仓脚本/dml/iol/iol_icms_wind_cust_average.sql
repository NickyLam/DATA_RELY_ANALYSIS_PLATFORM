/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wind_cust_average
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
create table ${iol_schema}.icms_wind_cust_average_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wind_cust_average
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wind_cust_average_op purge;
drop table ${iol_schema}.icms_wind_cust_average_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wind_cust_average_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wind_cust_average where 0=1;

create table ${iol_schema}.icms_wind_cust_average_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wind_cust_average where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wind_cust_average_cl(
            serialno -- 流水号
            ,badrateave -- 不良贷款率
            ,recordcount -- 均值计算样本记录数
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,loanprovisionrateave -- 贷款拨备率
            ,costincomerateave -- 成本收入比
            ,yicapirateave -- 一级资本充足率
            ,assetliqcoverrateave -- 流动性覆盖率
            ,assetprofitrateave -- 资本利润率
            ,attentionrateave -- 关注类贷款占比
            ,capirateave -- 资本充足率
            ,inputorgid -- 新增机构编号
            ,assetliqrateave -- 流动性比例)
            ,migtflag -- 
            ,inputdate -- 新增日期
            ,inputuserid -- 新增员工编号
            ,coreyicapirateave -- 核心一级资本充足率
            ,provisionrateave -- 拨备覆盖率
            ,leverrateave -- 杠杆率
            ,singlegrouprateave -- 单一集团贷款集中度
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wind_cust_average_op(
            serialno -- 流水号
            ,badrateave -- 不良贷款率
            ,recordcount -- 均值计算样本记录数
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,loanprovisionrateave -- 贷款拨备率
            ,costincomerateave -- 成本收入比
            ,yicapirateave -- 一级资本充足率
            ,assetliqcoverrateave -- 流动性覆盖率
            ,assetprofitrateave -- 资本利润率
            ,attentionrateave -- 关注类贷款占比
            ,capirateave -- 资本充足率
            ,inputorgid -- 新增机构编号
            ,assetliqrateave -- 流动性比例)
            ,migtflag -- 
            ,inputdate -- 新增日期
            ,inputuserid -- 新增员工编号
            ,coreyicapirateave -- 核心一级资本充足率
            ,provisionrateave -- 拨备覆盖率
            ,leverrateave -- 杠杆率
            ,singlegrouprateave -- 单一集团贷款集中度
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.badrateave, o.badrateave) as badrateave -- 不良贷款率
    ,nvl(n.recordcount, o.recordcount) as recordcount -- 均值计算样本记录数
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.loanprovisionrateave, o.loanprovisionrateave) as loanprovisionrateave -- 贷款拨备率
    ,nvl(n.costincomerateave, o.costincomerateave) as costincomerateave -- 成本收入比
    ,nvl(n.yicapirateave, o.yicapirateave) as yicapirateave -- 一级资本充足率
    ,nvl(n.assetliqcoverrateave, o.assetliqcoverrateave) as assetliqcoverrateave -- 流动性覆盖率
    ,nvl(n.assetprofitrateave, o.assetprofitrateave) as assetprofitrateave -- 资本利润率
    ,nvl(n.attentionrateave, o.attentionrateave) as attentionrateave -- 关注类贷款占比
    ,nvl(n.capirateave, o.capirateave) as capirateave -- 资本充足率
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 新增机构编号
    ,nvl(n.assetliqrateave, o.assetliqrateave) as assetliqrateave -- 流动性比例)
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 新增日期
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 新增员工编号
    ,nvl(n.coreyicapirateave, o.coreyicapirateave) as coreyicapirateave -- 核心一级资本充足率
    ,nvl(n.provisionrateave, o.provisionrateave) as provisionrateave -- 拨备覆盖率
    ,nvl(n.leverrateave, o.leverrateave) as leverrateave -- 杠杆率
    ,nvl(n.singlegrouprateave, o.singlegrouprateave) as singlegrouprateave -- 单一集团贷款集中度
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
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
from (select * from ${iol_schema}.icms_wind_cust_average_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wind_cust_average where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.badrateave <> n.badrateave
        or o.recordcount <> n.recordcount
        or o.updatedate <> n.updatedate
        or o.updateorgid <> n.updateorgid
        or o.loanprovisionrateave <> n.loanprovisionrateave
        or o.costincomerateave <> n.costincomerateave
        or o.yicapirateave <> n.yicapirateave
        or o.assetliqcoverrateave <> n.assetliqcoverrateave
        or o.assetprofitrateave <> n.assetprofitrateave
        or o.attentionrateave <> n.attentionrateave
        or o.capirateave <> n.capirateave
        or o.inputorgid <> n.inputorgid
        or o.assetliqrateave <> n.assetliqrateave
        or o.migtflag <> n.migtflag
        or o.inputdate <> n.inputdate
        or o.inputuserid <> n.inputuserid
        or o.coreyicapirateave <> n.coreyicapirateave
        or o.provisionrateave <> n.provisionrateave
        or o.leverrateave <> n.leverrateave
        or o.singlegrouprateave <> n.singlegrouprateave
        or o.updateuserid <> n.updateuserid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wind_cust_average_cl(
            serialno -- 流水号
            ,badrateave -- 不良贷款率
            ,recordcount -- 均值计算样本记录数
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,loanprovisionrateave -- 贷款拨备率
            ,costincomerateave -- 成本收入比
            ,yicapirateave -- 一级资本充足率
            ,assetliqcoverrateave -- 流动性覆盖率
            ,assetprofitrateave -- 资本利润率
            ,attentionrateave -- 关注类贷款占比
            ,capirateave -- 资本充足率
            ,inputorgid -- 新增机构编号
            ,assetliqrateave -- 流动性比例)
            ,migtflag -- 
            ,inputdate -- 新增日期
            ,inputuserid -- 新增员工编号
            ,coreyicapirateave -- 核心一级资本充足率
            ,provisionrateave -- 拨备覆盖率
            ,leverrateave -- 杠杆率
            ,singlegrouprateave -- 单一集团贷款集中度
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wind_cust_average_op(
            serialno -- 流水号
            ,badrateave -- 不良贷款率
            ,recordcount -- 均值计算样本记录数
            ,updatedate -- 更新日期
            ,updateorgid -- 更新机构
            ,loanprovisionrateave -- 贷款拨备率
            ,costincomerateave -- 成本收入比
            ,yicapirateave -- 一级资本充足率
            ,assetliqcoverrateave -- 流动性覆盖率
            ,assetprofitrateave -- 资本利润率
            ,attentionrateave -- 关注类贷款占比
            ,capirateave -- 资本充足率
            ,inputorgid -- 新增机构编号
            ,assetliqrateave -- 流动性比例)
            ,migtflag -- 
            ,inputdate -- 新增日期
            ,inputuserid -- 新增员工编号
            ,coreyicapirateave -- 核心一级资本充足率
            ,provisionrateave -- 拨备覆盖率
            ,leverrateave -- 杠杆率
            ,singlegrouprateave -- 单一集团贷款集中度
            ,updateuserid -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.badrateave -- 不良贷款率
    ,o.recordcount -- 均值计算样本记录数
    ,o.updatedate -- 更新日期
    ,o.updateorgid -- 更新机构
    ,o.loanprovisionrateave -- 贷款拨备率
    ,o.costincomerateave -- 成本收入比
    ,o.yicapirateave -- 一级资本充足率
    ,o.assetliqcoverrateave -- 流动性覆盖率
    ,o.assetprofitrateave -- 资本利润率
    ,o.attentionrateave -- 关注类贷款占比
    ,o.capirateave -- 资本充足率
    ,o.inputorgid -- 新增机构编号
    ,o.assetliqrateave -- 流动性比例)
    ,o.migtflag -- 
    ,o.inputdate -- 新增日期
    ,o.inputuserid -- 新增员工编号
    ,o.coreyicapirateave -- 核心一级资本充足率
    ,o.provisionrateave -- 拨备覆盖率
    ,o.leverrateave -- 杠杆率
    ,o.singlegrouprateave -- 单一集团贷款集中度
    ,o.updateuserid -- 更新人
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
from ${iol_schema}.icms_wind_cust_average_bk o
    left join ${iol_schema}.icms_wind_cust_average_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wind_cust_average_cl d
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
--truncate table ${iol_schema}.icms_wind_cust_average;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wind_cust_average') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wind_cust_average drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wind_cust_average add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wind_cust_average exchange partition p_${batch_date} with table ${iol_schema}.icms_wind_cust_average_cl;
alter table ${iol_schema}.icms_wind_cust_average exchange partition p_20991231 with table ${iol_schema}.icms_wind_cust_average_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wind_cust_average to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wind_cust_average_op purge;
drop table ${iol_schema}.icms_wind_cust_average_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wind_cust_average_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wind_cust_average',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
