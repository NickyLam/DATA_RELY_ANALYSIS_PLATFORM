/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_finance_deposit
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
create table ${iol_schema}.icms_clr_asset_finance_deposit_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_finance_deposit
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_deposit_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_deposit_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_finance_deposit_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_deposit where 0=1;

create table ${iol_schema}.icms_clr_asset_finance_deposit_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_finance_deposit where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_deposit_cl(
            clrid -- 押品编号
            ,deposittype -- 存单类型
            ,currency -- 币种
            ,buyaccount -- 认购账号
            ,account -- 止付账号
            ,subaccount -- 子账户号
            ,accountname -- 账户名称
            ,bankname -- 银行名称
            ,certificateno -- 存单凭证号
            ,depositsum -- 存单金额
            ,usebalance -- 账户可用余额
            ,pledgesum -- 质押金额
            ,startdate -- 生效日
            ,valuedate -- 起息日
            ,enddate -- 到期日
            ,rate -- 存单利率
            ,depositdays -- 存期（天）
            ,remark -- 其他说明
            ,stoppayno -- 止付通知书编号
            ,productid -- 产品编号
            ,productname -- 产品名称
            ,payinttype -- 付息方式
            ,customerid -- 客户编号
            ,liabaccount -- 负债账号
            ,registcountry -- 银行注册地所在国家或地区
            ,inratingresult -- 银行的内部评级结果
            ,inratingdate -- 银行的内部评级日期
            ,outratingresult -- 银行的外部评级结果
            ,outratingdate -- 银行的外部评级日期
            ,depositstatus -- 存单状态
            ,backnbr -- 核心限制流水号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,vouchertype -- 凭证类型
            ,acctbranchorgid -- 存单开户机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_deposit_op(
            clrid -- 押品编号
            ,deposittype -- 存单类型
            ,currency -- 币种
            ,buyaccount -- 认购账号
            ,account -- 止付账号
            ,subaccount -- 子账户号
            ,accountname -- 账户名称
            ,bankname -- 银行名称
            ,certificateno -- 存单凭证号
            ,depositsum -- 存单金额
            ,usebalance -- 账户可用余额
            ,pledgesum -- 质押金额
            ,startdate -- 生效日
            ,valuedate -- 起息日
            ,enddate -- 到期日
            ,rate -- 存单利率
            ,depositdays -- 存期（天）
            ,remark -- 其他说明
            ,stoppayno -- 止付通知书编号
            ,productid -- 产品编号
            ,productname -- 产品名称
            ,payinttype -- 付息方式
            ,customerid -- 客户编号
            ,liabaccount -- 负债账号
            ,registcountry -- 银行注册地所在国家或地区
            ,inratingresult -- 银行的内部评级结果
            ,inratingdate -- 银行的内部评级日期
            ,outratingresult -- 银行的外部评级结果
            ,outratingdate -- 银行的外部评级日期
            ,depositstatus -- 存单状态
            ,backnbr -- 核心限制流水号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,vouchertype -- 凭证类型
            ,acctbranchorgid -- 存单开户机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.deposittype, o.deposittype) as deposittype -- 存单类型
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.buyaccount, o.buyaccount) as buyaccount -- 认购账号
    ,nvl(n.account, o.account) as account -- 止付账号
    ,nvl(n.subaccount, o.subaccount) as subaccount -- 子账户号
    ,nvl(n.accountname, o.accountname) as accountname -- 账户名称
    ,nvl(n.bankname, o.bankname) as bankname -- 银行名称
    ,nvl(n.certificateno, o.certificateno) as certificateno -- 存单凭证号
    ,nvl(n.depositsum, o.depositsum) as depositsum -- 存单金额
    ,nvl(n.usebalance, o.usebalance) as usebalance -- 账户可用余额
    ,nvl(n.pledgesum, o.pledgesum) as pledgesum -- 质押金额
    ,nvl(n.startdate, o.startdate) as startdate -- 生效日
    ,nvl(n.valuedate, o.valuedate) as valuedate -- 起息日
    ,nvl(n.enddate, o.enddate) as enddate -- 到期日
    ,nvl(n.rate, o.rate) as rate -- 存单利率
    ,nvl(n.depositdays, o.depositdays) as depositdays -- 存期（天）
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.stoppayno, o.stoppayno) as stoppayno -- 止付通知书编号
    ,nvl(n.productid, o.productid) as productid -- 产品编号
    ,nvl(n.productname, o.productname) as productname -- 产品名称
    ,nvl(n.payinttype, o.payinttype) as payinttype -- 付息方式
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.liabaccount, o.liabaccount) as liabaccount -- 负债账号
    ,nvl(n.registcountry, o.registcountry) as registcountry -- 银行注册地所在国家或地区
    ,nvl(n.inratingresult, o.inratingresult) as inratingresult -- 银行的内部评级结果
    ,nvl(n.inratingdate, o.inratingdate) as inratingdate -- 银行的内部评级日期
    ,nvl(n.outratingresult, o.outratingresult) as outratingresult -- 银行的外部评级结果
    ,nvl(n.outratingdate, o.outratingdate) as outratingdate -- 银行的外部评级日期
    ,nvl(n.depositstatus, o.depositstatus) as depositstatus -- 存单状态
    ,nvl(n.backnbr, o.backnbr) as backnbr -- 核心限制流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,nvl(n.vouchertype, o.vouchertype) as vouchertype -- 凭证类型
    ,nvl(n.acctbranchorgid, o.acctbranchorgid) as acctbranchorgid -- 存单开户机构编号
    ,case when
            n.clrid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clrid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clrid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_asset_finance_deposit_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_finance_deposit where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.deposittype <> n.deposittype
        or o.currency <> n.currency
        or o.buyaccount <> n.buyaccount
        or o.account <> n.account
        or o.subaccount <> n.subaccount
        or o.accountname <> n.accountname
        or o.bankname <> n.bankname
        or o.certificateno <> n.certificateno
        or o.depositsum <> n.depositsum
        or o.usebalance <> n.usebalance
        or o.pledgesum <> n.pledgesum
        or o.startdate <> n.startdate
        or o.valuedate <> n.valuedate
        or o.enddate <> n.enddate
        or o.rate <> n.rate
        or o.depositdays <> n.depositdays
        or o.remark <> n.remark
        or o.stoppayno <> n.stoppayno
        or o.productid <> n.productid
        or o.productname <> n.productname
        or o.payinttype <> n.payinttype
        or o.customerid <> n.customerid
        or o.liabaccount <> n.liabaccount
        or o.registcountry <> n.registcountry
        or o.inratingresult <> n.inratingresult
        or o.inratingdate <> n.inratingdate
        or o.outratingresult <> n.outratingresult
        or o.outratingdate <> n.outratingdate
        or o.depositstatus <> n.depositstatus
        or o.backnbr <> n.backnbr
        or o.migtflag <> n.migtflag
        or o.vouchertype <> n.vouchertype
        or o.acctbranchorgid <> n.acctbranchorgid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_finance_deposit_cl(
            clrid -- 押品编号
            ,deposittype -- 存单类型
            ,currency -- 币种
            ,buyaccount -- 认购账号
            ,account -- 止付账号
            ,subaccount -- 子账户号
            ,accountname -- 账户名称
            ,bankname -- 银行名称
            ,certificateno -- 存单凭证号
            ,depositsum -- 存单金额
            ,usebalance -- 账户可用余额
            ,pledgesum -- 质押金额
            ,startdate -- 生效日
            ,valuedate -- 起息日
            ,enddate -- 到期日
            ,rate -- 存单利率
            ,depositdays -- 存期（天）
            ,remark -- 其他说明
            ,stoppayno -- 止付通知书编号
            ,productid -- 产品编号
            ,productname -- 产品名称
            ,payinttype -- 付息方式
            ,customerid -- 客户编号
            ,liabaccount -- 负债账号
            ,registcountry -- 银行注册地所在国家或地区
            ,inratingresult -- 银行的内部评级结果
            ,inratingdate -- 银行的内部评级日期
            ,outratingresult -- 银行的外部评级结果
            ,outratingdate -- 银行的外部评级日期
            ,depositstatus -- 存单状态
            ,backnbr -- 核心限制流水号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,vouchertype -- 凭证类型
            ,acctbranchorgid -- 存单开户机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_finance_deposit_op(
            clrid -- 押品编号
            ,deposittype -- 存单类型
            ,currency -- 币种
            ,buyaccount -- 认购账号
            ,account -- 止付账号
            ,subaccount -- 子账户号
            ,accountname -- 账户名称
            ,bankname -- 银行名称
            ,certificateno -- 存单凭证号
            ,depositsum -- 存单金额
            ,usebalance -- 账户可用余额
            ,pledgesum -- 质押金额
            ,startdate -- 生效日
            ,valuedate -- 起息日
            ,enddate -- 到期日
            ,rate -- 存单利率
            ,depositdays -- 存期（天）
            ,remark -- 其他说明
            ,stoppayno -- 止付通知书编号
            ,productid -- 产品编号
            ,productname -- 产品名称
            ,payinttype -- 付息方式
            ,customerid -- 客户编号
            ,liabaccount -- 负债账号
            ,registcountry -- 银行注册地所在国家或地区
            ,inratingresult -- 银行的内部评级结果
            ,inratingdate -- 银行的内部评级日期
            ,outratingresult -- 银行的外部评级结果
            ,outratingdate -- 银行的外部评级日期
            ,depositstatus -- 存单状态
            ,backnbr -- 核心限制流水号
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,vouchertype -- 凭证类型
            ,acctbranchorgid -- 存单开户机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.deposittype -- 存单类型
    ,o.currency -- 币种
    ,o.buyaccount -- 认购账号
    ,o.account -- 止付账号
    ,o.subaccount -- 子账户号
    ,o.accountname -- 账户名称
    ,o.bankname -- 银行名称
    ,o.certificateno -- 存单凭证号
    ,o.depositsum -- 存单金额
    ,o.usebalance -- 账户可用余额
    ,o.pledgesum -- 质押金额
    ,o.startdate -- 生效日
    ,o.valuedate -- 起息日
    ,o.enddate -- 到期日
    ,o.rate -- 存单利率
    ,o.depositdays -- 存期（天）
    ,o.remark -- 其他说明
    ,o.stoppayno -- 止付通知书编号
    ,o.productid -- 产品编号
    ,o.productname -- 产品名称
    ,o.payinttype -- 付息方式
    ,o.customerid -- 客户编号
    ,o.liabaccount -- 负债账号
    ,o.registcountry -- 银行注册地所在国家或地区
    ,o.inratingresult -- 银行的内部评级结果
    ,o.inratingdate -- 银行的内部评级日期
    ,o.outratingresult -- 银行的外部评级结果
    ,o.outratingdate -- 银行的外部评级日期
    ,o.depositstatus -- 存单状态
    ,o.backnbr -- 核心限制流水号
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
    ,o.vouchertype -- 凭证类型
    ,o.acctbranchorgid -- 存单开户机构编号
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
from ${iol_schema}.icms_clr_asset_finance_deposit_bk o
    left join ${iol_schema}.icms_clr_asset_finance_deposit_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_finance_deposit_cl d
        on
            o.clrid = d.clrid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_asset_finance_deposit;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_finance_deposit') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_finance_deposit drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_finance_deposit add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_finance_deposit exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_finance_deposit_cl;
alter table ${iol_schema}.icms_clr_asset_finance_deposit exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_finance_deposit_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_finance_deposit to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_finance_deposit_op purge;
drop table ${iol_schema}.icms_clr_asset_finance_deposit_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_finance_deposit_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_finance_deposit',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
