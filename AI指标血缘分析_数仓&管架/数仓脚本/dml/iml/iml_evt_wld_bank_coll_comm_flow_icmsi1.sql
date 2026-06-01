/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_wld_bank_coll_comm_flow_icmsi1
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
drop table ${iml_schema}.evt_wld_bank_coll_comm_flow_icmsi1_tm purge;
alter table ${iml_schema}.evt_wld_bank_coll_comm_flow add partition p_icmsi1 values ('icmsi1')(
        subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_wld_bank_coll_comm_flow modify partition p_icmsi1
    add subpartition p_icmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_bank_coll_comm_flow_icmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,comm_dt -- 佣金日期
    ,logic_card_no -- 逻辑卡号
    ,dubil_id -- 借据编号
    ,ovdue_days -- 贷款逾期天数
    ,repay_dt -- 还款日期
    ,repay_amt -- 还款金额
    ,syn_id -- 银团编号
    ,bank_id -- 银行编号
    ,bank_contri_ratio -- 银行出资比例
    ,outsourc_fee_rat -- 委外费率
    ,outsourc_fee -- 委外费用
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_wld_bank_coll_comm_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_res_ds_bank_no_dca_commission_day_coop-1
insert into ${iml_schema}.evt_wld_bank_coll_comm_flow_icmsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,ser_num -- 序列号
    ,comm_dt -- 佣金日期
    ,logic_card_no -- 逻辑卡号
    ,dubil_id -- 借据编号
    ,ovdue_days -- 贷款逾期天数
    ,repay_dt -- 还款日期
    ,repay_amt -- 还款金额
    ,syn_id -- 银团编号
    ,bank_id -- 银行编号
    ,bank_contri_ratio -- 银行出资比例
    ,outsourc_fee_rat -- 委外费率
    ,outsourc_fee -- 委外费用
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102063'||P1.REFNBR||P2.LOANRECEIPTNBR||P1.PARTITIONDATE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.REFNBR -- 序列号
    ,${iml_schema}.DATEFORMAT_MIN(P1.PARTITIONDATE) -- 佣金日期
    ,P1.CARDNO -- 逻辑卡号
    ,nvl(P2.LOANRECEIPTNBR,' ') -- 借据编号
    ,P1.DUEDAYS -- 贷款逾期天数
    ,P1.REPAYDATE -- 还款日期
    ,P1.REPAYAMT -- 还款金额
    ,P1.BANKGROUPID -- 银团编号
    ,P1.BANKNO -- 银行编号
    ,P1.BANKPROPORTION*100 -- 银行出资比例
    ,P1.COMMISSIONRATIO*100 -- 委外费率
    ,P1.OUTEXPENSE -- 委外费用
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_res_ds_bank_no_dca_commission_day_coop' -- 源表名称
    ,'icmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.icms_res_ds_bank_no_dca_commission_day_coop p1
  left join ${iol_schema}.icms_wld_tm_loan p2
    on p1.refnbr = p2.refnbr
   and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
 where p1.partitiondate = '${batch_date}'
   and p1.bankgroupid in ('GHB06','GHB07')
   ;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_wld_bank_coll_comm_flow truncate subpartition p_icmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_wld_bank_coll_comm_flow exchange subpartition p_icmsi1_${batch_date} with table ${iml_schema}.evt_wld_bank_coll_comm_flow_icmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_wld_bank_coll_comm_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_wld_bank_coll_comm_flow_icmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_wld_bank_coll_comm_flow', partname => 'p_icmsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);