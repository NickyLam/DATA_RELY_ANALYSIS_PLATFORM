/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a86payseqno
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a86payseqno
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a86payseqno purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a86payseqno(
    transtime varchar2(21) -- 操作时间
    ,aleseqno varchar2(48) -- 中台流水号
    ,paysys varchar2(2) -- 0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他
    ,transtype varchar2(12) -- 交易类型
    ,interfaceversion varchar2(15) -- 接口版本号
    ,transtimesource varchar2(21) -- 发起方交易时间yyyymmddhhmmss
    ,transtimedestination varchar2(21) -- 接收方交易时间yyyymmddhhmmss
    ,transnosource varchar2(39) -- 交易发起方流水号
    ,transnodestination varchar2(39) -- 交易接收方流水号
    ,source varchar2(15) -- 报文请求方
    ,destination varchar2(15) -- 报文接收方
    ,custno varchar2(30) -- 客户号
    ,seid varchar2(96) -- 安全芯片所对应的标识符
    ,span varchar2(29) -- 标准卡主账号
    ,newspan varchar2(29) -- 新的标准实体银行卡
    ,spanid varchar2(150) -- 标准卡主账号对应的标识符
    ,mpan varchar2(150) -- 移动设备卡主账号
    ,mpanid varchar2(150) -- 设备卡主账号对应的标识符
    ,mstpan varchar2(150) -- 移动mst设备卡主账号
    ,mstpanid varchar2(150) -- 移动mst设备卡主账号对应的标识符
    ,mappingstatus varchar2(3) -- 映射关系状态 00初始 01可用 02锁定 03注销
    ,mpanpersoresult varchar2(768) -- mpan应用个人化执行结果
    ,setype varchar2(15) -- 前4位 1011 apple产品  0011全手机模式
    ,seissuer varchar2(30) -- 前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派
    ,instanceaid varchar2(48) -- 应用安装实例aid
    ,expirydate varchar2(15) -- 有效期，mmyy
    ,cvn2 varchar2(6) -- cvn2
    ,pin varchar2(24) -- 密码
    ,custname varchar2(60) -- 持卡人姓名
    ,idtype varchar2(3) -- 证件类型
    ,idno varchar2(30) -- 证件号码
    ,phone varchar2(30) -- 手机号
    ,initquota varchar2(30) -- 免密限额
    ,cardartid varchar2(60) -- 卡面配置方案id
    ,invaluedate varchar2(15) -- 卡面有效期
    ,applychannel varchar2(5) -- 用户申请的渠道(00，01，02，03)
    ,bankchanneldata varchar2(1536) -- 银行渠道自有的数据
    ,termandconditionid varchar2(105) -- 用户签署协议和条款对应的id
    ,termandconditionaccepteddate varchar2(60) -- 用户接受协议和条款的日期和具体时间
    ,accountscore varchar2(3) -- 账户评分,取值从1到5。分值越高，代表该设备的可信度越高
    ,devicescore varchar2(3) -- 设备厂商给设备的评分，取值从1到5。分值越高，代表该设备的可信度越高
    ,sourcelp varchar2(24) -- 源 ip,设备厂商提供的一个信息，用于合规性检查。
    ,color varchar2(15) -- 设备厂商建议的加载流程对应颜色级别。 目前仅用于apple pay项目。
    ,reasoncodes varchar2(150) -- 设备厂商给出的颜色判断原因， 只在建议选择黄色流程的时候才出现， 解释为什么要建议选择黄色流程。 目前仅用于apple pay项目。
    ,devicetype varchar2(3) -- 设备厂商自己对用来做交易的设备类型所做的编码， 每类设备对应一个整数值， 取值范围从1至99。 目前仅在apple pay项目中出现。
    ,devicename varchar2(150) -- 用户给设备所添加的设备别名，比如“**的iphone”。
    ,devicenumber varchar2(8) -- 用来做设备卡加载时用户设备所对应的手机号码后四位数字。
    ,fulldevicenumber varchar2(30) -- 用来做设备卡加载时用户设备所对应的完整手机号码。
    ,phonenumberscore varchar2(3) -- 手机号信任级,copper建议的加载流程对应手机号信任评级级别。
    ,accountidhash varchar2(96) -- 用来标识用户在全手机厂商的登录账号id信息的哈希值，与用户登录账号id是一一对应关系。 目前仅用于apple pay项目
    ,devicelocation varchar2(15) -- 用来做设备卡加载时的用户设备位置信息，按照“纬度/经度”格式填写
    ,extensivedevicelocation varchar2(30) -- 用来做设备卡加载时的用户设备位置信息，按照“纬度/经度”格式填写, 但精度比devicelocationtype更高，有小数点
    ,billingaddress varchar2(384) -- 用户账单地址信息；
    ,billingzip varchar2(30) -- 用户账单邮编信息；
    ,colorstandardsversion varchar2(15) -- 设备厂商给出加载流程颜色建议时所基于的颜色判断原则对应的版本。 目前仅用于apple pay项目，取值从“0001.00”开始。
    ,cardholdername varchar2(60) -- 持卡人姓名
    ,itunesemaillife varchar2(6) -- 邮箱变更时间,数值范围：0-24，表示0-24个月
    ,capturemethod varchar2(9) -- 卡号录入方式，手输入卡号还是摄像头捕捉。(00,01)
    ,casdcertinfo varchar2(768) -- 前端提供的casd证书信息， 目前仅用于apple pay项目
    ,statuscode varchar2(24) -- 
    ,statusdescription varchar2(384) -- 
    ,storeidentifier varchar2(240) -- storeidentifier
    ,applicationid varchar2(300) -- application 标识符
    ,otptype varchar2(48) -- otp类型，目前支持手机动态验 证||电子邮件动态验证||客户 服务||银行客户端等四种方式
    ,otpresolutionvalue varchar2(96) -- 每种otp方法具体对应到用户的具体取值：对于手机动态验证，即为用户用于接收动态验证的手机号码；对于电子邮件动态验证，即为用户用于接收动态验证的电子邮件地址；对于客户服务，即为银行客服电话；对于银行客户端，即为客户端地址；
    ,otpresolutionid varchar2(48) -- 每种otp方法所对应的标识号，由银行生成
    ,otpsourceaddress varchar2(96) -- 银行发送otp的源地址，如银行提供该字段，则默认支持手机设备自动截取otp并填写；
    ,otp varchar2(12) -- 用户输入的0tp信息
    ,operationchannelid varchar2(6) -- 标识当前发起该变更操作的渠道方；（00，01，02，03）
    ,operationreason varchar2(384) -- 标识当前变更操作的变更原因
    ,applyexceptionresult varchar2(6) -- 移动设备卡申请异常处理结果(01,10,11,12,13,20,21,22,23,24,25,26,27,28,29)
    ,exceptionresultreason varchar2(384) -- 移动设备卡申请异常处理结果原因描述
    ,taskid varchar2(96) -- task id
    ,ecashbalance varchar2(75) -- 电子现金余额，本元素中取值不带小数点。 当币种为人民币时， 本元素的最右两位表示人民币的角和分。
    ,blacklistcategory varchar2(3) -- 黑名单类型(00,01,02,03)
    ,blackinvalidtime varchar2(21) -- 该pan号对应的黑名单失效时间
    ,blackoperationtype varchar2(2) -- 建议的操作类型（增加或删除）(i,d)
    ,transactionid varchar2(48) -- 当出现mpanid且交易为uics交易 时出现；
    ,transactiontype varchar2(48) -- 交易类型(purchase、 refund、 preauthorized、 preauthorizeddone 、 cashatm、 depositatm、 transferatm)
    ,transactiondate varchar2(48) -- 交易曰期
    ,currencycode varchar2(8) -- 货币代码
    ,transactionamount varchar2(24) -- 交易金额
    ,transactionstatus varchar2(48) -- 交易状态(approved （交易成功） 、 declined （交易被拒绝） 、 pending （交易处理中） 和refunded （已退款）)
    ,merchantname varchar2(96) -- 商户名称
    ,rawmerchantname varchar2(96) -- 商户原始名称
    ,industrycategory varchar2(48) -- 行业分类
    ,industrycode varchar2(6) -- 行业代码
    ,geolocation varchar2(14) -- 地理位置信息
    ,paninputmode varchar2(8) -- pan输入方式(00,01,02)
    ,mac varchar2(48) -- message authentication code
    ,notflag varchar2(6) -- 通知标志位 n未知 f失败 s成功
    ,notnum varchar2(12) -- 通知次数
    ,remark1 varchar2(300) -- 
    ,remark2 varchar2(300) -- 
    ,remark3 varchar2(768) -- 
    ,remark4 varchar2(768) -- 
    ,idecheck varchar2(3) -- 身份验证 0-初始，1-成功，2-失败
    ,srcseqno varchar2(96) -- 前端流水号
    ,operationresult varchar2(3) -- task id操作执行结果(00,01)
    ,blackpan varchar2(150) -- 黑名单帐号
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
grant select on ${iol_schema}.mpcs_a86payseqno to ${iml_schema};
grant select on ${iol_schema}.mpcs_a86payseqno to ${icl_schema};
grant select on ${iol_schema}.mpcs_a86payseqno to ${idl_schema};
grant select on ${iol_schema}.mpcs_a86payseqno to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a86payseqno is 'PAY交易流水表';
comment on column ${iol_schema}.mpcs_a86payseqno.transtime is '操作时间';
comment on column ${iol_schema}.mpcs_a86payseqno.aleseqno is '中台流水号';
comment on column ${iol_schema}.mpcs_a86payseqno.paysys is '0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他';
comment on column ${iol_schema}.mpcs_a86payseqno.transtype is '交易类型';
comment on column ${iol_schema}.mpcs_a86payseqno.interfaceversion is '接口版本号';
comment on column ${iol_schema}.mpcs_a86payseqno.transtimesource is '发起方交易时间yyyymmddhhmmss';
comment on column ${iol_schema}.mpcs_a86payseqno.transtimedestination is '接收方交易时间yyyymmddhhmmss';
comment on column ${iol_schema}.mpcs_a86payseqno.transnosource is '交易发起方流水号';
comment on column ${iol_schema}.mpcs_a86payseqno.transnodestination is '交易接收方流水号';
comment on column ${iol_schema}.mpcs_a86payseqno.source is '报文请求方';
comment on column ${iol_schema}.mpcs_a86payseqno.destination is '报文接收方';
comment on column ${iol_schema}.mpcs_a86payseqno.custno is '客户号';
comment on column ${iol_schema}.mpcs_a86payseqno.seid is '安全芯片所对应的标识符';
comment on column ${iol_schema}.mpcs_a86payseqno.span is '标准卡主账号';
comment on column ${iol_schema}.mpcs_a86payseqno.newspan is '新的标准实体银行卡';
comment on column ${iol_schema}.mpcs_a86payseqno.spanid is '标准卡主账号对应的标识符';
comment on column ${iol_schema}.mpcs_a86payseqno.mpan is '移动设备卡主账号';
comment on column ${iol_schema}.mpcs_a86payseqno.mpanid is '设备卡主账号对应的标识符';
comment on column ${iol_schema}.mpcs_a86payseqno.mstpan is '移动mst设备卡主账号';
comment on column ${iol_schema}.mpcs_a86payseqno.mstpanid is '移动mst设备卡主账号对应的标识符';
comment on column ${iol_schema}.mpcs_a86payseqno.mappingstatus is '映射关系状态 00初始 01可用 02锁定 03注销';
comment on column ${iol_schema}.mpcs_a86payseqno.mpanpersoresult is 'mpan应用个人化执行结果';
comment on column ${iol_schema}.mpcs_a86payseqno.setype is '前4位 1011 apple产品  0011全手机模式';
comment on column ${iol_schema}.mpcs_a86payseqno.seissuer is '前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派';
comment on column ${iol_schema}.mpcs_a86payseqno.instanceaid is '应用安装实例aid';
comment on column ${iol_schema}.mpcs_a86payseqno.expirydate is '有效期，mmyy';
comment on column ${iol_schema}.mpcs_a86payseqno.cvn2 is 'cvn2';
comment on column ${iol_schema}.mpcs_a86payseqno.pin is '密码';
comment on column ${iol_schema}.mpcs_a86payseqno.custname is '持卡人姓名';
comment on column ${iol_schema}.mpcs_a86payseqno.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a86payseqno.idno is '证件号码';
comment on column ${iol_schema}.mpcs_a86payseqno.phone is '手机号';
comment on column ${iol_schema}.mpcs_a86payseqno.initquota is '免密限额';
comment on column ${iol_schema}.mpcs_a86payseqno.cardartid is '卡面配置方案id';
comment on column ${iol_schema}.mpcs_a86payseqno.invaluedate is '卡面有效期';
comment on column ${iol_schema}.mpcs_a86payseqno.applychannel is '用户申请的渠道(00，01，02，03)';
comment on column ${iol_schema}.mpcs_a86payseqno.bankchanneldata is '银行渠道自有的数据';
comment on column ${iol_schema}.mpcs_a86payseqno.termandconditionid is '用户签署协议和条款对应的id';
comment on column ${iol_schema}.mpcs_a86payseqno.termandconditionaccepteddate is '用户接受协议和条款的日期和具体时间';
comment on column ${iol_schema}.mpcs_a86payseqno.accountscore is '账户评分,取值从1到5。分值越高，代表该设备的可信度越高';
comment on column ${iol_schema}.mpcs_a86payseqno.devicescore is '设备厂商给设备的评分，取值从1到5。分值越高，代表该设备的可信度越高';
comment on column ${iol_schema}.mpcs_a86payseqno.sourcelp is '源 ip,设备厂商提供的一个信息，用于合规性检查。';
comment on column ${iol_schema}.mpcs_a86payseqno.color is '设备厂商建议的加载流程对应颜色级别。 目前仅用于apple pay项目。';
comment on column ${iol_schema}.mpcs_a86payseqno.reasoncodes is '设备厂商给出的颜色判断原因， 只在建议选择黄色流程的时候才出现， 解释为什么要建议选择黄色流程。 目前仅用于apple pay项目。';
comment on column ${iol_schema}.mpcs_a86payseqno.devicetype is '设备厂商自己对用来做交易的设备类型所做的编码， 每类设备对应一个整数值， 取值范围从1至99。 目前仅在apple pay项目中出现。';
comment on column ${iol_schema}.mpcs_a86payseqno.devicename is '用户给设备所添加的设备别名，比如“**的iphone”。';
comment on column ${iol_schema}.mpcs_a86payseqno.devicenumber is '用来做设备卡加载时用户设备所对应的手机号码后四位数字。';
comment on column ${iol_schema}.mpcs_a86payseqno.fulldevicenumber is '用来做设备卡加载时用户设备所对应的完整手机号码。';
comment on column ${iol_schema}.mpcs_a86payseqno.phonenumberscore is '手机号信任级,copper建议的加载流程对应手机号信任评级级别。';
comment on column ${iol_schema}.mpcs_a86payseqno.accountidhash is '用来标识用户在全手机厂商的登录账号id信息的哈希值，与用户登录账号id是一一对应关系。 目前仅用于apple pay项目';
comment on column ${iol_schema}.mpcs_a86payseqno.devicelocation is '用来做设备卡加载时的用户设备位置信息，按照“纬度/经度”格式填写';
comment on column ${iol_schema}.mpcs_a86payseqno.extensivedevicelocation is '用来做设备卡加载时的用户设备位置信息，按照“纬度/经度”格式填写, 但精度比devicelocationtype更高，有小数点';
comment on column ${iol_schema}.mpcs_a86payseqno.billingaddress is '用户账单地址信息；';
comment on column ${iol_schema}.mpcs_a86payseqno.billingzip is '用户账单邮编信息；';
comment on column ${iol_schema}.mpcs_a86payseqno.colorstandardsversion is '设备厂商给出加载流程颜色建议时所基于的颜色判断原则对应的版本。 目前仅用于apple pay项目，取值从“0001.00”开始。';
comment on column ${iol_schema}.mpcs_a86payseqno.cardholdername is '持卡人姓名';
comment on column ${iol_schema}.mpcs_a86payseqno.itunesemaillife is '邮箱变更时间,数值范围：0-24，表示0-24个月';
comment on column ${iol_schema}.mpcs_a86payseqno.capturemethod is '卡号录入方式，手输入卡号还是摄像头捕捉。(00,01)';
comment on column ${iol_schema}.mpcs_a86payseqno.casdcertinfo is '前端提供的casd证书信息， 目前仅用于apple pay项目';
comment on column ${iol_schema}.mpcs_a86payseqno.statuscode is '';
comment on column ${iol_schema}.mpcs_a86payseqno.statusdescription is '';
comment on column ${iol_schema}.mpcs_a86payseqno.storeidentifier is 'storeidentifier';
comment on column ${iol_schema}.mpcs_a86payseqno.applicationid is 'application 标识符';
comment on column ${iol_schema}.mpcs_a86payseqno.otptype is 'otp类型，目前支持手机动态验 证||电子邮件动态验证||客户 服务||银行客户端等四种方式';
comment on column ${iol_schema}.mpcs_a86payseqno.otpresolutionvalue is '每种otp方法具体对应到用户的具体取值：对于手机动态验证，即为用户用于接收动态验证的手机号码；对于电子邮件动态验证，即为用户用于接收动态验证的电子邮件地址；对于客户服务，即为银行客服电话；对于银行客户端，即为客户端地址；';
comment on column ${iol_schema}.mpcs_a86payseqno.otpresolutionid is '每种otp方法所对应的标识号，由银行生成';
comment on column ${iol_schema}.mpcs_a86payseqno.otpsourceaddress is '银行发送otp的源地址，如银行提供该字段，则默认支持手机设备自动截取otp并填写；';
comment on column ${iol_schema}.mpcs_a86payseqno.otp is '用户输入的0tp信息';
comment on column ${iol_schema}.mpcs_a86payseqno.operationchannelid is '标识当前发起该变更操作的渠道方；（00，01，02，03）';
comment on column ${iol_schema}.mpcs_a86payseqno.operationreason is '标识当前变更操作的变更原因';
comment on column ${iol_schema}.mpcs_a86payseqno.applyexceptionresult is '移动设备卡申请异常处理结果(01,10,11,12,13,20,21,22,23,24,25,26,27,28,29)';
comment on column ${iol_schema}.mpcs_a86payseqno.exceptionresultreason is '移动设备卡申请异常处理结果原因描述';
comment on column ${iol_schema}.mpcs_a86payseqno.taskid is 'task id';
comment on column ${iol_schema}.mpcs_a86payseqno.ecashbalance is '电子现金余额，本元素中取值不带小数点。 当币种为人民币时， 本元素的最右两位表示人民币的角和分。';
comment on column ${iol_schema}.mpcs_a86payseqno.blacklistcategory is '黑名单类型(00,01,02,03)';
comment on column ${iol_schema}.mpcs_a86payseqno.blackinvalidtime is '该pan号对应的黑名单失效时间';
comment on column ${iol_schema}.mpcs_a86payseqno.blackoperationtype is '建议的操作类型（增加或删除）(i,d)';
comment on column ${iol_schema}.mpcs_a86payseqno.transactionid is '当出现mpanid且交易为uics交易 时出现；';
comment on column ${iol_schema}.mpcs_a86payseqno.transactiontype is '交易类型(purchase、 refund、 preauthorized、 preauthorizeddone 、 cashatm、 depositatm、 transferatm)';
comment on column ${iol_schema}.mpcs_a86payseqno.transactiondate is '交易曰期';
comment on column ${iol_schema}.mpcs_a86payseqno.currencycode is '货币代码';
comment on column ${iol_schema}.mpcs_a86payseqno.transactionamount is '交易金额';
comment on column ${iol_schema}.mpcs_a86payseqno.transactionstatus is '交易状态(approved （交易成功） 、 declined （交易被拒绝） 、 pending （交易处理中） 和refunded （已退款）)';
comment on column ${iol_schema}.mpcs_a86payseqno.merchantname is '商户名称';
comment on column ${iol_schema}.mpcs_a86payseqno.rawmerchantname is '商户原始名称';
comment on column ${iol_schema}.mpcs_a86payseqno.industrycategory is '行业分类';
comment on column ${iol_schema}.mpcs_a86payseqno.industrycode is '行业代码';
comment on column ${iol_schema}.mpcs_a86payseqno.geolocation is '地理位置信息';
comment on column ${iol_schema}.mpcs_a86payseqno.paninputmode is 'pan输入方式(00,01,02)';
comment on column ${iol_schema}.mpcs_a86payseqno.mac is 'message authentication code';
comment on column ${iol_schema}.mpcs_a86payseqno.notflag is '通知标志位 n未知 f失败 s成功';
comment on column ${iol_schema}.mpcs_a86payseqno.notnum is '通知次数';
comment on column ${iol_schema}.mpcs_a86payseqno.remark1 is '';
comment on column ${iol_schema}.mpcs_a86payseqno.remark2 is '';
comment on column ${iol_schema}.mpcs_a86payseqno.remark3 is '';
comment on column ${iol_schema}.mpcs_a86payseqno.remark4 is '';
comment on column ${iol_schema}.mpcs_a86payseqno.idecheck is '身份验证 0-初始，1-成功，2-失败';
comment on column ${iol_schema}.mpcs_a86payseqno.srcseqno is '前端流水号';
comment on column ${iol_schema}.mpcs_a86payseqno.operationresult is 'task id操作执行结果(00,01)';
comment on column ${iol_schema}.mpcs_a86payseqno.blackpan is '黑名单帐号';
comment on column ${iol_schema}.mpcs_a86payseqno.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a86payseqno.etl_timestamp is 'ETL处理时间戳';
