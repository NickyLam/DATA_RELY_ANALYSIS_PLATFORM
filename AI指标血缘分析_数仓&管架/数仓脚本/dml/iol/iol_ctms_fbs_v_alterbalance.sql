/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_fbs_v_alterbalance
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
create table ${iol_schema}.ctms_fbs_v_alterbalance_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_fbs_v_alterbalance;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_alterbalance_op purge;
drop table ${iol_schema}.ctms_fbs_v_alterbalance_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_fbs_v_alterbalance_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_alterbalance where 0=1;

create table ${iol_schema}.ctms_fbs_v_alterbalance_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_fbs_v_alterbalance where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_alterbalance_cl(
            alterbalance_id -- 变动明细唯一识别代码
            ,aspclient_id -- 部门代码
            ,keepfolder_id -- 后台账户代码
            ,acccode -- 会计事件代码
            ,assettype -- 资产类别
            ,buztype -- 业务类别
            ,majorassetcode -- 主资产代码
            ,minorassetcode -- 次资产代码
            ,settledate -- 业务发生日期
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
            ,alterbalance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
            ,alterbalance_id_rev -- 指向被冲回的变动交易
            ,rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
            ,bs_flag -- 无用
            ,bs_deal_tablename -- 无用
            ,bs_deal_id -- 无用
            ,reservevalue1 -- 备选值1
            ,reservevalue2 -- 备选值2
            ,event_source_name -- 会计事件源名称
            ,event_source_id -- 会计事件源交易代码：前台原始交易代码
            ,event_source_type -- 会计事件源类别
            ,counterparty -- 交易对手
            ,day_end_date -- 日终出账日期
            ,out_from -- 非系统自动产生的来源
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_alterbalance_op(
            alterbalance_id -- 变动明细唯一识别代码
            ,aspclient_id -- 部门代码
            ,keepfolder_id -- 后台账户代码
            ,acccode -- 会计事件代码
            ,assettype -- 资产类别
            ,buztype -- 业务类别
            ,majorassetcode -- 主资产代码
            ,minorassetcode -- 次资产代码
            ,settledate -- 业务发生日期
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
            ,alterbalance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
            ,alterbalance_id_rev -- 指向被冲回的变动交易
            ,rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
            ,bs_flag -- 无用
            ,bs_deal_tablename -- 无用
            ,bs_deal_id -- 无用
            ,reservevalue1 -- 备选值1
            ,reservevalue2 -- 备选值2
            ,event_source_name -- 会计事件源名称
            ,event_source_id -- 会计事件源交易代码：前台原始交易代码
            ,event_source_type -- 会计事件源类别
            ,counterparty -- 交易对手
            ,day_end_date -- 日终出账日期
            ,out_from -- 非系统自动产生的来源
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.alterbalance_id, o.alterbalance_id) as alterbalance_id -- 变动明细唯一识别代码
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门代码
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 后台账户代码
    ,nvl(n.acccode, o.acccode) as acccode -- 会计事件代码
    ,nvl(n.assettype, o.assettype) as assettype -- 资产类别
    ,nvl(n.buztype, o.buztype) as buztype -- 业务类别
    ,nvl(n.majorassetcode, o.majorassetcode) as majorassetcode -- 主资产代码
    ,nvl(n.minorassetcode, o.minorassetcode) as minorassetcode -- 次资产代码
    ,nvl(n.settledate, o.settledate) as settledate -- 业务发生日期
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
    ,nvl(n.alterbalance_id_prev, o.alterbalance_id_prev) as alterbalance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
    ,nvl(n.alterbalance_id_rev, o.alterbalance_id_rev) as alterbalance_id_rev -- 指向被冲回的变动交易
    ,nvl(n.rev_flag, o.rev_flag) as rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
    ,nvl(n.bs_flag, o.bs_flag) as bs_flag -- 无用
    ,nvl(n.bs_deal_tablename, o.bs_deal_tablename) as bs_deal_tablename -- 无用
    ,nvl(n.bs_deal_id, o.bs_deal_id) as bs_deal_id -- 无用
    ,nvl(n.reservevalue1, o.reservevalue1) as reservevalue1 -- 备选值1
    ,nvl(n.reservevalue2, o.reservevalue2) as reservevalue2 -- 备选值2
    ,nvl(n.event_source_name, o.event_source_name) as event_source_name -- 会计事件源名称
    ,nvl(n.event_source_id, o.event_source_id) as event_source_id -- 会计事件源交易代码：前台原始交易代码
    ,nvl(n.event_source_type, o.event_source_type) as event_source_type -- 会计事件源类别
    ,nvl(n.counterparty, o.counterparty) as counterparty -- 交易对手
    ,nvl(n.day_end_date, o.day_end_date) as day_end_date -- 日终出账日期
    ,nvl(n.out_from, o.out_from) as out_from -- 非系统自动产生的来源
    ,case when
            n.alterbalance_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.alterbalance_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.alterbalance_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_fbs_v_alterbalance_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_fbs_v_alterbalance where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.alterbalance_id = n.alterbalance_id
where (
        o.alterbalance_id is null
    )
    or (
        n.alterbalance_id is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.keepfolder_id <> n.keepfolder_id
        or o.acccode <> n.acccode
        or o.assettype <> n.assettype
        or o.buztype <> n.buztype
        or o.majorassetcode <> n.majorassetcode
        or o.minorassetcode <> n.minorassetcode
        or o.settledate <> n.settledate
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
        or o.alterbalance_id_prev <> n.alterbalance_id_prev
        or o.alterbalance_id_rev <> n.alterbalance_id_rev
        or o.rev_flag <> n.rev_flag
        or o.bs_flag <> n.bs_flag
        or o.bs_deal_tablename <> n.bs_deal_tablename
        or o.bs_deal_id <> n.bs_deal_id
        or o.reservevalue1 <> n.reservevalue1
        or o.reservevalue2 <> n.reservevalue2
        or o.event_source_name <> n.event_source_name
        or o.event_source_id <> n.event_source_id
        or o.event_source_type <> n.event_source_type
        or o.counterparty <> n.counterparty
        or o.day_end_date <> n.day_end_date
        or o.out_from <> n.out_from
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_fbs_v_alterbalance_cl(
            alterbalance_id -- 变动明细唯一识别代码
            ,aspclient_id -- 部门代码
            ,keepfolder_id -- 后台账户代码
            ,acccode -- 会计事件代码
            ,assettype -- 资产类别
            ,buztype -- 业务类别
            ,majorassetcode -- 主资产代码
            ,minorassetcode -- 次资产代码
            ,settledate -- 业务发生日期
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
            ,alterbalance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
            ,alterbalance_id_rev -- 指向被冲回的变动交易
            ,rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
            ,bs_flag -- 无用
            ,bs_deal_tablename -- 无用
            ,bs_deal_id -- 无用
            ,reservevalue1 -- 备选值1
            ,reservevalue2 -- 备选值2
            ,event_source_name -- 会计事件源名称
            ,event_source_id -- 会计事件源交易代码：前台原始交易代码
            ,event_source_type -- 会计事件源类别
            ,counterparty -- 交易对手
            ,day_end_date -- 日终出账日期
            ,out_from -- 非系统自动产生的来源
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_fbs_v_alterbalance_op(
            alterbalance_id -- 变动明细唯一识别代码
            ,aspclient_id -- 部门代码
            ,keepfolder_id -- 后台账户代码
            ,acccode -- 会计事件代码
            ,assettype -- 资产类别
            ,buztype -- 业务类别
            ,majorassetcode -- 主资产代码
            ,minorassetcode -- 次资产代码
            ,settledate -- 业务发生日期
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
            ,alterbalance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
            ,alterbalance_id_rev -- 指向被冲回的变动交易
            ,rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
            ,bs_flag -- 无用
            ,bs_deal_tablename -- 无用
            ,bs_deal_id -- 无用
            ,reservevalue1 -- 备选值1
            ,reservevalue2 -- 备选值2
            ,event_source_name -- 会计事件源名称
            ,event_source_id -- 会计事件源交易代码：前台原始交易代码
            ,event_source_type -- 会计事件源类别
            ,counterparty -- 交易对手
            ,day_end_date -- 日终出账日期
            ,out_from -- 非系统自动产生的来源
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.alterbalance_id -- 变动明细唯一识别代码
    ,o.aspclient_id -- 部门代码
    ,o.keepfolder_id -- 后台账户代码
    ,o.acccode -- 会计事件代码
    ,o.assettype -- 资产类别
    ,o.buztype -- 业务类别
    ,o.majorassetcode -- 主资产代码
    ,o.minorassetcode -- 次资产代码
    ,o.settledate -- 业务发生日期
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
    ,o.alterbalance_id_prev -- 指向累计仓位变动的前一次交易。Ex:交易、交割、计摊估....,后一笔指向前一笔，第一笔=Null
    ,o.alterbalance_id_rev -- 指向被冲回的变动交易
    ,o.rev_flag -- 标注本次变动是否为冲回重出后的。Y：是
    ,o.bs_flag -- 无用
    ,o.bs_deal_tablename -- 无用
    ,o.bs_deal_id -- 无用
    ,o.reservevalue1 -- 备选值1
    ,o.reservevalue2 -- 备选值2
    ,o.event_source_name -- 会计事件源名称
    ,o.event_source_id -- 会计事件源交易代码：前台原始交易代码
    ,o.event_source_type -- 会计事件源类别
    ,o.counterparty -- 交易对手
    ,o.day_end_date -- 日终出账日期
    ,o.out_from -- 非系统自动产生的来源
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_fbs_v_alterbalance_bk o
    left join ${iol_schema}.ctms_fbs_v_alterbalance_op n
        on
            o.alterbalance_id = n.alterbalance_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_fbs_v_alterbalance_cl d
        on
            o.alterbalance_id = d.alterbalance_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_fbs_v_alterbalance;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_fbs_v_alterbalance exchange partition p_19000101 with table ${iol_schema}.ctms_fbs_v_alterbalance_cl;
alter table ${iol_schema}.ctms_fbs_v_alterbalance exchange partition p_20991231 with table ${iol_schema}.ctms_fbs_v_alterbalance_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_fbs_v_alterbalance to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_fbs_v_alterbalance_op purge;
drop table ${iol_schema}.ctms_fbs_v_alterbalance_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_fbs_v_alterbalance_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_fbs_v_alterbalance',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
