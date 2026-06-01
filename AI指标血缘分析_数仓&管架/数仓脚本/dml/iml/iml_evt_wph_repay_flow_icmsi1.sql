/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wph_repay_flow_icmsi1
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
drop table ${iml_schema}.evt_wph_repay_flow_icmsi1_tm purge;
alter table ${iml_schema}.evt_wph_repay_flow add partition p_icmsi1 values ('icmsi1')(
        subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wph_repay_flow modify partition p_icmsi1
    add subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wph_repay_flow_icmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,tran_dt -- 交易日期
    ,tran_ref_no -- 交易参考号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,callbk_type_cd -- 回收类型代码
    ,callbk_prod_way_cd -- 回收产生方式代码
    ,callbk_amt -- 回收金额
    ,actl_repay_dt -- 实际还款日期
    ,serv_fee_amt -- 服务费金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wph_repay_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_wph_payment_transaction-1
insert into ${iml_schema}.evt_wph_repay_flow_icmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,tran_dt -- 交易日期
    ,tran_ref_no -- 交易参考号
    ,prod_id -- 产品编号
    ,curr_cd -- 币种代码
    ,callbk_type_cd -- 回收类型代码
    ,callbk_prod_way_cd -- 回收产生方式代码
    ,callbk_amt -- 回收金额
    ,actl_repay_dt -- 实际还款日期
    ,serv_fee_amt -- 服务费金额
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401051'||P1.RECEIPTNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.RECEIPTNO -- 还款流水号
    ,P1.INTERNALKEY -- 借据编号
    ,${iml_schema}.dateformat_max2(P1.TRANDATE) -- 交易日期
    ,P1.REFERENCE -- 交易参考号
    ,P1.PRODTYPE -- 产品编号
    ,P1.CCY -- 币种代码
    ,nvl(trim(P1.RECEIPTTYPE),'-') -- 回收类型代码
    ,nvl(trim(P1.RECEIPTGENCODE),'00') -- 回收产生方式代码
    ,P1.RECAMT -- 回收金额
    ,${iml_schema}.dateformat_max2(P1.ACTREPAYDATE) -- 实际还款日期
    ,P1.FEEAMT -- 服务费金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_wph_payment_transaction' -- 源表名称
    ,'icmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_wph_payment_transaction p1
where  1 = 1 
and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wph_repay_flow truncate subpartition p_icmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wph_repay_flow exchange subpartition p_icmsi1_${batch_date} with table ${iml_schema}.evt_wph_repay_flow_icmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wph_repay_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wph_repay_flow_icmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wph_repay_flow', partname => 'p_icmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);