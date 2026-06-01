/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_ul_receipt
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
drop table ${iol_schema}.ncbs_ul_receipt_ex purge;
alter table ${iol_schema}.ncbs_ul_receipt add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_ul_receipt truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_ul_receipt_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_ul_receipt where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_ul_receipt_ex(
    receipt_no -- 回收号|回收号
    ,batch_no -- 批次号|批次号
    ,cmisloan_no -- 客户借据编号|客户借据编号
    ,tran_branch -- 核心交易机构编号|核心交易机构编号
    ,receipt_date -- 贷款还款日期|贷款还款日期
    ,receipt_type -- 还款类型|还款类型|ns-正常回收,er-提前回收,ep-逾期提前还本,po-结清,wv-利息豁免,df-债权减免,tr-终止
    ,client_no -- 客户编号|客户编号
    ,ccy -- 币种|币种
    ,repay_total_amt -- 还款总金额|还款总金额
    ,pri_amt -- 本金金额|本金金额
    ,int_amt -- 利息金额|利息金额
    ,odp_amt -- 罚息金额|罚息金额
    ,odi_amt -- 复利金额|复利金额
    ,tran_date -- 交易日期|交易日期
    ,receipt_gen_code -- 回收产生方式 |回收产生方式|m-人工,a-自动
    ,accounting_status -- 核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止
    ,company -- 法人|法人
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,ul_partner_reference -- 联合贷合作方交易流水号|联合贷合作方交易流水号
    ,intp_amt -- 逾期利息
    ,prd_amt -- 逾期本金
    ,pre_intp_amt -- 还款前应收未收逾期利息
    ,pre_int_amt -- 还款前应收未收的正常利息
    ,pre_odi_amt -- 还款前应收未收复利
    ,pre_odp_amt -- 还款前应收未收罚息
    ,pre_prd_amt -- 还款前应收未收的逾期本金
    ,pre_pri_amt -- 还款前应收未收的正常本金
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    receipt_no -- 回收号|回收号
    ,batch_no -- 批次号|批次号
    ,cmisloan_no -- 客户借据编号|客户借据编号
    ,tran_branch -- 核心交易机构编号|核心交易机构编号
    ,receipt_date -- 贷款还款日期|贷款还款日期
    ,receipt_type -- 还款类型|还款类型|ns-正常回收,er-提前回收,ep-逾期提前还本,po-结清,wv-利息豁免,df-债权减免,tr-终止
    ,client_no -- 客户编号|客户编号
    ,ccy -- 币种|币种
    ,repay_total_amt -- 还款总金额|还款总金额
    ,pri_amt -- 本金金额|本金金额
    ,int_amt -- 利息金额|利息金额
    ,odp_amt -- 罚息金额|罚息金额
    ,odi_amt -- 复利金额|复利金额
    ,tran_date -- 交易日期|交易日期
    ,receipt_gen_code -- 回收产生方式 |回收产生方式|m-人工,a-自动
    ,accounting_status -- 核算状态|核算状态，为贷款核算状态类型，会计部门根据借款凭证针对借款合同进行审核的贷款核算分级审批制度|zhc-正常,yuq-逾期,fyj-非应计,fy-手工转非应计,dza-呆账,dzi-呆滞,wrn-核销,ter-终止
    ,company -- 法人|法人
    ,tran_timestamp -- 交易时间戳|交易时间戳
    ,ul_partner_reference -- 联合贷合作方交易流水号|联合贷合作方交易流水号
    ,intp_amt -- 逾期利息
    ,prd_amt -- 逾期本金
    ,pre_intp_amt -- 还款前应收未收逾期利息
    ,pre_int_amt -- 还款前应收未收的正常利息
    ,pre_odi_amt -- 还款前应收未收复利
    ,pre_odp_amt -- 还款前应收未收罚息
    ,pre_prd_amt -- 还款前应收未收的逾期本金
    ,pre_pri_amt -- 还款前应收未收的正常本金
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_ul_receipt
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_ul_receipt exchange partition p_${batch_date} with table ${iol_schema}.ncbs_ul_receipt_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_ul_receipt to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_ul_receipt_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_ul_receipt',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);