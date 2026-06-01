/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08thvtrx
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
drop table ${iol_schema}.mpcs_a08thvtrx_ex purge;
alter table ${iol_schema}.mpcs_a08thvtrx add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a08thvtrx'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a08thvtrx truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a08thvtrx add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a08thvtrx_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08thvtrx where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a08thvtrx(
    mainseq -- 支付报单号
    ,transseq -- 支付交易序号（行外）
    ,businesstrace -- 行内业务序号
    ,cmtno -- 报文编号（报文类型）
    ,hosttrcd -- 主机交易码
    ,fronttrcd -- 中台交易码
    ,transdt -- 交易日期
    ,consigndt -- 委托日期
    ,hostdate -- 主机日期
    ,hostnbr -- 主机流水
    ,ccynbr -- 币种
    ,transamt -- 交易金额
    ,spbrn -- 特许参与者
    ,sndct -- 发报中心（被借记行所在中心）
    ,sndupbrn -- 发起清算行行号
    ,sndbrn -- 发起行行号（被借记行）
    ,paybrn -- 付款人开户行部门号
    ,payopenbrn -- 付款人开户行行号
    ,payopenbanknm -- 付款人开户行名称
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,payaddr -- 付款人地址
    ,rcvct -- 收报中心（被贷记行所在中心）
    ,rcvupbrn -- 接收清算行行号
    ,rcvbrn -- 接收行行号（被贷记行）
    ,incobrn -- 收款人开户行行号
    ,recvopenbanknm -- 收款人开户行名称
    ,incoacct -- 收款人账号
    ,inconame -- 收款人名称
    ,incoaddr -- 收款人地址
    ,servtype -- 业务种类
    ,bustype -- 业务类型
    ,billdt -- 原委托日期
    ,billcode -- 原支付交易序号
    ,orasndbrn -- 原发起参与机构
    ,oracmtno -- 原报文类型
    ,cmpsamt -- 赔偿金金额、拆借利息、出票金额
    ,inrate -- 利率
    ,refuseamt -- 拒付金额
    ,status -- 处理状态
    ,processcode -- 人行业务状态
    ,varseal -- 处理码
    ,ckrvnbr -- 复核冲正流水号
    ,sndrvnbr -- 发送冲正流水号
    ,cleardt -- 清算日期
    ,errcode -- 错误代码
    ,errms -- 错误信息
    ,levels -- 优先级别
    ,oprtlr -- 录入柜员
    ,chktlr -- 复核柜员
    ,sndtlr -- 发送柜员
    ,auttlr -- 授权柜员
    ,stoptlr -- 滞留柜员
    ,oprbrn -- 录入复核柜员部门号
    ,sndtlrbrn -- 发送柜员部门号
    ,autbrn -- 授权柜员部门号
    ,seccode -- 支付密押
    ,chkstatus -- 对账状态
    ,info -- 附言
    ,note -- 备注
    ,note2 -- 备注2
    ,prtcnt -- 打印次数
    ,rcvdt -- 收到时间
    ,transmitdt -- 发送时间、转发时间
    ,billseccode -- 汇票密押
    ,paydt -- 提示付款日期
    ,wlflag -- 往来帐标志
    ,flag2 -- 实时联机标记
    ,flag3 -- 收费标志
    ,flag4 -- 借贷标记
    ,billrqcode -- 汇票申请书号码
    ,sacacct -- 挂帐帐号或确认后入帐帐号
    ,sacname -- 挂帐帐号或维护入账姓名
    ,crdt -- 维护入账日期
    ,crtlr -- 维护入账柜员
    ,crbrn -- 维护入账部门号
    ,cracct -- 清分入帐帐号
    ,crseq -- 清分流水
    ,prodnbr -- 代理标识
    ,tracenbr -- 日志流水号
    ,sndtracenbr -- 发送日志流水
    ,bookcode -- 凭证类型
    ,bookdate -- 凭证日期
    ,bookseqno -- 凭证号码
    ,idtype -- 证件种类
    ,idno -- 证件号码
    ,maxtransamt -- 转帐限额
    ,transnbr -- 交易流水套号
    ,sndtransnbr -- 发送交易流水
    ,changtime -- 修改时间
    ,reserv40 -- 城商行汇票号
    ,rcdver -- 记录更新版本号
    ,rcdstatus -- 记录状态
    ,paymod -- 支付方式
    ,openwintype -- 汇兑业务对应的窗口(交易渠道)
    ,changdate -- 修改日期
    ,servnbr -- 业务流水号
    ,magebrn -- 管理机构
    ,feeamt -- 手续费用金额
    ,feeamt1 -- 汇划费用金额
    ,feeamt2 -- 工本费
    ,feeamt3 -- 备用
    ,linkid -- 链路ID
    ,endtlr -- 取消（冲正）柜员
    ,edhostnbr -- 取消（冲正）交易流水
    ,edhostdt -- 取消（冲正）交易日期
    ,prodcd -- 产品代码
    ,isinout -- 客户帐、内部帐标识
    ,inacct -- 实际扣帐账号
    ,inname -- 实际扣帐户名
    ,ourcnapsver -- 行内系统版本
    ,othercnapsver -- 对手系统版本
    ,landdealsts -- 落地处理状态
    ,checkdealsts -- 查证处理状态
    ,appenddatatable -- 登记附加数据的表名
    ,hangupreason -- 挂账原因代码
    ,modifytlr -- 修改柜员
    ,info2 -- 附言2
    ,cmtno2 -- 二代报文号
    ,bustype2 -- 二代业务类型
    ,servtype2 -- 二代业务种类
    ,feetype -- 收费标志
    ,eaccflg -- 电子账户标志
    ,srcsysssn -- 渠道流水号
    ,od_flag -- 是否触发透支业务
    ,od_ovtranam -- 透支金额
    ,nextdayflag -- 次日转账标识
    ,crotransamt -- 额度变化值
    ,autoflag -- 自动退汇处理标识
    ,autocount -- 自动退汇处理次数
    ,automsg -- 自动退汇处理信息
    ,bindacct -- 绑定账户
    ,bindacctnm -- 绑定账户名
    ,accttype -- 账户类型
    ,bindacctopnbrn -- 绑定账户开户机构
    ,tacctp -- 账户分类标识
    ,limitorderid -- 限额订单号
    ,globalseqno -- 全局流水号
    ,returncode -- ESB接口返回码
    ,returnmsg -- ESB接口返回信息
    ,transseqno -- ESB接口交易流水号
    ,sendouttm -- 发送人行时间
    ,agtflg -- 是否代理
    ,agtidtp -- 代理人证件类型
    ,agtidno -- 代理人证件号码
    ,agtname -- 代理人姓名
    ,agtphone -- 代理人联系方式
    ,acct_typ_id -- 
    ,finaccountid -- 
    ,memocntt -- 
    ,sttlmtype -- 
    ,intrbksttlmdt -- 
    ,budgetary -- 预算级次
    ,exchgflg -- 个人汇兑标识
    ,orisrcsysssn -- 原交易流水
    ,orisyscd -- 原支付通道
    ,redoflag -- 重发标志
    ,dtittp -- 客户类型
    ,g105batflg -- G105批量处理标志：1-是，0-否
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    mainseq -- 支付报单号
    ,transseq -- 支付交易序号（行外）
    ,businesstrace -- 行内业务序号
    ,cmtno -- 报文编号（报文类型）
    ,hosttrcd -- 主机交易码
    ,fronttrcd -- 中台交易码
    ,transdt -- 交易日期
    ,consigndt -- 委托日期
    ,hostdate -- 主机日期
    ,hostnbr -- 主机流水
    ,ccynbr -- 币种
    ,transamt -- 交易金额
    ,spbrn -- 特许参与者
    ,sndct -- 发报中心（被借记行所在中心）
    ,sndupbrn -- 发起清算行行号
    ,sndbrn -- 发起行行号（被借记行）
    ,paybrn -- 付款人开户行部门号
    ,payopenbrn -- 付款人开户行行号
    ,payopenbanknm -- 付款人开户行名称
    ,payacct -- 付款人账号
    ,payname -- 付款人名称
    ,payaddr -- 付款人地址
    ,rcvct -- 收报中心（被贷记行所在中心）
    ,rcvupbrn -- 接收清算行行号
    ,rcvbrn -- 接收行行号（被贷记行）
    ,incobrn -- 收款人开户行行号
    ,recvopenbanknm -- 收款人开户行名称
    ,incoacct -- 收款人账号
    ,inconame -- 收款人名称
    ,incoaddr -- 收款人地址
    ,servtype -- 业务种类
    ,bustype -- 业务类型
    ,billdt -- 原委托日期
    ,billcode -- 原支付交易序号
    ,orasndbrn -- 原发起参与机构
    ,oracmtno -- 原报文类型
    ,cmpsamt -- 赔偿金金额、拆借利息、出票金额
    ,inrate -- 利率
    ,refuseamt -- 拒付金额
    ,status -- 处理状态
    ,processcode -- 人行业务状态
    ,varseal -- 处理码
    ,ckrvnbr -- 复核冲正流水号
    ,sndrvnbr -- 发送冲正流水号
    ,cleardt -- 清算日期
    ,errcode -- 错误代码
    ,errms -- 错误信息
    ,levels -- 优先级别
    ,oprtlr -- 录入柜员
    ,chktlr -- 复核柜员
    ,sndtlr -- 发送柜员
    ,auttlr -- 授权柜员
    ,stoptlr -- 滞留柜员
    ,oprbrn -- 录入复核柜员部门号
    ,sndtlrbrn -- 发送柜员部门号
    ,autbrn -- 授权柜员部门号
    ,seccode -- 支付密押
    ,chkstatus -- 对账状态
    ,info -- 附言
    ,note -- 备注
    ,note2 -- 备注2
    ,prtcnt -- 打印次数
    ,rcvdt -- 收到时间
    ,transmitdt -- 发送时间、转发时间
    ,billseccode -- 汇票密押
    ,paydt -- 提示付款日期
    ,wlflag -- 往来帐标志
    ,flag2 -- 实时联机标记
    ,flag3 -- 收费标志
    ,flag4 -- 借贷标记
    ,billrqcode -- 汇票申请书号码
    ,sacacct -- 挂帐帐号或确认后入帐帐号
    ,sacname -- 挂帐帐号或维护入账姓名
    ,crdt -- 维护入账日期
    ,crtlr -- 维护入账柜员
    ,crbrn -- 维护入账部门号
    ,cracct -- 清分入帐帐号
    ,crseq -- 清分流水
    ,prodnbr -- 代理标识
    ,tracenbr -- 日志流水号
    ,sndtracenbr -- 发送日志流水
    ,bookcode -- 凭证类型
    ,bookdate -- 凭证日期
    ,bookseqno -- 凭证号码
    ,idtype -- 证件种类
    ,idno -- 证件号码
    ,maxtransamt -- 转帐限额
    ,transnbr -- 交易流水套号
    ,sndtransnbr -- 发送交易流水
    ,changtime -- 修改时间
    ,reserv40 -- 城商行汇票号
    ,rcdver -- 记录更新版本号
    ,rcdstatus -- 记录状态
    ,paymod -- 支付方式
    ,openwintype -- 汇兑业务对应的窗口(交易渠道)
    ,changdate -- 修改日期
    ,servnbr -- 业务流水号
    ,magebrn -- 管理机构
    ,feeamt -- 手续费用金额
    ,feeamt1 -- 汇划费用金额
    ,feeamt2 -- 工本费
    ,feeamt3 -- 备用
    ,linkid -- 链路ID
    ,endtlr -- 取消（冲正）柜员
    ,edhostnbr -- 取消（冲正）交易流水
    ,edhostdt -- 取消（冲正）交易日期
    ,prodcd -- 产品代码
    ,isinout -- 客户帐、内部帐标识
    ,inacct -- 实际扣帐账号
    ,inname -- 实际扣帐户名
    ,ourcnapsver -- 行内系统版本
    ,othercnapsver -- 对手系统版本
    ,landdealsts -- 落地处理状态
    ,checkdealsts -- 查证处理状态
    ,appenddatatable -- 登记附加数据的表名
    ,hangupreason -- 挂账原因代码
    ,modifytlr -- 修改柜员
    ,info2 -- 附言2
    ,cmtno2 -- 二代报文号
    ,bustype2 -- 二代业务类型
    ,servtype2 -- 二代业务种类
    ,feetype -- 收费标志
    ,eaccflg -- 电子账户标志
    ,srcsysssn -- 渠道流水号
    ,od_flag -- 是否触发透支业务
    ,od_ovtranam -- 透支金额
    ,nextdayflag -- 次日转账标识
    ,crotransamt -- 额度变化值
    ,autoflag -- 自动退汇处理标识
    ,autocount -- 自动退汇处理次数
    ,automsg -- 自动退汇处理信息
    ,bindacct -- 绑定账户
    ,bindacctnm -- 绑定账户名
    ,accttype -- 账户类型
    ,bindacctopnbrn -- 绑定账户开户机构
    ,tacctp -- 账户分类标识
    ,limitorderid -- 限额订单号
    ,globalseqno -- 全局流水号
    ,returncode -- ESB接口返回码
    ,returnmsg -- ESB接口返回信息
    ,transseqno -- ESB接口交易流水号
    ,sendouttm -- 发送人行时间
    ,agtflg -- 是否代理
    ,agtidtp -- 代理人证件类型
    ,agtidno -- 代理人证件号码
    ,agtname -- 代理人姓名
    ,agtphone -- 代理人联系方式
    ,acct_typ_id -- 
    ,finaccountid -- 
    ,memocntt -- 
    ,sttlmtype -- 
    ,intrbksttlmdt -- 
    ,budgetary -- 预算级次
    ,exchgflg -- 个人汇兑标识
    ,orisrcsysssn -- 原交易流水
    ,orisyscd -- 原支付通道
    ,redoflag -- 重发标志
    ,dtittp -- 客户类型
    ,g105batflg -- G105批量处理标志：1-是，0-否
    ,to_date(transdt,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a08thvtrx
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08thvtrx to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a08thvtrx_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08thvtrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);