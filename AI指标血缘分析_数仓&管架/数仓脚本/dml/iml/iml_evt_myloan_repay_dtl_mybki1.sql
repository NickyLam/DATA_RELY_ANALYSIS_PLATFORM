/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_myloan_repay_dtl_mybki1
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
drop table ${iml_schema}.evt_myloan_repay_dtl_mybki1_tm purge;
alter table ${iml_schema}.evt_myloan_repay_dtl add partition p_mybki1 values ('mybki1')(
        subpartition p_mybki1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_myloan_repay_dtl modify partition p_mybki1
    add subpartition p_mybki1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_myloan_repay_dtl_mybki1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_dt -- 还款日期
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,repay_wdraw_odd_no -- 还款提现单号
    ,rpbl_nomal_pric -- 应还正常本金
    ,rpbl_ovdue_pric -- 应还逾期本金
    ,rpbl_nomal_int -- 应还正常利息
    ,rpbl_ovdue_int -- 应还逾期利息
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,rpbl_tot_amt -- 应还总金额
    ,paid_nomal_pric -- 实还正常本金
    ,paid_ovdue_pric -- 实还逾期本金
    ,paid_nomal_int -- 实还正常利息
    ,paid_ovdue_int -- 实还逾期利息
    ,paid_ovdue_pric_pnlt -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt -- 实还逾期利息罚息
    ,repay_type_cd -- 还款类型代码
    ,bf_repay_acru_flg -- 还款前应计标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_myloan_repay_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_mybk_repay_cont_tail-
insert into ${iml_schema}.evt_myloan_repay_dtl_mybki1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_dt -- 还款日期
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,repay_wdraw_odd_no -- 还款提现单号
    ,rpbl_nomal_pric -- 应还正常本金
    ,rpbl_ovdue_pric -- 应还逾期本金
    ,rpbl_nomal_int -- 应还正常利息
    ,rpbl_ovdue_int -- 应还逾期利息
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,rpbl_tot_amt -- 应还总金额
    ,paid_nomal_pric -- 实还正常本金
    ,paid_ovdue_pric -- 实还逾期本金
    ,paid_nomal_int -- 实还正常利息
    ,paid_ovdue_int -- 实还逾期利息
    ,paid_ovdue_pric_pnlt -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt -- 实还逾期利息罚息
    ,repay_type_cd -- 还款类型代码
    ,bf_repay_acru_flg -- 还款前应计标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102003'||P1.SEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MAX2(P1.REPAYDATE) -- 还款日期
    ,P1.SEQNO -- 还款流水号
    ,P1.CONTRACTNO -- 借据编号
    ,P1.WITHDRAWNO -- 还款提现单号
    ,P1.CURRPRINBAL -- 应还正常本金
    ,P1.CURROVDPRINBAL -- 应还逾期本金
    ,P1.CURRINTBAL -- 应还正常利息
    ,P1.CURROVDINTBAL -- 应还逾期利息
    ,P1.CURROVDPRINPNLTBAL -- 应还逾期本金罚息
    ,P1.CURROVDINTPNLTBAL -- 应还逾期利息罚息
    ,P1.REPAYAMT -- 应还总金额
    ,P1.PAIDPRINAMT -- 实还正常本金
    ,P1.PAIDOVDPRINAMT -- 实还逾期本金
    ,P1.PAIDINTAMT -- 实还正常利息
    ,P1.PAIDOVDINTAMT -- 实还逾期利息
    ,P1.PAIDOVDPRINPNLTAMT -- 实还逾期本金罚息
    ,P1.PAIDOVDINTPNLTAMT -- 实还逾期利息罚息
    ,NVL(TRIM(P1.REPAYTYPE),'00') -- 还款类型代码
    ,P1.BEFACCRUEDSTATUS -- 还款前应计标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_mybk_repay_cont_tail' -- 源表名称
    ,'mybki1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
   from ${iol_schema}.icms_mybk_repay_cont_tail p1
   left join ${iol_schema}.icms_mybk_acc_loan p2 
     on P1.CONTRACTNO = P2.CONTRACTNO 
    and P2.START_DT <= to_date('${batch_date}','yyyymmdd') 
    and p2.end_dt > to_date('${batch_date}','yyyymmdd')
  where replace(substr(P1.REPAYDATE,1,10),'-','') = '${batch_date}'
    and P1.ETL_DT = to_date('${batch_date}','yyyy-mm-dd')
    and p2.BIZTYPE <> '201020100057'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_myloan_repay_dtl truncate subpartition p_mybki1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_myloan_repay_dtl exchange subpartition p_mybki1_${batch_date} with table ${iml_schema}.evt_myloan_repay_dtl_mybki1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_myloan_repay_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_myloan_repay_dtl_mybki1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_myloan_repay_dtl', partname => 'p_mybki1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);