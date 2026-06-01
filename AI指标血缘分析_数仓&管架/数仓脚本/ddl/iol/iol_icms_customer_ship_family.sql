/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_ship_family
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_ship_family
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_ship_family purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_ship_family(
    serialno varchar2(64) -- 流水号
    ,updateorgid varchar2(64) -- 更新机构
    ,birthday varchar2(10) -- 出生日期
    ,workaddress varchar2(400) -- 公司地址
    ,corporgid varchar2(64) -- 法人机构编号
    ,inputorgid varchar2(64) -- 登记机构
    ,areacode varchar2(10) -- 区号
    ,remark varchar2(1000) -- 备注
    ,customerid varchar2(16) -- 客户编号
    ,relationship varchar2(36) -- 家族关系
    ,worktel varchar2(64) -- 家庭成员所在单位电话
    ,maincustomerid varchar2(64) -- 主客户号
    ,updateuserid varchar2(64) -- 更新人
    ,customername varchar2(100) -- 家族成员姓名
    ,address varchar2(400) -- 地址
    ,eduexperience varchar2(18) -- 最高学历
    ,monthincome number(22,2) -- 月收入
    ,certid varchar2(60) -- 证件号码
    ,countryzone varchar2(10) -- 联系人座机
    ,indtel varchar2(64) -- 联系电话
    ,certtype varchar2(4) -- 证件类型
    ,inputuserid varchar2(64) -- 登记人
    ,workstartdate date -- 参加工作年份
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,entloancardno varchar2(64) -- 家族成员所在企业贷款卡编号
    ,entname varchar2(160) -- 家族成员所在企业名称
    ,unitcountry varchar2(64) -- 单位所在地编码
    ,unitcountryname varchar2(64) -- 所在地名称
    ,migtoldvalue varchar2(250) -- 备份原字段值
    ,certstartdate date -- 
    ,certduedate date -- 
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
grant select on ${iol_schema}.icms_customer_ship_family to ${iml_schema};
grant select on ${iol_schema}.icms_customer_ship_family to ${icl_schema};
grant select on ${iol_schema}.icms_customer_ship_family to ${idl_schema};
grant select on ${iol_schema}.icms_customer_ship_family to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_ship_family is '客户家族信息';
comment on column ${iol_schema}.icms_customer_ship_family.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_ship_family.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_ship_family.birthday is '出生日期';
comment on column ${iol_schema}.icms_customer_ship_family.workaddress is '公司地址';
comment on column ${iol_schema}.icms_customer_ship_family.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_ship_family.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_ship_family.areacode is '区号';
comment on column ${iol_schema}.icms_customer_ship_family.remark is '备注';
comment on column ${iol_schema}.icms_customer_ship_family.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_ship_family.relationship is '家族关系';
comment on column ${iol_schema}.icms_customer_ship_family.worktel is '家庭成员所在单位电话';
comment on column ${iol_schema}.icms_customer_ship_family.maincustomerid is '主客户号';
comment on column ${iol_schema}.icms_customer_ship_family.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_ship_family.customername is '家族成员姓名';
comment on column ${iol_schema}.icms_customer_ship_family.address is '地址';
comment on column ${iol_schema}.icms_customer_ship_family.eduexperience is '最高学历';
comment on column ${iol_schema}.icms_customer_ship_family.monthincome is '月收入';
comment on column ${iol_schema}.icms_customer_ship_family.certid is '证件号码';
comment on column ${iol_schema}.icms_customer_ship_family.countryzone is '联系人座机';
comment on column ${iol_schema}.icms_customer_ship_family.indtel is '联系电话';
comment on column ${iol_schema}.icms_customer_ship_family.certtype is '证件类型';
comment on column ${iol_schema}.icms_customer_ship_family.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_ship_family.workstartdate is '参加工作年份';
comment on column ${iol_schema}.icms_customer_ship_family.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_ship_family.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_ship_family.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_ship_family.entloancardno is '家族成员所在企业贷款卡编号';
comment on column ${iol_schema}.icms_customer_ship_family.entname is '家族成员所在企业名称';
comment on column ${iol_schema}.icms_customer_ship_family.unitcountry is '单位所在地编码';
comment on column ${iol_schema}.icms_customer_ship_family.unitcountryname is '所在地名称';
comment on column ${iol_schema}.icms_customer_ship_family.migtoldvalue is '备份原字段值';
comment on column ${iol_schema}.icms_customer_ship_family.certstartdate is '';
comment on column ${iol_schema}.icms_customer_ship_family.certduedate is '';
comment on column ${iol_schema}.icms_customer_ship_family.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_ship_family.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_ship_family.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_ship_family.etl_timestamp is 'ETL处理时间戳';
