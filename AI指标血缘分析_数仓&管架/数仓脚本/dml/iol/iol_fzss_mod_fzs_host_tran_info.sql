/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fzss_mod_fzs_host_tran_info
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
create table ${iol_schema}.fzss_mod_fzs_host_tran_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fzss_mod_fzs_host_tran_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_host_tran_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_host_tran_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_host_tran_info_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.fzss_mod_fzs_host_tran_info where 0=1;

create table ${iol_schema}.fzss_mod_fzs_host_tran_info_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.fzss_mod_fzs_host_tran_info where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.fzss_mod_fzs_host_tran_info_op(
        plat_date -- 系统日期 yyyyMMdd
        ,plat_time -- 系统时间 HHmmss
        ,plat_serial_no -- 系统流水
        ,channel_no -- 渠道编号 3位英文系统编号,如FZS,PPP
        ,mybank -- 法人标识代码
        ,zone_no -- 分行号
        ,tellerno -- 柜员号
        ,brno -- 机构号
        ,corp_id -- 平台商户号
        ,global_serial_no -- 全局流水号
        ,corp_work_date -- 平台订单日期
        ,order_no -- 订单号
        ,plat_tran_type -- 平台交易类型 [枚举: D01-提现,T01-退汇,T02-普通入账]
        ,acct_no -- 交易账号
        ,acct_name -- 账户名称
        ,currency -- 币种
        ,tran_amt -- 交易金额
        ,revtranf -- 正反交易标志(0-正交易,1-冲正交易,) [枚举: 反交易标志(0-正交易,1-冲正交易,)]
        ,dc_flag -- 借贷方向 [枚举: D-借,C-贷]
        ,to_acct_no -- 对方账号
        ,to_acct_name -- 对方户名
        ,to_final_inst_code -- 对方金融机构代码
        ,to_final_inst_name -- 对方金融机构名称
        ,cnaps_branch_id -- 联行号
        ,bank_flag -- 行内外标志 [枚举: 1-行内,2-行外]
        ,abst_code -- 摘要码
        ,abst_desc -- 摘要描述
        ,ppp_check_code -- ppp对账代码
        ,ppp_srv_cllpty_trx_seq -- 记账系统内流水号
        ,ppp_status -- 记账平台状态 [枚举: 9-待处理,0-成功,1-失败,2-异常,3-处理中,]
        ,ppp_code -- 记账结果代码
        ,ppp_msg -- 记账结果信息
        ,ppp_date -- 记账平台交易日期
        ,ppp_time -- 记账平台交易时间
        ,ppp_serial_no -- 记账平台交易流水号
        ,ppp_chnl_encd -- ppp通道编码
        ,ppp_seq_no -- 记账平台交易序号
        ,host_date -- 核心交易日期
        ,host_time -- 核心交易时间
        ,host_serial_no -- 核心交易流水号
        ,check_status -- 对账状态 [枚举: 0-未对账,1-已对账]
        ,is_check_deal -- 是否差错处理 [枚举: 0-否,1-是]
        ,fund_flag -- 退汇标识 [枚举: 0-未退汇,1-已退汇,]
        ,fund_date -- 退汇通知日期
        ,fund_serial_no -- 退汇通知流水
        ,fund_reason -- 退汇原因
        ,reversal_flag -- 冲正标识
        ,reversal_date -- 冲正日期
        ,reversal_serial_no -- 冲正流水号
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
    ,n.channel_no -- 渠道编号 3位英文系统编号,如FZS,PPP
    ,n.mybank -- 法人标识代码
    ,n.zone_no -- 分行号
    ,n.tellerno -- 柜员号
    ,n.brno -- 机构号
    ,n.corp_id -- 平台商户号
    ,n.global_serial_no -- 全局流水号
    ,n.corp_work_date -- 平台订单日期
    ,n.order_no -- 订单号
    ,n.plat_tran_type -- 平台交易类型 [枚举: D01-提现,T01-退汇,T02-普通入账]
    ,n.acct_no -- 交易账号
    ,n.acct_name -- 账户名称
    ,n.currency -- 币种
    ,n.tran_amt -- 交易金额
    ,n.revtranf -- 正反交易标志(0-正交易,1-冲正交易,) [枚举: 反交易标志(0-正交易,1-冲正交易,)]
    ,n.dc_flag -- 借贷方向 [枚举: D-借,C-贷]
    ,n.to_acct_no -- 对方账号
    ,n.to_acct_name -- 对方户名
    ,n.to_final_inst_code -- 对方金融机构代码
    ,n.to_final_inst_name -- 对方金融机构名称
    ,n.cnaps_branch_id -- 联行号
    ,n.bank_flag -- 行内外标志 [枚举: 1-行内,2-行外]
    ,n.abst_code -- 摘要码
    ,n.abst_desc -- 摘要描述
    ,n.ppp_check_code -- ppp对账代码
    ,n.ppp_srv_cllpty_trx_seq -- 记账系统内流水号
    ,n.ppp_status -- 记账平台状态 [枚举: 9-待处理,0-成功,1-失败,2-异常,3-处理中,]
    ,n.ppp_code -- 记账结果代码
    ,n.ppp_msg -- 记账结果信息
    ,n.ppp_date -- 记账平台交易日期
    ,n.ppp_time -- 记账平台交易时间
    ,n.ppp_serial_no -- 记账平台交易流水号
    ,n.ppp_chnl_encd -- ppp通道编码
    ,n.ppp_seq_no -- 记账平台交易序号
    ,n.host_date -- 核心交易日期
    ,n.host_time -- 核心交易时间
    ,n.host_serial_no -- 核心交易流水号
    ,n.check_status -- 对账状态 [枚举: 0-未对账,1-已对账]
    ,n.is_check_deal -- 是否差错处理 [枚举: 0-否,1-是]
    ,n.fund_flag -- 退汇标识 [枚举: 0-未退汇,1-已退汇,]
    ,n.fund_date -- 退汇通知日期
    ,n.fund_serial_no -- 退汇通知流水
    ,n.fund_reason -- 退汇原因
    ,n.reversal_flag -- 冲正标识
    ,n.reversal_date -- 冲正日期
    ,n.reversal_serial_no -- 冲正流水号
    ,n.remark -- 备注
    ,n.error_code -- 返回码 [枚举: 0为成功，其他为失败]
    ,n.error_msg -- 返回信息
    ,n.create_timestamp -- 创建时间戳
    ,n.update_timestamp -- 更新时间戳
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fzss_mod_fzs_host_tran_info_bk o
    right join (select * from ${itl_schema}.fzss_mod_fzs_host_tran_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.plat_date = n.plat_date
            and o.plat_serial_no = n.plat_serial_no
where (
        o.plat_date is null
        and o.plat_serial_no is null
    )
    or (
        o.plat_time <> n.plat_time
        or o.channel_no <> n.channel_no
        or o.mybank <> n.mybank
        or o.zone_no <> n.zone_no
        or o.tellerno <> n.tellerno
        or o.brno <> n.brno
        or o.corp_id <> n.corp_id
        or o.global_serial_no <> n.global_serial_no
        or o.corp_work_date <> n.corp_work_date
        or o.order_no <> n.order_no
        or o.plat_tran_type <> n.plat_tran_type
        or o.acct_no <> n.acct_no
        or o.acct_name <> n.acct_name
        or o.currency <> n.currency
        or o.tran_amt <> n.tran_amt
        or o.revtranf <> n.revtranf
        or o.dc_flag <> n.dc_flag
        or o.to_acct_no <> n.to_acct_no
        or o.to_acct_name <> n.to_acct_name
        or o.to_final_inst_code <> n.to_final_inst_code
        or o.to_final_inst_name <> n.to_final_inst_name
        or o.cnaps_branch_id <> n.cnaps_branch_id
        or o.bank_flag <> n.bank_flag
        or o.abst_code <> n.abst_code
        or o.abst_desc <> n.abst_desc
        or o.ppp_check_code <> n.ppp_check_code
        or o.ppp_srv_cllpty_trx_seq <> n.ppp_srv_cllpty_trx_seq
        or o.ppp_status <> n.ppp_status
        or o.ppp_code <> n.ppp_code
        or o.ppp_msg <> n.ppp_msg
        or o.ppp_date <> n.ppp_date
        or o.ppp_time <> n.ppp_time
        or o.ppp_serial_no <> n.ppp_serial_no
        or o.ppp_chnl_encd <> n.ppp_chnl_encd
        or o.ppp_seq_no <> n.ppp_seq_no
        or o.host_date <> n.host_date
        or o.host_time <> n.host_time
        or o.host_serial_no <> n.host_serial_no
        or o.check_status <> n.check_status
        or o.is_check_deal <> n.is_check_deal
        or o.fund_flag <> n.fund_flag
        or o.fund_date <> n.fund_date
        or o.fund_serial_no <> n.fund_serial_no
        or o.fund_reason <> n.fund_reason
        or o.reversal_flag <> n.reversal_flag
        or o.reversal_date <> n.reversal_date
        or o.reversal_serial_no <> n.reversal_serial_no
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
        into ${iol_schema}.fzss_mod_fzs_host_tran_info_cl(
            plat_date -- 系统日期 yyyyMMdd
        ,plat_time -- 系统时间 HHmmss
        ,plat_serial_no -- 系统流水
        ,channel_no -- 渠道编号 3位英文系统编号,如FZS,PPP
        ,mybank -- 法人标识代码
        ,zone_no -- 分行号
        ,tellerno -- 柜员号
        ,brno -- 机构号
        ,corp_id -- 平台商户号
        ,global_serial_no -- 全局流水号
        ,corp_work_date -- 平台订单日期
        ,order_no -- 订单号
        ,plat_tran_type -- 平台交易类型 [枚举: D01-提现,T01-退汇,T02-普通入账]
        ,acct_no -- 交易账号
        ,acct_name -- 账户名称
        ,currency -- 币种
        ,tran_amt -- 交易金额
        ,revtranf -- 正反交易标志(0-正交易,1-冲正交易,) [枚举: 反交易标志(0-正交易,1-冲正交易,)]
        ,dc_flag -- 借贷方向 [枚举: D-借,C-贷]
        ,to_acct_no -- 对方账号
        ,to_acct_name -- 对方户名
        ,to_final_inst_code -- 对方金融机构代码
        ,to_final_inst_name -- 对方金融机构名称
        ,cnaps_branch_id -- 联行号
        ,bank_flag -- 行内外标志 [枚举: 1-行内,2-行外]
        ,abst_code -- 摘要码
        ,abst_desc -- 摘要描述
        ,ppp_check_code -- ppp对账代码
        ,ppp_srv_cllpty_trx_seq -- 记账系统内流水号
        ,ppp_status -- 记账平台状态 [枚举: 9-待处理,0-成功,1-失败,2-异常,3-处理中,]
        ,ppp_code -- 记账结果代码
        ,ppp_msg -- 记账结果信息
        ,ppp_date -- 记账平台交易日期
        ,ppp_time -- 记账平台交易时间
        ,ppp_serial_no -- 记账平台交易流水号
        ,ppp_chnl_encd -- ppp通道编码
        ,ppp_seq_no -- 记账平台交易序号
        ,host_date -- 核心交易日期
        ,host_time -- 核心交易时间
        ,host_serial_no -- 核心交易流水号
        ,check_status -- 对账状态 [枚举: 0-未对账,1-已对账]
        ,is_check_deal -- 是否差错处理 [枚举: 0-否,1-是]
        ,fund_flag -- 退汇标识 [枚举: 0-未退汇,1-已退汇,]
        ,fund_date -- 退汇通知日期
        ,fund_serial_no -- 退汇通知流水
        ,fund_reason -- 退汇原因
        ,reversal_flag -- 冲正标识
        ,reversal_date -- 冲正日期
        ,reversal_serial_no -- 冲正流水号
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
        into ${iol_schema}.fzss_mod_fzs_host_tran_info_op(
            plat_date -- 系统日期 yyyyMMdd
        ,plat_time -- 系统时间 HHmmss
        ,plat_serial_no -- 系统流水
        ,channel_no -- 渠道编号 3位英文系统编号,如FZS,PPP
        ,mybank -- 法人标识代码
        ,zone_no -- 分行号
        ,tellerno -- 柜员号
        ,brno -- 机构号
        ,corp_id -- 平台商户号
        ,global_serial_no -- 全局流水号
        ,corp_work_date -- 平台订单日期
        ,order_no -- 订单号
        ,plat_tran_type -- 平台交易类型 [枚举: D01-提现,T01-退汇,T02-普通入账]
        ,acct_no -- 交易账号
        ,acct_name -- 账户名称
        ,currency -- 币种
        ,tran_amt -- 交易金额
        ,revtranf -- 正反交易标志(0-正交易,1-冲正交易,) [枚举: 反交易标志(0-正交易,1-冲正交易,)]
        ,dc_flag -- 借贷方向 [枚举: D-借,C-贷]
        ,to_acct_no -- 对方账号
        ,to_acct_name -- 对方户名
        ,to_final_inst_code -- 对方金融机构代码
        ,to_final_inst_name -- 对方金融机构名称
        ,cnaps_branch_id -- 联行号
        ,bank_flag -- 行内外标志 [枚举: 1-行内,2-行外]
        ,abst_code -- 摘要码
        ,abst_desc -- 摘要描述
        ,ppp_check_code -- ppp对账代码
        ,ppp_srv_cllpty_trx_seq -- 记账系统内流水号
        ,ppp_status -- 记账平台状态 [枚举: 9-待处理,0-成功,1-失败,2-异常,3-处理中,]
        ,ppp_code -- 记账结果代码
        ,ppp_msg -- 记账结果信息
        ,ppp_date -- 记账平台交易日期
        ,ppp_time -- 记账平台交易时间
        ,ppp_serial_no -- 记账平台交易流水号
        ,ppp_chnl_encd -- ppp通道编码
        ,ppp_seq_no -- 记账平台交易序号
        ,host_date -- 核心交易日期
        ,host_time -- 核心交易时间
        ,host_serial_no -- 核心交易流水号
        ,check_status -- 对账状态 [枚举: 0-未对账,1-已对账]
        ,is_check_deal -- 是否差错处理 [枚举: 0-否,1-是]
        ,fund_flag -- 退汇标识 [枚举: 0-未退汇,1-已退汇,]
        ,fund_date -- 退汇通知日期
        ,fund_serial_no -- 退汇通知流水
        ,fund_reason -- 退汇原因
        ,reversal_flag -- 冲正标识
        ,reversal_date -- 冲正日期
        ,reversal_serial_no -- 冲正流水号
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
    ,o.channel_no -- 渠道编号 3位英文系统编号,如FZS,PPP
    ,o.mybank -- 法人标识代码
    ,o.zone_no -- 分行号
    ,o.tellerno -- 柜员号
    ,o.brno -- 机构号
    ,o.corp_id -- 平台商户号
    ,o.global_serial_no -- 全局流水号
    ,o.corp_work_date -- 平台订单日期
    ,o.order_no -- 订单号
    ,o.plat_tran_type -- 平台交易类型 [枚举: D01-提现,T01-退汇,T02-普通入账]
    ,o.acct_no -- 交易账号
    ,o.acct_name -- 账户名称
    ,o.currency -- 币种
    ,o.tran_amt -- 交易金额
    ,o.revtranf -- 正反交易标志(0-正交易,1-冲正交易,) [枚举: 反交易标志(0-正交易,1-冲正交易,)]
    ,o.dc_flag -- 借贷方向 [枚举: D-借,C-贷]
    ,o.to_acct_no -- 对方账号
    ,o.to_acct_name -- 对方户名
    ,o.to_final_inst_code -- 对方金融机构代码
    ,o.to_final_inst_name -- 对方金融机构名称
    ,o.cnaps_branch_id -- 联行号
    ,o.bank_flag -- 行内外标志 [枚举: 1-行内,2-行外]
    ,o.abst_code -- 摘要码
    ,o.abst_desc -- 摘要描述
    ,o.ppp_check_code -- ppp对账代码
    ,o.ppp_srv_cllpty_trx_seq -- 记账系统内流水号
    ,o.ppp_status -- 记账平台状态 [枚举: 9-待处理,0-成功,1-失败,2-异常,3-处理中,]
    ,o.ppp_code -- 记账结果代码
    ,o.ppp_msg -- 记账结果信息
    ,o.ppp_date -- 记账平台交易日期
    ,o.ppp_time -- 记账平台交易时间
    ,o.ppp_serial_no -- 记账平台交易流水号
    ,o.ppp_chnl_encd -- ppp通道编码
    ,o.ppp_seq_no -- 记账平台交易序号
    ,o.host_date -- 核心交易日期
    ,o.host_time -- 核心交易时间
    ,o.host_serial_no -- 核心交易流水号
    ,o.check_status -- 对账状态 [枚举: 0-未对账,1-已对账]
    ,o.is_check_deal -- 是否差错处理 [枚举: 0-否,1-是]
    ,o.fund_flag -- 退汇标识 [枚举: 0-未退汇,1-已退汇,]
    ,o.fund_date -- 退汇通知日期
    ,o.fund_serial_no -- 退汇通知流水
    ,o.fund_reason -- 退汇原因
    ,o.reversal_flag -- 冲正标识
    ,o.reversal_date -- 冲正日期
    ,o.reversal_serial_no -- 冲正流水号
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
from ${iol_schema}.fzss_mod_fzs_host_tran_info_bk o
    left join ${iol_schema}.fzss_mod_fzs_host_tran_info_op n
        on
            o.plat_date = n.plat_date
            and o.plat_serial_no = n.plat_serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fzss_mod_fzs_host_tran_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fzss_mod_fzs_host_tran_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fzss_mod_fzs_host_tran_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fzss_mod_fzs_host_tran_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fzss_mod_fzs_host_tran_info exchange partition p_${batch_date} with table ${iol_schema}.fzss_mod_fzs_host_tran_info_cl;
alter table ${iol_schema}.fzss_mod_fzs_host_tran_info exchange partition p_20991231 with table ${iol_schema}.fzss_mod_fzs_host_tran_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fzss_mod_fzs_host_tran_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_host_tran_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_host_tran_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fzss_mod_fzs_host_tran_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fzss_mod_fzs_host_tran_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
