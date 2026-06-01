/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cmm_e_acct_info
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
alter table ${itl_schema}.itl_edw_cmm_e_acct_info drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cmm_e_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cmm_e_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cmm_e_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_acct_id -- 客户账户编号
    ,cust_sub_acct_num -- 客户账户子户号
    ,cust_id -- 客户编号
    ,subj_id -- 科目编号
    ,prod_id -- 产品编号
    ,std_prod_id -- 标准产品编号
    ,dep_term -- 存期
    ,dep_kind_cd -- 储种代码
    ,acct_cls_cd -- 账户分类代码
    ,acct_type_cd -- 账户类型代码
    ,e_acct_type_cd -- 电子账户类型代码
    ,dep_acct_status_cd -- 存款账户状态代码
    ,corp_acct_flg -- 对公账户标志
    ,rc_flg -- 定活标志
    ,web_dep_flg -- 网络存款标志
    ,general_exch_flg -- 通兑标志
    ,margin_flg -- 保证金标志
    ,advise_dep_flg -- 通知存款标志
    ,ec_flg -- 钞汇标志
    ,privavy_acct_flg -- 隐私账户标志
    ,legal_acct_flg -- 涉案账户标志
    ,sleep_acct_flg -- 睡眠户标志
    ,froz_flg -- 冻结标志
    ,bind_acct_flg -- 绑定账户标志
    ,int_accr_flg -- 计息标志
    ,auto_redt_flg -- 自动转存标志
    ,redt_way_cd -- 转存方式代码
    ,int_accr_base_cd -- 计息基准代码
    ,int_set_way_cd -- 结息方式代码
    ,int_accr_way_cd -- 计息方式代码
    ,curr_cd -- 币种代码
    ,open_acct_chn_type_cd -- 开户渠道类型代码
    ,tran_chn_status_cd -- 交易渠道状态代码
    ,open_acct_dt -- 开户日期
    ,open_acct_tm -- 开户时间
    ,clos_acct_dt -- 销户日期
    ,clos_acct_tm -- 销户时间
    ,actv_dt -- 激活日期
    ,value_dt -- 起息日期
    ,exp_dt -- 到期日期
    ,final_activ_acct_dt -- 最后动户日期
    ,froz_dt -- 冻结日期
    ,unfrz_dt -- 解冻日期
    ,last_int_set_dt -- 上次结息日期
    ,next_int_set_dt -- 下次结息日期
    ,fir_value_dt -- 首次起息日期
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,exec_int_rat -- 执行利率
    ,td_acru_int -- 当日应计利息
    ,currt_acru_int -- 当期应计利息
    ,open_acct_teller_id -- 开户柜员编号
    ,clos_acct_teller_id -- 销户柜员编号
    ,open_acct_org_id -- 开户机构编号
    ,close_acct_org_id -- 销户机构编号
    ,belong_org_id -- 所属机构编号
    ,camp_activ_id -- 营销活动编号
    ,referrer_type_cd -- 推荐人类型代码
    ,referrer_num -- 推荐人号码
    ,vtual_acct_flg -- 虚拟账户标志
    ,mercht_id -- 商户编号
    ,currt_bal -- 当期余额
    ,aval_bal -- 可用余额
    ,froz_amt -- 冻结金额
    ,cl_curr_currt_bal -- 折本币当期余额
    ,ear_d_bal -- 日初余额
    ,ear_m_bal -- 月初余额
    ,ear_s_bal -- 季初余额
    ,ear_y_bal -- 年初余额
    ,y_acm_bal -- 年累计余额
    ,s_acm_bal -- 季累计余额
    ,m_acm_bal -- 月累计余额
    ,cl_curr_ear_d_bal -- 折本币日初余额
    ,cl_curr_ear_m_bal -- 折本币月初余额
    ,cl_curr_ear_s_bal -- 折本币季初余额
    ,cl_curr_ear_y_bal -- 折本币年初余额
    ,cl_curr_y_acm_bal -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal -- 折本币年初月累计余额
    ,entry_flg -- 记账标志
    ,y_avg_bal -- 年日均余额
    ,q_avg_bal -- 季日均余额
    ,m_avg_bal -- 月日均余额
    ,cl_curr_y_avg_bal -- 折本币年日均余额
    ,cl_curr_q_avg_bal -- 折本币季日均余额
    ,cl_curr_m_avg_bal -- 折本币月日均余额
    ,liab_acct_id -- 负债账户编号
    ,open_amt -- 开户金额
    ,old_acct_id -- 旧账户编号
    ,int_paybl_subj_id -- 应付利息科目编号
    ,int_paybl_adj_subj_id -- 应付利息调整科目编号
    ,int_expns_subj_id -- 利息支出科目编号
    ,int_expns_adj_subj_id -- 利息支出调整科目编号
    ,currt_int_paybl_adj -- 当期应付利息调整
    ,td_int_expns -- 当日利息支出
    ,td_int_expns_adj -- 当日利息支出调整
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(acct_id), ' ') as acct_id -- 账户编号
    ,nvl(trim(acct_name), ' ') as acct_name -- 账户名称
    ,nvl(trim(cust_acct_id), ' ') as cust_acct_id -- 客户账户编号
    ,nvl(trim(cust_sub_acct_num), ' ') as cust_sub_acct_num -- 客户账户子户号
    ,nvl(trim(cust_id), ' ') as cust_id -- 客户编号
    ,nvl(trim(subj_id), ' ') as subj_id -- 科目编号
    ,nvl(trim(prod_id), ' ') as prod_id -- 产品编号
    ,nvl(trim(std_prod_id), ' ') as std_prod_id -- 标准产品编号
    ,nvl(trim(dep_term), ' ') as dep_term -- 存期
    ,nvl(trim(dep_kind_cd), ' ') as dep_kind_cd -- 储种代码
    ,nvl(trim(acct_cls_cd), ' ') as acct_cls_cd -- 账户分类代码
    ,nvl(trim(acct_type_cd), ' ') as acct_type_cd -- 账户类型代码
    ,nvl(trim(e_acct_type_cd), ' ') as e_acct_type_cd -- 电子账户类型代码
    ,nvl(trim(dep_acct_status_cd), ' ') as dep_acct_status_cd -- 存款账户状态代码
    ,nvl(trim(corp_acct_flg), ' ') as corp_acct_flg -- 对公账户标志
    ,nvl(trim(rc_flg), ' ') as rc_flg -- 定活标志
    ,nvl(trim(web_dep_flg), ' ') as web_dep_flg -- 网络存款标志
    ,nvl(trim(general_exch_flg), ' ') as general_exch_flg -- 通兑标志
    ,nvl(trim(margin_flg), ' ') as margin_flg -- 保证金标志
    ,nvl(trim(advise_dep_flg), ' ') as advise_dep_flg -- 通知存款标志
    ,nvl(trim(ec_flg), ' ') as ec_flg -- 钞汇标志
    ,nvl(trim(privavy_acct_flg), ' ') as privavy_acct_flg -- 隐私账户标志
    ,nvl(trim(legal_acct_flg), ' ') as legal_acct_flg -- 涉案账户标志
    ,nvl(trim(sleep_acct_flg), ' ') as sleep_acct_flg -- 睡眠户标志
    ,nvl(trim(froz_flg), ' ') as froz_flg -- 冻结标志
    ,nvl(trim(bind_acct_flg), ' ') as bind_acct_flg -- 绑定账户标志
    ,nvl(trim(int_accr_flg), ' ') as int_accr_flg -- 计息标志
    ,nvl(trim(auto_redt_flg), ' ') as auto_redt_flg -- 自动转存标志
    ,nvl(trim(redt_way_cd), ' ') as redt_way_cd -- 转存方式代码
    ,nvl(trim(int_accr_base_cd), ' ') as int_accr_base_cd -- 计息基准代码
    ,nvl(trim(int_set_way_cd), ' ') as int_set_way_cd -- 结息方式代码
    ,nvl(trim(int_accr_way_cd), ' ') as int_accr_way_cd -- 计息方式代码
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种代码
    ,nvl(trim(open_acct_chn_type_cd), ' ') as open_acct_chn_type_cd -- 开户渠道类型代码
    ,nvl(trim(tran_chn_status_cd), ' ') as tran_chn_status_cd -- 交易渠道状态代码
    ,nvl(open_acct_dt, to_date('00010101', 'yyyymmdd')) as open_acct_dt -- 开户日期
    ,nvl(open_acct_tm, to_timestamp('00010101', 'yyyymmdd')) as open_acct_tm -- 开户时间
    ,nvl(clos_acct_dt, to_date('00010101', 'yyyymmdd')) as clos_acct_dt -- 销户日期
    ,nvl(clos_acct_tm, to_timestamp('00010101', 'yyyymmdd')) as clos_acct_tm -- 销户时间
    ,nvl(actv_dt, to_date('00010101', 'yyyymmdd')) as actv_dt -- 激活日期
    ,nvl(value_dt, to_date('00010101', 'yyyymmdd')) as value_dt -- 起息日期
    ,nvl(exp_dt, to_date('00010101', 'yyyymmdd')) as exp_dt -- 到期日期
    ,nvl(final_activ_acct_dt, to_date('00010101', 'yyyymmdd')) as final_activ_acct_dt -- 最后动户日期
    ,nvl(froz_dt, to_date('00010101', 'yyyymmdd')) as froz_dt -- 冻结日期
    ,nvl(unfrz_dt, to_date('00010101', 'yyyymmdd')) as unfrz_dt -- 解冻日期
    ,nvl(last_int_set_dt, to_date('00010101', 'yyyymmdd')) as last_int_set_dt -- 上次结息日期
    ,nvl(next_int_set_dt, to_date('00010101', 'yyyymmdd')) as next_int_set_dt -- 下次结息日期
    ,nvl(fir_value_dt, to_date('00010101', 'yyyymmdd')) as fir_value_dt -- 首次起息日期
    ,nvl(trim(base_rat_type_cd), ' ') as base_rat_type_cd -- 基准利率类型代码
    ,nvl(trim(base_rat), 0) as base_rat -- 基准利率
    ,nvl(trim(exec_int_rat), 0) as exec_int_rat -- 执行利率
    ,nvl(trim(td_acru_int), 0) as td_acru_int -- 当日应计利息
    ,nvl(trim(currt_acru_int), 0) as currt_acru_int -- 当期应计利息
    ,nvl(trim(open_acct_teller_id), ' ') as open_acct_teller_id -- 开户柜员编号
    ,nvl(trim(clos_acct_teller_id), ' ') as clos_acct_teller_id -- 销户柜员编号
    ,nvl(trim(open_acct_org_id), ' ') as open_acct_org_id -- 开户机构编号
    ,nvl(trim(close_acct_org_id), ' ') as close_acct_org_id -- 销户机构编号
    ,nvl(trim(belong_org_id), ' ') as belong_org_id -- 所属机构编号
    ,nvl(trim(camp_activ_id), ' ') as camp_activ_id -- 营销活动编号
    ,nvl(trim(referrer_type_cd), ' ') as referrer_type_cd -- 推荐人类型代码
    ,nvl(trim(referrer_num), ' ') as referrer_num -- 推荐人号码
    ,nvl(trim(vtual_acct_flg), ' ') as vtual_acct_flg -- 虚拟账户标志
    ,nvl(trim(mercht_id), ' ') as mercht_id -- 商户编号
    ,nvl(trim(currt_bal), 0) as currt_bal -- 当期余额
    ,nvl(trim(aval_bal), 0) as aval_bal -- 可用余额
    ,nvl(trim(froz_amt), 0) as froz_amt -- 冻结金额
    ,nvl(trim(cl_curr_currt_bal), 0) as cl_curr_currt_bal -- 折本币当期余额
    ,nvl(trim(ear_d_bal), 0) as ear_d_bal -- 日初余额
    ,nvl(trim(ear_m_bal), 0) as ear_m_bal -- 月初余额
    ,nvl(trim(ear_s_bal), 0) as ear_s_bal -- 季初余额
    ,nvl(trim(ear_y_bal), 0) as ear_y_bal -- 年初余额
    ,nvl(trim(y_acm_bal), 0) as y_acm_bal -- 年累计余额
    ,nvl(trim(s_acm_bal), 0) as s_acm_bal -- 季累计余额
    ,nvl(trim(m_acm_bal), 0) as m_acm_bal -- 月累计余额
    ,nvl(trim(cl_curr_ear_d_bal), 0) as cl_curr_ear_d_bal -- 折本币日初余额
    ,nvl(trim(cl_curr_ear_m_bal), 0) as cl_curr_ear_m_bal -- 折本币月初余额
    ,nvl(trim(cl_curr_ear_s_bal), 0) as cl_curr_ear_s_bal -- 折本币季初余额
    ,nvl(trim(cl_curr_ear_y_bal), 0) as cl_curr_ear_y_bal -- 折本币年初余额
    ,nvl(trim(cl_curr_y_acm_bal), 0) as cl_curr_y_acm_bal -- 折本币年累计余额
    ,nvl(trim(cl_curr_ear_d_y_acm_bal), 0) as cl_curr_ear_d_y_acm_bal -- 折本币日初年累计余额
    ,nvl(trim(cl_curr_ear_m_y_acm_bal), 0) as cl_curr_ear_m_y_acm_bal -- 折本币月初年累计余额
    ,nvl(trim(cl_curr_ear_s_y_acm_bal), 0) as cl_curr_ear_s_y_acm_bal -- 折本币季初年累计余额
    ,nvl(trim(cl_curr_ear_y_y_acm_bal), 0) as cl_curr_ear_y_y_acm_bal -- 折本币年初年累计余额
    ,nvl(trim(cl_curr_s_acm_bal), 0) as cl_curr_s_acm_bal -- 折本币季累计余额
    ,nvl(trim(cl_curr_ear_d_s_acm_bal), 0) as cl_curr_ear_d_s_acm_bal -- 折本币日初季累计余额
    ,nvl(trim(cl_curr_ear_s_s_acm_bal), 0) as cl_curr_ear_s_s_acm_bal -- 折本币季初季累计余额
    ,nvl(trim(cl_curr_ear_y_s_acm_bal), 0) as cl_curr_ear_y_s_acm_bal -- 折本币年初季累计余额
    ,nvl(trim(cl_curr_m_acm_bal), 0) as cl_curr_m_acm_bal -- 折本币月累计余额
    ,nvl(trim(cl_curr_ear_d_m_acm_bal), 0) as cl_curr_ear_d_m_acm_bal -- 折本币日初月累计余额
    ,nvl(trim(cl_curr_ear_m_m_acm_bal), 0) as cl_curr_ear_m_m_acm_bal -- 折本币月初月累计余额
    ,nvl(trim(cl_curr_ear_y_m_acm_bal), 0) as cl_curr_ear_y_m_acm_bal -- 折本币年初月累计余额
    ,nvl(trim(entry_flg), ' ') as entry_flg -- 记账标志
    ,nvl(trim(y_avg_bal), 0) as y_avg_bal -- 年日均余额
    ,nvl(trim(q_avg_bal), 0) as q_avg_bal -- 季日均余额
    ,nvl(trim(m_avg_bal), 0) as m_avg_bal -- 月日均余额
    ,nvl(trim(cl_curr_y_avg_bal), 0) as cl_curr_y_avg_bal -- 折本币年日均余额
    ,nvl(trim(cl_curr_q_avg_bal), 0) as cl_curr_q_avg_bal -- 折本币季日均余额
    ,nvl(trim(cl_curr_m_avg_bal), 0) as cl_curr_m_avg_bal -- 折本币月日均余额
    ,nvl(trim(liab_acct_id), ' ') as liab_acct_id -- 负债账户编号
    ,nvl(trim(open_amt), 0) as open_amt -- 开户金额
    ,nvl(trim(old_acct_id), ' ') as old_acct_id -- 旧账户编号
    ,nvl(trim(int_paybl_subj_id), ' ') as int_paybl_subj_id -- 应付利息科目编号
    ,nvl(trim(int_paybl_adj_subj_id), ' ') as int_paybl_adj_subj_id -- 应付利息调整科目编号
    ,nvl(trim(int_expns_subj_id), ' ') as int_expns_subj_id -- 利息支出科目编号
    ,nvl(trim(int_expns_adj_subj_id), ' ') as int_expns_adj_subj_id -- 利息支出调整科目编号
    ,nvl(trim(currt_int_paybl_adj), 0) as currt_int_paybl_adj -- 当期应付利息调整
    ,nvl(trim(td_int_expns), 0) as td_int_expns -- 当日利息支出
    ,nvl(trim(td_int_expns_adj), 0) as td_int_expns_adj -- 当日利息支出调整
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cmm_e_acct_info
where 1 = 1
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cmm_e_acct_info to ${idl_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cmm_e_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);