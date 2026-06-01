/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_lx_repayment_plan
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
create table ${iol_schema}.icms_lx_repayment_plan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_lx_repayment_plan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_repayment_plan_op purge;
drop table ${iol_schema}.icms_lx_repayment_plan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_repayment_plan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_repayment_plan where 0=1;

create table ${iol_schema}.icms_lx_repayment_plan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_lx_repayment_plan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lx_repayment_plan_cl(
            assetid -- 资产号
            ,capitalloanno -- 借据号
            ,paydate -- 付款时间
            ,payableday -- 应还款日
            ,curstageno -- 当前期数
            ,repaypriamt -- 应还本金
            ,payint -- 应还利息
            ,guarantyfee -- 担保费
            ,simulationfee -- 咨询服务费
            ,creditassessfee -- 信用评估费
            ,interest -- 计提利息
            ,attribute1 -- 备用字段
            ,lxbusinesssum -- 实还本金
            ,lxintamt -- 实还利息
            ,realamounttotal -- 实还金额总额(期数)
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,prinbal -- 本金余额
            ,intbal -- 利息余额
            ,status -- 状态标志(0-正常未到期,1-正常已还清,2-逾期)
            ,cleardate -- 结清日期
            ,loanterm -- 总期数
            ,customerid -- 客户号
            ,productid -- 产品号
            ,intedate -- 起息日期
            ,currency -- 币种
            ,periodpaydate -- 宽限日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lx_repayment_plan_op(
            assetid -- 资产号
            ,capitalloanno -- 借据号
            ,paydate -- 付款时间
            ,payableday -- 应还款日
            ,curstageno -- 当前期数
            ,repaypriamt -- 应还本金
            ,payint -- 应还利息
            ,guarantyfee -- 担保费
            ,simulationfee -- 咨询服务费
            ,creditassessfee -- 信用评估费
            ,interest -- 计提利息
            ,attribute1 -- 备用字段
            ,lxbusinesssum -- 实还本金
            ,lxintamt -- 实还利息
            ,realamounttotal -- 实还金额总额(期数)
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,prinbal -- 本金余额
            ,intbal -- 利息余额
            ,status -- 状态标志(0-正常未到期,1-正常已还清,2-逾期)
            ,cleardate -- 结清日期
            ,loanterm -- 总期数
            ,customerid -- 客户号
            ,productid -- 产品号
            ,intedate -- 起息日期
            ,currency -- 币种
            ,periodpaydate -- 宽限日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.assetid, o.assetid) as assetid -- 资产号
    ,nvl(n.capitalloanno, o.capitalloanno) as capitalloanno -- 借据号
    ,nvl(n.paydate, o.paydate) as paydate -- 付款时间
    ,nvl(n.payableday, o.payableday) as payableday -- 应还款日
    ,nvl(n.curstageno, o.curstageno) as curstageno -- 当前期数
    ,nvl(n.repaypriamt, o.repaypriamt) as repaypriamt -- 应还本金
    ,nvl(n.payint, o.payint) as payint -- 应还利息
    ,nvl(n.guarantyfee, o.guarantyfee) as guarantyfee -- 担保费
    ,nvl(n.simulationfee, o.simulationfee) as simulationfee -- 咨询服务费
    ,nvl(n.creditassessfee, o.creditassessfee) as creditassessfee -- 信用评估费
    ,nvl(n.interest, o.interest) as interest -- 计提利息
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 备用字段
    ,nvl(n.lxbusinesssum, o.lxbusinesssum) as lxbusinesssum -- 实还本金
    ,nvl(n.lxintamt, o.lxintamt) as lxintamt -- 实还利息
    ,nvl(n.realamounttotal, o.realamounttotal) as realamounttotal -- 实还金额总额(期数)
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.prinbal, o.prinbal) as prinbal -- 本金余额
    ,nvl(n.intbal, o.intbal) as intbal -- 利息余额
    ,nvl(n.status, o.status) as status -- 状态标志(0-正常未到期,1-正常已还清,2-逾期)
    ,nvl(n.cleardate, o.cleardate) as cleardate -- 结清日期
    ,nvl(n.loanterm, o.loanterm) as loanterm -- 总期数
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.productid, o.productid) as productid -- 产品号
    ,nvl(n.intedate, o.intedate) as intedate -- 起息日期
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.periodpaydate, o.periodpaydate) as periodpaydate -- 宽限日期
    ,case when
            n.assetid is null
            and n.capitalloanno is null
            and n.curstageno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.assetid is null
            and n.capitalloanno is null
            and n.curstageno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.assetid is null
            and n.capitalloanno is null
            and n.curstageno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_lx_repayment_plan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_lx_repayment_plan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.assetid = n.assetid
            and o.capitalloanno = n.capitalloanno
            and o.curstageno = n.curstageno
