/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fzss_mod_fzs_bookkeep_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.fzss_mod_fzs_bookkeep_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fzss_mod_fzs_bookkeep_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_bookkeep_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_bookkeep_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_bookkeep_info_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.fzss_mod_fzs_bookkeep_info where 0=1;

create table ${iol_schema}.fzss_mod_fzs_bookkeep_info_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.fzss_mod_fzs_bookkeep_info where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.fzss_mod_fzs_bookkeep_info_op(
        plat_date -- 系统日期 yyyyMMdd
        ,plat_time -- 系统时间 HHmmss
        ,plat_serial_no -- 系统流水
        ,corp_work_date -- 平台日期
        ,order_no -- 订单号/子订单号
        ,corp_id -- 平台商户号
        ,mybank -- 法人标识代码
        ,zone_no -- 分行号
        ,tran_type -- 交易类型 [枚举: B01-支付订单充值, B02-支付订单充值撤销, B03-支付订单充值退款, B11-先用后付垫资, C01-分账请求, C02-分账退回, C03-补差申请, C05-白名单资金划拨, C06-功能户划拨, C07-白名单资金划拨退回, D01-提现, T01-退汇, T02-普通入账, T03-提现冲正]
        ,acct_no -- 客户账号
        ,acct_name -- 账户名称
        ,tran_amt -- 交易金额
        ,dc_flag -- 借贷方向 [枚举: D-借,C-贷]
        ,reverse_flag -- 被退汇标志 [枚举: 1：是（表示本记录被退汇） 2：否]
        ,to_acct_no -- 对方账号
        ,to_acct_name -- 对方户名
        ,effect_type -- 影响余额类型 [枚举: 0-可提,1-待清算,2-冻结,]
        ,cal_flag -- 更新余额标识 [枚举: 0-未更新,1-已更新]
        ,clear_status -- 清算状态 [枚举: 0-未清算,1-已清算]
        ,clear_date -- 清算日期
        ,abst_desc -- 摘要描述
        ,tellerno -- 柜员号
        ,brno -- 机构号
        ,fund_date -- 退汇系统日期
        ,fund_serial_no -- 退汇系统流水号
        ,remark -- 备注
        ,error_code -- 返回码 [枚举: 0为成功，其他为失败]
        ,error_msg -- 返回信息
        ,create_timestamp -- 创建时间戳
        ,update_timestamp -- 更新时间戳
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.plat_date -- 系统日期 yyyyMMdd
    ,n.plat_time -- 系统时间 HHmmss
    ,n.plat_serial_no -- 系统流水
    ,n.corp_work_date -- 平台日期
    ,n.order_no -- 订单号/子订单号
    ,n.corp_id -- 平台商户号
    ,n.mybank -- 法人标识代码
    ,n.zone_no -- 分行号
    ,n.tran_type -- 交易类型 [枚举: B01-支付订单充值, B02-支付订单充值撤销, B03-支付订单充值退款, B11-先用后付垫资, C01-分账请求, C02-分账退回, C03-补差申请, C05-白名单资金划拨, C06-功能户划拨, C07-白名单资金划拨退回, D01-提现, T01-退汇, T02-普通入账, T03-提现冲正]
    ,n.acct_no -- 客户账号
    ,n.acct_name -- 账户名称
    ,n.tran_amt -- 交易金额
    ,n.dc_flag -- 借贷方向 [枚举: D-借,C-贷]
    ,n.reverse_flag -- 被退汇标志 [枚举: 1：是（表示本记录被退汇） 2：否]
    ,n.to_acct_no -- 对方账号
    ,n.to_acct_name -- 对方户名
    ,n.effect_type -- 影响余额类型 [枚举: 0-可提,1-待清算,2-冻结,]
    ,n.cal_flag -- 更新余额标识 [枚举: 0-未更新,1-已更新]
    ,n.clear_status -- 清算状态 [枚举: 0-未清算,1-已清算]
    ,n.clear_date -- 清算日期
    ,n.abst_desc -- 摘要描述
    ,n.tellerno -- 柜员号
    ,n.brno -- 机构号
    ,n.fund_date -- 退汇系统日期
    ,n.fund_serial_no -- 退汇系统流水号
    ,n.remark -- 备注
    ,n.error_code -- 返回码 [枚举: 0为成功，其他为失败]
    ,n.error_msg -- 返回信息
    ,n.create_timestamp -- 创建时间戳
    ,n.update_timestamp -- 更新时间戳
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fzss_mod_fzs_bookkeep_info_bk o
    right join (select * from ${itl_schema}.fzss_mod_fzs_bookkeep_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.plat_date = n.plat_date
            and o.plat_serial_no = n.plat_serial_no
where (
        o.plat_date is null
        and o.plat_serial_no is null
    )
    or (
        o.plat_time <> n.plat_time
        or o.corp_work_date <> n.corp_work_date
        or o.order_no <> n.order_no
        or o.corp_id <> n.corp_id
        or o.mybank <> n.mybank
        or o.zone_no <> n.zone_no
        or o.tran_type <> n.tran_type
        or o.acct_no <> n.acct_no
        or o.acct_name <> n.acct_name
        or o.tran_amt <> n.tran_amt
        or o.dc_flag <> n.dc_flag
        or o.reverse_flag <> n.reverse_flag
        or o.to_acct_no <> n.to_acct_no
        or o.to_acct_name <> n.to_acct_name
        or o.effect_type <> n.effect_type
        or o.cal_flag <> n.cal_flag
        or o.clear_status <> n.clear_status
        or o.clear_date <> n.clear_date
        or o.abst_desc <> n.abst_desc
        or o.tellerno <> n.tellerno
        or o.brno <> n.brno
        or o.fund_date <> n.fund_date
        or o.fund_serial_no <> n.fund_serial_no
        or o.remark <> n.remark
        or o.error_code <> n.error_code
        or o.error_msg <> n.error_msg
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fzss_mod_fzs_bookkeep_info_cl(
            plat_date -- 系统日期 yyyyMMdd
        ,plat_time -- 系统时间 HHmmss
        ,plat_serial_no -- 系统流水
        ,corp_work_date -- 平台日期
        ,order_no -- 订单号/子订单号
        ,corp_id -- 平台商户号
        ,mybank -- 法人标识代码
        ,zone_no -- 分行号
        ,tran_type -- 交易类型 [枚举: B01-支付订单充值, B02-支付订单充值撤销, B03-支付订单充值退款, B11-先用后付垫资, C01-分账请求, C02-分账退回, C03-补差申请, C05-白名单资金划拨, C06-功能户划拨, C07-白名单资金划拨退回, D01-提现, T01-退汇, T02-普通入账, T03-提现冲正]
        ,acct_no -- 客户账号
        ,acct_name -- 账户名称
        ,tran_amt -- 交易金额
        ,dc_flag -- 借贷方向 [枚举: D-借,C-贷]
        ,reverse_flag -- 被退汇标志 [枚举: 1：是（表示本记录被退汇） 2：否]
        ,to_acct_no -- 对方账号
        ,to_acct_name -- 对方户名
        ,effect_type -- 影响余额类型 [枚举: 0-可提,1-待清算,2-冻结,]
        ,cal_flag -- 更新余额标识 [枚举: 0-未更新,1-已更新]
        ,clear_status -- 清算状态 [枚举: 0-未清算,1-已清算]
        ,clear_date -- 清算日期
        ,abst_desc -- 摘要描述
        ,tellerno -- 柜员号
        ,brno -- 机构号
        ,fund_date -- 退汇系统日期
        ,fund_serial_no -- 退汇系统流水号
        ,remark -- 备注
        ,error_code -- 返回码 [枚举: 0为成功，其他为失败]
        ,error_msg -- 返回信息
        ,create_timestamp -- 创建时间戳
        ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fzss_mod_fzs_bookkeep_info_op(
            plat_date -- 系统日期 yyyyMMdd
        ,plat_time -- 系统时间 HHmmss
        ,plat_serial_no -- 系统流水
        ,corp_work_date -- 平台日期
        ,order_no -- 订单号/子订单号
        ,corp_id -- 平台商户号
        ,mybank -- 法人标识代码
        ,zone_no -- 分行号
        ,tran_type -- 交易类型 [枚举: B01-支付订单充值, B02-支付订单充值撤销, B03-支付订单充值退款, B11-先用后付垫资, C01-分账请求, C02-分账退回, C03-补差申请, C05-白名单资金划拨, C06-功能户划拨, C07-白名单资金划拨退回, D01-提现, T01-退汇, T02-普通入账, T03-提现冲正]
        ,acct_no -- 客户账号
        ,acct_name -- 账户名称
        ,tran_amt -- 交易金额
        ,dc_flag -- 借贷方向 [枚举: D-借,C-贷]
        ,reverse_flag -- 被退汇标志 [枚举: 1：是（表示本记录被退汇） 2：否]
        ,to_acct_no -- 对方账号
        ,to_acct_name -- 对方户名
        ,effect_type -- 影响余额类型 [枚举: 0-可提,1-待清算,2-冻结,]
        ,cal_flag -- 更新余额标识 [枚举: 0-未更新,1-已更新]
        ,clear_status -- 清算状态 [枚举: 0-未清算,1-已清算]
        ,clear_date -- 清算日期
        ,abst_desc -- 摘要描述
        ,tellerno -- 柜员号
        ,brno -- 机构号
        ,fund_date -- 退汇系统日期
        ,fund_serial_no -- 退汇系统流水号
        ,remark -- 备注
        ,error_code -- 返回码 [枚举: 0为成功，其他为失败]
        ,error_msg -- 返回信息
        ,create_timestamp -- 创建时间戳
        ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.plat_date -- 系统日期 yyyyMMdd
    ,o.plat_time -- 系统时间 HHmmss
    ,o.plat_serial_no -- 系统流水
    ,o.corp_work_date -- 平台日期
    ,o.order_no -- 订单号/子订单号
    ,o.corp_id -- 平台商户号
    ,o.mybank -- 法人标识代码
    ,o.zone_no -- 分行号
    ,o.tran_type -- 交易类型 [枚举: B01-支付订单充值, B02-支付订单充值撤销, B03-支付订单充值退款, B11-先用后付垫资, C01-分账请求, C02-分账退回, C03-补差申请, C05-白名单资金划拨, C06-功能户划拨, C07-白名单资金划拨退回, D01-提现, T01-退汇, T02-普通入账, T03-提现冲正]
    ,o.acct_no -- 客户账号
    ,o.acct_name -- 账户名称
    ,o.tran_amt -- 交易金额
    ,o.dc_flag -- 借贷方向 [枚举: D-借,C-贷]
    ,o.reverse_flag -- 被退汇标志 [枚举: 1：是（表示本记录被退汇） 2：否]
    ,o.to_acct_no -- 对方账号
    ,o.to_acct_name -- 对方户名
    ,o.effect_type -- 影响余额类型 [枚举: 0-可提,1-待清算,2-冻结,]
    ,o.cal_flag -- 更新余额标识 [枚举: 0-未更新,1-已更新]
    ,o.clear_status -- 清算状态 [枚举: 0-未清算,1-已清算]
    ,o.clear_date -- 清算日期
    ,o.abst_desc -- 摘要描述
    ,o.tellerno -- 柜员号
    ,o.brno -- 机构号
    ,o.fund_date -- 退汇系统日期
    ,o.fund_serial_no -- 退汇系统流水号
    ,o.remark -- 备注
    ,o.error_code -- 返回码 [枚举: 0为成功，其他为失败]
    ,o.error_msg -- 返回信息
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.fzss_mod_fzs_bookkeep_info_bk o
    left join ${iol_schema}.fzss_mod_fzs_bookkeep_info_op n
        on
            o.plat_date = n.plat_date
            and o.plat_serial_no = n.plat_serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fzss_mod_fzs_bookkeep_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fzss_mod_fzs_bookkeep_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fzss_mod_fzs_bookkeep_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fzss_mod_fzs_bookkeep_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fzss_mod_fzs_bookkeep_info exchange partition p_${batch_date} with table ${iol_schema}.fzss_mod_fzs_bookkeep_info_cl;
alter table ${iol_schema}.fzss_mod_fzs_bookkeep_info exchange partition p_20991231 with table ${iol_schema}.fzss_mod_fzs_bookkeep_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fzss_mod_fzs_bookkeep_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_bookkeep_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_bookkeep_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fzss_mod_fzs_bookkeep_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fzss_mod_fzs_bookkeep_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
