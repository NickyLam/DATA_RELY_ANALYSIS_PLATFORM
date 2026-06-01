/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cmm_dep_acct_attach_info
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_cmm_dep_acct_attach_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cmm_dep_acct_attach_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cmm_dep_acct_attach_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cmm_dep_acct_attach_info partition for (to_date('${batch_date}','yyyymmdd')) (
    lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,src_agt_id -- 源协议编号
    ,fx_acct_char_cd -- 外汇账户性质代码
    ,agt_dep_type_cd -- 协议存款类型代码
    ,acct_lics_num -- 账户许可证号
    ,acct_lics_issue_dt -- 账户许可证签发日期
    ,cap_char_cd -- 资金性质代码
    ,acct_close_rs_descb -- 账户关闭原因描述
    ,l_six_m_no_tran_flg -- 六个月无交易标志
    ,supv_type_cd -- 监管类型代码
    ,xhc_flg -- 兴惠存标志
    ,long_hang_amt -- 久悬金额
    ,init_open_acct_dt -- 原始开户日期
    ,init_exp_dt -- 原始到期日期
    ,sub_acct_int_rat_float_ratio -- 协定存款利率浮动比例
    ,sub_acct_int_rat_float_point -- 协定存款利率浮动点数
    ,delay_pay_int_int_float_point -- 延期付息利息浮动点
    ,txy_main_agt_files_int_rat -- 同兴赢主协议超档利率
    ,txy_sub_agt_agree_int_rat -- 同兴赢子协议协定利率
    ,cap_pool_agt_rat -- 资金池协议利率
    ,cert_print_flg -- 证实书打印标志
    ,precon_wdraw_flg -- 预约支取标志
    ,precon_wdraw_dt -- 预约支取日期
    ,apot_tenor_start_dt -- 约期开始日期
    ,apot_tenor_end_dt -- 约期结束日期
    ,heat_insu_acct_flg -- 医保账户标志
    ,travel_card_acct_flg -- 旅行通账户标志
    ,soci_secu_fin_acct_flg -- 社保卡下金融账户标志
    ,supv_idf_set_dt -- 监管标识设置日期
    ,supv_idf_cancel_dt -- 监管标识取消日期
    ,int_rat_apv_form_odd_no -- 利率审批单单号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(acct_id), ' ') as acct_id -- 账户编号
    ,nvl(trim(acct_name), ' ') as acct_name -- 账户名称
    ,nvl(trim(cust_id), ' ') as cust_id -- 客户编号
    ,nvl(trim(src_agt_id), ' ') as src_agt_id -- 源协议编号
    ,nvl(trim(fx_acct_char_cd), ' ') as fx_acct_char_cd -- 外汇账户性质代码
    ,nvl(trim(agt_dep_type_cd), ' ') as agt_dep_type_cd -- 协议存款类型代码
    ,nvl(trim(acct_lics_num), ' ') as acct_lics_num -- 账户许可证号
    ,nvl(acct_lics_issue_dt, to_date('00010101', 'yyyymmdd')) as acct_lics_issue_dt -- 账户许可证签发日期
    ,nvl(trim(cap_char_cd), ' ') as cap_char_cd -- 资金性质代码
    ,nvl(trim(acct_close_rs_descb), ' ') as acct_close_rs_descb -- 账户关闭原因描述
    ,nvl(trim(l_six_m_no_tran_flg), ' ') as l_six_m_no_tran_flg -- 六个月无交易标志
    ,nvl(trim(supv_type_cd), ' ') as supv_type_cd -- 监管类型代码
    ,nvl(trim(xhc_flg), ' ') as xhc_flg -- 兴惠存标志
    ,nvl(trim(long_hang_amt), 0) as long_hang_amt -- 久悬金额
    ,nvl(init_open_acct_dt, to_date('00010101', 'yyyymmdd')) as init_open_acct_dt -- 原始开户日期
    ,nvl(init_exp_dt, to_date('00010101', 'yyyymmdd')) as init_exp_dt -- 原始到期日期
    ,nvl(trim(sub_acct_int_rat_float_ratio), 0) as sub_acct_int_rat_float_ratio -- 协定存款利率浮动比例
    ,nvl(trim(sub_acct_int_rat_float_point), 0) as sub_acct_int_rat_float_point -- 协定存款利率浮动点数
    ,nvl(trim(delay_pay_int_int_float_point), 0) as delay_pay_int_int_float_point -- 延期付息利息浮动点
    ,nvl(trim(txy_main_agt_files_int_rat), 0) as txy_main_agt_files_int_rat -- 同兴赢主协议超档利率
    ,nvl(trim(txy_sub_agt_agree_int_rat), 0) as txy_sub_agt_agree_int_rat -- 同兴赢子协议协定利率
    ,nvl(trim(cap_pool_agt_rat), 0) as cap_pool_agt_rat -- 资金池协议利率
    ,nvl(trim(cert_print_flg), ' ') as cert_print_flg -- 证实书打印标志
    ,nvl(trim(precon_wdraw_flg), ' ') as precon_wdraw_flg -- 预约支取标志
    ,nvl(precon_wdraw_dt, to_date('00010101', 'yyyymmdd')) as precon_wdraw_dt -- 预约支取日期
    ,nvl(apot_tenor_start_dt, to_date('00010101', 'yyyymmdd')) as apot_tenor_start_dt -- 约期开始日期
    ,nvl(apot_tenor_end_dt, to_date('00010101', 'yyyymmdd')) as apot_tenor_end_dt -- 约期结束日期
    ,nvl(trim(heat_insu_acct_flg), ' ') as heat_insu_acct_flg -- 医保账户标志
    ,nvl(trim(travel_card_acct_flg), ' ') as travel_card_acct_flg -- 旅行通账户标志
    ,nvl(trim(soci_secu_fin_acct_flg), ' ') as soci_secu_fin_acct_flg -- 社保卡下金融账户标志
    ,nvl(supv_idf_set_dt, to_date('00010101', 'yyyymmdd')) as supv_idf_set_dt -- 监管标识设置日期
    ,nvl(supv_idf_cancel_dt, to_date('00010101', 'yyyymmdd')) as supv_idf_cancel_dt -- 监管标识取消日期
    ,nvl(trim(int_rat_apv_form_odd_no), ' ') as int_rat_apv_form_odd_no -- 利率审批单单号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cmm_dep_acct_attach_info
where 1=1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cmm_dep_acct_attach_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cmm_dep_acct_attach_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);