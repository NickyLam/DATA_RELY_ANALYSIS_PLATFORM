/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_fa_card
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
create table ${iol_schema}.iers_fa_card_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_fa_card
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fa_card_op purge;
drop table ${iol_schema}.iers_fa_card_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fa_card_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_fa_card where 0=1;

create table ${iol_schema}.iers_fa_card_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_fa_card where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fa_card_cl(
            archarea -- 建筑面积
            ,asset_code -- 资产编码
            ,asset_name -- 资产名称
            ,asset_name2 -- 资产名称2
            ,asset_name3 -- 资产名称3
            ,asset_name4 -- 资产名称4
            ,asset_name5 -- 资产名称5
            ,asset_name6 -- 资产名称6
            ,assetsuit_code -- 资产套号
            ,bar_code -- 条形码
            ,begin_date -- 开始使用日期
            ,bill_code_src -- 来源单据号
            ,bill_source -- 卡片来源
            ,bill_type -- 单据类型
            ,billmaker -- 制单人
            ,billmaketime -- 制单日期
            ,business_date -- 建卡日期
            ,card_code -- 卡片编号
            ,card_model -- 型号
            ,close_date -- 保险截止日期
            ,contrator -- 建筑承包商
            ,creationtime -- 创建日期
            ,creator -- 创建人
            ,currmoney -- 购买价款
            ,deploy_flag -- 调拨标识
            ,dismant_cost -- 弃置费用
            ,dr -- 删除标志
            ,dy_flag -- 递延标识
            ,fundorigin -- 资金来源
            ,install_fee -- 安装调试费
            ,leave_date -- 出厂日期
            ,license -- 车辆牌照号
            ,machinepower -- 电机功率
            ,machinequan -- 电机数量
            ,measureunit -- 计量单位
            ,modifiedtime -- 最后修改日期
            ,modifier -- 最后修改人
            ,nettonnage -- 净吨位
            ,other_cost -- 其他费用
            ,pk_addreducestyle -- 增加方式
            ,pk_assetgroup -- 资产组
            ,pk_assetuser -- 使用人
            ,pk_bill_b_src -- 来源单据表体主键
            ,pk_bill_source -- 来源单据类型主键
            ,pk_bill_src -- 来源单据主键
            ,pk_card -- 主键
            ,pk_currency -- 币种
            ,pk_equip -- 设备主键
            ,pk_equip_usedept -- 设备使用部门
            ,pk_equip_usedept_v -- 设备使用部门版本
            ,pk_group -- 集团
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_raorg -- 利润中心
            ,pk_raorg_v -- 利润中心版本
            ,pk_receipt -- 影像主键
            ,pk_transitype -- 交易类型
            ,pk_user -- 责任人
            ,position -- 存放地点
            ,position2 -- 存放地点2
            ,position3 -- 存放地点3
            ,position4 -- 存放地点4
            ,position5 -- 存放地点5
            ,position6 -- 存放地点6
            ,producer -- 生产厂商
            ,provider -- 供应商
            ,quantity -- 间[座]数
            ,revalued_amount -- 评估值
            ,saga_btxid -- 子事务
            ,saga_frozen -- 冻结状态
            ,saga_gtxid -- 全局事务
            ,saga_status -- 事务状态
            ,soilarea -- 土地面积
            ,soillevel -- 土地级别
            ,spec -- 规格
            ,tax_cost -- 相关税费
            ,transi_type -- 交易类型编码
            ,ts -- 时间戳
            ,workcenter -- 工作中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fa_card_op(
            archarea -- 建筑面积
            ,asset_code -- 资产编码
            ,asset_name -- 资产名称
            ,asset_name2 -- 资产名称2
            ,asset_name3 -- 资产名称3
            ,asset_name4 -- 资产名称4
            ,asset_name5 -- 资产名称5
            ,asset_name6 -- 资产名称6
            ,assetsuit_code -- 资产套号
            ,bar_code -- 条形码
            ,begin_date -- 开始使用日期
            ,bill_code_src -- 来源单据号
            ,bill_source -- 卡片来源
            ,bill_type -- 单据类型
            ,billmaker -- 制单人
            ,billmaketime -- 制单日期
            ,business_date -- 建卡日期
            ,card_code -- 卡片编号
            ,card_model -- 型号
            ,close_date -- 保险截止日期
            ,contrator -- 建筑承包商
            ,creationtime -- 创建日期
            ,creator -- 创建人
            ,currmoney -- 购买价款
            ,deploy_flag -- 调拨标识
            ,dismant_cost -- 弃置费用
            ,dr -- 删除标志
            ,dy_flag -- 递延标识
            ,fundorigin -- 资金来源
            ,install_fee -- 安装调试费
            ,leave_date -- 出厂日期
            ,license -- 车辆牌照号
            ,machinepower -- 电机功率
            ,machinequan -- 电机数量
            ,measureunit -- 计量单位
            ,modifiedtime -- 最后修改日期
            ,modifier -- 最后修改人
            ,nettonnage -- 净吨位
            ,other_cost -- 其他费用
            ,pk_addreducestyle -- 增加方式
            ,pk_assetgroup -- 资产组
            ,pk_assetuser -- 使用人
            ,pk_bill_b_src -- 来源单据表体主键
            ,pk_bill_source -- 来源单据类型主键
            ,pk_bill_src -- 来源单据主键
            ,pk_card -- 主键
            ,pk_currency -- 币种
            ,pk_equip -- 设备主键
            ,pk_equip_usedept -- 设备使用部门
            ,pk_equip_usedept_v -- 设备使用部门版本
            ,pk_group -- 集团
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_raorg -- 利润中心
            ,pk_raorg_v -- 利润中心版本
            ,pk_receipt -- 影像主键
            ,pk_transitype -- 交易类型
            ,pk_user -- 责任人
            ,position -- 存放地点
            ,position2 -- 存放地点2
            ,position3 -- 存放地点3
            ,position4 -- 存放地点4
            ,position5 -- 存放地点5
            ,position6 -- 存放地点6
            ,producer -- 生产厂商
            ,provider -- 供应商
            ,quantity -- 间[座]数
            ,revalued_amount -- 评估值
            ,saga_btxid -- 子事务
            ,saga_frozen -- 冻结状态
            ,saga_gtxid -- 全局事务
            ,saga_status -- 事务状态
            ,soilarea -- 土地面积
            ,soillevel -- 土地级别
            ,spec -- 规格
            ,tax_cost -- 相关税费
            ,transi_type -- 交易类型编码
            ,ts -- 时间戳
            ,workcenter -- 工作中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.archarea, o.archarea) as archarea -- 建筑面积
    ,nvl(n.asset_code, o.asset_code) as asset_code -- 资产编码
    ,nvl(n.asset_name, o.asset_name) as asset_name -- 资产名称
    ,nvl(n.asset_name2, o.asset_name2) as asset_name2 -- 资产名称2
    ,nvl(n.asset_name3, o.asset_name3) as asset_name3 -- 资产名称3
    ,nvl(n.asset_name4, o.asset_name4) as asset_name4 -- 资产名称4
    ,nvl(n.asset_name5, o.asset_name5) as asset_name5 -- 资产名称5
    ,nvl(n.asset_name6, o.asset_name6) as asset_name6 -- 资产名称6
    ,nvl(n.assetsuit_code, o.assetsuit_code) as assetsuit_code -- 资产套号
    ,nvl(n.bar_code, o.bar_code) as bar_code -- 条形码
    ,nvl(n.begin_date, o.begin_date) as begin_date -- 开始使用日期
    ,nvl(n.bill_code_src, o.bill_code_src) as bill_code_src -- 来源单据号
    ,nvl(n.bill_source, o.bill_source) as bill_source -- 卡片来源
    ,nvl(n.bill_type, o.bill_type) as bill_type -- 单据类型
    ,nvl(n.billmaker, o.billmaker) as billmaker -- 制单人
    ,nvl(n.billmaketime, o.billmaketime) as billmaketime -- 制单日期
    ,nvl(n.business_date, o.business_date) as business_date -- 建卡日期
    ,nvl(n.card_code, o.card_code) as card_code -- 卡片编号
    ,nvl(n.card_model, o.card_model) as card_model -- 型号
    ,nvl(n.close_date, o.close_date) as close_date -- 保险截止日期
    ,nvl(n.contrator, o.contrator) as contrator -- 建筑承包商
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建日期
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.currmoney, o.currmoney) as currmoney -- 购买价款
    ,nvl(n.deploy_flag, o.deploy_flag) as deploy_flag -- 调拨标识
    ,nvl(n.dismant_cost, o.dismant_cost) as dismant_cost -- 弃置费用
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.dy_flag, o.dy_flag) as dy_flag -- 递延标识
    ,nvl(n.fundorigin, o.fundorigin) as fundorigin -- 资金来源
    ,nvl(n.install_fee, o.install_fee) as install_fee -- 安装调试费
    ,nvl(n.leave_date, o.leave_date) as leave_date -- 出厂日期
    ,nvl(n.license, o.license) as license -- 车辆牌照号
    ,nvl(n.machinepower, o.machinepower) as machinepower -- 电机功率
    ,nvl(n.machinequan, o.machinequan) as machinequan -- 电机数量
    ,nvl(n.measureunit, o.measureunit) as measureunit -- 计量单位
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 最后修改日期
    ,nvl(n.modifier, o.modifier) as modifier -- 最后修改人
    ,nvl(n.nettonnage, o.nettonnage) as nettonnage -- 净吨位
    ,nvl(n.other_cost, o.other_cost) as other_cost -- 其他费用
    ,nvl(n.pk_addreducestyle, o.pk_addreducestyle) as pk_addreducestyle -- 增加方式
    ,nvl(n.pk_assetgroup, o.pk_assetgroup) as pk_assetgroup -- 资产组
    ,nvl(n.pk_assetuser, o.pk_assetuser) as pk_assetuser -- 使用人
    ,nvl(n.pk_bill_b_src, o.pk_bill_b_src) as pk_bill_b_src -- 来源单据表体主键
    ,nvl(n.pk_bill_source, o.pk_bill_source) as pk_bill_source -- 来源单据类型主键
    ,nvl(n.pk_bill_src, o.pk_bill_src) as pk_bill_src -- 来源单据主键
    ,nvl(n.pk_card, o.pk_card) as pk_card -- 主键
    ,nvl(n.pk_currency, o.pk_currency) as pk_currency -- 币种
    ,nvl(n.pk_equip, o.pk_equip) as pk_equip -- 设备主键
    ,nvl(n.pk_equip_usedept, o.pk_equip_usedept) as pk_equip_usedept -- 设备使用部门
    ,nvl(n.pk_equip_usedept_v, o.pk_equip_usedept_v) as pk_equip_usedept_v -- 设备使用部门版本
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 集团
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 财务组织
    ,nvl(n.pk_org_v, o.pk_org_v) as pk_org_v -- 财务组织版本
    ,nvl(n.pk_raorg, o.pk_raorg) as pk_raorg -- 利润中心
    ,nvl(n.pk_raorg_v, o.pk_raorg_v) as pk_raorg_v -- 利润中心版本
    ,nvl(n.pk_receipt, o.pk_receipt) as pk_receipt -- 影像主键
    ,nvl(n.pk_transitype, o.pk_transitype) as pk_transitype -- 交易类型
    ,nvl(n.pk_user, o.pk_user) as pk_user -- 责任人
    ,nvl(n.position, o.position) as position -- 存放地点
    ,nvl(n.position2, o.position2) as position2 -- 存放地点2
    ,nvl(n.position3, o.position3) as position3 -- 存放地点3
    ,nvl(n.position4, o.position4) as position4 -- 存放地点4
    ,nvl(n.position5, o.position5) as position5 -- 存放地点5
    ,nvl(n.position6, o.position6) as position6 -- 存放地点6
    ,nvl(n.producer, o.producer) as producer -- 生产厂商
    ,nvl(n.provider, o.provider) as provider -- 供应商
    ,nvl(n.quantity, o.quantity) as quantity -- 间[座]数
    ,nvl(n.revalued_amount, o.revalued_amount) as revalued_amount -- 评估值
    ,nvl(n.saga_btxid, o.saga_btxid) as saga_btxid -- 子事务
    ,nvl(n.saga_frozen, o.saga_frozen) as saga_frozen -- 冻结状态
    ,nvl(n.saga_gtxid, o.saga_gtxid) as saga_gtxid -- 全局事务
    ,nvl(n.saga_status, o.saga_status) as saga_status -- 事务状态
    ,nvl(n.soilarea, o.soilarea) as soilarea -- 土地面积
    ,nvl(n.soillevel, o.soillevel) as soillevel -- 土地级别
    ,nvl(n.spec, o.spec) as spec -- 规格
    ,nvl(n.tax_cost, o.tax_cost) as tax_cost -- 相关税费
    ,nvl(n.transi_type, o.transi_type) as transi_type -- 交易类型编码
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.workcenter, o.workcenter) as workcenter -- 工作中心
    ,case when
            n.pk_card is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_card is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_card is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_fa_card_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_fa_card where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_card = n.pk_card
