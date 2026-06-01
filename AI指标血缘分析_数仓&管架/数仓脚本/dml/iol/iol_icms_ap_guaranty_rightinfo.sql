/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_guaranty_rightinfo
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
create table ${iol_schema}.icms_ap_guaranty_rightinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_guaranty_rightinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_guaranty_rightinfo_op purge;
drop table ${iol_schema}.icms_ap_guaranty_rightinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_guaranty_rightinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_guaranty_rightinfo where 0=1;

create table ${iol_schema}.icms_ap_guaranty_rightinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_guaranty_rightinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_guaranty_rightinfo_cl(
            rightinfono -- 记录编号
            ,inputdate -- 登记日期
            ,guarantyid -- 资产编号
            ,otherrightflag -- 是否存在他项权利
            ,inputuserid -- 登记人
            ,rightkeeper -- 权证保管人
            ,updateorgid -- 更新机构
            ,fileno -- 影像平台编号
            ,updatedate -- 更新日期
            ,deliverydate -- 权证交付日期
            ,deliveryperson -- 权证交付人
            ,inputorgid -- 登记机构
            ,rightkeepadd -- 权证保管地点
            ,tmsp -- 时间戳
            ,otherrightinfo -- 他项权利说明
            ,updateuserid -- 更新人
            ,deleteflag -- 删除标志
            ,rightid -- 权证编号
            ,rightdate -- 取得权证日期
            ,rightname -- 权证名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_guaranty_rightinfo_op(
            rightinfono -- 记录编号
            ,inputdate -- 登记日期
            ,guarantyid -- 资产编号
            ,otherrightflag -- 是否存在他项权利
            ,inputuserid -- 登记人
            ,rightkeeper -- 权证保管人
            ,updateorgid -- 更新机构
            ,fileno -- 影像平台编号
            ,updatedate -- 更新日期
            ,deliverydate -- 权证交付日期
            ,deliveryperson -- 权证交付人
            ,inputorgid -- 登记机构
            ,rightkeepadd -- 权证保管地点
            ,tmsp -- 时间戳
            ,otherrightinfo -- 他项权利说明
            ,updateuserid -- 更新人
            ,deleteflag -- 删除标志
            ,rightid -- 权证编号
            ,rightdate -- 取得权证日期
            ,rightname -- 权证名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.rightinfono, o.rightinfono) as rightinfono -- 记录编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.guarantyid, o.guarantyid) as guarantyid -- 资产编号
    ,nvl(n.otherrightflag, o.otherrightflag) as otherrightflag -- 是否存在他项权利
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.rightkeeper, o.rightkeeper) as rightkeeper -- 权证保管人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.fileno, o.fileno) as fileno -- 影像平台编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.deliverydate, o.deliverydate) as deliverydate -- 权证交付日期
    ,nvl(n.deliveryperson, o.deliveryperson) as deliveryperson -- 权证交付人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.rightkeepadd, o.rightkeepadd) as rightkeepadd -- 权证保管地点
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.otherrightinfo, o.otherrightinfo) as otherrightinfo -- 他项权利说明
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,nvl(n.rightid, o.rightid) as rightid -- 权证编号
    ,nvl(n.rightdate, o.rightdate) as rightdate -- 取得权证日期
    ,nvl(n.rightname, o.rightname) as rightname -- 权证名称
    ,case when
            n.rightinfono is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.rightinfono is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.rightinfono is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_guaranty_rightinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_guaranty_rightinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.rightinfono = n.rightinfono
