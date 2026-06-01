/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_d_proj_val_index
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
    20210519 新增9个系统表 （ cims_proj_val_index && lpss_proj_val_index && alms_proj_val_index && brts_proj_val_index && lmis_proj_val_index && rcrs_proj_val_index && ftps_proj_val_index && ifrs_proj_val_index && vmss_proj_val_index ）
    20210528 新增15个系统表 （ tess_proj_val_index && mpcb_proj_val_index && atms_proj_val_index && iats_proj_val_index && mrms_proj_val_index && moas_proj_val_index && ogws_proj_val_index && ccrs_proj_val_index && icrs_proj_val_index && orws_proj_val_index && fdps_proj_val_index && nfss_proj_val_index && bdes_proj_val_index && ifss_proj_val_index && efss_proj_val_index  ）
    20211022 新增12个系统表 （ cass_proj_val_index && east_m_east_proj_val_index && ewss_proj_val_index && glms_proj_val_index && imas_imas_proj_val_index && kgss_proj_val_index && nhrs_proj_val_index && noas_proj_val_index && rtis_proj_val_index && rpas_rpas_proj_val_index && rrsp_proj_val_index && tcrs_proj_val_index  ）

*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.d_proj_val_index drop partition p_${last_date};
alter table ${idl_schema}.d_proj_val_index drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.d_proj_val_index add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.d_proj_val_index (
    etl_dt  -- 数据日期
    ,proj_val_id  -- 指标表数据ID
    ,proj_id  -- 项目编号
    ,proj_name  -- 项目名称
    ,proj_online_dt  -- 项目上线日期
    ,dep_name  -- 需求提出部门
    ,sys_short_name  -- 系统简称
    ,sys_name  -- 系统名称
    ,budg_amt  -- 预算金额
    ,xq_id  -- 需求编号
    ,index_type  -- 指标类型
    ,weht_ratio  -- 权重比例
    ,index_name  -- 指标名称
    ,index_unit  -- 指标单位
    ,tgt_val  -- 目标值
    ,index_val  -- 指标值
    ,stati_peri  -- 统计周期
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.bdms_proj_val_index t1    --票据系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') 
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.isbs_proj_val_index t1  --国际结算系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crcs_proj_val_index t1  --征信查询系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.twss_proj_val_index t1  --天威账户风险监控系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ilss_proj_val_index t1  --网贷平台系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.nfss_tcs_proj_val_index t1  --金融产品代销系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.scfs_proj_val_index t1  --供应链金融系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ifms_fds_proj_val_index t1  --理财分销系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ifms_proj_val_index t1  --理财系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${idl_schema}.ref_proj_val_index t1  --项目后评价参数（数据管理组汇总）
where 1 = 1

---20210322
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ifcs_proj_val_index t1  --ifcs系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_proj_val_index t1  --mpcs系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_proj_val_index t1  --crss系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.icss_proj_val_index t1  --icss系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.svss_proj_val_index t1  --svss系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.pbss_proj_val_index t1  --pbss系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.uogs_proj_val_index t1  --uogs系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.csrs_proj_val_index t1  --csrs系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ncts_proj_val_index t1  --ncts系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.tbps_proj_val_index t1  --tbps系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.tbms_proj_val_index t1  --tbms系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.heps_proj_val_index t1  --heps系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.cabs_proj_val_index t1  --cabs系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.uuss_proj_val_index t1  --uuss系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.rwas_proj_val_index t1  --rwas系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.albs_proj_val_index t1  --albs系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.icas_proj_val_index t1  --icas系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.cpms_proj_val_index t1  --cpms系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ctms_proj_val_index t1  --ctms系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ibms_proj_val_index t1  --ibms系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.bdps_proj_val_index t1  --bdps系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.icps_proj_val_index t1  --icps系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcc_proj_val_index t1  --mpcc系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ppps_proj_val_index t1  --ppps系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.esss_proj_val_index t1  --esss系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.msms_proj_val_index t1  --msms系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ncfs_proj_val_index t1  --ncfs系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.eips_proj_val_index t1  --eips系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all                                                              --changed in 20210517
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.cims_proj_val_index t1  --影像档案管理系统_CIMS
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.lpss_proj_val_index t1  --贷款产品系统_LPSS
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.alms_proj_val_index t1  --资产负债管理系统_ALMS
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.brts_proj_val_index t1  --大零售经营管理平台_BRTS
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.lmis_proj_val_index t1  --新租赁准则管理系统_LMIS
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all                                                    --changed in 20210518
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.rcrs_proj_val_index t1  --零售信贷管理系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ftps_proj_val_index t1  --内部资金转移定价管理系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ifrs_proj_val_index t1  --减估值计量管理系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.vmss_proj_val_index t1  --增值税管理系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all                                                                --changed in 20210525
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.uxds_proj_val_index t1  --统一外部数据管理平台
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcb_proj_val_index t1  --中台零售组
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.atms_proj_val_index t1  --自助设备系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.iats_proj_val_index t1  --企业级综合账户系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mrms_proj_val_index t1  --商户收单系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.moas_proj_val_index t1  --移动OA系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ogws_proj_val_index t1  --金融生态服务平台
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ccrs_proj_val_index t1  --对公客户关系管理系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.icrs_proj_val_index t1  --同业客户关系管理系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.orws_proj_val_index t1  --营运管理平台
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.fdps_proj_val_index t1  --资金存管系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.nfss_proj_val_index t1  --金融产品代销系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.bdes_proj_val_index t1  --票交所直连系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ifss_proj_val_index t1  --互联网金融账务系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.efss_proj_val_index t1  --电子档案系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all                                                           --changed in 20210603
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.dpss_proj_val_index t1  --储蓄产品系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all                                                           --changed in 20210622
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.pams_proj_val_index t1  --绩效考核系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all                                                           --changed in 20210622
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.osbs_ops_proj_val_index t1  --开放式服务总线
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.cass_proj_val_index t1  --cass系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.east_m_east_proj_val_index t1  --east系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.ewss_proj_val_index t1  --ewss系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.glms_proj_val_index t1  --glms系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.imas_imas_proj_val_index t1  --imas系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.kgss_proj_val_index t1  --kgss系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.nhrs_proj_val_index t1  --nhrs系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.noas_proj_val_index t1  --noas系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.rtis_proj_val_index t1  --rtis系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.rpas_rpas_proj_val_index t1  --rpas系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.rrsp_proj_val_index t1  --rrsp系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.tcrs_proj_val_index t1  --tcrs系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.cqss_proj_val_index t1  --二代征信系统项目价值指标表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.fams_proj_val_index t1  --资管系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.cbss_proj_val_index t1  --核心系统
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mmps_proj_val_index t1  --移动作业
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
union all
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.proj_val_id,chr(13),''),chr(10),'')  -- 指标表数据ID
    ,replace(replace(t1.proj_id,chr(13),''),chr(10),'')  -- 项目编号
    ,replace(replace(t1.proj_name,chr(13),''),chr(10),'')  -- 项目名称
    ,t1.proj_online_dt  -- 项目上线日期
    ,replace(replace(t1.dep_name,chr(13),''),chr(10),'')  -- 需求提出部门
    ,replace(replace(t1.sys_short_name,chr(13),''),chr(10),'')  -- 系统简称
    ,replace(replace(t1.sys_name,chr(13),''),chr(10),'')  -- 系统名称
    ,t1.budg_amt  -- 预算金额
    ,replace(replace(t1.xq_id,chr(13),''),chr(10),'')  -- 需求编号
    ,replace(replace(t1.index_type,chr(13),''),chr(10),'')  -- 指标类型
    ,t1.weht_ratio  -- 权重比例
    ,replace(replace(t1.index_name,chr(13),''),chr(10),'')  -- 指标名称
    ,replace(replace(t1.index_unit,chr(13),''),chr(10),'')  -- 指标单位
    ,t1.tgt_val  -- 目标值
    ,t1.index_val  -- 指标值
    ,replace(replace(t1.stati_peri,chr(13),''),chr(10),'')  -- 统计周期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.vtms_proj_val_index t1  --智慧柜台
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'd_proj_val_index',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);