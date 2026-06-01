/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zjbk_business_contract
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
create table ${iol_schema}.icms_zjbk_business_contract_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_zjbk_business_contract
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_business_contract_op purge;
drop table ${iol_schema}.icms_zjbk_business_contract_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_business_contract_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_business_contract where 0=1;

create table ${iol_schema}.icms_zjbk_business_contract_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_business_contract where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_business_contract_cl(
            serialno -- 合同号
            ,relativelhdserialno -- 关联联合贷申请号
            ,relativezdserialno -- 关联助贷申请号
            ,parentserialno -- 关联额度合同号
            ,accountid -- 授信ID
            ,approvestatus -- 审批状态
            ,status -- 合同状态
            ,customerid -- 客户号
            ,customername -- 姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,phone -- 手机号
            ,productid -- 产品编号
            ,productmode -- 产品类别
            ,businesssum -- 合同金额
            ,balance -- 合同余额
            ,intrate -- 利率
            ,currency -- 币种
            ,businessflag -- 业务类型
            ,startdate -- 合同起始日
            ,enddate -- 合同到期日
            ,termmonth -- 期限
            ,usage -- 用途
            ,loanid -- 用信申请流水号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,newcrdtestimatlmt -- 预估额度
            ,closedate -- 字节账户关闭日期
            ,closetype -- 字节关闭类型：1：账户注销 2：账户关闭
            ,dailyrate -- 授信日利率
            ,availablebalance -- 可用额度余额
            ,companyindustry -- 所属行业
            ,intraindustrytype -- 贷款投向
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_business_contract_op(
            serialno -- 合同号
            ,relativelhdserialno -- 关联联合贷申请号
            ,relativezdserialno -- 关联助贷申请号
            ,parentserialno -- 关联额度合同号
            ,accountid -- 授信ID
            ,approvestatus -- 审批状态
            ,status -- 合同状态
            ,customerid -- 客户号
            ,customername -- 姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,phone -- 手机号
            ,productid -- 产品编号
            ,productmode -- 产品类别
            ,businesssum -- 合同金额
            ,balance -- 合同余额
            ,intrate -- 利率
            ,currency -- 币种
            ,businessflag -- 业务类型
            ,startdate -- 合同起始日
            ,enddate -- 合同到期日
            ,termmonth -- 期限
            ,usage -- 用途
            ,loanid -- 用信申请流水号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,newcrdtestimatlmt -- 预估额度
            ,closedate -- 字节账户关闭日期
            ,closetype -- 字节关闭类型：1：账户注销 2：账户关闭
            ,dailyrate -- 授信日利率
            ,availablebalance -- 可用额度余额
            ,companyindustry -- 所属行业
            ,intraindustrytype -- 贷款投向
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 合同号
    ,nvl(n.relativelhdserialno, o.relativelhdserialno) as relativelhdserialno -- 关联联合贷申请号
    ,nvl(n.relativezdserialno, o.relativezdserialno) as relativezdserialno -- 关联助贷申请号
    ,nvl(n.parentserialno, o.parentserialno) as parentserialno -- 关联额度合同号
    ,nvl(n.accountid, o.accountid) as accountid -- 授信ID
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 审批状态
    ,nvl(n.status, o.status) as status -- 合同状态
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.customername, o.customername) as customername -- 姓名
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.phone, o.phone) as phone -- 手机号
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.productmode, o.productmode) as productmode -- 产品类别
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 合同金额
    ,nvl(n.balance, o.balance) as balance -- 合同余额
    ,nvl(n.intrate, o.intrate) as intrate -- 利率
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.businessflag, o.businessflag) as businessflag -- 业务类型
    ,nvl(n.startdate, o.startdate) as startdate -- 合同起始日
    ,nvl(n.enddate, o.enddate) as enddate -- 合同到期日
    ,nvl(n.termmonth, o.termmonth) as termmonth -- 期限
    ,nvl(n.usage, o.usage) as usage -- 用途
    ,nvl(n.loanid, o.loanid) as loanid -- 用信申请流水号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.newcrdtestimatlmt, o.newcrdtestimatlmt) as newcrdtestimatlmt -- 预估额度
    ,nvl(n.closedate, o.closedate) as closedate -- 字节账户关闭日期
    ,nvl(n.closetype, o.closetype) as closetype -- 字节关闭类型：1：账户注销 2：账户关闭
    ,nvl(n.dailyrate, o.dailyrate) as dailyrate -- 授信日利率
    ,nvl(n.availablebalance, o.availablebalance) as availablebalance -- 可用额度余额
    ,nvl(n.companyindustry, o.companyindustry) as companyindustry -- 所属行业
    ,nvl(n.intraindustrytype, o.intraindustrytype) as intraindustrytype -- 贷款投向
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
from (select * from ${iol_schema}.icms_zjbk_business_contract_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_zjbk_business_contract where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.relativelhdserialno <> n.relativelhdserialno
        or o.relativezdserialno <> n.relativezdserialno
        or o.parentserialno <> n.parentserialno
        or o.accountid <> n.accountid
        or o.approvestatus <> n.approvestatus
        or o.status <> n.status
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.phone <> n.phone
        or o.productid <> n.productid
        or o.productmode <> n.productmode
        or o.businesssum <> n.businesssum
        or o.balance <> n.balance
        or o.intrate <> n.intrate
        or o.currency <> n.currency
        or o.businessflag <> n.businessflag
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.termmonth <> n.termmonth
        or o.usage <> n.usage
        or o.loanid <> n.loanid
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.newcrdtestimatlmt <> n.newcrdtestimatlmt
        or o.closedate <> n.closedate
        or o.closetype <> n.closetype
        or o.dailyrate <> n.dailyrate
        or o.availablebalance <> n.availablebalance
        or o.companyindustry <> n.companyindustry
        or o.intraindustrytype <> n.intraindustrytype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_business_contract_cl(
            serialno -- 合同号
            ,relativelhdserialno -- 关联联合贷申请号
            ,relativezdserialno -- 关联助贷申请号
            ,parentserialno -- 关联额度合同号
            ,accountid -- 授信ID
            ,approvestatus -- 审批状态
            ,status -- 合同状态
            ,customerid -- 客户号
            ,customername -- 姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,phone -- 手机号
            ,productid -- 产品编号
            ,productmode -- 产品类别
            ,businesssum -- 合同金额
            ,balance -- 合同余额
            ,intrate -- 利率
            ,currency -- 币种
            ,businessflag -- 业务类型
            ,startdate -- 合同起始日
            ,enddate -- 合同到期日
            ,termmonth -- 期限
            ,usage -- 用途
            ,loanid -- 用信申请流水号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,newcrdtestimatlmt -- 预估额度
            ,closedate -- 字节账户关闭日期
            ,closetype -- 字节关闭类型：1：账户注销 2：账户关闭
            ,dailyrate -- 授信日利率
            ,availablebalance -- 可用额度余额
            ,companyindustry -- 所属行业
            ,intraindustrytype -- 贷款投向
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_business_contract_op(
            serialno -- 合同号
            ,relativelhdserialno -- 关联联合贷申请号
            ,relativezdserialno -- 关联助贷申请号
            ,parentserialno -- 关联额度合同号
            ,accountid -- 授信ID
            ,approvestatus -- 审批状态
            ,status -- 合同状态
            ,customerid -- 客户号
            ,customername -- 姓名
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,phone -- 手机号
            ,productid -- 产品编号
            ,productmode -- 产品类别
            ,businesssum -- 合同金额
            ,balance -- 合同余额
            ,intrate -- 利率
            ,currency -- 币种
            ,businessflag -- 业务类型
            ,startdate -- 合同起始日
            ,enddate -- 合同到期日
            ,termmonth -- 期限
            ,usage -- 用途
            ,loanid -- 用信申请流水号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,newcrdtestimatlmt -- 预估额度
            ,closedate -- 字节账户关闭日期
            ,closetype -- 字节关闭类型：1：账户注销 2：账户关闭
            ,dailyrate -- 授信日利率
            ,availablebalance -- 可用额度余额
            ,companyindustry -- 所属行业
            ,intraindustrytype -- 贷款投向
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 合同号
    ,o.relativelhdserialno -- 关联联合贷申请号
    ,o.relativezdserialno -- 关联助贷申请号
    ,o.parentserialno -- 关联额度合同号
    ,o.accountid -- 授信ID
    ,o.approvestatus -- 审批状态
    ,o.status -- 合同状态
    ,o.customerid -- 客户号
    ,o.customername -- 姓名
    ,o.certtype -- 证件类型
    ,o.certid -- 证件号码
    ,o.phone -- 手机号
    ,o.productid -- 产品编号
    ,o.productmode -- 产品类别
    ,o.businesssum -- 合同金额
    ,o.balance -- 合同余额
    ,o.intrate -- 利率
    ,o.currency -- 币种
    ,o.businessflag -- 业务类型
    ,o.startdate -- 合同起始日
    ,o.enddate -- 合同到期日
    ,o.termmonth -- 期限
    ,o.usage -- 用途
    ,o.loanid -- 用信申请流水号
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.newcrdtestimatlmt -- 预估额度
    ,o.closedate -- 字节账户关闭日期
    ,o.closetype -- 字节关闭类型：1：账户注销 2：账户关闭
    ,o.dailyrate -- 授信日利率
    ,o.availablebalance -- 可用额度余额
    ,o.companyindustry -- 所属行业
    ,o.intraindustrytype -- 贷款投向
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
from ${iol_schema}.icms_zjbk_business_contract_bk o
    left join ${iol_schema}.icms_zjbk_business_contract_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_zjbk_business_contract_cl d
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
--truncate table ${iol_schema}.icms_zjbk_business_contract;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_zjbk_business_contract') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_zjbk_business_contract drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_zjbk_business_contract add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_zjbk_business_contract exchange partition p_${batch_date} with table ${iol_schema}.icms_zjbk_business_contract_cl;
alter table ${iol_schema}.icms_zjbk_business_contract exchange partition p_20991231 with table ${iol_schema}.icms_zjbk_business_contract_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_zjbk_business_contract to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_business_contract_op purge;
drop table ${iol_schema}.icms_zjbk_business_contract_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_zjbk_business_contract_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_zjbk_business_contract',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
