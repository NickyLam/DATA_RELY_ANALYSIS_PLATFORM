/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08tbetrx
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
drop table ${iol_schema}.mpcs_a08tbetrx_ex purge;
alter table ${iol_schema}.mpcs_a08tbetrx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a08tbetrx'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a08tbetrx truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a08tbetrx add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a08tbetrx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08tbetrx where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a08tbetrx(
    mainsq -- 支付报单号(中台流水号)
    ,opersq -- 支付交易序号（行外），明细标识号
    ,businesstrace -- 行内业务序号
    ,bustype -- 业务类型
    ,servtype -- 业务种类
    ,dtlcmtno -- 业务要素集
    ,transseq -- 包序号
    ,pkcodt -- 包委托日期
    ,pktype -- 包类型
    ,hosttrcd -- 主机交易码
    ,fronttrcd -- 中台交易码
    ,transdt -- 交易日期
    ,consigndt -- 委托日期
    ,hostdate -- 主机日期
    ,hostnbr -- 主机流水
    ,crcycd -- 币种
    ,transamt -- 交易金额
    ,paybrn -- 付款人开户行部门号
    ,payopenbrn -- 付款人开户行行
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,payaddr -- 付款人地址
    ,incobrn -- 收款人开户行行号
    ,incoacct -- 收款人账号
    ,inconame -- 收款人名称
    ,incoaddr -- 收款人地址
    ,sndct -- 发报中心
    ,sndupbrn -- 发起清算行行号
    ,sndbrn -- 发起行行号
    ,rcvct -- 收报中心
    ,rcvupbrn -- 接收清算行行号
    ,rcvbrn -- 接收行行号
    ,billdt -- 原(包)委托日期
    ,billcd -- 原支付交易序号
    ,orabustype -- 原业务类型编码
    ,ptrasq -- 票据号码
    ,obaltp -- 轧差节点类型
    ,obalod -- 轧差场次
    ,obaldt -- 轧差日期/终态日期
    ,caclrs -- 退汇原因代码
    ,cmpsam -- 赔偿金金额、拆借利息、出票金额
    ,inrate -- 利率
    ,refuam -- 拒付金额
    ,transt -- 处理状态
    ,processcode -- 人行业务状态
    ,advest -- 回执码
    ,vrseal -- 处理代码(一般为人行返回码)
    ,ckrvno -- 复核冲正流水号
    ,rndday -- 回执期限
    ,retudt -- 回执日期
    ,sdrvno -- 发送冲正流水号
    ,clerdt -- 清算日期
    ,bperno -- 错误代码
    ,bpermg -- 错误信息
    ,levels -- 优先级别
    ,oprtlr -- 录入柜员
    ,chktlr -- 复核柜员
    ,sndtlr -- 发送柜员
    ,auttlr -- 授权柜员
    ,stptlr -- 滞留柜员
    ,oprbrn -- 录入复核柜员部门号
    ,sendbranch -- 发送柜员部门号
    ,autbrn -- 授权柜员部门号
    ,recdes -- 支付密押
    ,chksta -- 对账状态
    ,remark -- 附言
    ,protocolnb -- 提示付款日期、协议号
    ,prtcnt -- 打印次数
    ,recvdt -- 收到时间
    ,transmitdt -- 发送时间、转发时间
    ,blsecd -- 
    ,paydat -- 提示付款日期
    ,iotype -- 往来帐标志
    ,flag2 -- 实时联机标记
    ,flag3 -- 收费标志
    ,flag4 -- 借贷标记
    ,inoutflag -- 行内行外标志
    ,blrqno -- 汇票申请书号码
    ,sacact -- 挂帐帐号或维护入账帐号
    ,sacana -- 挂帐帐号或维护入账姓名
    ,clendt -- 维护入账日期
    ,clenus -- 维护入账柜员
    ,clrbrn -- 维护入账部门号
    ,clract -- 清分入帐帐号
    ,clrseq -- 清分流水
    ,prdnbr -- 代理标识 0 本行业务 1 代理他行
    ,tranbr -- 日志流水号
    ,sdtrno -- 发送日志流水
    ,bkcode -- 凭证类型
    ,cobkdt -- 委托凭证日期
    ,cobkcd -- 委托凭证号
    ,idtype -- 证件种类
    ,idno -- 证件号码
    ,mxtram -- 转帐限额
    ,transq -- 交易流水套号
    ,sdtrsq -- 发送交易流水
    ,paymod -- 支付方式
    ,opnwin -- 汇兑业务对应的窗口(交易渠道)
    ,chngdt -- 最近修改日期
    ,bepssq -- 业务流水号
    ,linkid -- ID号
    ,feamt1 -- 手续费
    ,feamt2 -- 汇划费
    ,feamt3 -- 工本费
    ,feamt4 -- 费用（备用）
    ,priamt -- 原托金额
    ,payamt -- 支付金额
    ,spiamt -- 多付金额
    ,edhtno -- 取消交易流水
    ,edhtdt -- 取消交易日期
    ,endtlr -- 取消柜员
    ,chngti -- 最近修改时间
    ,magbrn -- 处理机构
    ,resv40 -- 特殊码
    ,rcdver -- 记录更新版本号
    ,rcdsta -- 记录状态
    ,prpktp -- 原包类型
    ,prclbk -- 原包发起清算行
    ,prpkdt -- 原包委托日期
    ,prpksq -- 原包序号
    ,prodcd -- 产品代码
    ,isinout -- 客户帐、内部帐标识
    ,inacct -- 实际扣帐账号
    ,inname -- 实际扣帐户名
    ,ourcnapsver -- 行内系统版本
    ,othercnapsver -- 对手系统版本
    ,landdealsts -- 落地处理状态
    ,checkdealsts -- 查证处理状态
    ,appenddatatable -- 登记附加数据的表名
    ,appenddatadtltab -- 登记附加数据明细的表名
    ,hangupreason -- 挂账原因
    ,pkgbusinesstrace -- 包行内序号
    ,pktype2 -- 二代报文号
    ,bustype2 -- 二代业务类型
    ,servtype2 -- 二代业务种类
    ,payopenbanknm -- 付款人开户行名称
    ,recvopenbanknm -- 收款人开户行名称
    ,modifytlr -- 修改柜员
    ,feetype -- 收费方式
    ,eaccflg -- 电子账户标志
    ,od_flag -- 是否触发透支业务
    ,od_ovtranam -- 透支金额
    ,nextdayflag -- 次日转账标识
    ,autoflag -- 自动退汇处理标识
    ,autocount -- 自动退汇处理次数
    ,automsg -- 自动退汇处理信息
    ,bindacct -- 绑定账户
    ,bindacctnm -- 绑定账户名
    ,accttype -- 账户类型
    ,bindacctopnbrn -- 绑定账户开户机构
    ,lsttranst -- 上一交易状态
    ,tacctp -- 账户分类标识
    ,limitorderid -- 限额订单号
    ,isbindcard -- 绑定标志
    ,globalseqno -- 全局流水号
    ,returncode -- ESB接口返回码
    ,returnmsg -- ESB接口返回信息
    ,transseqno -- ESB接口交易流水号
    ,sendouttm -- 发送人行时间
    ,finaccountid -- 产品编号 e账户时需要
    ,acct_typ_id -- ppp账户类型
    ,memocntt -- 摘要码
    ,acctchngflg -- 接收方动账标识
    ,tagrmt -- 收付款通知编号
    ,cdtrfiacctfg -- 收款方金融账户标识
    ,inersettleacct -- 内部结算账号(收付款)
    ,inersettlename -- 内部结算名称(收付款)
    ,unisoccdtcd -- 统一社会信用代码
    ,regid -- 地域标识
    ,splchrgsreqtpcd -- 特约委收种类代码
    ,trnsmtdt -- 转发日期(用于计算回执日期)
    ,payupbrn -- 付款清算行
    ,incoupbrn -- 收款清算行
    ,agtflg -- 是否代理
    ,agtidtp -- 代理人证件类型
    ,agtidno -- 代理人证件号码
    ,agtname -- 代理人姓名
    ,agtphone -- 代理人联系方式
    ,budgetary -- 预算级次
    ,exchgflg -- 个人汇兑标识
    ,orisrcsysssn -- 原交易流水
    ,orisyscd -- 原支付通道
    ,redoflag -- 重发标志
    ,fintransdt -- 金融流水表中台日期
    ,finmainseq -- 金融流水表中台流水
    ,unique_seq_num -- 业务流水号(交易订单号)
    ,hangupmesg -- 挂账原因说明
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    mainsq -- 支付报单号(中台流水号)
    ,opersq -- 支付交易序号（行外），明细标识号
    ,businesstrace -- 行内业务序号
    ,bustype -- 业务类型
    ,servtype -- 业务种类
    ,dtlcmtno -- 业务要素集
    ,transseq -- 包序号
    ,pkcodt -- 包委托日期
    ,pktype -- 包类型
    ,hosttrcd -- 主机交易码
    ,fronttrcd -- 中台交易码
    ,transdt -- 交易日期
    ,consigndt -- 委托日期
    ,hostdate -- 主机日期
    ,hostnbr -- 主机流水
    ,crcycd -- 币种
    ,transamt -- 交易金额
    ,paybrn -- 付款人开户行部门号
    ,payopenbrn -- 付款人开户行行
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,payaddr -- 付款人地址
    ,incobrn -- 收款人开户行行号
    ,incoacct -- 收款人账号
    ,inconame -- 收款人名称
    ,incoaddr -- 收款人地址
    ,sndct -- 发报中心
    ,sndupbrn -- 发起清算行行号
    ,sndbrn -- 发起行行号
    ,rcvct -- 收报中心
    ,rcvupbrn -- 接收清算行行号
    ,rcvbrn -- 接收行行号
    ,billdt -- 原(包)委托日期
    ,billcd -- 原支付交易序号
    ,orabustype -- 原业务类型编码
    ,ptrasq -- 票据号码
    ,obaltp -- 轧差节点类型
    ,obalod -- 轧差场次
    ,obaldt -- 轧差日期/终态日期
    ,caclrs -- 退汇原因代码
    ,cmpsam -- 赔偿金金额、拆借利息、出票金额
    ,inrate -- 利率
    ,refuam -- 拒付金额
    ,transt -- 处理状态
    ,processcode -- 人行业务状态
    ,advest -- 回执码
    ,vrseal -- 处理代码(一般为人行返回码)
    ,ckrvno -- 复核冲正流水号
    ,rndday -- 回执期限
    ,retudt -- 回执日期
    ,sdrvno -- 发送冲正流水号
    ,clerdt -- 清算日期
    ,bperno -- 错误代码
    ,bpermg -- 错误信息
    ,levels -- 优先级别
    ,oprtlr -- 录入柜员
    ,chktlr -- 复核柜员
    ,sndtlr -- 发送柜员
    ,auttlr -- 授权柜员
    ,stptlr -- 滞留柜员
    ,oprbrn -- 录入复核柜员部门号
    ,sendbranch -- 发送柜员部门号
    ,autbrn -- 授权柜员部门号
    ,recdes -- 支付密押
    ,chksta -- 对账状态
    ,remark -- 附言
    ,protocolnb -- 提示付款日期、协议号
    ,prtcnt -- 打印次数
    ,recvdt -- 收到时间
    ,transmitdt -- 发送时间、转发时间
    ,blsecd -- 
    ,paydat -- 提示付款日期
    ,iotype -- 往来帐标志
    ,flag2 -- 实时联机标记
    ,flag3 -- 收费标志
    ,flag4 -- 借贷标记
    ,inoutflag -- 行内行外标志
    ,blrqno -- 汇票申请书号码
    ,sacact -- 挂帐帐号或维护入账帐号
    ,sacana -- 挂帐帐号或维护入账姓名
    ,clendt -- 维护入账日期
    ,clenus -- 维护入账柜员
    ,clrbrn -- 维护入账部门号
    ,clract -- 清分入帐帐号
    ,clrseq -- 清分流水
    ,prdnbr -- 代理标识 0 本行业务 1 代理他行
    ,tranbr -- 日志流水号
    ,sdtrno -- 发送日志流水
    ,bkcode -- 凭证类型
    ,cobkdt -- 委托凭证日期
    ,cobkcd -- 委托凭证号
    ,idtype -- 证件种类
    ,idno -- 证件号码
    ,mxtram -- 转帐限额
    ,transq -- 交易流水套号
    ,sdtrsq -- 发送交易流水
    ,paymod -- 支付方式
    ,opnwin -- 汇兑业务对应的窗口(交易渠道)
    ,chngdt -- 最近修改日期
    ,bepssq -- 业务流水号
    ,linkid -- ID号
    ,feamt1 -- 手续费
    ,feamt2 -- 汇划费
    ,feamt3 -- 工本费
    ,feamt4 -- 费用（备用）
    ,priamt -- 原托金额
    ,payamt -- 支付金额
    ,spiamt -- 多付金额
    ,edhtno -- 取消交易流水
    ,edhtdt -- 取消交易日期
    ,endtlr -- 取消柜员
    ,chngti -- 最近修改时间
    ,magbrn -- 处理机构
    ,resv40 -- 特殊码
    ,rcdver -- 记录更新版本号
    ,rcdsta -- 记录状态
    ,prpktp -- 原包类型
    ,prclbk -- 原包发起清算行
    ,prpkdt -- 原包委托日期
    ,prpksq -- 原包序号
    ,prodcd -- 产品代码
    ,isinout -- 客户帐、内部帐标识
    ,inacct -- 实际扣帐账号
    ,inname -- 实际扣帐户名
    ,ourcnapsver -- 行内系统版本
    ,othercnapsver -- 对手系统版本
    ,landdealsts -- 落地处理状态
    ,checkdealsts -- 查证处理状态
    ,appenddatatable -- 登记附加数据的表名
    ,appenddatadtltab -- 登记附加数据明细的表名
    ,hangupreason -- 挂账原因
    ,pkgbusinesstrace -- 包行内序号
    ,pktype2 -- 二代报文号
    ,bustype2 -- 二代业务类型
    ,servtype2 -- 二代业务种类
    ,payopenbanknm -- 付款人开户行名称
    ,recvopenbanknm -- 收款人开户行名称
    ,modifytlr -- 修改柜员
    ,feetype -- 收费方式
    ,eaccflg -- 电子账户标志
    ,od_flag -- 是否触发透支业务
    ,od_ovtranam -- 透支金额
    ,nextdayflag -- 次日转账标识
    ,autoflag -- 自动退汇处理标识
    ,autocount -- 自动退汇处理次数
    ,automsg -- 自动退汇处理信息
    ,bindacct -- 绑定账户
    ,bindacctnm -- 绑定账户名
    ,accttype -- 账户类型
    ,bindacctopnbrn -- 绑定账户开户机构
    ,lsttranst -- 上一交易状态
    ,tacctp -- 账户分类标识
    ,limitorderid -- 限额订单号
    ,isbindcard -- 绑定标志
    ,globalseqno -- 全局流水号
    ,returncode -- ESB接口返回码
    ,returnmsg -- ESB接口返回信息
    ,transseqno -- ESB接口交易流水号
    ,sendouttm -- 发送人行时间
    ,finaccountid -- 产品编号 e账户时需要
    ,acct_typ_id -- ppp账户类型
    ,memocntt -- 摘要码
    ,acctchngflg -- 接收方动账标识
    ,tagrmt -- 收付款通知编号
    ,cdtrfiacctfg -- 收款方金融账户标识
    ,inersettleacct -- 内部结算账号(收付款)
    ,inersettlename -- 内部结算名称(收付款)
    ,unisoccdtcd -- 统一社会信用代码
    ,regid -- 地域标识
    ,splchrgsreqtpcd -- 特约委收种类代码
    ,trnsmtdt -- 转发日期(用于计算回执日期)
    ,payupbrn -- 付款清算行
    ,incoupbrn -- 收款清算行
    ,agtflg -- 是否代理
    ,agtidtp -- 代理人证件类型
    ,agtidno -- 代理人证件号码
    ,agtname -- 代理人姓名
    ,agtphone -- 代理人联系方式
    ,budgetary -- 预算级次
    ,exchgflg -- 个人汇兑标识
    ,orisrcsysssn -- 原交易流水
    ,orisyscd -- 原支付通道
    ,redoflag -- 重发标志
    ,fintransdt -- 金融流水表中台日期
    ,finmainseq -- 金融流水表中台流水
    ,unique_seq_num -- 业务流水号(交易订单号)
    ,hangupmesg -- 挂账原因说明
    ,to_date(transdt,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a08tbetrx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08tbetrx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a08tbetrx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08tbetrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);