where (
        o.pk_card is null
    )
    or (
        n.pk_card is null
    )
    or (
        o.archarea <> n.archarea
        or o.asset_code <> n.asset_code
        or o.asset_name <> n.asset_name
        or o.asset_name2 <> n.asset_name2
        or o.asset_name3 <> n.asset_name3
        or o.asset_name4 <> n.asset_name4
        or o.asset_name5 <> n.asset_name5
        or o.asset_name6 <> n.asset_name6
        or o.assetsuit_code <> n.assetsuit_code
        or o.bar_code <> n.bar_code
        or o.begin_date <> n.begin_date
        or o.bill_code_src <> n.bill_code_src
        or o.bill_source <> n.bill_source
        or o.bill_type <> n.bill_type
        or o.billmaker <> n.billmaker
        or o.billmaketime <> n.billmaketime
        or o.business_date <> n.business_date
        or o.card_code <> n.card_code
        or o.card_model <> n.card_model
        or o.close_date <> n.close_date
        or o.contrator <> n.contrator
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.currmoney <> n.currmoney
        or o.deploy_flag <> n.deploy_flag
        or o.dismant_cost <> n.dismant_cost
        or o.dr <> n.dr
        or o.dy_flag <> n.dy_flag
        or o.fundorigin <> n.fundorigin
        or o.install_fee <> n.install_fee
        or o.leave_date <> n.leave_date
        or o.license <> n.license
        or o.machinepower <> n.machinepower
        or o.machinequan <> n.machinequan
        or o.measureunit <> n.measureunit
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.nettonnage <> n.nettonnage
        or o.other_cost <> n.other_cost
        or o.pk_addreducestyle <> n.pk_addreducestyle
        or o.pk_assetgroup <> n.pk_assetgroup
        or o.pk_assetuser <> n.pk_assetuser
        or o.pk_bill_b_src <> n.pk_bill_b_src
        or o.pk_bill_source <> n.pk_bill_source
        or o.pk_bill_src <> n.pk_bill_src
        or o.pk_currency <> n.pk_currency
        or o.pk_equip <> n.pk_equip
        or o.pk_equip_usedept <> n.pk_equip_usedept
        or o.pk_equip_usedept_v <> n.pk_equip_usedept_v
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_org_v <> n.pk_org_v
        or o.pk_raorg <> n.pk_raorg
        or o.pk_raorg_v <> n.pk_raorg_v
        or o.pk_receipt <> n.pk_receipt
        or o.pk_transitype <> n.pk_transitype
        or o.pk_user <> n.pk_user
        or o.position <> n.position
        or o.position2 <> n.position2
        or o.position3 <> n.position3
        or o.position4 <> n.position4
        or o.position5 <> n.position5
        or o.position6 <> n.position6
        or o.producer <> n.producer
        or o.provider <> n.provider
        or o.quantity <> n.quantity
        or o.revalued_amount <> n.revalued_amount
        or o.saga_btxid <> n.saga_btxid
        or o.saga_frozen <> n.saga_frozen
        or o.saga_gtxid <> n.saga_gtxid
        or o.saga_status <> n.saga_status
        or o.soilarea <> n.soilarea
        or o.soillevel <> n.soillevel
        or o.spec <> n.spec
        or o.tax_cost <> n.tax_cost
        or o.transi_type <> n.transi_type
        or o.ts <> n.ts
        or o.workcenter <> n.workcenter
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fa_card_cl(
            archarea -- 建筑面积
            ,asset_code -- 资产编码
            ,asset_name -- 资产名称
            ,asset_name2 -- 资产名称2
            ,asset_name3 -- 资产名称3
            ,asset_name4 -- 资产名称4
            ,asset_name5 -- 资产名称5
            ,asset_name6 -- 资产名称6
            ,assetsuit_code -- 资产套号
            ,bar_code -- 条形码
            ,begin_date -- 开始使用日期
            ,bill_code_src -- 来源单据号
            ,bill_source -- 卡片来源
            ,bill_type -- 单据类型
            ,billmaker -- 制单人
            ,billmaketime -- 制单日期
            ,business_date -- 建卡日期
            ,card_code -- 卡片编号
            ,card_model -- 型号
            ,close_date -- 保险截止日期
            ,contrator -- 建筑承包商
            ,creationtime -- 创建日期
            ,creator -- 创建人
            ,currmoney -- 购买价款
            ,deploy_flag -- 调拨标识
            ,dismant_cost -- 弃置费用
            ,dr -- 删除标志
            ,dy_flag -- 递延标识
            ,fundorigin -- 资金来源
            ,install_fee -- 安装调试费
            ,leave_date -- 出厂日期
            ,license -- 车辆牌照号
            ,machinepower -- 电机功率
            ,machinequan -- 电机数量
            ,measureunit -- 计量单位
            ,modifiedtime -- 最后修改日期
            ,modifier -- 最后修改人
            ,nettonnage -- 净吨位
            ,other_cost -- 其他费用
            ,pk_addreducestyle -- 增加方式
            ,pk_assetgroup -- 资产组
            ,pk_assetuser -- 使用人
            ,pk_bill_b_src -- 来源单据表体主键
            ,pk_bill_source -- 来源单据类型主键
            ,pk_bill_src -- 来源单据主键
            ,pk_card -- 主键
            ,pk_currency -- 币种
            ,pk_equip -- 设备主键
            ,pk_equip_usedept -- 设备使用部门
            ,pk_equip_usedept_v -- 设备使用部门版本
            ,pk_group -- 集团
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_raorg -- 利润中心
            ,pk_raorg_v -- 利润中心版本
            ,pk_receipt -- 影像主键
            ,pk_transitype -- 交易类型
            ,pk_user -- 责任人
            ,position -- 存放地点
            ,position2 -- 存放地点2
            ,position3 -- 存放地点3
            ,position4 -- 存放地点4
            ,position5 -- 存放地点5
            ,position6 -- 存放地点6
            ,producer -- 生产厂商
            ,provider -- 供应商
            ,quantity -- 间[座]数
            ,revalued_amount -- 评估值
            ,saga_btxid -- 子事务
            ,saga_frozen -- 冻结状态
            ,saga_gtxid -- 全局事务
            ,saga_status -- 事务状态
            ,soilarea -- 土地面积
            ,soillevel -- 土地级别
            ,spec -- 规格
            ,tax_cost -- 相关税费
            ,transi_type -- 交易类型编码
            ,ts -- 时间戳
            ,workcenter -- 工作中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fa_card_op(
            archarea -- 建筑面积
            ,asset_code -- 资产编码
            ,asset_name -- 资产名称
            ,asset_name2 -- 资产名称2
            ,asset_name3 -- 资产名称3
            ,asset_name4 -- 资产名称4
            ,asset_name5 -- 资产名称5
            ,asset_name6 -- 资产名称6
            ,assetsuit_code -- 资产套号
            ,bar_code -- 条形码
            ,begin_date -- 开始使用日期
            ,bill_code_src -- 来源单据号
            ,bill_source -- 卡片来源
            ,bill_type -- 单据类型
            ,billmaker -- 制单人
            ,billmaketime -- 制单日期
            ,business_date -- 建卡日期
            ,card_code -- 卡片编号
            ,card_model -- 型号
            ,close_date -- 保险截止日期
            ,contrator -- 建筑承包商
            ,creationtime -- 创建日期
            ,creator -- 创建人
            ,currmoney -- 购买价款
            ,deploy_flag -- 调拨标识
            ,dismant_cost -- 弃置费用
            ,dr -- 删除标志
            ,dy_flag -- 递延标识
            ,fundorigin -- 资金来源
            ,install_fee -- 安装调试费
            ,leave_date -- 出厂日期
            ,license -- 车辆牌照号
            ,machinepower -- 电机功率
            ,machinequan -- 电机数量
            ,measureunit -- 计量单位
            ,modifiedtime -- 最后修改日期
            ,modifier -- 最后修改人
            ,nettonnage -- 净吨位
            ,other_cost -- 其他费用
            ,pk_addreducestyle -- 增加方式
            ,pk_assetgroup -- 资产组
            ,pk_assetuser -- 使用人
            ,pk_bill_b_src -- 来源单据表体主键
            ,pk_bill_source -- 来源单据类型主键
            ,pk_bill_src -- 来源单据主键
            ,pk_card -- 主键
            ,pk_currency -- 币种
            ,pk_equip -- 设备主键
            ,pk_equip_usedept -- 设备使用部门
            ,pk_equip_usedept_v -- 设备使用部门版本
            ,pk_group -- 集团
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_raorg -- 利润中心
            ,pk_raorg_v -- 利润中心版本
            ,pk_receipt -- 影像主键
            ,pk_transitype -- 交易类型
            ,pk_user -- 责任人
            ,position -- 存放地点
            ,position2 -- 存放地点2
            ,position3 -- 存放地点3
            ,position4 -- 存放地点4
            ,position5 -- 存放地点5
            ,position6 -- 存放地点6
            ,producer -- 生产厂商
            ,provider -- 供应商
            ,quantity -- 间[座]数
            ,revalued_amount -- 评估值
            ,saga_btxid -- 子事务
            ,saga_frozen -- 冻结状态
            ,saga_gtxid -- 全局事务
            ,saga_status -- 事务状态
            ,soilarea -- 土地面积
            ,soillevel -- 土地级别
            ,spec -- 规格
            ,tax_cost -- 相关税费
            ,transi_type -- 交易类型编码
            ,ts -- 时间戳
            ,workcenter -- 工作中心
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.archarea -- 建筑面积
    ,o.asset_code -- 资产编码
    ,o.asset_name -- 资产名称
    ,o.asset_name2 -- 资产名称2
    ,o.asset_name3 -- 资产名称3
    ,o.asset_name4 -- 资产名称4
    ,o.asset_name5 -- 资产名称5
    ,o.asset_name6 -- 资产名称6
    ,o.assetsuit_code -- 资产套号
    ,o.bar_code -- 条形码
    ,o.begin_date -- 开始使用日期
    ,o.bill_code_src -- 来源单据号
    ,o.bill_source -- 卡片来源
    ,o.bill_type -- 单据类型
    ,o.billmaker -- 制单人
    ,o.billmaketime -- 制单日期
    ,o.business_date -- 建卡日期
    ,o.card_code -- 卡片编号
    ,o.card_model -- 型号
    ,o.close_date -- 保险截止日期
    ,o.contrator -- 建筑承包商
    ,o.creationtime -- 创建日期
    ,o.creator -- 创建人
    ,o.currmoney -- 购买价款
    ,o.deploy_flag -- 调拨标识
    ,o.dismant_cost -- 弃置费用
    ,o.dr -- 删除标志
    ,o.dy_flag -- 递延标识
    ,o.fundorigin -- 资金来源
    ,o.install_fee -- 安装调试费
    ,o.leave_date -- 出厂日期
    ,o.license -- 车辆牌照号
    ,o.machinepower -- 电机功率
    ,o.machinequan -- 电机数量
    ,o.measureunit -- 计量单位
    ,o.modifiedtime -- 最后修改日期
    ,o.modifier -- 最后修改人
    ,o.nettonnage -- 净吨位
    ,o.other_cost -- 其他费用
    ,o.pk_addreducestyle -- 增加方式
    ,o.pk_assetgroup -- 资产组
    ,o.pk_assetuser -- 使用人
    ,o.pk_bill_b_src -- 来源单据表体主键
    ,o.pk_bill_source -- 来源单据类型主键
    ,o.pk_bill_src -- 来源单据主键
    ,o.pk_card -- 主键
    ,o.pk_currency -- 币种
    ,o.pk_equip -- 设备主键
    ,o.pk_equip_usedept -- 设备使用部门
    ,o.pk_equip_usedept_v -- 设备使用部门版本
    ,o.pk_group -- 集团
    ,o.pk_org -- 财务组织
    ,o.pk_org_v -- 财务组织版本
    ,o.pk_raorg -- 利润中心
    ,o.pk_raorg_v -- 利润中心版本
    ,o.pk_receipt -- 影像主键
    ,o.pk_transitype -- 交易类型
    ,o.pk_user -- 责任人
    ,o.position -- 存放地点
    ,o.position2 -- 存放地点2
    ,o.position3 -- 存放地点3
    ,o.position4 -- 存放地点4
    ,o.position5 -- 存放地点5
    ,o.position6 -- 存放地点6
    ,o.producer -- 生产厂商
    ,o.provider -- 供应商
    ,o.quantity -- 间[座]数
    ,o.revalued_amount -- 评估值
    ,o.saga_btxid -- 子事务
    ,o.saga_frozen -- 冻结状态
    ,o.saga_gtxid -- 全局事务
    ,o.saga_status -- 事务状态
    ,o.soilarea -- 土地面积
    ,o.soillevel -- 土地级别
    ,o.spec -- 规格
    ,o.tax_cost -- 相关税费
    ,o.transi_type -- 交易类型编码
    ,o.ts -- 时间戳
    ,o.workcenter -- 工作中心
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
from ${iol_schema}.iers_fa_card_bk o
    left join ${iol_schema}.iers_fa_card_op n
        on
            o.pk_card = n.pk_card
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_fa_card_cl d
        on
            o.pk_card = d.pk_card
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_fa_card;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_fa_card') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_fa_card drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_fa_card add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_fa_card exchange partition p_${batch_date} with table ${iol_schema}.iers_fa_card_cl;
alter table ${iol_schema}.iers_fa_card exchange partition p_20991231 with table ${iol_schema}.iers_fa_card_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_fa_card to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fa_card_op purge;
drop table ${iol_schema}.iers_fa_card_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_fa_card_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_fa_card',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
