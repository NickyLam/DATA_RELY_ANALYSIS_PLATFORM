/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_bd_supplier
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_bd_supplier
whenever sqlerror continue none;
drop table ${iol_schema}.iers_bd_supplier purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_bd_supplier(
    buslicensenum varchar2(300) -- 营业执照号码
    ,code varchar2(60) -- 供应商编码
    ,corcustomer varchar2(30) -- 对应客户
    ,corpaddress varchar2(30) -- 企业地址
    ,creationtime varchar2(29) -- 创建时间
    ,creator varchar2(30) -- 创建人
    ,dataoriginflag number(38,0) -- 分布式
    ,def1 varchar2(1500) -- 自定义项1
    ,def10 varchar2(152) -- 自定义项10
    ,def11 varchar2(152) -- 自定义项11
    ,def12 varchar2(152) -- 自定义项12
    ,def13 varchar2(152) -- 自定义项13
    ,def14 varchar2(152) -- 自定义项14
    ,def15 varchar2(152) -- 自定义项15
    ,def16 varchar2(152) -- 自定义项16
    ,def17 varchar2(152) -- 自定义项17
    ,def18 varchar2(152) -- 自定义项18
    ,def19 varchar2(152) -- 自定义项19
    ,def2 varchar2(152) -- 自定义项2
    ,def20 varchar2(152) -- 自定义项20
    ,def21 varchar2(152) -- 自定义项21
    ,def22 varchar2(152) -- 自定义项22
    ,def23 varchar2(152) -- 自定义项23
    ,def24 varchar2(152) -- 自定义项24
    ,def25 varchar2(152) -- 自定义项25
    ,def26 varchar2(152) -- 自定义项26
    ,def27 varchar2(152) -- 自定义项27
    ,def28 varchar2(152) -- 自定义项28
    ,def29 varchar2(152) -- 自定义项29
    ,def3 varchar2(152) -- 自定义项3
    ,def30 varchar2(152) -- 自定义项30
    ,def4 varchar2(152) -- 自定义项4
    ,def5 varchar2(152) -- 自定义项5
    ,def6 varchar2(152) -- 自定义项6
    ,def7 varchar2(152) -- 自定义项7
    ,def8 varchar2(152) -- 自定义项8
    ,def9 varchar2(152) -- 自定义项9
    ,deletestate number(38,0) -- 删除状态
    ,delperson varchar2(30) -- 删除人
    ,deltime varchar2(29) -- 删除时间
    ,dr number(10,0) -- 删除标志
    ,ecotypesincevfive varchar2(30) -- 经济类型
    ,email varchar2(75) -- e-mail地址
    ,enablestate number(38,0) -- 启用状态
    ,ename varchar2(300) -- 供应商英文名称
    ,establishdate varchar2(29) -- 成立日期
    ,fax1 varchar2(75) -- 传真1
    ,fax2 varchar2(75) -- 传真2
    ,iscarrier varchar2(2) -- 承运商
    ,iscustomer varchar2(2) -- 客户
    ,isfreecust varchar2(2) -- 散户
    ,ismobilecoopertive varchar2(2) -- 移动协同
    ,isoutcheck varchar2(2) -- 外部检测机构
    ,isvat varchar2(2) -- vat注册码
    ,legalbody varchar2(300) -- 法人
    ,memo varchar2(2304) -- 备注
    ,mnecode varchar2(75) -- 助记码
    ,modifiedtime varchar2(29) -- 最后修改时间
    ,modifier varchar2(30) -- 最后修改人
    ,name varchar2(450) -- 供应商名称
    ,name2 varchar2(450) -- 供应商名称2
    ,name3 varchar2(450) -- 供应商名称3
    ,name4 varchar2(450) -- 供应商名称4
    ,name5 varchar2(450) -- 供应商名称5
    ,name6 varchar2(450) -- 供应商名称6
    ,pk_areacl varchar2(30) -- 地区分类
    ,pk_billtypecode varchar2(30) -- 单据类型
    ,pk_country varchar2(30) -- 国家/地区
    ,pk_currtype varchar2(30) -- 注册资金币种
    ,pk_financeorg varchar2(30) -- 对应业务单元
    ,pk_format varchar2(30) -- 数据格式
    ,pk_group varchar2(30) -- 所属集团
    ,pk_oldsupplier varchar2(30) -- 供应商旧主键
    ,pk_org varchar2(30) -- 所属组织
    ,pk_supplier varchar2(30) -- 供应商档案主键
    ,pk_supplier_main varchar2(30) -- 上级供应商
    ,pk_supplier_pf varchar2(30) -- 供应商申请单主键
    ,pk_supplierclass varchar2(30) -- 供应商基本分类
    ,pk_suptaxes varchar2(30) -- 供应商税类
    ,pk_timezone varchar2(30) -- 时区
    ,registerfund number(14,2) -- 注册资金
    ,shortname varchar2(450) -- 供应商简称
    ,supprop number(38,0) -- 供应商类型
    ,supstate number(38,0) -- 供应商状态
    ,taxpayerid varchar2(30) -- 纳税人登记号
    ,tel1 varchar2(75) -- 电话1
    ,tel2 varchar2(75) -- 电话2
    ,tel3 varchar2(75) -- 电话3
    ,trade varchar2(30) -- 所属行业
    ,ts varchar2(29) -- 时间戳
    ,url varchar2(90) -- web网址
    ,vatcode varchar2(75) -- 对应vat注册码
    ,zipcode varchar2(9) -- 邮政编码
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
grant select on ${iol_schema}.iers_bd_supplier to ${iml_schema};
grant select on ${iol_schema}.iers_bd_supplier to ${icl_schema};
grant select on ${iol_schema}.iers_bd_supplier to ${idl_schema};
grant select on ${iol_schema}.iers_bd_supplier to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_bd_supplier is '供应商主表';
comment on column ${iol_schema}.iers_bd_supplier.buslicensenum is '营业执照号码';
comment on column ${iol_schema}.iers_bd_supplier.code is '供应商编码';
comment on column ${iol_schema}.iers_bd_supplier.corcustomer is '对应客户';
comment on column ${iol_schema}.iers_bd_supplier.corpaddress is '企业地址';
comment on column ${iol_schema}.iers_bd_supplier.creationtime is '创建时间';
comment on column ${iol_schema}.iers_bd_supplier.creator is '创建人';
comment on column ${iol_schema}.iers_bd_supplier.dataoriginflag is '分布式';
comment on column ${iol_schema}.iers_bd_supplier.def1 is '自定义项1';
comment on column ${iol_schema}.iers_bd_supplier.def10 is '自定义项10';
comment on column ${iol_schema}.iers_bd_supplier.def11 is '自定义项11';
comment on column ${iol_schema}.iers_bd_supplier.def12 is '自定义项12';
comment on column ${iol_schema}.iers_bd_supplier.def13 is '自定义项13';
comment on column ${iol_schema}.iers_bd_supplier.def14 is '自定义项14';
comment on column ${iol_schema}.iers_bd_supplier.def15 is '自定义项15';
comment on column ${iol_schema}.iers_bd_supplier.def16 is '自定义项16';
comment on column ${iol_schema}.iers_bd_supplier.def17 is '自定义项17';
comment on column ${iol_schema}.iers_bd_supplier.def18 is '自定义项18';
comment on column ${iol_schema}.iers_bd_supplier.def19 is '自定义项19';
comment on column ${iol_schema}.iers_bd_supplier.def2 is '自定义项2';
comment on column ${iol_schema}.iers_bd_supplier.def20 is '自定义项20';
comment on column ${iol_schema}.iers_bd_supplier.def21 is '自定义项21';
comment on column ${iol_schema}.iers_bd_supplier.def22 is '自定义项22';
comment on column ${iol_schema}.iers_bd_supplier.def23 is '自定义项23';
comment on column ${iol_schema}.iers_bd_supplier.def24 is '自定义项24';
comment on column ${iol_schema}.iers_bd_supplier.def25 is '自定义项25';
comment on column ${iol_schema}.iers_bd_supplier.def26 is '自定义项26';
comment on column ${iol_schema}.iers_bd_supplier.def27 is '自定义项27';
comment on column ${iol_schema}.iers_bd_supplier.def28 is '自定义项28';
comment on column ${iol_schema}.iers_bd_supplier.def29 is '自定义项29';
comment on column ${iol_schema}.iers_bd_supplier.def3 is '自定义项3';
comment on column ${iol_schema}.iers_bd_supplier.def30 is '自定义项30';
comment on column ${iol_schema}.iers_bd_supplier.def4 is '自定义项4';
comment on column ${iol_schema}.iers_bd_supplier.def5 is '自定义项5';
comment on column ${iol_schema}.iers_bd_supplier.def6 is '自定义项6';
comment on column ${iol_schema}.iers_bd_supplier.def7 is '自定义项7';
comment on column ${iol_schema}.iers_bd_supplier.def8 is '自定义项8';
comment on column ${iol_schema}.iers_bd_supplier.def9 is '自定义项9';
comment on column ${iol_schema}.iers_bd_supplier.deletestate is '删除状态';
comment on column ${iol_schema}.iers_bd_supplier.delperson is '删除人';
comment on column ${iol_schema}.iers_bd_supplier.deltime is '删除时间';
comment on column ${iol_schema}.iers_bd_supplier.dr is '删除标志';
comment on column ${iol_schema}.iers_bd_supplier.ecotypesincevfive is '经济类型';
comment on column ${iol_schema}.iers_bd_supplier.email is 'e-mail地址';
comment on column ${iol_schema}.iers_bd_supplier.enablestate is '启用状态';
comment on column ${iol_schema}.iers_bd_supplier.ename is '供应商英文名称';
comment on column ${iol_schema}.iers_bd_supplier.establishdate is '成立日期';
comment on column ${iol_schema}.iers_bd_supplier.fax1 is '传真1';
comment on column ${iol_schema}.iers_bd_supplier.fax2 is '传真2';
comment on column ${iol_schema}.iers_bd_supplier.iscarrier is '承运商';
comment on column ${iol_schema}.iers_bd_supplier.iscustomer is '客户';
comment on column ${iol_schema}.iers_bd_supplier.isfreecust is '散户';
comment on column ${iol_schema}.iers_bd_supplier.ismobilecoopertive is '移动协同';
comment on column ${iol_schema}.iers_bd_supplier.isoutcheck is '外部检测机构';
comment on column ${iol_schema}.iers_bd_supplier.isvat is 'vat注册码';
comment on column ${iol_schema}.iers_bd_supplier.legalbody is '法人';
comment on column ${iol_schema}.iers_bd_supplier.memo is '备注';
comment on column ${iol_schema}.iers_bd_supplier.mnecode is '助记码';
comment on column ${iol_schema}.iers_bd_supplier.modifiedtime is '最后修改时间';
comment on column ${iol_schema}.iers_bd_supplier.modifier is '最后修改人';
comment on column ${iol_schema}.iers_bd_supplier.name is '供应商名称';
comment on column ${iol_schema}.iers_bd_supplier.name2 is '供应商名称2';
comment on column ${iol_schema}.iers_bd_supplier.name3 is '供应商名称3';
comment on column ${iol_schema}.iers_bd_supplier.name4 is '供应商名称4';
comment on column ${iol_schema}.iers_bd_supplier.name5 is '供应商名称5';
comment on column ${iol_schema}.iers_bd_supplier.name6 is '供应商名称6';
comment on column ${iol_schema}.iers_bd_supplier.pk_areacl is '地区分类';
comment on column ${iol_schema}.iers_bd_supplier.pk_billtypecode is '单据类型';
comment on column ${iol_schema}.iers_bd_supplier.pk_country is '国家/地区';
comment on column ${iol_schema}.iers_bd_supplier.pk_currtype is '注册资金币种';
comment on column ${iol_schema}.iers_bd_supplier.pk_financeorg is '对应业务单元';
comment on column ${iol_schema}.iers_bd_supplier.pk_format is '数据格式';
comment on column ${iol_schema}.iers_bd_supplier.pk_group is '所属集团';
comment on column ${iol_schema}.iers_bd_supplier.pk_oldsupplier is '供应商旧主键';
comment on column ${iol_schema}.iers_bd_supplier.pk_org is '所属组织';
comment on column ${iol_schema}.iers_bd_supplier.pk_supplier is '供应商档案主键';
comment on column ${iol_schema}.iers_bd_supplier.pk_supplier_main is '上级供应商';
comment on column ${iol_schema}.iers_bd_supplier.pk_supplier_pf is '供应商申请单主键';
comment on column ${iol_schema}.iers_bd_supplier.pk_supplierclass is '供应商基本分类';
comment on column ${iol_schema}.iers_bd_supplier.pk_suptaxes is '供应商税类';
comment on column ${iol_schema}.iers_bd_supplier.pk_timezone is '时区';
comment on column ${iol_schema}.iers_bd_supplier.registerfund is '注册资金';
comment on column ${iol_schema}.iers_bd_supplier.shortname is '供应商简称';
comment on column ${iol_schema}.iers_bd_supplier.supprop is '供应商类型';
comment on column ${iol_schema}.iers_bd_supplier.supstate is '供应商状态';
comment on column ${iol_schema}.iers_bd_supplier.taxpayerid is '纳税人登记号';
comment on column ${iol_schema}.iers_bd_supplier.tel1 is '电话1';
comment on column ${iol_schema}.iers_bd_supplier.tel2 is '电话2';
comment on column ${iol_schema}.iers_bd_supplier.tel3 is '电话3';
comment on column ${iol_schema}.iers_bd_supplier.trade is '所属行业';
comment on column ${iol_schema}.iers_bd_supplier.ts is '时间戳';
comment on column ${iol_schema}.iers_bd_supplier.url is 'web网址';
comment on column ${iol_schema}.iers_bd_supplier.vatcode is '对应vat注册码';
comment on column ${iol_schema}.iers_bd_supplier.zipcode is '邮政编码';
comment on column ${iol_schema}.iers_bd_supplier.start_dt is '开始时间';
comment on column ${iol_schema}.iers_bd_supplier.end_dt is '结束时间';
comment on column ${iol_schema}.iers_bd_supplier.id_mark is '增删标志';
comment on column ${iol_schema}.iers_bd_supplier.etl_timestamp is 'ETL处理时间戳';
