/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_mcht_settle_inf
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.mrms_tbl_mcht_settle_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_mcht_settle_inf
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_mcht_settle_inf_op purge;
drop table ${iol_schema}.mrms_tbl_mcht_settle_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_mcht_settle_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_mcht_settle_inf where 0=1;

create table ${iol_schema}.mrms_tbl_mcht_settle_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_mcht_settle_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_mcht_settle_inf_cl(
            mcht_no -- 商户号
            ,settle_type -- 商户结算方式
            ,rate_flag -- 手续费结算类型
            ,settle_chn -- 商户结算渠道
            ,bat_time -- 每日批上送时间
            ,auto_stl_flg -- 自动清算标志
            ,part_num -- 商户分期期数
            ,fee_type -- 01-特殊扣率-固定费
            ,fee_fixed -- 固定手续费
            ,fee_max_amt -- 手续费上限
            ,fee_min_amt -- 手续费下限
            ,fee_rate -- 手续费百分百率
            ,fee_div_1 -- 分段一
            ,fee_div_2 -- 分段二
            ,fee_div_3 -- 分段三
            ,settle_mode -- 商户本金清算模式
            ,fee_cycle -- 手续费清算周期
            ,settle_rpt -- 商户入账凭单模式
            ,settle_bank_no -- 商户结算帐户开户行
            ,settle_bank_nm -- 商户结算帐户开户行名称
            ,settle_acct_nm -- 商户结算帐户户名
            ,settle_acct -- 商户结算帐户号
            ,fee_acct_nm -- 手续费结算帐户名
            ,fee_acct -- 手续费结算帐户号
            ,group_flag -- 是否清算到集团商户
            ,open_stlno -- 商户开户行号
            ,change_stlno -- 客户号
            ,spe_settle_tp -- 特殊计费类型
            ,spe_settle_lv -- 特殊计费档次
            ,spe_settle_ds -- 特殊计费描述
            ,fee_back_flg -- 退货返还手续费标志
            ,reserved -- 保留
            ,rec_upd_ts -- 记录更新时间
            ,rec_crt_ts -- 记录创建时间
            ,settle_bank_no2 -- 商户结算账户开户行号2
            ,settle_bank_nm2 -- 商户结算账户开户行名2
            ,settle_acct_nm2 -- 商户结算账户户名2
            ,settle_acct2 -- 商户结算账户号2
            ,settle_bank_no3 -- 商户结算账户开户行号3
            ,settle_bank_nm3 -- 商户结算账户开户行名3
            ,settle_acct_nm3 -- 商户结算账户户名3
            ,settle_acct3 -- 商户结算账户号3
            ,paymnt_stl_proj_nm -- 缴费项目名称
            ,paymnt_stl_proj_no -- 缴费项目编号
            ,acct_type -- 账户类型
            ,open_stlno3 -- 商户开户行号
            ,change_stlno3 -- 客户号
            ,open_stlno2 -- 商户开户行号
            ,change_stlno2 -- 客户号
            ,misc_1 -- 保留字段1
            ,misc_2 -- 保留字段2
            ,misc_3 -- 保留字段3
            ,misc_flag -- 保留标识1
            ,acct_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_mcht_settle_inf_op(
            mcht_no -- 商户号
            ,settle_type -- 商户结算方式
            ,rate_flag -- 手续费结算类型
            ,settle_chn -- 商户结算渠道
            ,bat_time -- 每日批上送时间
            ,auto_stl_flg -- 自动清算标志
            ,part_num -- 商户分期期数
            ,fee_type -- 01-特殊扣率-固定费
            ,fee_fixed -- 固定手续费
            ,fee_max_amt -- 手续费上限
            ,fee_min_amt -- 手续费下限
            ,fee_rate -- 手续费百分百率
            ,fee_div_1 -- 分段一
            ,fee_div_2 -- 分段二
            ,fee_div_3 -- 分段三
            ,settle_mode -- 商户本金清算模式
            ,fee_cycle -- 手续费清算周期
            ,settle_rpt -- 商户入账凭单模式
            ,settle_bank_no -- 商户结算帐户开户行
            ,settle_bank_nm -- 商户结算帐户开户行名称
            ,settle_acct_nm -- 商户结算帐户户名
            ,settle_acct -- 商户结算帐户号
            ,fee_acct_nm -- 手续费结算帐户名
            ,fee_acct -- 手续费结算帐户号
            ,group_flag -- 是否清算到集团商户
            ,open_stlno -- 商户开户行号
            ,change_stlno -- 客户号
            ,spe_settle_tp -- 特殊计费类型
            ,spe_settle_lv -- 特殊计费档次
            ,spe_settle_ds -- 特殊计费描述
            ,fee_back_flg -- 退货返还手续费标志
            ,reserved -- 保留
            ,rec_upd_ts -- 记录更新时间
            ,rec_crt_ts -- 记录创建时间
            ,settle_bank_no2 -- 商户结算账户开户行号2
            ,settle_bank_nm2 -- 商户结算账户开户行名2
            ,settle_acct_nm2 -- 商户结算账户户名2
            ,settle_acct2 -- 商户结算账户号2
            ,settle_bank_no3 -- 商户结算账户开户行号3
            ,settle_bank_nm3 -- 商户结算账户开户行名3
            ,settle_acct_nm3 -- 商户结算账户户名3
            ,settle_acct3 -- 商户结算账户号3
            ,paymnt_stl_proj_nm -- 缴费项目名称
            ,paymnt_stl_proj_no -- 缴费项目编号
            ,acct_type -- 账户类型
            ,open_stlno3 -- 商户开户行号
            ,change_stlno3 -- 客户号
            ,open_stlno2 -- 商户开户行号
            ,change_stlno2 -- 客户号
            ,misc_1 -- 保留字段1
            ,misc_2 -- 保留字段2
            ,misc_3 -- 保留字段3
            ,misc_flag -- 保留标识1
            ,acct_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.mcht_no, o.mcht_no) as mcht_no -- 商户号
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 商户结算方式
    ,nvl(n.rate_flag, o.rate_flag) as rate_flag -- 手续费结算类型
    ,nvl(n.settle_chn, o.settle_chn) as settle_chn -- 商户结算渠道
    ,nvl(n.bat_time, o.bat_time) as bat_time -- 每日批上送时间
    ,nvl(n.auto_stl_flg, o.auto_stl_flg) as auto_stl_flg -- 自动清算标志
    ,nvl(n.part_num, o.part_num) as part_num -- 商户分期期数
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 01-特殊扣率-固定费
    ,nvl(n.fee_fixed, o.fee_fixed) as fee_fixed -- 固定手续费
    ,nvl(n.fee_max_amt, o.fee_max_amt) as fee_max_amt -- 手续费上限
    ,nvl(n.fee_min_amt, o.fee_min_amt) as fee_min_amt -- 手续费下限
    ,nvl(n.fee_rate, o.fee_rate) as fee_rate -- 手续费百分百率
    ,nvl(n.fee_div_1, o.fee_div_1) as fee_div_1 -- 分段一
    ,nvl(n.fee_div_2, o.fee_div_2) as fee_div_2 -- 分段二
    ,nvl(n.fee_div_3, o.fee_div_3) as fee_div_3 -- 分段三
    ,nvl(n.settle_mode, o.settle_mode) as settle_mode -- 商户本金清算模式
    ,nvl(n.fee_cycle, o.fee_cycle) as fee_cycle -- 手续费清算周期
    ,nvl(n.settle_rpt, o.settle_rpt) as settle_rpt -- 商户入账凭单模式
    ,nvl(n.settle_bank_no, o.settle_bank_no) as settle_bank_no -- 商户结算帐户开户行
    ,nvl(n.settle_bank_nm, o.settle_bank_nm) as settle_bank_nm -- 商户结算帐户开户行名称
    ,nvl(n.settle_acct_nm, o.settle_acct_nm) as settle_acct_nm -- 商户结算帐户户名
    ,nvl(n.settle_acct, o.settle_acct) as settle_acct -- 商户结算帐户号
    ,nvl(n.fee_acct_nm, o.fee_acct_nm) as fee_acct_nm -- 手续费结算帐户名
    ,nvl(n.fee_acct, o.fee_acct) as fee_acct -- 手续费结算帐户号
    ,nvl(n.group_flag, o.group_flag) as group_flag -- 是否清算到集团商户
    ,nvl(n.open_stlno, o.open_stlno) as open_stlno -- 商户开户行号
    ,nvl(n.change_stlno, o.change_stlno) as change_stlno -- 客户号
    ,nvl(n.spe_settle_tp, o.spe_settle_tp) as spe_settle_tp -- 特殊计费类型
    ,nvl(n.spe_settle_lv, o.spe_settle_lv) as spe_settle_lv -- 特殊计费档次
    ,nvl(n.spe_settle_ds, o.spe_settle_ds) as spe_settle_ds -- 特殊计费描述
    ,nvl(n.fee_back_flg, o.fee_back_flg) as fee_back_flg -- 退货返还手续费标志
    ,nvl(n.reserved, o.reserved) as reserved -- 保留
    ,nvl(n.rec_upd_ts, o.rec_upd_ts) as rec_upd_ts -- 记录更新时间
    ,nvl(n.rec_crt_ts, o.rec_crt_ts) as rec_crt_ts -- 记录创建时间
    ,nvl(n.settle_bank_no2, o.settle_bank_no2) as settle_bank_no2 -- 商户结算账户开户行号2
    ,nvl(n.settle_bank_nm2, o.settle_bank_nm2) as settle_bank_nm2 -- 商户结算账户开户行名2
    ,nvl(n.settle_acct_nm2, o.settle_acct_nm2) as settle_acct_nm2 -- 商户结算账户户名2
    ,nvl(n.settle_acct2, o.settle_acct2) as settle_acct2 -- 商户结算账户号2
    ,nvl(n.settle_bank_no3, o.settle_bank_no3) as settle_bank_no3 -- 商户结算账户开户行号3
    ,nvl(n.settle_bank_nm3, o.settle_bank_nm3) as settle_bank_nm3 -- 商户结算账户开户行名3
    ,nvl(n.settle_acct_nm3, o.settle_acct_nm3) as settle_acct_nm3 -- 商户结算账户户名3
    ,nvl(n.settle_acct3, o.settle_acct3) as settle_acct3 -- 商户结算账户号3
    ,nvl(n.paymnt_stl_proj_nm, o.paymnt_stl_proj_nm) as paymnt_stl_proj_nm -- 缴费项目名称
    ,nvl(n.paymnt_stl_proj_no, o.paymnt_stl_proj_no) as paymnt_stl_proj_no -- 缴费项目编号
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.open_stlno3, o.open_stlno3) as open_stlno3 -- 商户开户行号
    ,nvl(n.change_stlno3, o.change_stlno3) as change_stlno3 -- 客户号
    ,nvl(n.open_stlno2, o.open_stlno2) as open_stlno2 -- 商户开户行号
    ,nvl(n.change_stlno2, o.change_stlno2) as change_stlno2 -- 客户号
    ,nvl(n.misc_1, o.misc_1) as misc_1 -- 保留字段1
    ,nvl(n.misc_2, o.misc_2) as misc_2 -- 保留字段2
    ,nvl(n.misc_3, o.misc_3) as misc_3 -- 保留字段3
    ,nvl(n.misc_flag, o.misc_flag) as misc_flag -- 保留标识1
    ,nvl(n.acct_flag, o.acct_flag) as acct_flag -- 
    ,case when
            n.mcht_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.mcht_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.mcht_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_mcht_settle_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_mcht_settle_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.mcht_no = n.mcht_no
