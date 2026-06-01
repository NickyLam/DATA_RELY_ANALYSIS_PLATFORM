/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_cmm_dep_acct_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_cmm_dep_acct_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_cmm_dep_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_cmm_dep_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_cmm_dep_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,acct_name  -- 账户名称
    ,cust_acct_id  -- 客户账户编号
    ,cust_acct_sub_acct_num  -- 客户账户子户号
    ,cust_id  -- 客户编号
    ,subj_id  -- 科目编号
    ,dep_kind_cd  -- 储种代码
    ,acct_cls_cd  -- 账户分类代码
    ,acct_type_cd  -- 账户类型代码
    ,acct_attr_cd  -- 账户属性代码
    ,dep_term  -- 存期
    ,std_prod_id  -- 标准产品编号
    ,ext_prod_id  -- 外部产品编号
    ,intnal_prod_id  -- 内部产品编号
    ,dep_acct_status_cd  -- 存款账户状态代码
    ,cust_type_cd  -- 客户类型代码
    ,corp_acct_flg  -- 对公账户标志
    ,stop_pay_status_cd  -- 止付状态代码
    ,general_exch_flg  -- 通兑标志
    ,advise_dep_flg  -- 通知存款标志
    ,agt_dep_flg  -- 协议存款标志
    ,float_int_rat_flg  -- 浮动利率标志
    ,int_rat_float_way_cd  -- 利率浮动方式代码
    ,int_rat_adj_ped_corp_cd  -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq  -- 利率调整周期频率
    ,rc_flg  -- 定活标志
    ,margin_flg  -- 保证金标志
    ,agree_dep_flg  -- 协定存款标志
    ,ibank_dep_flg  -- 同业存款标志
    ,dep_basic_acct_flg  -- 存款基本户标志
    ,ec_flg  -- 钞汇标志
    ,privavy_acct_flg  -- 隐私账户标志
    ,legal_acct_flg  -- 涉案账户标志
    ,auto_redt_flg  -- 自动转存标志
    ,redted_cnt  -- 已转存次数
    ,itg_dep_earliest_drawbl_dt  -- 智能存款最早可提支日期
    ,sleep_acct_flg  -- 睡眠户标志
    ,dormt_acct_flg  -- 不动户标志
    ,sal_acct_flg  -- 工资账户标志
    ,froz_flg  -- 冻结标志
    ,advd_draw_flg  -- 可提前支取标志
    ,tranbl_flg  -- 可转让标志
    ,int_accr_base_cd  -- 计息基准代码
    ,int_accr_flg  -- 计息标志
    ,int_set_way_cd  -- 结息方式代码
    ,int_accr_way_cd  -- 计息方式代码
    ,allow_od_flg  -- 允许透支标志
    ,curr_cd  -- 币种代码
    ,redt_way_cd  -- 转存方式代码
    ,open_acct_chn_type_cd  -- 开户渠道类型代码
    ,tran_chn_status_cd  -- 交易渠道状态代码
    ,open_acct_dt  -- 开户日期
    ,open_acct_tm  -- 开户时间
    ,clos_acct_dt  -- 销户日期
    ,clos_acct_tm  -- 销户时间
    ,actv_dt  -- 激活日期
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,final_activ_acct_dt  -- 最后动户日期
    ,agree_dep_value_dt  -- 协定存款起息日期
    ,agree_dep_exp_dt  -- 协定存款到期日期
    ,froz_dt  -- 冻结日期
    ,unfrz_dt  -- 解冻日期
    ,agree_int_rat  -- 协定利率
    ,base_rat_type_cd  -- 基准利率类型代码
    ,base_rat  -- 基准利率
    ,exec_int_rat  -- 执行利率
    ,td_acru_int  -- 当日应计利息
    ,currt_acru_int  -- 当期应计利息
    ,cust_mgr_id  -- 客户经理编号
    ,open_acct_teller_id  -- 开户柜员编号
    ,clos_acct_teller_id  -- 销户柜员编号
    ,open_acct_org_id  -- 开户机构编号
    ,close_acct_org_id  -- 销户机构编号
    ,belong_org_id  -- 所属机构编号
    ,loc_flg  -- 开立存款证实书标志
    ,expe_higt_yld_rat  -- 预期最高收益率
    ,agree_dep_init_amt  -- 协定存款起存金额
    ,open_acct_amt  -- 开户金额
    ,currt_bal  -- 当期余额
    ,aval_bal  -- 可用余额
    ,froz_amt  -- 冻结金额
    ,stop_pay_amt  -- 止付金额
    ,cl_curr_currt_bal  -- 折本币当期余额
    ,ear_d_bal  -- 日初余额
    ,ear_m_bal  -- 月初余额
    ,ear_s_bal  -- 季初余额
    ,ear_y_bal  -- 年初余额
    ,y_acm_bal  -- 年累计余额
    ,s_acm_bal  -- 季累计余额
    ,m_acm_bal  -- 月累计余额
    ,cl_curr_ear_d_bal  -- 折本币日初余额
    ,cl_curr_ear_m_bal  -- 折本币月初余额
    ,cl_curr_ear_s_bal  -- 折本币季初余额
    ,cl_curr_ear_y_bal  -- 折本币年初余额
    ,cl_curr_y_acm_bal  -- 折本币年累计余额
    ,cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,cl_curr_s_acm_bal  -- 折本币季累计余额
    ,cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,cl_curr_m_acm_bal  -- 折本币月累计余额
    ,cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.acct_name,chr(13),''),chr(10),'')  -- 账户名称
    ,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'')  -- 客户账户编号
    ,replace(replace(t1.cust_acct_sub_acct_num,chr(13),''),chr(10),'')  -- 客户账户子户号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.dep_kind_cd,chr(13),''),chr(10),'')  -- 储种代码
    ,replace(replace(t1.acct_cls_cd,chr(13),''),chr(10),'')  -- 账户分类代码
    ,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'')  -- 账户类型代码
    ,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'')  -- 账户属性代码
    ,replace(replace(t1.dep_term,chr(13),''),chr(10),'')  -- 存期
    ,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'')  -- 标准产品编号
    ,replace(replace(t1.ext_prod_id,chr(13),''),chr(10),'')  -- 外部产品编号
    ,replace(replace(t1.intnal_prod_id,chr(13),''),chr(10),'')  -- 内部产品编号
    ,replace(replace(t1.dep_acct_status_cd,chr(13),''),chr(10),'')  -- 存款账户状态代码
    ,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'')  -- 客户类型代码
    ,replace(replace(t1.corp_acct_flg,chr(13),''),chr(10),'')  -- 对公账户标志
    ,replace(replace(t1.stop_pay_status_cd,chr(13),''),chr(10),'')  -- 止付状态代码
    ,replace(replace(t1.general_exch_flg,chr(13),''),chr(10),'')  -- 通兑标志
    ,replace(replace(t1.advise_dep_flg,chr(13),''),chr(10),'')  -- 通知存款标志
    ,replace(replace(t1.agt_dep_flg,chr(13),''),chr(10),'')  -- 协议存款标志
    ,replace(replace(t1.float_int_rat_flg,chr(13),''),chr(10),'')  -- 浮动利率标志
    ,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'')  -- 利率浮动方式代码
    ,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'')  -- 利率调整周期单位代码
    ,t1.int_rat_adj_ped_freq  -- 利率调整周期频率
    ,replace(replace(t1.rc_flg,chr(13),''),chr(10),'')  -- 定活标志
    ,replace(replace(t1.margin_flg,chr(13),''),chr(10),'')  -- 保证金标志
    ,replace(replace(t1.agree_dep_flg,chr(13),''),chr(10),'')  -- 协定存款标志
    ,replace(replace(t1.ibank_dep_flg,chr(13),''),chr(10),'')  -- 同业存款标志
    ,replace(replace(t1.dep_basic_acct_flg,chr(13),''),chr(10),'')  -- 存款基本户标志
    ,replace(replace(t1.ec_flg,chr(13),''),chr(10),'')  -- 钞汇标志
    ,replace(replace(t1.privavy_acct_flg,chr(13),''),chr(10),'')  -- 隐私账户标志
    ,replace(replace(t1.legal_acct_flg,chr(13),''),chr(10),'')  -- 涉案账户标志
    ,replace(replace(t1.auto_redt_flg,chr(13),''),chr(10),'')  -- 自动转存标志
    ,replace(replace(t1.redted_cnt,chr(13),''),chr(10),'')  -- 已转存次数
    ,t1.itg_dep_earliest_drawbl_dt  -- 智能存款最早可提支日期
    ,replace(replace(t1.sleep_acct_flg,chr(13),''),chr(10),'')  -- 睡眠户标志
    ,replace(replace(t1.dormt_acct_flg,chr(13),''),chr(10),'')  -- 不动户标志
    ,replace(replace(t1.sal_acct_flg,chr(13),''),chr(10),'')  -- 工资账户标志
    ,replace(replace(t1.froz_flg,chr(13),''),chr(10),'')  -- 冻结标志
    ,replace(replace(t1.advd_draw_flg,chr(13),''),chr(10),'')  -- 可提前支取标志
    ,replace(replace(t1.tranbl_flg,chr(13),''),chr(10),'')  -- 可转让标志
    ,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'')  -- 计息基准代码
    ,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'')  -- 计息标志
    ,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'')  -- 结息方式代码
    ,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'')  -- 计息方式代码
    ,replace(replace(t1.allow_od_flg,chr(13),''),chr(10),'')  -- 允许透支标志
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.redt_way_cd,chr(13),''),chr(10),'')  -- 转存方式代码
    ,replace(replace(t1.open_acct_chn_type_cd,chr(13),''),chr(10),'')  -- 开户渠道类型代码
    ,replace(replace(t1.tran_chn_status_cd,chr(13),''),chr(10),'')  -- 交易渠道状态代码
    ,t1.open_acct_dt  -- 开户日期
    ,t1.open_acct_tm  -- 开户时间
    ,t1.clos_acct_dt  -- 销户日期
    ,t1.clos_acct_tm  -- 销户时间
    ,t1.actv_dt  -- 激活日期
    ,t1.value_dt  -- 起息日期
    ,t1.exp_dt  -- 到期日期
    ,t1.final_activ_acct_dt  -- 最后动户日期
    ,t1.agree_dep_value_dt  -- 协定存款起息日期
    ,t1.agree_dep_exp_dt  -- 协定存款到期日期
    ,t1.froz_dt  -- 冻结日期
    ,t1.unfrz_dt  -- 解冻日期
    ,t1.agree_int_rat  -- 协定利率
    ,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'')  -- 基准利率类型代码
    ,t1.base_rat  -- 基准利率
    ,t1.exec_int_rat  -- 执行利率
    ,t1.td_acru_int  -- 当日应计利息
    ,t1.currt_acru_int  -- 当期应计利息
    ,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'')  -- 客户经理编号
    ,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'')  -- 开户柜员编号
    ,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'')  -- 销户柜员编号
    ,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'')  -- 开户机构编号
    ,replace(replace(t1.close_acct_org_id,chr(13),''),chr(10),'')  -- 销户机构编号
    ,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'')  -- 所属机构编号
    ,replace(replace(t1.loc_flg,chr(13),''),chr(10),'')  -- 开立存款证实书标志
    ,t1.expe_higt_yld_rat  -- 预期最高收益率
    ,t1.agree_dep_init_amt  -- 协定存款起存金额
    ,t1.open_acct_amt  -- 开户金额
    ,t1.currt_bal  -- 当期余额
    ,t1.aval_bal  -- 可用余额
    ,t1.froz_amt  -- 冻结金额
    ,t1.stop_pay_amt  -- 止付金额
    ,t1.cl_curr_currt_bal  -- 折本币当期余额
    ,t1.ear_d_bal  -- 日初余额
    ,t1.ear_m_bal  -- 月初余额
    ,t1.ear_s_bal  -- 季初余额
    ,t1.ear_y_bal  -- 年初余额
    ,t1.y_acm_bal  -- 年累计余额
    ,t1.s_acm_bal  -- 季累计余额
    ,t1.m_acm_bal  -- 月累计余额
    ,t1.cl_curr_ear_d_bal  -- 折本币日初余额
    ,t1.cl_curr_ear_m_bal  -- 折本币月初余额
    ,t1.cl_curr_ear_s_bal  -- 折本币季初余额
    ,t1.cl_curr_ear_y_bal  -- 折本币年初余额
    ,t1.cl_curr_y_acm_bal  -- 折本币年累计余额
    ,t1.cl_curr_ear_d_y_acm_bal  -- 折本币日初年累计余额
    ,t1.cl_curr_ear_m_y_acm_bal  -- 折本币月初年累计余额
    ,t1.cl_curr_ear_s_y_acm_bal  -- 折本币季初年累计余额
    ,t1.cl_curr_ear_y_y_acm_bal  -- 折本币年初年累计余额
    ,t1.cl_curr_s_acm_bal  -- 折本币季累计余额
    ,t1.cl_curr_ear_d_s_acm_bal  -- 折本币日初季累计余额
    ,t1.cl_curr_ear_s_s_acm_bal  -- 折本币季初季累计余额
    ,t1.cl_curr_ear_y_s_acm_bal  -- 折本币年初季累计余额
    ,t1.cl_curr_m_acm_bal  -- 折本币月累计余额
    ,t1.cl_curr_ear_d_m_acm_bal  -- 折本币日初月累计余额
    ,t1.cl_curr_ear_m_m_acm_bal  -- 折本币月初月累计余额
    ,t1.cl_curr_ear_y_m_acm_bal  -- 折本币年初月累计余额
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${icl_schema}.cmm_dep_acct_info t1    --存款账户信息
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_cmm_dep_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);