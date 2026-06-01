/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_guaranty_righttransfer
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
create table ${iol_schema}.icms_ap_guaranty_righttransfer_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_guaranty_righttransfer
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_guaranty_righttransfer_op purge;
drop table ${iol_schema}.icms_ap_guaranty_righttransfer_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_guaranty_righttransfer_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_guaranty_righttransfer where 0=1;

create table ${iol_schema}.icms_ap_guaranty_righttransfer_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_guaranty_righttransfer where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_guaranty_righttransfer_cl(
            recordno -- 记录编号
            ,rightname -- 过户后权证名称
            ,updateorgid -- 更新机构
            ,custodian -- 权证保管机构
            ,updateuserid -- 更新人
            ,guarantyid -- 抵债资产编号
            ,transferflag -- 是否办理权属转移过户）手续
            ,rightid -- 过户后权证编号
            ,inputorgid -- 登记机构
            ,ownername -- 过户后所有权人名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,rightdate -- 取得权证日期
            ,objectno -- 对象编号
            ,condition1 -- 办理权属转移过户）手续的情况
            ,transorgid -- 过户登记机构
            ,transdate -- 过户登记日期
            ,objecttype -- 对象类型
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标识
            ,tempsaveflag -- 暂存标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_guaranty_righttransfer_op(
            recordno -- 记录编号
            ,rightname -- 过户后权证名称
            ,updateorgid -- 更新机构
            ,custodian -- 权证保管机构
            ,updateuserid -- 更新人
            ,guarantyid -- 抵债资产编号
            ,transferflag -- 是否办理权属转移过户）手续
            ,rightid -- 过户后权证编号
            ,inputorgid -- 登记机构
            ,ownername -- 过户后所有权人名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,rightdate -- 取得权证日期
            ,objectno -- 对象编号
            ,condition1 -- 办理权属转移过户）手续的情况
            ,transorgid -- 过户登记机构
            ,transdate -- 过户登记日期
            ,objecttype -- 对象类型
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标识
            ,tempsaveflag -- 暂存标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.recordno, o.recordno) as recordno -- 记录编号
    ,nvl(n.rightname, o.rightname) as rightname -- 过户后权证名称
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.custodian, o.custodian) as custodian -- 权证保管机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.guarantyid, o.guarantyid) as guarantyid -- 抵债资产编号
    ,nvl(n.transferflag, o.transferflag) as transferflag -- 是否办理权属转移过户）手续
    ,nvl(n.rightid, o.rightid) as rightid -- 过户后权证编号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.ownername, o.ownername) as ownername -- 过户后所有权人名称
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.rightdate, o.rightdate) as rightdate -- 取得权证日期
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.condition1, o.condition1) as condition1 -- 办理权属转移过户）手续的情况
    ,nvl(n.transorgid, o.transorgid) as transorgid -- 过户登记机构
    ,nvl(n.transdate, o.transdate) as transdate -- 过户登记日期
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标识
    ,nvl(n.tempsaveflag, o.tempsaveflag) as tempsaveflag -- 暂存标记
    ,case when
            n.recordno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.recordno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.recordno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_guaranty_righttransfer_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_guaranty_righttransfer where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.recordno = n.recordno
