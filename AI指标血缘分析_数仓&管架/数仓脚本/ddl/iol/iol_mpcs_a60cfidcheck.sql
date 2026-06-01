/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a60cfidcheck
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a60cfidcheck
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a60cfidcheck purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60cfidcheck(
    trannbr varchar2(9) -- 交易流水号
    ,trandate number(22) -- 交易日期
    ,trantime number(22) -- 交易时间
    ,trancode varchar2(6) -- 交易码
    ,linkid number(22) -- 链路id
    ,bnakcode varchar2(18) -- 银行代码
    ,identype varchar2(6) -- 证件类型
    ,idennbr varchar2(30) -- 证件号码
    ,nationality varchar2(5) -- 国家代码
    ,cltname varchar2(45) -- 证件姓名
    ,issueoffice varchar2(75) -- 签发机构
    ,photoname varchar2(120) -- 相片文件名
    ,chkresult varchar2(11) -- 验证结果
    ,status varchar2(2) -- s：验证成功t：验证失败w：初始状态
    ,srcseqno varchar2(105) -- 报文流水号
    ,srcsysid varchar2(15) -- 系统id
    ,tlrno varchar2(12) -- 交易代码
    ,brcno varchar2(9) -- 机构号
    ,trndt varchar2(12) -- 日期
    ,chkrtp varchar2(2) -- 
    ,hostnbr varchar2(30) -- 
    ,hostdt varchar2(12) -- 
    ,mutrcd varchar2(30) -- 
    ,trnname varchar2(450) -- 业务交易名称
    ,tmip varchar2(75) -- 客户ip地址
    ,tmmac varchar2(90) -- 客户mac地址
    ,mobile varchar2(30) -- 客户手机号码
    ,tmtype varchar2(2) -- 客户终端
    ,formername varchar2(45) -- 曾用名
    ,gender varchar2(2) -- 性别  性别-gb/t 2261
    ,birthday varchar2(12) -- 出生日期
    ,birthplace varchar2(9) -- 出生地   出生地- gb/t 2260
    ,nativeplace varchar2(9) -- 籍贯  籍贯- gb/t 2260文化程度- gb/t 4658
    ,edulevel varchar2(3) -- 文化程度
    ,marriage varchar2(3) -- 婚姻状况  婚姻状况- gb/t 4766
    ,job varchar2(30) -- 职业
    ,engageaddr varchar2(300) -- 服务处所
    ,address varchar2(300) -- 住址
    ,checkchnl varchar2(2) -- 核查通道0-人行1-国证通2-本地
    ,recordstat varchar2(2) -- 记录状态0-无效1-有效
    ,checkdept varchar2(15) -- 核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部
    ,transeqno varchar2(105) -- 交易流水号
    ,acctno varchar2(32) -- 银行账号
    ,chkrspmsg varchar2(300) -- 核查返回信息
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
grant select on ${iol_schema}.mpcs_a60cfidcheck to ${iml_schema};
grant select on ${iol_schema}.mpcs_a60cfidcheck to ${icl_schema};
grant select on ${iol_schema}.mpcs_a60cfidcheck to ${idl_schema};
grant select on ${iol_schema}.mpcs_a60cfidcheck to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a60cfidcheck is '';
comment on column ${iol_schema}.mpcs_a60cfidcheck.trannbr is '交易流水号';
comment on column ${iol_schema}.mpcs_a60cfidcheck.trandate is '交易日期';
comment on column ${iol_schema}.mpcs_a60cfidcheck.trantime is '交易时间';
comment on column ${iol_schema}.mpcs_a60cfidcheck.trancode is '交易码';
comment on column ${iol_schema}.mpcs_a60cfidcheck.linkid is '链路id';
comment on column ${iol_schema}.mpcs_a60cfidcheck.bnakcode is '银行代码';
comment on column ${iol_schema}.mpcs_a60cfidcheck.identype is '证件类型';
comment on column ${iol_schema}.mpcs_a60cfidcheck.idennbr is '证件号码';
comment on column ${iol_schema}.mpcs_a60cfidcheck.nationality is '国家代码';
comment on column ${iol_schema}.mpcs_a60cfidcheck.cltname is '证件姓名';
comment on column ${iol_schema}.mpcs_a60cfidcheck.issueoffice is '签发机构';
comment on column ${iol_schema}.mpcs_a60cfidcheck.photoname is '相片文件名';
comment on column ${iol_schema}.mpcs_a60cfidcheck.chkresult is '验证结果';
comment on column ${iol_schema}.mpcs_a60cfidcheck.status is 's：验证成功t：验证失败w：初始状态';
comment on column ${iol_schema}.mpcs_a60cfidcheck.srcseqno is '报文流水号';
comment on column ${iol_schema}.mpcs_a60cfidcheck.srcsysid is '系统id';
comment on column ${iol_schema}.mpcs_a60cfidcheck.tlrno is '交易代码';
comment on column ${iol_schema}.mpcs_a60cfidcheck.brcno is '机构号';
comment on column ${iol_schema}.mpcs_a60cfidcheck.trndt is '日期';
comment on column ${iol_schema}.mpcs_a60cfidcheck.chkrtp is '';
comment on column ${iol_schema}.mpcs_a60cfidcheck.hostnbr is '';
comment on column ${iol_schema}.mpcs_a60cfidcheck.hostdt is '';
comment on column ${iol_schema}.mpcs_a60cfidcheck.mutrcd is '';
comment on column ${iol_schema}.mpcs_a60cfidcheck.trnname is '业务交易名称';
comment on column ${iol_schema}.mpcs_a60cfidcheck.tmip is '客户ip地址';
comment on column ${iol_schema}.mpcs_a60cfidcheck.tmmac is '客户mac地址';
comment on column ${iol_schema}.mpcs_a60cfidcheck.mobile is '客户手机号码';
comment on column ${iol_schema}.mpcs_a60cfidcheck.tmtype is '客户终端';
comment on column ${iol_schema}.mpcs_a60cfidcheck.formername is '曾用名';
comment on column ${iol_schema}.mpcs_a60cfidcheck.gender is '性别  性别-gb/t 2261';
comment on column ${iol_schema}.mpcs_a60cfidcheck.birthday is '出生日期';
comment on column ${iol_schema}.mpcs_a60cfidcheck.birthplace is '出生地   出生地- gb/t 2260';
comment on column ${iol_schema}.mpcs_a60cfidcheck.nativeplace is '籍贯  籍贯- gb/t 2260文化程度- gb/t 4658';
comment on column ${iol_schema}.mpcs_a60cfidcheck.edulevel is '文化程度';
comment on column ${iol_schema}.mpcs_a60cfidcheck.marriage is '婚姻状况  婚姻状况- gb/t 4766';
comment on column ${iol_schema}.mpcs_a60cfidcheck.job is '职业';
comment on column ${iol_schema}.mpcs_a60cfidcheck.engageaddr is '服务处所';
comment on column ${iol_schema}.mpcs_a60cfidcheck.address is '住址';
comment on column ${iol_schema}.mpcs_a60cfidcheck.checkchnl is '核查通道0-人行1-国证通2-本地';
comment on column ${iol_schema}.mpcs_a60cfidcheck.recordstat is '记录状态0-无效1-有效';
comment on column ${iol_schema}.mpcs_a60cfidcheck.checkdept is '核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部';
comment on column ${iol_schema}.mpcs_a60cfidcheck.transeqno is '交易流水号';
comment on column ${iol_schema}.mpcs_a60cfidcheck.acctno is '银行账号';
comment on column ${iol_schema}.mpcs_a60cfidcheck.chkrspmsg is '核查返回信息';
comment on column ${iol_schema}.mpcs_a60cfidcheck.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a60cfidcheck.etl_timestamp is 'ETL处理时间戳';
