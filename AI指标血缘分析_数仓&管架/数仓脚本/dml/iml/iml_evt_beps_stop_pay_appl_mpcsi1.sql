/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_beps_stop_pay_appl_mpcsi1
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
drop table ${iml_schema}.evt_beps_stop_pay_appl_mpcsi1_tm purge;
alter table ${iml_schema}.evt_beps_stop_pay_appl add partition p_mpcsi1 values ('mpcsi1')(
        subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_beps_stop_pay_appl modify partition p_mpcsi1
    add subpartition p_mpcsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_beps_stop_pay_appl_mpcsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_seq_num -- 申请序号
    ,midgrod_dt -- 中台日期
    ,midgrod_flow_num -- 中台流水号
    ,obank_init_stop_pay_flg -- 他行发起止付标志
    ,appl_dt -- 申请日期
    ,appl_clear_bk_no -- 申请清算行行号
    ,appl_bk_no -- 申请行行号
    ,reply_clear_bk_no -- 应答清算行行号
    ,reply_bk_no -- 应答行行号
    ,appl_type_cd -- 申请类型代码
    ,appl_stop_pay_cnt -- 申请止付笔数
    ,agree_stop_pay_cnt -- 同意止付笔数
    ,init_init_org_id -- 原发起机构编号
    ,init_recv_bank_no -- 原收款行行号
    ,init_pay_bank_no -- 原付款行行号
    ,init_entr_dt -- 原委托日期
    ,init_dtl_ind_no -- 原明细标识号
    ,init_bus_type_id -- 原业务类型编号
    ,appl_stop_pay_amt -- 申请止付金额
    ,appl_remark -- 申请备注
    ,reply_remark -- 应答备注
    ,stop_pay_reply_status_cd -- 止付应答状态代码
    ,appl_teller_id -- 申请柜员编号
    ,proc_status_cd -- 处理状态代码
    ,reply_dt -- 应答日期
    ,send_dt -- 发送日期
    ,send_tm -- 发送时间
    ,dept_id -- 部门编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_beps_stop_pay_appl
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- mpcs_a08tbestopapply-
insert into ${iml_schema}.evt_beps_stop_pay_appl_mpcsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_seq_num -- 申请序号
    ,midgrod_dt -- 中台日期
    ,midgrod_flow_num -- 中台流水号
    ,obank_init_stop_pay_flg -- 他行发起止付标志
    ,appl_dt -- 申请日期
    ,appl_clear_bk_no -- 申请清算行行号
    ,appl_bk_no -- 申请行行号
    ,reply_clear_bk_no -- 应答清算行行号
    ,reply_bk_no -- 应答行行号
    ,appl_type_cd -- 申请类型代码
    ,appl_stop_pay_cnt -- 申请止付笔数
    ,agree_stop_pay_cnt -- 同意止付笔数
    ,init_init_org_id -- 原发起机构编号
    ,init_recv_bank_no -- 原收款行行号
    ,init_pay_bank_no -- 原付款行行号
    ,init_entr_dt -- 原委托日期
    ,init_dtl_ind_no -- 原明细标识号
    ,init_bus_type_id -- 原业务类型编号
    ,appl_stop_pay_amt -- 申请止付金额
    ,appl_remark -- 申请备注
    ,reply_remark -- 应答备注
    ,stop_pay_reply_status_cd -- 止付应答状态代码
    ,appl_teller_id -- 申请柜员编号
    ,proc_status_cd -- 处理状态代码
    ,reply_dt -- 应答日期
    ,send_dt -- 发送日期
    ,send_tm -- 发送时间
    ,dept_id -- 部门编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104046'||P1.STPYDT||P1.STBKNO||P1.STPYSQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.STPYSQ -- 申请序号
    ,${iml_schema}.DATEFORMAT_MIN(P1.OPERDT) -- 中台日期
    ,P1.OPERSQ -- 中台流水号
    ,NVL(TRIM(P1.IOTYPE),'-') -- 他行发起止付标志
    ,${iml_schema}.DATEFORMAT_MIN(P1.STPYDT) -- 申请日期
    ,P1.STCLBK -- 申请清算行行号
    ,P1.STBKNO -- 申请行行号
    ,P1.RPCLBK -- 应答清算行行号
    ,P1.RPBKNO -- 应答行行号
    ,P1.STPYTP -- 申请类型代码
    ,P1.STPNUM -- 申请止付笔数
    ,P1.SUCCSTPNUM -- 同意止付笔数
    ,P1.ORSNDBK -- 原发起机构编号
    ,P1.ORASNDBRN -- 原收款行行号
    ,P1.ORARCVBRN -- 原付款行行号
    ,${iml_schema}.DATEFORMAT_MIN(P1.ORACONSIGNDT) -- 原委托日期
    ,P1.ORAOPERSQ -- 原明细标识号
    ,P1.ORABUSTYPE -- 原业务类型编号
    ,TO_NUMBER(nvl(trim(regexp_substr(P1.ORAAPPLYAMOUNT, '[0-9.]+')),0)) -- 申请止付金额
    ,P1.PSCRTX -- 申请备注
    ,P1.RSPTTX -- 应答备注
    ,P1.TRANST -- 止付应答状态代码
    ,P1.USERID -- 申请柜员编号
    ,P1.IOTYPE||'_'||P1.RPLYST -- 处理状态代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.RPLYDT) -- 应答日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.SENDDT) -- 发送日期
    ,${iml_schema}.TIMEFORMAT_MAX(P1.SENDTM） -- 发送时间
    ,P1.SDTLBR -- 部门编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a08tbestopapply' -- 源表名称
    ,'mpcsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a08tbestopapply p1
where  1 = 1 
    AND P1.STPYDT='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_beps_stop_pay_appl truncate subpartition p_mpcsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_beps_stop_pay_appl exchange subpartition p_mpcsi1_${batch_date} with table ${iml_schema}.evt_beps_stop_pay_appl_mpcsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_beps_stop_pay_appl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_beps_stop_pay_appl_mpcsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_beps_stop_pay_appl', partname => 'p_mpcsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);