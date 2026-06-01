/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_fa_cardhistory
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.iers_fa_cardhistory_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_fa_cardhistory
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fa_cardhistory_op purge;
drop table ${iol_schema}.iers_fa_cardhistory_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fa_cardhistory_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_fa_cardhistory where 0=1;

create table ${iol_schema}.iers_fa_cardhistory_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_fa_cardhistory where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fa_cardhistory_cl(
            accudep -- 累计折旧
            ,accudep_cal -- 累计折旧（计算用）
            ,accudep_global -- 累计折旧（全局）
            ,accudep_group -- 累计折旧（集团）
            ,accuworkloan -- 累计工作量
            ,accyear -- 会计年
            ,allworkloan -- 工作总量
            ,asset_state -- 资产状态
            ,business_flag -- 业务标记
            ,card_num -- 数量
            ,curryeardep -- 本年折旧
            ,curryeardep_global -- 本年折旧（全局）
            ,curryeardep_group -- 本年折旧（集团）
            ,dep_end_date -- 折旧截止日期
            ,dep_start_date -- 折旧开始日期
            ,depamount -- 月折旧额
            ,depamount_global -- 月折旧额（全局）
            ,depamount_group -- 月折旧额（集团）
            ,deprate -- 月折旧率(%)
            ,depunit -- 单位折旧
            ,depunit_global -- 单位折旧（全局）
            ,depunit_group -- 单位折旧（集团）
            ,dr -- 删除标志
            ,herit_flag -- 继承标志
            ,laststate_flag -- 月初月末
            ,localcurr_rate -- 折本汇率
            ,localorigin_count -- 计算原值
            ,localoriginvalue -- 本币原值
            ,localoriginvalue_global -- 本币原值（全局）
            ,localoriginvalue_group -- 本币原值（集团）
            ,monthworkloan -- 月工作量
            ,naturemonth -- 使用月限
            ,newasset_flag -- 新增标记
            ,originvalue -- 原币原值
            ,originvalue_cal -- 原币原值
            ,paydept_flag -- 折旧承担部门
            ,period -- 会计月
            ,pk_accbook -- 账簿
            ,pk_card -- 资产卡片(实体)_主键
            ,pk_cardhistory -- 主键
            ,pk_category -- 资产类别
            ,pk_category_old -- 资产类别（期初）
            ,pk_costcenter -- 成本中心
            ,pk_costcenter_old -- 成本中心（期初）
            ,pk_depmethod -- 折旧方法
            ,pk_depmethod_old -- 折旧方法（期初）
            ,pk_equiporg -- 使用权
            ,pk_equiporg_v -- 使用权版本
            ,pk_group -- 集团
            ,pk_jobmngfil -- 项目档案
            ,pk_jobmngfil_old -- 项目档案（期初）
            ,pk_mandept -- 管理部门
            ,pk_mandept_old -- 管理部门（期初）
            ,pk_mandept_v -- 管理部门版本
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_ownerorg -- 货主管理组织
            ,pk_ownerorg_v -- 货主管理组织版本
            ,pk_usedept -- 使用部门
            ,pk_usedept_old -- 使用部门（期初）
            ,pk_usingstatus -- 使用状况
            ,pk_usingstatus_old -- 使用状况（期初）
            ,predevaluate -- 减值准备
            ,predevaluate_global -- 减值准备（全局）
            ,predevaluate_group -- 减值准备（集团）
            ,salvage -- 净残值
            ,salvage_global -- 净残值（全局）
            ,salvage_group -- 净残值（集团）
            ,salvagerate -- 净残值率(%)
            ,servicemonth -- 折旧期数
            ,servicemonth_cal -- 使用月限（计算用）
            ,tax_input -- 进项税
            ,tax_input_global -- 进项税（全局）
            ,tax_input_group -- 进项税（集团）
            ,taxinput_flag -- 抵扣进项税标记
            ,ts -- 时间戳
            ,usedep_flag -- 多使用部门
            ,usedept_display -- 自定义
            ,usedept_display2 -- 自定义
            ,usedept_display3 -- 自定义
            ,usedept_display4 -- 自定义
            ,usedept_display5 -- 自定义
            ,usedept_display6 -- 自定义
            ,usedmonth -- 已计提期数
            ,usedmonth_cal -- 已使用月份（计算用）
            ,workloanunit -- 工作量单位
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fa_cardhistory_op(
            accudep -- 累计折旧
            ,accudep_cal -- 累计折旧（计算用）
            ,accudep_global -- 累计折旧（全局）
            ,accudep_group -- 累计折旧（集团）
            ,accuworkloan -- 累计工作量
            ,accyear -- 会计年
            ,allworkloan -- 工作总量
            ,asset_state -- 资产状态
            ,business_flag -- 业务标记
            ,card_num -- 数量
            ,curryeardep -- 本年折旧
            ,curryeardep_global -- 本年折旧（全局）
            ,curryeardep_group -- 本年折旧（集团）
            ,dep_end_date -- 折旧截止日期
            ,dep_start_date -- 折旧开始日期
            ,depamount -- 月折旧额
            ,depamount_global -- 月折旧额（全局）
            ,depamount_group -- 月折旧额（集团）
            ,deprate -- 月折旧率(%)
            ,depunit -- 单位折旧
            ,depunit_global -- 单位折旧（全局）
            ,depunit_group -- 单位折旧（集团）
            ,dr -- 删除标志
            ,herit_flag -- 继承标志
            ,laststate_flag -- 月初月末
            ,localcurr_rate -- 折本汇率
            ,localorigin_count -- 计算原值
            ,localoriginvalue -- 本币原值
            ,localoriginvalue_global -- 本币原值（全局）
            ,localoriginvalue_group -- 本币原值（集团）
            ,monthworkloan -- 月工作量
            ,naturemonth -- 使用月限
            ,newasset_flag -- 新增标记
            ,originvalue -- 原币原值
            ,originvalue_cal -- 原币原值
            ,paydept_flag -- 折旧承担部门
            ,period -- 会计月
            ,pk_accbook -- 账簿
            ,pk_card -- 资产卡片(实体)_主键
            ,pk_cardhistory -- 主键
            ,pk_category -- 资产类别
            ,pk_category_old -- 资产类别（期初）
            ,pk_costcenter -- 成本中心
            ,pk_costcenter_old -- 成本中心（期初）
            ,pk_depmethod -- 折旧方法
            ,pk_depmethod_old -- 折旧方法（期初）
            ,pk_equiporg -- 使用权
            ,pk_equiporg_v -- 使用权版本
            ,pk_group -- 集团
            ,pk_jobmngfil -- 项目档案
            ,pk_jobmngfil_old -- 项目档案（期初）
            ,pk_mandept -- 管理部门
            ,pk_mandept_old -- 管理部门（期初）
            ,pk_mandept_v -- 管理部门版本
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_ownerorg -- 货主管理组织
            ,pk_ownerorg_v -- 货主管理组织版本
            ,pk_usedept -- 使用部门
            ,pk_usedept_old -- 使用部门（期初）
            ,pk_usingstatus -- 使用状况
            ,pk_usingstatus_old -- 使用状况（期初）
            ,predevaluate -- 减值准备
            ,predevaluate_global -- 减值准备（全局）
            ,predevaluate_group -- 减值准备（集团）
            ,salvage -- 净残值
            ,salvage_global -- 净残值（全局）
            ,salvage_group -- 净残值（集团）
            ,salvagerate -- 净残值率(%)
            ,servicemonth -- 折旧期数
            ,servicemonth_cal -- 使用月限（计算用）
            ,tax_input -- 进项税
            ,tax_input_global -- 进项税（全局）
            ,tax_input_group -- 进项税（集团）
            ,taxinput_flag -- 抵扣进项税标记
            ,ts -- 时间戳
            ,usedep_flag -- 多使用部门
            ,usedept_display -- 自定义
            ,usedept_display2 -- 自定义
            ,usedept_display3 -- 自定义
            ,usedept_display4 -- 自定义
            ,usedept_display5 -- 自定义
            ,usedept_display6 -- 自定义
            ,usedmonth -- 已计提期数
            ,usedmonth_cal -- 已使用月份（计算用）
            ,workloanunit -- 工作量单位
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.accudep, o.accudep) as accudep -- 累计折旧
    ,nvl(n.accudep_cal, o.accudep_cal) as accudep_cal -- 累计折旧（计算用）
    ,nvl(n.accudep_global, o.accudep_global) as accudep_global -- 累计折旧（全局）
    ,nvl(n.accudep_group, o.accudep_group) as accudep_group -- 累计折旧（集团）
    ,nvl(n.accuworkloan, o.accuworkloan) as accuworkloan -- 累计工作量
    ,nvl(n.accyear, o.accyear) as accyear -- 会计年
    ,nvl(n.allworkloan, o.allworkloan) as allworkloan -- 工作总量
    ,nvl(n.asset_state, o.asset_state) as asset_state -- 资产状态
    ,nvl(n.business_flag, o.business_flag) as business_flag -- 业务标记
    ,nvl(n.card_num, o.card_num) as card_num -- 数量
    ,nvl(n.curryeardep, o.curryeardep) as curryeardep -- 本年折旧
    ,nvl(n.curryeardep_global, o.curryeardep_global) as curryeardep_global -- 本年折旧（全局）
    ,nvl(n.curryeardep_group, o.curryeardep_group) as curryeardep_group -- 本年折旧（集团）
    ,nvl(n.dep_end_date, o.dep_end_date) as dep_end_date -- 折旧截止日期
    ,nvl(n.dep_start_date, o.dep_start_date) as dep_start_date -- 折旧开始日期
    ,nvl(n.depamount, o.depamount) as depamount -- 月折旧额
    ,nvl(n.depamount_global, o.depamount_global) as depamount_global -- 月折旧额（全局）
    ,nvl(n.depamount_group, o.depamount_group) as depamount_group -- 月折旧额（集团）
    ,nvl(n.deprate, o.deprate) as deprate -- 月折旧率(%)
    ,nvl(n.depunit, o.depunit) as depunit -- 单位折旧
    ,nvl(n.depunit_global, o.depunit_global) as depunit_global -- 单位折旧（全局）
    ,nvl(n.depunit_group, o.depunit_group) as depunit_group -- 单位折旧（集团）
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.herit_flag, o.herit_flag) as herit_flag -- 继承标志
    ,nvl(n.laststate_flag, o.laststate_flag) as laststate_flag -- 月初月末
    ,nvl(n.localcurr_rate, o.localcurr_rate) as localcurr_rate -- 折本汇率
    ,nvl(n.localorigin_count, o.localorigin_count) as localorigin_count -- 计算原值
    ,nvl(n.localoriginvalue, o.localoriginvalue) as localoriginvalue -- 本币原值
    ,nvl(n.localoriginvalue_global, o.localoriginvalue_global) as localoriginvalue_global -- 本币原值（全局）
    ,nvl(n.localoriginvalue_group, o.localoriginvalue_group) as localoriginvalue_group -- 本币原值（集团）
    ,nvl(n.monthworkloan, o.monthworkloan) as monthworkloan -- 月工作量
    ,nvl(n.naturemonth, o.naturemonth) as naturemonth -- 使用月限
    ,nvl(n.newasset_flag, o.newasset_flag) as newasset_flag -- 新增标记
    ,nvl(n.originvalue, o.originvalue) as originvalue -- 原币原值
    ,nvl(n.originvalue_cal, o.originvalue_cal) as originvalue_cal -- 原币原值
    ,nvl(n.paydept_flag, o.paydept_flag) as paydept_flag -- 折旧承担部门
    ,nvl(n.period, o.period) as period -- 会计月
    ,nvl(n.pk_accbook, o.pk_accbook) as pk_accbook -- 账簿
    ,nvl(n.pk_card, o.pk_card) as pk_card -- 资产卡片(实体)_主键
    ,nvl(n.pk_cardhistory, o.pk_cardhistory) as pk_cardhistory -- 主键
    ,nvl(n.pk_category, o.pk_category) as pk_category -- 资产类别
    ,nvl(n.pk_category_old, o.pk_category_old) as pk_category_old -- 资产类别（期初）
    ,nvl(n.pk_costcenter, o.pk_costcenter) as pk_costcenter -- 成本中心
    ,nvl(n.pk_costcenter_old, o.pk_costcenter_old) as pk_costcenter_old -- 成本中心（期初）
    ,nvl(n.pk_depmethod, o.pk_depmethod) as pk_depmethod -- 折旧方法
    ,nvl(n.pk_depmethod_old, o.pk_depmethod_old) as pk_depmethod_old -- 折旧方法（期初）
    ,nvl(n.pk_equiporg, o.pk_equiporg) as pk_equiporg -- 使用权
    ,nvl(n.pk_equiporg_v, o.pk_equiporg_v) as pk_equiporg_v -- 使用权版本
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 集团
    ,nvl(n.pk_jobmngfil, o.pk_jobmngfil) as pk_jobmngfil -- 项目档案
    ,nvl(n.pk_jobmngfil_old, o.pk_jobmngfil_old) as pk_jobmngfil_old -- 项目档案（期初）
    ,nvl(n.pk_mandept, o.pk_mandept) as pk_mandept -- 管理部门
    ,nvl(n.pk_mandept_old, o.pk_mandept_old) as pk_mandept_old -- 管理部门（期初）
    ,nvl(n.pk_mandept_v, o.pk_mandept_v) as pk_mandept_v -- 管理部门版本
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 财务组织
    ,nvl(n.pk_org_v, o.pk_org_v) as pk_org_v -- 财务组织版本
    ,nvl(n.pk_ownerorg, o.pk_ownerorg) as pk_ownerorg -- 货主管理组织
    ,nvl(n.pk_ownerorg_v, o.pk_ownerorg_v) as pk_ownerorg_v -- 货主管理组织版本
    ,nvl(n.pk_usedept, o.pk_usedept) as pk_usedept -- 使用部门
    ,nvl(n.pk_usedept_old, o.pk_usedept_old) as pk_usedept_old -- 使用部门（期初）
    ,nvl(n.pk_usingstatus, o.pk_usingstatus) as pk_usingstatus -- 使用状况
    ,nvl(n.pk_usingstatus_old, o.pk_usingstatus_old) as pk_usingstatus_old -- 使用状况（期初）
    ,nvl(n.predevaluate, o.predevaluate) as predevaluate -- 减值准备
    ,nvl(n.predevaluate_global, o.predevaluate_global) as predevaluate_global -- 减值准备（全局）
    ,nvl(n.predevaluate_group, o.predevaluate_group) as predevaluate_group -- 减值准备（集团）
    ,nvl(n.salvage, o.salvage) as salvage -- 净残值
    ,nvl(n.salvage_global, o.salvage_global) as salvage_global -- 净残值（全局）
    ,nvl(n.salvage_group, o.salvage_group) as salvage_group -- 净残值（集团）
    ,nvl(n.salvagerate, o.salvagerate) as salvagerate -- 净残值率(%)
    ,nvl(n.servicemonth, o.servicemonth) as servicemonth -- 折旧期数
    ,nvl(n.servicemonth_cal, o.servicemonth_cal) as servicemonth_cal -- 使用月限（计算用）
    ,nvl(n.tax_input, o.tax_input) as tax_input -- 进项税
    ,nvl(n.tax_input_global, o.tax_input_global) as tax_input_global -- 进项税（全局）
    ,nvl(n.tax_input_group, o.tax_input_group) as tax_input_group -- 进项税（集团）
    ,nvl(n.taxinput_flag, o.taxinput_flag) as taxinput_flag -- 抵扣进项税标记
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.usedep_flag, o.usedep_flag) as usedep_flag -- 多使用部门
    ,nvl(n.usedept_display, o.usedept_display) as usedept_display -- 自定义
    ,nvl(n.usedept_display2, o.usedept_display2) as usedept_display2 -- 自定义
    ,nvl(n.usedept_display3, o.usedept_display3) as usedept_display3 -- 自定义
    ,nvl(n.usedept_display4, o.usedept_display4) as usedept_display4 -- 自定义
    ,nvl(n.usedept_display5, o.usedept_display5) as usedept_display5 -- 自定义
    ,nvl(n.usedept_display6, o.usedept_display6) as usedept_display6 -- 自定义
    ,nvl(n.usedmonth, o.usedmonth) as usedmonth -- 已计提期数
    ,nvl(n.usedmonth_cal, o.usedmonth_cal) as usedmonth_cal -- 已使用月份（计算用）
    ,nvl(n.workloanunit, o.workloanunit) as workloanunit -- 工作量单位
    ,case when
            n.pk_cardhistory is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_cardhistory is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_cardhistory is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_fa_cardhistory_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_fa_cardhistory where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_cardhistory = n.pk_cardhistory
