/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0tacctzf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0tacctzf
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0tacctzf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0tacctzf(
    txcode varchar2(9) -- 交易类型编码
    ,transserialnumber varchar2(80) -- 传输报文流水号
    ,transdt varchar2(12) -- 查询日期
    ,transtm varchar2(12) -- 查询时间
    ,status varchar2(3) -- 处理状态
    ,applicationid varchar2(54) -- 业务申请编号
    ,applicationtype varchar2(3) -- 是否补流程（00-初次提交正常止付人民币活期账户；01-初次提交正常 止付外币活期、本外币定期账户；02-银行举报案件止付人民币活期账户；03-银行举报案件止付外币活期、本外币定期账户；04-后补人民币活期止付流程； 05-后补外币活期止付流程
    ,originalapplicationid varchar2(54) -- 原举报申请编号(银行报案时必填，即applicationtype=02,03,04,05时)
    ,casenumber varchar2(45) -- 案件编号
    ,casetype varchar2(6) -- 案件类型（参照公安机关案件类型标准）案件类型做为案件名称  0001-电信诈骗
    ,emergencylevel varchar2(3) -- 紧急程度（01-正常；02-加急）
    ,transferoutbankid varchar2(18) -- 转出账户所属银行机构编码
    ,transferoutbankname varchar2(338) -- 转出账户银行名称
    ,transferoutaccountname varchar2(270) -- 转出账户名
    ,transferoutaccountnumber varchar2(75) -- 转出帐卡号
    ,currency varchar2(5) -- 币种(cny人民币、usd美元、eur欧元…)
    ,transferamount varchar2(27) -- 转出金额(单位到元)
    ,transfertime varchar2(21) -- 转出时间(yyyymmddhhmmss)
    ,bankid varchar2(18) -- 止付账户所属银行机构编码
    ,bankname varchar2(338) -- 止付账户所属银行名称
    ,accounttype varchar2(3) -- 止付账号类别（01-个人；02-对公）
    ,accountname varchar2(270) -- 止付账户名
    ,accountnumber varchar2(75) -- 止付帐卡号
    ,reason varchar2(675) -- 止付事由
    ,remark varchar2(675) -- 止付说明
    ,starttime varchar2(21) -- 止付起始时间(yyyymmddhhmmss)
    ,expiretime varchar2(21) -- 止付截止时间(yyyymmddhhmmss)
    ,applicationtime varchar2(21) -- 申请时间(yyyymmddhhmmss)
    ,applicationorgid varchar2(18) -- 申请机构编码
    ,applicationorgname varchar2(338) -- 申请机构名称
    ,operatoridtype varchar2(3) -- 经办人证件类型
    ,operatoridnumber varchar2(45) -- 经办人证件号
    ,operatorname varchar2(90) -- 经办人姓名
    ,operatorphonenumber varchar2(45) -- 经办人电话
    ,investigatoridtype varchar2(3) -- 协查人证件类型
    ,investigatorname varchar2(90) -- 协查人姓名
    ,withdrawalremark varchar2(675) -- 止付解除说明
    ,postponestarttime varchar2(21) -- 止付延期起始时间(yyyymmddhhmmss)
    ,extendremark varchar2(675) -- 止付延期说明
    ,hostdate varchar2(12) -- 核心日期
    ,hostnbr varchar2(90) -- 核心流水
    ,hostcode varchar2(18) -- 核心返回码
    ,erortx varchar2(338) -- 核心返回信息
    ,dataid varchar2(48) -- 止付唯一标识
    ,messagefrom varchar2(38) -- 发送机构编号
    ,acctbal varchar2(33) -- 账户余额
    ,zfstartdate varchar2(21) -- 实际止付开始日期
    ,zfenddate varchar2(21) -- 实际止付到期日
    ,upptransid varchar2(90) -- upp流水
    ,subsac varchar2(30) -- 子账号
    ,accttype varchar2(15) -- 账户类级
    ,openbr varchar2(15) -- 开立机构
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
grant select on ${iol_schema}.mpcs_a0tacctzf to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0tacctzf to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0tacctzf to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0tacctzf to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0tacctzf is '电信诈骗止付流水';
comment on column ${iol_schema}.mpcs_a0tacctzf.txcode is '交易类型编码';
comment on column ${iol_schema}.mpcs_a0tacctzf.transserialnumber is '传输报文流水号';
comment on column ${iol_schema}.mpcs_a0tacctzf.transdt is '查询日期';
comment on column ${iol_schema}.mpcs_a0tacctzf.transtm is '查询时间';
comment on column ${iol_schema}.mpcs_a0tacctzf.status is '处理状态';
comment on column ${iol_schema}.mpcs_a0tacctzf.applicationid is '业务申请编号';
comment on column ${iol_schema}.mpcs_a0tacctzf.applicationtype is '是否补流程（00-初次提交正常止付人民币活期账户；01-初次提交正常 止付外币活期、本外币定期账户；02-银行举报案件止付人民币活期账户；03-银行举报案件止付外币活期、本外币定期账户；04-后补人民币活期止付流程； 05-后补外币活期止付流程';
comment on column ${iol_schema}.mpcs_a0tacctzf.originalapplicationid is '原举报申请编号(银行报案时必填，即applicationtype=02,03,04,05时)';
comment on column ${iol_schema}.mpcs_a0tacctzf.casenumber is '案件编号';
comment on column ${iol_schema}.mpcs_a0tacctzf.casetype is '案件类型（参照公安机关案件类型标准）案件类型做为案件名称  0001-电信诈骗';
comment on column ${iol_schema}.mpcs_a0tacctzf.emergencylevel is '紧急程度（01-正常；02-加急）';
comment on column ${iol_schema}.mpcs_a0tacctzf.transferoutbankid is '转出账户所属银行机构编码';
comment on column ${iol_schema}.mpcs_a0tacctzf.transferoutbankname is '转出账户银行名称';
comment on column ${iol_schema}.mpcs_a0tacctzf.transferoutaccountname is '转出账户名';
comment on column ${iol_schema}.mpcs_a0tacctzf.transferoutaccountnumber is '转出帐卡号';
comment on column ${iol_schema}.mpcs_a0tacctzf.currency is '币种(cny人民币、usd美元、eur欧元…)';
comment on column ${iol_schema}.mpcs_a0tacctzf.transferamount is '转出金额(单位到元)';
comment on column ${iol_schema}.mpcs_a0tacctzf.transfertime is '转出时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.mpcs_a0tacctzf.bankid is '止付账户所属银行机构编码';
comment on column ${iol_schema}.mpcs_a0tacctzf.bankname is '止付账户所属银行名称';
comment on column ${iol_schema}.mpcs_a0tacctzf.accounttype is '止付账号类别（01-个人；02-对公）';
comment on column ${iol_schema}.mpcs_a0tacctzf.accountname is '止付账户名';
comment on column ${iol_schema}.mpcs_a0tacctzf.accountnumber is '止付帐卡号';
comment on column ${iol_schema}.mpcs_a0tacctzf.reason is '止付事由';
comment on column ${iol_schema}.mpcs_a0tacctzf.remark is '止付说明';
comment on column ${iol_schema}.mpcs_a0tacctzf.starttime is '止付起始时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.mpcs_a0tacctzf.expiretime is '止付截止时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.mpcs_a0tacctzf.applicationtime is '申请时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.mpcs_a0tacctzf.applicationorgid is '申请机构编码';
comment on column ${iol_schema}.mpcs_a0tacctzf.applicationorgname is '申请机构名称';
comment on column ${iol_schema}.mpcs_a0tacctzf.operatoridtype is '经办人证件类型';
comment on column ${iol_schema}.mpcs_a0tacctzf.operatoridnumber is '经办人证件号';
comment on column ${iol_schema}.mpcs_a0tacctzf.operatorname is '经办人姓名';
comment on column ${iol_schema}.mpcs_a0tacctzf.operatorphonenumber is '经办人电话';
comment on column ${iol_schema}.mpcs_a0tacctzf.investigatoridtype is '协查人证件类型';
comment on column ${iol_schema}.mpcs_a0tacctzf.investigatorname is '协查人姓名';
comment on column ${iol_schema}.mpcs_a0tacctzf.withdrawalremark is '止付解除说明';
comment on column ${iol_schema}.mpcs_a0tacctzf.postponestarttime is '止付延期起始时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.mpcs_a0tacctzf.extendremark is '止付延期说明';
comment on column ${iol_schema}.mpcs_a0tacctzf.hostdate is '核心日期';
comment on column ${iol_schema}.mpcs_a0tacctzf.hostnbr is '核心流水';
comment on column ${iol_schema}.mpcs_a0tacctzf.hostcode is '核心返回码';
comment on column ${iol_schema}.mpcs_a0tacctzf.erortx is '核心返回信息';
comment on column ${iol_schema}.mpcs_a0tacctzf.dataid is '止付唯一标识';
comment on column ${iol_schema}.mpcs_a0tacctzf.messagefrom is '发送机构编号';
comment on column ${iol_schema}.mpcs_a0tacctzf.acctbal is '账户余额';
comment on column ${iol_schema}.mpcs_a0tacctzf.zfstartdate is '实际止付开始日期';
comment on column ${iol_schema}.mpcs_a0tacctzf.zfenddate is '实际止付到期日';
comment on column ${iol_schema}.mpcs_a0tacctzf.upptransid is 'upp流水';
comment on column ${iol_schema}.mpcs_a0tacctzf.subsac is '子账号';
comment on column ${iol_schema}.mpcs_a0tacctzf.accttype is '账户类级';
comment on column ${iol_schema}.mpcs_a0tacctzf.openbr is '开立机构';
comment on column ${iol_schema}.mpcs_a0tacctzf.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0tacctzf.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0tacctzf.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0tacctzf.etl_timestamp is 'ETL处理时间戳';
