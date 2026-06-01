/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_myloan_repay_inst_flow_mybki1
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
drop table ${iml_schema}.evt_myloan_repay_inst_flow_mybki1_tm purge;
alter table ${iml_schema}.evt_myloan_repay_inst_flow add partition p_mybki1 values ('mybki1')(
        subpartition p_mybki1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_myloan_repay_inst_flow modify partition p_mybki1
    add subpartition p_mybki1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_myloan_repay_inst_flow_mybki1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pd_num -- 期次号
    ,repay_dt -- 还款日期
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,repay_wdraw_odd_no -- 还款提现单号
    ,repay_amt_type_cd -- 还款金额类型代码
    ,rpbl_nomal_pric -- 应还正常本金
    ,rpbl_nomal_int -- 应还正常利息
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,paid_tot_amt -- 实还总金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_ovdue_pric_pnlt -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt -- 实还逾期利息罚息
    ,bf_repay_acru_non_acru_flg -- 还款前应计非应计标志
    ,modif_bf_status_cd -- 变更前状态代码
    ,wrt_off_flg -- 核销标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_myloan_repay_inst_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_mybk_repay_detail-
insert into ${iml_schema}.evt_myloan_repay_inst_flow_mybki1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,pd_num -- 期次号
    ,repay_dt -- 还款日期
    ,repay_flow_num -- 还款流水号
    ,dubil_id -- 借据编号
    ,repay_wdraw_odd_no -- 还款提现单号
    ,repay_amt_type_cd -- 还款金额类型代码
    ,rpbl_nomal_pric -- 应还正常本金
    ,rpbl_nomal_int -- 应还正常利息
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,paid_tot_amt -- 实还总金额
    ,paid_pric -- 实还本金
    ,paid_int -- 实还利息
    ,paid_ovdue_pric_pnlt -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt -- 实还逾期利息罚息
    ,bf_repay_acru_non_acru_flg -- 还款前应计非应计标志
    ,modif_bf_status_cd -- 变更前状态代码
    ,wrt_off_flg -- 核销标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102023'||P1.TERMNO||P1.SEQNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TERMNO -- 期次号
    ,${iml_schema}.dateformat_max2(P1.REPAYDATE) -- 还款日期
    ,P1.SEQNO -- 还款流水号
    ,P1.CONTRACTNO -- 借据编号
    ,P1.WITHDRAWNO -- 还款提现单号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.REPAYAMTTYPE END -- 还款金额类型代码
    ,P1.CURRPRINBAL/100 -- 应还正常本金
    ,P1.CURRINTBAL/100 -- 应还正常利息
    ,P1.CURROVDPRINPNLTBAL/100 -- 应还逾期本金罚息
    ,P1.CURROVDINTPNLTBAL/100 -- 应还逾期利息罚息
    ,P1.REPAYAMT/100 -- 实还总金额
    ,P1.PAIDPRINAMT/100 -- 实还本金
    ,P1.PAIDINTAMT/100 -- 实还利息
    ,P1.PAIDOVDPRINPNLTAMT/100 -- 实还逾期本金罚息
    ,P1.PAIDOVDINTPNLTAMT/100 -- 实还逾期利息罚息
    ,P1.BEFACCRUEDSTATUS -- 还款前应计非应计标志
    ,P1.BEFSTATUS -- 变更前状态代码
    ,P1.WRITEOFF -- 核销标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_mybk_repay_detail' -- 源表名称
    ,'mybki1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_mybk_repay_detail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.REPAYAMTTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_MYBK_REPAY_DETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'REPAYAMTTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_MYLOAN_REPAY_INST_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REPAY_AMT_TYPE_CD'
where  1 = 1 
    and P1.etl_dt=to_date('${batch_date}','yyyy-mm-dd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_myloan_repay_inst_flow truncate subpartition p_mybki1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_myloan_repay_inst_flow exchange subpartition p_mybki1_${batch_date} with table ${iml_schema}.evt_myloan_repay_inst_flow_mybki1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_myloan_repay_inst_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_myloan_repay_inst_flow_mybki1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_myloan_repay_inst_flow', partname => 'p_mybki1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);