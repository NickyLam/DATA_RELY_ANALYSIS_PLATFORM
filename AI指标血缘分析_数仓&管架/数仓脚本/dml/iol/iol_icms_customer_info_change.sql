/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_customer_info_change
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
create table ${iol_schema}.icms_customer_info_change_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_customer_info_change
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_info_change_op purge;
drop table ${iol_schema}.icms_customer_info_change_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_info_change_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_info_change where 0=1;

create table ${iol_schema}.icms_customer_info_change_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_customer_info_change where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_info_change_cl(
            serialno -- 流水号
            ,oldcerttype -- 原证件类型
            ,oldcustomername -- 原客户名称
            ,approveuserid -- 终批人编号
            ,oldfictitiouspersoncertid -- 原法定代表证件号码
            ,corporgid -- 法人机构编号
            ,oldfictitiousperson -- 原法定代表名称
            ,applyorgid -- 申请人机构编号
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,remark -- 备注
            ,oldcertmaturity -- 原证件到期日
            ,newcertid -- 新证件号码
            ,approvestatus -- 审批状态
            ,oldsubjectbusiness -- 原主营业务
            ,newregisteradd -- 新注册地址
            ,oldcertid -- 原证件号码
            ,applyreason -- 申请原因
            ,approvedate -- 终批时间
            ,newsubjectbusiness -- 新主营业务
            ,oldregisteradd -- 原注册地址
            ,newcerttype -- 新证件类型
            ,newloancardno -- 新贷款卡编号
            ,updatedate -- 更新日期
            ,oldfictitiouspersoncerttype -- 原法定代表证件类型
            ,oldloancardno -- 原贷款卡编号
            ,newfictitiouspersoncertid -- 新法定代表证件号码
            ,newcustomername -- 新客户名称
            ,applyuserid -- 申请人编号
            ,newfictitiouspersoncerttype -- 新法定代表证件类型
            ,inputuserid -- 登记人
            ,applydate -- 发起申请时间
            ,newcustomertype -- 新客户类型
            ,approveorgid -- 终批人机构编号
            ,newfictitiousperson -- 新法定代表名称
            ,customerid -- 客户编号
            ,customertype -- 客户类型
            ,newcertmaturity -- 新证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_info_change_op(
            serialno -- 流水号
            ,oldcerttype -- 原证件类型
            ,oldcustomername -- 原客户名称
            ,approveuserid -- 终批人编号
            ,oldfictitiouspersoncertid -- 原法定代表证件号码
            ,corporgid -- 法人机构编号
            ,oldfictitiousperson -- 原法定代表名称
            ,applyorgid -- 申请人机构编号
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,remark -- 备注
            ,oldcertmaturity -- 原证件到期日
            ,newcertid -- 新证件号码
            ,approvestatus -- 审批状态
            ,oldsubjectbusiness -- 原主营业务
            ,newregisteradd -- 新注册地址
            ,oldcertid -- 原证件号码
            ,applyreason -- 申请原因
            ,approvedate -- 终批时间
            ,newsubjectbusiness -- 新主营业务
            ,oldregisteradd -- 原注册地址
            ,newcerttype -- 新证件类型
            ,newloancardno -- 新贷款卡编号
            ,updatedate -- 更新日期
            ,oldfictitiouspersoncerttype -- 原法定代表证件类型
            ,oldloancardno -- 原贷款卡编号
            ,newfictitiouspersoncertid -- 新法定代表证件号码
            ,newcustomername -- 新客户名称
            ,applyuserid -- 申请人编号
            ,newfictitiouspersoncerttype -- 新法定代表证件类型
            ,inputuserid -- 登记人
            ,applydate -- 发起申请时间
            ,newcustomertype -- 新客户类型
            ,approveorgid -- 终批人机构编号
            ,newfictitiousperson -- 新法定代表名称
            ,customerid -- 客户编号
            ,customertype -- 客户类型
            ,newcertmaturity -- 新证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.oldcerttype, o.oldcerttype) as oldcerttype -- 原证件类型
    ,nvl(n.oldcustomername, o.oldcustomername) as oldcustomername -- 原客户名称
    ,nvl(n.approveuserid, o.approveuserid) as approveuserid -- 终批人编号
    ,nvl(n.oldfictitiouspersoncertid, o.oldfictitiouspersoncertid) as oldfictitiouspersoncertid -- 原法定代表证件号码
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.oldfictitiousperson, o.oldfictitiousperson) as oldfictitiousperson -- 原法定代表名称
    ,nvl(n.applyorgid, o.applyorgid) as applyorgid -- 申请人机构编号
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.oldcertmaturity, o.oldcertmaturity) as oldcertmaturity -- 原证件到期日
    ,nvl(n.newcertid, o.newcertid) as newcertid -- 新证件号码
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.oldsubjectbusiness, o.oldsubjectbusiness) as oldsubjectbusiness -- 原主营业务
    ,nvl(n.newregisteradd, o.newregisteradd) as newregisteradd -- 新注册地址
    ,nvl(n.oldcertid, o.oldcertid) as oldcertid -- 原证件号码
    ,nvl(n.applyreason, o.applyreason) as applyreason -- 申请原因
    ,nvl(n.approvedate, o.approvedate) as approvedate -- 终批时间
    ,nvl(n.newsubjectbusiness, o.newsubjectbusiness) as newsubjectbusiness -- 新主营业务
    ,nvl(n.oldregisteradd, o.oldregisteradd) as oldregisteradd -- 原注册地址
    ,nvl(n.newcerttype, o.newcerttype) as newcerttype -- 新证件类型
    ,nvl(n.newloancardno, o.newloancardno) as newloancardno -- 新贷款卡编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.oldfictitiouspersoncerttype, o.oldfictitiouspersoncerttype) as oldfictitiouspersoncerttype -- 原法定代表证件类型
    ,nvl(n.oldloancardno, o.oldloancardno) as oldloancardno -- 原贷款卡编号
    ,nvl(n.newfictitiouspersoncertid, o.newfictitiouspersoncertid) as newfictitiouspersoncertid -- 新法定代表证件号码
    ,nvl(n.newcustomername, o.newcustomername) as newcustomername -- 新客户名称
    ,nvl(n.applyuserid, o.applyuserid) as applyuserid -- 申请人编号
    ,nvl(n.newfictitiouspersoncerttype, o.newfictitiouspersoncerttype) as newfictitiouspersoncerttype -- 新法定代表证件类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.applydate, o.applydate) as applydate -- 发起申请时间
    ,nvl(n.newcustomertype, o.newcustomertype) as newcustomertype -- 新客户类型
    ,nvl(n.approveorgid, o.approveorgid) as approveorgid -- 终批人机构编号
    ,nvl(n.newfictitiousperson, o.newfictitiousperson) as newfictitiousperson -- 新法定代表名称
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customertype, o.customertype) as customertype -- 客户类型
    ,nvl(n.newcertmaturity, o.newcertmaturity) as newcertmaturity -- 新证件到期日
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
from (select * from ${iol_schema}.icms_customer_info_change_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_customer_info_change where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.oldcerttype <> n.oldcerttype
        or o.oldcustomername <> n.oldcustomername
        or o.approveuserid <> n.approveuserid
        or o.oldfictitiouspersoncertid <> n.oldfictitiouspersoncertid
        or o.corporgid <> n.corporgid
        or o.oldfictitiousperson <> n.oldfictitiousperson
        or o.applyorgid <> n.applyorgid
        or o.inputdate <> n.inputdate
        or o.updateorgid <> n.updateorgid
        or o.inputorgid <> n.inputorgid
        or o.updateuserid <> n.updateuserid
        or o.remark <> n.remark
        or o.oldcertmaturity <> n.oldcertmaturity
        or o.newcertid <> n.newcertid
        or o.approvestatus <> n.approvestatus
        or o.oldsubjectbusiness <> n.oldsubjectbusiness
        or o.newregisteradd <> n.newregisteradd
        or o.oldcertid <> n.oldcertid
        or o.applyreason <> n.applyreason
        or o.approvedate <> n.approvedate
        or o.newsubjectbusiness <> n.newsubjectbusiness
        or o.oldregisteradd <> n.oldregisteradd
        or o.newcerttype <> n.newcerttype
        or o.newloancardno <> n.newloancardno
        or o.updatedate <> n.updatedate
        or o.oldfictitiouspersoncerttype <> n.oldfictitiouspersoncerttype
        or o.oldloancardno <> n.oldloancardno
        or o.newfictitiouspersoncertid <> n.newfictitiouspersoncertid
        or o.newcustomername <> n.newcustomername
        or o.applyuserid <> n.applyuserid
        or o.newfictitiouspersoncerttype <> n.newfictitiouspersoncerttype
        or o.inputuserid <> n.inputuserid
        or o.applydate <> n.applydate
        or o.newcustomertype <> n.newcustomertype
        or o.approveorgid <> n.approveorgid
        or o.newfictitiousperson <> n.newfictitiousperson
        or o.customerid <> n.customerid
        or o.customertype <> n.customertype
        or o.newcertmaturity <> n.newcertmaturity
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_customer_info_change_cl(
            serialno -- 流水号
            ,oldcerttype -- 原证件类型
            ,oldcustomername -- 原客户名称
            ,approveuserid -- 终批人编号
            ,oldfictitiouspersoncertid -- 原法定代表证件号码
            ,corporgid -- 法人机构编号
            ,oldfictitiousperson -- 原法定代表名称
            ,applyorgid -- 申请人机构编号
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,remark -- 备注
            ,oldcertmaturity -- 原证件到期日
            ,newcertid -- 新证件号码
            ,approvestatus -- 审批状态
            ,oldsubjectbusiness -- 原主营业务
            ,newregisteradd -- 新注册地址
            ,oldcertid -- 原证件号码
            ,applyreason -- 申请原因
            ,approvedate -- 终批时间
            ,newsubjectbusiness -- 新主营业务
            ,oldregisteradd -- 原注册地址
            ,newcerttype -- 新证件类型
            ,newloancardno -- 新贷款卡编号
            ,updatedate -- 更新日期
            ,oldfictitiouspersoncerttype -- 原法定代表证件类型
            ,oldloancardno -- 原贷款卡编号
            ,newfictitiouspersoncertid -- 新法定代表证件号码
            ,newcustomername -- 新客户名称
            ,applyuserid -- 申请人编号
            ,newfictitiouspersoncerttype -- 新法定代表证件类型
            ,inputuserid -- 登记人
            ,applydate -- 发起申请时间
            ,newcustomertype -- 新客户类型
            ,approveorgid -- 终批人机构编号
            ,newfictitiousperson -- 新法定代表名称
            ,customerid -- 客户编号
            ,customertype -- 客户类型
            ,newcertmaturity -- 新证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_customer_info_change_op(
            serialno -- 流水号
            ,oldcerttype -- 原证件类型
            ,oldcustomername -- 原客户名称
            ,approveuserid -- 终批人编号
            ,oldfictitiouspersoncertid -- 原法定代表证件号码
            ,corporgid -- 法人机构编号
            ,oldfictitiousperson -- 原法定代表名称
            ,applyorgid -- 申请人机构编号
            ,inputdate -- 登记日期
            ,updateorgid -- 更新机构
            ,inputorgid -- 登记机构
            ,updateuserid -- 更新人
            ,remark -- 备注
            ,oldcertmaturity -- 原证件到期日
            ,newcertid -- 新证件号码
            ,approvestatus -- 审批状态
            ,oldsubjectbusiness -- 原主营业务
            ,newregisteradd -- 新注册地址
            ,oldcertid -- 原证件号码
            ,applyreason -- 申请原因
            ,approvedate -- 终批时间
            ,newsubjectbusiness -- 新主营业务
            ,oldregisteradd -- 原注册地址
            ,newcerttype -- 新证件类型
            ,newloancardno -- 新贷款卡编号
            ,updatedate -- 更新日期
            ,oldfictitiouspersoncerttype -- 原法定代表证件类型
            ,oldloancardno -- 原贷款卡编号
            ,newfictitiouspersoncertid -- 新法定代表证件号码
            ,newcustomername -- 新客户名称
            ,applyuserid -- 申请人编号
            ,newfictitiouspersoncerttype -- 新法定代表证件类型
            ,inputuserid -- 登记人
            ,applydate -- 发起申请时间
            ,newcustomertype -- 新客户类型
            ,approveorgid -- 终批人机构编号
            ,newfictitiousperson -- 新法定代表名称
            ,customerid -- 客户编号
            ,customertype -- 客户类型
            ,newcertmaturity -- 新证件到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.oldcerttype -- 原证件类型
    ,o.oldcustomername -- 原客户名称
    ,o.approveuserid -- 终批人编号
    ,o.oldfictitiouspersoncertid -- 原法定代表证件号码
    ,o.corporgid -- 法人机构编号
    ,o.oldfictitiousperson -- 原法定代表名称
    ,o.applyorgid -- 申请人机构编号
    ,o.inputdate -- 登记日期
    ,o.updateorgid -- 更新机构
    ,o.inputorgid -- 登记机构
    ,o.updateuserid -- 更新人
    ,o.remark -- 备注
    ,o.oldcertmaturity -- 原证件到期日
    ,o.newcertid -- 新证件号码
    ,o.approvestatus -- 审批状态
    ,o.oldsubjectbusiness -- 原主营业务
    ,o.newregisteradd -- 新注册地址
    ,o.oldcertid -- 原证件号码
    ,o.applyreason -- 申请原因
    ,o.approvedate -- 终批时间
    ,o.newsubjectbusiness -- 新主营业务
    ,o.oldregisteradd -- 原注册地址
    ,o.newcerttype -- 新证件类型
    ,o.newloancardno -- 新贷款卡编号
    ,o.updatedate -- 更新日期
    ,o.oldfictitiouspersoncerttype -- 原法定代表证件类型
    ,o.oldloancardno -- 原贷款卡编号
    ,o.newfictitiouspersoncertid -- 新法定代表证件号码
    ,o.newcustomername -- 新客户名称
    ,o.applyuserid -- 申请人编号
    ,o.newfictitiouspersoncerttype -- 新法定代表证件类型
    ,o.inputuserid -- 登记人
    ,o.applydate -- 发起申请时间
    ,o.newcustomertype -- 新客户类型
    ,o.approveorgid -- 终批人机构编号
    ,o.newfictitiousperson -- 新法定代表名称
    ,o.customerid -- 客户编号
    ,o.customertype -- 客户类型
    ,o.newcertmaturity -- 新证件到期日
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
from ${iol_schema}.icms_customer_info_change_bk o
    left join ${iol_schema}.icms_customer_info_change_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_customer_info_change_cl d
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
--truncate table ${iol_schema}.icms_customer_info_change;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_customer_info_change') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_customer_info_change drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_customer_info_change add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_customer_info_change exchange partition p_${batch_date} with table ${iol_schema}.icms_customer_info_change_cl;
alter table ${iol_schema}.icms_customer_info_change exchange partition p_20991231 with table ${iol_schema}.icms_customer_info_change_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_customer_info_change to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_customer_info_change_op purge;
drop table ${iol_schema}.icms_customer_info_change_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_customer_info_change_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_customer_info_change',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
