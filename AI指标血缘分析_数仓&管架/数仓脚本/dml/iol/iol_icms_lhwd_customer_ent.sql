/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lhwd_customer_ent
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
create table ${iol_schema}.icms_lhwd_customer_ent_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lhwd_customer_ent
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_customer_ent_op purge;
drop table ${iol_schema}.icms_lhwd_customer_ent_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_customer_ent_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_customer_ent where 0=1;

create table ${iol_schema}.icms_lhwd_customer_ent_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lhwd_customer_ent where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhwd_customer_ent_cl(
            serialno -- 流水号
            ,relacustomerid -- 关联客户编号
            ,corpname -- 企业名称
            ,corpsocialcode -- 统一社会信用代码
            ,industrytype -- 所属行业类型
            ,corpstatus -- 企业状态
            ,customertype -- 客户属性
            ,managerrole -- 经营者身份
            ,setupdate -- 企业成立日期
            ,fictitiousperson -- 法定代表人
            ,registeradd -- 注册地址
            ,shareholdingratio -- 持股占比
            ,licensebegin -- 证照起始日期
            ,licensematurity -- 证照有效期至
            ,registerregion -- 注册地省市区
            ,registeramount -- 注册资本
            ,paidamount -- 实收资本
            ,employeenumber -- 企业员工人数
            ,enttype -- 企业类型
            ,currency -- 币种
            ,businessyear -- 实际经营年限
            ,businessscope -- 经营范围
            ,creditchannel -- 授信渠道
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_customer_ent_op(
            serialno -- 流水号
            ,relacustomerid -- 关联客户编号
            ,corpname -- 企业名称
            ,corpsocialcode -- 统一社会信用代码
            ,industrytype -- 所属行业类型
            ,corpstatus -- 企业状态
            ,customertype -- 客户属性
            ,managerrole -- 经营者身份
            ,setupdate -- 企业成立日期
            ,fictitiousperson -- 法定代表人
            ,registeradd -- 注册地址
            ,shareholdingratio -- 持股占比
            ,licensebegin -- 证照起始日期
            ,licensematurity -- 证照有效期至
            ,registerregion -- 注册地省市区
            ,registeramount -- 注册资本
            ,paidamount -- 实收资本
            ,employeenumber -- 企业员工人数
            ,enttype -- 企业类型
            ,currency -- 币种
            ,businessyear -- 实际经营年限
            ,businessscope -- 经营范围
            ,creditchannel -- 授信渠道
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.relacustomerid, o.relacustomerid) as relacustomerid -- 关联客户编号
    ,nvl(n.corpname, o.corpname) as corpname -- 企业名称
    ,nvl(n.corpsocialcode, o.corpsocialcode) as corpsocialcode -- 统一社会信用代码
    ,nvl(n.industrytype, o.industrytype) as industrytype -- 所属行业类型
    ,nvl(n.corpstatus, o.corpstatus) as corpstatus -- 企业状态
    ,nvl(n.customertype, o.customertype) as customertype -- 客户属性
    ,nvl(n.managerrole, o.managerrole) as managerrole -- 经营者身份
    ,nvl(n.setupdate, o.setupdate) as setupdate -- 企业成立日期
    ,nvl(n.fictitiousperson, o.fictitiousperson) as fictitiousperson -- 法定代表人
    ,nvl(n.registeradd, o.registeradd) as registeradd -- 注册地址
    ,nvl(n.shareholdingratio, o.shareholdingratio) as shareholdingratio -- 持股占比
    ,nvl(n.licensebegin, o.licensebegin) as licensebegin -- 证照起始日期
    ,nvl(n.licensematurity, o.licensematurity) as licensematurity -- 证照有效期至
    ,nvl(n.registerregion, o.registerregion) as registerregion -- 注册地省市区
    ,nvl(n.registeramount, o.registeramount) as registeramount -- 注册资本
    ,nvl(n.paidamount, o.paidamount) as paidamount -- 实收资本
    ,nvl(n.employeenumber, o.employeenumber) as employeenumber -- 企业员工人数
    ,nvl(n.enttype, o.enttype) as enttype -- 企业类型
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.businessyear, o.businessyear) as businessyear -- 实际经营年限
    ,nvl(n.businessscope, o.businessscope) as businessscope -- 经营范围
    ,nvl(n.creditchannel, o.creditchannel) as creditchannel -- 授信渠道
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
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
from (select * from ${iol_schema}.icms_lhwd_customer_ent_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lhwd_customer_ent where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.relacustomerid <> n.relacustomerid
        or o.corpname <> n.corpname
        or o.corpsocialcode <> n.corpsocialcode
        or o.industrytype <> n.industrytype
        or o.corpstatus <> n.corpstatus
        or o.customertype <> n.customertype
        or o.managerrole <> n.managerrole
        or o.setupdate <> n.setupdate
        or o.fictitiousperson <> n.fictitiousperson
        or o.registeradd <> n.registeradd
        or o.shareholdingratio <> n.shareholdingratio
        or o.licensebegin <> n.licensebegin
        or o.licensematurity <> n.licensematurity
        or o.registerregion <> n.registerregion
        or o.registeramount <> n.registeramount
        or o.paidamount <> n.paidamount
        or o.employeenumber <> n.employeenumber
        or o.enttype <> n.enttype
        or o.currency <> n.currency
        or o.businessyear <> n.businessyear
        or o.businessscope <> n.businessscope
        or o.creditchannel <> n.creditchannel
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lhwd_customer_ent_cl(
            serialno -- 流水号
            ,relacustomerid -- 关联客户编号
            ,corpname -- 企业名称
            ,corpsocialcode -- 统一社会信用代码
            ,industrytype -- 所属行业类型
            ,corpstatus -- 企业状态
            ,customertype -- 客户属性
            ,managerrole -- 经营者身份
            ,setupdate -- 企业成立日期
            ,fictitiousperson -- 法定代表人
            ,registeradd -- 注册地址
            ,shareholdingratio -- 持股占比
            ,licensebegin -- 证照起始日期
            ,licensematurity -- 证照有效期至
            ,registerregion -- 注册地省市区
            ,registeramount -- 注册资本
            ,paidamount -- 实收资本
            ,employeenumber -- 企业员工人数
            ,enttype -- 企业类型
            ,currency -- 币种
            ,businessyear -- 实际经营年限
            ,businessscope -- 经营范围
            ,creditchannel -- 授信渠道
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lhwd_customer_ent_op(
            serialno -- 流水号
            ,relacustomerid -- 关联客户编号
            ,corpname -- 企业名称
            ,corpsocialcode -- 统一社会信用代码
            ,industrytype -- 所属行业类型
            ,corpstatus -- 企业状态
            ,customertype -- 客户属性
            ,managerrole -- 经营者身份
            ,setupdate -- 企业成立日期
            ,fictitiousperson -- 法定代表人
            ,registeradd -- 注册地址
            ,shareholdingratio -- 持股占比
            ,licensebegin -- 证照起始日期
            ,licensematurity -- 证照有效期至
            ,registerregion -- 注册地省市区
            ,registeramount -- 注册资本
            ,paidamount -- 实收资本
            ,employeenumber -- 企业员工人数
            ,enttype -- 企业类型
            ,currency -- 币种
            ,businessyear -- 实际经营年限
            ,businessscope -- 经营范围
            ,creditchannel -- 授信渠道
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.relacustomerid -- 关联客户编号
    ,o.corpname -- 企业名称
    ,o.corpsocialcode -- 统一社会信用代码
    ,o.industrytype -- 所属行业类型
    ,o.corpstatus -- 企业状态
    ,o.customertype -- 客户属性
    ,o.managerrole -- 经营者身份
    ,o.setupdate -- 企业成立日期
    ,o.fictitiousperson -- 法定代表人
    ,o.registeradd -- 注册地址
    ,o.shareholdingratio -- 持股占比
    ,o.licensebegin -- 证照起始日期
    ,o.licensematurity -- 证照有效期至
    ,o.registerregion -- 注册地省市区
    ,o.registeramount -- 注册资本
    ,o.paidamount -- 实收资本
    ,o.employeenumber -- 企业员工人数
    ,o.enttype -- 企业类型
    ,o.currency -- 币种
    ,o.businessyear -- 实际经营年限
    ,o.businessscope -- 经营范围
    ,o.creditchannel -- 授信渠道
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新时间
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
from ${iol_schema}.icms_lhwd_customer_ent_bk o
    left join ${iol_schema}.icms_lhwd_customer_ent_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lhwd_customer_ent_cl d
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
--truncate table ${iol_schema}.icms_lhwd_customer_ent;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lhwd_customer_ent') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lhwd_customer_ent drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lhwd_customer_ent add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lhwd_customer_ent exchange partition p_${batch_date} with table ${iol_schema}.icms_lhwd_customer_ent_cl;
alter table ${iol_schema}.icms_lhwd_customer_ent exchange partition p_20991231 with table ${iol_schema}.icms_lhwd_customer_ent_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lhwd_customer_ent to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lhwd_customer_ent_op purge;
drop table ${iol_schema}.icms_lhwd_customer_ent_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lhwd_customer_ent_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lhwd_customer_ent',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
