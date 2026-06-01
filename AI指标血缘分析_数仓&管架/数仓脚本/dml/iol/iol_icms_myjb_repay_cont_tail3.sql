/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myjb_repay_cont_tail3
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.icms_myjb_repay_cont_tail3_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_myjb_repay_cont_tail3
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myjb_repay_cont_tail3_op purge;
drop table ${iol_schema}.icms_myjb_repay_cont_tail3_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_repay_cont_tail3_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_myjb_repay_cont_tail3 where 0=1;

create table ${iol_schema}.icms_myjb_repay_cont_tail3_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.icms_myjb_repay_cont_tail3 where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.icms_myjb_repay_cont_tail3_op(
        seqno -- 借呗平台贷款合同号
        ,paidovdprinpnltamt -- 本次实还逾期本金罚息金额
        ,currovdintbal -- 本次还款前的应收未收逾期利息余额
        ,accruedstatus -- 应计非应计标识，应计0，非应计1
        ,paidprinamt -- 本次实还正常本金金额
        ,paidovdprinamt -- 本次实还逾期本金金额
        ,currintbal -- 本次还款前的应收未收正常利息余额
        ,withdrawno -- 还款提现单号
        ,contractno -- 还款流水号
        ,paidintamt -- 本次实还正常利息金额
        ,repaytype -- 还款类型
        ,currovdprinpnltbal -- 本次还款前的应收未收逾期本金罚息余额
        ,feeno -- 平台服务费收费单号
        ,paidovdintamt -- 本次实还逾期利息金额
        ,writeoff -- 核销标识，已核销为y，否则为n
        ,currovdprinbal -- 本次还款前的应收未收逾期本金余额
        ,currovdintpnltbal -- 本次还款前的应收未收逾期利息罚息余额
        ,inputdate -- 登记日期
        ,paidovdintpnltamt -- 本次实还逾期利息罚息金额
        ,repaydate -- 还款日期
        ,repayamt -- 总金额
        ,feeamt -- 本次还款对应的平台服务费金额
        ,currprinbal -- 本次还款前的应收未收正常本金余额
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.seqno -- 借呗平台贷款合同号
    ,n.paidovdprinpnltamt -- 本次实还逾期本金罚息金额
    ,n.currovdintbal -- 本次还款前的应收未收逾期利息余额
    ,n.accruedstatus -- 应计非应计标识，应计0，非应计1
    ,n.paidprinamt -- 本次实还正常本金金额
    ,n.paidovdprinamt -- 本次实还逾期本金金额
    ,n.currintbal -- 本次还款前的应收未收正常利息余额
    ,n.withdrawno -- 还款提现单号
    ,n.contractno -- 还款流水号
    ,n.paidintamt -- 本次实还正常利息金额
    ,n.repaytype -- 还款类型
    ,n.currovdprinpnltbal -- 本次还款前的应收未收逾期本金罚息余额
    ,n.feeno -- 平台服务费收费单号
    ,n.paidovdintamt -- 本次实还逾期利息金额
    ,n.writeoff -- 核销标识，已核销为y，否则为n
    ,n.currovdprinbal -- 本次还款前的应收未收逾期本金余额
    ,n.currovdintpnltbal -- 本次还款前的应收未收逾期利息罚息余额
    ,n.inputdate -- 登记日期
    ,n.paidovdintpnltamt -- 本次实还逾期利息罚息金额
    ,n.repaydate -- 还款日期
    ,n.repayamt -- 总金额
    ,n.feeamt -- 本次还款对应的平台服务费金额
    ,n.currprinbal -- 本次还款前的应收未收正常本金余额
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_myjb_repay_cont_tail3_bk o
    right join (select * from ${itl_schema}.icms_myjb_repay_cont_tail3 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.seqno = n.seqno
where (
        o.seqno is null
    )
    or (
        o.paidovdprinpnltamt <> n.paidovdprinpnltamt
        or o.currovdintbal <> n.currovdintbal
        or o.accruedstatus <> n.accruedstatus
        or o.paidprinamt <> n.paidprinamt
        or o.paidovdprinamt <> n.paidovdprinamt
        or o.currintbal <> n.currintbal
        or o.withdrawno <> n.withdrawno
        or o.contractno <> n.contractno
        or o.paidintamt <> n.paidintamt
        or o.repaytype <> n.repaytype
        or o.currovdprinpnltbal <> n.currovdprinpnltbal
        or o.feeno <> n.feeno
        or o.paidovdintamt <> n.paidovdintamt
        or o.writeoff <> n.writeoff
        or o.currovdprinbal <> n.currovdprinbal
        or o.currovdintpnltbal <> n.currovdintpnltbal
        or o.inputdate <> n.inputdate
        or o.paidovdintpnltamt <> n.paidovdintpnltamt
        or o.repaydate <> n.repaydate
        or o.repayamt <> n.repayamt
        or o.feeamt <> n.feeamt
        or o.currprinbal <> n.currprinbal
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_myjb_repay_cont_tail3_cl(
            seqno -- 借呗平台贷款合同号
        ,paidovdprinpnltamt -- 本次实还逾期本金罚息金额
        ,currovdintbal -- 本次还款前的应收未收逾期利息余额
        ,accruedstatus -- 应计非应计标识，应计0，非应计1
        ,paidprinamt -- 本次实还正常本金金额
        ,paidovdprinamt -- 本次实还逾期本金金额
        ,currintbal -- 本次还款前的应收未收正常利息余额
        ,withdrawno -- 还款提现单号
        ,contractno -- 还款流水号
        ,paidintamt -- 本次实还正常利息金额
        ,repaytype -- 还款类型
        ,currovdprinpnltbal -- 本次还款前的应收未收逾期本金罚息余额
        ,feeno -- 平台服务费收费单号
        ,paidovdintamt -- 本次实还逾期利息金额
        ,writeoff -- 核销标识，已核销为y，否则为n
        ,currovdprinbal -- 本次还款前的应收未收逾期本金余额
        ,currovdintpnltbal -- 本次还款前的应收未收逾期利息罚息余额
        ,inputdate -- 登记日期
        ,paidovdintpnltamt -- 本次实还逾期利息罚息金额
        ,repaydate -- 还款日期
        ,repayamt -- 总金额
        ,feeamt -- 本次还款对应的平台服务费金额
        ,currprinbal -- 本次还款前的应收未收正常本金余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_myjb_repay_cont_tail3_op(
            seqno -- 借呗平台贷款合同号
        ,paidovdprinpnltamt -- 本次实还逾期本金罚息金额
        ,currovdintbal -- 本次还款前的应收未收逾期利息余额
        ,accruedstatus -- 应计非应计标识，应计0，非应计1
        ,paidprinamt -- 本次实还正常本金金额
        ,paidovdprinamt -- 本次实还逾期本金金额
        ,currintbal -- 本次还款前的应收未收正常利息余额
        ,withdrawno -- 还款提现单号
        ,contractno -- 还款流水号
        ,paidintamt -- 本次实还正常利息金额
        ,repaytype -- 还款类型
        ,currovdprinpnltbal -- 本次还款前的应收未收逾期本金罚息余额
        ,feeno -- 平台服务费收费单号
        ,paidovdintamt -- 本次实还逾期利息金额
        ,writeoff -- 核销标识，已核销为y，否则为n
        ,currovdprinbal -- 本次还款前的应收未收逾期本金余额
        ,currovdintpnltbal -- 本次还款前的应收未收逾期利息罚息余额
        ,inputdate -- 登记日期
        ,paidovdintpnltamt -- 本次实还逾期利息罚息金额
        ,repaydate -- 还款日期
        ,repayamt -- 总金额
        ,feeamt -- 本次还款对应的平台服务费金额
        ,currprinbal -- 本次还款前的应收未收正常本金余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.seqno -- 借呗平台贷款合同号
    ,o.paidovdprinpnltamt -- 本次实还逾期本金罚息金额
    ,o.currovdintbal -- 本次还款前的应收未收逾期利息余额
    ,o.accruedstatus -- 应计非应计标识，应计0，非应计1
    ,o.paidprinamt -- 本次实还正常本金金额
    ,o.paidovdprinamt -- 本次实还逾期本金金额
    ,o.currintbal -- 本次还款前的应收未收正常利息余额
    ,o.withdrawno -- 还款提现单号
    ,o.contractno -- 还款流水号
    ,o.paidintamt -- 本次实还正常利息金额
    ,o.repaytype -- 还款类型
    ,o.currovdprinpnltbal -- 本次还款前的应收未收逾期本金罚息余额
    ,o.feeno -- 平台服务费收费单号
    ,o.paidovdintamt -- 本次实还逾期利息金额
    ,o.writeoff -- 核销标识，已核销为y，否则为n
    ,o.currovdprinbal -- 本次还款前的应收未收逾期本金余额
    ,o.currovdintpnltbal -- 本次还款前的应收未收逾期利息罚息余额
    ,o.inputdate -- 登记日期
    ,o.paidovdintpnltamt -- 本次实还逾期利息罚息金额
    ,o.repaydate -- 还款日期
    ,o.repayamt -- 总金额
    ,o.feeamt -- 本次还款对应的平台服务费金额
    ,o.currprinbal -- 本次还款前的应收未收正常本金余额
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_myjb_repay_cont_tail3_bk o
    left join ${iol_schema}.icms_myjb_repay_cont_tail3_op n
        on
            o.seqno = n.seqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_myjb_repay_cont_tail3;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_myjb_repay_cont_tail3') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_myjb_repay_cont_tail3 drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_myjb_repay_cont_tail3 add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_myjb_repay_cont_tail3 exchange partition p_${batch_date} with table ${iol_schema}.icms_myjb_repay_cont_tail3_cl;
alter table ${iol_schema}.icms_myjb_repay_cont_tail3 exchange partition p_20991231 with table ${iol_schema}.icms_myjb_repay_cont_tail3_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myjb_repay_cont_tail3 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myjb_repay_cont_tail3_op purge;
drop table ${iol_schema}.icms_myjb_repay_cont_tail3_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_myjb_repay_cont_tail3_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myjb_repay_cont_tail3',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
