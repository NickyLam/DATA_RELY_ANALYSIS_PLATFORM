/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_mpcs_a60cfidcheck
CreateDate: 20221228
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.aml_mpcs_a60cfidcheck purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.aml_mpcs_a60cfidcheck(
etl_dt date --数据日期
,trannbr varchar2(9) --交易流水号
,trandate number(22) --交易日期
,trantime number(22) --交易时间
,trancode varchar2(6) --交易码
,linkid number(22) --链路ID
,bnakcode varchar2(18) --银行代码
,identype varchar2(6) --
,idennbr varchar2(30) --证件号码
,nationality varchar2(5) --国家代码
,cltname varchar2(45) --证件姓名
,issueoffice varchar2(75) --签发机构
,photoname varchar2(120) --
,chkresult varchar2(11) --验证结果
,status varchar2(2) --S：验证成功T：验证失败W：初始状态
,srcseqno varchar2(105) --
,srcsysid varchar2(15) --系统ID
,tlrno varchar2(12) --
,brcno varchar2(9) --机构号
,trndt varchar2(12) --日期
,chkrtp varchar2(2) --
,hostnbr varchar2(30) --主机流水
,hostdt varchar2(12) --主机日期
,mutrcd varchar2(30) --
,trnname varchar2(450) --业务交易名称
,tmip varchar2(75) --客户IP地址
,tmmac varchar2(75) --客户mac地址
,mobile varchar2(30) --客户手机号码
,tmtype varchar2(2) --客户终端
,formername varchar2(45) --曾用名
,gender varchar2(2) --性别  性别-GB/T 2261
,birthday varchar2(12) --出生日期
,birthplace varchar2(9) --出生地   出生地- GB/T 2260
,nativeplace varchar2(9) --籍贯  籍贯- GB/T 2260文化程度- GB/T 4658
,edulevel varchar2(3) --文化程度
,marriage varchar2(3) --婚姻状况  婚姻状况- GB/T 4766
,job varchar2(30) --职业
,engageaddr varchar2(300) --服务处所
,address varchar2(300) --住址
,checkchnl varchar2(2) --核查通道0-人行1-国证通2-本地
,recordstat varchar2(2) --记录状态0-无效1-有效
,checkdept varchar2(15) --核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部
,etl_timestamp timestamp(6) -- 任务处理时间

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_mpcs_a60cfidcheck to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_mpcs_a60cfidcheck is '联网核查流水表';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.trannbr is '交易流水号';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.trandate is '交易日期';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.trantime is '交易时间';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.trancode is '交易码';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.linkid is '链路ID';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.bnakcode is '银行代码';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.identype is '';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.idennbr is '证件号码';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.nationality is '国家代码';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.cltname is '证件姓名';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.issueoffice is '签发机构';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.photoname is '';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.chkresult is '验证结果';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.status is 'S：验证成功T：验证失败W：初始状态';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.srcseqno is '';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.srcsysid is '系统ID';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.tlrno is '';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.brcno is '机构号';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.trndt is '日期';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.chkrtp is '';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.hostnbr is '主机流水';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.hostdt is '主机日期';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.mutrcd is '';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.trnname is '业务交易名称';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.tmip is '客户IP地址';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.tmmac is '客户mac地址';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.mobile is '客户手机号码';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.tmtype is '客户终端';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.formername is '曾用名';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.gender is '性别  性别-GB/T 2261';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.birthday is '出生日期';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.birthplace is '出生地   出生地- GB/T 2260';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.nativeplace is '籍贯  籍贯- GB/T 2260文化程度- GB/T 4658';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.edulevel is '文化程度';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.marriage is '婚姻状况  婚姻状况- GB/T 4766';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.job is '职业';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.engageaddr is '服务处所';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.address is '住址';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.checkchnl is '核查通道0-人行1-国证通2-本地';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.recordstat is '记录状态0-无效1-有效';
comment on column ${idl_schema}.aml_mpcs_a60cfidcheck.checkdept is '核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部';

