/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_customer_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_customer_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_customer_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_customer_info(
    customerid varchar2(16) -- 客户号
    ,financialorganizationnumber varchar2(2) -- 客户类别
    ,customertype varchar2(6) -- 客户类型
    ,customersubtype varchar2(6) -- 客户子类型
    ,enterprisename varchar2(100) -- 客户中文名称
    ,certtype varchar2(3) -- 主证件类型
    ,certid varchar2(50) -- 证件号码
    ,certidexpiredate varchar2(10) -- 证件到期日
    ,institutionalcreditcode varchar2(50) -- 统一社会信用代码
    ,organizationcertificatenumber varchar2(50) -- 营业执照号
    ,expiredate varchar2(10) -- 营业执照有效截止日期
    ,registeraddr varchar2(2000) -- 注册地址
    ,registercountry varchar2(3) -- 国别
    ,registerareacode varchar2(8) -- 行政区划代码
    ,registerareaname varchar2(300) -- 行政区划名称
    ,registerdate varchar2(10) -- 成立日期
    ,operatinglife varchar2(8) -- 经营年限
    ,acoperatinglife varchar2(8) -- 实际控制人从业年限
    ,mostbusiness varchar2(4000) -- 经营范围
    ,rccurrency varchar2(3) -- 注册资本币种
    ,pccurrency number(20,4) -- 注册资本（元）
    ,industrytype varchar2(10) -- 行业投向
    ,economicindustrytype varchar2(10) -- 经济行业分类
    ,economictype varchar2(10) -- 经济类型
    ,officetel varchar2(30) -- 办公联系电话
    ,financedepttel varchar2(30) -- 财务联系电话
    ,owebalancesumbalance varchar2(20) -- 欠息汇总-余额
    ,badsumbalance varchar2(20) -- 不良、违约类汇总（余额）
    ,riskwarning varchar2(20) -- 风险预警信号
    ,basicaccoutcode varchar2(32) -- 基本存款账号
    ,basicaccoutname varchar2(100) -- 基本账户开户行名称
    ,listingflag varchar2(1) -- 上市公司标志
    ,zipcode varchar2(6) -- 邮政编码
    ,phonenumber varchar2(30) -- 传真号码
    ,staffnumber number(11) -- 员工人数
    ,enterpriseholdingtype varchar2(6) -- 企业控股类型
    ,opencloseflag varchar2(2) -- 是否关停企业
    ,organizationscale varchar2(2) -- 企业规模
    ,inoutflag varchar2(2) -- 境内境外标志
    ,laborintensiveflag varchar2(2) -- 劳动密集型企业标志
    ,taxpayertype varchar2(2) -- 纳税人类型
    ,recommend varchar2(30) -- 推荐人
    ,taxpayerid varchar2(50) -- 纳税人识别号
    ,creditrate varchar2(8) -- 纳税等级
    ,portal varchar2(20) -- 营销渠道号
    ,loansplitresult varchar2(2) -- 客户是否分流
    ,orgminputoutdate varchar2(10) -- 最早放款日期
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 废除五级分类
    ,custid varchar2(40) -- 我行客户号
    ,updatedate1 varchar2(30) -- 微纵更新时间
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
grant select on ${iol_schema}.icms_wyd_customer_info to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_customer_info to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_customer_info to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_customer_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_customer_info is '企业基本信息';
comment on column ${iol_schema}.icms_wyd_customer_info.customerid is '客户号';
comment on column ${iol_schema}.icms_wyd_customer_info.financialorganizationnumber is '客户类别';
comment on column ${iol_schema}.icms_wyd_customer_info.customertype is '客户类型';
comment on column ${iol_schema}.icms_wyd_customer_info.customersubtype is '客户子类型';
comment on column ${iol_schema}.icms_wyd_customer_info.enterprisename is '客户中文名称';
comment on column ${iol_schema}.icms_wyd_customer_info.certtype is '主证件类型';
comment on column ${iol_schema}.icms_wyd_customer_info.certid is '证件号码';
comment on column ${iol_schema}.icms_wyd_customer_info.certidexpiredate is '证件到期日';
comment on column ${iol_schema}.icms_wyd_customer_info.institutionalcreditcode is '统一社会信用代码';
comment on column ${iol_schema}.icms_wyd_customer_info.organizationcertificatenumber is '营业执照号';
comment on column ${iol_schema}.icms_wyd_customer_info.expiredate is '营业执照有效截止日期';
comment on column ${iol_schema}.icms_wyd_customer_info.registeraddr is '注册地址';
comment on column ${iol_schema}.icms_wyd_customer_info.registercountry is '国别';
comment on column ${iol_schema}.icms_wyd_customer_info.registerareacode is '行政区划代码';
comment on column ${iol_schema}.icms_wyd_customer_info.registerareaname is '行政区划名称';
comment on column ${iol_schema}.icms_wyd_customer_info.registerdate is '成立日期';
comment on column ${iol_schema}.icms_wyd_customer_info.operatinglife is '经营年限';
comment on column ${iol_schema}.icms_wyd_customer_info.acoperatinglife is '实际控制人从业年限';
comment on column ${iol_schema}.icms_wyd_customer_info.mostbusiness is '经营范围';
comment on column ${iol_schema}.icms_wyd_customer_info.rccurrency is '注册资本币种';
comment on column ${iol_schema}.icms_wyd_customer_info.pccurrency is '注册资本（元）';
comment on column ${iol_schema}.icms_wyd_customer_info.industrytype is '行业投向';
comment on column ${iol_schema}.icms_wyd_customer_info.economicindustrytype is '经济行业分类';
comment on column ${iol_schema}.icms_wyd_customer_info.economictype is '经济类型';
comment on column ${iol_schema}.icms_wyd_customer_info.officetel is '办公联系电话';
comment on column ${iol_schema}.icms_wyd_customer_info.financedepttel is '财务联系电话';
comment on column ${iol_schema}.icms_wyd_customer_info.owebalancesumbalance is '欠息汇总-余额';
comment on column ${iol_schema}.icms_wyd_customer_info.badsumbalance is '不良、违约类汇总（余额）';
comment on column ${iol_schema}.icms_wyd_customer_info.riskwarning is '风险预警信号';
comment on column ${iol_schema}.icms_wyd_customer_info.basicaccoutcode is '基本存款账号';
comment on column ${iol_schema}.icms_wyd_customer_info.basicaccoutname is '基本账户开户行名称';
comment on column ${iol_schema}.icms_wyd_customer_info.listingflag is '上市公司标志';
comment on column ${iol_schema}.icms_wyd_customer_info.zipcode is '邮政编码';
comment on column ${iol_schema}.icms_wyd_customer_info.phonenumber is '传真号码';
comment on column ${iol_schema}.icms_wyd_customer_info.staffnumber is '员工人数';
comment on column ${iol_schema}.icms_wyd_customer_info.enterpriseholdingtype is '企业控股类型';
comment on column ${iol_schema}.icms_wyd_customer_info.opencloseflag is '是否关停企业';
comment on column ${iol_schema}.icms_wyd_customer_info.organizationscale is '企业规模';
comment on column ${iol_schema}.icms_wyd_customer_info.inoutflag is '境内境外标志';
comment on column ${iol_schema}.icms_wyd_customer_info.laborintensiveflag is '劳动密集型企业标志';
comment on column ${iol_schema}.icms_wyd_customer_info.taxpayertype is '纳税人类型';
comment on column ${iol_schema}.icms_wyd_customer_info.recommend is '推荐人';
comment on column ${iol_schema}.icms_wyd_customer_info.taxpayerid is '纳税人识别号';
comment on column ${iol_schema}.icms_wyd_customer_info.creditrate is '纳税等级';
comment on column ${iol_schema}.icms_wyd_customer_info.portal is '营销渠道号';
comment on column ${iol_schema}.icms_wyd_customer_info.loansplitresult is '客户是否分流';
comment on column ${iol_schema}.icms_wyd_customer_info.orgminputoutdate is '最早放款日期';
comment on column ${iol_schema}.icms_wyd_customer_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_customer_info.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_customer_info.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_customer_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_customer_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_customer_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_customer_info.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_customer_info.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_customer_info.custid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_customer_info.updatedate1 is '微纵更新时间';
comment on column ${iol_schema}.icms_wyd_customer_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_customer_info.etl_timestamp is 'ETL处理时间戳';
