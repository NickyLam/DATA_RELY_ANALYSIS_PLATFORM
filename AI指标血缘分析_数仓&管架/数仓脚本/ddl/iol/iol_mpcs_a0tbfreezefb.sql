/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0tbfreezefb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0tbfreezefb
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0tbfreezefb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0tbfreezefb(
    orgtransserialnumber varchar2(80) -- 原传输报文流水号
    ,transdt varchar2(12) -- 交易日期
    ,transtm varchar2(9) -- 交易时间
    ,fkmode varchar2(3) -- 默认值01
    ,tobrcno varchar2(38) -- 接收机构id（对应下行报文中的messagefrom值）
    ,txcode varchar2(9) -- 交易类型编码100202
    ,transserialnumber varchar2(80) -- 传输报文流水号
    ,applicationid varchar2(54) -- 业务申请编号
    ,result varchar2(6) -- 冻结结果/冻结解除结果
    ,accounttype varchar2(3) -- 冻结账号类别（01-个人；02-对公）
    ,accountnumber varchar2(75) -- 冻结帐卡号(与原冻结报文帐卡号相同)
    ,cardnumber varchar2(45) -- 卡/折号(对私业务时需填写)
    ,appliedbalance varchar2(27) -- 申请冻结限额(单位到元)（"-"）
    ,frozedbalance varchar2(27) -- 执行冻结金额(单位到元)
    ,currency varchar2(5) -- 币种(cny人民币、usd美元、eur欧元…)
    ,accountbalance varchar2(27) -- 账户余额(冻结时刻的账户金额)
    ,starttime varchar2(21) -- 冻结起始时间(yyyymmddhhmmss)
    ,expiretime varchar2(21) -- 冻结结束时间(yyyymmddhhmmss)
    ,failurecause varchar2(338) -- 未能冻结原因
    ,formerapplicationdepartment varchar2(135) -- 在先冻结机关(上一个轮候机关)
    ,formerfrozencurrency varchar2(5) -- 币种(cny人民币、usd美元、eur欧元…)
    ,formerfrozenbalance varchar2(27) -- 在先冻结金额
    ,formerfrozenexpiretime varchar2(21) -- 在先冻结到期时间(yyyymmddhhmmss)
    ,accountavaiablebalance varchar2(27) -- 冻结后账户可用余额(冻结后的可用余额)
    ,feedbackremark varchar2(675) -- 反馈说明
    ,feedbackorgname varchar2(338) -- 反馈机构名称
    ,operatorname varchar2(90) -- 经办人姓名
    ,operatorphonenumber varchar2(45) -- 经办人电话
    ,hostdt varchar2(12) -- 冻结核心交易日期
    ,hostseqno varchar2(75) -- 冻结核心交易流水
    ,dataid varchar2(48) -- 中台流水
    ,status varchar2(3) -- 处理状态 0-未处理 1-已处理 2-处理失败
    ,times varchar2(3) -- 发送次数
    ,code varchar2(9) -- 返回码
    ,retutransserialnumber varchar2(80) -- 返回报文--传输报文流水号
    ,description varchar2(338) -- 返回消息
    ,lastmodifytm varchar2(21) -- 最后修改时间
    ,unfreezebalance varchar2(30) -- 解除冻结金额
    ,withdrawaltime varchar2(21) -- 冻结解除生效时间
    ,openbr varchar2(15) -- 开立机构
    ,upptransid varchar2(90) -- upp流水
    ,subsac varchar2(30) -- 子账号
    ,accttype varchar2(15) -- 账户类级
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
grant select on ${iol_schema}.mpcs_a0tbfreezefb to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0tbfreezefb to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0tbfreezefb to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0tbfreezefb to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0tbfreezefb is '电信诈骗冻结流水';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.orgtransserialnumber is '原传输报文流水号';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.transtm is '交易时间';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.fkmode is '默认值01';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.tobrcno is '接收机构id（对应下行报文中的messagefrom值）';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.txcode is '交易类型编码100202';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.transserialnumber is '传输报文流水号';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.applicationid is '业务申请编号';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.result is '冻结结果/冻结解除结果';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.accounttype is '冻结账号类别（01-个人；02-对公）';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.accountnumber is '冻结帐卡号(与原冻结报文帐卡号相同)';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.cardnumber is '卡/折号(对私业务时需填写)';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.appliedbalance is '申请冻结限额(单位到元)（"-"）';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.frozedbalance is '执行冻结金额(单位到元)';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.currency is '币种(cny人民币、usd美元、eur欧元…)';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.accountbalance is '账户余额(冻结时刻的账户金额)';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.starttime is '冻结起始时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.expiretime is '冻结结束时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.failurecause is '未能冻结原因';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.formerapplicationdepartment is '在先冻结机关(上一个轮候机关)';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.formerfrozencurrency is '币种(cny人民币、usd美元、eur欧元…)';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.formerfrozenbalance is '在先冻结金额';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.formerfrozenexpiretime is '在先冻结到期时间(yyyymmddhhmmss)';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.accountavaiablebalance is '冻结后账户可用余额(冻结后的可用余额)';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.feedbackremark is '反馈说明';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.feedbackorgname is '反馈机构名称';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.operatorname is '经办人姓名';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.operatorphonenumber is '经办人电话';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.hostdt is '冻结核心交易日期';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.hostseqno is '冻结核心交易流水';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.dataid is '中台流水';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.status is '处理状态 0-未处理 1-已处理 2-处理失败';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.times is '发送次数';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.code is '返回码';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.retutransserialnumber is '返回报文--传输报文流水号';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.description is '返回消息';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.lastmodifytm is '最后修改时间';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.unfreezebalance is '解除冻结金额';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.withdrawaltime is '冻结解除生效时间';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.openbr is '开立机构';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.upptransid is 'upp流水';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.subsac is '子账号';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.accttype is '账户类级';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0tbfreezefb.etl_timestamp is 'ETL处理时间戳';
