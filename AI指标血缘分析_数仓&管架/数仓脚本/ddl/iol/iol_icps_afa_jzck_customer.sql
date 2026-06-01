/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icps_afa_jzck_customer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icps_afa_jzck_customer
whenever sqlerror continue none;
drop table ${iol_schema}.icps_afa_jzck_customer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icps_afa_jzck_customer(
    productcode varchar2(10) -- 产品代码详见产品代码数据字典
    ,workdate varchar2(8) -- 平台日期
    ,agentserialno varchar2(20) -- 平台流水号
    ,worktime varchar2(6) -- 平台时间
    ,transserialnumber varchar2(53) -- 传输报文流水号
    ,applicationid varchar2(200) -- 业务申请编号
    ,result varchar2(50) -- 查询反馈结果对该查询任务的查询结果描述，成功或失败；01表示成功，02表示失败；
    ,description varchar2(200) -- 查询反馈结果原因对该查询反馈结果的原因的描述；
    ,idtype varchar2(15) -- 证照类型代码沿用请求单的证件类型代码；
    ,idnumber varchar2(60) -- 证照号码沿用请求单的证件号码；
    ,accountname varchar2(200) -- 客户名称客户的名称，沿用请求单的查询主体名称；
    ,telephone varchar2(20) -- 联系电话客户联系电话；
    ,mobilephone varchar2(20) -- 联系手机客户联系手机号码；
    ,operatorname varchar2(200) -- 代办人姓名代办人的姓名；
    ,operatorcredentialtype varchar2(15) -- 代办人证件类型代办人的证件类型，参见附录1证件类型代码规范；
    ,operatorcredentialnumber varchar2(50) -- 代办人证件号码代办人的证件号码；
    ,residentaddress varchar2(512) -- 住宅地址客户的住宅地址，属于个人账户开户信息；
    ,residenttelnumber varchar2(20) -- 住宅电话客户的住宅电话，属于个人账户开户信息；
    ,workcompanyname varchar2(200) -- 工作单位客户的工作单位，属于个人账户开户信息；
    ,workaddress varchar2(512) -- 单位地址客户的单位地址，属于个人账户开户信息；
    ,worktelnumber varchar2(20) -- 单位电话客户的单位电话，属于个人账户开户信息；
    ,emailaddress varchar2(60) -- 邮箱地址客户的邮箱地址，属于个人账户开户信息；
    ,legalpersonrep varchar2(120) -- 法人代表对公账户的法人代表，属于对公账户开户信息；
    ,legalpersonrepcredentialtype varchar2(15) -- 法人代表证件类型对公账户的法人代表证件类型，属于对公账户开户信息；
    ,legalpersonrepcredentialnumber varchar2(50) -- 法人代表证件号码对公账户的法人代表证件号码，属于对公账户开户信息；
    ,businesslicensenumber varchar2(18) -- 客户工商执照号码对公账户的客户工商执照号码，属于对公账户开户信息；
    ,statetaxserial varchar2(50) -- 国税纳税号对公账户的企业国税纳税号，属于对公账户开户信息；
    ,localtaxserial varchar2(50) -- 地税纳税号对公账户的企业地税纳税号，属于对公账户开户信息；
    ,remark1 varchar2(16) -- 备用字段1
    ,remark2 varchar2(32) -- 备用字段2
    ,remark3 varchar2(64) -- 备用字段3
    ,remark4 varchar2(128) -- 备用字段4
    ,zddz varchar2(256) -- 账单地址
    ,dbrlxdh varchar2(30) -- 代办人联系电话
    ,sjyhblrq varchar2(8) -- 手机银行办理日期
    ,sjyhkhwd varchar2(200) -- 手机银行开户网点
    ,sjyhkhwddm varchar2(20) -- 手机银行开户网点代码
    ,sjyhkhwdszd varchar2(600) -- 手机银行开户网点所在地
    ,sjyhzhm varchar2(400) -- 手机银行账户名
    ,wyblrq varchar2(8) -- 网银办理日期
    ,wykhwd varchar2(200) -- 网银开户网点
    ,wykhwddm varchar2(20) -- 网银开户网点代码
    ,wykhwdszd varchar2(600) -- 网银开户网点所在地
    ,wyzhm varchar2(200) -- 网银账户名
    ,custno varchar2(20) -- 客户号
    ,addr varchar2(400) -- 联系地址
    ,credentialexpirydate varchar2(8) -- 证照失效日期
    ,postcode varchar2(8) -- 邮政编码
    ,upddate varchar2(8) -- 更新日期
    ,updtime varchar2(6) -- 更新时间
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
grant select on ${iol_schema}.icps_afa_jzck_customer to ${iml_schema};
grant select on ${iol_schema}.icps_afa_jzck_customer to ${icl_schema};
grant select on ${iol_schema}.icps_afa_jzck_customer to ${idl_schema};
grant select on ${iol_schema}.icps_afa_jzck_customer to ${iel_schema};

-- comment
comment on table ${iol_schema}.icps_afa_jzck_customer is '查控客户基本信息表';
comment on column ${iol_schema}.icps_afa_jzck_customer.productcode is '产品代码详见产品代码数据字典';
comment on column ${iol_schema}.icps_afa_jzck_customer.workdate is '平台日期';
comment on column ${iol_schema}.icps_afa_jzck_customer.agentserialno is '平台流水号';
comment on column ${iol_schema}.icps_afa_jzck_customer.worktime is '平台时间';
comment on column ${iol_schema}.icps_afa_jzck_customer.transserialnumber is '传输报文流水号';
comment on column ${iol_schema}.icps_afa_jzck_customer.applicationid is '业务申请编号';
comment on column ${iol_schema}.icps_afa_jzck_customer.result is '查询反馈结果对该查询任务的查询结果描述，成功或失败；01表示成功，02表示失败；';
comment on column ${iol_schema}.icps_afa_jzck_customer.description is '查询反馈结果原因对该查询反馈结果的原因的描述；';
comment on column ${iol_schema}.icps_afa_jzck_customer.idtype is '证照类型代码沿用请求单的证件类型代码；';
comment on column ${iol_schema}.icps_afa_jzck_customer.idnumber is '证照号码沿用请求单的证件号码；';
comment on column ${iol_schema}.icps_afa_jzck_customer.accountname is '客户名称客户的名称，沿用请求单的查询主体名称；';
comment on column ${iol_schema}.icps_afa_jzck_customer.telephone is '联系电话客户联系电话；';
comment on column ${iol_schema}.icps_afa_jzck_customer.mobilephone is '联系手机客户联系手机号码；';
comment on column ${iol_schema}.icps_afa_jzck_customer.operatorname is '代办人姓名代办人的姓名；';
comment on column ${iol_schema}.icps_afa_jzck_customer.operatorcredentialtype is '代办人证件类型代办人的证件类型，参见附录1证件类型代码规范；';
comment on column ${iol_schema}.icps_afa_jzck_customer.operatorcredentialnumber is '代办人证件号码代办人的证件号码；';
comment on column ${iol_schema}.icps_afa_jzck_customer.residentaddress is '住宅地址客户的住宅地址，属于个人账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.residenttelnumber is '住宅电话客户的住宅电话，属于个人账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.workcompanyname is '工作单位客户的工作单位，属于个人账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.workaddress is '单位地址客户的单位地址，属于个人账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.worktelnumber is '单位电话客户的单位电话，属于个人账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.emailaddress is '邮箱地址客户的邮箱地址，属于个人账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.legalpersonrep is '法人代表对公账户的法人代表，属于对公账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.legalpersonrepcredentialtype is '法人代表证件类型对公账户的法人代表证件类型，属于对公账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.legalpersonrepcredentialnumber is '法人代表证件号码对公账户的法人代表证件号码，属于对公账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.businesslicensenumber is '客户工商执照号码对公账户的客户工商执照号码，属于对公账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.statetaxserial is '国税纳税号对公账户的企业国税纳税号，属于对公账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.localtaxserial is '地税纳税号对公账户的企业地税纳税号，属于对公账户开户信息；';
comment on column ${iol_schema}.icps_afa_jzck_customer.remark1 is '备用字段1';
comment on column ${iol_schema}.icps_afa_jzck_customer.remark2 is '备用字段2';
comment on column ${iol_schema}.icps_afa_jzck_customer.remark3 is '备用字段3';
comment on column ${iol_schema}.icps_afa_jzck_customer.remark4 is '备用字段4';
comment on column ${iol_schema}.icps_afa_jzck_customer.zddz is '账单地址';
comment on column ${iol_schema}.icps_afa_jzck_customer.dbrlxdh is '代办人联系电话';
comment on column ${iol_schema}.icps_afa_jzck_customer.sjyhblrq is '手机银行办理日期';
comment on column ${iol_schema}.icps_afa_jzck_customer.sjyhkhwd is '手机银行开户网点';
comment on column ${iol_schema}.icps_afa_jzck_customer.sjyhkhwddm is '手机银行开户网点代码';
comment on column ${iol_schema}.icps_afa_jzck_customer.sjyhkhwdszd is '手机银行开户网点所在地';
comment on column ${iol_schema}.icps_afa_jzck_customer.sjyhzhm is '手机银行账户名';
comment on column ${iol_schema}.icps_afa_jzck_customer.wyblrq is '网银办理日期';
comment on column ${iol_schema}.icps_afa_jzck_customer.wykhwd is '网银开户网点';
comment on column ${iol_schema}.icps_afa_jzck_customer.wykhwddm is '网银开户网点代码';
comment on column ${iol_schema}.icps_afa_jzck_customer.wykhwdszd is '网银开户网点所在地';
comment on column ${iol_schema}.icps_afa_jzck_customer.wyzhm is '网银账户名';
comment on column ${iol_schema}.icps_afa_jzck_customer.custno is '客户号';
comment on column ${iol_schema}.icps_afa_jzck_customer.addr is '联系地址';
comment on column ${iol_schema}.icps_afa_jzck_customer.credentialexpirydate is '证照失效日期';
comment on column ${iol_schema}.icps_afa_jzck_customer.postcode is '邮政编码';
comment on column ${iol_schema}.icps_afa_jzck_customer.upddate is '更新日期';
comment on column ${iol_schema}.icps_afa_jzck_customer.updtime is '更新时间';
comment on column ${iol_schema}.icps_afa_jzck_customer.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icps_afa_jzck_customer.etl_timestamp is 'ETL处理时间戳';
