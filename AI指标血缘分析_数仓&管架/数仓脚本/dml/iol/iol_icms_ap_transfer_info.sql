/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_transfer_info
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
create table ${iol_schema}.icms_ap_transfer_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_transfer_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_transfer_info_op purge;
drop table ${iol_schema}.icms_ap_transfer_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_transfer_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_transfer_info where 0=1;

create table ${iol_schema}.icms_ap_transfer_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_transfer_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_transfer_info_cl(
            programno -- 方案编号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,productid -- 产品编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,classifyresult -- 贷款五级分类
            ,currency -- 币种TRI
            ,businesssum -- 放款金额
            ,balance -- 贷款余额
            ,ysintamt -- 应收欠息
            ,yjodiamt -- 应计复息
            ,ysodpamt -- 应收罚息
            ,transfermoney -- 转让金额
            ,settlementaccount -- 结算账号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人"
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_transfer_info_op(
            programno -- 方案编号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,productid -- 产品编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,classifyresult -- 贷款五级分类
            ,currency -- 币种TRI
            ,businesssum -- 放款金额
            ,balance -- 贷款余额
            ,ysintamt -- 应收欠息
            ,yjodiamt -- 应计复息
            ,ysodpamt -- 应收罚息
            ,transfermoney -- 转让金额
            ,settlementaccount -- 结算账号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人"
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.programno, o.programno) as programno -- 方案编号
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.classifyresult, o.classifyresult) as classifyresult -- 贷款五级分类
    ,nvl(n.currency, o.currency) as currency -- 币种TRI
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 放款金额
    ,nvl(n.balance, o.balance) as balance -- 贷款余额
    ,nvl(n.ysintamt, o.ysintamt) as ysintamt -- 应收欠息
    ,nvl(n.yjodiamt, o.yjodiamt) as yjodiamt -- 应计复息
    ,nvl(n.ysodpamt, o.ysodpamt) as ysodpamt -- 应收罚息
    ,nvl(n.transfermoney, o.transfermoney) as transfermoney -- 转让金额
    ,nvl(n.settlementaccount, o.settlementaccount) as settlementaccount -- 结算账号
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人"
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,case when
            n.programno is null
            and n.objectno is null
            and n.objecttype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.programno is null
            and n.objectno is null
            and n.objecttype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.programno is null
            and n.objectno is null
            and n.objecttype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_transfer_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_transfer_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.programno = n.programno
            and o.objectno = n.objectno
            and o.objecttype = n.objecttype
where (
        o.programno is null
        and o.objectno is null
        and o.objecttype is null
    )
    or (
        n.programno is null
        and n.objectno is null
        and n.objecttype is null
    )
    or (
        o.productid <> n.productid
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.classifyresult <> n.classifyresult
        or o.currency <> n.currency
        or o.businesssum <> n.businesssum
        or o.balance <> n.balance
        or o.ysintamt <> n.ysintamt
        or o.yjodiamt <> n.yjodiamt
        or o.ysodpamt <> n.ysodpamt
        or o.transfermoney <> n.transfermoney
        or o.settlementaccount <> n.settlementaccount
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
        into ${iol_schema}.icms_ap_transfer_info_cl(
            programno -- 方案编号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,productid -- 产品编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,classifyresult -- 贷款五级分类
            ,currency -- 币种TRI
            ,businesssum -- 放款金额
            ,balance -- 贷款余额
            ,ysintamt -- 应收欠息
            ,yjodiamt -- 应计复息
            ,ysodpamt -- 应收罚息
            ,transfermoney -- 转让金额
            ,settlementaccount -- 结算账号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人"
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_transfer_info_op(
            programno -- 方案编号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,productid -- 产品编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,classifyresult -- 贷款五级分类
            ,currency -- 币种TRI
            ,businesssum -- 放款金额
            ,balance -- 贷款余额
            ,ysintamt -- 应收欠息
            ,yjodiamt -- 应计复息
            ,ysodpamt -- 应收罚息
            ,transfermoney -- 转让金额
            ,settlementaccount -- 结算账号
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人"
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.programno -- 方案编号
    ,o.objectno -- 对象编号
    ,o.objecttype -- 对象类型
    ,o.productid -- 产品编号
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.classifyresult -- 贷款五级分类
    ,o.currency -- 币种TRI
    ,o.businesssum -- 放款金额
    ,o.balance -- 贷款余额
    ,o.ysintamt -- 应收欠息
    ,o.yjodiamt -- 应计复息
    ,o.ysodpamt -- 应收罚息
    ,o.transfermoney -- 转让金额
    ,o.settlementaccount -- 结算账号
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人"
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
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
from ${iol_schema}.icms_ap_transfer_info_bk o
    left join ${iol_schema}.icms_ap_transfer_info_op n
        on
            o.programno = n.programno
            and o.objectno = n.objectno
            and o.objecttype = n.objecttype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_transfer_info_cl d
        on
            o.programno = d.programno
            and o.objectno = d.objectno
            and o.objecttype = d.objecttype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_transfer_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_transfer_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_transfer_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_transfer_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_transfer_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_transfer_info_cl;
alter table ${iol_schema}.icms_ap_transfer_info exchange partition p_20991231 with table ${iol_schema}.icms_ap_transfer_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_transfer_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_transfer_info_op purge;
drop table ${iol_schema}.icms_ap_transfer_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_transfer_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_transfer_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
