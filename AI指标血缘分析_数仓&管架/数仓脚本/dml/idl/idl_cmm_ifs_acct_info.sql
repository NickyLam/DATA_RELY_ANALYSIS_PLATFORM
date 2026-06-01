/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl cmm_ifs_acct_info
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.cmm_ifs_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.cmm_ifs_acct_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.cmm_ifs_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,cust_acct_sub_acct_num  -- 客户账户子户号
    ,cust_acct_id  -- 客户账户编号
    ,acct_name  -- 账户名称
    ,cust_id  -- 客户编号
    ,std_prod_id  -- 标准产品编号
    ,prod_id  -- 产品编号
    ,bind_webank_card_no  -- 绑定微众银行卡号
    ,subj_id  -- 科目编号
    ,cust_type_cd  -- 客户类型代码
    ,ext_prod_id  -- 外部产品编号
    ,dep_acct_status_cd  -- 存款账户状态代码
    ,acpt_pay_status_cd  -- 收付状态代码
    ,froz_status_cd  -- 冻结状态代码
    ,stop_pay_status_cd  -- 止付状态代码
    ,dep_term  -- 存期
    ,sav_type_cd  -- 储种代码
    ,exec_int_rat_cate_cd  -- 执行利率类别代码
    ,pa_ext_int_rat_cate_cd  -- 部提利率类别代码
    ,ovdue_int_rat_cate_cd  -- 逾期利率类别代码
    ,base_rat_type_cd  -- 基准利率类型代码
    ,int_set_way_cd  -- 结息方式代码
    ,int_accr_way_cd  -- 计息方式代码
    ,int_accr_base_cd  -- 计息基准代码
    ,corp_acct_flg  -- 对公账户标志
    ,rc_flg  -- 定活标志
    ,web_dep_flg  -- 网络存款标志
    ,int_accr_flg  -- 计息标志
    ,part_draw_cnt  -- 部分提取次数
    ,acct_instit_id  -- 账务机构编号
    ,open_acct_org_id  -- 开户机构编号
    ,open_acct_teller_id  -- 开户柜员编号
    ,open_acct_flow_num  -- 开户流水号
    ,open_acct_chn_cd  -- 开户渠道代码
    ,open_acct_dt  -- 开户日期
    ,open_acct_tm  -- 开户时间
    ,close_acct_org_id  -- 销户机构编号
    ,clos_acct_teller_id  -- 销户柜员编号
    ,clos_acct_flow_num  -- 销户流水号
    ,clos_acct_dt  -- 销户日期
    ,clos_acct_tm  -- 销户时间
    ,acct_dt  -- 账务日期
    ,value_dt  -- 起息日期
    ,exp_dt  -- 到期日期
    ,final_activ_acct_dt  -- 最后动户日期
    ,last_int_set_dt  -- 上次结息日期
    ,next_int_set_dt  -- 下次结息日期
    ,fir_value_dt  -- 首次起息日期
    ,base_rat  -- 基准利率
    ,exec_int_rat  -- 执行利率
    ,int_rat_flo_val  -- 利率浮动值
    ,curr_cd  -- 币种代码
    ,td_acru_int  -- 当日应计利息
    ,currt_acru_int  -- 当期应计利息
    ,currt_bal  -- 当期余额
    ,froz_amt  -- 冻结金额
    ,aval_bal  -- 可用余额
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
    ,y_avg_bal  -- 年日均余额
    ,q_avg_bal  -- 季日均余额
    ,m_avg_bal  -- 月日均余额
    ,cl_curr_y_avg_bal  -- 折本币年日均余额
    ,cl_curr_q_avg_bal  -- 折本币季日均余额
    ,cl_curr_m_avg_bal  -- 折本币月日均余额
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 时间戳
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt   -- 数据日期
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id   -- 法人编号
    ,replace(replace(t.cust_acct_sub_acct_num,chr(13),''),chr(10),'') as cust_acct_sub_acct_num   -- 客户账户子户号
    ,replace(replace(t.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id   -- 客户账户编号
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name   -- 账户名称
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id   -- 客户编号
    ,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id   -- 标准产品编号
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id   -- 产品编号
    ,replace(replace(t.bind_webank_card_no,chr(13),''),chr(10),'') as bind_webank_card_no   -- 绑定微众银行卡号
    ,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id   -- 科目编号
    ,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd   -- 客户类型代码
    ,replace(replace(t.ext_prod_id,chr(13),''),chr(10),'') as ext_prod_id   -- 外部产品编号
    ,replace(replace(t.dep_acct_status_cd,chr(13),''),chr(10),'') as dep_acct_status_cd   -- 存款账户状态代码
    ,replace(replace(t.acpt_pay_status_cd,chr(13),''),chr(10),'') as acpt_pay_status_cd   -- 收付状态代码
    ,replace(replace(t.froz_status_cd,chr(13),''),chr(10),'') as froz_status_cd   -- 冻结状态代码
    ,replace(replace(t.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd   -- 止付状态代码
    ,replace(replace(t.dep_term,chr(13),''),chr(10),'') as dep_term   -- 存期
    ,replace(replace(t.sav_type_cd,chr(13),''),chr(10),'') as sav_type_cd   -- 储种代码
    ,replace(replace(t.exec_int_rat_cate_cd,chr(13),''),chr(10),'') as exec_int_rat_cate_cd   -- 执行利率类别代码
    ,replace(replace(t.pa_ext_int_rat_cate_cd,chr(13),''),chr(10),'') as pa_ext_int_rat_cate_cd   -- 部提利率类别代码
    ,replace(replace(t.ovdue_int_rat_cate_cd,chr(13),''),chr(10),'') as ovdue_int_rat_cate_cd   -- 逾期利率类别代码
    ,replace(replace(t.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd   -- 基准利率类型代码
    ,replace(replace(t.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd   -- 结息方式代码
    ,replace(replace(t.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd   -- 计息方式代码
    ,replace(replace(t.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd   -- 计息基准代码
    ,replace(replace(t.corp_acct_flg,chr(13),''),chr(10),'') as corp_acct_flg   -- 对公账户标志
    ,replace(replace(t.rc_flg,chr(13),''),chr(10),'') as rc_flg   -- 定活标志
    ,replace(replace(t.web_dep_flg,chr(13),''),chr(10),'') as web_dep_flg   -- 网络存款标志
    ,replace(replace(t.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg   -- 计息标志
    ,t.part_draw_cnt as part_draw_cnt   -- 部分提取次数
    ,replace(replace(t.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id   -- 账务机构编号
    ,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id   -- 开户机构编号
    ,replace(replace(t.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id   -- 开户柜员编号
    ,replace(replace(t.open_acct_flow_num,chr(13),''),chr(10),'') as open_acct_flow_num   -- 开户流水号
    ,replace(replace(t.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd   -- 开户渠道代码
    ,t.open_acct_dt as open_acct_dt   -- 开户日期
    ,t.open_acct_tm as open_acct_tm   -- 开户时间
    ,replace(replace(t.close_acct_org_id,chr(13),''),chr(10),'') as close_acct_org_id   -- 销户机构编号
    ,replace(replace(t.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id   -- 销户柜员编号
    ,replace(replace(t.clos_acct_flow_num,chr(13),''),chr(10),'') as clos_acct_flow_num   -- 销户流水号
    ,t.clos_acct_dt as clos_acct_dt   -- 销户日期
    ,t.clos_acct_tm as clos_acct_tm   -- 销户时间
    ,t.acct_dt as acct_dt   -- 账务日期
    ,t.value_dt as value_dt   -- 起息日期
    ,t.exp_dt as exp_dt   -- 到期日期
    ,t.final_activ_acct_dt as final_activ_acct_dt   -- 最后动户日期
    ,t.last_int_set_dt as last_int_set_dt   -- 上次结息日期
    ,t.next_int_set_dt as next_int_set_dt   -- 下次结息日期
    ,t.fir_value_dt as fir_value_dt   -- 首次起息日期
    ,t.base_rat as base_rat   -- 基准利率
    ,t.exec_int_rat as exec_int_rat   -- 执行利率
    ,t.int_rat_flo_val as int_rat_flo_val   -- 利率浮动值
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd   -- 币种代码
    ,t.td_acru_int as td_acru_int   -- 当日应计利息
    ,t.currt_acru_int as currt_acru_int   -- 当期应计利息
    ,t.currt_bal as currt_bal   -- 当期余额
    ,t.froz_amt as froz_amt   -- 冻结金额
    ,t.aval_bal as aval_bal   -- 可用余额
    ,t.stop_pay_amt as stop_pay_amt   -- 止付金额
    ,t.cl_curr_currt_bal as cl_curr_currt_bal   -- 折本币当期余额
    ,t.ear_d_bal as ear_d_bal   -- 日初余额
    ,t.ear_m_bal as ear_m_bal   -- 月初余额
    ,t.ear_s_bal as ear_s_bal   -- 季初余额
    ,t.ear_y_bal as ear_y_bal   -- 年初余额
    ,t.y_acm_bal as y_acm_bal   -- 年累计余额
    ,t.s_acm_bal as s_acm_bal   -- 季累计余额
    ,t.m_acm_bal as m_acm_bal   -- 月累计余额
    ,t.cl_curr_ear_d_bal as cl_curr_ear_d_bal   -- 折本币日初余额
    ,t.cl_curr_ear_m_bal as cl_curr_ear_m_bal   -- 折本币月初余额
    ,t.cl_curr_ear_s_bal as cl_curr_ear_s_bal   -- 折本币季初余额
    ,t.cl_curr_ear_y_bal as cl_curr_ear_y_bal   -- 折本币年初余额
    ,t.cl_curr_y_acm_bal as cl_curr_y_acm_bal   -- 折本币年累计余额
    ,t.cl_curr_ear_d_y_acm_bal as cl_curr_ear_d_y_acm_bal   -- 折本币日初年累计余额
    ,t.cl_curr_ear_m_y_acm_bal as cl_curr_ear_m_y_acm_bal   -- 折本币月初年累计余额
    ,t.cl_curr_ear_s_y_acm_bal as cl_curr_ear_s_y_acm_bal   -- 折本币季初年累计余额
    ,t.cl_curr_ear_y_y_acm_bal as cl_curr_ear_y_y_acm_bal   -- 折本币年初年累计余额
    ,t.cl_curr_s_acm_bal as cl_curr_s_acm_bal   -- 折本币季累计余额
    ,t.cl_curr_ear_d_s_acm_bal as cl_curr_ear_d_s_acm_bal   -- 折本币日初季累计余额
    ,t.cl_curr_ear_s_s_acm_bal as cl_curr_ear_s_s_acm_bal   -- 折本币季初季累计余额
    ,t.cl_curr_ear_y_s_acm_bal as cl_curr_ear_y_s_acm_bal   -- 折本币年初季累计余额
    ,t.cl_curr_m_acm_bal as cl_curr_m_acm_bal   -- 折本币月累计余额
    ,t.cl_curr_ear_d_m_acm_bal as cl_curr_ear_d_m_acm_bal   -- 折本币日初月累计余额
    ,t.cl_curr_ear_m_m_acm_bal as cl_curr_ear_m_m_acm_bal   -- 折本币月初月累计余额
    ,t.cl_curr_ear_y_m_acm_bal as cl_curr_ear_y_m_acm_bal   -- 折本币年初月累计余额
    ,t.y_avg_bal as y_avg_bal   -- 年日均余额
    ,t.q_avg_bal as q_avg_bal   -- 季日均余额
    ,t.m_avg_bal as m_avg_bal   -- 月日均余额
    ,t.cl_curr_y_avg_bal as cl_curr_y_avg_bal   -- 折本币年日均余额
    ,t.cl_curr_q_avg_bal as cl_curr_q_avg_bal   -- 折本币季日均余额
    ,t.cl_curr_m_avg_bal as cl_curr_m_avg_bal   -- 折本币月日均余额
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6')  -- 时间戳
 from ${icl_schema}.cmm_ifs_acct_info t--联合存款分户信息
where t.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;

-- 3 table grant
-- whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.cmm_ifs_acct_info to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'cmm_ifs_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);