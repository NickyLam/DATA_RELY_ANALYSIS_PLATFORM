/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_telcoll_record
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
create table ${iol_schema}.icms_ap_telcoll_record_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_telcoll_record
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_telcoll_record_op purge;
drop table ${iol_schema}.icms_ap_telcoll_record_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_telcoll_record_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_telcoll_record where 0=1;

create table ${iol_schema}.icms_ap_telcoll_record_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_telcoll_record where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_telcoll_record_cl(
            recordno -- 催收记录编号
            ,deliveryway -- 送达方式
            ,customername -- 催收客户名称
            ,collectusername -- 催收人员
            ,attachment -- 催收采集的相关照片、文件附件
            ,guarantyno -- 担保合同编号
            ,updatedate -- 更新日期
            ,contactway -- 联系方式
            ,inputorgid -- 登记机构
            ,customertype -- 催收客户类型
            ,impawncondition -- 抵质押情况
            ,nextworkplan -- 下一步工作计划
            ,collectway -- 催收方式
            ,receiptdate -- 回执日期/公证送达日期
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标志
            ,guaranteeway -- 担保方式
            ,bankcontact -- 银行方联系人
            ,updateorgid -- 更新机构
            ,securitycondition -- 保全情况
            ,customerid -- 催收客户ID
            ,collectdate -- 催收日期
            ,collectuserid -- 催收人员编号
            ,collectprocess -- 催收过程
            ,updateuserid -- 更新人
            ,assetno -- 资产编号
            ,contractname -- 合同名称
            ,receipttype -- 回执/公证类型
            ,inputuserid -- 登记人
            ,colleccontact -- 催收人员联系方式
            ,collectresult -- 催收结果
            ,latestpayment -- 要求最迟还款日
            ,collectsite -- 催收地点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_telcoll_record_op(
            recordno -- 催收记录编号
            ,deliveryway -- 送达方式
            ,customername -- 催收客户名称
            ,collectusername -- 催收人员
            ,attachment -- 催收采集的相关照片、文件附件
            ,guarantyno -- 担保合同编号
            ,updatedate -- 更新日期
            ,contactway -- 联系方式
            ,inputorgid -- 登记机构
            ,customertype -- 催收客户类型
            ,impawncondition -- 抵质押情况
            ,nextworkplan -- 下一步工作计划
            ,collectway -- 催收方式
            ,receiptdate -- 回执日期/公证送达日期
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标志
            ,guaranteeway -- 担保方式
            ,bankcontact -- 银行方联系人
            ,updateorgid -- 更新机构
            ,securitycondition -- 保全情况
            ,customerid -- 催收客户ID
            ,collectdate -- 催收日期
            ,collectuserid -- 催收人员编号
            ,collectprocess -- 催收过程
            ,updateuserid -- 更新人
            ,assetno -- 资产编号
            ,contractname -- 合同名称
            ,receipttype -- 回执/公证类型
            ,inputuserid -- 登记人
            ,colleccontact -- 催收人员联系方式
            ,collectresult -- 催收结果
            ,latestpayment -- 要求最迟还款日
            ,collectsite -- 催收地点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.recordno, o.recordno) as recordno -- 催收记录编号
    ,nvl(n.deliveryway, o.deliveryway) as deliveryway -- 送达方式
    ,nvl(n.customername, o.customername) as customername -- 催收客户名称
    ,nvl(n.collectusername, o.collectusername) as collectusername -- 催收人员
    ,nvl(n.attachment, o.attachment) as attachment -- 催收采集的相关照片、文件附件
    ,nvl(n.guarantyno, o.guarantyno) as guarantyno -- 担保合同编号
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.contactway, o.contactway) as contactway -- 联系方式
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.customertype, o.customertype) as customertype -- 催收客户类型
    ,nvl(n.impawncondition, o.impawncondition) as impawncondition -- 抵质押情况
    ,nvl(n.nextworkplan, o.nextworkplan) as nextworkplan -- 下一步工作计划
    ,nvl(n.collectway, o.collectway) as collectway -- 催收方式
    ,nvl(n.receiptdate, o.receiptdate) as receiptdate -- 回执日期/公证送达日期
    ,nvl(n.tmsp, o.tmsp) as tmsp -- 时间戳
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.deleteflag, o.deleteflag) as deleteflag -- 删除标志
    ,nvl(n.guaranteeway, o.guaranteeway) as guaranteeway -- 担保方式
    ,nvl(n.bankcontact, o.bankcontact) as bankcontact -- 银行方联系人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.securitycondition, o.securitycondition) as securitycondition -- 保全情况
    ,nvl(n.customerid, o.customerid) as customerid -- 催收客户ID
    ,nvl(n.collectdate, o.collectdate) as collectdate -- 催收日期
    ,nvl(n.collectuserid, o.collectuserid) as collectuserid -- 催收人员编号
    ,nvl(n.collectprocess, o.collectprocess) as collectprocess -- 催收过程
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.assetno, o.assetno) as assetno -- 资产编号
    ,nvl(n.contractname, o.contractname) as contractname -- 合同名称
    ,nvl(n.receipttype, o.receipttype) as receipttype -- 回执/公证类型
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.colleccontact, o.colleccontact) as colleccontact -- 催收人员联系方式
    ,nvl(n.collectresult, o.collectresult) as collectresult -- 催收结果
    ,nvl(n.latestpayment, o.latestpayment) as latestpayment -- 要求最迟还款日
    ,nvl(n.collectsite, o.collectsite) as collectsite -- 催收地点
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
from (select * from ${iol_schema}.icms_ap_telcoll_record_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_telcoll_record where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.recordno = n.recordno
where (
        o.recordno is null
    )
    or (
        n.recordno is null
    )
    or (
        o.deliveryway <> n.deliveryway
        or o.customername <> n.customername
        or o.collectusername <> n.collectusername
        or o.attachment <> n.attachment
        or o.guarantyno <> n.guarantyno
        or o.updatedate <> n.updatedate
        or o.contactway <> n.contactway
        or o.inputorgid <> n.inputorgid
        or o.customertype <> n.customertype
        or o.impawncondition <> n.impawncondition
        or o.nextworkplan <> n.nextworkplan
        or o.collectway <> n.collectway
        or o.receiptdate <> n.receiptdate
        or o.tmsp <> n.tmsp
        or o.inputdate <> n.inputdate
        or o.deleteflag <> n.deleteflag
        or o.guaranteeway <> n.guaranteeway
        or o.bankcontact <> n.bankcontact
        or o.updateorgid <> n.updateorgid
        or o.securitycondition <> n.securitycondition
        or o.customerid <> n.customerid
        or o.collectdate <> n.collectdate
        or o.collectuserid <> n.collectuserid
        or o.collectprocess <> n.collectprocess
        or o.updateuserid <> n.updateuserid
        or o.assetno <> n.assetno
        or o.contractname <> n.contractname
        or o.receipttype <> n.receipttype
        or o.inputuserid <> n.inputuserid
        or o.colleccontact <> n.colleccontact
        or o.collectresult <> n.collectresult
        or o.latestpayment <> n.latestpayment
        or o.collectsite <> n.collectsite
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_telcoll_record_cl(
            recordno -- 催收记录编号
            ,deliveryway -- 送达方式
            ,customername -- 催收客户名称
            ,collectusername -- 催收人员
            ,attachment -- 催收采集的相关照片、文件附件
            ,guarantyno -- 担保合同编号
            ,updatedate -- 更新日期
            ,contactway -- 联系方式
            ,inputorgid -- 登记机构
            ,customertype -- 催收客户类型
            ,impawncondition -- 抵质押情况
            ,nextworkplan -- 下一步工作计划
            ,collectway -- 催收方式
            ,receiptdate -- 回执日期/公证送达日期
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标志
            ,guaranteeway -- 担保方式
            ,bankcontact -- 银行方联系人
            ,updateorgid -- 更新机构
            ,securitycondition -- 保全情况
            ,customerid -- 催收客户ID
            ,collectdate -- 催收日期
            ,collectuserid -- 催收人员编号
            ,collectprocess -- 催收过程
            ,updateuserid -- 更新人
            ,assetno -- 资产编号
            ,contractname -- 合同名称
            ,receipttype -- 回执/公证类型
            ,inputuserid -- 登记人
            ,colleccontact -- 催收人员联系方式
            ,collectresult -- 催收结果
            ,latestpayment -- 要求最迟还款日
            ,collectsite -- 催收地点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_telcoll_record_op(
            recordno -- 催收记录编号
            ,deliveryway -- 送达方式
            ,customername -- 催收客户名称
            ,collectusername -- 催收人员
            ,attachment -- 催收采集的相关照片、文件附件
            ,guarantyno -- 担保合同编号
            ,updatedate -- 更新日期
            ,contactway -- 联系方式
            ,inputorgid -- 登记机构
            ,customertype -- 催收客户类型
            ,impawncondition -- 抵质押情况
            ,nextworkplan -- 下一步工作计划
            ,collectway -- 催收方式
            ,receiptdate -- 回执日期/公证送达日期
            ,tmsp -- 时间戳
            ,inputdate -- 登记日期
            ,deleteflag -- 删除标志
            ,guaranteeway -- 担保方式
            ,bankcontact -- 银行方联系人
            ,updateorgid -- 更新机构
            ,securitycondition -- 保全情况
            ,customerid -- 催收客户ID
            ,collectdate -- 催收日期
            ,collectuserid -- 催收人员编号
            ,collectprocess -- 催收过程
            ,updateuserid -- 更新人
            ,assetno -- 资产编号
            ,contractname -- 合同名称
            ,receipttype -- 回执/公证类型
            ,inputuserid -- 登记人
            ,colleccontact -- 催收人员联系方式
            ,collectresult -- 催收结果
            ,latestpayment -- 要求最迟还款日
            ,collectsite -- 催收地点
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.recordno -- 催收记录编号
    ,o.deliveryway -- 送达方式
    ,o.customername -- 催收客户名称
    ,o.collectusername -- 催收人员
    ,o.attachment -- 催收采集的相关照片、文件附件
    ,o.guarantyno -- 担保合同编号
    ,o.updatedate -- 更新日期
    ,o.contactway -- 联系方式
    ,o.inputorgid -- 登记机构
    ,o.customertype -- 催收客户类型
    ,o.impawncondition -- 抵质押情况
    ,o.nextworkplan -- 下一步工作计划
    ,o.collectway -- 催收方式
    ,o.receiptdate -- 回执日期/公证送达日期
    ,o.tmsp -- 时间戳
    ,o.inputdate -- 登记日期
    ,o.deleteflag -- 删除标志
    ,o.guaranteeway -- 担保方式
    ,o.bankcontact -- 银行方联系人
    ,o.updateorgid -- 更新机构
    ,o.securitycondition -- 保全情况
    ,o.customerid -- 催收客户ID
    ,o.collectdate -- 催收日期
    ,o.collectuserid -- 催收人员编号
    ,o.collectprocess -- 催收过程
    ,o.updateuserid -- 更新人
    ,o.assetno -- 资产编号
    ,o.contractname -- 合同名称
    ,o.receipttype -- 回执/公证类型
    ,o.inputuserid -- 登记人
    ,o.colleccontact -- 催收人员联系方式
    ,o.collectresult -- 催收结果
    ,o.latestpayment -- 要求最迟还款日
    ,o.collectsite -- 催收地点
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
from ${iol_schema}.icms_ap_telcoll_record_bk o
    left join ${iol_schema}.icms_ap_telcoll_record_op n
        on
            o.recordno = n.recordno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_telcoll_record_cl d
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
--truncate table ${iol_schema}.icms_ap_telcoll_record;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_telcoll_record') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_telcoll_record drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_telcoll_record add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_telcoll_record exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_telcoll_record_cl;
alter table ${iol_schema}.icms_ap_telcoll_record exchange partition p_20991231 with table ${iol_schema}.icms_ap_telcoll_record_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_telcoll_record to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_telcoll_record_op purge;
drop table ${iol_schema}.icms_ap_telcoll_record_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_telcoll_record_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_telcoll_record',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
