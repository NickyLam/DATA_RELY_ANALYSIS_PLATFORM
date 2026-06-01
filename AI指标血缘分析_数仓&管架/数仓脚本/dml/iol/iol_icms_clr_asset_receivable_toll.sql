/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_receivable_toll
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
create table ${iol_schema}.icms_clr_asset_receivable_toll_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_receivable_toll
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_receivable_toll_op purge;
drop table ${iol_schema}.icms_clr_asset_receivable_toll_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_receivable_toll_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_receivable_toll where 0=1;

create table ${iol_schema}.icms_clr_asset_receivable_toll_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_receivable_toll where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_receivable_toll_cl(
            clrid -- 押品编号
            ,inappdocsubtype -- 收费权细类
            ,inappdocno -- 收费权政府批文文号
            ,inappdocnum -- 收费权政府批文名称
            ,certificatecode -- 收费权利证书号
            ,startdate -- 权益开始时间
            ,duedate -- 权益到期时间
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,address -- 详细地址
            ,openbankname -- 专用账户开户行名称
            ,accountno -- 专用账户账号
            ,accountname -- 专用账户名称
            ,remark -- 其他说明
            ,yearlimit -- 剩余收费年限(年)
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_receivable_toll_op(
            clrid -- 押品编号
            ,inappdocsubtype -- 收费权细类
            ,inappdocno -- 收费权政府批文文号
            ,inappdocnum -- 收费权政府批文名称
            ,certificatecode -- 收费权利证书号
            ,startdate -- 权益开始时间
            ,duedate -- 权益到期时间
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,address -- 详细地址
            ,openbankname -- 专用账户开户行名称
            ,accountno -- 专用账户账号
            ,accountname -- 专用账户名称
            ,remark -- 其他说明
            ,yearlimit -- 剩余收费年限(年)
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.inappdocsubtype, o.inappdocsubtype) as inappdocsubtype -- 收费权细类
    ,nvl(n.inappdocno, o.inappdocno) as inappdocno -- 收费权政府批文文号
    ,nvl(n.inappdocnum, o.inappdocnum) as inappdocnum -- 收费权政府批文名称
    ,nvl(n.certificatecode, o.certificatecode) as certificatecode -- 收费权利证书号
    ,nvl(n.startdate, o.startdate) as startdate -- 权益开始时间
    ,nvl(n.duedate, o.duedate) as duedate -- 权益到期时间
    ,nvl(n.province, o.province) as province -- 所在/注册省份
    ,nvl(n.city, o.city) as city -- 所在/注册市
    ,nvl(n.address, o.address) as address -- 详细地址
    ,nvl(n.openbankname, o.openbankname) as openbankname -- 专用账户开户行名称
    ,nvl(n.accountno, o.accountno) as accountno -- 专用账户账号
    ,nvl(n.accountname, o.accountname) as accountname -- 专用账户名称
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.yearlimit, o.yearlimit) as yearlimit -- 剩余收费年限(年)
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
from (select * from ${iol_schema}.icms_clr_asset_receivable_toll_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_receivable_toll where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.inappdocsubtype <> n.inappdocsubtype
        or o.inappdocno <> n.inappdocno
        or o.inappdocnum <> n.inappdocnum
        or o.certificatecode <> n.certificatecode
        or o.startdate <> n.startdate
        or o.duedate <> n.duedate
        or o.province <> n.province
        or o.city <> n.city
        or o.address <> n.address
        or o.openbankname <> n.openbankname
        or o.accountno <> n.accountno
        or o.accountname <> n.accountname
        or o.remark <> n.remark
        or o.yearlimit <> n.yearlimit
        or o.migtflag <> n.migtflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_receivable_toll_cl(
            clrid -- 押品编号
            ,inappdocsubtype -- 收费权细类
            ,inappdocno -- 收费权政府批文文号
            ,inappdocnum -- 收费权政府批文名称
            ,certificatecode -- 收费权利证书号
            ,startdate -- 权益开始时间
            ,duedate -- 权益到期时间
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,address -- 详细地址
            ,openbankname -- 专用账户开户行名称
            ,accountno -- 专用账户账号
            ,accountname -- 专用账户名称
            ,remark -- 其他说明
            ,yearlimit -- 剩余收费年限(年)
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_receivable_toll_op(
            clrid -- 押品编号
            ,inappdocsubtype -- 收费权细类
            ,inappdocno -- 收费权政府批文文号
            ,inappdocnum -- 收费权政府批文名称
            ,certificatecode -- 收费权利证书号
            ,startdate -- 权益开始时间
            ,duedate -- 权益到期时间
            ,province -- 所在/注册省份
            ,city -- 所在/注册市
            ,address -- 详细地址
            ,openbankname -- 专用账户开户行名称
            ,accountno -- 专用账户账号
            ,accountname -- 专用账户名称
            ,remark -- 其他说明
            ,yearlimit -- 剩余收费年限(年)
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.inappdocsubtype -- 收费权细类
    ,o.inappdocno -- 收费权政府批文文号
    ,o.inappdocnum -- 收费权政府批文名称
    ,o.certificatecode -- 收费权利证书号
    ,o.startdate -- 权益开始时间
    ,o.duedate -- 权益到期时间
    ,o.province -- 所在/注册省份
    ,o.city -- 所在/注册市
    ,o.address -- 详细地址
    ,o.openbankname -- 专用账户开户行名称
    ,o.accountno -- 专用账户账号
    ,o.accountname -- 专用账户名称
    ,o.remark -- 其他说明
    ,o.yearlimit -- 剩余收费年限(年)
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
from ${iol_schema}.icms_clr_asset_receivable_toll_bk o
    left join ${iol_schema}.icms_clr_asset_receivable_toll_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_receivable_toll_cl d
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
--truncate table ${iol_schema}.icms_clr_asset_receivable_toll;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_receivable_toll') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_receivable_toll drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_receivable_toll add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_receivable_toll exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_receivable_toll_cl;
alter table ${iol_schema}.icms_clr_asset_receivable_toll exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_receivable_toll_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_receivable_toll to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_receivable_toll_op purge;
drop table ${iol_schema}.icms_clr_asset_receivable_toll_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_receivable_toll_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_receivable_toll',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
