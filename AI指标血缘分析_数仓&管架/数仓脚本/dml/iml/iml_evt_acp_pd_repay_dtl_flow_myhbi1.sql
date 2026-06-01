/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_acp_pd_repay_dtl_flow_myhbi1
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
drop table ${iml_schema}.evt_acp_pd_repay_dtl_flow_myhbi1_tm purge;
alter table ${iml_schema}.evt_acp_pd_repay_dtl_flow add partition p_myhbi1 values ('myhbi1')(
        subpartition p_myhbi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_acp_pd_repay_dtl_flow modify partition p_myhbi1
    add subpartition p_myhbi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_acp_pd_repay_dtl_flow_myhbi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,pd_num -- 期次号
    ,inst_status_cd -- 分期状态代码
    ,repay_type_cd -- 还款类型代码
    ,repay_tm -- 还款时间
    ,paid_tot_amt -- 实还总金额
    ,paid_nomal_pric -- 实还正常本金
    ,paid_int -- 实还利息
    ,paid_ovdue_pric_pnlt -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt -- 实还逾期利息罚息
    ,intnal_carr_flg -- 内部结转标志
    ,dubil_type_cd -- 借据类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_acp_pd_repay_dtl_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- icms_myhb_istmnt_repay_detail-
insert into ${iml_schema}.evt_acp_pd_repay_dtl_flow_myhbi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,tran_flow_num -- 交易流水号
    ,pd_num -- 期次号
    ,inst_status_cd -- 分期状态代码
    ,repay_type_cd -- 还款类型代码
    ,repay_tm -- 还款时间
    ,paid_tot_amt -- 实还总金额
    ,paid_nomal_pric -- 实还正常本金
    ,paid_int -- 实还利息
    ,paid_ovdue_pric_pnlt -- 实还逾期本金罚息
    ,paid_ovdue_int_pnlt -- 实还逾期利息罚息
    ,intnal_carr_flg -- 内部结转标志
    ,dubil_type_cd -- 借据类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102004'||${batch_date}||P1.CONTRACTNO||P1.SEQNO||lpad(P1.TERMNO,3,'0')||P1.REPAYTYPE -- 事件编号
    ,'9999' -- 法人编号
    ,P1.SEQNO -- 交易流水号
    ,TO_CHAR(P1.TERMNO) -- 期次号
    ,P1.TERMSTATUS -- 分期状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.REPAYTYPE END  -- 还款类型代码
    ,TO_TIMESTAMP(P1.REPAYDATE,'yyyy-mm-dd hh24:mi:ss.ff') -- 还款时间
    ,P1.REPAYAMT -- 实还总金额
    ,P1.PAIDPRINAMT -- 实还正常本金
    ,P1.PAIDINTAMT -- 实还利息
    ,P1.PAIDOVDPRINPNLTAMT -- 实还逾期本金罚息
    ,P1.PAIDOVDINTPNLTAMT -- 实还逾期利息罚息
    ,P1.INTERNALTRANSFERTAG -- 内部结转标志
    ,P1.CONTRACTTYPE -- 借据类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_myhb_istmnt_repay_detail' -- 源表名称
    ,'myhbi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_myhb_istmnt_repay_detail p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.REPAYTYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_MYHB_ISTMNT_REPAY_DETAIL'
        AND R1.SRC_FIELD_EN_NAME= 'REPAYTYPE'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_ACP_PD_REPAY_DTL_FLOW'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'REPAY_TYPE_CD'
where  1 = 1 
    and P1.etl_dt=to_date('${batch_date}','yyyy-mm-dd') and replace(substr(P1.REPAYDATE,1,10),'-','')='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_acp_pd_repay_dtl_flow truncate subpartition p_myhbi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_acp_pd_repay_dtl_flow exchange subpartition p_myhbi1_${batch_date} with table ${iml_schema}.evt_acp_pd_repay_dtl_flow_myhbi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_acp_pd_repay_dtl_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_acp_pd_repay_dtl_flow_myhbi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_acp_pd_repay_dtl_flow', partname => 'p_myhbi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);