/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_balance
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
create table ${iol_schema}.ctms_fbs_v_balance_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_fbs_v_balance;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_balance_op purge;
drop table ${iol_schema}.ctms_fbs_v_balance_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_balance_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_balance where 0=1;

create table ${iol_schema}.ctms_fbs_v_balance_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_balance where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_balance_cl(
            balance_id -- 资产余额ID
            ,alterbalance_id -- 变动明细唯一识别代码
            ,aspclient_id -- 部门代码
            ,keepfolder_id -- 后台账户代码
            ,settledate -- 业务发生日期
            ,assettype -- 资产类别
            ,buztype -- 业务类别
            ,majorassetcode -- 主资产代码
            ,minorassetcode -- 次资产代码
            ,holdposition -- 持有仓位
            ,holdfaceamount -- 持有面额
            ,cleanpricecost -- 净价成本
            ,interestadjust -- 利息调整
            ,fairvaluealter -- 公允价值变动
            ,interestcost -- 利息成本
            ,dirtypricecost -- 全价成本
            ,impairment -- 减值准备
            ,priceearning -- 价差收益
            ,amortizeearning -- 摊销收益
            ,interestearning -- 利息收益
            ,fairvalueincome -- 公允价值变动损益
            ,impairmentlost -- 减值损失
            ,tradeexpense -- 交易费用
            ,realrate -- 实际利率
            ,chargeincome -- 手续费收入
            ,chargeexpense -- 手续费支出
            ,valuedate -- 起息日
            ,maturitydate -- 到期日
            ,lastmodified -- 更新时间
            ,occuramount -- 发生金额
            ,amortizationfactor -- 摊销调整因子
            ,balance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
            ,rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
            ,reservevalue1 -- 备选值1
            ,reservevalue2 -- 备选值2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_balance_op(
            balance_id -- 资产余额ID
            ,alterbalance_id -- 变动明细唯一识别代码
            ,aspclient_id -- 部门代码
            ,keepfolder_id -- 后台账户代码
            ,settledate -- 业务发生日期
            ,assettype -- 资产类别
            ,buztype -- 业务类别
            ,majorassetcode -- 主资产代码
            ,minorassetcode -- 次资产代码
            ,holdposition -- 持有仓位
            ,holdfaceamount -- 持有面额
            ,cleanpricecost -- 净价成本
            ,interestadjust -- 利息调整
            ,fairvaluealter -- 公允价值变动
            ,interestcost -- 利息成本
            ,dirtypricecost -- 全价成本
            ,impairment -- 减值准备
            ,priceearning -- 价差收益
            ,amortizeearning -- 摊销收益
            ,interestearning -- 利息收益
            ,fairvalueincome -- 公允价值变动损益
            ,impairmentlost -- 减值损失
            ,tradeexpense -- 交易费用
            ,realrate -- 实际利率
            ,chargeincome -- 手续费收入
            ,chargeexpense -- 手续费支出
            ,valuedate -- 起息日
            ,maturitydate -- 到期日
            ,lastmodified -- 更新时间
            ,occuramount -- 发生金额
            ,amortizationfactor -- 摊销调整因子
            ,balance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
            ,rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
            ,reservevalue1 -- 备选值1
            ,reservevalue2 -- 备选值2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.balance_id, o.balance_id) as balance_id -- 资产余额ID
    ,nvl(n.alterbalance_id, o.alterbalance_id) as alterbalance_id -- 变动明细唯一识别代码
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门代码
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 后台账户代码
    ,nvl(n.settledate, o.settledate) as settledate -- 业务发生日期
    ,nvl(n.assettype, o.assettype) as assettype -- 资产类别
    ,nvl(n.buztype, o.buztype) as buztype -- 业务类别
    ,nvl(n.majorassetcode, o.majorassetcode) as majorassetcode -- 主资产代码
    ,nvl(n.minorassetcode, o.minorassetcode) as minorassetcode -- 次资产代码
    ,nvl(n.holdposition, o.holdposition) as holdposition -- 持有仓位
    ,nvl(n.holdfaceamount, o.holdfaceamount) as holdfaceamount -- 持有面额
    ,nvl(n.cleanpricecost, o.cleanpricecost) as cleanpricecost -- 净价成本
    ,nvl(n.interestadjust, o.interestadjust) as interestadjust -- 利息调整
    ,nvl(n.fairvaluealter, o.fairvaluealter) as fairvaluealter -- 公允价值变动
    ,nvl(n.interestcost, o.interestcost) as interestcost -- 利息成本
    ,nvl(n.dirtypricecost, o.dirtypricecost) as dirtypricecost -- 全价成本
    ,nvl(n.impairment, o.impairment) as impairment -- 减值准备
    ,nvl(n.priceearning, o.priceearning) as priceearning -- 价差收益
    ,nvl(n.amortizeearning, o.amortizeearning) as amortizeearning -- 摊销收益
    ,nvl(n.interestearning, o.interestearning) as interestearning -- 利息收益
    ,nvl(n.fairvalueincome, o.fairvalueincome) as fairvalueincome -- 公允价值变动损益
    ,nvl(n.impairmentlost, o.impairmentlost) as impairmentlost -- 减值损失
    ,nvl(n.tradeexpense, o.tradeexpense) as tradeexpense -- 交易费用
    ,nvl(n.realrate, o.realrate) as realrate -- 实际利率
    ,nvl(n.chargeincome, o.chargeincome) as chargeincome -- 手续费收入
    ,nvl(n.chargeexpense, o.chargeexpense) as chargeexpense -- 手续费支出
    ,nvl(n.valuedate, o.valuedate) as valuedate -- 起息日
    ,nvl(n.maturitydate, o.maturitydate) as maturitydate -- 到期日
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 更新时间
    ,nvl(n.occuramount, o.occuramount) as occuramount -- 发生金额
    ,nvl(n.amortizationfactor, o.amortizationfactor) as amortizationfactor -- 摊销调整因子
    ,nvl(n.balance_id_prev, o.balance_id_prev) as balance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
    ,nvl(n.rev_flag, o.rev_flag) as rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
    ,nvl(n.reservevalue1, o.reservevalue1) as reservevalue1 -- 备选值1
    ,nvl(n.reservevalue2, o.reservevalue2) as reservevalue2 -- 备选值2
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
from (select * from ${iol_schema}.ctms_fbs_v_balance_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_fbs_v_balance where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_balance_cl(
            balance_id -- 资产余额ID
            ,alterbalance_id -- 变动明细唯一识别代码
            ,aspclient_id -- 部门代码
            ,keepfolder_id -- 后台账户代码
            ,settledate -- 业务发生日期
            ,assettype -- 资产类别
            ,buztype -- 业务类别
            ,majorassetcode -- 主资产代码
            ,minorassetcode -- 次资产代码
            ,holdposition -- 持有仓位
            ,holdfaceamount -- 持有面额
            ,cleanpricecost -- 净价成本
            ,interestadjust -- 利息调整
            ,fairvaluealter -- 公允价值变动
            ,interestcost -- 利息成本
            ,dirtypricecost -- 全价成本
            ,impairment -- 减值准备
            ,priceearning -- 价差收益
            ,amortizeearning -- 摊销收益
            ,interestearning -- 利息收益
            ,fairvalueincome -- 公允价值变动损益
            ,impairmentlost -- 减值损失
            ,tradeexpense -- 交易费用
            ,realrate -- 实际利率
            ,chargeincome -- 手续费收入
            ,chargeexpense -- 手续费支出
            ,valuedate -- 起息日
            ,maturitydate -- 到期日
            ,lastmodified -- 更新时间
            ,occuramount -- 发生金额
            ,amortizationfactor -- 摊销调整因子
            ,balance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
            ,rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
            ,reservevalue1 -- 备选值1
            ,reservevalue2 -- 备选值2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_balance_op(
            balance_id -- 资产余额ID
            ,alterbalance_id -- 变动明细唯一识别代码
            ,aspclient_id -- 部门代码
            ,keepfolder_id -- 后台账户代码
            ,settledate -- 业务发生日期
            ,assettype -- 资产类别
            ,buztype -- 业务类别
            ,majorassetcode -- 主资产代码
            ,minorassetcode -- 次资产代码
            ,holdposition -- 持有仓位
            ,holdfaceamount -- 持有面额
            ,cleanpricecost -- 净价成本
            ,interestadjust -- 利息调整
            ,fairvaluealter -- 公允价值变动
            ,interestcost -- 利息成本
            ,dirtypricecost -- 全价成本
            ,impairment -- 减值准备
            ,priceearning -- 价差收益
            ,amortizeearning -- 摊销收益
            ,interestearning -- 利息收益
            ,fairvalueincome -- 公允价值变动损益
            ,impairmentlost -- 减值损失
            ,tradeexpense -- 交易费用
            ,realrate -- 实际利率
            ,chargeincome -- 手续费收入
            ,chargeexpense -- 手续费支出
            ,valuedate -- 起息日
            ,maturitydate -- 到期日
            ,lastmodified -- 更新时间
            ,occuramount -- 发生金额
            ,amortizationfactor -- 摊销调整因子
            ,balance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
            ,rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
            ,reservevalue1 -- 备选值1
            ,reservevalue2 -- 备选值2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.balance_id -- 资产余额ID
    ,o.alterbalance_id -- 变动明细唯一识别代码
    ,o.aspclient_id -- 部门代码
    ,o.keepfolder_id -- 后台账户代码
    ,o.settledate -- 业务发生日期
    ,o.assettype -- 资产类别
    ,o.buztype -- 业务类别
    ,o.majorassetcode -- 主资产代码
    ,o.minorassetcode -- 次资产代码
    ,o.holdposition -- 持有仓位
    ,o.holdfaceamount -- 持有面额
    ,o.cleanpricecost -- 净价成本
    ,o.interestadjust -- 利息调整
    ,o.fairvaluealter -- 公允价值变动
    ,o.interestcost -- 利息成本
    ,o.dirtypricecost -- 全价成本
    ,o.impairment -- 减值准备
    ,o.priceearning -- 价差收益
    ,o.amortizeearning -- 摊销收益
    ,o.interestearning -- 利息收益
    ,o.fairvalueincome -- 公允价值变动损益
    ,o.impairmentlost -- 减值损失
    ,o.tradeexpense -- 交易费用
    ,o.realrate -- 实际利率
    ,o.chargeincome -- 手续费收入
    ,o.chargeexpense -- 手续费支出
    ,o.valuedate -- 起息日
    ,o.maturitydate -- 到期日
    ,o.lastmodified -- 更新时间
    ,o.occuramount -- 发生金额
    ,o.amortizationfactor -- 摊销调整因子
    ,o.balance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
    ,o.rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
    ,o.reservevalue1 -- 备选值1
    ,o.reservevalue2 -- 备选值2
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_fbs_v_balance_bk o
    left join ${iol_schema}.ctms_fbs_v_balance_op n
        on
            o.balance_id = n.balance_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_fbs_v_balance_cl d
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
-- truncate table ${iol_schema}.ctms_fbs_v_balance;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_fbs_v_balance exchange partition p_19000101 with table ${iol_schema}.ctms_fbs_v_balance_cl;
alter table ${iol_schema}.ctms_fbs_v_balance exchange partition p_20991231 with table ${iol_schema}.ctms_fbs_v_balance_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_v_balance to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_balance_op purge;
drop table ${iol_schema}.ctms_fbs_v_balance_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_fbs_v_balance_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_v_balance',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
