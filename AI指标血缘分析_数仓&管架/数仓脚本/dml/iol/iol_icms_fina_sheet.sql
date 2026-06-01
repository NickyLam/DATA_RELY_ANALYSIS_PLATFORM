/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_fina_sheet
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
create table ${iol_schema}.icms_fina_sheet_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_fina_sheet
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fina_sheet_op purge;
drop table ${iol_schema}.icms_fina_sheet_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_fina_sheet_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fina_sheet where 0=1;

create table ${iol_schema}.icms_fina_sheet_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_fina_sheet where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fina_sheet_cl(
            sheetno -- 报表号
            ,reportscope -- 报表口径(冗余)
            ,reportperiod -- 报表周期(冗余)
            ,customerid -- 客户编号(冗余)
            ,inputuserid -- 登记人
            ,calculateerrorinfo -- 计算错误信息
            ,reportname -- 报表名称
            ,sheettype -- 报表类型
            ,accountingmonth -- 会计月(冗余)
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,reportno -- 财报号
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,inputdate -- 登记日期登记日期时间
            ,updateorgid -- 更新机构
            ,reporttypeno -- 财报类型编号
            ,deleteflag -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fina_sheet_op(
            sheetno -- 报表号
            ,reportscope -- 报表口径(冗余)
            ,reportperiod -- 报表周期(冗余)
            ,customerid -- 客户编号(冗余)
            ,inputuserid -- 登记人
            ,calculateerrorinfo -- 计算错误信息
            ,reportname -- 报表名称
            ,sheettype -- 报表类型
            ,accountingmonth -- 会计月(冗余)
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,reportno -- 财报号
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,inputdate -- 登记日期登记日期时间
            ,updateorgid -- 更新机构
            ,reporttypeno -- 财报类型编号
            ,deleteflag -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sheetno, o.sheetno) as sheetno -- 报表号
    ,nvl(n.reportscope, o.reportscope) as reportscope -- 报表口径(冗余)
    ,nvl(n.reportperiod, o.reportperiod) as reportperiod -- 报表周期(冗余)
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号(冗余)
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.calculateerrorinfo, o.calculateerrorinfo) as calculateerrorinfo -- 计算错误信息
    ,nvl(n.reportname, o.reportname) as reportname -- 报表名称
    ,nvl(n.sheettype, o.sheettype) as sheettype -- 报表类型
    ,nvl(n.accountingmonth, o.accountingmonth) as accountingmonth -- 会计月(冗余)
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.reportno, o.reportno) as reportno -- 财报号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期登记日期时间
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.reporttypeno, o.reporttypeno) as reporttypeno -- 财报类型编号
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,case when
            n.sheetno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sheetno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sheetno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_fina_sheet_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_fina_sheet where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sheetno = n.sheetno
where (
        o.sheetno is null
    )
    or (
        n.sheetno is null
    )
    or (
        o.reportscope <> n.reportscope
        or o.reportperiod <> n.reportperiod
        or o.customerid <> n.customerid
        or o.inputuserid <> n.inputuserid
        or o.calculateerrorinfo <> n.calculateerrorinfo
        or o.reportname <> n.reportname
        or o.sheettype <> n.sheettype
        or o.accountingmonth <> n.accountingmonth
        or o.inputorgid <> n.inputorgid
        or o.updateuserid <> n.updateuserid
        or o.reportno <> n.reportno
        or o.updatedate <> n.updatedate
        or o.migtflag <> n.migtflag
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.reporttypeno <> n.reporttypeno
        or o.deleteflag <> n.deleteflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_fina_sheet_cl(
            sheetno -- 报表号
            ,reportscope -- 报表口径(冗余)
            ,reportperiod -- 报表周期(冗余)
            ,customerid -- 客户编号(冗余)
            ,inputuserid -- 登记人
            ,calculateerrorinfo -- 计算错误信息
            ,reportname -- 报表名称
            ,sheettype -- 报表类型
            ,accountingmonth -- 会计月(冗余)
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,reportno -- 财报号
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,inputdate -- 登记日期登记日期时间
            ,updateorgid -- 更新机构
            ,reporttypeno -- 财报类型编号
            ,deleteflag -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_fina_sheet_op(
            sheetno -- 报表号
            ,reportscope -- 报表口径(冗余)
            ,reportperiod -- 报表周期(冗余)
            ,customerid -- 客户编号(冗余)
            ,inputuserid -- 登记人
            ,calculateerrorinfo -- 计算错误信息
            ,reportname -- 报表名称
            ,sheettype -- 报表类型
            ,accountingmonth -- 会计月(冗余)
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,reportno -- 财报号
            ,updatedate -- 更新日期
            ,migtflag -- 
            ,inputdate -- 登记日期登记日期时间
            ,updateorgid -- 更新机构
            ,reporttypeno -- 财报类型编号
            ,deleteflag -- 删除标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sheetno -- 报表号
    ,o.reportscope -- 报表口径(冗余)
    ,o.reportperiod -- 报表周期(冗余)
    ,o.customerid -- 客户编号(冗余)
    ,o.inputuserid -- 登记人
    ,o.calculateerrorinfo -- 计算错误信息
    ,o.reportname -- 报表名称
    ,o.sheettype -- 报表类型
    ,o.accountingmonth -- 会计月(冗余)
    ,o.inputorgid -- 登记机构
    ,o.updateuserid -- 更新人
    ,o.reportno -- 财报号
    ,o.updatedate -- 更新日期
    ,o.migtflag -- 
    ,o.inputdate -- 登记日期登记日期时间
    ,o.updateorgid -- 更新机构
    ,o.reporttypeno -- 财报类型编号
    ,o.deleteflag -- 删除标志
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
from ${iol_schema}.icms_fina_sheet_bk o
    left join ${iol_schema}.icms_fina_sheet_op n
        on
            o.sheetno = n.sheetno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_fina_sheet_cl d
        on
            o.sheetno = d.sheetno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_fina_sheet;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_fina_sheet') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_fina_sheet drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_fina_sheet add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_fina_sheet exchange partition p_${batch_date} with table ${iol_schema}.icms_fina_sheet_cl;
alter table ${iol_schema}.icms_fina_sheet exchange partition p_20991231 with table ${iol_schema}.icms_fina_sheet_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_fina_sheet to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_fina_sheet_op purge;
drop table ${iol_schema}.icms_fina_sheet_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_fina_sheet_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_fina_sheet',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
