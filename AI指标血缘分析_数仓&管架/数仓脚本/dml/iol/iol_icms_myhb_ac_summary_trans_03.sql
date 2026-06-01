/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_myhb_ac_summary_trans_03
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_myhb_ac_summary_trans_03_ex purge;
alter table ${iol_schema}.icms_myhb_ac_summary_trans_03 add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.icms_myhb_ac_summary_trans_03;

-- 2.3 insert data to ex table
create table ${iol_schema}.icms_myhb_ac_summary_trans_03_ex nologging
for exchange with table
${iol_schema}.icms_myhb_ac_summary_trans_03;

insert /*+ append */ into ${iol_schema}.icms_myhb_ac_summary_trans_03_ex(
    settledate -- 
    ,regioncode -- 行政区划代码
    ,payablefeeamt -- 应付平台服务费汇总金额
    ,feeamt -- 实付平台服务费汇总金额
    ,receivablesubsidyintamt -- 贴息计提(表内)
    ,paidsubsidyintamt -- 实还贴息(表内)
    ,accruedintamt -- 短期正常/逾期90天以内(含)贷款计提每日利息(表内)
    ,nonaccruedintamt -- 短期逾期90天以上贷款计提每日利息(表外)
    ,encashamt -- 当天贷款发放金额
    ,accruedovdprinpnltamt -- 短期逾期90天以内(含)贷款计提每日逾期本金罚息(表内)
    ,nonaccruedovdprinpnltamt -- 短期逾期90天以上贷款计提每日逾期本金罚息(表外)
    ,accruedovdintpnltamt -- 短期逾期90天以内(含)贷款计提每日逾期利息罚息(表内)
    ,nonaccruedovdintpnltamt -- 短期逾期90天以上贷款计提每日逾期利息罚息(表外)
    ,printoovdprinamt -- 正常本金转逾期本金
    ,inttoovdintamt -- 正常利息转逾期利息
    ,nonprintononovdprinamt -- 正常本金(非应计)转逾期本金(非应计)
    ,outinttooutovdintamt -- 正常利息(表外)转逾期利息(表外)
    ,accruedtononprinamt -- 正常本金(应计)转正常本金(非应计)
    ,accruedtononovdprinamt -- 逾期本金(应计)转逾期本金(非应计)
    ,internaltooutintamt -- 正常利息(表内)转正常利息(表外)
    ,internaltooutovdintamt -- 逾期利息(表内)转逾期利息(表外)
    ,internaltooutovdprinpnltamt -- 逾期本金罚息(表内)转逾期本金罚息(表外)
    ,internaltooutovdintpnltamt -- 逾期利息罚息(表内)转逾期利息罚息(表外)
    ,nontoaccruedprinamt -- 正常本金(非应计)转正常本金(应计)
    ,nontoaccruedovdprinamt -- 逾期本金(非应计)转逾期本金(应计)
    ,outtointernalintamt -- 正常利息(表外)转正常利息(表内)
    ,outtointernalovdintamt -- 逾期利息(表外)转逾期利息(表内)
    ,outtointernalovdprinpnltamt -- 逾期本金罚息(表外)转逾本金罚息(表内)
    ,outtointernalovdintpnltamt -- 逾期利息罚息(表外)转逾期利息罚息(表内)
    ,paidprinamt -- 实还正常本金(应计)
    ,paidnonaccruedprinamt -- 实还正常本金(非应计)
    ,paidaccruedovdprinamt -- 实还逾期本金(应计)
    ,paidnonaccruedovdprinamt -- 实还逾期本金(非应计)
    ,paidintamt -- 实还正常利息(表内)
    ,paidoutintamt -- 实还正常利息(表外)
    ,paidinternalovdintamt -- 实还逾期利息(表内)
    ,paidoutovdintamt -- 实还逾期利息(表外)
    ,paidinternalovdprinpnltintamt -- 实还逾期本金罚息(表内)
    ,paidoutovdprinpnltintamt -- 实还逾期本金罚息(表外)
    ,paidinternalovdintpnltintamt -- 实还逾期利息罚息(表内)
    ,paidoutovdintpnltintamt -- 实还逾期利息罚息(表外)
    ,exemptintamt -- 减免正常利息(表内)
    ,exemptoutintamt -- 减免正常利息(表外)
    ,exemptinternalovdintamt -- 减免逾期利息(表内)
    ,exemptoutovdintamt -- 减免逾期利息(表外)
    ,exemptinternalovdprinpnltintamt -- 减免逾期本金罚息(表内)
    ,exemptoutovdprinpnltintamt -- 减免逾期本金罚息(表外)
    ,exemptinternalovdintpnltintamt -- 减免逾期利息罚息(表内)
    ,exemptoutovdintpnltintamt -- 减免逾期利息罚息(表外)
    ,printoprinamtrlv -- 正常本金转正常本金
    ,ovdprintoprinamtrlv -- 逾期本金转正常本金
    ,nontoprinamtrlv -- 正常本金(非应计)转正常本金
    ,nonprintoprinamtrlv -- 逾期本金(非应计)转正常本金
    ,inttointamtrlv -- 正常利息转正常利息
    ,outinttointamtrlv -- 正常利息(表外)转正常利息
    ,ovdinttointamtrlv -- 逾期利息(表内)转正常利息
    ,outovdinttointamtrlv -- 逾期利息(表外)转正常利息
    ,writeoffovdprintoprinamtrlv -- 逾期本金（核销）转正常本金
    ,writeoffovdinttointamtrlv -- 逾期利息（核销）转正常利息
    ,printoprinamtinst -- 正常本金转正常本金
    ,ovdprintoprinamtinst -- 逾期本金转正常本金
    ,nonaccruedprinamtinst -- 正常本金(非应计)转正常本金
    ,nonaccruedtoprinamtinst -- 逾期本金(非应计)转正常本金
    ,writeoffprintoprinamtinst -- 正常本金（核销）转正常本金
    ,printoprinmedium -- 正常本金转正常本金
    ,nonprintoprinmedium -- 正常本金（非应计）转正常本金（应计）
    ,wfprintoprinmedium -- 正常本金（核销）转正常本金（应计）
    ,writeoffnonprinamt -- 已减值正常贷款本金核销
    ,writeoffnonovdprinamt -- 已减值逾期贷款本金核销
    ,writeoffoutintamt -- 正常贷款利息（表外）核销
    ,writeoffoutovdintamt -- 逾期贷款利息（表外）核销
    ,writeoffoutovdprinpnltamt -- 逾期本金罚息（表外）核销
    ,writeoffoutovdintpnltamt -- 逾期利息罚息（表外）核销
    ,writeoffintamt -- 已核销的贷款正常利息计提
    ,writeoffovdprinpnltamt -- 已核销的贷款逾期本金罚息计提
    ,writeoffovdintpnltamt -- 已核销的贷款逾期利息罚息计提
    ,writeoffprintoovdprinamt -- 已核销的贷款本金转逾期
    ,writeoffinttoovdintamt -- 已核销的贷款利息转逾期
    ,paidwriteoffprinamt -- 实还已核销正常本金
    ,paidwriteoffovdprinamt -- 实还已核销逾期本金
    ,paidwriteoffintamt -- 实还已核销正常利息
    ,paidwriteoffovdintamt -- 实还已核销逾期利息
    ,paidwriteoffovdprinpnltintamt -- 实还已核销本金罚息
    ,paidwriteoffovdintpnltintamt -- 实还已核销利息罚息
    ,exemptwriteoffintamt -- 减免已核销正常利息
    ,exemptwriteoffovdintamt -- 减免已核销逾期利息
    ,exemptwriteoffovdprinpnltintamt -- 减免已核销本金罚息
    ,exemptwriteoffovdintpnltintamt -- 减免已核销利息罚息
    ,loantransitdeposit -- 放款待结算调拨回流金额
    ,repaytransitwithdraw -- 还款待结算调拨流入金额
    ,loantransitwithdraw -- 放款待结算调拨回流金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    settledate -- 
    ,regioncode -- 行政区划代码
    ,payablefeeamt -- 应付平台服务费汇总金额
    ,feeamt -- 实付平台服务费汇总金额
    ,receivablesubsidyintamt -- 贴息计提(表内)
    ,paidsubsidyintamt -- 实还贴息(表内)
    ,accruedintamt -- 短期正常/逾期90天以内(含)贷款计提每日利息(表内)
    ,nonaccruedintamt -- 短期逾期90天以上贷款计提每日利息(表外)
    ,encashamt -- 当天贷款发放金额
    ,accruedovdprinpnltamt -- 短期逾期90天以内(含)贷款计提每日逾期本金罚息(表内)
    ,nonaccruedovdprinpnltamt -- 短期逾期90天以上贷款计提每日逾期本金罚息(表外)
    ,accruedovdintpnltamt -- 短期逾期90天以内(含)贷款计提每日逾期利息罚息(表内)
    ,nonaccruedovdintpnltamt -- 短期逾期90天以上贷款计提每日逾期利息罚息(表外)
    ,printoovdprinamt -- 正常本金转逾期本金
    ,inttoovdintamt -- 正常利息转逾期利息
    ,nonprintononovdprinamt -- 正常本金(非应计)转逾期本金(非应计)
    ,outinttooutovdintamt -- 正常利息(表外)转逾期利息(表外)
    ,accruedtononprinamt -- 正常本金(应计)转正常本金(非应计)
    ,accruedtononovdprinamt -- 逾期本金(应计)转逾期本金(非应计)
    ,internaltooutintamt -- 正常利息(表内)转正常利息(表外)
    ,internaltooutovdintamt -- 逾期利息(表内)转逾期利息(表外)
    ,internaltooutovdprinpnltamt -- 逾期本金罚息(表内)转逾期本金罚息(表外)
    ,internaltooutovdintpnltamt -- 逾期利息罚息(表内)转逾期利息罚息(表外)
    ,nontoaccruedprinamt -- 正常本金(非应计)转正常本金(应计)
    ,nontoaccruedovdprinamt -- 逾期本金(非应计)转逾期本金(应计)
    ,outtointernalintamt -- 正常利息(表外)转正常利息(表内)
    ,outtointernalovdintamt -- 逾期利息(表外)转逾期利息(表内)
    ,outtointernalovdprinpnltamt -- 逾期本金罚息(表外)转逾本金罚息(表内)
    ,outtointernalovdintpnltamt -- 逾期利息罚息(表外)转逾期利息罚息(表内)
    ,paidprinamt -- 实还正常本金(应计)
    ,paidnonaccruedprinamt -- 实还正常本金(非应计)
    ,paidaccruedovdprinamt -- 实还逾期本金(应计)
    ,paidnonaccruedovdprinamt -- 实还逾期本金(非应计)
    ,paidintamt -- 实还正常利息(表内)
    ,paidoutintamt -- 实还正常利息(表外)
    ,paidinternalovdintamt -- 实还逾期利息(表内)
    ,paidoutovdintamt -- 实还逾期利息(表外)
    ,paidinternalovdprinpnltintamt -- 实还逾期本金罚息(表内)
    ,paidoutovdprinpnltintamt -- 实还逾期本金罚息(表外)
    ,paidinternalovdintpnltintamt -- 实还逾期利息罚息(表内)
    ,paidoutovdintpnltintamt -- 实还逾期利息罚息(表外)
    ,exemptintamt -- 减免正常利息(表内)
    ,exemptoutintamt -- 减免正常利息(表外)
    ,exemptinternalovdintamt -- 减免逾期利息(表内)
    ,exemptoutovdintamt -- 减免逾期利息(表外)
    ,exemptinternalovdprinpnltintamt -- 减免逾期本金罚息(表内)
    ,exemptoutovdprinpnltintamt -- 减免逾期本金罚息(表外)
    ,exemptinternalovdintpnltintamt -- 减免逾期利息罚息(表内)
    ,exemptoutovdintpnltintamt -- 减免逾期利息罚息(表外)
    ,printoprinamtrlv -- 正常本金转正常本金
    ,ovdprintoprinamtrlv -- 逾期本金转正常本金
    ,nontoprinamtrlv -- 正常本金(非应计)转正常本金
    ,nonprintoprinamtrlv -- 逾期本金(非应计)转正常本金
    ,inttointamtrlv -- 正常利息转正常利息
    ,outinttointamtrlv -- 正常利息(表外)转正常利息
    ,ovdinttointamtrlv -- 逾期利息(表内)转正常利息
    ,outovdinttointamtrlv -- 逾期利息(表外)转正常利息
    ,writeoffovdprintoprinamtrlv -- 逾期本金（核销）转正常本金
    ,writeoffovdinttointamtrlv -- 逾期利息（核销）转正常利息
    ,printoprinamtinst -- 正常本金转正常本金
    ,ovdprintoprinamtinst -- 逾期本金转正常本金
    ,nonaccruedprinamtinst -- 正常本金(非应计)转正常本金
    ,nonaccruedtoprinamtinst -- 逾期本金(非应计)转正常本金
    ,writeoffprintoprinamtinst -- 正常本金（核销）转正常本金
    ,printoprinmedium -- 正常本金转正常本金
    ,nonprintoprinmedium -- 正常本金（非应计）转正常本金（应计）
    ,wfprintoprinmedium -- 正常本金（核销）转正常本金（应计）
    ,writeoffnonprinamt -- 已减值正常贷款本金核销
    ,writeoffnonovdprinamt -- 已减值逾期贷款本金核销
    ,writeoffoutintamt -- 正常贷款利息（表外）核销
    ,writeoffoutovdintamt -- 逾期贷款利息（表外）核销
    ,writeoffoutovdprinpnltamt -- 逾期本金罚息（表外）核销
    ,writeoffoutovdintpnltamt -- 逾期利息罚息（表外）核销
    ,writeoffintamt -- 已核销的贷款正常利息计提
    ,writeoffovdprinpnltamt -- 已核销的贷款逾期本金罚息计提
    ,writeoffovdintpnltamt -- 已核销的贷款逾期利息罚息计提
    ,writeoffprintoovdprinamt -- 已核销的贷款本金转逾期
    ,writeoffinttoovdintamt -- 已核销的贷款利息转逾期
    ,paidwriteoffprinamt -- 实还已核销正常本金
    ,paidwriteoffovdprinamt -- 实还已核销逾期本金
    ,paidwriteoffintamt -- 实还已核销正常利息
    ,paidwriteoffovdintamt -- 实还已核销逾期利息
    ,paidwriteoffovdprinpnltintamt -- 实还已核销本金罚息
    ,paidwriteoffovdintpnltintamt -- 实还已核销利息罚息
    ,exemptwriteoffintamt -- 减免已核销正常利息
    ,exemptwriteoffovdintamt -- 减免已核销逾期利息
    ,exemptwriteoffovdprinpnltintamt -- 减免已核销本金罚息
    ,exemptwriteoffovdintpnltintamt -- 减免已核销利息罚息
    ,loantransitdeposit -- 放款待结算调拨回流金额
    ,repaytransitwithdraw -- 还款待结算调拨流入金额
    ,loantransitwithdraw -- 放款待结算调拨回流金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.icms_myhb_ac_summary_trans_03
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.icms_myhb_ac_summary_trans_03 exchange partition p_${batch_date} with table ${iol_schema}.icms_myhb_ac_summary_trans_03_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_myhb_ac_summary_trans_03 to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.icms_myhb_ac_summary_trans_03_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_myhb_ac_summary_trans_03',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);