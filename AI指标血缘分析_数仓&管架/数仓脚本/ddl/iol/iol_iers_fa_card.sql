/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_fa_card
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_fa_card
whenever sqlerror continue none;
drop table ${iol_schema}.iers_fa_card purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fa_card(
    archarea number(28,8) -- 建筑面积
    ,asset_code varchar2(60) -- 资产编码
    ,asset_name varchar2(600) -- 资产名称
    ,asset_name2 varchar2(600) -- 资产名称2
    ,asset_name3 varchar2(600) -- 资产名称3
    ,asset_name4 varchar2(600) -- 资产名称4
    ,asset_name5 varchar2(600) -- 资产名称5
    ,asset_name6 varchar2(600) -- 资产名称6
    ,assetsuit_code varchar2(480) -- 资产套号
    ,bar_code varchar2(120) -- 条形码
    ,begin_date varchar2(29) -- 开始使用日期
    ,bill_code_src varchar2(60) -- 来源单据号
    ,bill_source varchar2(60) -- 卡片来源
    ,bill_type varchar2(6) -- 单据类型
    ,billmaker varchar2(30) -- 制单人
    ,billmaketime varchar2(29) -- 制单日期
    ,business_date varchar2(29) -- 建卡日期
    ,card_code varchar2(60) -- 卡片编号
    ,card_model varchar2(600) -- 型号
    ,close_date varchar2(29) -- 保险截止日期
    ,contrator varchar2(120) -- 建筑承包商
    ,creationtime varchar2(29) -- 创建日期
    ,creator varchar2(30) -- 创建人
    ,currmoney number(28,8) -- 购买价款
    ,deploy_flag varchar2(30) -- 调拨标识
    ,dismant_cost number(28,8) -- 弃置费用
    ,dr number(10,0) -- 删除标志
    ,dy_flag varchar2(2) -- 递延标识
    ,fundorigin varchar2(120) -- 资金来源
    ,install_fee number(28,8) -- 安装调试费
    ,leave_date varchar2(29) -- 出厂日期
    ,license varchar2(120) -- 车辆牌照号
    ,machinepower number(28,8) -- 电机功率
    ,machinequan number(38,0) -- 电机数量
    ,measureunit varchar2(30) -- 计量单位
    ,modifiedtime varchar2(29) -- 最后修改日期
    ,modifier varchar2(30) -- 最后修改人
    ,nettonnage number(28,8) -- 净吨位
    ,other_cost number(28,8) -- 其他费用
    ,pk_addreducestyle varchar2(30) -- 增加方式
    ,pk_assetgroup varchar2(30) -- 资产组
    ,pk_assetuser varchar2(30) -- 使用人
    ,pk_bill_b_src varchar2(30) -- 来源单据表体主键
    ,pk_bill_source varchar2(30) -- 来源单据类型主键
    ,pk_bill_src varchar2(30) -- 来源单据主键
    ,pk_card varchar2(30) -- 主键
    ,pk_currency varchar2(30) -- 币种
    ,pk_equip varchar2(30) -- 设备主键
    ,pk_equip_usedept varchar2(30) -- 设备使用部门
    ,pk_equip_usedept_v varchar2(30) -- 设备使用部门版本
    ,pk_group varchar2(30) -- 集团
    ,pk_org varchar2(30) -- 财务组织
    ,pk_org_v varchar2(30) -- 财务组织版本
    ,pk_raorg varchar2(30) -- 利润中心
    ,pk_raorg_v varchar2(30) -- 利润中心版本
    ,pk_receipt varchar2(30) -- 影像主键
    ,pk_transitype varchar2(30) -- 交易类型
    ,pk_user varchar2(30) -- 责任人
    ,position varchar2(120) -- 存放地点
    ,position2 varchar2(120) -- 存放地点2
    ,position3 varchar2(120) -- 存放地点3
    ,position4 varchar2(120) -- 存放地点4
    ,position5 varchar2(120) -- 存放地点5
    ,position6 varchar2(120) -- 存放地点6
    ,producer varchar2(120) -- 生产厂商
    ,provider varchar2(30) -- 供应商
    ,quantity number(38,0) -- 间[座]数
    ,revalued_amount number(28,8) -- 评估值
    ,saga_btxid varchar2(96) -- 子事务
    ,saga_frozen number(38,0) -- 冻结状态
    ,saga_gtxid varchar2(96) -- 全局事务
    ,saga_status number(38,0) -- 事务状态
    ,soilarea number(28,8) -- 土地面积
    ,soillevel varchar2(120) -- 土地级别
    ,spec varchar2(600) -- 规格
    ,tax_cost number(28,8) -- 相关税费
    ,transi_type varchar2(45) -- 交易类型编码
    ,ts varchar2(29) -- 时间戳
    ,workcenter varchar2(30) -- 工作中心
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.iers_fa_card to ${iml_schema};
grant select on ${iol_schema}.iers_fa_card to ${icl_schema};
grant select on ${iol_schema}.iers_fa_card to ${idl_schema};
grant select on ${iol_schema}.iers_fa_card to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_fa_card is '无形资产明细表';
comment on column ${iol_schema}.iers_fa_card.archarea is '建筑面积';
comment on column ${iol_schema}.iers_fa_card.asset_code is '资产编码';
comment on column ${iol_schema}.iers_fa_card.asset_name is '资产名称';
comment on column ${iol_schema}.iers_fa_card.asset_name2 is '资产名称2';
comment on column ${iol_schema}.iers_fa_card.asset_name3 is '资产名称3';
comment on column ${iol_schema}.iers_fa_card.asset_name4 is '资产名称4';
comment on column ${iol_schema}.iers_fa_card.asset_name5 is '资产名称5';
comment on column ${iol_schema}.iers_fa_card.asset_name6 is '资产名称6';
comment on column ${iol_schema}.iers_fa_card.assetsuit_code is '资产套号';
comment on column ${iol_schema}.iers_fa_card.bar_code is '条形码';
comment on column ${iol_schema}.iers_fa_card.begin_date is '开始使用日期';
comment on column ${iol_schema}.iers_fa_card.bill_code_src is '来源单据号';
comment on column ${iol_schema}.iers_fa_card.bill_source is '卡片来源';
comment on column ${iol_schema}.iers_fa_card.bill_type is '单据类型';
comment on column ${iol_schema}.iers_fa_card.billmaker is '制单人';
comment on column ${iol_schema}.iers_fa_card.billmaketime is '制单日期';
comment on column ${iol_schema}.iers_fa_card.business_date is '建卡日期';
comment on column ${iol_schema}.iers_fa_card.card_code is '卡片编号';
comment on column ${iol_schema}.iers_fa_card.card_model is '型号';
comment on column ${iol_schema}.iers_fa_card.close_date is '保险截止日期';
comment on column ${iol_schema}.iers_fa_card.contrator is '建筑承包商';
comment on column ${iol_schema}.iers_fa_card.creationtime is '创建日期';
comment on column ${iol_schema}.iers_fa_card.creator is '创建人';
comment on column ${iol_schema}.iers_fa_card.currmoney is '购买价款';
comment on column ${iol_schema}.iers_fa_card.deploy_flag is '调拨标识';
comment on column ${iol_schema}.iers_fa_card.dismant_cost is '弃置费用';
comment on column ${iol_schema}.iers_fa_card.dr is '删除标志';
comment on column ${iol_schema}.iers_fa_card.dy_flag is '递延标识';
comment on column ${iol_schema}.iers_fa_card.fundorigin is '资金来源';
comment on column ${iol_schema}.iers_fa_card.install_fee is '安装调试费';
comment on column ${iol_schema}.iers_fa_card.leave_date is '出厂日期';
comment on column ${iol_schema}.iers_fa_card.license is '车辆牌照号';
comment on column ${iol_schema}.iers_fa_card.machinepower is '电机功率';
comment on column ${iol_schema}.iers_fa_card.machinequan is '电机数量';
comment on column ${iol_schema}.iers_fa_card.measureunit is '计量单位';
comment on column ${iol_schema}.iers_fa_card.modifiedtime is '最后修改日期';
comment on column ${iol_schema}.iers_fa_card.modifier is '最后修改人';
comment on column ${iol_schema}.iers_fa_card.nettonnage is '净吨位';
comment on column ${iol_schema}.iers_fa_card.other_cost is '其他费用';
comment on column ${iol_schema}.iers_fa_card.pk_addreducestyle is '增加方式';
comment on column ${iol_schema}.iers_fa_card.pk_assetgroup is '资产组';
comment on column ${iol_schema}.iers_fa_card.pk_assetuser is '使用人';
comment on column ${iol_schema}.iers_fa_card.pk_bill_b_src is '来源单据表体主键';
comment on column ${iol_schema}.iers_fa_card.pk_bill_source is '来源单据类型主键';
comment on column ${iol_schema}.iers_fa_card.pk_bill_src is '来源单据主键';
comment on column ${iol_schema}.iers_fa_card.pk_card is '主键';
comment on column ${iol_schema}.iers_fa_card.pk_currency is '币种';
comment on column ${iol_schema}.iers_fa_card.pk_equip is '设备主键';
comment on column ${iol_schema}.iers_fa_card.pk_equip_usedept is '设备使用部门';
comment on column ${iol_schema}.iers_fa_card.pk_equip_usedept_v is '设备使用部门版本';
comment on column ${iol_schema}.iers_fa_card.pk_group is '集团';
comment on column ${iol_schema}.iers_fa_card.pk_org is '财务组织';
comment on column ${iol_schema}.iers_fa_card.pk_org_v is '财务组织版本';
comment on column ${iol_schema}.iers_fa_card.pk_raorg is '利润中心';
comment on column ${iol_schema}.iers_fa_card.pk_raorg_v is '利润中心版本';
comment on column ${iol_schema}.iers_fa_card.pk_receipt is '影像主键';
comment on column ${iol_schema}.iers_fa_card.pk_transitype is '交易类型';
comment on column ${iol_schema}.iers_fa_card.pk_user is '责任人';
comment on column ${iol_schema}.iers_fa_card.position is '存放地点';
comment on column ${iol_schema}.iers_fa_card.position2 is '存放地点2';
comment on column ${iol_schema}.iers_fa_card.position3 is '存放地点3';
comment on column ${iol_schema}.iers_fa_card.position4 is '存放地点4';
comment on column ${iol_schema}.iers_fa_card.position5 is '存放地点5';
comment on column ${iol_schema}.iers_fa_card.position6 is '存放地点6';
comment on column ${iol_schema}.iers_fa_card.producer is '生产厂商';
comment on column ${iol_schema}.iers_fa_card.provider is '供应商';
comment on column ${iol_schema}.iers_fa_card.quantity is '间[座]数';
comment on column ${iol_schema}.iers_fa_card.revalued_amount is '评估值';
comment on column ${iol_schema}.iers_fa_card.saga_btxid is '子事务';
comment on column ${iol_schema}.iers_fa_card.saga_frozen is '冻结状态';
comment on column ${iol_schema}.iers_fa_card.saga_gtxid is '全局事务';
comment on column ${iol_schema}.iers_fa_card.saga_status is '事务状态';
comment on column ${iol_schema}.iers_fa_card.soilarea is '土地面积';
comment on column ${iol_schema}.iers_fa_card.soillevel is '土地级别';
comment on column ${iol_schema}.iers_fa_card.spec is '规格';
comment on column ${iol_schema}.iers_fa_card.tax_cost is '相关税费';
comment on column ${iol_schema}.iers_fa_card.transi_type is '交易类型编码';
comment on column ${iol_schema}.iers_fa_card.ts is '时间戳';
comment on column ${iol_schema}.iers_fa_card.workcenter is '工作中心';
comment on column ${iol_schema}.iers_fa_card.start_dt is '开始时间';
comment on column ${iol_schema}.iers_fa_card.end_dt is '结束时间';
comment on column ${iol_schema}.iers_fa_card.id_mark is '增删标志';
comment on column ${iol_schema}.iers_fa_card.etl_timestamp is 'ETL处理时间戳';
