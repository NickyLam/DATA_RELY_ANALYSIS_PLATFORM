/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_accti_midgrod_acct_ety_tglsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_accti_midgrod_acct_ety_tglsi1_tm purge;
alter table ${iml_schema}.evt_accti_midgrod_acct_ety add partition p_tglsi1 values ('tglsi1')(
        subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_accti_midgrod_acct_ety modify partition p_tglsi1
    add subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_accti_midgrod_acct_ety_tglsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,sob_id -- 账套编号
    ,bus_sys_id -- 业务系统编号
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,sumos_seq_num -- 传票序号
    ,sumos_id -- 传票编号
    ,tran_org_id -- 交易机构编号
    ,fin_org_id -- 财务机构编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,batch_no -- 批次号
    ,tran_tm -- 交易时间
    ,curr_cd -- 币种代码
    ,off_bs_flg -- 表外标志
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,acct_id -- 账户编号
    ,cash_trans_flg_cd -- 现转标志代码
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,tran_amt -- 交易金额
    ,tran_bal -- 交易余额
    ,memo_id -- 摘要编号
    ,memo_descb -- 摘要描述
    ,convt_exch_rat -- 折算汇率
    ,user_id -- 用户编号
    ,sorc_sys_dt -- 源系统日期
    ,sorc_sys_flow_num -- 源系统流水号
    ,src_sys_cd -- 源系统代码
    ,src_tran_flow_seq_num -- 源交易流水序号
    ,chn_id -- 渠道编号
    ,sellbl_prod_id -- 可售产品编号
    ,clear_status_cd -- 清算状态代码
    ,clear_flow_num -- 清算流水号
    ,clear_dt -- 清算日期
    ,enter_acct_status_cd -- 入账状态代码
    ,src_sob_id -- 源账套编号
    ,revs_status_cd -- 冲正状态代码
    ,init_bus_dt -- 原业务日期
    ,init_bus_flow_num -- 原业务流水号
    ,stand_mony_amt -- 本位币金额
    ,aldy_sync_flg -- 已同步标志
    ,ova_flow_num -- 全局流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_accti_midgrod_acct_ety
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- tgls_gla_vchr_h-1
insert into ${iml_schema}.evt_accti_midgrod_acct_ety_tglsi1_tm(
    evt_id -- 事件编号
    ,sob_id -- 账套编号
    ,bus_sys_id -- 业务系统编号
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,sumos_seq_num -- 传票序号
    ,sumos_id -- 传票编号
    ,tran_org_id -- 交易机构编号
    ,fin_org_id -- 财务机构编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,batch_no -- 批次号
    ,tran_tm -- 交易时间
    ,curr_cd -- 币种代码
    ,off_bs_flg -- 表外标志
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,acct_id -- 账户编号
    ,cash_trans_flg_cd -- 现转标志代码
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,tran_amt -- 交易金额
    ,tran_bal -- 交易余额
    ,memo_id -- 摘要编号
    ,memo_descb -- 摘要描述
    ,convt_exch_rat -- 折算汇率
    ,user_id -- 用户编号
    ,sorc_sys_dt -- 源系统日期
    ,sorc_sys_flow_num -- 源系统流水号
    ,src_sys_cd -- 源系统代码
    ,src_tran_flow_seq_num -- 源交易流水序号
    ,chn_id -- 渠道编号
    ,sellbl_prod_id -- 可售产品编号
    ,clear_status_cd -- 清算状态代码
    ,clear_flow_num -- 清算流水号
    ,clear_dt -- 清算日期
    ,enter_acct_status_cd -- 入账状态代码
    ,src_sob_id -- 源账套编号
    ,revs_status_cd -- 冲正状态代码
    ,init_bus_dt -- 原业务日期
    ,init_bus_flow_num -- 原业务流水号
    ,stand_mony_amt -- 本位币金额
    ,aldy_sync_flg -- 已同步标志
    ,ova_flow_num -- 全局流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401006'||p1.transq -- 事件编号
    ,p1.stacid -- 账套编号
    ,p1.systid -- 业务系统编号
    ,${iml_schema}.dateformat_min(p1.trandt) -- 交易日期
    ,p1.transq -- 交易流水号
    ,p1.vchrsq -- 传票序号
    ,p1.dcmtno -- 传票编号
    ,p1.tranbr -- 交易机构编号
    ,p1.acctbr -- 财务机构编号
    ,p1.itemcd -- 科目编号
    ,p1.itemna -- 科目名称
    ,p1.bathid -- 批次号
    ,p1.tranti -- 交易时间
    ,p1.crcycd -- 币种代码
    ,decode(trim(p1.ioflag),'o','1','i','0','','-') -- 表外标志
    ,p1.custcd -- 客户编号
    ,p1.prducd -- 产品编号
    ,p1.acctno -- 账户编号
    ,decode(trim(p1.trantp),'tr','1','cs','0','','-') -- 现转标志代码
    ,p1.amntcd -- 借贷方向代码
    ,p1.tranam -- 交易金额
    ,p1.tranbl -- 交易余额
    ,p1.smrycd -- 摘要编号
    ,p1.smrytx -- 摘要描述
    ,p1.exchus -- 折算汇率
    ,p1.usercd -- 用户编号
    ,${iml_schema}.dateformat_min(p1.sourdt) -- 源系统日期
    ,p1.soursq -- 源系统流水号
    ,p1.sourst -- 源系统代码
    ,p1.srvcsq -- 源交易流水序号
    ,p1.assis0 -- 渠道编号
    ,p1.assis1 -- 可售产品编号
    ,p1.clertg -- 清算状态代码
    ,p1.centsq -- 清算流水号
    ,${iml_schema}.dateformat_min(p1.clerdt) -- 清算日期
    ,p1.transt -- 入账状态代码
    ,p1.sourac -- 源账套编号
    ,p1.strkst -- 冲正状态代码
    ,${iml_schema}.dateformat_min(p1.odbsdt) -- 原业务日期
    ,p1.odbssq -- 原业务流水号
    ,p1.foldcn -- 本位币金额
    ,p1.istbgz -- 已同步标志
    ,p1.bsnssq -- 全局流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- etl处理日期
    ,'tgls_gla_vchr_h' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- etl处理时间戳
from ${iol_schema}.tgls_gla_vchr_h p1
where  1 = 1 
     and P1.stacid = '1'
     and p1.trandt = '${batch_date}'
;
commit;

-- tgls_gla_vchr-1
insert into ${iml_schema}.evt_accti_midgrod_acct_ety_tglsi1_tm(
    evt_id -- 事件编号
    ,sob_id -- 账套编号
    ,bus_sys_id -- 业务系统编号
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,sumos_seq_num -- 传票序号
    ,sumos_id -- 传票编号
    ,tran_org_id -- 交易机构编号
    ,fin_org_id -- 财务机构编号
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,batch_no -- 批次号
    ,tran_tm -- 交易时间
    ,curr_cd -- 币种代码
    ,off_bs_flg -- 表外标志
    ,cust_id -- 客户编号
    ,prod_id -- 产品编号
    ,acct_id -- 账户编号
    ,cash_trans_flg_cd -- 现转标志代码
    ,debit_crdt_dir_cd -- 借贷方向代码
    ,tran_amt -- 交易金额
    ,tran_bal -- 交易余额
    ,memo_id -- 摘要编号
    ,memo_descb -- 摘要描述
    ,convt_exch_rat -- 折算汇率
    ,user_id -- 用户编号
    ,sorc_sys_dt -- 源系统日期
    ,sorc_sys_flow_num -- 源系统流水号
    ,src_sys_cd -- 源系统代码
    ,src_tran_flow_seq_num -- 源交易流水序号
    ,chn_id -- 渠道编号
    ,sellbl_prod_id -- 可售产品编号
    ,clear_status_cd -- 清算状态代码
    ,clear_flow_num -- 清算流水号
    ,clear_dt -- 清算日期
    ,enter_acct_status_cd -- 入账状态代码
    ,src_sob_id -- 源账套编号
    ,revs_status_cd -- 冲正状态代码
    ,init_bus_dt -- 原业务日期
    ,init_bus_flow_num -- 原业务流水号
    ,stand_mony_amt -- 本位币金额
    ,aldy_sync_flg -- 已同步标志
    ,ova_flow_num -- 全局流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401006'||p1.transq -- 事件编号
    ,p1.stacid -- 账套编号
    ,p1.systid -- 业务系统编号
    ,${iml_schema}.dateformat_min(p1.trandt) -- 交易日期
    ,p1.transq -- 交易流水号
    ,p1.vchrsq -- 传票序号
    ,p1.dcmtno -- 传票编号
    ,p1.tranbr -- 交易机构编号
    ,p1.acctbr -- 财务机构编号
    ,p1.itemcd -- 科目编号
    ,p1.itemna -- 科目名称
    ,p1.bathid -- 批次号
    ,p1.tranti -- 交易时间
    ,p1.crcycd -- 币种代码
    ,decode(trim(p1.ioflag),'o','1','i','0','','-') -- 表外标志
    ,p1.custcd -- 客户编号
    ,p1.prducd -- 产品编号
    ,p1.acctno -- 账户编号
    ,decode(trim(p1.trantp),'tr','1','cs','0','','-') -- 现转标志代码
    ,p1.amntcd -- 借贷方向代码
    ,p1.tranam -- 交易金额
    ,p1.tranbl -- 交易余额
    ,p1.smrycd -- 摘要编号
    ,p1.smrytx -- 摘要描述
    ,p1.exchus -- 折算汇率
    ,p1.usercd -- 用户编号
    ,${iml_schema}.dateformat_min(p1.sourdt) -- 源系统日期
    ,p1.soursq -- 源系统流水号
    ,p1.sourst -- 源系统代码
    ,p1.srvcsq -- 源交易流水序号
    ,p1.assis0 -- 渠道编号
    ,p1.assis1 -- 可售产品编号
    ,p1.clertg -- 清算状态代码
    ,p1.centsq -- 清算流水号
    ,${iml_schema}.dateformat_min(p1.clerdt) -- 清算日期
    ,p1.transt -- 入账状态代码
    ,p1.sourac -- 源账套编号
    ,p1.strkst -- 冲正状态代码
    ,${iml_schema}.dateformat_min(p1.odbsdt) -- 原业务日期
    ,p1.odbssq -- 原业务流水号
    ,p1.foldcn -- 本位币金额
    ,p1.istbgz -- 已同步标志
    ,p1.bsnssq -- 全局流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- etl处理日期
    ,'tgls_gla_vchr' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- etl处理时间戳
from ${iol_schema}.tgls_gla_vchr p1
 left join ${iol_schema}.tgls_gla_vchr_h p2
   on p2.transq = p1.transq
  and p2.vchrsq = p1.vchrsq
  and p2.systid = p1.systid
  and P2.stacid = P1.stacid 
  and p2.etl_dt = to_date('${batch_date}','yyyymmdd') 
  and p2.trandt = '${batch_date}'
 where 1 = 1
  and p1.etl_dt = to_date('${batch_date}','yyyymmdd') 
  and p1.trandt = '${batch_date}'
  and P1.stacid = '1'
  and p2.transq is null
;
commit;


-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_accti_midgrod_acct_ety truncate subpartition p_tglsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_accti_midgrod_acct_ety exchange subpartition p_tglsi1_${batch_date} with table ${iml_schema}.evt_accti_midgrod_acct_ety_tglsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_accti_midgrod_acct_ety to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_accti_midgrod_acct_ety_tglsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_accti_midgrod_acct_ety', partname => 'p_tglsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);