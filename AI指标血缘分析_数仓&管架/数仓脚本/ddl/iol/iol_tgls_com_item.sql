/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_com_item
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_com_item
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_com_item purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_com_item(
    stacid number(19) -- 账套标记
    ,itemcd varchar2(30) -- 科目编号
    ,sprrcd varchar2(30) -- 上级科目编号
    ,itemna varchar2(200) -- 科目名称
    ,itemlv number -- 科目级别
    ,cutrna varchar2(200) -- 备用名称
    ,itemtp varchar2(1) -- 科目类型(1资产类2负债类3所有者权益类4系统往来类5损益类6表外,7备忘)
    ,itempr varchar2(1) -- 科目属性0汇总科目2多账户科目3无分户科目
    ,detltg varchar2(1) -- 是否末级(0非末级科目1末级科目)
    ,itemdn varchar2(1) -- 科目余额方向(d,c,r.p.b)
    ,usedtp varchar2(1) -- 是否已使用(1:已使用,0:未使用,9:停用)
    ,measut varchar2(30) -- 计量单位
    ,confin varchar2(1) -- 是否受限科目
    ,pomdtg varchar2(1) -- 是否允许透支(1允许0不允许)
    ,mntytg varchar2(1) -- 货币性项目标志(0货币性项目1一般非货币性项目2公允价值计量的非货币性项目)
    ,inactp varchar2(1) -- 建账类型(1总部管理2分行（市县联社）管理5支行（分社）管理)
    ,brchtg varchar2(1) -- 部门辅助设置
    ,prcdtg varchar2(1) -- 产品辅助设置
    ,bulntg varchar2(1) -- 业务条线辅助设置
    ,custtg varchar2(1) -- 往来单位辅助设置
    ,emlytg varchar2(1) -- 职员辅助设置
    ,accttg varchar2(1) -- 账户辅助设置
    ,itemcl varchar2(5) -- 科目归属（d：存款账l：贷款账i：内部账a：考核账）
    ,ioflag varchar2(1) -- 表内外标志（i表内o表外）
    ,hdopmd varchar2(1) -- 手工开户受理模式（0：不允许通用记账1：总行代开2：分行代开3：自行开立）
    ,begndt varchar2(8) -- 科目生效日期
    ,overdt varchar2(8) -- 科目失效日期
    ,usesys varchar2(100) -- 科目使用系统
    ,happen varchar2(100) -- 科目发生额方向
    ,sepatg varchar2(1) -- 是否价税分离（0：不涉及，1：是，2：否）
    ,warning varchar2(1) -- 是否科目余额浮动预警（0：否，1：是）
    ,counbe varchar2(8) -- 柜面手工记账开始日期
    ,counov varchar2(8) -- 柜面手工记账结束日期
    ,checkbe varchar2(8) -- 核算中台手工记账开始日期
    ,checkov varchar2(8) -- 核算中台手工记账结束日期
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
grant select on ${iol_schema}.tgls_com_item to ${iml_schema};
grant select on ${iol_schema}.tgls_com_item to ${icl_schema};
grant select on ${iol_schema}.tgls_com_item to ${idl_schema};
grant select on ${iol_schema}.tgls_com_item to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_com_item is '科目';
comment on column ${iol_schema}.tgls_com_item.stacid is '账套标记';
comment on column ${iol_schema}.tgls_com_item.itemcd is '科目编号';
comment on column ${iol_schema}.tgls_com_item.sprrcd is '上级科目编号';
comment on column ${iol_schema}.tgls_com_item.itemna is '科目名称';
comment on column ${iol_schema}.tgls_com_item.itemlv is '科目级别';
comment on column ${iol_schema}.tgls_com_item.cutrna is '备用名称';
comment on column ${iol_schema}.tgls_com_item.itemtp is '科目类型(1资产类2负债类3所有者权益类4系统往来类5损益类6表外,7备忘)';
comment on column ${iol_schema}.tgls_com_item.itempr is '科目属性0汇总科目2多账户科目3无分户科目';
comment on column ${iol_schema}.tgls_com_item.detltg is '是否末级(0非末级科目1末级科目)';
comment on column ${iol_schema}.tgls_com_item.itemdn is '科目余额方向(d,c,r.p.b)';
comment on column ${iol_schema}.tgls_com_item.usedtp is '是否已使用(1:已使用,0:未使用,9:停用)';
comment on column ${iol_schema}.tgls_com_item.measut is '计量单位';
comment on column ${iol_schema}.tgls_com_item.confin is '是否受限科目';
comment on column ${iol_schema}.tgls_com_item.pomdtg is '是否允许透支(1允许0不允许)';
comment on column ${iol_schema}.tgls_com_item.mntytg is '货币性项目标志(0货币性项目1一般非货币性项目2公允价值计量的非货币性项目)';
comment on column ${iol_schema}.tgls_com_item.inactp is '建账类型(1总部管理2分行（市县联社）管理5支行（分社）管理)';
comment on column ${iol_schema}.tgls_com_item.brchtg is '部门辅助设置';
comment on column ${iol_schema}.tgls_com_item.prcdtg is '产品辅助设置';
comment on column ${iol_schema}.tgls_com_item.bulntg is '业务条线辅助设置';
comment on column ${iol_schema}.tgls_com_item.custtg is '往来单位辅助设置';
comment on column ${iol_schema}.tgls_com_item.emlytg is '职员辅助设置';
comment on column ${iol_schema}.tgls_com_item.accttg is '账户辅助设置';
comment on column ${iol_schema}.tgls_com_item.itemcl is '科目归属（d：存款账l：贷款账i：内部账a：考核账）';
comment on column ${iol_schema}.tgls_com_item.ioflag is '表内外标志（i表内o表外）';
comment on column ${iol_schema}.tgls_com_item.hdopmd is '手工开户受理模式（0：不允许通用记账1：总行代开2：分行代开3：自行开立）';
comment on column ${iol_schema}.tgls_com_item.begndt is '科目生效日期';
comment on column ${iol_schema}.tgls_com_item.overdt is '科目失效日期';
comment on column ${iol_schema}.tgls_com_item.usesys is '科目使用系统';
comment on column ${iol_schema}.tgls_com_item.happen is '科目发生额方向';
comment on column ${iol_schema}.tgls_com_item.sepatg is '是否价税分离（0：不涉及，1：是，2：否）';
comment on column ${iol_schema}.tgls_com_item.warning is '是否科目余额浮动预警（0：否，1：是）';
comment on column ${iol_schema}.tgls_com_item.counbe is '柜面手工记账开始日期';
comment on column ${iol_schema}.tgls_com_item.counov is '柜面手工记账结束日期';
comment on column ${iol_schema}.tgls_com_item.checkbe is '核算中台手工记账开始日期';
comment on column ${iol_schema}.tgls_com_item.checkov is '核算中台手工记账结束日期';
comment on column ${iol_schema}.tgls_com_item.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_com_item.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_com_item.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_com_item.etl_timestamp is 'ETL处理时间戳';
