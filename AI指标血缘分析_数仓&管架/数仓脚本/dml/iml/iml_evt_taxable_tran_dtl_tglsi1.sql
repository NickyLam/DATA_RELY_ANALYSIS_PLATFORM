/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_taxable_tran_dtl_tglsi1
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
drop table ${iml_schema}.evt_taxable_tran_dtl_tglsi1_tm purge;
alter table ${iml_schema}.evt_taxable_tran_dtl add partition p_tglsi1 values ('tglsi1')(
        subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_taxable_tran_dtl modify partition p_tglsi1
    add subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_taxable_tran_dtl_tglsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,taxable_flow_num -- 应税流水号
    ,tran_flow_num -- 交易流水号
    ,sob_id -- 账套编号
    ,bus_sys_id -- 来源系统编号
    ,tran_dt -- 交易日期
    ,sumos_seq_num -- 传票序号
    ,tran_org_id -- 交易机构编号
    ,acct_instit_id -- 账务机构编号
    ,cust_id -- 客户编号
    ,bus_cate_cd -- 业务类别代码
    ,tran_curr_cd -- 交易币种代码
    ,tax_inc_tran_amt -- 含税交易金额
    ,tax_rat -- 税率
    ,tax_amt -- 税额
    ,exclude_tax_tran_amt -- 不含税交易金额
    ,remark -- 备注
    ,tran_status_cd -- 交易状态代码
    ,tax_way_cd -- 计税方式代码
    ,taxable_idf_cd -- 应税标识代码
    ,tax_item_id -- 税目编号
    ,open_invoice_curr_cd -- 开票币种代码
    ,convt_exch_rat -- 折算汇率
    ,net_price_convt_amt -- 净价折算金额
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,tax_lmt_convt_amt -- 税额折算金额
    ,net_price_subj_id -- 净价科目编号
    ,tax_lmt_subj_id -- 税额科目编号
    ,intnal_prod_id -- 内部产品编号
    ,bus_type_cd -- 业务类型代码
    ,prod_taxable_type_cd -- 产品应税类型代码
    ,loan_tis_tax_cd -- 贷款涉票涉税代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_taxable_tran_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- tgls_trb_txls-1
insert into ${iml_schema}.evt_taxable_tran_dtl_tglsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,taxable_flow_num -- 应税流水号
    ,tran_flow_num -- 交易流水号
    ,sob_id -- 账套编号
    ,bus_sys_id -- 来源系统编号
    ,tran_dt -- 交易日期
    ,sumos_seq_num -- 传票序号
    ,tran_org_id -- 交易机构编号
    ,acct_instit_id -- 账务机构编号
    ,cust_id -- 客户编号
    ,bus_cate_cd -- 业务类别代码
    ,tran_curr_cd -- 交易币种代码
    ,tax_inc_tran_amt -- 含税交易金额
    ,tax_rat -- 税率
    ,tax_amt -- 税额
    ,exclude_tax_tran_amt -- 不含税交易金额
    ,remark -- 备注
    ,tran_status_cd -- 交易状态代码
    ,tax_way_cd -- 计税方式代码
    ,taxable_idf_cd -- 应税标识代码
    ,tax_item_id -- 税目编号
    ,open_invoice_curr_cd -- 开票币种代码
    ,convt_exch_rat -- 折算汇率
    ,net_price_convt_amt -- 净价折算金额
    ,subj_id -- 科目编号
    ,subj_name -- 科目名称
    ,tax_lmt_convt_amt -- 税额折算金额
    ,net_price_subj_id -- 净价科目编号
    ,tax_lmt_subj_id -- 税额科目编号
    ,intnal_prod_id -- 内部产品编号
    ,bus_type_cd -- 业务类型代码
    ,prod_taxable_type_cd -- 产品应税类型代码
    ,loan_tis_tax_cd -- 贷款涉票涉税代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '302001'||P1.STACID||P1.SYSTID||P1.TRANDT||P1.TRANSQ||P1.VCHRSQ||P1.SERINO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SERINO -- 应税流水号
    ,P1.TRANSQ -- 交易流水号
    ,P1.STACID -- 账套编号
    ,P1.SYSTID -- 来源系统编号
    ,${iml_schema}.dateformat_min(P1.TRANDT) -- 交易日期
    ,P1.VCHRSQ -- 传票序号
    ,P1.TRANBR -- 交易机构编号
    ,P1.ACCTBR -- 账务机构编号
    ,P1.CUSTCD -- 客户编号
    ,P1.BUSITP -- 业务类别代码
    ,P1.CRCYCD -- 交易币种代码
    ,P1.TRANAM -- 含税交易金额
    ,P1.VATXRT -- 税率
    ,P1.TAXBAM -- 税额
    ,P1.PRICAM -- 不含税交易金额
    ,P1.SMRYTX -- 备注
    ,P1.STATUS -- 交易状态代码
    ,decode(trim(P1.CATXTP),'','-','N','0','S','1',P1.CATXTP) -- 计税方式代码
    ,P1.EXEPTG -- 应税标识代码
    ,P1.TYPECD -- 税目编号
    ,P1.CRCYIV -- 开票币种代码
    ,P1.EXCHRT -- 折算汇率
    ,P1.EXPRAM -- 净价折算金额
    ,P1.ITEMCD -- 科目编号
    ,P1.ITEMNA -- 科目名称
    ,P1.EXTXAM -- 税额折算金额
    ,P1.PRITEM -- 净价科目编号
    ,P1.TXITEM -- 税额科目编号
    ,P1.PRODCD -- 内部产品编号
    ,nvl(trim(P1.PRODP1),'-') -- 业务类型代码
    ,nvl(trim(P1.PRODP9),'-') -- 产品应税类型代码
    ,nvl(trim(P1.PRODPA),'-') -- 贷款涉票涉税代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_trb_txls' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.tgls_trb_txls p1
 where 1 = 1
   and p1.trandt = ${batch_date}
   and p1.stacid <> '3';
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_taxable_tran_dtl truncate subpartition p_tglsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_taxable_tran_dtl exchange subpartition p_tglsi1_${batch_date} with table ${iml_schema}.evt_taxable_tran_dtl_tglsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_taxable_tran_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_taxable_tran_dtl_tglsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_taxable_tran_dtl', partname => 'p_tglsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);