where (
        o.recordno is null
    )
    or (
        n.recordno is null
    )
    or (
        o.rightname <> n.rightname
        or o.updateorgid <> n.updateorgid
        or o.custodian <> n.custodian
        or o.updateuserid <> n.updateuserid
        or o.guarantyid <> n.guarantyid
        or o.transferflag <> n.transferflag
        or o.rightid <> n.rightid
        or o.inputorgid <> n.inputorgid
        or o.ownername <> n.ownername
        or o.remark <> n.remark
        or o.updatedate <> n.updatedate
        or o.rightdate <> n.rightdate
        or o.objectno <> n.objectno
        or o.condition1 <> n.condition1
        or o.transorgid <> n.transorgid
        or o.transdate <> n.transdate
        or o.objecttype <> n.objecttype
        or o.inputuserid <> n.inputuserid
        or o.inputdate <> n.inputdate
        or o.deleteflag <> n.deleteflag
        or o.tempsaveflag <> n.tempsaveflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_guaranty_righttransfer_cl(
            recordno -- 记录编号
            ,rightname -- 过户后权证名称
            ,updateorgid -- 更新机构
            ,custodian -- 权证保管机构
            ,updateuserid -- 更新人
            ,guarantyid -- 抵债资产编号
            ,transferflag -- 是否办理权属转移过户）手续
            ,rightid -- 过户后权证编号
            ,inputorgid -- 登记机构
            ,ownername -- 过户后所有权人名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,rightdate -- 取得权证日期
            ,objectno -- 对象编号
            ,condition1 -- 办理权属转移过户）手续的情况
            ,transorgid -- 过户登记机构
            ,transdate -- 过户登记日期
            ,objecttype -- 对象类型
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标识
            ,tempsaveflag -- 暂存标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_guaranty_righttransfer_op(
            recordno -- 记录编号
            ,rightname -- 过户后权证名称
            ,updateorgid -- 更新机构
            ,custodian -- 权证保管机构
            ,updateuserid -- 更新人
            ,guarantyid -- 抵债资产编号
            ,transferflag -- 是否办理权属转移过户）手续
            ,rightid -- 过户后权证编号
            ,inputorgid -- 登记机构
            ,ownername -- 过户后所有权人名称
            ,remark -- 备注
            ,updatedate -- 更新日期
            ,rightdate -- 取得权证日期
            ,objectno -- 对象编号
            ,condition1 -- 办理权属转移过户）手续的情况
            ,transorgid -- 过户登记机构
            ,transdate -- 过户登记日期
            ,objecttype -- 对象类型
            ,inputuserid -- 登记人
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标识
            ,tempsaveflag -- 暂存标记
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.recordno -- 记录编号
    ,o.rightname -- 过户后权证名称
    ,o.updateorgid -- 更新机构
    ,o.custodian -- 权证保管机构
    ,o.updateuserid -- 更新人
    ,o.guarantyid -- 抵债资产编号
    ,o.transferflag -- 是否办理权属转移过户）手续
    ,o.rightid -- 过户后权证编号
    ,o.inputorgid -- 登记机构
    ,o.ownername -- 过户后所有权人名称
    ,o.remark -- 备注
    ,o.updatedate -- 更新日期
    ,o.rightdate -- 取得权证日期
    ,o.objectno -- 对象编号
    ,o.condition1 -- 办理权属转移过户）手续的情况
    ,o.transorgid -- 过户登记机构
    ,o.transdate -- 过户登记日期
    ,o.objecttype -- 对象类型
    ,o.inputuserid -- 登记人
    ,o.inputdate -- 登记日期
    ,o.deleteflag -- 删除标识
    ,o.tempsaveflag -- 暂存标记
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
from ${iol_schema}.icms_ap_guaranty_righttransfer_bk o
    left join ${iol_schema}.icms_ap_guaranty_righttransfer_op n
        on
            o.recordno = n.recordno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_guaranty_righttransfer_cl d
        on
            o.recordno = d.recordno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_guaranty_righttransfer;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_guaranty_righttransfer') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_guaranty_righttransfer drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_guaranty_righttransfer add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_guaranty_righttransfer exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_guaranty_righttransfer_cl;
alter table ${iol_schema}.icms_ap_guaranty_righttransfer exchange partition p_20991231 with table ${iol_schema}.icms_ap_guaranty_righttransfer_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_guaranty_righttransfer to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_guaranty_righttransfer_op purge;
drop table ${iol_schema}.icms_ap_guaranty_righttransfer_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_guaranty_righttransfer_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_guaranty_righttransfer',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
