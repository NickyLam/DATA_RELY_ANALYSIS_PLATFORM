/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_osbs_ats_pub_trade_flow
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
drop table ${iol_schema}.osbs_ats_pub_trade_flow_ex purge;
alter table ${iol_schema}.osbs_ats_pub_trade_flow add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

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
    v_sql := 'select count(0) from user_tab_partitions where table_name = upper(''osbs_ats_pub_trade_flow'') and PARTITION_NAME = ''P_'||bat_dt||''' ';
    execute immediate v_sql into v_p_exists;
    -- exists patitions
    if v_p_exists = 1 then 
        v_sql := 'alter table iol.osbs_ats_pub_trade_flow truncate partition p_'||bat_dt ;
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    --no exists partitions  
    else 
        v_sql := 'alter table iol.osbs_ats_pub_trade_flow add partition p_'||bat_dt||' values (to_date('''||bat_dt||''',''yyyymmdd'')) ';
        dbms_output.put_line(v_sql);
        execute immediate v_sql;
    end if;
      end loop;
end;
/


-- 2.3 insert data to ex table
create table ${iol_schema}.osbs_ats_pub_trade_flow_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.osbs_ats_pub_trade_flow where 0=1;

insert /*+ append */ into ${iol_schema}.osbs_ats_pub_trade_flow(
    ptf_trade_flowno -- 流水号
    ,ptf_transtime -- 交易时间
    ,ptf_transcode -- 交易码
    ,ptf_state -- 交易状态(90:交易成功;99:交易失败;33:通讯异常;50:交易初始状态;10:待授权;11:授权中;12:授权完成)
    ,ptf_returncode -- 交易返回码
    ,ptf_returnmsg -- 失败原因
    ,ptf_accno -- 交易账号
    ,ptf_amonut -- 交易金额
    ,ptf_currency -- 币种
    ,ptf_ecifno -- 全行统一客户号
    ,ptf_userno -- 用户顺序号
    ,ptf_channel -- 交易渠道
    ,ptf_sendflowno -- 渠道发送流水号
    ,ptf_src_sendflowno -- 源系统流水号
    ,ptf_hostflowno -- 核心交易流水号
    ,ptf_fee -- 手续费
    ,ptf_accessflowno -- 访问流水号
    ,ptf_host_returntime -- 核心交易日期
    ,ptf_svrtranscode -- 被调方交易编码
    ,ptf_customerip -- 客户IP
    ,ptf_hostname -- 当前服务器主机名
    ,ptf_src_serverip -- 请求来源服务器IP
    ,ptf_clientmac -- 客户终端MAC地址
    ,ptf_clientos -- 客户终端操作系统
    ,ptf_clientbrowser -- 客户终端浏览器
    ,ptf_clientnunittype -- 客户终端设备型号
    ,ptf_clientterminateno -- 客户终端设备ID
    ,ptf_sessionid -- 登陆sessionID
    ,ptf_relflowno -- 关联流水号
    ,ptf_trade_inf -- 交易日志信息
    ,ptf_transtype -- 交易类型
    ,ptf_ecifname -- 客户姓名
    ,ptf_securitytype -- 安全认证方式
    ,ptf_menuid -- 功能菜单ID
    ,ptf_marketing_number -- 营销工号
    ,ptf_businessno -- 人行流水号
    ,tx_seq_num -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,biz_seq_num -- 系统内流水号
    ,ptf_channelcode -- 
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ptf_trade_flowno -- 流水号
    ,ptf_transtime -- 交易时间
    ,ptf_transcode -- 交易码
    ,ptf_state -- 交易状态(90:交易成功;99:交易失败;33:通讯异常;50:交易初始状态;10:待授权;11:授权中;12:授权完成)
    ,ptf_returncode -- 交易返回码
    ,ptf_returnmsg -- 失败原因
    ,ptf_accno -- 交易账号
    ,ptf_amonut -- 交易金额
    ,ptf_currency -- 币种
    ,ptf_ecifno -- 全行统一客户号
    ,ptf_userno -- 用户顺序号
    ,ptf_channel -- 交易渠道
    ,ptf_sendflowno -- 渠道发送流水号
    ,ptf_src_sendflowno -- 源系统流水号
    ,ptf_hostflowno -- 核心交易流水号
    ,ptf_fee -- 手续费
    ,ptf_accessflowno -- 访问流水号
    ,ptf_host_returntime -- 核心交易日期
    ,ptf_svrtranscode -- 被调方交易编码
    ,ptf_customerip -- 客户IP
    ,ptf_hostname -- 当前服务器主机名
    ,ptf_src_serverip -- 请求来源服务器IP
    ,ptf_clientmac -- 客户终端MAC地址
    ,ptf_clientos -- 客户终端操作系统
    ,ptf_clientbrowser -- 客户终端浏览器
    ,ptf_clientnunittype -- 客户终端设备型号
    ,ptf_clientterminateno -- 客户终端设备ID
    ,ptf_sessionid -- 登陆sessionID
    ,ptf_relflowno -- 关联流水号
    ,ptf_trade_inf -- 交易日志信息
    ,ptf_transtype -- 交易类型
    ,ptf_ecifname -- 客户姓名
    ,ptf_securitytype -- 安全认证方式
    ,ptf_menuid -- 功能菜单ID
    ,ptf_marketing_number -- 营销工号
    ,ptf_businessno -- 人行流水号
    ,tx_seq_num -- 交易订单号
    ,chain_way_track_no -- 链路跟踪号
    ,biz_seq_num -- 系统内流水号
    ,ptf_channelcode -- 
    ,to_date(SUBSTR(ptf_transtime,1,8),'yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.osbs_ats_pub_trade_flow
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table


-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.osbs_ats_pub_trade_flow to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.osbs_ats_pub_trade_flow_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'osbs_ats_pub_trade_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);