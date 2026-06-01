/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_insurance_record
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
create table ${iol_schema}.icms_clr_insurance_record_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_insurance_record
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_insurance_record_op purge;
drop table ${iol_schema}.icms_clr_insurance_record_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_insurance_record_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_insurance_record where 0=1;

create table ${iol_schema}.icms_clr_insurance_record_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_insurance_record where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_insurance_record_cl(
            insurancerecordid -- 保险记录编号
            ,guarantyplanno -- 担保方案编号
            ,clrid -- 押品编号
            ,insurancestatus -- 保险状态
            ,insurancecompany -- 保险公司
            ,insurancetype -- 保险类型
            ,benificiary -- 保险受益人
            ,insurancepolicyid -- 保单号码
            ,insuranceamount -- 投保金额
            ,insurancefee -- 保险费
            ,insurancefeerate -- 保险费率
            ,paymentmethod -- 缴费方式
            ,startdate -- 保险起始日
            ,enddate -- 保险到期日
            ,expirydate -- 保险失效日
            ,expiryreason -- 保险失效原因
            ,issuedate -- 出单日期
            ,isrenewinsurance -- 续保标志
            ,isneedwarehousing -- 是否需要入库
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,oldclrid -- 合并前押品编号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,insurancecompanycode -- 保险公司编号
            ,underwriters1 -- 核保人名称1
            ,underwriters2 -- 核保人名称2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_insurance_record_op(
            insurancerecordid -- 保险记录编号
            ,guarantyplanno -- 担保方案编号
            ,clrid -- 押品编号
            ,insurancestatus -- 保险状态
            ,insurancecompany -- 保险公司
            ,insurancetype -- 保险类型
            ,benificiary -- 保险受益人
            ,insurancepolicyid -- 保单号码
            ,insuranceamount -- 投保金额
            ,insurancefee -- 保险费
            ,insurancefeerate -- 保险费率
            ,paymentmethod -- 缴费方式
            ,startdate -- 保险起始日
            ,enddate -- 保险到期日
            ,expirydate -- 保险失效日
            ,expiryreason -- 保险失效原因
            ,issuedate -- 出单日期
            ,isrenewinsurance -- 续保标志
            ,isneedwarehousing -- 是否需要入库
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,oldclrid -- 合并前押品编号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,insurancecompanycode -- 保险公司编号
            ,underwriters1 -- 核保人名称1
            ,underwriters2 -- 核保人名称2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.insurancerecordid, o.insurancerecordid) as insurancerecordid -- 保险记录编号
    ,nvl(n.guarantyplanno, o.guarantyplanno) as guarantyplanno -- 担保方案编号
    ,nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.insurancestatus, o.insurancestatus) as insurancestatus -- 保险状态
    ,nvl(n.insurancecompany, o.insurancecompany) as insurancecompany -- 保险公司
    ,nvl(n.insurancetype, o.insurancetype) as insurancetype -- 保险类型
    ,nvl(n.benificiary, o.benificiary) as benificiary -- 保险受益人
    ,nvl(n.insurancepolicyid, o.insurancepolicyid) as insurancepolicyid -- 保单号码
    ,nvl(n.insuranceamount, o.insuranceamount) as insuranceamount -- 投保金额
    ,nvl(n.insurancefee, o.insurancefee) as insurancefee -- 保险费
    ,nvl(n.insurancefeerate, o.insurancefeerate) as insurancefeerate -- 保险费率
    ,nvl(n.paymentmethod, o.paymentmethod) as paymentmethod -- 缴费方式
    ,nvl(n.startdate, o.startdate) as startdate -- 保险起始日
    ,nvl(n.enddate, o.enddate) as enddate -- 保险到期日
    ,nvl(n.expirydate, o.expirydate) as expirydate -- 保险失效日
    ,nvl(n.expiryreason, o.expiryreason) as expiryreason -- 保险失效原因
    ,nvl(n.issuedate, o.issuedate) as issuedate -- 出单日期
    ,nvl(n.isrenewinsurance, o.isrenewinsurance) as isrenewinsurance -- 续保标志
    ,nvl(n.isneedwarehousing, o.isneedwarehousing) as isneedwarehousing -- 是否需要入库
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.oldclrid, o.oldclrid) as oldclrid -- 合并前押品编号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,nvl(n.insurancecompanycode, o.insurancecompanycode) as insurancecompanycode -- 保险公司编号
    ,nvl(n.underwriters1, o.underwriters1) as underwriters1 -- 核保人名称1
    ,nvl(n.underwriters2, o.underwriters2) as underwriters2 -- 核保人名称2
    ,case when
            n.insurancerecordid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.insurancerecordid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.insurancerecordid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_insurance_record_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_insurance_record where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.insurancerecordid = n.insurancerecordid
