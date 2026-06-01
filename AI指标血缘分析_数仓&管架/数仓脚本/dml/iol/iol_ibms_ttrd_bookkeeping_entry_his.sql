/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_bookkeeping_entry_his
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
drop table ${iol_schema}.ibms_ttrd_bookkeeping_entry_his_ex purge;
alter table ${iol_schema}.ibms_ttrd_bookkeeping_entry_his add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ibms_ttrd_bookkeeping_entry_his truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ibms_ttrd_bookkeeping_entry_his_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_bookkeeping_entry_his where 0=1;

insert /*+ append */ into ${iol_schema}.ibms_ttrd_bookkeeping_entry_his_ex(
    entry_id -- 凭证Id
    ,tsk_id -- 任务Id
    ,entry_date -- 凭证日期
    ,flow_id -- 流水号
    ,chg_id -- 变动Id
    ,inst_id -- 主指令Id
    ,bkkpg_org_id -- 记账机构号
    ,subj_org_id -- 科目机构码
    ,subj_code -- 科目码
    ,subj_sub_code -- 科目子码
    ,inner_acct_sn -- 内部账序号
    ,core_acct_code -- 核心账号
    ,step -- 0：利息计提；1：利息结转；2：公允价值损益计提；3：公允价值损益结转；4：收付。
    ,debit_credit_flag -- 1：借；2：贷。
    ,red_blue_flag -- 1：普通；2：红字；3：蓝字。
    ,pending_cancel_flag -- 0：普通；1：内部挂账；2：内部销账；3：外部挂账；4：外部销账。
    ,currency -- 币种
    ,value -- 借贷值
    ,state -- 0：未发送；1：已发送；2：未发送抹账；3：已发送抹账。
    ,is_sending_core -- 是否发送核心账号
    ,secu_acct_id -- 券账户
    ,cash_acct_id -- 资金账户
    ,update_time -- 更新时间
    ,estd_or_real -- E：理论核算；R：实际核算
    ,memo -- 备注
    ,core_acct_name -- 核心账号名称
    ,grp_flow_id -- 合并流水号
    ,acctg_obj_id -- 核算对象Id
    ,chg_type -- 变动类型
    ,detail_flag -- 明细标记
    ,src_type -- 源数据类型
    ,send_state -- 发送状态
    ,is_manual -- 1：手工凭证 0：非手工凭证
    ,ext_secu_acct_id -- 外部券账户
    ,ext_cash_acct_id -- 外部资金账户
    ,i9_flag -- I9标记
    ,ext_i_code -- 金融工具代码
    ,ext_a_type -- 金融工具资产类型
    ,ext_m_type -- 金融工具市场类型
    ,ext_dim1 -- 扩展维度1
    ,ext_dim2 -- 扩展维度2
    ,ext_dim3 -- 扩展维度3
    ,ext_dim4 -- 扩展维度4
    ,ext_dim5 -- 扩展维度5
    ,ext_dim6 -- 扩展维度6
    ,ext_value1 -- 扩展值字段1
    ,ext_value2 -- 扩展值字段2
    ,ext_value3 -- 扩展值3
    ,tax_type -- 征税类型： -1 无效值 0 征税 1 免税 2 不征税
    ,tax_value -- 税费
    ,debit_credit_flag_m -- 借贷标志,数据标准落标,触发器添加
    ,red_blue_flag_m -- 冲补抹标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    entry_id -- 凭证Id
    ,tsk_id -- 任务Id
    ,entry_date -- 凭证日期
    ,flow_id -- 流水号
    ,chg_id -- 变动Id
    ,inst_id -- 主指令Id
    ,bkkpg_org_id -- 记账机构号
    ,subj_org_id -- 科目机构码
    ,subj_code -- 科目码
    ,subj_sub_code -- 科目子码
    ,inner_acct_sn -- 内部账序号
    ,core_acct_code -- 核心账号
    ,step -- 0：利息计提；1：利息结转；2：公允价值损益计提；3：公允价值损益结转；4：收付。
    ,debit_credit_flag -- 1：借；2：贷。
    ,red_blue_flag -- 1：普通；2：红字；3：蓝字。
    ,pending_cancel_flag -- 0：普通；1：内部挂账；2：内部销账；3：外部挂账；4：外部销账。
    ,currency -- 币种
    ,value -- 借贷值
    ,state -- 0：未发送；1：已发送；2：未发送抹账；3：已发送抹账。
    ,is_sending_core -- 是否发送核心账号
    ,secu_acct_id -- 券账户
    ,cash_acct_id -- 资金账户
    ,update_time -- 更新时间
    ,estd_or_real -- E：理论核算；R：实际核算
    ,memo -- 备注
    ,core_acct_name -- 核心账号名称
    ,grp_flow_id -- 合并流水号
    ,acctg_obj_id -- 核算对象Id
    ,chg_type -- 变动类型
    ,detail_flag -- 明细标记
    ,src_type -- 源数据类型
    ,send_state -- 发送状态
    ,is_manual -- 1：手工凭证 0：非手工凭证
    ,ext_secu_acct_id -- 外部券账户
    ,ext_cash_acct_id -- 外部资金账户
    ,i9_flag -- I9标记
    ,ext_i_code -- 金融工具代码
    ,ext_a_type -- 金融工具资产类型
    ,ext_m_type -- 金融工具市场类型
    ,ext_dim1 -- 扩展维度1
    ,ext_dim2 -- 扩展维度2
    ,ext_dim3 -- 扩展维度3
    ,ext_dim4 -- 扩展维度4
    ,ext_dim5 -- 扩展维度5
    ,ext_dim6 -- 扩展维度6
    ,ext_value1 -- 扩展值字段1
    ,ext_value2 -- 扩展值字段2
    ,ext_value3 -- 扩展值3
    ,tax_type -- 征税类型： -1 无效值 0 征税 1 免税 2 不征税
    ,tax_value -- 税费
    ,debit_credit_flag_m -- 借贷标志,数据标准落标,触发器添加
    ,red_blue_flag_m -- 冲补抹标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ibms_ttrd_bookkeeping_entry_his
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ibms_ttrd_bookkeeping_entry_his exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_bookkeeping_entry_his_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_bookkeeping_entry_his to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ibms_ttrd_bookkeeping_entry_his_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_bookkeeping_entry_his',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);