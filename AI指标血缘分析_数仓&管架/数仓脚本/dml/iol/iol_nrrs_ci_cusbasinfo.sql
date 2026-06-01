/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nrrs_ci_cusbasinfo
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
create table ${iol_schema}.nrrs_ci_cusbasinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nrrs_ci_cusbasinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_ci_cusbasinfo_op purge;
drop table ${iol_schema}.nrrs_ci_cusbasinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_ci_cusbasinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_ci_cusbasinfo where 0=1;

create table ${iol_schema}.nrrs_ci_cusbasinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nrrs_ci_cusbasinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_ci_cusbasinfo_cl(
            custid -- 客户编号
            ,custcname -- 客户名称
            ,custtype -- 客户类型代码
            ,orgcertcode -- 组织机构代码
            ,interindustry -- 所属行业代码
            ,interindustryname -- 所属行业名称
            ,createyear -- 成立日期
            ,custscale -- 企业规模代码
            ,custscalenmae -- 企业规模名称
            ,emplquantity -- 职工人数
            ,custmgr -- 客户经理编号
            ,deptcode -- 所属机构编号
            ,bloccustid -- 集团客户编号
            ,blocname -- 集团客户名称
            ,pcustid -- 母公司客户编号
            ,modifydate -- 最后更新日期
            ,balance -- 最新授信余额
            ,sales -- 销售收入 指标Z0155
            ,state -- 客户状态代码
            ,lntoat -- 总资产
            ,amt -- 余额
            ,accbal -- 日期
            ,riskclass -- 风险类型
            ,maxovdue -- 日期
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,countycode -- 所属国家（地区）
            ,areas -- 所在省份、直辖市、自治区
            ,finantype -- 财务报表类型
            ,business1 -- 第一大主营业务
            ,business2 -- 第二大主营业务
            ,business3 -- 第三大主营业务
            ,busimgrsum -- 近三年平均营业收入
            ,comcorptype -- 所有制类型
            ,inputuser -- 登记人
            ,inputorg -- 登记机构
            ,calscale -- 计算规模
            ,isbloc -- 单一标示
            ,mfcustomerid -- 核心客户号
            ,risktype -- 风险类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_ci_cusbasinfo_op(
            custid -- 客户编号
            ,custcname -- 客户名称
            ,custtype -- 客户类型代码
            ,orgcertcode -- 组织机构代码
            ,interindustry -- 所属行业代码
            ,interindustryname -- 所属行业名称
            ,createyear -- 成立日期
            ,custscale -- 企业规模代码
            ,custscalenmae -- 企业规模名称
            ,emplquantity -- 职工人数
            ,custmgr -- 客户经理编号
            ,deptcode -- 所属机构编号
            ,bloccustid -- 集团客户编号
            ,blocname -- 集团客户名称
            ,pcustid -- 母公司客户编号
            ,modifydate -- 最后更新日期
            ,balance -- 最新授信余额
            ,sales -- 销售收入 指标Z0155
            ,state -- 客户状态代码
            ,lntoat -- 总资产
            ,amt -- 余额
            ,accbal -- 日期
            ,riskclass -- 风险类型
            ,maxovdue -- 日期
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,countycode -- 所属国家（地区）
            ,areas -- 所在省份、直辖市、自治区
            ,finantype -- 财务报表类型
            ,business1 -- 第一大主营业务
            ,business2 -- 第二大主营业务
            ,business3 -- 第三大主营业务
            ,busimgrsum -- 近三年平均营业收入
            ,comcorptype -- 所有制类型
            ,inputuser -- 登记人
            ,inputorg -- 登记机构
            ,calscale -- 计算规模
            ,isbloc -- 单一标示
            ,mfcustomerid -- 核心客户号
            ,risktype -- 风险类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.custid, o.custid) as custid -- 客户编号
    ,nvl(n.custcname, o.custcname) as custcname -- 客户名称
    ,nvl(n.custtype, o.custtype) as custtype -- 客户类型代码
    ,nvl(n.orgcertcode, o.orgcertcode) as orgcertcode -- 组织机构代码
    ,nvl(n.interindustry, o.interindustry) as interindustry -- 所属行业代码
    ,nvl(n.interindustryname, o.interindustryname) as interindustryname -- 所属行业名称
    ,nvl(n.createyear, o.createyear) as createyear -- 成立日期
    ,nvl(n.custscale, o.custscale) as custscale -- 企业规模代码
    ,nvl(n.custscalenmae, o.custscalenmae) as custscalenmae -- 企业规模名称
    ,nvl(n.emplquantity, o.emplquantity) as emplquantity -- 职工人数
    ,nvl(n.custmgr, o.custmgr) as custmgr -- 客户经理编号
    ,nvl(n.deptcode, o.deptcode) as deptcode -- 所属机构编号
    ,nvl(n.bloccustid, o.bloccustid) as bloccustid -- 集团客户编号
    ,nvl(n.blocname, o.blocname) as blocname -- 集团客户名称
    ,nvl(n.pcustid, o.pcustid) as pcustid -- 母公司客户编号
    ,nvl(n.modifydate, o.modifydate) as modifydate -- 最后更新日期
    ,nvl(n.balance, o.balance) as balance -- 最新授信余额
    ,nvl(n.sales, o.sales) as sales -- 销售收入 指标Z0155
    ,nvl(n.state, o.state) as state -- 客户状态代码
    ,nvl(n.lntoat, o.lntoat) as lntoat -- 总资产
    ,nvl(n.amt, o.amt) as amt -- 余额
    ,nvl(n.accbal, o.accbal) as accbal -- 日期
    ,nvl(n.riskclass, o.riskclass) as riskclass -- 风险类型
    ,nvl(n.maxovdue, o.maxovdue) as maxovdue -- 日期
    ,nvl(n.certtype, o.certtype) as certtype -- 证件类型
    ,nvl(n.certid, o.certid) as certid -- 证件号码
    ,nvl(n.countycode, o.countycode) as countycode -- 所属国家（地区）
    ,nvl(n.areas, o.areas) as areas -- 所在省份、直辖市、自治区
    ,nvl(n.finantype, o.finantype) as finantype -- 财务报表类型
    ,nvl(n.business1, o.business1) as business1 -- 第一大主营业务
    ,nvl(n.business2, o.business2) as business2 -- 第二大主营业务
    ,nvl(n.business3, o.business3) as business3 -- 第三大主营业务
    ,nvl(n.busimgrsum, o.busimgrsum) as busimgrsum -- 近三年平均营业收入
    ,nvl(n.comcorptype, o.comcorptype) as comcorptype -- 所有制类型
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 登记人
    ,nvl(n.inputorg, o.inputorg) as inputorg -- 登记机构
    ,nvl(n.calscale, o.calscale) as calscale -- 计算规模
    ,nvl(n.isbloc, o.isbloc) as isbloc -- 单一标示
    ,nvl(n.mfcustomerid, o.mfcustomerid) as mfcustomerid -- 核心客户号
    ,nvl(n.risktype, o.risktype) as risktype -- 风险类型
    ,case when
            n.custid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.custid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.custid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nrrs_ci_cusbasinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nrrs_ci_cusbasinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custid = n.custid
where (
        o.custid is null
    )
    or (
        n.custid is null
    )
    or (
        o.custcname <> n.custcname
        or o.custtype <> n.custtype
        or o.orgcertcode <> n.orgcertcode
        or o.interindustry <> n.interindustry
        or o.interindustryname <> n.interindustryname
        or o.createyear <> n.createyear
        or o.custscale <> n.custscale
        or o.custscalenmae <> n.custscalenmae
        or o.emplquantity <> n.emplquantity
        or o.custmgr <> n.custmgr
        or o.deptcode <> n.deptcode
        or o.bloccustid <> n.bloccustid
        or o.blocname <> n.blocname
        or o.pcustid <> n.pcustid
        or o.modifydate <> n.modifydate
        or o.balance <> n.balance
        or o.sales <> n.sales
        or o.state <> n.state
        or o.lntoat <> n.lntoat
        or o.amt <> n.amt
        or o.accbal <> n.accbal
        or o.riskclass <> n.riskclass
        or o.maxovdue <> n.maxovdue
        or o.certtype <> n.certtype
        or o.certid <> n.certid
        or o.countycode <> n.countycode
        or o.areas <> n.areas
        or o.finantype <> n.finantype
        or o.business1 <> n.business1
        or o.business2 <> n.business2
        or o.business3 <> n.business3
        or o.busimgrsum <> n.busimgrsum
        or o.comcorptype <> n.comcorptype
        or o.inputuser <> n.inputuser
        or o.inputorg <> n.inputorg
        or o.calscale <> n.calscale
        or o.isbloc <> n.isbloc
        or o.mfcustomerid <> n.mfcustomerid
        or o.risktype <> n.risktype
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nrrs_ci_cusbasinfo_cl(
            custid -- 客户编号
            ,custcname -- 客户名称
            ,custtype -- 客户类型代码
            ,orgcertcode -- 组织机构代码
            ,interindustry -- 所属行业代码
            ,interindustryname -- 所属行业名称
            ,createyear -- 成立日期
            ,custscale -- 企业规模代码
            ,custscalenmae -- 企业规模名称
            ,emplquantity -- 职工人数
            ,custmgr -- 客户经理编号
            ,deptcode -- 所属机构编号
            ,bloccustid -- 集团客户编号
            ,blocname -- 集团客户名称
            ,pcustid -- 母公司客户编号
            ,modifydate -- 最后更新日期
            ,balance -- 最新授信余额
            ,sales -- 销售收入 指标Z0155
            ,state -- 客户状态代码
            ,lntoat -- 总资产
            ,amt -- 余额
            ,accbal -- 日期
            ,riskclass -- 风险类型
            ,maxovdue -- 日期
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,countycode -- 所属国家（地区）
            ,areas -- 所在省份、直辖市、自治区
            ,finantype -- 财务报表类型
            ,business1 -- 第一大主营业务
            ,business2 -- 第二大主营业务
            ,business3 -- 第三大主营业务
            ,busimgrsum -- 近三年平均营业收入
            ,comcorptype -- 所有制类型
            ,inputuser -- 登记人
            ,inputorg -- 登记机构
            ,calscale -- 计算规模
            ,isbloc -- 单一标示
            ,mfcustomerid -- 核心客户号
            ,risktype -- 风险类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nrrs_ci_cusbasinfo_op(
            custid -- 客户编号
            ,custcname -- 客户名称
            ,custtype -- 客户类型代码
            ,orgcertcode -- 组织机构代码
            ,interindustry -- 所属行业代码
            ,interindustryname -- 所属行业名称
            ,createyear -- 成立日期
            ,custscale -- 企业规模代码
            ,custscalenmae -- 企业规模名称
            ,emplquantity -- 职工人数
            ,custmgr -- 客户经理编号
            ,deptcode -- 所属机构编号
            ,bloccustid -- 集团客户编号
            ,blocname -- 集团客户名称
            ,pcustid -- 母公司客户编号
            ,modifydate -- 最后更新日期
            ,balance -- 最新授信余额
            ,sales -- 销售收入 指标Z0155
            ,state -- 客户状态代码
            ,lntoat -- 总资产
            ,amt -- 余额
            ,accbal -- 日期
            ,riskclass -- 风险类型
            ,maxovdue -- 日期
            ,certtype -- 证件类型
            ,certid -- 证件号码
            ,countycode -- 所属国家（地区）
            ,areas -- 所在省份、直辖市、自治区
            ,finantype -- 财务报表类型
            ,business1 -- 第一大主营业务
            ,business2 -- 第二大主营业务
            ,business3 -- 第三大主营业务
            ,busimgrsum -- 近三年平均营业收入
            ,comcorptype -- 所有制类型
            ,inputuser -- 登记人
            ,inputorg -- 登记机构
            ,calscale -- 计算规模
            ,isbloc -- 单一标示
            ,mfcustomerid -- 核心客户号
            ,risktype -- 风险类型
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.custid -- 客户编号
    ,o.custcname -- 客户名称
    ,o.custtype -- 客户类型代码
    ,o.orgcertcode -- 组织机构代码
    ,o.interindustry -- 所属行业代码
    ,o.interindustryname -- 所属行业名称
    ,o.createyear -- 成立日期
    ,o.custscale -- 企业规模代码
    ,o.custscalenmae -- 企业规模名称
    ,o.emplquantity -- 职工人数
    ,o.custmgr -- 客户经理编号
    ,o.deptcode -- 所属机构编号
    ,o.bloccustid -- 集团客户编号
    ,o.blocname -- 集团客户名称
    ,o.pcustid -- 母公司客户编号
    ,o.modifydate -- 最后更新日期
    ,o.balance -- 最新授信余额
    ,o.sales -- 销售收入 指标Z0155
    ,o.state -- 客户状态代码
    ,o.lntoat -- 总资产
    ,o.amt -- 余额
    ,o.accbal -- 日期
    ,o.riskclass -- 风险类型
    ,o.maxovdue -- 日期
    ,o.certtype -- 证件类型
    ,o.certid -- 证件号码
    ,o.countycode -- 所属国家（地区）
    ,o.areas -- 所在省份、直辖市、自治区
    ,o.finantype -- 财务报表类型
    ,o.business1 -- 第一大主营业务
    ,o.business2 -- 第二大主营业务
    ,o.business3 -- 第三大主营业务
    ,o.busimgrsum -- 近三年平均营业收入
    ,o.comcorptype -- 所有制类型
    ,o.inputuser -- 登记人
    ,o.inputorg -- 登记机构
    ,o.calscale -- 计算规模
    ,o.isbloc -- 单一标示
    ,o.mfcustomerid -- 核心客户号
    ,o.risktype -- 风险类型
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
from ${iol_schema}.nrrs_ci_cusbasinfo_bk o
    left join ${iol_schema}.nrrs_ci_cusbasinfo_op n
        on
            o.custid = n.custid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nrrs_ci_cusbasinfo_cl d
        on
            o.custid = d.custid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nrrs_ci_cusbasinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nrrs_ci_cusbasinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nrrs_ci_cusbasinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nrrs_ci_cusbasinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nrrs_ci_cusbasinfo exchange partition p_${batch_date} with table ${iol_schema}.nrrs_ci_cusbasinfo_cl;
alter table ${iol_schema}.nrrs_ci_cusbasinfo exchange partition p_20991231 with table ${iol_schema}.nrrs_ci_cusbasinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nrrs_ci_cusbasinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nrrs_ci_cusbasinfo_op purge;
drop table ${iol_schema}.nrrs_ci_cusbasinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nrrs_ci_cusbasinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nrrs_ci_cusbasinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
