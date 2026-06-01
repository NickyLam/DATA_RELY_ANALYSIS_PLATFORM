/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_realty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_realty
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_realty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_realty(
    serialno varchar2(64) -- 流水号
    ,mortgage varchar2(36) -- 房产抵押情况房产抵押情况（代码：1-有抵押2-无抵押）
    ,corporgid varchar2(64) -- 法人机构编号
    ,realtyarea number(22) -- 房屋面积房屋面积（单位：平方米）
    ,customerid varchar2(16) -- 客户编号
    ,realtyadd varchar2(1000) -- 房屋地址
    ,updateorgid varchar2(64) -- 更新机构
    ,realtyname varchar2(160) -- 房屋名称
    ,shareprop number(24,8) -- 所占份额所占份额（后缀：%）
    ,purchasedate date -- 买入日期
    ,certificateno varchar2(64) -- 产权证号
    ,saledate date -- 卖出日期
    ,inputorgid varchar2(64) -- 登记机构
    ,remark varchar2(1000) -- 备注
    ,realtynature varchar2(36) -- 房屋性质房屋性质（代码：1-自购商品房2-自建房3-单位福利房4-其他）
    ,evaluateprice number(24,6) -- 评估价格评估价格（单位：元）
    ,buildprice number(24,6) -- 建构价格建构价格（单位：元）
    ,inputdate date -- 登记日期
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,uptodate date -- 统计截止日期
    ,inputuserid varchar2(64) -- 登记人
    ,updatedate date -- 更新日期
    ,updateuserid varchar2(64) -- 更新人
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
grant select on ${iol_schema}.icms_ind_realty to ${iml_schema};
grant select on ${iol_schema}.icms_ind_realty to ${icl_schema};
grant select on ${iol_schema}.icms_ind_realty to ${idl_schema};
grant select on ${iol_schema}.icms_ind_realty to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_realty is '房屋资产房屋资产情况';
comment on column ${iol_schema}.icms_ind_realty.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_realty.mortgage is '房产抵押情况房产抵押情况（代码：1-有抵押2-无抵押）';
comment on column ${iol_schema}.icms_ind_realty.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_realty.realtyarea is '房屋面积房屋面积（单位：平方米）';
comment on column ${iol_schema}.icms_ind_realty.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_realty.realtyadd is '房屋地址';
comment on column ${iol_schema}.icms_ind_realty.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_realty.realtyname is '房屋名称';
comment on column ${iol_schema}.icms_ind_realty.shareprop is '所占份额所占份额（后缀：%）';
comment on column ${iol_schema}.icms_ind_realty.purchasedate is '买入日期';
comment on column ${iol_schema}.icms_ind_realty.certificateno is '产权证号';
comment on column ${iol_schema}.icms_ind_realty.saledate is '卖出日期';
comment on column ${iol_schema}.icms_ind_realty.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_realty.remark is '备注';
comment on column ${iol_schema}.icms_ind_realty.realtynature is '房屋性质房屋性质（代码：1-自购商品房2-自建房3-单位福利房4-其他）';
comment on column ${iol_schema}.icms_ind_realty.evaluateprice is '评估价格评估价格（单位：元）';
comment on column ${iol_schema}.icms_ind_realty.buildprice is '建构价格建构价格（单位：元）';
comment on column ${iol_schema}.icms_ind_realty.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_realty.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_ind_realty.uptodate is '统计截止日期';
comment on column ${iol_schema}.icms_ind_realty.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_realty.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_realty.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_realty.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_realty.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_realty.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_realty.etl_timestamp is 'ETL处理时间戳';
