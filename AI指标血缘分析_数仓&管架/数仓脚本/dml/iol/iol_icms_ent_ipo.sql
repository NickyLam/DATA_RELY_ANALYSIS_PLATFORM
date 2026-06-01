/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ent_ipo
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
create table ${iol_schema}.icms_ent_ipo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ent_ipo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ent_ipo_op purge;
drop table ${iol_schema}.icms_ent_ipo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ent_ipo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ent_ipo where 0=1;

create table ${iol_schema}.icms_ent_ipo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ent_ipo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ent_ipo_cl(
            serialno -- 流水号
            ,ipoaddress -- 上市地
            ,stockcode -- 股票代码
            ,migtflag -- 
            ,ipodate -- 上市日期
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,customerid -- 客户编号
            ,stockquantity -- 发行量
            ,updateuserid -- 更新人
            ,stockname -- 股票名称
            ,updatedate -- 更新日期
            ,iponame -- 上市交易所
            ,inputuserid -- 登记人
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,stocktype -- 股票类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ent_ipo_op(
            serialno -- 流水号
            ,ipoaddress -- 上市地
            ,stockcode -- 股票代码
            ,migtflag -- 
            ,ipodate -- 上市日期
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,customerid -- 客户编号
            ,stockquantity -- 发行量
            ,updateuserid -- 更新人
            ,stockname -- 股票名称
            ,updatedate -- 更新日期
            ,iponame -- 上市交易所
            ,inputuserid -- 登记人
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,stocktype -- 股票类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.ipoaddress, o.ipoaddress) as ipoaddress -- 上市地
    ,nvl(n.stockcode, o.stockcode) as stockcode -- 股票代码
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.ipodate, o.ipodate) as ipodate -- 上市日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.stockquantity, o.stockquantity) as stockquantity -- 发行量
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.stockname, o.stockname) as stockname -- 股票名称
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.iponame, o.iponame) as iponame -- 上市交易所
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.stocktype, o.stocktype) as stocktype -- 股票类型
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
from (select * from ${iol_schema}.icms_ent_ipo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ent_ipo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.ipoaddress <> n.ipoaddress
        or o.stockcode <> n.stockcode
        or o.migtflag <> n.migtflag
        or o.ipodate <> n.ipodate
        or o.remark <> n.remark
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.customerid <> n.customerid
        or o.stockquantity <> n.stockquantity
        or o.updateuserid <> n.updateuserid
        or o.stockname <> n.stockname
        or o.updatedate <> n.updatedate
        or o.iponame <> n.iponame
        or o.inputuserid <> n.inputuserid
        or o.corporgid <> n.corporgid
        or o.inputorgid <> n.inputorgid
        or o.stocktype <> n.stocktype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ent_ipo_cl(
            serialno -- 流水号
            ,ipoaddress -- 上市地
            ,stockcode -- 股票代码
            ,migtflag -- 
            ,ipodate -- 上市日期
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,customerid -- 客户编号
            ,stockquantity -- 发行量
            ,updateuserid -- 更新人
            ,stockname -- 股票名称
            ,updatedate -- 更新日期
            ,iponame -- 上市交易所
            ,inputuserid -- 登记人
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,stocktype -- 股票类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ent_ipo_op(
            serialno -- 流水号
            ,ipoaddress -- 上市地
            ,stockcode -- 股票代码
            ,migtflag -- 
            ,ipodate -- 上市日期
            ,remark -- 备注
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,customerid -- 客户编号
            ,stockquantity -- 发行量
            ,updateuserid -- 更新人
            ,stockname -- 股票名称
            ,updatedate -- 更新日期
            ,iponame -- 上市交易所
            ,inputuserid -- 登记人
            ,corporgid -- 法人机构编号
            ,inputorgid -- 登记机构
            ,stocktype -- 股票类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.ipoaddress -- 上市地
    ,o.stockcode -- 股票代码
    ,o.migtflag -- 
    ,o.ipodate -- 上市日期
    ,o.remark -- 备注
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.customerid -- 客户编号
    ,o.stockquantity -- 发行量
    ,o.updateuserid -- 更新人
    ,o.stockname -- 股票名称
    ,o.updatedate -- 更新日期
    ,o.iponame -- 上市交易所
    ,o.inputuserid -- 登记人
    ,o.corporgid -- 法人机构编号
    ,o.inputorgid -- 登记机构
    ,o.stocktype -- 股票类型
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
from ${iol_schema}.icms_ent_ipo_bk o
    left join ${iol_schema}.icms_ent_ipo_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ent_ipo_cl d
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
--truncate table ${iol_schema}.icms_ent_ipo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ent_ipo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ent_ipo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ent_ipo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ent_ipo exchange partition p_${batch_date} with table ${iol_schema}.icms_ent_ipo_cl;
alter table ${iol_schema}.icms_ent_ipo exchange partition p_20991231 with table ${iol_schema}.icms_ent_ipo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ent_ipo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ent_ipo_op purge;
drop table ${iol_schema}.icms_ent_ipo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ent_ipo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ent_ipo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
