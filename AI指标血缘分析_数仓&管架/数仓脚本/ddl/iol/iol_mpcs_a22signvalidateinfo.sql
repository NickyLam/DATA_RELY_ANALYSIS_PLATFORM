/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a22signvalidateinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a22signvalidateinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a22signvalidateinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a22signvalidateinfo(
    msgid varchar2(192) -- 报文标识
    ,chnlid varchar2(3) -- 交易渠道(01：支付宝02：柜台，03：网银，04：电话银行，05：自助终端，06：pos，07：批量交易，08：第三方,09:中台
    ,protocolid varchar2(192) -- 协议号
    ,chnltime varchar2(26) -- 渠道时间
    ,trntm varchar2(26) -- 系统交易时间
    ,acctname varchar2(45) -- 账号名称
    ,acctno varchar2(68) -- 账号
    ,accttype varchar2(2) -- 账户类型
    ,bankcardareacode varchar2(15) -- 银行省市分行编码
    ,idtype varchar2(2) -- 证件类型
    ,idno varchar2(45) -- 证件号码
    ,mobile varchar2(45) -- 手机号码
    ,custaddr varchar2(150) -- 客户地址
    ,ischeckcertificateno varchar2(2) -- 是否校验证件类型、证件号
    ,ischeckmobilephone varchar2(2) -- 是否校验手机号
    ,ischeckaccountname varchar2(2) -- 是否校验户名
    ,expirydate varchar2(9) -- 有效期
    ,custstatus varchar2(2) -- 客户状态(0:正常，1:冻结，2:销户，默认为"0")
    ,signtlrno varchar2(15) -- 签约柜员
    ,authtlrno varchar2(15) -- 授权柜员
    ,signbrc varchar2(15) -- 签约网点
    ,trninlmtamt varchar2(30) -- 
    ,daytrnlmtamt varchar2(30) -- 
    ,thirdtrninlmtamt varchar2(30) -- 
    ,daythirdtrnlmtamt varchar2(30) -- 
    ,trngetlmtamt varchar2(30) -- 
    ,daygetlmtamt varchar2(30) -- 
    ,lastupdtlrno varchar2(15) -- 最后更新柜员
    ,lastupddt varchar2(26) -- 最后更新时间
    ,rmk1 varchar2(75) -- 备注1
    ,rmk2 varchar2(75) -- 备注2
    ,rmk3 varchar2(75) -- 备注3
    ,coopcd varchar2(3) -- 卡代码
    ,banktradetype varchar2(9) -- 交易类型
    ,webplatfrom varchar2(45) -- 网络交易平台
    ,payeemerchantname varchar2(768) -- 商户名称
    ,shopname varchar2(384) -- 店铺名
    ,merchantcode varchar2(384) -- 商户编码
    ,payeeaccount varchar2(768) -- 资金账号
    ,payeeinst varchar2(384) -- 对方机构
    ,merchantmcc varchar2(15) -- 商户类别编码
    ,isglobal varchar2(2) -- 商户境内外标识
    ,national varchar2(15) -- 国籍
    ,merchantwebinfo varchar2(768) -- 网络地址
    ,terminaltype varchar2(30) -- 支付终端
    ,bizno varchar2(768) -- 商品订单号
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
grant select on ${iol_schema}.mpcs_a22signvalidateinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a22signvalidateinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a22signvalidateinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a22signvalidateinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a22signvalidateinfo is '签约信息记录表';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.msgid is '报文标识';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.chnlid is '交易渠道(01：支付宝02：柜台，03：网银，04：电话银行，05：自助终端，06：pos，07：批量交易，08：第三方,09:中台';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.protocolid is '协议号';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.chnltime is '渠道时间';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.trntm is '系统交易时间';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.acctname is '账号名称';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.acctno is '账号';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.accttype is '账户类型';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.bankcardareacode is '银行省市分行编码';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.idno is '证件号码';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.mobile is '手机号码';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.custaddr is '客户地址';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.ischeckcertificateno is '是否校验证件类型、证件号';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.ischeckmobilephone is '是否校验手机号';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.ischeckaccountname is '是否校验户名';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.expirydate is '有效期';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.custstatus is '客户状态(0:正常，1:冻结，2:销户，默认为"0")';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.signtlrno is '签约柜员';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.authtlrno is '授权柜员';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.signbrc is '签约网点';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.trninlmtamt is '';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.daytrnlmtamt is '';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.thirdtrninlmtamt is '';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.daythirdtrnlmtamt is '';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.trngetlmtamt is '';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.daygetlmtamt is '';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.lastupdtlrno is '最后更新柜员';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.lastupddt is '最后更新时间';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.rmk1 is '备注1';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.rmk2 is '备注2';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.rmk3 is '备注3';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.coopcd is '卡代码';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.banktradetype is '交易类型';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.webplatfrom is '网络交易平台';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.payeemerchantname is '商户名称';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.shopname is '店铺名';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.merchantcode is '商户编码';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.payeeaccount is '资金账号';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.payeeinst is '对方机构';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.merchantmcc is '商户类别编码';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.isglobal is '商户境内外标识';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.national is '国籍';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.merchantwebinfo is '网络地址';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.terminaltype is '支付终端';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.bizno is '商品订单号';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a22signvalidateinfo.etl_timestamp is 'ETL处理时间戳';