where (
        o.rightinfono is null
    )
    or (
        n.rightinfono is null
    )
    or (
        o.inputdate <> n.inputdate
        or o.guarantyid <> n.guarantyid
        or o.otherrightflag <> n.otherrightflag
        or o.inputuserid <> n.inputuserid
        or o.rightkeeper <> n.rightkeeper
        or o.updateorgid <> n.updateorgid
        or o.fileno <> n.fileno
        or o.updatedate <> n.updatedate
        or o.deliverydate <> n.deliverydate
        or o.deliveryperson <> n.deliveryperson
        or o.inputorgid <> n.inputorgid
        or o.rightkeepadd <> n.rightkeepadd
        or o.tmsp <> n.tmsp
        or o.otherrightinfo <> n.otherrightinfo
        or o.updateuserid <> n.updateuserid
        or o.deleteflag <> n.deleteflag
        or o.rightid <> n.rightid
        or o.rightdate <> n.rightdate
        or o.rightname <> n.rightname
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_guaranty_rightinfo_cl(
            rightinfono -- 记录编号
            ,inputdate -- 登记日期
            ,guarantyid -- 资产编号
            ,otherrightflag -- 是否存在他项权利
            ,inputuserid -- 登记人
            ,rightkeeper -- 权证保管人
            ,updateorgid -- 更新机构
            ,fileno -- 影像平台编号
            ,updatedate -- 更新日期
            ,deliverydate -- 权证交付日期
            ,deliveryperson -- 权证交付人
            ,inputorgid -- 登记机构
            ,rightkeepadd -- 权证保管地点
            ,tmsp -- 时间戳
            ,otherrightinfo -- 他项权利说明
            ,updateuserid -- 更新人
            ,deleteflag -- 删除标志
            ,rightid -- 权证编号
            ,rightdate -- 取得权证日期
            ,rightname -- 权证名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_guaranty_rightinfo_op(
            rightinfono -- 记录编号
            ,inputdate -- 登记日期
            ,guarantyid -- 资产编号
            ,otherrightflag -- 是否存在他项权利
            ,inputuserid -- 登记人
            ,rightkeeper -- 权证保管人
            ,updateorgid -- 更新机构
            ,fileno -- 影像平台编号
            ,updatedate -- 更新日期
            ,deliverydate -- 权证交付日期
            ,deliveryperson -- 权证交付人
            ,inputorgid -- 登记机构
            ,rightkeepadd -- 权证保管地点
            ,tmsp -- 时间戳
            ,otherrightinfo -- 他项权利说明
            ,updateuserid -- 更新人
            ,deleteflag -- 删除标志
            ,rightid -- 权证编号
            ,rightdate -- 取得权证日期
            ,rightname -- 权证名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.rightinfono -- 记录编号
    ,o.inputdate -- 登记日期
    ,o.guarantyid -- 资产编号
    ,o.otherrightflag -- 是否存在他项权利
    ,o.inputuserid -- 登记人
    ,o.rightkeeper -- 权证保管人
    ,o.updateorgid -- 更新机构
    ,o.fileno -- 影像平台编号
    ,o.updatedate -- 更新日期
    ,o.deliverydate -- 权证交付日期
    ,o.deliveryperson -- 权证交付人
    ,o.inputorgid -- 登记机构
    ,o.rightkeepadd -- 权证保管地点
    ,o.tmsp -- 时间戳
    ,o.otherrightinfo -- 他项权利说明
    ,o.updateuserid -- 更新人
    ,o.deleteflag -- 删除标志
    ,o.rightid -- 权证编号
    ,o.rightdate -- 取得权证日期
    ,o.rightname -- 权证名称
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
from ${iol_schema}.icms_ap_guaranty_rightinfo_bk o
    left join ${iol_schema}.icms_ap_guaranty_rightinfo_op n
        on
            o.rightinfono = n.rightinfono
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_guaranty_rightinfo_cl d
        on
            o.rightinfono = d.rightinfono
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_guaranty_rightinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_guaranty_rightinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_guaranty_rightinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_guaranty_rightinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_guaranty_rightinfo exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_guaranty_rightinfo_cl;
alter table ${iol_schema}.icms_ap_guaranty_rightinfo exchange partition p_20991231 with table ${iol_schema}.icms_ap_guaranty_rightinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_guaranty_rightinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_guaranty_rightinfo_op purge;
drop table ${iol_schema}.icms_ap_guaranty_rightinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_guaranty_rightinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_guaranty_rightinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
