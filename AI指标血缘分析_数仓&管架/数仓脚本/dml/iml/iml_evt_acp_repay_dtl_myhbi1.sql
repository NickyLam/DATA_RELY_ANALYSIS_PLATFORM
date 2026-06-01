/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_acp_repay_dtl_myhbi1
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
drop table ${iml_schema}.evt_acp_repay_dtl_myhbi1_tm purge;
alter table ${iml_schema}.evt_acp_repay_dtl add partition p_myhbi1 values ('myhbi1')(
        subpartition p_myhbi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_acp_repay_dtl modify partition p_myhbi1
    add subpartition p_myhbi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_acp_repay_dtl_myhbi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,acru_non_acru_flg -- 应计非应计标志
    ,repay_type_cd -- 还款类型代码
    ,repay_dt -- 还款日期
    ,tran_flow_num -- 交易流水号
    ,dubil_id -- 借据编号
    ,paid_nomal_pric -- 实还正常本金
    ,paid_ovdue_pric -- 实还逾期本金
    ,paid_nomal_int -- 实还正常利息
    ,paid_ovdue_int -- 实还逾期利息
    ,paid_ovdue_pric_pnlt -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt -- 实还逾期利息罚息
    ,repay_plat_serv_fee -- 还款平台服务费
    ,repay_plat_serv_fee_ratio -- 还款平台服务费比例
    ,intnal_carr_flg -- 内部结转标志
    ,paid_tot_amt -- 实还总金额
    ,wrt_off_flg -- 核销标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_acp_repay_dtl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_myhb_repay_detail-
insert into ${iml_schema}.evt_acp_repay_dtl_myhbi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,acru_non_acru_flg -- 应计非应计标志
    ,repay_type_cd -- 还款类型代码
    ,repay_dt -- 还款日期
    ,tran_flow_num -- 交易流水号
    ,dubil_id -- 借据编号
    ,paid_nomal_pric -- 实还正常本金
    ,paid_ovdue_pric -- 实还逾期本金
    ,paid_nomal_int -- 实还正常利息
    ,paid_ovdue_int -- 实还逾期利息
    ,paid_ovdue_pric_pnlt -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt -- 实还逾期利息罚息
    ,repay_plat_serv_fee -- 还款平台服务费
    ,repay_plat_serv_fee_ratio -- 还款平台服务费比例
    ,intnal_carr_flg -- 内部结转标志
    ,paid_tot_amt -- 实还总金额
    ,wrt_off_flg -- 核销标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    case when length（'102004'||P1.SEQNO||P1.CONTRACTNO)>60 then '102004'||substr(P1.SEQNO||P1.CONTRACTNO,-54) else '102004'||P1.SEQNO||P1.CONTRACTNO end -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ACCRUEDSTATUS -- 应计非应计标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.REPAYTYPE END -- 还款类型代码
    ,${iml_schema}.DATEFORMAT_MAX2(P1.REPAYDATE) -- 还款日期
    ,P1.SEQNO -- 交易流水号
    ,P1.CONTRACTNO -- 借据编号
    ,P1.PAIDPRINAMT -- 实还正常本金
    ,P1.PAIDOVDPRINAMT -- 实还逾期本金
    ,P1.PAIDINTAMT -- 实还正常利息
    ,P1.PAIDOVDINTAMT -- 实还逾期利息
    ,P1.PAIDOVDPRINPNLTAMT -- 实还逾期本金罚息
    ,P1.PAIDOVDINTPNLTAMT -- 实还逾期利息罚息
    ,P1.FEEAMT -- 还款平台服务费
    ,P1.FEERATE -- 还款平台服务费比例
    ,P1.INTERNALTRANSFERTAG -- 内部结转标志
    ,P1.REPAYAMT -- 实还总金额
    ,NVL(TRIM(P1.WRITEOFF),'N') -- 核销标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_myhb_repay_detail' -- 源表名称
    ,'myhbi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_myhb_repay_detail p1
left join ${iml_schema}.ref_pub_cd_map r1 on P1.REPAYTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_MYHB_REPAY_DETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'REPAYTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_ACP_REPAY_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REPAY_TYPE_CD'
where  1 = 1 
    and replace(substr(P1.REPAYDATE,1,10),'-','')='${batch_date}'
and P1.etl_dt=to_date('${batch_date}','yyyy-mm-dd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_acp_repay_dtl truncate subpartition p_myhbi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_acp_repay_dtl exchange subpartition p_myhbi1_${batch_date} with table ${iml_schema}.evt_acp_repay_dtl_myhbi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_acp_repay_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_acp_repay_dtl_myhbi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_acp_repay_dtl', partname => 'p_myhbi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);