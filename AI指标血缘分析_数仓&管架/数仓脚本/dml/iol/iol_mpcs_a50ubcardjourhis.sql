/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a50ubcardjourhis
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
drop table ${iol_schema}.mpcs_a50ubcardjourhis_ex purge;
alter table ${iol_schema}.mpcs_a50ubcardjourhis add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
-- 2.2.1 get new data into table
set serveroutput on
declare bat_dt varchar2(10);
    v_p_exists varchar2(10);
    v_sql varchar2(200);
begin    
for i in 0 .. 14 loop
    bat_dt := to_char(to_date('${batch_date}','yyyymmdd') - i,'yyyymmdd');
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a50ubcardjourhis'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a50ubcardjourhis truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a50ubcardjourhis add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a50ubcardjourhis_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a50ubcardjourhis where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a50ubcardjourhis(
    acqinstid -- 受理方标识码
    ,fwdinstid -- 发送方标识码
    ,systrace -- 系统跟踪号
    ,transtime -- 交易时间（MMDDHHMMSS）
    ,transcode -- 交易代码
    ,transdate -- 前置交易日期
    ,tlrnbr -- 柜员号
    ,brnnbr -- 网点号
    ,trantype -- 交易类型
    ,channels -- 渠道
    ,msgtype -- 消息类型
    ,priacct -- 主账户号
    ,procecode -- 处理码
    ,workcode -- 内部处理码
    ,transamt -- 交易金额
    ,onlnbl -- 联机余额
    ,avalbl -- 账户当日可用余额
    ,cravbl -- ATM取款当日可用余额
    ,trxfee -- 交易费用
    ,localtime -- 受理方所在地时间
    ,localdate -- 受理方所在地日期
    ,exprdate -- 有效期
    ,settlmtdate -- 清算日期
    ,mchnttype -- 商户类型
    ,posentrymode -- 服务点输入方式码
    ,servicecode -- 服务点条件码
    ,trackdata2 -- 二磁道数据
    ,trackdata3 -- 三磁道数据
    ,retrivarefnum -- 检索参考号
    ,authridresp -- 授权标识应答码
    ,respcode -- 响应码
    ,acptermnlid -- 受理终端标识码
    ,accptrid -- 受理商户代码
    ,accttrnameloc -- 受理方名称/地址
    ,addtnlrespcd -- 附加响应数据
    ,privatedate -- 附加私有域
    ,currcycode -- 交易货币代码
    ,pindata -- 个人标识码数据
    ,reserve -- 保留域
    ,rcvinstid -- 接收方标识码
    ,cupsreserve -- CUPS保留
    ,oldacqinstid -- 原受理方标识码
    ,oldfwdinstid -- 原发送方标识码
    ,oldsystrace -- 原系统跟踪号
    ,oldtranstime -- 原交易时间
    ,inputdata -- 输入数据
    ,outputdata -- 银联汇率：优先取9域，否则取10域
    ,outacctnbr -- 支出账号
    ,inacctnbr -- 存入账号
    ,atmctrace -- ATMC交易流水号
    ,linkid -- 链路ID
    ,headinfo -- 报文头信息
    ,status -- 状态 0 : 失效状态(最终状态) 1 : 交易成功(最终状态) 2 : 已冲正(最终状态) 4 : 已发送到银联 5 : 已发送到核心 6 : 银联成功 7 : 核心成功 8 : 核心失败 9 : 已撤消(最终状态)
    ,errcode -- 错误码
    ,errmsg -- 错误信息
    ,tertype -- 终端类型
    ,promty -- 发起方式
    ,acqinstctrycd -- 商户国家代码
    ,cardholdamt -- 持卡人扣款金额
    ,cardholdrate -- 持卡人扣账汇率
    ,settlmtamt -- 清算金额
    ,newfwdinstid -- 发送方机构码（F33真实值）
    ,channeltp -- 跨境标识符
    ,cardseq -- 卡序列号
    ,inpbocelem -- 接入IC卡数据域
    ,outpbocelem -- 发出IC卡数据域
    ,atmcrust -- C端脚本执行响应
    ,trncd -- 内部交易代码
    ,foriegnbl -- 
    ,acctype -- 账户等级，I II III类
    ,openbrch -- 开户机构
    ,fee -- 手续费或其他费用
    ,card_type -- 卡类型：0:IC卡 1:磁条卡 3:未知
    ,card_trn_typ -- 卡交易类型：1:IC卡 2:磁条卡 3:二维码 4:云闪付 5:APPLEPAY 0:无卡
    ,scene -- 二维码付款场景 100-被扫消费 210-主扫一般商户消费 211-主扫消费 220-主扫ATM取现 212-主扫小微商户消费   231-主扫人到人二维码付款（贷记交易） 32-主扫人到人二维码付款（扣款交易）
    ,cross_flag -- 跨行标志
    ,fallback_fg -- 降级标识
    ,petty_flag -- 小额免密标识 1:免密
    ,respcode_s -- 细化应答码
    ,memo_cd -- 摘要码
    ,memo_det -- 附言
    ,global_seq -- 全局流水
    ,trn_seq -- 交易流水
    ,old_trn_seq -- 原交易流水
    ,upp_status -- UPP入账状态
    ,host_nbr -- 后台记账流水
    ,host_date -- 后台记账日期
    ,dly_trn_id -- 延时扣款交易流水
    ,dly_trn_dt -- 延时扣款交易日期
    ,dly_yl_stu -- 银联延时转账结果
    ,dly_status -- 延时转账结果
    ,cust_termid -- 终端设备号
    ,cust_ip -- 终端IP
    ,client_sim -- 终端SIM号码
    ,client_gps -- 终端GPS位置
    ,mobile -- 预留手机号
    ,cust_no -- 客户号
    ,cust_name -- 客户名称
    ,trn_time -- 交易时中台日期 YYYYMMDDhhmmssfff
    ,back_acct_date -- 后台会计日期
    ,oldtranscode -- 原交易码
    ,busi_seq -- 业务流水号
    ,old_busi_seq -- 原业务流水号
    ,old_global_seq -- 原全局流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acqinstid -- 受理方标识码
    ,fwdinstid -- 发送方标识码
    ,systrace -- 系统跟踪号
    ,transtime -- 交易时间（MMDDHHMMSS）
    ,transcode -- 交易代码
    ,transdate -- 前置交易日期
    ,tlrnbr -- 柜员号
    ,brnnbr -- 网点号
    ,trantype -- 交易类型
    ,channels -- 渠道
    ,msgtype -- 消息类型
    ,priacct -- 主账户号
    ,procecode -- 处理码
    ,workcode -- 内部处理码
    ,transamt -- 交易金额
    ,onlnbl -- 联机余额
    ,avalbl -- 账户当日可用余额
    ,cravbl -- ATM取款当日可用余额
    ,trxfee -- 交易费用
    ,localtime -- 受理方所在地时间
    ,localdate -- 受理方所在地日期
    ,exprdate -- 有效期
    ,settlmtdate -- 清算日期
    ,mchnttype -- 商户类型
    ,posentrymode -- 服务点输入方式码
    ,servicecode -- 服务点条件码
    ,trackdata2 -- 二磁道数据
    ,trackdata3 -- 三磁道数据
    ,retrivarefnum -- 检索参考号
    ,authridresp -- 授权标识应答码
    ,respcode -- 响应码
    ,acptermnlid -- 受理终端标识码
    ,accptrid -- 受理商户代码
    ,accttrnameloc -- 受理方名称/地址
    ,addtnlrespcd -- 附加响应数据
    ,privatedate -- 附加私有域
    ,currcycode -- 交易货币代码
    ,pindata -- 个人标识码数据
    ,reserve -- 保留域
    ,rcvinstid -- 接收方标识码
    ,cupsreserve -- CUPS保留
    ,oldacqinstid -- 原受理方标识码
    ,oldfwdinstid -- 原发送方标识码
    ,oldsystrace -- 原系统跟踪号
    ,oldtranstime -- 原交易时间
    ,inputdata -- 输入数据
    ,outputdata -- 银联汇率：优先取9域，否则取10域
    ,outacctnbr -- 支出账号
    ,inacctnbr -- 存入账号
    ,atmctrace -- ATMC交易流水号
    ,linkid -- 链路ID
    ,headinfo -- 报文头信息
    ,status -- 状态 0 : 失效状态(最终状态) 1 : 交易成功(最终状态) 2 : 已冲正(最终状态) 4 : 已发送到银联 5 : 已发送到核心 6 : 银联成功 7 : 核心成功 8 : 核心失败 9 : 已撤消(最终状态)
    ,errcode -- 错误码
    ,errmsg -- 错误信息
    ,tertype -- 终端类型
    ,promty -- 发起方式
    ,acqinstctrycd -- 商户国家代码
    ,cardholdamt -- 持卡人扣款金额
    ,cardholdrate -- 持卡人扣账汇率
    ,settlmtamt -- 清算金额
    ,newfwdinstid -- 发送方机构码（F33真实值）
    ,channeltp -- 跨境标识符
    ,cardseq -- 卡序列号
    ,inpbocelem -- 接入IC卡数据域
    ,outpbocelem -- 发出IC卡数据域
    ,atmcrust -- C端脚本执行响应
    ,trncd -- 内部交易代码
    ,foriegnbl -- 
    ,acctype -- 账户等级，I II III类
    ,openbrch -- 开户机构
    ,fee -- 手续费或其他费用
    ,card_type -- 卡类型：0:IC卡 1:磁条卡 3:未知
    ,card_trn_typ -- 卡交易类型：1:IC卡 2:磁条卡 3:二维码 4:云闪付 5:APPLEPAY 0:无卡
    ,scene -- 二维码付款场景 100-被扫消费 210-主扫一般商户消费 211-主扫消费 220-主扫ATM取现 212-主扫小微商户消费   231-主扫人到人二维码付款（贷记交易） 32-主扫人到人二维码付款（扣款交易）
    ,cross_flag -- 跨行标志
    ,fallback_fg -- 降级标识
    ,petty_flag -- 小额免密标识 1:免密
    ,respcode_s -- 细化应答码
    ,memo_cd -- 摘要码
    ,memo_det -- 附言
    ,global_seq -- 全局流水
    ,trn_seq -- 交易流水
    ,old_trn_seq -- 原交易流水
    ,upp_status -- UPP入账状态
    ,host_nbr -- 后台记账流水
    ,host_date -- 后台记账日期
    ,dly_trn_id -- 延时扣款交易流水
    ,dly_trn_dt -- 延时扣款交易日期
    ,dly_yl_stu -- 银联延时转账结果
    ,dly_status -- 延时转账结果
    ,cust_termid -- 终端设备号
    ,cust_ip -- 终端IP
    ,client_sim -- 终端SIM号码
    ,client_gps -- 终端GPS位置
    ,mobile -- 预留手机号
    ,cust_no -- 客户号
    ,cust_name -- 客户名称
    ,trn_time -- 交易时中台日期 YYYYMMDDhhmmssfff
    ,back_acct_date -- 后台会计日期
    ,oldtranscode -- 原交易码
    ,busi_seq -- 业务流水号
    ,old_busi_seq -- 原业务流水号
    ,old_global_seq -- 原全局流水号
    ,to_date(substr(trim(trn_time),1,8),'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a50ubcardjourhis
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a50ubcardjourhis to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a50ubcardjourhis_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a50ubcardjourhis',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);