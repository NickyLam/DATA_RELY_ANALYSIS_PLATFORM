/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ubrelationreg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ubrelationreg
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ubrelationreg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ubrelationreg(
    priacct varchar2(45) -- 账号
    ,usernotype varchar2(3) -- 用户号码类型
    ,userno varchar2(60) -- 用户号码(支付项目)
    ,usernoareacd varchar2(6) -- 用户号码地区编码
    ,usernoareacdadd varchar2(6) -- 用户号码附加地区编码
    ,acptermnlid varchar2(23) -- 商户代码
    ,paymode varchar2(2) -- 支付方式标志
    ,paymodetype varchar2(3) -- 支付方式类型
    ,paymodeno varchar2(60) -- 支付方式号码
    ,comsiontime varchar2(5) -- 委托关系期限
    ,maxlimitamt varchar2(18) -- 最高限制金额
    ,minlimitamt varchar2(18) -- 最低限制金额
    ,payextent varchar2(26) -- 支付区间
    ,reserve varchar2(750) -- 代收频率
    ,opendt varchar2(21) -- 签约日期
    ,closdt varchar2(21) -- 解约日期
    ,status varchar2(2) -- 状态 0:关闭无卡支付 1:开通无卡支付 2:小额临时支付
    ,relbusitype varchar2(3) -- 关联业务类型 01 : 有卡自助消费 02 : 无卡自助消费 03 : 互联网消费 04 : 订购 05 : 柜面无卡存款 06 : 自助存款 07 : 自助转账 08 : 互联网转账 09 : 代收 10 : 代付 11 : 预付费卡充值 14 : 无卡自助消费开通或关闭
    ,channels varchar2(5) -- 签约渠道 cnt-柜面 cup-银联 web-网银
    ,daymaxamt number(15,2) -- 当日最大交易限额
    ,snglmaxamt number(15,2) -- 单笔最大交易限额
    ,mtbrnnbr varchar2(18) -- 维护网点
    ,mttlrnbr varchar2(30) -- 维护柜员
    ,lastdt varchar2(12) -- 最后维护日期
    ,lasttm varchar2(9) -- 最后维护时间
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
grant select on ${iol_schema}.mpcs_a51ubrelationreg to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ubrelationreg to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ubrelationreg to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ubrelationreg to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ubrelationreg is '委托关系限额表';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.priacct is '账号';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.usernotype is '用户号码类型';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.userno is '用户号码(支付项目)';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.usernoareacd is '用户号码地区编码';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.usernoareacdadd is '用户号码附加地区编码';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.acptermnlid is '商户代码';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.paymode is '支付方式标志';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.paymodetype is '支付方式类型';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.paymodeno is '支付方式号码';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.comsiontime is '委托关系期限';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.maxlimitamt is '最高限制金额';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.minlimitamt is '最低限制金额';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.payextent is '支付区间';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.reserve is '代收频率';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.opendt is '签约日期';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.closdt is '解约日期';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.status is '状态 0:关闭无卡支付 1:开通无卡支付 2:小额临时支付';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.relbusitype is '关联业务类型 01 : 有卡自助消费 02 : 无卡自助消费 03 : 互联网消费 04 : 订购 05 : 柜面无卡存款 06 : 自助存款 07 : 自助转账 08 : 互联网转账 09 : 代收 10 : 代付 11 : 预付费卡充值 14 : 无卡自助消费开通或关闭';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.channels is '签约渠道 cnt-柜面 cup-银联 web-网银';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.daymaxamt is '当日最大交易限额';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.snglmaxamt is '单笔最大交易限额';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.mtbrnnbr is '维护网点';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.mttlrnbr is '维护柜员';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.lastdt is '最后维护日期';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.lasttm is '最后维护时间';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a51ubrelationreg.etl_timestamp is 'ETL处理时间戳';
