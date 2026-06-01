/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_ind_tax
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_ind_tax
whenever sqlerror continue none;
drop table ${iol_schema}.icms_ind_tax purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ind_tax(
    serialno varchar2(64) -- 流水号
    ,taxcurrency varchar2(3) -- 纳税币种纳税币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)
    ,begindate date -- 区间开始日期
    ,remark varchar2(1000) -- 备注
    ,inputorgid varchar2(64) -- 登记机构
    ,uptodate date -- 统计截止日期
    ,taxsum number(24,6) -- 纳税金额
    ,inputuserid varchar2(64) -- 登记人
    ,customerid varchar2(16) -- 客户编号
    ,taxtype varchar2(36) -- 税种税种(代码:1-个人所得税2-印花3-房产4-营业5-车辆所得税6-车船所得税7-土地增值税8-城镇土地使用税9-农业税10-耕地占用税11-契税12-其他)
    ,updateuserid varchar2(64) -- 更新人
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,enddate date -- 区间结束日期
    ,updateorgid varchar2(64) -- 更新机构
    ,taxdate date -- 纳税日期
    ,corporgid varchar2(64) -- 法人机构编号
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
grant select on ${iol_schema}.icms_ind_tax to ${iml_schema};
grant select on ${iol_schema}.icms_ind_tax to ${icl_schema};
grant select on ${iol_schema}.icms_ind_tax to ${idl_schema};
grant select on ${iol_schema}.icms_ind_tax to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_ind_tax is '纳税信息纳税信息';
comment on column ${iol_schema}.icms_ind_tax.serialno is '流水号';
comment on column ${iol_schema}.icms_ind_tax.taxcurrency is '纳税币种纳税币种(代码：1-人民币2-英镑3-港币4-美元5-日元6-欧元)';
comment on column ${iol_schema}.icms_ind_tax.begindate is '区间开始日期';
comment on column ${iol_schema}.icms_ind_tax.remark is '备注';
comment on column ${iol_schema}.icms_ind_tax.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_ind_tax.uptodate is '统计截止日期';
comment on column ${iol_schema}.icms_ind_tax.taxsum is '纳税金额';
comment on column ${iol_schema}.icms_ind_tax.inputuserid is '登记人';
comment on column ${iol_schema}.icms_ind_tax.customerid is '客户编号';
comment on column ${iol_schema}.icms_ind_tax.taxtype is '税种税种(代码:1-个人所得税2-印花3-房产4-营业5-车辆所得税6-车船所得税7-土地增值税8-城镇土地使用税9-农业税10-耕地占用税11-契税12-其他)';
comment on column ${iol_schema}.icms_ind_tax.updateuserid is '更新人';
comment on column ${iol_schema}.icms_ind_tax.inputdate is '登记日期';
comment on column ${iol_schema}.icms_ind_tax.updatedate is '更新日期';
comment on column ${iol_schema}.icms_ind_tax.enddate is '区间结束日期';
comment on column ${iol_schema}.icms_ind_tax.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_ind_tax.taxdate is '纳税日期';
comment on column ${iol_schema}.icms_ind_tax.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_ind_tax.start_dt is '开始时间';
comment on column ${iol_schema}.icms_ind_tax.end_dt is '结束时间';
comment on column ${iol_schema}.icms_ind_tax.id_mark is '增删标志';
comment on column ${iol_schema}.icms_ind_tax.etl_timestamp is 'ETL处理时间戳';
