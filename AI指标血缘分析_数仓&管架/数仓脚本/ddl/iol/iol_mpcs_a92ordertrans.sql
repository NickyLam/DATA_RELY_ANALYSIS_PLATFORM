/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a92ordertrans
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a92ordertrans
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a92ordertrans purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a92ordertrans(
    srcseqno varchar2(96) -- 前端请求流水号
    ,brokerorderno varchar2(96) -- 中台流水号
    ,trantype varchar2(6) -- 交易类型1-购买,2-赎回,3-转换,4-定投扣款,5-设置分红方式,6-强赎
    ,transtime varchar2(24) -- 流水时间
    ,paysys varchar2(15) -- 商户简称 ym
    ,instid varchar2(30) -- 商户号   1022
    ,channel varchar2(48) -- 请求渠道
    ,customno varchar2(45) -- 客户号
    ,accountid varchar2(96) -- 盈米财富账户id
    ,paymenttype varchar2(30) -- 支付方式
    ,paymentmethodid varchar2(96) -- 支付方式id
    ,usewallet varchar2(15) -- 使用盈米宝支付
    ,walletid varchar2(96) -- 盈米宝id
    ,buy varchar2(18) -- 购买类型(022)allot-申购(020)subscribe-认购
    ,fundcode varchar2(96) -- 基金代码
    ,fundname varchar2(384) -- 基金名称
    ,sharetype varchar2(6) -- 收费方式 a-前端收费  b-后端收费 c-c类收费
    ,dividendmethod varchar2(6) -- 分红方式   0-红利资金再投 1-现金分红
    ,ccy varchar2(15) -- 币种    156-人民币
    ,amount varchar2(24) -- 金额
    ,shareid varchar2(96) -- 份额id
    ,tradeshare varchar2(30) -- 份额
    ,ignoreriskgrade varchar2(6) -- 是否忽略基金的风险等级  0-检测风险 1-忽略风险
    ,signecontract varchar2(6) -- 是否签署电子合同
    ,overtimeflag varchar2(6) -- 订单日控制标志
    ,vastlyredeemflag varchar2(6) -- 巨额赎回处理方式  0-取消赎回 1-顺延赎回
    ,redeemtowallet varchar2(6) -- 是否赎回盈米宝
    ,walletfundcode varchar2(96) -- 盈米宝基金代码
    ,isidempotent varchar2(6) -- 幂等模式标志
    ,orderid varchar2(120) -- 订单id
    ,ordercreatedon varchar2(30) -- 订单生成的时间(自然日)
    ,ordercanceledon varchar2(30) -- 撤销订单产生的时间（自然日）
    ,ordertradedate varchar2(15) -- 订单所属的交易申请日期(t日)
    ,orderexpectedconfirmdate varchar2(15) -- 订单的预计确认日期
    ,orderconfirmdate varchar2(15) -- 订单确认日期
    ,setupdate varchar2(15) -- 基金预计成立日期
    ,transferintodate varchar2(15) -- 赎回款项支付日
    ,buymode varchar2(18) -- 购买类型  (022)allot-申购(020)subscribe-认购
    ,isduplicated varchar2(15) -- 幂等模式是否执行
    ,workcode varchar2(30) -- upp交易码
    ,accttype varchar2(30) -- 帐号类型 1-实体卡 2-Ⅱ类账户
    ,payeracct varchar2(51) -- 转出方账户
    ,payername varchar2(210) -- 转出方户名
    ,payeropbk varchar2(21) -- 转出方行号
    ,payeeacct varchar2(51) -- 转入方账户
    ,payeename varchar2(210) -- 转入方户名
    ,payeeopbk varchar2(21) -- 转入方行号
    ,uppfreetrace varchar2(96) -- upp止付请求流水
    ,settldate varchar2(21) -- 清算日期
    ,freezerecordid varchar2(96) -- 冻结编号
    ,upptransid varchar2(96) -- 作为对账流水、解冻时的原流水号（upp流水）
    ,hostdate varchar2(21) -- upp主机日期
    ,hostnbr varchar2(96) -- upp主机流水
    ,status varchar2(6) -- 交易状态0-初始；1-下订单成功；2-下订单失败；3-止付成功；4-止付失败;5-下订单超时；6-upp超时
    ,cdflg varchar2(6) -- 撤单状态0-初始；1-撤单成功；2-撤单失败；3-未知/超时;4-已撤单；
    ,finalstatus varchar2(8) -- 确认状态 0-未确认 1-确认失败 2-确认成功 3-部分确认成功 4-认购成功
    ,tzflg varchar2(6) -- 交易标志：0-联机交易，1-调账交易
    ,isnotesuccess varchar2(6) -- 支付结果通知是否成功0-失败，1-成功 2-未知/超时
    ,payresultnotetime varchar2(30) -- 购买订单支付结果通知的时间（自然日）
    ,successamount varchar2(30) -- 已成功金额
    ,successshare varchar2(30) -- 已成功份额
    ,cdsystrace varchar2(96) -- 撤单中台流水号
    ,cdsystime varchar2(24) -- 撤单时间
    ,checkflag varchar2(2) -- 对账标志 是否已对账：n:否(初始)，y：是
    ,noteflag varchar2(6) -- 通知标志位 n未知 f失败 s成功
    ,notenum varchar2(12) -- 通知次数
    ,updatetime varchar2(24) -- 最新更新时间
    ,remark1 varchar2(75) -- 确认文件对账状态
    ,remark2 varchar2(75) -- 
    ,remark3 varchar2(375) -- 
    ,remark4 varchar2(375) -- 
    ,remark5 varchar2(750) -- 
    ,remark6 varchar2(750) -- 
    ,rspcd varchar2(75) -- 错误码
    ,rspmsg varchar2(750) -- 错误信息
    ,orderstat varchar2(6) -- 0-处理中；1-委托失败；2-委托成功，待ta确认；9-已撤单
    ,destfundcode varchar2(96) -- 转换目标基金代码
    ,destfundname varchar2(384) -- 转换目标基金名称
    ,isriskconfirmhigh varchar2(15) -- 最高风险购买确认
    ,isriskconfirmagain varchar2(15) -- 二次确认
    ,terminalip varchar2(96) -- 终端ip地址
    ,terminaltype varchar2(15) -- 终端类型
    ,terminalinfo varchar2(900) -- 终端相关信息
    ,srcglobseqno varchar2(96) -- 全局流水号
    ,unique_seq_num varchar2(96) -- 业务流水号
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
grant select on ${iol_schema}.mpcs_a92ordertrans to ${iml_schema};
grant select on ${iol_schema}.mpcs_a92ordertrans to ${icl_schema};
grant select on ${iol_schema}.mpcs_a92ordertrans to ${idl_schema};
grant select on ${iol_schema}.mpcs_a92ordertrans to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a92ordertrans is '订单流水表';
comment on column ${iol_schema}.mpcs_a92ordertrans.srcseqno is '前端请求流水号';
comment on column ${iol_schema}.mpcs_a92ordertrans.brokerorderno is '中台流水号';
comment on column ${iol_schema}.mpcs_a92ordertrans.trantype is '交易类型1-购买,2-赎回,3-转换,4-定投扣款,5-设置分红方式,6-强赎';
comment on column ${iol_schema}.mpcs_a92ordertrans.transtime is '流水时间';
comment on column ${iol_schema}.mpcs_a92ordertrans.paysys is '商户简称 ym';
comment on column ${iol_schema}.mpcs_a92ordertrans.instid is '商户号   1022';
comment on column ${iol_schema}.mpcs_a92ordertrans.channel is '请求渠道';
comment on column ${iol_schema}.mpcs_a92ordertrans.customno is '客户号';
comment on column ${iol_schema}.mpcs_a92ordertrans.accountid is '盈米财富账户id';
comment on column ${iol_schema}.mpcs_a92ordertrans.paymenttype is '支付方式';
comment on column ${iol_schema}.mpcs_a92ordertrans.paymentmethodid is '支付方式id';
comment on column ${iol_schema}.mpcs_a92ordertrans.usewallet is '使用盈米宝支付';
comment on column ${iol_schema}.mpcs_a92ordertrans.walletid is '盈米宝id';
comment on column ${iol_schema}.mpcs_a92ordertrans.buy is '购买类型(022)allot-申购(020)subscribe-认购';
comment on column ${iol_schema}.mpcs_a92ordertrans.fundcode is '基金代码';
comment on column ${iol_schema}.mpcs_a92ordertrans.fundname is '基金名称';
comment on column ${iol_schema}.mpcs_a92ordertrans.sharetype is '收费方式 a-前端收费  b-后端收费 c-c类收费';
comment on column ${iol_schema}.mpcs_a92ordertrans.dividendmethod is '分红方式   0-红利资金再投 1-现金分红';
comment on column ${iol_schema}.mpcs_a92ordertrans.ccy is '币种    156-人民币';
comment on column ${iol_schema}.mpcs_a92ordertrans.amount is '金额';
comment on column ${iol_schema}.mpcs_a92ordertrans.shareid is '份额id';
comment on column ${iol_schema}.mpcs_a92ordertrans.tradeshare is '份额';
comment on column ${iol_schema}.mpcs_a92ordertrans.ignoreriskgrade is '是否忽略基金的风险等级  0-检测风险 1-忽略风险';
comment on column ${iol_schema}.mpcs_a92ordertrans.signecontract is '是否签署电子合同';
comment on column ${iol_schema}.mpcs_a92ordertrans.overtimeflag is '订单日控制标志';
comment on column ${iol_schema}.mpcs_a92ordertrans.vastlyredeemflag is '巨额赎回处理方式  0-取消赎回 1-顺延赎回';
comment on column ${iol_schema}.mpcs_a92ordertrans.redeemtowallet is '是否赎回盈米宝';
comment on column ${iol_schema}.mpcs_a92ordertrans.walletfundcode is '盈米宝基金代码';
comment on column ${iol_schema}.mpcs_a92ordertrans.isidempotent is '幂等模式标志';
comment on column ${iol_schema}.mpcs_a92ordertrans.orderid is '订单id';
comment on column ${iol_schema}.mpcs_a92ordertrans.ordercreatedon is '订单生成的时间(自然日)';
comment on column ${iol_schema}.mpcs_a92ordertrans.ordercanceledon is '撤销订单产生的时间（自然日）';
comment on column ${iol_schema}.mpcs_a92ordertrans.ordertradedate is '订单所属的交易申请日期(t日)';
comment on column ${iol_schema}.mpcs_a92ordertrans.orderexpectedconfirmdate is '订单的预计确认日期';
comment on column ${iol_schema}.mpcs_a92ordertrans.orderconfirmdate is '订单确认日期';
comment on column ${iol_schema}.mpcs_a92ordertrans.setupdate is '基金预计成立日期';
comment on column ${iol_schema}.mpcs_a92ordertrans.transferintodate is '赎回款项支付日';
comment on column ${iol_schema}.mpcs_a92ordertrans.buymode is '购买类型  (022)allot-申购(020)subscribe-认购';
comment on column ${iol_schema}.mpcs_a92ordertrans.isduplicated is '幂等模式是否执行';
comment on column ${iol_schema}.mpcs_a92ordertrans.workcode is 'upp交易码';
comment on column ${iol_schema}.mpcs_a92ordertrans.accttype is '帐号类型 1-实体卡 2-Ⅱ类账户';
comment on column ${iol_schema}.mpcs_a92ordertrans.payeracct is '转出方账户';
comment on column ${iol_schema}.mpcs_a92ordertrans.payername is '转出方户名';
comment on column ${iol_schema}.mpcs_a92ordertrans.payeropbk is '转出方行号';
comment on column ${iol_schema}.mpcs_a92ordertrans.payeeacct is '转入方账户';
comment on column ${iol_schema}.mpcs_a92ordertrans.payeename is '转入方户名';
comment on column ${iol_schema}.mpcs_a92ordertrans.payeeopbk is '转入方行号';
comment on column ${iol_schema}.mpcs_a92ordertrans.uppfreetrace is 'upp止付请求流水';
comment on column ${iol_schema}.mpcs_a92ordertrans.settldate is '清算日期';
comment on column ${iol_schema}.mpcs_a92ordertrans.freezerecordid is '冻结编号';
comment on column ${iol_schema}.mpcs_a92ordertrans.upptransid is '作为对账流水、解冻时的原流水号（upp流水）';
comment on column ${iol_schema}.mpcs_a92ordertrans.hostdate is 'upp主机日期';
comment on column ${iol_schema}.mpcs_a92ordertrans.hostnbr is 'upp主机流水';
comment on column ${iol_schema}.mpcs_a92ordertrans.status is '交易状态0-初始；1-下订单成功；2-下订单失败；3-止付成功；4-止付失败;5-下订单超时；6-upp超时';
comment on column ${iol_schema}.mpcs_a92ordertrans.cdflg is '撤单状态0-初始；1-撤单成功；2-撤单失败；3-未知/超时;4-已撤单；';
comment on column ${iol_schema}.mpcs_a92ordertrans.finalstatus is '确认状态 0-未确认 1-确认失败 2-确认成功 3-部分确认成功 4-认购成功';
comment on column ${iol_schema}.mpcs_a92ordertrans.tzflg is '交易标志：0-联机交易，1-调账交易';
comment on column ${iol_schema}.mpcs_a92ordertrans.isnotesuccess is '支付结果通知是否成功0-失败，1-成功 2-未知/超时';
comment on column ${iol_schema}.mpcs_a92ordertrans.payresultnotetime is '购买订单支付结果通知的时间（自然日）';
comment on column ${iol_schema}.mpcs_a92ordertrans.successamount is '已成功金额';
comment on column ${iol_schema}.mpcs_a92ordertrans.successshare is '已成功份额';
comment on column ${iol_schema}.mpcs_a92ordertrans.cdsystrace is '撤单中台流水号';
comment on column ${iol_schema}.mpcs_a92ordertrans.cdsystime is '撤单时间';
comment on column ${iol_schema}.mpcs_a92ordertrans.checkflag is '对账标志 是否已对账：n:否(初始)，y：是';
comment on column ${iol_schema}.mpcs_a92ordertrans.noteflag is '通知标志位 n未知 f失败 s成功';
comment on column ${iol_schema}.mpcs_a92ordertrans.notenum is '通知次数';
comment on column ${iol_schema}.mpcs_a92ordertrans.updatetime is '最新更新时间';
comment on column ${iol_schema}.mpcs_a92ordertrans.remark1 is '确认文件对账状态';
comment on column ${iol_schema}.mpcs_a92ordertrans.remark2 is '';
comment on column ${iol_schema}.mpcs_a92ordertrans.remark3 is '';
comment on column ${iol_schema}.mpcs_a92ordertrans.remark4 is '';
comment on column ${iol_schema}.mpcs_a92ordertrans.remark5 is '';
comment on column ${iol_schema}.mpcs_a92ordertrans.remark6 is '';
comment on column ${iol_schema}.mpcs_a92ordertrans.rspcd is '错误码';
comment on column ${iol_schema}.mpcs_a92ordertrans.rspmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a92ordertrans.orderstat is '0-处理中；1-委托失败；2-委托成功，待ta确认；9-已撤单';
comment on column ${iol_schema}.mpcs_a92ordertrans.destfundcode is '转换目标基金代码';
comment on column ${iol_schema}.mpcs_a92ordertrans.destfundname is '转换目标基金名称';
comment on column ${iol_schema}.mpcs_a92ordertrans.isriskconfirmhigh is '最高风险购买确认';
comment on column ${iol_schema}.mpcs_a92ordertrans.isriskconfirmagain is '二次确认';
comment on column ${iol_schema}.mpcs_a92ordertrans.terminalip is '终端ip地址';
comment on column ${iol_schema}.mpcs_a92ordertrans.terminaltype is '终端类型';
comment on column ${iol_schema}.mpcs_a92ordertrans.terminalinfo is '终端相关信息';
comment on column ${iol_schema}.mpcs_a92ordertrans.srcglobseqno is '全局流水号';
comment on column ${iol_schema}.mpcs_a92ordertrans.unique_seq_num is '业务流水号';
comment on column ${iol_schema}.mpcs_a92ordertrans.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a92ordertrans.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a92ordertrans.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a92ordertrans.etl_timestamp is 'ETL处理时间戳';