where (
        o.pk_cardhistory is null
    )
    or (
        n.pk_cardhistory is null
    )
    or (
        o.accudep <> n.accudep
        or o.accudep_cal <> n.accudep_cal
        or o.accudep_global <> n.accudep_global
        or o.accudep_group <> n.accudep_group
        or o.accuworkloan <> n.accuworkloan
        or o.accyear <> n.accyear
        or o.allworkloan <> n.allworkloan
        or o.asset_state <> n.asset_state
        or o.business_flag <> n.business_flag
        or o.card_num <> n.card_num
        or o.curryeardep <> n.curryeardep
        or o.curryeardep_global <> n.curryeardep_global
        or o.curryeardep_group <> n.curryeardep_group
        or o.dep_end_date <> n.dep_end_date
        or o.dep_start_date <> n.dep_start_date
        or o.depamount <> n.depamount
        or o.depamount_global <> n.depamount_global
        or o.depamount_group <> n.depamount_group
        or o.deprate <> n.deprate
        or o.depunit <> n.depunit
        or o.depunit_global <> n.depunit_global
        or o.depunit_group <> n.depunit_group
        or o.dr <> n.dr
        or o.herit_flag <> n.herit_flag
        or o.laststate_flag <> n.laststate_flag
        or o.localcurr_rate <> n.localcurr_rate
        or o.localorigin_count <> n.localorigin_count
        or o.localoriginvalue <> n.localoriginvalue
        or o.localoriginvalue_global <> n.localoriginvalue_global
        or o.localoriginvalue_group <> n.localoriginvalue_group
        or o.monthworkloan <> n.monthworkloan
        or o.naturemonth <> n.naturemonth
        or o.newasset_flag <> n.newasset_flag
        or o.originvalue <> n.originvalue
        or o.originvalue_cal <> n.originvalue_cal
        or o.paydept_flag <> n.paydept_flag
        or o.period <> n.period
        or o.pk_accbook <> n.pk_accbook
        or o.pk_card <> n.pk_card
        or o.pk_category <> n.pk_category
        or o.pk_category_old <> n.pk_category_old
        or o.pk_costcenter <> n.pk_costcenter
        or o.pk_costcenter_old <> n.pk_costcenter_old
        or o.pk_depmethod <> n.pk_depmethod
        or o.pk_depmethod_old <> n.pk_depmethod_old
        or o.pk_equiporg <> n.pk_equiporg
        or o.pk_equiporg_v <> n.pk_equiporg_v
        or o.pk_group <> n.pk_group
        or o.pk_jobmngfil <> n.pk_jobmngfil
        or o.pk_jobmngfil_old <> n.pk_jobmngfil_old
        or o.pk_mandept <> n.pk_mandept
        or o.pk_mandept_old <> n.pk_mandept_old
        or o.pk_mandept_v <> n.pk_mandept_v
        or o.pk_org <> n.pk_org
        or o.pk_org_v <> n.pk_org_v
        or o.pk_ownerorg <> n.pk_ownerorg
        or o.pk_ownerorg_v <> n.pk_ownerorg_v
        or o.pk_usedept <> n.pk_usedept
        or o.pk_usedept_old <> n.pk_usedept_old
        or o.pk_usingstatus <> n.pk_usingstatus
        or o.pk_usingstatus_old <> n.pk_usingstatus_old
        or o.predevaluate <> n.predevaluate
        or o.predevaluate_global <> n.predevaluate_global
        or o.predevaluate_group <> n.predevaluate_group
        or o.salvage <> n.salvage
        or o.salvage_global <> n.salvage_global
        or o.salvage_group <> n.salvage_group
        or o.salvagerate <> n.salvagerate
        or o.servicemonth <> n.servicemonth
        or o.servicemonth_cal <> n.servicemonth_cal
        or o.tax_input <> n.tax_input
        or o.tax_input_global <> n.tax_input_global
        or o.tax_input_group <> n.tax_input_group
        or o.taxinput_flag <> n.taxinput_flag
        or o.ts <> n.ts
        or o.usedep_flag <> n.usedep_flag
        or o.usedept_display <> n.usedept_display
        or o.usedept_display2 <> n.usedept_display2
        or o.usedept_display3 <> n.usedept_display3
        or o.usedept_display4 <> n.usedept_display4
        or o.usedept_display5 <> n.usedept_display5
        or o.usedept_display6 <> n.usedept_display6
        or o.usedmonth <> n.usedmonth
        or o.usedmonth_cal <> n.usedmonth_cal
        or o.workloanunit <> n.workloanunit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fa_cardhistory_cl(
            accudep -- 累计折旧
            ,accudep_cal -- 累计折旧（计算用）
            ,accudep_global -- 累计折旧（全局）
            ,accudep_group -- 累计折旧（集团）
            ,accuworkloan -- 累计工作量
            ,accyear -- 会计年
            ,allworkloan -- 工作总量
            ,asset_state -- 资产状态
            ,business_flag -- 业务标记
            ,card_num -- 数量
            ,curryeardep -- 本年折旧
            ,curryeardep_global -- 本年折旧（全局）
            ,curryeardep_group -- 本年折旧（集团）
            ,dep_end_date -- 折旧截止日期
            ,dep_start_date -- 折旧开始日期
            ,depamount -- 月折旧额
            ,depamount_global -- 月折旧额（全局）
            ,depamount_group -- 月折旧额（集团）
            ,deprate -- 月折旧率(%)
            ,depunit -- 单位折旧
            ,depunit_global -- 单位折旧（全局）
            ,depunit_group -- 单位折旧（集团）
            ,dr -- 删除标志
            ,herit_flag -- 继承标志
            ,laststate_flag -- 月初月末
            ,localcurr_rate -- 折本汇率
            ,localorigin_count -- 计算原值
            ,localoriginvalue -- 本币原值
            ,localoriginvalue_global -- 本币原值（全局）
            ,localoriginvalue_group -- 本币原值（集团）
            ,monthworkloan -- 月工作量
            ,naturemonth -- 使用月限
            ,newasset_flag -- 新增标记
            ,originvalue -- 原币原值
            ,originvalue_cal -- 原币原值
            ,paydept_flag -- 折旧承担部门
            ,period -- 会计月
            ,pk_accbook -- 账簿
            ,pk_card -- 资产卡片(实体)_主键
            ,pk_cardhistory -- 主键
            ,pk_category -- 资产类别
            ,pk_category_old -- 资产类别（期初）
            ,pk_costcenter -- 成本中心
            ,pk_costcenter_old -- 成本中心（期初）
            ,pk_depmethod -- 折旧方法
            ,pk_depmethod_old -- 折旧方法（期初）
            ,pk_equiporg -- 使用权
            ,pk_equiporg_v -- 使用权版本
            ,pk_group -- 集团
            ,pk_jobmngfil -- 项目档案
            ,pk_jobmngfil_old -- 项目档案（期初）
            ,pk_mandept -- 管理部门
            ,pk_mandept_old -- 管理部门（期初）
            ,pk_mandept_v -- 管理部门版本
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_ownerorg -- 货主管理组织
            ,pk_ownerorg_v -- 货主管理组织版本
            ,pk_usedept -- 使用部门
            ,pk_usedept_old -- 使用部门（期初）
            ,pk_usingstatus -- 使用状况
            ,pk_usingstatus_old -- 使用状况（期初）
            ,predevaluate -- 减值准备
            ,predevaluate_global -- 减值准备（全局）
            ,predevaluate_group -- 减值准备（集团）
            ,salvage -- 净残值
            ,salvage_global -- 净残值（全局）
            ,salvage_group -- 净残值（集团）
            ,salvagerate -- 净残值率(%)
            ,servicemonth -- 折旧期数
            ,servicemonth_cal -- 使用月限（计算用）
            ,tax_input -- 进项税
            ,tax_input_global -- 进项税（全局）
            ,tax_input_group -- 进项税（集团）
            ,taxinput_flag -- 抵扣进项税标记
            ,ts -- 时间戳
            ,usedep_flag -- 多使用部门
            ,usedept_display -- 自定义
            ,usedept_display2 -- 自定义
            ,usedept_display3 -- 自定义
            ,usedept_display4 -- 自定义
            ,usedept_display5 -- 自定义
            ,usedept_display6 -- 自定义
            ,usedmonth -- 已计提期数
            ,usedmonth_cal -- 已使用月份（计算用）
            ,workloanunit -- 工作量单位
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fa_cardhistory_op(
            accudep -- 累计折旧
            ,accudep_cal -- 累计折旧（计算用）
            ,accudep_global -- 累计折旧（全局）
            ,accudep_group -- 累计折旧（集团）
            ,accuworkloan -- 累计工作量
            ,accyear -- 会计年
            ,allworkloan -- 工作总量
            ,asset_state -- 资产状态
            ,business_flag -- 业务标记
            ,card_num -- 数量
            ,curryeardep -- 本年折旧
            ,curryeardep_global -- 本年折旧（全局）
            ,curryeardep_group -- 本年折旧（集团）
            ,dep_end_date -- 折旧截止日期
            ,dep_start_date -- 折旧开始日期
            ,depamount -- 月折旧额
            ,depamount_global -- 月折旧额（全局）
            ,depamount_group -- 月折旧额（集团）
            ,deprate -- 月折旧率(%)
            ,depunit -- 单位折旧
            ,depunit_global -- 单位折旧（全局）
            ,depunit_group -- 单位折旧（集团）
            ,dr -- 删除标志
            ,herit_flag -- 继承标志
            ,laststate_flag -- 月初月末
            ,localcurr_rate -- 折本汇率
            ,localorigin_count -- 计算原值
            ,localoriginvalue -- 本币原值
            ,localoriginvalue_global -- 本币原值（全局）
            ,localoriginvalue_group -- 本币原值（集团）
            ,monthworkloan -- 月工作量
            ,naturemonth -- 使用月限
            ,newasset_flag -- 新增标记
            ,originvalue -- 原币原值
            ,originvalue_cal -- 原币原值
            ,paydept_flag -- 折旧承担部门
            ,period -- 会计月
            ,pk_accbook -- 账簿
            ,pk_card -- 资产卡片(实体)_主键
            ,pk_cardhistory -- 主键
            ,pk_category -- 资产类别
            ,pk_category_old -- 资产类别（期初）
            ,pk_costcenter -- 成本中心
            ,pk_costcenter_old -- 成本中心（期初）
            ,pk_depmethod -- 折旧方法
            ,pk_depmethod_old -- 折旧方法（期初）
            ,pk_equiporg -- 使用权
            ,pk_equiporg_v -- 使用权版本
            ,pk_group -- 集团
            ,pk_jobmngfil -- 项目档案
            ,pk_jobmngfil_old -- 项目档案（期初）
            ,pk_mandept -- 管理部门
            ,pk_mandept_old -- 管理部门（期初）
            ,pk_mandept_v -- 管理部门版本
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_ownerorg -- 货主管理组织
            ,pk_ownerorg_v -- 货主管理组织版本
            ,pk_usedept -- 使用部门
            ,pk_usedept_old -- 使用部门（期初）
            ,pk_usingstatus -- 使用状况
            ,pk_usingstatus_old -- 使用状况（期初）
            ,predevaluate -- 减值准备
            ,predevaluate_global -- 减值准备（全局）
            ,predevaluate_group -- 减值准备（集团）
            ,salvage -- 净残值
            ,salvage_global -- 净残值（全局）
            ,salvage_group -- 净残值（集团）
            ,salvagerate -- 净残值率(%)
            ,servicemonth -- 折旧期数
            ,servicemonth_cal -- 使用月限（计算用）
            ,tax_input -- 进项税
            ,tax_input_global -- 进项税（全局）
            ,tax_input_group -- 进项税（集团）
            ,taxinput_flag -- 抵扣进项税标记
            ,ts -- 时间戳
            ,usedep_flag -- 多使用部门
            ,usedept_display -- 自定义
            ,usedept_display2 -- 自定义
            ,usedept_display3 -- 自定义
            ,usedept_display4 -- 自定义
            ,usedept_display5 -- 自定义
            ,usedept_display6 -- 自定义
            ,usedmonth -- 已计提期数
            ,usedmonth_cal -- 已使用月份（计算用）
            ,workloanunit -- 工作量单位
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.accudep -- 累计折旧
    ,o.accudep_cal -- 累计折旧（计算用）
    ,o.accudep_global -- 累计折旧（全局）
    ,o.accudep_group -- 累计折旧（集团）
    ,o.accuworkloan -- 累计工作量
    ,o.accyear -- 会计年
    ,o.allworkloan -- 工作总量
    ,o.asset_state -- 资产状态
    ,o.business_flag -- 业务标记
    ,o.card_num -- 数量
    ,o.curryeardep -- 本年折旧
    ,o.curryeardep_global -- 本年折旧（全局）
    ,o.curryeardep_group -- 本年折旧（集团）
    ,o.dep_end_date -- 折旧截止日期
    ,o.dep_start_date -- 折旧开始日期
    ,o.depamount -- 月折旧额
    ,o.depamount_global -- 月折旧额（全局）
    ,o.depamount_group -- 月折旧额（集团）
    ,o.deprate -- 月折旧率(%)
    ,o.depunit -- 单位折旧
    ,o.depunit_global -- 单位折旧（全局）
    ,o.depunit_group -- 单位折旧（集团）
    ,o.dr -- 删除标志
    ,o.herit_flag -- 继承标志
    ,o.laststate_flag -- 月初月末
    ,o.localcurr_rate -- 折本汇率
    ,o.localorigin_count -- 计算原值
    ,o.localoriginvalue -- 本币原值
    ,o.localoriginvalue_global -- 本币原值（全局）
    ,o.localoriginvalue_group -- 本币原值（集团）
    ,o.monthworkloan -- 月工作量
    ,o.naturemonth -- 使用月限
    ,o.newasset_flag -- 新增标记
    ,o.originvalue -- 原币原值
    ,o.originvalue_cal -- 原币原值
    ,o.paydept_flag -- 折旧承担部门
    ,o.period -- 会计月
    ,o.pk_accbook -- 账簿
    ,o.pk_card -- 资产卡片(实体)_主键
    ,o.pk_cardhistory -- 主键
    ,o.pk_category -- 资产类别
    ,o.pk_category_old -- 资产类别（期初）
    ,o.pk_costcenter -- 成本中心
    ,o.pk_costcenter_old -- 成本中心（期初）
    ,o.pk_depmethod -- 折旧方法
    ,o.pk_depmethod_old -- 折旧方法（期初）
    ,o.pk_equiporg -- 使用权
    ,o.pk_equiporg_v -- 使用权版本
    ,o.pk_group -- 集团
    ,o.pk_jobmngfil -- 项目档案
    ,o.pk_jobmngfil_old -- 项目档案（期初）
    ,o.pk_mandept -- 管理部门
    ,o.pk_mandept_old -- 管理部门（期初）
    ,o.pk_mandept_v -- 管理部门版本
    ,o.pk_org -- 财务组织
    ,o.pk_org_v -- 财务组织版本
    ,o.pk_ownerorg -- 货主管理组织
    ,o.pk_ownerorg_v -- 货主管理组织版本
    ,o.pk_usedept -- 使用部门
    ,o.pk_usedept_old -- 使用部门（期初）
    ,o.pk_usingstatus -- 使用状况
    ,o.pk_usingstatus_old -- 使用状况（期初）
    ,o.predevaluate -- 减值准备
    ,o.predevaluate_global -- 减值准备（全局）
    ,o.predevaluate_group -- 减值准备（集团）
    ,o.salvage -- 净残值
    ,o.salvage_global -- 净残值（全局）
    ,o.salvage_group -- 净残值（集团）
    ,o.salvagerate -- 净残值率(%)
    ,o.servicemonth -- 折旧期数
    ,o.servicemonth_cal -- 使用月限（计算用）
    ,o.tax_input -- 进项税
    ,o.tax_input_global -- 进项税（全局）
    ,o.tax_input_group -- 进项税（集团）
    ,o.taxinput_flag -- 抵扣进项税标记
    ,o.ts -- 时间戳
    ,o.usedep_flag -- 多使用部门
    ,o.usedept_display -- 自定义
    ,o.usedept_display2 -- 自定义
    ,o.usedept_display3 -- 自定义
    ,o.usedept_display4 -- 自定义
    ,o.usedept_display5 -- 自定义
    ,o.usedept_display6 -- 自定义
    ,o.usedmonth -- 已计提期数
    ,o.usedmonth_cal -- 已使用月份（计算用）
    ,o.workloanunit -- 工作量单位
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.iers_fa_cardhistory_bk o
    left join ${iol_schema}.iers_fa_cardhistory_op n
        on
            o.pk_cardhistory = n.pk_cardhistory
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_fa_cardhistory_cl d
        on
            o.pk_cardhistory = d.pk_cardhistory
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_fa_cardhistory;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_fa_cardhistory') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_fa_cardhistory drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_fa_cardhistory add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_fa_cardhistory exchange partition p_${batch_date} with table ${iol_schema}.iers_fa_cardhistory_cl;
alter table ${iol_schema}.iers_fa_cardhistory exchange partition p_20991231 with table ${iol_schema}.iers_fa_cardhistory_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_fa_cardhistory to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fa_cardhistory_op purge;
drop table ${iol_schema}.iers_fa_cardhistory_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_fa_cardhistory_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_fa_cardhistory',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
