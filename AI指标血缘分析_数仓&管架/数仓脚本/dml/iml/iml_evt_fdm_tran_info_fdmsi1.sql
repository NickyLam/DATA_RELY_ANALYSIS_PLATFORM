/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_fdm_tran_info_fdmsi1
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
drop table ${iml_schema}.evt_fdm_tran_info_fdmsi1_tm purge;
alter table ${iml_schema}.evt_fdm_tran_info add partition p_fdmsi1 values ('fdmsi1')(
        subpartition p_fdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_fdm_tran_info modify partition p_fdmsi1
    add subpartition p_fdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_fdm_tran_info_fdmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_evt_id -- 源事件编号
    ,entry_dt -- 记账日期
    ,rept_tm -- 报告时间
    ,proc_tm -- 处理时间
    ,bus_flow_num -- 业务流水号
    ,tran_flow_num -- 交易流水号
    ,acct_num -- 账号
    ,acct_duty_center_id -- 账户责任中心编号
    ,tran_duty_center_id -- 交易责任中心编号
    ,curr_cd -- 币种代码
    ,prod_type_id -- 产品类型编号
    ,tran_cd -- 交易代码
    ,amt_dir_cd -- 金额方向代码
    ,group_int_cont_id -- 集团内往来编号
    ,chn_cd -- 渠道代码
    ,sorc_sys_cd -- 源系统代码
    ,amt -- 发生额
    ,bal -- 余额
    ,create_pay_id -- 创建的支付编号
    ,create_inv_id -- 创建的发票编号
    ,err_cd -- 错误码
    ,revs_flow_num -- 冲正流水号
    ,revs_status_cd -- 冲正状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_fdm_tran_info
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- fdms_fdm_trans_info-
insert into ${iml_schema}.evt_fdm_tran_info_fdmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,src_evt_id -- 源事件编号
    ,entry_dt -- 记账日期
    ,rept_tm -- 报告时间
    ,proc_tm -- 处理时间
    ,bus_flow_num -- 业务流水号
    ,tran_flow_num -- 交易流水号
    ,acct_num -- 账号
    ,acct_duty_center_id -- 账户责任中心编号
    ,tran_duty_center_id -- 交易责任中心编号
    ,curr_cd -- 币种代码
    ,prod_type_id -- 产品类型编号
    ,tran_cd -- 交易代码
    ,amt_dir_cd -- 金额方向代码
    ,group_int_cont_id -- 集团内往来编号
    ,chn_cd -- 渠道代码
    ,sorc_sys_cd -- 源系统代码
    ,amt -- 发生额
    ,bal -- 余额
    ,create_pay_id -- 创建的支付编号
    ,create_inv_id -- 创建的发票编号
    ,err_cd -- 错误码
    ,revs_flow_num -- 冲正流水号
    ,revs_status_cd -- 冲正状态代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102052'||P1.fdm_trans_info_id -- 事件编号
    ,'9999' -- 法人编号
    ,P1.fdm_trans_info_id -- 源事件编号
    ,P1.posting_date -- 记账日期
    ,P1.report_time -- 报告时间
    ,P1.process_date -- 处理时间
    ,P1.business_ref_num -- 业务流水号
    ,P1.transaction_ref_num -- 交易流水号
    ,P1.account_number -- 账号
    ,P1.acc_response_center_id -- 账户责任中心编号
    ,P1.trans_response_center_id -- 交易责任中心编号
    ,P1.currency_uom_id -- 币种代码
    ,P1.product_category_id -- 产品类型编号
    ,P1.transaction_id -- 交易代码
    ,P1.amount_direction -- 金额方向代码
    ,P1.within_organ_id -- 集团内往来编号
    ,P1.channel_id -- 渠道代码
    ,P1.origin_sys_id -- 源系统代码
    ,P1.amount -- 发生额
    ,P1.account_balance -- 余额
    ,P1.payment_id -- 创建的支付编号
    ,P1.invoice_id -- 创建的发票编号
    ,P1.error_code -- 错误码
    ,P1.flushes_seq -- 冲正流水号
    ,P1.flushes_status -- 冲正状态代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fdms_fdm_trans_info' -- 源表名称
    ,'fdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fdms_fdm_trans_info p1
where  1 = 1 
     AND P1.ETL_DT = TO_DATE('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_fdm_tran_info truncate subpartition p_fdmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_fdm_tran_info exchange subpartition p_fdmsi1_${batch_date} with table ${iml_schema}.evt_fdm_tran_info_fdmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_fdm_tran_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_fdm_tran_info_fdmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_fdm_tran_info', partname => 'p_fdmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);