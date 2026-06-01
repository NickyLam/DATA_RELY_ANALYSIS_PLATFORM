/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_mpcs_a50ubcardjour
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.aml_mpcs_a50ubcardjour drop partition p_${last_date};
alter table ${idl_schema}.aml_mpcs_a50ubcardjour drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_mpcs_a50ubcardjour add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_mpcs_a50ubcardjour partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,acqinstid  -- 受理方标识码
    ,fwdinstid  -- 发送方标识码
    ,systrace  -- 系统跟踪号
    ,transtime  -- 交易时间（MMDDHHMMSS）
    ,transcode  -- 交易码
    ,transdate  -- 前置交易日期
    ,tlrnbr  -- 柜员号
    ,brnnbr  -- 网点号
    ,trantype  -- 交易类型 01 : 银联前置 02 : ATMP前置 03 : 柜台交易
    ,channels  -- 渠道 CDM-本行CDM CUP-银联 ATM-本行ATM GMT-柜面通
    ,msgtype  -- 消息类型
    ,priacct  -- 主账户号
    ,procecode  -- 处理码
    ,workcode  -- 内部处理码
    ,transamt  -- 交易金额
    ,onlnbl  -- 联机余额
    ,avalbl  -- 账户当日可用余额
    ,cravbl  -- ATM取款当日可用余额
    ,trxfee  -- 交易费用
    ,localtime  -- 受理方所在地时间
    ,localdate  -- 受理方所在地日期
    ,exprdate  -- 有效期
    ,settlmtdate  -- 清算日期
    ,mchnttype  -- 商户类型
    ,posentrymode  -- 服务点输入方式码
    ,servicecode  -- 服务点条件码
    ,trackdata2  -- 第二磁道数据
    ,trackdata3  -- 第三磁道数据
    ,retrivarefnum  -- 检索参考号
    ,authridresp  -- 授权标识应答码
    ,respcode  -- 响应码
    ,acptermnlid  -- 受理终端标识码
    ,accptrid  -- 受理商户代码
    ,accttrnameloc  -- 受理方名称/地址
    ,addtnlrespcd  -- 附加响应数据
    ,privatedate  -- 附加私有域
    ,currcycode  -- 交易货币代码
    ,pindata  -- 个人标识码数据
    ,reserve  -- 保留域
    ,rcvinstid  -- 接收方标识码
    ,cupsreserve  -- CUPS保留
    ,oldacqinstid  -- 原受理方标识码
    ,oldfwdinstid  -- 原发送方标识码
    ,oldsystrace  -- 原系统跟踪号
    ,oldtranstime  -- 原交易时间（MMDDHHMMSS）
    ,inputdata  -- 输入数据
    ,outputdata  -- 银联汇率：优先取9域，否则取10域
    ,outacctnbr  -- 支出账号
    ,inacctnbr  -- 存入账号
    ,atmctrace  -- ATMC交易流水号
    ,linkid  -- 链路ID
    ,headinfo  -- 报文头信息
    ,status  -- 状态 0 : 失效状态(最终状态) 1 : 交易成功(最终状态) 2 : 已冲正(最终状态) 4 : 已发送到银联 5 : 已发送到核心 6 : 银联成功 7 : 核心成功 8 : 核心失败 9 : 已撤消(最终状态)
    ,errcode  -- 错误码
    ,errmsg  -- 错误信息
    ,tertype  -- 终端类型
    ,promty  -- 发起方式
    ,acqinstctrycd  -- 商户国家代码
    ,cardholdamt  -- 持卡人扣款金额
    ,cardholdrate  -- 持卡人扣帐汇率
    ,settlmtamt  -- 清算金额
    ,newfwdinstid  -- 发送方机构码（F33真实值）
    ,channeltp  -- 跨境标识符 0 境内 1境外
    ,cardseq  -- 卡序列号
    ,inpbocelem  -- 接入IC卡数据域
    ,outpbocelem  -- 发出IC卡数据域
    ,atmcrust  -- C端脚本执行响应
    ,trncd  -- 内部交易代码
    ,foriegnbl  -- 外币交易主金额
    ,acctype  -- 账户等级，I II III类
    ,openbrch  -- 开户机构
    ,fee  -- 手续费或其他费用
    ,card_type  -- 卡类型：0:IC卡 1:磁条卡 3:未知
    ,card_trn_typ  -- 卡交易类型：1:IC卡 2:磁条卡 3:二维码 4:云闪付 5:APPLEPAY 0:无卡
    ,scene  -- 二维码付款场景 100-被扫消费 210-主扫一般商户消费 211-主扫消费 220-主扫ATM取现 212-主扫小微商户消费   231-主扫人到人二维码付款（贷记交易） 32-主扫人到人二维码付款（扣款交易）
    ,cross_flag  -- 跨行标志
    ,fallback_fg  -- 降级标识
    ,petty_flag  -- 小额免密标识 1:免密
    ,respcode_s  -- 细化应答码
    ,memo_cd  -- 摘要码
    ,memo_det  -- 附言
    ,global_seq  -- 全局流水
    ,trn_seq  -- 交易流水
    ,old_trn_seq  -- 原交易流水
    ,upp_status  -- UPP入账状态
    ,host_nbr  -- 后台记账流水
    ,host_date  -- 后台记账日期
    ,dly_trn_id  -- 延时扣款交易流水
    ,dly_trn_dt  -- 延时扣款交易日期
    ,dly_yl_stu  -- 银联延时转账结果
    ,dly_status  -- 延时转账结果
    ,cust_termid  -- 终端设备号
    ,cust_ip  -- 终端IP
    ,client_sim  -- 终端SIM号码
    ,client_gps  -- 终端GPS位置
    ,mobile  -- 预留手机号
    ,cust_no  -- 客户号
    ,cust_name  -- 客户名称
    ,trn_time  -- 交易时中台日期 YYYYMMDDhhmmssfff
    ,back_acct_date  -- 后台会计日期
    ,oldtranscode  -- 原交易码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(replace(t1.acqinstid,chr(27),''),chr(13),''),chr(10),'')  -- 受理方标识码
    ,replace(replace(replace(t1.fwdinstid,chr(27),''),chr(13),''),chr(10),'')  -- 发送方标识码
    ,replace(replace(replace(t1.systrace,chr(27),''),chr(13),''),chr(10),'')  -- 系统跟踪号
    ,replace(replace(replace(t1.transtime,chr(27),''),chr(13),''),chr(10),'')  -- 交易时间（MMDDHHMMSS）
    ,replace(replace(replace(t1.transcode,chr(27),''),chr(13),''),chr(10),'')  -- 交易码
    ,replace(replace(replace(t1.transdate,chr(27),''),chr(13),''),chr(10),'')  -- 前置交易日期
    ,replace(replace(replace(t1.tlrnbr,chr(27),''),chr(13),''),chr(10),'')  -- 柜员号
    ,replace(replace(replace(t1.brnnbr,chr(27),''),chr(13),''),chr(10),'')  -- 网点号
    ,replace(replace(replace(t1.trantype,chr(27),''),chr(13),''),chr(10),'')  -- 交易类型 01 : 银联前置 02 : ATMP前置 03 : 柜台交易
    ,replace(replace(replace(t1.channels,chr(27),''),chr(13),''),chr(10),'')  -- 渠道 CDM-本行CDM CUP-银联 ATM-本行ATM GMT-柜面通
    ,replace(replace(replace(t1.msgtype,chr(27),''),chr(13),''),chr(10),'')  -- 消息类型
    ,replace(replace(replace(t1.priacct,chr(27),''),chr(13),''),chr(10),'')  -- 主账户号
    ,replace(replace(replace(t1.procecode,chr(27),''),chr(13),''),chr(10),'')  -- 处理码
    ,replace(replace(replace(t1.workcode,chr(27),''),chr(13),''),chr(10),'')  -- 内部处理码
    ,t1.transamt  -- 交易金额
    ,t1.onlnbl  -- 联机余额
    ,t1.avalbl  -- 账户当日可用余额
    ,t1.cravbl  -- ATM取款当日可用余额
    ,replace(replace(replace(t1.trxfee,chr(27),''),chr(13),''),chr(10),'')  -- 交易费用
    ,replace(replace(replace(t1.localtime,chr(27),''),chr(13),''),chr(10),'')  -- 受理方所在地时间
    ,replace(replace(replace(t1.localdate,chr(27),''),chr(13),''),chr(10),'')  -- 受理方所在地日期
    ,replace(replace(replace(t1.exprdate,chr(27),''),chr(13),''),chr(10),'')  -- 有效期
    ,replace(replace(replace(t1.settlmtdate,chr(27),''),chr(13),''),chr(10),'')  -- 清算日期
    ,replace(replace(replace(t1.mchnttype,chr(27),''),chr(13),''),chr(10),'')  -- 商户类型
    ,replace(replace(replace(t1.posentrymode,chr(27),''),chr(13),''),chr(10),'')  -- 服务点输入方式码
    ,replace(replace(replace(t1.servicecode,chr(27),''),chr(13),''),chr(10),'')  -- 服务点条件码
    ,replace(replace(replace(t1.trackdata2,chr(27),''),chr(13),''),chr(10),'')  -- 第二磁道数据
    ,replace(replace(replace(t1.trackdata3,chr(27),''),chr(13),''),chr(10),'')  -- 第三磁道数据
    ,replace(replace(replace(t1.retrivarefnum,chr(27),''),chr(13),''),chr(10),'')  -- 检索参考号
    ,replace(replace(replace(t1.authridresp,chr(27),''),chr(13),''),chr(10),'')  -- 授权标识应答码
    ,replace(replace(replace(t1.respcode,chr(27),''),chr(13),''),chr(10),'')  -- 响应码
    ,replace(replace(replace(t1.acptermnlid,chr(27),''),chr(13),''),chr(10),'')  -- 受理终端标识码
    ,replace(replace(replace(t1.accptrid,chr(27),''),chr(13),''),chr(10),'')  -- 受理商户代码
    ,replace(replace(replace(t1.accttrnameloc,chr(27),''),chr(13),''),chr(10),'')  -- 受理方名称/地址
    ,replace(replace(replace(t1.addtnlrespcd,chr(27),''),chr(13),''),chr(10),'')  -- 附加响应数据
    ,replace(replace(replace(t1.privatedate,chr(27),''),chr(13),''),chr(10),'')  -- 附加私有域
    ,replace(replace(replace(t1.currcycode,chr(27),''),chr(13),''),chr(10),'')  -- 交易货币代码
    ,replace(replace(replace(t1.pindata,chr(27),''),chr(13),''),chr(10),'')  -- 个人标识码数据
    ,replace(replace(replace(t1.reserve,chr(27),''),chr(13),''),chr(10),'')  -- 保留域
    ,replace(replace(replace(t1.rcvinstid,chr(27),''),chr(13),''),chr(10),'')  -- 接收方标识码
    ,replace(replace(replace(t1.cupsreserve,chr(27),''),chr(13),''),chr(10),'')  -- CUPS保留
    ,replace(replace(replace(t1.oldacqinstid,chr(27),''),chr(13),''),chr(10),'')  -- 原受理方标识码
    ,replace(replace(replace(t1.oldfwdinstid,chr(27),''),chr(13),''),chr(10),'')  -- 原发送方标识码
    ,replace(replace(replace(t1.oldsystrace,chr(27),''),chr(13),''),chr(10),'')  -- 原系统跟踪号
    ,replace(replace(replace(t1.oldtranstime,chr(27),''),chr(13),''),chr(10),'')  -- 原交易时间（MMDDHHMMSS）
    ,replace(replace(replace(t1.inputdata,chr(27),''),chr(13),''),chr(10),'')  -- 输入数据
    ,replace(replace(replace(t1.outputdata,chr(27),''),chr(13),''),chr(10),'')  -- 银联汇率：优先取9域，否则取10域
    ,replace(replace(replace(t1.outacctnbr,chr(27),''),chr(13),''),chr(10),'')  -- 支出账号
    ,replace(replace(replace(t1.inacctnbr,chr(27),''),chr(13),''),chr(10),'')  -- 存入账号
    ,replace(replace(replace(t1.atmctrace,chr(27),''),chr(13),''),chr(10),'')  -- ATMC交易流水号
    ,t1.linkid  -- 链路ID
    ,replace(replace(replace(t1.headinfo,chr(27),''),chr(13),''),chr(10),'')  -- 报文头信息
    ,replace(replace(replace(t1.status,chr(27),''),chr(13),''),chr(10),'')  -- 状态 0 : 失效状态(最终状态) 1 : 交易成功(最终状态) 2 : 已冲正(最终状态) 4 : 已发送到银联 5 : 已发送到核心 6 : 银联成功 7 : 核心成功 8 : 核心失败 9 : 已撤消(最终状态)
    ,replace(replace(replace(t1.errcode,chr(27),''),chr(13),''),chr(10),'')  -- 错误码
    ,replace(replace(replace(t1.errmsg,chr(27),''),chr(13),''),chr(10),'')  -- 错误信息
    ,replace(replace(replace(t1.tertype,chr(27),''),chr(13),''),chr(10),'')  -- 终端类型
    ,replace(replace(replace(t1.promty,chr(27),''),chr(13),''),chr(10),'')  -- 发起方式
    ,replace(replace(replace(t1.acqinstctrycd,chr(27),''),chr(13),''),chr(10),'')  -- 商户国家代码
    ,t1.cardholdamt  -- 持卡人扣款金额
    ,replace(replace(replace(t1.cardholdrate,chr(27),''),chr(13),''),chr(10),'')  -- 持卡人扣帐汇率
    ,t1.settlmtamt  -- 清算金额
    ,replace(replace(replace(t1.newfwdinstid,chr(27),''),chr(13),''),chr(10),'')  -- 发送方机构码（F33真实值）
    ,replace(replace(replace(t1.channeltp,chr(27),''),chr(13),''),chr(10),'')  -- 跨境标识符 0 境内 1境外
    ,replace(replace(replace(t1.cardseq,chr(27),''),chr(13),''),chr(10),'')  -- 卡序列号
    ,replace(replace(replace(t1.inpbocelem,chr(27),''),chr(13),''),chr(10),'')  -- 接入IC卡数据域
    ,replace(replace(replace(t1.outpbocelem,chr(27),''),chr(13),''),chr(10),'')  -- 发出IC卡数据域
    ,replace(replace(replace(t1.atmcrust,chr(27),''),chr(13),''),chr(10),'')  -- C端脚本执行响应
    ,replace(replace(replace(t1.trncd,chr(27),''),chr(13),''),chr(10),'')  -- 内部交易代码
    ,t1.foriegnbl  -- 外币交易主金额
    ,replace(replace(replace(t1.acctype,chr(27),''),chr(13),''),chr(10),'')  -- 账户等级，I II III类
    ,replace(replace(replace(t1.openbrch,chr(27),''),chr(13),''),chr(10),'')  -- 开户机构
    ,t1.fee  -- 手续费或其他费用
    ,replace(replace(replace(t1.card_type,chr(27),''),chr(13),''),chr(10),'')  -- 卡类型：0:IC卡 1:磁条卡 3:未知
    ,replace(replace(replace(t1.card_trn_typ,chr(27),''),chr(13),''),chr(10),'')  -- 卡交易类型：1:IC卡 2:磁条卡 3:二维码 4:云闪付 5:APPLEPAY 0:无卡
    ,replace(replace(replace(t1.scene,chr(27),''),chr(13),''),chr(10),'')  -- 二维码付款场景 100-被扫消费 210-主扫一般商户消费 211-主扫消费 220-主扫ATM取现 212-主扫小微商户消费   231-主扫人到人二维码付款（贷记交易） 32-主扫人到人二维码付款（扣款交易）
    ,replace(replace(replace(t1.cross_flag,chr(27),''),chr(13),''),chr(10),'')  -- 跨行标志
    ,replace(replace(replace(t1.fallback_fg,chr(27),''),chr(13),''),chr(10),'')  -- 降级标识
    ,replace(replace(replace(t1.petty_flag,chr(27),''),chr(13),''),chr(10),'')  -- 小额免密标识 1:免密
    ,replace(replace(replace(t1.respcode_s,chr(27),''),chr(13),''),chr(10),'')  -- 细化应答码
    ,replace(replace(replace(t1.memo_cd,chr(27),''),chr(13),''),chr(10),'')  -- 摘要码
    ,replace(replace(replace(t1.memo_det,chr(27),''),chr(13),''),chr(10),'')  -- 附言
    ,replace(replace(replace(t1.global_seq,chr(27),''),chr(13),''),chr(10),'')  -- 全局流水
    ,replace(replace(replace(t1.trn_seq,chr(27),''),chr(13),''),chr(10),'')  -- 交易流水
    ,replace(replace(replace(t1.old_trn_seq,chr(27),''),chr(13),''),chr(10),'')  -- 原交易流水
    ,replace(replace(replace(t1.upp_status,chr(27),''),chr(13),''),chr(10),'')  -- UPP入账状态
    ,replace(replace(replace(t1.host_nbr,chr(27),''),chr(13),''),chr(10),'')  -- 后台记账流水
    ,replace(replace(replace(t1.host_date,chr(27),''),chr(13),''),chr(10),'')  -- 后台记账日期
    ,replace(replace(replace(t1.dly_trn_id,chr(27),''),chr(13),''),chr(10),'')  -- 延时扣款交易流水
    ,replace(replace(replace(t1.dly_trn_dt,chr(27),''),chr(13),''),chr(10),'')  -- 延时扣款交易日期
    ,replace(replace(replace(t1.dly_yl_stu,chr(27),''),chr(13),''),chr(10),'')  -- 银联延时转账结果
    ,replace(replace(replace(t1.dly_status,chr(27),''),chr(13),''),chr(10),'')  -- 延时转账结果
    ,replace(replace(replace(t1.cust_termid,chr(27),''),chr(13),''),chr(10),'')  -- 终端设备号
    ,replace(replace(replace(t1.cust_ip,chr(27),''),chr(13),''),chr(10),'')  -- 终端IP
    ,replace(replace(replace(t1.client_sim,chr(27),''),chr(13),''),chr(10),'')  -- 终端SIM号码
    ,replace(replace(replace(t1.client_gps,chr(27),''),chr(13),''),chr(10),'')  -- 终端GPS位置
    ,replace(replace(replace(t1.mobile,chr(27),''),chr(13),''),chr(10),'')  -- 预留手机号
    ,replace(replace(replace(t1.cust_no,chr(27),''),chr(13),''),chr(10),'')  -- 客户号
    ,replace(replace(replace(t1.cust_name,chr(27),''),chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(replace(t1.trn_time,chr(27),''),chr(13),''),chr(10),'')  -- 交易时中台日期 YYYYMMDDhhmmssfff
    ,replace(replace(replace(t1.back_acct_date,chr(27),''),chr(13),''),chr(10),'')  -- 后台会计日期
    ,replace(replace(replace(t1.oldtranscode,chr(27),''),chr(13),''),chr(10),'')  -- 原交易码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.mpcs_a50ubcardjour t1    --atmp/银联前置交易流水表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_mpcs_a50ubcardjour',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);