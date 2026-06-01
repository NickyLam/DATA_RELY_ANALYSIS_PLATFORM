/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_evt_core_entry_flow
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_evt_core_entry_flow drop partition p_${last_date};
alter table ${idl_schema}.aml_evt_core_entry_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_evt_core_entry_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_evt_core_entry_flow partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,evt_id  -- 事件编号
    ,tran_id  -- 交易编号
    ,tran_dt  -- 交易日期
    ,lp_id  -- 法人编号
    ,org_id  -- 机构编号
    ,entry_cancel_flg  -- 记账取消标志
    ,entry_flow_num  -- 记账流水号
    ,hxp_tran_flg  -- 补记交易标志
    ,msg_send_status_cd  -- 报文发送状态代码
    ,err_cd  -- 错误代码
    ,err_rs  -- 错误原因
    ,bus_type_cd  -- 业务类型代码
    ,buy_dtl_id  -- 买入明细编号
    ,bill_id  -- 票据编号
    ,cont_id  -- 合同编号
    ,entry_way_cd  -- 记账方式代码
    ,final_modif_operr_id  -- 最后修改操作员编号
    ,final_modif_tm  -- 最后修改时间
    ,bill_uniq_ind_no  -- 票据唯一标识号
    ,forgn_sys_bill_uniq_ind_no  -- 对外系统票据唯一标识号
    ,entry_step_seq_num  -- 记账步骤序号
    ,sugst_pay_appl_flow_num  -- 提示付款申请流水号
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.evt_id,chr(13),''),chr(10),'')  -- 事件编号
    ,replace(replace(t1.tran_id,chr(13),''),chr(10),'')  -- 交易编号
    ,t1.tran_dt  -- 交易日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.org_id,chr(13),''),chr(10),'')  -- 机构编号
    ,replace(replace(t1.entry_cancel_flg,chr(13),''),chr(10),'')  -- 记账取消标志
    ,replace(replace(t1.entry_flow_num,chr(13),''),chr(10),'')  -- 记账流水号
    ,replace(replace(t1.hxp_tran_flg,chr(13),''),chr(10),'')  -- 补记交易标志
    ,replace(replace(t1.msg_send_status_cd,chr(13),''),chr(10),'')  -- 报文发送状态代码
    ,replace(replace(t1.err_cd,chr(13),''),chr(10),'')  -- 错误代码
    ,replace(replace(t1.err_rs,chr(13),''),chr(10),'')  -- 错误原因
    ,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'')  -- 业务类型代码
    ,replace(replace(t1.buy_dtl_id,chr(13),''),chr(10),'')  -- 买入明细编号
    ,replace(replace(t1.bill_id,chr(13),''),chr(10),'')  -- 票据编号
    ,replace(replace(t1.cont_id,chr(13),''),chr(10),'')  -- 合同编号
    ,replace(replace(t1.entry_way_cd,chr(13),''),chr(10),'')  -- 记账方式代码
    ,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'')  -- 最后修改操作员编号
    ,t1.final_modif_tm  -- 最后修改时间
    ,replace(replace(t1.bill_uniq_ind_no,chr(13),''),chr(10),'')  -- 票据唯一标识号
    ,replace(replace(t1.forgn_sys_bill_uniq_ind_no,chr(13),''),chr(10),'')  -- 对外系统票据唯一标识号
    ,replace(replace(t1.entry_step_seq_num,chr(13),''),chr(10),'')  -- 记账步骤序号
    ,replace(replace(t1.sugst_pay_appl_flow_num,chr(13),''),chr(10),'')  -- 提示付款申请流水号
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.evt_core_entry_flow t1    --核心记账流水事件
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_evt_core_entry_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);