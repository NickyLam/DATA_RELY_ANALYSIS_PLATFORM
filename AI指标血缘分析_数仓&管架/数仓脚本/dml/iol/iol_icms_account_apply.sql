/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_account_apply
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
create table ${iol_schema}.icms_account_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_account_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_account_apply_op purge;
drop table ${iol_schema}.icms_account_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_account_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_account_apply where 0=1;

create table ${iol_schema}.icms_account_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_account_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_account_apply_cl(
            serialno -- 申请流水号
            ,applyexpain -- 提前还款说明
            ,inputuserid -- 录入人
            ,payaccountno -- 付款账号
            ,isdomeassetstype -- 是否境内资产转让
            ,boughtsum -- 卖出金额
            ,tradecustomer -- 交易对手
            ,inputdate -- 录入日期
            ,accounttype -- 提前还款类型
            ,businesscurrency -- 币种
            ,balance -- 借据余额
            ,flag -- 状态
            ,newdate -- 新期数
            ,removeorderno -- 退保单号
            ,inputorgid -- 录入机构
            ,interestamt -- 清收金额
            ,importcharges -- 汇入手续费
            ,duebillno -- 借据流水号
            ,liquidatedsum -- 违约金
            ,saleratio -- 卖出利率
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,advancerepaytype -- 提前还款类型
            ,businesssum -- 借据金额
            ,repaymentno -- 还款编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,repaytype -- 还款类型
            ,putoutno -- 出账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_account_apply_op(
            serialno -- 申请流水号
            ,applyexpain -- 提前还款说明
            ,inputuserid -- 录入人
            ,payaccountno -- 付款账号
            ,isdomeassetstype -- 是否境内资产转让
            ,boughtsum -- 卖出金额
            ,tradecustomer -- 交易对手
            ,inputdate -- 录入日期
            ,accounttype -- 提前还款类型
            ,businesscurrency -- 币种
            ,balance -- 借据余额
            ,flag -- 状态
            ,newdate -- 新期数
            ,removeorderno -- 退保单号
            ,inputorgid -- 录入机构
            ,interestamt -- 清收金额
            ,importcharges -- 汇入手续费
            ,duebillno -- 借据流水号
            ,liquidatedsum -- 违约金
            ,saleratio -- 卖出利率
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,advancerepaytype -- 提前还款类型
            ,businesssum -- 借据金额
            ,repaymentno -- 还款编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,repaytype -- 还款类型
            ,putoutno -- 出账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.applyexpain, o.applyexpain) as applyexpain -- 提前还款说明
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 录入人
    ,nvl(n.payaccountno, o.payaccountno) as payaccountno -- 付款账号
    ,nvl(n.isdomeassetstype, o.isdomeassetstype) as isdomeassetstype -- 是否境内资产转让
    ,nvl(n.boughtsum, o.boughtsum) as boughtsum -- 卖出金额
    ,nvl(n.tradecustomer, o.tradecustomer) as tradecustomer -- 交易对手
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 录入日期
    ,nvl(n.accounttype, o.accounttype) as accounttype -- 提前还款类型
    ,nvl(n.businesscurrency, o.businesscurrency) as businesscurrency -- 币种
    ,nvl(n.balance, o.balance) as balance -- 借据余额
    ,nvl(n.flag, o.flag) as flag -- 状态
    ,nvl(n.newdate, o.newdate) as newdate -- 新期数
    ,nvl(n.removeorderno, o.removeorderno) as removeorderno -- 退保单号
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 录入机构
    ,nvl(n.interestamt, o.interestamt) as interestamt -- 清收金额
    ,nvl(n.importcharges, o.importcharges) as importcharges -- 汇入手续费
    ,nvl(n.duebillno, o.duebillno) as duebillno -- 借据流水号
    ,nvl(n.liquidatedsum, o.liquidatedsum) as liquidatedsum -- 违约金
    ,nvl(n.saleratio, o.saleratio) as saleratio -- 卖出利率
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.advancerepaytype, o.advancerepaytype) as advancerepaytype -- 提前还款类型
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 借据金额
    ,nvl(n.repaymentno, o.repaymentno) as repaymentno -- 还款编号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.customername, o.customername) as customername -- 客户名称
    ,nvl(n.repaytype, o.repaytype) as repaytype -- 还款类型
    ,nvl(n.putoutno, o.putoutno) as putoutno -- 出账号
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
from (select * from ${iol_schema}.icms_account_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_account_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.applyexpain <> n.applyexpain
        or o.inputuserid <> n.inputuserid
        or o.payaccountno <> n.payaccountno
        or o.isdomeassetstype <> n.isdomeassetstype
        or o.boughtsum <> n.boughtsum
        or o.tradecustomer <> n.tradecustomer
        or o.inputdate <> n.inputdate
        or o.accounttype <> n.accounttype
        or o.businesscurrency <> n.businesscurrency
        or o.balance <> n.balance
        or o.flag <> n.flag
        or o.newdate <> n.newdate
        or o.removeorderno <> n.removeorderno
        or o.inputorgid <> n.inputorgid
        or o.interestamt <> n.interestamt
        or o.importcharges <> n.importcharges
        or o.duebillno <> n.duebillno
        or o.liquidatedsum <> n.liquidatedsum
        or o.saleratio <> n.saleratio
        or o.migtflag <> n.migtflag
        or o.advancerepaytype <> n.advancerepaytype
        or o.businesssum <> n.businesssum
        or o.repaymentno <> n.repaymentno
        or o.customerid <> n.customerid
        or o.customername <> n.customername
        or o.repaytype <> n.repaytype
        or o.putoutno <> n.putoutno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_account_apply_cl(
            serialno -- 申请流水号
            ,applyexpain -- 提前还款说明
            ,inputuserid -- 录入人
            ,payaccountno -- 付款账号
            ,isdomeassetstype -- 是否境内资产转让
            ,boughtsum -- 卖出金额
            ,tradecustomer -- 交易对手
            ,inputdate -- 录入日期
            ,accounttype -- 提前还款类型
            ,businesscurrency -- 币种
            ,balance -- 借据余额
            ,flag -- 状态
            ,newdate -- 新期数
            ,removeorderno -- 退保单号
            ,inputorgid -- 录入机构
            ,interestamt -- 清收金额
            ,importcharges -- 汇入手续费
            ,duebillno -- 借据流水号
            ,liquidatedsum -- 违约金
            ,saleratio -- 卖出利率
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,advancerepaytype -- 提前还款类型
            ,businesssum -- 借据金额
            ,repaymentno -- 还款编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,repaytype -- 还款类型
            ,putoutno -- 出账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_account_apply_op(
            serialno -- 申请流水号
            ,applyexpain -- 提前还款说明
            ,inputuserid -- 录入人
            ,payaccountno -- 付款账号
            ,isdomeassetstype -- 是否境内资产转让
            ,boughtsum -- 卖出金额
            ,tradecustomer -- 交易对手
            ,inputdate -- 录入日期
            ,accounttype -- 提前还款类型
            ,businesscurrency -- 币种
            ,balance -- 借据余额
            ,flag -- 状态
            ,newdate -- 新期数
            ,removeorderno -- 退保单号
            ,inputorgid -- 录入机构
            ,interestamt -- 清收金额
            ,importcharges -- 汇入手续费
            ,duebillno -- 借据流水号
            ,liquidatedsum -- 违约金
            ,saleratio -- 卖出利率
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,advancerepaytype -- 提前还款类型
            ,businesssum -- 借据金额
            ,repaymentno -- 还款编号
            ,customerid -- 客户编号
            ,customername -- 客户名称
            ,repaytype -- 还款类型
            ,putoutno -- 出账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 申请流水号
    ,o.applyexpain -- 提前还款说明
    ,o.inputuserid -- 录入人
    ,o.payaccountno -- 付款账号
    ,o.isdomeassetstype -- 是否境内资产转让
    ,o.boughtsum -- 卖出金额
    ,o.tradecustomer -- 交易对手
    ,o.inputdate -- 录入日期
    ,o.accounttype -- 提前还款类型
    ,o.businesscurrency -- 币种
    ,o.balance -- 借据余额
    ,o.flag -- 状态
    ,o.newdate -- 新期数
    ,o.removeorderno -- 退保单号
    ,o.inputorgid -- 录入机构
    ,o.interestamt -- 清收金额
    ,o.importcharges -- 汇入手续费
    ,o.duebillno -- 借据流水号
    ,o.liquidatedsum -- 违约金
    ,o.saleratio -- 卖出利率
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.advancerepaytype -- 提前还款类型
    ,o.businesssum -- 借据金额
    ,o.repaymentno -- 还款编号
    ,o.customerid -- 客户编号
    ,o.customername -- 客户名称
    ,o.repaytype -- 还款类型
    ,o.putoutno -- 出账号
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
from ${iol_schema}.icms_account_apply_bk o
    left join ${iol_schema}.icms_account_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_account_apply_cl d
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
--truncate table ${iol_schema}.icms_account_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_account_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_account_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_account_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_account_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_account_apply_cl;
alter table ${iol_schema}.icms_account_apply exchange partition p_20991231 with table ${iol_schema}.icms_account_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_account_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_account_apply_op purge;
drop table ${iol_schema}.icms_account_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_account_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_account_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
