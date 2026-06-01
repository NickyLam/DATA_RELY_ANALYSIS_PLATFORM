/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_ship_executives
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_ship_executives
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_ship_executives purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_ship_executives(
    serialno varchar2(64) -- 流水号
    ,migtflag varchar2(80) -- 迁移标志：crs rcr ilc upl
    ,sharevalue number(10,6) -- 持股比例
    ,birthday date -- 出生日期
    ,resume varchar2(600) -- 工作简历
    ,corporgid varchar2(32) -- 法人机构编号
    ,certtype varchar2(4) -- 证件类型
    ,engageterm number(22) -- 相关行业从业年限
    ,holdstock varchar2(500) -- 持股情况
    ,inputorgid varchar2(32) -- 登记机构
    ,updatedate date -- 更新日期
    ,telephone varchar2(32) -- 联系电话
    ,updateuserid varchar2(32) -- 更新人
    ,familycerttype varchar2(5) -- 配偶证件类型
    ,certid varchar2(60) -- 证件号码
    ,inputuserid varchar2(32) -- 登记人
    ,updateorgid varchar2(32) -- 更新机构
    ,maincustomerid varchar2(32) -- 主客户号
    ,jobtitle varchar2(5) -- 职称
    ,officephone varchar2(20) -- 单位电话
    ,customername varchar2(100) -- 高管姓名
    ,effstatus varchar2(2) -- 有效标志
    ,familycertid varchar2(60) -- 配偶证件号码
    ,sex varchar2(18) -- 性别
    ,inputdate date -- 登记日期
    ,ntlycd varchar2(4) -- 国籍
    ,eduexperience varchar2(18) -- 学历
    ,tempstatus varchar2(1) -- 是否引入标记
    ,actualcontroller varchar2(1) -- 是否为企业实际控制人
    ,relationship varchar2(18) -- 担任职务
    ,holddate date -- 担任该职务时间
    ,executivetype varchar2(5) -- 高管类型
    ,professional varchar2(5) -- 高管职业
    ,customerid varchar2(16) -- 客户编号
    ,remark varchar2(500) -- 备注
    ,familycustname varchar2(200) -- 配偶姓名
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
grant select on ${iol_schema}.icms_customer_ship_executives to ${iml_schema};
grant select on ${iol_schema}.icms_customer_ship_executives to ${icl_schema};
grant select on ${iol_schema}.icms_customer_ship_executives to ${idl_schema};
grant select on ${iol_schema}.icms_customer_ship_executives to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_ship_executives is '客户高管信息';
comment on column ${iol_schema}.icms_customer_ship_executives.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_ship_executives.migtflag is '迁移标志：crs rcr ilc upl';
comment on column ${iol_schema}.icms_customer_ship_executives.sharevalue is '持股比例';
comment on column ${iol_schema}.icms_customer_ship_executives.birthday is '出生日期';
comment on column ${iol_schema}.icms_customer_ship_executives.resume is '工作简历';
comment on column ${iol_schema}.icms_customer_ship_executives.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_ship_executives.certtype is '证件类型';
comment on column ${iol_schema}.icms_customer_ship_executives.engageterm is '相关行业从业年限';
comment on column ${iol_schema}.icms_customer_ship_executives.holdstock is '持股情况';
comment on column ${iol_schema}.icms_customer_ship_executives.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_customer_ship_executives.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_ship_executives.telephone is '联系电话';
comment on column ${iol_schema}.icms_customer_ship_executives.updateuserid is '更新人';
comment on column ${iol_schema}.icms_customer_ship_executives.familycerttype is '配偶证件类型';
comment on column ${iol_schema}.icms_customer_ship_executives.certid is '证件号码';
comment on column ${iol_schema}.icms_customer_ship_executives.inputuserid is '登记人';
comment on column ${iol_schema}.icms_customer_ship_executives.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_customer_ship_executives.maincustomerid is '主客户号';
comment on column ${iol_schema}.icms_customer_ship_executives.jobtitle is '职称';
comment on column ${iol_schema}.icms_customer_ship_executives.officephone is '单位电话';
comment on column ${iol_schema}.icms_customer_ship_executives.customername is '高管姓名';
comment on column ${iol_schema}.icms_customer_ship_executives.effstatus is '有效标志';
comment on column ${iol_schema}.icms_customer_ship_executives.familycertid is '配偶证件号码';
comment on column ${iol_schema}.icms_customer_ship_executives.sex is '性别';
comment on column ${iol_schema}.icms_customer_ship_executives.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_ship_executives.ntlycd is '国籍';
comment on column ${iol_schema}.icms_customer_ship_executives.eduexperience is '学历';
comment on column ${iol_schema}.icms_customer_ship_executives.tempstatus is '是否引入标记';
comment on column ${iol_schema}.icms_customer_ship_executives.actualcontroller is '是否为企业实际控制人';
comment on column ${iol_schema}.icms_customer_ship_executives.relationship is '担任职务';
comment on column ${iol_schema}.icms_customer_ship_executives.holddate is '担任该职务时间';
comment on column ${iol_schema}.icms_customer_ship_executives.executivetype is '高管类型';
comment on column ${iol_schema}.icms_customer_ship_executives.professional is '高管职业';
comment on column ${iol_schema}.icms_customer_ship_executives.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_ship_executives.remark is '备注';
comment on column ${iol_schema}.icms_customer_ship_executives.familycustname is '配偶姓名';
comment on column ${iol_schema}.icms_customer_ship_executives.migtoldvalue is '备份原字段值';
comment on column ${iol_schema}.icms_customer_ship_executives.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_ship_executives.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_ship_executives.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_ship_executives.etl_timestamp is 'ETL处理时间戳';
