/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_cmm_lc_acct_info
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
alter table ${idl_schema}.icrm_cmm_lc_acct_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_cmm_lc_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_cmm_lc_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_cmm_lc_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,lc_id  -- 信用证编号
    ,issue_bank_lc_id  -- 开证行信用证编号
    ,dubil_num  -- 借据号
    ,cust_id  -- 客户编号
    ,stl_acct_num  -- 结算帐号
    ,subj_id  -- 科目编号
    ,fwd_flg  -- 远期标志
    ,circl_flg  -- 循环标志
    ,mx_lc_flg  -- 进出口信用证标志
    ,lc_type_cd  -- 信用证类型代码
    ,lc_pay_type_cd  -- 信用证支付类型代码
    ,issue_chn_cd  -- 开证渠道代码
    ,bus_breed_id  -- 业务品种编号
    ,lc_status_cd  -- 信用证状态代码
    ,issue_bank_cfm_status_cd  -- 开证行保兑状态代码
    ,curr_cd  -- 币种代码
    ,oper_teller_id  -- 经办柜员编号
    ,sign_org_id  -- 签署机构编号
    ,mgmt_org_id  -- 管理机构编号
    ,acct_instit_id  -- 账务机构编号
    ,oper_org_id  -- 经办机构编号
    ,effect_dt  -- 生效日期
    ,wrtoff_dt  -- 注销日期
    ,issue_dt  -- 开证日期
    ,exp_dt  -- 到期日期
    ,cfm_dt  -- 保兑日期
    ,issue_bank_name  -- 开证行名称
    ,advise_bank_name  -- 通知行名称
    ,applit_name  -- 申请人名称
    ,benefc_name  -- 受益人名称
    ,benefc_cty_cd  -- 受益人国家代码
    ,cargo_descb  -- 货物描述
    ,open_bank_name  -- 代开行名称
    ,fwd_tenor  -- 远期期限
    ,comm_fee_rat  -- 手续费费率
    ,comm_fee_amt  -- 手续费金额
    ,lc_higt_lmt  -- 信用证最高限额
    ,issue_amt  -- 开证金额
    ,acpty_bal  -- 可承兑余额
    ,lc_bal  -- 信用证余额
    ,cl_curr_lc_bal  -- 折本币信用证余额
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
    ,std_prod_id              --标准产品编号      
    ,issue_bank_cn_name       --开证行中文名称     
    ,issue_bank_swiftcode     --开证行SWIFTCODE
    ,acpty_tot                --可承兑总额       
    ,y_avg_bal                --年日均余额       
    ,q_avg_bal                --季日均余额       
    ,m_avg_bal                --月日均余额       
    ,cl_curr_y_avg_bal        --折本币年日均余额    
    ,cl_curr_q_avg_bal        --折本币季日均余额    
    ,cl_curr_m_avg_bal        --折本币月日均余额    
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.acct_id,chr(13),''),chr(10),'')  -- 账户编号
    ,replace(replace(t1.lc_id,chr(13),''),chr(10),'')  -- 信用证编号
    ,replace(replace(t1.issue_bank_lc_id,chr(13),''),chr(10),'')  -- 开证行信用证编号
    ,replace(replace(t1.dubil_num,chr(13),''),chr(10),'')  -- 借据号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.stl_acct_num,chr(13),''),chr(10),'')  -- 结算帐号
    ,replace(replace(t1.subj_id,chr(13),''),chr(10),'')  -- 科目编号
    ,replace(replace(t1.fwd_flg,chr(13),''),chr(10),'')  -- 远期标志
    ,replace(replace(t1.circl_flg,chr(13),''),chr(10),'')  -- 循环标志
    ,replace(replace(t1.mx_lc_flg,chr(13),''),chr(10),'')  -- 进出口信用证标志
    ,replace(replace(t1.lc_type_cd,chr(13),''),chr(10),'')  -- 信用证类型代码
    ,replace(replace(t1.lc_pay_type_cd,chr(13),''),chr(10),'')  -- 信用证支付类型代码
    ,replace(replace(t1.issue_chn_cd,chr(13),''),chr(10),'')  -- 开证渠道代码
    ,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'')  -- 业务品种编号
    ,replace(replace(t1.lc_status_cd,chr(13),''),chr(10),'')  -- 信用证状态代码
    ,replace(replace(t1.issue_bank_cfm_status_cd,chr(13),''),chr(10),'')  -- 开证行保兑状态代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'')  -- 经办柜员编号
    ,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'')  -- 签署机构编号
    ,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'')  -- 管理机构编号
    ,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'')  -- 账务机构编号
    ,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'')  -- 经办机构编号
    ,t1.effect_dt  -- 生效日期
    ,t1.wrtoff_dt  -- 注销日期
    ,t1.issue_dt  -- 开证日期
    ,t1.exp_dt  -- 到期日期
    ,t1.cfm_dt  -- 保兑日期
    ,replace(replace(t1.issue_bank_name,chr(13),''),chr(10),'')  -- 开证行名称
    ,replace(replace(t1.advise_bank_name,chr(13),''),chr(10),'')  -- 通知行名称
    ,replace(replace(t1.applit_name,chr(13),''),chr(10),'')  -- 申请人名称
    ,replace(replace(t1.benefc_name,chr(13),''),chr(10),'')  -- 受益人名称
    ,replace(replace(t1.benefc_cty_cd,chr(13),''),chr(10),'')  -- 受益人国家代码
    ,replace(replace(t1.cargo_descb,chr(13),''),chr(10),'')  -- 货物描述
    ,replace(replace(t1.open_bank_name,chr(13),''),chr(10),'')  -- 代开行名称
    ,t1.fwd_tenor  -- 远期期限
    ,t1.comm_fee_rat  -- 手续费费率
    ,t1.comm_fee_amt  -- 手续费金额
    ,t1.lc_higt_lmt  -- 信用证最高限额
    ,t1.issue_amt  -- 开证金额
    ,t1.acpty_bal  -- 可承兑余额
    ,t1.lc_bal  -- 信用证余额
    ,t1.cl_curr_lc_bal  -- 折本币信用证余额
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
    ,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id                     -- 标准产品编号      
    ,replace(replace(t1.issue_bank_cn_name,chr(13),''),chr(10),'') as issue_bank_cn_name       -- 开证行中文名称     
    ,replace(replace(t1.issue_bank_swiftcode,chr(13),''),chr(10),'') as issue_bank_swiftcode   -- 开证行SWIFTCODE
    ,t1.acpty_tot as acpty_tot                                                                -- 可承兑总额       
    ,t1.y_avg_bal as y_avg_bal                                                                -- 年日均余额       
    ,t1.q_avg_bal as q_avg_bal                                                                -- 季日均余额       
    ,t1.m_avg_bal as m_avg_bal                                                                -- 月日均余额       
    ,t1.cl_curr_y_avg_bal as cl_curr_y_avg_bal                                                -- 折本币年日均余额    
    ,t1.cl_curr_q_avg_bal as cl_curr_q_avg_bal                                                -- 折本币季日均余额    
    ,t1.cl_curr_m_avg_bal as cl_curr_m_avg_bal                                                -- 折本币月日均余额    
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${icl_schema}.cmm_lc_acct_info t1    --信用证账户信息
where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_cmm_lc_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);