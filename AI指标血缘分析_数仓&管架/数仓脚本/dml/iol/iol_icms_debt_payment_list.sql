/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_debt_payment_list
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
create table ${iol_schema}.icms_debt_payment_list_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_debt_payment_list
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_debt_payment_list_op purge;
drop table ${iol_schema}.icms_debt_payment_list_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_debt_payment_list_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_debt_payment_list where 0=1;

create table ${iol_schema}.icms_debt_payment_list_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_debt_payment_list where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_debt_payment_list_cl(
            serialno -- 流水号
            ,relativeserialno -- 关联流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,debtrepayassetid -- 抵债资产编号
            ,debtrepayassetname -- 抵债资产名称
            ,debtrepaysum -- 抵扣债权金额
            ,debtoffsetamount -- 抵债金额
            ,receivedate -- 抵债日期
            ,debtrepayassettype -- 抵债资产类型(code:DebtRepaymentType)
            ,debtrepaymenttype -- 抵债类型(code:DebtRepayAssetType)
            ,status -- 处理状态(code:CollectResult)
            ,amount -- 数量
            ,stockcode -- 股票代码/权证号
            ,propertylocation -- 房产位置
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,operateuserid -- 经办客户经理
            ,operateorgid -- 经办客户经理所属机构
            ,operatedate -- 经办时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,putoutorgid -- 账务机构
            ,originaltaxfees -- 原相关税费
            ,lastevaltime -- 估值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_debt_payment_list_op(
            serialno -- 流水号
            ,relativeserialno -- 关联流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,debtrepayassetid -- 抵债资产编号
            ,debtrepayassetname -- 抵债资产名称
            ,debtrepaysum -- 抵扣债权金额
            ,debtoffsetamount -- 抵债金额
            ,receivedate -- 抵债日期
            ,debtrepayassettype -- 抵债资产类型(code:DebtRepaymentType)
            ,debtrepaymenttype -- 抵债类型(code:DebtRepayAssetType)
            ,status -- 处理状态(code:CollectResult)
            ,amount -- 数量
            ,stockcode -- 股票代码/权证号
            ,propertylocation -- 房产位置
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,operateuserid -- 经办客户经理
            ,operateorgid -- 经办客户经理所属机构
            ,operatedate -- 经办时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,putoutorgid -- 账务机构
            ,originaltaxfees -- 原相关税费
            ,lastevaltime -- 估值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.debtrepayassetid, o.debtrepayassetid) as debtrepayassetid -- 抵债资产编号
    ,nvl(n.debtrepayassetname, o.debtrepayassetname) as debtrepayassetname -- 抵债资产名称
    ,nvl(n.debtrepaysum, o.debtrepaysum) as debtrepaysum -- 抵扣债权金额
    ,nvl(n.debtoffsetamount, o.debtoffsetamount) as debtoffsetamount -- 抵债金额
    ,nvl(n.receivedate, o.receivedate) as receivedate -- 抵债日期
    ,nvl(n.debtrepayassettype, o.debtrepayassettype) as debtrepayassettype -- 抵债资产类型(code:DebtRepaymentType)
    ,nvl(n.debtrepaymenttype, o.debtrepaymenttype) as debtrepaymenttype -- 抵债类型(code:DebtRepayAssetType)
    ,nvl(n.status, o.status) as status -- 处理状态(code:CollectResult)
    ,nvl(n.amount, o.amount) as amount -- 数量
    ,nvl(n.stockcode, o.stockcode) as stockcode -- 股票代码/权证号
    ,nvl(n.propertylocation, o.propertylocation) as propertylocation -- 房产位置
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 经办客户经理
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 经办客户经理所属机构
    ,nvl(n.operatedate, o.operatedate) as operatedate -- 经办时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.putoutorgid, o.putoutorgid) as putoutorgid -- 账务机构
    ,nvl(n.originaltaxfees, o.originaltaxfees) as originaltaxfees -- 原相关税费
    ,nvl(n.lastevaltime, o.lastevaltime) as lastevaltime -- 估值日期
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
from (select * from ${iol_schema}.icms_debt_payment_list_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_debt_payment_list where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.relativeserialno <> n.relativeserialno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.debtrepayassetid <> n.debtrepayassetid
        or o.debtrepayassetname <> n.debtrepayassetname
        or o.debtrepaysum <> n.debtrepaysum
        or o.debtoffsetamount <> n.debtoffsetamount
        or o.receivedate <> n.receivedate
        or o.debtrepayassettype <> n.debtrepayassettype
        or o.debtrepaymenttype <> n.debtrepaymenttype
        or o.status <> n.status
        or o.amount <> n.amount
        or o.stockcode <> n.stockcode
        or o.propertylocation <> n.propertylocation
        or o.remark <> n.remark
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.operateuserid <> n.operateuserid
        or o.operateorgid <> n.operateorgid
        or o.operatedate <> n.operatedate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.putoutorgid <> n.putoutorgid
        or o.originaltaxfees <> n.originaltaxfees
        or o.lastevaltime <> n.lastevaltime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_debt_payment_list_cl(
            serialno -- 流水号
            ,relativeserialno -- 关联流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,debtrepayassetid -- 抵债资产编号
            ,debtrepayassetname -- 抵债资产名称
            ,debtrepaysum -- 抵扣债权金额
            ,debtoffsetamount -- 抵债金额
            ,receivedate -- 抵债日期
            ,debtrepayassettype -- 抵债资产类型(code:DebtRepaymentType)
            ,debtrepaymenttype -- 抵债类型(code:DebtRepayAssetType)
            ,status -- 处理状态(code:CollectResult)
            ,amount -- 数量
            ,stockcode -- 股票代码/权证号
            ,propertylocation -- 房产位置
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,operateuserid -- 经办客户经理
            ,operateorgid -- 经办客户经理所属机构
            ,operatedate -- 经办时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,putoutorgid -- 账务机构
            ,originaltaxfees -- 原相关税费
            ,lastevaltime -- 估值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_debt_payment_list_op(
            serialno -- 流水号
            ,relativeserialno -- 关联流水号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,debtrepayassetid -- 抵债资产编号
            ,debtrepayassetname -- 抵债资产名称
            ,debtrepaysum -- 抵扣债权金额
            ,debtoffsetamount -- 抵债金额
            ,receivedate -- 抵债日期
            ,debtrepayassettype -- 抵债资产类型(code:DebtRepaymentType)
            ,debtrepaymenttype -- 抵债类型(code:DebtRepayAssetType)
            ,status -- 处理状态(code:CollectResult)
            ,amount -- 数量
            ,stockcode -- 股票代码/权证号
            ,propertylocation -- 房产位置
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,operateuserid -- 经办客户经理
            ,operateorgid -- 经办客户经理所属机构
            ,operatedate -- 经办时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,putoutorgid -- 账务机构
            ,originaltaxfees -- 原相关税费
            ,lastevaltime -- 估值日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.relativeserialno -- 关联流水号
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.debtrepayassetid -- 抵债资产编号
    ,o.debtrepayassetname -- 抵债资产名称
    ,o.debtrepaysum -- 抵扣债权金额
    ,o.debtoffsetamount -- 抵债金额
    ,o.receivedate -- 抵债日期
    ,o.debtrepayassettype -- 抵债资产类型(code:DebtRepaymentType)
    ,o.debtrepaymenttype -- 抵债类型(code:DebtRepayAssetType)
    ,o.status -- 处理状态(code:CollectResult)
    ,o.amount -- 数量
    ,o.stockcode -- 股票代码/权证号
    ,o.propertylocation -- 房产位置
    ,o.remark -- 备注
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.operateuserid -- 经办客户经理
    ,o.operateorgid -- 经办客户经理所属机构
    ,o.operatedate -- 经办时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.putoutorgid -- 账务机构
    ,o.originaltaxfees -- 原相关税费
    ,o.lastevaltime -- 估值日期
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
from ${iol_schema}.icms_debt_payment_list_bk o
    left join ${iol_schema}.icms_debt_payment_list_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_debt_payment_list_cl d
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
--truncate table ${iol_schema}.icms_debt_payment_list;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_debt_payment_list') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_debt_payment_list drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_debt_payment_list add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_debt_payment_list exchange partition p_${batch_date} with table ${iol_schema}.icms_debt_payment_list_cl;
alter table ${iol_schema}.icms_debt_payment_list exchange partition p_20991231 with table ${iol_schema}.icms_debt_payment_list_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_debt_payment_list to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_debt_payment_list_op purge;
drop table ${iol_schema}.icms_debt_payment_list_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_debt_payment_list_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_debt_payment_list',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
