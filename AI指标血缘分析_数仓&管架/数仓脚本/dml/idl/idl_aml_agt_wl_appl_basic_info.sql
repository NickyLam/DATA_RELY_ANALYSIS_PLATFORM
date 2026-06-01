/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_agt_wl_appl_basic_info
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
alter table ${idl_schema}.aml_agt_wl_appl_basic_info drop partition p_${last_date};
alter table ${idl_schema}.aml_agt_wl_appl_basic_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_agt_wl_appl_basic_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_agt_wl_appl_basic_info (
    etl_dt  -- 数据日期
    ,appl_id  -- 申请编号
    ,lp_id  -- 法人编号
    ,init_appl_id  -- 原申请编号
    ,cust_id  -- 客户编号
    ,open_acct_bank_name  -- 开户银行名称
    ,bank_card_num  -- 银行卡号
    ,cust_name  -- 客户名称
    ,open_acct_bind_mobile_no  -- 开户绑定手机号码
    ,co_org_id  -- 合作机构编号
    ,prod_id  -- 产品编号
    ,prod_cls_id  -- 产品分类编号
    ,appl_chn_id  -- 申请渠道编号
    ,crdt_appl_id  -- 授信申请编号
    ,repay_num  -- 还款账号
    ,curr_cd  -- 币种代码
    ,appl_lmt  -- 申请额度
    ,appl_int_rat  -- 申请利率
    ,appl_tm  -- 申请时间
    ,appl_tenor  -- 申请期限
    ,repay_day  -- 还款日
    ,grace_days  -- 宽限天数
    ,loan_dir_cd  -- 贷款投向代码
    ,repay_way_cd  -- 还款方式代码
    ,appl_status_cd  -- 申请状态代码
    ,check_status_cd  -- 审核状态代码
    ,coprator_acct_id  -- 合作商户编号
    ,taxpayer_idtfy_num  -- 纳税人识别号
    ,tran_flow_num  -- 交易流水号
    ,user_group_id  -- 用户组编号
    ,co_proj_id  -- 合作项目编号
    ,org_co_id  -- 机构合作编号
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.appl_id,chr(13),''),chr(10),'')  -- 申请编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.init_appl_id,chr(13),''),chr(10),'')  -- 原申请编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.open_acct_bank_name,chr(13),''),chr(10),'')  -- 开户银行名称
    ,replace(replace(t1.bank_card_num,chr(13),''),chr(10),'')  -- 银行卡号
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.open_acct_bind_mobile_no,chr(13),''),chr(10),'')  -- 开户绑定手机号码
    ,replace(replace(t1.co_org_id,chr(13),''),chr(10),'')  -- 合作机构编号
    ,replace(replace(t1.prod_id,chr(13),''),chr(10),'')  -- 产品编号
    ,replace(replace(t1.prod_cls_id,chr(13),''),chr(10),'')  -- 产品分类编号
    ,replace(replace(t1.appl_chn_id,chr(13),''),chr(10),'')  -- 申请渠道编号
    ,replace(replace(t1.crdt_appl_id,chr(13),''),chr(10),'')  -- 授信申请编号
    ,replace(replace(t1.repay_num,chr(13),''),chr(10),'')  -- 还款账号
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.appl_lmt  -- 申请额度
    ,t1.appl_int_rat  -- 申请利率
    ,t1.appl_tm  -- 申请时间
    ,t1.appl_tenor  -- 申请期限
    ,replace(replace(t1.repay_day,chr(13),''),chr(10),'')  -- 还款日
    ,t1.grace_days  -- 宽限天数
    ,replace(replace(t1.loan_dir_cd,chr(13),''),chr(10),'')  -- 贷款投向代码
    ,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'')  -- 还款方式代码
    ,replace(replace(t1.appl_status_cd,chr(13),''),chr(10),'')  -- 申请状态代码
    ,replace(replace(t1.check_status_cd,chr(13),''),chr(10),'')  -- 审核状态代码
    ,replace(replace(t1.coprator_acct_id,chr(13),''),chr(10),'')  -- 合作商户编号
    ,replace(replace(t1.taxpayer_idtfy_num,chr(13),''),chr(10),'')  -- 纳税人识别号
    ,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'')  -- 交易流水号
    ,replace(replace(t1.user_group_id,chr(13),''),chr(10),'')  -- 用户组编号
    ,replace(replace(t1.co_proj_id,chr(13),''),chr(10),'')  -- 合作项目编号
    ,replace(replace(t1.org_co_id,chr(13),''),chr(10),'')  -- 机构合作编号
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.agt_wl_appl_basic_info t1    --网贷申请基本信息
where t1.create_dt <= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_agt_wl_appl_basic_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);