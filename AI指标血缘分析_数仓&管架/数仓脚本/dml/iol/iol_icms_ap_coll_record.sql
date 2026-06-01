/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_coll_record
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
create table ${iol_schema}.icms_ap_coll_record_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_coll_record
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_coll_record_op purge;
drop table ${iol_schema}.icms_ap_coll_record_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_coll_record_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_coll_record where 0=1;

create table ${iol_schema}.icms_ap_coll_record_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_coll_record where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_coll_record_cl(
            recordno -- 催收记录编号
            ,guaranteetel -- 担保人联系方式
            ,customername -- 催收客户名称
            ,deliveryway -- 送达方式
            ,projectno -- 项目编号
            ,customertel -- 催收客户联系方式
            ,guaranteeid -- 担保人编号
            ,letterdate -- 发函日期
            ,customerid -- 催收客户ID
            ,debitsum -- 截止本日所欠本息金额总额
            ,latestpayment -- 要求最迟还款日
            ,inputorgid -- 登记机构
            ,guaranteename -- 担保人名称
            ,updatedate -- 更新日期
            ,guaranteeaddress -- 担保人地址
            ,tmsp -- 时间戳
            ,recordtype -- 记录类型
            ,guaranteesum -- 担保金额
            ,receipttype -- 回执/公证类型
            ,customeraddress -- 催收客户地址
            ,deleteflag -- 删除标志
            ,fileno -- 影像平台编号
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,receiptdate -- 回执日期/公证送达日期
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,contractbalancesum -- 合同余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_coll_record_op(
            recordno -- 催收记录编号
            ,guaranteetel -- 担保人联系方式
            ,customername -- 催收客户名称
            ,deliveryway -- 送达方式
            ,projectno -- 项目编号
            ,customertel -- 催收客户联系方式
            ,guaranteeid -- 担保人编号
            ,letterdate -- 发函日期
            ,customerid -- 催收客户ID
            ,debitsum -- 截止本日所欠本息金额总额
            ,latestpayment -- 要求最迟还款日
            ,inputorgid -- 登记机构
            ,guaranteename -- 担保人名称
            ,updatedate -- 更新日期
            ,guaranteeaddress -- 担保人地址
            ,tmsp -- 时间戳
            ,recordtype -- 记录类型
            ,guaranteesum -- 担保金额
            ,receipttype -- 回执/公证类型
            ,customeraddress -- 催收客户地址
            ,deleteflag -- 删除标志
            ,fileno -- 影像平台编号
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,receiptdate -- 回执日期/公证送达日期
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,contractbalancesum -- 合同余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.recordno, o.recordno) as recordno -- 催收记录编号
    ,nvl(n.guaranteetel, o.guaranteetel) as guaranteetel -- 担保人联系方式
    ,nvl(n.customername, o.customername) as customername -- 催收客户名称
    ,nvl(n.deliveryway, o.deliveryway) as deliveryway -- 送达方式
    ,nvl(n.projectno, o.projectno) as projectno -- 项目编号
    ,nvl(n.customertel, o.customertel) as customertel -- 催收客户联系方式
    ,nvl(n.guaranteeid, o.guaranteeid) as guaranteeid -- 担保人编号
    ,nvl(n.letterdate, o.letterdate) as letterdate -- 发函日期
    ,nvl(n.customerid, o.customerid) as customerid -- 催收客户ID
    ,nvl(n.debitsum, o.debitsum) as debitsum -- 截止本日所欠本息金额总额
    ,nvl(n.latestpayment, o.latestpayment) as latestpayment -- 要求最迟还款日
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.guaranteename, o.guaranteename) as guaranteename -- 担保人名称
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.guaranteeaddress, o.guaranteeaddress) as guaranteeaddress -- 担保人地址
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.recordtype, o.recordtype) as recordtype -- 记录类型
    ,nvl(n.guaranteesum, o.guaranteesum) as guaranteesum -- 担保金额
    ,nvl(n.receipttype, o.receipttype) as receipttype -- 回执/公证类型
    ,nvl(n.customeraddress, o.customeraddress) as customeraddress -- 催收客户地址
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,nvl(n.fileno, o.fileno) as fileno -- 影像平台编号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.receiptdate, o.receiptdate) as receiptdate -- 回执日期/公证送达日期
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.contractbalancesum, o.contractbalancesum) as contractbalancesum -- 合同余额
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
from (select * from ${iol_schema}.icms_ap_coll_record_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_coll_record where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.recordno = n.recordno
where (
        o.recordno is null
    )
    or (
        n.recordno is null
    )
    or (
        o.guaranteetel <> n.guaranteetel
        or o.customername <> n.customername
        or o.deliveryway <> n.deliveryway
        or o.projectno <> n.projectno
        or o.customertel <> n.customertel
        or o.guaranteeid <> n.guaranteeid
        or o.letterdate <> n.letterdate
        or o.customerid <> n.customerid
        or o.debitsum <> n.debitsum
        or o.latestpayment <> n.latestpayment
        or o.inputorgid <> n.inputorgid
        or o.guaranteename <> n.guaranteename
        or o.updatedate <> n.updatedate
        or o.guaranteeaddress <> n.guaranteeaddress
        or o.tmsp <> n.tmsp
        or o.recordtype <> n.recordtype
        or o.guaranteesum <> n.guaranteesum
        or o.receipttype <> n.receipttype
        or o.customeraddress <> n.customeraddress
        or o.deleteflag <> n.deleteflag
        or o.fileno <> n.fileno
        or o.inputuserid <> n.inputuserid
        or o.updateorgid <> n.updateorgid
        or o.receiptdate <> n.receiptdate
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.contractbalancesum <> n.contractbalancesum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_coll_record_cl(
            recordno -- 催收记录编号
            ,guaranteetel -- 担保人联系方式
            ,customername -- 催收客户名称
            ,deliveryway -- 送达方式
            ,projectno -- 项目编号
            ,customertel -- 催收客户联系方式
            ,guaranteeid -- 担保人编号
            ,letterdate -- 发函日期
            ,customerid -- 催收客户ID
            ,debitsum -- 截止本日所欠本息金额总额
            ,latestpayment -- 要求最迟还款日
            ,inputorgid -- 登记机构
            ,guaranteename -- 担保人名称
            ,updatedate -- 更新日期
            ,guaranteeaddress -- 担保人地址
            ,tmsp -- 时间戳
            ,recordtype -- 记录类型
            ,guaranteesum -- 担保金额
            ,receipttype -- 回执/公证类型
            ,customeraddress -- 催收客户地址
            ,deleteflag -- 删除标志
            ,fileno -- 影像平台编号
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,receiptdate -- 回执日期/公证送达日期
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,contractbalancesum -- 合同余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_coll_record_op(
            recordno -- 催收记录编号
            ,guaranteetel -- 担保人联系方式
            ,customername -- 催收客户名称
            ,deliveryway -- 送达方式
            ,projectno -- 项目编号
            ,customertel -- 催收客户联系方式
            ,guaranteeid -- 担保人编号
            ,letterdate -- 发函日期
            ,customerid -- 催收客户ID
            ,debitsum -- 截止本日所欠本息金额总额
            ,latestpayment -- 要求最迟还款日
            ,inputorgid -- 登记机构
            ,guaranteename -- 担保人名称
            ,updatedate -- 更新日期
            ,guaranteeaddress -- 担保人地址
            ,tmsp -- 时间戳
            ,recordtype -- 记录类型
            ,guaranteesum -- 担保金额
            ,receipttype -- 回执/公证类型
            ,customeraddress -- 催收客户地址
            ,deleteflag -- 删除标志
            ,fileno -- 影像平台编号
            ,inputuserid -- 登记人
            ,updateorgid -- 更新机构
            ,receiptdate -- 回执日期/公证送达日期
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,contractbalancesum -- 合同余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.recordno -- 催收记录编号
    ,o.guaranteetel -- 担保人联系方式
    ,o.customername -- 催收客户名称
    ,o.deliveryway -- 送达方式
    ,o.projectno -- 项目编号
    ,o.customertel -- 催收客户联系方式
    ,o.guaranteeid -- 担保人编号
    ,o.letterdate -- 发函日期
    ,o.customerid -- 催收客户ID
    ,o.debitsum -- 截止本日所欠本息金额总额
    ,o.latestpayment -- 要求最迟还款日
    ,o.inputorgid -- 登记机构
    ,o.guaranteename -- 担保人名称
    ,o.updatedate -- 更新日期
    ,o.guaranteeaddress -- 担保人地址
    ,o.tmsp -- 时间戳
    ,o.recordtype -- 记录类型
    ,o.guaranteesum -- 担保金额
    ,o.receipttype -- 回执/公证类型
    ,o.customeraddress -- 催收客户地址
    ,o.deleteflag -- 删除标志
    ,o.fileno -- 影像平台编号
    ,o.inputuserid -- 登记人
    ,o.updateorgid -- 更新机构
    ,o.receiptdate -- 回执日期/公证送达日期
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.contractbalancesum -- 合同余额
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
from ${iol_schema}.icms_ap_coll_record_bk o
    left join ${iol_schema}.icms_ap_coll_record_op n
        on
            o.recordno = n.recordno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_coll_record_cl d
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
--truncate table ${iol_schema}.icms_ap_coll_record;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_coll_record') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_coll_record drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_coll_record add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_coll_record exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_coll_record_cl;
alter table ${iol_schema}.icms_ap_coll_record exchange partition p_20991231 with table ${iol_schema}.icms_ap_coll_record_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_coll_record to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_coll_record_op purge;
drop table ${iol_schema}.icms_ap_coll_record_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_coll_record_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_coll_record',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
