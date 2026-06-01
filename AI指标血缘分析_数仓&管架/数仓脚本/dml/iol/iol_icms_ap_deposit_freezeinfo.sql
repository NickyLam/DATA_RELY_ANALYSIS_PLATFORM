/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_deposit_freezeinfo
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
create table ${iol_schema}.icms_ap_deposit_freezeinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_deposit_freezeinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_deposit_freezeinfo_op purge;
drop table ${iol_schema}.icms_ap_deposit_freezeinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_deposit_freezeinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_deposit_freezeinfo where 0=1;

create table ${iol_schema}.icms_ap_deposit_freezeinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_deposit_freezeinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_deposit_freezeinfo_cl(
            freezeno -- 记录编号
            ,deleteflag -- 删除标志
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,planno -- 处置内容编号
            ,signdate -- 保证金冻结协议签订日期
            ,updatedate -- 更新日期
            ,depositvalue -- 保证金金额
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,tenderer -- 投标人
            ,updateorgid -- 更新机构
            ,contractinfo -- 保证金冻结协议
            ,updateuserid -- 更新人
            ,fileno -- 影像平台编号
            ,bailacctno -- 保证金账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_deposit_freezeinfo_op(
            freezeno -- 记录编号
            ,deleteflag -- 删除标志
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,planno -- 处置内容编号
            ,signdate -- 保证金冻结协议签订日期
            ,updatedate -- 更新日期
            ,depositvalue -- 保证金金额
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,tenderer -- 投标人
            ,updateorgid -- 更新机构
            ,contractinfo -- 保证金冻结协议
            ,updateuserid -- 更新人
            ,fileno -- 影像平台编号
            ,bailacctno -- 保证金账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.freezeno, o.freezeno) as freezeno -- 记录编号
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.planno, o.planno) as planno -- 处置内容编号
    ,nvl(n.signdate, o.signdate) as signdate -- 保证金冻结协议签订日期
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.depositvalue, o.depositvalue) as depositvalue -- 保证金金额
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.tenderer, o.tenderer) as tenderer -- 投标人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.contractinfo, o.contractinfo) as contractinfo -- 保证金冻结协议
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.fileno, o.fileno) as fileno -- 影像平台编号
    ,nvl(n.bailacctno, o.bailacctno) as bailacctno -- 保证金账号
    ,case when
            n.freezeno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.freezeno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.freezeno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_deposit_freezeinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_deposit_freezeinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.freezeno = n.freezeno
where (
        o.freezeno is null
    )
    or (
        n.freezeno is null
    )
    or (
        o.deleteflag <> n.deleteflag
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.planno <> n.planno
        or o.signdate <> n.signdate
        or o.updatedate <> n.updatedate
        or o.depositvalue <> n.depositvalue
        or o.tmsp <> n.tmsp
        or o.inputdate <> n.inputdate
        or o.tenderer <> n.tenderer
        or o.updateorgid <> n.updateorgid
        or o.contractinfo <> n.contractinfo
        or o.updateuserid <> n.updateuserid
        or o.fileno <> n.fileno
        or o.bailacctno <> n.bailacctno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_deposit_freezeinfo_cl(
            freezeno -- 记录编号
            ,deleteflag -- 删除标志
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,planno -- 处置内容编号
            ,signdate -- 保证金冻结协议签订日期
            ,updatedate -- 更新日期
            ,depositvalue -- 保证金金额
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,tenderer -- 投标人
            ,updateorgid -- 更新机构
            ,contractinfo -- 保证金冻结协议
            ,updateuserid -- 更新人
            ,fileno -- 影像平台编号
            ,bailacctno -- 保证金账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_deposit_freezeinfo_op(
            freezeno -- 记录编号
            ,deleteflag -- 删除标志
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,planno -- 处置内容编号
            ,signdate -- 保证金冻结协议签订日期
            ,updatedate -- 更新日期
            ,depositvalue -- 保证金金额
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,tenderer -- 投标人
            ,updateorgid -- 更新机构
            ,contractinfo -- 保证金冻结协议
            ,updateuserid -- 更新人
            ,fileno -- 影像平台编号
            ,bailacctno -- 保证金账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.freezeno -- 记录编号
    ,o.deleteflag -- 删除标志
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.planno -- 处置内容编号
    ,o.signdate -- 保证金冻结协议签订日期
    ,o.updatedate -- 更新日期
    ,o.depositvalue -- 保证金金额
    ,o.tmsp -- 时间戳
    ,o.inputdate -- 登记日期
    ,o.tenderer -- 投标人
    ,o.updateorgid -- 更新机构
    ,o.contractinfo -- 保证金冻结协议
    ,o.updateuserid -- 更新人
    ,o.fileno -- 影像平台编号
    ,o.bailacctno -- 保证金账号
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
from ${iol_schema}.icms_ap_deposit_freezeinfo_bk o
    left join ${iol_schema}.icms_ap_deposit_freezeinfo_op n
        on
            o.freezeno = n.freezeno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_deposit_freezeinfo_cl d
        on
            o.freezeno = d.freezeno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_deposit_freezeinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_deposit_freezeinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_deposit_freezeinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_deposit_freezeinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_deposit_freezeinfo exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_deposit_freezeinfo_cl;
alter table ${iol_schema}.icms_ap_deposit_freezeinfo exchange partition p_20991231 with table ${iol_schema}.icms_ap_deposit_freezeinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_deposit_freezeinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_deposit_freezeinfo_op purge;
drop table ${iol_schema}.icms_ap_deposit_freezeinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_deposit_freezeinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_deposit_freezeinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
