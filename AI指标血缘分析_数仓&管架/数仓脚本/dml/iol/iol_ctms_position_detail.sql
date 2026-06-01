/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_position_detail
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
drop table ${iol_schema}.ctms_position_detail_ex purge;
alter table ${iol_schema}.ctms_position_detail add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ctms_position_detail truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ctms_position_detail_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_position_detail where 0=1;

insert /*+ append */ into ${iol_schema}.ctms_position_detail_ex(
    query_date -- 查询日期
    ,last_modified -- 操作日期
    ,bond_rating -- 债券评级
    ,depository_trust -- 托管机构
    ,depository_trust_name -- 托管机构-名称
    ,dirty_price -- 全价
    ,fund_rate -- 可融资质押比(%)
    ,internal_rating -- 内部评级
    ,inv_group_id -- 群组编号
    ,inv_group_name -- 群组名称
    ,ivt_amount -- 可用量(万元)
    ,ivt_bl_b -- 债券借贷融入(万元)
    ,ivt_bl_b_amount -- 债券借贷融入可用量(万元)
    ,ivt_bond -- 现券(万元)
    ,ivt_bond_amount -- 现券可用量(万元)
    ,ivt_cr_b -- 质押式正回购/协议回购(万元)
    ,ivt_cr_sum -- 质押券总量(万元) =质押式正回购+债券借贷质押出
    ,ivt_fund_amount -- 可融资量(万元)
    ,ivt_kr_b -- 开放式正回购(万元)
    ,ivt_kr_s -- 开放式逆回购(万元)
    ,ivt_kr_s_amount -- 开放式逆回购可用量(万元)
    ,ivt_mat_amount -- 当日到期质押券(万元)
    ,ivt_or_b -- 买断式正回购(万元)
    ,ivt_or_s -- 买断式逆回购(万元)
    ,ivt_or_samount -- 买断式逆回购可用量(万元)
    ,ivt_sl_b -- 债券借贷质押出(万元)
    ,ivt_sl_s -- 债券借贷融出(万元)
    ,man_trans_pos -- 手动调仓量(万元)
    ,market_price -- 估值净价
    ,maturity_date -- 债券到期日
    ,portfolio_id -- 投组编号
    ,portfolio_name -- 投组名称
    ,security_id -- 债券代码
    ,security_name -- 债券名称
    ,security_type -- 债券类别
    ,short_inv -- 是否短仓
    ,subject_rating -- 主体评级
    ,trust_bond_sum -- 托管券总量(万元) = 可用量 + 质押券总量
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    query_date -- 查询日期
    ,last_modified -- 操作日期
    ,bond_rating -- 债券评级
    ,depository_trust -- 托管机构
    ,depository_trust_name -- 托管机构-名称
    ,dirty_price -- 全价
    ,fund_rate -- 可融资质押比(%)
    ,internal_rating -- 内部评级
    ,inv_group_id -- 群组编号
    ,inv_group_name -- 群组名称
    ,ivt_amount -- 可用量(万元)
    ,ivt_bl_b -- 债券借贷融入(万元)
    ,ivt_bl_b_amount -- 债券借贷融入可用量(万元)
    ,ivt_bond -- 现券(万元)
    ,ivt_bond_amount -- 现券可用量(万元)
    ,ivt_cr_b -- 质押式正回购/协议回购(万元)
    ,ivt_cr_sum -- 质押券总量(万元) =质押式正回购+债券借贷质押出
    ,ivt_fund_amount -- 可融资量(万元)
    ,ivt_kr_b -- 开放式正回购(万元)
    ,ivt_kr_s -- 开放式逆回购(万元)
    ,ivt_kr_s_amount -- 开放式逆回购可用量(万元)
    ,ivt_mat_amount -- 当日到期质押券(万元)
    ,ivt_or_b -- 买断式正回购(万元)
    ,ivt_or_s -- 买断式逆回购(万元)
    ,ivt_or_samount -- 买断式逆回购可用量(万元)
    ,ivt_sl_b -- 债券借贷质押出(万元)
    ,ivt_sl_s -- 债券借贷融出(万元)
    ,man_trans_pos -- 手动调仓量(万元)
    ,market_price -- 估值净价
    ,maturity_date -- 债券到期日
    ,portfolio_id -- 投组编号
    ,portfolio_name -- 投组名称
    ,security_id -- 债券代码
    ,security_name -- 债券名称
    ,security_type -- 债券类别
    ,short_inv -- 是否短仓
    ,subject_rating -- 主体评级
    ,trust_bond_sum -- 托管券总量(万元) = 可用量 + 质押券总量
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ctms_position_detail
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ctms_position_detail exchange partition p_${batch_date} with table ${iol_schema}.ctms_position_detail_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_position_detail to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ctms_position_detail_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_position_detail',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);