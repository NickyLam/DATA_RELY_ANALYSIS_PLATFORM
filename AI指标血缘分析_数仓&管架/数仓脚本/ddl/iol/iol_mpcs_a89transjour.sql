/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a89transjour
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a89transjour
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a89transjour purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a89transjour(
    srcseqno varchar2(96) -- 前端请求流水号
    ,trmseqnum varchar2(96) -- 终端交易流水号
    ,transcode varchar2(96) -- 光大交易码
    ,trncd varchar2(48) -- 中台交易码
    ,transdate varchar2(15) -- 交易日期
    ,transtime varchar2(15) -- 交易时间
    ,paysys varchar2(15) -- 商户简称
    ,instid varchar2(30) -- 商户机构号
    ,channel varchar2(48) -- 请求渠道号
    ,version varchar2(15) -- 版本号
    ,billkey varchar2(60) -- 机表号
    ,companyid varchar2(60) -- 收费单位标示号
    ,billno varchar2(60) -- 缴费单的流水号
    ,paydate varchar2(30) -- 缴费单支付日期
    ,beginnum varchar2(15) -- 起始笔数
    ,querynum varchar2(15) -- 查询笔数
    ,filed1 varchar2(150) -- 备用字段input2
    ,filed2 varchar2(150) -- 备用字段input3
    ,filed3 varchar2(150) -- 备用字段item1
    ,filed4 varchar2(150) -- 备用字段item2
    ,customername varchar2(210) -- 客户姓名
    ,payaccount varchar2(51) -- 缴费账号
    ,pin varchar2(30) -- 卡密码
    ,payamount varchar2(30) -- 缴费金额
    ,feeamount varchar2(30) -- 手续费
    ,actype varchar2(6) -- 账户类型
    ,contractno varchar2(60) -- 合同号
    ,workcode varchar2(15) -- 核心交易码
    ,payeracct varchar2(51) -- 转出方账户
    ,payername varchar2(210) -- 转出方户名
    ,payeropbk varchar2(21) -- 转出方行号
    ,payeeacct varchar2(51) -- 转入方账户
    ,payeename varchar2(210) -- 转入方户名
    ,payeeopbk varchar2(21) -- 转入方行号
    ,ccy varchar2(6) -- 币种
    ,cbstrace varchar2(96) -- 核心记账请求流水号
    ,settldate varchar2(21) -- 清算日期
    ,dataid varchar2(60) -- 中台记账标识号
    ,status varchar2(6) -- 交易状态：0-初始；1-核心记账成功；2-核心记账失败;3-已冲正;4-光大记账成功;5-核心超时;6-请求光大成功;7-请求光大失败；8-冲正超时
    ,czflg varchar2(6) -- 冲正状态：0-未知/超时；1-冲正成功；2-冲正失败
    ,tzflg varchar2(6) -- 交易标志：0-联机交易，1-调账交易，2-退款交易
    ,rspcode varchar2(30) -- 中台应前端返回码
    ,rspmsg varchar2(384) -- 中台应前端返回信息
    ,hostdate varchar2(15) -- 核心返回交易日期
    ,hosttrace varchar2(30) -- 核心返回交易流水
    ,resseqno varchar2(96) -- 甲方异步应答流水号
    ,bankbillno varchar2(48) -- 光大银行端处理流水
    ,receiptno varchar2(60) -- 打印凭证号码
    ,acctdate varchar2(30) -- 银行端帐务日期
    ,errorcode varchar2(23) -- 错误代码
    ,errormessage varchar2(384) -- 错误描述
    ,errordetail varchar2(768) -- 详细错误信息
    ,czsystrace varchar2(96) -- 冲正中台流水号
    ,czhostdate varchar2(23) -- 冲正核心返回交易日期
    ,czhostnbr varchar2(60) -- 冲正核心返回交易流水
    ,totalnum varchar2(12) -- 总笔数
    ,item1 varchar2(150) -- 备用字段output2
    ,item2 varchar2(150) -- 备用字段output3
    ,item3 varchar2(150) -- 备用字段item1
    ,item4 varchar2(150) -- 备用字段item2
    ,item5 varchar2(150) -- 备用字段item3
    ,item6 varchar2(150) -- 备用字段item4
    ,item7 varchar2(300) -- 备用字段item5
    ,reserve1 varchar2(384) -- 保留域1
    ,reserve2 varchar2(384) -- 保留域2
    ,reserve3 varchar2(384) -- 保留域3
    ,reserve4 varchar2(384) -- 保留域4
    ,reserve5 varchar2(384) -- 保留域5
    ,reserve6 varchar2(384) -- 
    ,reserve7 varchar2(384) -- 
    ,reserve8 varchar2(384) -- 
    ,reserve9 varchar2(384) -- 
    ,reserve10 varchar2(384) -- 
    ,checkflag varchar2(2) -- 对账标志 是否已对账：n:否(初始)，y：是
    ,itemname varchar2(150) -- 缴费项目名称
    ,company varchar2(384) -- 收费事业单位名称
    ,customno varchar2(45) -- 客户号
    ,busiid varchar2(15) -- 缴费种类
    ,cityno varchar2(96) -- 缴费地区，999-全国，广东省-000
    ,cityname varchar2(150) -- 缴费地区名称
    ,balance varchar2(30) -- 余额
    ,begindate varchar2(15) -- 起始日期
    ,enddate varchar2(15) -- 截至日期
    ,qbirfiled1 varchar2(150) -- 查询应答备用字段
    ,qbirfiled2 varchar2(150) -- 查询应答备用字段
    ,qbirfiled3 varchar2(150) -- 查询应答备用字段
    ,qbirfiled4 varchar2(150) -- 查询应答备用字段
    ,qbirfiled5 varchar2(150) -- 查询应答备用字段
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
grant select on ${iol_schema}.mpcs_a89transjour to ${iml_schema};
grant select on ${iol_schema}.mpcs_a89transjour to ${icl_schema};
grant select on ${iol_schema}.mpcs_a89transjour to ${idl_schema};
grant select on ${iol_schema}.mpcs_a89transjour to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a89transjour is '光大代缴交易流水表';
comment on column ${iol_schema}.mpcs_a89transjour.srcseqno is '前端请求流水号';
comment on column ${iol_schema}.mpcs_a89transjour.trmseqnum is '终端交易流水号';
comment on column ${iol_schema}.mpcs_a89transjour.transcode is '光大交易码';
comment on column ${iol_schema}.mpcs_a89transjour.trncd is '中台交易码';
comment on column ${iol_schema}.mpcs_a89transjour.transdate is '交易日期';
comment on column ${iol_schema}.mpcs_a89transjour.transtime is '交易时间';
comment on column ${iol_schema}.mpcs_a89transjour.paysys is '商户简称';
comment on column ${iol_schema}.mpcs_a89transjour.instid is '商户机构号';
comment on column ${iol_schema}.mpcs_a89transjour.channel is '请求渠道号';
comment on column ${iol_schema}.mpcs_a89transjour.version is '版本号';
comment on column ${iol_schema}.mpcs_a89transjour.billkey is '机表号';
comment on column ${iol_schema}.mpcs_a89transjour.companyid is '收费单位标示号';
comment on column ${iol_schema}.mpcs_a89transjour.billno is '缴费单的流水号';
comment on column ${iol_schema}.mpcs_a89transjour.paydate is '缴费单支付日期';
comment on column ${iol_schema}.mpcs_a89transjour.beginnum is '起始笔数';
comment on column ${iol_schema}.mpcs_a89transjour.querynum is '查询笔数';
comment on column ${iol_schema}.mpcs_a89transjour.filed1 is '备用字段input2';
comment on column ${iol_schema}.mpcs_a89transjour.filed2 is '备用字段input3';
comment on column ${iol_schema}.mpcs_a89transjour.filed3 is '备用字段item1';
comment on column ${iol_schema}.mpcs_a89transjour.filed4 is '备用字段item2';
comment on column ${iol_schema}.mpcs_a89transjour.customername is '客户姓名';
comment on column ${iol_schema}.mpcs_a89transjour.payaccount is '缴费账号';
comment on column ${iol_schema}.mpcs_a89transjour.pin is '卡密码';
comment on column ${iol_schema}.mpcs_a89transjour.payamount is '缴费金额';
comment on column ${iol_schema}.mpcs_a89transjour.feeamount is '手续费';
comment on column ${iol_schema}.mpcs_a89transjour.actype is '账户类型';
comment on column ${iol_schema}.mpcs_a89transjour.contractno is '合同号';
comment on column ${iol_schema}.mpcs_a89transjour.workcode is '核心交易码';
comment on column ${iol_schema}.mpcs_a89transjour.payeracct is '转出方账户';
comment on column ${iol_schema}.mpcs_a89transjour.payername is '转出方户名';
comment on column ${iol_schema}.mpcs_a89transjour.payeropbk is '转出方行号';
comment on column ${iol_schema}.mpcs_a89transjour.payeeacct is '转入方账户';
comment on column ${iol_schema}.mpcs_a89transjour.payeename is '转入方户名';
comment on column ${iol_schema}.mpcs_a89transjour.payeeopbk is '转入方行号';
comment on column ${iol_schema}.mpcs_a89transjour.ccy is '币种';
comment on column ${iol_schema}.mpcs_a89transjour.cbstrace is '核心记账请求流水号';
comment on column ${iol_schema}.mpcs_a89transjour.settldate is '清算日期';
comment on column ${iol_schema}.mpcs_a89transjour.dataid is '中台记账标识号';
comment on column ${iol_schema}.mpcs_a89transjour.status is '交易状态：0-初始；1-核心记账成功；2-核心记账失败;3-已冲正;4-光大记账成功;5-核心超时;6-请求光大成功;7-请求光大失败；8-冲正超时';
comment on column ${iol_schema}.mpcs_a89transjour.czflg is '冲正状态：0-未知/超时；1-冲正成功；2-冲正失败';
comment on column ${iol_schema}.mpcs_a89transjour.tzflg is '交易标志：0-联机交易，1-调账交易，2-退款交易';
comment on column ${iol_schema}.mpcs_a89transjour.rspcode is '中台应前端返回码';
comment on column ${iol_schema}.mpcs_a89transjour.rspmsg is '中台应前端返回信息';
comment on column ${iol_schema}.mpcs_a89transjour.hostdate is '核心返回交易日期';
comment on column ${iol_schema}.mpcs_a89transjour.hosttrace is '核心返回交易流水';
comment on column ${iol_schema}.mpcs_a89transjour.resseqno is '甲方异步应答流水号';
comment on column ${iol_schema}.mpcs_a89transjour.bankbillno is '光大银行端处理流水';
comment on column ${iol_schema}.mpcs_a89transjour.receiptno is '打印凭证号码';
comment on column ${iol_schema}.mpcs_a89transjour.acctdate is '银行端帐务日期';
comment on column ${iol_schema}.mpcs_a89transjour.errorcode is '错误代码';
comment on column ${iol_schema}.mpcs_a89transjour.errormessage is '错误描述';
comment on column ${iol_schema}.mpcs_a89transjour.errordetail is '详细错误信息';
comment on column ${iol_schema}.mpcs_a89transjour.czsystrace is '冲正中台流水号';
comment on column ${iol_schema}.mpcs_a89transjour.czhostdate is '冲正核心返回交易日期';
comment on column ${iol_schema}.mpcs_a89transjour.czhostnbr is '冲正核心返回交易流水';
comment on column ${iol_schema}.mpcs_a89transjour.totalnum is '总笔数';
comment on column ${iol_schema}.mpcs_a89transjour.item1 is '备用字段output2';
comment on column ${iol_schema}.mpcs_a89transjour.item2 is '备用字段output3';
comment on column ${iol_schema}.mpcs_a89transjour.item3 is '备用字段item1';
comment on column ${iol_schema}.mpcs_a89transjour.item4 is '备用字段item2';
comment on column ${iol_schema}.mpcs_a89transjour.item5 is '备用字段item3';
comment on column ${iol_schema}.mpcs_a89transjour.item6 is '备用字段item4';
comment on column ${iol_schema}.mpcs_a89transjour.item7 is '备用字段item5';
comment on column ${iol_schema}.mpcs_a89transjour.reserve1 is '保留域1';
comment on column ${iol_schema}.mpcs_a89transjour.reserve2 is '保留域2';
comment on column ${iol_schema}.mpcs_a89transjour.reserve3 is '保留域3';
comment on column ${iol_schema}.mpcs_a89transjour.reserve4 is '保留域4';
comment on column ${iol_schema}.mpcs_a89transjour.reserve5 is '保留域5';
comment on column ${iol_schema}.mpcs_a89transjour.reserve6 is '';
comment on column ${iol_schema}.mpcs_a89transjour.reserve7 is '';
comment on column ${iol_schema}.mpcs_a89transjour.reserve8 is '';
comment on column ${iol_schema}.mpcs_a89transjour.reserve9 is '';
comment on column ${iol_schema}.mpcs_a89transjour.reserve10 is '';
comment on column ${iol_schema}.mpcs_a89transjour.checkflag is '对账标志 是否已对账：n:否(初始)，y：是';
comment on column ${iol_schema}.mpcs_a89transjour.itemname is '缴费项目名称';
comment on column ${iol_schema}.mpcs_a89transjour.company is '收费事业单位名称';
comment on column ${iol_schema}.mpcs_a89transjour.customno is '客户号';
comment on column ${iol_schema}.mpcs_a89transjour.busiid is '缴费种类';
comment on column ${iol_schema}.mpcs_a89transjour.cityno is '缴费地区，999-全国，广东省-000';
comment on column ${iol_schema}.mpcs_a89transjour.cityname is '缴费地区名称';
comment on column ${iol_schema}.mpcs_a89transjour.balance is '余额';
comment on column ${iol_schema}.mpcs_a89transjour.begindate is '起始日期';
comment on column ${iol_schema}.mpcs_a89transjour.enddate is '截至日期';
comment on column ${iol_schema}.mpcs_a89transjour.qbirfiled1 is '查询应答备用字段';
comment on column ${iol_schema}.mpcs_a89transjour.qbirfiled2 is '查询应答备用字段';
comment on column ${iol_schema}.mpcs_a89transjour.qbirfiled3 is '查询应答备用字段';
comment on column ${iol_schema}.mpcs_a89transjour.qbirfiled4 is '查询应答备用字段';
comment on column ${iol_schema}.mpcs_a89transjour.qbirfiled5 is '查询应答备用字段';
comment on column ${iol_schema}.mpcs_a89transjour.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a89transjour.etl_timestamp is 'ETL处理时间戳';
