/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_log_peripherybusdata
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_log_peripherybusdata_ex purge;
alter table ${iol_schema}.nibs_ib_log_peripherybusdata add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.nibs_ib_log_peripherybusdata truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.nibs_ib_log_peripherybusdata_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_log_peripherybusdata where 0=1;

insert /*+ append */ into ${iol_schema}.nibs_ib_log_peripherybusdata_ex(
    pty_id -- 客户编号
    ,txn_dt -- 交易日期
    ,seq_num -- 流水号
    ,program_id -- 交易代码
    ,txn_name -- 交易名称
    ,txn_chn -- 交易渠道
    ,ta_cd -- TA代码
    ,ta_name -- TA名称
    ,prd_cd -- 产品代码
    ,prd_name -- 产品名称
    ,bank_acct_num -- 银行账号
    ,fin_acct_num -- 理财账号
    ,lot -- 份额
    ,ccy -- 币种
    ,amt -- 金额
    ,disct_rate -- 折扣率
    ,txn_status -- 交易状态
    ,memo -- 摘要
    ,error_msg -- 错误代码
    ,err_info -- 错误信息
    ,adt -- 附加信息
    ,frz_reas -- 冻结原因
    ,huge_rede_flg -- 巨额赎回标志
    ,divi_mode -- 分红方式
    ,divi_mode_name -- 分红方式名称
    ,txn_status_name -- 交易状态名称
    ,txn_tm -- 交易时间
    ,txn_med_typ -- 交易介质类型
    ,txn_med -- 交易介质
    ,pty_risk_rank -- 客户风险等级
    ,prd_risk_rank -- 产品风险等级
    ,contr_id -- 合同编码、保单号
    ,xtra_chrg_fee -- 外收手续费
    ,pty_name -- 客户名称
    ,assoc_dt -- 关联日期
    ,cash_remit_flg -- 钞汇标志
    ,curt_bus_status -- 帐务状态
    ,curt_bus_status_name -- 帐务状态名称
    ,enter_prd_cd -- 转入产品代码
    ,oppo_retl_cd -- 对方销售商代码
    ,oppo_fin_acct_num -- 对方理财账号
    ,tgt_bank_acct_num -- 目标银行账号
    ,prd_templ_num -- 产品模板号
    ,wthr_can_canc_flg -- 是否可撤单标志
    ,scene_num -- 场景码
    ,txn_org -- 交易机构
    ,txn_tell -- 交易柜员
    ,busitype -- 类型|1-基金 2-信托 3-理财 4-保险
    ,compang_code -- 公司代码
    ,issue_fee -- 出单费
    ,blendingstatu -- 勾兑状态 0-未勾兑、1-已勾兑，2-部分勾兑，3-手动勾兑不通过，4-自动勾兑不通过
    ,blendingtype -- 勾兑方式 0-手动，1-自动，2-手动+自动
    ,blip_id -- 影像编号
    ,blip_scndate -- 影像采集日期-yyyyMMdd
    ,blendingdesc -- 勾兑说明
    ,syncdatestr -- 同步日期-yyyyMMdd
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    pty_id -- 客户编号
    ,txn_dt -- 交易日期
    ,seq_num -- 流水号
    ,program_id -- 交易代码
    ,txn_name -- 交易名称
    ,txn_chn -- 交易渠道
    ,ta_cd -- TA代码
    ,ta_name -- TA名称
    ,prd_cd -- 产品代码
    ,prd_name -- 产品名称
    ,bank_acct_num -- 银行账号
    ,fin_acct_num -- 理财账号
    ,lot -- 份额
    ,ccy -- 币种
    ,amt -- 金额
    ,disct_rate -- 折扣率
    ,txn_status -- 交易状态
    ,memo -- 摘要
    ,error_msg -- 错误代码
    ,err_info -- 错误信息
    ,adt -- 附加信息
    ,frz_reas -- 冻结原因
    ,huge_rede_flg -- 巨额赎回标志
    ,divi_mode -- 分红方式
    ,divi_mode_name -- 分红方式名称
    ,txn_status_name -- 交易状态名称
    ,txn_tm -- 交易时间
    ,txn_med_typ -- 交易介质类型
    ,txn_med -- 交易介质
    ,pty_risk_rank -- 客户风险等级
    ,prd_risk_rank -- 产品风险等级
    ,contr_id -- 合同编码、保单号
    ,xtra_chrg_fee -- 外收手续费
    ,pty_name -- 客户名称
    ,assoc_dt -- 关联日期
    ,cash_remit_flg -- 钞汇标志
    ,curt_bus_status -- 帐务状态
    ,curt_bus_status_name -- 帐务状态名称
    ,enter_prd_cd -- 转入产品代码
    ,oppo_retl_cd -- 对方销售商代码
    ,oppo_fin_acct_num -- 对方理财账号
    ,tgt_bank_acct_num -- 目标银行账号
    ,prd_templ_num -- 产品模板号
    ,wthr_can_canc_flg -- 是否可撤单标志
    ,scene_num -- 场景码
    ,txn_org -- 交易机构
    ,txn_tell -- 交易柜员
    ,busitype -- 类型|1-基金 2-信托 3-理财 4-保险
    ,compang_code -- 公司代码
    ,issue_fee -- 出单费
    ,blendingstatu -- 勾兑状态 0-未勾兑、1-已勾兑，2-部分勾兑，3-手动勾兑不通过，4-自动勾兑不通过
    ,blendingtype -- 勾兑方式 0-手动，1-自动，2-手动+自动
    ,blip_id -- 影像编号
    ,blip_scndate -- 影像采集日期-yyyyMMdd
    ,blendingdesc -- 勾兑说明
    ,syncdatestr -- 同步日期-yyyyMMdd
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nibs_ib_log_peripherybusdata
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nibs_ib_log_peripherybusdata exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_log_peripherybusdata_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_log_peripherybusdata to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nibs_ib_log_peripherybusdata_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_log_peripherybusdata',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);