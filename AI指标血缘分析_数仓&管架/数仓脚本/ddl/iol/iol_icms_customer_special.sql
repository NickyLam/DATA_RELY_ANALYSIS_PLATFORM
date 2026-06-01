/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_special
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_special
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_special purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_special(
    serialno varchar2(32) -- 流水号
    ,email varchar2(400) -- 邮箱
    ,controltype varchar2(18) -- 控制方式
    ,inputdate date -- 登记日期
    ,certtype varchar2(18) -- 证件类型
    ,nationcode varchar2(3) -- 证件国别
    ,companytel varchar2(32) -- 单位电话
    ,relationship varchar2(80) -- 关系
    ,shareratio number(24,8) -- 持有本行股份占比
    ,inputuserid varchar2(32) -- 登记人编号
    ,customername varchar2(200) -- 客户名称
    ,remark varchar2(1000) -- 备注
    ,updatedate date -- 更新日期
    ,source varchar2(200) -- 来源描述
    ,content varchar2(500) -- 黑名单内容
    ,begindate date -- 开始日期
    ,listingplace varchar2(18) -- 上市地点
    ,jobtitle varchar2(18) -- 职称
    ,platformlevel varchar2(2) -- 平台等级
    ,birthday date -- 出生日期
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,relativecustname varchar2(80) -- 关联客户名称
    ,educationdegree varchar2(18) -- 最高学位
    ,certid varchar2(60) -- 证件号码
    ,enddate date -- 结束时间
    ,updateuserid varchar2(32) -- 更新人编号
    ,inputtype varchar2(10) -- 入库类型
    ,corporgid varchar2(32) -- 法人机构编号
    ,specialcustomersubtype varchar2(36) -- 名单类别-子类
    ,sex varchar2(6) -- 性别
    ,inliststatus varchar2(1) -- 是否有效
    ,relativecustid varchar2(32) -- 关联客户编号
    ,shares number(22) -- 持有本行股份数
    ,inputorgid varchar2(12) -- 登记机构编号
    ,actualassert number(24,6) -- 实缴资本
    ,updateorgid varchar2(32) -- 更新机构编号
    ,approvestatus varchar2(32) -- 审批状态
    ,provider varchar2(6) -- 名单来源
    ,specialcustomertype varchar2(30) -- 名单类别
    ,inlistreason varchar2(400) -- 列入原因
    ,industrytype varchar2(5) -- 国际行业分类国际行业分类型
    ,reason varchar2(200) -- 入库原因
    ,customerid varchar2(16) -- 客户编号
    ,mobiletel varchar2(32) -- 手机号码
    ,addapprovestatus varchar2(32) -- 
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
grant select on ${iol_schema}.icms_customer_special to ${iml_schema};
grant select on ${iol_schema}.icms_customer_special to ${icl_schema};
grant select on ${iol_schema}.icms_customer_special to ${idl_schema};
grant select on ${iol_schema}.icms_customer_special to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_special is '特定客户名单表特定客户名单表';
comment on column ${iol_schema}.icms_customer_special.serialno is '流水号';
comment on column ${iol_schema}.icms_customer_special.email is '邮箱';
comment on column ${iol_schema}.icms_customer_special.controltype is '控制方式';
comment on column ${iol_schema}.icms_customer_special.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_special.certtype is '证件类型';
comment on column ${iol_schema}.icms_customer_special.nationcode is '证件国别';
comment on column ${iol_schema}.icms_customer_special.companytel is '单位电话';
comment on column ${iol_schema}.icms_customer_special.relationship is '关系';
comment on column ${iol_schema}.icms_customer_special.shareratio is '持有本行股份占比';
comment on column ${iol_schema}.icms_customer_special.inputuserid is '登记人编号';
comment on column ${iol_schema}.icms_customer_special.customername is '客户名称';
comment on column ${iol_schema}.icms_customer_special.remark is '备注';
comment on column ${iol_schema}.icms_customer_special.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_special.source is '来源描述';
comment on column ${iol_schema}.icms_customer_special.content is '黑名单内容';
comment on column ${iol_schema}.icms_customer_special.begindate is '开始日期';
comment on column ${iol_schema}.icms_customer_special.listingplace is '上市地点';
comment on column ${iol_schema}.icms_customer_special.jobtitle is '职称';
comment on column ${iol_schema}.icms_customer_special.platformlevel is '平台等级';
comment on column ${iol_schema}.icms_customer_special.birthday is '出生日期';
comment on column ${iol_schema}.icms_customer_special.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_customer_special.relativecustname is '关联客户名称';
comment on column ${iol_schema}.icms_customer_special.educationdegree is '最高学位';
comment on column ${iol_schema}.icms_customer_special.certid is '证件号码';
comment on column ${iol_schema}.icms_customer_special.enddate is '结束时间';
comment on column ${iol_schema}.icms_customer_special.updateuserid is '更新人编号';
comment on column ${iol_schema}.icms_customer_special.inputtype is '入库类型';
comment on column ${iol_schema}.icms_customer_special.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_customer_special.specialcustomersubtype is '名单类别-子类';
comment on column ${iol_schema}.icms_customer_special.sex is '性别';
comment on column ${iol_schema}.icms_customer_special.inliststatus is '是否有效';
comment on column ${iol_schema}.icms_customer_special.relativecustid is '关联客户编号';
comment on column ${iol_schema}.icms_customer_special.shares is '持有本行股份数';
comment on column ${iol_schema}.icms_customer_special.inputorgid is '登记机构编号';
comment on column ${iol_schema}.icms_customer_special.actualassert is '实缴资本';
comment on column ${iol_schema}.icms_customer_special.updateorgid is '更新机构编号';
comment on column ${iol_schema}.icms_customer_special.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_customer_special.provider is '名单来源';
comment on column ${iol_schema}.icms_customer_special.specialcustomertype is '名单类别';
comment on column ${iol_schema}.icms_customer_special.inlistreason is '列入原因';
comment on column ${iol_schema}.icms_customer_special.industrytype is '国际行业分类国际行业分类型';
comment on column ${iol_schema}.icms_customer_special.reason is '入库原因';
comment on column ${iol_schema}.icms_customer_special.customerid is '客户编号';
comment on column ${iol_schema}.icms_customer_special.mobiletel is '手机号码';
comment on column ${iol_schema}.icms_customer_special.addapprovestatus is '';
comment on column ${iol_schema}.icms_customer_special.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_special.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_special.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_special.etl_timestamp is 'ETL处理时间戳';
