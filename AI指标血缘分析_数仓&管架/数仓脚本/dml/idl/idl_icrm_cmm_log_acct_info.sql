/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_cmm_log_acct_info
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
alter table ${idl_schema}.icrm_cmm_log_acct_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_cmm_log_acct_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_cmm_log_acct_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_cmm_log_acct_info partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,lp_id  -- 法人编号
    ,acct_id  -- 账户编号
    ,bus_id  -- 业务编号
    ,log_cont_id  -- 保函合同编号
    ,log_acct_num  -- 保函账号
    ,out_acct_acct_num  -- 出账账号
    ,stl_acct_num  -- 结算账号
    ,crdt_contr_no  -- 信贷合同号
    ,recvbl_num  -- 收款账号
    ,subj_cd  -- 科目代码
    ,log_kind_cd  -- 保函种类代码
    ,fin_log_flg  -- 融资性保函标志
    ,overs_log_flg  -- 境外保函标志
    ,advc_flg  -- 垫款标志
    ,advc_dubil_id  -- 垫款借据编号
    ,log_status  -- 保函状态
    ,wrtoff_way  -- 注销方式
    ,guar_way_cd  -- 担保方式代码
    ,tenor  -- 期限
    ,benefc_name  -- 受益人名称
    ,benefc_acct_num  -- 受益人账号
    ,benefc_open_bank_name  -- 受益人开户行名称
    ,guar_org_id  -- 担保机构编号
    ,acct_instit_id  -- 账务机构编号
    ,mgmt_org_id  -- 管理机构编号
    ,oper_org_id  -- 经办机构编号
    ,open_dt  -- 开立日期
    ,wrtoff_dt  -- 注销日期
    ,start_dt  -- 起始日期
    ,exp_dt  -- 到期日期
    ,open_flow  -- 开立流水
    ,wrtoff_flow  -- 注销流水
    ,curr_cd  -- 币种代码
    ,ovdue_int_rat  -- 逾期利率
    ,comm_fee_rat  -- 手续费费率
    ,comm_fee_amt  -- 手续费金额
    ,compens_amt  -- 赔付金额
    ,advc_amt  -- 垫款金额
    ,margin_acct_num  -- 保证金账号
    ,margin_curr  -- 保证金币种
    ,margin_ratio  -- 保证金比例
    ,margin_amt  -- 保证金金额
    ,log_amt  -- 保函金额
    ,currt_bal  -- 当期余额
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
    ,replace(replace(t1.bus_id,chr(13),''),chr(10),'')  -- 业务编号
    ,replace(replace(t1.log_cont_id,chr(13),''),chr(10),'')  -- 保函合同编号
    ,replace(replace(t1.log_acct_num,chr(13),''),chr(10),'')  -- 保函账号
    ,replace(replace(t1.out_acct_acct_num,chr(13),''),chr(10),'')  -- 出账账号
    ,replace(replace(t1.stl_acct_num,chr(13),''),chr(10),'')  -- 结算账号
    ,replace(replace(t1.crdt_contr_no,chr(13),''),chr(10),'')  -- 信贷合同号
    ,replace(replace(t1.recvbl_num,chr(13),''),chr(10),'')  -- 收款账号
    ,replace(replace(t1.subj_cd,chr(13),''),chr(10),'')  -- 科目代码
    ,replace(replace(t1.log_kind_cd,chr(13),''),chr(10),'')  -- 保函种类代码
    ,replace(replace(t1.fin_log_flg,chr(13),''),chr(10),'')  -- 融资性保函标志
    ,replace(replace(t1.overs_log_flg,chr(13),''),chr(10),'')  -- 境外保函标志
    ,replace(replace(t1.advc_flg,chr(13),''),chr(10),'')  -- 垫款标志
    ,replace(replace(t1.advc_dubil_id,chr(13),''),chr(10),'')  -- 垫款借据编号
    ,replace(replace(t1.log_status,chr(13),''),chr(10),'')  -- 保函状态
    ,replace(replace(t1.wrtoff_way,chr(13),''),chr(10),'')  -- 注销方式
    ,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'')  -- 担保方式代码
    ,replace(replace(t1.tenor,chr(13),''),chr(10),'')  -- 期限
    ,replace(replace(t1.benefc_name,chr(13),''),chr(10),'')  -- 受益人名称
    ,replace(replace(t1.benefc_acct_num,chr(13),''),chr(10),'')  -- 受益人账号
    ,replace(replace(t1.benefc_open_bank_name,chr(13),''),chr(10),'')  -- 受益人开户行名称
    ,replace(replace(t1.guar_org_id,chr(13),''),chr(10),'')  -- 担保机构编号
    ,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'')  -- 账务机构编号
    ,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'')  -- 管理机构编号
    ,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'')  -- 经办机构编号
    ,t1.open_dt  -- 开立日期
    ,t1.wrtoff_dt  -- 注销日期
    ,t1.start_dt  -- 起始日期
    ,t1.exp_dt  -- 到期日期
    ,replace(replace(t1.open_flow,chr(13),''),chr(10),'')  -- 开立流水
    ,replace(replace(t1.wrtoff_flow,chr(13),''),chr(10),'')  -- 注销流水
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.ovdue_int_rat  -- 逾期利率
    ,t1.comm_fee_rat  -- 手续费费率
    ,t1.comm_fee_amt  -- 手续费金额
    ,t1.compens_amt  -- 赔付金额
    ,t1.advc_amt  -- 垫款金额
    ,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'')  -- 保证金账号
    ,replace(replace(t1.margin_curr,chr(13),''),chr(10),'')  -- 保证金币种
    ,t1.margin_ratio  -- 保证金比例
    ,t1.margin_amt  -- 保证金金额
    ,t1.log_amt  -- 保函金额
    ,t1.currt_bal  -- 当期余额
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
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${icl_schema}.cmm_log_acct_info t1    --保函账户信息
where t1.etl_dt= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_cmm_log_acct_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);