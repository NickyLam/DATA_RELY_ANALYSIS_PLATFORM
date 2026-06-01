/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wph_repay_dtl_icmsi1
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
drop table ${iml_schema}.evt_wph_repay_dtl_icmsi1_tm purge;
alter table ${iml_schema}.evt_wph_repay_dtl add partition p_icmsi1 values ('icmsi1')(
        subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wph_repay_dtl modify partition p_icmsi1
    add subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wph_repay_dtl_icmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,repay_flow_num -- 还款流水号
    ,repay_perds -- 还款期数
    ,tran_dt -- 交易日期
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,paid_tot -- 实还总额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,paid_other_fee -- 实还其他费用
    ,repaybl_dt -- 应还款日期
    ,actl_repay_dt -- 实际还款日期
    ,ovdue_days -- 贷款逾期天数
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wph_repay_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_wph_payment_detail-1
insert into ${iml_schema}.evt_wph_repay_dtl_icmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 借据编号
    ,dubil_id -- 还款流水号
    ,tran_dt -- 还款期数
    ,prod_id -- 交易日期
    ,repay_perds -- 产品编号
    ,curr_cd -- 币种代码
    ,paid_tot -- 实还总额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_pnlt -- 实还罚息
    ,paid_comp_int -- 实还复利
    ,paid_other_fee -- 实还其他费用
    ,repaybl_dt -- 应还款日期
    ,actl_repay_dt -- 实际还款日期
    ,ovdue_days -- 贷款逾期天数
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401051'||P1.RECEIPTNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.RECEIPTNO -- 借据编号
    ,P1.INTERNALKEY -- 还款流水号
    ,${iml_schema}.dateformat_max2(P1.TRANDATE) -- 还款期数
    ,P1.PRODTYPE -- 交易日期
    ,P1.RECSTAGENO -- 产品编号
    ,P1.CCY -- 币种代码
    ,P1.RECEIPTAMT -- 实还总额
    ,P1.RECPRIAMT -- 实还本金
    ,P1.RECINTAMT -- 实还利息
    ,P1.RECODPAMT -- 实还罚息
    ,P1.RECODIAMT -- 实还复利
    ,P1.RECFEEAMT -- 实还其他费用
    ,${iml_schema}.dateformat_max2(P1.PAYDATE) -- 应还款日期
    ,${iml_schema}.dateformat_max2(P1.ACTREPAYDATE) -- 实际还款日期
    ,P1.OVEDATE -- 贷款逾期天数
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wph_payment_detail' -- 源表名称
    ,'icmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wph_payment_detail p1
where  1 = 1 
and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wph_repay_dtl truncate subpartition p_icmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wph_repay_dtl exchange subpartition p_icmsi1_${batch_date} with table ${iml_schema}.evt_wph_repay_dtl_icmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wph_repay_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wph_repay_dtl_icmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wph_repay_dtl', partname => 'p_icmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);