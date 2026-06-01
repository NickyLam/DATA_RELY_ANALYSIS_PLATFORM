/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_hstctrans1_v_tbgrpprdtranscfm
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
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm_ex purge;
alter table ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm where 0=1;

insert /*+ append */ into ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm_ex(
    imp_date -- 导入日期
    ,prd_code -- 产品代码
    ,bank_no -- 银行代码:租户编号(多租户模式用)
    ,bank_acc -- 资金账号
    ,trans_date -- 交易日期
    ,trans_time -- 交易时间
    ,ta_code -- TA代码
    ,prd_type -- 产品类型:1-基金
    ,ex_serial -- 原始请求外部流水号
    ,grp_serial -- 智能投顾流水号
    ,virtual_bank_acc -- 虚拟银行账号
    ,serial_no -- 流水序号:流水号
    ,trans_code -- 交易代码
    ,cfm_amt -- 确认金额
    ,cfm_vol -- 确认份额
    ,err_code -- 错误代码
    ,err_msg -- 错误信息
    ,status -- 状态
    ,cfm_date -- 确认日期
    ,cfm_fee -- 确认手续费
    ,cfm_nav -- 确认净值
    ,busin_code -- 业务代码
    ,from_flag -- 发起方:[K_FQF] 0	-  	系统 1	-  	TA 2	-  	其他
    ,cfm_no -- TA确认流水号
    ,div_mode -- 分红方式:0红利再投资,1现金红利
    ,div_date -- 分红日
    ,reg_date -- 登记日期
    ,in_client_no -- 内部客户编号
    ,amt1 -- 备用金额1
    ,amt2 -- 备用金额2
    ,amt3 -- 备用金额3
    ,reserve1 -- 保留字段1
    ,reserve2 -- 保留字段2
    ,reserve3 -- 保留字段3
    ,group_code -- 分组代码
    ,group_name -- 分组名称
    ,client_no -- 银行客户号
    ,client_type -- 客户类型:0机构,1个人,2产品
    ,amt -- 金额
    ,vol -- 份额
    ,modify_timestamp -- 修改时间戳
    ,back_amt -- 返款金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    imp_date -- 导入日期
    ,prd_code -- 产品代码
    ,bank_no -- 银行代码:租户编号(多租户模式用)
    ,bank_acc -- 资金账号
    ,trans_date -- 交易日期
    ,trans_time -- 交易时间
    ,ta_code -- TA代码
    ,prd_type -- 产品类型:1-基金
    ,ex_serial -- 原始请求外部流水号
    ,grp_serial -- 智能投顾流水号
    ,virtual_bank_acc -- 虚拟银行账号
    ,serial_no -- 流水序号:流水号
    ,trans_code -- 交易代码
    ,cfm_amt -- 确认金额
    ,cfm_vol -- 确认份额
    ,err_code -- 错误代码
    ,err_msg -- 错误信息
    ,status -- 状态
    ,cfm_date -- 确认日期
    ,cfm_fee -- 确认手续费
    ,cfm_nav -- 确认净值
    ,busin_code -- 业务代码
    ,from_flag -- 发起方:[K_FQF] 0	-  	系统 1	-  	TA 2	-  	其他
    ,cfm_no -- TA确认流水号
    ,div_mode -- 分红方式:0红利再投资,1现金红利
    ,div_date -- 分红日
    ,reg_date -- 登记日期
    ,in_client_no -- 内部客户编号
    ,amt1 -- 备用金额1
    ,amt2 -- 备用金额2
    ,amt3 -- 备用金额3
    ,reserve1 -- 保留字段1
    ,reserve2 -- 保留字段2
    ,reserve3 -- 保留字段3
    ,group_code -- 分组代码
    ,group_name -- 分组名称
    ,client_no -- 银行客户号
    ,client_type -- 客户类型:0机构,1个人,2产品
    ,amt -- 金额
    ,vol -- 份额
    ,modify_timestamp -- 修改时间戳
    ,back_amt -- 返款金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm exchange partition p_${batch_date} with table ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_hstctrans1_v_tbgrpprdtranscfm',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);