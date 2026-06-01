/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_new_balance
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
create table ${iol_schema}.ctms_fbs_v_new_balance_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_fbs_v_new_balance
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_new_balance_op purge;
drop table ${iol_schema}.ctms_fbs_v_new_balance_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_new_balance_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_new_balance where 0=1;

create table ${iol_schema}.ctms_fbs_v_new_balance_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_new_balance where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_new_balance_cl(
            balance_id -- 
            ,alterbalance_id -- 
            ,aspclient_id -- 
            ,keepfolder_id -- 
            ,settledate -- 
            ,assettype -- 
            ,buztype -- 
            ,majorassetcode -- 
            ,minorassetcode -- 
            ,holdposition -- 
            ,holdfaceamount -- 
            ,cleanpricecost -- 
            ,interestadjust -- 
            ,fairvaluealter -- 
            ,interestcost -- 
            ,dirtypricecost -- 
            ,impairment -- 
            ,priceearning -- 
            ,amortizeearning -- 
            ,interestearning -- 
            ,fairvalueincome -- 
            ,impairmentlost -- 
            ,tradeexpense -- 
            ,realrate -- 
            ,chargeincome -- 
            ,chargeexpense -- 
            ,valuedate -- 
            ,maturitydate -- 
            ,lastmodified -- 
            ,occuramount -- 
            ,amortizationfactor -- 
            ,balance_id_prev -- 
            ,rev_flag -- 
            ,reservevalue1 -- 
            ,reservevalue2 -- 
            ,product_code -- 
            ,capital_subjectid -- 本金科目编号
            ,interestcost_subjectid -- 利息成本科目编号
            ,interestadjust_subjectid -- 利息调整科目编号
            ,fairvaluealter_subjectid -- 公允价值变动科目编号
            ,interestearning_subjectid -- 利息收入科目编号
            ,amortizeearning_subjectid -- 摊销收益科目编号
            ,fairvalueincome_subjectid -- 公允价值变动损益科目编号
            ,priceearning_subjectid -- 价差收益科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_new_balance_op(
            balance_id -- 
            ,alterbalance_id -- 
            ,aspclient_id -- 
            ,keepfolder_id -- 
            ,settledate -- 
            ,assettype -- 
            ,buztype -- 
            ,majorassetcode -- 
            ,minorassetcode -- 
            ,holdposition -- 
            ,holdfaceamount -- 
            ,cleanpricecost -- 
            ,interestadjust -- 
            ,fairvaluealter -- 
            ,interestcost -- 
            ,dirtypricecost -- 
            ,impairment -- 
            ,priceearning -- 
            ,amortizeearning -- 
            ,interestearning -- 
            ,fairvalueincome -- 
            ,impairmentlost -- 
            ,tradeexpense -- 
            ,realrate -- 
            ,chargeincome -- 
            ,chargeexpense -- 
            ,valuedate -- 
            ,maturitydate -- 
            ,lastmodified -- 
            ,occuramount -- 
            ,amortizationfactor -- 
            ,balance_id_prev -- 
            ,rev_flag -- 
            ,reservevalue1 -- 
            ,reservevalue2 -- 
            ,product_code -- 
            ,capital_subjectid -- 本金科目编号
            ,interestcost_subjectid -- 利息成本科目编号
            ,interestadjust_subjectid -- 利息调整科目编号
            ,fairvaluealter_subjectid -- 公允价值变动科目编号
            ,interestearning_subjectid -- 利息收入科目编号
            ,amortizeearning_subjectid -- 摊销收益科目编号
            ,fairvalueincome_subjectid -- 公允价值变动损益科目编号
            ,priceearning_subjectid -- 价差收益科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.balance_id, o.balance_id) as balance_id -- 
    ,nvl(n.alterbalance_id, o.alterbalance_id) as alterbalance_id -- 
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 
    ,nvl(n.settledate, o.settledate) as settledate -- 
    ,nvl(n.assettype, o.assettype) as assettype -- 
    ,nvl(n.buztype, o.buztype) as buztype -- 
    ,nvl(n.majorassetcode, o.majorassetcode) as majorassetcode -- 
    ,nvl(n.minorassetcode, o.minorassetcode) as minorassetcode -- 
    ,nvl(n.holdposition, o.holdposition) as holdposition -- 
    ,nvl(n.holdfaceamount, o.holdfaceamount) as holdfaceamount -- 
    ,nvl(n.cleanpricecost, o.cleanpricecost) as cleanpricecost -- 
    ,nvl(n.interestadjust, o.interestadjust) as interestadjust -- 
    ,nvl(n.fairvaluealter, o.fairvaluealter) as fairvaluealter -- 
    ,nvl(n.interestcost, o.interestcost) as interestcost -- 
    ,nvl(n.dirtypricecost, o.dirtypricecost) as dirtypricecost -- 
    ,nvl(n.impairment, o.impairment) as impairment -- 
    ,nvl(n.priceearning, o.priceearning) as priceearning -- 
    ,nvl(n.amortizeearning, o.amortizeearning) as amortizeearning -- 
    ,nvl(n.interestearning, o.interestearning) as interestearning -- 
    ,nvl(n.fairvalueincome, o.fairvalueincome) as fairvalueincome -- 
    ,nvl(n.impairmentlost, o.impairmentlost) as impairmentlost -- 
    ,nvl(n.tradeexpense, o.tradeexpense) as tradeexpense -- 
    ,nvl(n.realrate, o.realrate) as realrate -- 
    ,nvl(n.chargeincome, o.chargeincome) as chargeincome -- 
    ,nvl(n.chargeexpense, o.chargeexpense) as chargeexpense -- 
    ,nvl(n.valuedate, o.valuedate) as valuedate -- 
    ,nvl(n.maturitydate, o.maturitydate) as maturitydate -- 
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 
    ,nvl(n.occuramount, o.occuramount) as occuramount -- 
    ,nvl(n.amortizationfactor, o.amortizationfactor) as amortizationfactor -- 
    ,nvl(n.balance_id_prev, o.balance_id_prev) as balance_id_prev -- 
    ,nvl(n.rev_flag, o.rev_flag) as rev_flag -- 
    ,nvl(n.reservevalue1, o.reservevalue1) as reservevalue1 -- 
    ,nvl(n.reservevalue2, o.reservevalue2) as reservevalue2 -- 
    ,nvl(n.product_code, o.product_code) as product_code -- 
    ,nvl(n.capital_subjectid, o.capital_subjectid) as capital_subjectid -- 本金科目编号
    ,nvl(n.interestcost_subjectid, o.interestcost_subjectid) as interestcost_subjectid -- 利息成本科目编号
    ,nvl(n.interestadjust_subjectid, o.interestadjust_subjectid) as interestadjust_subjectid -- 利息调整科目编号
    ,nvl(n.fairvaluealter_subjectid, o.fairvaluealter_subjectid) as fairvaluealter_subjectid -- 公允价值变动科目编号
    ,nvl(n.interestearning_subjectid, o.interestearning_subjectid) as interestearning_subjectid -- 利息收入科目编号
    ,nvl(n.amortizeearning_subjectid, o.amortizeearning_subjectid) as amortizeearning_subjectid -- 摊销收益科目编号
    ,nvl(n.fairvalueincome_subjectid, o.fairvalueincome_subjectid) as fairvalueincome_subjectid -- 公允价值变动损益科目编号
    ,nvl(n.priceearning_subjectid, o.priceearning_subjectid) as priceearning_subjectid -- 价差收益科目编号
    ,case when
            n.balance_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.balance_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.balance_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_fbs_v_new_balance_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_fbs_v_new_balance where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.balance_id = n.balance_id
where (
        o.balance_id is null
    )
    or (
        n.balance_id is null
    )
    or (
        o.alterbalance_id <> n.alterbalance_id
        or o.aspclient_id <> n.aspclient_id
        or o.keepfolder_id <> n.keepfolder_id
        or o.settledate <> n.settledate
        or o.assettype <> n.assettype
        or o.buztype <> n.buztype
        or o.majorassetcode <> n.majorassetcode
        or o.minorassetcode <> n.minorassetcode
        or o.holdposition <> n.holdposition
        or o.holdfaceamount <> n.holdfaceamount
        or o.cleanpricecost <> n.cleanpricecost
        or o.interestadjust <> n.interestadjust
        or o.fairvaluealter <> n.fairvaluealter
        or o.interestcost <> n.interestcost
        or o.dirtypricecost <> n.dirtypricecost
        or o.impairment <> n.impairment
        or o.priceearning <> n.priceearning
        or o.amortizeearning <> n.amortizeearning
        or o.interestearning <> n.interestearning
        or o.fairvalueincome <> n.fairvalueincome
        or o.impairmentlost <> n.impairmentlost
        or o.tradeexpense <> n.tradeexpense
        or o.realrate <> n.realrate
        or o.chargeincome <> n.chargeincome
        or o.chargeexpense <> n.chargeexpense
        or o.valuedate <> n.valuedate
        or o.maturitydate <> n.maturitydate
        or o.lastmodified <> n.lastmodified
        or o.occuramount <> n.occuramount
        or o.amortizationfactor <> n.amortizationfactor
        or o.balance_id_prev <> n.balance_id_prev
        or o.rev_flag <> n.rev_flag
        or o.reservevalue1 <> n.reservevalue1
        or o.reservevalue2 <> n.reservevalue2
        or o.product_code <> n.product_code
        or o.capital_subjectid <> n.capital_subjectid
        or o.interestcost_subjectid <> n.interestcost_subjectid
        or o.interestadjust_subjectid <> n.interestadjust_subjectid
        or o.fairvaluealter_subjectid <> n.fairvaluealter_subjectid
        or o.interestearning_subjectid <> n.interestearning_subjectid
        or o.amortizeearning_subjectid <> n.amortizeearning_subjectid
        or o.fairvalueincome_subjectid <> n.fairvalueincome_subjectid
        or o.priceearning_subjectid <> n.priceearning_subjectid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_new_balance_cl(
            balance_id -- 
            ,alterbalance_id -- 
            ,aspclient_id -- 
            ,keepfolder_id -- 
            ,settledate -- 
            ,assettype -- 
            ,buztype -- 
            ,majorassetcode -- 
            ,minorassetcode -- 
            ,holdposition -- 
            ,holdfaceamount -- 
            ,cleanpricecost -- 
            ,interestadjust -- 
            ,fairvaluealter -- 
            ,interestcost -- 
            ,dirtypricecost -- 
            ,impairment -- 
            ,priceearning -- 
            ,amortizeearning -- 
            ,interestearning -- 
            ,fairvalueincome -- 
            ,impairmentlost -- 
            ,tradeexpense -- 
            ,realrate -- 
            ,chargeincome -- 
            ,chargeexpense -- 
            ,valuedate -- 
            ,maturitydate -- 
            ,lastmodified -- 
            ,occuramount -- 
            ,amortizationfactor -- 
            ,balance_id_prev -- 
            ,rev_flag -- 
            ,reservevalue1 -- 
            ,reservevalue2 -- 
            ,product_code -- 
            ,capital_subjectid -- 本金科目编号
            ,interestcost_subjectid -- 利息成本科目编号
            ,interestadjust_subjectid -- 利息调整科目编号
            ,fairvaluealter_subjectid -- 公允价值变动科目编号
            ,interestearning_subjectid -- 利息收入科目编号
            ,amortizeearning_subjectid -- 摊销收益科目编号
            ,fairvalueincome_subjectid -- 公允价值变动损益科目编号
            ,priceearning_subjectid -- 价差收益科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_new_balance_op(
            balance_id -- 
            ,alterbalance_id -- 
            ,aspclient_id -- 
            ,keepfolder_id -- 
            ,settledate -- 
            ,assettype -- 
            ,buztype -- 
            ,majorassetcode -- 
            ,minorassetcode -- 
            ,holdposition -- 
            ,holdfaceamount -- 
            ,cleanpricecost -- 
            ,interestadjust -- 
            ,fairvaluealter -- 
            ,interestcost -- 
            ,dirtypricecost -- 
            ,impairment -- 
            ,priceearning -- 
            ,amortizeearning -- 
            ,interestearning -- 
            ,fairvalueincome -- 
            ,impairmentlost -- 
            ,tradeexpense -- 
            ,realrate -- 
            ,chargeincome -- 
            ,chargeexpense -- 
            ,valuedate -- 
            ,maturitydate -- 
            ,lastmodified -- 
            ,occuramount -- 
            ,amortizationfactor -- 
            ,balance_id_prev -- 
            ,rev_flag -- 
            ,reservevalue1 -- 
            ,reservevalue2 -- 
            ,product_code -- 
            ,capital_subjectid -- 本金科目编号
            ,interestcost_subjectid -- 利息成本科目编号
            ,interestadjust_subjectid -- 利息调整科目编号
            ,fairvaluealter_subjectid -- 公允价值变动科目编号
            ,interestearning_subjectid -- 利息收入科目编号
            ,amortizeearning_subjectid -- 摊销收益科目编号
            ,fairvalueincome_subjectid -- 公允价值变动损益科目编号
            ,priceearning_subjectid -- 价差收益科目编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.balance_id -- 
    ,o.alterbalance_id -- 
    ,o.aspclient_id -- 
    ,o.keepfolder_id -- 
    ,o.settledate -- 
    ,o.assettype -- 
    ,o.buztype -- 
    ,o.majorassetcode -- 
    ,o.minorassetcode -- 
    ,o.holdposition -- 
    ,o.holdfaceamount -- 
    ,o.cleanpricecost -- 
    ,o.interestadjust -- 
    ,o.fairvaluealter -- 
    ,o.interestcost -- 
    ,o.dirtypricecost -- 
    ,o.impairment -- 
    ,o.priceearning -- 
    ,o.amortizeearning -- 
    ,o.interestearning -- 
    ,o.fairvalueincome -- 
    ,o.impairmentlost -- 
    ,o.tradeexpense -- 
    ,o.realrate -- 
    ,o.chargeincome -- 
    ,o.chargeexpense -- 
    ,o.valuedate -- 
    ,o.maturitydate -- 
    ,o.lastmodified -- 
    ,o.occuramount -- 
    ,o.amortizationfactor -- 
    ,o.balance_id_prev -- 
    ,o.rev_flag -- 
    ,o.reservevalue1 -- 
    ,o.reservevalue2 -- 
    ,o.product_code -- 
    ,o.capital_subjectid -- 本金科目编号
    ,o.interestcost_subjectid -- 利息成本科目编号
    ,o.interestadjust_subjectid -- 利息调整科目编号
    ,o.fairvaluealter_subjectid -- 公允价值变动科目编号
    ,o.interestearning_subjectid -- 利息收入科目编号
    ,o.amortizeearning_subjectid -- 摊销收益科目编号
    ,o.fairvalueincome_subjectid -- 公允价值变动损益科目编号
    ,o.priceearning_subjectid -- 价差收益科目编号
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
from ${iol_schema}.ctms_fbs_v_new_balance_bk o
    left join ${iol_schema}.ctms_fbs_v_new_balance_op n
        on
            o.balance_id = n.balance_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_fbs_v_new_balance_cl d
        on
            o.balance_id = d.balance_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ctms_fbs_v_new_balance;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ctms_fbs_v_new_balance') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ctms_fbs_v_new_balance drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ctms_fbs_v_new_balance add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ctms_fbs_v_new_balance exchange partition p_${batch_date} with table ${iol_schema}.ctms_fbs_v_new_balance_cl;
alter table ${iol_schema}.ctms_fbs_v_new_balance exchange partition p_20991231 with table ${iol_schema}.ctms_fbs_v_new_balance_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_v_new_balance to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_new_balance_op purge;
drop table ${iol_schema}.ctms_fbs_v_new_balance_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_fbs_v_new_balance_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_v_new_balance',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
