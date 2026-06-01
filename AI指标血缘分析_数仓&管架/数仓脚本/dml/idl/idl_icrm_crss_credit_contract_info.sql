/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_crss_credit_contract_info
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
alter table ${idl_schema}.icrm_crss_credit_contract_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_crss_credit_contract_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_crss_credit_contract_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_crss_credit_contract_info (
    etl_dt  -- 数据日期
    ,crdt_lmt_agt_id  -- 授信额度协议编号
    ,cust_id  -- 客户编号
    ,cust_type_cd  -- 客户类型代码
    ,manu_cont_id  -- 人工合同编号
    ,crdt_apv_id  -- 授信审批编号
    ,crdt_appl_id  -- 授信申请编号
    ,crdt_kind_cd  -- 授信种类代码
    ,crdt_bus_kind_cd  -- 授信业务种类代码
    ,open_dt  -- 开立日期
    ,apv_dt  -- 审批日期
    ,crdt_start_dt  -- 授信起始日期
    ,crdt_exp_dt  -- 授信到期日期
    ,crdt_termnt_dt  -- 授信终止日期
    ,crdt_cont_status_cd  -- 授信合同状态代码
    ,crdt_lmt_wrtoff_effect_dt  -- 授信额度注销生效日期
    ,crdt_lmt_wrtoff_reason  -- 授信额度注销原因
    ,crdt_lmt_froz_flg  -- 授信合同冻结标志
    ,circl_flg  -- 循环标志
    ,crdt_valid_flg  -- 授信有效标志
    ,com_group_crdt_lmt_flg  -- 共用集团授信额度标志
    ,happ_type_cd  -- 发生类型代码
    ,curr_cd  -- 币种代码
    ,crdt_lmt  -- 授信额度
    ,used_crdt_lmt  -- 已用授信额度
    ,crdt_bal  -- 授信余额
    ,aval_crdt_lmt  -- 可用授信额度
    ,open_lmt  -- 敞口额度
    ,open_bal  -- 敞口余额
    ,aval_open_lmt  -- 敞口可用额度
    ,onl_lmt  -- 线上额度
    ,onl_bal  -- 线上额度余额
    ,apv_crdt_lmt  -- 批复授信额度
    ,apv_open_lmt  -- 批复敞口额度
    ,group_corp_crdt_lmt  -- 集团授信额度公司部分
    ,group_corp_open_lmt  -- 集团授信敞口公司部分
    ,group_ibank_crdt_lmt  -- 集团授信额度同业部分
    ,group_ibank_open_lmt  -- 集团授信敞口同业部分
    ,guar_val  -- 担保价值
    ,guar_ratio  -- 担保比例
    ,guar_way_cd  -- 担保方式代码
    ,open_org_id  -- 开立机构编号
    ,crdt_mgmt_org_id  -- 授信管理机构编号
    ,crdt_acct_instit_id  -- 授信账务机构编号
    ,crdt_user_id  -- 授信员工编号
    ,init_crdt_lmt_agt_id  -- 原授信协议号
    ,data_src_cd  -- 数据来源代码
    ,apv_path  -- 批复意见书地址字段
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.crdt_lmt_agt_id,chr(13),''),chr(10),'')  -- 授信额度协议编号
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'')  -- 客户类型代码
    ,replace(replace(t1.manu_cont_id,chr(13),''),chr(10),'')  -- 人工合同编号
    ,replace(replace(t1.crdt_apv_id,chr(13),''),chr(10),'')  -- 授信审批编号
    ,replace(replace(t1.crdt_appl_id,chr(13),''),chr(10),'')  -- 授信申请编号
    ,replace(replace(t1.crdt_kind_cd,chr(13),''),chr(10),'')  -- 授信种类代码
    ,replace(replace(t1.crdt_bus_kind_cd,chr(13),''),chr(10),'')  -- 授信业务种类代码
    ,t1.open_dt  -- 开立日期
    ,t1.apv_dt  -- 审批日期
    ,t1.crdt_start_dt  -- 授信起始日期
    ,t1.crdt_exp_dt  -- 授信到期日期
    ,t1.crdt_termnt_dt  -- 授信终止日期
    ,replace(replace(t1.crdt_cont_status_cd,chr(13),''),chr(10),'')  -- 授信合同状态代码
    ,t1.crdt_lmt_wrtoff_effect_dt  -- 授信额度注销生效日期
    ,replace(replace(t1.crdt_lmt_wrtoff_reason,chr(13),''),chr(10),'')  -- 授信额度注销原因
    ,replace(replace(t1.crdt_lmt_froz_flg,chr(13),''),chr(10),'')  -- 授信合同冻结标志
    ,replace(replace(t1.circl_flg,chr(13),''),chr(10),'')  -- 循环标志
    ,replace(replace(t1.crdt_valid_flg,chr(13),''),chr(10),'')  -- 授信有效标志
    ,replace(replace(t1.com_group_crdt_lmt_flg,chr(13),''),chr(10),'')  -- 共用集团授信额度标志
    ,replace(replace(t1.happ_type_cd,chr(13),''),chr(10),'')  -- 发生类型代码
    ,replace(replace(t1.curr_cd,chr(13),''),chr(10),'')  -- 币种代码
    ,t1.crdt_lmt  -- 授信额度
    ,t1.used_crdt_lmt  -- 已用授信额度
    ,t1.crdt_bal  -- 授信余额
    ,t1.aval_crdt_lmt  -- 可用授信额度
    ,t1.open_lmt  -- 敞口额度
    ,t1.open_bal  -- 敞口余额
    ,t1.aval_open_lmt  -- 敞口可用额度
    ,t1.onl_lmt  -- 线上额度
    ,t1.onl_bal  -- 线上额度余额
    ,t1.apv_crdt_lmt  -- 批复授信额度
    ,t1.apv_open_lmt  -- 批复敞口额度
    ,t1.group_corp_crdt_lmt  -- 集团授信额度公司部分
    ,t1.group_corp_open_lmt  -- 集团授信敞口公司部分
    ,t1.group_ibank_crdt_lmt  -- 集团授信额度同业部分
    ,t1.group_ibank_open_lmt  -- 集团授信敞口同业部分
    ,t1.guar_val  -- 担保价值
    ,t1.guar_ratio  -- 担保比例
    ,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'')  -- 担保方式代码
    ,replace(replace(t1.open_org_id,chr(13),''),chr(10),'')  -- 开立机构编号
    ,replace(replace(t1.crdt_mgmt_org_id,chr(13),''),chr(10),'')  -- 授信管理机构编号
    ,replace(replace(t1.crdt_acct_instit_id,chr(13),''),chr(10),'')  -- 授信账务机构编号
    ,replace(replace(t1.crdt_user_id,chr(13),''),chr(10),'')  -- 授信员工编号
    ,replace(replace(t1.init_crdt_lmt_agt_id,chr(13),''),chr(10),'')  -- 原授信协议号
    ,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'')  -- 数据来源代码
    ,replace(replace(t1.apv_path,chr(13),''),chr(10),'')  -- 批复意见书地址字段 
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iol_schema}.crss_credit_contract_info t1    --供对公crm授信额度信息
where t1.start_dt<=to_date('${batch_date}','yyyymmdd') and t1.end_dt>to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_crss_credit_contract_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);