where (
        o.assetid is null
        and o.capitalloanno is null
        and o.curstageno is null
    )
    or (
        n.assetid is null
        and n.capitalloanno is null
        and n.curstageno is null
    )
    or (
        o.paydate <> n.paydate
        or o.payableday <> n.payableday
        or o.repaypriamt <> n.repaypriamt
        or o.payint <> n.payint
        or o.guarantyfee <> n.guarantyfee
        or o.simulationfee <> n.simulationfee
        or o.creditassessfee <> n.creditassessfee
        or o.interest <> n.interest
        or o.attribute1 <> n.attribute1
        or o.lxbusinesssum <> n.lxbusinesssum
        or o.lxintamt <> n.lxintamt
        or o.realamounttotal <> n.realamounttotal
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.prinbal <> n.prinbal
        or o.intbal <> n.intbal
        or o.status <> n.status
        or o.cleardate <> n.cleardate
        or o.loanterm <> n.loanterm
        or o.customerid <> n.customerid
        or o.productid <> n.productid
        or o.intedate <> n.intedate
        or o.currency <> n.currency
        or o.periodpaydate <> n.periodpaydate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_lx_repayment_plan_cl(
            assetid -- 资产号
            ,capitalloanno -- 借据号
            ,paydate -- 付款时间
            ,payableday -- 应还款日
            ,curstageno -- 当前期数
            ,repaypriamt -- 应还本金
            ,payint -- 应还利息
            ,guarantyfee -- 担保费
            ,simulationfee -- 咨询服务费
            ,creditassessfee -- 信用评估费
            ,interest -- 计提利息
            ,attribute1 -- 备用字段
            ,lxbusinesssum -- 实还本金
            ,lxintamt -- 实还利息
            ,realamounttotal -- 实还金额总额(期数)
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,prinbal -- 本金余额
            ,intbal -- 利息余额
            ,status -- 状态标志(0-正常未到期,1-正常已还清,2-逾期)
            ,cleardate -- 结清日期
            ,loanterm -- 总期数
            ,customerid -- 客户号
            ,productid -- 产品号
            ,intedate -- 起息日期
            ,currency -- 币种
            ,periodpaydate -- 宽限日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_lx_repayment_plan_op(
            assetid -- 资产号
            ,capitalloanno -- 借据号
            ,paydate -- 付款时间
            ,payableday -- 应还款日
            ,curstageno -- 当前期数
            ,repaypriamt -- 应还本金
            ,payint -- 应还利息
            ,guarantyfee -- 担保费
            ,simulationfee -- 咨询服务费
            ,creditassessfee -- 信用评估费
            ,interest -- 计提利息
            ,attribute1 -- 备用字段
            ,lxbusinesssum -- 实还本金
            ,lxintamt -- 实还利息
            ,realamounttotal -- 实还金额总额(期数)
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新日期
            ,prinbal -- 本金余额
            ,intbal -- 利息余额
            ,status -- 状态标志(0-正常未到期,1-正常已还清,2-逾期)
            ,cleardate -- 结清日期
            ,loanterm -- 总期数
            ,customerid -- 客户号
            ,productid -- 产品号
            ,intedate -- 起息日期
            ,currency -- 币种
            ,periodpaydate -- 宽限日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.assetid -- 资产号
    ,o.capitalloanno -- 借据号
    ,o.paydate -- 付款时间
    ,o.payableday -- 应还款日
    ,o.curstageno -- 当前期数
    ,o.repaypriamt -- 应还本金
    ,o.payint -- 应还利息
    ,o.guarantyfee -- 担保费
    ,o.simulationfee -- 咨询服务费
    ,o.creditassessfee -- 信用评估费
    ,o.interest -- 计提利息
    ,o.attribute1 -- 备用字段
    ,o.lxbusinesssum -- 实还本金
    ,o.lxintamt -- 实还利息
    ,o.realamounttotal -- 实还金额总额(期数)
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新日期
    ,o.prinbal -- 本金余额
    ,o.intbal -- 利息余额
    ,o.status -- 状态标志(0-正常未到期,1-正常已还清,2-逾期)
    ,o.cleardate -- 结清日期
    ,o.loanterm -- 总期数
    ,o.customerid -- 客户号
    ,o.productid -- 产品号
    ,o.intedate -- 起息日期
    ,o.currency -- 币种
    ,o.periodpaydate -- 宽限日期
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
from ${iol_schema}.icms_lx_repayment_plan_bk o
    left join ${iol_schema}.icms_lx_repayment_plan_op n
        on
            o.assetid = n.assetid
            and o.capitalloanno = n.capitalloanno
            and o.curstageno = n.curstageno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_lx_repayment_plan_cl d
        on
            o.assetid = d.assetid
            and o.capitalloanno = d.capitalloanno
            and o.curstageno = d.curstageno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_lx_repayment_plan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_lx_repayment_plan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_lx_repayment_plan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_lx_repayment_plan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_lx_repayment_plan exchange partition p_${batch_date} with table ${iol_schema}.icms_lx_repayment_plan_cl;
alter table ${iol_schema}.icms_lx_repayment_plan exchange partition p_20991231 with table ${iol_schema}.icms_lx_repayment_plan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_lx_repayment_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_lx_repayment_plan_op purge;
drop table ${iol_schema}.icms_lx_repayment_plan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_lx_repayment_plan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_lx_repayment_plan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
