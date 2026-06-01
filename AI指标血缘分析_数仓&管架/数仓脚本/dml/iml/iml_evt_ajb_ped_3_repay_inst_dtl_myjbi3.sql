/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ajb_ped_3_repay_inst_dtl_myjbi3
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
drop table ${iml_schema}.evt_ajb_ped_3_repay_inst_dtl_myjbi3_tm purge;
alter table ${iml_schema}.evt_ajb_ped_3_repay_inst_dtl add partition p_myjbi3 values ('myjbi3')(
        subpartition p_myjbi3_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ajb_ped_3_repay_inst_dtl modify partition p_myjbi3
    add subpartition p_myjbi3_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ajb_ped_3_repay_inst_dtl_myjbi3_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,pd_num -- 期次号
    ,dubil_id -- 借据编号
    ,repay_amt_type_cd -- 还款金额类型代码
    ,repay_dt -- 还款日期
    ,rpbl_nomal_pric -- 应还正常本金
    ,rpbl_nomal_int -- 应还正常利息
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,paid_tot_amt -- 实还总金额
    ,paid_nomal_pric -- 实还正常本金
    ,paid_nomal_int -- 实还正常利息
    ,paid_ovdue_pric_pnlt -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt -- 实还逾期利息罚息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ajb_ped_3_repay_inst_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_myjb_repay_instmnt_detail3-
insert into ${iml_schema}.evt_ajb_ped_3_repay_inst_dtl_myjbi3_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,repay_flow_num -- 还款流水号
    ,pd_num -- 期次号
    ,dubil_id -- 借据编号
    ,repay_amt_type_cd -- 还款金额类型代码
    ,repay_dt -- 还款日期
    ,rpbl_nomal_pric -- 应还正常本金
    ,rpbl_nomal_int -- 应还正常利息
    ,rpbl_ovdue_pric_pnlt -- 应还逾期本金罚息
    ,rpbl_ovdue_int_pnlt -- 应还逾期利息罚息
    ,paid_tot_amt -- 实还总金额
    ,paid_nomal_pric -- 实还正常本金
    ,paid_nomal_int -- 实还正常利息
    ,paid_ovdue_pric_pnlt -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt -- 实还逾期利息罚息
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102024'||P1.SEQNO||p1.TERMNO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 还款流水号
    ,P1.TERMNO -- 期次号
    ,P1.CONTRACTNO -- 借据编号
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'|| P1.REPAYAMTTYPE END -- 还款金额类型代码
    ,${iml_schema}.dateformat_max2(P1.REPAYDATE) -- 还款日期
    ,P1.CURRPRINBAL/100 -- 应还正常本金
    ,P1.CURRINTBAL/100 -- 应还正常利息
    ,P1.CURROVDPRINPNLTBAL/100 -- 应还逾期本金罚息
    ,P1.CURROVDINTPNLTBAL/100 -- 应还逾期利息罚息
    ,P1.REPAYAMT/100 -- 实还总金额
    ,P1.PAIDPRINAMT/100 -- 实还正常本金
    ,P1.PAIDINTAMT/100 -- 实还正常利息
    ,P1.PAIDOVDPRINPNLTAMT/100 -- 实还逾期本金罚息
    ,P1.PAIDOVDINTPNLTAMT/100 -- 实还逾期利息罚息
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_myjb_repay_instmnt_detail3' -- 源表名称
    ,'myjbi3' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_myjb_repay_instmnt_detail3 p1
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.REPAYAMTTYPE = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'ICMS'
        AND R7.SRC_TAB_EN_NAME= 'ICMS_MYJB_REPAY_INSTMNT_DETAIL3'
        AND R7.SRC_FIELD_EN_NAME= 'REPAYAMTTYPE'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_AJB_PED_3_REPAY_INST_DTL'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'REPAY_AMT_TYPE_CD'
where  1 = 1 
    and P1.REPAYDATE='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ajb_ped_3_repay_inst_dtl truncate subpartition p_myjbi3_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ajb_ped_3_repay_inst_dtl exchange subpartition p_myjbi3_${batch_date} with table ${iml_schema}.evt_ajb_ped_3_repay_inst_dtl_myjbi3_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ajb_ped_3_repay_inst_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ajb_ped_3_repay_inst_dtl_myjbi3_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ajb_ped_3_repay_inst_dtl', partname => 'p_myjbi3_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);