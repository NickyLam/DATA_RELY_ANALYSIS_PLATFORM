/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_customer_info_wld
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_customer_info_wld
whenever sqlerror continue none;
drop table ${iol_schema}.icms_customer_info_wld purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_customer_info_wld(
    customerid varchar2(32) -- 客户号
    ,customername varchar2(200) -- 客户姓名
    ,certtype varchar2(4) -- 证件类型
    ,certid varchar2(60) -- 证件号码
    ,certstartdate date -- 证件起始日
    ,certmaturity date -- 证件到期日
    ,sex varchar2(1) -- 性别
    ,occupation varchar2(500) -- 职业
    ,nation varchar2(3) -- 国籍
    ,address varchar2(600) -- 地址
    ,telephone varchar2(30) -- 联系电话
    ,isfarmer varchar2(1) -- 农户标志
    ,isindividual varchar2(1) -- 是否个体工商户
    ,isminbusiowner varchar2(1) -- 是否小微企业主
    ,wldcustid number(20) -- 微粒贷客户号
    ,birthday date -- 生日
    ,profcountry varchar2(1) -- 是否永久居住
    ,residencycountrycd varchar2(3) -- 永久居住地国家代码
    ,languageind varchar2(8) -- 语言代码
    ,embname varchar2(120) -- 拼音名
    ,surname varchar2(200) -- 姓氏
    ,marrystate varchar2(2) -- 婚姻状况
    ,homephone varchar2(30) -- 家庭电话
    ,compphone varchar2(30) -- 单位电话
    ,qualification varchar2(2) -- 学历
    ,degree varchar2(2) -- 学位
    ,resideaddr varchar2(700) -- 户籍地址
    ,matecertp varchar2(10) -- 配偶证件类型
    ,matecerno varchar2(30) -- 配偶证件号码
    ,matename varchar2(200) -- 配偶姓名
    ,matecorp varchar2(500) -- 配偶工作单位
    ,matephone varchar2(30) -- 配偶联系电话
    ,addr varchar2(700) -- 居住地址
    ,residestate varchar2(2) -- 居住状况
    ,compnm varchar2(700) -- 工作单位
    ,compaddr varchar2(700) -- 单位地址
    ,comptrade varchar2(2) -- 行业
    ,business varchar2(2) -- 职务
    ,teachpose varchar2(2) -- 职称
    ,workdate varchar2(4) -- 本单位工作起始年份
    ,expiredate date -- 有效期
    ,entname varchar2(180) -- 企业名称
    ,entcerttype varchar2(4) -- 企业证件类型
    ,entcreditcode varchar2(50) -- 统一社会信用代码
    ,inputdate date -- 登记日期
    ,updatedate date -- 更新日期
    ,entregno varchar2(100) -- 企业注册号
    ,entbusinessstatus varchar2(128) -- 企业经营状态
    ,industrycode varchar2(20) -- 行业代码
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
grant select on ${iol_schema}.icms_customer_info_wld to ${iml_schema};
grant select on ${iol_schema}.icms_customer_info_wld to ${icl_schema};
grant select on ${iol_schema}.icms_customer_info_wld to ${idl_schema};
grant select on ${iol_schema}.icms_customer_info_wld to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_customer_info_wld is '微粒贷客户信息表';
comment on column ${iol_schema}.icms_customer_info_wld.customerid is '客户号';
comment on column ${iol_schema}.icms_customer_info_wld.customername is '客户姓名';
comment on column ${iol_schema}.icms_customer_info_wld.certtype is '证件类型';
comment on column ${iol_schema}.icms_customer_info_wld.certid is '证件号码';
comment on column ${iol_schema}.icms_customer_info_wld.certstartdate is '证件起始日';
comment on column ${iol_schema}.icms_customer_info_wld.certmaturity is '证件到期日';
comment on column ${iol_schema}.icms_customer_info_wld.sex is '性别';
comment on column ${iol_schema}.icms_customer_info_wld.occupation is '职业';
comment on column ${iol_schema}.icms_customer_info_wld.nation is '国籍';
comment on column ${iol_schema}.icms_customer_info_wld.address is '地址';
comment on column ${iol_schema}.icms_customer_info_wld.telephone is '联系电话';
comment on column ${iol_schema}.icms_customer_info_wld.isfarmer is '农户标志';
comment on column ${iol_schema}.icms_customer_info_wld.isindividual is '是否个体工商户';
comment on column ${iol_schema}.icms_customer_info_wld.isminbusiowner is '是否小微企业主';
comment on column ${iol_schema}.icms_customer_info_wld.wldcustid is '微粒贷客户号';
comment on column ${iol_schema}.icms_customer_info_wld.birthday is '生日';
comment on column ${iol_schema}.icms_customer_info_wld.profcountry is '是否永久居住';
comment on column ${iol_schema}.icms_customer_info_wld.residencycountrycd is '永久居住地国家代码';
comment on column ${iol_schema}.icms_customer_info_wld.languageind is '语言代码';
comment on column ${iol_schema}.icms_customer_info_wld.embname is '拼音名';
comment on column ${iol_schema}.icms_customer_info_wld.surname is '姓氏';
comment on column ${iol_schema}.icms_customer_info_wld.marrystate is '婚姻状况';
comment on column ${iol_schema}.icms_customer_info_wld.homephone is '家庭电话';
comment on column ${iol_schema}.icms_customer_info_wld.compphone is '单位电话';
comment on column ${iol_schema}.icms_customer_info_wld.qualification is '学历';
comment on column ${iol_schema}.icms_customer_info_wld.degree is '学位';
comment on column ${iol_schema}.icms_customer_info_wld.resideaddr is '户籍地址';
comment on column ${iol_schema}.icms_customer_info_wld.matecertp is '配偶证件类型';
comment on column ${iol_schema}.icms_customer_info_wld.matecerno is '配偶证件号码';
comment on column ${iol_schema}.icms_customer_info_wld.matename is '配偶姓名';
comment on column ${iol_schema}.icms_customer_info_wld.matecorp is '配偶工作单位';
comment on column ${iol_schema}.icms_customer_info_wld.matephone is '配偶联系电话';
comment on column ${iol_schema}.icms_customer_info_wld.addr is '居住地址';
comment on column ${iol_schema}.icms_customer_info_wld.residestate is '居住状况';
comment on column ${iol_schema}.icms_customer_info_wld.compnm is '工作单位';
comment on column ${iol_schema}.icms_customer_info_wld.compaddr is '单位地址';
comment on column ${iol_schema}.icms_customer_info_wld.comptrade is '行业';
comment on column ${iol_schema}.icms_customer_info_wld.business is '职务';
comment on column ${iol_schema}.icms_customer_info_wld.teachpose is '职称';
comment on column ${iol_schema}.icms_customer_info_wld.workdate is '本单位工作起始年份';
comment on column ${iol_schema}.icms_customer_info_wld.expiredate is '有效期';
comment on column ${iol_schema}.icms_customer_info_wld.entname is '企业名称';
comment on column ${iol_schema}.icms_customer_info_wld.entcerttype is '企业证件类型';
comment on column ${iol_schema}.icms_customer_info_wld.entcreditcode is '统一社会信用代码';
comment on column ${iol_schema}.icms_customer_info_wld.inputdate is '登记日期';
comment on column ${iol_schema}.icms_customer_info_wld.updatedate is '更新日期';
comment on column ${iol_schema}.icms_customer_info_wld.entregno is '企业注册号';
comment on column ${iol_schema}.icms_customer_info_wld.entbusinessstatus is '企业经营状态';
comment on column ${iol_schema}.icms_customer_info_wld.industrycode is '行业代码';
comment on column ${iol_schema}.icms_customer_info_wld.start_dt is '开始时间';
comment on column ${iol_schema}.icms_customer_info_wld.end_dt is '结束时间';
comment on column ${iol_schema}.icms_customer_info_wld.id_mark is '增删标志';
comment on column ${iol_schema}.icms_customer_info_wld.etl_timestamp is 'ETL处理时间戳';