where (
        o.insurancerecordid is null
    )
    or (
        n.insurancerecordid is null
    )
    or (
        o.guarantyplanno <> n.guarantyplanno
        or o.clrid <> n.clrid
        or o.insurancestatus <> n.insurancestatus
        or o.insurancecompany <> n.insurancecompany
        or o.insurancetype <> n.insurancetype
        or o.benificiary <> n.benificiary
        or o.insurancepolicyid <> n.insurancepolicyid
        or o.insuranceamount <> n.insuranceamount
        or o.insurancefee <> n.insurancefee
        or o.insurancefeerate <> n.insurancefeerate
        or o.paymentmethod <> n.paymentmethod
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.expirydate <> n.expirydate
        or o.expiryreason <> n.expiryreason
        or o.issuedate <> n.issuedate
        or o.isrenewinsurance <> n.isrenewinsurance
        or o.isneedwarehousing <> n.isneedwarehousing
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.corporgid <> n.corporgid
        or o.oldclrid <> n.oldclrid
        or o.migtflag <> n.migtflag
        or o.insurancecompanycode <> n.insurancecompanycode
        or o.underwriters1 <> n.underwriters1
        or o.underwriters2 <> n.underwriters2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_insurance_record_cl(
            insurancerecordid -- 保险记录编号
            ,guarantyplanno -- 担保方案编号
            ,clrid -- 押品编号
            ,insurancestatus -- 保险状态
            ,insurancecompany -- 保险公司
            ,insurancetype -- 保险类型
            ,benificiary -- 保险受益人
            ,insurancepolicyid -- 保单号码
            ,insuranceamount -- 投保金额
            ,insurancefee -- 保险费
            ,insurancefeerate -- 保险费率
            ,paymentmethod -- 缴费方式
            ,startdate -- 保险起始日
            ,enddate -- 保险到期日
            ,expirydate -- 保险失效日
            ,expiryreason -- 保险失效原因
            ,issuedate -- 出单日期
            ,isrenewinsurance -- 续保标志
            ,isneedwarehousing -- 是否需要入库
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,oldclrid -- 合并前押品编号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,insurancecompanycode -- 保险公司编号
            ,underwriters1 -- 核保人名称1
            ,underwriters2 -- 核保人名称2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_insurance_record_op(
            insurancerecordid -- 保险记录编号
            ,guarantyplanno -- 担保方案编号
            ,clrid -- 押品编号
            ,insurancestatus -- 保险状态
            ,insurancecompany -- 保险公司
            ,insurancetype -- 保险类型
            ,benificiary -- 保险受益人
            ,insurancepolicyid -- 保单号码
            ,insuranceamount -- 投保金额
            ,insurancefee -- 保险费
            ,insurancefeerate -- 保险费率
            ,paymentmethod -- 缴费方式
            ,startdate -- 保险起始日
            ,enddate -- 保险到期日
            ,expirydate -- 保险失效日
            ,expiryreason -- 保险失效原因
            ,issuedate -- 出单日期
            ,isrenewinsurance -- 续保标志
            ,isneedwarehousing -- 是否需要入库
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,corporgid -- 法人机构编号
            ,oldclrid -- 合并前押品编号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,insurancecompanycode -- 保险公司编号
            ,underwriters1 -- 核保人名称1
            ,underwriters2 -- 核保人名称2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.insurancerecordid -- 保险记录编号
    ,o.guarantyplanno -- 担保方案编号
    ,o.clrid -- 押品编号
    ,o.insurancestatus -- 保险状态
    ,o.insurancecompany -- 保险公司
    ,o.insurancetype -- 保险类型
    ,o.benificiary -- 保险受益人
    ,o.insurancepolicyid -- 保单号码
    ,o.insuranceamount -- 投保金额
    ,o.insurancefee -- 保险费
    ,o.insurancefeerate -- 保险费率
    ,o.paymentmethod -- 缴费方式
    ,o.startdate -- 保险起始日
    ,o.enddate -- 保险到期日
    ,o.expirydate -- 保险失效日
    ,o.expiryreason -- 保险失效原因
    ,o.issuedate -- 出单日期
    ,o.isrenewinsurance -- 续保标志
    ,o.isneedwarehousing -- 是否需要入库
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.corporgid -- 法人机构编号
    ,o.oldclrid -- 合并前押品编号
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
    ,o.insurancecompanycode -- 保险公司编号
    ,o.underwriters1 -- 核保人名称1
    ,o.underwriters2 -- 核保人名称2
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
from ${iol_schema}.icms_clr_insurance_record_bk o
    left join ${iol_schema}.icms_clr_insurance_record_op n
        on
            o.insurancerecordid = n.insurancerecordid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_insurance_record_cl d
        on
            o.insurancerecordid = d.insurancerecordid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_insurance_record;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_insurance_record') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_insurance_record drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_insurance_record add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_insurance_record exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_insurance_record_cl;
alter table ${iol_schema}.icms_clr_insurance_record exchange partition p_20991231 with table ${iol_schema}.icms_clr_insurance_record_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_insurance_record to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_insurance_record_op purge;
drop table ${iol_schema}.icms_clr_insurance_record_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_insurance_record_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_insurance_record',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
