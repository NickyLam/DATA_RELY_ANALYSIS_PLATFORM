/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a10tibpsdetaillog
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
drop table ${iol_schema}.mpcs_a10tibpsdetaillog_ex purge;
alter table ${iol_schema}.mpcs_a10tibpsdetaillog add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''mpcs_a10tibpsdetaillog'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.mpcs_a10tibpsdetaillog truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.mpcs_a10tibpsdetaillog add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a10tibpsdetaillog_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a10tibpsdetaillog where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a10tibpsdetaillog(
    function -- 主机交易码
    ,function1 -- 前置交易码
    ,function2 -- 人行交易代码
    ,businesstrace -- 行内业务序号
    ,businessno -- 业务序号
    ,hostretcode -- 主机结果代码
    ,processcode -- 人行业务状态
    ,rscode -- 拒绝原因代码
    ,functype -- 人行业务类型
    ,businesskind -- 人行业务种类
    ,businesstype -- 与主机对账状态
    ,batch -- 场次
    ,amount -- 交易金额
    ,kind -- 币种
    ,settlestat -- 与人行对账状态
    ,trace -- 前置机流水号
    ,hosttrace -- 主机流水号
    ,ticket -- 传票号
    ,node -- 交易网点
    ,operater -- 操作员号
    ,governor1 -- 主管号一
    ,governor2 -- 主管号二
    ,terminal -- 终端号
    ,printstat -- 网点打印标志
    ,printstat1 -- 临时打印标志
    ,printtime -- 打印次数
    ,subj -- 科目号
    ,vouchkind -- 凭证类型
    ,vouch -- 凭证号码
    ,billrecdate -- 票面记载日期
    ,date0 -- 提出提回日期
    ,date1 -- 记帐日期
    ,date2 -- 送银行日期
    ,dealdate -- 人行处理日期
    ,trantime -- 行内系统受理时间
    ,sendtime -- 业务发起时间
    ,level0 -- 提交优先级
    ,flag1 -- 提出提回标记
    ,flag2 -- 实时联机标记
    ,flag3 -- 收费标志
    ,flag4 -- 借贷标记
    ,acceptbank -- 收款(查询)行行号
    ,acceptbankname -- 收款(查询)行行名
    ,acceptacct -- 收款(查询)人帐号
    ,acceptname -- 收款(查询)人姓名
    ,acceptaccttype -- 收款(查询)人账户类型
    ,sendbank -- 付款(被查询)行行号
    ,sendbankname -- 付款(被查询)行行名
    ,sendacct -- 付款(被查询)人帐号
    ,sendname -- 付款(被查询)人姓名
    ,sendaccttype -- 付款(被查询)人账户类型
    ,msgoutbank -- 发报行行号
    ,msginbank -- 收报行行号
    ,status -- 交易状态
    ,counter -- 渠道
    ,fill -- 保留
    ,rejectbank -- 拒绝业务的机构行号
    ,outsdficode -- 付款(被查询)清算行行号
    ,insdficode -- 收款(查询)清算行行号
    ,sendopenbank -- 付款(被查询)人开户行行号
    ,acceptopenbank -- 收款(查询)人开户行行号
    ,sendcitycode -- 付款(被查询)人开户行所属城市代码
    ,acceptcitycode -- 收款(查询)人开户行所属城市代码
    ,chargefee -- 手续费
    ,postfee -- 邮电费
    ,thirdchargefee -- 第三方机构手续费金额
    ,settleamount -- 结算金额
    ,endtoendid -- 端到端标识号、网上交易单号
    ,authtype -- 认证方式
    ,authinfo -- 认证信息
    ,authid -- 预授权号
    ,merchantcode -- 商户号
    ,merchantname -- 商户名称
    ,onlinetrantrace -- 第三方机构行号、收取手续费的参与机构号
    ,onlinetrantime -- 网上交易时间
    ,onlinetrandesc -- 网上交易说明
    ,opennode -- 开户网点号
    ,chmoment -- 附言
    ,coldate -- 对账日期
    ,url -- URL
    ,dealcolflag -- 对账处理标志
    ,dataid -- 交易索引号
    ,eaccflg -- 电子账户标志
    ,transno -- 电子账户记账请求流水
    ,nextdayflag -- 次日达标识
    ,bingflag -- 监管账户
    ,bingacct -- 监管账号
    ,bingacctnm -- 监管账号户名
    ,bingacctopeninst -- 监管账号开户机构
    ,accttype -- 账户类型
    ,opertype -- 签约类型
    ,backflag -- 退款标志
    ,orgnlmsgid -- 原报文标识号
    ,orgnlmmbid -- 发起参与机构行号
    ,abscde -- 会记分录
    ,tacctp -- 账户类别
    ,handleflag -- 是否预绑
    ,custno -- 客户号
    ,otpseqno -- 短信验证序列号
    ,mobile -- 手机号码
    ,sendidcode -- 证件号
    ,traceseqno -- 超级网银记账流水关联序号
    ,limitorderid -- 限额订单号
    ,isbindcard -- 是否绑定标志
    ,globalseqno -- 全局流水号
    ,returncode -- ESB接口返回码
    ,returnmsg -- ESB接口返回信息
    ,transseqno -- ESB接口交易流水号
    ,finaccountid -- 产品账户
    ,memocntt -- 摘要码
    ,backacctdt -- 返回的第三方记账日期
    ,backacctseq -- 返回的第三方记账流水
    ,unique_seq_num -- 业务流水号
    ,chn_id -- 渠道id
    ,srvcfee -- 服务费用
    ,deductmut -- 扣款时间单位
    ,deductintvl -- 扣款时间间隔
    ,agramt -- 约定额度
    ,odamt -- 透支金额
    ,odflag -- 透支标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    function -- 主机交易码
    ,function1 -- 前置交易码
    ,function2 -- 人行交易代码
    ,businesstrace -- 行内业务序号
    ,businessno -- 业务序号
    ,hostretcode -- 主机结果代码
    ,processcode -- 人行业务状态
    ,rscode -- 拒绝原因代码
    ,functype -- 人行业务类型
    ,businesskind -- 人行业务种类
    ,businesstype -- 与主机对账状态
    ,batch -- 场次
    ,amount -- 交易金额
    ,kind -- 币种
    ,settlestat -- 与人行对账状态
    ,trace -- 前置机流水号
    ,hosttrace -- 主机流水号
    ,ticket -- 传票号
    ,node -- 交易网点
    ,operater -- 操作员号
    ,governor1 -- 主管号一
    ,governor2 -- 主管号二
    ,terminal -- 终端号
    ,printstat -- 网点打印标志
    ,printstat1 -- 临时打印标志
    ,printtime -- 打印次数
    ,subj -- 科目号
    ,vouchkind -- 凭证类型
    ,vouch -- 凭证号码
    ,billrecdate -- 票面记载日期
    ,date0 -- 提出提回日期
    ,date1 -- 记帐日期
    ,date2 -- 送银行日期
    ,dealdate -- 人行处理日期
    ,trantime -- 行内系统受理时间
    ,sendtime -- 业务发起时间
    ,level0 -- 提交优先级
    ,flag1 -- 提出提回标记
    ,flag2 -- 实时联机标记
    ,flag3 -- 收费标志
    ,flag4 -- 借贷标记
    ,acceptbank -- 收款(查询)行行号
    ,acceptbankname -- 收款(查询)行行名
    ,acceptacct -- 收款(查询)人帐号
    ,acceptname -- 收款(查询)人姓名
    ,acceptaccttype -- 收款(查询)人账户类型
    ,sendbank -- 付款(被查询)行行号
    ,sendbankname -- 付款(被查询)行行名
    ,sendacct -- 付款(被查询)人帐号
    ,sendname -- 付款(被查询)人姓名
    ,sendaccttype -- 付款(被查询)人账户类型
    ,msgoutbank -- 发报行行号
    ,msginbank -- 收报行行号
    ,status -- 交易状态
    ,counter -- 渠道
    ,fill -- 保留
    ,rejectbank -- 拒绝业务的机构行号
    ,outsdficode -- 付款(被查询)清算行行号
    ,insdficode -- 收款(查询)清算行行号
    ,sendopenbank -- 付款(被查询)人开户行行号
    ,acceptopenbank -- 收款(查询)人开户行行号
    ,sendcitycode -- 付款(被查询)人开户行所属城市代码
    ,acceptcitycode -- 收款(查询)人开户行所属城市代码
    ,chargefee -- 手续费
    ,postfee -- 邮电费
    ,thirdchargefee -- 第三方机构手续费金额
    ,settleamount -- 结算金额
    ,endtoendid -- 端到端标识号、网上交易单号
    ,authtype -- 认证方式
    ,authinfo -- 认证信息
    ,authid -- 预授权号
    ,merchantcode -- 商户号
    ,merchantname -- 商户名称
    ,onlinetrantrace -- 第三方机构行号、收取手续费的参与机构号
    ,onlinetrantime -- 网上交易时间
    ,onlinetrandesc -- 网上交易说明
    ,opennode -- 开户网点号
    ,chmoment -- 附言
    ,coldate -- 对账日期
    ,url -- URL
    ,dealcolflag -- 对账处理标志
    ,dataid -- 交易索引号
    ,eaccflg -- 电子账户标志
    ,transno -- 电子账户记账请求流水
    ,nextdayflag -- 次日达标识
    ,bingflag -- 监管账户
    ,bingacct -- 监管账号
    ,bingacctnm -- 监管账号户名
    ,bingacctopeninst -- 监管账号开户机构
    ,accttype -- 账户类型
    ,opertype -- 签约类型
    ,backflag -- 退款标志
    ,orgnlmsgid -- 原报文标识号
    ,orgnlmmbid -- 发起参与机构行号
    ,abscde -- 会记分录
    ,tacctp -- 账户类别
    ,handleflag -- 是否预绑
    ,custno -- 客户号
    ,otpseqno -- 短信验证序列号
    ,mobile -- 手机号码
    ,sendidcode -- 证件号
    ,traceseqno -- 超级网银记账流水关联序号
    ,limitorderid -- 限额订单号
    ,isbindcard -- 是否绑定标志
    ,globalseqno -- 全局流水号
    ,returncode -- ESB接口返回码
    ,returnmsg -- ESB接口返回信息
    ,transseqno -- ESB接口交易流水号
    ,finaccountid -- 产品账户
    ,memocntt -- 摘要码
    ,backacctdt -- 返回的第三方记账日期
    ,backacctseq -- 返回的第三方记账流水
    ,unique_seq_num -- 业务流水号
    ,chn_id -- 渠道id
    ,srvcfee -- 服务费用
    ,deductmut -- 扣款时间单位
    ,deductintvl -- 扣款时间间隔
    ,agramt -- 约定额度
    ,odamt -- 透支金额
    ,odflag -- 透支标志
    ,to_date(date2,'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a10tibpsdetaillog
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a10tibpsdetaillog to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a10tibpsdetaillog_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a10tibpsdetaillog',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);