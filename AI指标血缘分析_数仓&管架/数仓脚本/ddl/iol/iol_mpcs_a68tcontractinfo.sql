/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a68tcontractinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a68tcontractinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a68tcontractinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a68tcontractinfo(
    transdt varchar2(12) -- 交易日期
    ,transtm varchar2(9) -- 交易时间
    ,corprtnid varchar2(21) -- 收付费企业代码
    ,pmtid varchar2(48) -- 协议号
    ,reqid varchar2(96) -- 申请号
    ,pmtitmcd varchar2(750) -- 费项列表
    ,pmtitmnm varchar2(1536) -- 费项代码说明
    ,cstmrid varchar2(48) -- 客户号
    ,cstmrnm varchar2(90) -- 客户名称
    ,issr varchar2(21) -- 开户行行号
    ,issrnm varchar2(750) -- 开户行名称
    ,accttype varchar2(2) -- 账户类型
    ,acctid varchar2(48) -- 账号/卡号
    ,ccy varchar2(8) -- 币种
    ,oncddctnlmt varchar2(24) -- 一次扣费限额
    ,cycddctnnumlmt varchar2(24) -- 扣款周期内限制笔数
    ,ctrctduedt varchar2(12) -- 协议到期日期
    ,ctrctsgndt varchar2(12) -- 协议签署日期
    ,ectdt varchar2(12) -- 生效日期
    ,paypersna varchar2(180) -- 缴费人名称
    ,paypersidtp varchar2(3) -- 缴费人证件类型
    ,paypersid varchar2(48) -- 缴费人证件号码
    ,tel varchar2(45) -- 联系电话(预留手机号码)
    ,address varchar2(90) -- 地址
    ,remark varchar2(381) -- 备注/附言
    ,authmodel varchar2(2) -- 授权模式 1-系统透传短信验证码 2-系统透传付款行授权url 3-付款行短信发送授权url 4-非直通式（付款人临柜、使用自助设备或主动登录网上银行、手机银行等）
    ,timeunit varchar2(2) -- 扣款时间单位
    ,timestep varchar2(5) -- 扣款时间步长
    ,timedesc varchar2(360) -- 扣款时间描述
    ,moneylimit varchar2(24) -- 扣款周期内扣费限额
    ,authcode varchar2(30) -- 手机动态码
    ,status varchar2(2) -- 签约状态 z-初始登记 0-等待授权 1-已签约 a-同意授权处理中 r-拒绝授权处理中 c-注销处理中 c-已注销 r-已拒绝 h-授权超时 e-被中心拒绝
    ,errmsg varchar2(750) -- 错误信息
    ,dealinfo varchar2(750) -- 中心处理说明
    ,authtlr varchar2(12) -- 授权柜员
    ,authdt varchar2(12) -- 授权日期
    ,authseqno varchar2(96) -- 授权流水号
    ,authpmtid varchar2(96) -- 授权协议号
    ,sendmsgflag varchar2(2) -- 发送短信标识 0-未发送  1-已发送
    ,otpseqno varchar2(96) -- 短信验证码验证流水
    ,uptm varchar2(21) -- 更新时间
    ,authchl varchar2(3) -- 授权渠道 01：短信验证码回填 02：网上银行 03：手机银行 04：银行h5页面 05：柜面 06：自助设备 07：微信银行 99：其他(应在备注字段写明相应渠道)
    ,margbrn varchar2(18) -- 处理机构(一般开户行)
    ,openbrnnm varchar2(750) -- 开户机构名称(账户查询)
    ,uptransdt varchar2(12) -- 协议变更申请日期
    ,uptranstm varchar2(9) -- 协议变更申请时间
    ,upreqid varchar2(96) -- 协议变更申请号
    ,upctrctduedt varchar2(12) -- 协议变更申请的协议到期日
    ,upauthmodel varchar2(2) -- 协议变更授权模式
    ,upotpseqno varchar2(96) -- 协议变更短信验证流水
    ,upstatus varchar2(2) -- 协议变更状态 0-等待授权  1-同意授权成功 a-同意授权处理中 r-拒绝授权处理中 r-拒绝授权成功 h-授权超时 e-授权处理失败
    ,uperrmsg varchar2(750) -- 协议变更错误信息
    ,upauthdt varchar2(12) -- 协议变更授权日期
    ,upauthseqno varchar2(96) -- 协议授权流水号
    ,upauthtlr varchar2(12) -- 协议变更授权柜员
    ,upauthchl varchar2(3) -- 协议变更授权渠道
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
grant select on ${iol_schema}.mpcs_a68tcontractinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a68tcontractinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a68tcontractinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a68tcontractinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a68tcontractinfo is '';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.transtm is '交易时间';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.corprtnid is '收付费企业代码';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.pmtid is '协议号';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.reqid is '申请号';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.pmtitmcd is '费项列表';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.pmtitmnm is '费项代码说明';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.cstmrid is '客户号';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.cstmrnm is '客户名称';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.issr is '开户行行号';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.issrnm is '开户行名称';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.accttype is '账户类型';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.acctid is '账号/卡号';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.ccy is '币种';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.oncddctnlmt is '一次扣费限额';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.cycddctnnumlmt is '扣款周期内限制笔数';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.ctrctduedt is '协议到期日期';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.ctrctsgndt is '协议签署日期';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.ectdt is '生效日期';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.paypersna is '缴费人名称';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.paypersidtp is '缴费人证件类型';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.paypersid is '缴费人证件号码';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.tel is '联系电话(预留手机号码)';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.address is '地址';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.remark is '备注/附言';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.authmodel is '授权模式 1-系统透传短信验证码 2-系统透传付款行授权url 3-付款行短信发送授权url 4-非直通式（付款人临柜、使用自助设备或主动登录网上银行、手机银行等）';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.timeunit is '扣款时间单位';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.timestep is '扣款时间步长';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.timedesc is '扣款时间描述';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.moneylimit is '扣款周期内扣费限额';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.authcode is '手机动态码';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.status is '签约状态 z-初始登记 0-等待授权 1-已签约 a-同意授权处理中 r-拒绝授权处理中 c-注销处理中 c-已注销 r-已拒绝 h-授权超时 e-被中心拒绝';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.dealinfo is '中心处理说明';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.authtlr is '授权柜员';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.authdt is '授权日期';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.authseqno is '授权流水号';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.authpmtid is '授权协议号';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.sendmsgflag is '发送短信标识 0-未发送  1-已发送';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.otpseqno is '短信验证码验证流水';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.uptm is '更新时间';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.authchl is '授权渠道 01：短信验证码回填 02：网上银行 03：手机银行 04：银行h5页面 05：柜面 06：自助设备 07：微信银行 99：其他(应在备注字段写明相应渠道)';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.margbrn is '处理机构(一般开户行)';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.openbrnnm is '开户机构名称(账户查询)';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.uptransdt is '协议变更申请日期';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.uptranstm is '协议变更申请时间';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.upreqid is '协议变更申请号';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.upctrctduedt is '协议变更申请的协议到期日';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.upauthmodel is '协议变更授权模式';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.upotpseqno is '协议变更短信验证流水';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.upstatus is '协议变更状态 0-等待授权  1-同意授权成功 a-同意授权处理中 r-拒绝授权处理中 r-拒绝授权成功 h-授权超时 e-授权处理失败';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.uperrmsg is '协议变更错误信息';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.upauthdt is '协议变更授权日期';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.upauthseqno is '协议授权流水号';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.upauthtlr is '协议变更授权柜员';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.upauthchl is '协议变更授权渠道';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a68tcontractinfo.etl_timestamp is 'ETL处理时间戳';