where (
        o.mcht_no is null
    )
    or (
        n.mcht_no is null
    )
    or (
        o.settle_type <> n.settle_type
        or o.rate_flag <> n.rate_flag
        or o.settle_chn <> n.settle_chn
        or o.bat_time <> n.bat_time
        or o.auto_stl_flg <> n.auto_stl_flg
        or o.part_num <> n.part_num
        or o.fee_type <> n.fee_type
        or o.fee_fixed <> n.fee_fixed
        or o.fee_max_amt <> n.fee_max_amt
        or o.fee_min_amt <> n.fee_min_amt
        or o.fee_rate <> n.fee_rate
        or o.fee_div_1 <> n.fee_div_1
        or o.fee_div_2 <> n.fee_div_2
        or o.fee_div_3 <> n.fee_div_3
        or o.settle_mode <> n.settle_mode
        or o.fee_cycle <> n.fee_cycle
        or o.settle_rpt <> n.settle_rpt
        or o.settle_bank_no <> n.settle_bank_no
        or o.settle_bank_nm <> n.settle_bank_nm
        or o.settle_acct_nm <> n.settle_acct_nm
        or o.settle_acct <> n.settle_acct
        or o.fee_acct_nm <> n.fee_acct_nm
        or o.fee_acct <> n.fee_acct
        or o.group_flag <> n.group_flag
        or o.open_stlno <> n.open_stlno
        or o.change_stlno <> n.change_stlno
        or o.spe_settle_tp <> n.spe_settle_tp
        or o.spe_settle_lv <> n.spe_settle_lv
        or o.spe_settle_ds <> n.spe_settle_ds
        or o.fee_back_flg <> n.fee_back_flg
        or o.reserved <> n.reserved
        or o.rec_upd_ts <> n.rec_upd_ts
        or o.rec_crt_ts <> n.rec_crt_ts
        or o.settle_bank_no2 <> n.settle_bank_no2
        or o.settle_bank_nm2 <> n.settle_bank_nm2
        or o.settle_acct_nm2 <> n.settle_acct_nm2
        or o.settle_acct2 <> n.settle_acct2
        or o.settle_bank_no3 <> n.settle_bank_no3
        or o.settle_bank_nm3 <> n.settle_bank_nm3
        or o.settle_acct_nm3 <> n.settle_acct_nm3
        or o.settle_acct3 <> n.settle_acct3
        or o.paymnt_stl_proj_nm <> n.paymnt_stl_proj_nm
        or o.paymnt_stl_proj_no <> n.paymnt_stl_proj_no
        or o.acct_type <> n.acct_type
        or o.open_stlno3 <> n.open_stlno3
        or o.change_stlno3 <> n.change_stlno3
        or o.open_stlno2 <> n.open_stlno2
        or o.change_stlno2 <> n.change_stlno2
        or o.misc_1 <> n.misc_1
        or o.misc_2 <> n.misc_2
        or o.misc_3 <> n.misc_3
        or o.misc_flag <> n.misc_flag
        or o.acct_flag <> n.acct_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_mcht_settle_inf_cl(
            mcht_no -- 商户号
            ,settle_type -- 商户结算方式
            ,rate_flag -- 手续费结算类型
            ,settle_chn -- 商户结算渠道
            ,bat_time -- 每日批上送时间
            ,auto_stl_flg -- 自动清算标志
            ,part_num -- 商户分期期数
            ,fee_type -- 01-特殊扣率-固定费
            ,fee_fixed -- 固定手续费
            ,fee_max_amt -- 手续费上限
            ,fee_min_amt -- 手续费下限
            ,fee_rate -- 手续费百分百率
            ,fee_div_1 -- 分段一
            ,fee_div_2 -- 分段二
            ,fee_div_3 -- 分段三
            ,settle_mode -- 商户本金清算模式
            ,fee_cycle -- 手续费清算周期
            ,settle_rpt -- 商户入账凭单模式
            ,settle_bank_no -- 商户结算帐户开户行
            ,settle_bank_nm -- 商户结算帐户开户行名称
            ,settle_acct_nm -- 商户结算帐户户名
            ,settle_acct -- 商户结算帐户号
            ,fee_acct_nm -- 手续费结算帐户名
            ,fee_acct -- 手续费结算帐户号
            ,group_flag -- 是否清算到集团商户
            ,open_stlno -- 商户开户行号
            ,change_stlno -- 客户号
            ,spe_settle_tp -- 特殊计费类型
            ,spe_settle_lv -- 特殊计费档次
            ,spe_settle_ds -- 特殊计费描述
            ,fee_back_flg -- 退货返还手续费标志
            ,reserved -- 保留
            ,rec_upd_ts -- 记录更新时间
            ,rec_crt_ts -- 记录创建时间
            ,settle_bank_no2 -- 商户结算账户开户行号2
            ,settle_bank_nm2 -- 商户结算账户开户行名2
            ,settle_acct_nm2 -- 商户结算账户户名2
            ,settle_acct2 -- 商户结算账户号2
            ,settle_bank_no3 -- 商户结算账户开户行号3
            ,settle_bank_nm3 -- 商户结算账户开户行名3
            ,settle_acct_nm3 -- 商户结算账户户名3
            ,settle_acct3 -- 商户结算账户号3
            ,paymnt_stl_proj_nm -- 缴费项目名称
            ,paymnt_stl_proj_no -- 缴费项目编号
            ,acct_type -- 账户类型
            ,open_stlno3 -- 商户开户行号
            ,change_stlno3 -- 客户号
            ,open_stlno2 -- 商户开户行号
            ,change_stlno2 -- 客户号
            ,misc_1 -- 保留字段1
            ,misc_2 -- 保留字段2
            ,misc_3 -- 保留字段3
            ,misc_flag -- 保留标识1
            ,acct_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_mcht_settle_inf_op(
            mcht_no -- 商户号
            ,settle_type -- 商户结算方式
            ,rate_flag -- 手续费结算类型
            ,settle_chn -- 商户结算渠道
            ,bat_time -- 每日批上送时间
            ,auto_stl_flg -- 自动清算标志
            ,part_num -- 商户分期期数
            ,fee_type -- 01-特殊扣率-固定费
            ,fee_fixed -- 固定手续费
            ,fee_max_amt -- 手续费上限
            ,fee_min_amt -- 手续费下限
            ,fee_rate -- 手续费百分百率
            ,fee_div_1 -- 分段一
            ,fee_div_2 -- 分段二
            ,fee_div_3 -- 分段三
            ,settle_mode -- 商户本金清算模式
            ,fee_cycle -- 手续费清算周期
            ,settle_rpt -- 商户入账凭单模式
            ,settle_bank_no -- 商户结算帐户开户行
            ,settle_bank_nm -- 商户结算帐户开户行名称
            ,settle_acct_nm -- 商户结算帐户户名
            ,settle_acct -- 商户结算帐户号
            ,fee_acct_nm -- 手续费结算帐户名
            ,fee_acct -- 手续费结算帐户号
            ,group_flag -- 是否清算到集团商户
            ,open_stlno -- 商户开户行号
            ,change_stlno -- 客户号
            ,spe_settle_tp -- 特殊计费类型
            ,spe_settle_lv -- 特殊计费档次
            ,spe_settle_ds -- 特殊计费描述
            ,fee_back_flg -- 退货返还手续费标志
            ,reserved -- 保留
            ,rec_upd_ts -- 记录更新时间
            ,rec_crt_ts -- 记录创建时间
            ,settle_bank_no2 -- 商户结算账户开户行号2
            ,settle_bank_nm2 -- 商户结算账户开户行名2
            ,settle_acct_nm2 -- 商户结算账户户名2
            ,settle_acct2 -- 商户结算账户号2
            ,settle_bank_no3 -- 商户结算账户开户行号3
            ,settle_bank_nm3 -- 商户结算账户开户行名3
            ,settle_acct_nm3 -- 商户结算账户户名3
            ,settle_acct3 -- 商户结算账户号3
            ,paymnt_stl_proj_nm -- 缴费项目名称
            ,paymnt_stl_proj_no -- 缴费项目编号
            ,acct_type -- 账户类型
            ,open_stlno3 -- 商户开户行号
            ,change_stlno3 -- 客户号
            ,open_stlno2 -- 商户开户行号
            ,change_stlno2 -- 客户号
            ,misc_1 -- 保留字段1
            ,misc_2 -- 保留字段2
            ,misc_3 -- 保留字段3
            ,misc_flag -- 保留标识1
            ,acct_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.mcht_no -- 商户号
    ,o.settle_type -- 商户结算方式
    ,o.rate_flag -- 手续费结算类型
    ,o.settle_chn -- 商户结算渠道
    ,o.bat_time -- 每日批上送时间
    ,o.auto_stl_flg -- 自动清算标志
    ,o.part_num -- 商户分期期数
    ,o.fee_type -- 01-特殊扣率-固定费
    ,o.fee_fixed -- 固定手续费
    ,o.fee_max_amt -- 手续费上限
    ,o.fee_min_amt -- 手续费下限
    ,o.fee_rate -- 手续费百分百率
    ,o.fee_div_1 -- 分段一
    ,o.fee_div_2 -- 分段二
    ,o.fee_div_3 -- 分段三
    ,o.settle_mode -- 商户本金清算模式
    ,o.fee_cycle -- 手续费清算周期
    ,o.settle_rpt -- 商户入账凭单模式
    ,o.settle_bank_no -- 商户结算帐户开户行
    ,o.settle_bank_nm -- 商户结算帐户开户行名称
    ,o.settle_acct_nm -- 商户结算帐户户名
    ,o.settle_acct -- 商户结算帐户号
    ,o.fee_acct_nm -- 手续费结算帐户名
    ,o.fee_acct -- 手续费结算帐户号
    ,o.group_flag -- 是否清算到集团商户
    ,o.open_stlno -- 商户开户行号
    ,o.change_stlno -- 客户号
    ,o.spe_settle_tp -- 特殊计费类型
    ,o.spe_settle_lv -- 特殊计费档次
    ,o.spe_settle_ds -- 特殊计费描述
    ,o.fee_back_flg -- 退货返还手续费标志
    ,o.reserved -- 保留
    ,o.rec_upd_ts -- 记录更新时间
    ,o.rec_crt_ts -- 记录创建时间
    ,o.settle_bank_no2 -- 商户结算账户开户行号2
    ,o.settle_bank_nm2 -- 商户结算账户开户行名2
    ,o.settle_acct_nm2 -- 商户结算账户户名2
    ,o.settle_acct2 -- 商户结算账户号2
    ,o.settle_bank_no3 -- 商户结算账户开户行号3
    ,o.settle_bank_nm3 -- 商户结算账户开户行名3
    ,o.settle_acct_nm3 -- 商户结算账户户名3
    ,o.settle_acct3 -- 商户结算账户号3
    ,o.paymnt_stl_proj_nm -- 缴费项目名称
    ,o.paymnt_stl_proj_no -- 缴费项目编号
    ,o.acct_type -- 账户类型
    ,o.open_stlno3 -- 商户开户行号
    ,o.change_stlno3 -- 客户号
    ,o.open_stlno2 -- 商户开户行号
    ,o.change_stlno2 -- 客户号
    ,o.misc_1 -- 保留字段1
    ,o.misc_2 -- 保留字段2
    ,o.misc_3 -- 保留字段3
    ,o.misc_flag -- 保留标识1
    ,o.acct_flag -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.mrms_tbl_mcht_settle_inf_bk o
    left join ${iol_schema}.mrms_tbl_mcht_settle_inf_op n
        on
            o.mcht_no = n.mcht_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_mcht_settle_inf_cl d
        on
            o.mcht_no = d.mcht_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_mcht_settle_inf;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_mcht_settle_inf') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_mcht_settle_inf drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_mcht_settle_inf add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_mcht_settle_inf exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_mcht_settle_inf_cl;
alter table ${iol_schema}.mrms_tbl_mcht_settle_inf exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_mcht_settle_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_mcht_settle_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_mcht_settle_inf_op purge;
drop table ${iol_schema}.mrms_tbl_mcht_settle_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_mcht_settle_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_mcht_settle_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
