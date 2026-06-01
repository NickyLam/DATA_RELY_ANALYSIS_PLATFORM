/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_fa_cardhistory
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_fa_cardhistory
whenever sqlerror continue none;
drop table ${iol_schema}.iers_fa_cardhistory purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fa_cardhistory(
    accudep number(28,8) -- 累计折旧
    ,accudep_cal number(28,8) -- 累计折旧（计算用）
    ,accudep_global number(28,8) -- 累计折旧（全局）
    ,accudep_group number(28,8) -- 累计折旧（集团）
    ,accuworkloan number(28,8) -- 累计工作量
    ,accyear varchar2(6) -- 会计年
    ,allworkloan number(28,8) -- 工作总量
    ,asset_state varchar2(30) -- 资产状态
    ,business_flag varchar2(2) -- 业务标记
    ,card_num number(38,0) -- 数量
    ,curryeardep number(28,8) -- 本年折旧
    ,curryeardep_global number(28,8) -- 本年折旧（全局）
    ,curryeardep_group number(28,8) -- 本年折旧（集团）
    ,dep_end_date varchar2(29) -- 折旧截止日期
    ,dep_start_date varchar2(29) -- 折旧开始日期
    ,depamount number(28,8) -- 月折旧额
    ,depamount_global number(28,8) -- 月折旧额（全局）
    ,depamount_group number(28,8) -- 月折旧额（集团）
    ,deprate number(28,13) -- 月折旧率(%)
    ,depunit number(28,8) -- 单位折旧
    ,depunit_global number(28,8) -- 单位折旧（全局）
    ,depunit_group number(28,8) -- 单位折旧（集团）
    ,dr number(10,0) -- 删除标志
    ,herit_flag varchar2(2) -- 继承标志
    ,laststate_flag varchar2(2) -- 月初月末
    ,localcurr_rate number(28,8) -- 折本汇率
    ,localorigin_count number(28,8) -- 计算原值
    ,localoriginvalue number(28,8) -- 本币原值
    ,localoriginvalue_global number(28,8) -- 本币原值（全局）
    ,localoriginvalue_group number(28,8) -- 本币原值（集团）
    ,monthworkloan number(28,8) -- 月工作量
    ,naturemonth number(38,0) -- 使用月限
    ,newasset_flag number(38,0) -- 新增标记
    ,originvalue number(28,8) -- 原币原值
    ,originvalue_cal number(28,8) -- 原币原值
    ,paydept_flag varchar2(60) -- 折旧承担部门
    ,period varchar2(3) -- 会计月
    ,pk_accbook varchar2(30) -- 账簿
    ,pk_card varchar2(30) -- 资产卡片(实体)_主键
    ,pk_cardhistory varchar2(30) -- 主键
    ,pk_category varchar2(30) -- 资产类别
    ,pk_category_old varchar2(30) -- 资产类别（期初）
    ,pk_costcenter varchar2(30) -- 成本中心
    ,pk_costcenter_old varchar2(30) -- 成本中心（期初）
    ,pk_depmethod varchar2(30) -- 折旧方法
    ,pk_depmethod_old varchar2(30) -- 折旧方法（期初）
    ,pk_equiporg varchar2(30) -- 使用权
    ,pk_equiporg_v varchar2(30) -- 使用权版本
    ,pk_group varchar2(30) -- 集团
    ,pk_jobmngfil varchar2(30) -- 项目档案
    ,pk_jobmngfil_old varchar2(30) -- 项目档案（期初）
    ,pk_mandept varchar2(30) -- 管理部门
    ,pk_mandept_old varchar2(30) -- 管理部门（期初）
    ,pk_mandept_v varchar2(30) -- 管理部门版本
    ,pk_org varchar2(30) -- 财务组织
    ,pk_org_v varchar2(30) -- 财务组织版本
    ,pk_ownerorg varchar2(30) -- 货主管理组织
    ,pk_ownerorg_v varchar2(30) -- 货主管理组织版本
    ,pk_usedept varchar2(30) -- 使用部门
    ,pk_usedept_old varchar2(30) -- 使用部门（期初）
    ,pk_usingstatus varchar2(30) -- 使用状况
    ,pk_usingstatus_old varchar2(30) -- 使用状况（期初）
    ,predevaluate number(28,8) -- 减值准备
    ,predevaluate_global number(28,8) -- 减值准备（全局）
    ,predevaluate_group number(28,8) -- 减值准备（集团）
    ,salvage number(28,8) -- 净残值
    ,salvage_global number(28,8) -- 净残值（全局）
    ,salvage_group number(28,8) -- 净残值（集团）
    ,salvagerate number(28,8) -- 净残值率(%)
    ,servicemonth number(38,0) -- 折旧期数
    ,servicemonth_cal number(38,0) -- 使用月限（计算用）
    ,tax_input number(28,8) -- 进项税
    ,tax_input_global number(28,8) -- 进项税（全局）
    ,tax_input_group number(28,8) -- 进项税（集团）
    ,taxinput_flag varchar2(2) -- 抵扣进项税标记
    ,ts varchar2(29) -- 时间戳
    ,usedep_flag varchar2(2) -- 多使用部门
    ,usedept_display varchar2(600) -- 自定义
    ,usedept_display2 varchar2(600) -- 自定义
    ,usedept_display3 varchar2(600) -- 自定义
    ,usedept_display4 varchar2(600) -- 自定义
    ,usedept_display5 varchar2(600) -- 自定义
    ,usedept_display6 varchar2(600) -- 自定义
    ,usedmonth number(38,0) -- 已计提期数
    ,usedmonth_cal number(38,0) -- 已使用月份（计算用）
    ,workloanunit varchar2(120) -- 工作量单位
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
grant select on ${iol_schema}.iers_fa_cardhistory to ${iml_schema};
grant select on ${iol_schema}.iers_fa_cardhistory to ${icl_schema};
grant select on ${iol_schema}.iers_fa_cardhistory to ${idl_schema};
grant select on ${iol_schema}.iers_fa_cardhistory to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_fa_cardhistory is '多账簿历史';
comment on column ${iol_schema}.iers_fa_cardhistory.accudep is '累计折旧';
comment on column ${iol_schema}.iers_fa_cardhistory.accudep_cal is '累计折旧（计算用）';
comment on column ${iol_schema}.iers_fa_cardhistory.accudep_global is '累计折旧（全局）';
comment on column ${iol_schema}.iers_fa_cardhistory.accudep_group is '累计折旧（集团）';
comment on column ${iol_schema}.iers_fa_cardhistory.accuworkloan is '累计工作量';
comment on column ${iol_schema}.iers_fa_cardhistory.accyear is '会计年';
comment on column ${iol_schema}.iers_fa_cardhistory.allworkloan is '工作总量';
comment on column ${iol_schema}.iers_fa_cardhistory.asset_state is '资产状态';
comment on column ${iol_schema}.iers_fa_cardhistory.business_flag is '业务标记';
comment on column ${iol_schema}.iers_fa_cardhistory.card_num is '数量';
comment on column ${iol_schema}.iers_fa_cardhistory.curryeardep is '本年折旧';
comment on column ${iol_schema}.iers_fa_cardhistory.curryeardep_global is '本年折旧（全局）';
comment on column ${iol_schema}.iers_fa_cardhistory.curryeardep_group is '本年折旧（集团）';
comment on column ${iol_schema}.iers_fa_cardhistory.dep_end_date is '折旧截止日期';
comment on column ${iol_schema}.iers_fa_cardhistory.dep_start_date is '折旧开始日期';
comment on column ${iol_schema}.iers_fa_cardhistory.depamount is '月折旧额';
comment on column ${iol_schema}.iers_fa_cardhistory.depamount_global is '月折旧额（全局）';
comment on column ${iol_schema}.iers_fa_cardhistory.depamount_group is '月折旧额（集团）';
comment on column ${iol_schema}.iers_fa_cardhistory.deprate is '月折旧率(%)';
comment on column ${iol_schema}.iers_fa_cardhistory.depunit is '单位折旧';
comment on column ${iol_schema}.iers_fa_cardhistory.depunit_global is '单位折旧（全局）';
comment on column ${iol_schema}.iers_fa_cardhistory.depunit_group is '单位折旧（集团）';
comment on column ${iol_schema}.iers_fa_cardhistory.dr is '删除标志';
comment on column ${iol_schema}.iers_fa_cardhistory.herit_flag is '继承标志';
comment on column ${iol_schema}.iers_fa_cardhistory.laststate_flag is '月初月末';
comment on column ${iol_schema}.iers_fa_cardhistory.localcurr_rate is '折本汇率';
comment on column ${iol_schema}.iers_fa_cardhistory.localorigin_count is '计算原值';
comment on column ${iol_schema}.iers_fa_cardhistory.localoriginvalue is '本币原值';
comment on column ${iol_schema}.iers_fa_cardhistory.localoriginvalue_global is '本币原值（全局）';
comment on column ${iol_schema}.iers_fa_cardhistory.localoriginvalue_group is '本币原值（集团）';
comment on column ${iol_schema}.iers_fa_cardhistory.monthworkloan is '月工作量';
comment on column ${iol_schema}.iers_fa_cardhistory.naturemonth is '使用月限';
comment on column ${iol_schema}.iers_fa_cardhistory.newasset_flag is '新增标记';
comment on column ${iol_schema}.iers_fa_cardhistory.originvalue is '原币原值';
comment on column ${iol_schema}.iers_fa_cardhistory.originvalue_cal is '原币原值';
comment on column ${iol_schema}.iers_fa_cardhistory.paydept_flag is '折旧承担部门';
comment on column ${iol_schema}.iers_fa_cardhistory.period is '会计月';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_accbook is '账簿';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_card is '资产卡片(实体)_主键';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_cardhistory is '主键';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_category is '资产类别';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_category_old is '资产类别（期初）';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_costcenter is '成本中心';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_costcenter_old is '成本中心（期初）';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_depmethod is '折旧方法';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_depmethod_old is '折旧方法（期初）';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_equiporg is '使用权';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_equiporg_v is '使用权版本';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_group is '集团';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_jobmngfil is '项目档案';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_jobmngfil_old is '项目档案（期初）';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_mandept is '管理部门';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_mandept_old is '管理部门（期初）';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_mandept_v is '管理部门版本';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_org is '财务组织';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_org_v is '财务组织版本';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_ownerorg is '货主管理组织';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_ownerorg_v is '货主管理组织版本';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_usedept is '使用部门';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_usedept_old is '使用部门（期初）';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_usingstatus is '使用状况';
comment on column ${iol_schema}.iers_fa_cardhistory.pk_usingstatus_old is '使用状况（期初）';
comment on column ${iol_schema}.iers_fa_cardhistory.predevaluate is '减值准备';
comment on column ${iol_schema}.iers_fa_cardhistory.predevaluate_global is '减值准备（全局）';
comment on column ${iol_schema}.iers_fa_cardhistory.predevaluate_group is '减值准备（集团）';
comment on column ${iol_schema}.iers_fa_cardhistory.salvage is '净残值';
comment on column ${iol_schema}.iers_fa_cardhistory.salvage_global is '净残值（全局）';
comment on column ${iol_schema}.iers_fa_cardhistory.salvage_group is '净残值（集团）';
comment on column ${iol_schema}.iers_fa_cardhistory.salvagerate is '净残值率(%)';
comment on column ${iol_schema}.iers_fa_cardhistory.servicemonth is '折旧期数';
comment on column ${iol_schema}.iers_fa_cardhistory.servicemonth_cal is '使用月限（计算用）';
comment on column ${iol_schema}.iers_fa_cardhistory.tax_input is '进项税';
comment on column ${iol_schema}.iers_fa_cardhistory.tax_input_global is '进项税（全局）';
comment on column ${iol_schema}.iers_fa_cardhistory.tax_input_group is '进项税（集团）';
comment on column ${iol_schema}.iers_fa_cardhistory.taxinput_flag is '抵扣进项税标记';
comment on column ${iol_schema}.iers_fa_cardhistory.ts is '时间戳';
comment on column ${iol_schema}.iers_fa_cardhistory.usedep_flag is '多使用部门';
comment on column ${iol_schema}.iers_fa_cardhistory.usedept_display is '自定义';
comment on column ${iol_schema}.iers_fa_cardhistory.usedept_display2 is '自定义';
comment on column ${iol_schema}.iers_fa_cardhistory.usedept_display3 is '自定义';
comment on column ${iol_schema}.iers_fa_cardhistory.usedept_display4 is '自定义';
comment on column ${iol_schema}.iers_fa_cardhistory.usedept_display5 is '自定义';
comment on column ${iol_schema}.iers_fa_cardhistory.usedept_display6 is '自定义';
comment on column ${iol_schema}.iers_fa_cardhistory.usedmonth is '已计提期数';
comment on column ${iol_schema}.iers_fa_cardhistory.usedmonth_cal is '已使用月份（计算用）';
comment on column ${iol_schema}.iers_fa_cardhistory.workloanunit is '工作量单位';
comment on column ${iol_schema}.iers_fa_cardhistory.start_dt is '开始时间';
comment on column ${iol_schema}.iers_fa_cardhistory.end_dt is '结束时间';
comment on column ${iol_schema}.iers_fa_cardhistory.id_mark is '增删标志';
comment on column ${iol_schema}.iers_fa_cardhistory.etl_timestamp is 'ETL处理时间戳';
