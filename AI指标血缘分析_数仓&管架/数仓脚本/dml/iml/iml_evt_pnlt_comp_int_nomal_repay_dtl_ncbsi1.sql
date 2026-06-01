/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_pnlt_comp_int_nomal_repay_dtl_ncbsi1
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
drop table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl_ncbsi1_tm purge;
alter table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,advise_odd_no -- 通知单号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,bus_effect_dt -- 业务生效日期
    ,bus_invalid_dt -- 业务失效日期
    ,grace_dt -- 宽限日期
    ,doc_exp_dt -- 单据到期日期
    ,bus_tran_dt -- 业务交易日期
    ,tran_ref_no -- 交易参考号
    ,iss_amt -- 出单金额
    ,doc_bal -- 单据余额
    ,ld_doc_unpaid_amt -- 上日单据未还金额
    ,amt_type_cd -- 金额类型代码
    ,doc_create_way_cd -- 单据生成方式代码
    ,curr_pd -- 当前期次
    ,iss_flg -- 出单标志
    ,doc_full_amt_callbk_flg -- 单据全额回收标志
    ,final_stl_dt -- 最后结算日期
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_cl_invoice_od_detail-1
insert into ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl_ncbsi1_tm(
    evt_id -- 事件编号
    ,advise_odd_no -- 通知单号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,acct_id -- 账户编号
    ,bus_effect_dt -- 业务生效日期
    ,bus_invalid_dt -- 业务失效日期
    ,grace_dt -- 宽限日期
    ,doc_exp_dt -- 单据到期日期
    ,bus_tran_dt -- 业务交易日期
    ,tran_ref_no -- 交易参考号
    ,iss_amt -- 出单金额
    ,doc_bal -- 单据余额
    ,ld_doc_unpaid_amt -- 上日单据未还金额
    ,amt_type_cd -- 金额类型代码
    ,doc_create_way_cd -- 单据生成方式代码
    ,curr_pd -- 当前期次
    ,iss_flg -- 出单标志
    ,doc_full_amt_callbk_flg -- 单据全额回收标志
    ,final_stl_dt -- 最后结算日期
    ,tran_teller_id -- 交易柜员编号
    ,final_modif_dt -- 最后修改日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101072'||INVOICE_TRAN_NO -- 事件编号
    ,P1.INVOICE_TRAN_NO -- 通知单号
    ,'9999' -- 法人编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.START_DATE -- 业务生效日期
    ,P1.END_DATE -- 业务失效日期
    ,P1.GRACE_DATE -- 宽限日期
    ,P1.DUE_DATE -- 单据到期日期
    ,P1.TRAN_DATE -- 业务交易日期
    ,P1.REFERENCE -- 交易参考号
    ,P1.BILLED_AMT -- 出单金额
    ,P1.OUTSTANDING -- 单据余额
    ,P1.OUTSTANDING_PREV -- 上日单据未还金额
    ,P1.AMT_TYPE -- 金额类型代码
    ,P1.INVOICE_GEN_MODE -- 单据生成方式代码
    ,P1.STAGE_NO -- 当前期次
    ,DECODE(P1.INVOICE_FLAG,'Y','1','N','0') -- 出单标志
    ,DECODE(TRIM(P1.FULLY_SETTLED_FLAG),'','-','Y','1','N','0',P1.FULLY_SETTLED_FLAG) -- 单据全额回收标志
    ,P1.FINAL_SETTLE_DATE -- 最后结算日期
    ,P1.USER_ID -- 交易柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_invoice_od_detail' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_invoice_od_detail p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_pnlt_comp_int_nomal_repay_dtl_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_pnlt_comp_int_nomal_repay_dtl', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);