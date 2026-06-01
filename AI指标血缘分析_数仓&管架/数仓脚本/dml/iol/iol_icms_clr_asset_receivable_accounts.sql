/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_asset_receivable_accounts
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
create table ${iol_schema}.icms_clr_asset_receivable_accounts_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_asset_receivable_accounts
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_receivable_accounts_op purge;
drop table ${iol_schema}.icms_clr_asset_receivable_accounts_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_asset_receivable_accounts_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_receivable_accounts where 0=1;

create table ${iol_schema}.icms_clr_asset_receivable_accounts_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_asset_receivable_accounts where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_receivable_accounts_cl(
            clrid -- 押品编号
            ,creditno -- 信用证号码
            ,faceamount -- 应收账款金额/信用证金额(票面金额)
            ,tdcurrency -- 币种
            ,billno -- 发票编号
            ,startdate -- 发票日期
            ,duedate -- 发票到期日
            ,payor -- 付款人名称
            ,payoraccount -- 付款人账号
            ,ishandle -- 是否被破产清算
            ,isnotice -- 是否通知应收账款义务人
            ,isproduce -- 是否由销售、出租、或提供服务产生债权
            ,isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
            ,remark -- 其他说明
            ,usedtime -- 账龄
            ,payee -- 应收账款收款人名称
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,applyusername -- 开证申请人名称
            ,benefitusername -- 受益人名称
            ,registcountry -- 开证行所在国家或地区
            ,guarantyregno -- 人行质押登记证明编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_receivable_accounts_op(
            clrid -- 押品编号
            ,creditno -- 信用证号码
            ,faceamount -- 应收账款金额/信用证金额(票面金额)
            ,tdcurrency -- 币种
            ,billno -- 发票编号
            ,startdate -- 发票日期
            ,duedate -- 发票到期日
            ,payor -- 付款人名称
            ,payoraccount -- 付款人账号
            ,ishandle -- 是否被破产清算
            ,isnotice -- 是否通知应收账款义务人
            ,isproduce -- 是否由销售、出租、或提供服务产生债权
            ,isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
            ,remark -- 其他说明
            ,usedtime -- 账龄
            ,payee -- 应收账款收款人名称
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,applyusername -- 开证申请人名称
            ,benefitusername -- 受益人名称
            ,registcountry -- 开证行所在国家或地区
            ,guarantyregno -- 人行质押登记证明编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.creditno, o.creditno) as creditno -- 信用证号码
    ,nvl(n.faceamount, o.faceamount) as faceamount -- 应收账款金额/信用证金额(票面金额)
    ,nvl(n.tdcurrency, o.tdcurrency) as tdcurrency -- 币种
    ,nvl(n.billno, o.billno) as billno -- 发票编号
    ,nvl(n.startdate, o.startdate) as startdate -- 发票日期
    ,nvl(n.duedate, o.duedate) as duedate -- 发票到期日
    ,nvl(n.payor, o.payor) as payor -- 付款人名称
    ,nvl(n.payoraccount, o.payoraccount) as payoraccount -- 付款人账号
    ,nvl(n.ishandle, o.ishandle) as ishandle -- 是否被破产清算
    ,nvl(n.isnotice, o.isnotice) as isnotice -- 是否通知应收账款义务人
    ,nvl(n.isproduce, o.isproduce) as isproduce -- 是否由销售、出租、或提供服务产生债权
    ,nvl(n.isrelation2, o.isrelation2) as isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
    ,nvl(n.remark, o.remark) as remark -- 其他说明
    ,nvl(n.usedtime, o.usedtime) as usedtime -- 账龄
    ,nvl(n.payee, o.payee) as payee -- 应收账款收款人名称
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,nvl(n.applyusername, o.applyusername) as applyusername -- 开证申请人名称
    ,nvl(n.benefitusername, o.benefitusername) as benefitusername -- 受益人名称
    ,nvl(n.registcountry, o.registcountry) as registcountry -- 开证行所在国家或地区
    ,nvl(n.guarantyregno, o.guarantyregno) as guarantyregno -- 人行质押登记证明编号
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
from (select * from ${iol_schema}.icms_clr_asset_receivable_accounts_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_asset_receivable_accounts where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.creditno <> n.creditno
        or o.faceamount <> n.faceamount
        or o.tdcurrency <> n.tdcurrency
        or o.billno <> n.billno
        or o.startdate <> n.startdate
        or o.duedate <> n.duedate
        or o.payor <> n.payor
        or o.payoraccount <> n.payoraccount
        or o.ishandle <> n.ishandle
        or o.isnotice <> n.isnotice
        or o.isproduce <> n.isproduce
        or o.isrelation2 <> n.isrelation2
        or o.remark <> n.remark
        or o.usedtime <> n.usedtime
        or o.payee <> n.payee
        or o.migtflag <> n.migtflag
        or o.applyusername <> n.applyusername
        or o.benefitusername <> n.benefitusername
        or o.registcountry <> n.registcountry
        or o.guarantyregno <> n.guarantyregno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_asset_receivable_accounts_cl(
            clrid -- 押品编号
            ,creditno -- 信用证号码
            ,faceamount -- 应收账款金额/信用证金额(票面金额)
            ,tdcurrency -- 币种
            ,billno -- 发票编号
            ,startdate -- 发票日期
            ,duedate -- 发票到期日
            ,payor -- 付款人名称
            ,payoraccount -- 付款人账号
            ,ishandle -- 是否被破产清算
            ,isnotice -- 是否通知应收账款义务人
            ,isproduce -- 是否由销售、出租、或提供服务产生债权
            ,isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
            ,remark -- 其他说明
            ,usedtime -- 账龄
            ,payee -- 应收账款收款人名称
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,applyusername -- 开证申请人名称
            ,benefitusername -- 受益人名称
            ,registcountry -- 开证行所在国家或地区
            ,guarantyregno -- 人行质押登记证明编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_asset_receivable_accounts_op(
            clrid -- 押品编号
            ,creditno -- 信用证号码
            ,faceamount -- 应收账款金额/信用证金额(票面金额)
            ,tdcurrency -- 币种
            ,billno -- 发票编号
            ,startdate -- 发票日期
            ,duedate -- 发票到期日
            ,payor -- 付款人名称
            ,payoraccount -- 付款人账号
            ,ishandle -- 是否被破产清算
            ,isnotice -- 是否通知应收账款义务人
            ,isproduce -- 是否由销售、出租、或提供服务产生债权
            ,isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
            ,remark -- 其他说明
            ,usedtime -- 账龄
            ,payee -- 应收账款收款人名称
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,applyusername -- 开证申请人名称
            ,benefitusername -- 受益人名称
            ,registcountry -- 开证行所在国家或地区
            ,guarantyregno -- 人行质押登记证明编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.creditno -- 信用证号码
    ,o.faceamount -- 应收账款金额/信用证金额(票面金额)
    ,o.tdcurrency -- 币种
    ,o.billno -- 发票编号
    ,o.startdate -- 发票日期
    ,o.duedate -- 发票到期日
    ,o.payor -- 付款人名称
    ,o.payoraccount -- 付款人账号
    ,o.ishandle -- 是否被破产清算
    ,o.isnotice -- 是否通知应收账款义务人
    ,o.isproduce -- 是否由销售、出租、或提供服务产生债权
    ,o.isrelation2 -- 是否与证券化、从属参与或信用衍生工具相关
    ,o.remark -- 其他说明
    ,o.usedtime -- 账龄
    ,o.payee -- 应收账款收款人名称
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
    ,o.applyusername -- 开证申请人名称
    ,o.benefitusername -- 受益人名称
    ,o.registcountry -- 开证行所在国家或地区
    ,o.guarantyregno -- 人行质押登记证明编号
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
from ${iol_schema}.icms_clr_asset_receivable_accounts_bk o
    left join ${iol_schema}.icms_clr_asset_receivable_accounts_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_asset_receivable_accounts_cl d
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
--truncate table ${iol_schema}.icms_clr_asset_receivable_accounts;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_asset_receivable_accounts') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_asset_receivable_accounts drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_asset_receivable_accounts add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_asset_receivable_accounts exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_asset_receivable_accounts_cl;
alter table ${iol_schema}.icms_clr_asset_receivable_accounts exchange partition p_20991231 with table ${iol_schema}.icms_clr_asset_receivable_accounts_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_asset_receivable_accounts to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_asset_receivable_accounts_op purge;
drop table ${iol_schema}.icms_clr_asset_receivable_accounts_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_asset_receivable_accounts_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_asset_receivable_accounts',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
