/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_customer_manager
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_customer_manager
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_customer_manager purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_customer_manager(
    customerid varchar2(16) -- 对公客户编号
    ,positions varchar2(6) -- 高管类型
    ,managername varchar2(200) -- 高管名称
    ,certtype varchar2(10) -- 证件类型
    ,certid varchar2(50) -- 证件号码
    ,sex varchar2(2) -- 性别
    ,birthday varchar2(10) -- 出生日期
    ,certbegindate varchar2(10) -- 证件签发日期
    ,certenddate varchar2(10) -- 证件到期日期
    ,duty varchar2(2) -- 学历
    ,telephone varchar2(20) -- 联系电话
    ,pcredit varchar2(20) -- 个人征信记录
    ,updatedate1 varchar2(30) -- 微纵企业联系人基本信息更新时间
    ,ratio varchar2(100) -- 持股比例
    ,address varchar2(800) -- 联系地址
    ,position varchar2(100) -- 职务
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 废除五级分类
    ,custid varchar2(16) -- 行内客户号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_wyd_customer_manager to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_customer_manager to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_customer_manager to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_customer_manager to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_customer_manager is '企业联系人基本信息';
comment on column ${iol_schema}.icms_wyd_customer_manager.customerid is '对公客户编号';
comment on column ${iol_schema}.icms_wyd_customer_manager.positions is '高管类型';
comment on column ${iol_schema}.icms_wyd_customer_manager.managername is '高管名称';
comment on column ${iol_schema}.icms_wyd_customer_manager.certtype is '证件类型';
comment on column ${iol_schema}.icms_wyd_customer_manager.certid is '证件号码';
comment on column ${iol_schema}.icms_wyd_customer_manager.sex is '性别';
comment on column ${iol_schema}.icms_wyd_customer_manager.birthday is '出生日期';
comment on column ${iol_schema}.icms_wyd_customer_manager.certbegindate is '证件签发日期';
comment on column ${iol_schema}.icms_wyd_customer_manager.certenddate is '证件到期日期';
comment on column ${iol_schema}.icms_wyd_customer_manager.duty is '学历';
comment on column ${iol_schema}.icms_wyd_customer_manager.telephone is '联系电话';
comment on column ${iol_schema}.icms_wyd_customer_manager.pcredit is '个人征信记录';
comment on column ${iol_schema}.icms_wyd_customer_manager.updatedate1 is '微纵企业联系人基本信息更新时间';
comment on column ${iol_schema}.icms_wyd_customer_manager.ratio is '持股比例';
comment on column ${iol_schema}.icms_wyd_customer_manager.address is '联系地址';
comment on column ${iol_schema}.icms_wyd_customer_manager.position is '职务';
comment on column ${iol_schema}.icms_wyd_customer_manager.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_customer_manager.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_customer_manager.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_customer_manager.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_customer_manager.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_customer_manager.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_customer_manager.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_customer_manager.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_customer_manager.custid is '行内客户号';
comment on column ${iol_schema}.icms_wyd_customer_manager.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_customer_manager.etl_timestamp is 'ETL处理时间戳';
