/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_ship_sharehold
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_ship_sharehold
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_ship_sharehold purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_ship_sharehold(
    serialno varchar2(64) -- 流水号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,corporgid varchar2(32) -- 法人机构编号
    ,investmentprop number(10,6) -- 投资比例
    ,investmentmensftype varchar2(18) -- 出资人身份类别
    ,enttype varchar2(18) -- 企业类型
    ,tempstatus varchar2(1) -- 暂存状态
    ,actualcontroller varchar2(1) -- 是否为企业实际控制人
    ,inputorgid varchar2(32) -- 登记机构
    ,maincustomerid varchar2(32) -- 主客户号
    ,customerid varchar2(30) -- 客户编号
    ,investdate date -- 总投资最迟到位日期
    ,inputdate date -- 登记日期
    ,shareholdingratio number(10,6) -- 持股比例
    ,relationship varchar2(80) -- 出资方式
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,currencytype varchar2(3) -- 投资币种
    ,investlastdate date -- 出资最迟到位日期
    ,customertype varchar2(18) -- 股东类型
    ,investmentsum number(24,6) -- 实缴金额
    ,certid varchar2(60) -- 股东证件号码
    ,societyinstitutioncode varchar2(18) -- 社会信用代码
    ,commercialregno varchar2(18) -- 商事与非商事登记证号
    ,inputuserid varchar2(32) -- 登记人
    ,creditinstitutioncode varchar2(18) -- 机构信用代码
    ,fictitiousperson varchar2(200) -- 法人代表名称
    ,updatedate date -- 更新日期
    ,investmentype varchar2(18) -- 出资人类型
    ,effstatus varchar2(1) -- 有效标志
    ,countryorregion varchar2(3) -- 所在国家或地区
    ,customername varchar2(200) -- 股东姓名
    ,oughtsum number(24,6) -- 投资金额
    ,holdstartdate date -- 开始持股时间
    ,certtype varchar2(4) -- 股东证件类型
    ,loancardno varchar2(32) -- 股权证号
    ,remark varchar2(500) -- 备注
    ,migtoldvalue varchar2(250) -- 备份原字段值
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
grant select on ${iol_schema}.icms_customer_ship_sharehold to ${iml_schema};
grant select on ${iol_schema}.icms_customer_ship_sharehold to ${icl_schema};
grant select on ${iol_schema}.icms_customer_ship_sharehold to ${idl_schema};
grant select on ${iol_schema}.icms_customer_ship_sharehold to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_ship_sharehold is '客户股东信息';
comment on column ${iol_schema}.icms_customer_ship_sharehold.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_ship_sharehold.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_ship_sharehold.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_ship_sharehold.investmentprop is '投资比例';
comment on column ${iol_schema}.icms_customer_ship_sharehold.investmentmensftype is '出资人身份类别';
comment on column ${iol_schema}.icms_customer_ship_sharehold.enttype is '企业类型';
comment on column ${iol_schema}.icms_customer_ship_sharehold.tempstatus is '暂存状态';
comment on column ${iol_schema}.icms_customer_ship_sharehold.actualcontroller is '是否为企业实际控制人';
comment on column ${iol_schema}.icms_customer_ship_sharehold.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_ship_sharehold.maincustomerid is '主客户号';
comment on column ${iol_schema}.icms_customer_ship_sharehold.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_ship_sharehold.investdate is '总投资最迟到位日期';
comment on column ${iol_schema}.icms_customer_ship_sharehold.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_ship_sharehold.shareholdingratio is '持股比例';
comment on column ${iol_schema}.icms_customer_ship_sharehold.relationship is '出资方式';
comment on column ${iol_schema}.icms_customer_ship_sharehold.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_ship_sharehold.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_ship_sharehold.currencytype is '投资币种';
comment on column ${iol_schema}.icms_customer_ship_sharehold.investlastdate is '出资最迟到位日期';
comment on column ${iol_schema}.icms_customer_ship_sharehold.customertype is '股东类型';
comment on column ${iol_schema}.icms_customer_ship_sharehold.investmentsum is '实缴金额';
comment on column ${iol_schema}.icms_customer_ship_sharehold.certid is '股东证件号码';
comment on column ${iol_schema}.icms_customer_ship_sharehold.societyinstitutioncode is '社会信用代码';
comment on column ${iol_schema}.icms_customer_ship_sharehold.commercialregno is '商事与非商事登记证号';
comment on column ${iol_schema}.icms_customer_ship_sharehold.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_ship_sharehold.creditinstitutioncode is '机构信用代码';
comment on column ${iol_schema}.icms_customer_ship_sharehold.fictitiousperson is '法人代表名称';
comment on column ${iol_schema}.icms_customer_ship_sharehold.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_ship_sharehold.investmentype is '出资人类型';
comment on column ${iol_schema}.icms_customer_ship_sharehold.effstatus is '有效标志';
comment on column ${iol_schema}.icms_customer_ship_sharehold.countryorregion is '所在国家或地区';
comment on column ${iol_schema}.icms_customer_ship_sharehold.customername is '股东姓名';
comment on column ${iol_schema}.icms_customer_ship_sharehold.oughtsum is '投资金额';
comment on column ${iol_schema}.icms_customer_ship_sharehold.holdstartdate is '开始持股时间';
comment on column ${iol_schema}.icms_customer_ship_sharehold.certtype is '股东证件类型';
comment on column ${iol_schema}.icms_customer_ship_sharehold.loancardno is '股权证号';
comment on column ${iol_schema}.icms_customer_ship_sharehold.remark is '备注';
comment on column ${iol_schema}.icms_customer_ship_sharehold.migtoldvalue is '备份原字段值';
comment on column ${iol_schema}.icms_customer_ship_sharehold.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_ship_sharehold.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_ship_sharehold.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_ship_sharehold.etl_timestamp is 'ETL处理时间戳';
