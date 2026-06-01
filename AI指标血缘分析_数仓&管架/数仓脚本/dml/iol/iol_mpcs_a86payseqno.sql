/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a86payseqno
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a86payseqno_ex purge;
alter table ${iol_schema}.mpcs_a86payseqno add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a86payseqno truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a86payseqno_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a86payseqno where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a86payseqno_ex(
    transtime -- 操作时间
    ,aleseqno -- 中台流水号
    ,paysys -- 0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他
    ,transtype -- 交易类型
    ,interfaceversion -- 接口版本号
    ,transtimesource -- 发起方交易时间yyyymmddhhmmss
    ,transtimedestination -- 接收方交易时间yyyymmddhhmmss
    ,transnosource -- 交易发起方流水号
    ,transnodestination -- 交易接收方流水号
    ,source -- 报文请求方
    ,destination -- 报文接收方
    ,custno -- 客户号
    ,seid -- 安全芯片所对应的标识符
    ,span -- 标准卡主账号
    ,newspan -- 新的标准实体银行卡
    ,spanid -- 标准卡主账号对应的标识符
    ,mpan -- 移动设备卡主账号
    ,mpanid -- 设备卡主账号对应的标识符
    ,mstpan -- 移动mst设备卡主账号
    ,mstpanid -- 移动mst设备卡主账号对应的标识符
    ,mappingstatus -- 映射关系状态 00初始 01可用 02锁定 03注销
    ,mpanpersoresult -- mpan应用个人化执行结果
    ,setype -- 前4位 1011 apple产品  0011全手机模式
    ,seissuer -- 前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派
    ,instanceaid -- 应用安装实例aid
    ,expirydate -- 有效期，mmyy
    ,cvn2 -- cvn2
    ,pin -- 密码
    ,custname -- 持卡人姓名
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,phone -- 手机号
    ,initquota -- 免密限额
    ,cardartid -- 卡面配置方案id
    ,invaluedate -- 卡面有效期
    ,applychannel -- 用户申请的渠道(00，01，02，03)
    ,bankchanneldata -- 银行渠道自有的数据
    ,termandconditionid -- 用户签署协议和条款对应的id
    ,termandconditionaccepteddate -- 用户接受协议和条款的日期和具体时间
    ,accountscore -- 账户评分,取值从1到5。分值越高，代表该设备的可信度越高
    ,devicescore -- 设备厂商给设备的评分，取值从1到5。分值越高，代表该设备的可信度越高
    ,sourcelp -- 源 ip,设备厂商提供的一个信息，用于合规性检查。
    ,color -- 设备厂商建议的加载流程对应颜色级别。 目前仅用于apple pay项目。
    ,reasoncodes -- 设备厂商给出的颜色判断原因， 只在建议选择黄色流程的时候才出现， 解释为什么要建议选择黄色流程。 目前仅用于apple pay项目。
    ,devicetype -- 设备厂商自己对用来做交易的设备类型所做的编码， 每类设备对应一个整数值， 取值范围从1至99。 目前仅在apple pay项目中出现。
    ,devicename -- 用户给设备所添加的设备别名，比如“**的iphone”。
    ,devicenumber -- 用来做设备卡加载时用户设备所对应的手机号码后四位数字。
    ,fulldevicenumber -- 用来做设备卡加载时用户设备所对应的完整手机号码。
    ,phonenumberscore -- 手机号信任级,copper建议的加载流程对应手机号信任评级级别。
    ,accountidhash -- 用来标识用户在全手机厂商的登录账号id信息的哈希值，与用户登录账号id是一一对应关系。 目前仅用于apple pay项目
    ,devicelocation -- 用来做设备卡加载时的用户设备位置信息，按照“纬度/经度”格式填写
    ,extensivedevicelocation -- 用来做设备卡加载时的用户设备位置信息，按照“纬度/经度”格式填写, 但精度比devicelocationtype更高，有小数点
    ,billingaddress -- 用户账单地址信息；
    ,billingzip -- 用户账单邮编信息；
    ,colorstandardsversion -- 设备厂商给出加载流程颜色建议时所基于的颜色判断原则对应的版本。 目前仅用于apple pay项目，取值从“0001.00”开始。
    ,cardholdername -- 持卡人姓名
    ,itunesemaillife -- 邮箱变更时间,数值范围：0-24，表示0-24个月
    ,capturemethod -- 卡号录入方式，手输入卡号还是摄像头捕捉。(00,01)
    ,casdcertinfo -- 前端提供的casd证书信息， 目前仅用于apple pay项目
    ,statuscode -- 
    ,statusdescription -- 
    ,storeidentifier -- storeidentifier
    ,applicationid -- application 标识符
    ,otptype -- otp类型，目前支持手机动态验 证||电子邮件动态验证||客户 服务||银行客户端等四种方式
    ,otpresolutionvalue -- 每种otp方法具体对应到用户的具体取值：对于手机动态验证，即为用户用于接收动态验证的手机号码；对于电子邮件动态验证，即为用户用于接收动态验证的电子邮件地址；对于客户服务，即为银行客服电话；对于银行客户端，即为客户端地址；
    ,otpresolutionid -- 每种otp方法所对应的标识号，由银行生成
    ,otpsourceaddress -- 银行发送otp的源地址，如银行提供该字段，则默认支持手机设备自动截取otp并填写；
    ,otp -- 用户输入的0tp信息
    ,operationchannelid -- 标识当前发起该变更操作的渠道方；（00，01，02，03）
    ,operationreason -- 标识当前变更操作的变更原因
    ,applyexceptionresult -- 移动设备卡申请异常处理结果(01,10,11,12,13,20,21,22,23,24,25,26,27,28,29)
    ,exceptionresultreason -- 移动设备卡申请异常处理结果原因描述
    ,taskid -- task id
    ,ecashbalance -- 电子现金余额，本元素中取值不带小数点。 当币种为人民币时， 本元素的最右两位表示人民币的角和分。
    ,blacklistcategory -- 黑名单类型(00,01,02,03)
    ,blackinvalidtime -- 该pan号对应的黑名单失效时间
    ,blackoperationtype -- 建议的操作类型（增加或删除）(i,d)
    ,transactionid -- 当出现mpanid且交易为uics交易 时出现；
    ,transactiontype -- 交易类型(purchase、 refund、 preauthorized、 preauthorizeddone 、 cashatm、 depositatm、 transferatm)
    ,transactiondate -- 交易曰期
    ,currencycode -- 货币代码
    ,transactionamount -- 交易金额
    ,transactionstatus -- 交易状态(approved （交易成功） 、 declined （交易被拒绝） 、 pending （交易处理中） 和refunded （已退款）)
    ,merchantname -- 商户名称
    ,rawmerchantname -- 商户原始名称
    ,industrycategory -- 行业分类
    ,industrycode -- 行业代码
    ,geolocation -- 地理位置信息
    ,paninputmode -- pan输入方式(00,01,02)
    ,mac -- message authentication code
    ,notflag -- 通知标志位 n未知 f失败 s成功
    ,notnum -- 通知次数
    ,remark1 -- 
    ,remark2 -- 
    ,remark3 -- 
    ,remark4 -- 
    ,idecheck -- 身份验证 0-初始，1-成功，2-失败
    ,srcseqno -- 前端流水号
    ,operationresult -- task id操作执行结果(00,01)
    ,blackpan -- 黑名单帐号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    transtime -- 操作时间
    ,aleseqno -- 中台流水号
    ,paysys -- 0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他
    ,transtype -- 交易类型
    ,interfaceversion -- 接口版本号
    ,transtimesource -- 发起方交易时间yyyymmddhhmmss
    ,transtimedestination -- 接收方交易时间yyyymmddhhmmss
    ,transnosource -- 交易发起方流水号
    ,transnodestination -- 交易接收方流水号
    ,source -- 报文请求方
    ,destination -- 报文接收方
    ,custno -- 客户号
    ,seid -- 安全芯片所对应的标识符
    ,span -- 标准卡主账号
    ,newspan -- 新的标准实体银行卡
    ,spanid -- 标准卡主账号对应的标识符
    ,mpan -- 移动设备卡主账号
    ,mpanid -- 设备卡主账号对应的标识符
    ,mstpan -- 移动mst设备卡主账号
    ,mstpanid -- 移动mst设备卡主账号对应的标识符
    ,mappingstatus -- 映射关系状态 00初始 01可用 02锁定 03注销
    ,mpanpersoresult -- mpan应用个人化执行结果
    ,setype -- 前4位 1011 apple产品  0011全手机模式
    ,seissuer -- 前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派
    ,instanceaid -- 应用安装实例aid
    ,expirydate -- 有效期，mmyy
    ,cvn2 -- cvn2
    ,pin -- 密码
    ,custname -- 持卡人姓名
    ,idtype -- 证件类型
    ,idno -- 证件号码
    ,phone -- 手机号
    ,initquota -- 免密限额
    ,cardartid -- 卡面配置方案id
    ,invaluedate -- 卡面有效期
    ,applychannel -- 用户申请的渠道(00，01，02，03)
    ,bankchanneldata -- 银行渠道自有的数据
    ,termandconditionid -- 用户签署协议和条款对应的id
    ,termandconditionaccepteddate -- 用户接受协议和条款的日期和具体时间
    ,accountscore -- 账户评分,取值从1到5。分值越高，代表该设备的可信度越高
    ,devicescore -- 设备厂商给设备的评分，取值从1到5。分值越高，代表该设备的可信度越高
    ,sourcelp -- 源 ip,设备厂商提供的一个信息，用于合规性检查。
    ,color -- 设备厂商建议的加载流程对应颜色级别。 目前仅用于apple pay项目。
    ,reasoncodes -- 设备厂商给出的颜色判断原因， 只在建议选择黄色流程的时候才出现， 解释为什么要建议选择黄色流程。 目前仅用于apple pay项目。
    ,devicetype -- 设备厂商自己对用来做交易的设备类型所做的编码， 每类设备对应一个整数值， 取值范围从1至99。 目前仅在apple pay项目中出现。
    ,devicename -- 用户给设备所添加的设备别名，比如“**的iphone”。
    ,devicenumber -- 用来做设备卡加载时用户设备所对应的手机号码后四位数字。
    ,fulldevicenumber -- 用来做设备卡加载时用户设备所对应的完整手机号码。
    ,phonenumberscore -- 手机号信任级,copper建议的加载流程对应手机号信任评级级别。
    ,accountidhash -- 用来标识用户在全手机厂商的登录账号id信息的哈希值，与用户登录账号id是一一对应关系。 目前仅用于apple pay项目
    ,devicelocation -- 用来做设备卡加载时的用户设备位置信息，按照“纬度/经度”格式填写
    ,extensivedevicelocation -- 用来做设备卡加载时的用户设备位置信息，按照“纬度/经度”格式填写, 但精度比devicelocationtype更高，有小数点
    ,billingaddress -- 用户账单地址信息；
    ,billingzip -- 用户账单邮编信息；
    ,colorstandardsversion -- 设备厂商给出加载流程颜色建议时所基于的颜色判断原则对应的版本。 目前仅用于apple pay项目，取值从“0001.00”开始。
    ,cardholdername -- 持卡人姓名
    ,itunesemaillife -- 邮箱变更时间,数值范围：0-24，表示0-24个月
    ,capturemethod -- 卡号录入方式，手输入卡号还是摄像头捕捉。(00,01)
    ,casdcertinfo -- 前端提供的casd证书信息， 目前仅用于apple pay项目
    ,statuscode -- 
    ,statusdescription -- 
    ,storeidentifier -- storeidentifier
    ,applicationid -- application 标识符
    ,otptype -- otp类型，目前支持手机动态验 证||电子邮件动态验证||客户 服务||银行客户端等四种方式
    ,otpresolutionvalue -- 每种otp方法具体对应到用户的具体取值：对于手机动态验证，即为用户用于接收动态验证的手机号码；对于电子邮件动态验证，即为用户用于接收动态验证的电子邮件地址；对于客户服务，即为银行客服电话；对于银行客户端，即为客户端地址；
    ,otpresolutionid -- 每种otp方法所对应的标识号，由银行生成
    ,otpsourceaddress -- 银行发送otp的源地址，如银行提供该字段，则默认支持手机设备自动截取otp并填写；
    ,otp -- 用户输入的0tp信息
    ,operationchannelid -- 标识当前发起该变更操作的渠道方；（00，01，02，03）
    ,operationreason -- 标识当前变更操作的变更原因
    ,applyexceptionresult -- 移动设备卡申请异常处理结果(01,10,11,12,13,20,21,22,23,24,25,26,27,28,29)
    ,exceptionresultreason -- 移动设备卡申请异常处理结果原因描述
    ,taskid -- task id
    ,ecashbalance -- 电子现金余额，本元素中取值不带小数点。 当币种为人民币时， 本元素的最右两位表示人民币的角和分。
    ,blacklistcategory -- 黑名单类型(00,01,02,03)
    ,blackinvalidtime -- 该pan号对应的黑名单失效时间
    ,blackoperationtype -- 建议的操作类型（增加或删除）(i,d)
    ,transactionid -- 当出现mpanid且交易为uics交易 时出现；
    ,transactiontype -- 交易类型(purchase、 refund、 preauthorized、 preauthorizeddone 、 cashatm、 depositatm、 transferatm)
    ,transactiondate -- 交易曰期
    ,currencycode -- 货币代码
    ,transactionamount -- 交易金额
    ,transactionstatus -- 交易状态(approved （交易成功） 、 declined （交易被拒绝） 、 pending （交易处理中） 和refunded （已退款）)
    ,merchantname -- 商户名称
    ,rawmerchantname -- 商户原始名称
    ,industrycategory -- 行业分类
    ,industrycode -- 行业代码
    ,geolocation -- 地理位置信息
    ,paninputmode -- pan输入方式(00,01,02)
    ,mac -- message authentication code
    ,notflag -- 通知标志位 n未知 f失败 s成功
    ,notnum -- 通知次数
    ,remark1 -- 
    ,remark2 -- 
    ,remark3 -- 
    ,remark4 -- 
    ,idecheck -- 身份验证 0-初始，1-成功，2-失败
    ,srcseqno -- 前端流水号
    ,operationresult -- task id操作执行结果(00,01)
    ,blackpan -- 黑名单帐号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a86payseqno
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a86payseqno exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a86payseqno_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a86payseqno to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a86payseqno_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a86payseqno',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);