/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_eqpt_voucher_tran_info
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
drop table ${iol_schema}.ncbs_tb_eqpt_voucher_tran_info_ex purge;
alter table ${iol_schema}.ncbs_tb_eqpt_voucher_tran_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_tb_eqpt_voucher_tran_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_tb_eqpt_voucher_tran_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_eqpt_voucher_tran_info where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_tb_eqpt_voucher_tran_info_ex(
    reference -- 交易参考号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,confirm_user_id -- 确认柜员编号
    ,move_id -- 调拨转移id
    ,on_way_status -- 在途状态
    ,reserve_flag -- 冲正标志
    ,confirm_date -- 上缴确认日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,tran_branch -- 核心交易机构编号
    ,confirm_branch -- 确认机构
    ,eqpt_type -- 自助设备类型
    ,eqpt_seq_no -- 自助设备交易编号
    ,eqpt_tran_operate_type -- 自助设备交易操作类型
    ,eqpt_tran_status -- 自助设备交易流程状态
    ,confirm_reference -- 确认交易流水号
    ,eqpt_mistake_id -- 自助设备交易差错编号
    ,virtual_user_id -- 虚拟柜员代号
    ,virtual_branch -- 虚拟柜员柜员所在机构
    ,virtual_tailbox_id -- 虚拟柜员柜员尾箱id
    ,teller_user_id -- 自助设备出库真实柜员
    ,teller_branch -- 自助设备出库真实柜员所属机构
    ,teller_trailbox_id -- 自助设备出库真实柜员尾箱
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    reference -- 交易参考号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,confirm_user_id -- 确认柜员编号
    ,move_id -- 调拨转移id
    ,on_way_status -- 在途状态
    ,reserve_flag -- 冲正标志
    ,confirm_date -- 上缴确认日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,tran_branch -- 核心交易机构编号
    ,confirm_branch -- 确认机构
    ,eqpt_type -- 自助设备类型
    ,eqpt_seq_no -- 自助设备交易编号
    ,eqpt_tran_operate_type -- 自助设备交易操作类型
    ,eqpt_tran_status -- 自助设备交易流程状态
    ,confirm_reference -- 确认交易流水号
    ,eqpt_mistake_id -- 自助设备交易差错编号
    ,virtual_user_id -- 虚拟柜员代号
    ,virtual_branch -- 虚拟柜员柜员所在机构
    ,virtual_tailbox_id -- 虚拟柜员柜员尾箱id
    ,teller_user_id -- 自助设备出库真实柜员
    ,teller_branch -- 自助设备出库真实柜员所属机构
    ,teller_trailbox_id -- 自助设备出库真实柜员尾箱
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_tb_eqpt_voucher_tran_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_tb_eqpt_voucher_tran_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_eqpt_voucher_tran_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_eqpt_voucher_tran_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_tb_eqpt_voucher_tran_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_eqpt_voucher_tran_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);